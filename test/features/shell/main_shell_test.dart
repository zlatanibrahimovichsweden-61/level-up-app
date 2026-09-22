import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/features/shell/screens/tab_placeholder.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../leaderboard/leaderboard_fixtures.dart';
import '../profile/profile_fixtures.dart';

/// The nav shell, driven through the REAL router: a signed-in student lands on
/// Home inside the shell, and switching tabs preserves each branch's state.

class _MockStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  late _MockStorage storage;
  late _MockProfileRepository repo;
  late _MockLeaderboardRepository board;

  setUpAll(() => registerFallbackValue(LeaderboardScope.system));

  setUp(() {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    repo = _MockProfileRepository();
    when(repo.getMe).thenAnswer((_) async => schoolProfile());
    when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

    // The Leaderboard branch is a real screen since 2026-09-22, so the shell
    // can no longer switch to it without a board behind it. A complete
    // five-row board: this file is about the SHELL, and the board's own states
    // are exercised in `leaderboard_screen_test.dart`.
    board = _MockLeaderboardRepository();
    when(
      () => board.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => boardPage(ranks: const [1, 2, 3, 4, 5]));
  });

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        profileRepositoryProvider.overrideWithValue(repo),
        leaderboardRepositoryProvider.overrideWithValue(board),
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
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('post-login lands on /home INSIDE the shell', (tester) async {
    await pumpApp(tester);

    // The guard sent the authenticated student off /login and into the shell.
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    // Real data, not the old "/home — not built yet" placeholder.
    expect(find.text('LEVEL 8'), findsOneWidget);
    expect(find.text('Home — not built yet'), findsNothing);
  });

  testWidgets('all five tabs are present, Home selected first', (tester) async {
    await pumpApp(tester);

    for (final label in [
      'Home',
      'Leaderboard',
      'Learn',
      'Message',
      'Account',
    ]) {
      expect(find.text(label), findsWidgets, reason: '$label tab missing');
    }

    final shell = tester.widget<MainShell>(find.byType(MainShell));
    expect(shell.navigationShell.currentIndex, 0);
  });

  testWidgets('Message is the last coming-soon placeholder', (tester) async {
    await pumpApp(tester);

    // Learn left this list in Day 5 (real SubjectsScreen), Account in Day 8
    // (real ProfileScreen) and Leaderboard on 2026-09-22 (D-008 closed —
    // `docs/D008_LEADERBOARD_AUDIT.md`). Message is what remains, and unlike
    // the other three its screen was never built: no endpoint exists for it.
    await tester.tap(find.text('Message').last);
    await tester.pumpAndSettle();

    expect(find.byType(MessagePlaceholderScreen), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('the Leaderboard tab is the real board, not a placeholder', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Leaderboard').last);
    await tester.pumpAndSettle();

    // This is the tab TAP — the board's own test navigates with `go`, because
    // four of its cases run in Arabic where this label is المتصدرون.
    expect(find.byType(LeaderboardScreen), findsOneWidget);
    expect(find.text('Coming soon'), findsNothing);
    // The board's own heading, deliberately a different key from the tab label.
    expect(find.text('Leaderboard'), findsWidgets);
  });

  testWidgets('the Account tab is the real Profile hub, not a placeholder', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Account').last);
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Coming soon'), findsNothing);
    // Rendered from the /me the Home tab already fetched — see the
    // "switching tabs preserves Home" test below for the call count.
    expect(find.text('Ahmed Mohamed'), findsOneWidget);
  });

  testWidgets('switching tabs preserves Home — /me is not re-fetched', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('LEVEL 8'), findsOneWidget);

    await tester.tap(find.text('Leaderboard').last);
    await tester.pumpAndSettle();
    expect(find.byType(LeaderboardScreen), findsOneWidget);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('LEVEL 8'), findsOneWidget);
    // The whole point of indexedStack: Home was never rebuilt from scratch, so
    // the student does not pay for a second /me on every tab switch.
    verify(repo.getMe).called(1);
  });
}
