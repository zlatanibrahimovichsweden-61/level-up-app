import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// CW12a copy register — TRACKING ONLY. **This test is NOT a release gate.**
///
/// Nothing in this repository stops a release build from shipping a string that
/// is not approved: there is no guard, build flag, flavor resource or CI step
/// that excludes provisional copy (searched `test/`, `tool/`, `.github/` and
/// `lib/` on 2026-10-10, CW12a_PLAN §4). This file only makes the CURRENT state
/// of the Support copy visible and stops it changing by accident:
///
/// * Eleven Support strings have English from the Figma frames and **no
///   Arabic supplied**. `app_ar.arb` carries the SAME ENGLISH text for them, so
///   the Arabic UI visibly shows English instead of presenting an unreviewed
///   Arabic translation as if it were approved. The English is a known gap, not
///   production-approved Arabic.
/// * `supportTicketMeta` is a format with no words (`{reference} · {date}`), so
///   it is the same in both languages and needs no Arabic.
/// * Four already-approved keys are reused by the Support screens and must not
///   change value.
///
/// **To graduate a key** when approved Arabic arrives: put the approved Arabic
/// in `app_ar.arb`, drop the `ARABIC NOT SUPPLIED` marker from the key's
/// `@key` description in `app_en.arb`, and move the key out of
/// [_arabicNotSupplied] below in the same change. This test failing on the AR
/// value is the prompt to do all three; it is not a reason to edit the test
/// alone.
void main() {
  /// The one sentence every unapproved key's English description carries.
  const marker = 'ARABIC NOT SUPPLIED (CW12a copy register)';

  /// The eleven keys that have English from Figma and no Arabic: key to its
  /// verbatim English text (Figma node in CW12a_PLAN §4.2).
  const arabicNotSupplied = <String, String>{
    'supportCreateNewTicket': 'Create a New Ticket',
    'supportDescribeYourIssue': 'Describe your issue',
    'supportRecentTickets': 'Recent Tickets',
    'supportNewTicketTitle': 'New Ticket',
    'supportCreateTicketSubtitle': "Describe your issue and we'll help you",
    'supportSubjectLabel': 'Subject',
    'supportDetailsLabel': 'Details',
    'supportDetailsHint': 'Describe the issue in detail...',
    'supportSubmitTicket': 'Submit Ticket',
    'supportStatusClosed': 'Closed',
    'supportComposerHint': 'Write your message',
  };

  /// The format-only key.
  const metaKey = 'supportTicketMeta';

  /// Every `support*` key CW12a registers: the eleven word keys and the format.
  final registered = <String>{...arabicNotSupplied.keys, metaKey};

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

  group('the register is exactly the twelve registered keys', () {
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

    test('the registered set is twelve keys and the legacy allowance one', () {
      expect(registered, hasLength(12));
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

  group('the eleven keys with no Arabic supplied show English in Arabic', () {
    test('app_en.arb has the verbatim Figma English', () {
      arabicNotSupplied.forEach((key, english) {
        expect(en[key], english, reason: '$key EN is not the Figma copy');
      });
    });

    test('app_ar.arb carries the SAME English text, not Arabic', () {
      arabicNotSupplied.forEach((key, english) {
        expect(
          ar[key],
          en[key],
          reason: '$key: AR must equal EN until approved',
        );
        expect(ar[key], english, reason: '$key AR is not the English text');
      });
    });

    test('no Arabic script enters those values before it is approved', () {
      final arabicScript = RegExp(r'[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]');
      arabicNotSupplied.forEach((key, _) {
        expect(
          arabicScript.hasMatch(ar[key] as String),
          isFalse,
          reason: '$key AR holds Arabic script that has not been approved',
        );
      });
    });

    test('every English description carries the marker', () {
      arabicNotSupplied.forEach((key, _) {
        expect(
          description(key),
          contains(marker),
          reason: '@$key lost the "$marker" marker',
        );
      });
    });

    test('every English description names its Figma node', () {
      arabicNotSupplied.forEach((key, _) {
        expect(
          description(key),
          matches(RegExp(r'Figma 178:\d+')),
          reason: '@$key does not name its Figma node',
        );
      });
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

    test('its description says format only and carries no marker', () {
      final d = description(metaKey);
      expect(d, contains('Format only'));
      expect(d, isNot(contains(marker)));
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
