# Part 12 — Policy gap analysis (Wave 1-D, Opus) — 2026-09-22

**Scope.** Applies the researched policy in parts 08 (Apple) and 09 (Google) to what the repository
actually does at HEAD `bf967d6`. Read-only: no repo file outside this one was created or modified.

**Inputs read in full:** parts 01, 02, 03, 04, 05, 06, 08, 09; `../store_readiness_state.md`;
`C:\Users\musta\Downloads\flutter-partner-web-redemption-warning-v3.md` (adr-171 + spec-036, FINAL
2026-09-16 — authoritative for redemption).

**Verification levels.** SOURCE = read in this repo this session · PARTS = taken from a Wave-0/1 part
file · WEB = re-read from the official page by this session (2026-09-22) · UNVERIFIED = flagged.

**Re-confirmed at source this session (WEB).** Four fetches were made, only to confirm quotes that
carry weight in a verdict:

| Page | What it confirmed |
|---|---|
| developer.apple.com/app-store/review/guidelines/ | 3.1.1 (license keys), 3.1.1(a), 3.1.3 intro, 1.2's four requirements — **verbatim, exactly as part 08 reports them** |
| support.google.com/…/answer/10281818 | consumption-only definition; the permitted in-app phrasings; the "administrative information … does not eventually lead" sentence — **part 09's "tool paraphrase" caveat (note 8, ambiguity list) is now CLOSED; the wording is confirmed** |
| developer.apple.com/support/offering-account-deletion-in-your-app/ | deactivate-is-insufficient; slow deletion acceptable **if the user is told how long and gets a completion confirmation**; link-to-web-page; re-authentication allowed; no support-only flows outside regulated industries |
| support.google.com/…/answer/13327111 | web link required **in addition to** the in-app path, submitted **in the Data safety form**, must name the app/developer |

One fetch failed: Apple's `describing-use-of-required-reason-api` page (404 / JS-rendered, same as
part 08 reported). POL-07 therefore rests on part 08's quote and is flagged.

**Severity legend.** A blocker · B high · C medium · D low · E external/owner-or-console · F pass · G n/a.

---

## Headline

Two findings drive everything else:

1. **The two stores are not equally strict here, and the gap is wide enough that release 1 should not
   ship the same subscription-area UI on both.** Google explicitly blesses consumption-only apps and
   even blesses the *sentence* "Go to our website to upgrade your subscription to Premium". Apple
   bans out-links and calls to action on every storefront except the US, and Egypt is not one of the
   five External-Purchase-Link territories. adr-171's single neutral link is **fine on Play** (subject
   to a landing-page certification) and is an **Apple blocker on the Egypt storefront**.
2. **Nothing else matters until a reviewer can sign in.** The prod base URL is a placeholder and the
   only OTP bypass is staging-only *by contract*. Both stores reject on this alone, and every other
   finding in this file is untestable by a reviewer until it is fixed.

Then a third, structural one that no agent stated: **the contract's one-device-one-session rule
(`session_superseded`) collides with how App Review and Play's pre-launch report actually work** —
see POL-03 §3.

---

## POL-01 — Apple 3.1.1 / 3.1.3 vs the purchase-silent model

**Verdict: A (blocker) for adr-171's planned link on iOS/Egypt · C (medium) for the current
no-link build.**

### Policy

> "Apps may not use their own mechanisms to unlock content or functionality, such as license keys"
> — Guideline 3.1.1, https://developer.apple.com/app-store/review/guidelines/ (WEB, verbatim)

> "apps and their metadata may not include buttons, external links, or other calls to action that
> direct customers to purchasing mechanisms"
> — Guideline 3.1.1(a), same URL. Full sentence scopes this to "all other storefronts, except for the
> United States storefront". (WEB, verbatim)

> "cannot, within the app, encourage users to use a purchasing method other than in-app purchase,
> except for apps on the United States storefront"
> — Guideline 3.1.3 intro, same URL. (WEB, verbatim)

Supporting, from part 08 note 3: 3.1.3(b) multiplatform requires the items be "also available as
in-app purchases within the app"; 3.1.3(a) reader apps are limited to "magazines, newspapers, books,
audio, music, and video" (education does not qualify); 3.1.3(c) enterprise excludes "Consumer, single
user, or family sales"; 3.1.3(f) free stand-alone companions are exampled as "VoIP, Cloud Storage,
Email Services, Web Hosting". The External Purchase Link entitlement exists only for EU/EEA, South
Korea, Russia, Brazil and Japan — **Egypt is not on the list**.

### Repo evidence

- Purchase-silence is real and ARTEFACT-proven: no CTA in the limit sheet
  (`lib/features/quiz/.../limit_sheet.dart:91-96`), no Subscription row
  (`profile_screen.dart:241-242`), ARB grep clean for EGP/Paymob/Fawry/Vodafone/InstaPay/website/
  upgrade (part 01 §2), and the shipped Dart snapshot contains **11 distinct URL literals**, none of
  which is a purchase or redemption URL (part 02, string scan of `libapp.so`).
- The three `x-consumers: [web]` redemption operations are never called — `grep redemption` → 0 hits
  in `lib/` (part 05 census; independently re-checked this session).
- Neutral copy names the entitlement without saying where it comes from:
  `subscriptionRequiredBody` "This lesson needs an active subscription." (`lib/l10n/app_en.arb:484`),
  `errorSubscriptionRequired` (`:495`), AR at `app_ar.arb:202,:207`.
- adr-171 §2 requires **exactly one neutral link** in the account/subscription area, system browser
  only, behind a leave-the-app confirmation, bare URL. `lib/features/subscription/` is empty — **not
  built at HEAD** (state file, REDEMPTION STATUS).

### Reasoning

**Is the current app acceptable?** The *code* posture is the strongest available and I rate it a
pass on its own terms — there is no button, no link, no price, no provider name, no checkout, and
nothing in the binary that could be read as a call to action. What remains is not an engineering
defect and cannot be engineered away: **no 3.1.3 exception cleanly authorises a consumer education
subscription sold only on the web with no IAP at all.** 3.1.3(b) would authorise it *if* an IAP
equivalent existed; 3.1.3(a) and (c) exclude it by subject matter and buyer type; 3.1.3(f)'s
*requirement* ("no purchasing inside the app, or calls to action for purchase outside of the app") is
exactly what the app does, but its enumerated examples are infrastructure services, not education.

So the honest verdict on HEAD is **C**: a residual, non-zero business-model risk that a reviewer may
open by asking "how does a user get a subscription?", with an answer that Apple's text does not
bless. It is mitigated — not removed — by (a) honest App Review Notes (POL-03), and (b) an *entitled*
reviewer account so the reviewer never lands on the locked state and never has to ask. Part 01 rates
this F (code) while the state file rates it HIGH (business) — **both are right at different levels**;
I record the disagreement rather than collapsing it.

**Is adr-171's link acceptable on Egypt?** No, not on iOS. Three independent reasons:

1. **3.1.1(a) is categorical and Egypt is in scope.** The clause bans "external links **or other calls
   to action** that direct customers to purchasing mechanisms". The test is the *destination's
   function*, not the tap's label. A page whose purpose is to turn money already spent into an active
   subscription is part of a purchasing mechanism even if the money moved earlier and elsewhere.
2. **The 3.1.1 "license keys" sentence cuts closer than the redemption/checkout distinction
   suggests.** Read it precisely: it bans *the app* from using its own unlock mechanism. A server-side
   entitlement read is not an app-side unlock — the app performs no unlock, the server decides, and
   the app only renders `active: true`. That reading is sound and is exactly what adr-171 §1 protects,
   and it holds **only while the app has zero code-handling surface**. But a *link* whose single
   purpose is to reach a license-key entry field re-associates the app with the mechanism. The app
   stops being a passive reader of state and becomes the on-ramp to the unlock. That is a materially
   weaker position than HEAD's, for a feature the app does not need.
3. **Apple objects to out-linking for sign-in independently of purchase.** Apple's own
   account-deletion FAQ states that linking out to the default browser "to sign in or register an
   account … is not appropriate, per App Store Review Guideline 4" (part 08 note 3). The redemption
   page **must** authenticate — that is what `POST /auth/redemption-session/otp/request`/`verify`
   exist for (`contract/openapi.yaml`, `x-consumers: [web]`). So the link is *also* an out-link to a
   sign-in surface, under a guideline that has nothing to do with payments. **No agent listed this
   second, independent objection.**

**Redemption page vs checkout page.** The distinction is real and worth making to Apple — but it is a
distinction Apple's *text* does not draw, and 3.1.1(a) says "purchasing mechanisms", not "checkout
pages". It is an argument to make in a formal appeal, not a foundation to build a release on.

### Recommendation for release 1 (defensible)

**Ship no redemption link on iOS. Ship it on Android only, behind a platform check, and only after
the landing page is certified (below).**

- Concretely: the subscription area's link widget is gated on `Platform.isAndroid` (or a
  `--dart-define` build flag, which is cleaner for a future US/EU storefront). The iOS build must
  contain **no link widget, no URL string, no confirmation-sheet copy** — 3.1.1(a) covers "apps **and
  their metadata**", and a dead-code URL in the snapshot is a string a static scan can find (part 02
  proved the string scan works both ways).
- If the owner requires cross-platform parity, the compliant parity option is **no link on either
  platform in release 1** — which is `docs/DECISIONS.md` D-007 / adr-049 §3 as originally written. It
  costs Android nothing except a support burden.
- **This is an owner decision, not an engineering one** (CLAUDE.md §1.3 rule 5: business/revenue
  decisions stop and ask). Both options are defensible; shipping the link on iOS/Egypt is not.

### What must be certified about the landing page

Before any link ships on any platform, the owner or web team must certify in writing, and re-certify
at every release, that the page:

