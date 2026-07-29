import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/features/shell/screens/tab_placeholder.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';

/// The nav shell, driven through the REAL router: a signed-in student lands on
/// Home inside the shell, and switching tabs preserves each branch's state.

class _MockStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockStorage storage;
  late _MockProfileRepository repo;

  setUp(() {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    repo = _MockProfileRepository();
    when(repo.getMe).thenAnswer((_) async => schoolProfile());
    when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
  });

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        profileRepositoryProvider.overrideWithValue(repo),
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

  testWidgets('the three unbuilt tabs are coming-soon placeholders',
      (tester) async {
    await pumpApp(tester);

    // Learn is NOT in this list any more — Day 5 gave it the real
    // SubjectsScreen (see catalog tests). Home and Learn are the built tabs.
    for (final (label, type) in <(String, Type)>[
      ('Leaderboard', LeaderboardPlaceholderScreen),
      ('Message', MessagePlaceholderScreen),
      ('Account', AccountPlaceholderScreen),
    ]) {
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();

      expect(find.byType(type), findsOneWidget, reason: '$label tab');
      expect(find.text('Coming soon'), findsOneWidget);
    }
  });

  testWidgets('switching tabs preserves Home — /me is not re-fetched',
      (tester) async {
    await pumpApp(tester);
    expect(find.text('LEVEL 8'), findsOneWidget);

    await tester.tap(find.text('Leaderboard').last);
    await tester.pumpAndSettle();
    expect(find.byType(LeaderboardPlaceholderScreen), findsOneWidget);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('LEVEL 8'), findsOneWidget);
    // The whole point of indexedStack: Home was never rebuilt from scratch, so
    // the student does not pay for a second /me on every tab switch.
    verify(repo.getMe).called(1);
  });
}
