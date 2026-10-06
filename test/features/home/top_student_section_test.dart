import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/home/widgets/top_student_section.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/notifier/leaderboard_notifier.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../leaderboard/leaderboard_fixtures.dart';
import '../profile/profile_fixtures.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

/// Home's Top Student block (API→UI Wave 05): the top three of the board the
/// Leaderboard tab opens on, with its own four states, and the surface it took
/// over from the "coming soon" placeholder (`59:2090` / `337:5460`).
void main() {
  setUpAll(() => registerFallbackValue(LeaderboardScope.system));

  late _MockLeaderboardRepository board;
  late _MockProfileRepository profiles;

  setUp(() {
    board = _MockLeaderboardRepository();
    profiles = _MockProfileRepository();
  });

  void givenPage(Future<CursorPage<LeaderboardEntry>> Function() page) {
    when(
      () => board.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => page());
  }

  void givenRanks(List<int> ranks) =>
      givenPage(() async => boardPage(ranks: ranks));

  void givenError(Object error) => givenPage(() async => throw error);

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    StudentProfile? profile,
    Brightness brightness = Brightness.light,
  }) async {
    final me = profile ?? schoolProfile();
    // The block listens to `/me` for points changes (after a quiz).
    when(profiles.getMe).thenAnswer((_) async => me);
    final container = ProviderContainer(
      overrides: [
        leaderboardRepositoryProvider.overrideWithValue(board),
        profileRepositoryProvider.overrideWithValue(profiles),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: brightness == Brightness.light
              ? AppTheme.light
              : AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: '/home',
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, _) => Scaffold(
                  body: SingleChildScrollView(
                    child: TopStudentSection(profile: me),
                  ),
                ),
              ),
              GoRoute(
                path: '/leaderboard',
                builder: (_, _) =>
                    const Scaffold(body: Center(child: Text('BOARD TAB'))),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  ElevatedSurface surfaceOf(WidgetTester tester) =>
      tester.widget(find.byType(ElevatedSurface));

  // -------------------------------------------------------------------------
  group('which board (owner, Wave 05)', () {
    for (final (label, profile, scope) in [
      ('school', schoolProfile, LeaderboardScope.system),
      ('university', universityProfile, LeaderboardScope.global),
    ]) {
      testWidgets('$label reads the board the tab opens on: ${scope.wire}', (
        tester,
      ) async {
        givenRanks([1, 2, 3]);
        await pump(tester, profile: profile());

        verify(
          () => board.getLeaderboard(
            scope: scope,
            cursor: null,
            limit: any(named: 'limit'),
          ),
        ).called(1);
        expect(LeaderboardScope.defaultFor(profile()), scope);
      });
    }

    testWidgets('ONE request serves Home and the Leaderboard tab', (
      tester,
    ) async {
      // The tab watches `leaderboardProvider(defaultFor(me))` when it opens.
      // Reading that key while Home holds it must not fetch again.
      givenRanks([1, 2, 3, 4, 5]);
      final me = schoolProfile();
      final container = await pump(tester, profile: me);

      final tab = container.read(
        leaderboardProvider(LeaderboardScope.defaultFor(me)),
      );
      await tester.pumpAndSettle();

      expect(tab.value?.items, hasLength(5), reason: 'already warm');
      verify(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });
  });

  // -------------------------------------------------------------------------
  testWidgets('new points on /me (a finished quiz) refetch the board', (
    tester,
  ) async {
    Future<void> boardCalls(int n) async => verify(
      () => board.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).called(n);

    givenRanks([1, 2, 3]);
    final container = await pump(tester);
    await boardCalls(1);

    // Same points again: nothing to re-rank, no request.
    container.invalidate(meProvider);
    await tester.pumpAndSettle();
    verifyNever(
      () => board.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    );

    final after = schoolProfileJson()
      ..['points'] = <String, dynamic>{
        'school': 2600,
        'university': 0,
        'total': 2600,
      };
    when(
      profiles.getMe,
    ).thenAnswer((_) async => StudentProfile.fromJson(after));
    container.invalidate(meProvider);
    await tester.pumpAndSettle();
    await boardCalls(1);
  });

  testWidgets('…and so does a board on the OTHER scope the tab may sit on', (
    tester,
  ) async {
    // The tab keeps whichever scope it was left on alive inside the shell's
    // IndexedStack. Invalidating only `defaultFor(me)` left a Governorate
    // board reading the old total after a quiz while the level card read the
    // new one (Fable-eye audit 2026-10-06, FE-07): the whole family goes.
    Future<void> boardCalls(int n) async => verify(
      () => board.getLeaderboard(
        scope: any(named: 'scope'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).called(n);

    givenRanks([1, 2, 3]);
    final container = await pump(tester);
    // The tab on its other scope, held open as the IndexedStack would.
    final other = container.listen(
      leaderboardProvider(LeaderboardScope.governorate),
      (_, _) {},
    );
    addTearDown(other.close);
    await tester.pumpAndSettle();
    await boardCalls(2);

    final after = schoolProfileJson()
      ..['points'] = <String, dynamic>{
        'school': 2600,
        'university': 0,
        'total': 2600,
      };
    when(
      profiles.getMe,
    ).thenAnswer((_) async => StudentProfile.fromJson(after));
    container.invalidate(meProvider);
    await tester.pumpAndSettle();
    // Both boards fetched again — Home's own scope and the tab's.
    await boardCalls(2);
  });

  // -------------------------------------------------------------------------
  group('rows · 59:2091 / 337:5461', () {
    testWidgets('the top THREE, each medal · name · points', (tester) async {
      givenRanks([1, 2, 3, 4, 5]);
      await pump(tester);

      for (final (rank, medal) in [(1, '🥇'), (2, '🥈'), (3, '🥉')]) {
        expect(find.text('Student $rank'), findsOneWidget);
        expect(find.text(medal), findsOneWidget);
        // No unit, as the frame writes "18,200".
        expect(find.text('${1000 - rank * 10}'), findsOneWidget);
      }
      expect(find.text('Student 4'), findsNothing);
    });

    testWidgets('dividers sit BETWEEN rows only, in the hairline colour', (
      tester,
    ) async {
      Finder dividers() => find.byWidgetPredicate(
        (w) =>
            w is ColoredBox &&
            w.color == colours(Brightness.light).topStudentBorder,
      );

      givenRanks([1, 2, 3]);
      await pump(tester);
      expect(dividers(), findsNWidgets(2));
    });

    testWidgets('a two-student board shows two rows and one divider', (
      tester,
    ) async {
      givenRanks([1, 2]);
      await pump(tester);

      expect(find.text('Student 1'), findsOneWidget);
      expect(find.text('Student 2'), findsOneWidget);
      expect(find.text('🥉'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is ColoredBox &&
              w.color == colours(Brightness.light).topStudentBorder,
        ),
        findsOneWidget,
      );
    });

    for (final brightness in Brightness.values) {
      testWidgets('${brightness.name} · name and points take their tokens', (
        tester,
      ) async {
        givenRanks([1, 2, 3]);
        await pump(tester, brightness: brightness);

        final name = tester.widget<Text>(find.text('Student 1'));
        final points = tester.widget<Text>(find.text('990'));
        expect(name.style?.color, colours(brightness).topStudentName);
        expect(points.style?.color, colours(brightness).topStudentPoints);
      });
    }

    testWidgets('the tokens hold the frame values', (tester) async {
      expect(AppColors.light.topStudentName, const Color(0xFF384F47));
      expect(AppColors.dark.topStudentName, const Color(0xFFFCFBF9));
      expect(AppColors.light.topStudentPoints, const Color(0xFFE67E22));
      expect(AppColors.dark.topStudentPoints, const Color(0xFFAE87E7));
    });
  });

  // -------------------------------------------------------------------------
  group('states', () {
    testWidgets('empty board → its own line, no rows', (tester) async {
      givenRanks([]);
      await pump(tester);

      expect(find.text("This board doesn't have anyone on it yet."), findsOne);
      expect(find.text('🥇'), findsNothing);
    });

    testWidgets('error → the generic line and a Retry that refetches', (
      tester,
    ) async {
      givenError(const UnknownException());
      await pump(tester);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.genericError), findsOneWidget);
      givenRanks([1, 2, 3]);
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Student 1'), findsOneWidget);
    });

    testWidgets('429 → no Retry, as on the Leaderboard tab', (tester) async {
      givenError(const RateLimitedException());
      await pump(tester);

      expect(find.widgetWithText(TextButton, 'Retry'), findsNothing);
    });

    testWidgets('403 account_pending_deletion → its own copy, no Retry', (
      tester,
    ) async {
      givenError(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      );
      await pump(tester);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsNothing);
    });

    testWidgets('offline → its own copy, with Retry', (tester) async {
      givenError(const OfflineException());
      await pump(tester);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.offline), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  testWidgets('See All opens the Leaderboard tab (owner, Wave 05)', (
    tester,
  ) async {
    givenRanks([1, 2, 3]);
    await pump(tester);

    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();
    expect(find.text('BOARD TAB'), findsOneWidget);
  });

  // W05-1 (Wave 05 walk): the frames draw "See All" in the title's colour —
  // `59:2089` black, `337:5456` #FCFBF9 — not `mutedText` #B3B3B3.
  for (final brightness in Brightness.values) {
    testWidgets('${brightness.name} · See All wears the title colour', (
      tester,
    ) async {
      givenRanks([1, 2, 3]);
      await pump(tester, brightness: brightness);

      final seeAll = tester.widget<Text>(find.text('See All'));
      expect(seeAll.style?.color, colours(brightness).textPrimary);
      expect(
        seeAll.style?.color,
        tester.widget<Text>(find.text('Top Student')).style?.color,
      );
    });
  }

  // -------------------------------------------------------------------------
  // Moved from `coming_soon_section_test.dart` with the surface (Wave 05).
  group('surface · 59:2090 / 337:5460', () {
    for (final brightness in Brightness.values) {
      testWidgets('${brightness.name} · a hairline on ALL FOUR sides', (
        tester,
      ) async {
        givenRanks([1, 2, 3]);
        await pump(tester, brightness: brightness);

        final s = surfaceOf(tester);
        expect(s.color, colours(brightness).topStudentFill);
        expect(
          ((s.shape as RoundedRectangleBorder).borderRadius as BorderRadius)
              .topLeft
              .x,
          16.374941,
        );
        // W05-2: both frames stroke `border-[1.208px]` all round.
        expect(s.side?.color, colours(brightness).topStudentBorder);
        expect(s.side?.width, 1.20791);
        expect(s.topSide, isNull, reason: 'a full border, not a top line');
        // ...and the frame's `p-[1.208px]` inside it, so the row dividers stop
        // short of the outline instead of doubling it at their ends.
        expect(s.padding, const EdgeInsets.all(1.20791 + 1.208));
      });
    }

    testWidgets('the UNIVERSITY Top Student has no back-light at all', (
      tester,
    ) async {
      // `349:16788` sits under no glass surface (edit3.md #44, #78).
      givenRanks([1, 2, 3]);
      await pump(
        tester,
        profile: universityProfile(),
        brightness: Brightness.dark,
      );
      expect(surfaceOf(tester).backlights, isEmpty);
    });

    testWidgets('the school one has its back-light in dark', (tester) async {
      givenRanks([1, 2, 3]);
      await pump(tester, brightness: Brightness.dark);
      expect(surfaceOf(tester).backlights, hasLength(1));
    });
  });
}
