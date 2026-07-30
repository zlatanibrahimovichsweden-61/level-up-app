import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/catalog/screens/chapters_screen.dart';
import 'package:level_up_app/features/catalog/screens/lessons_screen.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/catalog/screens/units_screen.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_placeholder.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// The drill-down, walked end to end through the real nested routes.
///
/// The assertion this file exists for: **the tree is fetched ONCE.** Units,
/// Chapters and Lessons all read one cached object, so a four-screen walk costs
/// exactly one request. If someone later "fixes" a screen by fetching its own
/// level, `verify(...).called(1)` fails here.
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(() => catalog.getSubjectTree(any()))
        .thenAnswer((_) async => schoolTree());
  });

  /// Learn → Biology → Cell Biology → The Cell.
  Future<void> walkToLessons(WidgetTester tester) async {
    await openLearnTab(tester);

    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cell Biology'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('The Cell'));
    await tester.pumpAndSettle();
  }

  testWidgets('Subjects → Units → Chapters → Lessons costs ONE tree fetch',
      (tester) async {
    await pumpCatalogApp(tester, catalog: catalog);

    await openLearnTab(tester);
    expect(find.byType(SubjectsScreen), findsOneWidget);

    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();
    expect(find.byType(UnitsView), findsOneWidget);
    expect(find.text('Cell Biology'), findsOneWidget);
    expect(find.text('Genetics'), findsOneWidget);

    await tester.tap(find.text('Cell Biology'));
    await tester.pumpAndSettle();
    expect(find.byType(ChaptersScreen), findsOneWidget);
    expect(find.text('The Cell'), findsOneWidget);
    expect(find.text('Transport'), findsOneWidget);

    await tester.tap(find.text('The Cell'));
    await tester.pumpAndSettle();
    expect(find.byType(LessonsScreen), findsOneWidget);
    expect(find.text('Cell Structure'), findsOneWidget);
    expect(find.text('Cell Division'), findsOneWidget);

    // THE point of this file: three screens, one request.
    verify(() => catalog.getSubjectTree('sub-1')).called(1);
  });

  testWidgets('going back up and down again still does not re-fetch',
      (tester) async {
    await pumpCatalogApp(tester, catalog: catalog);
    await walkToLessons(tester);

    // Back to Chapters, then to Units, via the header's own chevron (the
    // screens have no AppBar, so `pageBack` has nothing to press).
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();
    expect(find.byType(ChaptersScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();
    expect(find.byType(UnitsView), findsOneWidget);

    await tester.tap(find.text('Cell Biology'));
    await tester.pumpAndSettle();

    verify(() => catalog.getSubjectTree('sub-1')).called(1);
  });

  testWidgets('a lesson opens /quiz/setup with its id and name',
      (tester) async {
    await pumpCatalogApp(tester, catalog: catalog);
    await walkToLessons(tester);

    await tester.tap(find.text('Cell Division'));
    await tester.pumpAndSettle();

    final screen = tester.widget<QuizSetupPlaceholderScreen>(
      find.byType(QuizSetupPlaceholderScreen),
    );
    expect(screen.args.lessonId, 'lesson-2');
    expect(screen.args.scopeName, 'Cell Division');
    expect(find.text('Quiz setup is coming soon'), findsOneWidget);
  });

  testWidgets('questionCounter never disables or hides a lesson row',
      (tester) async {
    // Contract: the counter "never locks retakes". `Cell Structure` is at 0/25
    // and `Cell Division` at 40/40 — both must render, both must be tappable.
    await pumpCatalogApp(tester, catalog: catalog);
    await walkToLessons(tester);

    expect(find.byType(TreeListRow), findsNWidgets(2));
    for (final row in tester.widgetList<TreeListRow>(
      find.byType(TreeListRow),
    )) {
      expect(row.onTap, isNotNull, reason: '${row.name} is not tappable');
    }
    expect(find.text('0 / 25 questions'), findsOneWidget);
    expect(find.text('40 / 40 questions'), findsOneWidget);

    // Open the FINISHED one — a retake must be reachable.
    await tester.tap(find.text('Cell Division'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizSetupPlaceholderScreen), findsOneWidget);
  });

  testWidgets('an empty level shows the empty state, not an error',
      (tester) async {
    await pumpCatalogApp(tester, catalog: catalog);
    await openLearnTab(tester);

    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Genetics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inheritance'));
    await tester.pumpAndSettle();

    expect(find.byType(LessonsScreen), findsOneWidget);
    expect(find.text('Nothing here yet'), findsOneWidget);
    expect(find.text('Something went wrong'), findsNothing);
  });

  testWidgets('a subject with no units at all is empty, not broken',
      (tester) async {
    when(() => catalog.getSubjectTree(any())).thenAnswer(
      (_) async => SchoolSubjectTree.fromJson(<String, dynamic>{
        'track': 'school',
        'units': <dynamic>[],
      }),
    );

    await pumpCatalogApp(tester, catalog: catalog);
    await openLearnTab(tester);
    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();

    expect(find.byType(SubjectTreeScreen), findsOneWidget);
    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  group('row anatomy (Figma 337:5926)', () {
    testWidgets('every level titles itself after its parent', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      expect(find.text('Biology Units'), findsOneWidget);

      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
      expect(find.text('Cell Biology Chapters'), findsOneWidget);

      await tester.tap(find.text('The Cell'));
      await tester.pumpAndSettle();
      expect(find.text('The Cell Lessons'), findsOneWidget);
    });

    testWidgets('rows are numbered 1..n in list order', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      final rows = tester.widgetList<TreeListRow>(find.byType(TreeListRow));
      expect(rows.map((r) => r.index), [1, 2]);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets(
      'units and chapters draw NO progress bar — the contract gives them no '
      'counter',
      (tester) async {
        await pumpCatalogApp(tester, catalog: catalog);
        await openLearnTab(tester);

        await tester.tap(find.text('Biology'));
        await tester.pumpAndSettle();
        expect(
          tester.widgetList<TreeListRow>(find.byType(TreeListRow)).every(
                (r) => r.progress == null,
              ),
          isTrue,
        );
        expect(find.byType(LinearProgressIndicator), findsNothing);

        await tester.tap(find.text('Cell Biology'));
        await tester.pumpAndSettle();
        expect(find.byType(LinearProgressIndicator), findsNothing);
      },
    );

    testWidgets('lessons DO draw a bar, straight from questionCounter',
        (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await walkToLessons(tester);

      final bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();

      expect(bars, hasLength(2));
      expect(bars[0].value, 0.0); // 0 / 25
      expect(bars[1].value, 1.0); // 40 / 40
    });
  });

  testWidgets('the tree shows a row skeleton while it loads', (tester) async {
    final completer = Completer<SubjectTree>();
    when(() => catalog.getSubjectTree(any())).thenAnswer((_) => completer.future);

    await pumpCatalogApp(tester, catalog: catalog);
    await openLearnTab(tester);
    await tester.tap(find.text('Biology'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SubjectTreeScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(CatalogBlock), findsWidgets);
    expect(find.byType(TreeListRow), findsNothing);

    completer.complete(schoolTree());
    await tester.pumpAndSettle();
    expect(find.byType(TreeListRow), findsNWidgets(2));
  });

  group('tree failures', () {
    testWidgets('error shows copy + a retry that re-requests', (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) => Future<SubjectTree>.error(const UnknownException()),
      );

      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);

      when(() => catalog.getSubjectTree(any()))
          .thenAnswer((_) async => schoolTree());
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Cell Biology'), findsOneWidget);
    });

    testWidgets('offline gets its own view', (tester) async {
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) => Future<SubjectTree>.error(const OfflineException()),
      );

      await pumpCatalogApp(tester, catalog: catalog, online: false);
      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text('You are offline'), findsWidgets);
      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('403 insufficient_scope gets its own copy and NO retry',
        (tester) async {
      // Retrying an out-of-scope subject would 403 again — offering the button
      // would just teach the student to tap it forever.
      when(() => catalog.getSubjectTree(any())).thenAnswer(
        (_) => Future<SubjectTree>.error(
          const ApiException(status: 403, code: 'insufficient_scope'),
        ),
      );

      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text("This subject isn't part of your course."), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });
  });

  testWidgets('the drill-down keeps the nav bar and survives a tab switch',
      (tester) async {
    await pumpCatalogApp(tester, catalog: catalog);
    await walkToLessons(tester);

    // The nav bar is still there — these are nested branch routes, not a
    // full-screen stack.
    expect(find.text('Home'), findsWidgets);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.byType(LessonsScreen), findsNothing);

    await openLearnTab(tester);

    // Back on the Learn tab, still deep in the tree — branch state preserved.
    expect(find.byType(LessonsScreen), findsOneWidget);
    verify(() => catalog.getSubjectTree('sub-1')).called(1);
  });

  testWidgets('Arabic walks the same path under RTL', (tester) async {
    await pumpCatalogApp(tester, catalog: catalog, locale: 'ar');
    await openLearnTab(tester, locale: 'ar');

    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();

    expect(find.text('وحدات Biology'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(SubjectTreeScreen))),
      TextDirection.rtl,
    );
  });
}
