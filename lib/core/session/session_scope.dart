import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/notifier/login_notifier.dart';
import '../../features/auth/notifier/otp_notifier.dart';
import '../../features/catalog/notifier/subject_tree_notifier.dart';
import '../../features/catalog/notifier/subjects_notifier.dart';
import '../../features/mistakes/notifier/mistakes_notifiers.dart';
import '../../features/profile/notifier/edit_profile_notifier.dart';
import '../../features/profile/notifier/me_notifier.dart';
import '../../features/quiz/notifier/quiz_setup_notifier.dart';
import '../../features/registration/notifier/registration_controller.dart';
import '../../features/registration/notifier/registration_submit_notifier.dart';
import '../../features/registration/notifier/school_search_notifier.dart';

/// Drops every piece of state that belongs to ONE signed-in student.
///
/// **Why this exists.** `AuthController.logout` / `forceLogout` used to clear the
/// tokens and flip the auth state, and nothing else. Every provider below is
/// either non-`autoDispose` or can outlive its screen by a frame, so the values
/// survived the sign-out and were still in memory — and still rendered — when
/// the NEXT student signed in on the same handset. On the shared devices this
/// app is actually used on, that is one minor's name, level, points, school,
/// governorate and entitlements shown to another. (Tier-0 finding C-2.)
///
/// **Why it is one function and not scattered `ref.invalidate` calls.** The list
/// below IS the session inventory. Keeping it in one place means adding a new
/// user-scoped provider and forgetting to clear it is a one-line review catch
/// rather than an archaeology exercise across twelve features. The pattern
/// itself is the project's existing one — `edit_profile_notifier.dart:57`
/// invalidates `meProvider` after a successful `PATCH` for the same reason:
/// one source of truth, invalidated rather than written through.
/// `test/core/session/session_scope_discipline_test.dart` fails if a new
/// non-`autoDispose` notifier appears in `lib/features/` without being
/// classified here.
///
/// **What is deliberately NOT here.**
/// - `authControllerProvider` — this runs *from inside* it; invalidating the
///   provider mid-logout would tear down the notifier that is mid-teardown.
/// - `localeProvider`, `themeModeProvider` — device preferences, persisted on
///   purpose (`preferences_store.dart`: "a theme choice is not a secret, is not
///   personal data"). Language and canvas survive a sign-out by design.
/// - `deviceInfoProvider` and the `device_id` in secure storage — `forceLogout`
///   goes out of its way to preserve these, because wiping the device id makes
///   the next login look like a new device and mis-fires `session_superseded`
///   (Decisions_Log 2026-07-23).
/// - The seven reference providers in `reference_providers.dart` (countries,
///   governorates, cities, schools, education systems, universities, avatars) —
///   the same catalogue for every student, carrying no user data. Dropping them
///   would re-download the whole reference set on a metered Egyptian connection
///   to achieve nothing.
/// - Repositories, Dio, storage, connectivity, router, screen protection —
///   infrastructure, stateless with respect to who is signed in.
///
/// **Ordering.** Call this AFTER the auth state has flipped to
/// `AuthUnauthenticated`. Invalidating a provider that still has listeners makes
/// it rebuild, and a rebuild with no token in storage earns a 401 — which is
/// why `forceLogout` is idempotent. See the note there.
void invalidateSessionScope(Ref ref) {
  // --- Profile: the PII. -----------------------------------------------------
  ref.invalidate(meProvider); // name, phone, DOB, school, governorate
  ref.invalidate(entitlementsProvider); // what this student paid for
  ref.invalidate(editProfileProvider); // in-flight edits to the above

  // --- Catalogue: scoped to enrolment, never to entitlement (adr-091). --------
  ref.invalidate(subjectsProvider);
  ref.invalidate(subjectTreeProvider); // family — clears every subject id

  // --- Mistakes: a per-student answer history, and the most revealing of it. ---
  // `GET /me/mistakes` returns the subjects this student currently has wrong
  // answers in, with live counts. That is a record of what one named minor is
  // failing at — exactly the Tier-0 C-2 class of leak, and worse than the
  // catalogue, which is merely their cohort's syllabus. `mistakesOverviewProvider`
  // is non-autoDispose (it survives the drill-down deliberately), so it MUST be
  // dropped here. `mistakesTreeProvider` is autoDispose by design — the counts
  // decay on every read — but is invalidated anyway to close the frame-width
  // window where a forced logout lands while a tree is still mounted.
  ref.invalidate(mistakesOverviewProvider);
  ref.invalidate(mistakesTreeProvider); // family — clears every subject id

  // --- Auth surfaces that hold the phone number. ------------------------------
  ref.invalidate(loginProvider); // OtpRequestResult for a specific phone
  ref.invalidate(otpProvider); // family — per-phone OTP ui state

  // --- Registration: a minor's draft PII before an account exists. -------------
  // Scenario B of the Tier-0 brief. A forced logout mid-wizard (or an abandoned
  // wizard followed by a different student picking up the handset) must not
  // leave a half-filled draft — name, date of birth, school, governorate —
  // reachable. `registrationSubmitProvider` was NOT in the original finding and
  // was added by the inventory sweep: it is non-autoDispose and holds the
  // submission outcome.
  ref.invalidate(registrationControllerProvider);
  ref.invalidate(registrationSubmitProvider);
  ref.invalidate(schoolSearchProvider); // family — student's typed queries

  // --- Quiz. ------------------------------------------------------------------
  // autoDispose, so normally gone with its screen; invalidated anyway to close
  // the frame-width window where a forced logout lands while the setup sheet is
  // still mounted.
  ref.invalidate(quizSetupProvider);
}
