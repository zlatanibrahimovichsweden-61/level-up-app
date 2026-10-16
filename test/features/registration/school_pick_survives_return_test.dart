import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/form_fields.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// BUG-027 — the School form forgot which school was picked (or skipped) once
/// the student left it: the chosen row lived in the screen's own state, so a
/// new screen state started with the search hint while the draft still held
/// the id. The row and the skip now live on the registration draft beside the
/// id (`pickedSchool`, `schoolSkipped`).
///
/// Driven through the app's REAL [routerProvider] and real taps — the picker
/// sheet, the back chip, Track's Continue — because the defect only shows when
/// the School screen is re-created.
///
/// The University track is checked the same way: its selections were already
/// drawn from the draft (`value: draft.universityId` …), so it never had the
/// defect; the test keeps it that way.

class _MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

class _FakeBody extends Fake implements RegistrationBody {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _name = 'Nour Hassan';
const _correctedName = 'Nour Hassan Ali';
const _parentPhone = '+2010000000001';
const _school = NamedRef(
  id: 'school-42',
  nameAr: 'مدرسة النيل',
  nameEn: 'Nile School',
);

void main() {
  setUpAll(() => registerFallbackValue(_FakeBody()));

  late _MockRegistrationRepository repo;
  late _MockSecureStorage storage;
  late MockReferenceRepository reference;

  setUp(() {
    repo = _MockRegistrationRepository();
    storage = _MockSecureStorage();
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    // The submit stays in flight: only the body it carries matters here.
    when(
      () => repo.register(any()),
    ).thenAnswer((_) => Completer<Never>().future);
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        registrationRepositoryProvider.overrideWithValue(repo),
        referenceRepositoryProvider.overrideWithValue(reference),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<ProviderContainer> pumpApp(
    WidgetTester tester, {
    required String language,
  }) async {
    final container = makeContainer();
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: Locale(language),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// A bounded `pumpAndSettle`: a focused field blinks its cursor forever.
  Future<void> frames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await frames(tester);
    await tester.tap(finder);
    await frames(tester);
  }

  Future<void> tapButton(WidgetTester tester, String label) =>
      tapVisible(tester, find.widgetWithText(FilledButton, label));

  String location(ProviderContainer container) =>
      container.read(routerProvider).state.uri.toString();

  Finder schoolField() => find.byKey(const Key('field-schoolId'));

  Finder inSchoolField(String text) =>
      find.descendant(of: schoolField(), matching: find.text(text));

  /// Opens a dropdown and taps one of its menu entries.
  Future<void> selectOption(
    WidgetTester tester,
    String fieldKey,
    String optionLabel,
  ) async {
    await tapVisible(tester, find.byKey(Key(fieldKey)));
    await tester.tap(find.text(optionLabel).last);
    await frames(tester);
  }

  /// Everything School needs but the school itself, as Sign Up_1, Track and an
  /// earlier visit to the form would have left it.
  void seedSchool(ProviderContainer container) {
    container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: _name, parentPhone: _parentPhone)
      ..setTrack(RegTrack.school)
      ..setDateOfBirth(DateTime(2009, 5, 1))
      ..setCountry(countryCode: 'EG', requiresGovernorate: true)
      ..setGovernorate('gov-cairo')
      ..setCity('city-nasr')
      ..setEducationSystem('ig')
      ..setStage('secondary1');
  }

  /// Sign Up_1 → Track → the detail screen with real taps.
  Future<void> reachDetail(
    WidgetTester tester,
    ProviderContainer container,
    AppLocalizations l10n,
    Type screen,
  ) async {
    container.read(routerProvider).go('/register');
    await frames(tester);
    expect(find.byType(SignupIdentityScreen), findsOneWidget);
    await tapButton(tester, l10n.continueLabel);
    expect(find.byType(SignupTrackScreen), findsOneWidget);
    await tapButton(tester, l10n.continueLabel);
    expect(find.byType(screen), findsOneWidget);
  }

  /// The detail form's back chip → Track → Continue: the School screen is
  /// popped (its state disposed) and a new one is pushed.
  Future<void> leaveAndComeBack(
    WidgetTester tester,
    AppLocalizations l10n,
    Type screen,
  ) async {
    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(screen),
        matching: find.byType(CircleBackButton),
      ),
    );
    expect(find.byType(screen), findsNothing);
    expect(find.byType(SignupTrackScreen), findsOneWidget);
    await tapButton(tester, l10n.continueLabel);
    expect(find.byType(screen), findsOneWidget);
  }