1. contains no price, amount, currency, plan comparison, "buy/purchase/subscribe/pay" CTA, payment-
   provider name or logo, and no checkout step;
2. is **not one click from** any of the above — Google's word is "eventually", so a header, footer,
   side-nav or banner link that reaches a purchase page breaks it;
3. accepts only a code the student already holds; offers **no path to acquire** a code;
4. performs no auto-redirect or interstitial to a purchase surface;
5. receives a **bare URL with no query parameters** (adr-171 §2 — no token, session id, student id,
   code, opaque reference or analytics parameter);
6. is on a domain that does not itself read as a storefront.

Because the page is mutable after review, add **change control**: any edit to the redemption page
routes through a store-compliance check before it goes live. A page that passes review and later
grows a "Buy a code" button is a policy violation on a shipped binary.

### Action / owner

| # | Action | Owner |
|---|---|---|
| 1 | Decide: Android-only link, or no link at all, for release 1. Record in `docs/DECISIONS.md` as superseding the adr-171 §2 "both platforms" reading. | **Owner (business)** |
| 2 | Keep HEAD's zero-surface posture; add the mechanised guard part 05 API-08 proposes (every `_dio.*` path literal resolves to a stable, non-`[web]` operation) so a future contributor cannot re-import 3.1.1 risk. Prose rules decay; this one should be a test. | Frontend |
| 3 | Obtain and file the landing-page certification above. | Owner + web |
| 4 | Do **not** put the redemption URL in App Review Notes (3.1.1(a) covers metadata). | Console |

---

## POL-02 — Google Play payments, same design

**Verdict: F (pass) at HEAD · C (medium, conditional) for the planned link.**

### Policy

> "consumption-only means that any product(s) or service(s), whether digital or physical, cannot be
> purchased from within the app"
> — https://support.google.com/googleplay/android-developer/answer/10281818 (WEB, verbatim)

> "Go to our website to upgrade your subscription to Premium"
> — same URL, given as **permitted** in-app phrasing for consumption-only apps. (WEB, verbatim)

> "as long as the webpage does not eventually lead to an alternate payment method prohibited by the
> Payments policy"
> — same URL, on referring users to administrative information. (WEB, verbatim)

> "apps may not lead users to a payment method other than Google Play's billing system"
> — Payments policy, https://support.google.com/googleplay/android-developer/answer/9858738, which
> enumerates "in-app webviews, buttons, links, messaging, advertisements, or other calls to action".
> (WEB)

### Repo evidence

Same as POL-01: no billing dependency anywhere — the AAB's `dependencies.pb` Maven graph shows
**no Play Billing, no Firebase, no GMS, no ads, no analytics** (part 02, ARTEFACT). `url_launcher`
opens three constant URLs with `LaunchMode.externalApplication` and `canLaunchUrl` is never called
(part 03 PASS; part 06 PASS). `url_launcher_android`'s `WebViewActivity` ships in the binary but is
never invoked (part 02 merged manifest) — relevant because adr-171 §2 bans embedded webviews and Play
names "in-app webviews" first in its list; the Activity's presence is *not* a violation, but it is
what a reviewer's static scan will surface, so note it in the Play instructions if asked.

### Reasoning

Play is **explicitly permissive** about this exact design. Consumption-only is named and allowed; the
permitted-phrasing examples go considerably further than anything the app says today. The only live
constraint is the destination test: the page must not *eventually* lead to an alternate payment
method. A pure redemption page satisfies it; a redemption page with a "don't have a code?" link does
not.

Two things worth telling the team:

- **adr-171 §3's banned-vocabulary rule is an Apple-driven constraint, not a Play one.** Play would
  permit "Go to our website to upgrade your subscription". Keeping adr-171's stricter copy on Android
  costs nothing and keeps one string table for both platforms — do it, but do not let anyone believe
  Play requires it.
- The **certification** in POL-01 is what converts this from C to F. Without it, "the page does not
  eventually lead to payment" is an assumption, and it is an assumption about a system the app team
  does not control.

### Which store is stricter, and why

**Apple, decisively.** Three separable reasons:

1. **Scope of the IAP mandate.** Apple requires IAP to unlock in-app features at all, with a closed
   list of exceptions none of which fits education-sold-on-web. Play has no equivalent mandate for
   consumption-only apps — it blesses them by name.
2. **Out-links.** Apple bans buttons, links and CTAs on every storefront except the US, with no
   landing-page test to pass. Play permits links subject to a landing-page test.
3. **Non-payment out-links.** Apple additionally polices out-linking to sign-in/registration under
   Guideline 4. Play has no analogue.

**Consequence:** the subscription area should not be the same on both platforms in release 1. That is
the single most important cross-platform conclusion in this report.

### Action / owner

Certify the landing page (POL-01) → ship the link on Android → answer the Play payments questions
honestly in the console. Owner: owner + web (certification), frontend (platform gate), console.

---

## POL-03 — Reviewer access

**Verdict: A (blocker), both stores.**

### Policy

> "include demo account info (and turn on your back-end service!) if your app includes a login"
> — Apple 2.1, https://developer.apple.com/app-store/review/guidelines/ (part 08 note 1). ASC's field
> reference adds: "Account must not expire."

> "provide reusable login credentials that can bypass these requirements" … "valid regardless of user
> location" … "provided in English"
> — Play App access, https://support.google.com/googleplay/android-developer/answer/15748846
> (part 09 item 9), which adds that otherwise "the app may be rejected".

### Repo evidence

- `contract/openapi.yaml:96-98` (SOURCE, re-read this session): "reserved fake numbers
  (+20100000000xx) are whitelisted in **staging config only** — fixed OTP `000000` … **Absent from
  production configuration**."
- `lib/core/config/app_config.dart:54` → `Flavor.prod => 'https://TBD.example/api/v1'`, and the
  placeholder is in the shipped snapshot: part 02's string scan finds it **once**, as the only API
  base URL in the prod artefact.
- Phone+OTP is the only login path (`lib/features/auth/repository/auth_repository.dart:29-47`); no
  social login, no password (part 01 §2).
- Device binding: a new-device verify evicts the old session → `session_superseded` on any endpoint
  (`openapi.yaml:56-60, 180-181, 401-403`; part 05 auth summary).
- OTP throttle is "per-identifier/device/**IP**" with 5 failed verifies → 15-min lock
  (`openapi.yaml:86-88, 169`).

### Reasoning

Both stores require working reusable credentials against a **live production backend**. Today neither
exists: there is no production host in the binary, and the contract states in writing that the bypass
is not in production config. This is upstream of every other finding — a reviewer cannot reach the
second screen.

Three risks inside this that the Wave-0/1 parts did not surface:

1. **Device binding will evict reviewers.** One credential + two devices = the first session dies.
   Apple commonly reviews on more than one device; Play runs the **Robo crawler (pre-launch report)
   on a device farm concurrently** with human review. A single whitelisted number is close to
   guaranteed to produce a "the app logged me out" rejection. Ask Seif for **at least three**
   whitelisted numbers from the `+20100000000xx` range, or a relaxed device-binding rule for the
   whitelisted cohort.
2. **Shared-NAT OTP throttling.** The per-IP OTP limit (`openapi.yaml:169`; magnitudes unknown — part
   05 Q13) can lock out a reviewer farm sitting behind one egress IP. Ask Seif to exempt the
   whitelisted cohort from the per-IP limit, or raise it materially.
3. **Egypt-only registration vs worldwide territories.** The contract's `Phone` is global
   (`^\+[1-9][0-9]{7,14}$`) but the app pins a `+20` chip (`lib/core/.../phone.dart:17-43`), so the
   app *does* restrict by location in effect. Apple 3.2.2(v) bans "Arbitrarily restricting who may
   use the app, such as by location or carrier" — explain it in Notes, or restrict ASC/Play
   territories to match. Part 08 note 16 raises 3.2.2(v); nobody connected it to the territory list.

### What must EXACTLY exist

