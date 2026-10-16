import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/form_fields.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// The University form's Academic Year picker carries the School form's "Soon"
/// mark (owner decision 2026-10-15, Figma `1409:26536`): the same ARB key
/// (`registrationSoonMark`, «قريبًا»), the same `AppType.buttonSmall` in the
/// hint colour, the same row treatment — label dimmed, mark at full strength at
/// the row's end edge, spoken as "<label>, <mark>".
///
/// Only a `soon` year is marked. Selection is unchanged: `active` is the only
/// selectable status; an unknown or empty status stays unselectable and
/// unmarked; a year with no status at all does not parse.
///
/// Every widget test runs at text scale 1.3, in English (LTR) and Arabic (RTL),
/// on a phone-wide surface.

const _scale = TextScaler.linear(1.3);

/// The frame's faculty: year 1 open, years 2–5 "Soon".
const _frameYears = [
  StudyYearRef(id: 'y1', yearNumber: 1, status: 'active'),
  StudyYearRef(id: 'y2', yearNumber: 2, status: 'soon'),
  StudyYearRef(id: 'y3', yearNumber: 3, status: 'soon'),
  StudyYearRef(id: 'y4', yearNumber: 4, status: 'soon'),
  StudyYearRef(id: 'y5', yearNumber: 5, status: 'soon'),
];

/// Statuses this build has never seen, next to one open year.
const _unknownYears = [
  StudyYearRef(id: 'y1', yearNumber: 1, status: 'active'),
  StudyYearRef(id: 'y2', yearNumber: 2, status: 'paused'),
  StudyYearRef(id: 'y3', yearNumber: 3, status: ''),
];

List<UniversityRef> _universityWith(List<StudyYearRef> years) => [
  UniversityRef(
    id: 'uni-frame',
    nameAr: 'جامعة القاهرة',
    nameEn: 'Cairo University',
    faculties: [
      FacultyRef(
        id: 'fac-frame',
        nameAr: 'كلية الطب',
        nameEn: 'Faculty of Medicine',
        years: years,
      ),
    ],
  ),
];

