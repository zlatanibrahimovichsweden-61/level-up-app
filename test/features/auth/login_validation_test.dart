import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/models/phone.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../core/visual_order.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _harness(
  MockAuthRepository repo, {
  Locale locale = const Locale('en'),
  bool offline = false,
  bool dark = false,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      if (offline) isOnlineProvider.overrideWith((ref) => Stream.value(false)),
    ],
    child: MaterialApp(
      locale: locale,
      // Both carry the AppColors ThemeExtension.
      theme: dark ? AppTheme.dark : AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginScreen(),
    ),
  );
}

/// Login inside a real router, so the phone → OTP hand-off can be followed.
Widget _routerHarness(MockAuthRepository repo) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      // Must be explicit: the real connectivity plugin reports `none` under
      // test, and `_submit` refuses to fire a doomed request while offline.
      isOnlineProvider.overrideWith((ref) => Stream.value(true)),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (_, _) => const LoginScreen(),
            routes: [
              GoRoute(
                path: 'otp',
                builder: (_, _) =>
                    const Scaffold(body: Center(child: Text('OTP SCREEN'))),
              ),
            ],
          ),
          // The route Create New Account used to dead-end on.
          GoRoute(
            path: '/register',
            builder: (_, _) =>
                const Scaffold(body: Center(child: Text('REGISTER'))),
          ),
        ],
      ),
    ),
  );
}

/// The secondary CTA sits below the fold in the test viewport.
Future<void> _tapCreateAccount(WidgetTester tester) async {
  final button = find.widgetWithText(OutlinedButton, 'Create New Account');
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pump();
}

