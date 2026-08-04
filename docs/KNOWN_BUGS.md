# Known bugs

Runtime defects found in built code. Distinct from `DESIGN_ISSUES.md`, which tracks
design ↔ contract gaps — everything here is our own code being wrong.

Format: what breaks · how to reproduce · root cause (`file:line`) · why tests missed it ·
the fix. Entries keep their history after being fixed — the "why tests missed it" note is
the point.

---

## BUG-001 ✅ The whole registration wizard red-screens on device

**Status:** FIXED 2026-07-27 (found 2026-07-26; the fix was deferred one day, then taken).

**What breaks:** verifying an OTP for a phone with no account (the `registrationRequired`
fork) navigates to `/register` and immediately paints Flutter's red ErrorWidget. Sign Up_1,
the track picker, and both Day-3 track-detail screens are therefore **unreachable on a real
device**. The `authenticated` fork (existing account → `/home`) is unaffected.

**Reproduce:** run the mock harness (`flutter run -t lib/main_mock.dart`), enter any valid
phone, then enter any 6-digit code OTHER than `000000`.

**Root cause (pre-fix code, kept for the record):**
`lib/features/registration/screens/signup_identity_screen.dart:52`

```dart
void initState() {
  super.initState();
  final args = widget.args;
  if (args != null) {
    ref.read(registrationControllerProvider.notifier).start(args); // ← illegal here
  }
```

`start()` assigns `state`, i.e. it MUTATES a provider. `initState` runs inside element
mount, which is part of the build phase, and Riverpod asserts on that:

```
Tried to modify a provider while the widget tree was building.
#10  RegistrationController.start          registration_controller.dart:29
#11  _SignupIdentityScreenState.initState  signup_identity_screen.dart:52
#13  ComponentElement.mount
...  (go_router Builder rebuild)
```

**Why 216 green tests missed it:** the assert only fires when the screen is mounted during a
*rebuild* of an existing tree — which is exactly what `context.go()` from the OTP screen
does. Every widget test pumps `SignupIdentityScreen` into a fresh `ProviderScope`, so it
mounts during the INITIAL build, where Riverpod's guard flag is not set. The bug is
invisible to direct-pump tests by construction; only router-driven navigation reaches it.

**Scope check (done):** this is the only offending line. `school_detail_screen.dart:54`,
`signup_track_screen.dart:33` and `login_screen.dart:52` all merely READ a provider in
`initState`, which is legal. `signup_track_screen.dart:39` writes, but from a tap callback.

**The fix (as proposed — the preferred option):** the seeding moved out of the widget
lifecycle entirely.

- `otp_screen.dart` — the `ref.listen` `registrationRequired` branch now builds the
  `RegistrationArgs` once, calls `start(args)`, *then* `context.go('/register', extra: args)`.
  A `ref.listen` callback runs outside the build phase, so mutating a provider there is legal.
- `signup_identity_screen.dart` — the `start(args)` call is gone from `initState`, which now
  only READS the draft for its pre-fill. `widget.args` is retained as the route payload (the
  router still passes `extra`) but is no longer what seeds the wizard; the doc comment says so.

**Rejected alternative:** deferring `start()` to `addPostFrameCallback`. One file instead of
two, but the first frame then has `draft == null`, so the expiry guard renders and
`RegistrationExpiredView` flashes before the form appears — a visible glitch traded for a
crash.

**Regression test:** `test/features/registration/registration_router_flow_test.dart` — two
cases driving login → OTP → `/register` → `/register/track` through the REAL `routerProvider`
and real `context.go`, asserting no `ErrorWidget`, that `SignupIdentityScreen` renders, that
the draft carries the token seeded at the OTP step, and that Continue reaches Choose Your
Track. Verified to actually bite: with both edits reverted it fails with the original
`Tried to modify a provider while the widget tree was building` at
`_SignupIdentityScreenState.initState`. Suite: 216 → 218 green, `flutter analyze` clean.

Two things this cost more than expected, worth knowing next time:

- `pumpAndSettle` is unusable from the OTP screen onward — the auto-focused Pinput blinks a
  cursor forever, so it times out. The test pumps a bounded 1s of frames instead.
- Reverting only the `initState` half does NOT reproduce the crash: `start()` is idempotent
  per token, so with the OTP seeding still in place the second call returns without assigning
  state. Both halves must be reverted to see the bug.

**Harness scaffolding removed with the fix:** the `START=school|university` deep-link block
and its `_MockRoot` wrapper in `lib/main_mock.dart` existed only to bypass this crash. The
wizard's front door works now, so they are gone; `lib/main_mock.dart` is back to the plain
`dioProvider` override plus `kResetSessionOnLaunch`.

---

## Note on how this was found

Found by walking the app on a Pixel 8 against the additive mock backend
(`lib/main_mock.dart` + `lib/dev/mock_backend.dart`). It had never surfaced because no
backend existed to return `registrationRequired` — the harness is what made the fork
reachable for the first time.
