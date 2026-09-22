# Part 20 — Google Play blind-spot hunt (Wave 3-D, Opus, adversarial) — 2026-09-22

**Method.** Read `store_readiness_state.md` (full), `parts/09`, `parts/12` (POL-05/06/09/10/11/12 in
full, others by heading + verdict), `parts/03` §1–2, `parts/02`, `parts/14` (Play + permissions),
`parts/16` §1C/1D, §4, §6, §7. Everything already listed there is **excluded by construction** —
nothing below repeats a FE-/AND-/API-/SEC-/POL-/DECL-/REV- finding, though several sharpen or
re-time one, and that is said explicitly where it happens.

**Question answered:** *what would make me reject, delay, or later remove this app that the audit has
not listed?*

**Severity key** (same as parts 03/16): **A** upload/launch blocker · **B** must fix before launch ·
**C** should fix · **D** verify/advisory · **E** console/hygiene · **F** doc-only · **G** informational.

**Verification levels:** WEB = official Google page fetched this session, quoted ≤25 words ·
SOURCE = read in this repo · ARTEFACT = carried from parts/02 · PROJECTION = reasoned consequence.

---

## Headline

Three of the findings below are **schedule blockers that no part models**: Play's critical path for
this app is **not** "finish the app → submit". It is *prod backend → truthful Data safety form →
12 testers × 14 continuous days with real engagement → apply for production access → ≤7-day Google
review → production*. The Data safety form gates the **closed** track (only *internal* testing is
exempt), and the production-access application can be refused for "insufficient tester engagement" —
which is guaranteed while `TBD.example` ships and no cohort content is seeded. That is **four to six
weeks after the last code change**, and parts/16 §5 places declarations at step 8, after the stub
cull, which inverts the real order.

Two are **new policy exposures with verbatim Google text**: the store-listing art can get the app
**reclassified as child-appealing and rejected** (bird mascot + gamified assets), and Play's UGC
policy is **materially stricter and more explicit than Apple 1.2** — it demands report *and* block
*and* a terms-of-use acceptance gate before a user creates UGC, and Google's own definition of UGC
covers a leaderboard display name.

One **closes a trap the brief suspected**: the Families "phone number" clause is scoped to
`TelephonyManager`, so phone-OTP login is compatible with Families scope. Written up as a PASS so
nobody re-opens it.

---

## BS-D-01 · Severity A (schedule) · The Data safety form gates the **closed** testing track, so the 12×14 clock cannot start until six currently-false answers are true

**Issue.** Parts 09 (item 10d), 12 and 16 (REV-31) all treat the 12-testers × 14-days rule as a
calendar dependency and the Data safety form as a *submission* item (parts/16 §5 step 8, after steps
6–7). That ordering is wrong. The Data safety form is required for **closed** testing, not just
production — only the *internal* testing track is exempt.

> "All developers that have an app published on Google Play must complete the Data safety form,
> including apps on closed, open, or production testing tracks."
> — Data safety, https://support.google.com/googleplay/android-developer/answer/10787469 (WEB)

> "apps that are active on internal testing tracks are exempt from inclusion in the data safety
> section." — same URL (WEB)

**Why Google would raise it.** They would not "raise" it — the Console simply will not let the closed
release roll out. And the form cannot be filed truthfully today: parts/14 DECL-11 and parts/12 POL-11
list **six answers that would be false**, the largest being "users can request deletion = Yes" with no
in-app or web path, and the form is where the **web deletion URL** is entered (POL-04).

**Repo evidence.** `lib/core/config/app_config.dart:54` (prod URL placeholder) · parts/14 §"Flagged
answers that would be FALSE if filed today" (DECL-11, DECL-07a, DECL-21, DECL-06a) · parts/12 POL-11
§"Six answers…".

**Consequence.** The real dependency chain is
`prod URL (Seif) → account-deletion flow + hosted web deletion URL → Seif answers Q4–Q7 → Data safety
form → closed release → 14 continuous days → production-access application`. Every day the deletion
work slips pushes production back **by that day plus fourteen**.

**Action / owner.** Re-draw parts/16 §5 with Data safety **before** the closed test, not after the
stub cull. Use the **internal** track (Data-safety-exempt) for build validation in the meantime, so
engineering is not blocked by the form. Owner: **console/owner**, with backend (Seif) on the critical
input.

---

## BS-D-02 · Severity A (schedule) · Production access is an **application Google reviews**, it can be refused for "insufficient tester engagement", and engagement is impossible against a placeholder host

**Issue.** Part 09 item 10d and REV-31 record "12 testers × 14 days" as if satisfying it unlocks
production automatically. It does not. The developer must **apply**, and Google reviews the
application against three questionnaires and the testers' actual behaviour.

> "At least 12 testers must be opted in to your closed test when you apply for production access, and
> they must have been opted in continuously for the preceding 14 days."
> — https://support.google.com/googleplay/android-developer/answer/14151465 (WEB)

> "Review usually takes seven days or less, but can occasionally take longer." — same URL (WEB)

> "Reasons for required continued testing include having fewer than 12 opted-in testers or
> insufficient tester engagement during the testing period." — same URL (WEB)

**Why Google would raise it.** Twelve testers installing a build whose every request fails against
`https://TBD.example/api/v1` generate **zero engagement** — parts/16 §1C proves the reachable surface
is Onboarding + Login and nothing else. A test that produces a two-screen crawl and no sessions is
exactly the "insufficient engagement" case, and the remedy is *continue testing*, i.e. another 14 days.

