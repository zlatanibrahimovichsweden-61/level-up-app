import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/models/registration_validation.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/notifier/registration_submit_notifier.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements RegistrationRepository {}

class _MockStorage extends Mock implements SecureStorage {}

class _FakeBody extends Fake implements RegistrationBody {}

const _args = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600,
  phone: '+201555000111',
);

final _authenticated = AuthResult.authenticated(
  tokens: const TokenPair(
    accessToken: 'access.jwt',
    accessExpiresInSeconds: 900,
    refreshToken: 'refresh.jwt',
    refreshExpiresInSeconds: 5184000,
  ),
  profile: const {'id': 'student-1'},
) as AuthenticatedResult;

void main() {
  setUpAll(() => registerFallbackValue(_FakeBody()));

  late _MockRepo repo;
  late _MockStorage storage;

  setUp(() {
    repo = _MockRepo();
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
  });

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        registrationRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  /// Seeds a complete, valid Egyptian school draft.
  ProviderContainer seededSchool({
    bool requiresGovernorate = true,
    bool expired = false,
  }) {
    final c = container();
    final controller = c.read(registrationControllerProvider.notifier)
      ..start(
        expired
            ? const RegistrationArgs(
                registrationToken: 'reg.token',
                expiresInSeconds: -1,
                phone: '+201555000111',
              )
            : _args,
      )
      ..setIdentity(
        name: 'Nour Hassan',
        parentPhone: '+201021871999',
        referralCode: 'FRIEND50',
      )
      ..setTrack(RegTrack.school)
      ..setDateOfBirth(DateTime(2009, 5, 1))
      ..setCountry(
        countryCode: requiresGovernorate ? 'EG' : 'AE',
        requiresGovernorate: requiresGovernorate,
      )
      ..setCity('city-nasr')
      ..setStage('secondary1')
      ..setEducationSystem('ig');

    if (requiresGovernorate) {
      controller
        ..setGovernorate('gov-cairo')
        ..setCity('city-nasr')
        ..setSchool('school-42');
    }
    return c;
  }

  ProviderContainer seededUniversity() {
    final c = container();
    c.read(registrationControllerProvider.notifier)
      ..start(_args)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+201021871999')
      ..setTrack(RegTrack.university)
      ..setDateOfBirth(DateTime(2004, 3, 7))
      ..setUniversity('uni-cairo')
      ..setFaculty('fac-medicine')
      ..setStudyYear('year-2')
      ..setGovernorate('gov-giza')
      ..setCity('city-dokki');
    return c;
  }

  group('201 → session established', () {
    test('writes tokens, flips AuthController, emits RegistrationSubmitted',
        () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      verify(
        () => storage.writeTokens(
          access: 'access.jwt',
          refresh: 'refresh.jwt',
        ),
      ).called(1);
      expect(c.read(authControllerProvider), isA<AuthAuthenticated>());
      expect(
        c.read(registrationSubmitProvider).value,
        isA<RegistrationSubmitted>(),
      );
    });

    test('builds the SCHOOL body from the draft', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      final body = verify(() => repo.register(captureAny())).captured.single;
      expect(body, isA<SchoolRegistration>());
      final json = (body as SchoolRegistration).toJson();
      expect(json['track'], 'school');
      expect(json['governorateId'], 'gov-cairo');
      expect(json['schoolId'], 'school-42');
      expect(json['cityId'], isNotNull);
      // adr-028 §2 — the field no longer exists on the contract at all.
      expect(json.containsKey('schoolName'), isFalse);
    });

    test('builds the UNIVERSITY body from the draft', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededUniversity();

      await c.read(registrationSubmitProvider.notifier).submit();

      final body = verify(() => repo.register(captureAny())).captured.single;
      expect(body, isA<UniversityRegistration>());
      expect((body as UniversityRegistration).toJson()['track'], 'university');
    });

    test('name + parentPhone come from the draft; referral never submitted',
        () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      final json = (verify(() => repo.register(captureAny())).captured.single
              as SchoolRegistration)
          .toJson();
      expect(json['name'], 'Nour Hassan');
      expect(json['parentPhone'], '+201021871999');
      expect(json.containsKey('referralCode'), isFalse);
      expect(json.values, isNot(contains('FRIEND50')));
    });

    test('non-Egypt draft omits the coded ids and every school key', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool(requiresGovernorate: false);

      await c.read(registrationSubmitProvider.notifier).submit();

      final json = (verify(() => repo.register(captureAny())).captured.single
              as SchoolRegistration)
          .toJson();
      expect(json.containsKey('governorateId'), isFalse);
      expect(json.containsKey('schoolId'), isFalse);
      expect(json.containsKey('schoolName'), isFalse);
    });

    test('a free-text city passes the pre-flight and reaches the wire',
        () async {
      // End to end for adr-028 §1: the escape's controller state clears the
      // coded id, the validator accepts the free text in its place, and the
      // body carries cityName with no cityId key at all.
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool(requiresGovernorate: false);
      c.read(registrationControllerProvider.notifier).setCityName('Al Ain');

      await c.read(registrationSubmitProvider.notifier).submit();

      final json = (verify(() => repo.register(captureAny())).captured.single
              as SchoolRegistration)
          .toJson();
      expect(json['cityName'], 'Al Ain');
      expect(json.containsKey('cityId'), isFalse);
    });

    test('an Egyptian student can submit with no school at all', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool();
      // Changing governorate clears the previously-picked school; under v1.0
      // that alone made the draft unsubmittable.
      c.read(registrationControllerProvider.notifier)
        ..setGovernorate('gov-giza')
        ..setCity('city-dokki');

      await c.read(registrationSubmitProvider.notifier).submit();

      final json = (verify(() => repo.register(captureAny())).captured.single
              as SchoolRegistration)
          .toJson();
      expect(json.containsKey('schoolId'), isFalse);
      expect(json['cityId'], 'city-dokki');
    });
  });

  group('failures surface as typed errors the screen branches on', () {
    test('400 validation_failed keeps the ValidationException field map',
        () async {
      when(() => repo.register(any())).thenThrow(
        const ValidationException(
          errors: {
            'schoolName': ['not allowed'],
          },
        ),
      );
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      final error = c.read(registrationSubmitProvider).error;
      expect(error, isA<ValidationException>());
      expect((error! as ValidationException).fields, contains('schoolName'));
    });

    test('401 registration_token_invalid surfaces for the /login restart',
        () async {
      when(() => repo.register(any())).thenThrow(
        const UnauthorizedException(code: 'registration_token_invalid'),
      );
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      expect(
        c.read(registrationSubmitProvider).error,
        isA<UnauthorizedException>()
            .having((e) => e.code, 'code', 'registration_token_invalid'),
      );
    });

    test('409 phone_already_registered surfaces for the /login restart',
        () async {
      when(() => repo.register(any())).thenThrow(
        const ApiException(status: 409, code: 'phone_already_registered'),
      );
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      expect(
        c.read(registrationSubmitProvider).error,
        isA<ApiException>()
            .having((e) => e.code, 'code', 'phone_already_registered'),
      );
    });

    test('offline surfaces as NetworkException and stores NO tokens', () async {
      when(() => repo.register(any()))
          .thenThrow(const NetworkException(detail: 'timeout'));
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      expect(c.read(registrationSubmitProvider).error, isA<NetworkException>());
      verifyNever(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
      expect(c.read(authControllerProvider), isNot(isA<AuthAuthenticated>()));
    });

    test('the draft survives a failure so the form can be retried', () async {
      when(() => repo.register(any()))
          .thenThrow(const NetworkException(detail: 'timeout'));
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      expect(c.read(registrationControllerProvider)?.schoolId, 'school-42');
    });
  });

  group('pre-flight — the request is never sent when it cannot succeed', () {
    test('an expired token short-circuits to registration_token_invalid',
        () async {
      final c = seededSchool(expired: true);

      await c.read(registrationSubmitProvider.notifier).submit();

      verifyNever(() => repo.register(any()));
      expect(
        c.read(registrationSubmitProvider).error,
        isA<UnauthorizedException>()
            .having((e) => e.code, 'code', 'registration_token_invalid'),
      );
    });

    test('no draft at all short-circuits the same way', () async {
      final c = container();

      await c.read(registrationSubmitProvider.notifier).submit();

      verifyNever(() => repo.register(any()));
      expect(c.read(registrationSubmitProvider).error, isA<UnauthorizedException>());
    });

    test('an incomplete draft fails client-side with the per-field issues',
        () async {
      final c = seededSchool();
      // Clear a contract-required field the way the UI would on a cascade reset.
      c.read(registrationControllerProvider.notifier).setGovernorate('gov-giza');

      await c.read(registrationSubmitProvider.notifier).submit();

      verifyNever(() => repo.register(any()));
      final error = c.read(registrationSubmitProvider).error;
      expect(error, isA<DraftValidationFailure>());
      final issues = (error! as DraftValidationFailure).issues;
      // Changing governorate cleared city + school. Only the city blocks now:
      // adr-028 §2 made schoolId optional, so its absence is not an issue.
      expect(issues[RegFields.cityId], RegFieldIssue.missing);
      expect(issues.containsKey(RegFields.schoolId), isFalse);
    });

    test('a forbidden field is caught client-side too (adr-010)', () async {
      final c = seededSchool(requiresGovernorate: false);
      // Force the combination the UI prevents: a non-Egypt draft still holding
      // a coded schoolId from before the country was switched.
      c.read(registrationControllerProvider.notifier).setSchool('school-42');

      await c.read(registrationSubmitProvider.notifier).submit();

      verifyNever(() => repo.register(any()));
      expect(
        (c.read(registrationSubmitProvider).error! as DraftValidationFailure)
            .issues[RegFields.schoolId],
        RegFieldIssue.forbidden,
      );
    });
  });

  group('notifier housekeeping', () {
    test('starts idle', () {
      expect(container().read(registrationSubmitProvider).value, isNull);
    });

    test('clearError returns to idle so stale errors stop rendering', () async {
      when(() => repo.register(any()))
          .thenThrow(const NetworkException(detail: 'timeout'));
      final c = seededSchool();
      await c.read(registrationSubmitProvider.notifier).submit();
      expect(c.read(registrationSubmitProvider).hasError, isTrue);

      c.read(registrationSubmitProvider.notifier).clearError();

      expect(c.read(registrationSubmitProvider).hasError, isFalse);
      expect(c.read(registrationSubmitProvider).value, isNull);
    });
  });

  group('serverFieldIssues', () {
    test('maps server field NAMES onto the shared per-field channel', () {
      final issues = serverFieldIssues(['cityId', 'schoolId']);
      expect(issues[RegFields.cityId], RegFieldIssue.rejected);
      expect(issues[RegFields.schoolId], RegFieldIssue.rejected);
    });
  });
}
