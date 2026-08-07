import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/models/screen_state.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/features/profile/widgets/profile_menu_row.dart';
import 'package:level_up_app/features/profile/widgets/profile_stat_card.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';
import 'profile_harness.dart';

/// Profile · Figma `166:4416`.
///
/// Two things this file exists to pin down, beyond the usual state matrix:
///
/// 1. **Points is the server's number.** Nothing on this screen adds, sums or
///    approximates a displayed figure, and the two cards the frame draws that
///    the contract cannot fill are ABSENT rather than guessed.
/// 2. **Disabled is disabled.** Every dead row is asserted twice — present, and
///    genuinely non-interactive — because a row that looks live and swallows
///    the tap is the failure mode being prevented.
void main() {
  /// Rows with nowhere to go AT ALL, by `Key`, with the `seif_fight.md` entry
  /// that tracks each.
  ///
  /// Shorter than it was in Step 1: four of the original seven now open a
  /// SHELL (below). These three do not, because a shell for them would have to
  /// invent the very thing that is missing — a favourites list, a progress
  /// history, a checkout session.
  const disabledRows = <String, String>{
    'profile_row_favorites': 'S11 — /me/favorites is draft',
    'profile_row_progress': 'S32 — "your progress" has no endpoint',
    'profile_row_subscription': 'S8 — /checkout/sessions is draft',
  };

  /// Rows that navigate to a disabled SHELL screen (Step 3), by `Key` → route.
  ///
  /// Live rows leading to honest dead ends. The gap each one represents is
  /// unchanged — the `TODO(contract)` markers stay — but a student who taps
  /// learns the feature exists and is not open yet, which a dead row cannot
  /// tell them.
  const shellRows = <String, String>{
    'profile_row_refer': '/refer',
    'profile_row_support': '/support',
    'profile_row_privacy': '/legal/privacy',
    'profile_row_terms': '/legal/terms',
  };

  group('loaded', () {
    testWidgets('renders the header from GET /me', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Ahmed Mohamed'), findsOneWidget);
      // Server-authoritative integer, printed — never inferred from points.
      expect(find.text('Level 8'), findsOneWidget);
    });

    testWidgets('Points renders points.total VERBATIM', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      expect(find.byKey(const Key('profile_points_card')), findsOneWidget);
      expect(find.text('Points'), findsOneWidget);
      expect(find.text('2,450'), findsOneWidget);
    });

    testWidgets(
        'points.total is printed, not re-summed from the dual pools '
        '(adr-003)', (tester) async {
      // The pools deliberately do NOT add up to `total` here. A screen that
      // computed `school + university` would render 1,500; the contract says
      // the server's `total` is authoritative, so 9,999 is what must appear.
      final drifted = StudentProfile.fromJson(<String, dynamic>{
        ...schoolProfileJson(),
        'points': <String, dynamic>{
          'school': 1000,
          'university': 500,
          'total': 9999,
        },
      });
      await pumpProfileScreen(tester, profile: profileRepo(me: drifted));

      expect(find.text('9,999'), findsOneWidget);
      expect(find.text('1,500'), findsNothing, reason: 'no client-side sum');
    });

    testWidgets(
        'Solved Questions and Rank are OMITTED — the contract has neither',
        (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      // Conflict 2 (S24): no answered/solved counter exists in StudentProfile,
      // and SubjectTree's per-node counts are not summable into a lifetime
      // figure. Conflict 3 (S25): no rank tier string exists either.
      expect(find.text('Solved Questions'), findsNothing);
      expect(find.text('Rank'), findsNothing);
      // Not rendered as an em-dash placeholder either — that invites a guess.
      expect(find.text('—'), findsNothing);
      expect(find.text('300'), findsNothing, reason: 'the frame mock value');
      expect(find.text('HERO'), findsNothing, reason: 'the frame mock value');
      // Exactly one stat card survives.
      expect(find.byType(ProfileStatCard), findsOneWidget);
    });

    testWidgets('all ten of the frame\'s rows render', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      // Eight navigation rows plus the two action rows (Go to Uni, Logout).
      expect(find.byType(ProfileMenuRow), findsNWidgets(10));
      for (final label in [
        'Settings',
        'Favorite questions',
        'Your progress',
        'Refer a Friend',
        'Customer Support',
        'Subscription',
        'Privacy & policy',
        'Terms & Conditions',
        'Go to University',
        'Logout',
      ]) {
        expect(find.text(label), findsOneWidget, reason: '$label row missing');
      }
    });

    testWidgets('the university track gets the identical hub', (tester) async {
      // One Account feature for both tracks — the University Student Flow
      // mirrors this cluster, exactly as it did for Home and the quiz.
      await pumpProfileScreen(
        tester,
        profile: profileRepo(me: universityProfile()),
      );

      expect(find.text('Mona Adel'), findsOneWidget);
      expect(find.text('2,450'), findsOneWidget);
      expect(find.byType(ProfileMenuRow), findsNWidgets(10));
      // Still offered the switch: the contract cannot express a track change in
      // either direction, so the row is not branched on `track`.
      expect(find.text('Go to University'), findsOneWidget);
    });
  });

  group('disabled rows are present AND non-interactive', () {
    for (final entry in disabledRows.entries) {
      testWidgets('${entry.key} renders but has no tap target', (tester) async {
        await pumpProfileScreen(tester, profile: profileRepo());

        final row = find.byKey(Key(entry.key));
        expect(row, findsOneWidget, reason: entry.value);

        // Half one: no InkWell ANYWHERE under it. A disabled row is not a live
        // tap target holding a null callback — there is nothing to tap.
        expect(
          find.descendant(of: row, matching: find.byType(InkWell)),
          findsNothing,
          reason: '${entry.key} must not be tappable',
        );

        // Half two: pointer events are refused outright, and it is dimmed.
        final ignore = tester.widget<IgnorePointer>(
          find.descendant(of: row, matching: find.byType(IgnorePointer)),
        );
        expect(ignore.ignoring, isTrue);

        final opacity = tester.widget<Opacity>(
          find.descendant(of: row, matching: find.byType(Opacity)),
        );
        expect(opacity.opacity, kProfileDisabledOpacity);
      });
    }

    testWidgets('and are announced as disabled buttons, with a reason',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpProfileScreen(tester, profile: profileRepo());

      for (final key in disabledRows.keys) {
        expect(
          tester.getSemantics(find.byKey(Key(key))),
          isSemantics(
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
            hint: 'Not available yet',
          ),
          reason: '$key must announce itself disabled, and say why',
        );
      }
      handle.dispose();
    });

    testWidgets('every live row DOES have a tap target', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      final live = [
        'profile_row_settings',
        'profile_row_logout',
        ...shellRows.keys,
      ];
      for (final key in live) {
        expect(
          find.descendant(
            of: find.byKey(Key(key)),
            matching: find.byType(InkWell),
          ),
          findsOneWidget,
          reason: '$key is live',
        );
      }
    });
  });

  group('navigation, through the real router', () {
    testWidgets('the Account tab IS the Profile hub', (tester) async {
      final container = await pumpProfileApp(tester, profile: profileRepo());
      await openAccountTab(tester);

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(locationOf(container), '/account');
    });

    testWidgets('Settings is the one live menu row', (tester) async {
      final container = await pumpProfileApp(tester, profile: profileRepo());
      await openAccountTab(tester);

      await tapProfileKey(tester, 'profile_row_settings');

      expect(locationOf(container), '/settings');
    });

    testWidgets('every disabled row leads nowhere — the location does not move',
        (tester) async {
      final container = await pumpProfileApp(tester, profile: profileRepo());
      await openAccountTab(tester);

      for (final key in disabledRows.keys) {
        // Nothing is expected to receive this tap — that IS the assertion.
        await tapProfileKey(tester, key, warnIfMissed: false);
        expect(locationOf(container), '/account', reason: '$key navigated');
      }
    });

    testWidgets('each shell row lands on its own screen', (tester) async {
      for (final entry in shellRows.entries) {
        final container = await pumpProfileApp(tester, profile: profileRepo());
        await openAccountTab(tester);

        await tapProfileKey(tester, entry.key);

        expect(
          locationOf(container),
          entry.value,
          reason: '${entry.key} must open its shell',
        );
      }
    });

    testWidgets('the pencil routes to /profile/edit (Step 2 replaces it)',
        (tester) async {
      final container = await pumpProfileApp(tester, profile: profileRepo());
      await openAccountTab(tester);

      await tapProfileKey(tester, 'profile_edit_button');

      expect(locationOf(container), '/profile/edit');
      expect(find.byType(EditProfileScreen), findsOneWidget);
    });

    testWidgets('/me is fetched ONCE across Home → Account', (tester) async {
      final repo = profileRepo();
      await pumpProfileApp(tester, profile: repo);
      await openAccountTab(tester);

      expect(find.text('Ahmed Mohamed'), findsOneWidget);
      // The whole reason meNotifier is non-autoDispose: the Account tab adds no
      // request of its own.
      verify(repo.getMe).called(1);
    });
  });

  group('Logout dialog (the one thing that fully works)', () {
    late MockAuthRepository auth;

    setUp(() {
      auth = MockAuthRepository();
      when(auth.logout).thenAnswer((_) async {});
    });

    testWidgets('confirm calls the existing AuthController logout',
        (tester) async {
      final container = await pumpProfileScreen(
        tester,
        profile: profileRepo(),
        auth: auth,
      );
      container.read(authControllerProvider.notifier).markAuthenticated();

      await tapProfileKey(tester, 'profile_row_logout');

      expect(find.text('Are you sure you want to log out?'), findsOneWidget);

      await tapProfileKey(tester, 'logout_confirm');

      // `POST /auth/logout` was consumed on Day 1b and is not reimplemented
      // here — the dialog only decides whether the existing flow runs.
      verify(auth.logout).called(1);
      expect(
        container.read(authControllerProvider),
        isA<AuthUnauthenticated>().having(
          (s) => s.reason,
          'reason',
          LogoutReason.userInitiated,
        ),
      );
    });

    testWidgets('dismiss does NOT log out', (tester) async {
      final container = await pumpProfileScreen(
        tester,
        profile: profileRepo(),
        auth: auth,
      );
      container.read(authControllerProvider.notifier).markAuthenticated();

      await tapProfileKey(tester, 'profile_row_logout');
      await tapProfileKey(tester, 'profile_dialog_dismiss');

      verifyNever(auth.logout);
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
      expect(find.text('Are you sure you want to log out?'), findsNothing);
    });
  });

  group('Go to Uni dialog', () {
    testWidgets('opens, and its Confirm is genuinely disabled', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      await tapProfileKey(tester, 'profile_row_go_to_uni');

      expect(find.text('Go to Uni'), findsOneWidget);
      expect(find.text("You can't go back again."), findsOneWidget);

      final confirm = tester.widget<FilledButton>(
        find.byKey(const Key('go_to_uni_confirm')),
      );
      // Track switching has no endpoint, and adr-003's dual point pools make it
      // a data-model question nobody has answered (S31).
      expect(confirm.onPressed, isNull);
      expect(confirm.enabled, isFalse);
      // And it says why, rather than sitting there dimmed and mute.
      expect(
        find.text("Switching tracks isn't available yet."),
        findsOneWidget,
      );
    });

    testWidgets('tapping the dead Confirm changes nothing', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      await tapProfileKey(tester, 'profile_row_go_to_uni');
      await tapProfileKey(tester, 'go_to_uni_confirm', warnIfMissed: false);

      // Still open — a disabled confirm cannot even resolve the dialog.
      expect(find.text('Go to Uni'), findsOneWidget);
    });

    testWidgets('the ✕ closes it', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      await tapProfileKey(tester, 'profile_row_go_to_uni');
      await tapProfileKey(tester, 'profile_dialog_dismiss');

      expect(find.text('Go to Uni'), findsNothing);
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });

  group('states', () {
    testWidgets('loading → a skeleton, not a bare spinner', (tester) async {
      final repo = MockProfileRepository();
      when(repo.getMe).thenAnswer((_) => Completer<StudentProfile>().future);
      when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

      await pumpProfileScreen(tester, profile: repo);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Ahmed Mohamed'), findsNothing);
      expect(find.byType(ProfileMenuRow), findsNothing);
      // The skeleton blocks stand in for the header, stat card and rows.
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('error → localized copy + a Retry that re-calls /me',
        (tester) async {
      final repo = MockProfileRepository();
      when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
      when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(
          const ApiException(status: 500, code: 'internal_error'),
        ),
      );
      await pumpProfileScreen(tester, profile: repo);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('You are offline'), findsNothing);

      when(repo.getMe).thenAnswer((_) async => schoolProfile());
      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Ahmed Mohamed'), findsOneWidget);
      verify(repo.getMe).called(2);
    });

    testWidgets('offline error → the offline view, not the generic error',
        (tester) async {
      final repo = MockProfileRepository();
      when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
      when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(const OfflineException()),
      );
      await pumpProfileScreen(tester, profile: repo);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('connectivity down with data on screen → pinned banner',
        (tester) async {
      await pumpProfileScreen(
        tester,
        profile: profileRepo(),
        online: false,
      );

      // Both: the banner AND the loaded content.
      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Ahmed Mohamed'), findsOneWidget);
    });

    test('profileScreenState maps /me onto the sealed ScreenState', () {
      // The mapping is exercised through the widget above; asserted directly
      // here so a regression names itself instead of surfacing as a blank page.
      expect(
        profileScreenState(const AsyncLoading<StudentProfile>()),
        isA<ScreenLoading<StudentProfile>>(),
      );
      expect(
        profileScreenState(AsyncData<StudentProfile>(schoolProfile())),
        isA<ScreenLoaded<StudentProfile>>(),
      );
      expect(
        profileScreenState(
          AsyncError<StudentProfile>(const OfflineException(), StackTrace.empty),
        ),
        isA<ScreenOffline<StudentProfile>>(),
      );
      expect(
        profileScreenState(
          AsyncError<StudentProfile>(
            const ApiException(status: 500, code: 'internal_error'),
            StackTrace.empty,
          ),
        ),
        isA<ScreenError<StudentProfile>>().having(
          (e) => e.messageKey,
          'messageKey',
          // A KEY, not user-facing copy — the server's English never shows.
          'genericError',
        ),
      );
    });
  });

  group('AR (RTL) + EN × light + dark', () {
    testWidgets('renders in dark theme', (tester) async {
      await pumpProfileScreen(
        tester,
        profile: profileRepo(),
        theme: AppTheme.dark,
      );

      expect(find.text('2,450'), findsOneWidget);
      expect(find.byType(ProfileMenuRow), findsNWidgets(10));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders Arabic under RTL directionality', (tester) async {
      await pumpProfileScreen(
        tester,
        profile: profileRepo(),
        locale: const Locale('ar').languageCode,
      );

      expect(find.text('الملف الشخصي'), findsOneWidget); // profileTitle
      expect(find.text('الإعدادات'), findsOneWidget); // profileSettings
      expect(find.text('تسجيل الخروج'), findsOneWidget); // profileLogout
      expect(find.text('المستوى 8'), findsOneWidget); // levelProgress
      // The points figure is the SERVER's, formatted by the ARB's
      // `decimalPattern` placeholder. `intl` renders `ar` with Western digits
      // here — app-wide behaviour Home already ships, asserted rather than
      // assumed so a future intl bump that flips it to ٢٬٤٥٠ shows up as a
      // deliberate change instead of a surprise.
      expect(find.text('2,450'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('الإعدادات'))),
        TextDirection.rtl,
      );
    });

    testWidgets('Arabic + dark, and the dialogs are localized too',
        (tester) async {
      await pumpProfileScreen(
        tester,
        profile: profileRepo(),
        locale: 'ar',
        theme: AppTheme.dark,
      );

      await tapProfileKey(tester, 'profile_row_go_to_uni');

      expect(find.text('لا يمكنك الرجوع مرة أخرى.'), findsOneWidget);
      expect(find.text('تغيير المسار غير متاح بعد.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the offline view is localized in Arabic', (tester) async {
      final repo = MockProfileRepository();
      when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
      when(repo.getMe).thenAnswer(
        (_) => Future<StudentProfile>.error(const OfflineException()),
      );
      await pumpProfileScreen(tester, profile: repo, locale: 'ar');

      expect(find.text('أنت غير متصل بالإنترنت'), findsOneWidget);
    });
  });
}
