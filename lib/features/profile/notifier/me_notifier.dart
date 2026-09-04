import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/entitlement_state.dart';
import '../models/student_profile.dart';
import '../repository/profile_repository.dart';

/// `GET /me` — the signed-in student's profile, and the single source Home
/// renders from.
///
/// A plain (non-autoDispose) [AsyncNotifier] so the profile survives tab
/// switches inside the nav shell: leaving Home for Leaderboard and coming back
/// must not re-fetch and re-flash a skeleton.
///
/// Nothing here computes anything. `points`, `level` and `badges` are
/// server-authoritative — this notifier hands the payload through untouched.
class MeNotifier extends AsyncNotifier<StudentProfile> {
  @override
  Future<StudentProfile> build() =>
      ref.watch(profileRepositoryProvider).getMe();

  /// User-tapped retry / pull-to-refresh. Never auto-retried on failure: a
  /// silent retry loop on a dead network is how you drain a student's battery
  /// and their data bundle.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).getMe(),
    );
  }
}

/// `retry: _noRetry` is NOT optional here. Riverpod 3 retries a failed provider
/// build automatically with exponential backoff, and while it is retrying the
/// state stays `AsyncLoading` (carrying the error) rather than becoming
/// `AsyncError` — so the screen would sit on its skeleton instead of showing
/// the error/offline view, and would keep hammering `/me` on a dead network.
/// The project rule is explicit: retry is a user-tapped button, never silent.
final meProvider = AsyncNotifierProvider<MeNotifier, StudentProfile>(
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
class EntitlementsNotifier extends AsyncNotifier<List<EntitlementState>> {
  @override
  Future<List<EntitlementState>> build() {
    final listener = AppLifecycleListener(onResume: refresh);
    ref.onDispose(listener.dispose);
    return ref.watch(profileRepositoryProvider).getEntitlements();
  }

  /// Re-reads the entitlement set. Deliberately does NOT flip to
  /// `AsyncLoading` first: this runs unprompted on resume, and blanking a
  /// paywall the student is looking at would be a visible flicker they never
  /// asked for. The previous value stays on screen until the new one lands.
  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).getEntitlements(),
    );
  }
}

final entitlementsProvider =
    AsyncNotifierProvider<EntitlementsNotifier, List<EntitlementState>>(
      EntitlementsNotifier.new,
      retry: _noRetry, // same reasoning as meProvider
    );
