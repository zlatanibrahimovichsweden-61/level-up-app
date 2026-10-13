# NNA — `name_not_allowed` built ahead of the pin (2026-10-10)

**Owner instruction:** "NEXT STEP — IMPLEMENT `name_not_allowed` SAFELY, THEN PREPARE THE NEXT SCREEN WAVE" (2026-10-10).
- **Authorised:** a narrowly scoped implementation ahead of the pinned 3.46.0-m1.
- **Constraints:**
  - No re-vendor and no new EN/AR copy; use the existing approved field-validation copy.
  - Keep the draft and the registration token on a refused name.
  - Separate the change by wave ownership; keep CW12a / O-14 intact.
  - No stage, commit or push.

**Answers O-11 in part.** It builds ahead of the pin; the re-vendor itself stays open.

**Change-set id:** NNA. It is its own unit, not CW02 and not CW12a.

**Verification level:** BUILD (widget and unit tests, a mutation run, the full gates). There was no device walk, no
TalkBack, no iOS, and no staging registration. The name filter must never be probed via registration on staging:
an unenforced filter would create an account (`staging-endpoint-coverage`).

## 1. Baseline (before any edit)

- **Repo:** `F:\level\level_up\level_up_app`, on branch `merged` @ `b227f61`, the same commit as `origin/merged`
  (0 / 0).
- **Working tree:**
  - status 115 lines (75 M, 40 ??), with 210 files in total
  - staged 0, stash 0
- **Last pass intact:**
  - Every one of the 210 files was byte-identical to the end-of-O-14 snapshot (`git hash-object --no-filters`).
  - The two exceptions are `COMPLETION_STATE.md` and `CW12a_FOLLOWUP_REPORT.md`, patched after that snapshot was
    taken.
  - So the O-14 copy and both CW12a fixes (the composer's lasting name, the closed bar's font) were intact.
- **Contract:** the upstream wording was read, not vendored. In `cc2a29d` (3.48.0-m1), both `completeRegistration`
  and `updateMyProfile` declare `422 name_not_allowed`. It is "checked after every `400`". For registration, "the
  registration token is not used … resubmit with the same token. Do not retry the same name". The response does not
  repeat the name.
- **Network layer:** a 422 with that code already arrives as a plain `ApiException(422, 'name_not_allowed')`
  (`error_interceptor.dart`), so no interceptor change was needed.

## 2. Architecture check, and one correction to §13.10

The previous note (`CW12a_FOLLOWUP_REPORT.md` §13.10) held, with one correction.

**Held:**
- **Draft:** it lives in `RegistrationController`, which is not auto-disposed. `start` is idempotent for the same
  token.
- **The return:** the wizard is a push stack, and `context.go('/register')` rebuilds the one-screen stack the OTP step
  left, with a null `extra` (the route accepts that).
- **Refill:** Sign Up_1 refills from the draft, and Track pre-selects from it. Every detail field drawn from the draft
  comes back.
- **Token:** it is untouched; the contract says a refused name does not use it.

**Correction (BUG-027).** "Every screen refills from the draft" is not true for one field. The School form keeps the
picked school's *name*, and the "I can't find my school" choice, in its own state. After any return they show the
search hint again.
- **Picked:** the id stays in the draft and is still sent.
- **Skipped:** the body is the same either way.
- **Evidence:** BUILD-reproduced by a probe in a throwaway copy, in four cases: picked or skipped, × leaving by the
  back chip or by the new return.
- **Not new:** the back chip has done this since Day 3 / `7fdc16b`.
- **Not fixed:** it would touch the draft model. Recorded as `docs/KNOWN_BUGS.md` BUG-027 for an owner decision.
- **Why the build went ahead:** this does not stop the authorised behaviour. No draft field and no token is lost; one
  field's label is.

**A hazard found and closed: the rejection must not outlive its registration.** The submit provider is not
auto-disposed, so a refused name would have marked the empty name field of the *next* registration.
- **Fix:** the outcome is now scoped to the token. When the token changes or the draft is dropped, it goes back to
  idle.
