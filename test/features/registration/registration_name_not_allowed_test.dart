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
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/registration_validation.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/notifier/registration_submit_notifier.dart';
import 'package:level_up_app/features/registration/registration_error_copy.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/features/registration/widgets/registration_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// `422 name_not_allowed` on `POST /auth/register` (upstream contract
/// 3.47.0-m1, built ahead of the vendored 3.46.0-m1 pin on the owner's word,
/// 2026-10-10).
///
/// The name is asked on Sign Up_1 but submitted from a detail screen, so the
/// refusal sends the student back to Sign Up_1 with the name marked by the
/// approved "Please check this field". The draft and its `registrationToken`
/// are kept, because the contract says the token is not used by this refusal,
/// and nothing is resent on its own.
///
/// The contract also says not to retry the same name, so the refused name is
/// recorded on the draft (owner, 2026-10-10): it stays marked, Continue will not
/// go on with it, and the submit will not send it again. Only a different name
/// clears the mark and goes forward, with the same token.
///
/// Driven through the app's REAL [routerProvider] and real taps, so the
/// one-screen stack the return rebuilds is the production route table, and
/// Sign Up_1 re-mounts into an existing tree (the only place BUG-001-style
/// build-phase mutations show).

class _MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

class _FakeBody extends Fake implements RegistrationBody {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');

/// The server's refusal. The response does not repeat the name.
const _nameNotAllowed = ApiException(status: 422, code: 'name_not_allowed');

const _name = 'Nour Hassan';
const _correctedName = 'Nour Hassan Ali';
const _parentPhone = '+2010000000001';

typedef _Track = ({
  RegTrack track,
  String path,
  Type screen,
  void Function(RegistrationController controller) seed,
  Map<String, String> dropdowns,
});

final _tracks = <String, _Track>{
  'School': (
    track: RegTrack.school,
    path: '/register/school',
    screen: SchoolDetailScreen,
    seed: (controller) => controller
      ..start(regArgs)
      ..setIdentity(name: _name, parentPhone: _parentPhone)
      ..setTrack(RegTrack.school)
      ..setDateOfBirth(DateTime(2009, 5, 1))
      ..setCountry(countryCode: 'EG', requiresGovernorate: true)
      ..setGovernorate('gov-cairo')
      ..setCity('city-nasr')
      ..setEducationSystem('ig')
      ..setStage('secondary1')
      ..setSchool('school-42'),
    dropdowns: const {
      'field-countryCode': 'EG',
      'field-governorateId': 'gov-cairo',
      'field-cityId': 'city-nasr',
      'field-educationSystem': 'ig',
      'field-stage': 'secondary1',
    },
  ),
  'University': (
    track: RegTrack.university,
    path: '/register/university',
    screen: UniversityDetailScreen,
    seed: (controller) => controller
      ..start(regArgs)
      ..setIdentity(name: _name, parentPhone: _parentPhone)
      ..setTrack(RegTrack.university)
      ..setDateOfBirth(DateTime(2004, 3, 7))
      ..setUniversity('uni-cairo')
      ..setFaculty('fac-medicine')
      ..setStudyYear('year-2')
      ..setGovernorate('gov-cairo')
      ..setCity('city-nasr'),
    dropdowns: const {
      'field-universityId': 'uni-cairo',
      'field-facultyId': 'fac-medicine',
      'field-studyYearId': 'year-2',
      'field-governorateId': 'gov-cairo',
      'field-cityId': 'city-nasr',
    },
  ),
};

/// The two body fields this file is about, whichever track sent them.
({String token, String name}) _wire(Object? body) => switch (body) {
  SchoolRegistration(:final registrationToken, :final name) => (
    token: registrationToken,
    name: name,
  ),
  UniversityRegistration(:final registrationToken, :final name) => (
    token: registrationToken,
    name: name,
  ),
  _ => throw StateError('not a registration body: ${body.runtimeType}'),
};

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
    // Signed out: the guard keeps the whole /register wizard reachable.
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
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
    // Tall enough for the whole detail form, so no tap lands off-screen.
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

  Future<void> tapButton(WidgetTester tester, String label) async {
    final finder = find.widgetWithText(FilledButton, label);
    await tester.ensureVisible(finder);
    await frames(tester);
    await tester.tap(finder);
    await frames(tester);
  }