**Repo evidence.** `lib/core/config/app_config.dart:54` · parts/02 ARTEFACT string scan (the
placeholder is the only base URL in the shipped snapshot) · parts/16 §1C step 3–5 · REV-19 (empty
Learn tab with no seeded cohort).

**Action / owner.** Confirm the developer account's type and creation date **today** — if it is a
personal account created after 13 Nov 2023, add **~3–4 weeks** to the plan (14 days + up to 7 days
review + re-test risk) and start the test only once the prod backend, a seeded cohort and the
deletion flow exist. Owner: **console/owner** + backend.

---

## BS-D-03 · Severity B · Developer identity verification: organisation accounts need a **D-U-N-S number** and publish a **legal address and phone number** on the listing; personal accounts publish a legal name

**Issue.** The state file lists only "developer verification" in the Android *package-registration*
sense (30 Sep 2026). The **Play Console account identity** requirement is separate, is already live,
has a long lead time, and decides what personal data about the owner is published next to an app used
by Egyptian 13–17-year-olds.

> "You will not be able to create a developer account for an organization without one."
> [a D-U-N-S number] — https://support.google.com/googleplay/android-developer/answer/13628312 (WEB)

> Organisation accounts display "Your legal name, legal address, developer email address, and
> developer phone number on Google Play." — same URL (WEB)

> Personal accounts display "Your legal name, your country (as per your legal address), and developer
> email address on Google Play." — same URL (WEB)

> mismatches with Dun & Bradstreet records can lead to "your developer account being restricted, which
> would remove all of your apps from Google Play" — same URL (WEB)

**Why it matters here, beyond bureaucracy.**
1. **Lead time.** A D-U-N-S number for a new Egyptian entity is requested from Dun & Bradstreet and
   commonly takes days to weeks. It is a prerequisite to *creating* the org account, i.e. it precedes
   everything else including the 14-day test.
2. **A minors' audience and a published address.** An organisation account publishes a **physical
   address and a phone number** on the public listing. If the "organisation" is the owner's home, that
   address is published to a teenage user base. A **personal** account publishes only name, country
   and email — materially less exposure, but it is the account type that triggers BS-D-02's 12×14 +
   application path. **These two facts pull in opposite directions and the trade-off is not recorded
   anywhere in the audit.**
3. **Termination risk is retroactive** — a later D&B mismatch removes *all* apps, not just this one.

**Repo evidence.** External (Console). Repo-side only insofar as the app declares a 13–17 audience
(parts/12 POL-05).

**Action / owner.** **Owner decision, this week:** org vs personal, with the published-address and the
12×14 consequences written down side by side; start the D-U-N-S request the same day if org. If
personal, budget a business address-of-record for the listing contact rather than a home address.
Owner: **owner** (+ legal).

---

## BS-D-04 · Severity B · The **store-listing artwork** can get the app reclassified as appealing to under-13s and rejected — and the app ships a bird mascot

**Issue.** Part 09 item 6a and POL-05 both frame the Families question as a *legal* question about
whether Egyptian law treats 13–17 as children. There is a second, purely **operational** route into
Families scope that nobody listed: Google judges the **store listing's marketing assets**, and can
reject on that basis alone regardless of what the developer declared.

> "If your app is not primarily designed for children under 13 but your listing contains marketing
> elements that suggest otherwise (such as youthful animation or young characters in the graphic
> assets), Google Play may reject your app."
> — https://support.google.com/googleplay/android-developer/answer/9867159 (WEB)

Google's own listed remedies are to "Remove any marketing elements in your store listing that may
appeal to children" **or** "Change the target age group(s) of your app to only include children under
13" (WEB, same URL) — i.e. the fix is a *listing* fix, applied after a rejection.

**Repo evidence.** `assets/images/bird_logo.svg` (SOURCE — the brand mark is an animal character) ·
`assets/images/onboarding_illustration.svg`, `assets/images/success_badge.svg`,
`assets/images/track_school.svg` · the product is built on points, levels, streaks and a podium
leaderboard (`lib/features/leaderboard/widgets/podium.dart`). The **feature graphic is not yet drawn**
(POL-10 — it is an unstarted design deliverable), so this is cheap to get right and expensive to get
wrong.

**Why a reviewer raises it.** A 1024×500 feature graphic built around a cartoon bird, confetti and a
podium, on an app declaring 13–17, is precisely the pattern the quoted sentence describes. The
rejection costs a listing round-trip; worse, the *alternative* remedy Google names is to declare
under-13, which drags the app into full Families scope.

**Second, sharper hook on the same page family.** For a child-audience app the in-app privacy-policy
link is unconditional:
> "For apps that target children: You must link to a privacy policy on your app's store listing page
> and within your app, regardless of your app's access to sensitive permissions or data."
> — https://support.google.com/googleplay/android-developer/answer/9859455 (WEB)
This removes any remaining argument about the auth-gated `/legal/*` routes (POL-12 §10c) if the
audience is ever read as including children.

**Action / owner.** Brief the designer **before** the feature graphic exists: teen-facing, not
child-facing — restrained palette, real UI, no infantilising characters in the *listing* assets (the
in-app mascot is not what Google inspects here). Keep target audience at 13–17. Owner: **design +
product**, gated by console.

---

## BS-D-05 · Severity G (PASS — closes an open question) · The Families "phone number" clause is scoped to `TelephonyManager`; **phone-OTP login is compatible with Families scope**

**Issue.** The brief hypothesised a trap: a phone-OTP app that Google deems child-appealing would be
pushed into Families policy, which allegedly bans transmitting phone numbers collected from children.
Part 09 item 6b asserted the obligations were "mostly trivially met" but never quoted the clause.
Fetched and resolved:

> "apps targeting children should not request the device phone number from the TelephonyManager API."
> — Families policy, https://support.google.com/googleplay/android-developer/answer/11043825 (WEB)

The banned-identifier list is device-derived only — "Android Advertising ID (AAID), SIM Serial, Build
Serial, BSSID, MAC, SSID, IMEI, IMSI" (WEB, same URL). A phone number **typed by the user into a form**
is not in scope of that clause.

**Repo evidence (confirms the app is on the right side of it).** Zero `READ_PHONE_STATE`, zero
`AD_ID`, no `TelephonyManager` anywhere — ARTEFACT permission set is exactly `INTERNET`,
`ACCESS_NETWORK_STATE`, `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (parts/02, parts/03 §2). The
`deviceId` is `Random.secure()` (`lib/core/storage/secure_storage.dart:72-83`), not a hardware id.

**Conclusion to record.** Even in the worst case — Google reclassifies the audience as including
children (BS-D-04) — the **technical** Families obligations are already satisfied at ARTEFACT level.
What would change is *paperwork and policy*: privacy policy becomes unconditional, the ads-SDK
self-certification rule attaches (vacuously — there are no SDKs), and a neutral age screen becomes
relevant only if the audience is **mixed**:
> "A neutral age screen is a mechanism to verify a user's age in a way that doesn't encourage them to
> falsify their age" — https://support.google.com/googleplay/android-developer/answer/9867159 (WEB)
Declaring 13–17 only (POL-05's recommendation) means no mixed audience and no neutral age screen is
required — but POL-05's recommended **age floor gate** should be built neutrally anyway, so it doubles
as the Families-compliant mechanism if the classification ever moves.

**Action / owner.** None technical. Record the quote in the Play review notes and stop re-litigating.
Owner: **console** (documentation only).

---

## BS-D-06 · Severity B (when the leaderboard ships) / C (now) · Play's UGC policy is **stricter and more explicit** than Apple 1.2 — it adds a **terms-of-use acceptance gate** the app has nowhere

**Issue.** POL-06 analyses user-generated content entirely against **Apple 1.2** and quotes only
Apple. Play's UGC policy is a separate instrument with a **broader definition** and an **extra
requirement**, and neither appears anywhere in the audit.

> "User-generated content (UGC) is content that users contribute to an app, and which is visible to or
> accessible by at least a subset of the app's users."
> — https://support.google.com/googleplay/android-developer/answer/9876937 (WEB)

> apps must implement "an in-app system for reporting and blocking objectionable UGC and users"
> — same URL (WEB)

> apps must require "users accept the app's terms of use and/or user policy before users can create or
> upload UGC" — same URL (WEB)

**Why this is not a duplicate of POL-06.** Three deltas:
1. **Definition.** Google's "visible to … at least a subset of the app's users" settles the question
   POL-06 argues from first principles: a free-text display name rendered on a peer's leaderboard **is
   UGC**, full stop. There is no room for the "it's only a rank list" reading on Play.
2. **Terms acceptance before creation.** Apple 1.2 has no equivalent. The display name is created in
   the registration wizard, and **there is no acceptance action anywhere in it** — grep of
   `lib/features/registration/` for agree/consent/terms returns nothing (SOURCE, this session). The
   only legal line in the app is a passive sentence on Login, `legalPrefix` = "By continuing, you agree
   to our" (`lib/l10n/app_en.arb:36`) pointing at `.example` URLs
   (`lib/features/auth/screens/login_screen.dart:43-46`). A passive sentence on a *different* screen,
   linking to a document that does not exist, is not "users accept … before users can create UGC".
3. **Block, explicitly.** POL-06's Option 1 lists block as one of four Apple sub-requirements; Play
   names reporting **and** blocking in a single sentence, which removes the argument that a report
   path alone suffices.

**Repo evidence.** `lib/core/router/app_router.dart:169-170` (board is a placeholder today — which is
why this is C and not B *now*) · `lib/features/leaderboard/widgets/leaderboard_row.dart:89`,
`podium.dart:154` (`entry.name` is the peer-visible free text) · zero report/block UI in `lib/`
(grep) · registration consent grep → none (SOURCE).

**Action / owner.** POL-06's **Option 0** (never render a peer's name) remains the cheapest answer and
now has a second, stronger justification: it avoids Play's terms-acceptance requirement as well as
Apple's four. If Option 1 is chosen, add to POL-06's change-request list: **an explicit terms
acceptance control in the registration wizard, gating submission**, plus a published objectionable-
content definition in the Terms document. Owner: **product + frontend**, change requests to Seif.

---

## BS-D-07 · Severity B · `FLAG_SECURE` blocks the **marketing** screenshots too — you cannot photograph the core feature, and Play requires screenshots that show it

**Issue.** REV-16 and parts/10 §3 cover the *pre-launch report* consequence of `FLAG_SECURE` (black
Robo screenshots) and parts/12 POL-03 supplies a "KNOWN BEHAVIOUR, NOT A CRASH" paragraph for the
reviewer notes. **Nobody covered the store-listing asset production problem**, which is a hard publish
gate rather than a cosmetic one.

> "Screenshots must demonstrate the actual in-app or in-game experience, focusing on the core features
> and content" — https://support.google.com/googleplay/android-developer/answer/9866151 (WEB)

Play also requires a "minimum of two screenshots" to publish a listing (WEB, same URL).

**Repo evidence.** Screen protection is enabled on **both** answer-bearing screens —
`lib/features/quiz/screens/quiz_screen.dart:62` and
`lib/features/quiz/screens/quiz_review_screen.dart:55`, via
`lib/features/quiz/screens/screen_protection.dart:34` `ScreenProtector.preventScreenshotOn()` →
`FLAG_SECURE` (`ScreenProtectorPlugin.kt:27-30`, parts/03 §3). The quiz **is** the core feature.

**Why this bites.** Every on-device capture route is blocked: system screenshot, `adb shell screencap`
(project memory confirms black output on the quiz screen), and screen recording. So the marketing
screenshots of the app's flagship surface must come from a **build with screen protection disabled** —
which must then *not* be the build that is uploaded, and must still show the genuine UI so the
screenshots stay truthful under the quoted rule.

**Action / owner.** Add a dedicated, documented capture path — e.g. a `--dart-define` that swaps
`screenProtectionProvider` for a no-op (the provider indirection at
`screen_protection.dart:40-41` already makes this a one-line override) — used **only** for asset
capture, never for a shipped artefact, and guarded by the existing release-entrypoint guard pattern
(`test/guards/workflow_test.dart:147-273`). Budget the capture session **after** the prod URL and a
seeded cohort exist, because empty states are not publishable screenshots (REV-19). Owner: **frontend
+ product/design**; this is on the same critical path as BS-D-01/02.

---

## BS-D-08 · Severity B (framing, not a new defect) · On Play a completeness rejection is not free — removals and suspensions accumulate into **strikes** and can terminate the account

**Issue.** POL-09 and parts/16 treat the "Coming soon" tabs and stub screens as a rejection risk, with
rejection implicitly costing a round-trip (the Apple model). Play's enforcement model is different and
nobody stated it, which changes how much the stub cull is worth.

> "Rejections don't impact the standing of your Google Play Developer account."
> — Enforcement process, https://support.google.com/googleplay/android-developer/answer/9899234 (WEB)

> "Removals don't immediately impact the standing of your Google Play Developer account, although
> multiple removals may result in a suspension." — same URL (WEB)

> "suspensions count as strikes against the good standing of your Google Play Developer account.
> Multiple strikes can result in the termination of individual and related Google Play Developer
> accounts." — same URL (WEB)

**Why it matters for this app specifically.** A pre-publication rejection is cheap. But the surfaces
POL-09 lists are exactly the ones that draw **post-launch** enforcement, where the action is a
**removal**, not a rejection: two of five primary nav tabs rendering "Coming soon"
(`app_router.dart:169-170, 268-271`), four notification toggles controlling nothing
(`settings_screen.dart:357-393`), a referral input that is never transmitted
(`registration_draft.dart:17`), and a destructive-sounding disabled dialog (REV-34). A "Broken
Functionality"/Deceptive-Behavior removal against a brand-new account with no enforcement history is
the first step of a ladder that ends in termination — and termination is stated to reach "related"
accounts, which for a solo developer means their other Google identities.

**Action / owner.** Reprice POL-09's stub cull from "reduce rejection risk" to **"avoid the first
strike on a new account"**, and do it before the *closed test* (uploads to closed tracks are reviewed
too), not before production. Owner: **product + frontend**.

---

## BS-D-09 · Severity B · The application ID is a **template slug**, it is permanent, and it is still unclaimed — decide it before the **first** upload of any kind

**Issue.** `com.levelup.level_up_app` came from the scaffold, still carries the Flutter template's
"Specify your own unique Application ID" TODO (AND-15, treated as cosmetic), and differs from the iOS
bundle id `com.levelup.levelUpApp` (IOS-17, rated "harmless"). Nobody noted that on Play the
application ID is **irrevocable**: it cannot be changed after the first upload, it identifies the app
for developer verification / package registration (the 30 Sep 2026 item), and a name consumed by a
suspended or deleted app is not returned to the pool.

**Verified.** `https://play.google.com/store/apps/details?id=com.levelup.level_up_app` → **HTTP 404**
(WEB, this session) — the identifier is currently **unclaimed**, so the decision is still free. That
window closes at the first upload to *any* track, including internal testing.

