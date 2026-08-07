import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/settings/screens/settings_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';
import 'settings_harness.dart';

/// Settings · Figma `176:1840`.
///
/// Three claims this file exists to hold down:
///
/// 1. **The two privacy toggles are independent.** The frame draws one switch;
///    the contract has two booleans with different adr-023 defaults. Flipping
///    one must send one key — never both — or the app has silently chosen a
///    privacy policy on a minor's behalf.
/// 2. **Languages and Mode drive the REAL app**, not a local copy of the state.
///    Both assertions read the value off the root widget and the palette off
///    the rendered tree.
/// 3. **The four notification toggles are structurally dead**, not merely
///    callback-free.
void main() {
  setUpAll(() => registerFallbackValue(const ProfileUpdate()));

  /// The disabled toggles, by `Key`, with the entry that tracks them.
  const notificationRows = <String, String>{
    'settings_notif_announcements': 'S28 — nothing persists a preference',
    'settings_notif_promotions': 'S28',
    'settings_notif_support': 'S28',
    'settings_notif_system': 'S28',
  };

  Finder atSettings() => find.byType(SettingsScreen);

  group('the screen replaces the placeholder', () {
    testWidgets('/settings renders the real screen', (tester) async {
      await pumpAppAt(tester, '/settings');

      expect(atSettings(), findsOneWidget);
      expect(find.text('Settings — not built yet'), findsNothing);
      // The four blocks the frame draws.
      expect(find.text('Languages'), findsOneWidget);
      expect(find.text('Mode'), findsOneWidget);
      expect(find.text('Rank'), findsOneWidget);
      expect(find.text('Notification Preferences'), findsOneWidget);
    });

    testWidgets('adds no request of its own — /me is still fetched once',
        (tester) async {
      final repo = settingsRepo();
      await pumpAppAt(tester, '/settings', profile: repo);

      // Home fetched it; Settings reads the same notifier.
      verify(repo.getMe).called(1);
    });
  });

  group('Rank — two independent booleans (S27)', () {
    testWidgets('the frame\'s ONE switch is drawn as two, from /me',
        (tester) async {
      await pumpAppAt(tester, '/settings');

      // The fixture is the adr-023 default pair: listed, score shown.
      expect(find.byKey(const Key('settings_leaderboard_visible')),
          findsOneWidget);
      expect(find.byKey(const Key('settings_score_hidden')), findsOneWidget);

      final switches = tester.widgetList<Switch>(
        find.descendant(
          of: find.byKey(const Key('settings_leaderboard_visible')),
          matching: find.byType(Switch),
        ),
      );
      expect(switches.single.value, isTrue, reason: 'leaderboardVisible: true');
    });

    testWidgets('flipping leaderboardVisible sends ONLY leaderboardVisible',
        (tester) async {
      final repo = settingsRepo();
      await pumpAppAt(tester, '/settings', profile: repo);

      await tester.tap(find.byKey(const Key('settings_leaderboard_visible')));
      await tester.pumpAndSettle();

      final body = sentUpdate(repo).toJson();
      expect(body, <String, dynamic>{'leaderboardVisible': false});
      expect(
        body.containsKey('scoreHidden'),
        isFalse,
        reason: 'the other toggle must not ride along',
      );
    });

    testWidgets('flipping scoreHidden sends ONLY scoreHidden', (tester) async {
      final repo = settingsRepo();
      await pumpAppAt(tester, '/settings', profile: repo);

      await tester.tap(find.byKey(const Key('settings_score_hidden')));
      await tester.pumpAndSettle();

      final body = sentUpdate(repo).toJson();
      expect(body, <String, dynamic>{'scoreHidden': true});
      expect(
        body.containsKey('leaderboardVisible'),
        isFalse,
        reason: 'the other toggle must not ride along',
      );
    });

    testWidgets('neither toggle carries name, email or avatarId', (tester) async {
      final repo = settingsRepo();
      await pumpAppAt(tester, '/settings', profile: repo);

      await tester.tap(find.byKey(const Key('settings_score_hidden')));
      await tester.pumpAndSettle();

      final body = sentUpdate(repo).toJson();
      for (final key in ['name', 'email', 'avatarId']) {
        expect(
          body.containsKey(key),
          isFalse,
          reason: 'a privacy toggle must not touch $key',
        );
      }
    });

    testWidgets('a successful save re-reads /me — the server decides the value',
        (tester) async {
      final hidden = StudentProfile.fromJson(<String, dynamic>{
        ...schoolProfileJson(),
        'privacy': <String, dynamic>{
          'leaderboardVisible': false,
          'scoreHidden': false,
        },
      });
      final repo = settingsRepo(updated: hidden);
      await pumpAppAt(tester, '/settings', profile: repo);

      await tester.tap(find.byKey(const Key('settings_leaderboard_visible')));
      await tester.pumpAndSettle();

      // Nothing optimistic: the switch moved because `/me` was invalidated and
      // came back saying so.
      verify(repo.getMe).called(2);
    });

    testWidgets('a failed save says so and does not move the switch',
        (tester) async {
      final repo = settingsRepo(failure: const NetworkException());
      await pumpAppAt(tester, '/settings', profile: repo);

      await tester.tap(find.byKey(const Key('settings_leaderboard_visible')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_rank_error')), findsOneWidget);
      final control = tester.widget<Switch>(
        find.descendant(
          of: find.byKey(const Key('settings_leaderboard_visible')),
          matching: find.byType(Switch),
        ),
      );
      expect(control.value, isTrue, reason: 'still what /me last said');
    });

    testWidgets('when /me has never loaded, Rank degrades and the rest works',
        (tester) async {
      final repo = settingsRepo();
      when(repo.getMe).thenThrow(const NetworkException());
      await pumpAppAt(tester, '/settings', profile: repo);

      expect(find.byKey(const Key('settings_rank_unavailable')), findsOneWidget);
      // The two client-side sections are untouched by a failing request.
      expect(find.byKey(const Key('settings_language_ar')), findsOneWidget);
      expect(find.byKey(const Key('settings_mode_dark')), findsOneWidget);
    });
  });

  group('Mode — two canvases, not the frame\'s three (S26)', () {
    testWidgets('exactly two options', (tester) async {
      await pumpAppAt(tester, '/settings');

      expect(find.byKey(const Key('settings_mode_light')), findsOneWidget);
      expect(find.byKey(const Key('settings_mode_dark')), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('picking Dark changes the app\'s canvas, not just a flag',
        (tester) async {
      final container = await pumpAppAt(tester, '/settings');

      expect(paletteAt(tester, atSettings()).background,
          AppColors.light.background);

      await tester.tap(find.byKey(const Key('settings_mode_dark')));
      await tester.pumpAndSettle();

      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(
        paletteAt(tester, atSettings()).background,
        AppColors.dark.background,
        reason: 'the rendered tree must actually be on the dark palette',
      );
    });

    testWidgets('picking Light again comes back', (tester) async {
      await pumpAppAt(tester, '/settings');

      await tester.tap(find.byKey(const Key('settings_mode_dark')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('settings_mode_light')));
      await tester.pumpAndSettle();

      expect(paletteAt(tester, atSettings()).background,
          AppColors.light.background);
    });
  });

  group('Languages — the existing locale switch', () {
    testWidgets('picking Arabic flips the whole app to RTL', (tester) async {
      final container = await pumpAppAt(tester, '/settings');

      expect(Directionality.of(tester.element(atSettings())),
          TextDirection.ltr);

      await tester.tap(find.byKey(const Key('settings_language_ar')));
      await tester.pumpAndSettle();

      expect(container.read(localeProvider), const Locale('ar'));
      expect(
        Directionality.of(tester.element(atSettings())),
        TextDirection.rtl,
      );
      expect(find.text('الترتيب'), findsOneWidget);
    });

    testWidgets('both names are written in their own language, in both locales',
        (tester) async {
      await pumpAppAt(tester, '/settings');
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      await tester.tap(find.byKey(const Key('settings_language_ar')));
      await tester.pumpAndSettle();

      // The point of the rule: a student stranded in the wrong script can still
      // find the row that gets them out.
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('tapping the language already in use is a no-op',
        (tester) async {
      final container = await pumpAppAt(tester, '/settings');

      await tester.tap(find.byKey(const Key('settings_language_en')));
      await tester.pumpAndSettle();

      expect(container.read(localeProvider), const Locale('en'),
          reason: 'select(), not toggle() — it must not flip away');
    });
  });

  group('Notification Preferences — four dead toggles (S28)', () {
    testWidgets('all four render', (tester) async {
      await pumpAppAt(tester, '/settings');

      expect(find.text('Announcements'), findsOneWidget);
      expect(find.text('Promotions'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    for (final entry in notificationRows.entries) {
      testWidgets('${entry.key} is structurally non-interactive',
          (tester) async {
        await pumpAppAt(tester, '/settings');
        expectDeadControl(tester, entry.key);
      }, );
    }

    testWidgets('tapping one changes nothing and sends nothing',
        (tester) async {
      final repo = settingsRepo();
      await pumpAppAt(tester, '/settings', profile: repo);

      for (final key in notificationRows.keys) {
        await tester.tap(find.byKey(Key(key)), warnIfMissed: false);
      }
      await tester.pumpAndSettle();

      verifyNever(() => repo.updateMe(any()));
      for (final key in notificationRows.keys) {
        final control = tester.widget<Switch>(
          find.descendant(of: find.byKey(Key(key)), matching: find.byType(Switch)),
        );
        expect(control.value, isFalse, reason: '$key must not have moved');
        expect(control.onChanged, isNull);
      }
    });

    testWidgets('each announces itself disabled, with a reason', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAppAt(tester, '/settings');

      for (final key in notificationRows.keys) {
        expect(
          tester.getSemantics(find.byKey(Key(key))),
          isSemantics(
            hasEnabledState: true,
            isEnabled: false,
            hint: 'Notification settings aren\'t available yet.',
          ),
          reason: '$key must say why it cannot be used',
        );
      }
      handle.dispose();
    });
  });

  group('AR (RTL) + EN × light + dark', () {
    testWidgets('Arabic renders the Arabic section titles under RTL',
        (tester) async {
      await pumpAppAt(tester, '/settings', locale: 'ar');

      expect(Directionality.of(tester.element(atSettings())),
          TextDirection.rtl);
      expect(find.text('اللغة'), findsOneWidget);
      expect(find.text('المظهر'), findsOneWidget);
      expect(find.text('الترتيب'), findsOneWidget);
      expect(find.text('تفضيلات الإشعارات'), findsOneWidget);
    });

    testWidgets('Arabic + dark, and the disabled reason is localized too',
        (tester) async {
      await pumpAppAt(tester, '/settings', locale: 'ar');

      await tester.tap(find.byKey(const Key('settings_mode_dark')));
      await tester.pumpAndSettle();

      expect(paletteAt(tester, atSettings()).background,
          AppColors.dark.background);
      expect(find.text('إعدادات الإشعارات غير متاحة بعد.'), findsOneWidget);
      // Dark must not quietly re-enable anything.
      expectDeadControl(tester, 'settings_notif_system');
    });

    testWidgets('offline pins the banner and Rank still reads from cache',
        (tester) async {
      await pumpAppAt(tester, '/settings', online: false);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.byKey(const Key('settings_leaderboard_visible')),
          findsOneWidget);
    });
  });
}
