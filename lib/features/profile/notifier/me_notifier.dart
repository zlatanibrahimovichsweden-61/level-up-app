import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/entitlement_state.dart';
import '../models/student_profile.dart';
import '../repository/profile_repository.dart';

/// `GET /me` — the signed-in student's profile, and the single source Home
/// renders from.
///
/// **autoDispose, and that is the session boundary** (API→UI Wave 19, owner
/// ruling 2026-09-27, KNOWN_BUGS BUG-015). Inside the nav shell Home is always
/// mounted and watches this, so tab switches never re-fetch or re-flash a
/// skeleton. A sign-out unmounts the shell, and the last listener leaving is
/// what drops the profile. As a plain provider it was dropped only by
/// [invalidateSessionScope], which runs while Home still watches, so Riverpod
/// rebuilt it on the next frame with no token and carried the result into the
/// next session: the previous student on the mock, a 401 on staging. A refetch
/// at the next sign-in would not have been enough either: Riverpod 3 keeps a
/// provider's previous value through every rebuild, so the new student's Home
/// would show the old one's name until their own `/me` landed.
///
/// Nothing here computes anything. `points`, `level` and `badges` are
/// server-authoritative — this notifier hands the payload through untouched.
class MeNotifier extends AsyncNotifier<StudentProfile> {
  /// Set when the provider is torn down, so a Retry still in flight does not
  /// write to a dead notifier (the guard `autoDispose notifiers that await
  /// track their own disposal`).
  bool _disposed = false;

  @override
  Future<StudentProfile> build() {
    // Re-armed on EVERY build. Riverpod 3 keeps this instance across rebuilds
    // and runs the dispose callbacks on each one, and this provider is
    // rebuilt in use (a finished quiz and a saved edit invalidate it). Left
    // set, the next Retry would sit on its skeleton forever.
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return ref.watch(profileRepositoryProvider).getMe();
  }

  /// User-tapped retry / pull-to-refresh. Never auto-retried on failure: a
  /// silent retry loop on a dead network is how you drain a student's battery
  /// and their data bundle.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).getMe(),
    );
    if (_disposed) return;
    state = next;
  }
}

/// `retry: _noRetry` is NOT optional here. Riverpod 3 retries a failed provider
/// build automatically with exponential backoff, and while it is retrying the
/// state stays `AsyncLoading` (carrying the error) rather than becoming
/// `AsyncError` — so the screen would sit on its skeleton instead of showing
/// the error/offline view, and would keep hammering `/me` on a dead network.
/// The project rule is explicit: retry is a user-tapped button, never silent.
final meProvider =
    AsyncNotifierProvider.autoDispose<MeNotifier, StudentProfile>(
      MeNotifier.new,
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;

/// `GET /me/entitlements` — the entitlement-state source of truth, kept
/// available rather than displayed on Home (this frame has no entitlement
/// widget). The app is purchase-silent (adr-049): it reads this state and
/// never offers a way to change it.
///
/// Refetched on app RESUME as the contract instructs: a student can buy on the
/// website and come back, and the app must not keep showing the stale state.
/// The listener is torn down with the provider.
///
/// **autoDispose, and that is what ends the listener with the session** (E4-03,
/// the same remedy as `meProvider`, KNOWN_BUGS BUG-015). As a plain provider it
/// outlived the student: `invalidateSessionScope` rebuilt it while a screen was
/// still listening, the rebuild registered a NEW resume listener, and the
/// element was never disposed — so every later app resume sent a tokenless
/// `GET /me/entitlements` for as long as the process lived. Now the sign-out
/// unmounts the shell, the last listener leaving drops the element, and the
/// resume hook goes with it.
class EntitlementsNotifier extends AsyncNotifier<List<EntitlementState>> {
  /// Set when the provider is torn down, so a resume refetch whose answer lands
  /// AFTER the session ended does not write to a dead notifier. Re-armed on
  /// EVERY build (Riverpod 3 keeps this instance across rebuilds and runs the
  /// dispose callbacks on each one).
  bool _disposed = false;

  @override
  Future<List<EntitlementState>> build() {
    _disposed = false;
    final listener = AppLifecycleListener(onResume: refresh);
    ref.onDispose(() {
      _disposed = true;
      listener.dispose();
    });
    return ref.watch(profileRepositoryProvider).getEntitlements();
  }

  /// Re-reads the entitlement set. Deliberately does NOT flip to
  /// `AsyncLoading` first: this runs unprompted on resume, and blanking a
  /// paywall the student is looking at would be a visible flicker they never
  /// asked for. The previous value stays on screen until the new one lands.
  Future<void> refresh() async {
    final next = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).getEntitlements(),
    );
    if (_disposed) return;
    state = next;
  }
}

final entitlementsProvider =
    AsyncNotifierProvider.autoDispose<
      EntitlementsNotifier,
      List<EntitlementState>
    >(
      EntitlementsNotifier.new,
      retry: _noRetry, // same reasoning as meProvider
    );