**Repo evidence.** `android/app/build.gradle.kts:42` (template TODO), `:48-49` ·
`applicationId`/`namespace` `com.levelup.level_up_app` (parts/03 §4) · ARTEFACT `package` line
(parts/02) · iOS `PRODUCT_BUNDLE_IDENTIFIER` `com.levelup.levelUpApp` (IOS-17).

**Why a reviewer/ops person raises it.** They do not — this is a self-inflicted, irreversible one.
Underscores are legal in an Android application ID, so `level_up_app` is *valid*; it is simply a
scaffold artefact that will appear in crash reports, intent URIs, the custom
`com.levelup.level_up_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` string, and (for anyone who looks)
the Play URL, forever.

**Action / owner.** **Before any upload**, confirm in one decision: (a) keep or change the Android
application ID — `com.levelup.app` or `com.levelup.levelup` would match the brand and the iOS side;
(b) accept or fix the iOS/Android divergence; (c) delete the template TODO. Then register the package
for developer verification. If the answer is "keep", record it as a decision so it is never reopened.
Owner: **owner + app**.

---

## BS-D-10 · Severity C · The **Advertising ID declaration** is a separate mandatory App-content item from "Contains ads", and nothing guards against a future plugin adding `AD_ID`

**Issue.** POL-12 item 1 lists the declarations that must be *answered* (Financial, Health,
Government, News, Ads). It does not list the **Advertising ID** declaration, which is a distinct
App-content entry required of every app targeting Android 13+ and cross-checked against the merged
manifest.

> apps targeting Android 13+ "need to declare a Google Play services normal permission in the manifest
> file as: `com.google.android.gms.permission.AD_ID`" when they use the advertising ID
> — https://support.google.com/googleplay/android-developer/answer/6048248 (WEB, via search summary)

