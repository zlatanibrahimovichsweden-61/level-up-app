import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';

class _MockStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

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

  ProviderContainer makeContainer({List<Override> overrides = const []}) {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        ...overrides,
      ],
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

  // CW02 slice C: a forced sign-out now also leaves a return target behind.
  // Showing the one-time message must neither depend on it, repeat because of
  // it, nor spend it — the target is for the sign-in landing, not for Login.
  //
  // O-10: the target is bound to the student whose session ended, read from
  // `/me` at the forced sign-out — so this harness loads `/me` and keeps it
  // alive, as Home does in the app, and consumes as that same student. The
  // router's redirect remembers the location after the flip; here that is done
  // by hand, in the same order.
  testWidgets('the message still shows exactly once with a return target '
      'pending, and leaves the target for the sign-in landing', (tester) async {
    final profile = _MockProfileRepository();
    when(profile.getMe).thenAnswer((_) async => schoolProfile());
    final container = makeContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(profile)],
    );
    holdProfile(container);
    final student = await container.read(meProvider.future);

    await container
        .read(authControllerProvider.notifier)
        .forceLogout(LogoutReason.supersededOtherDevice);
    container.read(returnTargetProvider).remember('/message?from=push');

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
    expect(
      (container.read(authControllerProvider) as AuthUnauthenticated).reason,
      isNull,
      reason: 'the reason is consumed when the message is shown',
    );

    await _drainSnackBar(tester);

    // Not repeated…
    expect(
      find.text(
        "You've been signed out — your account was used on another device.",
      ),
      findsNothing,
    );
    // …and the target survived the forced sign-out and the Login screen, for
    // the student whose session ended.
    expect(
      container.read(returnTargetProvider).consume(studentId: student.id),
      '/message?from=push',
    );
  });
}
