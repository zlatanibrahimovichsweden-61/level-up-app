import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:level_up_app/features/leaderboard/widgets/scope_toggle.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';
import 'leaderboard_fixtures.dart';

/// The Leaderboard tab, driven through the REAL router so the shell branch and
/// the nav bar's selection are exercised rather than assumed.

class _MockStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  late _MockStorage storage;
  late _MockProfileRepository profile;
  late _MockLeaderboardRepository board;

  setUpAll(() => registerFallbackValue(LeaderboardScope.system));

  setUp(() {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    profile = _MockProfileRepository();
    when(profile.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

    board = _MockLeaderboardRepository();
  });

  void givenBoard({List<int> ranks = const [1, 2, 3, 4, 5], int? meRank}) {
    when(
      () => board.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => boardPage(ranks: ranks, meRank: meRank));
  }

  Future<WidgetTester> openLeaderboard(
    WidgetTester tester, {
    required StudentProfile me,
    String locale = 'en',
  }) async {
    when(profile.getMe).thenAnswer((_) async => me);

    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        profileRepositoryProvider.overrideWithValue(profile),
        leaderboardRepositoryProvider.overrideWithValue(board),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).markAuthenticated();

    // Mounted DIRECTLY, not through the router: `/leaderboard` serves
    // LeaderboardPlaceholderScreen while `GET /leaderboard` is
    // `x-stability: draft` (D-008). Every assertion below is about the board
    // itself, so it survives the gating; the one test that was genuinely about
    // the shell branch is skipped rather than weakened. Restore the nav-tap
    // mount when the route goes back.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LeaderboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester;
  }

  group('the scope switcher forks by track', () {
    testWidgets('an Egyptian school student gets System + Governorate', (
      tester,
    ) async {
      givenBoard();
      await openLeaderboard(tester, me: schoolProfile());

      expect(find.text('System'), findsOneWidget);
      expect(find.text('Governorate'), findsOneWidget);
      // The other track's scopes would be 400 validation_failed.
      expect(find.text('Global'), findsNothing);
      expect(find.text('Cohort'), findsNothing);
    });

    testWidgets('a university student gets Global + Cohort', (tester) async {
      givenBoard();
      await openLeaderboard(tester, me: universityProfile());

      expect(find.text('Global'), findsOneWidget);
      expect(find.text('Cohort'), findsOneWidget);
      expect(find.text('System'), findsNothing);
      expect(find.text('Governorate'), findsNothing);
    });

    testWidgets('a non-Egyptian school student gets no switcher at all', (
      tester,
    ) async {
      // `governorate` is an Egypt-only sub-scope, so this student has exactly
      // one board. Drawing a second segment would offer a guaranteed 400.
      givenBoard();
      await openLeaderboard(tester, me: freeTextCityProfile());

      expect(find.byType(ScopeToggle), findsOneWidget);
      expect(find.text('Governorate'), findsNothing);
      // The widget collapses itself rather than rendering a one-option control.
      expect(tester.getSize(find.byType(ScopeToggle)).height, 0);
    });

    testWidgets('switching scope asks the server for the other board', (
      tester,
    ) async {
      givenBoard();
      await openLeaderboard(tester, me: schoolProfile());

      await tester.tap(find.text('Governorate'));
      await tester.pumpAndSettle();

      verify(
        () => board.getLeaderboard(
          scope: LeaderboardScope.governorate,
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });
  });

  group("the caller's own row", () {
    testWidgets('is labelled "You" when the server marks it isMe', (
      tester,
    ) async {
      givenBoard(ranks: const [1, 2, 3, 4, 5], meRank: 4);
      await openLeaderboard(tester, me: schoolProfile());

      expect(find.text('You'), findsOneWidget);
      // …and it replaces that row's name rather than adding a row.
      expect(find.text('Student 4'), findsNothing);
    });

    testWidgets('is absent — with no synthetic row — when not on the board', (
      tester,
    ) async {
      // Contract: "Do not add a synthetic self-rank row to the board." A
      // student below the 200-row display bound is on no page, and the board
      // is rendered without a self-rank element at all.
      givenBoard(ranks: const [1, 2, 3, 4, 5]);
      await openLeaderboard(tester, me: schoolProfile());

      expect(find.text('You'), findsNothing);
      expect(find.text('Student 4'), findsOneWidget);
    });
  });

  testWidgets('the podium shows points and never invents a level', (
    tester,
  ) async {
    // The frame's podium subtitle reads "level 7,3000Pts", but the endpoint
    // carries no level. Only points are rendered.
    givenBoard(ranks: const [1, 2, 3]);
    await openLeaderboard(tester, me: schoolProfile());

    expect(find.text('990 pts'), findsOneWidget); // rank 1 → 1000 - 10
    expect(find.textContaining('level'), findsNothing);
  });

  testWidgets('back goes to the Home tab, not off the shell', (tester) async {
    // The board is a root tab of the shell, so there is nothing to pop. Back
    // switches the branch, which moves the nav bar's selection with it.
    givenBoard();
    await openLeaderboard(tester, me: schoolProfile());

    expect(
      tester
          .widget<MainShell>(find.byType(MainShell))
          .navigationShell
          .currentIndex,
      1,
      reason: 'the Leaderboard branch is selected on open',
    );

    // The shared chip carries a Semantics label, not a Tooltip, so it is found
    // by type rather than by tooltip.
    await tester.tap(find.byType(CircleBackButton));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<MainShell>(find.byType(MainShell))
          .navigationShell
          .currentIndex,
      0,
      reason: 'back lands on Home and the nav bar follows',
    );
    expect(find.byType(MainShell), findsOneWidget);
    // SKIPPED, not deleted — D-008. The board is not a shell branch while
    // `GET /leaderboard` is `x-stability: draft`: `/leaderboard` serves
    // LeaderboardPlaceholderScreen, so there is no MainShell to assert on.
    // `testWidgets` takes a bool skip, hence the reason lives here.
    // Un-skip in the same commit that restores the route.
  }, skip: true);

  testWidgets('share is present but inert — there is no sharing surface', (
    tester,
  ) async {
    givenBoard();
    await openLeaderboard(tester, me: schoolProfile());

    final share = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.share),
    );
    expect(share.onPressed, isNull);
  });

  testWidgets('an empty board says so instead of showing a blank list', (
    tester,
  ) async {
    givenBoard(ranks: const []);
    await openLeaderboard(tester, me: schoolProfile());

    expect(
      find.text("This board doesn't have anyone on it yet."),
      findsOneWidget,
    );
  });

  group('Arabic (RTL)', () {
    // Arabic is the baseline locale here, not an edge case. These assert the
    // copy actually resolves from app_ar.arb — a missing AR key falls back to
    // English SILENTLY, so an English string appearing on this screen is the
    // failure being guarded against.
    testWidgets('the loaded board renders in Arabic, right-to-left', (
      tester,
    ) async {
      givenBoard(ranks: const [1, 2, 3, 4], meRank: 4);
      await openLeaderboard(tester, me: schoolProfile(), locale: 'ar');

      expect(
        Directionality.of(tester.element(find.byType(ScopeToggle))),
        TextDirection.rtl,
      );
      // The heading is its own copy, NOT the nav tab's. Both appear on this
      // screen at once, so a single key would make one of them wrong.
      expect(find.text('لوحة الصدارة'), findsOneWidget);
      expect(find.text('نظامي'), findsOneWidget);
      expect(find.text('المحافظة'), findsOneWidget);
      expect(find.text('أنت'), findsOneWidget);
      expect(find.textContaining('نقطة'), findsWidgets);
      // The English fallbacks must not leak through.
      expect(find.text('System'), findsNothing);
      expect(find.text('You'), findsNothing);
    });

    testWidgets('the empty state renders in Arabic', (tester) async {
      givenBoard(ranks: const []);
      await openLeaderboard(tester, me: schoolProfile(), locale: 'ar');

      expect(find.text('لا يوجد أحد في هذه القائمة بعد.'), findsOneWidget);
    });

    testWidgets('the error state renders in Arabic, with a retry', (
      tester,
    ) async {
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw const UnknownException());

      await openLeaderboard(tester, me: schoolProfile(), locale: 'ar');

      expect(find.text('حدث خطأ ما'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    testWidgets('the offline state is its own view, in Arabic', (tester) async {
      // Driven by exception TYPE, not by a generic error — offline is a
      // distinct state, not a flavour of failure.
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw const OfflineException());

      await openLeaderboard(tester, me: schoolProfile(), locale: 'ar');

      expect(find.text('أنت غير متصل بالإنترنت'), findsOneWidget);
    });
  });
}
