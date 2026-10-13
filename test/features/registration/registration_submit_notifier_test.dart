import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
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
  phone: '+201500000001',
);

/// The same fixture the OTP tests use. `deviceInfoProvider` itself is
/// overridden below rather than its SecureStorage half: the real provider
/// would otherwise fall through to DeviceInfoPlugin and throw
/// MissingPluginException under `flutter test`.
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');

final _authenticated =
    AuthResult.authenticated(
          tokens: const TokenPair(
            accessToken: 'access.jwt',
            accessExpiresInSeconds: 900,
            refreshToken: 'refresh.jwt',
            refreshExpiresInSeconds: 5184000,
          ),
          profile: const {'id': 'student-1'},
        )
        as AuthenticatedResult;

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
        deviceInfoProvider.overrideWith((ref) async => _device),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  /// Seeds a complete, valid Egyptian school draft.
  ProviderContainer seededSchool({
    bool requiresGovernorate = true,
    bool expired = false,
    String? referralCode = 'FRIEND50',
  }) {
    final c = container();
    final controller = c.read(registrationControllerProvider.notifier)
      ..start(
        expired
            ? const RegistrationArgs(
                registrationToken: 'reg.token',
                expiresInSeconds: -1,
                phone: '+201500000001',
              )
            : _args,
      )
      ..setIdentity(
        name: 'Nour Hassan',
        parentPhone: '+2010000000001',
        referralCode: referralCode,
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

  ProviderContainer seededUniversity({String? referralCode}) {
    final c = container();
    c.read(registrationControllerProvider.notifier)
      ..start(_args)
      ..setIdentity(
        name: 'Nour Hassan',
        parentPhone: '+2010000000001',
        referralCode: referralCode,
      )
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
    test(
      'writes tokens, flips AuthController, emits RegistrationSubmitted',
      () async {
        when(
          () => repo.register(any()),
        ).thenAnswer((_) async => _authenticated);
        final c = seededSchool();

        await c.read(registrationSubmitProvider.notifier).submit();

        verify(
          () =>
              storage.writeTokens(access: 'access.jwt', refresh: 'refresh.jwt'),
        ).called(1);
        expect(c.read(authControllerProvider), isA<AuthAuthenticated>());
        expect(
          c.read(registrationSubmitProvider).value,
          isA<RegistrationSubmitted>(),
        );
      },
    );

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

    test('name + parentPhone come from the draft; the referral is sent as '
        'inviteCode, never as referralCode', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      final json =
          (verify(() => repo.register(captureAny())).captured.single
                  as SchoolRegistration)
              .toJson();
      expect(json['name'], 'Nour Hassan');
      expect(json['parentPhone'], '+2010000000001');
      expect(json.containsKey('referralCode'), isFalse);
      expect(json['inviteCode'], 'FRIEND50');
    });

    test('non-Egypt draft omits the coded ids and every school key', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool(requiresGovernorate: false);

      await c.read(registrationSubmitProvider.notifier).submit();

      final json =
          (verify(() => repo.register(captureAny())).captured.single
                  as SchoolRegistration)
              .toJson();
      expect(json.containsKey('governorateId'), isFalse);
      expect(json.containsKey('schoolId'), isFalse);
      expect(json.containsKey('schoolName'), isFalse);
    });

    test(
      'a free-text city passes the pre-flight and reaches the wire',
      () async {
        // End to end for adr-028 §1: the escape's controller state clears the
        // coded id, the validator accepts the free text in its place, and the
        // body carries cityName with no cityId key at all.
        when(
          () => repo.register(any()),
        ).thenAnswer((_) async => _authenticated);
        final c = seededSchool(requiresGovernorate: false);
        c.read(registrationControllerProvider.notifier).setCityName('Al Ain');

        await c.read(registrationSubmitProvider.notifier).submit();

        final json =
            (verify(() => repo.register(captureAny())).captured.single
                    as SchoolRegistration)
                .toJson();
        expect(json['cityName'], 'Al Ain');
        expect(json.containsKey('cityId'), isFalse);
      },
    );

    test('an Egyptian student can submit with no school at all', () async {
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);
      final c = seededSchool();
      // Changing governorate clears the previously-picked school; under v1.0
      // that alone made the draft unsubmittable.
      c.read(registrationControllerProvider.notifier)
        ..setGovernorate('gov-giza')
        ..setCity('city-dokki');

      await c.read(registrationSubmitProvider.notifier).submit();

      final json =
          (verify(() => repo.register(captureAny())).captured.single
                  as SchoolRegistration)
              .toJson();
      expect(json.containsKey('schoolId'), isFalse);
      expect(json['cityId'], 'city-dokki');
    });
  });

  group('invite code (spec-047) — School sends it, nothing is shown', () {
    Map<String, dynamic> sentSchoolBody() =>
        (verify(() => repo.register(captureAny())).captured.single
                as SchoolRegistration)
            .toJson();

    test(
      'the School body carries the trimmed code the student typed',
      () async {
        when(
          () => repo.register(any()),
        ).thenAnswer((_) async => _authenticated);
        final c = seededSchool(referralCode: '  FRIEND50  ');

        await c.read(registrationSubmitProvider.notifier).submit();

        expect(sentSchoolBody()['inviteCode'], 'FRIEND50');
      },
    );

    test('no code, or a blank one, leaves the key OUT — never null, never '
        'empty', () async {
      for (final referral in <String?>[null, '', '   ']) {
        when(
          () => repo.register(any()),
        ).thenAnswer((_) async => _authenticated);
        final c = seededSchool(referralCode: referral);

        await c.read(registrationSubmitProvider.notifier).submit();

        final json = sentSchoolBody();
        expect(
          json.containsKey('inviteCode'),
          isFalse,
          reason: 'referral [$referral]',
        );
        expect(json.values, isNot(contains(null)));
        expect(json.values, isNot(contains('')));
        clearInteractions(repo);
      }
    });

    test(
      'the University body never sends it, whatever the draft holds',
      () async {
        when(
          () => repo.register(any()),
        ).thenAnswer((_) async => _authenticated);
        final c = seededUniversity(referralCode: 'FRIEND50');

        await c.read(registrationSubmitProvider.notifier).submit();

        final json =
            (verify(() => repo.register(captureAny())).captured.single
                    as UniversityRegistration)
                .toJson();
        expect(json.containsKey('inviteCode'), isFalse);
        expect(json.containsKey('referralCode'), isFalse);
        expect(json.values, isNot(contains('FRIEND50')));
      },
    );

    for (final applied in <bool?>[true, false, null]) {
      test('inviteCodeApplied $applied is carried; the session is live '
          'either way', () async {
        when(() => repo.register(any())).thenAnswer(
          (_) async =>
              AuthResult.authenticated(
                    tokens: const TokenPair(
                      accessToken: 'access.jwt',
                      accessExpiresInSeconds: 900,
                      refreshToken: 'refresh.jwt',
                      refreshExpiresInSeconds: 5184000,
                    ),
                    profile: const {'id': 'student-1'},
                    inviteCodeApplied: applied,
                  )
                  as AuthenticatedResult,
        );
        final c = seededSchool();

        await c.read(registrationSubmitProvider.notifier).submit();

        final state = c.read(registrationSubmitProvider);
        expect(state.hasError, isFalse, reason: 'a code never blocks');
        expect(state.value?.inviteCodeApplied, applied);
        expect(c.read(authControllerProvider), isA<AuthAuthenticated>());
      });
    }

    test('name_not_allowed keeps the code on the draft, and a different name '
        'goes out with it on the same token', () async {
      when(
        () => repo.register(any()),
      ).thenThrow(const ApiException(status: 422, code: 'name_not_allowed'));
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      expect(
        c.read(registrationSubmitProvider).error,
        isA<ApiException>().having((e) => e.code, 'code', 'name_not_allowed'),
      );
      final draft = c.read(registrationControllerProvider)!;
      expect(draft.referralCode, 'FRIEND50');
      expect(draft.registrationToken, 'reg.token');
      expect(draft.refusedNames, {'Nour Hassan'});

      // The same name is not sent again: the answer would be the same.
      await c.read(registrationSubmitProvider.notifier).submit();
      verify(() => repo.register(any())).called(1);

      // Sign Up_1 sends the student on with a different name and the same code.
      c
          .read(registrationControllerProvider.notifier)
          .setIdentity(
            name: 'Nour Hassan Ali',
            parentPhone: '+2010000000001',
            referralCode: draft.referralCode,
          );
      reset(repo);
      when(() => repo.register(any())).thenAnswer((_) async => _authenticated);

      await c.read(registrationSubmitProvider.notifier).submit();

      final json = sentSchoolBody();
      expect(json['name'], 'Nour Hassan Ali');
      expect(json['registrationToken'], 'reg.token');
      expect(json['inviteCode'], 'FRIEND50');
    });
  });

  group('failures surface as typed errors the screen branches on', () {
    test(
      '400 validation_failed keeps the ValidationException field map',
      () async {
        when(() => repo.register(any())).thenThrow(
          // adr-028 §1's own violation. `schoolName` used to be the sample here;
          // the server can never name that field again.
          const ValidationException(
            errors: {
              'cityName': ['not allowed together with cityId'],
            },
          ),
        );
        final c = seededSchool();

        await c.read(registrationSubmitProvider.notifier).submit();

        final error = c.read(registrationSubmitProvider).error;
        expect(error, isA<ValidationException>());
        expect((error! as ValidationException).fields, contains('cityName'));
      },
    );

    test(
      '401 registration_token_invalid surfaces for the /login restart',
      () async {
        when(() => repo.register(any())).thenThrow(
          const UnauthorizedException(code: 'registration_token_invalid'),
        );
        final c = seededSchool();

        await c.read(registrationSubmitProvider.notifier).submit();

        expect(
          c.read(registrationSubmitProvider).error,
          isA<UnauthorizedException>().having(
            (e) => e.code,
            'code',
            'registration_token_invalid',
          ),
        );
      },
    );

    test(
      '409 phone_already_registered surfaces for the /login restart',
      () async {
        when(() => repo.register(any())).thenThrow(
          const ApiException(status: 409, code: 'phone_already_registered'),
        );
        final c = seededSchool();

        await c.read(registrationSubmitProvider.notifier).submit();

        expect(
          c.read(registrationSubmitProvider).error,
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'phone_already_registered',
          ),
        );
      },
    );

    test('offline surfaces as NetworkException and stores NO tokens', () async {
      when(
        () => repo.register(any()),
      ).thenThrow(const NetworkException(detail: 'timeout'));
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
      when(
        () => repo.register(any()),
      ).thenThrow(const NetworkException(detail: 'timeout'));
      final c = seededSchool();

      await c.read(registrationSubmitProvider.notifier).submit();

      expect(c.read(registrationControllerProvider)?.schoolId, 'school-42');
    });
  });

  group('pre-flight — the request is never sent when it cannot succeed', () {
    test(
      'an expired token short-circuits to registration_token_invalid',
      () async {
        final c = seededSchool(expired: true);

        await c.read(registrationSubmitProvider.notifier).submit();

        verifyNever(() => repo.register(any()));
        expect(
          c.read(registrationSubmitProvider).error,
          isA<UnauthorizedException>().having(
            (e) => e.code,
            'code',
            'registration_token_invalid',
          ),
        );
      },
    );

    test('no draft at all short-circuits the same way', () async {
      final c = container();

      await c.read(registrationSubmitProvider.notifier).submit();

      verifyNever(() => repo.register(any()));
      expect(
        c.read(registrationSubmitProvider).error,
        isA<UnauthorizedException>(),
      );
    });

    test(
      'an incomplete draft fails client-side with the per-field issues',
      () async {
        final c = seededSchool();
        // Clear a contract-required field the way the UI would on a cascade reset.
        c
            .read(registrationControllerProvider.notifier)
            .setGovernorate('gov-giza');

        await c.read(registrationSubmitProvider.notifier).submit();

        verifyNever(() => repo.register(any()));
        final error = c.read(registrationSubmitProvider).error;
        expect(error, isA<DraftValidationFailure>());
        final issues = (error! as DraftValidationFailure).issues;
        // Changing governorate cleared city + school. Only the city blocks now:
        // adr-028 §2 made schoolId optional, so its absence is not an issue.
        expect(issues[RegFields.cityId], RegFieldIssue.missing);
        expect(issues.containsKey(RegFields.schoolId), isFalse);
      },
    );

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
      when(
        () => repo.register(any()),
      ).thenThrow(const NetworkException(detail: 'timeout'));
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
