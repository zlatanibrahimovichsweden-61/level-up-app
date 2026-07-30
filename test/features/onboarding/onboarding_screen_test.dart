import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/language_pill.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// Onboarding · Figma dark `337:15146` / light sheet `459:43873`.
///
/// **Reduced state matrix.** The screen makes no network call and holds no async
/// state, so there is no loading / empty / error / offline to cover. What is left
/// is light × dark × AR × EN, plus the two things that are easy to get wrong
/// here: the sheet must be anchored by content (not the frame's 529), and the
/// accented word must be translator-controlled rather than a fixed span index.
void main() {
  /// The screen under a real router, so the two buttons actually navigate.
  Future<String> pumpOnboarding(
    WidgetTester tester, {
    String locale = 'en',
    ThemeData? theme,
    Size? size,
  }) async {
    if (size != null) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
    }

    var location = '/';
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const OnboardingScreen()),
        GoRoute(
          path: '/login',
          builder: (_, _) {
            location = '/login';
            return const Scaffold(body: Text('login'));
          },
        ),
        GoRoute(
          path: '/register',
          builder: (_, _) {
            location = '/register';
            return const Scaffold(body: Text('register'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: theme ?? AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return location;
  }

  group('content', () {
    testWidgets('renders the title, tagline, subtitle and both buttons',
        (tester) async {
      await pumpOnboarding(tester);

      expect(find.text('Level Up'), findsOneWidget);
      expect(find.text('Your'), findsNothing); // it is a span, not a Text
      expect(
        find.text('Study. Compete. Achieve.\nAll in one place.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Get Started'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Log In'), findsOneWidget);
    });

    testWidgets('ships "Achieve", not the design\'s "Achive"', (tester) async {
      // The typo is in BOTH frames (DESIGN_ISSUES #26). A design typo must not
      // become user-facing copy.
      await pumpOnboarding(tester);

      expect(find.textContaining('Achieve'), findsOneWidget);
      expect(find.textContaining('Achive'), findsNothing);
    });

    testWidgets('the illustration renders full-bleed from the top',
        (tester) async {
      await pumpOnboarding(tester);

      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svg.fit, BoxFit.cover);
      expect(svg.alignment, Alignment.topCenter);
    });

    testWidgets('carries a language pill the frame does not draw',
        (tester) async {
      // Deliberate addition: Login and OTP-success both have one, so without it
      // a student landing here in the wrong language is stuck (DESIGN_ISSUES
      // #27).
      await pumpOnboarding(tester);

      expect(find.byType(LanguagePill), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget); // the OTHER language
    });
  });

  group('the two-colour "Your Learning Journey" run', () {
    /// Pulls the rich-text spans in render order with their colours.
    List<(String, Color?)> spansOf(WidgetTester tester) {
      final text = tester.widget<Text>(
        find.byWidgetPredicate(
          (w) => w is Text && w.textSpan != null,
        ),
      );
      final out = <(String, Color?)>[];
      text.textSpan!.visitChildren((span) {
        if (span is TextSpan && span.text != null) {
          out.add((span.text!, span.style?.color));
        }
        return true;
      });
      return out;
    }

    testWidgets('accents the word the .arb marks, in the light sage',
        (tester) async {
      await pumpOnboarding(tester);

      final spans = spansOf(tester);
      expect(spans.map((s) => s.$1).join(), 'Your Learning Journey');
      expect(spans.first.$2, AppColors.light.accentSoft);
      expect(spans.last.$2, AppColors.light.textPrimary);
    });

    testWidgets('the accent follows the TRANSLATION, not a fixed span index',
        (tester) async {
      // Arabic keys the accent off its own .arb entry, so the accented word is
      // whatever the translator put there — the widget never splits a sentence
      // on a space or hardcodes [accent, plain] against English word order.
      await pumpOnboarding(tester, locale: 'ar');

      final spans = spansOf(tester);
      expect(spans.first.$1, 'رحلتك');
      expect(spans.first.$2, AppColors.light.accentSoft);
      expect(spans.last.$1, 'التعليمية');
    });

    testWidgets('dark swaps the accent to purple via the token', (tester) async {
      await pumpOnboarding(tester, theme: AppTheme.dark);

      expect(spansOf(tester).first.$2, AppColors.dark.accentSoft);
    });
  });

  group('navigation', () {
    testWidgets('Get Started → /register', (tester) async {
      await pumpOnboarding(tester);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(find.text('register'), findsOneWidget);
    });

    testWidgets('Log In → /login', (tester) async {
      await pumpOnboarding(tester);

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('login'), findsOneWidget);
    });
  });

  group('the sheet is anchored by content, never a hardcoded 529', () {
    /// Sheet top as a fraction of screen height.
    double sheetTopFractionOf(WidgetTester tester) {
      final sheet = tester.getRect(find.byType(FilledButton));
      final screen = tester.getRect(find.byType(OnboardingScreen));
      // Use the sheet's own painted box rather than the button.
      final box = tester.getRect(
        find.ancestor(
          of: find.byType(FilledButton),
          matching: find.byType(SafeArea),
        ).last,
      );
      expect(sheet.top, greaterThan(0));
      return box.top / screen.height;
    }

    for (final (label, size) in <(String, Size)>[
      ('small phone', Size(360, 640)),
      ('reference', Size(402, 878)),
      ('tablet', Size(834, 1194)),
    ]) {
      testWidgets('$label: sheet sits at the bottom, no overflow',
          (tester) async {
        await pumpOnboarding(tester, size: size);

        final screen = tester.getRect(find.byType(OnboardingScreen));
        final button = tester.getRect(find.byType(OutlinedButton));

        // Bottom-anchored: the last control is near the bottom edge, and
        // nothing is pushed off-screen.
        expect(button.bottom, lessThanOrEqualTo(screen.height));
        expect(button.bottom, greaterThan(screen.height - 60));
        expect(button.left, greaterThanOrEqualTo(0));
        expect(button.right, lessThanOrEqualTo(screen.width));

        // A RenderFlex overflow would have been thrown by now.
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('at the reference size the sheet lands near the frame\'s 60%',
        (tester) async {
      // Figma puts the sheet top at 529/878 = 0.602. Content-sizing must land
      // in that neighbourhood WITHOUT the number appearing in the source.
      await pumpOnboarding(tester, size: const Size(402, 878));

      expect(sheetTopFractionOf(tester), closeTo(0.602, 0.08));
    });
  });

  group('themes and directions', () {
    for (final locale in ['en', 'ar']) {
      for (final (themeName, theme) in <(String, ThemeData)>[
        ('light', AppTheme.light),
        ('dark', AppTheme.dark),
      ]) {
        testWidgets('renders in $themeName × $locale', (tester) async {
          await pumpOnboarding(tester, locale: locale, theme: theme);

          expect(find.byType(OnboardingScreen), findsOneWidget);
          expect(find.byType(FilledButton), findsOneWidget);
          expect(find.byType(OutlinedButton), findsOneWidget);
          expect(tester.takeException(), isNull);

          expect(
            Directionality.of(tester.element(find.byType(OnboardingScreen))),
            locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          );
        });
      }
    }

    testWidgets('the language pill mirrors to the start edge in Arabic',
        (tester) async {
      await pumpOnboarding(tester, size: const Size(402, 878));
      final ltr = tester.getRect(find.byType(LanguagePill));

      await pumpOnboarding(
        tester,
        locale: 'ar',
        size: const Size(402, 878),
      );
      final rtl = tester.getRect(find.byType(LanguagePill));

      // AlignmentDirectional.topEnd: right in LTR, left in RTL.
      expect(ltr.right, greaterThan(402 / 2));
      expect(rtl.left, lessThan(402 / 2));
    });
  });
}