| # | Requirement | Detail |
|---|---|---|
| 1 | **Production host** | Seif publishes the prod `servers:` entry; `app_config.dart:54` replaced; a guard fails the release build while `.example` remains (part 03 AND-01). Nothing below is testable without this. |
| 2 | **Account state** | ≥3 production-whitelisted E.164 numbers with a fixed OTP, **already past the registration wizard** (a reviewer must not have to invent a DOB and a parent's phone number). Exempt from the per-IP OTP limit. |
| 3 | **Entitlement** | The primary account holds an **active `baseSubscription`** — and `flashcardSubscription` if the University track is the one shown — so quiz creation, explanations and flashcards are all reachable. Without it the reviewer lands on `403 subscription_required` and the neutral copy, which is precisely what opens the POL-01 conversation. Optionally a second, *unentitled* account so the free tier is reviewable too. |
| 4 | **Content seeding** | For that account's cohort (School and University are different trees): ≥1 subject → learning item → lecture, with questions **and** flashcards, and at least one question carrying `explanationAvailable: true`. |
| 5 | **Validity** | No expiry (Apple: "Account must not expire"). If the backend insists on one, ≥12 months, diarised, and re-checked at every submission. |
| 6 | **Notes text** | Below. Play requires it **in English** even though the app is Arabic-first. |
| 7 | **Web paths** | Privacy policy, terms, support and web-deletion URLs live and reachable **before** submission (POL-04, POL-10). |

### Paste-able App Review Notes (Apple; ≤4000 bytes, placeholders in brackets)

```
LEVEL UP - APP REVIEW NOTES

1. SIGNING IN (phone number + one-time code; no social login, no password)
   The login screen fixes the country to Egypt (+20). Enter the number WITHOUT
   the leading zero.
     Phone: [REVIEWER_PHONE_E164]      Code: [REVIEWER_FIXED_OTP]
   This number is whitelisted on our production servers. No SMS is sent; the
   code above is accepted every time, does not expire, and the account is
   permanent.
   ONE DEVICE AT A TIME: for account security, signing in on a second device
   ends the session on the first. If you review on more than one device, please
   use one number per device - all accept the same code:
     [REVIEWER_PHONE_2]   [REVIEWER_PHONE_3]

2. WHAT THE ACCOUNT CONTAINS
   Track: [School|University]. It has an active subscription and seeded content,
   so every screen is reachable: Subjects > [SUBJECT] > [LEARNING_ITEM] > start a
   quiz, open an answer explanation, open flashcards.
   To see the free tier instead: [REVIEWER_PHONE_FREE], same code.

3. HOW ACCESS WORKS (guidelines 3.1.1 / 3.1.3)
   Level Up sells nothing inside the app. There is no in-app purchase, no price,
   no plan picker, no checkout, and no link to any purchasing mechanism. Access
   is arranged entirely outside the app; the app reads the resulting entitlement
   from our server and displays only whether it is active. Locked content shows a
   neutral message and offers no way to transact.

4. REGION
   The service is offered in Egypt and registration accepts Egyptian mobile
   numbers (+20). This is our distribution scope, not an arbitrary restriction.

5. AGE AND PARENT CONTACT
   The audience is secondary-school and university students, 13 and older. Date
   of birth and a parent/guardian contact number are collected to meet
   children's-privacy obligations and to allow account recovery. They are not
   used for marketing and are not shared. Privacy policy: [PRIVACY_POLICY_URL]

6. ACCOUNT DELETION
   In app: Profile > Settings > Delete account. The confirm screen states what is
   lost; deletion completes within 30 days and can be cancelled by signing in
   again during that window. On the web: [WEB_DELETION_URL]

7. THINGS THAT MAY LOOK LIKE DEFECTS
   - The app is Arabic-first with full right-to-left layout. Language is in
     Settings.
   - [IF iOS SCREENSHOT PROTECTION IS KEPT - see POL-08:] The quiz and quiz
     review screens block screen capture to protect our question bank, so
     recordings of those two screens appear blank.

   Contact: [REVIEW_CONTACT_NAME], [REVIEW_CONTACT_EMAIL], [REVIEW_CONTACT_PHONE]
```

Do **not** add the redemption URL to these notes — 3.1.1(a) covers metadata. Have the owner sign off
on §3's wording; it is a business statement, not an engineering one.

### Paste-able Play "Any other instructions"

```
LEVEL UP - REVIEWER INSTRUCTIONS (English)

SIGN-IN: phone number + one-time code. No social login, no password. The login
screen fixes the country to Egypt (+20); enter the number without the leading 0.
   Phone: [REVIEWER_PHONE_E164]      Code: [REVIEWER_FIXED_OTP]
These credentials are enabled on our production servers, are reusable, never
expire, and work from any country. No SMS is sent - the code above is always
accepted.
ONE DEVICE AT A TIME: signing in on another device signs the first one out.
Please use separate numbers for the automated pre-launch report and for manual
review (all accept the same code):
   pre-launch / Robo: [REVIEWER_PHONE_ROBO]   manual review: [REVIEWER_PHONE_E164]

ACCOUNT STATE: [School|University] track, active subscription, seeded subjects
and questions, so quizzes, answer explanations and flashcards are all reachable.

PAYMENTS: the app is consumption-only. Nothing can be bought inside it - there is
no billing library, no price, no plan picker and no checkout. Access is arranged
outside the app and the app only displays whether it is currently active.

KNOWN BEHAVIOUR, NOT A CRASH: the quiz and quiz-review screens set FLAG_SECURE to
protect our question bank, so automated screenshots of those two screens come out
black in the pre-launch report.

ACCOUNT DELETION: in app at Profile > Settings > Delete account; on the web at
[WEB_DELETION_URL].

The app is Arabic-first (right-to-left). Language can be changed in Settings.
Support: [SUPPORT_EMAIL]
```

### Action / owner

Raise part 05 Q1 with Seif **today**, extended with the three sub-risks above (multiple numbers, IP
exemption, seeded cohort + entitlement). Owner: backend (Seif) → console → frontend (prod URL).

---

## POL-04 — Account deletion

**Verdict: A (blocker), both stores.**

### Policy

> "you must also offer account deletion within the app"
> — Apple 5.1.1(v), https://developer.apple.com/app-store/review/guidelines/

> "only offering to temporarily deactivate or disable an account is insufficient"
> — https://developer.apple.com/support/offering-account-deletion-in-your-app/ (WEB, verbatim)

> "Inform the user how long it will take to delete the account and provide a confirmation when the
> deletion has been completed."
> — same page, on manual/slow deletion. (WEB, verbatim)

> the web link must "reference the app or developer name (that is, as it appears on your store
> listing in Google Play)"
> — https://support.google.com/googleplay/android-developer/answer/13327111 (WEB, verbatim)

### Repo evidence

- Contract has both operations, stable: `contract/openapi.yaml:993-1046` (`requestAccountDeletion`,
  `202 {requestedAt, effectiveAt}`) and `:1044+` (`cancelAccountDeletion`, `204` / `404`). Staging
  routes them (part 05, STAGING probe).
- App calls neither. Zero `deletion-request` call sites in `lib/`; `SecureStorage.clear()`
  (`lib/core/storage/secure_storage.dart:64`) has **zero callers** (part 01 FE-03, part 06 SEC-17).
- Dead end during grace: `lib/core/network/exceptions.dart:127-134` maps every 403 to
  `accountPendingDeletion` = "Your account is scheduled for deletion. Cancel the request to use Level
  Up again." (`lib/l10n/app_en.arb:659`), and the ARB's own description at `:661` says it should
  "route to the cancel screen, **which does not exist yet**" (part 01 FE-04, part 05 API-03).
- No web deletion URL: `contract/contract-changelog.md:250` states the Play web leg is "a separate,
  still-unowned decision" (part 05 API-04).

### Reasoning

**Is a 30-day grace with cancel allowed by both? Yes — with two conditions each.**

*Apple.* Explicitly yes: slow/manual deletion is acceptable **if** the user is told how long. Two
conditions:
- (a) The flow must not read as deactivation. "Only offering to temporarily deactivate … is
  insufficient" targets apps that *stop at* suspension. A grace window that ends in erasure is not
  that — but the copy must say *deleted on <date>*, not *disabled* or *paused*, and the cancel
  affordance must be presented as an undo, not as the primary outcome.
- (b) Apple also asks for "a confirmation when the deletion has been completed". **The contract makes
  this impossible in-app**: the `202` revokes the session and the refresh chain immediately
  (`openapi.yaml:1006-1009`), so there is no authenticated surface left 30 days later. The
  confirmation must be out-of-band (SMS to the registered number, or email if one is on file) or the
  app must state the exact date at request time and Apple must accept that as the confirmation.
  **This is a new question for Seif — no agent raised it.**

*Play.* Yes, under "retain data for legitimate reasons … clearly inform users about your data
retention practices", tempered by "complete their requests within a reasonably quick period of time".
30 days is defensible and conventional; it must be disclosed in the privacy policy and in the Data
safety answers.

**What the confirm screen must say.** The contract mandates the substance at
`contract/openapi.yaml:1011-1018` (adr-114 D3) — the screen must state, **before** the call:

1. an active subscription is forfeited; there is no partial refund; remaining time is not restored by
   cancelling and does not carry to a future account;
2. a new account registered later with the same phone number **starts from zero** — no points, no
   level, no badges, no quiz history;
3. the phone stays blocked for the whole grace window and is freed at execution;
4. the request is reversible **only inside the grace window**, by logging in again and cancelling.

