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
import 'package:level_up_app/features/registration/models/registration_validation.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/widgets/registration_chrome.dart';
import 'package:level_up_app/features/registration/widgets/school_picker_field.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

void main() {
  late MockReferenceRepository reference;

  setUp(() {
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
  });

  /// Seeds the wizard up to the point the school screen is reached.
  void seedSchoolDraft(ProviderContainer container) {
    container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
      ..setTrack(RegTrack.school);
  }

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    bool offline = false,
    bool seed = true,
    void Function(ProviderContainer container)? afterSeed,
    // A pending picker spins forever, so pumpAndSettle would never return.
    bool settle = true,
  }) async {
    final container = ProviderContainer(
      overrides: [
        referenceRepositoryProvider.overrideWithValue(reference),
        if (offline)
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
      ],
    );
    addTearDown(container.dispose);
    if (seed) seedSchoolDraft(container);
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
            initialLocation: '/register/school',
            routes: [
              GoRoute(
                path: '/register/school',
                builder: (_, _) => const SchoolDetailScreen(),
              ),
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

  /// Scrolls a control into view before tapping it — the form is taller than
  /// the test viewport.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('frame 337:5269 — layout', () {
    testWidgets('renders the title, subtitle and Start learning CTA', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('School Registration'), findsWidgets);
      expect(find.text('Complete your profile to get started'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Start learning'),
        findsOneWidget,
      );
    });

    testWidgets('shows the frame fields in order after Date of Birth', (
      tester,
    ) async {
      await pump(tester);

      // Vertical positions must follow the frame's top-to-bottom order.
      double dy(String label) => tester.getTopLeft(find.text(label)).dy;

      expect(dy('Date of Birth'), lessThan(dy('Country')));
      expect(dy('Country'), lessThan(dy('Governorate')));
      expect(dy('Governorate'), lessThan(dy('City')));
      expect(dy('City'), lessThan(dy('Education System')));
      expect(dy('Education System'), lessThan(dy('Grade')));
      expect(dy('Grade'), lessThan(dy('School Name')));
    });

    testWidgets('includes the Date of Birth field the Figma frame is missing '
        '(DESIGN_ISSUES #2 — contract-required)', (tester) async {
      await pump(tester);
      expect(find.byKey(const Key('field-dateOfBirth')), findsOneWidget);
    });

    testWidgets('defaults the country to Egypt from the server list', (
      tester,
    ) async {
      final container = await pump(tester);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.countryCode, 'EG');
      expect(draft.requiresGovernorate, isTrue);
    });

    // Wave 03, W03-1: `125:511` spaces everything 25 apart, box to box (its
    // text is untrimmed: title 29, subtitle 26). The build had 8 / 28 / 16 / 28.
    testWidgets('vertical rhythm: 25 between every block (Egypt)', (
      tester,
    ) async {
      await pump(tester);

      Rect rect(Finder f) => tester.getRect(f);
      final cta = find.widgetWithText(FilledButton, 'Start learning');
      await tester.ensureVisible(cta);
      await tester.pumpAndSettle();

      expect(
        rect(find.text('School Registration').last).top -
            rect(find.byType(RegistrationHeader)).bottom,
        25,
        reason: 'header row → title',
      );
      expect(
        rect(find.text('Date of Birth')).top -
            rect(find.text('Complete your profile to get started')).bottom,
        25,
        reason: 'subtitle → first field block',
      );
      expect(
        rect(find.text('Governorate')).top -
            rect(find.byKey(const Key('field-countryCode'))).bottom,
        25,
        reason: 'field block → field block',
      );
      expect(
        rect(find.text('Grade')).top -
            rect(find.byKey(const Key('field-educationSystem'))).bottom,
        25,
      );
      expect(
        rect(cta).top - rect(find.byType(SchoolPickerField)).bottom,
        25,
        reason: 'last field block → Start learning',
      );
    });

    testWidgets('outside Egypt the Grade → CTA gap stays a single 25', (
      tester,
    ) async {
      final container = await pump(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setCountry(countryCode: 'AE', requiresGovernorate: false);
      await tester.pumpAndSettle();

      final cta = find.widgetWithText(FilledButton, 'Start learning');
      await tester.ensureVisible(cta);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(cta).top -
            tester.getRect(find.byKey(const Key('field-stage'))).bottom,
        25,
      );
    });

    // W03-2: `125:536` is `#7C7C7C`, the grey DESIGN_ISSUES #24 maps to
    // `bodyMuted`; it rendered in `textSecondary` (`#2C2C2C`).
    testWidgets('the subtitle is muted grey, not textSecondary', (
      tester,
    ) async {
      await pump(tester);

      final subtitle = tester.widget<Text>(
        find.text('Complete your profile to get started'),
      );
      expect(subtitle.style?.color, AppColors.light.bodyMuted);
      expect(subtitle.style?.color, isNot(AppColors.light.textSecondary));
    });
  });

  group('geography conditionality (adr-010)', () {
    testWidgets('Egypt shows Governorate + the coded school picker', (
      tester,
    ) async {
      await pump(tester);

      expect(find.byKey(const Key('field-governorateId')), findsOneWidget);
      expect(find.byKey(const Key('field-schoolId')), findsOneWidget);
    });

    testWidgets(
      'a non-Egypt country hides Governorate AND the school step entirely',
      (tester) async {
        final container = await pump(tester);
        container
            .read(registrationControllerProvider.notifier)
            .setCountry(countryCode: 'AE', requiresGovernorate: false);
        await tester.pumpAndSettle();

        // Governorate is FORBIDDEN there — absent, not merely disabled.
        expect(find.byKey(const Key('field-governorateId')), findsNothing);
        // adr-028 §2: the coded list is Egyptian, so outside Egypt there is
        // no school field of ANY kind — no picker, and no free-text
        // replacement either (v1.1 cancelled that outright).
        expect(find.byKey(const Key('field-schoolId')), findsNothing);
        expect(find.byKey(const Key('field-schoolName')), findsNothing);
        expect(find.textContaining('School Name'), findsNothing);
      },
    );

    testWidgets('switching country clears the dependent geography', (
      tester,
    ) async {
      final container = await pump(
        tester,
        afterSeed: (c) {
          c.read(registrationControllerProvider.notifier)
            ..setCountry(countryCode: 'EG', requiresGovernorate: true)
            ..setGovernorate('gov-cairo')
            ..setCity('city-nasr')
            ..setSchool('school-42');
        },
      );

      container
          .read(registrationControllerProvider.notifier)
          .setCountry(countryCode: 'AE', requiresGovernorate: false);
      await tester.pumpAndSettle();

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.governorateId, isNull);
      expect(draft.cityId, isNull);
      expect(draft.schoolId, isNull);
    });

    testWidgets('City stays gated until a governorate is chosen (Egypt)', (
      tester,
    ) async {
      await pump(tester);

      // The contract 400s on /reference/cities?countryCode=EG with no
      // governorateId, so the request is never fired.
      expect(find.text('Choose a governorate first'), findsOneWidget);
      verifyNever(
        () => reference.getCities(
          countryCode: any(named: 'countryCode'),
          governorateId: any(named: 'governorateId'),
        ),
      );
    });

    testWidgets('choosing a governorate unlocks the city list', (tester) async {
      final container = await pump(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setGovernorate('gov-cairo');
      await tester.pumpAndSettle();

      expect(find.text('Choose a governorate first'), findsNothing);
      verify(
        () =>
            reference.getCities(countryCode: 'EG', governorateId: 'gov-cairo'),
      ).called(1);
    });
  });

  group('rate limiting (429 rate_limited)', () {
    testWidgets('renders in the picker\'s EXISTING error slot, with Retry', (
      tester,
    ) async {
      // No new widget and no gating: the same failure state every other
      // picker error uses, just with copy that does not invite the student to
      // hammer Retry against a limiter.
      when(reference.getEducationSystems).thenThrow(
        const RateLimitedException(retryAfter: Duration(seconds: 30)),
      );
      await pump(tester);

      expect(
        find.text('Too many requests. Please try again in 30 seconds.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Retry'), findsWidgets);
      // Definitively not the offline branch — a limiter is not a lost signal.
      expect(find.text('You are offline'), findsNothing);
    });

    testWidgets('the message stands alone when Retry-After was unusable', (
      tester,
    ) async {
      when(
        reference.getEducationSystems,
      ).thenThrow(const RateLimitedException());
      await pump(tester);

      expect(
        find.text('Too many requests. Please try again shortly.'),
        findsOneWidget,
      );
    });

    testWidgets('and is localized', (tester) async {
      when(
        reference.getEducationSystems,
      ).thenThrow(const RateLimitedException());
      await pump(tester, locale: const Locale('ar'));

      expect(find.text('طلبات كثيرة. حاول مرة أخرى بعد قليل.'), findsOneWidget);
    });

    testWidgets('country_not_found still shows the GENERIC geography error', (
      tester,
    ) async {
      // Seif's notice §3 — map the code, render nothing new.
      when(
        () => reference.getGovernorates(any()),
      ).thenThrow(const ApiException(status: 404, code: 'country_not_found'));
      await pump(tester);

      expect(find.text('Something went wrong'), findsWidgets);
    });
  });

  group('picker states', () {
    testWidgets('loading → an in-field progress indicator', (tester) async {
      final completer = stubCountriesPending(reference);
      await pump(tester, settle: false);

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      completer.complete(countries);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('empty → the localized empty line, not a blank field', (
      tester,
    ) async {
      when(() => reference.getEducationSystems()).thenAnswer((_) async => []);
      await pump(tester);

      expect(find.text('Nothing to show here'), findsWidgets);
    });

    testWidgets('error → message + a user-tapped Retry that refetches', (
      tester,
    ) async {
      when(
        () => reference.getEducationSystems(),
      ).thenThrow(const UnknownException());
      await pump(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);

      when(
        () => reference.getEducationSystems(),
      ).thenAnswer((_) async => educationSystems);
      await tapVisible(tester, find.widgetWithText(TextButton, 'Retry'));

      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('offline → its own copy, distinct from a generic error', (
      tester,
    ) async {
      when(
        () => reference.getEducationSystems(),
      ).thenThrow(const NetworkException(detail: 'timeout'));
      await pump(tester);

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('no connectivity → the offline banner', (tester) async {
      await pump(tester, offline: true);
      expect(find.text('You are offline'), findsWidgets);
    });
  });

  group('submit pre-flight', () {
    testWidgets('an incomplete form shows inline errors and sends no request', (
      tester,
    ) async {
      await pump(tester);

      await tapVisible(
        tester,
        find.widgetWithText(FilledButton, 'Start learning'),
      );

      // dateOfBirth, cityId, stage, educationSystem, schoolId, governorateId
      // are all still empty.
      expect(find.text('This field is required'), findsWidgets);
    });
  });

  group('expiry guard', () {
    testWidgets(
      'an expired token renders the expiry view instead of the form',
      (tester) async {
        await pump(
          tester,
          seed: false,
          afterSeed: (c) {
            c.read(registrationControllerProvider.notifier)
              ..start(
                const RegistrationArgs(
                  registrationToken: 'reg.token',
                  expiresInSeconds: -1,
                  phone: '+201500000001',
                ),
              )
              ..setTrack(RegTrack.school);
          },
        );

        expect(
          find.text('Your registration session expired. Please start again.'),
          findsOneWidget,
        );
        expect(find.text('Start learning'), findsNothing);
      },
    );

    testWidgets('no draft at all renders the expiry view', (tester) async {
      await pump(tester, seed: false);
      expect(find.text('Back to login'), findsOneWidget);
    });
  });

  group('Arabic (RTL)', () {
    testWidgets('renders Arabic copy under RTL directionality', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      expect(
        Directionality.of(tester.element(find.byType(SingleChildScrollView))),
        TextDirection.rtl,
      );
      expect(find.text('تسجيل طلاب المدارس'), findsWidgets);
      expect(find.text('تاريخ الميلاد'), findsOneWidget);
      expect(find.text('المحافظة'), findsOneWidget);
      expect(find.text('الصف الدراسي'), findsOneWidget);
    });

    testWidgets('reference rows display their Arabic names', (tester) async {
      await pump(tester, locale: const Locale('ar'));
      expect(find.text('مصر'), findsWidgets);
    });

    testWidgets('picker errors are localized in Arabic', (tester) async {
      when(
        () => reference.getEducationSystems(),
      ).thenThrow(const NetworkException(detail: 'timeout'));
      await pump(tester, locale: const Locale('ar'));

      expect(find.text('أنت غير متصل بالإنترنت'), findsOneWidget);
    });

    testWidgets('both adr-028 escapes carry Seif\'s Arabic copy', (
      tester,
    ) async {
      final container = await pump(tester, locale: const Locale('ar'));
      container
          .read(registrationControllerProvider.notifier)
          .setGovernorate('gov-cairo');
      await tester.pumpAndSettle();

      expect(find.text('مدينتي غير موجودة'), findsOneWidget);
      expect(find.text('لم أجد مدرستي'), findsOneWidget);
    });
  });

  // adr-028 §1. No Figma frame draws this — see DESIGN_ISSUES #44. The spec is
  // Seif's partner notice of 2026-07-30, quoted in the Day 7c brief.
  group('city escape — "my city isn\'t listed"', () {
    /// The governorate has to be set AFTER the first frame: `_seedDefaultCountry`
    /// runs post-frame and `setCountry` clears the whole geography branch, so a
    /// value seeded before the pump is wiped.
    Future<ProviderContainer> pumpWithGovernorate(WidgetTester tester) async {
      final container = await pump(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setGovernorate('gov-cairo');
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('the picker is the default; the escape is a link under it', (
      tester,
    ) async {
      await pumpWithGovernorate(tester);

      expect(find.byKey(const Key('field-cityId')), findsOneWidget);
      expect(find.byKey(const Key('field-cityName')), findsNothing);
      // Low visual weight on purpose: a TextButton, not a FilledButton.
      final link = find.widgetWithText(TextButton, "My city isn't listed");
      expect(link, findsOneWidget);
      expect(
        tester.getTopLeft(link).dy,
        greaterThan(
          tester.getTopLeft(find.byKey(const Key('field-cityId'))).dy,
        ),
      );
    });

    testWidgets('tapping it SWAPS the dropdown for a text field in place', (
      tester,
    ) async {
      await pumpWithGovernorate(tester);
      await tapVisible(
        tester,
        find.widgetWithText(TextButton, "My city isn't listed"),
      );

      expect(find.byKey(const Key('field-cityName')), findsOneWidget);
      expect(find.byKey(const Key('field-cityId')), findsNothing);
      // Label + placeholder both read "City name".
      expect(find.text('City name'), findsWidgets);
    });

    testWidgets('typing lands on the controller and clears the coded id', (
      tester,
    ) async {
      final container = await pumpWithGovernorate(tester);
      container.read(registrationControllerProvider.notifier)
        ..setCity('city-nasr')
        ..setSchool('school-42');

      await tapVisible(
        tester,
        find.widgetWithText(TextButton, "My city isn't listed"),
      );
      await tester.enterText(
        find.byKey(const Key('field-cityName')),
        'Somewhere Uncoded',
      );
      await tester.pumpAndSettle();

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.cityName, 'Somewhere Uncoded');
      expect(draft.cityId, isNull);
      // The school search is scoped by city, so the selection cannot survive.
      expect(draft.schoolId, isNull);
    });

    testWidgets('"Choose from the list" returns AND clears the free text', (
      tester,
    ) async {
      final container = await pumpWithGovernorate(tester);
      await tapVisible(
        tester,
        find.widgetWithText(TextButton, "My city isn't listed"),
      );
      await tester.enterText(
        find.byKey(const Key('field-cityName')),
        'Somewhere Uncoded',
      );
      await tester.pumpAndSettle();

      await tapVisible(
        tester,
        find.widgetWithText(TextButton, 'Choose from the list'),
      );

      expect(find.byKey(const Key('field-cityId')), findsOneWidget);
      expect(find.byKey(const Key('field-cityName')), findsNothing);
      // Leaving it on the draft would make the body factory throw on "both".
      expect(container.read(registrationControllerProvider)!.cityName, isNull);
    });

    testWidgets('a free-text city still permits a school search', (
      tester,
    ) async {
      // The consequence that is easy to miss: the coded search is filtered by
      // governorateId + cityId, and a free-text city has no cityId. It must
      // fall back to governorate-only, not be disabled and not send an empty
      // string.
      final container = await pumpWithGovernorate(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setCityName('Somewhere Uncoded');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('field-schoolId')), findsOneWidget);
      await tapVisible(tester, find.byKey(const Key('field-schoolId')));
      await tester.tap(find.text('Nile School'));
      await tester.pumpAndSettle();

      expect(
        container.read(registrationControllerProvider)!.schoolId,
        'school-42',
      );
      verify(
        () => reference.searchSchools(
          q: any(named: 'q'),
          governorateId: 'gov-cairo',
          cityId: null,
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).called(greaterThanOrEqualTo(1));
    });
  });

  // adr-028 §2, same provenance as the city escape above.
  group('school step — Egypt only, and skippable', () {
    /// After the first frame, for the same reason as the city group above.
    Future<ProviderContainer> pumpEgypt(WidgetTester tester) async {
      final container = await pump(tester);
      container.read(registrationControllerProvider.notifier)
        ..setGovernorate('gov-cairo')
        ..setCity('city-nasr');
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('the skip affordance sits under the Egyptian picker', (
      tester,
    ) async {
      await pumpEgypt(tester);

      final link = find.widgetWithText(TextButton, "I can't find my school");
      expect(link, findsOneWidget);
      expect(
        tester.getTopLeft(link).dy,
        greaterThan(
          tester.getTopLeft(find.byKey(const Key('field-schoolId'))).dy,
        ),
      );
    });

    testWidgets('skipping marks the field RESOLVED, not blank', (tester) async {
      final container = await pumpEgypt(tester);
      container
          .read(registrationControllerProvider.notifier)
          .setSchool('school-42');
      await tester.pumpAndSettle();

      await tapVisible(
        tester,
        find.widgetWithText(TextButton, "I can't find my school"),
      );

      // Not the hint, and not empty: the student answered the question.
      expect(find.text('No school selected'), findsOneWidget);
      expect(find.text('Search for your school'), findsNothing);
      expect(container.read(registrationControllerProvider)!.schoolId, isNull);
      // The link is gone once the field reads as resolved.
      expect(
        find.widgetWithText(TextButton, "I can't find my school"),
        findsNothing,
      );
    });

    testWidgets('an Egyptian student can submit having skipped it', (
      tester,
    ) async {
      final container = await pumpEgypt(tester);
      container.read(registrationControllerProvider.notifier)
        ..setDateOfBirth(DateTime(2009, 5, 1))
        ..setEducationSystem('ig')
        ..setStage('secondary1');
      await tester.pumpAndSettle();

      await tapVisible(
        tester,
        find.widgetWithText(TextButton, "I can't find my school"),
      );

      // No blocking issue anywhere in the pre-flight — under v1.0 schoolId
      // would have been `missing` here.
      expect(
        validateDraft(container.read(registrationControllerProvider)!),
        isEmpty,
      );
    });

    testWidgets('picking a school afterwards un-skips the field', (
      tester,
    ) async {
      final container = await pumpEgypt(tester);
      await tapVisible(
        tester,
        find.widgetWithText(TextButton, "I can't find my school"),
      );
      expect(find.text('No school selected'), findsOneWidget);

      await tapVisible(tester, find.byKey(const Key('field-schoolId')));
      await tester.tap(find.text('Nile School'));
      await tester.pumpAndSettle();

      expect(find.text('Nile School'), findsOneWidget);
      expect(find.text('No school selected'), findsNothing);
      expect(
        container.read(registrationControllerProvider)!.schoolId,
        'school-42',
      );
    });
  });
}