- **`listen`, not `watch`:** in Riverpod 3 a rebuild recreates the notifier, and the expiry view's "start again" can
  drop the draft mid-request. That would break an in-flight submit. An in-flight submit is left to land its own
  outcome. A mutation proves both halves.

## 3. What changed, by ownership

**NNA-owned changes:**

| File | State at HEAD | NNA change | Shares the file with |
| --- | --- | --- | --- |
| `lib/features/profile/profile_error_copy.dart` | clean | `rejectedFields` → `{'name'}`; banner → `errorValidationFailed` (`:23`, `:41`, `:52`) | — |
| `lib/features/profile/notifier/edit_profile_notifier.dart` | clean | one doc line (`:22`) | — |
| `lib/features/registration/registration_error_copy.dart` | clean | `isNameNotAllowed` (`:89`); banner → `errorValidationFailed` (`:24`); field issue → `name` (`:70`) | — |
| `lib/features/registration/notifier/registration_submit_notifier.dart` | clean | outcome scoped to its token (`:58-63`); doc line | — |
| `lib/features/registration/screens/school_detail_screen.dart` | CW02-dirty | listener branch → `/register` (`:379-388`); no banner for this code (`:288-292`) | CW02: import `@4`, return-target clear `@359` |
| `lib/features/registration/screens/university_detail_screen.dart` | CW02-dirty | the same (`:344-349`; `:275-278`) | CW02: import `@3`, clear `@325` |
| `lib/features/registration/screens/signup_identity_screen.dart` | O-15-dirty | 2 imports; `_clearNameRejection`; watch the rejection; mark the name field (`:93`, `:111`, `:126`, `:197-203`) | O-15: `_headerSlop`, padded back chip, gaps |
| `test/features/registration/registration_name_not_allowed_test.dart` | new | 28 tests | — |
| `test/features/profile/edit_profile_name_not_allowed_test.dart` | new | 10 tests | — |
| `docs/KNOWN_BUGS.md` | CW02-dirty (BUG-026) | BUG-027 appended | CW02: BUG-026 |

- **Not touched:** the ARBs and generated l10n, `contract/`, `pubspec.*`, the network layer, guards and tools, every
  CW07a, CW12a, O-14 and N-26 file, and the Edit Profile screen itself (`edit_profile_screen.dart` is O-15-dirty and
  needed nothing).
- **Hunk separation:**
  - **School / University:** the NNA hunks are their own hunks, apart from CW02's.
  - **Sign Up_1:** five hunks are separate. The two import lines sit two unchanged lines above O-15's first hunk, so
    they show as one hunk that `git add -p` can split with `s`.
  - **`KNOWN_BUGS.md`:** BUG-027 follows CW02's BUG-026 directly, so that hunk needs the patch below.
- **Exact separation record:**
  - `nna_prewave/` holds pre-edit copies of all nine edited files plus `SHA_LIST.txt` and `TAKEN_AT.txt`.
  - `nna_prewave/NNA_CHANGESET.patch` is the whole change set against those copies.
  - Applied to the copies in a scratch tree, the patch rebuilds all ten files with content identical to the working
    tree. Line endings come out LF, as git stores them; the working tree is CRLF.
  - To commit NNA on its own: commit CW02 and O-15 first, then apply the patch.
- **Commit order when asked:** N-26 → CW02 → CW07a → CW12a → O-15 → **NNA**.

## 4. Behaviour

**Edit Profile (`PATCH /me`).** On a refused name:
- The name field is marked (`hasError`) with the approved "Please check this field" / «من فضلك تحقق من هذا الحقل».
- The banner reads the approved validation line, "Please check your input and try again." / «من فضلك تحقق من بياناتك
  وحاول مرة أخرى.», not "Something went wrong".
- The typed name stays and the screen stays.
- Editing the name clears both.
- Before: the generic line, no field marked (BUILD-reproduced in the second pass).