void main() {
  testWidgets('invalid phone blocks submit — error shown, repo never called', (
    tester,
  ) async {
    final repo = MockAuthRepository();
    await tester.pumpWidget(_harness(repo));

    await tester.enterText(find.byType(TextField), '123');
    await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
    await tester.pump();

    expect(find.text('Please enter a valid phone number'), findsOneWidget);
    verifyNever(() => repo.requestOtp(any()));
  });

  testWidgets('renders in Arabic with RTL directionality', (tester) async {
    final repo = MockAuthRepository();
    await tester.pumpWidget(_harness(repo, locale: const Locale('ar')));

    expect(find.text('مرحبًا بعودتك'), findsOneWidget); // welcomeBack (AR)
    expect(
      Directionality.of(tester.element(find.text('مرحبًا بعودتك'))),
      TextDirection.rtl,
    );
  });

  testWidgets('offline → distinct banner shown and Send OTP disabled', (
    tester,
  ) async {
    final repo = MockAuthRepository();
    await tester.pumpWidget(_harness(repo, offline: true));
    await tester.pump(); // let the connectivity stream emit `false`

    expect(find.text('You are offline'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Send OTP'),
    );
    expect(button.onPressed, isNull);
  });

  group('Create New Account (DESIGN_ISSUES #8)', () {
    testWidgets(
      'no longer dead-ends on the registration expiry guard — it starts the '
      'same phone → OTP flow',
      (tester) async {
        final repo = MockAuthRepository();
        when(() => repo.requestOtp(any())).thenAnswer(
          (_) async => const OtpRequestResult(
            resendAfterSeconds: 60,
            expiresInSeconds: 300,
          ),
        );
        await tester.pumpWidget(_routerHarness(repo));
        // Settle the router's first frame before interacting; without it the
        // typed number does not reach `_submit`.
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '01021871999');
        await tester.pumpAndSettle();
        await _tapCreateAccount(tester);
        await tester.pumpAndSettle();

        // The contract is phone-verify-first: there is no token-less
        // registration route, so this must request an OTP like Send OTP does
        // and let `otp/verify` decide new-vs-existing.
        expect(find.text('OTP SCREEN'), findsOneWidget);
        expect(find.text('REGISTER'), findsNothing);
        verify(() => repo.requestOtp('+201021871999')).called(1);
      },
    );

    testWidgets('an empty phone surfaces the same inline error', (
      tester,
    ) async {
      final repo = MockAuthRepository();
      await tester.pumpWidget(_harness(repo));

      await _tapCreateAccount(tester);

      expect(find.text('Please enter a valid phone number'), findsOneWidget);
      verifyNever(() => repo.requestOtp(any()));
    });

    testWidgets('is disabled while offline, like Send OTP', (tester) async {
      final repo = MockAuthRepository();
      await tester.pumpWidget(_harness(repo, offline: true));
      await tester.pump();

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Create New Account'),
      );
      expect(button.onPressed, isNull);
    });
  });

  // Device finding 2026-09-20 (tablet walk, item 4): the dial chip painted
  // `20+` in Arabic. The phone TextField beside it was already LTR; the chip
  // was not. `find.text('+20')` matches either order, so assert the paint.
  testWidgets('the +20 dial code paints sign-first in Arabic', (tester) async {
    await tester.pumpWidget(
      _harness(MockAuthRepository(), locale: const Locale('ar')),
    );
    await tester.pump();

    final chip = find.text(Phone.egyptDialCode);
    expect(chip, findsOneWidget);
    expect(
      glyphLeft(tester, chip, 0),
      lessThan(glyphLeft(tester, chip, 1)),
      reason: '"+" must paint to the LEFT of "2" — `+20`, not `20+`',
    );
  });

  // Wave 01 walk, W01-2: the error was stored as the RESOLVED string, so after
  // toggling to Arabic it stayed English. Re-pumping the same tree with a new
  // locale keeps the State (and its error) — exactly what the pill does.
  testWidgets('an on-screen phone error follows a language toggle', (
    tester,
  ) async {
    final repo = MockAuthRepository();
    await tester.pumpWidget(_harness(repo));
    await tester.pump(); // the CTA is not in the tree on the very first frame
    await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
    await tester.pump();
    expect(find.text('Please enter a valid phone number'), findsOneWidget);

    await tester.pumpWidget(_harness(repo, locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid phone number'), findsNothing);
    expect(find.text('من فضلك أدخل رقم هاتف صحيح'), findsOneWidget);
  });

  group('header matches 82:819 / 337:15652 (Wave 01 walk)', () {
    // By asset, not `.first`: the language pill's icon is also an SvgPicture
    // and comes earlier in the tree.
    SvgPicture bird(WidgetTester tester) => tester.widget<SvgPicture>(
      find.byWidgetPredicate(
        (w) =>
            w is SvgPicture &&
            w.bytesLoader is SvgAssetLoader &&
            (w.bytesLoader as SvgAssetLoader).assetName ==
                'assets/images/bird_logo.svg',
      ),
    );

    testWidgets('the bird is tinted per canvas — cream on dark (W01-1)', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(MockAuthRepository(), dark: true));
      expect(
        bird(tester).colorFilter,
        ColorFilter.mode(AppColors.dark.brandLogo, BlendMode.srcIn),
      );

      await tester.pumpWidget(_harness(MockAuthRepository()));
      await tester.pumpAndSettle();
      expect(
        bird(tester).colorFilter,
        ColorFilter.mode(AppColors.light.brandLogo, BlendMode.srcIn),
      );
    });

    testWidgets('the bird is drawn at the frame size, 132.854 tall (W01-4)', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(MockAuthRepository()));
      expect(bird(tester).height, 132.854);
    });

    testWidgets('the subtitle is h2, start-aligned (W01-3)', (tester) async {
      await tester.pumpWidget(_harness(MockAuthRepository()));
      final subtitle = tester.widget<Text>(
        find.text('Enter your phone number to continue'),
      );
      expect(subtitle.textAlign, TextAlign.start);
      expect(subtitle.style?.fontSize, AppType.h2.fontSize);
      expect(subtitle.style?.fontWeight, AppType.h2.fontWeight);
    });
  });
}
