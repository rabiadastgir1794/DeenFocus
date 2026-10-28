import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:deenly/core/services/nearby_mosques_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const mosqueBody = '''
{"elements":[{"type":"node","id":1,"lat":31.55,"lon":74.34,"tags":{"amenity":"mosque","name":"Badshahi Mosque"}}]}
''';

  NearbyMosquesService service({
    required Future<http.Response> Function(http.Request request) handler,
    int maxTransientAttempts = 3,
    Duration requestTimeout = const Duration(seconds: 2),
    Duration Function(int attempt)? backoff,
    Future<void> Function(Duration delay)? sleep,
  }) {
    return NearbyMosquesService(
      client: MockClient(handler),
      maxTransientAttempts: maxTransientAttempts,
      requestTimeout: requestTimeout,
      backoff: backoff ?? (_) => Duration.zero,
      sleep: sleep ?? (_) async {},
    );
  }

  Future<List<NearbyMosque>> search(NearbyMosquesService mosques) {
    return mosques.fetchNearby(
      latitude: 31.52,
      longitude: 74.35,
      radiusMeters: 5000,
    );
  }

  test('a client timeout is retried and then reported as a timeout', () async {
    var calls = 0;
    final mosques = service(
      maxTransientAttempts: 2,
      requestTimeout: const Duration(milliseconds: 20),
      handler: (request) async {
        calls++;
        await Completer<void>().future;
        return http.Response(mosqueBody, 200);
      },
    );

    await expectLater(
      search(mosques),
      throwsA(
        isA<NearbyMosquesException>()
            .having((error) => error.kind, 'kind', NearbyMosquesFailureKind.timeout)
            .having((error) => error.retryable, 'retryable', isTrue)
            .having((error) => error.message, 'message', contains('took too long')),
      ),
    );
    expect(calls, 6);
  });

  test('a 429 is retried after Retry-After and can recover', () async {
    var calls = 0;
    final delays = <Duration>[];
    final mosques = service(
      sleep: (delay) async {
        delays.add(delay);
      },
      backoff: (_) => const Duration(milliseconds: 10),
      handler: (request) async {
        calls++;
        if (calls <= 3) {
          return http.Response(
            'slow down',
            429,
            headers: const <String, String>{'retry-after': '3'},
          );
        }
        return http.Response(mosqueBody, 200);
      },
    );

    final found = await search(mosques);

    expect(found.map((mosque) => mosque.name), ['Badshahi Mosque']);
    expect(delays, [const Duration(seconds: 3)]);
    expect(calls, greaterThan(3));
  });

  test('a 504 is retried and is not reported as offline', () async {
    var calls = 0;
    final mosques = service(
      maxTransientAttempts: 2,
      handler: (request) async {
        calls++;
        return http.Response('gateway timeout', 504);
      },
    );

    await expectLater(
      search(mosques),
      throwsA(
        isA<NearbyMosquesException>()
            .having((error) => error.kind, 'kind', NearbyMosquesFailureKind.server)
            .having((error) => error.retryable, 'retryable', isTrue)
            .having((error) => error.message, 'message', contains('busy')),
      ),
    );
    expect(calls, greaterThan(3));
  });

  test('an offline failure is retried and stays an offline error', () async {
    var calls = 0;
    final mosques = service(
      maxTransientAttempts: 2,
      handler: (request) async {
        calls++;
        throw const SocketException('network is unreachable');
      },
    );

    await expectLater(
      search(mosques),
      throwsA(
        isA<NearbyMosquesException>()
            .having((error) => error.kind, 'kind', NearbyMosquesFailureKind.offline)
            .having((error) => error.retryable, 'retryable', isTrue)
            .having(
              (error) => error.message,
              'message',
              contains('No internet connection'),
            ),
      ),
    );
    expect(calls, 6);
  });

  test('a server error recovers on a later attempt', () async {
    var calls = 0;
    final mosques = service(
      handler: (request) async {
        calls++;
        if (calls <= 3) return http.Response('unavailable', 503);
        return http.Response(mosqueBody, 200);
      },
    );

    final found = await search(mosques);

    expect(found.single.name, 'Badshahi Mosque');
    expect(calls, greaterThan(3));
  });

  test('the same in-flight query is not sent twice', () async {
    var calls = 0;
    final gate = Completer<void>();
    final dense = jsonEncode(<String, dynamic>{
      'elements': <Object>[
        for (var id = 0; id < 12; id++)
          <String, Object>{
            'type': 'node',
            'id': id,
            'lat': 31.55,
            'lon': 74.34 + (id * 0.001),
            'tags': <String, String>{
              'amenity': 'mosque',
              'name': 'Masjid $id',
            },
          },
      ],
    });
    final mosques = service(
      handler: (request) async {
        calls++;
        await gate.future;
        return http.Response(dense, 200);
      },
    );

    final first = search(mosques);
    final second = search(mosques);
    await Future<void>.delayed(Duration.zero);
    expect(calls, 3);
    gate.complete();

    final results = await Future.wait([first, second]);
    expect(results[0], hasLength(12));
    expect(results[1], hasLength(12));
    expect(calls, 3);
  });

  test('an Overpass timeout remark is retried, then recovered', () async {
    var calls = 0;
    final mosques = service(
      handler: (request) async {
        calls++;
        if (calls <= 3) {
          return http.Response(
            jsonEncode(<String, dynamic>{
              'remark': 'runtime error: Query timed out.',
              'elements': <Object>[],
            }),
            200,
          );
        }
        return http.Response(mosqueBody, 200);
      },
    );

    final found = await search(mosques);

    expect(found.single.name, 'Badshahi Mosque');
    expect(calls, greaterThan(3));
  });
}