> "If your app uses SDKs as dependencies, the AD_ID permission from the SDK's library manifest will be
> merged with your app's main manifest by default" — same source (WEB)

**Repo evidence.** Answer is **No** and it is ARTEFACT-true today: `aapt2 dump permissions` yields
exactly three permissions, none of them `AD_ID` (parts/02, parts/03 §2). The exposure is forward-
looking: **AND-08** records that CI only greps for `INTERNET` being *present*
(`.github/workflows/ci.yml:397`), so a future dependency that merges `AD_ID` into the manifest would
ship silently — and then the shipped manifest would **contradict a filed "No" declaration**, which is
a data-declaration mismatch rather than a build bug.

**Action / owner.** Answer the Advertising ID declaration **No** explicitly (an unanswered App-content
item blocks releases, same as the Financial form). Then convert AND-08 from "should fix" to a blocking
guard: diff `aapt2 dump permissions` against a three-entry allow-list in CI — per CLAUDE.md's own rule
3, this is a rule that can be a test, so it should be one. Owner: **console** + **DevOps**.

---

## BS-D-11 · Severity C · The **default store-listing language**: an English-only reviewer instruction sheet describing an app that opens in Arabic, in a listing whose default language is unset

**Issue.** REV-02 establishes that the app **always** opens Arabic/RTL regardless of device locale,
and POL-03 supplies Play "Any other instructions" text that must be in English. No part addresses the
**listing's default language**, which is set once at app creation and cannot be changed afterwards,
and which determines what the reviewer and Google's policy systems read by default.

**Why Google would raise it.** They do not raise it as a violation — the damage is procedural: a
reviewer whose Console locale resolves to an Arabic default listing, running an app that renders
entirely in Arabic RTL, with only the App-access box in English, has no English-language description
of what they are looking at. That materially raises the odds of a "could not evaluate"/App-access
rejection on a build whose *only* real problem is language mismatch. Note also that Play offers
**Arabic (`ar`)** as a listing language — there is no `ar-EG` variant — so the Egyptian targeting is
expressed through the country list, not the listing locale.

**Repo evidence.** `lib/core/locale/locale_provider.dart:23-24` (fallback `const Locale('ar')`, no
`Platform.localeName`) · `lib/app.dart:58` · iOS bundle declares `en` only (IOS-07) — so the two
platforms' metadata would disagree about the app's language if this is not decided once.

**Action / owner.** Set the **default listing language to English (US)** and add Arabic as a
translation; state in the App-access notes, in English, that the app intentionally launches in Arabic
RTL and where the language pill is (parts/16 REV-37 already proposes extending the paste-able block —
add this line there rather than writing new text). Owner: **console + product**.

---

## BS-D-12 · Severity D · Category choice — Apps → **Education** vs Games → **Educational** — changes the questionnaire, the child-appeal scrutiny and the Teacher-Approved path

**Issue.** The state file and part 09 assume "Play category = Education" without recording it as a
decision. Play has both an *Apps* category (Education) and a *Games* category (Educational), and the
choice is not cosmetic: a **Games** classification routes the app through the game IARC questionnaire,
places it in the Games tab where child-appeal review is more aggressive (interacting with BS-D-04),
and changes eligibility for the Teacher Approved programme (an Apps-side, invitation-based programme,
not something to opt into).

**Repo evidence / why it is a live question.** The product is a *quiz engine* with points, levels,
streaks, a countdown timer and a podium leaderboard (`lib/features/quiz/`,
`lib/features/leaderboard/widgets/podium.dart`) — i.e. it reads as a game to a classifier even though
it is a study tool. Part 09 item 6c's conclusion that Child Safety Standards do not apply rests on
"Play category = Education"; if the category were ever set to a Games category, that reasoning would
need re-checking.

**Action / owner.** Record **Apps → Education** as an explicit decision with the reasoning, and add
"category" to the release checklist alongside the IARC re-run trigger POL-12 item 9 already diarises.
Owner: **console + product**.

---

## BS-D-13 · Severity D · The pre-launch report runs an **accessibility** scan, and the app has almost no semantics

**Issue.** Parts 09/16 model the PLR only for crashes, security findings and black screenshots.
Google's PLR also runs an accessibility pass (touch targets < 48 dp, missing item labels, low
contrast) and surfaces it in the Console as a per-screen list. The findings are advisory, not
blocking — but they appear on every release and are the kind of signal that gets quoted back during an
appeal.

**Repo evidence (SOURCE, counted this session across ~36k lines of `lib/`).** `Semantics(` appears in
**21 files**; `semanticsLabel` appears **3 times**; `tooltip:` appears **3 times**. The app is
icon-heavy — `assets/icons/nav/{home,learn,leaderboard,message,account}.svg`, `chevron.svg`,
`notification.svg`, `language.svg`, `stopwatch.svg` — and `flutter_svg` renders an `SvgPicture` with
**no semantic label unless one is passed**. Flutter only materialises its semantics tree when an
accessibility service is active, which is exactly what the PLR's scanner does, so the scan will see
whatever labels exist — and mostly it will see none.

**Why a reviewer would care.** They would not reject for it. The risk is reputational and cumulative:
a first release whose PLR lists dozens of unlabelled controls, on an app for students (a population
with above-average assistive-tech use in the education context), is a bad first artefact to have on
file — and the fix is cheapest now, before 36k lines become 60k.

