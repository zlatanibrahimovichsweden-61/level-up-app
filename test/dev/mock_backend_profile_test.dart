import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

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

  test('mock GET /me/entitlements parses, and agrees with the /me embed',
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
  });
}
