import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where a signed-out student was heading when the router sent them to `/login`,
/// so the next sign-in can put them back there instead of on Home.
///
/// **The rule.** When the router bounces a SIGNED-OUT student from a location
/// inside the tab shell to `/login`, the router's `redirect` remembers that
/// location — path plus query — UNLESS the sign-out was the student's own
/// (`LogoutReason.userInitiated`): a student who deliberately signed out must not
/// be walked back to where they were, so a user-initiated sign-out clears
/// whatever was remembered. Only shell locations qualify, because only those
/// come back with a parent stack, a nav bar and a working back chip when
/// reached with `go`; everything else (the auth routes, unmatched locations,
/// `/quiz*`, `/profile*`, `/settings`, `/support`…) is never remembered and falls
/// back to `/home` — see `rememberableLocation` in `app_router.dart`. The one
/// landing that returns a student to where they were is the OTP sign-in
/// success view's Continue: it calls [consume] and goes to the remembered
/// location, or `/home`, ONCE. The two registration submits are deliberately NOT
/// landings of this kind: `registrationRequired` means no account existed for
/// that phone, so a new registrant is never the student whose session ended —
/// they [clear] the target and go to `/home`.
///
/// **Returned only to the same student (owner decision O-10).** The handset is
/// shared, so student A's forced sign-out must not steer the NEXT sign-in to A's
/// location when a different student B signs in. The target is bound to the
/// student whose session ended: `AuthController.forceLogout` calls
/// [sessionEnding] with that student's id BEFORE the auth state flips (the flip
/// is what makes the router [remember] the location), and [consume] hands the
/// location back only when the id of the student who just signed in is the same
/// one. A different student gets the fallback and the target is dropped, so it
/// cannot be picked up by a third sign-in either. The target is also dropped the
/// moment a sign-in completes for anyone other than its owner ([sessionStarted],
/// called by `AuthController.markAuthenticated`), so it follows the LIVE session
/// even when a verify the student walked away from lands after theirs.
///
/// **The key is the server's student id, never the phone number.** The id is the
/// identity the API itself uses (`StudentProfile.id`); a phone number is personal
/// data of a minor and also changes hands. **Unknown on either side fails
/// closed**: if the ending student's id could not be read, or the sign-in
/// response carried none, the student lands on the fallback. There are no
/// timeouts, and nothing is persisted. A signed-out COLD START — no session
/// ended in this process, e.g. a future deep link followed while signed out —
/// has no session owner to match, so it too falls back to Home.
///
/// **Why a plain object and not Riverpod state.** [remember] is called from the
/// router's `redirect`, which runs during navigation and build. Mutating
/// reactive provider state from there is exactly the BUG-001 failure class
/// (Riverpod asserts on a provider write while the tree is building). Nothing
/// watches this value either: it is read once, at a button press. So it is a
/// plain holder, exposed by a plain [Provider] only so the router, the sign-in
/// landing and `AuthController.logout` share one instance.
///
/// **Why in memory only.** A location can carry ids from a student's own
/// catalogue (`/learn/subject/<id>/…`) and many users are minors. It is never a
/// URL or query parameter, never written to secure storage or preferences, and
/// never logged — and the same goes for the owner's id held beside it. A process
/// restart forgets both — the right outcome for a convenience that must not
/// become a record.
///
/// **Why it deliberately survives a forced sign-out.** That is the whole
/// feature: `forceLogout` (expired session, session taken over elsewhere) is
/// exactly when a student should land back where they were after signing in
/// again. So `returnTargetProvider` is NOT in `invalidateSessionScope`.
class ReturnTarget {
  String? _location;

  /// The server id of the student whose session ended — the only student the
  /// remembered [_location] may be returned to. Null = unknown.
  String? _owner;

  /// A session is ending: binds whatever is remembered from here on to
  /// [studentId] (null when it could not be read — the target then goes to
  /// nobody) and forgets any location remembered earlier.
  ///
  /// Forgetting is the point of the second half: a new session end starts a new
  /// binding, so a location left over from an EARLIER session can never be
  /// re-bound to a different student. The router's [remember] for THIS sign-out
  /// comes after this call.
  void sessionEnding(String? studentId) {
    _owner = studentId;
    _location = null;
  }

  /// A sign-in completed for [studentId] (null = its response carried no id):
  /// keeps the remembered location only when that is the student it is bound
  /// to; otherwise forgets the location and its owner.
  ///
  /// Why it exists (O10-1): a verify started on an OTP screen the student then
  /// left still completes in the background — it writes tokens and flips the
  /// auth state after the screen is gone — so it can land AFTER another
  /// student's sign-in, and the live session is then the late student's. The
  /// landing matches the target against the id of ITS OWN outcome, which no
  /// longer names the live session, so the target itself must follow the live
  /// session: every completed sign-in reports here, and a target that does not
  /// belong to the student now signed in is gone before anything can hand it
  /// out.
  ///
  /// Fails closed: no owner, or a sign-in without an id, drops it. The key is the
  /// server's student id, never the phone number. The fields are assigned
  /// directly (as [consume] and [sessionEnding] do), not through [clear], so a
  /// sign-in never depends on an override of it.
  void sessionStarted(String? studentId) {
    final owner = _owner;
    if (owner != null && owner == studentId) return;
    _location = null;
    _owner = null;
  }

  /// Remembers [location], replacing any earlier one. Ignores anything that is
  /// not an app-relative location (a single leading `/`), so a malformed or
  /// absolute value can never become a navigation target. Does not touch the
  /// owner: that is [sessionEnding]'s.
  void remember(String location) {
    if (!location.startsWith('/') || location.startsWith('//')) return;
    _location = location;
  }

  /// Forgets the remembered location AND its owner, if any.
  void clear() {
    _location = null;
    _owner = null;
  }

  /// The remembered location when — and only when — the student who just signed
  /// in ([studentId]) is the same student whose session ended; otherwise
  /// [fallback]. It forgets the location and the owner either way, so a second
  /// landing, or a different student's, goes to [fallback].
  ///
  /// [studentId] is required, and nullable, on purpose: every sign-in landing
  /// must state who signed in, and "the response carried no id" is a value the
  /// caller passes explicitly — which fails closed (null never matches).
  String consume({required String? studentId, String fallback = '/home'}) {
    final location = _location;
    final owner = _owner;
    _location = null;
    _owner = null;
    if (location != null &&
        owner != null &&
        studentId != null &&
        owner == studentId) {
      return location;
    }
    return fallback;
  }
}

/// The one [ReturnTarget] for the app. A plain, non-`autoDispose` provider with
/// no dependencies: it must outlive a sign-out.
final returnTargetProvider = Provider<ReturnTarget>((ref) => ReturnTarget());
