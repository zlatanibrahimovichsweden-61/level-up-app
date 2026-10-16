import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/registration_validation.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/stage.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/registration_error_copy.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/widgets/registration_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// `422 school_stage_not_available` / `education_system_not_available` on
/// `POST /auth/register` (School body; contract 3.52.0-m1, spec-081).
///
/// The server says the grade (or the education system) the student chose is not
/// open. The contract says the `registrationToken` is NOT consumed, so the
/// student stays on the School form, fixes the choice and resubmits with the
/// SAME token. Nothing here resubmits on its own, restarts the registration,
/// shows a snackbar or navigates.
///
/// Driven through the real [SchoolDetailScreen], the real submit notifier and
/// the real controller, with only the two repositories mocked, at text scale
/// 1.3 on a short phone surface so that "scrolled into view" is a real test:
/// the refused field is off-screen when Start learning is tapped.

class _MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

class _FakeBody extends Fake implements RegistrationBody {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _scale = TextScaler.linear(1.3);

/// Short on purpose: with the CTA scrolled to the bottom, the Education System
/// and Grade blocks are both out of view (in English and in Arabic), so a
/// refused field that is on screen afterwards was scrolled there.
const _shortPhone = Size(412, 240);

const _stageRefused = ApiException(
  status: 422,
  code: 'school_stage_not_available',
);
const _systemRefused = ApiException(
  status: 422,
  code: 'education_system_not_available',
);

List<SchoolStageRef> _stages(Map<String, String> status) => [
  for (final stage in Stage.values)
    SchoolStageRef(
      stage: stage.wireValue,
      status: status[stage.wireValue] ?? 'active',
    ),
];

List<EducationSystemRef> _systems(Map<String, String> status) => [
  for (final (code, en, ar) in const [
    ('nationalArabic', 'National Arabic', 'وطني عربي'),
    ('nationalLanguages', 'National Languages', 'وطني لغات'),
    ('ig', 'IG', 'آي جي'),
  ])
    EducationSystemRef(
      code: code,
      nameAr: ar,
      nameEn: en,
      status: status[code] ?? (code == 'ig' ? 'soon' : 'active'),
    ),
];

void main() {
  setUpAll(() => registerFallbackValue(_FakeBody()));

  late _MockRegistrationRepository repo;
  late MockReferenceRepository reference;

  setUp(() {
    repo = _MockRegistrationRepository();
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
    // The student's lists, as read when the form opened: everything open.
    when(reference.getSchoolStages).thenAnswer((_) async => _stages({}));
    when(reference.getEducationSystems).thenAnswer((_) async => _systems({}));
  });

  /// Pumps the School screen with a complete, valid draft that holds a stage and
  /// an education system the server is about to refuse.
  Future<({ProviderContainer container, GoRouter router})> pump(
    WidgetTester tester, {
    required Locale locale,
    Size size = _shortPhone,
  }) async {
    final container = ProviderContainer(
      overrides: [
        referenceRepositoryProvider.overrideWithValue(reference),
        registrationRepositoryProvider.overrideWithValue(repo),
        deviceInfoProvider.overrideWith((ref) async => _device),
      ],
    );
    addTearDown(container.dispose);
    container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
      ..setTrack(RegTrack.school)
      ..setDateOfBirth(DateTime(2009, 5, 1))
      ..setCountry(countryCode: 'EG', requiresGovernorate: true)
      ..setGovernorate('gov-cairo')
      ..setCity('city-nasr')
      ..setEducationSystem('nationalArabic')
      ..setStage('secondary2');

    final router = GoRouter(
      initialLocation: '/register/school',
      routes: [
        GoRoute(
          path: '/register/school',
          builder: (_, _) => const SchoolDetailScreen(),
        ),
        GoRoute(path: '/register', builder: (_, _) => marker('SIGNUP_1')),
        GoRoute(path: '/login', builder: (_, _) => marker('LOGIN')),
        GoRoute(path: '/home', builder: (_, _) => marker('HOME')),
      ],
    );
    addTearDown(router.dispose);

    await tester.binding.setSurfaceSize(size);
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
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (container: container, router: router);
  }

  RegistrationDraft draftOf(ProviderContainer c) =>
      c.read(registrationControllerProvider)!;

  Finder field(String key) => find.byKey(Key(key));

  bool onScreen(WidgetTester tester, Finder f, Size size) {
    final rect = tester.getRect(f);
    return rect.top >= 0 &&
        rect.bottom <= size.height &&
        rect.left >= 0 &&
        rect.right <= size.width;
  }

  /// Scrolls to the CTA the way a student does, then taps it. [settle] false
  /// leaves a request in flight (its spinner never settles) and pumps a few
  /// bounded frames instead.
  Future<void> tapStartLearning(
    WidgetTester tester,
    AppLocalizations l10n, {
    bool settle = true,
  }) async {
    final cta = find.widgetWithText(FilledButton, l10n.startLearning);
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }
  }