Policy adds three more lines:
5. **how long it takes** — "no earlier than [effectiveAt]", noting erasure runs from a daily job and
   may lag ~24 hours (Apple's "inform the user how long");
6. what is retained and why (once Seif answers part 05 Q4 — see POL-11(d));
7. a link to the privacy policy.

All seven in **AR and EN**.

> ⚠️ **Direct conflict between two authoritative sources — not listed by any agent.** The
> contract-mandated copy uses "**paid** subscription" and "no partial **refund**". adr-171 §3 bans
> "price", "payment", "buy", "purchase", "subscribe", amounts and currency **app-wide**, explicitly
> including "any empty/locked state that mentions it". The contract's description is a *semantic*
> requirement (the student must understand the consequence), not a verbatim string. Resolution:
> render it as "Any active subscription is forfeited. It is not restored by cancelling and does not
> carry over to a future account." — which preserves every element of the consequence and contains no
> banned word. **Get this confirmed by Seif and the owner** rather than shipping either reading
> silently; it is exactly the kind of gap CLAUDE.md says to raise, not work around.

**Is the web deletion URL a Play submission blocker or only a Data safety answer?** **Both, and
effectively a submission blocker.** The URL is submitted *inside* the Data safety form (confirmed
WEB); the Data safety form is mandatory to publish; and the requirement states plainly that the
in-app path alone is insufficient, because "Some users may have already uninstalled your app". So
there is no route to publication that skips it. It is **not** an Apple requirement — Apple wants the
in-app path, and only wants a web link if the web is where deletion is *finished*.

### Action / owner

| # | Action | Owner |
|---|---|---|
| 1 | Build the delete-account entry (Profile → Settings), confirm screen with all seven points in AR+EN, `POST /me/deletion-request`, then `SecureStorage.clear()` + `invalidateSessionScope` + route to login. **Do not** follow the `202` with `GET /me`. | Frontend |
| 2 | Build the cancel screen and wire the global `403 account_pending_deletion` redirect — the predicate at `exceptions.dart:134` is the hook. Closes FE-04 / API-03. | Frontend |
| 3 | Resolve the "paid/refund" vs adr-171 vocabulary conflict; sign off final copy. | Product + Seif |
| 4 | Ask Seif: out-of-band completion confirmation (Apple), and part 05 Q4 (what is erased vs retained). | Backend |
| 5 | Stand up the web deletion page; it must name the app as listed, work without returning the user to the app, and enter the same 30-day flow. Put the URL in the Data safety form. | Owner + web + console |

---

## POL-05 — Minors and age

**Verdict: B (high).** Split: no age floor = C (fixable, but needs a server rule); mandatory parent
phone = B (declaration + minimisation + third-party-notice); declarations = E (console/legal).

### Policy

> "Apps may ask for birthdate and parental contact information only for the purpose of complying with
> these statutes"
> — Apple 5.1.4(a), https://developer.apple.com/app-store/review/guidelines/ (part 08 note 9)

> apps that "collect, transmit, or have the capability to share personal information … from a minor
> must include a privacy policy"
> — Apple 5.1.4(b), same URL

> "this age group may be considered to include children in some locales"
> — Play target audience (13–15 / 16–17),
> https://support.google.com/googleplay/android-developer/answer/9867159

> "consult with your legal counsel"
> — Play Families policy, https://support.google.com/googleplay/android-developer/answer/11043825

### Repo evidence

- `parentPhone` is **required** on both registration bodies (`contract/openapi.yaml:2311`, `:2337`,
  SOURCE re-read this session) and **write-only** — absent from `StudentProfile` (`:2439` required
  list has no `parentPhone`; S34 Open in `docs/seif_fight.md`).
- `dateOfBirth` is `{ type: string, format: date }` with **no min/max and no description**
  (`openapi.yaml:2300`, `:2327`, `:2357`).
- Client has **no floor**: `lib/features/registration/widgets/date_of_birth_field.dart` picks
  `firstDate: DateTime(now.year - 100)`, `lastDate: now`, initial `now.year - 15` (SOURCE, re-read).
  A five-year-old's DOB is selectable and submittable.
- No consent or legal acknowledgement anywhere in the wizard (part 01 FE-15, grep of
  `lib/features/registration/` for legal/consent/agree → none). The only "By continuing, you agree
  to…" line is on Login (`app_en.arb:36`) and points at `.example`.
- `parentReportStatus` reads `inactive` for everyone and nothing is delivered to parents (part 05
  API-09).

### Reasoning

**What to declare.**

*Apple.* Do **not** opt into the Kids Category. Kids Category rules would forbid the adr-171 link
outright, require a parental gate on any out-link, and ban third-party analytics and ads — it buys
nothing and costs the redemption strategy. Answer the age-rating questionnaire honestly: "Contests"
for the leaderboard (infrequent → 4+, frequent → 13+ — a persistent points board is arguably
frequent); **do not** answer the "Social media" descriptor yes for a rank list (part 08 note 7 agrees:
"redistribution, amplification, or interaction with user-generated content through a social feed" is
not a leaderboard). Expect to land on **13+**, and note Apple's rule: "If your app has a EULA with
minimum age requirements that exceed the rating … you must override." If the terms of service set 13
as the floor, the rating must be at least 13+.

*Play.* Target audience: tick **13–17 only**; do **not** tick under-13. Ticking 13–15 puts you in
Families-policy scope in locales that treat them as children — the Egypt determination is a legal
call Google explicitly defers ("consult with your legal counsel"). If Families applies, the concrete
obligations are **already met at ARTEFACT level**: no AAID, no IMEI, no `READ_PHONE_STATE`, no ads,
no third-party SDKs, phone typed by the user rather than read from the device (part 03 PASS; part 02
`dependencies.pb`). App category Education. IARC questionnaire honestly (POL-06 and POL-12 item 9).

**Is mandatory parent phone a rejection risk or a privacy-wording issue?** Predominantly a wording
issue, with one real 5.1.1(v) edge:

- Apple 5.1.4(a) *permits* asking for birthdate and parental contact — but "**only** for the purpose
  of complying with these statutes". That purpose has to be true and stated. Today it is asserted
  nowhere: no on-screen reason string, no privacy policy (FE-02), and no feature consumes the number
  (`parentReportStatus` is inert). A reviewer who asks "why do you need my parent's number?" and finds
  no answer and no feature has a 5.1.1(v) case (data beyond what is directly relevant).
- There **is** a legitimate use: `/auth/recovery/*` verifies a parent OTP (draft in the contract, but
  real in design). Say so.
- Cure: (a) a purpose line at the field in AR+EN; (b) a privacy-policy paragraph naming both purposes
  (children's-privacy compliance and account recovery); (c) ask product whether the field can be
  optional for university registrants who are adults — the contract currently requires it for both
  tracks, so that is a change request to Seif, not a client edit.

**The under-recognised half: it is a third party's PII.** The parent has given no consent, received
no notice, and cannot see or delete the record (it is write-only). That is a privacy-law exposure
(Egyptian PDPL; GDPR Art. 14 if any EU user exists) rather than a store rule, and it is the one place
where Play's "prominent disclosure" test is genuinely arguable, because collecting *someone else's*
phone number is plausibly outside a user's reasonable expectation. Minimum: the on-screen purpose
line; ideally, a decision with counsel on whether a notice SMS to the parent is required.

**What if a 12-year-old registers?** Today, nothing stops them — client picker allows it, contract
has no constraint, server rule unknown (part 05 Q8). Three consequences, in increasing order of
seriousness:

1. The app is knowingly collecting personal data from an under-13 with no verifiable parental
   consent — COPPA if the US is ever in the territory list, Play Families/child-directed rules, and
   Apple 5.1.4(b)'s "comply with all applicable children's privacy statutes".
2. The Apple age rating and the Play target-audience declaration become **false declarations**. A
   false declaration is treated more harshly than the underlying collection by both stores, because
   it undermines every other answer on the form.
3. There is no way to remediate an already-registered under-13 account, because the app cannot tell
   which accounts they are (DOB is stored but nothing queries it).

**Fix must be server-side.** A client-only gate is cosmetic — the API would still accept the payload
from any client. Required: a minimum-age rule on `dateOfBirth` in the contract and on the server
(change request to Seif), plus a client-side neutral age check that blocks the wizard and **does not
retain the rejected DOB**. "Neutral" matters: the gate must not tell the user which answer gets them
in.

### Action / owner

| # | Action | Owner |
|---|---|---|
| 1 | Decide the minimum age; request a server-side `dateOfBirth` constraint in the contract. | Product/legal → Seif |
| 2 | Add a neutral client age gate that does not persist a rejected DOB. | Frontend |
| 3 | Purpose strings at DOB and parent-phone fields (AR+EN); privacy-policy paragraphs for both, plus the third-party-notice question. | Product/legal |
| 4 | Console: Play target audience 13–17, Education category, IARC; Apple questionnaire, **Kids Category = NO**, expect 13+. | Console |
| 5 | Ask Seif: is parent phone verified at registration? Is any consent record kept? Can it be optional on the University track? (extends part 05 Q8/Q9) | Backend |

---

## POL-06 — User-generated content (Apple 1.2)

**Verdict: G (n/a) at HEAD · B (high) the moment the leaderboard ships.**

### Policy

Apple 1.2 requires, verbatim (WEB, https://developer.apple.com/app-store/review/guidelines/):

> "A method for filtering objectionable material from being posted to the app"
> "a mechanism to report offensive content and timely responses to concerns"
> "The ability to block abusive users from the service"
> "Published contact information so users can easily reach you"

### Repo evidence

- The leaderboard tab routes to a placeholder: `lib/core/router/app_router.dart:169-170`
  `path: '/leaderboard'` → `LeaderboardPlaceholderScreen` (SOURCE, re-read this session). The real
  `LeaderboardScreen` exists and is tested but has **zero router references** (part 01 FE-10).
- The only peer-visible free text would be `entry.name` at
  `lib/features/leaderboard/widgets/leaderboard_row.dart:89` (and `podium.dart:154`) — unreachable.
- Avatars are a **server catalogue**; upload is disabled in-app
  (`lib/features/profile/.../avatar_sheets.dart:137-138`) and draft in the contract.
- `/message` is also a placeholder (`app_router.dart:268-271`). No messaging exists.
- `name` is free text, max 100, with **no stated moderation** (`openapi.yaml:2422-2424`); the contract
  has no report/block operation — `error-codes.md`'s last line only *reserves* "chat block/report
  outcomes" (part 05 API-10).
- `studentId` (UUID) is returned for every peer (`leaderboard_models.dart:67`) but **never rendered** —
  the only use is a doc-comment describing comparison against a locally held id to derive `isMe`
  (`:73`), and `leaderboard_row.dart:89` shows `leaderboardYou` for the caller's own row (SOURCE,
  re-checked this session).

### Reasoning

**Is 1.2 triggered at HEAD? No.** 1.2 attaches to apps "with user-generated content or social
networking services". At HEAD no content authored by one user is displayed to another: the board is
not routed, there is no messaging, avatars are a fixed catalogue, and the only free-text field a
student controls (`name`) is shown back only to themselves. Declare "no UGC" on both questionnaires
**for release 1** — and put a hard note in the release checklist that this answer expires the day the
board ships, because a rating or UGC answer that was true for v1 and false for v2 is a false
declaration (POL-12 item 9).

**When the board ships: B.** Displaying another student's free-text display name is user-generated
content, and Apple's four requirements attach in full. Three of the four are currently absent
(`name` has no filter; there is no report path; there is no block).

**Minimum viable compliance, cheapest first:**

- **Option 0 — design the requirement away (recommended).** Show rank, avatar (catalogue), and points,
  with the student's **own** name visible only in their own row (which the UI already does — the row
  reads `leaderboardYou` for `isMe`). If no peer's free text is ever displayed, 1.2 does not attach,
  and you keep the entire competitive feature. Cost: one design conversation. This is far cheaper than
  building moderation for a rank list, and no agent proposed it.
- **Option 1 — comply properly.** If names must be shown:
  1. *Filter* — server-side profanity/offensive-name screening on `name` at write time
     (`PATCH /me`). Must be server-side: a client filter is trivially bypassed and cannot clean names
     already stored. Change request to Seif (part 05 Q10).
  2. *Report* — a per-row report affordance backed by a server operation. The contract reserves the
     codes but has no op. If the op slips, the interim fallback is a report entry that opens a support
     ticket — but **Support is itself a stub** (`/support`, "Support isn't available yet.", part 01
     FE-12), so that fallback requires Support to become real first (which POL-09 recommends anyway).
  3. *Block* — hide a specific peer from your board. The existing privacy toggles
     (`leaderboardVisible`, `scoreHidden`, `lib/features/settings/.../settings_screen.dart:306`) let
     *you* hide *yourself*; they are not blocking an abusive user and will not satisfy 1.2 on their
     own.
  4. *Contact* — the ASC Support URL / Play listing contact, required independently.

**Separate from 1.2: `studentId` leaves the server for every peer.** It is not displayed, so it is not
a UGC issue, but it is a data-minimisation issue (Apple 5.1.1(v)) and a Data-safety accuracy issue —
every student's device receives other students' account identifiers. Ask Seif to drop it, or replace
it with a per-response opaque token, or return a boolean `isMe` (part 05 Q10). Cheap, and it removes a
row-level question from POL-11.

### Action / owner

Decide Option 0 vs Option 1 **before** the board leaves placeholder state (product + design). If
Option 1: change requests to Seif for name filtering, a report op, and a block op; `studentId`
removal in either case. Declare "no UGC" for release 1 and diarise the re-declaration.

---

## POL-07 — Privacy manifest / ITMS-91053

**Verdict: B (high).** *Disagreement recorded: part 04 rates IOS-03 "A (likely)". Reasoning below.*

### Policy

> "Starting May 1, 2024, apps that don't describe their use … aren't accepted"
> — Apple, describing use of required reason API (quoted in part 08 note 5;
> https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api —
> **this session could not re-read the page: 404 on one form of the URL, JS-rendered empty on the
> other, exactly as part 08 reported**).

Part 08 also records: "each executable/dylib that uses a required-reason API needs its own manifest";
disk-space category id `NSPrivacyAccessedAPICategoryDiskSpace` = `E174.1`; error codes ITMS-91053
(missing API reason) and ITMS-91061 (listed SDK without manifest, enforced 12 Feb 2025).

### Repo evidence

- `…\Pub\Cache\hosted\pub.dev\device_info_plus-13.2.0\ios\device_info_plus\Sources\device_info_plus\FPPDeviceInfoPlusPlugin.m:38, 42-43, 67-68`
  calls `NSFileSystemFreeSize` and `NSFileSystemSize` on every `iosInfo` call (part 04 §4).
- That pod's bundled `PrivacyInfo.xcprivacy` declares **no** `NSPrivacyAccessedAPITypes` (part 04 §4
  table).
