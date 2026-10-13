import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/push/push_gateway.dart';
import 'package:level_up_app/core/push/push_lifecycle.dart';
import 'package:level_up_app/core/push/push_token_repository.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_referral.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/models/track_transfer_request.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/profile/repository/track_transfer_repository.dart';
import 'package:level_up_app/features/profile/track_transfer_errors.dart';
import 'package:level_up_app/features/referral/repository/referral_repository.dart';

import '../core/push/fake_push_gateway.dart';

/// The three W3d operations as `buildMockDio` serves them, through the REAL
/// repositories: `PUT /me/fcm-token`, `GET /me/invite` and
/// `POST /me/track-transfer`.
///
/// This file proves the hook lines in `mock_backend.dart` (the dispatch blocks
/// and the session track/stage hand-off). The desks' own rules are pinned by
/// `mock_push_test.dart`, `mock_referral_test.dart` and
/// `mock_track_transfer_test.dart`; this is only about the wiring.
///
/// **The transfer's success path is not reachable through `buildMockDio`.**
/// The mock's school student is always `secondary2` (the magic-code sessions
/// and, because `GET /me` ignores the registered stage, every registered one
/// too), and the contract lets only `secondary3` transfer. Making a session
/// final-year would change what `GET /me` returns after a registration, which
/// is an existing mock behaviour, so it was deliberately not hooked in. The
/// success branch of the dispatch block is pinned at the desk
/// (`mock_track_transfer_test.dart`); the refusals are pinned here.
///
/// Every test builds a FRESH Dio (`buildMockDio` per session), so no track or
/// token leaks from one test to the next.
void main() {
  const cairo = '0197b2f3-0005-7cc3-9b4e-000000000001';
  const cairoMedicine = '0197b2f3-0006-7cc3-9b4e-000000000001';
  const medYear2 = '0197b2f3-0007-7cc3-9b4e-000000000002';

  const request = TrackTransferRequest(
    universityId: cairo,
    facultyId: cairoMedicine,
    studyYearId: medYear2,
  );

  late Dio dio;

  setUp(() => dio = buildMockDio(latency: Duration.zero));

  /// The OTP screen's magic codes: `000000` is a school student (secondary2),
  /// `111111` a university student.
  Future<void> signInWithCode(String code) async {
    await dio.post<Object?>(
      '/auth/otp/verify',
      data: <String, dynamic>{'code': code, 'phone': '+2010000000001'},
    );
  }

  group('PUT /me/fcm-token', () {
    test('a token is accepted (204) through the real repository', () async {
      await PushTokenRepository(dio).registerFcmToken('fake-token-for-tests');
    });

    test('an empty token is 400 validation_failed on field token', () async {
      try {
        await PushTokenRepository(dio).registerFcmToken('');
        fail('should have been refused');
      } on ValidationException catch (e) {
        expect(e.fields, ['token']);
      }
    });

    test('a token over 4096 characters is 400 on field token', () async {
      try {
        await PushTokenRepository(dio).registerFcmToken('x' * 4097);
        fail('should have been refused');
      } on ValidationException catch (e) {
        expect(e.fields, ['token']);
      }
    });

    test('the lifecycle registers a fake gateway\'s token, and the Noop '
        'registers nothing', () async {
      final repo = PushTokenRepository(dio);
      final gateway = FakePushGateway(token: 'fake-token-for-tests');
      final live = PushRegistrationLifecycle(
        gateway: gateway,
        repository: repo,
      );
      final dormant = PushRegistrationLifecycle(
        gateway: const NoopPushGateway(),
        repository: repo,
      );
      addTearDown(() async {
        await live.dispose();
        await dormant.dispose();
        await gateway.close();
      });

      expect(await live.onSignedIn(), PushRegistrationOutcome.registered);
      expect(await dormant.onSignedIn(), PushRegistrationOutcome.noToken);
    });
  });

  group('GET /me/invite', () {
    test('serves the fixture, which parses into the real MyInvite', () async {
      final invite = await ReferralRepository(dio).getMyInvite();

      expect(invite.code, kMockInviteCode);
      expect(invite.friendsJoined, kMockInviteFriendsJoined);
      expect(invite.pointsEarned, kMockInvitePointsEarned);
    });
  });

  group('POST /me/track-transfer', () {
    test('the stock school student (secondary2) is 403 not_eligible', () async {
      await signInWithCode('000000');

      try {
        await TrackTransferRepository(dio).transferToUniversity(request);
        fail('should have been refused');
      } on Object catch (e) {
        expect(isTrackTransferNotEligible(e), isTrue);
        expect((e as ApiException).status, 403);
      }
      expect((await ProfileRepository(dio).getMe()).track, Track.school);
    });

    test('a university student is 409 not_allowed', () async {
      await signInWithCode('111111');

      try {
        await TrackTransferRepository(dio).transferToUniversity(request);
        fail('should have been refused');
      } on Object catch (e) {
        expect(isTrackTransferNotAllowed(e), isTrue);
        expect((e as ApiException).status, 409);
      }
    });
  });
}