  DropdownButton<String> dropdownOf(WidgetTester tester, String key) =>
      tester.widget<DropdownButton<String>>(
        find.descendant(
          of: field(key),
          matching: find.byType(DropdownButton<String>),
        ),
      );

  for (final language in ['en', 'ar']) {
    final locale = Locale(language);
    final l10n = lookupAppLocalizations(locale);
    final isAr = language == 'ar';
    const phone = _shortPhone;

    group('school_stage_not_available · $language', () {
      testWidgets('the form stays, the grade is forgotten and marked, the lists '
          'are read again, and nothing is resent', (tester) async {
        final (:container, :router) = await pump(tester, locale: locale);
        final before = draftOf(container);
        expect(before.stage, 'secondary2');

        // The server closes secondary2 after the student's lists were read.
        when(
          reference.getSchoolStages,
        ).thenAnswer((_) async => _stages({'secondary2': 'soon'}));
        when(() => repo.register(any())).thenThrow(_stageRefused);

        // Precondition: tapping Start learning scrolled the Grade field away.
        final cta = find.widgetWithText(FilledButton, l10n.startLearning);
        await tester.ensureVisible(cta);
        await tester.pumpAndSettle();
        expect(
          onScreen(tester, field('field-stage'), phone),
          isFalse,
          reason: 'the test needs the refused field to be out of view first',
        );
        await tester.tap(cta);
        await tester.pumpAndSettle();

        // 1 — the banner carries the contract copy, verbatim, in this language.
        expect(
          find.text(
            isAr
                ? 'ليفل أب غير متاح لهذا الصف بعد. قريبًا!'
                : "Level Up isn't open for this grade yet. Coming soon!",
          ),
          findsOneWidget,
        );
        expect(find.text(l10n.genericError), findsNothing);
        if (isAr) {
          expect(
            Directionality.of(tester.element(field('field-stage'))),
            TextDirection.rtl,
          );
        }

        // 2 — the refused selection is cleared; nothing else on the draft moved.
        final after = draftOf(container);
        expect(after.stage, isNull);
        expect(after, before.copyWith(stage: null));
        expect(dropdownOf(tester, 'field-stage').value, isNull);
        // 3 — the token is the same one.
        expect(after.registrationToken, regArgs.registrationToken);
        expect(after.isExpired, isFalse);

        // 4 — both lists were read again (initial read + one per list).
        verify(reference.getSchoolStages).called(2);
        verify(reference.getEducationSystems).called(2);
        // …and the fresh answer is what the picker now shows: secondary2 is Soon.
        expect(
          dropdownOf(
            tester,
            'field-stage',
          ).items!.firstWhere((i) => i.value == 'secondary2').enabled,
          isFalse,
        );

        // 5 — the Grade field is marked with the approved line, under Grade and
        // above School; the system is not marked.
        final line = find.text(l10n.fieldRejected);
        expect(line, findsOneWidget);
        expect(
          tester.getTopLeft(line).dy,
          greaterThan(tester.getBottomLeft(field('field-stage')).dy),
        );
        expect(
          tester.getTopLeft(line).dy,
          lessThan(tester.getTopLeft(field('field-schoolId')).dy),
        );

        // 6 — the refused field was scrolled back into view.
        expect(
          onScreen(tester, field('field-stage'), phone),
          isTrue,
          reason: 'the refused Grade field must be on screen',
        );

        // 7 — stayed on the screen; no snackbar, no navigation, no restart.
        expect(router.state.uri.toString(), '/register/school');
        expect(find.byType(SchoolDetailScreen), findsOneWidget);
        expect(find.byType(SnackBar), findsNothing);

        // 8 — one request, and no second one on its own.
        verify(() => repo.register(any())).called(1);
        await tester.pump(const Duration(seconds: 30));
        verifyNever(() => repo.register(any()));
      });

      testWidgets('the refused grade is forgotten even when the fresh list '
          'still calls it open — the server\'s 422 is what counts', (
        tester,
      ) async {
        final (:container, router: _) = await pump(tester, locale: locale);
        // Every status unchanged: only the register answer says "no".
        when(() => repo.register(any())).thenThrow(_stageRefused);

        await tapStartLearning(tester, l10n);

        expect(draftOf(container).stage, isNull);
        expect(draftOf(container).educationSystem, 'nationalArabic');
        expect(dropdownOf(tester, 'field-stage').value, isNull);
        expect(find.text(l10n.fieldRejected), findsOneWidget);
        verify(reference.getSchoolStages).called(2);
      });

      testWidgets('picking an open grade clears the banner and resubmits with '
          'the SAME token', (tester) async {
        final (:container, router: _) = await pump(tester, locale: locale);
        when(
          reference.getSchoolStages,
        ).thenAnswer((_) async => _stages({'secondary2': 'soon'}));
        when(() => repo.register(any())).thenThrow(_stageRefused);
        await tapStartLearning(tester, l10n);
        expect(find.byType(SubmitFailureBanner), findsOneWidget);

        // A taller surface, so the menu has room; the same screen and state.
        await tester.binding.setSurfaceSize(const Size(412, 2600));
        await tester.pumpAndSettle();
        await tester.tap(field('field-stage'));
        await tester.pumpAndSettle();
        final secondary3 = isAr ? l10n.stageSecondary3 : 'Secondary 3';
        await tester.tap(find.text(secondary3).last);
        await tester.pumpAndSettle();

        expect(draftOf(container).stage, 'secondary3');
        expect(find.byType(SubmitFailureBanner), findsNothing);
        expect(find.text(l10n.fieldRejected), findsNothing);

        when(
          () => repo.register(any()),
        ).thenAnswer((_) => Completer<Never>().future);
        await tapStartLearning(tester, l10n, settle: false);

        final sent = verify(() => repo.register(captureAny())).captured;
        expect(sent, hasLength(2));
        final first = sent[0] as SchoolRegistration;
        final second = sent[1] as SchoolRegistration;
        expect(first.stage, 'secondary2');
        expect(second.stage, 'secondary3');
        expect(second.registrationToken, regArgs.registrationToken);
        expect(second.registrationToken, first.registrationToken);
      });

      testWidgets('when both are closed the server answers with the stage '
          'code: the stage goes at once, the system once the fresh list says '
          'it is closed — quietly, and only the grade is marked', (
        tester,
      ) async {
        final (:container, router: _) = await pump(tester, locale: locale);
        when(
          reference.getSchoolStages,
        ).thenAnswer((_) async => _stages({'secondary2': 'soon'}));
        when(
          reference.getEducationSystems,
        ).thenAnswer((_) async => _systems({'nationalArabic': 'soon'}));
        when(() => repo.register(any())).thenThrow(_stageRefused);

        await tapStartLearning(tester, l10n);

        expect(draftOf(container).stage, isNull);
        expect(draftOf(container).educationSystem, isNull);
        expect(
          find.text(l10n.registrationSchoolStageNotAvailable),
          findsOneWidget,
        );
        expect(
          find.text(l10n.registrationEducationSystemNotAvailable),
          findsNothing,
        );
        expect(find.text(l10n.fieldRejected), findsOneWidget);
        expect(find.byType(SnackBar), findsNothing);
      });
    });

    group('education_system_not_available · $language', () {
      testWidgets('the form stays, the system is forgotten and marked, the '
          'lists are read again, and nothing is resent', (tester) async {
        final (:container, :router) = await pump(tester, locale: locale);
        final before = draftOf(container);
        expect(before.educationSystem, 'nationalArabic');

        when(
          reference.getEducationSystems,
        ).thenAnswer((_) async => _systems({'nationalArabic': 'soon'}));
        when(() => repo.register(any())).thenThrow(_systemRefused);

        // The Education System block sits above Grade, so it is out of view
        // once the CTA has been scrolled to.
        final cta = find.widgetWithText(FilledButton, l10n.startLearning);
        await tester.ensureVisible(cta);
        await tester.pumpAndSettle();
        expect(
          onScreen(tester, field('field-educationSystem'), phone),
          isFalse,
          reason: 'the test needs the refused field to be out of view first',
        );
        await tester.tap(cta);
        await tester.pumpAndSettle();

        expect(
          find.text(
            isAr
                ? 'هذا النظام التعليمي غير متاح بعد. قريبًا!'
                : "This education system isn't available yet. Coming soon!",
          ),
          findsOneWidget,
        );
        expect(find.text(l10n.genericError), findsNothing);

        final after = draftOf(container);
        expect(after.educationSystem, isNull);
        expect(after, before.copyWith(educationSystem: null));
        expect(dropdownOf(tester, 'field-educationSystem').value, isNull);
        expect(after.registrationToken, regArgs.registrationToken);
        expect(after.isExpired, isFalse);
        // The grade is untouched: only the refused field is forgotten.
        expect(after.stage, 'secondary2');

        verify(reference.getSchoolStages).called(2);
        verify(reference.getEducationSystems).called(2);
        expect(
          dropdownOf(
            tester,
            'field-educationSystem',
          ).items!.firstWhere((i) => i.value == 'nationalArabic').enabled,
          isFalse,
        );

        // Marked under the Education System, above Grade — and only there.
        final line = find.text(l10n.fieldRejected);
        expect(line, findsOneWidget);
        expect(
          tester.getTopLeft(line).dy,
          greaterThan(tester.getBottomLeft(field('field-educationSystem')).dy),
        );
        expect(
          tester.getTopLeft(line).dy,
          lessThan(tester.getTopLeft(find.text(l10n.stageLabel)).dy),
        );

        expect(
          onScreen(tester, field('field-educationSystem'), phone),
          isTrue,
          reason: 'the refused Education System field must be on screen',
        );

        expect(router.state.uri.toString(), '/register/school');
        expect(find.byType(SchoolDetailScreen), findsOneWidget);
        expect(find.byType(SnackBar), findsNothing);

        verify(() => repo.register(any())).called(1);
        await tester.pump(const Duration(seconds: 30));
        verifyNever(() => repo.register(any()));
      });

      testWidgets('the refused system is forgotten even when the fresh list '
          'still calls it open — the server\'s 422 is what counts', (
        tester,
      ) async {
        final (:container, router: _) = await pump(tester, locale: locale);
        // Every status unchanged: only the register answer says "no".
        when(() => repo.register(any())).thenThrow(_systemRefused);

        await tapStartLearning(tester, l10n);

        expect(draftOf(container).educationSystem, isNull);
        expect(draftOf(container).stage, 'secondary2');
        expect(dropdownOf(tester, 'field-educationSystem').value, isNull);
        expect(find.text(l10n.fieldRejected), findsOneWidget);
        verify(reference.getEducationSystems).called(2);
      });

      testWidgets('picking an open system resubmits with the SAME token', (
        tester,
      ) async {
        final (:container, router: _) = await pump(tester, locale: locale);
        when(
          reference.getEducationSystems,
        ).thenAnswer((_) async => _systems({'nationalArabic': 'soon'}));
        when(() => repo.register(any())).thenThrow(_systemRefused);
        await tapStartLearning(tester, l10n);
        expect(find.byType(SubmitFailureBanner), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(412, 2600));
        await tester.pumpAndSettle();
        await tester.tap(field('field-educationSystem'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(isAr ? 'وطني لغات' : 'National Languages').last,
        );
        await tester.pumpAndSettle();

        expect(draftOf(container).educationSystem, 'nationalLanguages');
        expect(find.byType(SubmitFailureBanner), findsNothing);

        when(
          () => repo.register(any()),
        ).thenAnswer((_) => Completer<Never>().future);
        await tapStartLearning(tester, l10n, settle: false);

        final sent = verify(() => repo.register(captureAny())).captured;
        expect(sent, hasLength(2));
        final second = sent[1] as SchoolRegistration;
        expect(second.educationSystem, 'nationalLanguages');
        expect(second.registrationToken, regArgs.registrationToken);
      });
    });
  }

  // The pickers stay enabled while Start learning is in flight, so a student
  // can pick another value before the refusal for the OLD one lands. The 422
  // answers the request that was SENT: it must forget that choice, never the
  // valid one picked since.
  group('a 422 for the choice that was SENT, landing after a new pick', () {
    final en = lookupAppLocalizations(const Locale('en'));

    /// Bounded frames: the in-flight spinner never lets `pumpAndSettle` end.
    Future<void> pumpFrames(WidgetTester tester) async {
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    /// Opens [key]'s menu and taps [label], with the request still pending.
    Future<void> pickWhilePending(
      WidgetTester tester,
      String key,
      String label,
    ) async {
      await tester.tap(field(key));
      await pumpFrames(tester);
      await tester.tap(find.text(label).last);
      await pumpFrames(tester);
    }

    testWidgets('school_stage_not_available clears the grade that was sent, '
        'not the open grade picked while it was in flight', (tester) async {
      final (:container, router: _) = await pump(
        tester,
        locale: const Locale('en'),
      );
      final pending = Completer<Never>();
      when(() => repo.register(any())).thenAnswer((_) => pending.future);

      await tapStartLearning(tester, en, settle: false);
      verify(() => repo.register(any())).called(1);
      expect(draftOf(container).stage, 'secondary2');

      // While the request is pending: a different, open grade.
      await tester.binding.setSurfaceSize(const Size(412, 2600));
      await pumpFrames(tester);
      await pickWhilePending(tester, 'field-stage', 'Secondary 3');
      expect(draftOf(container).stage, 'secondary3');

      pending.completeError(_stageRefused);
      await tester.pumpAndSettle();

      expect(
        draftOf(container).stage,
        'secondary3',
        reason: 'the 422 was about secondary2, which is no longer the choice',
      );
      expect(dropdownOf(tester, 'field-stage').value, 'secondary3');
      expect(draftOf(container).educationSystem, 'nationalArabic');
      // The rest of the refusal is unchanged: both lists read again, and the
      // one request is not repeated on its own.
      verify(reference.getSchoolStages).called(2);
      verify(reference.getEducationSystems).called(2);
      await tester.pump(const Duration(seconds: 30));
      verifyNever(() => repo.register(any()));
    });

    testWidgets('education_system_not_available clears the system that was '
        'sent, not the open system picked while it was in flight', (
      tester,
    ) async {
      final (:container, router: _) = await pump(
        tester,
        locale: const Locale('en'),
      );
      final pending = Completer<Never>();
      when(() => repo.register(any())).thenAnswer((_) => pending.future);

      await tapStartLearning(tester, en, settle: false);
      verify(() => repo.register(any())).called(1);
      expect(draftOf(container).educationSystem, 'nationalArabic');

      // While the request is pending: a different, open education system.
      await tester.binding.setSurfaceSize(const Size(412, 2600));
      await pumpFrames(tester);
      await pickWhilePending(
        tester,
        'field-educationSystem',
        'National Languages',
      );
      expect(draftOf(container).educationSystem, 'nationalLanguages');

      pending.completeError(_systemRefused);
      await tester.pumpAndSettle();

      expect(
        draftOf(container).educationSystem,
        'nationalLanguages',
        reason: 'the 422 was about nationalArabic, no longer the choice',
      );
      expect(
        dropdownOf(tester, 'field-educationSystem').value,
        'nationalLanguages',
      );
      expect(draftOf(container).stage, 'secondary2');
      verify(reference.getSchoolStages).called(2);
      verify(reference.getEducationSystems).called(2);
      await tester.pump(const Duration(seconds: 30));
      verifyNever(() => repo.register(any()));
    });
  });

  group('the 422 helpers', () {
    test('each predicate matches its own code only', () {
      expect(isSchoolStageNotAvailable(_stageRefused), isTrue);
      expect(isSchoolStageNotAvailable(_systemRefused), isFalse);
      expect(isEducationSystemNotAvailable(_systemRefused), isTrue);
      expect(isEducationSystemNotAvailable(_stageRefused), isFalse);
      expect(isSchoolStageNotAvailable(null), isFalse);
      expect(isEducationSystemNotAvailable(const OfflineException()), isFalse);
      expect(
        isSchoolStageNotAvailable(
          const ApiException(status: 422, code: 'name_not_allowed'),
        ),
        isFalse,
      );
    });

    test('neither restarts the registration — the token is not consumed', () {
      expect(restartsRegistration(_stageRefused), isFalse);
      expect(restartsRegistration(_systemRefused), isFalse);
    });

    test(
      'each maps onto its own field, as the approved "check this field"',
      () {
        expect(fieldIssuesFrom(_stageRefused), {
          RegFields.stage: RegFieldIssue.rejected,
        });
        expect(fieldIssuesFrom(_systemRefused), {
          RegFields.educationSystem: RegFieldIssue.rejected,
        });
      },
    );

    test('the copy: English is the contract\'s suggested copy verbatim '
        '(apostrophe U+0027); Arabic is the contract\'s suggested copy with '
        'the app\'s own spelling «قريبًا» (owner decision 2026-10-15)', () {
      final en = lookupAppLocalizations(const Locale('en'));
      final ar = lookupAppLocalizations(const Locale('ar'));

      expect(
        registrationErrorMessage(en, _stageRefused),
        "Level Up isn't open for this grade yet. Coming soon!",
      );
      expect(
        registrationErrorMessage(en, _systemRefused),
        "This education system isn't available yet. Coming soon!",
      );
      expect(
        registrationErrorMessage(ar, _stageRefused),
        'ليفل أب غير متاح لهذا الصف بعد. قريبًا!',
      );
      expect(
        registrationErrorMessage(ar, _systemRefused),
        'هذا النظام التعليمي غير متاح بعد. قريبًا!',
      );
      expect(en.registrationSoonMark, 'Soon');

      // The app's one spelling of "soon": the Soon mark IS the existing
      // `comingSoon` string - fathatan U+064B on the beh, then alef U+0627.
      expect(ar.registrationSoonMark, ar.comingSoon);
      const appSpelling = [0x0642, 0x0631, 0x064A, 0x0628, 0x064B, 0x0627];
      expect(ar.registrationSoonMark.runes.toList(), appSpelling);
      expect(
        ar.comingSoon.runes.toList(),
        appSpelling,
        reason: '`comingSoon` is untouched',
      );

      // None of the three keys carries the other spelling, alef U+0627 then
      // fathatan U+064B («اً»).
      const alefThenFathatan = 'اً';
      expect(
        alefThenFathatan.runes.toList(),
        [0x0627, 0x064B],
        reason: 'the probe itself must be alef then fathatan',
      );
      for (final (key, value) in [
        ('registrationSoonMark', ar.registrationSoonMark),
        (
          'registrationSchoolStageNotAvailable',
          ar.registrationSchoolStageNotAvailable,
        ),
        (
          'registrationEducationSystemNotAvailable',
          ar.registrationEducationSystemNotAvailable,
        ),
      ]) {
        expect(
          value,
          isNot(contains(alefThenFathatan)),
          reason: '$key must use «قريبًا», not «قريباً»',
        );
      }

      // They stay separate KEYS, and the English pair stays different.
      expect(en.comingSoon, 'Coming soon');
      expect(en.registrationSoonMark, isNot(en.comingSoon));
    });

    test(
      'the controller clears one field and leaves the rest and the token',
      () {
        final c = ProviderContainer();
        addTearDown(c.dispose);
        final controller = c.read(registrationControllerProvider.notifier);

        // No draft: both are no-ops.
        controller
          ..clearStage()
          ..clearEducationSystem();
        expect(c.read(registrationControllerProvider), isNull);

        controller
          ..start(regArgs)
          ..setStage('secondary2')
          ..setEducationSystem('nationalArabic');
        controller.clearStage();
        expect(c.read(registrationControllerProvider)!.stage, isNull);
        expect(
          c.read(registrationControllerProvider)!.educationSystem,
          'nationalArabic',
        );
        controller.clearEducationSystem();
        expect(c.read(registrationControllerProvider)!.educationSystem, isNull);
        expect(
          c.read(registrationControllerProvider)!.registrationToken,
          regArgs.registrationToken,
        );
      },
    );
  });
}