**Sign-up, School and University (`POST /auth/register`).** On a refused name:
- The detail screen's listener goes to `/register`. The detail form slides back without a banner of its own; the
  restart errors were already excluded from it the same way.
- Sign Up_1 shows the refused name, the field marked, with "Please check this field".
- The whole draft is unchanged, token and deadline included, and nothing is resent.
- Editing the name, or tapping Continue, takes the mark off.
- Going forward, Track is pre-selected, every draft-drawn detail field is filled (BUG-027 aside), and there is no stale
  banner. Start learning sends the corrected name with the **same token**.
- **Unrelated failures unchanged:** 500, a 422 with another code, and a 400 `validation_failed` stay on the detail
  screen with their existing banners; a 401 `registration_token_invalid` still restarts at `/login`.

**Copy.** No new key; the ARBs are unchanged. Reused: `fieldRejected`, `errorValidationFailed`.

**Not resent on its own.** One request per tap. A student who taps Start learning again with the same name sends it
again (one request) and is returned again. Blocking a resend of the unchanged name would be a new client rule; it is
listed in §8.

## 5. Tests added (38)

**`registration_name_not_allowed_test.dart` (28).** It runs on the app's real `routerProvider` with real taps.
- For School and University, each in EN and AR:
  - **the return:** location `/register`, the line under the name, the field marked, no generic line or snackbar, RTL
    in AR, the field still holds the refused name, the draft `==` before, the token unchanged, one request and none
    after 30 s
  - **the corrected retry:** the mark comes off on edit; Track then the detail form, filled with no banner; two
    bodies, the same token, the old then the new name; for School the `schoolId` is resent
- For School and University, EN only:
  - **Continue with the name unchanged:** the mark comes off, no stale banner, nothing sent until a tap; one request
    per tap
  - **no banner during the transition:** checked frame by frame
  - **other failures:** 500, another 422, a 400 and a 401 restart, all unchanged
- One test that a fresh registration (a new token) does not inherit the mark.
- Notifier: per track, a typed error, one request, the draft and token intact, and a same-token retry; a new token or
  a dropped draft resets an idle outcome; an in-flight submit is left alone.
- Mapping: EN / AR; it matches the code, not the status, and is not a restart.

**`edit_profile_name_not_allowed_test.dart` (10).**
- Per language: marked with the approved line, the banner the validation line, the text kept, one request with
  `{name}` only and none after 30 s; editing clears it.
- One request per tap.
- Other failures keep the generic line.
- Mapper unit tests.

**Mutation run** (throwaway copy; the repo untouched). The unmutated copy passes **36 / 36** before and after; the two
banner mutations were checked against the 28-test file. **15 / 15 mutations caught:**

| Mutation | Failing tests |
| --- | --- |
| School no return | 6 |
| University no return | 5 |
| Sign Up_1 never marks | 11 |
| No clear on edit | 4 |
| No clear on Continue | 2 |
| Outcome not token-scoped | 4 |
| No in-flight guard | 1 |
| `watch` instead of `listen` | 1 |
| Registration banner generic | 2 |
| No field issue | 2 |
| Predicate on status, not code | 3 |
| Profile field not marked | 5 |
| Profile banner generic | 4 |
| School banner flash | 1 |
| University banner flash | 1 |

**Neighbouring suites:** registration + profile + auth + session, **591 / 0** (run before the banner change; the full
gate below covers everything after it).

## 6. CW12a / O-14 untouched

Not one CW12a, O-14 or support file changed in this pass (§3). The support suite and the O-15 suite were re-run in
§7.

## 7. Validation (fresh runs, 2026-10-10)

