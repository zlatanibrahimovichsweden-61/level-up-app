import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/flashcards/models/flashcard.dart';
import 'package:level_up_app/features/flashcards/notifier/lecture_flashcards_notifier.dart';
import 'package:level_up_app/features/flashcards/repository/flashcards_repository.dart';
import 'package:level_up_app/features/flashcards/screens/flashcard_setup_screen.dart';
import 'package:level_up_app/features/flashcards/screens/flashcard_study_screen.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../catalog/catalog_fixtures.dart';
import '../catalog/catalog_harness.dart';
import '../leaderboard/leaderboard_fixtures.dart';
import '../profile/profile_fixtures.dart';
import 'reading_order.dart';

/// Flash Card Setup · Figma `1234:8797`, and the two routes it adds.
///
/// Two harnesses on purpose:
/// - the REAL `routerProvider`, for the claims that are about the wiring (both
///   paths build the right screen, inside the nav shell, over the right stack);
/// - a stand-in router around the real [FlashcardSetupScreen], for everything
///   about the screen itself. The study route is a stub there, so what Start
///   pushes is asserted without depending on what the study screen builds.
///
/// Widths are the test font's (about 1.5x Inter), so nothing below asserts a
/// text width as a device fact — only positions and heights that the layout
/// fixes independently of the glyphs.

const _setupPath = '/learn/subject/sub-1/lecture/lec-1/flashcards';
const _studyPath = '$_setupPath/study';

const _pillKey = Key('flashcard_setup_pill');
const _helperKey = Key('flashcard_setup_helper');
const _startKey = Key('flashcard_setup_start');
const _scopeKey = Key('flashcard_setup_scope');
const _backKey = Key('flashcard_setup_back');

/// Counts every request that would have touched the flashcards endpoint.
///
/// `GET /flashcards/lectures/{id}/cards` charges the weekly preview per card
/// delivered, so Setup must never call it — `cardCalls` is the assertion.
class _CountingFlashcardsRepository extends Fake
    implements FlashcardsRepository {
  int cardCalls = 0;
  int gradeCalls = 0;

  @override
  Future<CursorPage<FlashcardCard>> getFlashcardsForLecture(
    String lectureId, {
    String? cursor,
    int? pageSize,
  }) async {
    cardCalls++;
    return const CursorPage<FlashcardCard>(
      items: [
        FlashcardCard(
          id: 'card-1',
          front: 'front 1',
          back: 'back 1',
          imageUrl: null,
          selfGrade: null,
        ),
      ],
      hasMore: false,
    );
  }

  @override
  Future<void> setSelfGrade(
    String flashcardId,
    FlashcardSelfGrade grade,
  ) async {
    gradeCalls++;
  }
}

/// A two-round deck, answering by cursor the way the server's keyset does:
/// no cursor is the first round (cards 1-2, `hasMore`, `nextCursor: 'tok'`) and
/// `'tok'` is the next one (cards 3-4, the end). [cursors] is every request's
/// cursor, in order — the assertion for "which round did the student get".
class _TwoRoundFlashcardsRepository extends Fake
    implements FlashcardsRepository {
  final List<String?> cursors = [];

  @override
  Future<CursorPage<FlashcardCard>> getFlashcardsForLecture(
    String lectureId, {
    String? cursor,
    int? pageSize,
  }) async {
    cursors.add(cursor);
    final first = cursor == null;
    return CursorPage<FlashcardCard>(
      items: [
        for (final n in first ? const [1, 2] : const [3, 4])
          FlashcardCard(
            id: 'card-$n',
            front: 'Front $n',
            back: 'Back $n',
            imageUrl: null,
            selfGrade: null,
          ),
      ],
      hasMore: first,
      nextCursor: first ? 'tok' : null,
    );
  }

  @override
  Future<void> setSelfGrade(
    String flashcardId,
    FlashcardSelfGrade grade,
  ) async {}
}

/// A Setup screen on its own under a stand-in router.
class _Harness {
  _Harness({
    required this.container,
    required this.router,
    required this.flashcards,
    required this.studyArrivals,
  });

  final ProviderContainer container;
  final GoRouter router;
  final _CountingFlashcardsRepository flashcards;

  /// The path parameters every arrival at the stub study route carried.
  final List<Map<String, String>> studyArrivals;

  String get location => router.state.uri.toString();
}

