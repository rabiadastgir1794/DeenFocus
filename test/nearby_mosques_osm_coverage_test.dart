import 'dart:convert';

import 'package:deenly/core/services/nearby_mosques_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  Map<String, dynamic> node({
    required int id,
    required Map<String, dynamic> tags,
    double lat = 31.55,
    double lon = 74.34,
  }) {
    return <String, dynamic>{
      'type': 'node',
      'id': id,
      'lat': lat,
      'lon': lon,
      'tags': tags,
    };
  }

  Future<List<NearbyMosque>> search(List<Map<String, dynamic>> elements) {
    final service = NearbyMosquesService(
      client: MockClient((request) async {
        return http.Response(
          jsonEncode(<String, dynamic>{'elements': elements}),
          200,
        );
      }),
    );
    return service.fetchNearby(
      latitude: 31.52,
      longitude: 74.35,
      radiusMeters: 5000,
    );
  }

  test('query asks Overpass for musalla tags and masjid names', () async {
    String? body;
    final service = NearbyMosquesService(
      client: MockClient((request) async {
        body ??= request.body;
        return http.Response(
          jsonEncode(<String, dynamic>{'elements': <Object>[]}),
          200,
        );
      }),
    );

    await service.fetchNearby(
      latitude: 31.52,
      longitude: 74.35,
      radiusMeters: 5000,
    );

    expect(body, contains('nwr["amenity"="musalla"]'));
    expect(body, contains('moslem'));
    expect(body, contains('masjid|mosque|musalla|musallah|mosqu..e'));
    expect(body, contains('islamic cent(re|er)'));
    expect(body, contains('name:fr'));
    expect(body, contains('name:ur'));
    expect(body, isNot(contains('مسجد')));
  });

  test(
    'keeps name-only and musalla masajid, drops roads shops and ruins',
    () async {
      final mosques = await search([
        node(id: 1, tags: const {'name': 'Noor Masjid'}),
        node(id: 2, tags: const {'amenity': 'musalla', 'name': 'Musalla Hall'}),
        node(
          id: 3,
          tags: const {
            'building': 'yes',
            'religion': 'moslem',
            'name': 'Community Hall',
          },
        ),
        node(
          id: 4,
          tags: const {'highway': 'residential', 'name': 'Masjid Road'},
        ),
        node(
          id: 5,
          tags: const {'amenity': 'restaurant', 'name': 'Masjid Grill'},
        ),
        node(
          id: 6,
          tags: const {
            'amenity': 'mosque',
            'name': 'Old Masjid',
            'ruins': 'yes',
          },
        ),
        node(
          id: 7,
          tags: const {'disused:amenity': 'mosque', 'name': 'Closed Masjid'},
        ),
        node(
          id: 8,
          tags: const {
            'amenity': 'place_of_worship',
            'religion': 'christian',
            'name': 'Mosque Hill Church',
          },
        ),
      ]);

      final names = mosques.map((m) => m.name).toSet();
      expect(names, {'Noor Masjid', 'Musalla Hall', 'Community Hall'});

      final byName = {for (final m in mosques) m.name: m};
      expect(byName['Noor Masjid']!.confidence, NearbyMosqueConfidence.low);
      expect(byName['Musalla Hall']!.confidence, NearbyMosqueConfidence.low);
      expect(
        byName['Community Hall']!.confidence,
        NearbyMosqueConfidence.medium,
      );
    },
  );

  test('an empty timeout does not hide a later complete mirror', () async {
    final service = NearbyMosquesService(
      client: MockClient((request) async {
        if (request.url.host.contains('private.coffee')) {
          return http.Response(
            jsonEncode(<String, dynamic>{
              'remark': 'runtime error: Query timed out.',
              'elements': <Object>[],
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode(<String, dynamic>{
            'elements': [
              node(
                id: 9,
                tags: const {'amenity': 'mosque', 'name': 'Slow Mirror Masjid'},
              ),
            ],
          }),
          200,
        );
      }),
    );

    final mosques = await service.fetchNearby(
      latitude: 31.52,
      longitude: 74.35,
      radiusMeters: 5000,
    );

    expect(mosques.map((m) => m.name), ['Slow Mirror Masjid']);
  });

  test(
    'keeps a Canadian Islamic Centre within 1 km of a tagged masjid',
    () async {
      // Halifax: way 462587947 is building=yes / name=Islamic Centre,
      // 639 m from way 596118328 Ummah Masjid (place_of_worship, muslim).
      final service = NearbyMosquesService(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode(<String, dynamic>{
              'elements': [
                node(
                  id: 462587947,
                  lat: 44.65634,
                  lon: -63.59778,
                  tags: const {'building': 'yes', 'name': 'Islamic Centre'},
                ),
                node(
                  id: 596118328,
                  lat: 44.65059,
                  lon: -63.59764,
                  tags: const {
                    'amenity': 'place_of_worship',
                    'building': 'yes',
                    'name': 'Ummah Masjid',
                    'religion': 'muslim',
                  },
                ),
                node(
                  id: 3,
                  tags: const {
                    'amenity': 'school',
                    'building': 'yes',
                    'name': 'Islamic Centre School',
                  },
                ),
                node(
                  id: 4,
                  lat: 44.65650,
                  lon: -63.59790,
                  tags: const {'name': 'Mosquée Al-Rawdah'},
                ),
                node(
                  id: 5,
                  lat: 44.65660,
                  lon: -63.59800,
                  tags: const {'name:fr': 'Mosquée Tawuba'},
                ),
                node(
                  id: 6,
                  lat: 44.65620,
                  lon: -63.59760,
                  tags: const {
                    'landuse': 'religious',
                    'name': 'Islamic Center',
                  },
                ),
              ],
            }),
            200,
          );
        }),
      );

      final mosques = await service.fetchNearby(
        latitude: 44.65634,
        longitude: -63.59778,
        radiusMeters: 1000,
      );

      final byName = {for (final m in mosques) m.name: m};
      expect(byName.keys, {
        'Islamic Centre',
        'Ummah Masjid',
        'Mosquée Al-Rawdah',
        'Mosquée Tawuba',
        'Islamic Center',
      });
      expect(byName['Ummah Masjid']!.distanceMeters, lessThan(1000));
      expect(byName['Islamic Centre']!.confidence, NearbyMosqueConfidence.low);
      expect(byName['Ummah Masjid']!.denomination.isSpecified, isFalse);
    },
  );

  test('an Overpass error remark is not reported as no mosques', () async {
    final service = NearbyMosquesService(
      client: MockClient((request) async {
        return http.Response(
          jsonEncode(<String, dynamic>{
            'remark': 'runtime error: Query run out of memory.',
            'elements': <Object>[],
          }),
          200,
        );
      }),
    );

    expect(
      service.fetchNearby(
        latitude: 44.65634,
        longitude: -63.59778,
        radiusMeters: 1000,
      ),
      throwsA(
        isA<NearbyMosquesException>().having(
          (error) => error.message,
          'message',
          contains('could not return nearby mosques'),
        ),
      ),
    );
  });
}
