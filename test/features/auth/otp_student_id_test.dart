import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/auth_outcome.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/notifier/otp_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:mocktail/mocktail.dart';

/// O-10 plumbing: where the student id of an `authenticated` verify response
/// goes. `OtpNotifier.verify` reads `profile['id']` (the opaque profile's one
/// used field) and hands it to BOTH the outcome the sign-in landing compares
/// with the return target, and `AuthController.markAuthenticated`, which keeps
/// it for the session so a later forced sign-out can bind the target without
/// reading `/me`. The router-driven tests prove the end-to-end behaviour; this
/// file pins each hand-off on its own, so a dropped argument names itself.

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

const _args = OtpArgs(
  phone: '+2010000000001',
  resendAfterSeconds: 0,
  expiresInSeconds: 300,
);
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _tokens = TokenPair(
  accessToken: 'access.jwt',
  accessExpiresInSeconds: 900,
  refreshToken: 'refresh.jwt',
  refreshExpiresInSeconds: 5184000,
);

/// A server student id. Any string will do — only equality is ever checked.
const _studentId = 'x';

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late _MockAuthRepository repo;
  late _MockSecureStorage storage;

  setUp(() {
    repo = _MockAuthRepository();
    storage = _MockSecureStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(() => storage.clearTokens()).thenAnswer((_) async {});
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
  });

  /// The next correct code verifies into an `authenticated` result carrying
  /// [profile].
  void verifyAnswersWith(Map<String, dynamic> profile) {
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer(
      (_) async => AuthResult.authenticated(tokens: _tokens, profile: profile),
    );
  }

  Future<ProviderContainer> makeContainer() async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
      ],
    );
    addTearDown(container.dispose);
    // `otpProvider` is autoDispose.
    container.listen(otpProvider(_args), (_, _) {});
    // Let the controller's initial token read settle first (signed out):
    // otherwise it could land AFTER the verify's `markAuthenticated` and flip
    // the state back.
    container.read(authControllerProvider);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authControllerProvider), isA<AuthUnauthenticated>());
    return container;
  }

  Future<void> verify(ProviderContainer container) =>
      container.read(otpProvider(_args).notifier).verify('482913');

  group('the outcome carries the student id of the verify response', () {
    test('a string id is carried through', () async {
      verifyAnswersWith({'id': _studentId});
      final container = await makeContainer();

      await verify(container);

      final outcome = container.read(otpProvider(_args)).outcome;
      expect(outcome, isA<AuthenticatedOutcome>());
      expect((outcome! as AuthenticatedOutcome).studentId, _studentId);
    });

    for (final profile in <Map<String, dynamic>>[
      <String, dynamic>{},
      <String, dynamic>{'id': ''},
      <String, dynamic>{'id': 7},
    ]) {
      test('$profile → no id (null), still an authenticated outcome', () async {
        verifyAnswersWith(profile);
        final container = await makeContainer();

        await verify(container);

        final outcome = container.read(otpProvider(_args)).outcome;
        expect(outcome, isA<AuthenticatedOutcome>());
        expect((outcome! as AuthenticatedOutcome).studentId, isNull);
        expect(
          container.read(authControllerProvider),
          isA<AuthAuthenticated>(),
        );
      });
    }
  });

  group('the id reaches AuthController — a forced sign-out binds it with no '
      '`/me` involved', () {
    test('after verify with an id, the SAME student gets the location back '
        'and a different one does not', () async {
      for (final (signedInAs, expected) in [
        (_studentId, '/learn'),
        ('someone-else', 'none'),
      ]) {
        verifyAnswersWith({'id': _studentId});
        final container = await makeContainer();
        await verify(container);
        expect(
          container.read(authControllerProvider),
          isA<AuthAuthenticated>(),
        );

        // No `/me` exists in this container (and no profile repository is
        // wired), so the only possible source of the binding is the capture.
        await container
            .read(authControllerProvider.notifier)
            .forceLogout(LogoutReason.sessionExpired);
        final target = container.read(returnTargetProvider)
          ..remember('/learn'); // the router's bounce, after the flip

        expect(
          target.consume(studentId: signedInAs, fallback: 'none'),
          expected,
          reason: 'signed in as $signedInAs',
        );
      }
    });

    test('a response without an id captures nothing: nobody gets the '
        'location', () async {
      verifyAnswersWith(<String, dynamic>{});
      final container = await makeContainer();
      await verify(container);

      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      final target = container.read(returnTargetProvider)..remember('/learn');

      expect(target.consume(studentId: _studentId, fallback: 'none'), 'none');
    });
  });
}