| Check | Exit | Result |
| --- | --- | --- |
| `validate.sh` (16:07:23–16:10:40Z, `LEVELUP_VALIDATE_OUT` to scratch) | 0 | **3063 passed / 0 failed / 0 skipped**, OVERALL PASS; format 326 files, 0 changed; analyze 0 issues |
| `validate.ps1` (16:10:41–16:13:32Z, to scratch) | 0 | **3063 / 0 / 0**, OVERALL PASS; format 326 / 0; analyze 0 |
| `flutter gen-l10n` | 0 | no drift: the 2 ARBs and 3 generated files are byte-identical before and after. The ARBs and `app_localizations.dart` equal the end-of-O-14 snapshot |
| Guards (`test/guards`) | 0 | 124 |
| `contract_models_test` / `contract_pin_test` | 0 / 0 | 14 / 2 |
| Support suite (`test/features/support`) | 0 | 472, unchanged from O-14 |
| O-15 five-file suite | 0 | 125, unchanged |
| NNA tests alone | 0 | 38 |
| Registration + profile + auth + session | 0 | 593 (the earlier 591 + the 2 banner tests) |
| `git diff --check` | 0 | clean |
| Tracked `.ai/audits/current/test-results.md` | — | unchanged, blob `57716a44` |

- **Counts:** 3063 = 3025 (the O-14 gate) + 38. The new tests appear by name in both result records.
- **One comment-only edit landed between the two scripts.** The School listener comment's mention of BUG-027 was
  saved at 16:10:32Z. That is after `validate.sh` had compiled the tests and before `validate.ps1` started, so the
  PowerShell run covers the final code.
- **Later edits were records only:** this report, `CW04a_BRIEF.md` and `COMPLETION_STATE.md`. No guard reads them.
- **Not done:** Pixel 8, iOS, TalkBack, Figma, staging. Store readiness was not re-scored.

## 8. Risks, limits and open decisions

1. **BUG-027:** the School picker's chosen name or skip is not re-shown after a return (§2). It is pre-existing, and
   the data is right. The fix touches the draft model and needs an owner OK.
2. **Same-name resend:** the client does not block it; each resend is the student's own tap. The contract says "do not
   retry the same name", which the app honours (no automatic resend). A client-side block would be a new rule.
   Owner call.
3. **Screen reader:** after the return, focus and announcements are Flutter's defaults. The error is an inline line
   under the field, with no live announcement. Not checked with TalkBack or VoiceOver.
4. **Sign Up_1 inconsistency:** the existing pre-flight "Please enter your name" still draws no red border; the refused
   name does. This is pre-existing, and the border was not added for the pre-flight case (not in scope).
5. **Ahead of the pin:** the comments cite upstream 3.47.0-m1 text that is not vendored. When O-11 re-vendors,
   re-read the wording. `contract/` and its pin guard are unchanged.
6. **No mock trigger:** the mock backend never answers `name_not_allowed`, so an AVD walk cannot show this without a
   mock change. None was made.
7. **Not verified:** staging registration (never probe it), DEVICE, iOS, TalkBack. The Edit Profile refusal is known
   to be enforced on staging (second pass, API level); this pass did not re-run it.

## 9. Git state at hand-back

- **Branch:** `merged` @ `b227f61`, level with `origin/merged` (0 / 0). Staged 0, stash 0.
- **Not done:** nothing committed, pushed, merged, rebased, amended, reset, stashed or cleaned. Nothing was sent to
  Seif or the designer.
- **Status:** 115 → **124 lines** (79 M, 45 ??).
  - **Newly modified (were clean at HEAD):** `profile_error_copy.dart`, `edit_profile_notifier.dart`,
    `registration_error_copy.dart`, `registration_submit_notifier.dart`.
  - **New untracked:**
    - `test/features/registration/registration_name_not_allowed_test.dart`
    - `test/features/profile/edit_profile_name_not_allowed_test.dart`
    - this report
    - `CW04a_BRIEF.md`
    - `nna_prewave/`
  - **Already modified, now also carrying NNA hunks:** `school_detail_screen.dart`, `university_detail_screen.dart`
    (CW02), `signup_identity_screen.dart` (O-15), `docs/KNOWN_BUGS.md` (CW02), `COMPLETION_STATE.md`.