**Action / owner.** Pass `semanticsLabel` on every `SvgPicture` used as a control, and add `tooltip:`
to icon-only `IconButton`s; verify the five bottom-nav destinations expose their labels. Then read the
PLR accessibility section on the first closed-track upload rather than only the crash section.
Owner: **frontend**. *(Note: parts/17 covers repo blind spots and may overlap on the Flutter
semantics point; the PLR-surfacing angle is the part that is Play-specific.)*

---

## BS-D-14 · Severity C · Post-launch, Play acts on **Android vitals**, and the app is blind to the only signal Play acts on

**Issue.** FE-14 / SEC-11 note "no global error handlers/crash reporting" as an engineering gap.
Nobody connected it to Play's **post-launch enforcement**: Android vitals' bad-behaviour thresholds
(user-perceived crash rate and ANR rate) drive Console warnings and **store-listing demotion in
discovery**, and they are computed from Play's own telemetry, not the app's.

**Why this is a Play finding, not a repo finding.** Play will tell the team *that* the app crashes
and demote it; with R8 obfuscation on it will even deobfuscate the traces (the AAB carries the mapping
— parts/02). But with no `FlutterError.onError` / `PlatformDispatcher.instance.onError` handler and no
crash reporter, the team has **no pre-release signal** and no per-user context, so the first knowledge
of a regression is a vitals threshold breach after it has already reached users. Combined with a new
account that has no enforcement history (BS-D-08), the team's remediation speed is the thing under
test.

**Repo evidence.** FE-14 / SEC-11 (no handlers) · parts/02 (R8 on, mapping + native symbols ship in
the AAB — so Play-side deobfuscation already works, which is the one half that is solved) ·
`.github/workflows/ci.yml:377` (CI builds an APK only — AND-07 — so nothing currently produces the AAB
that carries the mapping).

**Action / owner.** Two cheap halves: (1) install global `FlutterError.onError` +
`PlatformDispatcher.instance.onError` handlers that surface a user-facing error state and **log
nothing personal** (CLAUDE.md's no-PII-logging rule makes a third-party crash reporter an owner
decision with new Data-safety rows, so do not assume one); (2) put "read Android vitals + the PLR"
into the post-release checklist with the thresholds written down. Owner: **frontend** (1), **owner**
(2, and the crash-reporter decision that FE-14 already raises).

---

## BS-D-15 · Severity C · Data-safety **mismatch** enforcement vs the deliberate decision to declare `model` nowhere

**Issue.** POL-11(c) and parts/14 both conclude — correctly on the taxonomy — that device `model` has
**no** Play Data-safety type and should not be declared, with the recommended fix being to stop
sending it. The unlisted risk is what happens **if it ships undeclared**: Google's Data-safety review
compares declarations against observed app behaviour, and "declared nothing" for a field that is
visibly transmitted in a request body is the shape of a mismatch finding — which is an enforcement
action against a *declaration*, treated more harshly than the underlying collection (POL-05's own
reasoning about false declarations applies here too).

**Repo evidence.** `lib/core/device/device_info_provider.dart:19-27` (`model`, `platform` read and
sent) · `contract/openapi.yaml:2239-2247` (DeviceInfo; `model` optional, purpose = "display label for
eviction messaging") · parts/14 §"Ambiguity carried forward from POL-11(c)" (explicitly recommends no
row) · REV/ENT: the eviction message that `model` exists for is **never rendered** by the app.

**Why this is decidable rather than ambiguous.** Because `model` is *optional in the contract* and its
only consumer is a UI surface that does not exist, the ambiguity is entirely self-imposed. Dropping
the field removes a mismatch vector on Play, removes the Apple nutrition-label ambiguity, and removes
the `device_info_plus` dependency that drives ITMS-91053 on iOS (POL-07). One change, three findings.

**Action / owner.** Escalate "stop sending `model`" from a *recommendation inside three other
findings* to a tracked work item with an owner, because three separate parts now depend on it.
Owner: **frontend**, with a one-line note to Seif that the optional field will not be sent.

---

## BS-D-16 · Severity C · The Robo crawler and the device-binding eviction collide during the **14-day closed test**, not only during review

**Issue.** REV-15/15b and API-16 establish that one-session-per-student binding evicts concurrent
reviewers and Play's Robo device farm. Both frame it as a *review-window* hazard. Re-timed: the PLR
runs on **every upload to a testing track**, so the collision starts on day 1 of the closed test and
repeats for 14 days — while 12 human testers are also signing in, on their own devices, and evicting
each other if they share accounts.

**Why it changes the ask to Seif.** POL-03's request is "≥3 production reviewer numbers". The closed
test needs **12 distinct, working student accounts that can hold sessions simultaneously**, plus the
Robo number, plus the spare — and they must survive 14 days without expiry, against a rate limiter
whose magnitudes are unknown (part 05 Q13, API-21). That is a materially bigger backend ask than "3
numbers", and it lands earlier than anyone has scheduled it.

**Repo evidence.** `contract/openapi.yaml:56-60, 178-181, 401-403` (eviction), `:86-88, 169` (per-IP
OTP throttle), `:443` (`/reference/*` per-IP limit) · `lib/core/network/auth_interceptor.dart:131,
148-150` (forced logout) · parts/16 §1D items 1–3.

**Action / owner.** Fold into the single Seif ask: **12 tester accounts + ≥3 reviewer numbers + Robo
number**, all pre-registered, entitled, seeded, per-IP exempt, no expiry, valid for at least the test
window plus the review window. Owner: **backend (Seif)** → **console/owner**.

---

## BS-D-17 · Severity D · Title "Level Up" — no uniqueness rule, but a live **trademark takedown** vector, and the app has no brand clearance on file

