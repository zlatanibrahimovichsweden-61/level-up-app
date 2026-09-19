/// Shared harness for the quiz WIDGET tests.
///
/// Runs through the REAL `routerProvider`, like the catalog harness: the quiz
/// routes deliberately live outside the nav shell, the screens navigate with
/// `context.push`/`go`, and a fake router would stop testing the wiring that
/// actually matters.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';
import 'package:level_up_app/features/quiz/screens/screen_protection.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';

class MockQuizRepository extends Mock implements QuizRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

/// Records the calls the plugin would have made.
///
/// The Day 7 requirement is that screenshot protection is VERIFIED on and off,
/// not assumed — so the seam exists precisely so a widget test can assert this.
class RecordingScreenProtection extends ScreenProtection {
  int enableCalls = 0;
  int disableCalls = 0;

  @override
  Future<void> enable() async => enableCalls++;

  @override
  Future<void> disable() async => disableCalls++;
}

class QuizHarness {
  QuizHarness({
    required this.container,
    required this.router,
    required this.quiz,
    required this.profile,
    required this.protection,
    required this.storage,
  });

  final ProviderContainer container;
  final GoRouter router;
  final MockQuizRepository quiz;

  /// Exposed so a test can assert that finishing a quiz invalidates `/me`.
  final MockProfileRepository profile;
  final RecordingScreenProtection protection;

  /// Exposed so a test can assert that a screen wrote NOTHING — the quiz
  /// feature caches nothing at all (no Hive, no tokens touched), and the
  /// review screen listing correct answers is the one that must stay that way.
  final MockSecureStorage storage;
}

/// Boots the real app, signed in, with a mocked quiz repository.
Future<QuizHarness> pumpQuizApp(
  WidgetTester tester, {
  MockQuizRepository? quiz,
  String locale = 'en',
  ThemeData? theme,
  bool online = true,
}) async {
  final storage = MockSecureStorage();
  when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
  when(() => storage.clearTokens()).thenAnswer((_) async {});

  final profile = MockProfileRepository();
  when(profile.getMe).thenAnswer((_) async => schoolProfile());
  when(profile.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

  final repository = quiz ?? MockQuizRepository();
  final protection = RecordingScreenProtection();

  final container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(storage),
      profileRepositoryProvider.overrideWithValue(profile),
      quizRepositoryProvider.overrideWithValue(repository),
      screenProtectionProvider.overrideWithValue(protection),
      isOnlineProvider.overrideWith((ref) => Stream.value(online)),
    ],
  );
  addTearDown(container.dispose);

  container.read(authControllerProvider.notifier).markAuthenticated();
  final router = container.read(routerProvider);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
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

  return QuizHarness(
    container: container,
    router: router,
    quiz: repository,
    profile: profile,
    protection: protection,
    storage: storage,
  );
}