- **Untouched:** `contract/`, `pubspec.*`, the ARBs and generated l10n, guards, tools, and every CW07a / CW12a / O-14 /
  N-26 file.

## 10. Follow-ups after the owner accepted NNA (2026-10-10, second pass)

**Owner instruction:** "NEXT STEP — ACCEPT NNA, CLOSE BUG-027, AND IMPLEMENT CW04a LEGAL DOCUMENT VIEWER". The owner
**accepts** NNA as built (§1–§9) and authorises two follow-ups, still change set NNA (not CW02, not CW12a). Pre-edit
copies of every file touched: `nna2_prewave/` (blob ids in `SHA_LIST.txt`, taken 2026-10-10T18:47:59Z).

### 10.1 BUG-027 fixed — the School picker keeps the picked school

- **Before:** the chosen row and the skip lived in `_SchoolDetailScreenState`, so leaving the form (back chip, or the
  NNA return to Sign Up_1) and coming back showed the search hint while the draft still held — and sent — the id.
- **After:** `RegistrationDraft` carries `pickedSchool` (the row: id and both names) and `schoolSkipped` beside
  `schoolId`; `RegistrationController.setSchool(id, row:)` and `skipSchool()` set them, and every setter that drops the
  id (a new country, governorate, city or typed city) drops all three. The School form reads the field from the
  draft. Only the id is ever submitted (pinned). `registration_draft.freezed.dart` regenerated in a throwaway copy
  with the repo's generator (diff = the new fields only) and copied back.
- **Behaviour changes, both toward what is sent:** re-picking the same country/governorate/city no longer blanks the
  field (it used to hide a school that was still sent); a new governorate now drops a skip too (it already dropped the
  city the skip was about).
- **University:** no equivalent defect — its selections were already drawn from the draft's ids; a test now leaves
  and returns to prove it.
- **Records:** `docs/KNOWN_BUGS.md` BUG-027 → FIXED (2026-10-10).

### 10.2 A refused name is never sent again

- **Rule (owner):** after `422 name_not_allowed`, the same name is not sent again; the mark clears only when the name
  is changed to a different value; revisiting Sign Up_1 or tapping Continue does not clear it; a corrected name goes
  with the same token; no automatic retry; no new copy.
- **How:** the draft records the names refused during THIS registration (`refusedNames`, recorded by the submit
  notifier on the draft of the token it submitted with — a refusal that lands after the draft was replaced is
  recorded on no one).
  - **Sign Up_1** marks the field ("Please check this field", existing `fieldRejected`) whenever its trimmed text —
    exactly what would be sent — is a refused name: a different name clears the mark, typing the refused one back
    restores it, re-mounting the screen keeps it. **Continue does nothing** while the name is refused.
  - **The submit** does not send a refused name; it restates the server's own answer (as the expiry check does for a
    dead token), afresh on every tap, so the detail screen that is showing sends the student back to Sign Up_1 — even
    one re-entered after the refusal landed while the student had already backed out (review finding, fixed: §10.4).
- **Edit Profile is unchanged:** the instruction is about Continue / Start learning; Edit Profile still marks the
  refused name and clears the mark on any edit, and Save with the unchanged name sends again (one request per tap).
  Extending the rule there is an owner call.

### 10.3 Tests and mutation run

- `registration_name_not_allowed_test.dart`: 28 → **35** — refusal records the name (draft otherwise unchanged);
  Continue with the unchanged name (and with spaces around it) stays on Sign Up_1, marked, both tracks × EN/AR;
  re-mount keeps the mark; a genuine edit clears it, typing the refused name back restores it, the corrected name is
  sent once with the same token; the notifier sends nothing for a refused name (also after the outcome was cleared)
  and restates the refusal; a refusal landing after the draft was replaced is recorded on no one; the record is
  per-token and de-duplicated; the back-out-in-flight case (both tracks).
