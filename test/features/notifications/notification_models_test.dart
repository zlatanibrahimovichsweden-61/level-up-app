import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/notifications/models/notification_models.dart';

import '../../guards/rules.dart';
import 'notification_fixtures.dart';

/// The inbox item model and the classification that decides what is shown.
///
/// The rules guarded here are the ones the contract states in PROSE
/// (`openapi.yaml:1162-1197`) and a client can silently get wrong:
/// - an unknown `kind` or `category` must be IGNORED, never a parse failure;
/// - an `announcement`'s text is display text, in four required keys;
/// - `moderation_warning` carries no data at all;
/// - `readAt` is the server's, and null is its ordinary value.
void main() {
  group('NotificationCategory', () {
    test('wire values are the contract enum, spelled exactly', () {
      expect(
        [for (final c in NotificationCategory.values) c.wire],
        ['system', 'announcements', 'support'],
      );
    });

    test('tryParse returns the member for each published value', () {
      expect(
        NotificationCategory.tryParse('system'),
        NotificationCategory.system,
      );
      expect(
        NotificationCategory.tryParse('announcements'),
        NotificationCategory.announcements,
      );
      expect(
        NotificationCategory.tryParse('support'),
        NotificationCategory.support,
      );
    });

    test('tryParse returns null for anything else - never throws', () {
      for (final value in const [
        'promotions',
        'all',
        'System',
        'announcement',
        '',
      ]) {
        expect(NotificationCategory.tryParse(value), isNull, reason: value);
      }
      expect(NotificationCategory.tryParse(null), isNull);
    });
  });

  group('NotificationItem.fromJson', () {
    test('decodes all six wire fields of an unread item', () {
      final item = NotificationItem.fromJson(wireItem());

      expect(item.notificationId, '5a000000-0000-4000-8000-000000000001');
      expect(item.kind, 'announcement');
      expect(item.category, 'announcements');
      expect(item.data['titleEn'], 'English title');
      expect(item.createdAt, DateTime.utc(2026, 10, 9, 12));
      expect(item.createdAt.isUtc, isTrue);
      // `null` is the ordinary value of `readAt`, not an error.
      expect(item.readAt, isNull);
    });

    test('decodes readAt when the server has one', () {
      final item = NotificationItem.fromJson(
        wireItem(readAt: '2026-10-09T12:30:00Z'),
      );

      expect(item.readAt, DateTime.utc(2026, 10, 9, 12, 30));
    });

    test('an absent readAt key is "not read", like an explicit null', () {
      final json = wireItem()..remove('readAt');

      expect(NotificationItem.fromJson(json).readAt, isNull);
    });

    test('an unknown kind decodes - it is classified, not rejected', () {
      // The contract: "Clients MUST ignore an item whose `kind` they do not
      // recognise". A strict enum here would fail the WHOLE page on the first
      // new server-side value.
      final item = NotificationItem.fromJson(
        wireItem(kind: 'brand_new_kind', data: const <String, dynamic>{}),
      );

      expect(item.kind, 'brand_new_kind');
      expect(item.content, isNull);
    });

    test('an unknown category decodes and has no known category', () {
      final item = NotificationItem.fromJson(wireItem(category: 'promotions'));

      expect(item.category, 'promotions');
      expect(item.knownCategory, isNull);
    });

    test('a known category maps to its enum member', () {
      final item = NotificationItem.fromJson(wireItem());

      expect(item.knownCategory, NotificationCategory.announcements);
    });

    test('data keeps String values and drops everything else', () {
      final item = NotificationItem.fromJson(
        wireItem(
          data: <String, dynamic>{
            'reference': 'TK-12',
            'count': 3,
            'flag': true,
            'nothing': null,
            'nested': <String, dynamic>{'a': 'b'},
            'list': <String>['x'],
          },
        ),
      );

      expect(item.data, {'reference': 'TK-12'});
    });

    test('an empty data object is an empty map', () {
      final item = NotificationItem.fromJson(
        wireItem(
          kind: 'moderation_warning',
          category: 'system',
          data: const <String, dynamic>{},
        ),
      );

      expect(item.data, isEmpty);
    });

    for (final key in const [
      'notificationId',
      'kind',
      'category',
      'data',
      'createdAt',
    ]) {
      test('a missing $key throws - the contract marks it required', () {
        final json = wireItem()..remove(key);

        expect(() => NotificationItem.fromJson(json), throwsA(anything));
      });
    }

    test('a value of the wrong type throws', () {
      expect(
        () => NotificationItem.fromJson(wireItem()..['kind'] = 7),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => NotificationItem.fromJson(wireItem()..['data'] = 'text'),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => NotificationItem.fromJson(wireItem(createdAt: 'yesterday')),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('classification - what is shown', () {
    test('an announcement shows its four texts', () {
      final content = notificationContentFor(
        notification(
          'a',
          data: announcementData(
            titleEn: 'New Biology Quiz Available!',
            bodyEn: 'Test your knowledge now!',
            titleAr: 'اختبار جديد',
            bodyAr: 'اختبر معلوماتك الآن',
          ),
        ),
      );

      expect(content, isA<AnnouncementContent>());
      final announcement = content! as AnnouncementContent;
      expect(announcement.titleEn, 'New Biology Quiz Available!');
      expect(announcement.bodyEn, 'Test your knowledge now!');
      expect(announcement.titleAr, 'اختبار جديد');
      expect(announcement.bodyAr, 'اختبر معلوماتك الآن');
    });

    test('the item getter agrees with the function', () {
      final item = announcementItem('a');

      expect(item.content, isA<AnnouncementContent>());
    });

    test('titleFor / bodyFor pick the UI language', () {
      final content =
          notificationContentFor(announcementItem('a'))! as AnnouncementContent;

      expect(content.titleFor('ar'), content.titleAr);
      expect(content.bodyFor('ar'), content.bodyAr);
      expect(content.titleFor('en'), content.titleEn);
      expect(content.bodyFor('en'), content.bodyEn);
      // English is the fallback for anything that is not Arabic.
      expect(content.titleFor('fr'), content.titleEn);
    });

    test('text is plain: line breaks kept, nothing trimmed or linked', () {
      const body = 'Line one\nLine two\n\nhttps://example.test/a?b=1 and more ';
      final content =
          notificationContentFor(
                notification('a', data: announcementData(bodyEn: body)),
              )!
              as AnnouncementContent;

      // Verbatim - the model neither strips, collapses, nor wraps a URL.
      expect(content.bodyEn, body);
    });

    test('a moderation_warning shows the fixed warning, whatever data says', () {
      expect(
        notificationContentFor(warningItem('w')),
        isA<ModerationWarningContent>(),
      );
      // Its data is always empty by contract; if it ever carried something the
      // app still renders only the approved copy, never that data.
      expect(
        notificationContentFor(
          notification(
            'w',
            kind: 'moderation_warning',
            category: 'system',
            data: const {'extra': 'value'},
          ),
        ),
        isA<ModerationWarningContent>(),
      );
    });
  });

  group('classification - what is IGNORED', () {
    test('enrolment_opened is known to the contract and still ignored', () {
      // SQ-20: its localized copy and data keys are not sourced yet.
      expect(notificationContentFor(ignoredItem('e')), isNull);
    });

    test('support_ticket_replied is ignored (CW07b)', () {
      expect(
        notificationContentFor(
          notification(
            't',
            kind: 'support_ticket_replied',
            category: 'support',
            data: const {'ticketId': 'tid', 'reference': 'TK-12'},
          ),
        ),
        isNull,
      );
    });

    test('academic_year_opened is ignored (CW07b)', () {
      expect(
        notificationContentFor(
          notification(
            'y',
            kind: 'academic_year_opened',
            category: 'system',
            data: const {'track': 'school', 'academicYear': '2026/2027'},
          ),
        ),
        isNull,
      );
    });

    test('an unknown kind is ignored', () {
      expect(
        notificationContentFor(notification('u', kind: 'brand_new_kind')),
        isNull,
      );
      expect(notificationContentFor(notification('u', kind: '')), isNull);
      // Kinds are exact: a near-miss is a different, unknown kind.
      expect(
        notificationContentFor(notification('u', kind: 'Announcement')),
        isNull,
      );
    });

    test(
      'an unknown category is ignored even for a known, well-formed kind',
      () {
        expect(
          notificationContentFor(notification('c', category: 'promotions')),
          isNull,
        );
        expect(
          notificationContentFor(
            notification(
              'c',
              kind: 'moderation_warning',
              category: 'promotions',
            ),
          ),
          isNull,
        );
      },
    );

    for (final key in const ['titleEn', 'titleAr', 'bodyEn', 'bodyAr']) {
      test('an announcement missing $key is ignored', () {
        final data = announcementData()..remove(key);

        expect(notificationContentFor(notification('a', data: data)), isNull);
      });
    }

    test('an announcement whose text is not a String is ignored', () {
      // `fromJson` drops non-String data values, so a numeric title reaches the
      // classifier as an absent one.
      final item = NotificationItem.fromJson(
        wireItem(data: <String, dynamic>{...announcementData(), 'titleEn': 42}),
      );

      expect(item.content, isNull);
    });

    test('an announcement with no data at all is ignored', () {
      expect(notificationContentFor(notification('a', data: const {})), isNull);
    });

    test('announcementId is not needed to show an announcement', () {
      final data = announcementData()..remove('announcementId');

      expect(
        notificationContentFor(notification('a', data: data)),
        isA<AnnouncementContent>(),
      );
    });
  });

  group('contract binding', () {
    // `contract_models_test.dart` binds `components/schemas` entries only; this
    // item schema is INLINE in the `listMyNotifications` response, so it is
    // bound here instead, with the same method: the `required: [...]` list is
    // read out of the contract at run time and each name must be a constructor
    // parameter of the Dart class.
    late String contract;

    setUpAll(() {
      contract = File('contract/openapi.yaml').readAsStringSync();
    });

    List<String> requiredItemFields() {
      final operation = contract.indexOf('operationId: listMyNotifications');
      expect(operation, isNonNegative, reason: 'listMyNotifications moved');
      final item = contract.indexOf('notificationId:', operation);
      expect(item, isNonNegative, reason: 'the inline item schema moved');
      final match = RegExp(
        r'required:\s*\[([^\]]*)\]',
      ).firstMatch(contract.substring(item));
      expect(
        match,
        isNotNull,
        reason: 'the item schema lost its required list',
      );
      return match!
          .group(1)!
          .split(',')
          .map((name) => name.trim())
          .where((name) => name.isNotEmpty)
          .toList();
    }

    test('the contract is read: six required fields', () {
      expect(requiredItemFields(), [
        'notificationId',
        'kind',
        'category',
        'data',
        'createdAt',
        'readAt',
      ]);
    });

    test('every contract-required field is a NotificationItem parameter', () {
      final dart = File(
        'lib/features/notifications/models/notification_models.dart',
      ).readAsStringSync();
      final body = dartClassBody(dart, 'NotificationItem');
      expect(body, isNotNull, reason: 'NotificationItem was renamed or moved');

      final missing = [
        for (final field in requiredItemFields())
          if (!dartDeclaresField(body!, field)) field,
      ];

      expect(
        missing,
        isEmpty,
        reason:
            'contract/openapi.yaml marks ${missing.join(", ")} as REQUIRED on '
            'the listMyNotifications item, but NotificationItem does not take '
            'it as a constructor parameter.',
      );
    });

    test('the probe can fail: a class without readAt is caught', () {
      // Proves the check above is not vacuous.
      const withoutReadAt = '''
class NotificationItem {
  const NotificationItem({
    required this.notificationId,
    required this.kind,
    required this.category,
    required this.data,
    required this.createdAt,
  });
}
''';
      final body = dartClassBody(withoutReadAt, 'NotificationItem')!;

      expect(dartDeclaresField(body, 'readAt'), isFalse);
      expect(dartDeclaresField(body, 'createdAt'), isTrue);
    });
  });
}
