import 'package:flutter/foundation.dart' show immutable;

/// The caller's Terms-acceptance state — the `getTermsAcceptance` 200 body
/// (`GET /me/terms-acceptance`, `contract/openapi.yaml:1083`): four fields, all
/// four `required`.
///
/// **Presence is required, nullability is the content.** Three of the four may
/// be `null` ("required but usually null" reads like "optional" to a skim), so
/// the decoder insists the KEY is there and only then accepts `null`: a body
/// that drops one is contract drift and fails here, typed, instead of reading
/// as "nothing accepted yet".
///
/// - [currentVersion] — the server-configured version the student must accept,
///   or `null` when none is configured. `null` means the feature is **inert**
///   ([isInert]): the contract says every accept is then refused, so there is
///   nothing to ask for and nothing to accept. Opaque identifier (≤ 32
///   characters); the backend serves no Terms text and no link — the text is
///   `getLegalDocument`, a different operation.
/// - [acceptedVersion] / [acceptedAtUtc] — the caller's most recent
///   acceptance, or `null` for both when there is none. The time is the
///   server's, in UTC.
/// - [isCurrent] — the server's verdict: `true` only when [currentVersion] is
///   non-null and equals [acceptedVersion]. **Never recomputed here**: the
///   server decides whether the student is up to date, the app displays it.
///
/// This records the student's own acceptance. It is not parent consent
/// (contract, `getTermsAcceptance` description).
///
/// Hand-written rather than generated, like the other `/me` records. Nothing
/// here is printed by [toString] beyond the verdict: an acceptance time
/// belongs to a student who may be a minor.
@immutable
class TermsAcceptance {
  const TermsAcceptance({
    required this.currentVersion,
    required this.acceptedVersion,
    required this.acceptedAtUtc,
    required this.isCurrent,
  });

  factory TermsAcceptance.fromJson(Map<String, dynamic> json) {
    final acceptedAt = _required(json, 'acceptedAtUtc') as String?;
    return TermsAcceptance(
      currentVersion: _required(json, 'currentVersion') as String?,
      acceptedVersion: _required(json, 'acceptedVersion') as String?,
      acceptedAtUtc: acceptedAt == null
          ? null
          : DateTime.parse(acceptedAt).toUtc(),
      isCurrent: _required(json, 'isCurrent') as bool,
    );
  }

  final String? currentVersion;
  final String? acceptedVersion;
  final DateTime? acceptedAtUtc;
  final bool isCurrent;

  /// No Terms version is configured, so there is nothing to accept
  /// (`currentVersion` is `null`). The contract: "the feature is inert until
  /// one is — every accept is then refused".
  bool get isInert => currentVersion == null;

  @override
  bool operator ==(Object other) =>
      other is TermsAcceptance &&
      other.currentVersion == currentVersion &&
      other.acceptedVersion == acceptedVersion &&
      other.acceptedAtUtc == acceptedAtUtc &&
      other.isCurrent == isCurrent;

  @override
  int get hashCode =>
      Object.hash(currentVersion, acceptedVersion, acceptedAtUtc, isCurrent);

  @override
  String toString() => 'TermsAcceptance(isCurrent: $isCurrent)';
}

/// The value under [key], which must be PRESENT (it may be `null`). The key
/// name is the only thing the failure carries.
Object? _required(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key)) {
    throw FormatException('TermsAcceptance: missing required key $key');
  }
  return json[key];
}
