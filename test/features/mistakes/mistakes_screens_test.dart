import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_scaffold.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/catalog/widgets/quiz_type_tabs.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/features/mistakes/models/mistakes_subject.dart';
import 'package:level_up_app/features/mistakes/models/mistakes_tree.dart';
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

/// The frame's 35 header band inside [CatalogHeader]. Since O-15 the header is
/// at least the back chip's 48 target tall, with the frame's band — the title,
/// the chip, the Mistakes pill — centred in it, so "N under the header" is
/// measured from the band's edge, which is where it always was on screen.
Rect _band(Rect header) => Rect.fromLTRB(
  header.left,
  header.top + CircleBackButton.tapSlop,
  header.right,
  header.bottom - CircleBackButton.tapSlop,
);

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
      // It is the OTHER 403 both routes can answer, and it is not route-
      // specific at all: the contract's rule is default-deny, so every
      // authenticated endpoint outside a four-entry allowlist answers it
      // (`openapi.yaml:62-71`).
      //
      // This test used to assert "Something went wrong" + a live Retry, with a
      // note saying the real handling belonged to a global interceptor. Both
      // halves of that were wrong in the same way: the copy told the student
      // nothing, and the button invited a request the contract says never
      // succeeds — "do not log the user out and do not retry" (`:82-83`).
      when(mistakes.getMistakes).thenThrow(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      );

      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      expect(
        find.text(
          'Your account is scheduled for deletion. '
          'Cancel the request to use Level Up again.',
        ),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);
      // Still not confused with either scope meaning.
      expect(
        find.text('Your enrolment is being updated. Try again in a moment.'),
        findsNothing,
      );
      expect(
        find.text("This subject isn't part of your course."),
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

    testWidgets(
      'a subject with no units is EMPTY, not a crash and not an error',
      (tester) async {
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
      },
    );
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
      //
      // Until API→UI Wave 07 this asserted the `chevron_left` GLYPH, which is
      // the bug itself: the glyph carries `matchTextDirection: true`, Icon
      // mirrors it, and it is drawn pointing right. The right check is the
      // LTR glyph, mirrored by Icon's own Transform (x scale -1).
      final chevrons = find.byIcon(Icons.chevron_right);
      expect(chevrons, findsWidgets);
      expect(find.byIcon(Icons.chevron_left), findsNothing);
      final mirrored = tester
          .widgetList<Transform>(
            find.descendant(of: chevrons, matching: find.byType(Transform)),
          )
          .where((t) => t.transform.storage[0] < 0);
      expect(mirrored.length, chevrons.evaluate().length);
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
  group('Wave 15: the frames (404:6292 · 404:7428)', () {
    // The frame's 402 width, without its 44 status bar (the harness has none).
    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(402, 816);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Finder header() => find.descendant(
      of: find.byType(MistakesOverviewScreen),
      matching: find.byType(CatalogHeader),
    );
    Finder card(String name) => find.ancestor(
      of: find.text(name),
      matching: find.byType(MistakesSubjectCard),
    );
    Finder inCard(String name, Finder matching) =>
        find.descendant(of: card(name), matching: matching);
    AppColors colors(WidgetTester tester) => Theme.of(
      tester.element(find.byType(MistakesOverviewScreen)),
    ).extension<AppColors>()!;
    const chevron = Key('mistakes_card_chevron');

    testWidgets('the grid starts 25 under the header; cards 89 tall, 16.5 and '
        '18 apart', (tester) async {
      phone(tester);
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      final bar = _band(tester.getRect(header()));
      final bio = tester.getRect(card('Biology'));
      final chem = tester.getRect(card('Chemistry'));
      final phys = tester.getRect(card('Physics'));
      // `404:6475` ends at 99.44 and `404:6312` starts at 124.44. It was 16.
      expect(bio.top - bar.bottom, closeTo(25, 0.01));
      expect(bio.left, closeTo(20, 0.01));
      expect(bio.height, closeTo(89, 0.01));
      expect(bio.width, closeTo(172.75, 0.01));
      expect(chem.top, bio.top);
      expect(chem.height, bio.height);
      expect(chem.left - bio.right, closeTo(16.5, 0.01));
      expect(phys.left, bio.left);
      expect(phys.top - bio.bottom, closeTo(18, 0.01));
    });

    testWidgets('the skeleton sits where the cards will', (tester) async {
      phone(tester);
      when(mistakes.getMistakes).thenAnswer((_) => Completer<Never>().future);
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openLearnTab(tester);
      await tester.tap(find.text('Mistakes'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final bar = _band(tester.getRect(header()));
      final block = tester.getRect(
        find
            .descendant(
              of: find.byType(MistakesOverviewScreen),
              matching: find.byType(CatalogBlock),
            )
            .first,
      );
      expect(block.top - bar.bottom, closeTo(25, 0.01));
      expect(block.height, closeTo(89, 0.01));
    });

    testWidgets('the chevron is the frame\'s 13 × 27 arrow: 12 from the end, '
        'centred on the card, #517066', (tester) async {
      phone(tester);
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      final bio = tester.getRect(card('Biology'));
      final box = tester.getRect(inCard('Biology', find.byKey(chevron)));
      expect(box.size, const Size(13, 27));
      expect(bio.right - box.right, closeTo(12, 0.01));
      // `top: calc(50% - 0.44px)` on the card, not on the title's line.
      expect(box.center.dy - bio.center.dy, closeTo(-0.44, 0.01));

      final svg = tester.widget<SvgPicture>(
        inCard('Biology', find.byType(SvgPicture)),
      );
      expect(
        (svg.bytesLoader as SvgAssetLoader).assetName,
        'assets/icons/chevron.svg',
      );
      // Stretched into the frame's 13 × 27 box: `vector_graphics` would
      // derive the width from a height and draw it 13.5 wide.
      final fitted = find.descendant(
        of: inCard('Biology', find.byKey(chevron)),
        matching: find.byType(FittedBox),
      );
      expect(tester.widget<FittedBox>(fitted.first).fit, BoxFit.fill);
      expect(inCard('Biology', find.byType(Icon)), findsNothing);
      expect(
        svg.colorFilter,
        ColorFilter.mode(colors(tester).mistakesCardChevron, BlendMode.srcIn),
      );
      expect(colors(tester).mistakesCardChevron, const Color(0xFF517066));
    });

    testWidgets('dark: the chevron is cream (404:7651)', (tester) async {
      phone(tester);
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        theme: AppTheme.dark,
      );
      await openMistakes(tester);

      final svg = tester.widget<SvgPicture>(
        inCard('Biology', find.byType(SvgPicture)),
      );
      expect(
        svg.colorFilter,
        const ColorFilter.mode(Color(0xFFFCFBF9), BlendMode.srcIn),
      );
    });

    testWidgets('title and count sit on the frame\'s lines; the text stops at '
        'the chevron', (tester) async {
      phone(tester);
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      final bio = tester.getRect(card('Biology'));
      final title = tester.getRect(inCard('Biology', find.text('Biology')));
      final count = tester.getRect(inCard('Biology', find.text('20 mistakes')));
      // Line centres from the frame: 24.61 + 2.12 + 14.85 / 2 for "Biology",
      // 24.61 + 26.60 + 2.57 + 2.69 + 10.62 / 2 for the count. They were
      // 30.44 and 61.44: a centred block put the title 3.7 high.
      expect(title.center.dy - bio.top, closeTo(34.155, 0.01));
      expect(count.center.dy - bio.top, closeTo(61.783, 0.01));
      expect(title.left - bio.left, closeTo(9, 0.01));
      expect(count.left - bio.left, closeTo(9, 0.01));
      // The chevron's box starts at 148; the text never runs under it.
      expect(bio.right - title.right, closeTo(25, 0.01));
      expect(bio.right - count.right, closeTo(25, 0.01));
    });

    testWidgets('Arabic: the chevron moves to the left edge and turns to point '
        'left; the text starts 9 from the right', (tester) async {
      phone(tester);
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        locale: 'ar',
      );
      await openMistakes(tester, locale: 'ar');

      final bio = tester.getRect(card('Biology'));
      final box = tester.getRect(inCard('Biology', find.byKey(chevron)));
      expect(box.left - bio.left, closeTo(12, 0.01));
      final flips = tester
          .widgetList<Transform>(
            find.descendant(
              of: card('Biology'),
              matching: find.ancestor(
                of: inCard('Biology', find.byType(SvgPicture)),
                matching: find.byType(Transform),
              ),
            ),
          )
          .where((t) => t.transform.storage[0] < 0);
      expect(flips, hasLength(1));
      final title = tester.getRect(inCard('Biology', find.text('Biology')));
      expect(bio.right - title.right, closeTo(9, 0.01));
      expect(title.left - bio.left, closeTo(25, 0.01));
    });

    testWidgets('each card is ONE button to TalkBack', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);

      // Mirrors `_MistakesButton`: `ElevatedSurface` adds a tap ACTION and no
      // button FLAG, so without the wrap TalkBack read the name and the count
      // as two texts and never said "button".
      final node = tester.getSemantics(card('Biology'));
      expect(node, isSemantics(isButton: true, hasTapAction: true));
      expect(node.label, contains('Biology'));
      expect(node.label, contains('20 mistakes'));
      semantics.dispose();
    });

    // BUG-002: the Arabic cards overflowed from 1.3 and every card at 2.0. The
    // card now grows with its text and a row takes its tallest card, so the
    // frame's 89 is the floor, not a cap. The scale is raised AFTER the
    // Subjects screen is covered, so only this screen lays out at it (the
    // Subjects cards overflow too: BUG-002's other half, not this wave's).
    for (final (locale, scale) in [
      ('en', 1.3),
      ('ar', 1.3),
      ('en', 2.0),
      ('ar', 2.0),
    ]) {
      testWidgets('BUG-002: no overflow in $locale at ${scale}x; rows grow '
          'together', (tester) async {
        phone(tester);
        when(mistakes.getMistakes).thenAnswer(
          (_) async => [
            ...mistakesOverview(),
            MistakesSubject.fromJson(const {
              'id': 'sub-ar',
              'name': 'اللغة العربية',
              'mistakeCount': 12,
            }),
          ],
        );
        await pumpCatalogApp(
          tester,
          catalog: catalog,
          mistakes: mistakes,
          locale: locale,
        );
        await openMistakes(tester, locale: locale);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        final bio = tester.getRect(card('Biology'));
        final chem = tester.getRect(card('Chemistry'));
        final phys = tester.getRect(card('Physics'));
        final arabic = tester.getRect(card('اللغة العربية'));
        expect(chem.height, bio.height);
        expect(arabic.height, phys.height);
        expect(bio.height, greaterThanOrEqualTo(89));
        expect(phys.height, greaterThanOrEqualTo(89));
        if (scale >= 2) expect(bio.height, greaterThan(89));
        expect(phys.top - bio.bottom, closeTo(18, 0.01));
        // Nothing is clipped: each count ends above its card's bottom.
        for (final name in ['Biology', 'اللغة العربية']) {
          final count = tester.getRect(
            find.descendant(of: card(name), matching: find.byType(Text)).last,
          );
          expect(
            count.bottom,
            lessThanOrEqualTo(tester.getRect(card(name)).bottom),
          );
        }
      });
    }
  });

  // -------------------------------------------------------------------------
  group('Wave 16: the frames (404:6539 · 404:7181 · 404:7765)', () {
    // The frame's 402 width, without its 44 status bar (the harness has none).
    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(402, 816);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Future<void> openSubject(
      WidgetTester tester, {
      String locale = 'en',
      ThemeData? theme,
    }) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        locale: locale,
        theme: theme,
      );
      await openMistakes(tester, locale: locale);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
    }

    Finder rows() => find.descendant(
      of: find.byType(MistakesSubjectScreen),
      matching: find.byType(TreeListRow),
    );
    Finder inRow(int index, Finder matching) =>
        find.descendant(of: rows().at(index), matching: matching);
    Rect header(WidgetTester tester) => _band(
      tester.getRect(
        find.descendant(
          of: find.byType(MistakesSubjectScreen),
          matching: find.byType(CatalogHeader),
        ),
      ),
    );
    AppColors colors(WidgetTester tester) => Theme.of(
      tester.element(find.byType(MistakesSubjectScreen)),
    ).extension<AppColors>()!;

    for (final university in [false, true]) {
      testWidgets(
        '${university ? 'Lectures' : 'Units'}: the list starts 25 under the '
        'header, rows 78 tall and 16 apart',
        (tester) async {
          phone(tester);
          if (university) {
            when(
              () => mistakes.getMistakesForSubject(any()),
            ).thenAnswer((_) async => universityMistakesTree());
          }
          await openSubject(tester);

          final first = tester.getRect(rows().at(0));
          final second = tester.getRect(rows().at(1));
          expect(first.top - header(tester).bottom, closeTo(25, 0.01));
          expect(first.height, closeTo(78, 0.01));
          expect(second.height, closeTo(78, 0.01));
          expect(second.top - first.bottom, closeTo(16, 0.01));
        },
      );
    }

    testWidgets('badge, lines and chevron sit where 404:6642 puts them', (
      tester,
    ) async {
      phone(tester);
      await openSubject(tester);

      final row = tester.getRect(rows().at(0));
      final badge = tester.getRect(inRow(0, find.byType(ElevatedSurface)));
      final name = tester.getRect(inRow(0, find.text('Cell Biology')));
      final count = tester.getRect(inRow(0, find.text('5 mistakes')));
      final chevron = tester.getRect(inRow(0, find.byType(Icon)));

      // 17 from the start and the top: the container's 16.5 inside the 0.5
      // border. Centred at 37.0 with the chevron.
      expect(badge.left - row.left, closeTo(17, 0.01));
      expect(badge.top - row.top, closeTo(17, 0.01));
      expect(badge.size, const Size(40, 40));
      expect(chevron.center.dy - row.top, closeTo(37, 0.01));
      // The container is 334 wide: the chevron ends 12 from the row's end.
      expect(row.right - chevron.right, closeTo(12, 0.01));
      expect(chevron.size, const Size(28, 28));
      // The name starts after the badge and the 12 gap; the lines sit on
      // the frame's centres, 28.0 and 46.5 below the row's top.
      expect(name.left - row.left, closeTo(69, 0.01));
      expect(name.center.dy - row.top, closeTo(28, 0.01));
      expect(count.left - row.left, closeTo(69, 0.01));
      expect(count.center.dy - row.top, closeTo(46.5, 0.01));
    });

    for (final (dark, stroke) in [
      (false, 0xFF4B675E), // 404:6654
      (true, 0xFFFCFBF9), // 404:7778
    ]) {
      testWidgets('the row chevron is the frame stroke in '
          '${dark ? 'dark' : 'light'}', (tester) async {
        phone(tester);
        await openSubject(tester, theme: dark ? AppTheme.dark : null);
        final icon = tester.widget<Icon>(inRow(0, find.byType(Icon)));
        expect(icon.color, Color(stroke));
        expect(icon.color, colors(tester).mistakesRowChevron);
      });
    }

    testWidgets('the light badge disc is the frame lavender #F4E6FF', (
      tester,
    ) async {
      phone(tester);
      await openSubject(tester);
      final disc = tester.widget<ElevatedSurface>(
        inRow(0, find.byType(ElevatedSurface)),
      );
      expect(disc.color, const Color(0xFFF4E6FF)); // 404:6644
    });

    testWidgets('Arabic mirrors the insets: badge 17 from the right, chevron '
        '12 from the left', (tester) async {
      phone(tester);
      await openSubject(tester, locale: 'ar');

      final row = tester.getRect(rows().at(0));
      final badge = tester.getRect(inRow(0, find.byType(ElevatedSurface)));
      final chevron = tester.getRect(inRow(0, find.byType(Icon)));
      expect(row.right - badge.right, closeTo(17, 0.01));
      expect(chevron.left - row.left, closeTo(12, 0.01));
      expect(row.height, greaterThanOrEqualTo(78));
    });

    // BUG-002, measured on the tree rows: they grow with their text rather
    // than overflow. The lift keeps the count under the name at any scale.
    for (final (locale, scale) in [
      ('en', 1.3),
      ('ar', 1.3),
      ('en', 2.0),
      ('ar', 2.0),
    ]) {
      testWidgets('BUG-002: $locale at ${scale}x nothing overflows, the rows '
          'grow and the count stays under the name', (tester) async {
        phone(tester);
        when(() => mistakes.getMistakesForSubject(any())).thenAnswer(
          (_) async => SchoolMistakesTree.fromJson({
            'track': 'school',
            'mistakeCount': 20,
            'units': [
              for (final (id, name, n) in [
                ('u1', 'الوحدة الأولى: الخلية وتركيبها ووظائف أجزائها', 5),
                ('u2', 'Genetics', 15),
              ])
                {
                  'id': id,
                  'name': name,
                  'mistakeCount': n,
                  'chapters': [
                    {
                      'id': '$id-c',
                      'name': 'c',
                      'mistakeCount': n,
                      'lessons': [
                        {'id': '$id-l', 'name': 'l', 'mistakeCount': n},
                      ],
                    },
                  ],
                },
            ],
          }),
        );
        await openSubject(tester, locale: locale);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        for (var i = 0; i < 2; i++) {
          final row = tester.getRect(rows().at(i));
          final texts = inRow(i, find.byType(Text));
          final name = tester.getRect(texts.at(1));
          final count = tester.getRect(texts.last);
          expect(row.height, greaterThan(78));
          expect(count.top, greaterThanOrEqualTo(name.bottom - 2.5 - 0.01));
          expect(count.bottom, lessThanOrEqualTo(row.bottom));
          for (final part in [
            find.byType(ElevatedSurface),
            find.byType(Icon),
          ]) {
            final r = tester.getRect(inRow(i, part));
            expect(r.top, greaterThanOrEqualTo(row.top));
            expect(r.bottom, lessThanOrEqualTo(row.bottom));
          }
        }
      });
    }
  });

  // -------------------------------------------------------------------------
  group('Wave 17: the Chapters frames (404:6677 · 404:7894)', () {
    // The frame's 402 width, without its 44 status bar (the harness has none).
    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(402, 816);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    /// Mistakes → Biology → Cell Biology: the unit's two chapters.
    Future<ProviderContainer> openChapters(
      WidgetTester tester, {
      String locale = 'en',
      ThemeData? theme,
    }) async {
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        locale: locale,
        theme: theme,
      );
      await openMistakes(tester, locale: locale);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
      expect(find.byType(MistakesChaptersScreen), findsOneWidget);
      return container;
    }

    Finder rows() => find.descendant(
      of: find.byType(MistakesChaptersScreen),
      matching: find.byType(TreeListRow),
    );
    Finder inRow(int index, Finder matching) =>
        find.descendant(of: rows().at(index), matching: matching);
    Rect header(WidgetTester tester) => _band(
      tester.getRect(
        find.descendant(
          of: find.byType(MistakesChaptersScreen),
          matching: find.byType(CatalogHeader),
        ),
      ),
    );

    // "Cell Structure" wraps in the test font (its glyphs are wider than
    // Inter's), so its row is taller here; the one-line row, "Mitosis", is the
    // one measured against the frame's 78.
    for (final dark in [false, true]) {
      testWidgets('${dark ? 'dark' : 'light'}: the list starts 25 under the '
          'header, rows 16 apart, a one-line row 78 tall', (tester) async {
        phone(tester);
        await openChapters(tester, theme: dark ? AppTheme.dark : null);

        expect(rows(), findsNWidgets(2));
        final first = tester.getRect(rows().at(0));
        final second = tester.getRect(rows().at(1));
        expect(first.top - header(tester).bottom, closeTo(25, 0.01));
        expect(second.top - first.bottom, closeTo(16, 0.01));
        expect(second.height, closeTo(78, 0.01));
      });
    }

    testWidgets('the rows take the frame geometry of 404:6697 here too', (
      tester,
    ) async {
      phone(tester);
      await openChapters(tester);

      // The one-line row (see above).
      final row = tester.getRect(rows().at(1));
      final badge = tester.getRect(inRow(1, find.byType(ElevatedSurface)));
      final name = tester.getRect(inRow(1, find.text('Mitosis')));
      final count = tester.getRect(inRow(1, find.text('2 mistakes')));
      final chevron = tester.getRect(inRow(1, find.byType(Icon)));
      expect(row.height, closeTo(78, 0.01));
      expect(row.left, closeTo(20, 0.01));
      expect(402 - row.right, closeTo(20, 0.01));
      expect(badge.left - row.left, closeTo(17, 0.01));
      expect(badge.center.dy - row.top, closeTo(37, 0.01));
      expect(row.right - chevron.right, closeTo(12, 0.01));
      expect(chevron.center.dy - row.top, closeTo(37, 0.01));
      expect(name.center.dy - row.top, closeTo(28, 0.01));
      expect(count.center.dy - row.top, closeTo(46.5, 0.01));
    });

    // I2: one merged button node per row, as on the Units list.
    testWidgets('each chapter row is ONE button node with the whole label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await openChapters(tester);

      for (final (i, name, count) in [
        (0, 'Cell Structure', '3 mistakes'),
        (1, 'Mitosis', '2 mistakes'),
      ]) {
        final node = tester.getSemantics(rows().at(i));
        expect(node, isSemantics(isButton: true, hasTapAction: true));
        expect(node.label, contains('${i + 1}'));
        expect(node.label, contains(name));
        expect(node.label, contains(count));
      }
      handle.dispose();
    });

    // I1: forward is LEFT in Arabic, on this screen's rows.
    testWidgets('Arabic mirrors the row: badge 17 from the right, chevron '
        'mirrored and 12 from the left', (tester) async {
      phone(tester);
      await openChapters(tester, locale: 'ar');

      for (var i = 0; i < 2; i++) {
        final row = tester.getRect(rows().at(i));
        final badge = tester.getRect(inRow(i, find.byType(ElevatedSurface)));
        final chevron = inRow(i, find.byIcon(Icons.chevron_right));
        expect(row.right - badge.right, closeTo(17, 0.01));
        expect(tester.getRect(chevron).left - row.left, closeTo(12, 0.01));
        final flips = tester
            .widgetList<Transform>(
              find.descendant(of: chevron, matching: find.byType(Transform)),
            )
            .where((t) => t.transform.storage[0] < 0);
        expect(flips, isNotEmpty, reason: 'row $i chevron points right');
      }
    });

    // F2: a unit the cached tree does not have (a stale link, or a count that
    // decayed to zero and pruned the branch between two reads).
    testWidgets('a unit the tree does not have is EMPTY, not an error, and '
        'costs no second fetch', (tester) async {
      final container = await openChapters(tester);
      container
          .read(routerProvider)
          .go('/learn/mistakes/subject/sub-bio/unit/unit-withdrawn');
      await tester.pumpAndSettle();

      expect(find.byType(MistakesChaptersScreen), findsOneWidget);
      expect(find.text('No mistakes yet'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.text('Retry'), findsNothing);
      expect(rows(), findsNothing);
      // No unit, so no name to title the screen after: the bare fallback.
      expect(find.text('Chapters'), findsOneWidget);
      verify(() => mistakes.getMistakesForSubject('sub-bio')).called(1);
    });

    // States on THIS screen: a cold link whose load fails, and Retry.
    testWidgets('a failed load on Chapters offers Retry, which refetches this '
        'subject and shows the rows', (tester) async {
      var calls = 0;
      when(() => mistakes.getMistakesForSubject(any())).thenAnswer((_) async {
        calls++;
        if (calls == 1) throw const NetworkException();
        return schoolMistakesTree();
      });
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
      );
      await openMistakes(tester);
      container
          .read(routerProvider)
          .go('/learn/mistakes/subject/sub-bio/unit/unit-1');
      await tester.pumpAndSettle();

      expect(find.byType(MistakesChaptersScreen), findsOneWidget);
      expect(rows(), findsNothing);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(rows(), findsNWidgets(2));
      expect(find.text('Cell Biology Chapters'), findsOneWidget);
      expect(calls, 2);
      verify(() => mistakes.getMistakesForSubject('sub-bio')).called(2);
    });

    testWidgets('offline pins the banner on Chapters and keeps the rows', (
      tester,
    ) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        online: false,
      );
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(MistakesChaptersScreen),
          matching: find.text('You are offline'),
        ),
        findsOneWidget,
      );
      expect(rows(), findsNWidgets(2));
    });
  });

  // -------------------------------------------------------------------------
  group('Wave 18: the Lessons frames (404:6762 · 549:19390)', () {
    setUp(() {
      when(
        () => mistakes.getMistakesForSubject(any()),
      ).thenAnswer((_) async => schoolMistakesTreeLessons());
    });

    // The frame's 402 width, without its 44 status bar (the harness has none).
    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(402, 816);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    /// Mistakes → Biology → Cell Biology → Cell Structure: its four lessons.
    Future<ProviderContainer> openLessons(
      WidgetTester tester, {
      String locale = 'en',
      ThemeData? theme,
    }) async {
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        locale: locale,
        theme: theme,
      );
      await openMistakes(tester, locale: locale);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Structure'));
      await tester.pumpAndSettle();
      expect(find.byType(MistakesLessonsScreen), findsOneWidget);
      return container;
    }

    Finder rows() => find.descendant(
      of: find.byType(MistakesLessonsScreen),
      matching: find.byType(TreeListRow),
    );
    Finder inRow(int index, Finder matching) =>
        find.descendant(of: rows().at(index), matching: matching);
    Rect header(WidgetTester tester) => _band(
      tester.getRect(
        find.descendant(
          of: find.byType(MistakesLessonsScreen),
          matching: find.byType(CatalogHeader),
        ),
      ),
    );

    // V1 / V2: the family's list rhythm. `404:6762` has one row, 25 under the
    // header; the dark frame in the Lessons slot (`404:7990`) spaces its rows
    // 16 apart, as every other list in the family does.
    for (final dark in [false, true]) {
      testWidgets('${dark ? 'dark' : 'light'}: the list starts 25 under the '
          'header, rows 16 apart, each 78 tall', (tester) async {
        phone(tester);
        await openLessons(tester, theme: dark ? AppTheme.dark : null);

        expect(rows(), findsNWidgets(4));
        expect(
          tester.getRect(rows().at(0)).top - header(tester).bottom,
          closeTo(25, 0.01),
        );
        for (var i = 0; i < 4; i++) {
          final row = tester.getRect(rows().at(i));
          expect(row.height, closeTo(78, 0.01), reason: 'row $i');
          if (i > 0) {
            final above = tester.getRect(rows().at(i - 1));
            expect(row.top - above.bottom, closeTo(16, 0.01), reason: 'gap $i');
          }
        }
      });
    }

    // V1: the frame's row `404:6782`, less the chevron the leaf does not draw.
    testWidgets(
      'the rows take the frame geometry of 404:6782, with no chevron',
      (tester) async {
        phone(tester);
        await openLessons(tester);

        final row = tester.getRect(rows().at(0));
        final badge = tester.getRect(inRow(0, find.byType(ElevatedSurface)));
        final name = tester.getRect(inRow(0, find.text('Genetics')));
        final count = tester.getRect(inRow(0, find.text('1 mistake')));
        expect(row.left, closeTo(20, 0.01));
        expect(402 - row.right, closeTo(20, 0.01));
        expect(badge.left - row.left, closeTo(17, 0.01));
        expect(badge.center.dy - row.top, closeTo(37, 0.01));
        expect(name.left - badge.right, closeTo(12, 0.01));
        expect(name.center.dy - row.top, closeTo(28, 0.01));
        expect(count.center.dy - row.top, closeTo(46.5, 0.01));
        expect(inRow(0, find.byType(Icon)), findsNothing);
      },
    );

    // F2: a leaf is inert. No chevron, no ripple, no destination, in both
    // languages; the replay quiz (`404:6853`) is deferred (owner ruling
    // 2026-09-12).
    for (final locale in ['en', 'ar']) {
      testWidgets('$locale: every lesson row is inert — no chevron, no tap '
          'handler, and a tap goes nowhere', (tester) async {
        final container = await openLessons(tester, locale: locale);
        final before = locationOf(container);

        for (var i = 0; i < 4; i++) {
          expect(inRow(i, find.byType(Icon)), findsNothing, reason: 'row $i');
          final ink = tester.widget<InkWell>(inRow(i, find.byType(InkWell)));
          expect(ink.onTap, isNull, reason: 'row $i');
          await tester.tap(rows().at(i));
          await tester.pumpAndSettle();
          expect(find.byType(MistakesLessonsScreen), findsOneWidget);
          expect(locationOf(container), before);
        }
      });
    }

    // F2 / I: one merged node per row, and not a button: it does not go
    // anywhere, so TalkBack must not say it can be pressed.
    testWidgets('each lesson row is ONE node with the whole label, not a '
        'button', (tester) async {
      final handle = tester.ensureSemantics();
      await openLessons(tester);

      for (final (i, name, count) in [
        (0, 'Genetics', '1 mistake'),
        (1, 'Membranes', '2 mistakes'),
        (2, 'Organelles', '3 mistakes'),
        (3, 'Transport', '11 mistakes'),
      ]) {
        final node = tester.getSemantics(rows().at(i));
        expect(node, isSemantics(isButton: false, hasTapAction: false));
        expect(node.label, contains('${i + 1}'));
        expect(node.label, contains(name));
        expect(node.label, contains(count));
      }
      handle.dispose();
    });

    // F3: the frames write "1 questions"; the rows pluralise, in English ...
    testWidgets('English: the lesson counts pluralise ("1 mistake")', (
      tester,
    ) async {
      await openLessons(tester);

      for (final (i, count) in [
        (0, '1 mistake'),
        (1, '2 mistakes'),
        (2, '3 mistakes'),
        (3, '11 mistakes'),
      ]) {
        expect(inRow(i, find.text(count)), findsOneWidget);
      }
      expect(find.text('1 mistakes'), findsNothing);
    });

    // ... and in Arabic, where 1, 2, 3 and 11 are four different words.
    testWidgets('Arabic: the lesson counts take the one, two, few and many '
        'forms', (tester) async {
      await openLessons(tester, locale: 'ar');

      for (final (i, count) in [
        (0, 'خطأ واحد'),
        (1, 'خطآن'),
        (2, '3 أخطاء'),
        (3, '11 خطأً'),
      ]) {
        expect(inRow(i, find.text(count)), findsOneWidget, reason: count);
      }
    });

    // I1: the row mirrors (`549:19390` keeps an unmirrored LTR row; the app
    // builds rows mirrored, DESIGN_ISSUES #64).
    testWidgets('Arabic mirrors the row: badge 17 from the right, the text '
        'starting 12 to its left, no chevron', (tester) async {
      phone(tester);
      await openLessons(tester, locale: 'ar');

      expect(find.text('دروس Cell Structure'), findsOneWidget);
      final names = ['Genetics', 'Membranes', 'Organelles', 'Transport'];
      for (var i = 0; i < 4; i++) {
        final row = tester.getRect(rows().at(i));
        final badge = tester.getRect(inRow(i, find.byType(ElevatedSurface)));
        final name = tester.getRect(inRow(i, find.text(names[i])));
        expect(row.right - badge.right, closeTo(17, 0.01), reason: 'row $i');
        expect(badge.left - name.right, closeTo(12, 0.01), reason: 'row $i');
        expect(inRow(i, find.byType(Icon)), findsNothing, reason: 'row $i');
      }
    });

    // F1: Lessons is a view over the tree Chapters already holds — the rows
    // are there on the first frame, with no skeleton and no second fetch.
    testWidgets('arriving from Chapters shows the rows at once, from the '
        'cached tree', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, mistakes: mistakes);
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cell Structure'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      expect(find.byType(MistakesLessonsScreen), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(MistakesLessonsScreen),
          matching: find.byType(CatalogListSkeleton),
        ),
        findsNothing,
      );
      expect(rows(), findsNWidgets(4));
      await tester.pumpAndSettle();
      verify(() => mistakes.getMistakesForSubject('sub-bio')).called(1);
    });

    // Loading on THIS screen: a cold link shows the list skeleton until the
    // tree arrives. (No frame draws a skeleton; it is the shared default.)
    testWidgets('a cold link shows the skeleton on Lessons until the tree '
        'arrives', (tester) async {
      final tree = Completer<MistakesTree>();
      when(
        () => mistakes.getMistakesForSubject(any()),
      ).thenAnswer((_) => tree.future);
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
      );
      await openMistakes(tester);
      container
          .read(routerProvider)
          .go('/learn/mistakes/subject/sub-bio/unit/unit-1/chapter/chap-1');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.descendant(
          of: find.byType(MistakesLessonsScreen),
          matching: find.byType(CatalogListSkeleton),
        ),
        findsOneWidget,
      );
      expect(rows(), findsNothing);

      tree.complete(schoolMistakesTreeLessons());
      await tester.pumpAndSettle();
      expect(rows(), findsNWidgets(4));
      expect(find.byType(CatalogListSkeleton), findsNothing);
    });

    // A chapter the cached tree does not have (a stale link, or a count that
    // decayed to zero and pruned the branch between two reads).
    testWidgets('a chapter the tree does not have is EMPTY, not an error, and '
        'costs no second fetch', (tester) async {
      final container = await openLessons(tester);
      container
          .read(routerProvider)
          .go('/learn/mistakes/subject/sub-bio/unit/unit-1/chapter/chap-gone');
      await tester.pumpAndSettle();

      expect(find.byType(MistakesLessonsScreen), findsOneWidget);
      expect(find.text('No mistakes yet'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.text('Retry'), findsNothing);
      expect(rows(), findsNothing);
      // No chapter, so no name to title the screen after: the bare fallback.
      expect(find.text('Lessons'), findsOneWidget);
      verify(() => mistakes.getMistakesForSubject('sub-bio')).called(1);
    });

    // States on THIS screen: a cold link whose load fails, and Retry.
    testWidgets('a failed load on Lessons offers Retry, which refetches this '
        'subject and shows the rows', (tester) async {
      var calls = 0;
      when(() => mistakes.getMistakesForSubject(any())).thenAnswer((_) async {
        calls++;
        if (calls == 1) throw const NetworkException();
        return schoolMistakesTreeLessons();
      });
      final container = await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
      );
      await openMistakes(tester);
      container
          .read(routerProvider)
          .go('/learn/mistakes/subject/sub-bio/unit/unit-1/chapter/chap-1');
      await tester.pumpAndSettle();

      expect(find.byType(MistakesLessonsScreen), findsOneWidget);
      expect(rows(), findsNothing);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(rows(), findsNWidgets(4));
      expect(find.text('Cell Structure Lessons'), findsOneWidget);
      expect(calls, 2);
      verify(() => mistakes.getMistakesForSubject('sub-bio')).called(2);
    });

    testWidgets('offline pins the banner on Lessons and keeps the rows', (
      tester,
    ) async {
      await pumpCatalogApp(
        tester,
        catalog: catalog,
        mistakes: mistakes,
        online: false,
      );
      await openMistakes(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Biology'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cell Structure'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(MistakesLessonsScreen),
          matching: find.text('You are offline'),
        ),
        findsOneWidget,
      );
      expect(rows(), findsNWidgets(4));
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
