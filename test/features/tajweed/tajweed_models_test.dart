import 'package:deenly/features/tajweed/model/tajweed_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TajweedScoreResult', () {
    test('round-trips JSON schema from ADR-006', () {
      const json = <String, dynamic>{
        'ref': '1:4',
        'expected': 'مَالِكِ يَوْمِ الدِّينِ',
        'hypothesis': 'مَالِكِ يَوْمِ الدِّينِ',
        'durationSec': 4.68,
        'wordAccuracy': 1.0,
        'exactMatch': true,
        'tokens': [
          {
            'text': 'مَالِكِ',
            'status': 'ok',
            'prob': 0.92,
            'startSec': 0.1,
            'endSec': 0.4,
          },
          {'text': 'يَوْمِ', 'status': 'minor', 'prob': 0.7},
        ],
      };

      final score = TajweedScoreResult.fromJson(json);
      expect(score.ref, '1:4');
      expect(score.exactMatch, isTrue);
      expect(score.tokens, hasLength(2));
      expect(score.tokens[0].status, TajweedTokenStatus.ok);
      expect(score.tokens[1].status, TajweedTokenStatus.minor);
      expect(score.tokenSummary.ok, 1);
      expect(score.tokenSummary.minor, 1);
      expect(score.tokenSummary.sub, 0);

      final encoded = score.toJson();
      final again = TajweedScoreResult.fromJson(encoded);
      expect(again.ref, score.ref);
      expect(again.tokens.length, score.tokens.length);
    });

    test('parses substitution status and additive lexical fields', () {
      final score = TajweedScoreResult.fromJson(const <String, dynamic>{
        'ref': '112:1',
        'expected': 'قُلْ هُوَ',
        'hypothesis': 'مَالِكِ يَوْمِ',
        'durationSec': 2.0,
        'wordAccuracy': 0.0,
        'exactMatch': false,
        'tokens': [
          {
            'text': 'قُلْ',
            'status': 'sub',
            'lexical': 'sub',
            'pronunciation': null,
            'prob': 0.0,
          },
          {
            'text': 'هُوَ',
            'status': 'ok',
            'lexical': 'match',
            'pronunciation': 'ok',
            'prob': 0.95,
          },
        ],
      });
      expect(score.tokens[0].status, TajweedTokenStatus.sub);
      expect(score.tokens[0].lexical, 'sub');
      expect(score.tokens[1].lexical, 'match');
      expect(score.tokens[1].pronunciation, 'ok');
      expect(score.tokenSummary.sub, 1);
      expect(score.tokenSummary.ok, 1);
      expect(score.wordAccuracy, 0.0);
    });
  });

  group('TajweedHistoryEntry', () {
    test('builds from score without storing hypothesis audio', () {
      final score = TajweedScoreResult.fromJson(const <String, dynamic>{
        'ref': '1:1',
        'expected': 'بِسْمِ',
        'hypothesis': 'بِسْمِ',
        'durationSec': 1.2,
        'wordAccuracy': 1.0,
        'exactMatch': true,
        'tokens': [
          {'text': 'بِسْمِ', 'status': 'ok', 'prob': 0.99},
        ],
      });

      final entry = TajweedHistoryEntry.fromScore(
        surah: 1,
        ayah: 1,
        score: score,
      );

      expect(entry.surah, 1);
      expect(entry.ayah, 1);
      expect(entry.ref, '1:1');
      expect(entry.toJson().containsKey('hypothesis'), isFalse);
      expect(entry.tokenSummary.ok, 1);
    });
  });

  group('TajweedRecordingState', () {
    test('parses wire names', () {
      expect(
        TajweedRecordingState.fromName('recording'),
        TajweedRecordingState.recording,
      );
      expect(
        TajweedRecordingState.fromName('unknown'),
        TajweedRecordingState.idle,
      );
    });
  });
}
