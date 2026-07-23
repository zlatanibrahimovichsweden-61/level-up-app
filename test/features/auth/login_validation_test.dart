import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _harness(
  MockAuthRepository repo, {
  Locale locale = const Locale('en'),
  bool offline = false,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      if (offline) isOnlineProvider.overrideWith((ref) => Stream.value(false)),
    ],
    child: MaterialApp(
      locale: locale,
      theme: AppTheme.light, // carries the AppColors ThemeExtension
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginScreen(),
    ),
  );
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
}
