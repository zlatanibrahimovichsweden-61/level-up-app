import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../features/catalog/catalog_fixtures.dart';
import '../../features/leaderboard/leaderboard_fixtures.dart';
import '../../features/profile/profile_fixtures.dart';
import '../../features/profile/profile_harness.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

/// `/quiz/setup` and `/quiz/:quizId/result` used to force-unwrap `state.extra`
/// (`state.extra! as QuizSetupArgs`, `... as QuizResultArgs`), so a location
/// opened without its in-memory payload threw a cast error into the framework's
/// red screen. go_router nulls a non-JSON `extra` on an auth refresh (BUG-005),
/// and quiz state is in memory only, so a missing or wrong `extra` is a real
/// state, not an impossible one. Their siblings (`/quiz/:quizId` and
/// `.../review`) already answered it with `_QuizUnavailableScreen`; these two
/// now do too.
///
/// Reached here the only way a missing `extra` is reached in the app: the real
/// router, signed in, `go` to the location with nothing attached.
void main() {
  /// Signed in, on the shell, ready to be sent somewhere. The Learn catalogue
  /// is stubbed because "Back to Learn" lands on it.
  Future<GoRouter> pumpSignedIn(
    WidgetTester tester, {
    String locale = 'en',
  }) async {
    final catalog = _MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());

    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(signedInStorage()),
        profileRepositoryProvider.overrideWithValue(profileRepo()),
        catalogRepositoryProvider.overrideWithValue(catalog),
        leaderboardRepositoryProvider.overrideWithValue(
          QuietLeaderboardRepository(),
        ),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    holdBoards(container);
    holdProfile(container);
    container.read(authControllerProvider.notifier).markAuthenticated();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container.read(routerProvider);
  }

  Finder backToLearn(String label) => find.widgetWithText(FilledButton, label);

  for (final location in ['/quiz/setup', '/quiz/q-1/result']) {
    testWidgets('$location with no extra shows the unavailable screen, not a '
        'cast error (EN)', (tester) async {
      final router = await pumpSignedIn(tester);

      router.go(location);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Quiz'), findsOneWidget); // the screen's title
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(backToLearn('Back to Learn'), findsOneWidget);
      // The real screens are not built over nothing.
      expect(find.byType(QuizSetupScreen), findsNothing);
      expect(find.byType(QuizResultScreen), findsNothing);
      expect(router.state.uri.toString(), location);
    });

    testWidgets('$location with no extra, in Arabic (RTL)', (tester) async {
      final router = await pumpSignedIn(tester, locale: 'ar');

      router.go(location);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuizSetupScreen), findsNothing);
      expect(find.byType(QuizResultScreen), findsNothing);
      // One button, and it is the way back.
      expect(find.byType(FilledButton), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(FilledButton))),
        TextDirection.rtl,
      );
    });

    testWidgets('$location with an extra of the WRONG type is the same screen '
        '(the old `as` cast threw on this too)', (tester) async {
      final router = await pumpSignedIn(tester);

      router.go(location, extra: 'not the payload');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byType(QuizSetupScreen), findsNothing);
      expect(find.byType(QuizResultScreen), findsNothing);
    });

    testWidgets('$location: "Back to Learn" leaves for /learn', (tester) async {
      final router = await pumpSignedIn(tester);
      router.go(location);
      await tester.pumpAndSettle();

      await tester.tap(backToLearn('Back to Learn'));
      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), '/learn');
    });
  }
}
