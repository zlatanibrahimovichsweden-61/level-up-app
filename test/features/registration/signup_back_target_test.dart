import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/language_pill.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/features/registration/widgets/registration_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'registration_harness.dart';

/// O-15 on Sign Up_1 and Sign Up_2 (DESIGN_ISSUES #132), and then on the
/// School and University headers ([RegistrationHeader]).
///
/// The header row holds the back chip and the 36.10 language pill. The chip is
/// now a 48 box, flush to the START of it so the extra reaches into the free
/// space before the pill, not past the page gutter; the row is 48 tall, so the
/// page's top inset and the gap under the row each give back half of 48 −
/// 36.10. Everything the frame draws stays put — the numbers below are the
/// pre-O-15 positions — and a tap just past the chip's edge now goes back.
const _args = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600,
  phone: '+2010000000001',
);

Widget _marker(String text) => Scaffold(body: Center(child: Text(text)));

void main() {
  Future<GoRouter> pump(
    WidgetTester tester, {
    required String locale,
    required bool track,
  }) async {
    final container = ProviderContainer(
      overrides: [isOnlineProvider.overrideWith((ref) => Stream.value(true))],
    );
    addTearDown(container.dispose);
    container.read(registrationControllerProvider.notifier).start(_args);

    final router = GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(
          path: '/register',
          builder: (_, state) =>
              SignupIdentityScreen(args: state.extra as RegistrationArgs?),
        ),
        GoRoute(
          path: '/register/track',
          builder: (_, _) => const SignupTrackScreen(),
        ),
        GoRoute(path: '/login', builder: (_, _) => _marker('LOGIN')),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (track) {
      router.push('/register/track');
      await tester.pumpAndSettle();
    }
    return router;
  }

  Rect chipRect(WidgetTester tester) => tester.getRect(
    find.descendant(
      of: find.byType(CircleBackButton),
      matching: find.byType(ElevatedSurface),
    ),
  );

  for (final track in [false, true]) {
    final screen = track ? 'Sign Up_2 (track)' : 'Sign Up_1 (identity)';
    // The frame's side inset: 24 on Sign Up_1, 20 on Sign Up_2.
    final gutter = track ? 20.0 : 24.0;

    for (final locale in ['en', 'ar']) {
      testWidgets('$screen · $locale: the chip, the pill and the title stay '
          'where they were', (tester) async {
        await pump(tester, locale: locale, track: track);
        final width =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final ltr = locale == 'en';
        final l10n = lookupAppLocalizations(Locale(locale));

        final chip = chipRect(tester);
        final pill = tester.getRect(find.byType(LanguagePill));
        expect(chip.size, const Size(35, 35));
        expect(ltr ? chip.left : chip.right, ltr ? gutter : width - gutter);
        // Centred on the pill's row, as before: 8 down, a 36.10 row.
        expect(
          chip.center.dy,
          moreOrLessEquals(8 + LanguagePill.height / 2, epsilon: 0.01),
        );
        expect(pill.top, moreOrLessEquals(8, epsilon: 0.01));
        expect(ltr ? pill.right : pill.left, ltr ? width - gutter : gutter);

        final title = tester.getRect(
          find.text(track ? l10n.chooseTrackTitle : l10n.createAccountTitle),
        );
        expect(
          title.top,
          moreOrLessEquals(8 + LanguagePill.height + 8, epsilon: 0.01),
        );
      });

      testWidgets('$screen · $locale: the target is 48, and a tap 10 dp past '
          'the chip\'s inner edge goes back', (tester) async {
        final router = await pump(tester, locale: locale, track: track);
        final ltr = locale == 'en';

        final target = tester.getRect(find.byType(CircleBackButton));
        final chip = chipRect(tester);
        expect(target.size, const Size(48, 48));
        expect(ltr ? target.left : target.right, ltr ? chip.left : chip.right);

        await tester.tapAt(
          Offset(ltr ? chip.right + 10 : chip.left - 10, chip.center.dy),
        );
        await tester.pumpAndSettle();
        expect(
          router.state.uri.path,
          track ? '/register' : '/login',
          reason: track ? 'Sign Up_2 pops' : 'Sign Up_1 abandons to /login',
        );
      });
    }
  }

  // ---------------------------------------------------------------------------
  // School (337:5269) and University (337:10373): the same header,
  // [RegistrationHeader], on a page that has something to pop back to.
  // ---------------------------------------------------------------------------

  const detailPath = {
    RegTrack.school: '/register/school',
    RegTrack.university: '/register/university',
  };

  Future<GoRouter> pumpDetail(
    WidgetTester tester, {
    required RegTrack track,
    required String locale,
  }) async {
    final reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
    final container = ProviderContainer(
      overrides: [
        referenceRepositoryProvider.overrideWithValue(reference),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
      ..setTrack(track);

    final router = GoRouter(
      initialLocation: '/register/track',
      routes: [
        GoRoute(path: '/register/track', builder: (_, _) => marker('TRACK')),
        GoRoute(
          path: '/register/school',
          builder: (_, _) => const SchoolDetailScreen(),
        ),
        GoRoute(
          path: '/register/university',
          builder: (_, _) => const UniversityDetailScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    router.push(detailPath[track]!);
    await tester.pumpAndSettle();
    expect(router.state.uri.path, detailPath[track]);
    return router;
  }

  for (final track in [RegTrack.school, RegTrack.university]) {
    final screen = track == RegTrack.school ? 'School' : 'University';

    for (final locale in ['en', 'ar']) {
      testWidgets('$screen · $locale: the chip, the pill and the title stay '
          'where the frame draws them', (tester) async {
        await pumpDetail(tester, track: track, locale: locale);
        final width =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final ltr = locale == 'en';
        final l10n = lookupAppLocalizations(Locale(locale));

        final chip = chipRect(tester);
        final pill = tester.getRect(find.byType(LanguagePill));
        expect(chip.size, const Size(35, 35));
        expect(ltr ? chip.left : chip.right, ltr ? 24 : width - 24);
        // Centred on the pill's 36.10 row, 8 down: the pre-O-15 positions.
        expect(
          chip.center.dy,
          moreOrLessEquals(8 + LanguagePill.height / 2, epsilon: 0.01),
        );
        expect(pill.top, moreOrLessEquals(8, epsilon: 0.01));
        expect(ltr ? pill.right : pill.left, ltr ? width - 24 : 24);

        // Frame: header row bottom → title, 25.
        final title = tester.getRect(
          find.text(
            track == RegTrack.school
                ? l10n.schoolRegistrationTitle
                : l10n.universityRegistrationTitle,
          ),
        );
        expect(
          title.top,
          moreOrLessEquals(8 + LanguagePill.height + 25, epsilon: 0.01),
        );
        expect(
          title.top - pill.bottom,
          moreOrLessEquals(25, epsilon: 0.01),
          reason: 'the frame\'s 25 is measured from the 36.10 row',
        );
      });

      testWidgets('$screen · $locale: the target is 48, and a tap 10 dp past '
          'the chip\'s inner edge goes back', (tester) async {
        final semantics = tester.ensureSemantics();
        final router = await pumpDetail(tester, track: track, locale: locale);
        final ltr = locale == 'en';

        final target = tester.getRect(find.byType(CircleBackButton));
        final chip = chipRect(tester);
        expect(target.size, const Size(48, 48));
        expect(ltr ? target.left : target.right, ltr ? chip.left : chip.right);
        // The header itself is 48 tall: a render box refuses a pointer
        // outside its own size, so the target is only 48 if the bar is.
        expect(tester.getSize(find.byType(RegistrationHeader)).height, 48);
        expect(
          tester.getSemantics(find.byType(CircleBackButton)).rect.size,
          const Size(48, 48),
        );

        // Past the box (13 dp past the chip): nothing goes back.
        await tester.tapAt(
          Offset(ltr ? chip.right + 20 : chip.left - 20, chip.center.dy),
        );
        await tester.pumpAndSettle();
        expect(router.state.uri.path, detailPath[track]);

        // Inside the box, outside the drawn chip: back.
        await tester.tapAt(
          Offset(ltr ? chip.right + 10 : chip.left - 10, chip.center.dy),
        );
        await tester.pumpAndSettle();
        expect(router.state.uri.path, '/register/track');
        semantics.dispose();
      });

      testWidgets('$screen · $locale: a tap 5 dp below the chip goes back, '
          'where the 36.10 row used to end', (tester) async {
        final router = await pumpDetail(tester, track: track, locale: locale);

        final chip = chipRect(tester);
        // The old row ended 0.55 dp under the chip. 5 dp under it is the new
        // box and nothing the frame draws.
        await tester.tapAt(Offset(chip.center.dx, chip.bottom + 5));
        await tester.pumpAndSettle();
        expect(router.state.uri.path, '/register/track');
      });
    }
  }
}