  String location(ProviderContainer container) =>
      container.read(routerProvider).state.uri.toString();

  Finder nameField(AppLocalizations l10n, {bool skipOffstage = true}) =>
      find.byWidgetPredicate(
        (widget) =>
            widget is PlainTextField && widget.hint == l10n.fullNameHint,
        skipOffstage: skipOffstage,
      );

  Finder nameInput(AppLocalizations l10n) =>
      find.descendant(of: nameField(l10n), matching: find.byType(TextField));

  /// Seeds the draft (as OTP + Sign Up_1 + Track would have), then walks
  /// Sign Up_1 → Track → the detail screen with real taps, so the stack is
  /// the one a student builds.
  Future<void> reachDetail(
    WidgetTester tester,
    ProviderContainer container,
    _Track track,
    AppLocalizations l10n,
  ) async {
    track.seed(container.read(registrationControllerProvider.notifier));
    container.read(routerProvider).go('/register');
    await frames(tester);
    expect(find.byType(SignupIdentityScreen), findsOneWidget);
    await tapButton(tester, l10n.continueLabel);
    expect(find.byType(SignupTrackScreen), findsOneWidget);
    await tapButton(tester, l10n.continueLabel);
    expect(find.byType(track.screen), findsOneWidget);
    expect(location(container), track.path);
  }

