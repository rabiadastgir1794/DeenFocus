import 'package:deenly/core/share/content_share_payload.dart';
import 'package:deenly/core/share/content_share_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentSharePayload', () {
    test('builds intro and both store links without repeating card text', () {
      const payload = ContentSharePayload(
        title: 'Brotherhood in faith',
        paragraphs: [
          'None of you truly believes until he loves for his brother what he loves for himself.',
        ],
        fields: [
          ContentShareField(label: 'Narrator:', value: 'Anas ibn Malik (RA)'),
          ContentShareField(label: 'Source:', value: 'Sahih Muslim 45'),
        ],
      );

      final message = payload.buildMessage(
        intro:
            'Hey there! 👋 Check out DeenFocus — an app for Quran, Salah, and learning. I’m sharing this content from the app with you. 🤍',
        exploreLabel: 'Explore DeenFocus:',
        storeLinks: ContentShareService.storeLinksBlock,
      );

      expect(message, contains('Hey there! 👋 Check out DeenFocus'));
      expect(message, isNot(contains('Brotherhood in faith')));
      expect(message, isNot(contains('None of you truly believes')));
      expect(message, contains('Explore DeenFocus:'));
      expect(message, contains('iOS: ${ContentShareService.iosStoreUrl}'));
      expect(
        message,
        contains('Android: ${ContentShareService.androidStoreUrl}'),
      );
      expect(message, isNot(contains('deenfocus.app/download')));
    });
  });

  test('storeLinksBlock lists both store constants once', () {
    expect(
      ContentShareService.storeLinksBlock,
      contains(ContentShareService.iosStoreUrl),
    );
    expect(
      ContentShareService.storeLinksBlock,
      contains(ContentShareService.androidStoreUrl),
    );
  });
}
