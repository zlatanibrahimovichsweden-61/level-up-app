/// Throwaway on-device preview data for the push-token registration - NOT
/// production code.
///
/// Answers the one operation the push seam calls - `PUT /me/fcm-token`
/// (`registerFcmToken`, `contract/openapi.yaml:1064`, `x-stability: stable`) -
/// for `lib/dev/mock_backend.dart`, which owns the request plumbing. This file
/// holds the contract's rules; the interceptor turns a [MockPushReply] into a
/// Dio response. It follows `mock_support.dart`'s shape on purpose.
///
/// Strict where the server is strict, per `mock_backend.dart`'s own rule:
/// - the body is `{ token: string }`; a missing token, a non-string, an
///   empty/whitespace-only string, or one **longer than 4096 characters** is
///   `400 validation_failed` on field `token`, exactly the contract's list;
/// - a valid token is stored (one per mock session, the latest wins) and
///   answered `204` with no body, and a repeat of the same token is `204` too
///   (idempotent).
///
/// **The token is never printed.** It is held in a private field so a test can
/// ask "is this the stored token" without the mock ever echoing it, and
/// nothing here logs. No real token, phone number or person appears anywhere:
/// callers supply whatever string they like.
///
/// Dormant by design: the app's only gateway today is `NoopPushGateway`, which
/// has no token, so a mock session never receives this request unless a test
/// drives it with a fake gateway.
library;

/// What the mock answers, in terms the interceptor maps onto its own `_ok` and
/// `_validationFailed` helpers.
sealed class MockPushReply {
  const MockPushReply();
}

/// A success: [status] (`204`) and no body.
final class MockPushOk extends MockPushReply {
  const MockPushOk(this.status, this.data);

  final int status;
  final Object? data;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockPushValidation extends MockPushReply {
  const MockPushValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// The longest token the contract accepts (`openapi.yaml:1078`: "longer than
/// 4096 characters" is `validation_failed`).
const kMockPushMaxTokenLength = 4096;

/// One push-token registry per mock session. See the file header.
class MockPushDesk {
  String? _token;
  var _registrations = 0;

  /// How many `204`s this session has answered. A repeat of the same token
  /// counts: the mock is idempotent, not deduplicating.
  int get registrations => _registrations;

  /// Whether [token] is the one the session currently holds. The token itself
  /// is not exposed.
  bool holds(String token) => _token != null && _token == token;

  /// Whether the session holds any token.
  bool get hasToken => _token != null;

  /// The reply for `PUT /me/fcm-token`, or `null` when [method] + [path] is not
  /// that route (so the interceptor keeps looking).
  MockPushReply? handle(String method, String path, Map<String, dynamic> body) {
    if (method != 'PUT' || path != '/me/fcm-token') return null;

    final token = body['token'];
    if (token is! String || token.trim().isEmpty) {
      return const MockPushValidation(<String, List<String>>{
        'token': ['Required.'],
      });
    }
    if (token.length > kMockPushMaxTokenLength) {
      return const MockPushValidation(<String, List<String>>{
        'token': ['Must be at most $kMockPushMaxTokenLength characters.'],
      });
    }

    _token = token;
    _registrations++;
    return const MockPushOk(204, null);
  }
}