- `school_pick_survives_return_test.dart` (new): **16** — see BUG-027.
- **Mutation run** (throwaway copy, 4 files / 109 tests): **18 / 18 caught** — school_selected_local 6,
  school_skipped_local 3, controller_no_row 7, controller_city_keeps_row 2, controller_governorate_keeps_skip 1,
  controller_skip_keeps_row 1, notifier_no_block 3, notifier_no_record 18, notifier_always_resynth 2 (now the
  intended behaviour, §10.4), refuse_any_token 2, signup_no_block 4, signup_mark_untrimmed 4, signup_no_rederive 4,
  signup_no_mark 15, school_no_return 10, university_no_return 7, notifier_no_scope 4, notifier_no_loading_guard 1.

### 10.4 Independent review

A read-only Sonnet review (4 reviewers + 1 verifier, run with CW04a) found one NNA defect, now fixed: if the student
backed out of the detail screen while the submit was in flight and the refusal landed afterwards, Start learning on the
re-entered screen did nothing (the unchanged error state notified no one). The submit now restates the refusal on every
tap; +2 tests (one per track).

### 10.5 Validation

Gated together with CW04a (`CW04a_REPORT.md` §6, fresh runs on the final code): `validate.sh` (20:11:41–20:17:04Z) and `validate.ps1` (20:17:04–20:22:15Z) both exit 0, **3168 passed / 0 failed / 0 skipped**, OVERALL PASS, format 0 changed, analyze 0; guards 124; contract 14 / 2; `gen-l10n` no drift; support 472 and the O-15 five-file suite 125, both unchanged; `git diff --check` clean; the tracked `test-results.md` unchanged (`57716a44`). The NNA suites alone: refusal 35, school pick 16. A one-mutation check of the §10.4 fix (restore the old "already showing" guard) fails 4 tests; the restored copy passes 35.

### 10.6 Still open / not done

- Edit Profile same-name resend (owner call, §10.2) — approved and built as O-17 on 2026-10-11, §11. TalkBack announcement of the mark (none; inline line only).
- Not verified: staging registration (never probe), Pixel 8, iOS, TalkBack. The mock backend still has no
  `name_not_allowed` trigger, so an AVD walk cannot show it.
- Commit order when asked: N-26 → CW02 → CW07a → CW12a → O-15 → NNA → CW04a. NNA's hunks in
  `school_detail_screen.dart` (CW02) and `signup_identity_screen.dart` (O-15) stay separable against `nna_prewave/` and
  `nna2_prewave/`.

## 11. O-17 — the refused-name rule on Edit Profile (2026-10-11, owner-approved)

The owner's instruction "Level Up — Safe Follow-up: O-17, Final Focused Review, and Designer Handoff" approved O-17:
apply the sign-up rule (§10.2) to Edit Profile. Built in the same change set (NNA), uncommitted.

### 11.1 Behaviour

- A `422 name_not_allowed` on `PATCH /me` records the name **as it was sent**: trimmed by `ProfileUpdate.diff`, then
  compared exactly, the same rule as sign-up (`signup_identity_screen.dart` `_isRefused`). The command trims again
  when it records and when it checks, so the rule does not depend on the caller.
- **Save with that name sends nothing.** The command states the refusal again as a fresh `AsyncError`, which brings
  back the existing banner ("Please check your input and try again.") and the field line ("Please check this field").
  The screen stays. Spaces around the name make no difference.
- **The whole save is held back** while the box holds the refused name, even if the email or avatar changed too.
  Sending the rest without the name would save something other than what the student asked for. If the name goes back
  to the saved one, the name leaves the body and the rest goes out as before.
- **The mark follows the box.** Any edit clears the banner, as before. The field stays marked while the trimmed name
  is a refused one. A different name takes the mark off, and typing the refused name back brings it back. A name
  changed while the refused save was still in flight is **not** marked (review finding, §11.3). A `400` on the name
  still marks it from the error, as before.
