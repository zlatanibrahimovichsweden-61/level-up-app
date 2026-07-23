import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
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

  /// Called after tokens are written (OTP verify success) so the router flips.
  void markAuthenticated() => state = const AuthAuthenticated();

  /// Server-driven eviction / dead refresh. Clears ONLY the tokens
  /// ([SecureStorage.clearTokens]) so `device_id` survives — wiping it would make
  /// the next login look like a new device and mis-fire `session_superseded`
  /// (Decisions_Log 2026-07-23). Never `clear()`.
  Future<void> forceLogout(LogoutReason reason) async {
    await ref.read(secureStorageProvider).clearTokens();
    state = AuthUnauthenticated(reason);
  }

  /// User-initiated sign-out (no caller yet — Settings wires the button later).
  /// Best-effort server revoke, then clear tokens regardless.
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // 204 is idempotent and a 401 means already-revoked — either way we clear.
    }
    await ref.read(secureStorageProvider).clearTokens();
    state = const AuthUnauthenticated(LogoutReason.userInitiated);
  }

  /// Consume the logout reason so its message shows exactly once.
  void clearReason() {
    if (state is AuthUnauthenticated) {
      state = const AuthUnauthenticated();
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthStatus>(AuthController.new);
