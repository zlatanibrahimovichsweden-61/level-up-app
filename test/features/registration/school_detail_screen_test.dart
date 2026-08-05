import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
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
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+201021871999')
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
    testWidgets('renders the title, subtitle and Start learning CTA',
        (tester) async {
      await pump(tester);

      expect(find.text('School Registration'), findsWidgets);
      expect(find.text('Complete your profile to get started'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Start learning'),
        findsOneWidget,
      );
    });

    testWidgets('shows the frame fields in order after Date of Birth',
        (tester) async {
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

    testWidgets(
      'includes the Date of Birth field the Figma frame is missing '
      '(DESIGN_ISSUES #2 — contract-required)',
      (tester) async {
        await pump(tester);
        expect(find.byKey(const Key('field-dateOfBirth')), findsOneWidget);
      },
    );

    testWidgets('defaults the country to Egypt from the server list',
        (tester) async {
      final container = await pump(tester);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.countryCode, 'EG');
      expect(draft.requiresGovernorate, isTrue);
    });
  });

  group('geography conditionality (adr-010)', () {
    testWidgets('Egypt shows Governorate + the coded school picker',
        (tester) async {
      await pump(tester);

      expect(find.byKey(const Key('field-governorateId')), findsOneWidget);
      expect(find.byKey(const Key('field-schoolId')), findsOneWidget);
    });

    testWidgets(
      'a non-Egypt country hides Governorate AND the school step entirely',
      (tester) async {
        final container = await pump(tester);
        container.read(registrationControllerProvider.notifier).setCountry(
              countryCode: 'AE',
              requiresGovernorate: false,
            );
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

    testWidgets('switching country clears the dependent geography',
        (tester) async {
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

      container.read(registrationControllerProvider.notifier).setCountry(
            countryCode: 'AE',
            requiresGovernorate: false,
          );
      await tester.pumpAndSettle();

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.governorateId, isNull);
      expect(draft.cityId, isNull);
      expect(draft.schoolId, isNull);
    });

    testWidgets('City stays gated until a governorate is chosen (Egypt)',
        (tester) async {
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
        () => reference.getCities(
          countryCode: 'EG',
          governorateId: 'gov-cairo',
        ),
      ).called(1);
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

    testWidgets('empty → the localized empty line, not a blank field',
        (tester) async {
      when(() => reference.getEducationSystems()).thenAnswer((_) async => []);
      await pump(tester);

      expect(find.text('Nothing to show here'), findsWidgets);
    });

    testWidgets('error → message + a user-tapped Retry that refetches',
        (tester) async {
      when(() => reference.getEducationSystems())
          .thenThrow(const UnknownException());
      await pump(tester);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);

      when(() => reference.getEducationSystems())
          .thenAnswer((_) async => educationSystems);
      await tapVisible(tester, find.widgetWithText(TextButton, 'Retry'));

      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('offline → its own copy, distinct from a generic error',
        (tester) async {
      when(() => reference.getEducationSystems())
          .thenThrow(const NetworkException(detail: 'timeout'));
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
    testWidgets('an incomplete form shows inline errors and sends no request',
        (tester) async {
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
    testWidgets('an expired token renders the expiry view instead of the form',
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
                phone: '+201555000111',
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
    });

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
      when(() => reference.getEducationSystems())
          .thenThrow(const NetworkException(detail: 'timeout'));
      await pump(tester, locale: const Locale('ar'));

      expect(find.text('أنت غير متصل بالإنترنت'), findsOneWidget);
    });
  });
}
