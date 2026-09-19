import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/catalog/widgets/quiz_type_tabs.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/features/mistakes/repository/mistakes_repository.dart';
import 'package:level_up_app/features/mistakes/screens/mistakes_overview_screen.dart';
import 'package:level_up_app/features/mistakes/screens/mistakes_subject_screen.dart';
import 'package:level_up_app/features/mistakes/screens/mistakes_tree_screens.dart';
import 'package:level_up_app/features/mistakes/widgets/mistakes_subject_card.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../catalog/catalog_fixtures.dart';
import '../catalog/catalog_harness.dart';
import 'mistakes_fixtures.dart';

class MockMistakesRepository extends Mock implements MistakesRepository {}

/// The Mistakes flow, walked through the REAL router.
///
/// Every test here boots the whole app and taps its way in from the Subjects
/// header, because that is the only way the flow is reachable and because the
/// screens read `GoRouter.of(context)`. A direct pump would need a fake router
/// and would stop testing the thing Day 10 actually changed — the routes.
void main() {
  late MockCatalogRepository catalog;
  late MockMistakesRepository mistakes;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());

    mistakes = MockMistakesRepository();
    when(mistakes.getMistakes).thenAnswer((_) async => mistakesOverview());
    when(
      () => mistakes.getMistakesForSubject(any()),
    ).thenAnswer((_) async => schoolMistakesTree());
  });

  /// Learn tab → the Mistakes header action.
  ///
  /// Found by its LABEL, not by its widget type. It was an `OutlinedButton`
  /// until 2026-09-19, when edit3 rebuilt it as the frame's filled pill on an
  /// `ElevatedSurface` (`Frame 427319504`); a type finder would break again the
  /// next time its surface changes, and the label is what a student taps.
  Future<void> openMistakes(WidgetTester tester, {String locale = 'en'}) async {
    await openLearnTab(tester, locale: locale);
    await tester.tap(find.text(locale == 'ar' ? 'أخطائي' : 'Mistakes'));
    await tester.pumpAndSettle();
  }

  // -------------------------------------------------------------------------
  group('the entry point', () {
    testWidgets('the Day-6 coming-soon snackbar is gone', (tester) async {
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
      );
      await openMistakes(tester);

      // The stub said "Coming soon" and stayed put for four waves. Both halves
      // of that are asserted: the copy is gone AND the tap now lands somewhere.
      expect(find.text('Coming soon'), findsNothing);
      expect(find.byType(MistakesOverviewScreen), findsOneWidget);
      expect(locationOf(container), '/learn/mistakes');
    });

    testWidgets('it PUSHES, so the back chevron returns to Subjects', (
      tester,
    ) async {
      // `push`, not `go`: the frame draws a back chevron, and `CatalogHeader`
      // only renders one when the branch's Navigator can actually pop.
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
      );
      await openMistakes(tester);

      await tester.tap(find.byType(CircleBackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SubjectsScreen), findsOneWidget);
      expect(locationOf(container), '/learn');
    });
  });

  // -------------------------------------------------------------------------
  group('the overview', () {
    testWidgets('renders one card per subject, in the SERVER order', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(find.byType(MistakesSubjectCard), findsNWidgets(3));

      // `name` ascending, then `id` — "a stable order the client can render
      // without sorting". If anyone adds a sort, this catches it.
      final names = tester
          .widgetList<MistakesSubjectCard>(find.byType(MistakesSubjectCard))
          .map((card) => card.subject.name)
          .toList();
      expect(names, ['Biology', 'Chemistry', 'Physics']);
    });

    testWidgets('the count says MISTAKES, not "questions" (#59)', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(find.text('20 mistakes'), findsOneWidget);
      expect(find.text('3 mistakes'), findsOneWidget);
      // The frames caption this "N questions", which inverts the meaning of the
      // number. Transcribing the frame is the bug this asserts against.
      expect(find.text('20 questions'), findsNothing);
    });

    testWidgets('the count PLURALISES — the frames write "1 questions"', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(find.text('1 mistake'), findsOneWidget);
      expect(find.text('1 mistakes'), findsNothing);
    });

    testWidgets('an empty list is the HAPPY PATH, not an error', (
      tester,
    ) async {
      // `200 []` is "a NORMAL response — the record of a student who has
      // nothing outstanding", and the contract forbids empty-as-error.
      when(mistakes.getMistakes).thenAnswer((_) async => []);

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(find.text('No mistakes yet'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.text('Retry'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('the two insufficient_scope meanings (#61)', () {
    testWidgets('on the OVERVIEW it is an enrolment state, and retryable', (
      tester,
    ) async {
      // The overview takes no id and refuses no id: the code means "no active
      // enrolment right now", reachable in ordinary use during a track
      // transfer (adr-032).
      when(
        mistakes.getMistakes,
      ).thenThrow(const ApiException(status: 403, code: 'insufficient_scope'));

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(
        find.text('Your enrolment is being updated. Try again in a moment.'),
        findsOneWidget,
      );
      // The assertion the brief asked for by name.
      expect(
        find.text("This subject isn't part of your course."),
        findsNothing,
      );
      // …and the retry `CatalogAsyncView` suppresses for a refused subject is
      // restored here, because this state resolves on its own.
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('on the SUBJECT route it still means "not your subject"', (
      tester,
    ) async {
      when(
        () => mistakes.getMistakesForSubject(any()),
      ).thenThrow(const ApiException(status: 403, code: 'insufficient_scope'));

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(
        find.text("This subject isn't part of your course."),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('account_pending_deletion is NOT swallowed as a scope error', (
      tester,
    ) async {
      // It is the OTHER 403 both routes can answer. Handling it belongs to the
      // global interceptor (TODO(contract) → seif_fight.md S38); all this
      // screen owes is not mistaking it for a scope refusal and not hiding it.
      when(mistakes.getMistakes).thenThrow(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      );

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(
        find.text('Your enrolment is being updated. Try again in a moment.'),
        findsNothing,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('the school tree', () {
    /// Mistakes → Biology → Cell Biology.
    Future<void> walkToChapters(WidgetTester tester) async {
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
    }

    testWidgets('four screens cost ONE tree fetch', (tester) async {
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
      );

      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      expect(find.byType(MistakesUnitsView), findsOneWidget);
      expect(find.text('Biology Units'), findsOneWidget);

      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
      expect(find.byType(MistakesChaptersScreen), findsOneWidget);
      expect(find.text('Cell Biology Chapters'), findsOneWidget);

      await tester.tap(find.text('Cell Structure'));
      await tester.pumpAndSettle();
      expect(find.byType(MistakesLessonsScreen), findsOneWidget);
      expect(
        locationOf(container),
        '/learn/mistakes/subject/sub-bio/unit/unit-1/chapter/chap-1',
      );

      // THE point of this test: three levels, one request. The levels are
      // VIEWS over the cached tree, not per-level fetches.
      verify(() => mistakes.getMistakesForSubject('sub-bio')).called(1);
    });

    testWidgets('every row renders the SERVER count, never a sum', (
      tester,
    ) async {
      // The fixture's parents deliberately disagree with their children:
      // the unit says 42 while its chapters say 3 and 4. The contract owns the
      // arithmetic; a client that "corrected" this would show 7.
      when(
        () => mistakes.getMistakesForSubject(any()),
      ).thenAnswer((_) async => schoolMistakesTreeInconsistent());

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.text('42 mistakes'), findsOneWidget);
      expect(find.text('7 mistakes'), findsNothing);

      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
      expect(find.text('3 mistakes'), findsOneWidget);
      expect(find.text('4 mistakes'), findsOneWidget);
    });

    testWidgets('a LESSON is inert — no chevron, no tap', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await walkToChapters(tester);

      await tester.tap(find.text('Cell Structure'));
      await tester.pumpAndSettle();
      expect(find.byType(MistakesLessonsScreen), findsOneWidget);

      final rows = tester.widgetList<TreeListRow>(find.byType(TreeListRow));
      expect(rows, isNotEmpty);
      for (final row in rows) {
        // The replay quiz is next day's work. A row that kept its affordance
        // and swallowed the tap would read to a student as a bug.
        expect(row.onTap, isNull, reason: '${row.name} looks tappable');
      }
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('an unknown unitId is EMPTY, not a crash and not an error', (
      tester,
    ) async {
      when(
        () => mistakes.getMistakesForSubject(any()),
      ).thenAnswer((_) async => emptySchoolMistakesTree());

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      // `mistakeCount: 0` with an empty `units` is a NORMAL 200, not a 403.
      expect(find.text('No mistakes yet'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(
        find.text("This subject isn't part of your course."),
        findsNothing,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('the university tree', () {
    setUp(() {
      when(
        () => mistakes.getMistakesForSubject(any()),
      ).thenAnswer((_) async => universityMistakesTree());
    });

    testWidgets('is FLAT, has no quizType tabs, and its leaves are inert', (
      tester,
    ) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        track: Track.university,
      );
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.byType(MistakesLecturesView), findsOneWidget);
      expect(find.text('Biology Lectures'), findsOneWidget);
      expect(find.text('5 mistakes'), findsOneWidget);
      expect(find.text('15 mistakes'), findsOneWidget);

      // `UniversityMistakesTree` carries no `quizTypes` — "a mistakes tree is a
      // history view, not a quiz-build tree" — and frame 404:7181 draws no tab
      // row. Contract and design agree; reusing QuizTypeTabs here would be a
      // shape the server never sent.
      expect(find.byType(QuizTypeTabs), findsNothing);

      for (final row in tester.widgetList<TreeListRow>(
        find.byType(TreeListRow),
      )) {
        expect(row.onTap, isNull, reason: '${row.name} looks tappable');
      }
    });

    testWidgets('the OVERVIEW is the same screen on both tracks', (
      tester,
    ) async {
      // Frames 404:6292 and 404:7110 are pixel-identical and the endpoint takes
      // no track parameter. If a branch ever appears, this fails.
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        track: Track.university,
      );
      await openMistakes(tester);

      expect(find.byType(MistakesOverviewScreen), findsOneWidget);
      expect(find.byType(MistakesSubjectCard), findsNWidgets(3));
      expect(find.text('20 mistakes'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  group('Arabic (RTL) and dark', () {
    testWidgets('the count picks the right Arabic plural category', (
      tester,
    ) async {
      // Arabic has SIX plural categories and this is exactly the case where a
      // naive "$n مسألة" is wrong. All three of these are different words, not
      // a shared stem with a different number in front.
      //
      // The DIGITS are Western on purpose. `intl` formats `ar` that way in this
      // app, which the project has already found and asserted twice rather than
      // assumed — profile_screen_test.dart:534 and the row-number finding in
      // lectures_screen_test.dart:294 (DESIGN_ISSUES #19). Whether Egyptian
      // students should see ٠١٢ is a design question, not a client one; if a
      // future intl bump flips it, this fails as a deliberate change.
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        locale: 'ar',
      );
      await openMistakes(tester, locale: 'ar');

      expect(find.byType(MistakesOverviewScreen), findsOneWidget);
      // 20 → `many`: 11–99 take the singular in the accusative.
      expect(find.text('20 خطأً'), findsOneWidget);
      // 3 → `few`: 3–10 take the plural noun.
      expect(find.text('3 أخطاء'), findsOneWidget);
      // 1 → `one`, which carries no digit at all.
      expect(find.text('خطأ واحد'), findsOneWidget);
    });

    testWidgets('chevrons mirror in RTL', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        locale: 'ar',
      );
      await openMistakes(tester, locale: 'ar');
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      // Forward means LEFT in Arabic. A row chevron pointing the wrong way is a
      // real bug, not a cosmetic one.
      expect(find.byIcon(Icons.chevron_left), findsWidgets);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('dark theme renders the same content', (tester) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        theme: AppTheme.dark,
      );
      await openMistakes(tester);

      expect(find.byType(MistakesSubjectCard), findsNWidgets(3));
      expect(find.text('20 mistakes'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  testWidgets('offline shows the banner and an offline state, not an error', (
    tester,
  ) async {
    when(mistakes.getMistakes).thenThrow(const NetworkException());

    await pumpCatalogApp(
      tester,
      catalog: catalog,
      mistakes: mistakes,
      online: false,
    );
    await openMistakes(tester);

    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
  });
}
