import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/catalog/widgets/subject_card.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// Subjects · Figma `337:5702`, driven through the real router.
///
/// Covers the Definition of Done for this screen: loading / empty / error /
/// offline, EN and AR (RTL), light and dark — plus the two rules that are easy
/// to break silently (client-side search, display-only counter).
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());
  });

  group('loaded', () {
    testWidgets('renders a 2-column grid from GET /catalog/subjects', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      expect(find.byType(SubjectsScreen), findsOneWidget);
      expect(find.text('Subjects'), findsWidgets);
      expect(find.byType(SubjectCard), findsNWidgets(3));

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('each card shows its own server counter', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      expect(find.text('216 / 480 questions'), findsOneWidget);
      expect(find.text('480 / 480 questions'), findsOneWidget);
      expect(find.text('0 / 0 questions'), findsOneWidget);
      // The frame's mock figures are never hardcoded — only what the API sent.
      expect(find.text('216 / 480 questions'), findsOneWidget);
    });

    testWidgets('the progress bar is driven by answered/total', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      final bars = tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .toList();

      expect(bars[0].value, closeTo(216 / 480, 0.001));
      expect(bars[1].value, 1.0);
      expect(bars[2].value, 0.0); // 0/0 draws empty, not NaN
    });

    testWidgets('a finished or empty counter never disables or hides a card', (
      tester,
    ) async {
      // The contract: questionCounter "never locks retakes". A 480/480 subject
      // and a 0/0 subject must both be present AND tappable.
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      expect(find.byType(SubjectCard), findsNWidgets(3));
      for (final card in tester.widgetList<SubjectCard>(
        find.byType(SubjectCard),
      )) {
        expect(
          card.onTap,
          isNotNull,
          reason: '${card.subject.name} not tappable',
        );
      }

      // Prove it for the FINISHED one by actually opening it. The Units screen
      // titles itself after the subject (Figma 337:5894, "Biology Units").
      await tester.tap(find.text('الكيمياء'));
      await tester.pumpAndSettle();
      expect(find.text('الكيمياء Units'), findsOneWidget);
    });
  });

  group('search', () {
    testWidgets('filters client-side without calling the API', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      await tester.enterText(find.byType(TextField), 'phys');
      await tester.pumpAndSettle();

      expect(find.byType(SubjectCard), findsOneWidget);
      expect(find.text('Physics'), findsOneWidget);
      expect(find.text('Biology'), findsNothing);
      // There is no search endpoint; typing must not cost a round trip.
      verify(catalog.getSubjects).called(1);
    });

    testWidgets('a query that matches nothing shows its own message', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pumpAndSettle();

      expect(find.byType(SubjectCard), findsNothing);
      // Distinct from "you have no subjects".
      expect(find.text('No subjects match your search'), findsOneWidget);
      expect(find.text('No subjects yet'), findsNothing);
    });

    testWidgets('clearing the query restores the full list', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      await tester.enterText(find.byType(TextField), 'phys');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(find.byType(SubjectCard), findsNWidgets(3));
    });
  });

  group('states', () {
    testWidgets('loading shows a skeleton grid, not a bare spinner', (
      tester,
    ) async {
      final completer = Completer<List<Subject>>();
      when(catalog.getSubjects).thenAnswer((_) => completer.future);

      await pumpCatalogApp(tester, catalog: catalog);
      await tester.tap(find.text('Learn').last);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SubjectCard), findsNothing);
      expect(find.byType(GridView), findsOneWidget); // the skeleton grid

      completer.complete(subjects());
      await tester.pumpAndSettle();
      expect(find.byType(SubjectCard), findsNWidgets(3));
    });

    testWidgets('empty catalog gets its own message, not a blank grid', (
      tester,
    ) async {
      when(catalog.getSubjects).thenAnswer((_) async => <Subject>[]);

      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      expect(find.text('No subjects yet'), findsOneWidget);
      expect(find.byType(SubjectCard), findsNothing);
    });

    testWidgets('error shows copy + a retry that re-requests', (tester) async {
      when(catalog.getSubjects).thenAnswer(
        (_) => Future<List<Subject>>.error(const UnknownException()),
      );

      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      expect(find.text('Something went wrong'), findsOneWidget);

      when(catalog.getSubjects).thenAnswer((_) async => subjects());
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.byType(SubjectCard), findsNWidgets(3));
      verify(catalog.getSubjects).called(2);
    });

    testWidgets('offline gets its own view, distinct from a generic error', (
      tester,
    ) async {
      when(catalog.getSubjects).thenAnswer(
        (_) => Future<List<Subject>>.error(const OfflineException()),
      );

      await pumpCatalogApp(tester, catalog: catalog, online: false);
      await openLearnTab(tester);

      expect(find.text('You are offline'), findsWidgets);
      expect(find.text('Something went wrong'), findsNothing);
    });
  });

  group('languages and themes', () {
    testWidgets('Arabic renders RTL with Arabic copy', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, locale: 'ar');
      await openLearnTab(tester, locale: 'ar');

      expect(find.text('المواد'), findsWidgets);
      expect(find.text('أخطائي'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(SubjectsScreen))),
        TextDirection.rtl,
      );
      // Server copy is rendered verbatim — it is already localized (adr-018).
      expect(find.text('Biology'), findsOneWidget);
    });

    testWidgets('the counter is localized in Arabic', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, locale: 'ar');
      await openLearnTab(tester, locale: 'ar');

      expect(find.textContaining('سؤال'), findsNWidgets(3));
    });

    testWidgets('dark theme renders the same content', (tester) async {
      await pumpCatalogApp(tester, catalog: catalog, theme: AppTheme.dark);
      await openLearnTab(tester);

      expect(find.byType(SubjectCard), findsNWidgets(3));
      expect(find.text('216 / 480 questions'), findsOneWidget);
    });
  });

  testWidgets('Mistakes is no longer a stub — the snackbar is gone', (
    tester,
  ) async {
    // This test used to assert the opposite: that tapping Mistakes showed
    // "Coming soon" and went nowhere. It was right for four waves, for one
    // reason — no endpoint. `GET /me/mistakes` shipped `stable` at contract
    // 3.10.0-m1 and the stub was removed on 2026-09-12 (Day 10).
    //
    // Kept, inverted, rather than deleted: the snackbar coming back would mean
    // someone reverted the entry point, and that should fail loudly here. The
    // destination itself is covered in test/features/mistakes/.
    await pumpCatalogApp(tester, catalog: catalog);
    await openLearnTab(tester);

    await tester.tap(find.text('Mistakes'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Coming soon'), findsNothing);
  });

  // -------------------------------------------------------------------------
  /// edit3.md #7 — the header pill, and the tap target it cannot have.
  ///
  /// The pill is the frame's 35 dp and so is its target, because
  /// `CatalogHeader` is a 35-tall box and a render box refuses a pointer
  /// outside its own size. That is a finding, not a build choice
  /// (DESIGN_ISSUES #80), and it is pinned here so that the day the header
  /// grows, this test is what says so.
  group('the Mistakes pill (edit3 #7)', () {
    testWidgets('is the frame\'s 35 dp pill, tappable over exactly itself', (
      tester,
    ) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);

      final pill = tester.getRect(
        find.ancestor(
          of: find.text('Mistakes'),
          matching: find.byType(ElevatedSurface),
        ),
      );
      expect(pill.height, 35);

      // The reachable band, measured by hit-testing rather than assumed.
      //
      // Membership of the PILL'S OWN ink box, not "some pointer listener":
      // the nav shell and the header behind it carry listeners of their own,
      // so the loose question answers `true` everywhere and proves nothing.
      final ink = tester.renderObject(
        find.descendant(
          of: find.ancestor(
            of: find.text('Mistakes'),
            matching: find.byType(ElevatedSurface),
          ),
          matching: find.byType(InkWell),
        ),
      );
      bool reaches(double dy) => tester
          .hitTestOnBinding(Offset(pill.center.dx, pill.center.dy + dy))
          .path
          .any((e) => identical(e.target, ink));

      expect(reaches(0), isTrue);
      expect(reaches(-15.5), isTrue);
      expect(reaches(15.5), isTrue);
      // 24 dp would be inside a 48 dp target. It is not reachable.
      expect(reaches(-24), isFalse, reason: 'DESIGN_ISSUES #80');
      expect(reaches(24), isFalse, reason: 'DESIGN_ISSUES #80');
    });

    testWidgets(
      'announces as a BUTTON, in one node, like the one it replaced',
      (tester) async {
        // The `OutlinedButton` this replaced carried the button flag for free.
        // `ElevatedSurface` adds no semantics and its `InkWell` exposes only a
        // tap action, so losing the flag here would be a silent TalkBack
        // regression that nothing else in this file would notice.
        // Disposed inline rather than in a tear-down: the framework checks that
        // no handle is live at the end of the test BODY, which is before
        // tear-downs run.
        final handle = tester.ensureSemantics();

        await pumpCatalogApp(tester, catalog: catalog);
        await openLearnTab(tester);

        expect(
          tester.getSemantics(find.text('Mistakes')),
          matchesSemantics(
            label: 'Mistakes',
            isButton: true,
            hasTapAction: true,
            hasFocusAction: true,
            hasEnabledState: false,
            isFocusable: true,
          ),
        );

        handle.dispose();
      },
    );

    testWidgets('a tap pushes the overview exactly once', (tester) async {
      final container = await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);
      expect(locationOf(container), '/learn');

      await tester.tap(find.text('Mistakes'));
      await tester.pumpAndSettle();
      expect(locationOf(container), '/learn/mistakes');

      // ONE push, not two. The location alone cannot tell them apart — two
      // pushes of the same route read the same — so the stack DEPTH is what is
      // asserted: after a single pop we must be back on Subjects.
      container.read(routerProvider).pop();
      await tester.pumpAndSettle();
      expect(locationOf(container), '/learn');
    });
  });
}
