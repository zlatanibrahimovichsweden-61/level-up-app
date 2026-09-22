# Part 15 — Entitlement / subscription / redemption architecture (Wave 2-C, Opus) — 2026-09-22

**HEAD** `bf967d6` · contract pin `768e67d` (3.22.0-m1) · **read-only**: no repo file outside this
one was created, edited or deleted.

**Authoritative inputs, read in full this session:**
`C:\Users\musta\Downloads\flutter-partner-web-redemption-warning-v3.md` (adr-171 + spec-036, FINAL
2026-09-16) · `parts/05_api_backend.md` · `parts/12_policy_gap_analysis.md` §§POL-01, POL-02, POL-04,
POL-12 · `parts/10_frontend_gaps_edge_cases.md` §1 and FE-24 · `parts/01_frontend.md` FE-08 ·
`../store_readiness_state.md` §REDEMPTION STATUS.

**Verification levels.** SOURCE = read at HEAD in this repo this session · PUB = read from the pub
cache at `C:\Users\musta\AppData\Local\Pub\Cache\hosted\pub.dev\` this session · PARTS = taken from a
prior part file and re-checked at source where cited · POLICY = quoted from parts 08/09/12, which
re-fetched the official pages on 2026-09-22 · UNVERIFIED = flagged inline. **Nothing here is BUILD,
ARTEFACT or DEVICE level.** No app was compiled, run, or observed on a handset for this part.

**Scope note.** This part covers entitlement state and the redemption journey only. Account deletion
appears exactly twice — once as an entitlement-lifecycle transition (§1.7) and once as a vocabulary
collision (§4) — because both touch entitlement copy. POL-04 owns account deletion itself.

---

## 0. Headline

Three things are true at once and the report keeps them separate:

1. **The entitlement lifecycle is correct by construction and invisible by accident.** Every gate in
   the app is a server `403` at call time, so a web redemption is honoured on the student's very next
   request with no client work at all. **Stale entitlement state cannot reach a screen today, for the
   single reason that no screen reads entitlement state** (§1). That is a genuinely strong posture,
   and it is the whole of the app's Apple 3.1.1 defence (POL-01).
2. **adr-171 §4's central factual claim about this repo is false.** "The app already refetches
   `GET /me/entitlements` on foreground/resume" is not true at HEAD and has never been true:
   `entitlementsProvider` has zero `watch`/`read` consumers, Riverpod providers are lazy, so
   `build()` — and with it the only `AppLifecycleListener` in the entire codebase — never runs (§2).
   The partner has been told to "just make sure the existing refetch runs"; there is no existing
   refetch to make sure of. This must go back to Seif as a correction, not be silently built.
3. **The moment a subscription area exists, four latent defects become visible at once** — a
   resume-refetch that discards last-known state on failure (ENT-04), two entitlement sources that
   diverge after the first resume (ENT-03), a 2-day grace window that renders as plain "active"
   unless the screen branches on `inGrace` (ENT-05), and — the one nobody has listed —
   **`LaunchMode.inAppBrowserView` silently falling back to an embedded WebView on Android**, which
   is precisely the thing adr-171 §2 marks 🔴 and Play's Payments policy names first (RED-01).

---

## 1. Full lifecycle trace at HEAD — student → entitlement → backend → API → Flutter

### 1.0 The two sources, and what each is for

| Source | Contract | App |
|---|---|---|
| `StudentProfile.entitlements` | `openapi.yaml:2425-2428` — "Read-only embed for **first paint**; the entitlement-state source of truth is GET /me/entitlements". It is in `required` (`:2439`), so it is always present, possibly `[]`. | Parsed into `List<EntitlementState>` (`lib/features/profile/models/student_profile.dart:61-62`), carried on `meProvider`. **Read by no screen.** |
| `GET /me/entitlements` | `openapi.yaml:1065-1090` — stable, `getMyEntitlements`, "**Refetch on app resume. There is no `pending` state — an entitlement is active or it isn't.** Also embedded read-only in GET /me for first paint. Types are additively extensible." Returns `{items: EntitlementState[]}`, `items` required. | `ProfileRepository.getEntitlements()` (`profile_repository.dart:78-93`) → `EntitlementsNotifier` (`me_notifier.dart:55-78`). **Read by no screen and by no other provider.** |

`EntitlementState` (`openapi.yaml:2444-2451`): `type` (`EntitlementType`, `:2440-2443`, enum
`[baseSubscription, flashcardSubscription]`, "Extensible set (adr-018) — clients must tolerate
unknown values additively"), `active: bool`, `expiresAt: [string,null]`, `inGrace: bool` ("2-day
grace after expiry (requirements §5)"), `graceEndsAt: [string,null]`. Required: `[type, active,
inGrace]`. The Dart model mirrors this exactly (`entitlement_state.dart:26-37`) — see ENT-08 for the
unknown-value handling, which is correct.

### 1.1 Login → first paint

`POST /auth/otp/verify` → `AuthenticatedResult.profile` → `StudentProfile.fromJson` →
`entitlements` parsed. Nothing reads it. The student lands on Home, which renders from `meProvider`
only (`me_notifier_test.dart:144-146` asserts exactly this: "A failed paywall check must not take the
whole screen down").

**Stale on screen? No — nothing is on screen.** Correct by accident, not by design.

### 1.2 Cold start on an existing session

`meProvider.build()` → `getMe()` (`me_notifier.dart:19-20`). There is no disk cache for the profile,
no hydration layer, no `SharedPreferences` copy — `grep` for a persisted profile returns nothing; the
only persisted items are tokens, `device_id`, theme and locale (`secure_storage.dart`,
`preferences_store.dart`, corroborated by part 07's 20-row data map). So **every cold start is a live
server read** and first paint is always fresh.

This is the answer to the cold-start half of the adr-171 §4 question (§2.4 below): a web redemption
that happens while the app is **killed** is picked up correctly, because the next launch re-reads
`/me` from the network. The resume-refetch gap is a *warm-process* gap only.

### 1.3 Resume / foreground

**Nothing happens.** `grep -rn "AppLifecycleListener|didChangeAppLifecycleState|WidgetsBindingObserver|AppLifecycleState" lib`
returns **exactly one line** — `me_notifier.dart:58`, inside `EntitlementsNotifier.build()`, which
never executes (§2). `meProvider` has no resume refresh either (part 05 API-06; re-confirmed: its
only refresh triggers are `home_screen.dart:57` retry, `edit_profile_notifier.dart:79` after
`PATCH /me`, and `quiz_screen.dart:231` after `finishQuiz`).

**Stale on screen? Today no** (nothing reads it). **Tomorrow yes** — this is the single transition
that ENT-01 makes dangerous.

### 1.4 Gating — the three `403`s

Gating is entirely server-authoritative at call time. The app never asks "am I subscribed?" before
acting; it acts and reads the refusal.

| Code | Where the contract raises it | Where the app handles it |
|---|---|---|
| `subscription_required` | `createQuiz` (`openapi.yaml:1455`), `getExplanation` (`:1629-1632`) | `quiz_setup_notifier.dart:26` doc-contract → `LimitSheet.show` → `limit_sheet.dart:64` branches `code == 'subscription_required'` vs weekly limit; `quiz_error_copy.dart:18-20,51-52` |
| `weekly_question_limit_reached` | `createQuiz` (`:1813-1814`); `error-codes.md:30` "Free-plan 50 questions/week exhausted … the allowance resets at the start of the next week (requirements §3)" | same sheet, `freeUsageReachedTitle` / `weeklyLimitBody` |
| `flashcard_subscription_required` | `getFlashcardsForLecture` (`:1803`), University-only; free preview is *truncated*, not refused (`:1746-1749`) | `flashcards_repository.dart:40-64` documents the `hasMore`-not-`items.length` rule; `lecture_flashcards_notifier.dart:41` states an empty page never means exhausted allowance. **No flashcard screen exists yet** — `lib/features/flashcards/` has a notifier and repository and no `screens/` consumer, so this `403` currently has no rendering path. |

**Why this design is the right one and must survive the subscription area.** Because the gate is a
live refusal, a redemption performed on the website is honoured on the student's *next request*,
regardless of what any provider holds. Even a maximally stale entitlement display cannot lock a
student out of content they have paid for. Any future "check entitlement, then enable the button"
optimisation would invert that and is forbidden by CLAUDE.md's server-authoritative rule.

### 1.5 Expiry and the 2-day grace

Purely server-side. `active` and `inGrace` are independent booleans; the contract nowhere states
their relationship during grace, and **the app must not infer one** (ENT-05). `expiresAt` and
`graceEndsAt` are nullable and are display-only; nothing in `lib/` compares them to
`DateTime.now()` — `grep` for `expiresAt`/`graceEndsAt` outside the model and generated files returns
nothing. That is correct and must stay that way: a client-side clock comparison is a
compute-entitlement-client-side violation, and Egyptian handsets with a wrong clock would
self-lock or self-unlock.

**Stale on screen? Today no.** Once a screen exists, the grace window is the *most* stale-prone
state in the system, because it is the only one that changes without any student action and without
any request being made (§6, ENT-05).

### 1.6 Logout, forced logout, account switch

`AuthController.logout()` (`auth_controller.dart:75-85`): best-effort `POST /auth/logout` →
`clearTokens()` (deliberately **not** `clear()`, so `device_id` survives — `secure_storage.dart:56-64`)
→ state flips → `invalidateSessionScope(ref)`.
`forceLogout(reason)` (`:67-72`): idempotent, same sweep, no server call.
`invalidateSessionScope` invalidates `entitlementsProvider` explicitly
(`session_scope.dart:61`, comment "what this student paid for") alongside `meProvider` and eleven
other user-scoped providers.

`test/core/session/session_isolation_test.dart:155-163` proves the entitlement list does not survive
into the next student's session — and is, with `me_notifier_test.dart:121-170`, one of only two
places in the repo where `entitlementsProvider` is read at all.

**Stale on screen? No, in either direction.** Cross-student leakage — the Tier-0 C-2 class of bug
this sweep was written for — is closed for entitlements. **This is the one transition that is already
correct for a future subscription area and needs no new work.**

### 1.7 Account deletion grace, and reinstall

- **Deletion request.** `POST /me/deletion-request` → `202`, which "is the last thing that token
  does" (`openapi.yaml:1006-1009`). During the 30-day window every authenticated endpoint outside a
  four-endpoint allowlist answers `403 account_pending_deletion` — and `getMyEntitlements` **is not on
  that allowlist** (`error-codes.md:43`: `GET /me`, `POST /me/deletion-request`,
  `DELETE /me/deletion-request`, `POST /auth/logout`). So a pending-deletion student's entitlement
  read fails with a `403` that is *not* `subscription_required`. A subscription area that maps any
  `403` to "not subscribed" would tell a deleting student they have no subscription, which is both
  false and the opposite of the contract-mandated message that their subscription is forfeited.
  **The app calls neither deletion endpoint at HEAD** (part 05 API-01), so this is a design
  constraint for the build, not a live defect.
- **Reinstall.** Android: secure storage is removed with app data, so reinstall is a fresh login and
  a fresh `/me`. **iOS: the Keychain survives uninstall** (part 07 rows 9 and 11, part 04 IOS-06,
  unmitigated), so tokens *and* `device_id` persist and the app cold-starts already signed in — and
  then immediately does a live `GET /me`. Entitlement state is therefore still correct. What is *not*
  correct is the contract's own claim that `deviceId` is "regenerated on reinstall"
  (`openapi.yaml:2239-2247`), which POL-12 already flags as a declaration-accuracy problem. **No
  entitlement consequence; recorded here so the next reader does not re-derive it.**

### 1.8 Where staleness becomes possible — the exact list

Once a subscription area reads entitlement state, these are the transitions at which the screen can
be wrong, in descending order of likelihood:

| # | Transition | Stale today | Stale once a screen exists | Why |
|---|---|---|---|---|
| 1 | Web redemption while the app is backgrounded → resume | n/a | **Yes** | No resume refetch runs at all (§2) |
| 2 | Entitlement expires while the app is warm | n/a | **Yes, indefinitely** | Nothing polls; no request is made; the boolean changes server-side with no client event |
| 3 | Grace elapses while the app is warm | n/a | **Yes, indefinitely** | Same, and the copy is the most alarming one to get wrong |
| 4 | Resume refetch fails (offline on resume is the normal case) | n/a | **Yes — and it blanks** | `refresh()` assigns a bare `AsyncError`, dropping the last value (ENT-04) |
| 5 | Two screens, one reading `profile.entitlements`, one reading `/me/entitlements`, after any resume | n/a | **Yes, and they disagree** | `meProvider` has no resume refresh; the embed ages while the dedicated provider does not (ENT-03) |
| 6 | Login → logout → different student | No | No | `invalidateSessionScope` covers it (§1.6) |
| 7 | Cold start after a web redemption | No | No | Always a live read (§1.2) |

---

## 2. API-05 confirmed, and what adr-171 §4 actually requires

### 2.1 The confirmation (SOURCE, this session)

`me_notifier.dart:55-78`:

```dart
class EntitlementsNotifier extends AsyncNotifier<List<EntitlementState>> {
  @override
  Future<List<EntitlementState>> build() {
    final listener = AppLifecycleListener(onResume: refresh);   // :58
    ref.onDispose(listener.dispose);
    return ref.watch(profileRepositoryProvider).getEntitlements();
  }
```

`grep -rn "entitlementsProvider" lib test` returns, in `lib/`, **three lines and no consumer**:

- `lib/core/session/session_scope.dart:61` — `ref.invalidate(...)`
- `lib/features/profile/notifier/me_notifier.dart:74` — the declaration
- `lib/features/profile/repository/profile_repository.dart:77` — a doc comment

Every other hit is in `test/`. `ref.invalidate` on a provider with no listeners **does not schedule a
build** — it discards any cached state, and Riverpod rebuilds lazily on the next read, which never
comes. Therefore `build()` never executes, therefore the `AppLifecycleListener` is never
constructed, therefore no resume refetch has ever run in a shipped build.

Independently corroborated: the whole-repo lifecycle grep (§1.3) finds `me_notifier.dart:58` and
**nothing else**. The app installs no lifecycle observer anywhere. There is no second mechanism that
could accidentally be doing this job.

**API-05 is confirmed at SOURCE. `store_readiness_state.md`'s "❌ FALSE at HEAD" is correct, and
adr-171 §4's premise is factually wrong about this repository.** (ENT-01.)

### 2.2 What must be true for adr-171 §4's assumption to hold

Five conditions. All five are currently unmet; three of them are not obvious.

1. **The provider must have a live listener for the whole time the app is foregroundable — not just
   while the subscription screen is mounted.** A resume refetch that only runs while the student is
   *looking at* the subscription screen is useless: the redemption journey is "leave the app, redeem,
   come back", and the student comes back to wherever they were. Two acceptable shapes: a
   `ref.listen(entitlementsProvider, (_, __) {})` (or `ref.watch`) in the **nav shell** so the
   provider is alive for the whole authenticated session; or keeping the lifecycle listener out of
   the provider entirely and putting a single `WidgetsBindingObserver` in the shell that calls
   `ref.read(entitlementsProvider.notifier).refresh()`. **The second is better** — it decouples "a
   resume happened" from "somebody happens to be watching this provider", and it is the shape that
   also fixes API-06 (`meProvider` has the same gap) with one observer instead of two.
   *Corollary:* the listener must be **inside** the authenticated subtree, so it is torn down at
   logout and cannot fire a `/me/entitlements` call with no token (`session_scope.dart`'s ordering
   note at `:54-57` explains why that matters).
2. **The resume trigger must be the real one.** `AppLifecycleListener(onResume:)` fires on
   `resumed`, which on Android also fires after a transient loss of focus (a notification shade pull,
   a permission dialog). That is over-firing, not under-firing, and is acceptable — but it means the
   refetch must be cheap and must never show a spinner. It must **not** be `onShow`/`onRestart`,
   which do not fire on the path that matters (returning from Chrome Custom Tabs). This needs a
   DEVICE-level check on both platforms before it is believed; **nothing in this repo has ever
   exercised it** (the tests call `refresh()` directly — `me_notifier_test.dart:164`).
3. **Error and offline must keep the last known state. Today the code does the opposite.**
   `refresh()` is documented as "the previous value stays on screen until the new one lands"
   (`me_notifier.dart:63-66`) and the test at `me_notifier_test.dart:147-170` proves that **for the
   success path only**. On the failure path:

   ```dart
   state = await AsyncValue.guard(() => ...getEntitlements());   // :68-70
   ```

   `AsyncValue.guard` returns `AsyncValue.error(err, stack)` with **no previous value attached**
   (riverpod 3.3.2, `lib/src/core/async_value.dart:518-531`, PUB). Assigning it replaces `AsyncData`
   outright. A resume with no network — the *normal* case, since a handset resuming often has not
   re-associated with Wi-Fi yet — therefore **blanks the entitlement state** and a subscription area
   would flip from "active" to an error view for no reason the student can understand.
   **Fix:** `final next = await AsyncValue.guard(...); state = next.copyWithPrevious(state);` or,
   more conservatively, assign only on success and keep the failure silent (a background refresh the
   student did not ask for should not be able to produce an error view at all). Add a test for the
   failure path; the existing one only covers success. (ENT-04.)
4. **Nothing may be computed client-side.** The screen renders `active`, `inGrace`, `expiresAt`,
   `graceEndsAt` as given. No `DateTime.now()` comparison, no "expires in N days" derived from the
   device clock unless the copy is explicitly relative-and-approximate, no inference of `active` from
   `inGrace` or vice versa, no caching of a previous `active: true` as a fallback. CLAUDE.md's
   server-authoritative rule and `entitlement_state.dart:12-15` already say this; a guard test is the
   only thing that will keep it true (§3.6).
5. **The subscription area must rebuild from the provider, not from a snapshot.** A
   `ConsumerWidget`/`Consumer` watching `entitlementsProvider`, not a value passed down through a
   constructor or captured in `initState` — which would also trip BUG-001's guard.

### 2.3 Is `profile.entitlements` consistent with `/me/entitlements`?

**At a single instant, yes; over a session, no — and the divergence is structural, not a race.**

Both are live server reads of the same server-side state and the same schema, so a `GET /me` and a
`GET /me/entitlements` issued together agree. But the two are carried by two providers with
**different refresh regimes**: `meProvider` is non-autoDispose and refreshes only on retry, after
`PATCH /me` and after `finishQuiz` (part 05 API-06, re-confirmed); `entitlementsProvider` is
*intended* to refresh on resume. The moment condition 1 above is satisfied, the embed starts ageing
while the dedicated provider does not, and any screen that happens to read `profile.entitlements` —
which is the one that is always populated and therefore the tempting one — shows the older value.

**Rule for the build: exactly one entitlement source reaches the UI, and it is
`entitlementsProvider`.** `StudentProfile.entitlements` is for first paint before the dedicated
provider has resolved, and for nothing else; if it is used at all it must be used as
`entitlementsProvider`'s *initial* value, never as a parallel source. The cleanest option is to have
the subscription area watch `entitlementsProvider` only and accept one skeleton frame. (ENT-03.)

### 2.4 Is resume-refetch sufficient after a web redemption?

**For the cold-start path: yes, and no work is needed.** A killed app re-reads `/me` on launch
(§1.2), so the entitlement is correct before the first frame. This is worth stating explicitly
because adr-171 §4 does not distinguish the two paths and a reader could conclude the whole journey
depends on a resume hook.

**For the warm path: yes in principle, and only if all five conditions in §2.2 hold.** Two residual
cases the warning does not address:

- **Process death while in the browser.** Android kills backgrounded Flutter processes freely under
  memory pressure, and a Custom Tab session plus a browser is exactly the memory pressure that does
  it. The return is then a **cold start**, not a resume — which is fine for entitlement (fresh read)
  but is *not* fine for wherever the student was, and FE-30 already records that the registration
  draft does not survive process kill. Recommend the subscription area be reachable from a stable
  route so the cold-start landing is not disorienting. No entitlement defect.
- **The student never comes back to the app.** They redeem, close the browser, and open the app
  three days later. Cold start; correct. No deep link needed. adr-171's "no deep link in release 1"
  is sound and this audit does not challenge it.

**The one thing resume-refetch does NOT cover, and nobody has said so:** a redemption that happens
while the app is *foregrounded on another device*, or an expiry that happens while the app is warm
(§1.8 rows 2 and 3). Resume is the only trigger the contract names, so this is correct-per-contract —
but a subscription area that sits open for an hour will show an hour-old truth. The mitigation is
copy, not polling: the area should not present itself as a live meter. Do **not** add a polling loop;
adr-171 §4 forbids it and the contract exposes no counter.

---

## 3. The compliance design of the not-yet-built subscription area

`lib/features/subscription/{models,notifier,repository,screens}/` contain `.gitkeep` and nothing else
(SOURCE, `find` this session) — confirming the state file's "❌ NOT BUILT" and part 10 §1
independently.

### 3.1 The three release-1 options

| | Option | Apple (Egypt storefront) | Play | Cost |
|---|---|---|---|---|
| (i) | **No link on either platform** — D-007 / adr-049 §3 as originally written | Strongest available. HEAD's posture: no button, no link, no URL string in the binary. POL-01 rates the *code* a pass; residual business-model risk remains and is not removable by any code change. | Trivially compliant. | Support burden: students must find the website themselves. Zero engineering. |
| (ii) | **Android-only link, behind a platform/build gate** | Unchanged from (i): the iOS binary contains no link widget, no URL, no confirmation copy. 3.1.1(a) covers "apps **and their metadata**", and part 02 proved a string scan of `libapp.so` finds URL literals — so a dead-code URL on iOS is a finding, not a technicality. | Permitted. Play blesses consumption-only by name and even permits "Go to our website to upgrade your subscription" (POL-02, WEB-verbatim). Conditional on the landing page. | One platform gate + one screen + certification. |
| (iii) | **Link on both platforms with a certified purchase-free landing page** | **Not defensible.** Three independent objections, all in POL-01: 3.1.1(a) is categorical and Egypt is in scope; a link whose only purpose is to reach a code-entry field re-associates the app with the unlock mechanism it currently has nothing to do with; and Apple objects to out-linking **to sign-in** under Guideline 4 regardless of payments — and the redemption page *must* authenticate, which is exactly what `POST /auth/redemption-session/otp/*` exists for. | Same as (ii). | Same engineering, plus iOS rejection risk on a feature the app does not need. |

**Recommendation: (ii) if the owner wants the link at all, (i) if they want one code path.**

Between (i) and (ii) this audit does not hold the pen — POL-01 is right that this is a business
decision (CLAUDE.md §1.3 rule 5). What this part adds is an engineering argument for **(i) in release
1 specifically**: option (ii) requires a platform-conditional screen, a confirmation sheet, a
launch-mode implementation with an Android fallback hazard (RED-01), a URL that **does not exist yet**
("no domain is purchased … Do not hardcode a URL"), a landing page that must be certified before the
link can ship, and a re-certification at every release. That is a meaningful amount of new
policy-governed surface, on the *one* platform where it buys the least, for a release that is already
carrying six A-severity blockers (POL-01..04, part 05 API-01/02). **Ship (i) in release 1; build (ii)
in release 2 once the domain exists and the page can actually be certified.** Record whichever is
chosen in `docs/DECISIONS.md` as superseding adr-171 §2's "both platforms" reading — D-007's current
text says the surface is removed, which is now only half the story.

### 3.2 What the landing page must and must not contain

POL-01's six certification conditions stand as written and are not restated. Three additions from
this part's angle:

7. **The page must not require the app to have done anything.** The URL is bare (§3.4), so the page
   receives no identity; it must therefore start from its own phone-OTP entry
   (`requestRedemptionSessionOtp`). A page that assumes a token, a session id or a prefilled phone is
   a page that will demand a query parameter, and the ban on query parameters is 🔴 in adr-171 §2.
8. **The page must keep its auth on phone-OTP.** POL-12(10e): adding social login to the redemption
   page would harden the Guideline 4 objection and create a second identity system for one student.
9. **The page must not tell the student to "go back to the app and refresh".** There is no refresh
   control and there will not be one; the correct instruction is "your subscription will be active
   the next time you open the app", which is true under §1.4's server-authoritative gating even if
   every provider in the app is stale.

### 3.3 Confirmation-sheet copy constraints

- **adr-171 §3 applies to this sheet by name**: "including this link, its confirmation sheet, and any
  empty/locked state that mentions it". No *price*, *buy*, *purchase*, *payment*, *subscribe*,
  provider name, amount, currency, or plan comparison.
- The copy "says where it goes, not what it costs" (adr-171 §3).
- adr-171 §3 also requires: "Keep the copy placeholder-free and send it to us before you finalise
  it." **The copy is not ours to finalise** — draft it, send it, do not ship it unreviewed.
- Because of POL-12(10d) / POL-01 reason 3, the sheet must **not** hint that the destination is a
  sign-in ("log in on the website", "enter your phone number there"). It should name the destination
  neutrally and stop. This is the one constraint that is Apple-Guideline-4-driven rather than
  payments-driven, and it is easy to violate while trying to be helpful.
- Both languages, AR (RTL) and EN (LTR), both ARB files, parity guard-enforced.

### 3.4 The launch mode — and the Android trap (RED-01, new)

adr-171 §2 requires "**System browser only** — `SFSafariViewController` on iOS, Chrome Custom Tabs on
Android" and marks "Never an embedded webview. Never `WKWebView`" 🔴.

The matching url_launcher constant is **`LaunchMode.inAppBrowserView`**, verbatim from the package:

> `/// Loads the URL in an in-app browser view (e.g., Android Custom Tabs, SFSafariViewController).`
> — `url_launcher-6.3.2/lib/src/types.dart:19-21` (PUB)

`LaunchMode.externalApplication` is documented as "Passes the URL to the OS to be handled by another
application" (`types.dart:23-24`) — i.e. it hands off to whatever browser app the student has set,
leaving the app. That is **not** what adr-171 asks for. It is what the repo's only existing call site
uses (`login_screen.dart:118`, FE-24), and it is the pattern a future implementer will copy.

🔴 **The trap nobody has listed.** On Android, `inAppBrowserView` **silently falls back to an embedded
WebView** when Custom Tabs are unavailable:

```java
// Try to launch using Custom Tabs if they have the necessary functionality, unless the caller
// specifically requested a web view.
if (allowCustomTab && !containsRestrictedHeader(...)) {
  if (openCustomTab(activity, uri, headersBundle, browserOptions)) return true;
}
// Fall back to a web view if necessary.
Intent launchIntent = WebViewActivity.createIntent(...);
```
— `url_launcher_android-6.3.32/android/src/main/java/io/flutter/plugins/urllauncher/UrlLauncher.java:113-129` (PUB)

So the naive implementation of adr-171 §2 produces, on any handset without a Custom-Tabs-capable
browser, **exactly the embedded webview adr-171 marks 🔴 and Play's Payments policy names first** in
"in-app webviews, buttons, links, messaging, advertisements, or other calls to action" (POL-02, WEB).
Part 02 observed that `WebViewActivity` ships in the merged manifest but is never invoked — true at
HEAD because the only call site uses `externalApplication`. **`inAppBrowserView` is what invokes it.**

iOS is safe: `url_launcher_ios-6.4.1/lib/url_launcher_ios.dart:74-78` maps both `inAppWebView` and
`inAppBrowserView` to the same in-app path, and the note is explicit — "The iOS implementation doesn't
distinguish between these two modes; both are treated as inAppBrowserView" — which is
`SFSafariViewController`, never `WKWebView`.

**Required implementation** (Android leg):

```dart
final ok = await supportsLaunchMode(LaunchMode.inAppBrowserView);
await launchUrl(uri, mode: ok ? LaunchMode.inAppBrowserView
                              : LaunchMode.externalApplication);
```

`supportsLaunchMode` resolves to `_hostApi.supportsCustomTabs()` on Android
(`url_launcher_android-6.3.32/lib/url_launcher_android.dart:134-141`, PUB) — and per the package
README it **returns false without a manifest `<queries>` entry**:

> "Checking for `supportsLaunchMode(LaunchMode.inAppBrowserView)` also requires a `<queries>` entry to
> return anything but false."
> — `url_launcher-6.3.2/README.md:63-66` (PUB)

`android/app/src/main/AndroidManifest.xml:66-71` currently declares **one** `<queries>` intent
(`PROCESS_TEXT`) and **no** `android.support.customtabs.action.CustomTabsService` entry (SOURCE). So
without a manifest change the support check returns false and every Android launch degrades to
`externalApplication` — which is *safe* (no webview) but is *not* what adr-171 asked for, and nobody
would notice. Add the `<queries>` entry **and** the fallback; never call `inAppBrowserView`
unconditionally. Never use `inAppWebView`, and never add `webview_flutter` or `flutter_inappwebview`
to `pubspec.yaml`.

### 3.5 "No query parameters" — how to make it a rule that holds

adr-171 §2: "🔴 The outbound URL carries NO query parameters. No token, no session id, no student id,
no code, no opaque reference, no analytics parameter. Nothing. A bare URL."

CLAUDE.md's rule 3 applies squarely: "Prose rules decay; mechanised rules hold." Proposed guard,
modelled on the existing colour-palette guard (the one rule that has held across 36k lines):

```dart
// test/guards/external_launch_guard_test.dart
// 1. Every `launchUrl(` call site in lib/ passes a Uri built from a const whose
//    literal matches ^https://[A-Za-z0-9.-]+(/[A-Za-z0-9._~/-]*)?$ — no '?', no '#', no '$'
//    interpolation anywhere in the literal.
// 2. No lib/ source contains `LaunchMode.inAppWebView`.
// 3. pubspec.lock contains neither `webview_flutter` nor `flutter_inappwebview`.
// 4. Every `inAppBrowserView` call site is preceded by a `supportsLaunchMode` check
//    in the same function body.
```

Rules 1–3 are cheap source-level regex assertions over `lib/` and `pubspec.lock` and belong in
`test/guards/` next to the existing ones. Rule 4 is harder to express and may be better as a review
checklist item than a bad test — prefer three guards that hold over four where one is flaky.
**Additionally**, part 05 API-08's proposed guard (every `_dio.*` path literal resolves to a stable,
non-`x-consumers:[web]` operation) is the mechanised form of "never call the three web-only ops", and
this part endorses it: today's proof is a manual census that decays on the next contributor.

A runtime belt-and-braces assertion is also cheap: `assert(!uri.hasQuery && !uri.hasFragment)` at the
launch site, which fails loudly in debug and profile and costs nothing in release.

### 3.6 What the entitlement display should show, using only server fields

Four states, derived from `active` and `inGrace` **only** — never from a date comparison, never from
a stored previous value:

| `active` | `inGrace` | State | What the app may say | What it may not say |
|---|---|---|---|---|
| `true` | `false` | **Active** | The entitlement is active. `expiresAt` may be shown as a date if non-null. | Anything about renewal, cost, or how it was obtained. |
| either | `true` | **In grace** | The entitlement has ended and access continues for a short period. `graceEndsAt` may be shown as a date if non-null. | "Renew now", "extend", any urgency framing that implies a transaction. |
| `false` | `false`, item present | **Ended** | The entitlement is not active. | A destination, a price, a CTA. |
| item absent from `items` | — | **None** | Same copy as Ended, or nothing at all. | Do not fabricate a "free plan" tier name — the glossary forbids "plan"/"premium"/"pro" (`app_en.arb:486`). |

**Three rules that are easy to get wrong:**

1. **`active` and `inGrace` are independent booleans and the contract never states their
   relationship.** Do not write `if (active) show(active) else if (inGrace) show(grace)` — that
   renders a grace-window entitlement as plainly "Active" if the server sets `active: true` during
   grace, which is the single most misleading thing this screen can do (ENT-05). **Branch on
   `inGrace` first.** If the owner needs certainty about which combination the server actually emits,
   that is a question for Seif (§7 Q-E2), not an inference.
2. **`items` is a list and `type` is extensible.** Render per entitlement type; do not collapse the
   list to one boolean. `baseSubscription` and `flashcardSubscription` are independent
   (`flashcards_repository.dart:58-62`: "A `baseSubscription` changes nothing here … the two
   subscriptions are independent (adr-004/adr-060)"). An `EntitlementType.unknown` item must render
   as *nothing at all*, not as an error and not as a generic row with a raw enum name (ENT-08).
3. **There is no `pending`.** `openapi.yaml:1069-1071` and `entitlement_state.dart:14-15`. Never
   invent an "activating…" state to cover the window between a web redemption and the next read.

---

## 4. Vocabulary audit of the copy the app will need

Part 10 §1 established that **HEAD is clean**: zero banned hits in any ARB value or user-visible Dart
string; all 12 grep hits are `///`/`//` comments explaining the *absence* of a purchase surface. This
section audits the copy that does not exist yet.

### 4.1 Existing keys — all four are AMBIGUOUS, all four should stay

`subscriptionRequiredTitle` "Subscription Required" (`app_en.arb:483`), `subscriptionRequiredBody`
"This lesson needs an active subscription." (`:484`), `errorSubscriptionRequired` (`:495`),
`weeklyLimitBody` "You've used all your questions for this week." (`:479`), plus AR at
`app_ar.arb:201,202,207`.

**Verdict: keep.** "Subscription" here is the **state noun** naming what the server's `403` reports,
with no verb, no price and no destination. adr-171 bans "subscribe" (the imperative), and its own §2
speaks of "the student's account/**subscription** area" — the warning uses the noun itself. Changing
these would be churn against a rule the copy already satisfies. This confirms part 10's classification
independently.

One caution: `weeklyLimitBody` says "this week" and the reset is **Monday 00:00 Africa/Cairo**, ruled
in adr-091 §3 and published only in `contract/contract-changelog.md:305` — "**What is NOT specified
here, so nobody infers it** … reset **Monday 00:00 Africa/Cairo** … **owed by a later milestone's
spec**, not published on the wire". **Never compute or display the reset moment** (ENT-07).

### 4.2 New copy the subscription area needs, with collisions and neutral EN wording

AR is left to the owner, per the brief. Every EN string below is a **proposal for Seif's review**,
not a finalised string (adr-171 §3 requires the copy be sent before it is finalised).

| Surface | Wording that will be reached for | Collision | Proposed neutral EN |
|---|---|---|---|
| Area title | "Subscription", "My Plan", "Premium", "Billing" | **plan / premium** are glossary-forbidden (`app_en.arb:486`); **Billing** collides with *payment* | **"Subscription"** — the state noun, matching adr-171 §2's own phrase |
| Active row | "Your Premium plan is active until …" | plan, premium | **"Active until {date}."** |
| Grace row | "Expired — renew now to keep access", "Payment overdue" | *renew* implies a transaction; *payment* is banned | **"Ended. Access continues until {date}."** |
| Ended row | "Expired — subscribe to continue" | *subscribe* banned | **"Not active."** |
| None row | "You are on the Free plan" | plan | **"No active subscription."** or omit the row |
| Flashcards entitlement | "Flashcards add-on", "upgrade for flashcards" | *upgrade* was removed by D-007 and is a purchase CTA | **"Flashcards: active / not active."** Use the glossary term `flashcard_subscription` in code, not in copy |
| Link label | "Buy a subscription", "Get Premium", "Upgrade" | buy, premium, upgrade | **"Manage your subscription on the website"** — states the destination, not the cost. ⚠️ Avoid any phrasing that reads as *sign in on the website* (POL-12(10d)) |
| Confirmation sheet | "You'll be taken to our secure checkout" | checkout, and it is a purchase claim | **"This opens the Level Up website in your browser."** + Continue / Cancel |
| Limit sheet | already correct — keep `freeUsageReachedTitle` / `weeklyLimitBody` verbatim (D-007 ruled "A verbatim") | — | no change |
| Flashcard gate | none exists yet; the `403` has no screen | — | reuse `errorSubscriptionRequired`; do **not** write a second, warmer string that names a destination |
| **Deletion confirm** | contract-mandated: "an active **paid** subscription is forfeited — there is no partial **refund**" (`openapi.yaml:1011-1018`, quoted below) | **paid**, **refund** — both banned app-wide by adr-171 §3 | see §4.3 |

### 4.3 The deletion-copy conflict, quoted at source

`contract/openapi.yaml:1011-1018`, verbatim:

> **Confirm-screen copy the app must show BEFORE calling this (adr-114 D3).** The request is
> reversible only inside the grace window, by logging in again and calling
> `DELETE /me/deletion-request`. **An active paid subscription is forfeited** — there is no
> partial refund, the remaining paid time is not restored by cancelling, and it does not
> carry to a future account. **A new account registered later with the same phone number
> starts from zero** — no points, no level, no badges, no quiz history. The phone stays
> blocked for the whole grace window (the account still exists) and is freed at execution.

Three banned words in one sentence: **paid** (twice), **refund**, and the *concept* of purchase
throughout. POL-04 already proposes the resolution and this part endorses it verbatim:

> "Any active subscription is forfeited. It is not restored by cancelling and does not carry over to
> a future account."

That preserves all three semantic elements the contract requires (forfeiture, non-restoration on
cancel, non-portability) and contains no banned word. The contract's text is a **semantic**
requirement — it says what the student must understand, not which characters to render — so this is a
faithful implementation, not a workaround. **But it is a divergence from an authoritative source and
must be signed off by Seif and the owner in writing** (CLAUDE.md §1.3 rule 1: where the contract and
another authority disagree, stop and file it, do not resolve silently). This part adds it to
`docs/seif_fight.md` as a question, not as a decision. (RED-06.)

### 4.4 Words that are safe, and words that are not

**Safe** (state nouns and server vocabulary): subscription, active, not active, ended, access,
flashcards, website, browser, questions, week.
**Banned** (adr-171 §3): price, buy, purchase, payment, pay, subscribe, checkout, refund, paid,
amount, currency (EGP / ج.م / جنيه), any provider name (Paymob, Fawry, Vodafone, InstaPay), plan
comparison.
**Banned by the glossary, not adr-171** (`app_en.arb:486`): plan, premium, pro.
**Banned by D-007 precedent**: upgrade.
**Additionally avoid** (Guideline 4, POL-12(10d)): sign in, log in, your account on the website,
enter your phone — anywhere in the link label or its confirmation.
**Avoid for accuracy**: renew, expires in N days (computed), voucher, code, redeem — the last three
because the app must never mention code redemption at all (adr-049 §4: "the app never mentions
voucher redemption", `openapi.yaml:1878`).

---

## 5. Verification — the greps, re-run at HEAD this session

**(a) Web-only operations, webviews — one grep, zero hits.**

```
$ grep -rniE "redemption|subscription-codes|redeemSubscriptionCode|requestRedemptionSessionOtp|verifyRedemptionSessionOtp|inAppWebView|webview_flutter|flutter_inappwebview|WKWebView" --include="*.dart" lib
$ echo $?
1
```

Exit 1 = **no matches, case-insensitive, across all of `lib/` including `lib/dev/`**. This
re-confirms part 05's census with a single command: none of
`POST /auth/redemption-session/otp/request`, `POST /auth/redemption-session/otp/verify` or
`POST /subscription-codes/redemptions` is called or named, and no embedded-webview API appears. (Part
05's residual "router comment" hit at `app_router.dart:434` is gone from this grep's terms because the
comment says `/subscription`, not `redemption`; the comment is at `app_router.dart:430-437` and
records that `/subscription` and `/subscription/return` "went with the purchase surface … removed, not
built".) ✅ **PASS.**

**(b) No webview package in the lockfile.**

```
$ grep -ciE "webview_flutter|flutter_inappwebview" pubspec.lock
0
```
✅ **PASS.** `url_launcher 6.3.2` (`pubspec.lock:1181-1188`), `url_launcher_android 6.3.32`
(`:1189-1196`), `url_launcher_ios 6.4.1` (`:1197-1204`). Note that `url_launcher_android` **contains**
`WebViewActivity` regardless (§3.4) — the absence of a webview *package* is not the absence of a
webview *code path*.

**(c) No external launch carries a query parameter.**
The **only** `launchUrl` call site in `lib/` is `login_screen.dart:118`:

```dart
await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
```

`url` is always one of three `static const` literals (`login_screen.dart:43-46`):
`https://levelup.example/legal/user-agreement`, `/legal/privacy`, `/legal/cookies` — **no `?`, no
`#`, no interpolation** (FE-02 separately records that `.example` is a placeholder). Every other
`queryParameters:` in `lib/` is a **Dio** call to the API, not an external launch:
`flashcards_repository.dart:73` (`cursor`, `pageSize`), `leaderboard_repository.dart:52`,
`reference_repository.dart:74,107`, and `mock_backend.dart:124` (reads them). ✅ **PASS**, with the
caveat that this is a property of today's three URLs, not a rule — hence the guard in §3.5.

**(d) `EntitlementType` tolerates unknown values.** `entitlement_state.dart:21-30`:

```dart
@JsonEnum()
enum EntitlementType { baseSubscription, flashcardSubscription, unknown }
...
@JsonKey(unknownEnumValue: EntitlementType.unknown)
required EntitlementType type,
```

Matches `openapi.yaml:2440-2443` ("Extensible set (adr-018) — clients must tolerate unknown values
additively"). ✅ **PASS at SOURCE** — a new server-side entitlement type will decode, not throw. The
residual is *rendering*, not decoding (ENT-08).

---

## 6. Risks unique to this architecture that no agent has listed

**RED-02 · Web session vs app session — RESOLVED BY CONTRACT, and the resolution is load-bearing.**
The obvious fear is that the website's redemption OTP mints a session that evicts the app's session
under device binding, logging the student out as a side effect of paying. **It does not**, and the
contract is explicit at `openapi.yaml:216-235` and `:303-310`:

> "a student who redeems a subscription code in the browser must not be logged out of the app as a
> side effect, and the session that makes that true can do nothing else" (`:218-220`)
> "**This does NOT evict the student's app session, and is not evicted by one.** A second verify
> replaces the previous *redemption* session only." (`:303-305`)

The redemption session is a **second credential kind**: reaches exactly three operations
(`redeemSubscriptionCode`, `getMyEntitlements`, `logout`), `403 redemption_scope_only` on everything
else by default-deny, no refresh token, ten minutes, one redemption. Its OTP is **purpose-bound** —
"It cannot be verified at `POST /auth/otp/verify`" (`:249-251`) — and it runs "over its OWN counters,
so nothing here can lock a student out of signing in to the app" (`:255-257`).

**Why this is still a risk to record rather than a pass:** every one of those properties is a
*server* property that the app depends on and cannot verify. Two of them should be confirmed rather
than assumed (§7 Q-R1, Q-R3): that a redemption session never appears as a device-binding session,
and that `POST /auth/logout` called by the *web* session does not revoke the *app* session — the
contract lists `logout` among the redemption session's three reachable operations, and
`openapi.yaml:424-433` says logout revokes "this session (access + refresh chain)". If "this session"
is resolved by student rather than by token, a student tapping a "log out" control on the redemption
page would kill their app session. **No agent has raised this.** Low likelihood, trivially confirmable,
severe if wrong.

**RED-03 · The replay note names the app as a consumer, and a future contributor will read it as
permission.** `redeemSubscriptionCode` is `x-consumers: [web]` (`openapi.yaml:1878`) and adr-171 §5
says "We audit for this." But the 3.21.0-m1 behavioural note says, in bold, that the `201` replay
"is reached by an **app session**" and is "NOT reachable" from the web session
(`openapi.yaml:1908-1913`). So the contract itself documents an app-session path through an operation
the app is forbidden to call. A contributor reading only that paragraph has a plausible-sounding
reason to wire it up — and the consequence is an Apple 3.1.1 "license keys" violation on a shipped
binary. **Mechanise the prohibition** (part 05 API-08's guard, §3.5) rather than relying on the
prose; and ask Seif to reconcile the note with `x-consumers` (§7 Q-R2).

**RED-04 · Replay of `redeemSubscriptionCode` success — no app-side exposure, recorded for
completeness.** The 3.20.0-m1 change (re-posting a code the *same* student already redeemed replays
`201` instead of `409`) and the 3.21.0-m1 `redemption_in_progress` split are both web-side. adr-171 §6
is correct that there is nothing for the app to change. The **only** app-visible consequence is
indirect and benign: the web recovery path for a lost response is "re-read `GET /me/entitlements`",
which is the same read the app does — so a student may see the entitlement appear in the app *before*
the website's confirmation page updates. Do not write copy that asserts an ordering between the two
surfaces.

**ENT-05 · A 2-day grace window displayed as "active" is the worst failure mode this screen has.**
`inGrace` is documented as "2-day grace after expiry" and is **required**, while `active` carries no
statement about its value during grace (`openapi.yaml:2444-2451`). A screen that branches on `active`
first will either (a) show "Active" for two days after expiry, so the student is surprised by a `403`
they were told could not happen, or (b) show "Not active" while access still works, so the student
believes they lost access they still have. **Branch on `inGrace` first** (§3.6 rule 1) and ask Seif
which combination the server emits (§7 Q-E2). A 48-hour window is also long enough for the "expires
while the app is warm" case (§1.8 row 3) to be common rather than theoretical.

**ENT-06 · Two clocks, and the device's is not authoritative.** `expiresAt` and `graceEndsAt` are UTC
instants; Egyptian handsets may have a wrong clock or a manually-set timezone, and Egypt observes DST.
Any "expires in N days" the app computes is the *device's* opinion. Render dates through the existing
localisation (which already handles AR digits — FE-32/33 records an Arabic-Indic asymmetry elsewhere
in the app, so this needs a deliberate choice, not a default) and **never** compute a countdown that
the student could act on.

**ENT-07 · The weekly reset is a server rule with a named timezone that is not on the wire.**
`contract-changelog.md:305` rules it Monday 00:00 Africa/Cairo but states explicitly that it is not
published by that entry and no endpoint exposes the counter. A student in a different timezone, or a
handset set to one, would see "next week" arrive at a different moment than the server does. Today's
copy ("this week") is safe precisely because it is vague. **Keep it vague.** (This also re-confirms
why `limit_sheet.dart:28-32` correctly refuses to draw a "QUESTIONS 50/50" bar.)

**ENT-08 · Unknown entitlement types decode safely but have no rendering rule.** §5(d) proves the
model tolerates them. What is undefined is what a subscription area *draws* for
`EntitlementType.unknown`. The safe rule is **render nothing** — an unknown type is by definition one
this build cannot describe, and inventing a label for it is the "never invent" rule in its purest
form. A `switch` over `EntitlementType` in UI code that is exhaustive over the two known values and
throws or falls through on `unknown` would crash or blank the screen the day Seif ships a third type —
which the contract says can happen "additively — no version bump" (`openapi.yaml:1071-1073`). Write
the `switch` with an explicit `unknown → SizedBox.shrink()` arm and a test that feeds it a type the
enum does not have.

**ENT-09 · A `403` during the deletion grace window is not "no subscription".**
`getMyEntitlements` is not on the four-endpoint allowlist, so a pending-deletion student's entitlement
read answers `403 account_pending_deletion` (§1.7). A subscription area that maps `403 → not
subscribed` shows a false statement to the one student for whom the contract mandates the *opposite*
message. Branch on the error **code**, never the status — the same rule `error-codes.md:45` states for
the redemption codes, and the predicate at `exceptions.dart:134` already exists for it.

**RED-05 · The subscription area is a new authenticated screen and inherits every existing screen
rule.** Loading / empty / error / offline × AR (RTL) + EN (LTR); no colour outside
`lib/core/theme/`; no inline `fontSize`/`fontWeight` (ratchet 0); Riverpod not Bloc; no provider
mutation in `initState` (BUG-001). It also needs a `GoRouter` route — and FE-25/FE-27 record that
there is no `errorBuilder`, so a mistyped route near this area renders go_router's un-localised error
page. Listed because "the compliance design" tends to be reviewed for policy and then shipped
skipping the project's own checklist.

**RED-06 · The vocabulary conflict is an unresolved contradiction between two authorities** (§4.3).
Recorded here because it is entitlement copy, owned by POL-04.

**ENT-10 · `parentReportStatus` is irrelevant to entitlement — stated so it stops being re-checked.**
It reads `'inactive'` for everyone (part 05 API-09; the only occurrences in the repo are
`mock_backend.dart:1613` and the optional model field `student_profile.dart:224`). It is not an
entitlement, is not in `EntitlementType`, and must never be read as one — in particular, a
subscription area must not surface it as a third "subscription" row. Its real problem is API-09's
(a guardian phone compelled from minors with nothing delivered to the guardian), which is POL-05's,
not this part's.

---

## 7. Questions for Seif (new; none duplicate part 05's Q1–Q14)

| # | Question | Why it blocks |
|---|---|---|
| Q-E1 | adr-171 §4 asserts the app "already refetches `GET /me/entitlements` on foreground/resume". It does not and never has (ENT-01). Please correct the ADR, and confirm resume is still the only refetch trigger you expect. | The partner is building against a false premise about our code |
| Q-E2 | During the 2-day grace window, what does the server emit — `active: true, inGrace: true`, or `active: false, inGrace: true`? The schema does not say and we must not guess. | Decides the display branch (ENT-05) |
| Q-E3 | Confirm `StudentProfile.entitlements` and `GET /me/entitlements` are read from the same store with no caching layer between them, so a web redemption is visible to both on the next read. (Part 05 Q11 asked about the route; this asks about coherence between the two sources.) | Decides whether the embed is safe as an initial value (ENT-03) |
| Q-R1 | Does a redemption-scoped session ever appear as a **device-binding** session — i.e. can minting one cause `session_superseded` on the app, now or after any future change? `:303-305` says no today; we want it stated as an invariant. | RED-02 |
| Q-R2 | `redeemSubscriptionCode` is `x-consumers: [web]`, but its 3.21.0-m1 note says the `201` replay "is reached by an **app session**". Which is authoritative? We are treating `x-consumers` as binding and will never call it. | RED-03; a contributor could read the note as permission |
| Q-R3 | `POST /auth/logout` is one of the redemption session's three reachable operations. Confirm that calling it with a redemption token revokes **only** that session and never the student's app session. | RED-02 |
| Q-R4 | Is the "no query parameters" rule also a *server* rule — will the redemption page reject or ignore parameters if one is ever appended by a link-preview service or an OS share sheet? | adr-171 §2 is a 🔴 constraint we can only enforce on our side |

---

## 8. Findings

Severity legend (as parts 05/12): **A** submission blocker · **B** likely rejection / decision needed ·
**C** must-fix pre-release · **D** should-fix · **E** hygiene · **F** informational · **G** no action.

| ID | Sev | Finding | Evidence | Remediation | Owner |
|---|---|---|---|---|---|
| **ENT-01** | **B** | **adr-171 §4's premise is false.** `entitlementsProvider` has zero consumers in `lib/`; providers are lazy; `build()` and its `AppLifecycleListener` never run. The app has **no** lifecycle observer of any kind. Confirms API-05 at SOURCE. | `me_notifier.dart:55-78`; `session_scope.dart:61`; whole-repo lifecycle grep → 1 hit, in the dead provider | Correct the ADR with Seif (Q-E1). Then either delete the dead provider, or — when the subscription area lands — drive the refetch from a single shell-level observer covering both `entitlementsProvider` and `meProvider`. Add a widget test that a resume triggers the call. | frontend + backend (ADR) |
| **ENT-02** | **F** | **No screen reads entitlement state at all** — neither `entitlementsProvider` nor `profile.entitlements`. Gating is 100% server `403` at call time, so stale entitlement display is impossible today and a web redemption is honoured on the next request with zero client work. This is the app's Apple 3.1.1 defence. | §1; `limit_sheet.dart:64`; `quiz_setup_notifier.dart:26`; `flashcards_repository.dart:40-64` | **Preserve the server-authoritative gate when the subscription area lands.** Never pre-check entitlement to enable a control. | frontend |
| **ENT-03** | **C** | **Two entitlement sources with different refresh regimes.** Once a resume refetch is live, `profile.entitlements` (no resume refresh) ages while `entitlementsProvider` does not; two screens can disagree. | `openapi.yaml:2425-2428`; `me_notifier.dart:17-42` vs `:55-78`; API-06 | One source reaches the UI: `entitlementsProvider`. Use the embed only as its initial value, or not at all. | frontend |
| **ENT-04** | **C** | **`refresh()` discards last-known state on failure**, contradicting its own doc comment and adr-171 §4's implicit requirement. `AsyncValue.guard` returns a bare `AsyncValue.error`; assigning it drops the previous `AsyncData`. Offline-on-resume is the common case. | `me_notifier.dart:63-70`; riverpod `3.3.2` `lib/src/core/async_value.dart:518-531` (PUB); `me_notifier_test.dart:147-170` covers success only | `state = next.copyWithPrevious(state)`, or assign only on success. Add a failure-path test. Applies to `meProvider.refresh()` too if it gains a resume trigger. | frontend |
| **ENT-05** | **C** | **2-day grace can render as "active".** `active`/`inGrace` are independent and the contract states no relationship. Branching on `active` first is the obvious and wrong implementation. | `openapi.yaml:2444-2451`; §3.6 | Branch on `inGrace` first; ask Q-E2 before finalising copy. | frontend + backend |
| **ENT-06** | D | **Device clock is not authoritative** for `expiresAt`/`graceEndsAt`. Any computed countdown is the handset's opinion. | `openapi.yaml:2448-2450`; no date arithmetic exists in `lib/` today | Render server dates; compute no countdown the student could act on. | frontend |
| **ENT-07** | D | **Weekly reset is Monday 00:00 Africa/Cairo**, ruled in adr-091 §3 and published only in the changelog; no endpoint exposes the counter. Current copy is safe because it is vague. | `contract-changelog.md:305`; `error-codes.md:30`; `limit_sheet.dart:28-32` | Keep "this week". Never render a reset time or a remaining count. | frontend |
| **ENT-08** | D | **Unknown entitlement types decode but have no rendering rule.** Model is correct; a future exhaustive `switch` in UI is the hazard. | `entitlement_state.dart:21-30`; `openapi.yaml:2440-2443` | Explicit `unknown → render nothing` arm + a test feeding an unmapped type. | frontend |
| **ENT-09** | C | **`403` during the deletion grace is not "not subscribed".** `getMyEntitlements` is outside the four-endpoint allowlist. | `error-codes.md:43`; `openapi.yaml:1006-1009` | Branch on error `code`, never status; `exceptions.dart:134` is the hook. Ships with POL-04's deletion work. | frontend |
| **ENT-10** | G | **`parentReportStatus` is not an entitlement.** `'inactive'` for everyone; must not appear in a subscription area. | `student_profile.dart:224`; `mock_backend.dart:1613`; API-09 | None here. | — |
| **RED-01** | **B** | 🔴 **`LaunchMode.inAppBrowserView` silently falls back to an embedded WebView on Android** when Custom Tabs are unavailable — the exact thing adr-171 §2 marks 🔴 and Play names first. The manifest also lacks the `<queries>` entry that makes `supportsLaunchMode` return anything but false. **Not listed by any agent.** | `url_launcher_android-6.3.32/.../UrlLauncher.java:113-129` (PUB); `url_launcher-6.3.2/README.md:63-66` (PUB); `AndroidManifest.xml:66-71` (SOURCE) | Gate every `inAppBrowserView` launch on `supportsLaunchMode`, fall back to `externalApplication`, add the `CustomTabsService` `<queries>` entry, and never use `inAppWebView`. Guard it (§3.5). iOS is safe by implementation. | frontend |
| **RED-02** | D | **Web session vs app session** is resolved in the app's favour by contract, but three properties are server-side assumptions the app cannot verify — including whether the redemption session's `logout` could kill the app session. | `openapi.yaml:216-235, 303-310, 424-433` | Ask Q-R1, Q-R3. No code change. | backend |
| **RED-03** | C | **The contract documents an app-session path through a `[web]`-only operation** ("the `201` replay … is reached by an **app session**"), which a future contributor can read as permission to call it. | `openapi.yaml:1878, 1908-1913`; adr-171 §5 | Mechanise the prohibition (API-08 guard). Ask Q-R2. | frontend + backend |
| **RED-04** | G | `redeemSubscriptionCode` replay / `redemption_in_progress` are web-side only; adr-171 §6 is correct that there is nothing to change. One indirect consequence: the app may show the entitlement before the website's page updates — do not assert an ordering in copy. | `openapi.yaml:1886-1913`; `error-codes.md:45-46` | Receipt confirmed; no action. | — |
| **RED-05** | C | The subscription area is a new authenticated screen and inherits the project's full screen checklist (4 states × 2 locales, theme/typography guards, Riverpod, BUG-001) plus FE-25's missing `errorBuilder`. | CLAUDE.md non-negotiables; FE-25/FE-27 | Apply `screen-states` before calling it done. | frontend |
| **RED-06** | **B** | **Contract-mandated deletion copy uses "paid" and "refund"; adr-171 §3 bans both app-wide.** POL-04's neutral rewrite is semantically complete and is endorsed — but it is a divergence from an authoritative source and needs written sign-off. | `openapi.yaml:1011-1018` (quoted §4.3); adr-171 §3 | File in `docs/seif_fight.md`; sign-off from Seif + owner before the deletion screen ships. | product + backend |
| **RED-07** | **B** | **Release-1 link decision is unmade.** Recommendation: **no link on either platform in release 1** (option i), Android-only in release 2 once the domain exists and the landing page can be certified. Shipping the link on iOS/Egypt is not defensible (POL-01, three independent objections). | §3.1; POL-01; POL-02; adr-171 §2; `lib/features/subscription/` empty | Owner decision; record in `docs/DECISIONS.md` as superseding both D-007's current text and adr-171 §2's "both platforms" reading. | **owner** |
| **RED-08** | C | **No mechanised guard** for "bare URL, no query parameters", "no `inAppWebView`", "no webview package", or "no web-only endpoint". All four are prose today, and prose decays. | §3.5; part 05 API-08; `docs/ENFORCEMENT.md` | Add `test/guards/external_launch_guard_test.dart` (3 assertions) + API-08's `_dio` path guard. | frontend |

---

## 9. What this part did NOT verify

1. **Nothing was built, run, or observed on a device.** Every claim is SOURCE or PUB level. In
   particular, **that `AppLifecycleListener(onResume:)` actually fires on return from a Chrome Custom
   Tab / `SFSafariViewController`** is assumed, not measured — and it is the single behaviour the whole
   adr-171 §4 design rests on. It must be checked on both platforms before anyone reports the
   subscription area as working. (Project memory records that FLAG_SECURE blacks out `screencap` on
   quiz screens; the subscription area is not answer-bearing, so screenshots should work there.)
2. **Server behaviour during the grace window** (Q-E2) and the three redemption-session invariants
   (Q-R1..R4) are contract readings, not observations. Staging has never been probed with an
   entitled account — part 05's staging work was unauthenticated.
3. **The landing page does not exist** (no domain purchased, adr-171 §2), so POL-01's six
   certification conditions cannot be evaluated against anything. Everything in §3.2 is a
   specification for a page nobody has built.
4. **Apple's actual tolerance** for a web-only-subscription education app with no IAP is undocumented
   either way (POL-12 thin-evidence item 8). Option (i) minimises exposure; it does not eliminate it.
5. `url_launcher_android`'s fallback (RED-01) was read from the **6.3.32** source in the pub cache,
   which is the version in `pubspec.lock`. It was **not** confirmed on a device with Custom Tabs
   disabled — the code path is unambiguous, but the finding is SOURCE, not DEVICE.
