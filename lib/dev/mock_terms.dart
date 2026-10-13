/// Throwaway on-device preview data for the caller's Terms acceptance - NOT
/// production code.
///
/// Answers `GET /me/terms-acceptance` (`getTermsAcceptance`) and
/// `POST /me/terms-acceptance` (`acceptTerms`) - `contract/openapi.yaml:1083`,
/// both `x-stability: stable` - for `lib/dev/mock_backend.dart`, which owns the
/// request plumbing. This file holds the state and the contract's rules; the
/// interceptor turns a [MockTermsReply] into a Dio response.
///
/// It lives in its own file rather than beside `mock_legal.dart` on purpose:
/// that file serves the document TEXT (`getLegalDocument`); this one serves the
/// RECORD of acceptance, a different resource with state.
///
/// Strict where the server is strict, per `mock_backend.dart`'s own rule:
/// - `acceptTerms` takes exactly the version the mock currently requires. An
///   absent, empty, non-string or different `termsVersion` - and ANY version
///   when none is configured - is `400 validation_failed` on field
///   `termsVersion`, and the response never names the required version;
/// - accepting a version already accepted is `204` and changes nothing: the
///   first acceptance time stands;
/// - `isCurrent` is `true` only when a version is configured and equals the
///   accepted one.
///
/// **The version is the one `MockLegalDocuments` serves for the Terms
/// document** (`mock-sample-1`, a layout sample and NOT legal text), so the
/// viewer and the acceptance record agree on a single value on a device walk.
///
/// The mock starts **not accepted**; [MockTermsAcceptance.new] takes the
/// other starting states (nothing configured, accepted, accepted an older
/// version) so each state of the contract can be reached from a test. State is
/// per instance: one mock session (one `buildMockDio`) keeps its acceptance, a
/// fresh session starts again.
library;

/// What the mock answers, mapped by the interceptor onto its own `_ok` and
/// `_validationFailed` helpers.
sealed class MockTermsReply {
  const MockTermsReply();
}

/// A success: [status] (`200` or `204`) and the JSON body, or `null` for `204`.
final class MockTermsOk extends MockTermsReply {
  const MockTermsOk(this.status, this.data);

  final int status;
  final Map<String, Object?>? data;
}

/// A `400 validation_failed` with its field map.
final class MockTermsValidation extends MockTermsReply {
  const MockTermsValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// The Terms version the mock requires by default - the same value
/// `MockLegalDocuments` reports for the Terms document.
const kMockTermsVersion = 'mock-sample-1';

/// One caller's Terms acceptance. See the file header.
class MockTermsAcceptance {
  /// [currentVersion] is the version the mock requires (`null`: none is
  /// configured, so the feature is inert and every accept is refused).
  /// [acceptedVersion] / [acceptedAt] are the starting acceptance, if any.
  /// [clock] is the time source, for a deterministic `acceptedAtUtc`.
  MockTermsAcceptance({
    String? currentVersion = kMockTermsVersion,
    String? acceptedVersion,
    DateTime? acceptedAt,
    DateTime Function()? clock,
  }) : _currentVersion = currentVersion,
       _acceptedVersion = acceptedVersion,
       _acceptedAt = acceptedAt?.toUtc(),
       _clock = clock ?? DateTime.now;

  String? _currentVersion;
  String? _acceptedVersion;
  DateTime? _acceptedAt;
  final DateTime Function() _clock;

  static const _path = '/me/terms-acceptance';

  /// The reply for a Terms-acceptance route, or `null` when [method] + [path]
  /// is not one (so the interceptor keeps looking). [body] is the decoded JSON
  /// request body (empty when there is none).
  MockTermsReply? handle(
    String method,
    String path,
    Map<String, dynamic> body,
  ) {
    if (path != _path) return null;
    return switch (method) {
      'GET' => MockTermsOk(200, _state()),
      'POST' => _accept(body),
      _ => null,
    };
  }

  /// Changes the version the mock requires - what a server-side configuration
  /// change does (`null`: none is configured any more). The acceptance already
  /// recorded is kept, so a later version leaves the student not-current until
  /// they accept it, and the earlier acceptance stays on record.
  void requireVersion(String? version) => _currentVersion = version;

  /// `isCurrent` exactly as the contract defines it: true only when a version
  /// is configured and it is the accepted one.
  bool get isCurrent =>
      _currentVersion != null && _currentVersion == _acceptedVersion;

  Map<String, Object?> _state() => <String, Object?>{
    'currentVersion': _currentVersion,
    'acceptedVersion': _acceptedVersion,
    'acceptedAtUtc': _acceptedAt?.toIso8601String(),
    'isCurrent': isCurrent,
  };

  MockTermsReply _accept(Map<String, dynamic> body) {
    final sent = body['termsVersion'];
    final current = _currentVersion;
    // Absent, empty, not a string, not the required version, or no version
    // configured at all: one answer, which never says what is required.
    if (sent is! String || sent.isEmpty || current == null || sent != current) {
      return const MockTermsValidation({
        'termsVersion': ['Not the Terms version currently required.'],
      });
    }
    // Idempotent: a version already accepted is a no-op and the first
    // acceptance time stands. A later version is a new record.
    if (_acceptedVersion != current) {
      _acceptedVersion = current;
      _acceptedAt = _clock().toUtc();
    }
    return const MockTermsOk(204, null);
  }
}