  for (final MapEntry(key: trackName, value: track) in _tracks.entries) {
    for (final language in ['en', 'ar']) {
      final l10n = lookupAppLocalizations(Locale(language));

      group('$trackName · $language', () {
        testWidgets('a refused name goes back to Sign Up_1, marked with the '
            'approved line; the draft and its token are kept, and nothing is '
            'resent', (tester) async {
          when(() => repo.register(any())).thenThrow(_nameNotAllowed);
          final container = await pumpApp(tester, language: language);
          await reachDetail(tester, container, track, l10n);
          final before = container.read(registrationControllerProvider);

          await tapButton(tester, l10n.startLearning);

          // Back on the name step: the one-screen stack OTP leaves.
          expect(location(container), '/register');
          expect(find.byType(SignupIdentityScreen), findsOneWidget);
          expect(find.byType(track.screen), findsNothing);
          expect(find.byType(SignupTrackScreen), findsNothing);

          // The approved field line, under the name, and the field marked.
          final line = find.text(l10n.fieldRejected);
          expect(line, findsOneWidget);
          expect(
            tester.getTopLeft(line).dy,
            greaterThan(tester.getBottomLeft(nameField(l10n)).dy),
          );
          expect(
            tester.getTopLeft(line).dy,
            lessThan(tester.getTopLeft(find.text(l10n.phoneLabel)).dy),
          );
          expect(
            tester.widget<PlainTextField>(nameField(l10n)).hasError,
            isTrue,
          );
          // Not the generic line, and no restart.
          expect(find.text(l10n.genericError), findsNothing);
          expect(find.byType(SnackBar), findsNothing);
          if (language == 'ar') {
            expect(Directionality.of(tester.element(line)), TextDirection.rtl);
          }

          // The refused name is still in the field, from the draft.
          expect(
            tester.widget<TextField>(nameInput(l10n)).controller!.text,
            _name,
          );
          // The whole draft, token and deadline included, is untouched but for
          // the refused name, now recorded on it.
          final after = container.read(registrationControllerProvider);
          expect(after, before!.copyWith(refusedNames: {_name}));
          expect(after!.registrationToken, regArgs.registrationToken);
          expect(after.isExpired, isFalse);

          // Sent once, and never again on its own.
          verify(() => repo.register(any())).called(1);
          await tester.pump(const Duration(seconds: 30));
          verifyNever(() => repo.register(any()));
        });

        testWidgets('the corrected name goes forward through a filled-in '
            'wizard and is sent once, with the same token', (tester) async {
          var calls = 0;
          when(() => repo.register(any())).thenAnswer((_) {
            calls++;
            if (calls == 1) return Future.error(_nameNotAllowed);
            // The retry stays in flight: where a 201 lands is covered by
            // `registration_return_target_test.dart`.
            return Completer<Never>().future;
          });
          final container = await pumpApp(tester, language: language);
          await reachDetail(tester, container, track, l10n);
          await tapButton(tester, l10n.startLearning);
          expect(find.text(l10n.fieldRejected), findsOneWidget);

          // A genuine edit takes the mark off at once…
          await tester.enterText(nameInput(l10n), _correctedName);
          await frames(tester);
          expect(find.text(l10n.fieldRejected), findsNothing);
          expect(
            tester.widget<PlainTextField>(nameField(l10n)).hasError,
            isFalse,
          );
          // …typing the refused name back brings it back…
          await tester.enterText(nameInput(l10n), _name);
          await frames(tester);
          expect(find.text(l10n.fieldRejected), findsOneWidget);
          // …and the corrected name takes it off again.
          await tester.enterText(nameInput(l10n), _correctedName);
          await frames(tester);
          expect(find.text(l10n.fieldRejected), findsNothing);

          await tapButton(tester, l10n.continueLabel);
          expect(location(container), '/register/track');
          // Going on with an accepted name spends the refusal's outcome.
          expect(container.read(registrationSubmitProvider).hasError, isFalse);
          await tapButton(tester, l10n.continueLabel);
          expect(location(container), track.path);

          // The detail form comes back filled in, with no stale banner.
          expect(find.byType(SubmitFailureBanner), findsNothing);
          for (final MapEntry(key: key, value: id) in track.dropdowns.entries) {
            final dropdown = tester.widget<DropdownButton<String>>(
              find.descendant(
                of: find.byKey(Key(key)),
                matching: find.byType(DropdownButton<String>),
              ),
            );
            expect(dropdown.value, id, reason: key);
          }
          final draft = container.read(registrationControllerProvider)!;
          expect(draft.name, _correctedName);
          expect(draft.parentPhone, _parentPhone);
          expect(draft.dateOfBirth, isNotNull);
          expect(draft.refusedNames, {_name});

          await tapButton(tester, l10n.startLearning);

          // One request for the refused name, one for the corrected one.
          final sent = verify(() => repo.register(captureAny())).captured;
          expect(sent, hasLength(2));
          expect(_wire(sent[0]), (
            token: regArgs.registrationToken,
            name: _name,
          ));
          expect(_wire(sent[1]), (
            token: regArgs.registrationToken,
            name: _correctedName,
          ));
          if (track.track == RegTrack.school) {
            // The school id was kept in the draft and goes out again. It is
            // seeded by id here; the picked NAME surviving the trip is
            // `school_pick_survives_return_test.dart` (BUG-027).
            expect((sent[1] as SchoolRegistration).schoolId, 'school-42');
          }
        });
      });
    }

    for (final language in ['en', 'ar']) {
      testWidgets('$trackName · $language: the unchanged name is not sent '
          'again — Continue keeps it marked and stays, coming back keeps it '
          'marked', (tester) async {
        final l10n = lookupAppLocalizations(Locale(language));
        when(() => repo.register(any())).thenThrow(_nameNotAllowed);
        final container = await pumpApp(tester, language: language);
        await reachDetail(tester, container, track, l10n);
        await tapButton(tester, l10n.startLearning);
        verify(() => repo.register(any())).called(1);
        expect(location(container), '/register');

        void expectStillRefused() {
          expect(location(container), '/register');
          expect(find.byType(SignupIdentityScreen), findsOneWidget);
          expect(find.byType(SignupTrackScreen), findsNothing);
          expect(find.text(l10n.fieldRejected), findsOneWidget);
          expect(
            tester.widget<PlainTextField>(nameField(l10n)).hasError,
            isTrue,
          );
          expect(
            isNameNotAllowed(container.read(registrationSubmitProvider).error),
            isTrue,
          );
        }

        // Continue, twice, with the name as it came back.
        await tapButton(tester, l10n.continueLabel);
        expectStillRefused();
        await tapButton(tester, l10n.continueLabel);
        expectStillRefused();

        // Spaces around it do not make it a different name: it is sent
        // trimmed, so it is the same name to the server.
        await tester.enterText(nameInput(l10n), '  $_name  ');
        await frames(tester);
        expectStillRefused();
        await tapButton(tester, l10n.continueLabel);
        expectStillRefused();

        // Coming back to the screen (it re-mounts from the draft) does not
        // clear it either.
        container.read(routerProvider).go('/login');
        await frames(tester);
        container.read(routerProvider).go('/register');
        await frames(tester);
        expect(
          tester.widget<TextField>(nameInput(l10n)).controller!.text,
          _name,
        );
        expectStillRefused();
        await tapButton(tester, l10n.continueLabel);
        expectStillRefused();

        // The other fields are untouched, and nothing more was sent.
        final draft = container.read(registrationControllerProvider)!;
        expect(draft.registrationToken, regArgs.registrationToken);
        expect(draft.parentPhone, _parentPhone);
        expect(draft.track, track.track);
        expect(draft.refusedNames, {_name});
        await tester.pump(const Duration(seconds: 30));
        verifyNever(() => repo.register(any()));
      });
    }

    testWidgets('$trackName · en: a refusal that lands after the student left '
        'the detail screen — coming back and tapping Start learning sends '
        'nothing and goes to Sign Up_1, marked', (tester) async {
      final l10n = lookupAppLocalizations(const Locale('en'));
      final response = Completer<AuthenticatedResult>();
      when(() => repo.register(any())).thenAnswer((_) => response.future);
      final container = await pumpApp(tester, language: 'en');
      await reachDetail(tester, container, track, l10n);

      // In flight, the student backs out to Track…
      await tapButton(tester, l10n.startLearning);
      await tester.tap(
        find.descendant(
          of: find.byType(track.screen),
          matching: find.byType(CircleBackButton),
        ),
      );
      await frames(tester);
      expect(location(container), '/register/track');

      // …and the refusal lands with no detail screen to hear it.
      response.completeError(_nameNotAllowed);
      await frames(tester);
      expect(location(container), '/register/track');
      expect(container.read(registrationControllerProvider)!.refusedNames, {
        _name,
      });

      // Forward again, and Start learning: nothing is sent, the student is
      // taken to the name, and it is marked.
      await tapButton(tester, l10n.continueLabel);
      expect(find.byType(track.screen), findsOneWidget);
      await tapButton(tester, l10n.startLearning);

      expect(location(container), '/register');
      expect(find.text(l10n.fieldRejected), findsOneWidget);
      verify(() => repo.register(any())).called(1);
    });

    testWidgets('$trackName · en: the form sliding back shows no banner of '
        'its own', (tester) async {
      final l10n = lookupAppLocalizations(const Locale('en'));
      when(() => repo.register(any())).thenThrow(_nameNotAllowed);
      final container = await pumpApp(tester, language: 'en');
      await reachDetail(tester, container, track, l10n);

      final cta = find.widgetWithText(FilledButton, l10n.startLearning);
      await tester.ensureVisible(cta);
      await frames(tester);
      await tester.tap(cta);
      // Frame by frame through the transition: the outgoing form is still
      // painted, and it must not flash a banner for an error Sign Up_1 owns.
      for (var i = 0; i < 16; i++) {
        await tester.pump(const Duration(milliseconds: 25));
        expect(
          find.byType(SubmitFailureBanner, skipOffstage: false),
          findsNothing,
          reason: 'frame ${i + 1}',
        );
      }
      await frames(tester);
      expect(location(container), '/register');
    });

    group('$trackName · other failures keep their existing behaviour', () {
      final l10n = lookupAppLocalizations(const Locale('en'));

      final staying = <String, ({Object error, String banner})>{
        '500 internal_error': (
          error: const ApiException(status: 500, code: 'internal_error'),
          banner: l10n.genericError,
        ),
        'a 422 with another code': (
          error: const ApiException(status: 422, code: 'unprocessable'),
          banner: l10n.genericError,
        ),
        '400 validation_failed': (
          error: const ValidationException(
            errors: {
              'governorateId': ['unknown governorate'],
            },
          ),
          banner: l10n.errorValidationFailed,
        ),
      };

      for (final MapEntry(key: label, value: failure) in staying.entries) {
        testWidgets('$label stays on the detail screen with its banner', (
          tester,
        ) async {
          when(() => repo.register(any())).thenThrow(failure.error);
          final container = await pumpApp(tester, language: 'en');
          await reachDetail(tester, container, track, l10n);

          await tapButton(tester, l10n.startLearning);

          expect(location(container), track.path);
          expect(find.byType(track.screen), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(SubmitFailureBanner),
              matching: find.text(failure.banner),
            ),
            findsOneWidget,
          );
          // Sign Up_1, still underneath, marks nothing.
          expect(
            tester
                .widget<PlainTextField>(nameField(l10n, skipOffstage: false))
                .hasError,
            isFalse,
          );
          verify(() => repo.register(any())).called(1);
        });
      }

      testWidgets('401 registration_token_invalid still restarts at /login', (
        tester,
      ) async {
        when(() => repo.register(any())).thenThrow(
          const UnauthorizedException(code: 'registration_token_invalid'),
        );
        final container = await pumpApp(tester, language: 'en');
        await reachDetail(tester, container, track, l10n);

        await tapButton(tester, l10n.startLearning);

        expect(location(container), '/login');
        expect(find.text(l10n.registrationTokenInvalid), findsOneWidget);
        expect(container.read(registrationControllerProvider), isNull);
        // The dropped draft took the outcome back to idle with it.
        expect(container.read(registrationSubmitProvider).hasError, isFalse);
      });
    });
  }

  testWidgets('a fresh registration does not inherit the mark: a new token '
      'starts idle', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    when(() => repo.register(any())).thenThrow(_nameNotAllowed);
    final container = await pumpApp(tester, language: 'en');
    await reachDetail(tester, container, _tracks['School']!, l10n);
    await tapButton(tester, l10n.startLearning);
    expect(find.text(l10n.fieldRejected), findsOneWidget);

    // The student abandons the wizard from Sign Up_1's back chip…
    await tester.tap(find.byType(CircleBackButton));
    await frames(tester);
    expect(location(container), '/login');

    // …and a new OTP verify starts another registration (OTP seeds the draft
    // from its listener, then goes to /register).
    container
        .read(registrationControllerProvider.notifier)
        .start(
          RegistrationArgs(
            registrationToken: 'reg.token.next',
            expiresInSeconds: 600,
            phone: regArgs.phone,
          ),
        );
    container.read(routerProvider).go('/register');
    await frames(tester);

    expect(find.byType(SignupIdentityScreen), findsOneWidget);
    expect(find.text(l10n.fieldRejected), findsNothing);
    expect(tester.widget<PlainTextField>(nameField(l10n)).hasError, isFalse);
    expect(tester.widget<TextField>(nameInput(l10n)).controller!.text, isEmpty);
    expect(container.read(registrationSubmitProvider).hasError, isFalse);
  });

  group('the submit notifier', () {
    ProviderContainer seeded(_Track track) {
      final container = makeContainer();
      track.seed(container.read(registrationControllerProvider.notifier));
      return container;
    }

    for (final MapEntry(key: trackName, value: track) in _tracks.entries) {
      test('$trackName: the refusal is a typed error; one request; the draft '
          'and token survive; the retry carries the same token', () async {
        when(() => repo.register(any())).thenThrow(_nameNotAllowed);
        final container = seeded(track);
        final before = container.read(registrationControllerProvider);
        final notifier = container.read(registrationSubmitProvider.notifier);

        await notifier.submit();

        final state = container.read(registrationSubmitProvider);
        expect(isNameNotAllowed(state.error), isTrue);
        expect(
          container.read(registrationControllerProvider),
          before!.copyWith(refusedNames: {_name}),
        );
        verify(() => repo.register(any())).called(1);
        verifyNever(
          () => storage.writeTokens(
            access: any(named: 'access'),
            refresh: any(named: 'refresh'),
          ),
        );

        // The same name again: no request, and the refusal is stated afresh,
        // so whichever detail screen is showing hears it and goes back.
        await notifier.submit();
        verifyNever(() => repo.register(any()));
        final again = container.read(registrationSubmitProvider);
        expect(isNameNotAllowed(again.error), isTrue);
        expect(again, isNot(same(state)));

        container
            .read(registrationControllerProvider.notifier)
            .setIdentity(name: _correctedName, parentPhone: _parentPhone);
        // Editing the draft is not a new registration: the outcome stays.
        expect(container.read(registrationSubmitProvider).hasError, isTrue);
        await notifier.submit();

        final retry = verify(() => repo.register(captureAny())).captured;
        expect(_wire(retry.single), (
          token: regArgs.registrationToken,
          name: _correctedName,
        ));
      });
    }

    test(
      'a new token or a dropped draft puts an idle outcome back to idle',
      () async {
        when(() => repo.register(any())).thenThrow(_nameNotAllowed);
        final container = seeded(_tracks['School']!);
        await container.read(registrationSubmitProvider.notifier).submit();
        expect(container.read(registrationSubmitProvider).hasError, isTrue);

        container.read(registrationControllerProvider.notifier).reset();

        expect(container.read(registrationSubmitProvider).hasError, isFalse);
        expect(container.read(registrationSubmitProvider).value, isNull);
      },
    );

    test('a refused name whose outcome was cleared is still not sent: the '
        'refusal comes back without a request', () async {
      when(() => repo.register(any())).thenThrow(_nameNotAllowed);
      final container = seeded(_tracks['School']!);
      final notifier = container.read(registrationSubmitProvider.notifier);
      await notifier.submit();
      verify(() => repo.register(any())).called(1);

      // An edit on the detail form clears a shown failure.
      notifier.clearError();
      expect(container.read(registrationSubmitProvider).hasError, isFalse);

      await notifier.submit();
      verifyNever(() => repo.register(any()));
      expect(
        isNameNotAllowed(container.read(registrationSubmitProvider).error),
        isTrue,
      );
    });

    test('a refusal that lands after its draft was replaced is recorded on '
        'no one', () async {
      final response = Completer<Never>();
      when(() => repo.register(any())).thenAnswer((_) => response.future);
      final container = seeded(_tracks['School']!);
      final pending = container
          .read(registrationSubmitProvider.notifier)
          .submit();
      await Future<void>.delayed(Duration.zero);

      container.read(registrationControllerProvider.notifier)
        ..reset()
        ..start(
          RegistrationArgs(
            registrationToken: 'reg.token.next',
            expiresInSeconds: 600,
            phone: regArgs.phone,
          ),
        )
        ..setIdentity(name: _name, parentPhone: _parentPhone);
      response.completeError(_nameNotAllowed);
      await pending;

      expect(
        container.read(registrationControllerProvider)!.refusedNames,
        isEmpty,
      );
    });

    test('the record keeps each refused name once, on its own token', () {
      final container = seeded(_tracks['School']!);
      final controller = container.read(registrationControllerProvider.notifier)
        ..refuseName(registrationToken: regArgs.registrationToken, name: _name)
        ..refuseName(registrationToken: regArgs.registrationToken, name: _name)
        ..refuseName(registrationToken: 'another.token', name: 'Other Name');
      expect(container.read(registrationControllerProvider)!.refusedNames, {
        _name,
      });

      controller.reset();
      controller.refuseName(
        registrationToken: regArgs.registrationToken,
        name: _name,
      );
      expect(container.read(registrationControllerProvider), isNull);
    });

    test('an in-flight submit is left to land its own outcome', () async {
      final response = Completer<Never>();
      when(() => repo.register(any())).thenAnswer((_) => response.future);
      final container = seeded(_tracks['School']!);

      final pending = container
          .read(registrationSubmitProvider.notifier)
          .submit();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(registrationSubmitProvider).isLoading, isTrue);

      // The expiry view's "start again" drops the draft mid-request.
      container.read(registrationControllerProvider.notifier).reset();
      expect(container.read(registrationSubmitProvider).isLoading, isTrue);

      response.completeError(_nameNotAllowed);
      await pending;
      expect(
        isNameNotAllowed(container.read(registrationSubmitProvider).error),
        isTrue,
      );
    });
  });

  group('the copy mapping', () {
    for (final language in ['en', 'ar']) {
      test('$language: the banner line is the approved validation line, and '
          'the field issue lands on `name` only', () {
        final l10n = lookupAppLocalizations(Locale(language));
        expect(
          registrationErrorMessage(l10n, _nameNotAllowed),
          l10n.errorValidationFailed,
        );
        expect(fieldIssuesFrom(_nameNotAllowed), {
          RegFields.name: RegFieldIssue.rejected,
        });
        expect(
          fieldIssueMessage(l10n, RegFieldIssue.rejected),
          l10n.fieldRejected,
        );
      });
    }

    test('it matches the code, not the status, and it is not a restart', () {
      expect(isNameNotAllowed(_nameNotAllowed), isTrue);
      expect(
        isNameNotAllowed(const ApiException(status: 422, code: 'other')),
        isFalse,
      );
      expect(
        isNameNotAllowed(const ValidationException(errors: {'name': []})),
        isFalse,
      );
      expect(isNameNotAllowed(null), isFalse);
      expect(restartsRegistration(_nameNotAllowed), isFalse);
      expect(
        fieldIssuesFrom(const ApiException(status: 422, code: 'other')),
        isEmpty,
      );
    });
  });
}
