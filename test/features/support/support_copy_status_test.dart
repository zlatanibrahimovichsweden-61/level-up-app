import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// CW12a copy register — TRACKING ONLY. **This test is NOT a release gate.**
///
/// Nothing in this repository stops a release build from shipping a string that
/// is not approved: there is no guard, build flag, flavor resource or CI step
/// that excludes provisional copy (searched `test/`, `tool/`, `.github/` and
/// `lib/` on 2026-10-10, CW12a_PLAN §4). This file pins the Support copy as the
/// owner APPROVED it, so it cannot drift by accident:
///
/// * **Approved 2026-10-10 (O-14, CW12a_FOLLOWUP_REPORT §13):** the Arabic for
///   the eleven Support strings whose English is Figma copy, and English AND
///   Arabic for three strings Figma does not draw: the Open and In progress
///   pills and the send button's accessible name. Each value below is the
///   owner's text, character for character.
/// * `supportCreateNewTicket` takes the SHORTER Arabic on purpose: the same
///   words as the approved `createTicket`. It is also the closed bar's button,
///   so both places read alike. The two must not drift apart.
/// * **Not approved: `pending`.** Its meaning to a student waits on SQ-32, so no
///   label for it may exist in either file.
/// * `supportTicketMeta` is a format with no words (`{reference} · {date}`), so
///   it is the same in both languages and needs no Arabic.
/// * Four already-approved keys are reused by the Support screens and must not
///   change value.
///
/// **Changing a value** needs the owner's approval first; then change the ARB
/// files and this table in the same change. This test failing on a value is
/// the prompt to check that approval exists, not a reason to edit the test
/// alone.
void main() {
  /// The sentence every key carried while its Arabic was missing. It must be
  /// gone from every description now.
  const oldMarker = 'ARABIC NOT SUPPLIED';

  /// What every approved key's English description records.
  const approvalNote = 'approved by the owner 2026-10-10 (O-14)';

  /// The eleven keys whose English is Figma copy (CW12a_PLAN §4.2), with the
  /// owner-approved Arabic.
  const approvedFromFigma = <String, ({String en, String ar})>{
    'supportCreateNewTicket': (en: 'Create a New Ticket', ar: 'إنشاء تذكرة'),
    'supportDescribeYourIssue': (en: 'Describe your issue', ar: 'اشرح مشكلتك'),
    'supportRecentTickets': (en: 'Recent Tickets', ar: 'التذاكر الأخيرة'),
    'supportNewTicketTitle': (en: 'New Ticket', ar: 'تذكرة جديدة'),
    'supportCreateTicketSubtitle': (
      en: "Describe your issue and we'll help you",
      ar: 'اشرح مشكلتك وسنساعدك',
    ),
    'supportSubjectLabel': (en: 'Subject', ar: 'الموضوع'),
    'supportDetailsLabel': (en: 'Details', ar: 'التفاصيل'),
    'supportDetailsHint': (
      en: 'Describe the issue in detail...',
      ar: 'اشرح المشكلة بالتفصيل...',
    ),
    'supportSubmitTicket': (en: 'Submit Ticket', ar: 'إرسال التذكرة'),
    'supportStatusClosed': (en: 'Closed', ar: 'مغلقة'),
    'supportComposerHint': (en: 'Write your message', ar: 'اكتب رسالتك'),
  };

  /// The three keys Figma does not draw, approved in both languages
  /// (CW12a_PLAN §4.3).
  const approvedNotDrawn = <String, ({String en, String ar})>{
    'supportStatusOpen': (en: 'Open', ar: 'مفتوحة'),
    'supportStatusInProgress': (en: 'In progress', ar: 'قيد المعالجة'),
    'supportSend': (en: 'Send', ar: 'إرسال'),
  };

  final approved = {...approvedFromFigma, ...approvedNotDrawn};

  /// The format-only key.
  const metaKey = 'supportTicketMeta';

  /// Every `support*` key CW12a registers: the fourteen word keys and the
  /// format.
  final registered = <String>{...approved.keys, metaKey};

  /// A `support*` key that PREDATES CW12a and is not part of its register: the
  /// old "Support isn't available yet." shell message. It is allowed to be
  /// present or gone; any OTHER `support*` key outside [registered] fails.
  const legacy = <String>{'supportUnavailable'};

  /// The four already-approved keys the Support screens reuse, with the EN and
  /// AR values they had before CW12a touched the ARB files (read from the files
  /// on 2026-10-10, before any edit).
  const reusedApproved = <String, ({String en, String ar})>{
    'profileCustomerSupport': (en: 'Customer Support', ar: 'دعم العملاء'),
    'createTicket': (en: 'Create Ticket', ar: 'إنشاء تذكرة'),
    'leaderboardYou': (en: 'You', ar: 'أنت'),
    'nothingHere': (en: 'Nothing here yet', ar: 'لا يوجد شيء هنا بعد'),
  };

  late Map<String, dynamic> en;
  late Map<String, dynamic> ar;

  Map<String, dynamic> readArb(String path) {
    final text = File(path).readAsStringSync();
    return jsonDecode(text) as Map<String, dynamic>;
  }

  setUpAll(() {
    en = readArb('lib/l10n/app_en.arb');
    ar = readArb('lib/l10n/app_ar.arb');
  });

  Set<String> supportKeys(Map<String, dynamic> arb) => {
    for (final k in arb.keys)
      if (k.startsWith('support')) k,
  };

  String description(String key) {
    final meta = en['@$key'];
    expect(
      meta,
      isA<Map>(),
      reason: '$key has no @$key metadata in the EN ARB',
    );
    final d = (meta as Map)['description'];
    expect(d, isA<String>(), reason: '@$key has no description');
    return d as String;
  }

  Set<String> placeholdersIn(String message) => {
    for (final m in RegExp(r'\{(\w+)\}').allMatches(message)) m.group(1)!,
  };

  final arabicScript = RegExp(r'[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]');

  group('the register is exactly the fifteen registered keys', () {
    test('every support* key in app_en.arb is registered or legacy', () {
      final extra = supportKeys(en).difference(registered).difference(legacy);
      expect(extra, isEmpty, reason: 'an unregistered support* key: $extra');
      expect(
        supportKeys(en).intersection(registered),
        registered,
        reason: 'a registered key is missing from app_en.arb',
      );
    });

    test('every support* key in app_ar.arb is registered or legacy', () {
      final extra = supportKeys(ar).difference(registered).difference(legacy);
      expect(extra, isEmpty, reason: 'an unregistered support* key: $extra');
      expect(
        supportKeys(ar).intersection(registered),
        registered,
        reason: 'a registered key is missing from app_ar.arb',
      );
    });

    test('the registered set is fifteen keys and the legacy allowance one', () {
      expect(approvedFromFigma, hasLength(11));
      expect(approvedNotDrawn, hasLength(3));
      expect(registered, hasLength(15));
      expect(legacy, hasLength(1));
      expect(registered.intersection(legacy), isEmpty);
    });

    test('app_en.arb carries @metadata for exactly the registered keys', () {
      // `@supportUnavailable` never existed, so the legacy key adds nothing.
      final meta = {
        for (final k in en.keys)
          if (k.startsWith('@support')) k.substring(1),
      };
      expect(meta, registered);
    });
  });

  group('the approved copy, character for character', () {
    test('app_en.arb has the approved English', () {
      approved.forEach((key, value) {
        expect(en[key], value.en, reason: '$key EN is not the approved text');
      });
    });

    test('app_ar.arb has the approved Arabic', () {
      approved.forEach((key, value) {
        expect(ar[key], value.ar, reason: '$key AR is not the approved text');
      });
    });

    test('no Arabic value is still the English placeholder', () {
      approved.forEach((key, _) {
        expect(ar[key], isNot(en[key]), reason: '$key AR is still English');
        expect(
          arabicScript.hasMatch(ar[key] as String),
          isTrue,
          reason: '$key AR holds no Arabic script',
        );
      });
    });

    test('Create a New Ticket shares createTicket\'s Arabic, by approval', () {
      expect(ar['supportCreateNewTicket'], ar['createTicket']);
      // The English stays distinct: only the Arabic was shortened.
      expect(en['supportCreateNewTicket'], isNot(en['createTicket']));
    });

    test('no description still carries the "Arabic not supplied" marker', () {
      for (final key in registered) {
        expect(
          description(key),
          isNot(contains(oldMarker)),
          reason: '@$key still says its Arabic is missing',
        );
      }
    });

    test('every approved description records the approval', () {
      approved.forEach((key, _) {
        expect(
          description(key),
          contains(approvalNote),
          reason: '@$key does not record the owner approval',
        );
      });
    });

    test('every Figma key names its Figma node', () {
      approvedFromFigma.forEach((key, _) {
        expect(
          description(key),
          matches(RegExp(r'Figma 178:\d+')),
          reason: '@$key does not name its Figma node',
        );
      });
    });
  });

  group('pending has no label (SQ-32)', () {
    test('no support* key is named for pending, in either file', () {
      for (final arb in [en, ar]) {
        final pending = {
          for (final k in arb.keys)
            if (k.toLowerCase().contains('support') &&
                k.toLowerCase().contains('pending'))
              k,
        };
        expect(pending, isEmpty, reason: 'a pending label exists: $pending');
      }
    });

    test('no support value is the provisional pending text', () {
      // The plan's provisional words (CW12a_PLAN §4.3), never approved.
      for (final key in supportKeys(en)) {
        expect(en[key], isNot('Pending'), reason: key);
      }
      for (final key in supportKeys(ar)) {
        expect(ar[key], isNot(contains('معلّقة')), reason: key);
        expect(ar[key], isNot(contains('معلقة')), reason: key);
      }
    });
  });

  group('supportTicketMeta is format only', () {
    test('the same message in both files', () {
      expect(en[metaKey], '{reference} · {date}');
      expect(ar[metaKey], en[metaKey]);
    });

    test('the same placeholders in both files', () {
      expect(placeholdersIn(en[metaKey] as String), {'reference', 'date'});
      expect(
        placeholdersIn(ar[metaKey] as String),
        placeholdersIn(en[metaKey] as String),
      );
    });

    test('both placeholders are declared as String in the EN metadata', () {
      final meta = en['@$metaKey'] as Map;
      final placeholders = meta['placeholders'] as Map;
      expect(placeholders.keys.toSet(), {'reference', 'date'});
      for (final entry in placeholders.entries) {
        expect(
          (entry.value as Map)['type'],
          'String',
          reason: '${entry.key} must be a String placeholder',
        );
      }
    });

    test('its description says format only', () {
      expect(description(metaKey), contains('Format only'));
    });
  });

  group('the reused approved keys did not change', () {
    reusedApproved.forEach((key, value) {
      test('$key keeps its approved EN and AR', () {
        expect(en[key], value.en, reason: '$key EN changed');
        expect(ar[key], value.ar, reason: '$key AR changed');
      });
    });
  });
}
