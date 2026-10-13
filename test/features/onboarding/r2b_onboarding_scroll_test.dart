import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart' show loadAppFonts;

/// The onboarding bottom sheet is sized by its content. At the OS's largest
/// text on the smallest phone (320 x 568) that content is taller than the
/// screen, and "Log In" - the last control - was pushed past the bottom edge,
/// outside the Column's bounds, where a tap does not reach it (E1 journey
/// sweep). The sheet content scrolls now, and a sheet that fits is the sheet it
/// always was.
void main() {
  setUpAll(loadAppFonts);

  Future<GoRouter> pumpOnboarding(
    WidgetTester tester, {
    required Size size,
    String locale = 'en',
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    if (textScale != 1.0) {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const OnboardingScreen()),
        GoRoute(
          path: '/login',
          builder: (_, _) => const Scaffold(body: Text('LOGIN')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
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
    return router;
  }

  Rect sheet(WidgetTester tester) => tester.getRect(
    find
        .ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(ElevatedSurface),
        )
        .first,
  );

  double scrollExtent(WidgetTester tester) => tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position
      .maxScrollExtent;

  // Where the sheet is too tall for the screen: the smallest phone and the
  // short one at the largest text, and a phone on its side.
  const tight = <(String, Size, double)>[
    ('320x568 at 2.0x', Size(320, 568), 2.0),
    ('360x568 at 2.0x', Size(360, 568), 2.0),
    ('landscape 640x360', Size(640, 360), 1.0),
    ('landscape 915x412 at 1.5x', Size(915, 412), 1.5),
  ];
  for (final (tag, size, scale) in tight) {
    for (final locale in ['en', 'ar']) {
      testWidgets('$tag ($locale): no overflow, and both buttons work', (
        tester,
      ) async {
        final l10n = lookupAppLocalizations(Locale(locale));
        final router = await pumpOnboarding(
          tester,
          size: size,
          locale: locale,
          textScale: scale,
        );
        expect(tester.takeException(), isNull, reason: 'layout overflow');

        // Taller than the screen, the sheet is the screen's height at most:
        // it is bottom-anchored and its content is what scrolls.
        expect(sheet(tester).top, greaterThanOrEqualTo(0));
        expect(sheet(tester).bottom, size.height);

        // Log In is the last control: scrolled to and tapped like a student.
        final logIn = find.widgetWithText(OutlinedButton, l10n.logIn);
        await tester.ensureVisible(logIn);
        await tester.pump();
        expect(tester.getRect(logIn).bottom, lessThanOrEqualTo(size.height));
        await tester.tap(logIn);
        await tester.pumpAndSettle();
        expect(router.state.uri.toString(), '/login');
      });
    }
  }

  testWidgets('320x568 at 2.0x (en): the content really is taller than the '
      'sheet and scrolls', (tester) async {
    await pumpOnboarding(tester, size: const Size(320, 568), textScale: 2.0);
    expect(scrollExtent(tester), greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'ar']) {
    for (final size in const [Size(412, 915), Size(360, 800), Size(402, 878)]) {
      testWidgets('a sheet that fits does not scroll and is the content\'s '
          'height ($locale, ${size.width.toInt()}x${size.height.toInt()})', (
        tester,
      ) async {
        await pumpOnboarding(tester, size: size, locale: locale);
        expect(tester.takeException(), isNull);
        expect(scrollExtent(tester), 0);

        // Anchored to the bottom, sized by its content: nothing grows it to
        // the room it is given. The frame's sheet is ~349 dp, content-sized.
        final rect = sheet(tester);
        expect(rect.bottom, size.height);
        expect(rect.height, lessThan(size.height / 2));
        expect(rect.width, size.width);
      });
    }
  }
}
