/// Shared harness for the catalog WIDGET tests.
///
/// Everything here runs through the REAL `routerProvider`, because the Learn
/// screens are only reachable inside the nav shell's Learn branch and the
/// header reads `GoRouter.of(context)`. A direct pump would need a fake router
/// and would stop testing the thing that matters — the nested routes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:level_up_app/features/mistakes/repository/mistakes_repository.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';

import '../profile/profile_fixtures.dart';
import '../leaderboard/leaderboard_fixtures.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

/// The Learn tab's label, per locale — what [openLearnTab] taps.
const _learnLabel = {'en': 'Learn', 'ar': 'تعلّم'};

/// Boots the real app, signed in, and returns the container.
Future<ProviderContainer> pumpCatalogApp(
  WidgetTester tester, {
  required MockCatalogRepository catalog,
  MistakesRepository? mistakes,
  String locale = 'en',
  ThemeData? theme,
  bool online = true,
  Stream<bool>? onlineStream,
  Track track = Track.school,
}) async {
  final storage = MockSecureStorage();
  when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
  when(() => storage.clearTokens()).thenAnswer((_) async {});

  final profile = MockProfileRepository();
  // `GET /me` is track-agnostic for everything the Learn stack reads; the track
  // matters only to Home. The catalog screens branch on the TREE's
  // discriminator, never on this — which is what makes the university flow
  // testable without touching the profile at all.
  when(profile.getMe).thenAnswer(
    (_) async =>
        track == Track.university ? universityProfile() : schoolProfile(),
  );
  when(profile.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

  final container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(storage),
      profileRepositoryProvider.overrideWithValue(profile),
      leaderboardRepositoryProvider.overrideWithValue(
        QuietLeaderboardRepository(),
      ),
      catalogRepositoryProvider.overrideWithValue(catalog),
      // The Mistakes flow is entered FROM the Subjects header, so its tests
      // boot through this same harness rather than a second one. Left
      // un-overridden for the catalog's own tests: an unstubbed repository
      // that is never read is not a stub worth writing.
      if (mistakes != null)
        mistakesRepositoryProvider.overrideWithValue(mistakes),
      isOnlineProvider.overrideWith(
        (ref) => onlineStream ?? Stream.value(online),
      ),
    ],
  );
  addTearDown(container.dispose);
  holdBoards(container);
  holdProfile(container);

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

/// Switches to the Learn tab the way a student does — by tapping the nav bar.
Future<void> openLearnTab(WidgetTester tester, {String locale = 'en'}) async {
  await tester.tap(find.text(_learnLabel[locale]!).last);
  await tester.pumpAndSettle();
}

/// Where the real router currently is.
///
/// `GoRouter.state.uri` and NOT `routerDelegate.currentConfiguration.uri` —
/// the latter reports the last DECLARATIVE match and silently misses an
/// imperative `push`, which is exactly what the Mistakes flow navigates with.
String locationOf(ProviderContainer container) =>
    container.read(routerProvider).state.uri.toString();