void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => universityTree());
  });

  /// The frame is 402 wide; the harness has no status bar.
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(402, 868);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  /// Setup watches an autoDispose provider. When the binding tears the tree
  /// down the vsync is already gone, so Riverpod would schedule that disposal on
  /// a zero-length Timer the binding then reports as pending — the same trap
  /// `holdBoards` documents for Home. Unmounting INSIDE the test lets it run.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  void flashTest(
    String description,
    Future<void> Function(WidgetTester tester) body,
  ) {
    testWidgets(description, (tester) async {
      phone(tester);
      await body(tester);
      await unmount(tester);
    });
  }

  Future<_Harness> pumpSetup(
    WidgetTester tester, {
    String locale = 'en',
    ThemeData? theme,
    bool online = true,
    Stream<bool>? connectivity,
    String subjectId = 'sub-1',
    String lectureId = 'lec-1',
  }) async {
    final flashcards = _CountingFlashcardsRepository();
    final studyArrivals = <Map<String, String>>[];
    final container = ProviderContainer(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(catalog),
        flashcardsRepositoryProvider.overrideWithValue(flashcards),
        isOnlineProvider.overrideWith(
          (ref) => connectivity ?? Stream.value(online),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('root stand-in')),
        ),
        GoRoute(
          path: '/learn/subject/:subjectId/lecture/:lectureId/flashcards',
          builder: (_, state) => FlashcardSetupScreen(
            subjectId: state.pathParameters['subjectId']!,
            lectureId: state.pathParameters['lectureId']!,
          ),
          routes: [
            GoRoute(
              path: 'study',
              builder: (_, state) {
                studyArrivals.add(state.pathParameters);
                return const Scaffold(body: Text('study stand-in'));
              },
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

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
    unawaited(
      router.push<void>(
        '/learn/subject/$subjectId/lecture/$lectureId/flashcards',
      ),
    );
    await tester.pumpAndSettle();

    return _Harness(
      container: container,
      router: router,
      flashcards: flashcards,
      studyArrivals: studyArrivals,
    );
  }

  /// A university tree holding one lecture with [count] cards.
  UniversitySubjectTree treeWithCount(int count, {String id = 'lec-1'}) =>
      universityTree(
        lectures: [
          lectureJson(
            id: id,
            name: 'Upper Limb',
            hasFlashcards: count > 0,
            flashcardCount: count,
          ),
        ],
      );

  /// The pill's box. The key sits on the pill widget, whose one child is the
  /// decorated [Container].
  BoxDecoration pillDecoration(WidgetTester tester) =>
      tester
              .widget<Container>(
                find.descendant(
                  of: find.byKey(_pillKey),
                  matching: find.byType(Container),
                ),
              )
              .decoration!
          as BoxDecoration;

  AppColors colorsOf(WidgetTester tester) => Theme.of(
    tester.element(find.byType(FlashcardSetupScreen)),
  ).extension<AppColors>()!;

  // ---------------------------------------------------------------------------
  group('what the frame draws', () {
    flashTest('title, subject caption, lecture heading, pill, helper and Start '
        '(EN)', (tester) async {
      await pumpSetup(tester);

      expect(find.text('Flash Card Setup'), findsOneWidget);
      // The caption is the subject the student tapped through; the heading is
      // the lecture. Both are server copy, rendered verbatim.
      expect(find.text('Biology'), findsOneWidget);
      expect(find.text('Upper Limb'), findsOneWidget);
      expect(find.text('12 Flash Cards'), findsOneWidget);
      expect(
        find.text('this is available Flash cards for this quiz'),
        findsOneWidget,
      );
      expect(find.text('Start learning'), findsOneWidget);
    });

    flashTest('the same in Arabic', (tester) async {
      await pumpSetup(tester, locale: 'ar');

      expect(find.text('إعداد الفلاش كارد'), findsOneWidget);
      expect(find.text('Biology'), findsOneWidget);
      expect(find.text('Upper Limb'), findsOneWidget);
      expect(find.text('12 فلاش كارد'), findsOneWidget);
      expect(
        find.text('هذه الفلاش كارد المتاحة لهذا الاختبار'),
        findsOneWidget,
      );
      expect(find.text('ابدأ التعلّم'), findsOneWidget);
    });

    flashTest('a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", '
        '"0 Flash Cards"', (tester) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(24));
      await pumpSetup(tester);
      expect(find.text('24 Flash Cards'), findsOneWidget);
      await unmount(tester);

      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(1));
      await pumpSetup(tester);
      expect(find.text('1 Flash Card'), findsOneWidget);
      expect(find.text('1 Flash Cards'), findsNothing);
      await unmount(tester);

      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(0));
      await pumpSetup(tester);
      expect(find.text('0 Flash Cards'), findsOneWidget);
    });

    flashTest('Arabic 24 reads "24 فلاش كارد"', (tester) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(24));
      await pumpSetup(tester, locale: 'ar');

      expect(find.text('24 فلاش كارد'), findsOneWidget);
    });

    flashTest('the lecture is picked by id, not by position', (tester) async {
      // Three lectures; the path names the LAST one.
      await pumpSetup(tester, lectureId: 'lec-3');

      expect(find.text('Thorax'), findsOneWidget);
      expect(find.text('5 Flash Cards'), findsOneWidget);
      expect(find.text('Upper Limb'), findsNothing);
    });

    flashTest('on a cold link the subjects list has no name: the caption is '
        'left out, never invented', (tester) async {
      when(catalog.getSubjects).thenAnswer(
        (_) async => throw const ApiException(status: 500, code: 'internal'),
      );
      await pumpSetup(tester);

      expect(find.text('Biology'), findsNothing);
      expect(find.text('Upper Limb'), findsOneWidget);
      expect(find.text('12 Flash Cards'), findsOneWidget);
    });

    flashTest('no price, upgrade or limit surface is drawn', (tester) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(0));
      await pumpSetup(tester);

      for (final word in ['EGP', 'Upgrade', 'Subscribe', 'Buy', 'price']) {
        expect(find.textContaining(word), findsNothing, reason: word);
      }
    });
  });

  // ---------------------------------------------------------------------------
  group('the pill is text, not a control', () {
    flashTest('no button flag and no tap action, while Start is a button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSetup(tester);

      final pill = tester.getSemantics(find.text('12 Flash Cards'));
      expect(
        pill,
        isSemantics(
          label: '12 Flash Cards',
          isButton: false,
          hasTapAction: false,
        ),
      );
      // The control: the same traversal DOES see a button where there is one,
      // so the assertion above cannot pass for want of looking.
      expect(
        tester.getSemantics(find.byKey(_startKey)),
        isSemantics(isButton: true, hasTapAction: true),
      );
      handle.dispose();
    });

    flashTest('tapping the pill goes nowhere and asks for nothing', (
      tester,
    ) async {
      final h = await pumpSetup(tester);

      await tester.tap(find.byKey(_pillKey));
      await tester.pumpAndSettle();

      expect(h.location, _setupPath);
      expect(h.flashcards.cardCalls, 0);
    });
  });

  // ---------------------------------------------------------------------------
  group('Start', () {
    flashTest('pushes exactly the study path, ids in the path only', (
      tester,
    ) async {
      final h = await pumpSetup(tester);

      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();

      // `state.uri`, not `currentConfiguration.uri`: the latter silently misses
      // an imperative push, which is what Start is.
      expect(h.location, _studyPath);
      expect(h.studyArrivals, [
        {'subjectId': 'sub-1', 'lectureId': 'lec-1'},
      ]);
      expect(find.text('study stand-in'), findsOneWidget);
    });

    flashTest('a second tap during the transition does not stack a second '
        'study screen', (tester) async {
      final h = await pumpSetup(tester);

      await tester.tap(find.byKey(_startKey));
      // No pump between the taps: the button is still live under the route
      // transition.
      await tester.tap(find.byKey(_startKey), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(h.studyArrivals, hasLength(1));

      h.router.pop();
      await tester.pumpAndSettle();

      // One pop returns to Setup. With two study routes stacked it would land
      // on the second.
      expect(h.location, _setupPath);
      expect(find.byType(FlashcardSetupScreen), findsOneWidget);
    });

    flashTest('Start can be used again after the student comes back', (
      tester,
    ) async {
      final h = await pumpSetup(tester);

      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();
      h.router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();

      expect(h.studyArrivals, hasLength(2));
      expect(h.location, _studyPath);
    });

    flashTest('is enabled online with cards', (tester) async {
      await pumpSetup(tester);

      expect(
        tester.widget<FilledButton>(find.byKey(_startKey)).onPressed,
        isNotNull,
      );
      expect(find.byType(OfflineBanner), findsNothing);
    });

    flashTest('is disabled while offline, with the banner', (tester) async {
      final h = await pumpSetup(tester, online: false);

      expect(
        tester.widget<FilledButton>(find.byKey(_startKey)).onPressed,
        isNull,
      );
      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.text('You are offline'), findsOneWidget);

      await tester.tap(find.byKey(_startKey), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(h.location, _setupPath);
      expect(h.studyArrivals, isEmpty);
    });

    flashTest('follows connectivity: offline disables it, back online '
        'enables it', (tester) async {
      final connectivity = StreamController<bool>();
      addTearDown(connectivity.close);
      connectivity.add(true);
      await pumpSetup(tester, connectivity: connectivity.stream);
      FilledButton start() =>
          tester.widget<FilledButton>(find.byKey(_startKey));
      expect(start().onPressed, isNotNull);

      connectivity.add(false);
      await tester.pumpAndSettle();
      expect(start().onPressed, isNull);

      connectivity.add(true);
      await tester.pumpAndSettle();
      expect(start().onPressed, isNotNull);
    });

    flashTest('is disabled when the lecture holds no cards', (tester) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(0));
      final h = await pumpSetup(tester);

      expect(find.text('0 Flash Cards'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byKey(_startKey)).onPressed,
        isNull,
      );
      await tester.tap(find.byKey(_startKey), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(h.location, _setupPath);
    });

    flashTest('is enabled at one card', (tester) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => treeWithCount(1));
      await pumpSetup(tester);

      expect(
        tester.widget<FilledButton>(find.byKey(_startKey)).onPressed,
        isNotNull,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // The REAL study screen under Setup, because the claim is about what the two
  // screens share: `lectureFlashcardsProvider`, which the study screen's State
  // keeps alive until its route has left the tree — not until it starts to pop.
  group('Start right after a round finished', () {
    const gotItKey = Key('flashcard_got_it');

    Future<(GoRouter, _TwoRoundFlashcardsRepository)> pumpRealStudyStack(
      WidgetTester tester,
    ) async {
      final repository = _TwoRoundFlashcardsRepository();
      final container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(catalog),
          flashcardsRepositoryProvider.overrideWithValue(repository),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: Text('root stand-in')),
          ),
          GoRoute(
            path: '/learn/subject/:subjectId/lecture/:lectureId/flashcards',
            builder: (_, state) => FlashcardSetupScreen(
              subjectId: state.pathParameters['subjectId']!,
              lectureId: state.pathParameters['lectureId']!,
            ),
            routes: [
              GoRoute(
                path: 'study',
                builder: (_, state) => FlashcardStudyScreen(
                  subjectId: state.pathParameters['subjectId']!,
                  lectureId: state.pathParameters['lectureId']!,
                ),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('en'),
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(router.push<void>(_setupPath));
      await tester.pumpAndSettle();
      return (router, repository);
    }

    /// Start, then grade both cards of the first round. The second grade is
    /// tapped and left in flight: what happens next is the test's to time.
    Future<void> gradeFirstRoundToItsEnd(WidgetTester tester) async {
      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();
      expect(find.text('Front 1'), findsOneWidget);
      await tester.tap(find.byKey(gotItKey));
      await tester.pumpAndSettle();
      expect(find.text('Front 2'), findsOneWidget);
      await tester.tap(find.byKey(gotItKey));
    }

    for (final intoThePopMs in [20, 250]) {
      flashTest('tapped $intoThePopMs ms into the finished round\'s pop, it '
          'starts the NEXT round, not the one just finished', (tester) async {
        final (router, repository) = await pumpRealStudyStack(tester);
        await gradeFirstRoundToItsEnd(tester);

        // The grade lands, `finishRound` writes the position and the study
        // route starts to pop: the router is already back on Setup, but the
        // study screen is still mounted, running its exit transition.
        await tester.pump();
        await tester.pump();
        await tester.pump(Duration(milliseconds: intoThePopMs));
        expect(router.state.uri.toString(), _setupPath);
        expect(find.byType(FlashcardStudyScreen), findsOneWidget);

        // The exiting route ignores pointers, so the tap lands on Setup.
        await tester.tap(find.byKey(_startKey), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(router.state.uri.toString(), _studyPath);
        expect(find.byType(FlashcardStudyScreen), findsOneWidget);
        // One request per round, the second at the stored position.
        expect(repository.cursors, [null, 'tok']);
        expect(find.text('Front 3'), findsOneWidget);
        expect(find.text('Front 1'), findsNothing);
      });
    }

    flashTest('tapped after the pop has finished, it fetches the next round '
        'exactly once', (tester) async {
      final (router, repository) = await pumpRealStudyStack(tester);
      await gradeFirstRoundToItsEnd(tester);
      await tester.pumpAndSettle();
      expect(router.state.uri.toString(), _setupPath);
      expect(find.byType(FlashcardStudyScreen), findsNothing);
      expect(repository.cursors, [null]);

      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), _studyPath);
      expect(repository.cursors, [null, 'tok']);
      expect(find.text('Front 3'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  group('Setup never touches the flashcards endpoint', () {
    flashTest('no request on opening, on a tap on the pill, or on Start', (
      tester,
    ) async {
      final h = await pumpSetup(tester);
      expect(h.flashcards.cardCalls, 0);

      await tester.tap(find.byKey(_pillKey));
      await tester.pumpAndSettle();
      expect(h.flashcards.cardCalls, 0);

      // Start pushes the study route and nothing else. The stub there reads no
      // provider, so a call here would be Setup's own.
      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();
      expect(h.flashcards.cardCalls, 0);
      expect(h.flashcards.gradeCalls, 0);
    });

    flashTest(
      'the lecture list is read from the cached tree: one tree request',
      (tester) async {
        await pumpSetup(tester);

        verify(() => catalog.getSubjectTree('sub-1')).called(1);
      },
    );
  });

  // ---------------------------------------------------------------------------
  group('the round position', () {
    final position = flashcardRoundPositionProvider('lec-1');

    flashTest('stays alive while Setup is mounted, including under the study '
        'route', (tester) async {
      final h = await pumpSetup(tester);

      h.container.read(position.notifier).moveTo('cursor-2');
      // Long enough for an unlistened autoDispose provider to be gone.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(h.container.read(position), 'cursor-2');

      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();
      expect(h.location, _studyPath);
      expect(h.container.read(position), 'cursor-2');

      h.router.pop();
      await tester.pumpAndSettle();
      expect(h.container.read(position), 'cursor-2');
    });

    flashTest('is dropped once Setup is popped', (tester) async {
      final h = await pumpSetup(tester);
      h.container.read(position.notifier).moveTo('cursor-2');
      await tester.pump(const Duration(seconds: 1));
      expect(h.container.exists(position), isTrue);

      h.router.pop();
      await tester.pumpAndSettle();
      expect(find.byType(FlashcardSetupScreen), findsNothing);
      await tester.pump(const Duration(seconds: 1));

      expect(h.container.exists(position), isFalse);
    });

    flashTest('is held while the tree is still loading and after it fails', (
      tester,
    ) async {
      final gate = Completer<SubjectTree>();
      when(() => catalog.getSubjectTree(any())).thenAnswer((_) => gate.future);
      final h = await pumpSetup(tester);

      h.container.read(position.notifier).moveTo('cursor-3');
      await tester.pump(const Duration(seconds: 1));
      expect(h.container.read(position), 'cursor-3');

      gate.completeError(const ApiException(status: 500, code: 'internal'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(h.container.read(position), 'cursor-3');
    });

    flashTest(
      'is per lecture: another lecture\'s Setup does not hold this one',
      (tester) async {
        final h = await pumpSetup(tester, lectureId: 'lec-3');
        h.container.read(position.notifier).moveTo('cursor-2');
        await tester.pump(const Duration(seconds: 1));

        // Setup for lec-3 is mounted, not lec-1: lec-1's position has no holder.
        expect(h.container.exists(position), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  group('geometry against the frame (402 wide)', () {
    flashTest('scope block, pill 20 in and 45 tall, helper 4 under, Start 60 '
        'under the helper and 60 tall', (tester) async {
      await pumpSetup(tester);

      final scope = tester.getRect(find.byKey(_scopeKey));
      final pill = tester.getRect(find.byKey(_pillKey));
      final helper = tester.getRect(find.byKey(_helperKey));
      final start = tester.getRect(find.byKey(_startKey));

      // The hairline block is full width; the content column starts 20 below it.
      expect(scope.left, 0);
      expect(scope.right, 402);
      expect(pill.top - scope.bottom, 20);

      expect(pill.height, 45);
      expect(pill.left, 20);
      expect(402 - pill.right, 20);

      expect(helper.top - pill.bottom, 4);
      expect(helper.left, 20);
      expect(402 - helper.right, 20);

      expect(start.top - helper.bottom, 60);
      expect(start.height, 60);
      expect(start.left, 20);
      expect(402 - start.right, 20);
    });

    flashTest('the caption sits 22 in and the heading under it', (
      tester,
    ) async {
      await pumpSetup(tester);

      final caption = tester.getTopLeft(find.text('Biology'));
      final heading = tester.getTopLeft(find.text('Upper Limb'));
      expect(caption.dx, 22);
      expect(heading.dx, 22);
      expect(heading.dy, greaterThan(caption.dy));
    });

    flashTest('the pill has the frame\'s radius 10, 0.5 hairline and centred '
        'h3 label', (tester) async {
      await pumpSetup(tester);

      final decoration = pillDecoration(tester);
      expect(decoration.borderRadius, BorderRadius.circular(10));
      final border = decoration.border! as Border;
      expect(border.top.width, 0.5);
      expect(border.left.width, 0.5);
      expect(border.right.width, 0.5);
      expect(border.bottom.width, 0.5);

      final label = tester.widget<Text>(find.text('12 Flash Cards'));
      expect(label.textAlign, TextAlign.center);
      expect(label.style!.fontSize, AppType.h3.fontSize);
      // Centred on the pill.
      final pill = tester.getRect(find.byKey(_pillKey));
      final text = tester.getRect(find.text('12 Flash Cards'));
      expect((text.center.dx - pill.center.dx).abs(), lessThan(0.5));
      expect((text.center.dy - pill.center.dy).abs(), lessThan(0.5));
    });

    flashTest('the helper is start-aligned, in AR too', (tester) async {
      /// The horizontal extent of the helper's GLYPHS in screen space — the
      /// widget's own rect is the full column width whichever way it aligns.
      (double, double) extentOf(WidgetTester tester) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.byKey(_helperKey),
        );
        final boxes = paragraph.getBoxesForSelection(
          TextSelection(
            baseOffset: 0,
            extentOffset: paragraph.text.toPlainText().length,
          ),
        );
        double global(double x) => paragraph.localToGlobal(Offset(x, 0)).dx;
        return (
          boxes.map((b) => global(b.left)).reduce((a, b) => a < b ? a : b),
          boxes.map((b) => global(b.right)).reduce((a, b) => a > b ? a : b),
        );
      }

      await pumpSetup(tester);
      expect(extentOf(tester).$1, 20);
      await unmount(tester);

      await pumpSetup(tester, locale: 'ar');
      expect(extentOf(tester).$2, 402 - 20);
    });
  });

  // ---------------------------------------------------------------------------
  group('light and dark', () {
    flashTest('light: the pill and helper wear the light tokens', (
      tester,
    ) async {
      await pumpSetup(tester);
      final ext = colorsOf(tester);

      expect(
        ext.flashcardSetupPillFill,
        AppColors.light.flashcardSetupPillFill,
      );
      final decoration = pillDecoration(tester);
      expect(decoration.color, AppColors.light.flashcardSetupPillFill);
      expect(
        (decoration.border! as Border).top.color,
        AppColors.light.flashcardSetupPillBorder,
      );
      expect(
        tester.widget<Text>(find.text('12 Flash Cards')).style!.color,
        AppColors.light.flashcardSetupPillText,
      );
      expect(
        tester.widget<Text>(find.byKey(_helperKey)).style!.color,
        AppColors.light.flashcardSetupHelper,
      );
    });

    flashTest('dark: the stand-in tokens, not the light ones', (tester) async {
      await pumpSetup(tester, theme: AppTheme.dark);

      final decoration = pillDecoration(tester);
      expect(decoration.color, AppColors.dark.flashcardSetupPillFill);
      expect(
        (decoration.border! as Border).top.color,
        AppColors.dark.flashcardSetupPillBorder,
      );
      expect(
        tester.widget<Text>(find.text('12 Flash Cards')).style!.color,
        AppColors.dark.flashcardSetupPillText,
      );
      expect(
        tester.widget<Text>(find.byKey(_helperKey)).style!.color,
        AppColors.dark.flashcardSetupHelper,
      );
      // The two canvases really do differ, so the assertions above cannot pass
      // by reading one palette twice.
      expect(
        AppColors.dark.flashcardSetupPillFill,
        isNot(AppColors.light.flashcardSetupPillFill),
      );
      expect(
        AppColors.dark.flashcardSetupHelper,
        isNot(AppColors.light.flashcardSetupHelper),
      );
    });

    flashTest('dark reuses the quiz setup\'s scope colours', (tester) async {
      await pumpSetup(tester, theme: AppTheme.dark);

      expect(
        tester.widget<Text>(find.text('Biology')).style!.color,
        AppColors.dark.quizSetupSubject,
      );
      expect(
        tester.widget<Text>(find.text('Upper Limb')).style!.color,
        AppColors.dark.quizSetupScope,
      );
    });

    flashTest('dark Arabic builds from the same layout', (tester) async {
      await pumpSetup(tester, theme: AppTheme.dark, locale: 'ar');

      final pill = tester.getRect(find.byKey(_pillKey));
      expect(pill.height, 45);
      expect(pill.left, 20);
      expect(find.text('12 فلاش كارد'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  group('Arabic mirrors', () {
    flashTest('the back chip is at the right, the caption 22 in from the '
        'right', (tester) async {
      await pumpSetup(tester, locale: 'ar');

      final chip = tester.getRect(find.byKey(_backKey));
      expect(chip.right, 402 - 20);
      expect(chip.left, greaterThan(402 / 2));

      expect(tester.getTopRight(find.text('Biology')).dx, 402 - 22);
      expect(tester.getTopRight(find.text('Upper Limb')).dx, 402 - 22);
    });

    // BUG-020: both lines are content (adr-018), in either language whatever
    // the app's. Each keeps its own direction, so a closing mark stays at the
    // end of its name, and still starts at the app's side.
    flashTest('English names in Arabic keep their own direction, still at '
        'the right', (tester) async {
      const subject = 'Programming in C++';
      const lecture = 'What is a cell?';
      when(
        catalog.getSubjects,
      ).thenAnswer((_) async => [subjects().first.copyWith(name: subject)]);
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(
          lectures: [
            lectureJson(
              id: 'lec-1',
              name: lecture,
              hasFlashcards: true,
              flashcardCount: 24,
            ),
          ],
        ),
      );
      await pumpSetup(tester, locale: 'ar');

      for (final line in [subject, lecture]) {
        expectReadingOrder(
          tester.renderObject<RenderParagraph>(find.text(line)),
          line,
          TextDirection.ltr,
        );
        expect(tester.getTopRight(find.text(line)).dx, 402 - 22);
      }
    });

    flashTest('Arabic names in English keep their own direction, still at '
        'the left', (tester) async {
      const subject = 'التشريح.';
      const lecture = 'مقدمة في علم التشريح.';
      when(
        catalog.getSubjects,
      ).thenAnswer((_) async => [subjects().first.copyWith(name: subject)]);
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(
          lectures: [
            lectureJson(
              id: 'lec-1',
              name: lecture,
              hasFlashcards: true,
              flashcardCount: 24,
            ),
          ],
        ),
      );
      await pumpSetup(tester);

      for (final line in [subject, lecture]) {
        expectReadingOrder(
          tester.renderObject<RenderParagraph>(find.text(line)),
          line,
          TextDirection.rtl,
        );
        expect(tester.getTopLeft(find.text(line)).dx, 22);
      }
    });

    // A wrapped name shows the alignment: it stays the app's start, whatever
    // the name's own direction.
    for (final (locale, name, side) in [
      ('ar', 'Introduction to the upper limb and its muscles', 'right'),
      ('en', 'مقدمة في الطرف العلوي وعضلاته ومفاصله وأعصابه', 'left'),
    ]) {
      flashTest('$locale: a wrapped name in the other language keeps the '
          'app\'s start, every line at the $side', (tester) async {
        when(() => catalog.getSubjectTree(any())).thenAnswer(
          (_) async => universityTree(
            lectures: [
              lectureJson(
                id: 'lec-1',
                name: name,
                hasFlashcards: true,
                flashcardCount: 24,
              ),
            ],
          ),
        );
        await pumpSetup(tester, locale: locale);

        final p = tester.renderObject<RenderParagraph>(find.text(name));
        final lines = expectReadingOrder(
          p,
          name,
          locale == 'ar' ? TextDirection.ltr : TextDirection.rtl,
        );
        expect(lines, greaterThan(1));
        // Each line's ink, by line: its outer edge on the app's start side.
        final edges = <double, double>{};
        for (var i = 0; i < name.length; i++) {
          if (name[i].trim().isEmpty) continue;
          for (final box in p.getBoxesForSelection(
            TextSelection(baseOffset: i, extentOffset: i + 1),
          )) {
            final edge = side == 'right' ? box.right : box.left;
            edges.update(
              box.top,
              (e) => side == 'right'
                  ? (e > edge ? e : edge)
                  : (e < edge ? e : edge),
              ifAbsent: () => edge,
            );
          }
        }
        expect(edges.length, lines);
        for (final edge in edges.values) {
          expect(
            edge,
            moreOrLessEquals(side == 'right' ? p.size.width : 0, epsilon: 0.01),
          );
        }
      });
    }

    flashTest('EN: the back chip is at the left', (tester) async {
      await pumpSetup(tester);

      final chip = tester.getRect(find.byKey(_backKey));
      expect(chip.left, 20);
    });

    flashTest('the back chip pops Setup', (tester) async {
      final h = await pumpSetup(tester);

      await tester.tap(find.byKey(_backKey));
      await tester.pumpAndSettle();

      expect(h.location, '/');
      expect(find.text('root stand-in'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  group('loading, error, offline and scope', () {
    flashTest('loading shows skeleton blocks in the frame\'s places, no '
        'controls', (tester) async {
      final gate = Completer<SubjectTree>();
      when(() => catalog.getSubjectTree(any())).thenAnswer((_) => gate.future);
      await pumpSetup(tester);

      // The header and back chip do not wait for the tree.
      expect(find.text('Flash Card Setup'), findsOneWidget);
      expect(find.byKey(_backKey), findsOneWidget);
      expect(find.byType(CatalogBlock), findsWidgets);
      expect(find.byKey(_startKey), findsNothing);
      expect(find.byKey(_pillKey), findsNothing);
      expect(find.byType(FilledButton), findsNothing);

      gate.complete(universityTree());
      await tester.pumpAndSettle();

      expect(find.byType(CatalogBlock), findsNothing);
      expect(find.text('12 Flash Cards'), findsOneWidget);
    });

    flashTest(
      'a generic failure shows the message and a Retry that refetches',
      (tester) async {
        var calls = 0;
        when(() => catalog.getSubjectTree(any())).thenAnswer((_) async {
          if (calls++ == 0) {
            throw const ApiException(status: 500, code: 'internal');
          }
          return universityTree();
        });
        await pumpSetup(tester);

        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.byKey(_startKey), findsNothing);

        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        expect(calls, 2);
        expect(find.text('12 Flash Cards'), findsOneWidget);
        expect(find.text('Something went wrong'), findsNothing);
      },
    );

    flashTest('a failure reads in Arabic too', (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => throw const ApiException(status: 500, code: 'internal'),
      );
      await pumpSetup(tester, locale: 'ar');

      expect(find.text('حدث خطأ ما'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    flashTest('a network failure is the offline view, with Retry', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => throw const NetworkException());
      await pumpSetup(tester);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byKey(_startKey), findsNothing);
    });

    flashTest('a pending deletion says so and offers no Retry', (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => throw const ApiException(
          status: 403,
          code: 'account_pending_deletion',
        ),
      );
      await pumpSetup(tester);

      expect(
        find.text(
          'Your account is scheduled for deletion. Cancel the request to use '
          'Level Up again.',
        ),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
    });

    flashTest('a school tree is refused with the scope message and no Retry', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => schoolTree());
      final h = await pumpSetup(tester);

      expect(
        find.text('This content isn\'t part of your course.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
      expect(find.byKey(_startKey), findsNothing);
      expect(find.byKey(_pillKey), findsNothing);
      // The header and back chip are still there to leave by.
      expect(find.text('Flash Card Setup'), findsOneWidget);
      await tester.tap(find.byKey(_backKey));
      await tester.pumpAndSettle();
      expect(h.location, '/');
    });

    flashTest('a lecture that is not in the tree is refused the same way', (
      tester,
    ) async {
      await pumpSetup(tester, lectureId: 'no-such-lecture');

      expect(
        find.text('This content isn\'t part of your course.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
      expect(find.byKey(_startKey), findsNothing);
    });

    flashTest('the scope message reads in Arabic', (tester) async {
      await pumpSetup(tester, locale: 'ar', lectureId: 'no-such-lecture');

      expect(find.text('هذا المحتوى ليس ضمن مقررك.'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsNothing);
    });

    flashTest('a refused subject id (403) is the catalog\'s no-Retry copy', (
      tester,
    ) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async =>
            throw const ApiException(status: 403, code: 'insufficient_scope'),
      );
      await pumpSetup(tester);

      expect(
        find.text('This subject isn\'t part of your course.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
    });

    flashTest('offline with a loaded tree: banner, pill still shown', (
      tester,
    ) async {
      await pumpSetup(tester, online: false);

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.text('12 Flash Cards'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // The REAL router: both paths, inside the nav shell, over the right stack.
  group('routes (real router)', () {
    Future<(ProviderContainer, _CountingFlashcardsRepository)> pumpApp(
      WidgetTester tester, {
      String locale = 'en',
    }) async {
      final storage = MockSecureStorage();
      when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
      when(() => storage.clearTokens()).thenAnswer((_) async {});
      final profile = MockProfileRepository();
      when(profile.getMe).thenAnswer((_) async => universityProfile());
      when(profile.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
      final flashcards = _CountingFlashcardsRepository();

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          profileRepositoryProvider.overrideWithValue(profile),
          leaderboardRepositoryProvider.overrideWithValue(
            QuietLeaderboardRepository(),
          ),
          catalogRepositoryProvider.overrideWithValue(catalog),
          flashcardsRepositoryProvider.overrideWithValue(flashcards),
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
      return (container, flashcards);
    }

    /// Two nav-bar facts at once: the shell is on screen, and it is on Learn.
    void expectNavBar(WidgetTester tester) {
      expect(find.byType(MainShell), findsOneWidget);
      expect(find.text('Learn'), findsOneWidget);
    }

    flashTest('the setup path builds Setup with the nav bar', (tester) async {
      final (container, _) = await pumpApp(tester);
      final router = container.read(routerProvider);

      router.go(_setupPath);
      await tester.pumpAndSettle();

      final screen = tester.widget<FlashcardSetupScreen>(
        find.byType(FlashcardSetupScreen),
      );
      expect(screen.subjectId, 'sub-1');
      expect(screen.lectureId, 'lec-1');
      expect(locationOf(container), _setupPath);
      expect(find.text('12 Flash Cards'), findsOneWidget);
      expect(find.text('Biology'), findsOneWidget);
      expectNavBar(tester);
      expect(find.byType(FlashcardStudyScreen), findsNothing);
      // A cold link has nothing cached, so it fetches — once.
      verify(() => catalog.getSubjectTree('sub-1')).called(1);
    });

    flashTest('the study path builds the study screen over Setup, nav bar '
        'kept', (tester) async {
      final (container, _) = await pumpApp(tester);
      final router = container.read(routerProvider);

      router.go(_studyPath);
      await tester.pumpAndSettle();

      final screen = tester.widget<FlashcardStudyScreen>(
        find.byType(FlashcardStudyScreen),
      );
      expect(screen.subjectId, 'sub-1');
      expect(screen.lectureId, 'lec-1');
      expect(locationOf(container), _studyPath);
      expectNavBar(tester);

      // The stack under it is Setup, then the subject, so "back" walks the
      // student out the way they came in.
      router.pop();
      await tester.pumpAndSettle();
      expect(locationOf(container), _setupPath);
      expect(find.byType(FlashcardSetupScreen), findsOneWidget);
      expectNavBar(tester);

      router.pop();
      await tester.pumpAndSettle();
      expect(locationOf(container), '/learn/subject/sub-1');
      expect(find.byType(SubjectTreeScreen), findsOneWidget);
    });

    flashTest('the ids come from the path: another lecture, another '
        'subject', (tester) async {
      final (container, _) = await pumpApp(tester);
      final router = container.read(routerProvider);

      router.go('/learn/subject/sub-1/lecture/lec-3/flashcards');
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<FlashcardSetupScreen>(find.byType(FlashcardSetupScreen))
            .lectureId,
        'lec-3',
      );
      expect(find.text('Thorax'), findsOneWidget);
      expect(find.text('5 Flash Cards'), findsOneWidget);
    });

    flashTest('Learn → subject → Flashcard tab → lecture → Setup → Start → '
        'study, and back the same way', (tester) async {
      final (container, _) = await pumpApp(tester);

      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Flashcard'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Upper Limb'));
      await tester.pumpAndSettle();

      expect(locationOf(container), _setupPath);
      expect(find.byType(FlashcardSetupScreen), findsOneWidget);
      expect(find.text('12 Flash Cards'), findsOneWidget);
      expectNavBar(tester);

      await tester.tap(find.byKey(_startKey));
      await tester.pumpAndSettle();
      expect(locationOf(container), _studyPath);
      expect(find.byType(FlashcardStudyScreen), findsOneWidget);
      expectNavBar(tester);

      container.read(routerProvider).pop();
      await tester.pumpAndSettle();
      expect(locationOf(container), _setupPath);

      await tester.tap(find.byKey(_backKey));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/learn/subject/sub-1');
      expect(find.byType(FlashcardSetupScreen), findsNothing);

      // The subject screen fetched the tree; Setup, the study route and the way
      // back only read it. (Verified once, at the end: mocktail consumes a call
      // it has verified.)
      verify(() => catalog.getSubjectTree('sub-1')).called(1);
    });

    flashTest('the school children of the subject route still resolve', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => schoolTree());
      final (container, _) = await pumpApp(tester);

      container
          .read(routerProvider)
          .go('/learn/subject/sub-1/unit/unit-1/chapter/chap-1');
      await tester.pumpAndSettle();

      expect(find.text('Cell Structure'), findsOneWidget);
      expect(find.byType(FlashcardSetupScreen), findsNothing);
    });
  });
}