  Future<void> pickSchool(WidgetTester tester, String label) async {
    await tapVisible(tester, schoolField());
    await tester.tap(find.text(label).last);
    await frames(tester);
  }

  for (final language in ['en', 'ar']) {
    final l10n = lookupAppLocalizations(Locale(language));
    final schoolName = language == 'ar' ? _school.nameAr : _school.nameEn;

    group('School · $language', () {
      testWidgets('a picked school is still shown by name after the student '
          'leaves the form and comes back, and its id is what is sent', (
        tester,
      ) async {
        final container = await pumpApp(tester, language: language);
        seedSchool(container);
        await reachDetail(tester, container, l10n, SchoolDetailScreen);
        expect(inSchoolField(l10n.searchSchoolsHint), findsOneWidget);

        await pickSchool(tester, schoolName);
        expect(inSchoolField(schoolName), findsOneWidget);

        await leaveAndComeBack(tester, l10n, SchoolDetailScreen);

        // Before BUG-027's fix this was the search hint.
        expect(inSchoolField(schoolName), findsOneWidget);
        expect(inSchoolField(l10n.searchSchoolsHint), findsNothing);
        if (language == 'ar') {
          expect(
            Directionality.of(tester.element(inSchoolField(schoolName))),
            TextDirection.rtl,
          );
        }
        final draft = container.read(registrationControllerProvider)!;
        expect(draft.schoolId, _school.id);
        expect(draft.pickedSchool, _school);
        expect(draft.schoolSkipped, isFalse);
        // Every other field came back too.
        expect(draft.governorateId, 'gov-cairo');
        expect(draft.cityId, 'city-nasr');
        expect(draft.registrationToken, regArgs.registrationToken);

        await tapButton(tester, l10n.startLearning);
        final sent =
            verify(() => repo.register(captureAny())).captured.single
                as SchoolRegistration;
        expect(sent.schoolId, _school.id);
        expect(sent.registrationToken, regArgs.registrationToken);
      });

      testWidgets('after a refused name the trip back through Sign Up_1 keeps '
          'the picked school; the corrected name is sent once with it and the '
          'same token', (tester) async {
        var calls = 0;
        when(() => repo.register(any())).thenAnswer((_) {
          calls++;
          if (calls == 1) {
            return Future.error(
              const ApiException(status: 422, code: 'name_not_allowed'),
            );
          }
          return Completer<Never>().future;
        });
        final container = await pumpApp(tester, language: language);
        seedSchool(container);
        await reachDetail(tester, container, l10n, SchoolDetailScreen);
        await pickSchool(tester, schoolName);

        await tapButton(tester, l10n.startLearning);
        expect(location(container), '/register');
        expect(find.text(l10n.fieldRejected), findsOneWidget);

        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (w) => w is PlainTextField && w.hint == l10n.fullNameHint,
            ),
            matching: find.byType(TextField),
          ),
          _correctedName,
        );
        await frames(tester);
        await tapButton(tester, l10n.continueLabel);
        await tapButton(tester, l10n.continueLabel);
        expect(find.byType(SchoolDetailScreen), findsOneWidget);
        expect(inSchoolField(schoolName), findsOneWidget);

        await tapButton(tester, l10n.startLearning);
        final sent = verify(() => repo.register(captureAny())).captured;
        expect(sent, hasLength(2));
        final retry = sent[1] as SchoolRegistration;
        expect(retry.name, _correctedName);
        expect(retry.schoolId, _school.id);
        expect(retry.registrationToken, regArgs.registrationToken);
      });
    });
  }

  group('School · en', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    testWidgets('a skipped school still reads as answered after the student '
        'comes back, and no schoolId is sent', (tester) async {
      final container = await pumpApp(tester, language: 'en');
      seedSchool(container);
      await reachDetail(tester, container, l10n, SchoolDetailScreen);

      await tapVisible(
        tester,
        find.widgetWithText(TextButton, l10n.schoolNotFound),
      );
      expect(inSchoolField(l10n.schoolSkipped), findsOneWidget);

      await leaveAndComeBack(tester, l10n, SchoolDetailScreen);

      expect(inSchoolField(l10n.schoolSkipped), findsOneWidget);
      expect(inSchoolField(l10n.searchSchoolsHint), findsNothing);
      // The link stays gone while the field reads as resolved.
      expect(
        find.widgetWithText(TextButton, l10n.schoolNotFound),
        findsNothing,
      );
      final draft = container.read(registrationControllerProvider)!;
      expect(draft.schoolSkipped, isTrue);
      expect(draft.schoolId, isNull);
      expect(draft.pickedSchool, isNull);

      await tapButton(tester, l10n.startLearning);
      final sent =
          verify(() => repo.register(captureAny())).captured.single
              as SchoolRegistration;
      expect(sent.schoolId, isNull);
    });

    testWidgets('a new city still drops the picked school; picking the same '
        'city again keeps it', (tester) async {
      final container = await pumpApp(tester, language: 'en');
      seedSchool(container);
      await reachDetail(tester, container, l10n, SchoolDetailScreen);
      await pickSchool(tester, _school.nameEn);

      // The same city again: the school was picked inside it, so it stays —
      // on screen and in what would be sent.
      await selectOption(tester, 'field-cityId', 'Nasr City');
      expect(inSchoolField(_school.nameEn), findsOneWidget);
      expect(
        container.read(registrationControllerProvider)!.schoolId,
        _school.id,
      );

      // Another city: the school is scoped by city, so the question is new.
      await selectOption(tester, 'field-cityId', 'Maadi');
      expect(inSchoolField(l10n.searchSchoolsHint), findsOneWidget);
      final draft = container.read(registrationControllerProvider)!;
      expect(draft.schoolId, isNull);
      expect(draft.pickedSchool, isNull);
    });
  });

  testWidgets('University · en: the picked university, faculty and year are '
      'still shown after the student leaves the form and comes back', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final container = await pumpApp(tester, language: 'en');
    container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: _name, parentPhone: _parentPhone)
      ..setTrack(RegTrack.university)
      ..setDateOfBirth(DateTime(2004, 3, 7));
    await reachDetail(tester, container, l10n, UniversityDetailScreen);

    await selectOption(tester, 'field-universityId', 'Cairo University');
    await selectOption(tester, 'field-facultyId', 'Faculty of Medicine');
    await selectOption(tester, 'field-studyYearId', l10n.studyYearNumber(2));

    await leaveAndComeBack(tester, l10n, UniversityDetailScreen);

    const expected = {
      'field-universityId': 'uni-cairo',
      'field-facultyId': 'fac-medicine',
      'field-studyYearId': 'year-2',
    };
    for (final MapEntry(key: key, value: id) in expected.entries) {
      final dropdown = tester.widget<DropdownButton<String>>(
        find.descendant(
          of: find.byKey(Key(key)),
          matching: find.byType(DropdownButton<String>),
        ),
      );
      expect(dropdown.value, id, reason: key);
    }
    final draft = container.read(registrationControllerProvider)!;
    expect(draft.universityId, 'uni-cairo');
    expect(draft.facultyId, 'fac-medicine');
    expect(draft.studyYearId, 'year-2');

    await selectOption(tester, 'field-governorateId', 'Cairo');
    await selectOption(tester, 'field-cityId', 'Nasr City');
    await tapButton(tester, l10n.startLearning);
    final sent =
        verify(() => repo.register(captureAny())).captured.single
            as UniversityRegistration;
    expect(sent.universityId, 'uni-cairo');
    expect(sent.facultyId, 'fac-medicine');
    expect(sent.studyYearId, 'year-2');
  });

  group('the draft keeps the school as one answer', () {
    RegistrationController seeded(ProviderContainer container) =>
        container.read(registrationControllerProvider.notifier)
          ..start(regArgs)
          ..setCountry(countryCode: 'EG', requiresGovernorate: true)
          ..setGovernorate('gov-cairo')
          ..setCity('city-nasr');

    RegistrationDraft draftOf(ProviderContainer container) =>
        container.read(registrationControllerProvider)!;

    void expectNoSchool(RegistrationDraft draft, {required String reason}) {
      expect(draft.schoolId, isNull, reason: reason);
      expect(draft.pickedSchool, isNull, reason: reason);
      expect(draft.schoolSkipped, isFalse, reason: reason);
    }

    test('picking records the id and the row, and un-skips', () {
      final container = makeContainer();
      seeded(container)
        ..skipSchool()
        ..setSchool(_school.id, row: _school);
      expect(draftOf(container).schoolId, _school.id);
      expect(draftOf(container).pickedSchool, _school);
      expect(draftOf(container).schoolSkipped, isFalse);
    });

    test('skipping drops the id and the row', () {
      final container = makeContainer();
      seeded(container)
        ..setSchool(_school.id, row: _school)
        ..skipSchool();
      expect(draftOf(container).schoolId, isNull);
      expect(draftOf(container).pickedSchool, isNull);
      expect(draftOf(container).schoolSkipped, isTrue);
    });

    final changes = <String, void Function(RegistrationController)>{
      'a new country': (c) =>
          c.setCountry(countryCode: 'AE', requiresGovernorate: false),
      'a new governorate': (c) => c.setGovernorate('gov-giza'),
      'a new city': (c) => c.setCity('city-maadi'),
      'a typed city': (c) => c.setCityName('Somewhere'),
    };
    for (final MapEntry(key: label, value: change) in changes.entries) {
      test('$label drops the picked school, and the skip', () {
        final container = makeContainer();
        final controller = seeded(container)
          ..setSchool(_school.id, row: _school);
        change(controller);
        expectNoSchool(draftOf(container), reason: '$label after a pick');

        seeded(container);
        controller
          ..setCity('city-nasr')
          ..skipSchool();
        change(controller);
        expectNoSchool(draftOf(container), reason: '$label after a skip');
      });
    }

    test('the same country, governorate or city again changes nothing', () {
      final container = makeContainer();
      final controller = seeded(container)..setSchool(_school.id, row: _school);
      final before = draftOf(container);
      controller
        ..setCountry(countryCode: 'EG', requiresGovernorate: true)
        ..setGovernorate('gov-cairo')
        ..setCity('city-nasr');
      expect(draftOf(container), before);
    });

    test('a school set by id alone shows no row (nothing to name it by)', () {
      final container = makeContainer();
      seeded(container).setSchool(_school.id);
      expect(draftOf(container).schoolId, _school.id);
      expect(draftOf(container).pickedSchool, isNull);
    });

    test('the row never reaches the body: only the id is sent', () {
      final container = makeContainer();
      seeded(container)
        ..setIdentity(name: _name, parentPhone: _parentPhone)
        ..setTrack(RegTrack.school)
        ..setDateOfBirth(DateTime(2009, 5, 1))
        ..setEducationSystem('ig')
        ..setStage('secondary1')
        ..setSchool(_school.id, row: _school);
      final json = SchoolRegistration.fromDraft(
        draftOf(container),
        device: _device,
      ).toJson();
      expect(json['schoolId'], _school.id);
      expect(json.containsKey('pickedSchool'), isFalse);
      expect(json.containsKey('schoolSkipped'), isFalse);
      expect(json.containsKey('refusedNames'), isFalse);
      expect(json.toString(), isNot(contains(_school.nameEn)));
    });
  });
}