**Issue.** Part 09 note 11 correctly finds no rule tying the manifest label to the listing title and no
uniqueness requirement, and POL-10 covers the placeholder-identity problem. Nobody covered the
*post-launch removal* vector: Play operates a separate trademark/copyright complaint channel that is
**not** a policy review — a rights-holder complaint can remove the listing independently of everything
in this audit, and "Level Up" is a common commercial mark (notably in US payments/loyalty) as well as
a generic phrase.

**Why it is D and not higher.** Different goods/services class (education software vs payments), a
different territory (Egypt), and a descriptive phrase — the risk is low. But it is unmitigated, the
brand string is not yet settled (three different strings ship today — POL-10 / IOS-11), and the cost
of discovering it *after* the 12×14 test and a production-access approval is an entire relaunch under
a new package name (BS-D-09 makes that irreversible).

**Repo evidence.** `lib/l10n/app_en.arb:3` `appTitle` "Level Up" · `AndroidManifest.xml:27`
`android:label="level_up_app"` · `ios/Runner/Info.plist:8,16`.

**Action / owner.** Before the brand string is frozen (POL-10 action), do a 30-minute clearance pass:
search Play and the App Store for "Level Up" in Education, and check the Egyptian trademark register
for the mark in the relevant class. Record the result as a decision. Owner: **owner** (+ legal if
anything turns up).

---

## BS-D-18 · Severity E · Console items nobody listed, each a one-click answer that blocks a release if left blank

| # | Item | Why | Source |
|---|---|---|---|
| a | **US export laws acknowledgement** at app creation | Required when creating the app in Play Console; Google is a US company so a download is an export. One checkbox — but it is at *creation* time, i.e. it precedes the internal-track upload, not the submission | "developers must acknowledge the 'Developer Program Policies' and 'US export laws' declarations" — https://support.google.com/googleplay/android-developer/answer/9859152 (WEB, via search summary) |
| b | **Advertising ID declaration = No** | See BS-D-10; distinct from the "Contains ads" answer | answer/6048248 (WEB) |
| c | **Store-listing contact details are published** | Play publishes the developer email (and, for org accounts, the phone number and legal address) beside an app used by minors — the same exposure as BS-D-03, reached by a different form | answer/13628312 (WEB) |
| d | **The web account-deletion URL becomes public** | It is entered in the Data safety form and Play surfaces it on the public listing's Data safety section. The page must therefore be safe to expose anonymously and must not leak whether a given phone number has an account | answer/13327111 (part 09 item 3) |
| e | **No payments profile is needed** — and say so | A free app with no Play Billing needs no merchant account. Worth one line in the Play notes: the purchase-silent model means there is *nothing* for Play's billing policy to attach to (ARTEFACT: no Play Billing in `dependencies.pb`, parts/02) | parts/02 ARTEFACT |

**Action / owner.** Add (a)–(d) to the console checklist; add (e) to the Play "Any other instructions"
block drafted in POL-03. Owner: **console/owner**.

---

## Checked and PASS (stated so they are not re-hunted)

