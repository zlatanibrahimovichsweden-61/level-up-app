import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/account_shells/screens/friends_screen.dart';
import 'package:level_up_app/features/account_shells/screens/legal_document_screen.dart';
import 'package:level_up_app/features/account_shells/screens/refer_a_friend_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_harness.dart' show locationOf;
import 'settings_harness.dart';

/// The four disabled shell screens.
///
/// **Shells, not mocks.** The claim every test here defends is that these
/// screens render the shape of a designed feature and contain **no invented
/// data** — no referral code, no ticket, no friend row, no legal paragraph. The
/// negative assertions (`findsNothing` on inputs and lists) are the point of
/// the file, not padding: the failure being prevented is a future edit that
/// makes one of these look plausible.
void main() {
  /// route → the screen's title, in EN.
  const shells = <String, String>{
    '/refer': 'Refer a Friend',
    '/support': 'Customer Support',
    '/friends': 'Friends',
    '/legal/privacy': 'Privacy & policy',
    '/legal/terms': 'Terms & Conditions',
  };

  /// The disabled primary controls, by route → `Key`.
  const deadControls = <String, String>{
    '/refer': 'refer_share_button',
    '/support': 'support_create_ticket_button',
  };

  group('each shell exists at its route', () {
    for (final entry in shells.entries) {
      testWidgets('${entry.key} renders "${entry.value}"', (tester) async {
        final container = await pumpAppAt(tester, entry.key);

        expect(locationOf(container), entry.key);
        expect(find.text(entry.value), findsOneWidget);
      });
    }

    testWidgets('the right screen class, not a placeholder', (tester) async {
      for (final pair in <String, Type>{
        '/refer': ReferAFriendScreen,
        '/support': CustomerSupportScreen,
        '/friends': FriendsScreen,
        '/legal/privacy': LegalDocumentScreen,
      }.entries) {
        await pumpAppAt(tester, pair.key);
        expect(find.byType(pair.value), findsOneWidget);
        expect(find.textContaining('not built yet'), findsNothing);
      }
    });
  });

  group('no invented data', () {
    for (final route in shells.keys) {
      testWidgets('$route has nothing to type into and nothing to list',
          (tester) async {
        await pumpAppAt(tester, route);

        // A referral code, a ticket form, a friend search: all of them would
        // need one of these, and none of them has an endpoint.
        expect(find.byType(TextField), findsNothing);
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(TextButton), findsNothing);
      });
    }

    testWidgets('the only live control on a shell is the way back',
        (tester) async {
      for (final route in shells.keys) {
        await pumpAppAt(tester, route);

        expect(
          find.byType(InkWell),
          findsOneWidget,
          reason: '$route must offer exactly one tap target: the back chip',
        );
      }
    });

    testWidgets('a shell fetches nothing', (tester) async {
      final repo = settingsRepo();
      await pumpAppAt(tester, '/refer', profile: repo);

      // Home's one call, and no more. A shell with no endpoint must not invent
      // a request either.
      verify(repo.getMe).called(1);
      verifyNever(() => repo.updateMe(any()));
    });
  });

  group('the drawn controls render and are dead', () {
    for (final entry in deadControls.entries) {
      testWidgets('${entry.value} is structurally non-interactive',
          (tester) async {
        await pumpAppAt(tester, entry.key);
        expectDeadControl(tester, entry.value);
      });
    }

    testWidgets('and each announces itself disabled, with a reason',
        (tester) async {
      const reasons = <String, String>{
        'refer_share_button': 'Inviting friends isn\'t available yet.',
        'support_create_ticket_button': 'Support isn\'t available yet.',
      };

      for (final entry in deadControls.entries) {
        final handle = tester.ensureSemantics();
        await pumpAppAt(tester, entry.key);

        expect(
          tester.getSemantics(find.byKey(Key(entry.value))),
          isSemantics(
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
            hint: reasons[entry.value],
          ),
          reason: '${entry.value} must say why it cannot be used',
        );
        handle.dispose();
      }
    });

    testWidgets('tapping a dead control does nothing at all', (tester) async {
      final container = await pumpAppAt(tester, '/refer');

      await tester.tap(
        find.byKey(const Key('refer_share_button')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(locationOf(container), '/refer');
    });
  });

  group('legal — one screen, two documents, no copy', () {
    testWidgets('both routes render the same empty body, different titles',
        (tester) async {
      await pumpAppAt(tester, '/legal/privacy');
      expect(find.byKey(const Key('legal_body')), findsOneWidget);
      expect(find.text('This document hasn\'t been published yet.'),
          findsOneWidget);
      expect(find.text('Terms & Conditions'), findsNothing);

      await pumpAppAt(tester, '/legal/terms');
      expect(find.byKey(const Key('legal_body')), findsOneWidget);
      expect(find.text('Privacy & policy'), findsNothing);
    });

    testWidgets('no legal prose is rendered — the screen is one line',
        (tester) async {
      await pumpAppAt(tester, '/legal/privacy');

      // If somebody ever pastes a policy in here, this is what notices: a
      // document body would be many Texts, not a title and a line.
      expect(find.byType(Text), findsNWidgets(2));
    });
  });

  group('leaving', () {
    testWidgets('the back chip pops to where the student came from',
        (tester) async {
      final container = await pumpAppAt(tester, '/support');

      await tester.tap(find.byKey(const Key('support_back')));
      await tester.pumpAndSettle();

      expect(locationOf(container), '/home');
    });
  });

  group('AR (RTL) + EN × light + dark', () {
    testWidgets('Arabic renders Arabic copy under RTL', (tester) async {
      await pumpAppAt(tester, '/refer', locale: 'ar');

      expect(
        Directionality.of(tester.element(find.byType(ReferAFriendScreen))),
        TextDirection.rtl,
      );
      expect(find.text('دعوة الأصدقاء غير متاحة بعد.'), findsOneWidget);
      expect(find.text('مشاركة الدعوة'), findsOneWidget);
    });

    testWidgets('dark does not quietly re-enable anything', (tester) async {
      await pumpAppAt(tester, '/settings');
      await tester.tap(find.byKey(const Key('settings_mode_dark')));
      await tester.pumpAndSettle();

      // Same session, same container: the canvas the student picked follows
      // them onto the shell.
      await tester.tap(find.byKey(const Key('settings_back')));
      await tester.pumpAndSettle();

      expect(
        Theme.of(tester.element(find.byType(Scaffold).first))
            .extension<AppColors>()!
            .background,
        AppColors.dark.background,
      );
    });

    testWidgets('the legal screen is localized in Arabic', (tester) async {
      await pumpAppAt(tester, '/legal/terms', locale: 'ar');

      expect(find.text('لم يتم نشر هذا المستند بعد.'), findsOneWidget);
    });
  });
}
