import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../models/profile_update.dart';
import '../models/student_profile.dart';
import '../profile_error_copy.dart';
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
///     · `422 name_not_allowed`→ the name field marked, like a `400` on it,
///                               and the name recorded so it is never sent
///                               again (see [isRefused])
///     · offline/network       → the offline line
///     · anything else         → the generic line
///
/// `autoDispose` because this is screen-scoped: leaving Edit Profile and coming
/// back must not land on a stale error from the previous attempt. [meProvider]
/// is the opposite — it is deliberately kept alive so tab switches cost no
/// request — and the two live at different lifetimes on purpose.
class EditProfileNotifier extends AsyncNotifier<StudentProfile?> {
  /// True once this notifier has been disposed — see [save].
  bool _disposed = false;

  /// Names the server refused with `422 name_not_allowed` on this visit to
  /// Edit Profile, as they were sent (trimmed, by [ProfileUpdate.diff]).
  ///
  /// The sign-up rule, applied here (O-17, owner 2026-10-11): a refused name is
  /// never sent again, because the same name only brings the same answer back.
  /// Kept here and not on any registration state; it lives and dies with this
  /// screen-scoped notifier, as sign-up's lives and dies with one registration.
  /// A new visit starts from the saved name, so nothing refused is on screen.
  final Set<String> _refusedNames = {};

  /// Was [name] refused on this visit? Compared trimmed, as it is sent, so
  /// spaces around a refused name never make it a new one. Null (the name is
  /// not part of the save) never is.
  bool isRefused(String? name) =>
      name != null && _refusedNames.contains(name.trim());

  @override
  FutureOr<StudentProfile?> build() {
    ref.onDispose(() => _disposed = true);
    // Sign-out's session reset invalidates this provider
    // (`invalidateSessionScope`), and a rebuild can keep this instance: one
    // student's typed names must never carry over to the next.
    _refusedNames.clear();
    return null;
  }

  /// Submits [update]. Returns true when the profile is saved (or when there
  /// was nothing to save), so the screen can decide to leave.
  ///
  /// Navigation stays in the widget layer; this never touches a router.
  Future<bool> save(ProfileUpdate update) async {
    if (state.isLoading) return false; // no double-submit

    // Nothing changed. Spending a round trip to tell the server so would flash
    // a spinner over a request whose response is the payload we already hold.
    if (update.isEmpty) return true;

    // A name the server already refused on this visit is not sent again, with
    // whatever else changed beside it: sending the rest without it would save
    // something other than what the student asked for. The refusal is stated
    // afresh, so Save shows it again even after an edit took it off.
    if (isRefused(update.name)) {
      state = AsyncError<StudentProfile?>(
        const ApiException(status: 422, code: 'name_not_allowed'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading<StudentProfile?>();
    final result = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).updateMe(update),
    );

    // This provider is autoDispose and screen-scoped, so leaving Edit Profile
    // mid-save disposes it while the PATCH is still in flight. The save has
    // already happened server-side; what is unsafe is touching this notifier
    // afterwards.
    //
    // Nothing below runs in that case — including `ref.invalidate`, because
    // `ref` is dead too, and invalidating through it would throw exactly like
    // the state assignment does. The cost is that `meProvider` keeps the
    // pre-edit profile until something else refreshes it. That is a real but
    // narrow staleness window (the student left the screen mid-request), and it
    // is strictly better than an unhandled exception. Widening it into a
    // guaranteed refresh would mean invalidating from a live ref — the screen's
    // or the router's — which is a larger change than this hazard justifies.
    if (_disposed) return !result.hasError;

    // Recorded before the outcome lands, so the screen that rebuilds on it
    // already knows the name is refused.
    final name = update.name;
    if (name != null && isProfileNameNotAllowed(result.error)) {
      _refusedNames.add(name.trim());
    }
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
      // Its build never fetches; the rule is uniform (project_rules_test).
      retry: (_, _) => null,
    );
