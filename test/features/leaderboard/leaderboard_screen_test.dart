import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:level_up_app/features/leaderboard/widgets/leaderboard_row.dart';
import 'package:level_up_app/features/leaderboard/widgets/scope_toggle.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';

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
    Brightness brightness = Brightness.light,
    bool settle = true,
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

    // Mounted through the REAL router (restored 2026-09-22 when D-008 closed
    // and `/leaderboard` went back to serving LeaderboardScreen), so every
    // assertion below is made against the board as it actually sits inside the
    // shell — with the nav bar present and the branch selected.
    //
    // Navigated with `go` rather than by tapping the tab because the tab's
    // label is localized and four tests below run in Arabic. The tab TAP is
    // covered where it belongs, in `main_shell_test.dart`.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: brightness == Brightness.light
              ? AppTheme.light
              : AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
      container.read(routerProvider).go('/leaderboard');
      await tester.pumpAndSettle();
    } else {
      // A board that never answers keeps its spinner turning, so the tree
      // never settles: a fixed run of frames instead.
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      container.read(routerProvider).go('/leaderboard');
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }
    // Asserted on every mount, not once: this is what keeps D-008 closed. If
    // `/leaderboard` is ever pointed back at a placeholder, all 17 cases in
    // this file go red here rather than passing against a screen nobody can
    // reach — which is exactly how the board stayed green for two weeks while
    // being unreachable.
    expect(
      find.byType(LeaderboardScreen),
      findsOneWidget,
      reason: '/leaderboard must serve the real board',
    );
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

  testWidgets('the rows sit 8 apart, the frame\'s auto layout', (tester) async {
    // `134:3536` stacks its 48-high rows at y 0 / 56 / 112. The build had 10
    // until the Wave 06 device walk measured it (W06-4).
    givenBoard(ranks: const [1, 2, 3, 4, 5, 6]);
    await openLeaderboard(tester, me: schoolProfile());

    final rows = find.byType(LeaderboardRow);
    final first = tester.getRect(rows.at(0));
    final second = tester.getRect(rows.at(1));
    expect(first.height, 48);
    expect(second.top - first.bottom, 8);
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
    // Un-skipped 2026-09-22, in the same change that restored the route — this
    // test was D-008's marker and the suite's single skipped test.
  });

  testWidgets('share is present but inert — there is no sharing surface', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    givenBoard();
    await openLeaderboard(tester, me: schoolProfile());

    final share = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.share),
    );
    expect(share.onPressed, isNull);
    // ONE node says "Share": the labelled, disabled wrapper. The IconButton's
    // own node (its tooltip, no label) used to sit beside it at the same
    // bounds, so TalkBack met the dead control twice (Fable-eye audit
    // 2026-10-06, FE-04).
    var saysShare = 0;
    void walk(SemanticsNode node) {
      if (node.label == 'Share' || node.tooltip == 'Share') saysShare++;
      node.visitChildren((child) {
        walk(child);
        return true;
      });
    }

    // From the nearest node above the screen's Scaffold, the whole board.
    walk(tester.getSemantics(find.byType(Scaffold).first));
    expect(saysShare, 1);
    handle.dispose();
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

  group('account_pending_deletion (adr-114) — the grace window', () {
    void givenFailure(Object error) {
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw error);
    }

    testWidgets('says what is wrong and withholds Retry', (tester) async {
      // The contract's two client rules for this code, in its own words: "do
      // not log the user out and do not retry" (`openapi.yaml:82-83`). The
      // board already supplied the copy; the Retry button contradicted it.
      givenFailure(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      );

      await openLeaderboard(tester, me: schoolProfile());

      expect(
        find.text(
          'Your account is scheduled for deletion. '
          'Cancel the request to use Level Up again.',
        ),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('an ordinary failure still gets its Retry', (tester) async {
      // The other half of the rule. Suppression must be narrow — a board that
      // withheld Retry for every error would be a regression, not a fix.
      givenFailure(const ApiException(status: 500, code: 'server_error'));

      await openLeaderboard(tester, me: schoolProfile());

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // CW17 / TalkBack: the board as the router mounts it. Each podium place and
  // each ranked row is one node (rank, name or "You", points), the avatar photo
  // is no stop of its own, and only the caller's row is selected.
  for (final locale in ['en', 'ar']) {
    testWidgets('$locale · podium places and rows are one node each', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      givenBoard(ranks: const [1, 2, 3, 4, 5], meRank: 4);
      await openLeaderboard(tester, me: schoolProfile(), locale: locale);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(LeaderboardScreen)),
      );

      // A podium place: badge, name, points.
      final winner = tester.getSemantics(find.text('Student 1'));
      expect(winner.getSemanticsData().label.split('\n'), [
        '1',
        'Student 1',
        l10n.leaderboardPoints(990),
      ]);
      expect(winner.childrenCount, 0);
      expect(winner.getSemanticsData().flagsCollection.isImage, isFalse);

      // The caller's own row: "You" in place of the name, and selected.
      final me = tester.getSemantics(find.text(l10n.leaderboardYou));
      expect(me.getSemanticsData().label.split('\n'), [
        '4',
        l10n.leaderboardYou,
        l10n.leaderboardPoints(960),
      ]);
      expect(me.childrenCount, 0);
      expect(me.getSemanticsData().flagsCollection.isImage, isFalse);
      expect(me.getSemanticsData().flagsCollection.isSelected, Tristate.isTrue);

      // An ordinary row is merged the same way and is not selected.
      final other = tester.getSemantics(find.text('Student 5'));
      expect(other.getSemanticsData().label.split('\n'), [
        '5',
        'Student 5',
        l10n.leaderboardPoints(950),
      ]);
      expect(other.childrenCount, 0);
      expect(other.getSemanticsData().flagsCollection.isImage, isFalse);
      expect(
        other.getSemanticsData().flagsCollection.isSelected,
        Tristate.isFalse,
      );
      handle.dispose();
    });
  }

  // `getLeaderboard` documents 429 `rate_limited` ("Honour Retry-After",
  // `openapi.yaml:2568`). Until CW17 the board said "Something went wrong" and
  // gave no hint that waiting was the cure.
  group('429 rate_limited', () {
    void givenFailure(Object error) {
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw error);
    }

    for (final locale in ['en', 'ar']) {
      testWidgets('says so, with no Retry to hammer · $locale', (tester) async {
        givenFailure(const RateLimitedException());
        await openLeaderboard(tester, me: schoolProfile(), locale: locale);
        final l10n = await AppLocalizations.delegate.load(Locale(locale));

        expect(find.text(l10n.rateLimited), findsOneWidget);
        expect(find.text(l10n.genericError), findsNothing);
        expect(find.text(l10n.retry), findsNothing);
      });

      testWidgets('names the wait when the server sent Retry-After · $locale', (
        tester,
      ) async {
        givenFailure(
          const RateLimitedException(retryAfter: Duration(seconds: 42)),
        );
        await openLeaderboard(tester, me: schoolProfile(), locale: locale);
        final l10n = await AppLocalizations.delegate.load(Locale(locale));

        expect(find.text(l10n.rateLimitedIn(42)), findsOneWidget);
        expect(find.text(l10n.rateLimited), findsNothing);
        expect(find.text(l10n.genericError), findsNothing);
        expect(find.text(l10n.retry), findsNothing);
      });
    }
  });

  // The footer of a board that is already on screen. A failed append keeps the
  // rows; whether it may offer Retry is the first page's call
  // ([boardRetryAllowed]): a 429 recovers on its own clock (`getLeaderboard`:
  // "Honour Retry-After", `openapi.yaml:2568`) and a pending deletion answers
  // the same 403 on every tap. The footer used to be a bare Retry for all of
  // them, and a scroll near the bottom re-fired the request regardless.
  group('a failed append (the footer)', () {
    // Counted by hand: mocktail's `verify` skips calls it already verified, so
    // two reads of it in one test would not see the same history.
    var secondPageAsks = 0;
    var thirdPageAsks = 0;
    setUp(() {
      secondPageAsks = 0;
      thirdPageAsks = 0;
    });

    /// A second page that fails on its first ask and is answered on the next
    /// (the footer's Retry), followed by a third and last page.
    void givenRecoveringSecondPage(Object error) {
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => boardPage(
          ranks: [for (var rank = 1; rank <= 14; rank++) rank],
          hasMore: true,
          nextCursor: 'cursor-2',
        ),
      );
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: 'cursor-2',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async {
        secondPageAsks++;
        if (secondPageAsks == 1) throw error;
        return boardPage(
          ranks: [for (var rank = 15; rank <= 28; rank++) rank],
          hasMore: true,
          nextCursor: 'cursor-3',
        );
      });
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: 'cursor-3',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async {
        thirdPageAsks++;
        return boardPage(ranks: const [29, 30]);
      });
    }

    void givenFailingSecondPage(Object error) {
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => boardPage(
          ranks: [for (var rank = 1; rank <= 14; rank++) rank],
          hasMore: true,
          nextCursor: 'cursor-2',
        ),
      );
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: 'cursor-2',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async {
        secondPageAsks++;
        throw error;
      });
    }

    /// To the end of the list, the way a student gets there.
    Future<void> scrollToFooter(WidgetTester tester) async {
      await tester.drag(find.byType(ListView), const Offset(0, -3000));
      await tester.pumpAndSettle();
    }

    for (final locale in ['en', 'ar']) {
      testWidgets('429 · the text, no Retry, rows kept · $locale', (
        tester,
      ) async {
        givenFailingSecondPage(const RateLimitedException());
        await openLeaderboard(tester, me: schoolProfile(), locale: locale);
        final l10n = await AppLocalizations.delegate.load(Locale(locale));

        await scrollToFooter(tester);

        expect(find.text(l10n.rateLimited), findsOneWidget);
        expect(find.text(l10n.retry), findsNothing);
        expect(find.text(l10n.genericError), findsNothing);
        // The rows already on screen survive.
        expect(find.byType(LeaderboardRow), findsWidgets);
        expect(secondPageAsks, 1);
        expect(tester.takeException(), isNull);
      });

      testWidgets('429 with Retry-After · names the wait · $locale', (
        tester,
      ) async {
        givenFailingSecondPage(
          const RateLimitedException(retryAfter: Duration(seconds: 30)),
        );
        await openLeaderboard(tester, me: schoolProfile(), locale: locale);
        final l10n = await AppLocalizations.delegate.load(Locale(locale));

        await scrollToFooter(tester);

        expect(find.text(l10n.rateLimitedIn(30)), findsOneWidget);
        expect(find.text(l10n.retry), findsNothing);
      });
    }

    testWidgets('429 · scrolling again does not ask the server again', (
      tester,
    ) async {
      givenFailingSecondPage(const RateLimitedException());
      await openLeaderboard(tester, me: schoolProfile());
      await scrollToFooter(tester);
      expect(secondPageAsks, 1);

      // Back up and down again: the withheld button must not be bypassed by the
      // scroll listener that fired the first request.
      await tester.drag(find.byType(ListView), const Offset(0, 3000));
      await tester.pumpAndSettle();
      await scrollToFooter(tester);
      await scrollToFooter(tester);

      expect(secondPageAsks, 1);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('account_pending_deletion · its line, no Retry', (
      tester,
    ) async {
      givenFailingSecondPage(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      );
      await openLeaderboard(tester, me: schoolProfile());
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await scrollToFooter(tester);

      expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
      expect(find.text(l10n.retry), findsNothing);
    });

    testWidgets('an ordinary failure still gets its Retry, and it asks again', (
      tester,
    ) async {
      // Suppression must be narrow: a footer that withheld Retry for every
      // error would be a regression, not a fix.
      givenFailingSecondPage(const NetworkException());
      await openLeaderboard(tester, me: schoolProfile());

      await scrollToFooter(tester);

      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);

      final asksBefore = secondPageAsks;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(secondPageAsks, asksBefore + 1);
    });

    // `LeaderboardNotifier.loadMore` promises "never a silent retry". The scroll
    // listener broke that for every failure kind that keeps its Retry: each
    // tick near the bottom asked again (eight requests in one drag against a
    // page that fails at once). A failed append now waits for the button.
    final ordinaryFailures = <String, Object>{
      'network error': const NetworkException(),
      'server error': const ApiException(status: 500, code: 'internal_error'),
      'unknown': const UnknownException(),
      'validation (not the cursor)': const ValidationException(
        errors: {
          'limit': ['bad'],
        },
      ),
    };
    for (final MapEntry(key: name, value: error) in ordinaryFailures.entries) {
      testWidgets(
        '$name · one failed append is one request; scrolling asks no more, '
        'only Retry does',
        (tester) async {
          givenFailingSecondPage(error);
          await openLeaderboard(tester, me: schoolProfile());

          // One drag to the end: the failure lands while the list is still at
          // the bottom, which is where a scroll tick used to fire again.
          await scrollToFooter(tester);
          expect(find.text('Retry'), findsOneWidget);
          expect(secondPageAsks, 1);

          // Up and down again, twice over: the footer's button is the only
          // way to ask again, so none of this reaches the server.
          await tester.drag(find.byType(ListView), const Offset(0, 3000));
          await tester.pumpAndSettle();
          await scrollToFooter(tester);
          await scrollToFooter(tester);
          expect(secondPageAsks, 1);
          expect(find.text('Retry'), findsOneWidget);

          // The button asks exactly once, and its failure waits again.
          await tester.tap(find.text('Retry'));
          await tester.pumpAndSettle();
          expect(secondPageAsks, 2);
          await scrollToFooter(tester);
          expect(secondPageAsks, 2);
          expect(find.text('Retry'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }

    // The other half of "only Retry asks again": once a Retry has been
    // answered the failure is over, and paging by scroll must work again. A
    // stale `appendError` would stall the board for good, and the tests above
    // (which only ever see failures) would stay green.
    for (final MapEntry(key: name, value: error) in ordinaryFailures.entries) {
      testWidgets(
        '$name · after a Retry that succeeds, scrolling pages again',
        (tester) async {
          givenRecoveringSecondPage(error);
          await openLeaderboard(tester, me: schoolProfile());

          await scrollToFooter(tester);
          expect(find.text('Retry'), findsOneWidget);
          expect(secondPageAsks, 1);

          // The button's ask is answered: the footer's failure is gone, and
          // nothing but the student's scroll has asked for the next page.
          await tester.tap(find.text('Retry'));
          await tester.pumpAndSettle();
          expect(secondPageAsks, 2);
          expect(find.text('Retry'), findsNothing);
          expect(thirdPageAsks, 0);

          // Now a scroll to the new end is paging again - exactly once.
          await scrollToFooter(tester);
          expect(thirdPageAsks, 1);
          expect(secondPageAsks, 2);
          expect(find.text('Student 30'), findsOneWidget);
          expect(find.text('Retry'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  // CW07a_REPORT.md:187-189 - error, empty and offline were never rendered on
  // the dark canvas by any test. The dark and Arabic frames for these states do
  // not exist (DG-35, DG-08, DG-31), so this pins behaviour - the line, whether
  // Retry is offered, that nothing overflows - and deliberately NOT colours or
  // pixels, which would freeze a stand-in as if it were the design.
  group('every state on the dark canvas', () {
    Future<void> openDark(
      WidgetTester tester,
      String locale, {
      bool settle = true,
    }) async {
      await openLeaderboard(
        tester,
        me: schoolProfile(),
        locale: locale,
        brightness: Brightness.dark,
        settle: settle,
      );
      expect(
        Theme.of(tester.element(find.byType(LeaderboardScreen))).brightness,
        Brightness.dark,
        reason: 'this group is about the dark canvas',
      );
    }

    void givenFailure(Object error) {
      when(
        () => board.getLeaderboard(
          scope: any(named: 'scope'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => throw error);
    }

    Finder retryButton(AppLocalizations l10n) =>
        find.widgetWithText(FilledButton, l10n.retry);

    for (final locale in ['en', 'ar']) {
      group(locale, () {
        testWidgets('loading: the spinner, nothing else', (tester) async {
          final pending = Completer<CursorPage<LeaderboardEntry>>();
          when(
            () => board.getLeaderboard(
              scope: any(named: 'scope'),
              cursor: any(named: 'cursor'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) => pending.future);

          await openDark(tester, locale, settle: false);

          expect(
            find.descendant(
              of: find.byType(LeaderboardScreen),
              matching: find.byType(CircularProgressIndicator),
            ),
            findsOneWidget,
          );
          expect(find.byType(LeaderboardRow), findsNothing);
          expect(tester.takeException(), isNull);
        });

        testWidgets('empty: its line, no Retry', (tester) async {
          givenBoard(ranks: const []);
          await openDark(tester, locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          expect(find.text(l10n.leaderboardEmpty), findsOneWidget);
          expect(retryButton(l10n), findsNothing);
          expect(tester.takeException(), isNull);
        });

        testWidgets('error: the generic line and a Retry', (tester) async {
          givenFailure(const UnknownException());
          await openDark(tester, locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          expect(find.text(l10n.genericError), findsOneWidget);
          expect(retryButton(l10n), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('offline: its own line and a Retry', (tester) async {
          givenFailure(const OfflineException());
          await openDark(tester, locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          expect(find.text(l10n.offline), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retryButton(l10n), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('pending deletion: its own line, no Retry', (tester) async {
          givenFailure(
            const ApiException(status: 403, code: 'account_pending_deletion'),
          );
          await openDark(tester, locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          expect(find.text(l10n.accountPendingDeletion), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retryButton(l10n), findsNothing);
          expect(tester.takeException(), isNull);
        });

        testWidgets('rate limited: its own line, no Retry', (tester) async {
          givenFailure(const RateLimitedException());
          await openDark(tester, locale);
          final l10n = await AppLocalizations.delegate.load(Locale(locale));

          expect(find.text(l10n.rateLimited), findsOneWidget);
          expect(find.text(l10n.genericError), findsNothing);
          expect(retryButton(l10n), findsNothing);
          expect(tester.takeException(), isNull);
        });

        testWidgets('loaded: podium and rows, nothing overflows', (
          tester,
        ) async {
          givenBoard(ranks: const [1, 2, 3, 4, 5], meRank: 4);
          await openDark(tester, locale);

          expect(find.byType(LeaderboardRow), findsNWidgets(2));
          expect(find.text('Student 1'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      });
    }
  });

  // O-15 / DESIGN_ISSUES #132: the row is already 48 tall (the share
  // IconButton's padded target), so the chip's 48 box only had to find room
  // sideways — it reaches toward the screen edge, never into the title.
  group('the back target (O-15)', () {
    testWidgets('the chip keeps the frame\'s 20 and a tap 10 dp outside it, '
        'toward the edge, goes Home', (tester) async {
      givenBoard();
      await openLeaderboard(tester, me: schoolProfile());

      final target = tester.getRect(find.byType(CircleBackButton));
      final chip = tester.getRect(
        find.descendant(
          of: find.byType(CircleBackButton),
          matching: find.byType(ElevatedSurface),
        ),
      );
      expect(target.size, const Size(48, 48));
      expect(chip.size, const Size(35, 35));
      expect(chip.left, 20);
      expect(chip.right, target.right, reason: 'the title starts where it did');
      expect(chip.center.dy, target.center.dy);

      await tester.tapAt(Offset(chip.left - 10, chip.center.dy));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<MainShell>(find.byType(MainShell))
            .navigationShell
            .currentIndex,
        0,
      );
    });
  });
}
