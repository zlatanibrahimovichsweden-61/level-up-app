import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/catalog/screens/lectures_screen.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/screens/units_screen.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_scaffold.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/catalog/widgets/quiz_type_tabs.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// University Learn · Figma `180:5208`, driven through the REAL router.
///
/// The structural claim under test: **one route serves both tracks.**
/// `/learn/subject/:subjectId` loads the tree and switches on the contract's
/// `track` discriminator — it never consults the student's profile, so a
/// mis-scoped server response could not silently render the wrong screen.
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => universityTree());
  });

  /// Learn → Biology. On a university tree that lands on Lectures.
  Future<void> openSubject(
    WidgetTester tester, {
    String name = 'Biology',
  }) async {
    await openLearnTab(tester);
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  group('the one route branches on the tree, not on the profile', () {
    testWidgets('a university tree renders Lectures', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(SubjectTreeScreen), findsOneWidget);
      expect(find.byType(LecturesView), findsOneWidget);
      expect(find.byType(UnitsView), findsNothing);
      expect(find.text('Upper Limb'), findsOneWidget);
      expect(find.text('Thorax'), findsOneWidget);
    });

    testWidgets('a school tree renders Units from the SAME route', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => schoolTree());

      await pumpCatalogApp(tester, catalog: catalog);
      await openSubject(tester);

      expect(find.byType(UnitsView), findsOneWidget);
      expect(find.byType(LecturesView), findsNothing);
      expect(find.text('Cell Biology'), findsOneWidget);
    });

    testWidgets(
      'the school profile does not force the school view — the payload decides',
      (tester) async {
        // Deliberately contradictory: a school student, a university tree. The
        // screen must follow the discriminator. (In production the server scopes
        // by token so this cannot happen — which is exactly why the client must
        // not be the one deciding.)
        await pumpCatalogApp(tester, catalog: catalog);
        await openSubject(tester);

        expect(find.byType(LecturesView), findsOneWidget);
      },
    );

    testWidgets(
      'university is FLAT — a lecture is the leaf, not a drill-down',
      (tester) async {
        await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
        await openSubject(tester);

        await tester.tap(find.text('Upper Limb'));
        await tester.pumpAndSettle();

        // Straight to the quiz hand-off; there is no chapter/lesson level.
        expect(find.byType(QuizSetupScreen), findsOneWidget);
      },
    );
  });

  group('title', () {
    testWidgets('is the subject name from the CACHED subjects list', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Biology Lectures'), findsOneWidget);
      // The name came from the list already in memory, not a second request.
      verify(catalog.getSubjects).called(1);
    });

    testWidgets('falls back to the bare title when the name is not cached', (
      tester,
    ) async {
      // The cold-deep-link case: the tree loads for a subject that is not in
      // the subjects list, so there is no name to title the header with. It must
      // degrade to "Lectures" rather than invent one.
      when(catalog.getSubjects).thenAnswer((_) async => []);

      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
      );
      container.read(routerProvider).go('/learn/subject/sub-unknown');
      await tester.pumpAndSettle();

      expect(find.byType(LecturesView), findsOneWidget);
      expect(find.text('Lectures'), findsOneWidget);
      expect(find.textContaining('Biology'), findsNothing);
    });

    testWidgets('Arabic titles it in Arabic, around the server copy', (
      tester,
    ) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        locale: 'ar',
      );
      await openLearnTab(tester, locale: 'ar');
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text('محاضرات Biology'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(LecturesView))),
        TextDirection.rtl,
      );
    });
  });

  group('quiz-type tabs', () {
    testWidgets('are built from tree.quizTypes, not a hardcoded five', (
      tester,
    ) async {
      // The fixture offers three of the four contract types.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Midterm'), findsOneWidget);
      expect(find.text('Final'), findsOneWidget);
      // Not offered by this subject → not drawn.
      expect(find.text('Practice'), findsNothing);
    });

    testWidgets('a subject offering one type shows exactly one tab', (
      tester,
    ) async {
      // No lecture has flashcards here, so the only tab is the quiz type. (With
      // flashcards the Flashcard tab would sit beside it — see the group
      // 'the Flashcard tab'.)
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(
          quizTypes: <String>['normal'],
          lectures: lecturesWithoutFlashcards(),
        ),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(QuizTypeTabs), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Midterm'), findsNothing);
      expect(find.text('Flashcard'), findsNothing);
    });

    testWidgets(
      'no quiz types and no flashcards → no tab row, and the list still renders',
      (tester) async {
        when(() => catalog.getSubjectTree(any())).thenAnswer(
          (_) async => universityTree(
            quizTypes: <String>[],
            lectures: lecturesWithoutFlashcards(),
          ),
        );

        await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
        await openSubject(tester);

        expect(find.byType(QuizTypeTabs), findsNothing);
        expect(find.byType(TreeListRow), findsNWidgets(3));
      },
    );

    testWidgets('selecting a tab does NOT re-fetch the tree', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await tester.tap(find.text('Final'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Midterm'));
      await tester.pumpAndSettle();

      // It is local UI state — it selects, it does not filter or reload.
      verify(() => catalog.getSubjectTree('sub-1')).called(1);
      expect(find.byType(TreeListRow), findsNWidgets(3));

      // The Flashcard tab is no different: it filters what is already loaded.
      // (`verify` above consumed the one legitimate call, so any further
      // `getSubjectTree` would be a NEW, unverified one.)
      await tester.tap(find.text('Flashcard'));
      await tester.pumpAndSettle();
      verifyNever(() => catalog.getSubjectTree(any()));
    });

    testWidgets('Arabic labels the tabs in Arabic', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        locale: 'ar',
      );
      await openLearnTab(tester, locale: 'ar');
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text('عادي'), findsOneWidget);
      expect(find.text('منتصف الترم'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  /// The Lectures "Flashcard" tab · owner rulings 2026-09-29 · DESIGN_ISSUES #18.
  ///
  /// Students open Flashcards through this tab. It is NOT a quiz type — the
  /// contract's `quizTypes` enum is closed and has no such value — so it is a
  /// `FlashcardsTab` beside the `QuizTab`s, and `QuizType` must stay four long.
  group('the Flashcard tab', () {
    const allFour = <String>[
      'normal',
      'midTermRevision',
      'finalRevision',
      'practicalRevision',
    ];

    /// The visible tab captions, in on-screen left-to-right order.
    List<String> tabOrder(WidgetTester tester, List<String> candidates) {
      final found = <(double, String)>[
        for (final label in candidates)
          if (find.text(label).evaluate().isNotEmpty)
            (tester.getRect(find.text(label)).center.dx, label),
      ]..sort((a, b) => a.$1.compareTo(b.$1));
      return [for (final (_, label) in found) label];
    }

    Future<void> openFlashcardTab(WidgetTester tester) async {
      await tester.tap(find.text('Flashcard'));
      await tester.pumpAndSettle();
    }

    test('is not a quiz type — the contract enum is closed', () {
      expect(QuizType.values.map((t) => t.name), isNot(contains('flashcard')));
      expect(QuizType.values, hasLength(4));
    });

    testWidgets('sits SECOND when any lecture has flashcards', (tester) async {
      // Normal · Flashcard · Midterm · Final — 180:5208 / 349:15962 / 337:11059.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Flashcard'), findsOneWidget);
      expect(tabOrder(tester, ['Normal', 'Flashcard', 'Midterm', 'Final']), [
        'Normal',
        'Flashcard',
        'Midterm',
        'Final',
      ]);
    });

    testWidgets(
      'all four quiz types → the design\'s five pills, in its order',
      (tester) async {
        when(
          () => catalog.getSubjectTree(any()),
        ).thenAnswer((_) async => universityTree(quizTypes: allFour));
        await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
        await openSubject(tester);

        expect(
          tabOrder(tester, [
            'Normal',
            'Flashcard',
            'Midterm',
            'Final',
            'Practice',
          ]),
          ['Normal', 'Flashcard', 'Midterm', 'Final', 'Practice'],
        );
      },
    );

    testWidgets('is HIDDEN when no lecture in the subject has flashcards', (
      tester,
    ) async {
      // The contract: "a faculty whose whole tree returns false ... the surface
      // should not be offered at all".
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(lectures: lecturesWithoutFlashcards()),
      );
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Flashcard'), findsNothing);
      expect(find.byType(QuizTypeTabs), findsOneWidget);
      // The quiz tabs are exactly what they were.
      expect(tabOrder(tester, ['Normal', 'Midterm', 'Final']), [
        'Normal',
        'Midterm',
        'Final',
      ]);
    });

    testWidgets('one lecture with cards is enough to offer it', (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(
          lectures: [
            ...lecturesWithoutFlashcards(),
            lectureJson(
              id: 'lec-9',
              name: 'Pelvis',
              hasFlashcards: true,
              flashcardCount: 1,
            ),
          ],
        ),
      );
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Flashcard'), findsOneWidget);
      await openFlashcardTab(tester);
      expect(find.byType(TreeListRow), findsOneWidget);
      expect(find.text('Pelvis'), findsOneWidget);
    });

    testWidgets('a subject with no quiz types but flashcards shows it ALONE', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree(quizTypes: <String>[]));
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(QuizTypeTabs), findsOneWidget);
      expect(find.text('Flashcard'), findsOneWidget);
      expect(find.text('Normal'), findsNothing);
      // ...and it is the tab in force: the default quiz type is not in this
      // row, so the list is the Flashcard list — the two lectures with cards,
      // no bars — not a quiz list under a pill nobody selected.
      expect(
        tester.widget<QuizTypeTabs>(find.byType(QuizTypeTabs)).selected,
        const FlashcardsTab(),
      );
      expect(find.byType(TreeListRow), findsNWidgets(2));
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.text('Lower Limb'), findsNothing);
    });

    testWidgets('the default selection is unchanged — Normal, with every '
        'lecture and its bar', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(TreeListRow), findsNWidgets(3));
      expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
      expect(find.text('Lower Limb'), findsOneWidget);
    });

    testWidgets('selecting it lists ONLY lectures with cards, keeping their '
        'ORIGINAL numbers', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);
      await openFlashcardTab(tester);

      // Lower Limb (lec-2, hasFlashcards false) is hidden; Thorax stays "3",
      // not "2" — its number must match its number on the quiz tabs.
      expect(find.text('Lower Limb'), findsNothing);
      final rows = tester
          .widgetList<TreeListRow>(find.byType(TreeListRow))
          .toList();
      expect(rows.map((r) => r.name), ['Upper Limb', 'Thorax']);
      expect(rows.map((r) => r.index), [1, 3]);
      for (final row in rows) {
        expect(row.onTap, isNotNull, reason: '${row.name} is not tappable');
      }
    });

    testWidgets('its rows carry NO progress bar and NO caption — the contract '
        'has no flashcard progress', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);
      await openFlashcardTab(tester);

      for (final row in tester.widgetList<TreeListRow>(
        find.byType(TreeListRow),
      )) {
        expect(row.progress, isNull, reason: row.name);
        expect(row.caption, isNull, reason: row.name);
        expect(row.countLabel, isNull, reason: row.name);
      }
      expect(
        find.descendant(
          of: find.byType(TreeListRow),
          matching: find.byType(LinearProgressIndicator),
        ),
        findsNothing,
      );
      // ...and no "{answered} / {total} questions" readout either.
      expect(find.textContaining('questions'), findsNothing);
      // flashcardCount is informational, not a progress number, so it is not
      // dressed up as one.
      expect(find.text('12'), findsNothing);
    });

    testWidgets('going back to a quiz tab restores every lecture and its '
        'bar', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await openFlashcardTab(tester);
      expect(find.byType(TreeListRow), findsNWidgets(2));

      await tester.tap(find.text('Midterm'));
      await tester.pumpAndSettle();
      expect(find.byType(TreeListRow), findsNWidgets(3));
      expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
      expect(find.text('0 / 60 questions'), findsOneWidget);
    });

    testWidgets('is selected in semantics — exactly one segment at a time', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      Set<String> selectedLabels() => tester
          .widgetList<Semantics>(
            find.descendant(
              of: find.byType(QuizTypeTabs),
              matching: find.byType(Semantics),
            ),
          )
          .where((s) => s.properties.selected ?? false)
          .map((s) => s.properties.label!)
          .toSet();

      expect(selectedLabels(), {'Normal'});
      await openFlashcardTab(tester);
      expect(selectedLabels(), {'Flashcard'});
    });

    testWidgets('a quiz tab picked AFTER visiting Flashcard is the one handed '
        'to /quiz/setup', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await openFlashcardTab(tester);
      await tester.tap(find.text('Final'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lower Limb'));
      await tester.pumpAndSettle();

      final screen = tester.widget<QuizSetupScreen>(
        find.byType(QuizSetupScreen),
      );
      expect(screen.args.quizType, QuizType.finalRevision);
      expect(screen.args.lectureId, 'lec-2');
    });

    testWidgets('the route hands LecturesView the subject id it was opened '
        'with', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(
        tester.widget<LecturesView>(find.byType(LecturesView)).subjectId,
        'sub-1',
      );
    });

    testWidgets('Arabic: label is فلاش كارد, second from the START, and the '
        'rows mirror', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        locale: 'ar',
      );
      await openLearnTab(tester, locale: 'ar');
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text('فلاش كارد'), findsOneWidget);
      expect(find.text('Flashcard'), findsNothing);

      // RTL: Normal at the right edge, Flashcard immediately to its left, then
      // Midterm. The primitive gets this from `Row` + `Directionality`.
      final normal = tester.getRect(find.text('عادي')).center.dx;
      final flash = tester.getRect(find.text('فلاش كارد')).center.dx;
      final mid = tester.getRect(find.text('منتصف الترم')).center.dx;
      expect(normal, greaterThan(flash));
      expect(flash, greaterThan(mid));

      await tester.tap(find.text('فلاش كارد'));
      await tester.pumpAndSettle();

      // The row mirrors: the number badge leads (right), the name follows it,
      // and the chevron trails (left).
      final rows = find.byType(TreeListRow);
      expect(rows, findsNWidgets(2));
      final row = tester.getRect(rows.first);
      final badge = tester.getRect(find.text('1'));
      final name = tester.getRect(find.text('Upper Limb'));
      expect(badge.center.dx, greaterThan(name.center.dx));
      expect(row.right - badge.right, lessThan(row.width / 4));
      expect(tester.widgetList<TreeListRow>(rows).map((r) => r.index), [1, 3]);
    });

    testWidgets('dark theme lists the same rows', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        theme: AppTheme.dark,
      );
      await openSubject(tester);
      await openFlashcardTab(tester);

      expect(find.byType(TreeListRow), findsNWidgets(2));
      expect(find.text('Thorax'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Navigation, and a selection the row can no longer show. These pump
    // `LecturesView` on its own under a stand-in router: the destination route
    // is owned by the flashcards feature, and the assertion here is only WHERE
    // a tap goes, which must not depend on what is built there.
    group('on its own', () {
      /// `tree` is a notifier so a test can hand the SAME `LecturesView` state a
      /// reloaded tree, the way `subjectTreeProvider.refresh()` does.
      Future<GoRouter> pumpLectures(
        WidgetTester tester, {
        required ValueNotifier<UniversitySubjectTree> tree,
        List<Map<String, String>>? flashcardArrivals,
        List<Object?>? quizArrivals,
      }) async {
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => Scaffold(
                body: ValueListenableBuilder<UniversitySubjectTree>(
                  valueListenable: tree,
                  builder: (_, value, _) => LecturesView(
                    subjectId: 'sub-1',
                    tree: value,
                    subjectName: 'Biology',
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/learn/subject/:subjectId/lecture/:lectureId/flashcards',
              builder: (_, state) {
                flashcardArrivals?.add(state.pathParameters);
                return const Scaffold(body: Text('flashcards stand-in'));
              },
            ),
            GoRoute(
              path: '/quiz/setup',
              builder: (_, state) {
                quizArrivals?.add(state.extra);
                return const Scaffold(body: Text('quiz setup stand-in'));
              },
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        await tester.pumpAndSettle();
        return router;
      }

      testWidgets('a row tap pushes exactly the lecture\'s flashcards path', (
        tester,
      ) async {
        final arrivals = <Map<String, String>>[];
        final router = await pumpLectures(
          tester,
          tree: ValueNotifier(universityTree()),
          flashcardArrivals: arrivals,
        );

        await tester.tap(find.text('Flashcard'));
        await tester.pumpAndSettle();
        // Selecting the tab navigates nowhere. `state.uri`, not
        // `currentConfiguration.uri`: the latter silently misses an imperative
        // push, which is what a row tap is.
        expect(router.state.uri.toString(), '/');

        await tester.tap(find.text('Thorax'));
        await tester.pumpAndSettle();

        expect(
          router.state.uri.toString(),
          '/learn/subject/sub-1/lecture/lec-3/flashcards',
        );
        expect(arrivals, [
          {'subjectId': 'sub-1', 'lectureId': 'lec-3'},
        ]);
        expect(find.text('flashcards stand-in'), findsOneWidget);
      });

      testWidgets('a quiz tab row tap still goes to /quiz/setup, never the '
          'flashcards path', (tester) async {
        final flashcards = <Map<String, String>>[];
        final quizzes = <Object?>[];
        final router = await pumpLectures(
          tester,
          tree: ValueNotifier(universityTree()),
          flashcardArrivals: flashcards,
          quizArrivals: quizzes,
        );

        // A lecture that HAS cards, on the default (Normal) tab.
        await tester.tap(find.text('Upper Limb'));
        await tester.pumpAndSettle();

        expect(router.state.uri.toString(), '/quiz/setup');
        expect(flashcards, isEmpty);
        expect(quizzes, hasLength(1));
        final args = quizzes.single! as QuizSetupArgs;
        expect(args.lectureId, 'lec-1');
        expect(args.quizType, QuizType.normal);
      });

      testWidgets('a picked Flashcard tab falls back to Normal when a reloaded '
          'tree no longer offers it', (tester) async {
        final tree = ValueNotifier(universityTree());
        await pumpLectures(tester, tree: tree);
        await tester.tap(find.text('Flashcard'));
        await tester.pumpAndSettle();
        expect(find.byType(TreeListRow), findsNWidgets(2));

        // The same LecturesView state, handed a tree in which nothing has cards
        // any more. A selection the row can no longer show must not leave the
        // list on Flashcard while no pill is lit.
        tree.value = universityTree(lectures: lecturesWithoutFlashcards());
        await tester.pumpAndSettle();

        expect(find.text('Flashcard'), findsNothing);
        expect(find.byType(TreeListRow), findsNWidgets(3));
        expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
      });
    });
  });

  group('lecturesTabsFor', () {
    const three = [
      QuizType.normal,
      QuizType.midTermRevision,
      QuizType.finalRevision,
    ];

    test('inserts the Flashcard tab after the FIRST quiz type', () {
      expect(lecturesTabsFor(quizTypes: three, hasFlashcards: true), [
        const QuizTab(QuizType.normal),
        const FlashcardsTab(),
        const QuizTab(QuizType.midTermRevision),
        const QuizTab(QuizType.finalRevision),
      ]);
    });

    test('adds nothing when no lecture has flashcards', () {
      expect(lecturesTabsFor(quizTypes: three, hasFlashcards: false), [
        for (final type in three) QuizTab(type),
      ]);
    });

    test('is the Flashcard tab alone when there are no quiz types', () {
      expect(lecturesTabsFor(quizTypes: const [], hasFlashcards: true), [
        const FlashcardsTab(),
      ]);
      expect(
        lecturesTabsFor(quizTypes: const [], hasFlashcards: false),
        isEmpty,
      );
    });

    test('keeps the server order of the quiz types', () {
      expect(
        lecturesTabsFor(
          quizTypes: const [QuizType.finalRevision, QuizType.normal],
          hasFlashcards: true,
        ),
        [
          const QuizTab(QuizType.finalRevision),
          const FlashcardsTab(),
          const QuizTab(QuizType.normal),
        ],
      );
    });

    test('tabs compare by value — SegmentedTrack selects with ==', () {
      expect(const QuizTab(QuizType.normal), const QuizTab(QuizType.normal));
      expect(
        const QuizTab(QuizType.normal),
        isNot(const QuizTab(QuizType.finalRevision)),
      );
      expect(const FlashcardsTab(), const FlashcardsTab());
      expect(const FlashcardsTab(), isNot(const QuizTab(QuizType.normal)));
      expect(
        const QuizTab(QuizType.normal).hashCode,
        const QuizTab(QuizType.normal).hashCode,
      );
      expect(const FlashcardsTab().hashCode, const FlashcardsTab().hashCode);
    });
  });

  group('lecture rows', () {
    testWidgets('are numbered 1..n with a bar from their own counter', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      final rows = tester.widgetList<TreeListRow>(find.byType(TreeListRow));
      expect(rows.map((r) => r.index), [1, 2, 3]);

      final bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();
      expect(bars, hasLength(3));
      expect(bars[0].value, 0.0); // 0 / 60
      expect(bars[1].value, closeTo(0.5, 0.001)); // 30 / 60
      expect(bars[2].value, 1.0); // 45 / 45

      // Same label format as school's lessons — one wording across both tracks.
      expect(find.text('0 / 60 questions'), findsOneWidget);
      expect(find.text('45 / 45 questions'), findsOneWidget);
    });

    testWidgets('the counter never disables or hides a lecture', (
      tester,
    ) async {
      // Contract: it "never locks retakes". A 0/60 lecture and a finished 45/45
      // one must both render AND both be tappable.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(TreeListRow), findsNWidgets(3));
      for (final row in tester.widgetList<TreeListRow>(
        find.byType(TreeListRow),
      )) {
        expect(row.onTap, isNotNull, reason: '${row.name} is not tappable');
      }

      // Prove it on the FINISHED one by actually opening it.
      await tester.tap(find.text('Thorax'));
      await tester.pumpAndSettle();
      expect(find.byType(QuizSetupScreen), findsOneWidget);
    });

    testWidgets('row numbers go through the locale, not string interpolation', (
      tester,
    ) async {
      // `MaterialLocalizations.formatDecimal`, not '${index + 1}'. Flutter's
      // Arabic data formats with Latin digits, so that is what must render —
      // hardcoding Arabic-Indic glyphs would be overriding the locale, and
      // whether Egyptian students should see ٠١٢ is a design question, not a
      // client one. See docs/DESIGN_ISSUES.md #19.
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        locale: 'ar',
      );
      await openLearnTab(tester, locale: 'ar');
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          MaterialLocalizations.of(
            tester.element(find.byType(LecturesView)),
          ).formatDecimal(1),
        ),
        findsOneWidget,
      );
      expect(find.byType(TreeListRow), findsNWidgets(3));
    });

    testWidgets('dark theme renders the same content', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        theme: AppTheme.dark,
      );
      await openSubject(tester);

      expect(find.byType(TreeListRow), findsNWidgets(3));
      expect(find.text('Upper Limb'), findsOneWidget);
    });
  });

  group('the /quiz/setup hand-off', () {
    testWidgets('carries lectureId, name, subject and the DEFAULT quiz type', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await tester.tap(find.text('Lower Limb'));
      await tester.pumpAndSettle();

      final screen = tester.widget<QuizSetupScreen>(
        find.byType(QuizSetupScreen),
      );
      expect(screen.args.lectureId, 'lec-2');
      expect(screen.args.scopeName, 'Lower Limb');
      // From the subjects list the student tapped through (API→UI Wave 11).
      expect(screen.args.subjectName, 'Biology');
      expect(screen.args.quizType, QuizType.normal);
      // School's field stays null — the two are mutually exclusive in the
      // contract's POST /quizzes.
      expect(screen.args.lessonId, isNull);
    });

    testWidgets('carries the SELECTED quiz type', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await tester.tap(find.text('Final'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Upper Limb'));
      await tester.pumpAndSettle();

      final screen = tester.widget<QuizSetupScreen>(
        find.byType(QuizSetupScreen),
      );
      expect(screen.args.quizType, QuizType.finalRevision);
      expect(screen.args.lectureId, 'lec-1');
    });

    testWidgets('falls back to normal when the subject omits it', (
      tester,
    ) async {
      // `normal` is the contract's own default for POST /quizzes.quizType, so
      // using it when the subject offers nothing is not an invented value.
      // Flashcard-free: a subject with no quiz types but with cards opens on
      // its one tab, Flashcard, whose rows lead to flashcards, not quiz setup.
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(
          quizTypes: <String>[],
          lectures: lecturesWithoutFlashcards(),
        ),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);
      await tester.tap(find.byType(TreeListRow).first);
      await tester.pumpAndSettle();

      final screen = tester.widget<QuizSetupScreen>(
        find.byType(QuizSetupScreen),
      );
      expect(screen.args.quizType, QuizType.normal);
    });
  });

  group('states', () {
    testWidgets('empty lectures get their OWN copy, not the school one', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree(lectures: <dynamic>[]));

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('No lectures yet'), findsOneWidget);
      expect(find.text('Nothing here yet'), findsNothing);
    });

    testWidgets('loading shows a row skeleton, not a bare spinner', (
      tester,
    ) async {
      final completer = Completer<SubjectTree>();
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) => completer.future);

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CatalogBlock), findsWidgets);
      // The track is not known yet, so the header shows the subject's own name
      // and guesses no noun — a university student must never see "Units" flash.
      expect(
        find.descendant(
          of: find.byType(CatalogHeader),
          matching: find.text('Biology'),
        ),
        findsOneWidget,
      );
      expect(find.text('Biology Units'), findsNothing);
      expect(find.text('Biology Lectures'), findsNothing);

      completer.complete(universityTree());
      await tester.pumpAndSettle();
      expect(find.text('Biology Lectures'), findsOneWidget);
    });

    testWidgets('error shows copy + a retry that re-requests', (tester) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) => Future<SubjectTree>.error(const UnknownException()));

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Something went wrong'), findsOneWidget);

      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree());
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Upper Limb'), findsOneWidget);
    });

    testWidgets('offline gets its own view, distinct from a generic error', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) => Future<SubjectTree>.error(const OfflineException()));

      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        online: false,
      );
      await openSubject(tester);

      expect(find.text('You are offline'), findsWidgets);
      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('403 insufficient_scope gets its own copy and NO retry', (
      tester,
    ) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) => Future<SubjectTree>.error(
          const ApiException(status: 403, code: 'insufficient_scope'),
        ),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(
        find.text("This subject isn't part of your course."),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  /// edit3.md #9 — the tabs became a `SegmentedTrack`.
  ///
  /// The chip row is gone and the segments are EQUAL WIDTH inside one groove,
  /// so a long label can no longer take just the space it wants. The first
  /// build resolved that by shrinking the label; the owner's 2026-09-19 ruling
  /// (`docs/DECISIONS.md` D-012) resolved it the other way — the label keeps
  /// its size and the GROOVE gives way, scrolling when it has to.
  ///
  /// The cases below pin that ruling on the real screen, with the real
  /// localised labels and the widest tab set the contract allows.
  group('the segmented track (edit3 #9)', () {
    /// The rendered segment boxes, in visual left-to-right order.
    List<Rect> segmentRects(WidgetTester tester) => tester
        .widgetList<Semantics>(
          find.descendant(
            of: find.byType(QuizTypeTabs),
            matching: find.byType(Semantics),
          ),
        )
        .where((s) => s.properties.inMutuallyExclusiveGroup ?? false)
        .map((s) => tester.getRect(find.byWidget(s)))
        .toList();

    testWidgets('one segment per server quiz type, all the same width', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      final rects = segmentRects(tester);
      expect(
        rects,
        hasLength(4),
        reason: 'the fixture lists three types, and two lectures have cards',
      );
      // Equal width to within a rounding pixel — `Expanded` divides the track.
      for (final r in rects) {
        expect(r.width, closeTo(rects.first.width, 1));
        expect(r.height, 44, reason: 'the frame is 44 tall');
      }
    });

    testWidgets('the labels take the READ tokens, not the old chip colours', (
      tester,
    ) async {
      // Read off the Properties panel 2026-09-19 (DESIGN_ISSUES #77). The idle
      // LIGHT value is the one that matters: `#384F47`, a dark green, where the
      // chips this replaced drew the grey `textSecondary` `#2C2C2C`. Had the
      // §7.6.2 fallback shipped, that grey would have been permanent.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      final light = AppTheme.light.extension<AppColors>()!;
      expect(light.pillTrackLabel, const Color(0xFF384F47));
      expect(light.pillTrackSelectedLabel, const Color(0xFFFCFBF9));
      expect(
        AppTheme.dark.extension<AppColors>()!.pillTrackLabel,
        const Color(0xFFFCFBF9),
      );

      // And the widget actually reads them: 'Normal' is idle here, 'Midterm'
      // is not selected either, so both carry the idle colour.
      expect(
        tester.widget<Text>(find.text('Midterm')).style!.color,
        light.pillTrackLabel,
      );
      expect(
        tester.widget<Text>(find.text('Normal')).style!.color,
        light.pillTrackSelectedLabel,
        reason: 'Normal is the selected segment on first load',
      );
    });

    testWidgets('tapping a segment SELECTS it, in semantics', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      Set<String> selectedLabels() => tester
          .widgetList<Semantics>(
            find.descendant(
              of: find.byType(QuizTypeTabs),
              matching: find.byType(Semantics),
            ),
          )
          .where((s) => s.properties.selected ?? false)
          .map((s) => s.properties.label!)
          .toSet();

      // Exactly one is selected at a time — the control is a radio group, and
      // `inMutuallyExclusiveGroup` is a promise a screen reader relies on.
      expect(selectedLabels(), {'Normal'});

      await tester.tap(find.text('Midterm'));
      await tester.pumpAndSettle();
      expect(selectedLabels(), {'Midterm'});
    });

    testWidgets('RTL orders the segments right-to-left', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        locale: 'ar',
      );
      await openLearnTab(tester, locale: 'ar');
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      // The FIRST server type must sit at the trailing (right) edge in Arabic.
      // The primitive gets this from `Row` + `Directionality`; the assertion
      // exists because "it is a Row" is exactly the kind of claim that stops
      // being true when someone reaches for `Positioned` later.
      final first = tester.getRect(find.text('عادي'));
      final second = tester.getRect(find.text('منتصف الترم'));
      expect(first.center.dx, greaterThan(second.center.dx));
    });

    /// **Run at a real phone width, with the WIDEST tab set.**
    ///
    /// The first version of these ran at the default 800 dp test surface with
    /// the fixture's three quiz types, and asserted the track's own geometry.
    /// It could not fail: `Expanded` fixes the segment widths and the
    /// primitive's `FittedBox(scaleDown)` guarantees no `RenderFlex` overflow
    /// at any width, so "no exception, track is 760 wide" is true however long
    /// a label is. It measured the test surface.
    ///
    /// What §7.6.4 actually asks is whether the longest labels FIT — and the
    /// case that matters is the one the fixture omits: a subject offering all
    /// FOUR contract quiz types, on a 375 dp phone, in Arabic. The tabs come
    /// from the server's `tree.quizTypes`, so four is a real payload.
    ///
    /// What these pin is the label's PAINTED size against its LAID-OUT size,
    /// which is the only place the scale-down is visible.
    const phone = Size(375, 800);

    /// The painted (post-`FittedBox`) and laid-out (pre-scale) heights of one
    /// label. `getRect` walks the ancestor transforms and so sees the scale;
    /// `getSize` is the unscaled box the text asked for.
    (double painted, double laid) glyph(WidgetTester tester, String label) => (
      tester.getRect(find.text(label)).height,
      tester.getSize(find.text(label)).height,
    );

    /// The text scale is applied AFTER the drill-down, on purpose.
    ///
    /// `SubjectCard` overflows its 89 dp box by 9.1 dp at 1.3x on a 375 dp
    /// phone — measured, and measured to be **exactly the same 9.1 dp at
    /// `HEAD` before this wave**, so it is the pre-existing item in
    /// `docs/RESPONSIVE.md`'s unapplied queue and not edit3's doing. Scaling
    /// the Subjects grid on the way past would drag that failure into a test
    /// about the tabs and make it impossible to tell the two apart.
    /// Errors raised while the text scale is applied, captured instead of
    /// being reported, so a test can assert WHICH ones happened.
    late List<String> scaledErrors;

    Future<void> openLectures(
      WidgetTester tester, {
      required String locale,
      required double scale,
      required List<String> quizTypes,
    }) async {
      await tester.binding.setSurfaceSize(phone);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree(quizTypes: quizTypes));

      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
        locale: locale,
      );
      await openLearnTab(tester, locale: locale);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      // Intercept rather than let the binding record them: the Lectures screen
      // has a KNOWN pre-existing overflow at this scale (see the caller), and
      // an unconsumed exception fails a widget test outright no matter what it
      // asserts. Captured here so the caller can prove it is only that one.
      scaledErrors = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (details) => scaledErrors.add(details.toString());
      addTearDown(() => FlutterError.onError = previous);

      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
    }

    const allFour = <String>[
      'normal',
      'midTermRevision',
      'finalRevision',
      'practicalRevision',
    ];

    for (final (locale, scale) in [
      ('en', 1.0),
      ('en', 1.3),
      ('ar', 1.0),
      ('ar', 1.3),
    ]) {
      testWidgets('$locale at text scale $scale: five tabs (four quiz types '
          '+ Flashcard) stay equal, and every label keeps its full size', (
        tester,
      ) async {
        await openLectures(
          tester,
          locale: locale,
          scale: scale,
          quizTypes: allFour,
        );

        // The Lectures screen already throws at `en` 1.3x on a 375 dp phone:
        // `TreeListRow`'s progress row (bar + caption) overflows by 7 and 20
        // dp. Measured at `HEAD` before this wave and again after it, the
        // exceptions are IDENTICAL in count and in kind — another unapplied
        // `docs/RESPONSIVE.md` item, not edit3's doing, and edit3 §10 does not
        // put that row's layout in scope.
        //
        // So the assertion is not "nothing threw" but "nothing NEW threw, and
        // nothing thrown came from the tabs" — which is the part this wave is
        // answerable for.
        for (final e in scaledErrors) {
          expect(
            e,
            contains('tree_list_row.dart'),
            reason: 'an overflow from outside TreeListRow belongs to edit3',
          );
        }
        expect(
          scaledErrors.where((e) => e.contains('segmented_track.dart')),
          isEmpty,
        );
        expect(
          scaledErrors.where((e) => e.contains('quiz_type_tabs.dart')),
          isEmpty,
        );

        final rects = segmentRects(tester);
        // Four quiz types plus the Flashcard tab: the widest row the contract
        // can produce, and the Figma frame's own five pills.
        expect(rects, hasLength(5));
        // Min/max, not first/last: the list is in WIDGET order, and in Arabic
        // the first segment is the rightmost one.
        final left = rects.map((r) => r.left).reduce(min);
        final right = rects.map((r) => r.right).reduce(max);
        // `>=`, not `closeTo`, and this is the D-012 change. The groove is
        // never NARROWER than the space it is given; when the labels do not
        // fit it is WIDER, and that overflow is scrollable rather than being
        // absorbed by shrinking the type.
        expect(right - left, greaterThanOrEqualTo(375 - 40 - 1));
        for (final r in rects) {
          expect(r.height, 44, reason: 'the frame keeps its 44 dp height');
          expect(r.width, closeTo(rects.first.width, 1));
        }

        // The ruling itself, per label: painted size == laid-out size.
        for (final label
            in locale == 'ar'
                ? const ['عادي', 'فلاش كارد', 'منتصف الترم', 'نهائي', 'عملي']
                : const [
                    'Normal',
                    'Flashcard',
                    'Midterm',
                    'Final',
                    'Practice',
                  ]) {
          final (painted, laid) = glyph(tester, label);
          expect(painted, closeTo(laid, 0.01), reason: '$label at $scale');
        }
      });
    }

    testWidgets('no label is scaled AT ALL — D-012', (tester) async {
      // This test used to read "only ever scaled DOWN, never up", and guarded
      // `BoxFit.scaleDown` against being loosened to `BoxFit.contain`. The
      // ruling removed the `FittedBox` outright, so the property to hold is now
      // the stronger one: no scale in either direction, on any label, in the
      // worst configuration this screen can be handed.
      await openLectures(tester, locale: 'ar', scale: 1.0, quizTypes: allFour);

      for (final label in [
        'عادي',
        'فلاش كارد',
        'منتصف الترم',
        'نهائي',
        'عملي',
      ]) {
        final (painted, laid) = glyph(tester, label);
        expect(painted, closeTo(laid, 0.01), reason: label);
      }
    });

    testWidgets(
      'the worst label keeps its full size, and the GROOVE gives way — #81',
      (tester) async {
        // ✅ The #81 ratchet, inverted by the ruling.
        //
        // It used to pin a defect in place: the Arabic "منتصف الترم" painted at
        // **10.2 dp** against a 16.0 dp layout box, held there so it could not
        // get worse while the owner decided. The decision came back on the side
        // of readability, so the same measurement now asserts that the shrink
        // is gone — same label, same width, same tab set.
        await openLectures(
          tester,
          locale: 'ar',
          scale: 1.0,
          quizTypes: allFour,
        );

        final (painted, laid) = glyph(tester, 'منتصف الترم');
        expect(laid, 16.0);
        expect(painted, 16.0, reason: 'painted 10.2 before D-012');

        // ...and the cost lands where the ruling says to put it: the groove is
        // wider than the phone and the overflow scrolls.
        //
        // ⚠️ WIDTHS HERE ARE THE TEST FONT'S, NOT INTER'S. The test binding
        // draws every glyph as a box of the font size, which is ~1.5x wider
        // than Inter at the same px — Figma reads "Normal" at 49 px where this
        // lays it out at 72. So this asserts that the fallback ENGAGES, not
        // where it engages on a device. Only a device pass settles that.
        final rects = segmentRects(tester);
        final span =
            rects.map((r) => r.right).reduce(max) -
            rects.map((r) => r.left).reduce(min);
        expect(span, greaterThan(375));

        // That the overflow is DRAGGABLE is asserted in the primitive's own
        // test, not here. Dragging inside this harness leaves a scroll offset
        // that the tear-down's surface reset has to correct after
        // `FlutterError.onError` has already been restored, which reports as a
        // failure after the test completed — harness noise, not a finding.
      },
    );

    testWidgets(
      'raising the text scale enlarges EVERY label, the worst included — #81',
      (tester) async {
        // The sharp end of #81, and the reason it was filed as an
        // accessibility defect rather than a cosmetic one: a student who set a
        // LARGER system text size used to get no change at all on this label
        // while the label beside it grew — a row with a 21 dp label next to a
        // 10 dp one. The fixed segment handed back exactly what the scale
        // added.
        await openLectures(
          tester,
          locale: 'ar',
          scale: 1.0,
          quizTypes: allFour,
        );
        final atOne = glyph(tester, 'منتصف الترم').$1;
        final shortAtOne = glyph(tester, 'عادي').$1;

        await openLectures(
          tester,
          locale: 'ar',
          scale: 1.3,
          quizTypes: allFour,
        );
        final atOneThree = glyph(tester, 'منتصف الترم').$1;
        final shortAtOneThree = glyph(tester, 'عادي').$1;

        expect(shortAtOneThree, greaterThan(shortAtOne));
        expect(atOneThree, greaterThan(atOne));
        // The same factor, which is what makes the row read as ONE type scale.
        // The old build's failure shows up here as 1.0 against 1.3.
        expect(atOneThree / atOne, closeTo(shortAtOneThree / shortAtOne, 0.01));
      },
    );
  });
}
