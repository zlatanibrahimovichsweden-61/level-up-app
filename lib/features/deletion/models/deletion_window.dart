import 'package:flutter/foundation.dart' show immutable;

import '../../profile/models/student_profile.dart' show PendingDeletion;

/// The grace window an accepted deletion request opened — the
/// `requestAccountDeletion` 202 body (`POST /me/deletion-request`,
/// `contract/openapi.yaml:1263`): `{requestedAt, effectiveAt}`, both required,
/// both UTC `date-time`.
///
/// - [requestedAt] — when the server recorded the request.
/// - [effectiveAt] — [requestedAt] + 30 days, and a **"no earlier than"** time,
///   not a promise: erasure runs from a daily job, so it may lag by up to
///   ~24 hours. The server computes it; nothing here adds days.
///
/// **Not a second `pendingDeletion` model.** `GET /me` already decodes the
/// pending state as [PendingDeletion] (`{effectiveAt}`), and the cancel screen
/// is "drawn from `GET /me`'s `pendingDeletion.effectiveAt`" (`openapi.yaml:83`).
/// The 202 body is a different shape — it ALSO carries [requestedAt], which
/// [PendingDeletion] has no place for — so it is its own type; [pending] hands
/// the shared part back as the one existing type, so the two sources of the
/// same fact speak one language instead of two copies of `effectiveAt`.
///
/// The 202 is the last thing the access token does (the session and refresh
/// chain are revoked at request time), so this is not a state to keep: the
/// student is signed out, and after the next sign-in `GET /me` is the source of
/// the live window.
///
/// Hand-written and strict, like the other `/me` records: a missing or
/// mistyped field throws here and the repository turns it into an
/// `UnknownException`. Nothing here prints a time.
@immutable
class DeletionWindow {
  const DeletionWindow({required this.requestedAt, required this.effectiveAt});

  factory DeletionWindow.fromJson(Map<String, dynamic> json) => DeletionWindow(
    requestedAt: DateTime.parse(json['requestedAt'] as String).toUtc(),
    effectiveAt: DateTime.parse(json['effectiveAt'] as String).toUtc(),
  );

  final DateTime requestedAt;
  final DateTime effectiveAt;

  /// The part of this window `GET /me` also carries, as that model.
  PendingDeletion get pending => PendingDeletion(effectiveAt: effectiveAt);

  @override
  bool operator ==(Object other) =>
      other is DeletionWindow &&
      other.requestedAt == requestedAt &&
      other.effectiveAt == effectiveAt;

  @override
  int get hashCode => Object.hash(requestedAt, effectiveAt);

  @override
  String toString() => 'DeletionWindow()';
}
