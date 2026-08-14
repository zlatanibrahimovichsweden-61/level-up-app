import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements SecureStorage {}

Future<void> _pumpLoginAfterForceLogout(
  WidgetTester tester, {
  required Locale locale,
  required ProviderContainer container,
}) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: locale,
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginScreen(),
      ),
    ),
  );
  await tester.pump(); // post-frame callback → showSnackBar
  await tester.pump(const Duration(milliseconds: 800)); // entrance animation
}

Future<void> _drainSnackBar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 4)); // fire the auto-hide timer
  await tester.pumpAndSettle();
}

void main() {
  late _MockStorage storage;

  setUp(() {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.clearTokens()).thenAnswer((_) async {});
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    return container;
  }

  testWidgets('superseded reason shows the message once (EN), then clears', (
    tester,
  ) async {
    final container = makeContainer();
    await container
        .read(authControllerProvider.notifier)
        .forceLogout(LogoutReason.supersededOtherDevice);

    await _pumpLoginAfterForceLogout(
      tester,
      locale: const Locale('en'),
      container: container,
    );

    expect(
      find.text(
        "You've been signed out — your account was used on another device.",
      ),
      findsOneWidget,
    );
    // Consumed → won't repeat.
    expect(
      (container.read(authControllerProvider) as AuthUnauthenticated).reason,
      isNull,
    );

    await _drainSnackBar(tester);
  });

  testWidgets('sessionExpired reason shows the message in Arabic', (
    tester,
  ) async {
    final container = makeContainer();
    await container
        .read(authControllerProvider.notifier)
        .forceLogout(LogoutReason.sessionExpired);

    await _pumpLoginAfterForceLogout(
      tester,
      locale: const Locale('ar'),
      container: container,
    );

    expect(
      find.text('انتهت صلاحية جلستك. من فضلك سجّل الدخول مرة أخرى.'),
      findsOneWidget,
    );

    await _drainSnackBar(tester);
  });
}
