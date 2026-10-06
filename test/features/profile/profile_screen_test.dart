import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/models/screen_state.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/features/profile/widgets/profile_header_card.dart';
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
  /// SHELL (below). These two do not, because a shell for them would have to
  /// invent the very thing that is missing — a favourites list, a progress
  /// history. The seventh, Subscription, is gone altogether: adr-049 makes the
  /// app purchase-silent, so the row is absent, not disabled (D-007).
  const disabledRows = <String, String>{
    'profile_row_favorites': 'S11 — /me/favorites is draft',
    'profile_row_progress': 'S32 — "your progress" has no endpoint',
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

    testWidgets('points.total is printed, not re-summed from the dual pools '
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
      },
    );

    testWidgets('nine of the frame\'s ten rows render', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      // Seven navigation rows plus the two action rows (Go to Uni, Logout).
      // The frame's tenth row, Subscription, is absent by product rule
      // (adr-049 §3 — purchase-silent; D-007), not by omission.
      expect(find.byType(ProfileMenuRow), findsNWidgets(9));
      for (final label in [
        'Settings',
        'Favorite questions',
        'Your progress',
        'Refer a Friend',
        'Customer Support',
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
      expect(find.byType(ProfileMenuRow), findsNWidgets(9));
      // Still offered the switch: the contract cannot express a track change in
      // either direction, so the row is not branched on `track`.
      expect(find.text('Go to University'), findsOneWidget);
    });
  });

  group('purchase-silent (adr-049 §3)', () {
    testWidgets('the Subscription row is absent, not disabled', (tester) async {
      await pumpProfileScreen(tester, profile: profileRepo());

      // The Profile frame draws a Subscription row. The contract forbids any
      // purchase surface in the app, so the row is gone — not dimmed, not
      // routed to a shell. D-007.
      expect(find.byKey(const Key('profile_row_subscription')), findsNothing);
      expect(find.text('Subscription'), findsNothing);
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

    testWidgets('and are announced as disabled buttons, with a reason', (
      tester,
    ) async {
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

    testWidgets('and every row is a BUTTON to TalkBack, never an image', (
      tester,
    ) async {
      // The chevron is an SvgPicture; its image semantics used to merge into
      // the row, and Android maps a merged image+button node to ImageView —
      // the same defect BUG-013 fixed on the back chip. Fable-eye audit
      // 2026-10-06, FE-02.
      final handle = tester.ensureSemantics();
      await pumpProfileScreen(tester, profile: profileRepo());

      for (final key in [
        'profile_row_settings',
        'profile_row_favorites',
        'profile_row_progress',
        'profile_row_refer',
        'profile_row_support',
      ]) {
        final flags = tester.getSemantics(find.byKey(Key(key))).flagsCollection;
        expect(flags.isButton, isTrue, reason: '$key is a button');
        expect(flags.isImage, isFalse, reason: '$key is not an image');
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

    testWidgets(
      'every disabled row leads nowhere — the location does not move',
      (tester) async {
        final container = await pumpProfileApp(tester, profile: profileRepo());
        await openAccountTab(tester);

        for (final key in disabledRows.keys) {
          // Nothing is expected to receive this tap — that IS the assertion.
          await tapProfileKey(tester, key, warnIfMissed: false);
          expect(locationOf(container), '/account', reason: '$key navigated');
        }
      },
    );

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

    testWidgets('the pencil routes to /profile/edit (Step 2 replaces it)', (
      tester,
    ) async {
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

    testWidgets('confirm calls the existing AuthController logout', (
      tester,
    ) async {
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

    testWidgets('error → localized copy + a Retry that re-calls /me', (
      tester,
    ) async {
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

    testWidgets('offline error → the offline view, not the generic error', (
      tester,
    ) async {
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

    testWidgets('connectivity down with data on screen → pinned banner', (
      tester,
    ) async {
      await pumpProfileScreen(tester, profile: profileRepo(), online: false);

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
          AsyncError<StudentProfile>(
            const OfflineException(),
            StackTrace.empty,
          ),
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
      expect(find.byType(ProfileMenuRow), findsNWidgets(9));
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

    testWidgets('Arabic + dark, and the dialogs are localized too', (
      tester,
    ) async {
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

  group('Wave 19: the frames (166:4416 · 180:4704 · 180:4445)', () {
    /// The frame's 402-wide phone, so the dialog card is the frame's 345.
    Future<ProviderContainer> phone(
      WidgetTester tester, {
      String locale = 'en',
      ThemeData? theme,
      MockProfileRepository? profile,
      MockAuthRepository? auth,
    }) async {
      await tester.binding.setSurfaceSize(const Size(402, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      return pumpProfileScreen(
        tester,
        profile: profile ?? profileRepo(),
        auth: auth,
        locale: locale,
        theme: theme,
      );
    }

    Finder titleBar(String title) => find.ancestor(
      of: find.text(title),
      matching: find.byWidgetPredicate((w) => w is SizedBox && w.height == 35),
    );

    // The dialog card: the first Material under the Dialog.
    Rect card(WidgetTester tester) => tester.getRect(
      find
          .descendant(of: find.byType(Dialog), matching: find.byType(Material))
          .first,
    );

    Color fill(WidgetTester tester, String key) => tester
        .widget<Material>(
          find
              .descendant(
                of: find.byKey(Key(key)),
                matching: find.byType(Material),
              )
              .first,
        )
        .color!;

    CtaTone toneOf(WidgetTester tester, String key) => tester
        .widget<PrimaryCta>(
          find.ancestor(
            of: find.byKey(Key(key)),
            matching: find.byType(PrimaryCta),
          ),
        )
        .tone;

    Finder crossGlyph() => find.descendant(
      of: find.byKey(const Key('profile_dialog_dismiss')),
      matching: find.byType(SvgPicture),
    );

    group('the header (169:4631), not an AppBar', () {
      for (final (name, theme, ink) in [
        ('light', AppTheme.light, const Color(0xFF0E0E0E)),
        ('dark', AppTheme.dark, const Color(0xFFFCFBF9)),
      ]) {
        testWidgets(
          '$name: a 35 dp bar 16 from the top, the card 25 under it',
          (tester) async {
            await phone(tester, theme: theme);

            expect(find.byType(AppBar), findsNothing);
            final bar = tester.getRect(titleBar('Profile'));
            expect(bar.top, 16);
            expect(bar.height, 35);
            expect(
              tester.getRect(find.byType(ProfileHeaderCard)).top - bar.bottom,
              25,
            );
            // The app's header style (h2, textPrimary): #57 / #99.
            expect(tester.widget<Text>(find.text('Profile')).style!.color, ink);
          },
        );
      }

      testWidgets('the title is centred and is a heading to screen readers', (
        tester,
      ) async {
        await phone(tester);

        expect(tester.getCenter(find.text('Profile')).dx, 201);
        expect(
          tester.getSemantics(find.text('Profile')),
          isSemantics(isHeader: true),
        );
      });

      testWidgets('Arabic: the same bar, "الملف الشخصي" centred', (
        tester,
      ) async {
        await phone(tester, locale: 'ar');

        final bar = tester.getRect(titleBar('الملف الشخصي'));
        expect(bar.top, 16);
        expect(tester.getCenter(find.text('الملف الشخصي')).dx, 201);
        expect(
          tester.getRect(find.byType(ProfileHeaderCard)).top - bar.bottom,
          25,
        );
      });

      testWidgets('the skeleton starts 25 under the bar too', (tester) async {
        final repo = MockProfileRepository();
        when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
        when(repo.getMe).thenAnswer((_) => Completer<StudentProfile>().future);
        await phone(tester, profile: repo);

        final scroll = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(
          scroll.padding,
          const EdgeInsetsDirectional.fromSTEB(20, 25, 20, 24),
        );
      });
    });

    group('Logout: the No / Yes pair (180:4757)', () {
      late MockAuthRepository auth;

      setUp(() {
        auth = MockAuthRepository();
        when(auth.logout).thenAnswer((_) async {});
      });

      Future<ProviderContainer> openLogout(
        WidgetTester tester, {
        String locale = 'en',
        ThemeData? theme,
      }) async {
        final container = await phone(
          tester,
          locale: locale,
          theme: theme,
          auth: auth,
        );
        container.read(authControllerProvider.notifier).markAuthenticated();
        await tapProfileKey(tester, 'profile_row_logout');
        return container;
      }

      testWidgets('No, Yes and the ✕', (tester) async {
        await openLogout(tester);
        expect(find.text('No'), findsOneWidget);
        expect(find.text('Yes'), findsOneWidget);
        expect(find.byKey(const Key('profile_dialog_dismiss')), findsOneWidget);
      });

      testWidgets('Arabic copy: "لا" and "نعم"', (tester) async {
        await openLogout(tester, locale: 'ar');
        expect(find.text('لا'), findsOneWidget);
        expect(find.text('نعم'), findsOneWidget);
      });

      testWidgets('No dismisses and does NOT log out', (tester) async {
        final container = await openLogout(tester);

        await tester.tap(find.text('No'));
        await tester.pumpAndSettle();

        verifyNever(auth.logout);
        expect(
          container.read(authControllerProvider),
          isA<AuthAuthenticated>(),
        );
        expect(find.byType(Dialog), findsNothing);
      });

      testWidgets('Yes revokes, then signs out', (tester) async {
        final container = await openLogout(tester);

        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

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

      testWidgets('geometry: 155 x 60 each, 5 apart, 15 in, 15 above the '
          'card\'s bottom; the card is 345', (tester) async {
        await openLogout(tester);

        final c = card(tester);
        final no = tester.getRect(find.byKey(const Key('logout_no')));
        final yes = tester.getRect(find.byKey(const Key('logout_confirm')));
        expect(c.width, 345);
        expect(no.left - c.left, 15);
        expect(no.size, const Size(155, 60));
        expect(yes.left - no.right, 5);
        expect(yes.size, const Size(155, 60));
        expect(c.right - yes.right, 15);
        expect(c.bottom - no.bottom, 15);
      });

      testWidgets('Arabic mirrors the pair: No at the reading start, on the '
          'right (owner ruling, #102)', (tester) async {
        await openLogout(tester, locale: 'ar');

        final c = card(tester);
        final no = tester.getRect(find.byKey(const Key('logout_no')));
        final yes = tester.getRect(find.byKey(const Key('logout_confirm')));
        expect(c.right - no.right, 15);
        expect(no.left - yes.right, 5);
        expect(yes.left - c.left, 15);
      });

      for (final (name, theme, yesFill, hex) in [
        ('light', AppTheme.light, const Color(0xFF384F47), '#384F47'),
        ('dark', AppTheme.dark, const Color(0xFFAE87E7), '#AE87E7'),
      ]) {
        testWidgets('$name: No #EF4444, Yes $hex, both shadow-only', (
          tester,
        ) async {
          await openLogout(tester, theme: theme);

          expect(fill(tester, 'logout_no'), const Color(0xFFEF4444));
          expect(fill(tester, 'logout_confirm'), yesFill);
          // Neither glows in dark (edit2 #12).
          expect(toneOf(tester, 'logout_no'), CtaTone.destructive);
          expect(toneOf(tester, 'logout_confirm'), CtaTone.shadowOnly);
          for (final label in ['No', 'Yes']) {
            expect(
              tester.widget<Text>(find.text(label)).style?.color ??
                  DefaultTextStyle.of(
                    tester.element(find.text(label)),
                  ).style.color,
              const Color(0xFFFCFBF9),
            );
          }
        });
      }
    });

    group('the ✕ (180:4706)', () {
      for (final (name, theme, ink, hex) in [
        ('light', AppTheme.light, const Color(0xFF3F3F3F), '#3F3F3F'),
        ('dark', AppTheme.dark, const Color(0xFFFCFBF9), '#FCFBF9'),
      ]) {
        testWidgets('$name: the frame\'s cross in $hex, 24 from the card\'s '
            'start, a 48 x 48 target', (tester) async {
          await phone(tester, theme: theme);
          await tapProfileKey(tester, 'profile_row_logout');

          final c = card(tester);
          final glyph = tester.getRect(crossGlyph());
          expect(glyph.size, const Size(23, 23));
          expect(glyph.left - c.left, 24);
          expect(
            tester.getSize(find.byKey(const Key('profile_dialog_dismiss'))),
            const Size(48, 48),
          );
          expect(
            tester.widget<SvgPicture>(crossGlyph()).colorFilter,
            ColorFilter.mode(ink, BlendMode.srcIn),
          );
        });
      }

      testWidgets('Arabic: 24 from the card\'s right, and clear of the title '
          '(SF-08)', (tester) async {
        await phone(tester, locale: 'ar');
        await tapProfileKey(tester, 'profile_row_logout');

        final c = card(tester);
        final target = tester.getRect(
          find.byKey(const Key('profile_dialog_dismiss')),
        );
        expect(c.right - tester.getRect(crossGlyph()).right, 24);
        final title = tester.getRect(find.text('تسجيل الخروج').last);
        expect(title.overlaps(target), isFalse);
      });

      testWidgets('a button named "Close", not an image (W11-7)', (
        tester,
      ) async {
        await phone(tester);
        await tapProfileKey(tester, 'profile_row_logout');

        expect(
          tester.widget<SvgPicture>(crossGlyph()).excludeFromSemantics,
          isTrue,
        );
        expect(
          tester
              .widget<IconButton>(
                find.byKey(const Key('profile_dialog_dismiss')),
              )
              .tooltip,
          'Close',
        );
      });
    });

    testWidgets('Go to Uni keeps ONE button, 284 wide and centred (180:4572)', (
      tester,
    ) async {
      await phone(tester);
      await tapProfileKey(tester, 'profile_row_go_to_uni');

      final c = card(tester);
      final confirm = tester.getRect(
        find.byKey(const Key('go_to_uni_confirm')),
      );
      expect(find.byKey(const Key('logout_no')), findsNothing);
      expect(confirm.width, 284);
      expect(confirm.left - c.left, 30.5);
      expect(c.right - confirm.right, 30.5);
      expect(
        tester.widget<SvgPicture>(crossGlyph()).colorFilter,
        const ColorFilter.mode(Color(0xFF3F3F3F), BlendMode.srcIn),
      );
    });
  });
}