- No app-level `ios/Runner/PrivacyInfo.xcprivacy` exists at all (part 04 §3 IOS-03).
- The app reads exactly one field: `lib/features/auth/repository/device_info_provider.dart:23`
  (`iosInfo.model`) — nothing else.
- `DeviceInfo.model` is **optional** in the contract (`openapi.yaml:2239-2247`), described as a
  "display label for eviction messaging" — a surface the app does not render anywhere (part 05).
- `device_info_plus` is on Apple's named-SDK list, so it also needs a manifest **and a signature** for
  ITMS-91061 purposes (part 08 item 18).

### Reasoning

**Raised on the app binary, the plugin bundle, or both?** The scan runs over the **uploaded binary as
a whole**: Apple's tooling finds the symbol in the linked framework and then looks for a matching
declaration in the manifests present in the app bundle — including the SDK's own
`PrivacyInfo.xcprivacy` inside its resource bundle. So ITMS-91053 is **reported against your upload**,
is **caused by the plugin's omission**, and can be **cured in either manifest**. *Confidence: medium.*
Apple does not publish the resolution order in a quotable sentence, and part 08's verbatim quote
("each executable/dylib that uses a required-reason API needs its own manifest") arguably points the
other way. **[PARTLY UNVERIFIED]** — do not build a plan that depends on the app-level manifest curing
a plugin's omission.

**Warning email or hard rejection today?** Apple's own wording is "aren't accepted". In practice
ITMS-9105x messages arrive as post-processing emails from App Store Connect; ITMS-91061 has been
enforced as a hard failure since Feb 2025. For ITMS-91053 the honest answer is: **plan for blocking.**
At minimum it is a guaranteed reviewer flag on a first submission; at worst the build is rejected. Do
not schedule a release on the assumption that it is advisory. **[UNVERIFIED at source this session.]**

**Why B and not A.** Part 04 calls it "A (likely)" and that is reasonable if the team ships
`device_info_plus` unchanged. I rate it **B** because: (a) it is caught at upload, before publication,
so it cannot reach users; (b) it requires no contract change, no business decision and no third-party
cooperation; (c) the best fix is a one-file change that the contract already permits. It becomes an A
only if the team decides to keep the plugin and rely on a Runner-manifest declaration — see below.

**Cleanest fix, ranked:**

1. **Drop `device_info_plus` on iOS (recommended).** The app uses one optional field. Either stop
   sending `model` on iOS, or read the machine string from `utsname` via a short platform channel or
   `dart:ffi` — neither touches a required-reason API. This removes the ITMS-91053 cause, removes one
   named-SDK manifest+signature dependency, shrinks the pod set on a target that has never been built
   (IOS-01), and — see POL-11(c) — removes a Data-safety declaration ambiguity at the same time. **It
   is the single highest-leverage change in this report: one dependency, four problems.**
2. **Upgrade/pin to a `device_info_plus` release whose manifest declares DiskSpace.** Cheapest if one
   exists. Verify by reading the `PrivacyInfo.xcprivacy` **in the pub cache**, not the changelog.
   **[UNVERIFIED — this session did not check pub.dev for a newer release.]**
3. **Declare DiskSpace in `ios/Runner/PrivacyInfo.xcprivacy` — do not use this as the primary fix.**
   Is declaring an API the app never itself calls truthful? Partly. The declaration is about *the app
   bundle's* use, and the API genuinely is called from code shipped inside your bundle — so naming the
   *category* is not a lie about the binary. **The untruthful part is the reason code.** You must
   attest to a specific purpose (e.g. `E174.1` — displaying space to the user / writing a file only if
   space allows), and the app has none of those purposes. Attesting to a purpose you do not have is a
   false declaration on a privacy form, which is worse than the upload warning it avoids. Use (1) or
   (2).
4. **Independently required regardless of 1–3:** add `ios/Runner/PrivacyInfo.xcprivacy` with
   `NSPrivacyTracking = false`, an empty `NSPrivacyTrackingDomains`, and the `NSPrivacyCollectedDataTypes`
   rows from POL-11. It feeds Xcode's Privacy Report and the nutrition label and its absence is its own
   gap.
5. **Verify on the Mac before the first upload:** the Flutter engine's own `PrivacyInfo.xcprivacy` was
   not inspectable on this Windows host (part 04 §4), and `screen_protector`'s closed
   `ScreenProtectorKit` xcframework has unknown manifest status (part 04 §4, IOS-15 — another reason
   for POL-08). The Xcode archive **Privacy Report** answers both in one look.

### Action / owner

Drop `device_info_plus` from the iOS build path (frontend) · add the Runner manifest (frontend) ·
verify the archive Privacy Report on the first Mac build (dev, DEVICE/ARTEFACT level).

---

## POL-08 — `screen_protector` on iOS

**Verdict: C (medium). Recommendation: drop the iOS leg for release 1; keep Android FLAG_SECURE.**

### Policy

Apple DTS, developer forums thread 824922 (May 2026), cited in part 08 note 6: using
`isSecureTextEntry` as a container "is not its intended purpose", and the behaviour is "a side effect
… subject to change at any time without notice", citing **Guideline 2.5.1** (public APIs used as
documented). No Apple guideline mentions screenshots at all.

### Repo evidence

- `lib/features/quiz/screens/screen_protection.dart:30-37` — the code itself documents that iOS "is
  NOT a hard block"; call sites `quiz_screen.dart:69-70, 78` and `quiz_review_screen.dart:64-65, 69-72`.
- Android side is plain `FLAG_SECURE` via `ScreenProtectorPlugin.kt:27-30, 38-40` (part 03).
- iOS side calls `ScreenProtectorKit.enabledPreventScreenshot()` from a **closed xcframework whose
  source is not in the pub cache** and whose privacy-manifest status is unknown (part 04 §4, IOS-15).
- `screen_protector 1.5.3` ships **no** `PrivacyInfo.xcprivacy` (part 04 §4).
- The enable call is unawaited (`quiz_screen.dart:70`) and there are no global error handlers (part 01
  FE-14), so a missing plugin surfaces as an unhandled `MissingPluginException`.

### Reasoning

**Rejection risk: low-to-moderate.** `isSecureTextEntry` is a public API used unusually, not a private
API; Apple's static analysis does not flag it, and a human reviewer is unlikely to notice a screenshot
guard. If it were the only consideration I would say keep it.

**But the benefit side is near-zero and the cost side is not.**

*Benefit:* the repo's own code says it is not a hard block; the technique is undocumented; Apple DTS
has said on the record it may break without notice; and nobody has DEVICE-verified it on current iOS
(part 04 §6). "The bank is the product" protection on iOS does not reliably exist today **whether or
not the plugin ships**.

