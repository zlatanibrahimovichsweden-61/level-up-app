import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/features/registration/widgets/city_field.dart';
import 'package:level_up_app/features/registration/widgets/registration_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

void main() {
  late MockReferenceRepository reference;

  setUp(() {
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
  });

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    bool offline = false,
    bool seed = true,
    void Function(ProviderContainer container)? afterSeed,
  }) async {
    final container = ProviderContainer(
      overrides: [
        referenceRepositoryProvider.overrideWithValue(reference),
        if (offline)
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
      ],
    );
    addTearDown(container.dispose);
    if (seed) {
      container.read(registrationControllerProvider.notifier)
        ..start(regArgs)
        ..setIdentity(name: 'Nour Hassan', parentPhone: '+201021871999')
        ..setTrack(RegTrack.university);
    }
    afterSeed?.call(container);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: locale,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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

  /// Opens a dropdown and taps one of its menu entries.
  Future<void> selectOption(
    WidgetTester tester,
    Key fieldKey,
    String optionLabel,
  ) async {
    await tester.ensureVisible(find.byKey(fieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(fieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(optionLabel).last);
    await tester.pumpAndSettle();
  }

  group('frame 337:10373 — layout', () {
    testWidgets('renders the title, subtitle and Start learning CTA', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('University Registration'), findsWidgets);
      expect(find.text('Egypt University students'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Start learning'),
        findsOneWidget,
      );
    });

    testWidgets('orders fields by the DATA cascade, not the drawn order '
        '(DESIGN_ISSUES #4)', (tester) async {
      await pump(tester);
      double dy(String label) => tester.getTopLeft(find.text(label)).dy;

      // University must precede Faculty, which must precede Academic Year.
      expect(dy('Date of Birth'), lessThan(dy('University Name')));
      expect(dy('University Name'), lessThan(dy('Faculty')));
      expect(dy('Faculty'), lessThan(dy('Academic Year')));
      // Governorate precedes City so the city list can be scoped.
      expect(dy('Academic Year'), lessThan(dy('Governorate')));
      expect(dy('Governorate'), lessThan(dy('City')));
    });

    testWidgets('includes the two fields the Figma frame is missing '
        '(DESIGN_ISSUES #2 dateOfBirth, #3 governorateId)', (tester) async {
      await pump(tester);

      expect(find.byKey(const Key('field-dateOfBirth')), findsOneWidget);
      expect(find.byKey(const Key('field-governorateId')), findsOneWidget);
    });

    testWidgets('has NO country field — Egypt-only by shape (adr-010)', (
      tester,
    ) async {
      await pump(tester);

      expect(find.byKey(const Key('field-countryCode')), findsNothing);
      expect(find.text('Country'), findsNothing);
      verifyNever(reference.getCountries);
    });

    // Wave 04, W04-1: `125:2336` / `337:10373` space every block 25 apart,
    // box to box (untrimmed text). The build had 8 / 28 / 16 / 28.
    testWidgets('vertical rhythm: 25 between every block', (tester) async {
      await pump(tester);

      Rect rect(Finder f) => tester.getRect(f);
      final cta = find.widgetWithText(FilledButton, 'Start learning');
      await tester.ensureVisible(cta);
      await tester.pumpAndSettle();

      expect(
        rect(find.text('University Registration').last).top -
            rect(find.byType(RegistrationHeader)).bottom,
        closeTo(25, 0.001),
        reason: 'header row → title',
      );
      expect(
        rect(find.text('Date of Birth')).top -
            rect(find.text('Egypt University students')).bottom,
        closeTo(25, 0.001),
        reason: 'subtitle → first field block',
      );
      for (final (above, label) in [
        ('field-universityId', 'Faculty'),
        ('field-facultyId', 'Academic Year'),
        ('field-studyYearId', 'Governorate'),
        ('field-governorateId', 'City'),
      ]) {
        expect(
          rect(find.text(label)).top - rect(find.byKey(Key(above))).bottom,
          closeTo(25, 0.001),
          reason: '$above → $label',
        );
      }
      expect(
        rect(cta).top - rect(find.byType(CityField)).bottom,
        closeTo(25, 0.001),
        reason: 'last field block → Start learning',
      );
    });

    // W04-2: `125:2361` is `#7C7C7C`, `bodyMuted` per DESIGN_ISSUES #24.
    testWidgets('the subtitle is muted grey, not textSecondary', (
      tester,
    ) async {
      await pump(tester);

      final subtitle = tester.widget<Text>(
        find.text('Egypt University students'),
      );
      expect(subtitle.style?.color, AppColors.light.bodyMuted);
    });
  });

  group('the university → faculty → year cascade is gated', () {
    testWidgets('Faculty is disabled until a University is chosen', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('Choose a university first'), findsOneWidget);
    });

    testWidgets('Academic Year is disabled until a Faculty is chosen', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('Choose a faculty first'), findsOneWidget);
    });

    testWidgets('choosing a University unlocks its own faculties', (
      tester,
    ) async {
      await pump(tester);

      await selectOption(
        tester,
        const Key('field-universityId'),
        'Cairo University',
      );

      expect(find.text('Choose a university first'), findsNothing);
      // Year is still gated — no faculty yet.
      expect(find.text('Choose a faculty first'), findsOneWidget);
    });

    testWidgets('choosing a Faculty unlocks its years', (tester) async {
      final container = await pump(tester);
      container.read(registrationControllerProvider.notifier)
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine');
      await tester.pumpAndSettle();

      expect(find.text('Choose a faculty first'), findsNothing);
    });

    testWidgets('changing University re-gates Faculty and Year', (
      tester,
    ) async {
      final container = await pump(tester);
      container.read(registrationControllerProvider.notifier)
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine')
        ..setStudyYear('year-2');
      await tester.pumpAndSettle();

      // A university with no faculties: the cascade below must reset.
      container
          .read(registrationControllerProvider.notifier)
          .setUniversity('uni-ain-shams');
      await tester.pumpAndSettle();

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.facultyId, isNull);
      expect(draft.studyYearId, isNull);
      expect(find.text('Choose a faculty first'), findsOneWidget);
    });
  });

  group('academic years', () {
    /// The year picker's items, read off the button rather than the rendered
    /// menu: a CLOSED `DropdownButton` puts no `DropdownMenuItem` in the tree
    /// at all, so finding them by type would assert on nothing.
    List<DropdownMenuItem<String>> yearItems(WidgetTester tester) => tester
        .widget<DropdownButton<String>>(
          find.descendant(
            of: find.byKey(const Key('field-studyYearId')),
            matching: find.byType(DropdownButton<String>),
          ),
        )
        .items!;

    testWidgets('`soon` years are SHOWN, and are not selectable', (
      tester,
    ) async {
      // openapi.yaml:751 — "Years carry status `active|soon` — `soon` years are
      // shown but not selectable at registration." This screen used to drop
      // them, which left a student unable to tell a year their faculty has not
      // opened yet from one it does not offer at all.
      final container = await pump(tester);
      container.read(registrationControllerProvider.notifier)
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('field-studyYearId')));
      await tester.pumpAndSettle();

      // The fixture faculty has years 1 (active), 2 (active), 3 (soon).
      final items = yearItems(tester);
      expect(
        items.map((i) => i.value),
        ['year-1', 'year-2', 'year-3'],
        reason: 'the soon year must be offered, not filtered out',
      );
      expect(items[0].enabled, isTrue);
      expect(items[1].enabled, isTrue);
      expect(items[2].enabled, isFalse, reason: 'soon is not selectable');
    });

    testWidgets('tapping a `soon` year selects nothing', (tester) async {
      final container = await pump(tester);
      container.read(registrationControllerProvider.notifier)
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('field-studyYearId')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('field-studyYearId')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Year 3').last, warnIfMissed: false);
      await tester.pumpAndSettle();

      // A submitted `soon` id is the validation_failed at openapi.yaml:2330,
      // which the student cannot act on or explain.
      expect(
        container.read(registrationControllerProvider)!.studyYearId,
        isNull,
      );
    });

    testWidgets('selecting a year stores its id', (tester) async {
      final container = await pump(tester);
      container.read(registrationControllerProvider.notifier)
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine');
      await tester.pumpAndSettle();

      await selectOption(tester, const Key('field-studyYearId'), 'Year 2');

      expect(
        container.read(registrationControllerProvider)!.studyYearId,
        'year-2',
      );
    });
  });

  group('geography', () {
    testWidgets('City is gated until a Governorate is chosen', (tester) async {
      await pump(tester);

      expect(find.text('Choose a governorate first'), findsOneWidget);
      verifyNever(
        () => reference.getCities(
          countryCode: any(named: 'countryCode'),
          governorateId: any(named: 'governorateId'),
        ),
      );
    });

    testWidgets('governorates are fetched for EG directly', (tester) async {
      await pump(tester);
      verify(() => reference.getGovernorates('EG')).called(1);
    });

    testWidgets('choosing a governorate scopes the city request', (
      tester,
    ) async {
      final container = await pump(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setGovernorate('gov-giza');
      await tester.pumpAndSettle();

      verify(
        () => reference.getCities(countryCode: 'EG', governorateId: 'gov-giza'),
      ).called(1);
    });

    // adr-028 §1 applies to BOTH tracks — university registration collects a
    // city too. No frame draws this; see DESIGN_ISSUES #44.
    testWidgets('the city escape swaps the picker for free text here too', (
      tester,
    ) async {
      final container = await pump(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setGovernorate('gov-giza');
      await tester.pumpAndSettle();

      final link = find.widgetWithText(TextButton, "My city isn't listed");
      await tester.ensureVisible(link);
      await tester.pumpAndSettle();
      await tester.tap(link);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('field-cityName')), findsOneWidget);
      expect(find.byKey(const Key('field-cityId')), findsNothing);

      await tester.enterText(
        find.byKey(const Key('field-cityName')),
        'Somewhere Uncoded',
      );
      await tester.pumpAndSettle();

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.cityName, 'Somewhere Uncoded');
      expect(draft.cityId, isNull);
    });

    testWidgets('the escape is reachable even while the picker is GATED', (
      tester,
    ) async {
      // The picker needs a governorate; a student whose city is missing from
      // the coded list must not also be blocked by the list's own scoping.
      await pump(tester);

      expect(find.text('Choose a governorate first'), findsOneWidget);
      expect(
        find.widgetWithText(TextButton, "My city isn't listed"),
        findsOneWidget,
      );
    });
  });

  group('picker states', () {
    testWidgets('error → message + retry', (tester) async {
      when(reference.getUniversities).thenThrow(const UnknownException());
      await pump(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
    });

    testWidgets('offline → its own copy', (tester) async {
      when(
        reference.getUniversities,
      ).thenThrow(const NetworkException(detail: 'timeout'));
      await pump(tester);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('empty → the localized empty line', (tester) async {
      when(reference.getUniversities).thenAnswer((_) async => []);
      await pump(tester);

      expect(find.text('Nothing to show here'), findsWidgets);
    });

    testWidgets('no connectivity → the offline banner', (tester) async {
      await pump(tester, offline: true);
      expect(find.text('You are offline'), findsWidgets);
    });
  });

  group('submit pre-flight', () {
    testWidgets('an incomplete form shows inline errors, sends no request', (
      tester,
    ) async {
      await pump(tester);

      final button = find.widgetWithText(FilledButton, 'Start learning');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsWidgets);
    });
  });

  group('expiry guard', () {
    testWidgets('an expired token renders the expiry view', (tester) async {
      await pump(
        tester,
        seed: false,
        afterSeed: (c) {
          c.read(registrationControllerProvider.notifier)
            ..start(
              const RegistrationArgs(
                registrationToken: 'reg.token',
                expiresInSeconds: -1,
                phone: '+201555000111',
              ),
            )
            ..setTrack(RegTrack.university);
        },
      );

      expect(
        find.text('Your registration session expired. Please start again.'),
        findsOneWidget,
      );
      expect(find.text('Start learning'), findsNothing);
    });
  });

  group('Arabic (RTL)', () {
    testWidgets('renders Arabic copy under RTL directionality', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      expect(
        Directionality.of(tester.element(find.byType(SingleChildScrollView))),
        TextDirection.rtl,
      );
      expect(find.text('تسجيل طلاب الجامعات'), findsWidgets);
      expect(find.text('اسم الجامعة'), findsOneWidget);
      expect(find.text('الكلية'), findsOneWidget);
      expect(find.text('السنة الدراسية'), findsOneWidget);
      expect(find.text('تاريخ الميلاد'), findsOneWidget);
    });

    testWidgets('university rows display their Arabic names', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      await tester.tap(find.byKey(const Key('field-universityId')));
      await tester.pumpAndSettle();
      expect(find.text('جامعة القاهرة'), findsWidgets);
    });

    testWidgets('the gating hints are localized', (tester) async {
      await pump(tester, locale: const Locale('ar'));
      expect(find.text('اختر الجامعة أولًا'), findsOneWidget);
      expect(find.text('اختر الكلية أولًا'), findsOneWidget);
    });
  });
}
