import 'dart:convert';

import 'package:deenly/core/services/nearby_mosques_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const sunni = 'Sunni';
  const shia = 'Shia';
  const ahlEHadith = 'Ahl-e-Hadith';

  String label(NearbyMosqueDenomination d) => d.joinedDisplayLabel(
        sunniLabel: sunni,
        shiaLabel: shia,
        ahlEHadithLabel: ahlEHadith,
      );

  group('NearbyMosqueDenomination.fromOsmTag', () {
    test('sunni', () {
      final d = NearbyMosqueDenomination.fromOsmTag('sunni');
      expect(d.isSpecified, isTrue);
      expect(d.includesSunni, isTrue);
      expect(d.includesShia, isFalse);
      expect(label(d), 'Sunni');
    });

    test('shia aliases map to Shia', () {
      for (final raw in ['shia', 'shiite', "shi'a", 'twelver', 'jafari']) {
        final d = NearbyMosqueDenomination.fromOsmTag(raw);
        expect(d.includesShia, isTrue, reason: raw);
        expect(label(d), 'Shia', reason: raw);
      }
    });

    test('ahle hadith OSM tokens are not collapsed to Sunni', () {
      for (final raw in [
        'ahle_hadees',
        'ahle_hadith',
        'ahl_e_hadith',
        'salafi',
      ]) {
        final d = NearbyMosqueDenomination.fromOsmTag(raw);
        expect(d.includesAhlEHadith, isTrue, reason: raw);
        expect(d.includesSunni, isFalse, reason: raw);
        expect(label(d), ahlEHadith, reason: raw);
      }
    });

    test('missing or blank is unspecified — no guessing', () {
      expect(NearbyMosqueDenomination.fromOsmTag(null).isSpecified, isFalse);
      expect(NearbyMosqueDenomination.fromOsmTag('').isSpecified, isFalse);
      expect(NearbyMosqueDenomination.fromOsmTag('   ').isSpecified, isFalse);
      expect(
        NearbyMosqueDenomination.fromTags(const {}).isSpecified,
        isFalse,
      );
      expect(
        NearbyMosqueDenomination.fromTags(const {'name': 'Jamia Masjid'})
            .isSpecified,
        isFalse,
      );
    });

    test('unknown values are kept without inventing sunni/shia', () {
      final d = NearbyMosqueDenomination.fromOsmTag('ahmadiyya');
      expect(d.isSpecified, isTrue);
      expect(d.includesSunni, isFalse);
      expect(d.includesShia, isFalse);
      expect(label(d), 'Ahmadiyya');
    });

    test('multiple values are de-duplicated and joined safely', () {
      final d = NearbyMosqueDenomination.fromOsmTag('sunni;shia;sunni');
      expect(d.rawValues, ['sunni', 'shia']);
      expect(label(d), 'Sunni · Shia');

      final mixed = NearbyMosqueDenomination.fromOsmTag('sunni, ahmadiyya');
      expect(label(mixed), 'Sunni · Ahmadiyya');
    });
  });

  group('NearbyMosqueDenomination.resolve name refinement', () {
    test('Ahle Hadees in name overrides generic sunni OSM tag', () {
      final d = NearbyMosqueDenomination.resolve(
        osmTag: 'sunni',
        name: 'Jama Masjid Ahle Hadees',
      );
      expect(d.includesAhlEHadith, isTrue);
      expect(d.includesSunni, isFalse);
      expect(label(d), ahlEHadith);
    });

    test('Ahle Hadees name fills missing denomination', () {
      final d = NearbyMosqueDenomination.fromTags(const {
        'name': 'Masjid Ahl-e-Hadith Wapda Town',
      });
      expect(label(d), ahlEHadith);
    });

    test('plain Jamia name does not invent Ahl-e-Hadith', () {
      final d = NearbyMosqueDenomination.resolve(
        osmTag: 'sunni',
        name: 'Jamia Masjid',
      );
      expect(label(d), sunni);
    });

    test('ahle sunnat stays Sunni', () {
      final d = NearbyMosqueDenomination.fromOsmTag('ahle_sunnat');
      expect(label(d), sunni);
      expect(d.includesAhlEHadith, isFalse);
    });
  });

  group('NearbyMosquesService denomination from Overpass JSON', () {
    test('reads denomination tags from OSM elements', () async {
      final payload = {
        'elements': [
          {
            'type': 'node',
            'id': 1,
            'lat': 24.86,
            'lon': 67.00,
            'tags': {
              'amenity': 'mosque',
              'name': 'Sunni Mosque',
              'denomination': 'sunni',
            },
          },
          {
            'type': 'node',
            'id': 2,
            'lat': 24.861,
            'lon': 67.001,
            'tags': {
              'amenity': 'mosque',
              'name': 'Shia Mosque',
              'denomination': 'shiite',
            },
          },
          {
            'type': 'node',
            'id': 3,
            'lat': 24.862,
            'lon': 67.002,
            'tags': {
              'amenity': 'mosque',
              'name': 'Unspecified Mosque',
            },
          },
          {
            'type': 'node',
            'id': 4,
            'lat': 24.863,
            'lon': 67.003,
            'tags': {
              'amenity': 'mosque',
              'name': 'Multi Mosque',
              'denomination': 'sunni;ahmadiyya',
            },
          },
          {
            'type': 'node',
            'id': 5,
            'lat': 24.864,
            'lon': 67.004,
            'tags': {
              'amenity': 'mosque',
              'name': 'Jama Masjid Ahle Hadees',
              'denomination': 'sunni',
            },
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(
          jsonEncode(payload),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = NearbyMosquesService(client: client);
      final mosques = await service.fetchNearby(
        latitude: 24.86,
        longitude: 67.0,
        radiusMeters: 5000,
      );

      expect(mosques, hasLength(5));
      final byName = {for (final m in mosques) m.name: m};

      expect(byName['Sunni Mosque']!.denomination.includesSunni, isTrue);
      expect(byName['Shia Mosque']!.denomination.includesShia, isTrue);
      expect(byName['Unspecified Mosque']!.denomination.isSpecified, isFalse);
      expect(
        label(byName['Multi Mosque']!.denomination),
        'Sunni · Ahmadiyya',
      );
      expect(
        label(byName['Jama Masjid Ahle Hadees']!.denomination),
        ahlEHadith,
      );
    });
  });
}
