import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_update.dart';
import '../models/student_profile.dart';
import '../repository/profile_repository.dart';
import 'me_notifier.dart';

/// `PATCH /me` — the Edit Profile form's submit command, and the last stable
/// endpoint in the contract to be consumed.
///
/// A COMMAND notifier, like `RegistrationSubmitNotifier`: `build` seeds idle and
/// does no work, so `AsyncValue` carries the whole story with no parallel
/// booleans —
///
/// - `AsyncData(null)`          → idle
/// - `AsyncLoading`             → in flight (Save shows a spinner)
/// - `AsyncData(StudentProfile)`→ 200, the updated profile the server returned
/// - `AsyncError(...)`          → the screen maps it:
///     · [ValidationException] → per-field inline errors from the field map
///     · offline/network       → the offline line
///     · anything else         → the generic line
///
/// `autoDispose` because this is screen-scoped: leaving Edit Profile and coming
/// back must not land on a stale error from the previous attempt. [meProvider]
/// is the opposite — it is deliberately kept alive so tab switches cost no
/// request — and the two live at different lifetimes on purpose.
class EditProfileNotifier extends AsyncNotifier<StudentProfile?> {
  @override
  FutureOr<StudentProfile?> build() => null;

  /// Submits [update]. Returns true when the profile is saved (or when there
  /// was nothing to save), so the screen can decide to leave.
  ///
  /// Navigation stays in the widget layer; this never touches a router.
  Future<bool> save(ProfileUpdate update) async {
    if (state.isLoading) return false; // no double-submit

    // Nothing changed. Spending a round trip to tell the server so would flash
    // a spinner over a request whose response is the payload we already hold.
    if (update.isEmpty) return true;

    state = const AsyncLoading<StudentProfile?>();
    final result = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).updateMe(update),
    );
    state = result;
    if (result.hasError) return false;

    // ONE source of profile truth. `PATCH` did return the updated profile, but
    // Home, the Profile hub and this screen all read [meProvider] — so the
    // provider is invalidated and re-reads, exactly as the quiz does after a
    // finish (`quiz_screen.dart:213`). Writing the response straight into
    // [meProvider] instead would give the profile two ways to change, and two
    // ways is how they drift.
    ref.invalidate(meProvider);
    return true;
  }

  /// Back to idle — called when the student edits a field after a failure, so
  /// the stale error stops rendering under it.
  void clearError() {
    if (state.hasError) state = const AsyncData<StudentProfile?>(null);
  }
}

final editProfileProvider =
    AsyncNotifierProvider.autoDispose<EditProfileNotifier, StudentProfile?>(
  EditProfileNotifier.new,
);
