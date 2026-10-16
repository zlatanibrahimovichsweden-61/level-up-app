import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';

/// The on-device preview harness must keep answering `/me` in a shape the REAL
/// model parses — otherwise Home renders its error state on the device and the
/// harness silently stops being a preview of anything.
///
/// This is the harness doing its job: if `StudentProfile` changes and the canned
/// JSON is not updated, this test fails instead of a Pixel 8 showing "Something
/// went wrong".
void main() {
  test('mock GET /me parses into a StudentProfile Home can render', () async {
    final dio = buildMockDio(latency: Duration.zero);

    final res = await dio.get<Map<String, dynamic>>('/me');
    final profile = StudentProfile.fromJson(res.data!);

    expect(res.statusCode, 200);
    expect(profile.track, Track.school);
    expect(profile.name, isNotEmpty);
    expect(profile.avatar.url, isNotEmpty); // the header's cached image
    // The level card's two numbers.
    expect(profile.level, greaterThan(0));
    expect(profile.points.total, greaterThanOrEqualTo(0));
  });

  test(
    'mock GET /me/entitlements parses, and agrees with the /me embed',
    () async {
      final dio = buildMockDio(latency: Duration.zero);

      final standalone = EntitlementsResponse.fromJson(
        (await dio.get<Map<String, dynamic>>('/me/entitlements')).data!,
      ).items;
      final embedded = StudentProfile.fromJson(
        (await dio.get<Map<String, dynamic>>('/me')).data!,
      ).entitlements;

      expect(standalone.single.type, EntitlementType.baseSubscription);
      // One student cannot have two different subscription truths depending on
      // which call was made.
      expect(embedded, standalone);
    },
  );

  // API→UI Wave 20: the mock's `PATCH /me` (`updateMyProfile`), driven through
  // the REAL repository, so the body the screen builds is the body the mock
  // reads, and a 400 arrives as the typed exception the screen maps.
  group('mock PATCH /me', () {
    late Dio dio;
    late ProfileRepository repo;

    setUp(() {
      dio = buildMockDio(latency: Duration.zero);
      repo = ProfileRepository(dio);
    });

    Future<void> signInUniversity() => dio.post<Object?>(
      '/auth/otp/verify',
      data: {'phone': '+2010000000001', 'code': '111111'},
    );

    test('a new name is in the answer and in the next GET /me', () async {
      final answer = await repo.updateMe(const ProfileUpdate(name: 'سارة'));
      expect(answer.name, 'سارة');
      expect((await repo.getMe()).name, 'سارة');
    });

    test('an e-mail set, then cleared with an explicit null', () async {
      await repo.updateMe(
        const ProfileUpdate(email: EmailPatch.set('sara@example.com')),
      );
      expect((await repo.getMe()).email, 'sara@example.com');

      final cleared = await repo.updateMe(
        const ProfileUpdate(email: EmailPatch.cleared()),
      );
      expect(cleared.email, isNull);
      expect((await repo.getMe()).email, isNull);
    });

    test('an absent key leaves the field as it was', () async {
      await repo.updateMe(
        const ProfileUpdate(email: EmailPatch.set('sara@example.com')),
      );
      await repo.updateMe(const ProfileUpdate(name: 'سارة'));
      expect((await repo.getMe()).email, 'sara@example.com');
    });

    test('a picked avatar comes back with its id and url', () async {
      final avatars = (await dio.get<List<dynamic>>(
        '/reference/avatars',
      )).data!.cast<Map<String, dynamic>>();
      final third = avatars[2];

      await repo.updateMe(ProfileUpdate(avatarId: third['id'] as String));
      final me = await repo.getMe();
      expect(me.avatar.id, third['id']);
      expect(me.avatar.url, third['url']);
    });

    test('the privacy toggles round-trip (Wave 21 needs them)', () async {
      await repo.updateMe(
        const ProfileUpdate(leaderboardVisible: false, scoreHidden: true),
      );
      final me = await repo.getMe();
      expect(me.privacy.leaderboardVisible, isFalse);
      expect(me.privacy.scoreHidden, isTrue);
    });

    test('a malformed e-mail is 400 validation_failed on `email`', () async {
      await expectLater(
        repo.updateMe(const ProfileUpdate(email: EmailPatch.set('sara@mail'))),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.status, 'status', 400)
              .having((e) => e.code, 'code', 'validation_failed')
              .having((e) => e.fields, 'fields', ['email']),
        ),
      );
      // Rejected means unchanged.
      expect((await repo.getMe()).email, isNull);
    });

    test('a name over 100 characters is 400 on `name`', () async {
      await expectLater(
        repo.updateMe(ProfileUpdate(name: 'س' * 101)),
        throwsA(
          isA<ValidationException>().having((e) => e.fields, 'fields', [
            'name',
          ]),
        ),
      );
    });

    test('edits stay with their track across a sign-in', () async {
      await repo.updateMe(const ProfileUpdate(name: 'سارة'));
      await signInUniversity();
      expect((await repo.getMe()).name, 'طالب جامعي تجريبي');

      await repo.updateMe(const ProfileUpdate(name: 'ليلى'));
      await dio.post<Object?>(
        '/auth/otp/verify',
        data: {'phone': '+2010000000001', 'code': '000000'},
      );
      expect((await repo.getMe()).name, 'سارة');
    });
  });
}