*Cost:* a 2.5.1 hook if noticed · a closed-source xcframework with unknown manifest status on a target
that has never been built (an independent ITMS-91061 exposure if ScreenProtectorKit is ever added to
Apple's SDK list, and an unsignable-binary risk today) · one more pod at the first `pod install` ·
the one unawaited platform-channel future in the app.

**Recommendation for release 1: make `ScreenProtection` a no-op on iOS** (or drop the package and
implement `FLAG_SECURE` in a ~20-line Android-only method channel). Keep Android: `FLAG_SECURE` is a
documented platform API and Play explicitly recommends it (part 09 item 10b).

**The supported future path, if iOS protection is later required:** observe
`UIScreen.isCaptured` / `UIScreen.capturedDidChangeNotification` and blank your own view when capture
is active. Documented, intended-purpose, reviewer-safe — and honest about what it does (it detects
recording rather than preventing screenshots). Recommend this rather than another undocumented trick.

**Two operational notes:** (a) Android FLAG_SECURE blacks out the Play pre-launch report's screenshots
of the quiz and review screens — pre-empt it in the Play instructions (POL-03), or no one will know
whether the black frames are a crash. (b) Part 03 AND-13 flags that Mistakes is a separate route with
no protection; if the question bank is the asset, confirm the intended scope covers every
answer-bearing screen, not two of them.

### Action / owner

Frontend (no-op the iOS leg) · product (accept that iOS screenshot protection does not exist in
release 1) · console (note the black pre-launch screenshots).

---

## POL-09 — Stub and "Coming soon" surfaces

**Verdict: B (high), aggregate.**

### Policy

Apple 2.1 App Completeness; 4.2 Minimum Functionality; 2.3 accurate metadata
(https://developer.apple.com/app-store/review/guidelines/).

> "Apps that are designed to do nothing or have no function"
> — Play quality, https://support.google.com/googleplay/android-developer/answer/9898783

> "don't include any hidden, dormant, or undocumented features" … "Apps that misrepresent or do not
> accurately and clearly describe their functionality"
> — Play Deceptive Behavior, https://support.google.com/googleplay/android-developer/answer/9888077
> (part 09 note 13)

### Repo evidence

`lib/core/router/app_router.dart:169-170, 268-271` (two of five bottom tabs are placeholders rendering
`comingSoon`) · `home_screen.dart:92-131` + `coming_soon_section.dart:37` (three Home cards; "See All"
inert) · `/refer`, `/support` with disabled buttons, disabled Favorites/Progress rows, Go-to-Uni
dialog, `avatar_sheets.dart:137-138` upload photo, `settings_screen.dart:357-393` four dead
notification toggles (part 01 FE-12; AR strings at `app_ar.arb:223,233,245,267,270-275`) ·
`registration_draft.dart:17` "collected but NOT submitted" + `school_registration.dart:96` +
`university_registration.dart:78` (referral code; SOURCE re-checked) · `app_router.dart:133-136`
`_Placeholder('Track select')` with a hardcoded English title · `friends_screen.dart:15-19` orphan.

### Reasoning and the rule to give the team

> **A disabled control with honest copy is acceptable in a secondary surface. A reachable screen whose
> only content is "Coming soon" is not. A primary navigation tab never is.**

**Must be hidden / removed before submission:**

| Surface | Why |
|---|---|
| The two **placeholder bottom-nav tabs** (`/leaderboard`, `/message`) | A top-level navigation slot that says "Coming soon" is the most reviewer-visible completeness failure there is, on both stores. Either ship the real `LeaderboardScreen` (subject to POL-06) or reduce to 3–4 tabs. **The `/message` tab is doubly bad** — see POL-12 item 10a. |
| The **referral field** (`signup_identity_screen.dart:183`) | A visible input with literally zero effect is Play's "do not accurately … describe their functionality" verbatim, and an Apple 2.1 trip. Remove the field; keep the draft plumbing if you want it later. |
| The four **notification toggles** (`settings_screen.dart:357-393`) | Switches that control nothing, promising a feature the app cannot deliver (no FCM, no `POST_NOTIFICATIONS`, no `UIBackgroundModes` — ARTEFACT). 2.3 accuracy. Hide the section until push lands. |
| **Upload photo** (`avatar_sheets.dart:137-138`) | Remove the entry; keep the catalogue picker, which works. |
| `/track-select` and `/friends` | Dev placeholders, one with a hardcoded English title. Unreachable today but they are routes. Delete or `kDebugMode`-gate — zero cost. |
| The inert **"See All"** (`coming_soon_section.dart:37`) | An inert control is worse than no control. Remove it rather than disabling it. |

**May ship with honest copy:**

- The three **Home "Coming soon" cards** — honest, non-interactive, and reviewers routinely accept a
  roadmap strip. But three of them on the first screen after login reads as an unfinished app. Keep at
  most one, or remove the section for release 1.
- **Refer a Friend**, **Favorites**, **Progress**, **Go to Uni** — secondary Profile rows. Ship as
  *disabled rows with a subtitle*, so the user learns the feature is unavailable **before** tapping,
  rather than as a screen whose only content is a disabled button.
- **Support is the exception: make it real rather than hiding it.** Both stores require a working
  support contact anyway (ASC Support URL must carry legal address, email and phone — part 08 item 12;
  Play listing contact), and POL-06's "published contact information" needs it too. Point the row at
  `mailto:[SUPPORT_EMAIL]` or the hosted support page. One change satisfies three requirements.

### Action / owner

Product decides hide-vs-finish per row (this is the "product intent" class that CLAUDE.md §1.3 rule 5
says to ask about) · frontend implements · console checks the store description promises nothing the
build does not do.

---

## POL-10 — Store identity (template icons and label)

**Verdict: B (high) as a review risk on the binary · effectively A on Play, because the listing
assets are a hard publish gate.**

### Policy

Apple 2.3.8 (metadata, including icons) and 4.0 Design, https://developer.apple.com/app-store/review/guidelines/.
Play listing assets: icon 512×512 32-bit PNG ≤1024 KB and a 1024×500 feature graphic "Required to
publish store listing", plus "minimum of two screenshots" —
https://support.google.com/googleplay/android-developer/answer/9866151 (part 09 item 11c).

### Repo evidence

- Android launcher icons at **all five densities are md5-identical** to the Flutter SDK template
  (part 02: xxxhdpi `57838d52c318faff743130c3fcfae0c6`; part 03 AND-03 lists all five). No
  `mipmap-anydpi-v26`, so no adaptive icon and no monochrome layer for Android 13 themed icons.
- iOS: all 15 app-icon PNGs md5-identical to `flutter_template_images-5.0.0`
  (1024 `c785f8932297af4acd5f5ccb7630f01c`); LaunchImage PNGs are the template 1×1 transparent stubs
  (part 02, part 04 IOS-02).
- Label: `android/app/src/main/AndroidManifest.xml:27` `android:label="level_up_app"`, and aapt2
  badging shows `application-label:'level_up_app'` **identically in all 80+ locale rows** (part 02) —
  so Arabic users see a Latin developer slug. iOS `CFBundleName` `level_up_app` / display name
  "Level Up App" (`ios/Runner/Info.plist:8,16`); ARB `appTitle` "Level Up" (`app_en.arb:3`). Three
  different strings (part 04 IOS-11).

### Reasoning — rejection ground or metadata rejection?

**They are two separate events and both happen.**

- **The binary.** A build carrying the stock Flutter icon is a review ground under Apple 2.3.8 / 4.0
  and under Play's quality policy. It is also trivially provable — the md5s match the SDK template, so
  there is no "it's just similar" defence. Apple issues this as a normal rejection against the build.
- **The listing.** A placeholder listing icon is a *metadata* rejection at listing review (Apple
  "Metadata Rejected"), which does not touch the binary. On Play it is stricter than that: without a
  512×512 icon and a 1024×500 feature graphic **you cannot publish the listing at all**. That is a
  hard gate, not a judgement call — hence "effectively A on Play".
- **The label.** No rule ties the manifest label to the listing title (part 09 note 11), so
  `level_up_app` is not *itself* a rejection ground. But Apple 2.3 requires accurate metadata, and a
  developer slug as the on-device name, combined with a stock icon, reads to a reviewer as a
  placeholder submission — which is how 2.1 rejections start. And AND-04's unlocalised label is a real
  user-facing defect in the app's primary language.

### Action / owner

Brand icon: five Android densities + adaptive (foreground/background/**monochrome**) + 512 Play icon +
1024×500 feature graphic + the iOS 15-size set (iOS 18 dark/tinted variants optional) · replace the
1×1 LaunchImage stubs and give the launch screen a per-appearance background (IOS-12) · move the label
to `res/values/strings.xml` + `values-ar/strings.xml` · settle **one** brand string and align
`CFBundleDisplayName`, `CFBundleName`, the Android label and ARB `appTitle` (IOS-11). Owner:
designer + product + app.

---

## POL-11 — Data-declaration mapping

**Verdict: B (high).** The rows proposed in parts 08 §5 / 09 note 5 are mostly right. Two need
changing, one is an ambiguity that should be resolved by *not sending the data*, and **six answers
would be false declarations if the forms were filled today.**

### Policy

> "transmitting data off the device in a way that allows you … to access it" [for longer than the
> request]
> — Apple's definition of "collect", https://developer.apple.com/app-store/app-privacy-details/

> "Identifiers that relate to an individual device, browser or app … Firebase installation ID"
> — Play "Device or other IDs", https://support.google.com/googleplay/android-developer/answer/10787469

> "Any other personal information such as date of birth…" (Other info) · "gameplay, likes, and dialog
> options" (Other actions) — same URL.

### Row-by-row

**(a) Parent phone — a third party's PII entered by the user.**
Neither taxonomy has a concept of "someone else's data". Declare it where the data type lives:
- **Apple:** Contact Info → **Phone Number**, Linked to you, purpose App Functionality. (Part 08's
  proposal — **agree**.)
- **Play:** Personal info → **Phone number**, collected, not shared, **required**, purpose Account
  management (+ App functionality once recovery ships). (Part 09 — **agree**.)
- ⚠️ **Mismatch risk:** the contract makes it `required` on both bodies (`openapi.yaml:2311, :2337`).
  Declaring it optional would be false. Declare **required**.
- The label cannot express third-party subjecthood — the privacy policy must, and the field needs a
  purpose string (POL-05).

**(b) App-generated random `deviceId` — Apple "Device ID" or "User ID"?**
**Device ID.** Apple's User ID means a screen name, handle, account ID or assigned user id — something
that identifies a *person*. This value is 32 hex characters from `Random.secure()`
(`lib/core/storage/secure_storage.dart:72-83`), is not derived from the user, and is not a hardware
identifier (no ANDROID_ID, IDFV or IDFA anywhere — part 03 PASS, part 05 DeviceInfo section). It is a
per-installation device identifier. Part 08's proposal — **agree**. Play: **Device or other IDs**;
Google's own example is "Firebase installation ID", which is exactly this shape. Part 09 — **agree**.

> ⚠️ **iOS nuance no agent connected.** On iOS the Keychain survives app deletion (IOS-06), so this ID
> persists across uninstall/reinstall **and across different people using the same device**. That
> makes it materially stronger than its Android twin and makes the contract's own description —
> "client-generated STABLE id … **regenerated on reinstall**" (`openapi.yaml:2239-2247`) — **false on
> iOS**. Two consequences: fix IOS-06 (first-run flag in `shared_preferences`, which *is* wiped on
> uninstall, → `SecureStorage.clear()`), and until it is fixed, do not let the privacy policy repeat
> the "regenerated on reinstall" claim. This promotes IOS-06 from "wrong runtime behaviour" to
> "declaration accuracy".

Separately, the **server account id** (`StudentProfile.id`) is a genuine **User ID** on both forms.
Keep that row too.

**(c) Device `model`.**
- **Apple:** there is no "device model" type in the nutrition-label taxonomy. It is not Diagnostics
  (that means crash/performance data) and not an Identifier (a model string is not unique). **Do not
  invent a row.** Part 08 proposed none — **agree**. Disclose in the privacy policy instead.
- **Play:** part 09 correctly flags this as an ambiguity — there is no listed type. The temptation is
  "Device or other IDs", but a model string is **not** an identifier and declaring it there
  over-declares, forcing identifier answers that are untrue. **Do not declare `model` as a Device ID.**
- **Best answer: stop sending it.** `model` is optional in the contract and its stated purpose
  ("display label for eviction messaging") is a surface the app never renders. Dropping it removes the
  ambiguity on both forms **and** is the same change that fixes POL-07. Do it once, bank it twice.

**(d) Quiz answers and self-grades.**
- **Apple:** User Content → **Gameplay Content**, Linked, App Functionality. Part 08 — **agree**. Do
  not also add Usage Data → Product Interaction; the app logs no navigation or analytics, so that row
  would over-declare.
- **Play:** App activity → **Other actions** — Google's definition names "gameplay, likes, and dialog
  options". Part 09 — **agree**.
- ⚠️ **Retention trap nobody listed.** Quiz attempts are "kept forever" (adr-017, part 05 API-13) and
  the erasure scope at `effectiveAt` is unknown (part 05 Q4). Play's Data safety asks whether users
  can request deletion of each type; if attempts survive account deletion, answering an unqualified
  "yes" for this type is a **false declaration**, and the privacy policy must state that attempts are
  retained (pseudonymised?) indefinitely. **Do not file either form until Seif answers Q4.**

**(e) IP address / server logs — UNVERIFIED, and must not stay that way.**
Apple's "collect" test is about data **transmitted by the app**. An IP is an artefact of the
connection, not a payload, so it is normally out of scope of the nutrition label — *unless* it is
retained and used beyond servicing the request. The contract confirms IP **is** processed: per-IP
rate limits on `/reference/*` and on OTP (`openapi.yaml:169`), with unknown magnitudes and unknown
retention, plus "abuse-flagged numbers" and an "audited" recovery flow (part 05 API-13).
- **Recommended answers today:** Apple — no row; Play — no row (Google's Data safety covers data the
  *app* sends; server-side logs the app does not transmit are out of scope); **privacy policy — an
  explicit paragraph** naming IP processing for abuse prevention and rate limiting.
- **Revisit** the moment Seif answers part 05 Q5 (log retention, whether phones/IPs appear in logs,
  backup retention, purge-after-erasure). If IP is retained long-term for anything beyond transient
  abuse control, Apple's optional-disclosure exemption (four strict conditions) will not cover it and
  a row is needed. **This is the largest remaining unknown in the declaration set.**

**(f) The rest, confirmed.**
Name → Apple Contact Info/Name, Play Personal info/Name · student phone → Phone Number / Phone number
· email (**optional**, and it is genuinely optional — the PATCH tri-state exists) → Email Address /
Email address · DOB + school/university/governorate/stage/faculty/year → Apple **Other Data**, Play
**Personal info → Other info** (Google's definition names date of birth) · avatar = server catalogue,
**no row** (if upload ever ships: Apple User Content → Photos or Videos, Play Photos and videos, plus
the SafeSearch vendor as a processor to disclose) · leaderboard rank/points → already inside Gameplay
Content / App activity; other **end users** are not "third parties" in Google's sense, so no "shared"
tick — but the privacy policy must say the board is peer-visible · **Tracking: No** on Apple, no ATT
prompt, no `NSUserTrackingUsageDescription`, no tracking domains · Play **"Encrypted in transit:
Yes"** (HTTPS only, no cleartext, ARTEFACT) · Apple: **every row Linked to you** (the account is a
phone number) · Play: **no ads, no analytics, no third-party SDKs** — ARTEFACT-provable from the AAB's
`dependencies.pb` (part 02). That last point is unusually strong; say it in both forms and in the
review notes.

### ⚠️ Six answers that would be false declarations if filed today

1. "Users can request that their data be deleted" = **Yes**, while no in-app or web path exists
   (POL-04). Fix the app first, then answer.
2. A blanket deletion answer while quiz attempts are "kept forever" (part 05 Q4).
3. Parent phone declared **optional** while the contract requires it.
4. Repeating the contract's "regenerated on reinstall" for `deviceId` while iOS Keychain survives
   uninstall (IOS-06).
5. Declaring device `model` as a **Device ID** (over-declaration, and it drags identifier answers with
   it).
6. Declaring `NSPrivacyAccessedAPICategoryDiskSpace` with reason `E174.1`/similar in the Runner
   manifest when the app has no such purpose (POL-07 option 3).

**Also confirmed as a non-issue:** `referralCode` is collected into a **local draft only** and is never
transmitted (`registration_draft.dart:17`; `school_registration.dart:96`; `university_registration.dart:78`
— SOURCE, re-checked this session). It therefore does **not** belong on either form. It is a POL-09
completeness problem, not a privacy one — correcting the framing in the brief.

### Action / owner

Hold both forms until part 05 Q4–Q7 are answered (backend) · make the six corrections above (console)
· drop `model` and `device_info_plus` (frontend) · privacy policy must cover: parent phone as a third
party's data, IP for abuse control, quiz-attempt retention, peer-visible leaderboard, deviceId
lifetime (product/legal).

---

## POL-12 — Contradictions, and what a reviewer would raise that nobody listed

**Verdict: B (high), aggregate.**

**1. Play "Financial features" declaration, given entitlements exist — answer *no financial features*.**
> "Even developers with apps that do not offer any financial features must complete this form"
> — https://support.google.com/googleplay/android-developer/answer/13849271 (part 09 item 11b)

The declaration covers lending, investments, crypto, insurance and money-transfer **products**. A
content subscription is not one, and the app takes no payment at all (no Play Billing in the AAB —
ARTEFACT). Answer **No**. It must be *answered*, not skipped: since 30 Oct 2025 an unanswered form
blocks updates. Same for Health = No, Government = No, News = No, **Ads = No ads** (ARTEFACT-true and
automatically cross-checked). **Verdict E (console), but with a hard deadline attached.**

**2. Apple export compliance.** `ITSAppUsesNonExemptEncryption` is absent from
`ios/Runner/Info.plist` (IOS-04 / FE-21). All cryptography is OS-provided — HTTPS via URLSession and
Keychain via `flutter_secure_storage` — which Apple's own page calls exempt. Add
`<key>ITSAppUsesNonExemptEncryption</key><false/>`. Without it every upload prompts, and a *wrong*
answer creates an annual self-classification obligation. The French declaration is N/A because the
crypto is OS-only, regardless of territories. **D (low), zero cost, do it.**

**3. EU trader status.**
> "Even if you don't distribute apps in the EU, you'll still need to declare a trader status"
> — part 08 item 26. Must be answered even for an Egypt-only release. If the EU **is** in the
> territory list, trader verification is required and is slow — decide territories before submitting,
> not after. **E (console).**

**4. Territories and age assurance — decide early, it removes a whole surface.** If the **US storefront
is excluded**, the Texas/Utah/Louisiana Declared Age Range obligations (Apple) and Play's Age Signals
work disappear entirely (part 08 item 16, part 09 item 6e). Apple's Declared Age Range API is iOS
26.2+ native with no Flutter plugin, so US distribution would mean native work for an Egypt-targeted
app. **Recommend excluding the US for release 1, and recording it as a decision.** This also interacts
with POL-01: the US storefront is the one place Apple's link-out prohibition does **not** apply, so a
future US launch would change the adr-171 answer. **E (owner), with a POL-01 dependency.**

**5. Apple 4.5.4 push — N/A today, correctly.** No Firebase, no `UIBackgroundModes`, no
`POST_NOTIFICATIONS` (ARTEFACT). But `registerFcmToken` is stable in the contract (API-07) and four
dead toggles ship (FE-12). The issue is **2.3 metadata accuracy**, not 4.5.4 — hide the toggles
(POL-09). When push lands: opt-in copy, an opt-out setting, `POST_NOTIFICATIONS` requested in context
(not at launch), and new Data-safety/nutrition rows for the Firebase installation ID. **G today.**

**6. Apple 2.3.10 — no other-platform references in iOS metadata.** Nobody flagged this for the
*binary*, and it is not a binary problem (Android strings do not reach the IPA). It is a
**screenshot-production** rule: iOS screenshots must be captured on an iOS device or simulator — no
Android status bar, no Android navigation bar, no Play badge — and the description and keywords must
not mention Android. Note also that the two platforms carry **different bundle ids**
(`com.levelup.levelUpApp` vs `com.levelup.level_up_app`, IOS-17): harmless, but keep both out of
user-facing copy. **D (low), process rule for the listing.**

**7. Apple 5.1.1 data minimisation for `referralCode` — the framing in the brief is wrong, and that
matters.** The field is never transmitted (evidence in POL-11). There is no data-minimisation finding.
The finding is 2.1 / Play "misrepresent functionality" (POL-09). Remove the field. If it is ever
wired up, it becomes a referral-relationship disclosure and a new declaration row. **C, handled in
POL-09.**

**8. Play Restore Credentials, April 2027 — in scope, and it collides with device binding.**
> "From April 2027, apps on Play will need to support zero-tap restore credentials"
> — https://support.google.com/googleplay/android-developer/answer/17492799 (part 09 item 10e)

Level Up supports user sign-in, so it is in scope. Not a release-1 item — but **raise it with Seif
now**, because restoring a credential onto a new device contradicts the contract's one-device-one-
session rule (`session_superseded`, `openapi.yaml:56-60`) and would need a server-side answer, not a
client one. It also interacts with IOS-06 (the iOS Keychain already does a crude version of this, and
does it wrong). **No agent connected these three.** **D now, A by 2027.**

**9. Content-rating descriptors for a leaderboard — and the answer that expires.** Apple: "Contests"
(infrequent → 4+, frequent → 13+) covers a points board; do **not** tick "Social media" for a rank
list (part 08 note 7). At HEAD, tick **no UGC** on both questionnaires, because the board is not
routed (POL-06). Play IARC: same, and Play re-runs the rating when questionnaire answers change.
> ⚠️ **The release-1 answers become false the day the leaderboard ships.** Both questionnaires must be
> re-run *before* that release, not after. Put it in the release checklist; a stale rating answer is a
> false declaration, which both stores treat more harshly than the underlying content.
**C, with a diarised dependency.**

**10. Five things a reviewer would raise that no agent listed at all.**

- **(a) The `/message` bottom tab is a liability beyond POL-09.** Part 09 item 6c correctly concludes
  that a leaderboard is not messaging and Child Safety Standards do not apply — but the app ships a
  primary nav tab **labelled "Message"** in a product declared for 13–17. A reviewer reading the tab,
  not the code, has every reason to ask about messaging, moderation and Child Safety Standards.
  **Rename or remove it.** Cheapest high-value change in this report after the icon set.
- **(b) Device binding vs App Review and the Robo crawler** — see POL-03 §3. One credential cannot
  serve concurrent reviewers, and Play runs the pre-launch report on a device farm. This can fail both
  reviews for a reason that has nothing to do with the app's quality.
- **(c) The privacy policy must be reachable while logged out — the fix is routing, not copy.** Today
  `/legal/privacy` and `/legal/terms` are auth-gated (`app_router.dart:49` `_authRoutes = {'/', '/login',
  '/otp'}`, redirect at `:74`) and the pre-login links point at `.example`
  (`login_screen.dart:43-46`). Part 01 FE-02 notes both. The policy point nobody made explicit:
  **supplying the copy and a real URL is not sufficient** — Apple 5.1.1(i) and Play's User Data policy
  both require the in-app link, and an auth-gated policy screen fails them even with perfect copy.
  `/legal/*` must come out of the auth gate.
- **(d) Apple's Guideline 4 objection to out-linking for sign-in** — POL-01 reason 3. It is
  independent of payments and nobody listed it as a separate objection.
- **(e) Sign in with Apple stays exempt — keep it that way.** The 4.8 exemption holds because the app
  "exclusively uses your company's own account setup and sign-in systems" (part 08 item 5). 4.8 does
  not reach a website, so the redemption page could in principle offer social login without
  triggering it — but doing so would harden the Guideline 4 objection in (d) and would create a second
  identity system for the same student. **Keep the redemption page's auth on phone-OTP**, which is
  what `POST /auth/redemption-session/otp/*` already implies.

---

## Where agents disagree, and where the evidence is thin

**Disagreements (recorded, not collapsed):**

| # | Disagreement | My reading |
|---|---|---|
| 1 | Part 01 FE-08 rates purchase-silence an implementation **PASS**; `store_readiness_state.md` lists "Apple 3.1.1 exposure" under **HIGH**. | Both correct at different levels. The *code* is a pass (POL-01 §Recommendation); the *business model* carries residual risk no code change removes. Report them as two findings, never as one. |
| 2 | Part 08 note 3 concludes the adr-171 link is prohibited; part 09 item 8 concludes it is permitted subject to the landing page. | Not a contradiction — a genuine platform divergence, correctly researched on both sides. Resolution is a **platform-conditional build** (POL-01/POL-02), not a single answer. |
| 3 | Part 04 rates IOS-03 (`device_info_plus` / ITMS-91053) **"A (likely)"**; I rate POL-07 **B**. | It is caught at upload, needs no external party, and the best fix is a one-file change the contract already permits. It is an A only if the team keeps the plugin and relies on a Runner-manifest declaration. |
| 4 | `contract/openapi.yaml:1011-1018` mandates confirm-screen copy containing "paid" and "refund"; adr-171 §3 bans that vocabulary app-wide. | Genuine conflict between two authoritative sources. Proposed resolution in POL-04; **must be signed off by Seif and the owner**, not resolved silently. |

**Thin or missing evidence (do not treat as settled):**

1. **ITMS-91053: warning email vs hard rejection.** Apple's page was unreadable from this session
   (404 / JS-rendered). Part 08's quote "aren't accepted" is the best available. Plan for blocking.
2. **Whether the app-level manifest can cure a plugin's omission** (POL-07). Medium confidence,
   unquotable.
3. **Whether a newer `device_info_plus` declares DiskSpace.** Not checked — check the pub-cache
   `PrivacyInfo.xcprivacy`, not the changelog.
4. **`ScreenProtectorKit`'s mechanism and manifest status.** Closed xcframework; README sentence only;
   upstream repo 404 (part 08 ambiguity list, part 04 IOS-15).
5. **The Flutter engine's own iOS privacy manifest** — unverifiable on Windows (part 04 §4). The Xcode
   archive Privacy Report settles items 2, 4 and 5 in one look.
6. **Whether Egyptian law treats 13–17 as children** for Families policy. Legal, not researchable
   (Google says so itself).
7. **Server-side retention: logs, IPs, backups, subprocessors, erasure scope** (part 05 Q4–Q7). Blocks
   POL-11's forms.
8. **Whether Apple accepts a web-only-subscription education app with no IAP at all.** Not documented
   by Apple either way (part 08 ambiguity list). The residual in POL-01, and an owner decision.
9. **iOS is SOURCE-only throughout.** Nothing on the iOS side of this report has been built,
   archived, or validated by Apple tooling. Every iOS verdict is provisional until the first Mac
   release build (part 04 §6).

---

## Consolidated action list, in dependency order

| Order | Action | ID | Owner | Blocks |
|---|---|---|---|---|
| 1 | Production base URL published and shipped | POL-03 | Seif → app | everything |
| 2 | Production reviewer numbers (≥3), fixed OTP, per-IP exemption, entitled + seeded cohort, no expiry | POL-03 | Seif → console | both submissions |
| 3 | Hosted privacy policy + terms + support + **web deletion** URLs; `/legal/*` out of the auth gate | POL-04, POL-12(10c) | product/legal → frontend | both submissions |
| 4 | Account deletion: entry, confirm screen (7 points, AR+EN), cancel screen, global 403 redirect | POL-04 | frontend + product | both submissions |
| 5 | Owner decision: Android-only redemption link, or none. Landing-page certification if any. | POL-01, POL-02 | **owner** | iOS submission |
| 6 | Drop `device_info_plus`/`model` on iOS; add `ios/Runner/PrivacyInfo.xcprivacy`; no-op iOS screen protection | POL-07, POL-08, POL-11(c) | frontend | iOS upload |
| 7 | Brand icons (both platforms, adaptive + monochrome + 512 + feature graphic), localized label, one brand string | POL-10 | design + app | Play publish |
| 8 | Hide/finish stubs; remove the referral field; rename or remove the Message tab; make Support real | POL-09, POL-12(10a) | product + frontend | both reviews |
| 9 | Age floor (server rule + neutral client gate); purpose strings for DOB and parent phone | POL-05 | product/legal → Seif → frontend | declarations |
| 10 | Leaderboard: choose Option 0 (no peer names) or build filter/report/block; drop peer `studentId` | POL-06 | product + Seif | board release |
| 11 | Fill declarations only after Seif answers Q4–Q7; apply the six corrections | POL-11 | console + backend | both submissions |
| 12 | `ITSAppUsesNonExemptEncryption=false`; Play declarations (Financial/Health/Gov/Ads/News = none); trader status; exclude the US; diarise IARC re-run and Restore Credentials | POL-12 | console + owner | submission hygiene |
