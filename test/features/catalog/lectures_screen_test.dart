import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/router/app_router.dart';
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
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_placeholder.dart';
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
    when(() => catalog.getSubjectTree(any()))
        .thenAnswer((_) async => universityTree());
  });

  /// Learn → Biology. On a university tree that lands on Lectures.
  Future<void> openSubject(WidgetTester tester, {String name = 'Biology'}) async {
    await openLearnTab(tester);
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  group('the one route branches on the tree, not on the profile', () {
    testWidgets('a university tree renders Lectures', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        track: Track.university,
      );
      await openSubject(tester);

      expect(find.byType(SubjectTreeScreen), findsOneWidget);
      expect(find.byType(LecturesView), findsOneWidget);
      expect(find.byType(UnitsView), findsNothing);
      expect(find.text('Upper Limb'), findsOneWidget);
      expect(find.text('Thorax'), findsOneWidget);
    });

    testWidgets('a school tree renders Units from the SAME route',
        (tester) async {
      when(() => catalog.getSubjectTree(any()))
          .thenAnswer((_) async => schoolTree());

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

    testWidgets('university is FLAT — a lecture is the leaf, not a drill-down',
        (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await tester.tap(find.text('Upper Limb'));
      await tester.pumpAndSettle();

      // Straight to the quiz hand-off; there is no chapter/lesson level.
      expect(find.byType(QuizSetupPlaceholderScreen), findsOneWidget);
    });
  });

  group('title', () {
    testWidgets('is the subject name from the CACHED subjects list',
        (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Biology Lectures'), findsOneWidget);
      // The name came from the list already in memory, not a second request.
      verify(catalog.getSubjects).called(1);
    });

    testWidgets('falls back to the bare title when the name is not cached',
        (tester) async {
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

    testWidgets('Arabic titles it in Arabic, around the server copy',
        (tester) async {
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
    testWidgets('are built from tree.quizTypes, not a hardcoded five',
        (tester) async {
      // The fixture offers three of the four contract types.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Midterm'), findsOneWidget);
      expect(find.text('Final'), findsOneWidget);
      // Not offered by this subject → not drawn.
      expect(find.text('Practice'), findsNothing);
    });

    testWidgets('never draw a Flashcard tab — it is not in the contract',
        (tester) async {
      // The frame draws one (DESIGN_ISSUES #18). `quizTypes` has no such value,
      // and there is no M1 endpoint behind it, so a tab would be inert.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Flashcard'), findsNothing);
      expect(QuizType.values.map((t) => t.name), isNot(contains('flashcard')));
    });

    testWidgets('a subject offering one type shows exactly one tab',
        (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(quizTypes: <String>['normal']),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(QuizTypeTabs), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Midterm'), findsNothing);
    });

    testWidgets('no quiz types at all → no tab row, and the list still renders',
        (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(quizTypes: <String>[]),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(QuizTypeTabs), findsNothing);
      expect(find.byType(TreeListRow), findsNWidgets(3));
    });

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

  group('lecture rows', () {
    testWidgets('are numbered 1..n with a bar from their own counter',
        (tester) async {
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

    testWidgets('the counter never disables or hides a lecture', (tester) async {
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
      expect(find.byType(QuizSetupPlaceholderScreen), findsOneWidget);
    });

    testWidgets('row numbers go through the locale, not string interpolation',
        (tester) async {
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
        find.text(MaterialLocalizations.of(
          tester.element(find.byType(LecturesView)),
        ).formatDecimal(1)),
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
    testWidgets('carries lectureId, name and the DEFAULT quiz type',
        (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      await tester.tap(find.text('Lower Limb'));
      await tester.pumpAndSettle();

      final screen = tester.widget<QuizSetupPlaceholderScreen>(
        find.byType(QuizSetupPlaceholderScreen),
      );
      expect(screen.args.lectureId, 'lec-2');
      expect(screen.args.scopeName, 'Lower Limb');
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

      final screen = tester.widget<QuizSetupPlaceholderScreen>(
        find.byType(QuizSetupPlaceholderScreen),
      );
      expect(screen.args.quizType, QuizType.finalRevision);
      expect(screen.args.lectureId, 'lec-1');
    });

    testWidgets('falls back to normal when the subject omits it',
        (tester) async {
      // `normal` is the contract's own default for POST /quizzes.quizType, so
      // using it when the subject offers nothing is not an invented value.
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(quizTypes: <String>[]),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);
      await tester.tap(find.text('Upper Limb'));
      await tester.pumpAndSettle();

      final screen = tester.widget<QuizSetupPlaceholderScreen>(
        find.byType(QuizSetupPlaceholderScreen),
      );
      expect(screen.args.quizType, QuizType.normal);
    });
  });

  group('states', () {
    testWidgets('empty lectures get their OWN copy, not the school one',
        (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) async => universityTree(lectures: <dynamic>[]),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('No lectures yet'), findsOneWidget);
      expect(find.text('Nothing here yet'), findsNothing);
    });

    testWidgets('loading shows a row skeleton, not a bare spinner',
        (tester) async {
      final completer = Completer<SubjectTree>();
      when(() => catalog.getSubjectTree(any()))
          .thenAnswer((_) => completer.future);

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
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) => Future<SubjectTree>.error(const UnknownException()),
      );

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Something went wrong'), findsOneWidget);

      when(() => catalog.getSubjectTree(any()))
          .thenAnswer((_) async => universityTree());
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Upper Limb'), findsOneWidget);
    });

    testWidgets('offline gets its own view, distinct from a generic error',
        (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) => Future<SubjectTree>.error(const OfflineException()),
      );

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

    testWidgets('403 insufficient_scope gets its own copy and NO retry',
        (tester) async {
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
}
