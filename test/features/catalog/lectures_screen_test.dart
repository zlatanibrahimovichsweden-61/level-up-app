import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';
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

    testWidgets('never draw a Flashcard tab — it is not in the contract', (
      tester,
    ) async {
      // The frame draws one (DESIGN_ISSUES #18). `quizTypes` has no such value,
      // and there is no M1 endpoint behind it, so a tab would be inert.
      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.text('Flashcard'), findsNothing);
      expect(QuizType.values.map((t) => t.name), isNot(contains('flashcard')));
    });

    testWidgets('a subject offering one type shows exactly one tab', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree(quizTypes: <String>['normal']));

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);

      expect(find.byType(QuizTypeTabs), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Midterm'), findsNothing);
    });

    testWidgets(
      'no quiz types at all → no tab row, and the list still renders',
      (tester) async {
        when(
          () => catalog.getSubjectTree(any()),
        ).thenAnswer((_) async => universityTree(quizTypes: <String>[]));

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
    testWidgets('carries lectureId, name and the DEFAULT quiz type', (
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
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree(quizTypes: <String>[]));

      await pumpCatalogApp(tester, catalog: catalog, track: Track.university);
      await openSubject(tester);
      await tester.tap(find.text('Upper Limb'));
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
      expect(rects, hasLength(3), reason: 'the fixture lists three types');
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
      testWidgets('$locale at text scale $scale: four tabs stay equal, and '
          'every label keeps its full size', (tester) async {
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
        expect(rects, hasLength(4));
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
                ? const ['عادي', 'منتصف الترم', 'نهائي', 'عملي']
                : const ['Normal', 'Midterm', 'Final', 'Practice']) {
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

      for (final label in ['عادي', 'منتصف الترم', 'نهائي', 'عملي']) {
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
