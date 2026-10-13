import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/recovery/models/recovery_models.dart';
import 'package:level_up_app/features/recovery/notifier/recovery_flow_notifier.dart';
import 'package:level_up_app/features/recovery/recovery_errors.dart';
import 'package:level_up_app/features/recovery/repository/recovery_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecoveryRepository extends Mock implements RecoveryRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

/// An [AuthController] that records the one call recovery must make, and does
/// not touch storage or the router.
class _SpyAuth extends AuthController {
  final studentIds = <String?>[];

  @override
  AuthStatus build() => const AuthUnauthenticated();

  @override
  void markAuthenticated({String? studentId}) {
    studentIds.add(studentId);
    state = const AuthAuthenticated();
  }
}

/// The lost-phone recovery flow (CW06): the four steps in the contract's
/// order, every documented failure, the secrets it must not expose, and the
/// `autoDispose` that keeps them off the device once the flow is left.
///
/// Every value below is fabricated.
void main() {
  const phone = '+2010000000001';
  const newPhone = '+2010000000002';
  const recoveryId = '7ec0e000-0000-4000-8000-000000000001';
  const secondRecoveryId = '7ec0e000-0000-4000-8000-000000000009';
  const masked = '•••• ••• 1234';
  const rebindToken = 'fabricated.rebind.token';
  const code = '482913';
  const device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
  const tokens = TokenPair(
    accessToken: 'access.jwt',
    accessExpiresInSeconds: 900,
    refreshToken: 'refresh.jwt',
    refreshExpiresInSeconds: 5184000,
  );
  const authenticated = AuthenticatedResult(
    tokens: tokens,
    profile: {'id': 'student-1'},
  );
  const started = RecoveryStartResult(
    recoveryId: recoveryId,
    parentPhoneMasked: masked,
    resendAfterSeconds: 60,
    expiresInSeconds: 300,
  );
  const verified = ParentVerifiedResult(
    rebindToken: rebindToken,
    expiresInSeconds: 600,
  );
  const codeSent = OtpRequestResult(
    resendAfterSeconds: 45,
    expiresInSeconds: 240,
  );

  const throttled = ApiException(status: 429, code: 'otp_throttled');
  const invalid = ApiException(status: 400, code: 'otp_invalid');
  const expired = ApiException(status: 400, code: 'otp_expired');
  const tokenDead = UnauthorizedException(code: 'registration_token_invalid');
  const banned = ApiException(status: 403, code: 'account_banned');
  const taken = ApiException(status: 409, code: 'phone_already_registered');
  const unavailable = ApiException(status: 404, code: 'recovery_unavailable');

  setUpAll(() => registerFallbackValue(device));

  late _MockRecoveryRepository repo;
  late _MockSecureStorage storage;
  late _SpyAuth auth;
  late ProviderContainer container;
  late ProviderSubscription<RecoveryFlowState> listener;

  RecoveryFlowNotifier notifier() =>
      container.read(recoveryFlowProvider.notifier);
  RecoveryFlowState state() => container.read(recoveryFlowProvider);

  void stubStart([Object answer = started]) {
    final call = when(() => repo.startRecovery(any()));
    answer is RecoveryStartResult
        ? call.thenAnswer((_) async => answer)
        : call.thenThrow(answer);
  }

  void stubVerify([Object answer = verified]) {
    final call = when(
      () => repo.verifyParentOtp(
        recoveryId: any(named: 'recoveryId'),
        code: any(named: 'code'),
      ),
    );
    answer is ParentVerifiedResult
        ? call.thenAnswer((_) async => answer)
        : call.thenThrow(answer);
  }

  void stubNewPhone([Object answer = codeSent]) {
    final call = when(
      () => repo.submitNewPhone(
        rebindToken: any(named: 'rebindToken'),
        newPhone: any(named: 'newPhone'),
      ),
    );
    answer is OtpRequestResult
        ? call.thenAnswer((_) async => answer)
        : call.thenThrow(answer);
  }

  void stubConfirm([Object answer = authenticated]) {
    final call = when(
      () => repo.confirmRecovery(
        rebindToken: any(named: 'rebindToken'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    );
    answer is AuthenticatedResult
        ? call.thenAnswer((_) async => answer)
        : call.thenThrow(answer);
  }

  void verifyNoRepositoryCall() => verifyNoMoreInteractions(repo);

  /// A container over the mocks. The provider is autoDispose, so the listener
  /// holds it the way the recovery screens would.
  var hasContainer = false;

  void useContainer({Future<DeviceInfo> Function(Ref)? deviceRead}) {
    if (hasContainer) container.dispose();
    hasContainer = true;
    auth = _SpyAuth();
    container = ProviderContainer(
      overrides: [
        recoveryRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith(deviceRead ?? (ref) async => device),
        authControllerProvider.overrideWith(() => auth),
      ],
    );
    listener = container.listen(recoveryFlowProvider, (_, _) {});
  }

  setUp(() {
    repo = _MockRecoveryRepository();
    storage = _MockSecureStorage();
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(() => storage.clearTokens()).thenAnswer((_) async {});
    useContainer();
  });

  tearDown(() => container.dispose());

  /// Drives the flow to [stage] with the happy-path stubs.
  Future<void> advanceTo(RecoveryStage stage) async {
    stubStart();
    stubVerify();
    stubNewPhone();
    stubConfirm();
    await notifier().start(phone);
    if (stage == RecoveryStage.parentCode) return;
    await notifier().verifyParent(code);
    if (stage == RecoveryStage.newPhone) return;
    await notifier().submitNewPhone(newPhone);
    expect(state().stage, RecoveryStage.newPhoneCode);
  }

  test('starts waiting for the old phone, with nothing held', () {
    expect(state().stage, RecoveryStage.phone);
    expect(state().isBusy, isFalse);
    expect(state().error, isNull);
    expect(state().failure, isNull);
    expect(state().parentPhoneMasked, isNull);
    expect(state().codeResendAfterSeconds, isNull);
    expect(state().codeExpiresInSeconds, isNull);
  });

  group('the happy path, in the contract\'s order', () {
    test('start: the masked parent phone and the code timing are held; the '
        'old phone is what was sent', () async {
      stubStart();
      await notifier().start(phone);

      verify(() => repo.startRecovery(phone)).called(1);
      expect(state().stage, RecoveryStage.parentCode);
      expect(state().parentPhoneMasked, masked);
      expect(state().codeResendAfterSeconds, 60);
      expect(state().codeExpiresInSeconds, 300);
      expect(state().isBusy, isFalse);
      expect(state().error, isNull);
    });

    test('verifyParent: sends the recovery id step 1 issued, then asks for '
        'the new phone and lets go of the masked number', () async {
      await advanceTo(RecoveryStage.parentCode);
      await notifier().verifyParent(code);

      verify(
        () => repo.verifyParentOtp(recoveryId: recoveryId, code: code),
      ).called(1);
      expect(state().stage, RecoveryStage.newPhone);
      expect(state().parentPhoneMasked, isNull);
      expect(state().codeResendAfterSeconds, isNull);
      expect(state().codeExpiresInSeconds, isNull);
    });

    test('submitNewPhone: sends the rebind token step 2 issued; the code '
        'timing is the new phone\'s', () async {
      await advanceTo(RecoveryStage.newPhone);
      await notifier().submitNewPhone(newPhone);

      verify(
        () => repo.submitNewPhone(rebindToken: rebindToken, newPhone: newPhone),
      ).called(1);
      expect(state().stage, RecoveryStage.newPhoneCode);
      expect(state().codeResendAfterSeconds, 45);
      expect(state().codeExpiresInSeconds, 240);
    });

    test('confirm: sends token, code and this device; stores the session; '
        'signs in with the student id; completes', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      await notifier().confirm(code);

      verify(
        () => repo.confirmRecovery(
          rebindToken: rebindToken,
          code: code,
          device: device,
        ),
      ).called(1);
      verify(
        () => storage.writeTokens(access: 'access.jwt', refresh: 'refresh.jwt'),
      ).called(1);
      expect(auth.studentIds, ['student-1']);
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
      expect(state().stage, RecoveryStage.completed);
      expect(state().isBusy, isFalse);
      expect(state().error, isNull);
      expect(state().parentPhoneMasked, isNull);
    });

    test('confirm stores the tokens BEFORE it flips the router: the sign-in '
        'must not fire GET /me with no access token to send', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      // Held open: the write has begun but not finished. The router flips to
      // authenticated and calls GET /me the moment `markAuthenticated` runs, so
      // it must not run until the tokens are in secure storage.
      final written = Completer<void>();
      when(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      ).thenAnswer((_) => written.future);

      final call = notifier().confirm(code);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => storage.writeTokens(access: 'access.jwt', refresh: 'refresh.jwt'),
      ).called(1);
      expect(
        auth.studentIds,
        isEmpty,
        reason: 'flipped before the write ended',
      );
      expect(
        container.read(authControllerProvider),
        isA<AuthUnauthenticated>(),
      );
      expect(state().isBusy, isTrue);

      written.complete();
      await call;

      expect(auth.studentIds, ['student-1']);
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
      expect(state().stage, RecoveryStage.completed);
    });

    test('a profile with no usable id still signs in, with no id (the return '
        'target then fails closed)', () async {
      for (final profile in <Map<String, dynamic>>[
        {},
        {'id': ''},
        {'id': 7},
      ]) {
        // A fresh flow each time: confirm completes the previous one.
        useContainer();
        stubStart();
        stubVerify();
        stubNewPhone();
        stubConfirm(AuthenticatedResult(tokens: tokens, profile: profile));
        await notifier().start(phone);
        await notifier().verifyParent(code);
        await notifier().submitNewPhone(newPhone);
        await notifier().confirm(code);

        expect(auth.studentIds, [null], reason: '$profile');
        expect(state().stage, RecoveryStage.completed);
      }
    });

    test('nothing the flow holds is printable: no id, token or number in '
        'toString at any stage', () async {
      final secrets = [
        recoveryId,
        rebindToken,
        masked,
        '1234',
        phone,
        newPhone,
      ];
      stubStart();
      stubVerify();
      stubNewPhone();
      stubConfirm();
      final seen = <String>['${state()}'];
      await notifier().start(phone);
      seen.add('${state()}');
      await notifier().verifyParent(code);
      seen.add('${state()}');
      await notifier().submitNewPhone(newPhone);
      seen.add('${state()}');
      await notifier().confirm(code);
      seen.add('${state()}');

      for (final text in seen) {
        for (final secret in secrets) {
          expect(text, isNot(contains(secret)), reason: text);
        }
      }
      expect(seen.last, 'RecoveryFlowState(stage: completed)');
    });
  });

  group('the ladder is strictly ordered', () {
    test('verifyParent, submitNewPhone and confirm do nothing before their '
        'stage', () async {
      await notifier().verifyParent(code);
      await notifier().submitNewPhone(newPhone);
      await notifier().confirm(code);

      verifyNoRepositoryCall();
      expect(state().stage, RecoveryStage.phone);
      expect(state().error, isNull);
    });

    test('start does nothing once the flow is past step 1', () async {
      await advanceTo(RecoveryStage.newPhone);
      clearInteractions(repo);

      await notifier().start(phone);

      verifyNoRepositoryCall();
      expect(state().stage, RecoveryStage.newPhone);
    });

    test('confirm does nothing at newPhone; verifyParent does nothing at '
        'newPhoneCode', () async {
      await advanceTo(RecoveryStage.newPhone);
      clearInteractions(repo);
      await notifier().confirm(code);
      await notifier().verifyParent(code);
      verifyNoRepositoryCall();

      await notifier().submitNewPhone(newPhone);
      clearInteractions(repo);
      await notifier().verifyParent(code);
      verifyNoRepositoryCall();
    });

    test('a second call while one is in flight is ignored', () async {
      final gate = Completer<RecoveryStartResult>();
      when(() => repo.startRecovery(any())).thenAnswer((_) => gate.future);

      final first = notifier().start(phone);
      expect(state().isBusy, isTrue);
      await notifier().start(phone);
      await notifier().verifyParent(code);
      gate.complete(started);
      await first;

      expect(state().isBusy, isFalse);
      expect(state().stage, RecoveryStage.parentCode);
      // Exactly one startRecovery ever went out.
      verify(() => repo.startRecovery(any())).called(1);
    });

    test('start from parentCode asks for a fresh code and replaces the '
        'recovery id', () async {
      await advanceTo(RecoveryStage.parentCode);
      stubStart(
        const RecoveryStartResult(
          recoveryId: secondRecoveryId,
          parentPhoneMasked: masked,
          resendAfterSeconds: 60,
          expiresInSeconds: 300,
        ),
      );

      await notifier().start(phone);
      await notifier().verifyParent(code);

      verify(
        () => repo.verifyParentOtp(recoveryId: secondRecoveryId, code: code),
      ).called(1);
      verifyNever(
        () => repo.verifyParentOtp(recoveryId: recoveryId, code: code),
      );
    });

    test('submitNewPhone from newPhoneCode corrects or resends, with the same '
        'rebind token', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      await notifier().submitNewPhone('+2010000000003');

      verify(
        () => repo.submitNewPhone(
          rebindToken: rebindToken,
          newPhone: '+2010000000003',
        ),
      ).called(1);
      expect(state().stage, RecoveryStage.newPhoneCode);
    });
  });

  group('a failure keeps the stage; the next try clears it', () {
    Future<void> expectStays(
      RecoveryStage stage,
      Object error,
      RecoveryFailure failure,
      Future<void> Function() act,
    ) async {
      await act();
      expect(state().stage, stage);
      expect(state().isBusy, isFalse);
      expect(state().error, same(error));
      expect(state().failure, failure);
    }

    test(
      'step 1: recovery_unavailable (support path), throttled, offline',
      () async {
        for (final (error, failure) in <(Object, RecoveryFailure)>[
          (unavailable, RecoveryFailure.unavailable),
          (throttled, RecoveryFailure.throttled),
          (const NetworkException(detail: 'timeout'), RecoveryFailure.offline),
        ]) {
          stubStart(error);
          await expectStays(
            RecoveryStage.phone,
            error,
            failure,
            () => notifier().start(phone),
          );
        }
        expect(state().parentPhoneMasked, isNull);

        stubStart();
        await notifier().start(phone);
        expect(state().stage, RecoveryStage.parentCode);
        expect(state().error, isNull);
      },
    );

    test(
      'step 2: otp_invalid, otp_expired, throttled keep parentCode',
      () async {
        await advanceTo(RecoveryStage.parentCode);
        for (final (error, failure) in <(Object, RecoveryFailure)>[
          (invalid, RecoveryFailure.otpInvalid),
          (expired, RecoveryFailure.otpExpired),
          (throttled, RecoveryFailure.throttled),
        ]) {
          stubVerify(error);
          await expectStays(
            RecoveryStage.parentCode,
            error,
            failure,
            () => notifier().verifyParent(code),
          );
          // The masked number is still there for the screen to show.
          expect(state().parentPhoneMasked, masked);
        }

        stubVerify();
        await notifier().verifyParent(code);
        expect(state().stage, RecoveryStage.newPhone);
        expect(state().error, isNull);
      },
    );

    test('step 3: phone_already_registered and validation keep newPhone; '
        'another number then goes through', () async {
      await advanceTo(RecoveryStage.newPhone);
      for (final (error, failure) in <(Object, RecoveryFailure)>[
        (taken, RecoveryFailure.phoneAlreadyRegistered),
        (
          const ValidationException(
            errors: {
              'newPhone': ['bad'],
            },
          ),
          RecoveryFailure.validation,
        ),
        (throttled, RecoveryFailure.throttled),
      ]) {
        stubNewPhone(error);
        await expectStays(
          RecoveryStage.newPhone,
          error,
          failure,
          () => notifier().submitNewPhone(newPhone),
        );
      }

      stubNewPhone();
      await notifier().submitNewPhone('+2010000000003');
      expect(state().stage, RecoveryStage.newPhoneCode);
      expect(state().error, isNull);
    });

    test('step 4: wrong code, expired, throttled, validation keep '
        'newPhoneCode - and nothing is stored or signed in', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      for (final (error, failure) in <(Object, RecoveryFailure)>[
        (invalid, RecoveryFailure.otpInvalid),
        (expired, RecoveryFailure.otpExpired),
        (throttled, RecoveryFailure.throttled),
        (
          const ValidationException(
            errors: {
              'device': ['bad'],
            },
          ),
          RecoveryFailure.validation,
        ),
      ]) {
        stubConfirm(error);
        await expectStays(
          RecoveryStage.newPhoneCode,
          error,
          failure,
          () => notifier().confirm(code),
        );
      }
      verifyNever(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
      expect(auth.studentIds, isEmpty);

      stubConfirm();
      await notifier().confirm(code);
      expect(state().stage, RecoveryStage.completed);
    });

    test(
      'a non-AppException from below is UnknownException, `other`',
      () async {
        when(() => repo.startRecovery(any())).thenThrow(StateError('boom'));
        await notifier().start(phone);

        expect(state().stage, RecoveryStage.phone);
        expect(state().error, isA<UnknownException>());
        expect(state().failure, RecoveryFailure.other);
        expect(state().isBusy, isFalse);
      },
    );

    test(
      'the device read failing is a failure of confirm, not a crash',
      () async {
        useContainer(deviceRead: (ref) async => throw StateError('x'));
        await advanceTo(RecoveryStage.newPhoneCode);

        await notifier().confirm(code);

        expect(state().stage, RecoveryStage.newPhoneCode);
        expect(state().failure, RecoveryFailure.other);
        verifyNever(
          () => repo.confirmRecovery(
            rebindToken: any(named: 'rebindToken'),
            code: any(named: 'code'),
            device: any(named: 'device'),
          ),
        );
        expect(auth.studentIds, isEmpty);
      },
    );
  });

  group('401 registration_token_invalid restarts from the top', () {
    Future<void> expectRestarted(Object error) async {
      expect(state().stage, RecoveryStage.phone);
      expect(state().failure, RecoveryFailure.restartRequired);
      expect(state().error, same(error));
      expect(state().isBusy, isFalse);
      expect(state().parentPhoneMasked, isNull);
      expect(state().codeResendAfterSeconds, isNull);

      // Everything that named the attempt is gone: later steps send nothing.
      clearInteractions(repo);
      await notifier().verifyParent(code);
      await notifier().submitNewPhone(newPhone);
      await notifier().confirm(code);
      verifyNoRepositoryCall();
    }

    test('at step 2', () async {
      await advanceTo(RecoveryStage.parentCode);
      stubVerify(tokenDead);
      await notifier().verifyParent(code);
      await expectRestarted(tokenDead);
    });

    test('at step 3', () async {
      await advanceTo(RecoveryStage.newPhone);
      stubNewPhone(tokenDead);
      await notifier().submitNewPhone(newPhone);
      await expectRestarted(tokenDead);
    });

    test('at step 4: nothing stored, nobody signed in', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      stubConfirm(tokenDead);
      await notifier().confirm(code);
      await expectRestarted(tokenDead);
      verifyNever(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
      expect(auth.studentIds, isEmpty);
    });

    test('and a fresh start works, with the new recovery id', () async {
      await advanceTo(RecoveryStage.newPhone);
      stubNewPhone(tokenDead);
      await notifier().submitNewPhone(newPhone);

      stubStart(
        const RecoveryStartResult(
          recoveryId: secondRecoveryId,
          parentPhoneMasked: masked,
          resendAfterSeconds: 60,
          expiresInSeconds: 300,
        ),
      );
      await notifier().start(phone);
      expect(state().stage, RecoveryStage.parentCode);
      expect(state().error, isNull);
      await notifier().verifyParent(code);

      verify(
        () => repo.verifyParentOtp(recoveryId: secondRecoveryId, code: code),
      ).called(1);
    });
  });

  group('403 account_banned is terminal', () {
    Future<void> expectTerminal() async {
      expect(state().stage, RecoveryStage.banned);
      expect(state().failure, RecoveryFailure.banned);
      expect(state().isBusy, isFalse);
      expect(state().parentPhoneMasked, isNull);

      // Nothing more is ever sent - not a retry, not a resend, not a restart.
      clearInteractions(repo);
      await notifier().start(phone);
      await notifier().verifyParent(code);
      await notifier().submitNewPhone(newPhone);
      await notifier().confirm(code);
      notifier().reset();
      verifyNoRepositoryCall();
      expect(state().stage, RecoveryStage.banned);
    }

    test('at step 2 (verifyParentOtp)', () async {
      await advanceTo(RecoveryStage.parentCode);
      stubVerify(banned);
      await notifier().verifyParent(code);
      await expectTerminal();
    });

    test('at step 4 (confirmRecovery): no tokens were issued, so none are '
        'stored and nobody is signed in', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      stubConfirm(banned);
      await notifier().confirm(code);

      await expectTerminal();
      verifyNever(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
      expect(auth.studentIds, isEmpty);
      expect(
        container.read(authControllerProvider),
        isA<AuthUnauthenticated>(),
      );
    });

    test('the error is kept for the screen, as the server typed it', () async {
      await advanceTo(RecoveryStage.parentCode);
      stubVerify(banned);
      await notifier().verifyParent(code);
      expect(state().error, same(banned));
      expect(isAccountBanned(state().error), isTrue);
    });
  });

  group('credentials are held only while the attempt needs them', () {
    bool held() => notifier().holdsCredentials;

    test(
      'none at the start; held through steps 1-3; none once completed',
      () async {
        expect(held(), isFalse);

        await advanceTo(RecoveryStage.parentCode);
        expect(held(), isTrue, reason: 'the recovery id');
        stubVerify();
        await notifier().verifyParent(code);
        expect(held(), isTrue, reason: 'the rebind token');
        await notifier().submitNewPhone(newPhone);
        expect(held(), isTrue, reason: 'the rebind token');

        await notifier().confirm(code);
        expect(state().stage, RecoveryStage.completed);
        expect(held(), isFalse);
      },
    );

    test('a wrong code is not the end of the attempt: they are kept so the '
        'next try can be sent', () async {
      await advanceTo(RecoveryStage.parentCode);
      stubVerify(invalid);
      await notifier().verifyParent(code);
      expect(held(), isTrue);

      await advanceTo(RecoveryStage.newPhoneCode);
      stubConfirm(throttled);
      await notifier().confirm(code);
      expect(held(), isTrue);
    });

    test('401 registration_token_invalid drops them, at each step that can '
        'answer it', () async {
      for (final step in [
        RecoveryStage.parentCode,
        RecoveryStage.newPhone,
        RecoveryStage.newPhoneCode,
      ]) {
        useContainer();
        await advanceTo(step);
        expect(held(), isTrue, reason: step.name);
        switch (step) {
          case RecoveryStage.parentCode:
            stubVerify(tokenDead);
            await notifier().verifyParent(code);
          case RecoveryStage.newPhone:
            stubNewPhone(tokenDead);
            await notifier().submitNewPhone(newPhone);
          default:
            stubConfirm(tokenDead);
            await notifier().confirm(code);
        }
        expect(held(), isFalse, reason: step.name);
      }
    });

    test(
      '403 account_banned drops them, at both steps that can answer it',
      () async {
        await advanceTo(RecoveryStage.parentCode);
        stubVerify(banned);
        await notifier().verifyParent(code);
        expect(held(), isFalse);

        useContainer();
        await advanceTo(RecoveryStage.newPhoneCode);
        stubConfirm(banned);
        await notifier().confirm(code);
        expect(held(), isFalse);
      },
    );

    test('reset drops them', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      expect(held(), isTrue);
      notifier().reset();
      expect(held(), isFalse);
    });
  });

  group('reset', () {
    test('goes back to the start and forgets the attempt', () async {
      await advanceTo(RecoveryStage.parentCode);
      notifier().reset();

      expect(state().stage, RecoveryStage.phone);
      expect(state().parentPhoneMasked, isNull);
      clearInteractions(repo);
      await notifier().verifyParent(code);
      verifyNoRepositoryCall();
    });

    test('is ignored while a call is in flight', () async {
      final gate = Completer<RecoveryStartResult>();
      when(() => repo.startRecovery(any())).thenAnswer((_) => gate.future);
      final call = notifier().start(phone);

      notifier().reset();
      expect(state().isBusy, isTrue);

      gate.complete(started);
      await call;
      expect(state().stage, RecoveryStage.parentCode);
    });

    test('does not revive a completed flow into a second sign-in', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      await notifier().confirm(code);
      expect(state().stage, RecoveryStage.completed);

      clearInteractions(repo);
      await notifier().confirm(code);
      await notifier().start(phone);
      verifyNoRepositoryCall();
      expect(auth.studentIds, hasLength(1));
    });
  });

  group('the secrets do not outlive the flow (autoDispose)', () {
    test('the provider is dropped with its last listener, and a new visit '
        'starts empty', () async {
      await advanceTo(RecoveryStage.parentCode);
      expect(state().parentPhoneMasked, masked);
      expect(container.exists(recoveryFlowProvider), isTrue);

      listener.close();
      await container.pump();

      expect(container.exists(recoveryFlowProvider), isFalse);
      listener = container.listen(recoveryFlowProvider, (_, _) {});
      expect(state().stage, RecoveryStage.phone);
      expect(state().parentPhoneMasked, isNull);
    });

    test('the recovery id and the rebind token are gone with it: a new '
        'notifier cannot send a later step', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      listener.close();
      await container.pump();
      listener = container.listen(recoveryFlowProvider, (_, _) {});
      clearInteractions(repo);

      await notifier().verifyParent(code);
      await notifier().submitNewPhone(newPhone);
      await notifier().confirm(code);

      verifyNoRepositoryCall();
    });

    test('leaving mid-confirm: the session is still stored and the router '
        'still flips, and nothing throws', () async {
      await advanceTo(RecoveryStage.newPhoneCode);
      final gate = Completer<AuthenticatedResult>();
      when(
        () => repo.confirmRecovery(
          rebindToken: any(named: 'rebindToken'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenAnswer((_) => gate.future);

      final call = notifier().confirm(code);
      listener.close();
      await container.pump();
      expect(container.exists(recoveryFlowProvider), isFalse);

      gate.complete(authenticated);
      await call;

      verify(
        () => storage.writeTokens(access: 'access.jwt', refresh: 'refresh.jwt'),
      ).called(1);
      expect(auth.studentIds, ['student-1']);
    });

    test('leaving mid-call with a failure does not assign to a dead '
        'notifier', () async {
      final gate = Completer<RecoveryStartResult>();
      when(() => repo.startRecovery(any())).thenAnswer((_) => gate.future);
      final call = notifier().start(phone);
      listener.close();
      await container.pump();

      gate.completeError(throttled);
      await call;
      expect(container.exists(recoveryFlowProvider), isFalse);
    });
  });

  test('with the REAL AuthController, a completed recovery signs the student '
      'in AND binds the return target to them (O-10)', () async {
    final realContainer = ProviderContainer(
      overrides: [
        recoveryRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => device),
      ],
    );
    addTearDown(realContainer.dispose);
    realContainer.listen(recoveryFlowProvider, (_, _) {});
    realContainer.read(authControllerProvider);
    await Future<void>.delayed(Duration.zero);
    expect(
      realContainer.read(authControllerProvider),
      isA<AuthUnauthenticated>(),
    );

    stubStart();
    stubVerify();
    stubNewPhone();
    stubConfirm();
    final flow = realContainer.read(recoveryFlowProvider.notifier);
    await flow.start(phone);
    await flow.verifyParent(code);
    await flow.submitNewPhone(newPhone);
    await flow.confirm(code);

    expect(
      realContainer.read(authControllerProvider),
      isA<AuthAuthenticated>(),
    );

    // A later forced sign-out binds the remembered location to THIS student,
    // without a /me read: the id captured at sign-in is the only source.
    await realContainer
        .read(authControllerProvider.notifier)
        .forceLogout(LogoutReason.sessionExpired);
    final target = realContainer.read(returnTargetProvider)..remember('/learn');
    expect(target.consume(studentId: 'student-1', fallback: 'none'), '/learn');
  });
}
