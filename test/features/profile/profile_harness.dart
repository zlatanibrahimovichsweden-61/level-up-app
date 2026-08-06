/// Shared harness for the Profile WIDGET tests.
///
/// Two pumps, because the screen has two kinds of claim to prove:
///
/// - [pumpProfileScreen] mounts [ProfileScreen] directly. Cheap, and the right
///   tool for rendering, the state matrix, locale/theme, and the dialogs.
/// - [pumpProfileApp] boots the REAL router, signed in, so navigation can be
///   asserted against the router's own location — the only way to prove a
///   disabled row leads nowhere rather than merely lacking a callback.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

/// The Account tab's label, per locale — what [openAccountTab] taps.
const accountLabel = {'en': 'Account', 'ar': 'حسابي'};

/// A storage stub that reports a live session and accepts a token wipe.
MockSecureStorage signedInStorage() {
  final storage = MockSecureStorage();
  when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
  // `clearTokens`, never `clear` — `device_id` has to survive a sign-out.
  when(() => storage.clearTokens()).thenAnswer((_) async {});
  return storage;
}

/// Mounts [ProfileScreen] on its own. No router, so anything that navigates is
/// out of scope here by construction.
Future<ProviderContainer> pumpProfileScreen(
  WidgetTester tester, {
  required MockProfileRepository profile,
  MockAuthRepository? auth,
  MockSecureStorage? storage,
  String locale = 'en',
  ThemeData? theme,
  bool online = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(profile),
      secureStorageProvider.overrideWithValue(storage ?? signedInStorage()),
      if (auth != null) authRepositoryProvider.overrideWithValue(auth),
      isOnlineProvider.overrideWith((ref) => Stream.value(online)),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: Locale(locale),
        theme: theme ?? AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ProfileScreen(),
      ),
    ),
  );
  // Two frames: one for the connectivity stream and the resolved /me future, a
  // second because a REJECTED future reaches the widget a microtask later than
  // a resolved one.
  await tester.pump();
  await tester.pump();
  return container;
}

/// Boots the real app, signed in, on the nav shell.
Future<ProviderContainer> pumpProfileApp(
  WidgetTester tester, {
  required MockProfileRepository profile,
  MockAuthRepository? auth,
  String locale = 'en',
  ThemeData? theme,
}) async {
  final container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(signedInStorage()),
      profileRepositoryProvider.overrideWithValue(profile),
      if (auth != null) authRepositoryProvider.overrideWithValue(auth),
      isOnlineProvider.overrideWith((ref) => Stream.value(true)),
    ],
  );
  addTearDown(container.dispose);

  // Signed in — exactly what the OTP `authenticated` fork does.
  container.read(authControllerProvider.notifier).markAuthenticated();

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: Locale(locale),
        theme: theme ?? AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: container.read(routerProvider),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// Switches to the Account tab the way a student does — by tapping the nav bar.
Future<void> openAccountTab(WidgetTester tester, {String locale = 'en'}) async {
  await tester.tap(find.text(accountLabel[locale]!).last);
  await tester.pumpAndSettle();
}

/// Scrolls a Profile control into view and taps it.
///
/// The hub is ~966px tall and the test viewport is 600 — without the scroll,
/// half the rows are off-screen and a tap silently misses. [warnIfMissed] is
/// off for the DISABLED rows, where nothing is meant to receive the tap.
Future<void> tapProfileKey(
  WidgetTester tester,
  String key, {
  bool warnIfMissed = true,
}) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: warnIfMissed);
  await tester.pumpAndSettle();
}

/// Where the real router currently is.
///
/// `GoRouter.state.uri` and NOT `routerDelegate.currentConfiguration.uri` —
/// the latter reports the last DECLARATIVE match and stays on `/account` after
/// an imperative `push`, which would make "this row went nowhere" pass for a
/// row that navigated.
String locationOf(ProviderContainer container) =>
    container.read(routerProvider).state.uri.toString();

/// A `/me` repository stub returning a school student, plus entitlements so
/// nothing is left unstubbed if that provider is read.
MockProfileRepository profileRepo({StudentProfile? me}) {
  final repo = MockProfileRepository();
  when(repo.getMe).thenAnswer((_) async => me ?? schoolProfile());
  when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
  return repo;
}
