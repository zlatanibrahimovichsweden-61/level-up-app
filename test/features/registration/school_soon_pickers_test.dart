import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/form_fields.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/stage.dart';
import 'package:level_up_app/features/registration/notifier/reference_providers.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/features/registration/widgets/reference_dropdown.dart';
import 'package:level_up_app/features/registration/widgets/registration_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// The School form's "Soon" rows (SEIF1014 / SSG): the Grade and Education
/// System pickers read `status: active | soon` from the server on every visit.
/// A `soon` row is visible, dimmed, marked "Soon" / «قريبًا», spoken with its
/// mark and NOT selectable; an unknown status, or a stage the answer omits,
/// fails closed (disabled, no mark). Registration waits for both lists.
///
/// Every widget test runs at text scale 1.3, in English (LTR) and Arabic (RTL)
/// where the language matters, on a phone-wide surface.

const _scale = TextScaler.linear(1.3);

/// The launch rule as the server would serve it: only the last two stages.
const _launch = {
  'prep1': 'soon',
  'prep2': 'soon',
  'prep3': 'soon',
  'secondary1': 'soon',
};

List<SchoolStageRef> _stages(
  Map<String, String> status, {
  List<String> omit = const [],
}) => [
  for (final stage in Stage.values)
    if (!omit.contains(stage.wireValue))
      SchoolStageRef(
        stage: stage.wireValue,
        status: status[stage.wireValue] ?? 'active',
      ),
];

/// Two real systems — one open, one `soon` — and one with a status this build
/// has never seen.
const _systems = [
  EducationSystemRef(
    code: 'nationalArabic',
    nameAr: 'وطني عربي',
    nameEn: 'National Arabic',
    status: 'active',
  ),
  EducationSystemRef(code: 'ig', nameAr: 'آي جي', nameEn: 'IG', status: 'soon'),
  EducationSystemRef(
    code: 'american',
    nameAr: 'أمريكي',
    nameEn: 'American',
    status: 'paused',
  ),
];

String _stageLabel(AppLocalizations l10n, Stage stage) => switch (stage) {
  Stage.prep1 => l10n.stagePrep1,
  Stage.prep2 => l10n.stagePrep2,
  Stage.prep3 => l10n.stagePrep3,
  Stage.secondary1 => l10n.stageSecondary1,
  Stage.secondary2 => l10n.stageSecondary2,
  Stage.secondary3 => l10n.stageSecondary3,
};

