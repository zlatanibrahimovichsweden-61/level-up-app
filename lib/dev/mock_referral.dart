/// Throwaway on-device preview data for the Refer a Friend record - NOT
/// production code.
///
/// Answers the one operation the referral data layer calls - `GET /me/invite`
/// (`getMyInvite`, `contract/openapi.yaml:1434`, `x-stability: stable`) - for
/// `lib/dev/mock_backend.dart`, which owns the request plumbing. This file holds
/// the data; the interceptor turns a [MockReferralReply] into a Dio response. It
/// follows `mock_support.dart`'s shape on purpose.
///
/// **Everything below is MOCK SAMPLE DATA, not product copy.** The code is a
/// fixed fixture, not a real student's: eight characters from the contract's
/// alphabet (`^[0-9A-HJKMNP-TV-Z]{8}$` - digits and capital letters without
/// I, L, O, U), so it parses into the REAL `MyInvite` and would pass the
/// contract's own pattern. The counts are fixed too: four friends joined and
/// 30 points earned, i.e. LESS than `10 x friendsJoined`, which the contract
/// allows ("no credit while the caller had no active enrolment") and which
/// keeps a screen honest about displaying the server's figure rather than
/// multiplying.
///
/// Stateless: the contract says the code is created on the first call, never
/// changes and cannot be regenerated, so every call returns the same record.
/// No phone number, name or e-mail address appears anywhere.
library;

/// What the mock answers, in terms the interceptor maps onto its own `_ok`
/// helper.
sealed class MockReferralReply {
  const MockReferralReply();
}

/// A success: [status] (`200`) and the JSON body.
final class MockReferralOk extends MockReferralReply {
  const MockReferralOk(this.status, this.data);

  final int status;
  final Object? data;
}

/// The fixture's invite code. A sample, not anyone's real code.
const kMockInviteCode = 'K7M2Q9XD';

/// New accounts that registered with [kMockInviteCode].
const kMockInviteFriendsJoined = 4;

/// Points the code has earned: deliberately not `10 x` [kMockInviteFriendsJoined].
const kMockInvitePointsEarned = 30;

/// The referral record of a mock session. See the file header.
class MockReferral {
  /// The reply for `GET /me/invite`, or `null` when [method] + [path] is not
  /// that route (so the interceptor keeps looking).
  MockReferralReply? handle(String method, String path) {
    if (method != 'GET' || path != '/me/invite') return null;
    return const MockReferralOk(200, <String, dynamic>{
      'code': kMockInviteCode,
      'friendsJoined': kMockInviteFriendsJoined,
      'pointsEarned': kMockInvitePointsEarned,
    });
  }
}