| Area | Finding | Level |
|---|---|---|
| Families technical obligations | Even under a worst-case reclassification, all of them already hold: no AAID/IMEI/SIM/MAC/SSID, no `READ_PHONE_STATE`, no `TelephonyManager`, no ads, no third-party SDKs. See BS-D-05 | ARTEFACT + WEB |
| Package name legality | Underscores are valid in an Android application ID; `com.levelup.level_up_app` is syntactically fine. The problem is that it is a slug and permanent (BS-D-09), not that it is illegal | SOURCE |
| Package name availability | `play.google.com/store/apps/details?id=com.levelup.level_up_app` → 404: unclaimed as of 2026-09-22 | WEB |
| Child Safety Standards (14747720) | Part 09 item 6c's N/A verdict holds — scope is Social/Dating/anonymous-chat, and a leaderboard is not messaging. **Conditional on removing the "Message" tab (REV-06/POL-12 10a) and on the category staying Apps→Education (BS-D-12)** | WEB + SOURCE |
| Neutral age screen | Not required while the declared audience is 13–17 only (no mixed child/adult audience). POL-05's recommended age gate should still be built *neutrally* so it doubles as the Families mechanism if the classification moves | WEB |
| Play SDK Console / SDK index | The AAB's `dependencies.pb` is androidx + kotlin-stdlib + Tink + gson + okio + the Flutter engine. No ad, analytics, attribution or billing SDK, so nothing that the SDK index flags for policy | ARTEFACT |
| `<queries>` / package visibility | `PROCESS_TEXT` only; no `QUERY_ALL_PACKAGES`; no Play declaration form applies (PERM-04) | ARTEFACT |
| `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | AndroidX-generated signature permission; no Data-safety or declaration implication | ARTEFACT |
| Payments profile / merchant account | Not required for a free app with no Play Billing | ARTEFACT |

---

## UNVERIFIED — leads, not facts

1. **Whether an Android **emulator** honours `FLAG_SECURE` for host-side captures.** If it does not, BS-D-07's capture problem may have a cheaper answer than a custom build. Test before building the `--dart-define`.
2. **Whether the developer account already exists, its type, and its creation date.** BS-D-02 and BS-D-03 both branch on this and neither can be closed from the repo. *This is the single highest-value unknown in this part.*
3. **D-U-N-S lead time for an Egyptian entity.** Commonly days to weeks; not verifiable here.
4. **Whether Play's production-access review has a published SLA beyond "seven days or less, but can occasionally take longer"** — that sentence is the only committed figure found.
5. **Whether the Egyptian trademark register holds a conflicting "Level Up" mark** (BS-D-17). Not searched.
6. **Exact Android vitals bad-behaviour thresholds as of Sep 2026** (BS-D-14). The thresholds have moved historically; read them in the Console rather than quoting a remembered number.
7. **Whether Play's Data-safety automated review actually inspects request bodies** (BS-D-15) or only SDK/permission signals. The conservative reading is assumed.

---

## Where this part sharpens or re-times an earlier one

| # | Earlier claim | This part |
|---|---|---|
| 1 | parts/16 §5 places declarations at step 8, after the stub cull, before submission | **Re-timed.** The Data safety form gates the *closed* track, so it precedes the 14-day test, which precedes a reviewed production-access application. The tail of the plan is ~3–6 weeks longer than the diagram implies (BS-D-01, BS-D-02) |
| 2 | REV-31 / part 09 item 10d: "12 testers × 14 days" as a calendar item | **Sharpened.** It is 12 testers × 14 days **plus an application Google reviews and can refuse for insufficient engagement** — which a placeholder base URL guarantees (BS-D-02) |
| 3 | POL-06 analyses UGC solely under Apple 1.2 | **Extended.** Play's UGC policy defines UGC to cover a peer-visible display name and adds a **terms-of-use acceptance gate before creation** that the registration wizard has nowhere (BS-D-06) |
| 4 | POL-05 frames Families scope as an Egyptian-law question | **Extended.** There is a second route in — Google judging the *listing artwork* as child-appealing — with a rejection quote and a bird-mascot repo fact (BS-D-04). Separately, the Families phone clause is `TelephonyManager`-scoped, so phone-OTP is safe (BS-D-05) |
| 5 | REV-16 covers FLAG_SECURE for the pre-launch report | **Extended.** It equally blocks *marketing* screenshot capture of the core feature, against a Play rule requiring screenshots of the core experience (BS-D-07) |
| 6 | POL-09 prices the stub cull as rejection-avoidance | **Re-priced.** Post-launch the same surfaces draw a *removal*, and removals ladder to suspensions, strikes and account termination (BS-D-08) |
| 7 | AND-15 / IOS-17 treat the template application ID and the iOS/Android divergence as cosmetic | **Re-rated B.** The ID is permanent from the first upload and is currently still unclaimed — the decision window is open now and closes at the first internal-track upload (BS-D-09) |
| 8 | POL-11(c) / parts/14 resolve device `model` as "declare nothing, ideally stop sending" | **Sharpened into a work item.** Undeclared-but-transmitted is the shape of a Data-safety mismatch, and three separate findings now depend on the same one-line removal (BS-D-15) |

---

## Recommended actions, dependency-ordered (Play only)

| # | Action | Owner | Blocks |
|---|---|---|---|
| 1 | Establish the developer account's type and creation date; decide org vs personal with the published-address trade-off written down; start D-U-N-S if org | **owner** | everything |
| 2 | Freeze the application ID (and the brand string) **before any upload to any track**; run the trademark clearance pass | **owner + app** | first upload, permanently |
| 3 | Re-draw the critical path: prod URL → deletion flow + web URL → Seif Q4–Q7 → **Data safety** → closed test (14 d) → production-access application (≤7 d) | **console/owner** | the launch date |
| 4 | Extend the Seif ask to **12 tester accounts + ≥3 reviewer numbers + a Robo number**, all seeded, entitled, per-IP exempt, non-expiring | **backend → console** | the closed test |
| 5 | Brief the designer that **listing** assets must read teen, not child; keep the mascot in-app | **design + product** | the feature graphic |
| 6 | Add a capture-only screen-protection override and schedule the screenshot session after the backend and seeding land | **frontend + design** | listing publication |
| 7 | Do the POL-09 stub cull **before the closed test**, not before production | **product + frontend** | first strike risk |
| 8 | Console: Advertising ID = No, US export acknowledgement, default listing language English (US) + Arabic translation, category Apps → Education | **console** | release rollout |
| 9 | Drop device `model` (one change closes BS-D-15, POL-07 and POL-11(c)); add the CI permission allow-list diff (AND-08 → guard test) | **frontend + DevOps** | declaration accuracy |
| 10 | If the leaderboard ships: add a terms-acceptance gate to registration **and** report + block, or take POL-06 Option 0 | **product + frontend + Seif** | the board release |
| 11 | Semantics labels on SVG controls; global error handlers; read the PLR accessibility section and Android vitals after the first upload | **frontend** | quality signals |

---

## Policy sources used (all fetched this session)

- Target audience & content — https://support.google.com/googleplay/android-developer/answer/9867159
- Families policy (data practices) — https://support.google.com/googleplay/android-developer/answer/11043825
- User-generated content — https://support.google.com/googleplay/android-developer/answer/9876937
- Developer identity verification / D-U-N-S / public details — https://support.google.com/googleplay/android-developer/answer/13628312
- Closed testing + production access — https://support.google.com/googleplay/android-developer/answer/14151465
- Data safety (track scope) — https://support.google.com/googleplay/android-developer/answer/10787469
- Prepare your app for review (privacy policy for child audiences) — https://support.google.com/googleplay/android-developer/answer/9859455
- Enforcement process (warnings/removals/suspensions/strikes) — https://support.google.com/googleplay/android-developer/answer/9899234
- Store listing assets (screenshots, feature graphic) — https://support.google.com/googleplay/android-developer/answer/9866151
- Advertising ID — https://support.google.com/googleplay/android-developer/answer/6048248
- Create and set up your app (export laws acknowledgement) — https://support.google.com/googleplay/android-developer/answer/9859152
- Package availability probe — https://play.google.com/store/apps/details?id=com.levelup.level_up_app (404)