void main() {
  late MockReferenceRepository reference;

  setUp(() {
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
    when(
      reference.getUniversities,
    ).thenAnswer((_) async => _universityWith(_frameYears));
  });

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required Locale locale,
    String? studyYearId,
  }) async {
    final container = ProviderContainer(
      overrides: [referenceRepositoryProvider.overrideWithValue(reference)],
    );
    addTearDown(container.dispose);
    final controller = container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
      ..setTrack(RegTrack.university)
      ..setUniversity('uni-frame')
      ..setFaculty('fac-frame');
    if (studyYearId != null) controller.setStudyYear(studyYearId);

    // Phone-wide and tall: nothing needs scrolling to be tapped, but a label
    // that does not fit at 1.3 still overflows and fails the test.
    await tester.binding.setSurfaceSize(const Size(412, 2600));
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
            initialLocation: '/register/university',
            routes: [
              GoRoute(
                path: '/register/university',
                builder: (_, _) => const UniversityDetailScreen(),
              ),
              GoRoute(path: '/login', builder: (_, _) => marker('LOGIN')),
              GoRoute(path: '/home', builder: (_, _) => marker('HOME')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  final yearField = find.byKey(const Key('field-studyYearId'));

  /// The rows the closed year field's dropdown was handed, by id.
  Map<String, bool> enabledByRow(WidgetTester tester) => {
    for (final item
        in tester
            .widget<DropdownButton<String>>(
              find.descendant(
                of: yearField,
                matching: find.byType(DropdownButton<String>),
              ),
            )
            .items!)
      item.value!: item.enabled,
  };

  Future<void> openYears(WidgetTester tester) async {
    await tester.tap(yearField);
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

  for (final language in ['en', 'ar']) {
    final l10n = lookupAppLocalizations(Locale(language));
    final locale = Locale(language);
    final soon = l10n.registrationSoonMark;
    final isAr = language == 'ar';
    String year(int n) => l10n.studyYearNumber(n);

    group('Academic Year · $language', () {
      testWidgets(
        'every year is listed in order; only `active` can be chosen',
        (tester) async {
          await pump(tester, locale: locale);

          expect(enabledByRow(tester), {
            'y1': true,
            'y2': false,
            'y3': false,
            'y4': false,
            'y5': false,
          });
          expect(
            Directionality.of(tester.element(yearField)),
            isAr ? TextDirection.rtl : TextDirection.ltr,
          );
        },
      );

      testWidgets('a soon year is visible, dimmed and marked with the School '
          'form\'s mark; the active year is none of those (1409:26536)', (
        tester,
      ) async {
        await pump(tester, locale: locale);
        await openYears(tester);

        for (final n in [2, 3, 4, 5]) {
          final label = menuText(year(n));
          expect(label, findsOneWidget, reason: 'year $n is visible');
          expect(isDimmed(label), isTrue, reason: 'year $n is dimmed');
        }
        expect(isDimmed(menuText(year(1))), isFalse, reason: 'year 1 is open');
        // One mark per soon year, and no more.
        expect(find.text(soon), findsNWidgets(4));
      });

      testWidgets('the mark is at full strength, outside the label\'s dimming, '
          'in buttonSmall at the row\'s end edge', (tester) async {
        await pump(tester, locale: locale);
        await openYears(tester);

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
        // After the label in reading order, mirrored under RTL.
        final markBox = tester.getRect(find.text(soon).first);
        final labelBox = tester.getRect(menuText(year(2)));
        if (isAr) {
          expect(markBox.right, lessThan(labelBox.left));
        } else {
          expect(markBox.left, greaterThan(labelBox.right));
        }
      });

      testWidgets('the mark is part of a soon year\'s spoken name; the open '
          'year is spoken plain', (tester) async {
        final handle = tester.ensureSemantics();
        await pump(tester, locale: locale);
        await openYears(tester);

        for (final n in [2, 3, 4, 5]) {
          expect(
            find.bySemanticsLabel(
              RegExp('^${RegExp.escape(year(n))}, ${RegExp.escape(soon)}\$'),
            ),
            findsOneWidget,
            reason: 'year $n says "$soon"',
          );
        }
        expect(
          find.bySemanticsLabel(RegExp('^${RegExp.escape(year(1))}, ')),
          findsNothing,
        );
        handle.dispose();
      });

      testWidgets('tapping a soon year changes nothing; the active year '
          'selects', (tester) async {
        final container = await pump(tester, locale: locale);
        await openYears(tester);

        await tester.tap(menuText(year(3)), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(
          container.read(registrationControllerProvider)!.studyYearId,
          isNull,
        );

        // The menu may have stayed open on the refused tap; open it if not.
        if (find.text(soon).evaluate().isEmpty) await openYears(tester);
        await tester.tap(menuText(year(1)));
        await tester.pumpAndSettle();
        expect(
          container.read(registrationControllerProvider)!.studyYearId,
          'y1',
        );
      });

      testWidgets('an unknown or empty status is disabled with NO mark', (
        tester,
      ) async {
        when(
          reference.getUniversities,
        ).thenAnswer((_) async => _universityWith(_unknownYears));
        await pump(tester, locale: locale);

        expect(enabledByRow(tester), {'y1': true, 'y2': false, 'y3': false});

        await openYears(tester);
        expect(isDimmed(menuText(year(2))), isTrue);
        expect(isDimmed(menuText(year(3))), isTrue);
        expect(find.text(soon), findsNothing);
      });
    });
  }

  test('a year with no status does not parse, so it can never be offered', () {
    expect(
      () => StudyYearRef.fromJson({'id': 'y9', 'yearNumber': 9}),
      throwsA(anything),
    );
  });
}
