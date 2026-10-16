import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/notifier/modules_notifier.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/catalog/widgets/module_picker.dart';
import 'package:level_up_app/features/catalog/widgets/subject_card.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';
import 'module_fixtures.dart';

/// The University module picker on the real Subjects screen (CW16b-M), driven
/// through the real router at text scale 1.3 in English and Arabic.
///
/// A module groups subjects for navigation and NOTHING else: it picks which
/// loaded subjects the grid lists. These tests hold that, and hold the other
/// half of the contract - the screen is EXACTLY what it was without modules
/// whenever the row is not drawn.
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => universitySubjects());
    when(catalog.getModules).thenAnswer((_) async => u1Modules());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => universityTree());
  });

  Finder pill(String id) => find.byKey(Key('module_pill_$id'));

  /// The subject names on screen, in layout order (row by row, start to end).
  List<String> cardNames(WidgetTester tester) => [
    for (final card in tester.widgetList<SubjectCard>(find.byType(SubjectCard)))
      card.subject.name,
  ];

  /// Boots the real app as a University student, opens Learn, then applies the
  /// text scale - the order the existing BUG-002 test uses.
  Future<ProviderContainer> openSubjects(
    WidgetTester tester, {
    String locale = 'en',
    Track track = Track.university,
    double scale = 1.3,
    Stream<bool>? onlineStream,
  }) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final container = await pumpCatalogApp(
      tester,
      catalog: catalog,
      locale: locale,
      track: track,
      onlineStream: onlineStream,
    );
    await openLearnTab(tester, locale: locale);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> choose(WidgetTester tester, String id) async {
    await tester.ensureVisible(pill(id));
    await tester.pumpAndSettle();
    await tester.tap(pill(id));
    await tester.pumpAndSettle();
  }

  Future<void> search(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
  }

  bool isSelected(WidgetTester tester, String id) =>
      tester.getSemantics(pill(id)).flagsCollection.isSelected ==
      Tristate.isTrue;

  group('University: the picker', () {
    for (final (locale, all) in [('en', 'All subjects'), ('ar', 'كل المواد')]) {
      group(locale, () {
        testWidgets('"All subjects" first and selected by default, then '
            'Foundation and Cardiovascular; every subject is listed', (
          tester,
        ) async {
          final handle = tester.ensureSemantics();
          await openSubjects(tester, locale: locale);

          expect(find.byType(ModulePicker), findsOneWidget);
          expect(find.text(all), findsOneWidget);
          expect(find.text('Foundation Module'), findsOneWidget);
          expect(find.text('Cardiovascular Module'), findsOneWidget);

          // Server order, start to end (right to left in Arabic).
          final xs = [
            for (final id in ['all', 'mod-foundation', 'mod-cardio'])
              tester.getCenter(pill(id)).dx,
          ];
          if (locale == 'en') {
            expect(xs[0], lessThan(xs[1]));
            expect(xs[1], lessThan(xs[2]));
          } else {
            expect(xs[0], greaterThan(xs[1]));
            expect(xs[1], greaterThan(xs[2]));
          }

          expect(isSelected(tester, 'all'), isTrue);
          expect(
            cardNames(tester),
            ['Anatomy', 'Physiology', 'Biochemistry', 'Histology'],
            reason: 'All subjects shows the whole list, in its own order',
          );
          expect(tester.takeException(), isNull);
          handle.dispose();
        });

        testWidgets('choosing Foundation shows only Physiology', (
          tester,
        ) async {
          await openSubjects(tester, locale: locale);

          await choose(tester, 'mod-foundation');

          expect(cardNames(tester), ['Physiology']);
          expect(tester.takeException(), isNull);
        });

        testWidgets('choosing Cardiovascular shows only Physiology', (
          tester,
        ) async {
          await openSubjects(tester, locale: locale);

          await choose(tester, 'mod-cardio');

          expect(cardNames(tester), ['Physiology']);
          expect(tester.takeException(), isNull);
        });

        testWidgets('All subjects shows everything again; Histology, '
            'Biochemistry and Anatomy are only ever under All', (tester) async {
          await openSubjects(tester, locale: locale);

          for (final id in ['mod-foundation', 'mod-cardio']) {
            await choose(tester, id);
            for (final name in ['Histology', 'Biochemistry', 'Anatomy']) {
              expect(find.text(name), findsNothing, reason: '$name under $id');
            }
          }

          await choose(tester, 'all');

          expect(cardNames(tester), hasLength(4));
          expect(find.text('Histology'), findsOneWidget);
          expect(find.text('Biochemistry'), findsOneWidget);
          expect(find.text('Anatomy'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('no overflow at 1.3 with the row, the grid and a '
            'chosen module', (tester) async {
          await openSubjects(tester, locale: locale);
          await choose(tester, 'mod-cardio');

          expect(tester.takeException(), isNull);
        });

        testWidgets('the frame\'s gaps at 1.0x: 25 from the search field to '
            'the DRAWN pill and 25 from it to the first card', (tester) async {
          // Short names, so every pill is one line even in the placeholder
          // test face (a full em per glyph) and the row is one pill tall.
          when(catalog.getModules).thenAnswer(
            (_) async => [
              module(id: 'mod-foundation', name: 'Foundation'),
              module(id: 'mod-cardio', name: 'Cardio'),
            ],
          );
          await openSubjects(tester, locale: locale, scale: 1);

          final searchBottom = tester
              .getRect(
                find
                    .ancestor(
                      of: find.byType(TextField),
                      matching: find.byType(ElevatedSurface),
                    )
                    .first,
              )
              .bottom;
          final firstCardTop = tester
              .getRect(find.byType(SubjectCard).first)
              .top;

          for (final id in ['all', 'mod-foundation', 'mod-cardio']) {
            final drawn = tester.getRect(
              find.descendant(
                of: pill(id),
                matching: find.byType(ElevatedSurface),
              ),
            );
            expect(drawn.height, closeTo(35, 0.01), reason: '$id drawn height');
            expect(
              drawn.top - searchBottom,
              closeTo(25, 0.01),
              reason: '$id: search field bottom -> drawn pill top',
            );
            expect(
              firstCardTop - drawn.bottom,
              closeTo(25, 0.01),
              reason: '$id: drawn pill bottom -> first card top',
            );
          }
          expect(tester.takeException(), isNull);
        });
      });
    }

    testWidgets('each pill is a button; only the chosen one is selected', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await openSubjects(tester);

      for (final id in ['all', 'mod-foundation', 'mod-cardio']) {
        await tester.ensureVisible(pill(id));
        await tester.pumpAndSettle();
        expect(
          tester.getSemantics(pill(id)).flagsCollection.isButton,
          isTrue,
          reason: '$id is a button',
        );
      }

      await choose(tester, 'mod-foundation');

      expect(isSelected(tester, 'mod-foundation'), isTrue);
      expect(isSelected(tester, 'all'), isFalse);
      expect(isSelected(tester, 'mod-cardio'), isFalse);
      expect(
        tester.getSemantics(pill('mod-foundation')).label,
        'Foundation Module',
      );
      handle.dispose();
    });

    testWidgets('the row sits between the search field and the grid, '
        'with a small gap below', (tester) async {
      await openSubjects(tester);

      final searchBottom = tester
          .getRect(
            find
                .ancestor(
                  of: find.byType(TextField),
                  matching: find.byType(ElevatedSurface),
                )
                .first,
          )
          .bottom;
      final row = tester.getRect(find.byType(ModulePicker));
      final firstCard = tester.getRect(find.byType(SubjectCard).first);
      final pillBottom = [
        for (final id in ['all', 'mod-foundation', 'mod-cardio'])
          tester.getRect(pill(id)).bottom,
      ].reduce((a, b) => a > b ? a : b);

      // The search field has 18.5 under it (the frame's 25 less the 6.5 the
      // pill's 48 tap box spends above the drawn 35), then the row, then the
      // grid; the row carries the same 18.5 below its tallest pill's tap box.
      expect(row.top, closeTo(searchBottom + ModulePicker.gapToTapBox, 0.01));
      expect(pillBottom, closeTo(row.bottom - ModulePicker.gapToTapBox, 0.01));
      expect(firstCard.top, closeTo(row.bottom, 0.01));
    });

    testWidgets('search filters WITHIN the chosen view', (tester) async {
      await openSubjects(tester);

      // Under All, "ana" finds Anatomy.
      await search(tester, 'ana');
      expect(cardNames(tester), ['Anatomy']);

      // Under Foundation (Physiology only) the same search matches nothing:
      // the screen's own no-match line, not the no-subjects state.
      await choose(tester, 'mod-foundation');
      expect(find.byType(SubjectCard), findsNothing);
      expect(find.text('No subjects match your search'), findsOneWidget);
      expect(find.text('No subjects yet'), findsNothing);

      // A search that matches inside the view still finds it.
      await search(tester, 'physio');
      expect(cardNames(tester), ['Physiology']);

      // Clearing it shows the whole view again, and All widens it.
      await search(tester, '');
      expect(cardNames(tester), ['Physiology']);
      await choose(tester, 'all');
      expect(cardNames(tester), hasLength(4));
    });

    testWidgets('a module\'s subjects keep the order the server sent', (
      tester,
    ) async {
      when(catalog.getModules).thenAnswer(
        (_) async => [
          module(
            id: 'mod-mixed',
            name: 'Mixed Module',
            subjectIds: const [
              'uni-histology',
              'uni-anatomy',
              'unloaded-id',
              'uni-physio',
            ],
          ),
        ],
      );
      await openSubjects(tester);

      await choose(tester, 'mod-mixed');

      expect(cardNames(tester), ['Histology', 'Anatomy', 'Physiology']);
    });

    testWidgets('an EMPTY module shows the screen\'s "no subjects" state, '
        'not the no-match line', (tester) async {
      when(catalog.getModules).thenAnswer(
        (_) async => [
          ...u1Modules(),
          module(id: 'mod-empty', name: 'Empty Module'),
        ],
      );
      await openSubjects(tester);

      await choose(tester, 'mod-empty');

      expect(find.byType(SubjectCard), findsNothing);
      expect(find.text('No subjects yet'), findsOneWidget);
      expect(find.text('No subjects match your search'), findsNothing);
      // The same widget and icon CatalogAsyncView draws for an empty list.
      final message = tester.widget<CatalogMessage>(
        find.byType(CatalogMessage),
      );
      expect(message.icon, Icons.inbox_outlined);
      // The row stays, so the student can leave the empty module.
      expect(find.byType(ModulePicker), findsOneWidget);

      await choose(tester, 'all');
      expect(cardNames(tester), hasLength(4));
    });

    testWidgets('a module whose ids load nothing is the same empty state', (
      tester,
    ) async {
      when(catalog.getModules).thenAnswer(
        (_) async => [
          module(
            id: 'mod-ghost',
            name: 'Ghost Module',
            subjectIds: const ['not-a-loaded-subject'],
          ),
        ],
      );
      await openSubjects(tester);

      await choose(tester, 'mod-ghost');

      expect(find.text('No subjects yet'), findsOneWidget);
    });

    testWidgets('the choice survives leaving the screen and coming back', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      // Default text scale: the lectures screen this walks into has its own
      // (pre-existing) 1.3 behaviour, which is not what this test is about.
      final container = await openSubjects(tester, scale: 1);
      await choose(tester, 'mod-foundation');

      // Into the subject (context.go), then back by the header's chip.
      await tester.tap(find.text('Physiology'));
      await tester.pumpAndSettle();
      expect(find.byType(SubjectsScreen), findsNothing);
      expect(container.read(selectedModuleProvider), 'mod-foundation');

      await tester.tap(find.byType(CircleBackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SubjectsScreen), findsOneWidget);
      expect(isSelected(tester, 'mod-foundation'), isTrue);
      expect(isSelected(tester, 'all'), isFalse);
      expect(cardNames(tester), ['Physiology']);
      // Neither list was fetched again to restore it.
      verify(catalog.getSubjects).called(1);
      verify(catalog.getModules).called(1);
      handle.dispose();
    });

    testWidgets('the choice survives the whole screen being torn down and '
        'rebuilt on the same ProviderContainer', (tester) async {
      // The Subjects page can stay alive under a pushed route, in which case
      // the test above proves nothing about WHERE the choice lives. This one
      // disposes the entire widget tree and mounts a fresh one: a choice kept
      // in the screen's State would be gone, a choice kept in the provider is
      // not.
      final handle = tester.ensureSemantics();
      final container = await openSubjects(tester);
      await choose(tester, 'mod-foundation');
      expect(cardNames(tester), ['Physiology']);

      await tester.pumpWidget(const SizedBox());
      expect(find.byType(SubjectsScreen), findsNothing);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SubjectsScreen), findsOneWidget);
      expect(isSelected(tester, 'mod-foundation'), isTrue);
      expect(isSelected(tester, 'all'), isFalse);
      expect(cardNames(tester), ['Physiology']);
      handle.dispose();
    });

    testWidgets('a selection the server no longer serves falls back to All '
        'subjects', (tester) async {
      final handle = tester.ensureSemantics();
      final container = await openSubjects(tester);

      container.read(selectedModuleProvider.notifier).select('mod-gone');
      await tester.pumpAndSettle();

      expect(isSelected(tester, 'all'), isTrue);
      expect(cardNames(tester), hasLength(4));
      handle.dispose();
    });

    testWidgets('a module never gates a subject: the counter and the tap '
        'work exactly as under All', (tester) async {
      // Default text scale, as above: it walks into the lectures screen.
      await openSubjects(tester, scale: 1);
      await choose(tester, 'mod-foundation');

      // Physiology is 400 / 400 - finished, and still fully tappable.
      expect(find.text('400 / 400 questions'), findsOneWidget);
      await tester.tap(find.text('Physiology'));
      await tester.pumpAndSettle();

      verify(() => catalog.getSubjectTree('uni-physio')).called(1);
    });
  });

  group('the screen is EXACTLY as before when the row is not drawn', () {
    /// The screen as it always was: the search field, then the grid 25 below.
    void expectScreenAsToday(WidgetTester tester) {
      expect(find.byType(ModulePicker), findsNothing);
      final searchBottom = tester
          .getRect(
            find
                .ancestor(
                  of: find.byType(TextField),
                  matching: find.byType(ElevatedSurface),
                )
                .first,
          )
          .bottom;
      expect(
        tester.getRect(find.byType(SubjectCard).first).top,
        closeTo(searchBottom + 25, 0.01),
        reason: 'the grid sits 25 under the search field, with no row between',
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    }

    for (final locale in ['en', 'ar']) {
      testWidgets('[$locale] a school student: [] -> no row, the school '
          'list', (tester) async {
        when(catalog.getSubjects).thenAnswer((_) async => subjects());
        when(catalog.getModules).thenAnswer((_) async => <CatalogModule>[]);
        await openSubjects(tester, locale: locale, track: Track.school);

        expect(cardNames(tester), ['Biology', 'الكيمياء', 'Physics']);
        expectScreenAsToday(tester);
      });

      testWidgets('[$locale] a University student with no modules: [] -> no '
          'row, every subject', (tester) async {
        when(catalog.getModules).thenAnswer((_) async => <CatalogModule>[]);
        await openSubjects(tester, locale: locale);

        expect(cardNames(tester), hasLength(4));
        expectScreenAsToday(tester);
      });

      testWidgets('[$locale] modules failing -> no row, no error from '
          'modules, subjects untouched', (tester) async {
        when(catalog.getModules).thenAnswer(
          (_) => Future<List<CatalogModule>>.error(const UnknownException()),
        );
        await openSubjects(tester, locale: locale);

        expect(cardNames(tester), hasLength(4));
        expect(find.byType(CatalogMessage), findsNothing);
        expectScreenAsToday(tester);
      });

      testWidgets('[$locale] modules OFFLINE -> no row, no offline view '
          'from modules', (tester) async {
        when(catalog.getModules).thenAnswer(
          (_) => Future<List<CatalogModule>>.error(const OfflineException()),
        );
        await openSubjects(tester, locale: locale);

        expect(cardNames(tester), hasLength(4));
        expect(find.byType(CatalogMessage), findsNothing);
        expectScreenAsToday(tester);
      });
    }

    testWidgets('modules still LOADING -> no row, no spinner, and the '
        'subjects do not wait for them', (tester) async {
      final pending = Completer<List<CatalogModule>>();
      when(catalog.getModules).thenAnswer((_) => pending.future);
      await openSubjects(tester);

      expect(cardNames(tester), hasLength(4), reason: 'subjects are shown');
      expectScreenAsToday(tester);

      // They arrive late: the row appears, the subjects stay.
      pending.complete(u1Modules());
      await tester.pumpAndSettle();

      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), hasLength(4));
    });

    testWidgets('a stale selection is ignored while there is no row', (
      tester,
    ) async {
      when(catalog.getModules).thenAnswer((_) async => <CatalogModule>[]);
      final container = await openSubjects(tester);

      container.read(selectedModuleProvider.notifier).select('mod-foundation');
      await tester.pumpAndSettle();

      expect(cardNames(tester), hasLength(4));
      expectScreenAsToday(tester);
    });

    testWidgets('the subjects failing is its own error view; the row '
        'never replaces it', (tester) async {
      when(catalog.getSubjects).thenAnswer(
        (_) => Future<List<Subject>>.error(const UnknownException()),
      );
      await openSubjects(tester);

      expect(find.byType(SubjectCard), findsNothing);
      expect(find.byType(CatalogMessage), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  // Riverpod 3: a provider that already had data and is loading again (or
  // failed on the reload) still carries its OLD `value`. The screen must not
  // draw the row from that stale value, so reading `.value` alone is wrong -
  // the pure helper is tested on its own, these hold the SCREEN to it.
  group('a modules reload hides the row, whatever value it still holds', () {
    /// The University screen with the row up and "Foundation" chosen, so the
    /// grid is narrowed to one subject: whether the selection is ignored once
    /// the row is hidden is then visible in the grid.
    Future<ProviderContainer> openWithFoundationChosen(
      WidgetTester tester,
    ) async {
      final container = await openSubjects(tester);
      await choose(tester, 'mod-foundation');
      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), ['Physiology']);
      return container;
    }

    const allSubjects = ['Anatomy', 'Physiology', 'Biochemistry', 'Histology'];

    testWidgets('a reload in flight -> no row and every subject, until it '
        'lands', (tester) async {
      final container = await openWithFoundationChosen(tester);

      final pending = Completer<List<CatalogModule>>();
      when(catalog.getModules).thenAnswer((_) => pending.future);
      container.invalidate(modulesProvider);
      await tester.pump();
      await tester.pump();

      // The premise: Riverpod 3 holds the old rows while it reloads.
      final reloading = container.read(modulesProvider);
      expect(reloading.isLoading, isTrue);
      expect(reloading.hasValue, isTrue);

      expect(find.byType(ModulePicker), findsNothing);
      expect(
        cardNames(tester),
        allSubjects,
        reason: 'the selection is ignored while the row is hidden',
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);

      // The reload lands: the row is back, and the choice made before applies.
      pending.complete(u1Modules());
      await tester.pumpAndSettle();

      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), ['Physiology']);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a reload that throws -> the row stays hidden and every '
        'subject is listed', (tester) async {
      final container = await openWithFoundationChosen(tester);

      when(catalog.getModules).thenAnswer(
        (_) => Future<List<CatalogModule>>.error(const UnknownException()),
      );
      container.invalidate(modulesProvider);
      await tester.pumpAndSettle();

      // The premise: it failed, and still holds the rows it had before.
      final failed = container.read(modulesProvider);
      expect(failed.hasError, isTrue);
      expect(failed.hasValue, isTrue);

      expect(find.byType(ModulePicker), findsNothing);
      expect(
        cardNames(tester),
        allSubjects,
        reason: 'the selection is ignored while the row is hidden',
      );
      // Modules failing is no error view of the screen's own.
      expect(find.byType(CatalogMessage), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  // Owner decision 2026-10-15 (SEIF1014 follow-up). Modules are never retried
  // silently by Riverpod, but a FAILED read is fetched again - when the student
  // taps the Subjects screen's Retry, and when the connection comes back while
  // the screen is mounted. A read that is loaded, loading or reloading is NOT
  // requested again, and the subjects never wait for, or fail with, any of it.
  group('a FAILED modules read is fetched again', () {
    /// The connectivity feed the app listens to. Single-subscription, so a value
    /// added before the app boots is buffered until `isOnlineProvider` listens.
    late StreamController<bool> online;

    /// How many times `GET /catalog/modules` was requested - every request
    /// counts, whichever way the stub answers it.
    var modulesRequests = 0;

    setUp(() {
      online = StreamController<bool>();
      modulesRequests = 0;
    });

    tearDown(() {
      unawaited(online.close());
    });

    void stubModules(Future<List<CatalogModule>> Function() answer) {
      when(catalog.getModules).thenAnswer((_) {
        modulesRequests++;
        return answer();
      });
    }

    Future<List<CatalogModule>> modulesFail() =>
        Future<List<CatalogModule>>.error(const UnknownException());

    void subjectsFail() => when(
      catalog.getSubjects,
    ).thenAnswer((_) => Future<List<Subject>>.error(const UnknownException()));

    void subjectsSucceed() =>
        when(catalog.getSubjects).thenAnswer((_) async => universitySubjects());

    /// Taps the Subjects screen's Retry (the subjects error view's button).
    Future<void> tapRetry(WidgetTester tester) async {
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
    }

    /// One connectivity change, then the frames it causes.
    Future<void> emit(WidgetTester tester, bool isOnline) async {
      online.add(isOnline);
      await tester.pumpAndSettle();
    }

    testWidgets('T1 Retry with the subjects AND the modules failed: both are '
        'requested again and the row appears', (tester) async {
      subjectsFail();
      stubModules(modulesFail);
      final container = await openSubjects(tester, onlineStream: online.stream);

      // The premise: both failed, so the screen is the subjects error view.
      expect(find.text('Retry'), findsOneWidget);
      expect(container.read(modulesProvider).hasError, isTrue);
      expect(find.byType(ModulePicker), findsNothing);
      expect(modulesRequests, 1);

      subjectsSucceed();
      stubModules(() async => u1Modules());
      await tapRetry(tester);

      expect(modulesRequests, 2, reason: 'a failed read is fetched again');
      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), hasLength(4));
      expect(tester.takeException(), isNull);
    });

    testWidgets('T2 Retry with the subjects failed but the modules loaded: a '
        'healthy read is not requested again', (tester) async {
      subjectsFail();
      stubModules(() async => u1Modules());
      await openSubjects(tester, onlineStream: online.stream);

      expect(find.text('Retry'), findsOneWidget);
      expect(modulesRequests, 1);

      subjectsSucceed();
      await tapRetry(tester);

      expect(modulesRequests, 1, reason: 'loaded modules are never refetched');
      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), hasLength(4));
      expect(tester.takeException(), isNull);
    });

    testWidgets('T3 Retry while the modules STILL fail: the subjects load, no '
        'row, and no error from modules', (tester) async {
      subjectsFail();
      stubModules(modulesFail);
      await openSubjects(tester, onlineStream: online.stream);
      expect(find.text('Retry'), findsOneWidget);

      subjectsSucceed();
      await tapRetry(tester);

      expect(cardNames(tester), hasLength(4));
      expect(find.byType(ModulePicker), findsNothing);
      expect(find.byType(CatalogMessage), findsNothing);
      expect(find.text('Retry'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('T4 Retry with the modules refetch still pending: the subjects '
        'are listed meanwhile, no row, no spinner; it lands, the row appears', (
      tester,
    ) async {
      subjectsFail();
      stubModules(modulesFail);
      await openSubjects(tester, onlineStream: online.stream);
      expect(find.text('Retry'), findsOneWidget);

      subjectsSucceed();
      final pending = Completer<List<CatalogModule>>();
      stubModules(() => pending.future);
      await tapRetry(tester);

      // The refetch is in flight and has not answered: the subjects do not wait.
      expect(modulesRequests, 2);
      expect(cardNames(tester), hasLength(4));
      expect(find.byType(ModulePicker), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CatalogMessage), findsNothing);
      expect(tester.takeException(), isNull);

      pending.complete(u1Modules());
      await tester.pumpAndSettle();

      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), hasLength(4));
      expect(modulesRequests, 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('T5 the connection comes back after an offline modules '
        'failure: they are fetched again and the row appears', (tester) async {
      online.add(false); // Buffered: the app boots already offline.
      stubModules(() => Future.error(const OfflineException()));
      final container = await openSubjects(tester, onlineStream: online.stream);

      // The premise: offline, the modules read failed, the subjects are fine.
      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(container.read(modulesProvider).hasError, isTrue);
      expect(find.byType(ModulePicker), findsNothing);
      expect(cardNames(tester), hasLength(4));
      expect(modulesRequests, 1);

      stubModules(() async => u1Modules());
      await emit(tester, true);

      expect(modulesRequests, 2, reason: 'the reconnect fetched them again');
      expect(find.byType(OfflineBanner), findsNothing);
      expect(find.byType(ModulePicker), findsOneWidget);
      // The subjects were never touched by it.
      expect(cardNames(tester), hasLength(4));
      verify(catalog.getSubjects).called(1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('T6 loaded modules: going offline and back online does not '
        'request them again', (tester) async {
      stubModules(() async => u1Modules());
      await openSubjects(tester, onlineStream: online.stream);
      expect(find.byType(ModulePicker), findsOneWidget);
      expect(modulesRequests, 1);

      await emit(tester, false);
      expect(find.byType(OfflineBanner), findsOneWidget);
      await emit(tester, true);

      expect(find.byType(OfflineBanner), findsNothing);
      expect(modulesRequests, 1, reason: 'a healthy read is not requested');
      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), hasLength(4));
      expect(tester.takeException(), isNull);
    });

    testWidgets('T7 failed modules: the FIRST connectivity value (unknown -> '
        'online) and online -> online request nothing', (tester) async {
      stubModules(modulesFail);
      final container = await openSubjects(tester, onlineStream: online.stream);
      expect(container.read(modulesProvider).hasError, isTrue);
      expect(modulesRequests, 1);

      await emit(tester, true); // The first value ever: unknown -> online.
      expect(modulesRequests, 1, reason: 'unknown -> online is no reconnect');

      await emit(tester, true); // online -> online.
      expect(modulesRequests, 1, reason: 'online -> online is no reconnect');

      expect(container.read(modulesProvider).hasError, isTrue);
      expect(find.byType(ModulePicker), findsNothing);
      expect(cardNames(tester), hasLength(4));
      expect(tester.takeException(), isNull);
    });

    testWidgets('T8 the connection comes back while the modules refetch is '
        'already in flight: it is not requested a third time', (tester) async {
      online.add(false); // Buffered: the app boots already offline.
      subjectsFail();
      stubModules(modulesFail);
      final container = await openSubjects(tester, onlineStream: online.stream);

      // The premise: offline, the subjects AND the modules failed.
      expect(find.text('Retry'), findsOneWidget);
      expect(container.read(modulesProvider).hasError, isTrue);
      expect(modulesRequests, 1);

      // Retry requests the modules again (#2) and this one does not answer.
      // Riverpod 3 keeps the old error on a reload, so the read is now BOTH
      // `hasError` and `isLoading`: failed, and already being fetched.
      subjectsSucceed();
      final pending = Completer<List<CatalogModule>>();
      stubModules(() => pending.future);
      await tapRetry(tester);

      expect(modulesRequests, 2, reason: 'Retry fetched the failed read again');
      final inFlight = container.read(modulesProvider);
      expect(inFlight.hasError, isTrue);
      expect(inFlight.isLoading, isTrue);
      expect(find.byType(ModulePicker), findsNothing);

      // The connection comes back while #2 is still in flight. A read that is
      // being fetched is NOT requested again, even though it still holds the
      // error: removing `!isLoading` from `_refetchFailedModules` makes this 3.
      await emit(tester, true);

      expect(
        modulesRequests,
        2,
        reason: 'a read in flight is not a failed one',
      );
      expect(find.byType(ModulePicker), findsNothing);
      expect(cardNames(tester), hasLength(4));
      expect(tester.takeException(), isNull);

      pending.complete(u1Modules());
      await tester.pumpAndSettle();

      expect(find.byType(ModulePicker), findsOneWidget);
      expect(cardNames(tester), hasLength(4));
      expect(modulesRequests, 2);
      expect(tester.takeException(), isNull);
    });
  });
}