- **Other failures are not remembered:** `500`, another `422` code, a `400` on the name and offline all keep their
  existing lines, and Save sends again. A save without a name is never held back.
- **Scope: one visit.** The record lives on the screen-scoped (`autoDispose`) `EditProfileNotifier`, not on any
  registration state. Leaving Edit Profile drops it; a new visit starts from the saved name, unmarked. The record is
  also emptied when sign-out's `invalidateSessionScope` rebuilds the provider, so one student's typed names never
  reach the next. A refusal that lands after the student left touches nothing (the notifier's existing `_disposed`
  guard).
- **No new copy;** registration is unchanged.

**Owner note (not blocking):** within one visit the same name is never sent twice. On a **new** visit, retyping a
name refused on an earlier visit sends it once more, and it is then held for that visit. Holding it across visits
would need a session-scoped provider cleared in `invalidateSessionScope` (`lib/core/session/session_scope.dart`,
CW02-dirty). That touches another wave's file and keeps a minor's typed names for the whole session, so it was not
built without a decision.

**Owner direction, 2026-10-11 checkpoint:** O-17 stays **implemented, not closed**. The record keeps exactly the lifetime built here: **one Edit Profile visit**, emptied on **sign-out**. It is not to be extended (no session-scoped, persisted or cross-visit record) without the owner's decision.

### 11.2 Files (NNA change set)

| File | Change |
| --- | --- |
| `lib/features/profile/notifier/edit_profile_notifier.dart` | `_refusedNames`, `isRefused` (trimmed), the hold and the restated refusal in `save`, recording after the `_disposed` check, emptied in `build` |
| `lib/features/profile/profile_error_copy.dart` | `_isNameNotAllowed` made public as `isProfileNameNotAllowed`; the name avoids sign-up's `isNameNotAllowed` |
| `lib/features/profile/screens/edit_profile_screen.dart` | `nameRejected`: the record for the name that would be sent, or a non-refusal `400` on the name |
| `test/features/profile/edit_profile_name_not_allowed_test.dart` | 10 → 35 tests |

Pre-edit copies: `o17_prewave/` (with `SHA_LIST.txt`, `TAKEN_AT.txt` 2026-10-10T22:03:11Z).

### 11.3 Tests, mutation run, review

The 26 new tests (one replaces the old resend test) cover:
- EN and AR: Save again sends nothing and stays; spaces around the name; a different name is sent once and its
  success returns to the hub (`/me` re-read); the refused name typed back is marked and not sent.
- The refused name holds back an email change, and the email goes out once the name is back to the saved one.
- Other failures are not remembered (4 kinds).
- Two taps while a save is in flight send once, and the refusal that lands then holds.
- A name changed while the refused save was in flight is not marked, and is sent.
- Leaving mid-save: the late refusal touches nothing, and the next visit starts clean.
- Leaving after a refusal, then coming back.
- Command level:
  - the record, the restatement with other fields beside the name, and a save without the name;
  - trimming on both sides, and other failures recording nothing;
  - the real `invalidateSessionScope` emptying the record.

The old test "a second tap sends again" pinned the pre-O-17 behaviour and is replaced.

**Mutation run** (throwaway copy): 12 of 12 caught.

| Mutant | Failures |
| --- | --- |
| no hold | 12 |
| no record | 20 |
| record any error | 7 |
| no restatement | 6 |
| drop the name and send the rest | 10 |
| mark from the error only | 6 |
| mark from the error too | 1 |
| command untrimmed, check side | 1 |
| command untrimmed, record side | 1 |
| no clear in `build` | 1 |
| copy: no field | 1 |
| copy: any 422 | 5 |

The restored copy passes 35 / 35.

**Independent review** (a read-only Sonnet reviewer, verified by running). Confirmed fixed with tests:
- **Medium:** a name typed during the refused save was marked once the refusal landed. Fixed: a refusal's mark comes
  from the record, never from the error alone.