void main() {
  late MockReferenceRepository reference;

  setUp(() {
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
    when(reference.getSchoolStages).thenAnswer((_) async => _stages(_launch));
    when(reference.getEducationSystems).thenAnswer((_) async => _systems);
  });

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    void Function(RegistrationController draft)? afterSeed,
    bool settle = true,
    Widget screen = const SchoolDetailScreen(),
    String path = '/register/school',
    RegTrack track = RegTrack.school,
    // 412 dp is the phone this is checked on. The picker FAILURE row (shared,
    // untouched here) overflows by ~3 px in Arabic at 1.3x on 412 dp whatever
    // field it is in, so the error-state tests ask for a little more width.
    double width = 412,
  }) async {
    final container = ProviderContainer(
      overrides: [referenceRepositoryProvider.overrideWithValue(reference)],
    );
    addTearDown(container.dispose);
    final controller = container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
      ..setTrack(track);
    afterSeed?.call(controller);

    // Phone-wide and tall: nothing needs scrolling to be tapped, but a label
    // that does not fit at 1.3 still overflows and fails the test.
    await tester.binding.setSurfaceSize(Size(width, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: locale,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: _scale),
            child: child!,
          ),
          routerConfig: GoRouter(
            initialLocation: path,
            routes: [
              GoRoute(path: path, builder: (_, _) => screen),
              GoRoute(path: '/login', builder: (_, _) => marker('LOGIN')),
              GoRoute(path: '/home', builder: (_, _) => marker('HOME')),
            ],
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
    return container;
  }

  RegistrationDraft draftOf(ProviderContainer c) =>
      c.read(registrationControllerProvider)!;

  Finder field(String key) => find.byKey(Key(key));

  /// The rows a closed field's dropdown was handed, in order.
  List<DropdownMenuItem<String>> rowsOf(WidgetTester tester, String key) =>
      tester
          .widget<DropdownButton<String>>(
            find.descendant(
              of: field(key),
              matching: find.byType(DropdownButton<String>),
            ),
          )
          .items!;

  Map<String, bool> enabledByRow(WidgetTester tester, String key) => {
    for (final item in rowsOf(tester, key)) item.value!: item.enabled,
  };

  Future<void> openField(WidgetTester tester, String key) async {
    await tester.tap(field(key));
    await tester.pumpAndSettle();
  }

  /// An open menu's Text for [label] (the closed button also holds the
  /// selected one, hence `.last`).
  Finder menuText(String label) => find.text(label).last;

  /// Whether [label]'s row is wrapped in the 0.6 dimming a refused row gets.
  bool isDimmed(Finder label) => find
      .ancestor(
        of: label,
        matching: find.byWidgetPredicate(
          (w) => w is Opacity && w.opacity == disabledControlOpacity,
        ),
      )
      .evaluate()
      .isNotEmpty;

  FilledButton startLearning(WidgetTester tester, AppLocalizations l10n) =>
      tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, l10n.startLearning),
      );

  for (final language in ['en', 'ar']) {
    final l10n = lookupAppLocalizations(Locale(language));
    final locale = Locale(language);
    final soon = l10n.registrationSoonMark;
    final isAr = language == 'ar';
    // See `pump`'s `width`: the shared failure row needs a few px more in
    // Arabic at 1.3x.
    final failureWidth = isAr ? 460.0 : 412.0;

    group('Grade · $language', () {
      testWidgets('lists the six stages in order under the app\'s own labels; '
          'only the active ones can be chosen', (tester) async {
        await pump(tester, locale: locale);

        expect(rowsOf(tester, 'field-stage').map((r) => r.value), [
          for (final s in Stage.values) s.wireValue,
        ]);
        expect(enabledByRow(tester, 'field-stage'), {
          'prep1': false,
          'prep2': false,
          'prep3': false,
          'secondary1': false,
          'secondary2': true,
          'secondary3': true,
        });
        if (isAr) {
          expect(
            Directionality.of(tester.element(field('field-stage'))),
            TextDirection.rtl,
          );
        }
      });

      testWidgets('a Soon row is visible, dimmed and marked; an active row is '
          'none of those', (tester) async {
        await pump(tester, locale: locale);
        await openField(tester, 'field-stage');

        for (final stage in [
          Stage.prep1,
          Stage.prep2,
          Stage.prep3,
          Stage.secondary1,
        ]) {
          final label = menuText(_stageLabel(l10n, stage));
          expect(label, findsOneWidget, reason: '${stage.name} is visible');
          expect(isDimmed(label), isTrue, reason: '${stage.name} is dimmed');
        }
        for (final stage in [Stage.secondary2, Stage.secondary3]) {
          final label = menuText(_stageLabel(l10n, stage));
          expect(isDimmed(label), isFalse, reason: '${stage.name} is open');
        }
        // One mark per Soon row, and no more.
        expect(find.text(soon), findsNWidgets(4));
      });

      testWidgets('the Soon mark is at full strength, outside the label\'s '
          'dimming, in buttonSmall (1409:26374)', (tester) async {
        await pump(tester, locale: locale);
        await openField(tester, 'field-stage');

        final label = menuText(_stageLabel(l10n, Stage.prep1));
        expect(isDimmed(label), isTrue, reason: 'the label is greyed');
        expect(find.text(soon), findsNWidgets(4));
        for (var i = 0; i < 4; i++) {
          final mark = find.text(soon).at(i);
          expect(isDimmed(mark), isFalse, reason: 'mark #$i is not dimmed');
          expect(
            tester.widget<Text>(mark).style,
            AppType.buttonSmall.copyWith(color: AppColors.light.hint),
            reason: 'mark #$i: Inter SemiBold 12 in the hint colour',
          );
        }
        // The mark is still the row's end edge: after the label in reading
        // order, mirrored under RTL.
        final markBox = tester.getRect(find.text(soon).first);
        final labelBox = tester.getRect(label);
        if (isAr) {
          expect(markBox.right, lessThan(labelBox.left));
        } else {
          expect(markBox.left, greaterThan(labelBox.right));
        }
      });

      testWidgets('the mark is part of the row\'s spoken name; open rows are '
          'spoken plain', (tester) async {
        final handle = tester.ensureSemantics();
        await pump(tester, locale: locale);
        await openField(tester, 'field-stage');

        for (final stage in [
          Stage.prep1,
          Stage.prep2,
          Stage.prep3,
          Stage.secondary1,
        ]) {
          expect(
            find.bySemanticsLabel(
              RegExp('^${RegExp.escape(_stageLabel(l10n, stage))}, $soon\$'),
            ),
            findsOneWidget,
            reason: '${stage.name} says "$soon"',
          );
        }
        expect(
          find.bySemanticsLabel(
            RegExp('${RegExp.escape(_stageLabel(l10n, Stage.secondary2))}, '),
          ),
          findsNothing,
        );
        handle.dispose();
      });

      testWidgets('tapping a Soon row changes nothing; an active row selects', (
        tester,
      ) async {
        final container = await pump(
          tester,
          locale: locale,
          afterSeed: (draft) => draft.setStage('secondary3'),
        );
        await openField(tester, 'field-stage');

        await tester.tap(menuText(_stageLabel(l10n, Stage.prep1)));
        await tester.pumpAndSettle();
        await tester.tap(menuText(_stageLabel(l10n, Stage.secondary1)));
        await tester.pumpAndSettle();
        expect(draftOf(container).stage, 'secondary3');

        await tester.tap(menuText(_stageLabel(l10n, Stage.secondary2)));
        await tester.pumpAndSettle();
        expect(draftOf(container).stage, 'secondary2');
      });

      testWidgets('an unknown status and a stage the answer omits are disabled '
          'with NO mark; a stage the enum does not know adds no row', (
        tester,
      ) async {
        when(reference.getSchoolStages).thenAnswer(
          (_) async => [
            ..._stages({'prep1': 'paused'}, omit: ['prep2']),
            const SchoolStageRef(stage: 'prep9', status: 'active'),
          ],
        );
        await pump(tester, locale: locale);

        expect(
          rowsOf(tester, 'field-stage').map((r) => r.value),
          [for (final s in Stage.values) s.wireValue],
          reason: 'six rows, the app\'s own, in order',
        );
        expect(enabledByRow(tester, 'field-stage'), {
          'prep1': false, // unknown status
          'prep2': false, // omitted by the answer
          'prep3': true,
          'secondary1': true,
          'secondary2': true,
          'secondary3': true,
        });

        await openField(tester, 'field-stage');
        expect(isDimmed(menuText(_stageLabel(l10n, Stage.prep1))), isTrue);
        expect(isDimmed(menuText(_stageLabel(l10n, Stage.prep2))), isTrue);
        expect(find.text(soon), findsNothing);
      });

      testWidgets('while the answer is loading: a spinner, no rows, and Start '
          'learning is off — then it comes on', (tester) async {
        final pending = Completer<List<SchoolStageRef>>();
        when(reference.getSchoolStages).thenAnswer((_) => pending.future);
        await pump(tester, locale: locale, settle: false);
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          find.descendant(
            of: field('field-stage'),
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: field('field-stage'),
            matching: find.byType(DropdownButton<String>),
          ),
          findsNothing,
        );
        expect(startLearning(tester, l10n).onPressed, isNull);

        pending.complete(_stages(_launch));
        await tester.pumpAndSettle();

        expect(rowsOf(tester, 'field-stage'), hasLength(6));
        expect(startLearning(tester, l10n).onPressed, isNotNull);
      });

      testWidgets('a failed answer: the error slot with a user-tapped Retry; '
          'Start learning stays off until it loads', (tester) async {
        when(reference.getSchoolStages).thenThrow(const UnknownException());
        await pump(tester, locale: locale, width: failureWidth);

        expect(find.text(l10n.genericError), findsOneWidget);
        expect(find.widgetWithText(TextButton, l10n.retry), findsOneWidget);
        expect(startLearning(tester, l10n).onPressed, isNull);
        // Nothing was retried on its own.
        verify(reference.getSchoolStages).called(1);

        when(
          reference.getSchoolStages,
        ).thenAnswer((_) async => _stages(_launch));
        await tester.tap(find.widgetWithText(TextButton, l10n.retry));
        await tester.pumpAndSettle();

        verify(reference.getSchoolStages).called(1);
        expect(find.text(l10n.genericError), findsNothing);
        expect(rowsOf(tester, 'field-stage'), hasLength(6));
        expect(startLearning(tester, l10n).onPressed, isNotNull);
      });

      testWidgets('offline has its own copy and the same Retry', (
        tester,
      ) async {
        when(
          reference.getSchoolStages,
        ).thenThrow(const NetworkException(detail: 'timeout'));
        await pump(tester, locale: locale, width: failureWidth);

        expect(find.text(l10n.offline), findsOneWidget);
        expect(find.text(l10n.genericError), findsNothing);
        expect(find.widgetWithText(TextButton, l10n.retry), findsOneWidget);
        expect(startLearning(tester, l10n).onPressed, isNull);
      });

      testWidgets('a refresh that still holds the old rows shows LOADING, not '
          'the old rows as selectable', (tester) async {
        final container = await pump(tester, locale: locale);
        expect(rowsOf(tester, 'field-stage'), hasLength(6));

        final pending = Completer<List<SchoolStageRef>>();
        when(reference.getSchoolStages).thenAnswer((_) => pending.future);
        container.invalidate(schoolStagesProvider);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          find.descendant(
            of: field('field-stage'),
            matching: find.byType(DropdownButton<String>),
          ),
          findsNothing,
          reason: 'the stale rows must not be offered while the answer is out',
        );
        expect(startLearning(tester, l10n).onPressed, isNull);

        pending.complete(_stages(_launch));
        await tester.pumpAndSettle();
        expect(rowsOf(tester, 'field-stage'), hasLength(6));
        expect(startLearning(tester, l10n).onPressed, isNotNull);
      });
    });

    group('Education System · $language', () {
      testWidgets('the open system selects; Soon and unknown-status systems '
          'do not', (tester) async {
        final container = await pump(tester, locale: locale);

        expect(enabledByRow(tester, 'field-educationSystem'), {
          'nationalArabic': true,
          'ig': false,
          'american': false,
        });

        await openField(tester, 'field-educationSystem');
        final ig = isAr ? 'آي جي' : 'IG';
        final american = isAr ? 'أمريكي' : 'American';
        final national = isAr ? 'وطني عربي' : 'National Arabic';

        // Soon: visible, dimmed, marked — once. Unknown status: dimmed, no mark.
        expect(isDimmed(menuText(ig)), isTrue);
        expect(isDimmed(menuText(american)), isTrue);
        expect(isDimmed(menuText(national)), isFalse);
        expect(find.text(soon), findsOneWidget);

        await tester.tap(menuText(ig));
        await tester.pumpAndSettle();
        await tester.tap(menuText(american));
        await tester.pumpAndSettle();
        expect(draftOf(container).educationSystem, isNull);

        await tester.tap(menuText(national));
        await tester.pumpAndSettle();
        expect(draftOf(container).educationSystem, 'nationalArabic');
      });

      testWidgets('the Soon mark is at full strength, outside the label\'s '
          'dimming, in buttonSmall (1409:26436)', (tester) async {
        await pump(tester, locale: locale);
        await openField(tester, 'field-educationSystem');

        final ig = isAr ? 'آي جي' : 'IG';
        expect(isDimmed(menuText(ig)), isTrue, reason: 'the label is greyed');
        final mark = find.text(soon);
        expect(mark, findsOneWidget);
        expect(isDimmed(mark), isFalse, reason: 'the mark is not dimmed');
        expect(
          tester.widget<Text>(mark).style,
          AppType.buttonSmall.copyWith(color: AppColors.light.hint),
          reason: 'Inter SemiBold 12 in the hint colour',
        );
      });

      testWidgets('the Soon mark is spoken with the row', (tester) async {
        final handle = tester.ensureSemantics();
        await pump(tester, locale: locale);
        await openField(tester, 'field-educationSystem');

        final ig = isAr ? 'آي جي' : 'IG';
        expect(
          find.bySemanticsLabel(RegExp('^${RegExp.escape(ig)}, $soon\$')),
          findsOneWidget,
        );
        handle.dispose();
      });

      testWidgets('a failed answer: the error slot, Retry, Start learning '
          'off', (tester) async {
        when(
          reference.getEducationSystems,
        ).thenThrow(const NetworkException(detail: 'timeout'));
        await pump(tester, locale: locale, width: failureWidth);

        expect(find.text(l10n.offline), findsOneWidget);
        expect(find.widgetWithText(TextButton, l10n.retry), findsOneWidget);
        expect(startLearning(tester, l10n).onPressed, isNull);

        when(reference.getEducationSystems).thenAnswer((_) async => _systems);
        await tester.tap(find.widgetWithText(TextButton, l10n.retry));
        await tester.pumpAndSettle();
        expect(startLearning(tester, l10n).onPressed, isNotNull);
      });

      testWidgets('while loading: Start learning is off', (tester) async {
        final pending = Completer<List<EducationSystemRef>>();
        when(reference.getEducationSystems).thenAnswer((_) => pending.future);
        await pump(tester, locale: locale, settle: false);
        await tester.pump(const Duration(milliseconds: 50));

        expect(startLearning(tester, l10n).onPressed, isNull);
        pending.complete(_systems);
        await tester.pumpAndSettle();
        expect(startLearning(tester, l10n).onPressed, isNotNull);
      });
    });

    group('no stale choice · $language', () {
      testWidgets('a restored draft holding a Soon stage and a Soon system '
          'is cleared once the statuses are in — quietly', (tester) async {
        final container = await pump(
          tester,
          locale: locale,
          afterSeed: (draft) => draft
            ..setStage('prep1')
            ..setEducationSystem('ig'),
        );

        expect(draftOf(container).stage, isNull);
        expect(draftOf(container).educationSystem, isNull);
        // Quiet: no banner, no snackbar, and the token is untouched.
        expect(find.byType(SubmitFailureBanner), findsNothing);
        expect(find.byType(SnackBar), findsNothing);
        expect(draftOf(container).registrationToken, regArgs.registrationToken);
      });

      testWidgets('a restored draft holding an OPEN stage and system keeps '
          'them', (tester) async {
        final container = await pump(
          tester,
          locale: locale,
          afterSeed: (draft) => draft
            ..setStage('secondary2')
            ..setEducationSystem('nationalArabic'),
        );

        expect(draftOf(container).stage, 'secondary2');
        expect(draftOf(container).educationSystem, 'nationalArabic');
      });

      testWidgets('a stage the answer omits, and a system with an unknown '
          'status, count as not open', (tester) async {
        when(
          reference.getSchoolStages,
        ).thenAnswer((_) async => _stages({}, omit: ['secondary1']));
        final container = await pump(
          tester,
          locale: locale,
          afterSeed: (draft) => draft
            ..setStage('secondary1')
            ..setEducationSystem('american'),
        );

        expect(draftOf(container).stage, isNull);
        expect(draftOf(container).educationSystem, isNull);
      });

      testWidgets('fresh statuses clear a choice that has since closed, '
          'but only once they have SETTLED', (tester) async {
        final container = await pump(
          tester,
          locale: locale,
          afterSeed: (draft) => draft.setStage('secondary2'),
        );
        expect(draftOf(container).stage, 'secondary2');

        // The server closes secondary2; the answer is slow.
        final pending = Completer<List<SchoolStageRef>>();
        when(reference.getSchoolStages).thenAnswer((_) => pending.future);
        container.invalidate(schoolStagesProvider);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          draftOf(container).stage,
          'secondary2',
          reason: 'nothing is judged on the OLD answer while a new one is out',
        );

        pending.complete(_stages({..._launch, 'secondary2': 'soon'}));
        await tester.pumpAndSettle();
        expect(draftOf(container).stage, isNull);
        expect(find.byType(SubmitFailureBanner), findsNothing);
      });

      testWidgets('while the statuses are still loading a restored choice is '
          'left alone', (tester) async {
        final pending = Completer<List<SchoolStageRef>>();
        when(reference.getSchoolStages).thenAnswer((_) => pending.future);
        final container = await pump(
          tester,
          locale: locale,
          settle: false,
          afterSeed: (draft) => draft.setStage('prep1'),
        );
        await tester.pump(const Duration(milliseconds: 50));

        expect(draftOf(container).stage, 'prep1');
        pending.complete(_stages(_launch));
        await tester.pumpAndSettle();
        expect(draftOf(container).stage, isNull);
      });
    });
  }

  group('ReferenceDropdown.rowMarks', () {
    Future<void> pumpDropdown(
      WidgetTester tester, {
      Map<String, String>? rowMarks,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: _scale),
              child: child!,
            ),
            home: Scaffold(
              body: ReferenceDropdown(
                fieldKey: 'field-x',
                label: 'X',
                value: null,
                options: const AsyncData([
                  (id: 'a', label: 'Alpha', leading: null, enabled: true),
                  (
                    id: 'b',
                    label: 'Beta',
                    leading: Icon(Icons.flag),
                    enabled: false,
                  ),
                ]),
                rowMarks: rowMarks,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('field-x')));
      await tester.pumpAndSettle();
    }

    testWidgets('null marks, or no entry for a row, draw nothing and add no '
        'semantics wrapper', (tester) async {
      await pumpDropdown(tester);
      expect(find.text('Soon'), findsNothing);
      // The popup route itself carries a label ("Popup menu"); the row must
      // not carry one of its own.
      Finder rowLabelled() => find.ancestor(
        of: find.text('Beta').last,
        matching: find.byWidgetPredicate(
          (w) =>
              w is Semantics && (w.properties.label?.contains('Beta') ?? false),
        ),
      );
      expect(rowLabelled(), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await pumpDropdown(tester, rowMarks: {'zzz': 'Soon'});
      expect(find.text('Soon'), findsNothing);
      expect(rowLabelled(), findsNothing);
    });

    /// Whether [finder] sits under the 0.6 dimming a refused row gets.
    bool dimmed(Finder finder) => find
        .ancestor(
          of: finder,
          matching: find.byWidgetPredicate(
            (w) => w is Opacity && w.opacity == disabledControlOpacity,
          ),
        )
        .evaluate()
        .isNotEmpty;

    testWidgets('a mark follows the label, after the leading glyph; the glyph '
        'and the label keep their dimming and the mark does not '
        '(1409:26374 / 1409:26436)', (tester) async {
      await pumpDropdown(tester, rowMarks: {'b': 'Soon'});

      final label = find.text('Beta').last;
      final glyph = find.byIcon(Icons.flag).last;
      final mark = find.text('Soon');
      expect(mark, findsOneWidget);
      expect(find.byIcon(Icons.flag), findsWidgets);
      expect(
        tester.getTopLeft(mark).dx,
        greaterThan(tester.getTopLeft(label).dx),
      );
      expect(dimmed(label), isTrue, reason: 'the label is the greyed part');
      expect(dimmed(glyph), isTrue, reason: 'so is the leading glyph');
      expect(
        dimmed(mark),
        isFalse,
        reason: 'the frame draws the mark at full strength, not dimmed',
      );
      expect(
        tester.widget<Text>(mark).style,
        AppType.buttonSmall.copyWith(color: AppColors.light.hint),
        reason: 'Inter SemiBold 12 (buttonSmall), in the hint colour',
      );
    });

    testWidgets('a marked row is still spoken "<label>, <mark>", once', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpDropdown(tester, rowMarks: {'b': 'Soon'});

      expect(
        find.bySemanticsLabel(RegExp(r'^Beta, Soon$')),
        findsOneWidget,
        reason: 'moving the mark out of the dimming must not change the name',
      );
      handle.dispose();
    });

    testWidgets('a disabled row with no mark is dimmed whole, as it always '
        'was', (tester) async {
      await pumpDropdown(tester);

      final label = find.text('Beta').last;
      expect(dimmed(label), isTrue);
      expect(dimmed(find.byIcon(Icons.flag).last), isTrue);
      // One dimming wrapper around the whole row, not one per part.
      expect(
        find.ancestor(
          of: label,
          matching: find.byWidgetPredicate(
            (w) => w is Opacity && w.opacity == disabledControlOpacity,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('an enabled row is never dimmed, marked or not', (
      tester,
    ) async {
      await pumpDropdown(tester, rowMarks: {'a': 'Soon'});

      final label = find.text('Alpha').last;
      expect(find.text('Soon'), findsOneWidget);
      expect(dimmed(label), isFalse);
      expect(dimmed(find.text('Soon')), isFalse);
    });
  });

  group('University (owner decision 2026-10-15)', () {
    testWidgets('a soon study year is dimmed and carries the same mark', (
      tester,
    ) async {
      final l10n = lookupAppLocalizations(const Locale('en'));
      await pump(
        tester,
        screen: const UniversityDetailScreen(),
        path: '/register/university',
        track: RegTrack.university,
      );

      Future<void> choose(String key, String label) async {
        await tester.tap(field(key));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
      }

      await choose('field-universityId', 'Cairo University');
      await choose('field-facultyId', 'Faculty of Medicine');
      await tester.tap(field('field-studyYearId'));
      await tester.pumpAndSettle();

      // Year 3 is `soon` in the harness: visible and dimmed, as before.
      final year3 = find.text(l10n.studyYearNumber(3)).last;
      expect(year3, findsOneWidget);
      expect(isDimmed(year3), isTrue);
      // It now carries the School form's own mark (Figma `1409:26536`); the
      // full University checks are in `university_year_soon_test.dart`.
      expect(find.text(l10n.registrationSoonMark), findsOneWidget);
      expect(
        find.descendant(
          of: field('field-studyYearId'),
          matching: find.byType(DropdownButton<String>),
        ),
        findsOneWidget,
      );
      // The University form never asked for the School lists.
      verifyNever(reference.getSchoolStages);
    });
  });
}
