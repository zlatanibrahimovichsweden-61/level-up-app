import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/router/return_target.dart';
import '../../../core/session/session_scope.dart';
import '../../profile/notifier/me_notifier.dart';
import '../repository/auth_repository.dart';

/// The single source of auth truth. The interceptor flips this (never navigates);
/// the router's `refreshListenable` reacts and redirects. Sealed so the router
/// can pattern-match without booleans.
sealed class AuthStatus {
  const AuthStatus();
}

/// First frame only — the access-token read is async, so we don't yet know.
class AuthUnknown extends AuthStatus {
  const AuthUnknown();
}

class AuthAuthenticated extends AuthStatus {
  const AuthAuthenticated();
}

/// Signed out. [reason] drives the one-time message on /login (null once shown,
/// or when the sign-out was routine).
class AuthUnauthenticated extends AuthStatus {
  const AuthUnauthenticated([this.reason]);
  final LogoutReason? reason;
}

/// Why the session ended. `userInitiated` shows no message (see Piece 6).
enum LogoutReason { supersededOtherDevice, sessionExpired, userInitiated }

class AuthController extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    // The token read is async → start `unknown`, resolve on the next microtask.
    // The router treats `unknown` as "wait" (returns null), so no flicker to
    // /login before we know.
    _resolveInitial();
    return const AuthUnknown();
  }

  Future<void> _resolveInitial() async {
    final token = await ref.read(secureStorageProvider).readAccessToken();
    state = (token != null && token.isNotEmpty)
        ? const AuthAuthenticated()
        : const AuthUnauthenticated();
  }

  /// The server id of the student the CURRENT session signed in as, captured by
  /// [markAuthenticated] from the id the sign-in response carried. Null when the
  /// session did not go through a sign-in in this process (restored from stored
  /// tokens at a cold start) or the sign-in carried no id (registration). Kept
  /// in memory only and never logged; see [_signedInStudentId] for how it is
  /// used.
  String? _sessionStudentId;

  /// Called after tokens are written (OTP verify success) so the router flips.
  ///
  /// [studentId] is the id the verify response carried for this session, or null
  /// when it carried none. It is ALWAYS assigned, so a sign-in without an id
  /// resets what the previous session captured instead of inheriting it — which
  /// is also why registration's argument-less call is correct: it lands on
  /// /home, where `/me` covers the binding.
  ///
  /// **Every completed sign-in passes through here** (OTP verify, registration),
  /// so this is the single point where the router's [ReturnTarget] follows the
  /// live session: [ReturnTarget.sessionStarted] keeps a remembered location only
  /// when it is bound to [studentId], and drops it otherwise (O10-1). It runs
  /// BEFORE the state flips, so nothing reacting to the new state can see a
  /// target that belongs to someone else. That also covers a verify that
  /// completes after its screen was left, after another student signed in: the
  /// live session is then that late student's, and the target is gone. A
  /// registration's id-less call drops it too (fail closed) — including a late
  /// registration whose screen is already gone and so skips its own `clear()`.
  void markAuthenticated({String? studentId}) {
    _sessionStudentId = studentId;
    ref.read(returnTargetProvider).sessionStarted(studentId);
    state = const AuthAuthenticated();
  }

  /// Server-driven eviction / dead refresh. Clears ONLY the tokens
  /// ([SecureStorage.clearTokens]) so `device_id` survives — wiping it would make
  /// the next login look like a new device and mis-fire `session_superseded`
  /// (Decisions_Log 2026-07-23). Never `clear()`.
  ///
  /// **Idempotent once signed out.** Returning early when already signed out is
  /// load-bearing, not tidiness. [invalidateSessionScope] rebuilds any session
  /// provider that still has a listener, a rebuild with no token in storage
  /// earns a 401, and `AuthInterceptor._performRefresh` answers a 401 with no
  /// refresh token by calling this method — which would invalidate again,
  /// refetch again, and loop. The guard breaks that cycle at the first repeat,
  /// and absorbs any later 401. It is NOT a lock, though: the check comes BEFORE
  /// the `await` on `clearTokens`, so it returns only for calls that arrive
  /// after the state has flipped. Calls that arrive while an earlier call is
  /// still awaiting `clearTokens` pass it and run through: each binds the same
  /// student (see below) and each flips, so the reason the state ends with is the
  /// LAST such call's, not the first.
  ///
  /// **Binds the router's [ReturnTarget] to the student whose session ends**
  /// (owner decision O-10): [ReturnTarget.sessionEnding] is called with that
  /// student's id before anything else changes (see [_signedInStudentId] for the
  /// two places it comes from and why it may be null), so the location the
  /// router remembers for this sign-out is returned only to the same student (a
  /// different student signing in next lands on Home). It must happen BEFORE the
  /// state flip below — the flip is what runs the router's redirect, which is
  /// what remembers the location, and the call also forgets any location left
  /// over from an earlier session.
  ///
  /// The id captured at sign-in is dropped only immediately before the flip, not
  /// earlier: a second `forceLogout` that enters during the `await` on
  /// `clearTokens` (the state is still authenticated) must still see it. Once the
  /// state has flipped that second call returns at its guard.
  Future<void> forceLogout(LogoutReason reason) async {
    if (state is AuthUnauthenticated) return;
    ref.read(returnTargetProvider).sessionEnding(_signedInStudentId());
    await ref.read(secureStorageProvider).clearTokens();
    _sessionStudentId = null;
    state = AuthUnauthenticated(reason);
    invalidateSessionScope(ref);
  }

  /// The server id of the student whose session is ending, or null when it
  /// cannot be told — which makes the return target go to nobody (fail closed).
  ///
  /// **Two sources, in this order.**
  /// 1. The id captured at sign-in ([_sessionStudentId]): the `id` the verify
  ///    response carried for THIS session. It is authoritative — it names the
  ///    student the server signed in — and needs no `/me` read at all, so it
  ///    cannot start or flush a fetch either.
  /// 2. Otherwise `meProvider`, for a session that never went through a sign-in
  ///    in this process (restored from stored tokens at a cold start; or a
  ///    registration, whose `markAuthenticated()` carries no id). Those always
  ///    land on /home first, where Home loads `/me`.
  ///
  /// Why the captured id comes first and `/me` alone is not enough: "Home keeps
  /// `/me` loaded exactly when a target can exist" was false after a
  /// return-to-target landing straight into `/learn/…` or `/message`. The shell
  /// is rebuilt with only that branch (branches are lazy, there is no
  /// `preload`), so Home never mounts and `meProvider` never exists — a SECOND
  /// forced sign-out from there would bind nobody and deny the same student.
  ///
  /// The `/me` fallback: `exists` keeps this from CREATING the provider, and
  /// with it a fetch that would race the token clear and earn a 401 that calls
  /// [forceLogout] again. It does not make the read free: reading an existing
  /// provider whose rebuild is already due flushes it (riverpod 3.3.2
  /// `readSelf`), which DOES send that already-due `GET /me` now, with the old
  /// token, before the tokens are cleared. Its state is then loading, which binds
  /// nobody, and a 401 from it lands after the flip, where [forceLogout] returns
  /// at its guard. With a captured id that read no longer happens for sessions
  /// signed in within this process.
  ///
  /// **Only a settled, successful `/me` binds.** Riverpod 3 keeps the PREVIOUS
  /// value through a rebuild (`AsyncValue.value` is the last value, also while a
  /// refresh is loading or after it failed), so a value that is loading or has
  /// an error is not trusted: if `meProvider` ever outlived a sign-out, a later
  /// student forced out before their own `/me` settled would otherwise bind
  /// their location to the earlier student's id. The primary session boundary is
  /// still that `meProvider` is autoDispose (BUG-015) and the shell unmounting
  /// drops it; this rule is the second line, so the binding does not depend on
  /// that timing. The cost is deliberate: a forced sign-out while `/me` is
  /// refreshing (right after a finished quiz invalidates it) or after a refresh
  /// failed lands the same student on Home. Fail closed.
  ///
  /// Any error is swallowed to null: a forced sign-out must never fail because
  /// of this convenience. The id is a UUID, never the phone number, and is never
  /// logged.
  String? _signedInStudentId() {
    try {
      final captured = _sessionStudentId;
      if (captured != null) return captured;
      if (!ref.exists(meProvider)) return null;
      final me = ref.read(meProvider);
      return !me.isLoading && !me.hasError ? me.value?.id : null;
    } catch (_) {
      return null;
    }
  }

  /// User-initiated sign-out, from the Profile hub's Sign Out row.
  /// Best-effort server revoke, then clear tokens regardless.
  ///
  /// Also forgets the router's [ReturnTarget]: a student who deliberately signs
  /// out must not be walked back to where they were. It is cleared HERE, after
  /// the awaits, rather than only in the router's redirect, so a forced sign-out
  /// that landed (and was remembered) while the revoke was in flight cannot
  /// survive the student's own sign-out; the owner it was bound to goes with it,
  /// and so does the student id captured at sign-in.
  /// A FORCED sign-out does not clear it, on purpose — that is the feature —
  /// it binds it to the ending student instead (see [forceLogout]).
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // 204 is idempotent and a 401 means already-revoked — either way we clear.
    }
    await ref.read(secureStorageProvider).clearTokens();
    ref.read(returnTargetProvider).clear();
    _sessionStudentId = null;
    state = const AuthUnauthenticated(LogoutReason.userInitiated);
    invalidateSessionScope(ref);
  }

  /// Consume the logout reason so its message shows exactly once.
  void clearReason() {
    if (state is AuthUnauthenticated) {
      state = const AuthUnauthenticated();
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthStatus>(
  AuthController.new,
);