- **Low:** the trim lived only in `ProfileUpdate.diff`. Fixed: the command trims too.
- **Low:** the record survived an invalidation of the provider. Fixed: emptied in `build`.

Not changed:
- **Per-visit scope:** the owner's call, §11.1.
- **A latent issue older than O-17:** after an invalidation that keeps the instance, `_disposed` stays true and a later
  save would never settle. The only invalidation is at sign-out, which unmounts the screen. Not user-reachable; recorded.
- **Hypothetical:** a `422 name_not_allowed` on a save that carries no name marks nothing and is not recorded. The
  contract ties the code to a new or changed name.

### 11.4 Focused re-check of the NNA follow-ups (2026-10-11)

A read-only Sonnet reviewer re-verified §10 in the current tree.
- **All six claims hold:**
  - the school name and the skip survive leaving and coming back;
  - only `schoolId` reaches the body;
  - a refused name is not resubmitted, from Continue or from Start learning;
  - the in-flight refusal returns to `/register`, marked, with no second request;
  - University and the token are intact;
  - a geography change drops the pick, and the same value keeps it.
- **Test files:** refusal 35 / 35, school pick 16 / 16.
- **Mutation checks:** 17 of 17 caught.

Two low findings, recorded and not changed (NNA is accepted; no wrong request is sent and no refusal is lost):
1. **A late refusal can bounce an open detail screen once.** Start learning with name A, back out, change to B,
   Continue to the detail screen. A's refusal then lands and sends the student to Sign Up 1, where B is unmarked.
   Continue goes on normally. No test covers the open-detail-screen case.
2. **A free-text city has no same-value shortcut.** Retyping the same free-text city, or a trailing space, still
   drops the picked school and the skip. This is not a regression: the old code cleared `schoolId` there too.

### 11.5 Validation (fresh runs on the final code, 2026-10-10 UTC)

| Check | Exit | Result |
| --- | --- | --- |
| `validate.sh` (22:39:12–22:43:54Z, `LEVELUP_VALIDATE_OUT` in the scratchpad) | 0 | **3193 passed / 0 failed / 0 skipped**, OVERALL PASS; format PASS; analyze 0 issues |
| `validate.ps1` (22:43:54–22:48:20Z, same) | 0 | **3193 / 0 / 0**, OVERALL PASS |
| Count | — | 3193 = 3168 (last gate) + 25 (O-17: 35 tests replace 10) |
| `flutter gen-l10n` | 0 | no drift: the five l10n files byte-identical before and after (`ae66b44c`, `8c6f3f89`, `9795a74d`, `84085641`, `5e18a63e`) |
| Guards (`test/guards`) | 0 | 124 |
| `contract_models_test` + `contract_pin_test` | 0 | 16 (14 + 2); `contract/` untouched, pin 3.46.0-m1 (`eddb6ac`) |
| O-17 file / profile suite (after the review fixes) | 0 | 35 / 234 |
| NNA refusal / school pick / registration suite | 0 | 35 / 16 / 291 |
| Legal (viewer + routes + repository) / mock legal | 0 | 84 (47 + 14 + 23) / 5 |
| Support / O-15 five-file suite / shell screens | 0 | 472 / 125 / 13 |
| `dart format` on the 85 untracked `.dart` files (80 + this pass's 5 backup copies in `o17_prewave/`) | 0 | 0 changed |
| `git diff --check` | 0 | clean |
| Tracked `test-results.md` | — | unchanged: raw blob `57716a44`, mtime 2026-10-09T15:42:45Z |

The targeted non-profile suites ran before the last profile-only fix; the two full gates ran on the final code.
`pubspec.yaml` / `pubspec.lock` are unchanged in this pass; the lock still differs from HEAD by CW04a's two packages
only (+16), and both validate scripts still flag it until they are committed together.

**Not verified:** Pixel 8, iOS, TalkBack, an emulator walk and staging. The mock backend has no `name_not_allowed`
trigger, and the name filter is never probed on staging. Figma was not opened.
