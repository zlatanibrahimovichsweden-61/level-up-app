# Part 19 — Apple reviewer blind-spot hunt (Wave 3-C, Opus) — 2026-09-22

**Stance.** Adversarial senior App Review reviewer. The question is *not* "is the audit right" — it is
**"what would make ME reject or delay this app that parts 01–16 have NOT listed?"** Everything already
in `store_readiness_state.md`, parts 04 §1–3, 08, 11, 12 and 16 is treated as known and is **not
repeated**. Where a new finding touches an existing ID, the existing ID is named and only the **new**
angle is written.

**Read this session:** `store_readiness_state.md` (full); `08_policy_apple.md` (headings + all 16
per-item notes); `12_policy_gap_analysis.md` (headline, POL verdicts, POL-12 in full, disagreements,
action list); `04_ios_src.md` §1–3; `11_ios_lookups.md` (headings + summary); `16_reviewer_walkthrough.md`
§Headline, §1A, §3, §6, §7, §8.

**Verification levels.** SOURCE = read in this repo this session · WEB = fetched from the official
Apple page by this session (2026-09-22) · PARTS = taken from an earlier part file · UNVERIFIED = flagged.

**Severity legend (project standard).** A blocker · B high · C medium · D low · E external/console/owner
· F pass · G n/a.

**Read-only.** No repo file outside this one was created, edited or deleted.

---

## Web sources fetched this session (all 2026-09-22)

| # | URL | What it gave |
|---|---|---|
| W1 | `https://developer.apple.com/app-store/review/guidelines/` | 2.3.3, 2.3.8, 2.4.1, 4.1(a)(b)(c), 4.2/4.2.1/4.2.2/4.2.3, 5.1.1(i), 5.1.1(v), 5.1.2(i), 5.1.4(a)(b), 3.2.2(vi)(vii) — verbatim |
| W2 | `https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/` | iPad 13" screenshot **"Required if app runs on iPad"**, 2064 × 2752 |
| W3 | `https://developer.apple.com/help/app-store-connect/reference/age-ratings/` | verbatim definitions of Unrestricted Web Access, User-Generated Content, Social Media, **Social Media Disabled for Users Under 13**, Messaging and Chat, **Contests**, Parental Controls, Age Assurance |
| W4 | `https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/` | Content Rights text; Name 2–30 chars; Subtitle 30 chars; **age rating "is applied across all platforms"** |
| W5 | `https://developer.apple.com/help/app-store-connect/reference/app-review-information/` | **"Sign-in required: Username and password"**; Notes 4000 bytes; "must not expire" |
| W6 | `https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/manage-availability-of-iphone-and-ipad-apps-on-macs-with-apple-silicon/` | Mac availability is **on unless edited**; opt-out checkbox wording |
| W7 | WebSearch → `developer.apple.com` (TN3192 + WWDC25/26 sessions) | `UIRequiresFullScreen` deprecated; iPad multitasking opt-out removed |

**One fetch degraded:** `TN3192` returned title-only (JS-rendered body), same failure class part 12 hit
on `describing-use-of-required-reason-api`. BS-C-02's *mechanism* therefore rests on W7's search
synthesis of Apple's own pages plus the `UIRequiresFullScreen` deprecation notice — **flagged
UNVERIFIED for exact wording**, but the deprecation itself is not in doubt.

---

## Headline — the three I would actually stop the submission on

1. **The binary claims iPad, and iPad is unowned.** `TARGETED_DEVICE_FAMILY = "1,2"` makes a 13" iPad
   screenshot set **mandatory in App Store Connect before the build can be submitted** (W2), and
   iPadOS 26 has removed the full-screen opt-out, so the app is a freely resizable window on a device
   whose layout nobody has ever opened. Two `LayoutBuilder` call sites exist in ~36k lines of `lib/`.
   **Shipping iPhone-only deletes this entire surface for one line in the pbxproj.** (BS-C-01, BS-C-02)
2. **The reviewer will tap Delete Account, and at HEAD that is irreversible and takes the phone number
   with it for 30 days.** POL-03's own paste-able notes *invite* them to. There is no cancel screen
   (API-03). One tap ends the review and poisons the demo credential for a month. (BS-C-06)
3. **The app collects a birthdate and a parent's phone number and does nothing with either.** 5.1.4(a)
   permits asking "**only for the purpose of complying with these statutes**" (W1, verbatim). At HEAD
   `dateOfBirth` is required, stored, and read by **zero** age logic; there is no under-13 gate, no
   parental-consent flow, and the parent never consents to their own number being transmitted
   (5.1.2(i)). The Notes text POL-03 drafted asserts a purpose the code does not implement.
   (BS-C-07, BS-C-08)

---

## Findings

### BS-C-01 · A · iPad support is declared in the binary and is a hard App Store Connect submission gate

**Issue.** `TARGETED_DEVICE_FAMILY = "1,2"` in all three build configurations. App Store Connect then
requires a 13" iPad screenshot set (2064 × 2752 portrait / 2752 × 2064 landscape) before the version
can be submitted. Nobody owns iPad: `lib/` contains exactly **two** `LayoutBuilder` call sites
(`segmented_track.dart`, one other) and **zero** width-breakpoint logic; `docs/RESPONSIVE.md` is
"proposed, not applied" (project quick-reference); FE-17 records "no orientation lock, iPad landscape
untested" and rates it C. Nobody has connected the device-family flag to the **screenshot gate**.

**Why a reviewer raises it.** They do not — App Store Connect does, earlier and harder. A missing
required screenshot set blocks the *Submit for Review* button. When it is unblocked with hastily
up-scaled iPhone images, 2.3.3 applies to those images too.

**Clause.** W2, screenshot specifications, 13" Display: > "Required if app runs on iPad"
— https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/
Note 2.4.1 is an *encouragement*, not a requirement: > "iPhone apps should run on iPad whenever
possible." — https://developer.apple.com/app-store/review/guidelines/ — **dropping iPad is allowed.**

**Evidence.** `ios/Runner.xcodeproj/project.pbxproj:353,479,532` (SOURCE, this session);
`ios/Runner/Info.plist:37-43` iPad all four orientations (PARTS 04 §2); `grep -rn LayoutBuilder lib/`
→ 2 hits (SOURCE).

**Action.** Owner decision this week: **set `TARGETED_DEVICE_FAMILY = "1"` for release 1**, remove the
`UISupportedInterfaceOrientations~ipad` block, and record it in `docs/DECISIONS.md`. This deletes
BS-C-02, the iPad screenshot set, FE-17's iPad half and part 04 §6's iPad verification item in one
change. Re-add iPad when a designer has produced iPad frames. **Owner: owner + frontend.**

---

### BS-C-02 · B · iPadOS 26 removed the full-screen opt-out — the app is a resizable window and nothing adapts

**Issue.** Part 04 §2 records `UIRequiresFullScreen` as *absent* and part 16 §3 reads that as
"multitasking-compatible". Under iPadOS 26 the key is **deprecated and no longer honoured** — an app
built against the iPadOS 26 SDK (mandatory since 2026-04-28, IOS-16/part 11) cannot opt out of
multitasking or dynamic resizing at all. Every frame is a portrait phone design with hand-rolled
headers (FE-17), and BUG-002 already proves the layout breaks under *vertical* pressure at text scale
1.3 in Arabic. Horizontal pressure has never been tested because it was never possible to reach.

**Why a reviewer raises it.** iPad review runs in a window the reviewer drags. A `RenderFlex overflowed
by N pixels` stripe is filed as 2.1 (App Completeness) or 4.0 (Design), with a screenshot attached.
It is also the single most likely thing to be found, because resizing is the first thing an iPad
reviewer does.

**Clause.** 2.1 App Completeness (W1). The mechanism is Apple's own deprecation of
`UIRequiresFullScreen` — TN3192 / WWDC25 "Make your UIKit app more flexible", WWDC26 "Modernize your
UIKit app". **UNVERIFIED for exact wording** (TN3192 body is JS-rendered; W7 search synthesis only).

**Evidence.** `ios/Runner/Info.plist` — no `UIRequiresFullScreen` (PARTS 04 §2, re-checked SOURCE);
`docs/KNOWN_BUGS.md:104` BUG-002; FE-17; 2 `LayoutBuilder` in `lib/`.

**Action.** Subsumed by BS-C-01 if iPad is dropped. If iPad is kept: adopt the UIScene lifecycle
(IOS-05, which the first Mac build does anyway), set a `UIWindowScene` `sizeRestriction` minimum, and
run a real device pass at 1/2 and 1/3 widths in both languages before submitting. **Owner: owner
(decide) → frontend.**

---

### BS-C-03 · C · The app auto-publishes to Macs with Apple silicon and to Apple Vision Pro — both default ON

**Issue.** Nobody in parts 01–16 mentions either storefront. Both are opt-*out*, not opt-in, and the
opt-out lives in ASC → Pricing and Availability. The app has never been launched on either. Concretely
on a Mac: `flutter_secure_storage`'s Keychain item persists across app removal in a way nobody has
modelled (IOS-06 is an iPhone finding); `screen_protector`'s `isSecureTextEntry` layer trick is
undefined on macOS's iOS-app runtime (IOS-19 / POL-08); the app is RTL-by-default (REV-02) inside a
Mac window it does not control; and `connectivity_plus` / `device_info_plus` report a Mac.

**Why a reviewer raises it.** They may not — but the Mac *storefront* is public, the app is 13+ rated
there too (W4: the rating "is applied across all platforms"), and one Apple reviewer testing the
"iPhone apps on Mac" path against an Arabic-first portrait UI with a black quiz screen is a 2.1 report
nobody planned for. The cost of avoiding it is two checkboxes.

**Clause.** W6: > "Users running macOS 11 or later on Macs with Apple silicon can access iPhone and
iPad apps through the Mac App Store, provided no edits are made to the app availability."
— https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/manage-availability-of-iphone-and-ipad-apps-on-macs-with-apple-silicon/
Opt-out wording: > "deselect 'Make this app available' to opt out of offering your app on the Mac App
Store." The Vision Pro equivalent is "Make this app available on Apple Vision Pro".

**Evidence.** External (console). Repo has no macOS/visionOS runner and no code path that tests for
either (SOURCE: `grep -rn "Platform.isMacOS" lib/` → 0).

**Action.** In ASC → Pricing and Availability, **deselect both** for release 1. Record as a decision so
release 2 revisits it deliberately. **Owner: console (owner).**

---

### BS-C-04 · A · "Content Rights" is an unanswered question with a legal dependency: who wrote the question bank?

**Issue.** App Store Connect → App Information carries a **Content Rights** declaration, and the app
cannot be submitted until it is answered. No part of this audit establishes the provenance of the
question bank, the answer explanations, the flashcards, or the reference data (school lists,
university/faculty/study-year lists, governorates). If any of it derives from textbooks, past papers,
a ministry syllabus, or a third-party publisher, the team must hold the rights **and attach
documentary evidence in App Review Information**. SEC-14 flags "logo ownership unverified" — that is
the *brand*, not the *content*, and the content is the entire product.

**Why a reviewer raises it.** It is a form field, and a false answer is a Developer Code of Conduct
problem rather than a guideline one. Education apps built on exam content are a known target for
publisher takedowns; a reviewer seeing recognisably-sourced questions can ask for proof at any time.

**Clause.** W4: > "Apps that contain, show, or access third-party content must have all the necessary
rights to that content or be otherwise permitted to use it under the laws of each App Store country
or region in which they're available."
— https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/

**Evidence.** External. Repo-side: the app only *renders* server content — `openapi.yaml` carries no
provenance, licence or attribution field for questions, explanations or flashcards (SOURCE grep for
`licen|copyright|attribution|source` in `contract/openapi.yaml` → no content-provenance field).

**Action.** Owner answers, in writing, before the ASC record is created: who authored the questions,
under what agreement, and whether any are transcribed from published material. If "yes, third-party
content", prepare the evidence pack. Google Play has the equivalent under the Intellectual Property
declarations. Add it to the EXTERNAL / CONSOLE ITEMS list in the state file. **Owner: owner + legal.**

---

### BS-C-05 · A · The "Sign-in required" field is Username + Password; the app has neither

**Issue.** POL-03 wrote excellent 4000-byte Notes prose but did not address the **two structured
fields** that App Review actually reads first. They are literally labelled "Username" and "Password".
An app with a phone-and-OTP login has no value for either. Leaving them blank while ticking
"Sign-in required" is the classic path to *"We were unable to sign in to review your app"* — a 2.1
rejection that costs a full review cycle and says nothing about the app.

**Why a reviewer raises it.** The reviewer opens the app, sees a login wall, looks at the sign-in
fields, and finds them empty or unusable. They do not always read Notes first.

**Clause.** W5: > "Sign-in information for a demo account… The demo account is used during the App
Review process and must not expire. Details for additional accounts should be included in the Notes
field." — https://developer.apple.com/help/app-store-connect/reference/app-review-information/

**Evidence.** External (console) + `lib/features/auth/screens/login_screen.dart` (phone + OTP only, no
password field anywhere in `lib/` — SOURCE).

**Action.** Fill **Username** = the reviewer phone in the exact format the login screen expects
(REV-14: the field accepts full E.164 with a leading `+`, so give `+20XXXXXXXXXX` — do **not** rely on
POL-03 §1's "WITHOUT the leading zero" instruction, which REV-14 has already corrected), and
**Password** = the fixed OTP. Repeat both in Notes §1 with the step order. Consider attaching a short
screen recording via the **Attachment** field showing the sign-in — it pre-empts both this and the
black-quiz-screen surprise (BS-C-11). **Owner: console.**

---

### BS-C-06 · A · The reviewer will tap "Delete account", and at HEAD that ends the review and blocks the phone for 30 days

**Issue.** 5.1.1(v) deletion is a standing checklist item, so a reviewer *will* exercise it. The
contract's own description of what happens:

> "The caller's session and refresh chain are revoked — this `202` is the last thing that token does…
> The phone stays blocked for the whole grace window (the account still exists) and is freed at
> execution." — `contract/openapi.yaml:1005-1019`

So: the reviewer is logged out instantly; the account enters a state where **every authenticated
endpoint outside a four-endpoint allowlist returns 403 `account_pending_deletion`** (`:1021-1024`); the
only recovery is logging back in and calling `DELETE /me/deletion-request` — which the app **cannot
do, because there is no cancel screen** (API-03, "grace-window dead end", already listed). And a
resubmission within 30 days cannot register a fresh account on that number.

**What is new.** The audit lists the cancel-screen gap (API-03) and lists deletion as a POL-04 blocker.
Nobody has connected them to the **reviewer credential**. Worse, POL-03's own paste-able Apple Notes
§6 actively invites it: *"In app: Profile > Settings > Delete account."* That paragraph, shipped as
written, is an instruction to destroy the demo account.

**Why a reviewer raises it.** They do not raise it — they trigger it, then report *"the app stopped
working after we tested account deletion"*, which is a 2.1 rejection on a credential that cannot be
reissued for a month.

**Clause.** 5.1.1(v) (W1): > "If your app supports account creation, you must also offer account
deletion within the app." Plus W5: the demo account "must not expire."

**Evidence.** `contract/openapi.yaml:996-1024` (SOURCE, this session); API-03 (PARTS 05/13);
`12_policy_gap_analysis.md:` POL-03 paste-able notes §6 (PARTS).

**Action, three parts, all required.**
1. **Seif provides a dedicated, resettable deletion-test number** (a 4th whitelisted number) whose
   grace state the backend can clear on demand.
2. **Rewrite POL-03 Notes §6** to name *that* number for the deletion test and to say explicitly:
   *"Please use [DELETION_TEST_PHONE] to test account deletion; the main review account cannot be
   restored for 30 days."*
3. **The cancel screen is not optional.** Without it the app fails its own confirm-screen promise
   ("reversible only inside the grace window") and there is no in-app path back.
**Owner: Seif (1) + owner/console (2) + frontend (3).**

---

### BS-C-07 · B · 5.1.4(a) permits DOB and parent contact "only for the purpose of complying with these statutes" — and the app complies with nothing

**Issue.** POL-05 rates minors B and names "no age floor" and "mandatory unexplained parentPhone". The
clause that actually governs it has not been quoted, and it is narrower than the audit assumes:

> "Apps may ask for birthdate and parental contact information **only for the purpose of complying
> with these statutes**, but must include some useful functionality or entertainment value regardless
> of a person's age." — 5.1.4(a), https://developer.apple.com/app-store/review/guidelines/

At HEAD `dateOfBirth` is a **hard-required** registration field
(`registration_validation.dart:80,140`; pickers at `school_detail_screen.dart:126` and
`university_detail_screen.dart:118`) and is read by **zero** age logic anywhere in `lib/` — there is
no under-13 block, no parental-consent flow, no differentiated behaviour, nothing. The same is true of
`parentPhone`, which is write-only (FE-15 / PRIV-*). So the permission in 5.1.4(a) does not attach:
the app is not collecting these to comply with a statute, it is collecting them because the form asks.

**Why a reviewer raises it.** The natural question — *"why do you need the parent's phone number?"* —
has no answer the code supports. POL-03's Notes §5 asserts *"collected to meet children's-privacy
obligations and to allow account recovery"*; the first half is unimplemented and the second half is
also unimplemented (the recovery endpoints use the **student's** phone, `openapi.yaml:77`). Asserting
an unimplemented purpose in review notes is worse than saying nothing.

**Clause.** 5.1.4(a) verbatim above; plus 5.1.1(v): > "Apps may not require users to enter personal
information to function, except when directly relevant to the core functionality of the app or
required by law."

**Evidence.** `lib/features/registration/models/registration_validation.dart:80,140`;
`lib/features/registration/screens/signup_identity_screen.dart:78-83` (hard block on parent phone);
`grep -rn dateOfBirth lib/ | grep -v freezed` → model + validation + mock only, **no age comparison**
(all SOURCE, this session).

**Action.** Either **implement the stated purpose** (an age floor that acts on the DOB; a documented
parental-notification use for the number) or **stop collecting them**, which needs a contract change
from Seif. Whichever is chosen, the in-app field must carry a one-line purpose string, and Notes §5
must describe what the app *does*, not what it intends. **Owner: product/legal → Seif → frontend.**

---

### BS-C-08 · B · 5.1.2(i): the parent's phone number is a third party's personal data collected without that third party's permission

**Issue.** Every part treats `parentPhone` as a declaration row (DECL-*, POL-11) or a minimisation
question (POL-05). Nobody has framed it as what it is: the app transmits an **identified non-user's**
phone number to a server, and that person never sees the app, never consents, and has no route to
erasure — the deletion endpoint deletes the *student's* account.

**Clause.** 5.1.2(i), verbatim: > "Unless otherwise permitted by law, you may not use, transmit, or
share someone's personal data without first obtaining their permission."
— https://developer.apple.com/app-store/review/guidelines/
The "otherwise permitted by law" carve-out is exactly the 5.1.4(a) statutory route — which BS-C-07
shows is not currently occupied.

**Why a reviewer raises it.** A 13-year-old typing a parent's mobile number into a mandatory field, in
an app declared for minors, is a visible, concrete instance of the clause. It is also the question a
privacy-minded reviewer asks *instead of* approving.

**Evidence.** `signup_identity_screen.dart:75,78-83,89-94` (collected, validated, mandatory);
`contract/openapi.yaml` school/university registration bodies (PARTS 05); `parts/07` data map row for
parent phone; no erasure route for the parent (SOURCE: deletion is caller-scoped,
`openapi.yaml:999-1000` "the **caller's own** account (there is no id parameter)").

**Action.** The hosted privacy policy must (a) name the parent/guardian as a data subject, (b) state
the legal basis, (c) state retention, and (d) give the parent a contact route to request erasure. The
in-app field must state the purpose before the number is typed. If legal cannot support (a)–(d),
the field must go. **Owner: legal → product → frontend.**

---

### BS-C-09 · C · Age rating: "Contests" is true at HEAD, not only when the leaderboard ships

**Issue.** Part 08 note 7 reads Contests as "probably covers leaderboards" and POL-12(9) concludes
"At HEAD, tick **no UGC** on both questionnaires, because the board is not routed" — correct for UGC,
but it leaves the impression that the whole chance-based block is a future problem. Apple's actual
definition is broader than a leaderboard:

> "**Contests:** Events that allow users to compete with one another for rankings, rewards, or the
> achievement of personal goals."
> — https://developer.apple.com/help/app-store-connect/reference/age-ratings/

Points, levels, streaks (`StreakPair`), `"topStudent": "Top Student"` (`app_en.arb:249`),
`"rewardsEarned": "REWARDS EARNED"` (`:431`) and the onboarding tagline
`"Study. Compete. Achieve."` (`:83`) are "the achievement of personal goals" with the board hidden.
Answering "no contests" while the onboarding screen says *Compete* is a declaration that contradicts
the first screenshot.

**Why a reviewer raises it.** Age-rating answers are cross-checked against the binary and the
screenshots. A contradicted answer is treated more harshly than the underlying content, because it is
a false declaration (POL-12(9) makes this point about the *future* re-run; it applies now).

**Evidence.** `lib/l10n/app_en.arb:83,249,431` (SOURCE, this session); `lib/core/theme/app_colors.dart:1118`
`topStudentFill` (the Top Student card is a built, themed surface, not a stub).

**Action.** Tick **Contests** on both the Apple questionnaire and IARC at release 1 — "infrequent"
still lands at 4+, and the target is 13+ anyway, so it costs nothing and removes the contradiction.
**Owner: console.**

---

### BS-C-10 · C · Two age-rating answers that are right today and become wrong the moment the redemption link ships

**Issue.** Nobody has written the questionnaire answers down against Apple's verbatim definitions.
Two of them are volatile:

**(a) Unrestricted Web Access — NO today.**
> "Users can navigate to any webpage within the app or freely browse the web. *May include: embedded
> browser functionality or browser app.*" — W3
At HEAD the only outbound navigation is `launchUrl(..., mode: LaunchMode.externalApplication)`
(`login_screen.dart:118`, the **only** `launchUrl` in `lib/` — SOURCE). That leaves the app entirely;
it is not "within the app". Answer **No**. **But** adr-171 §3 asks for SFSafariViewController /
Chrome Custom Tabs, which *is* in-app browser chrome, and RED-01 already found the Android leg
silently degrades to an **embedded WebView**. If that link ships, this answer must be re-examined —
and an embedded WebView pointing at a redemption page compounds POL-01 and Apple's Guideline 4
objection (POL-12(10d)) rather than sitting beside them.

**(b) Messaging and Chat — NO, while a primary tab is labelled "Message".**
> "**Messaging and Chat:** Users can directly communicate with one another through features within
> the app." — W3
The honest answer is No (nothing communicates). But the app ships a bottom-tab labelled EN
`"Message"` / AR `"الرسائل"` (REV-06). A "No" answer next to a tab named *Messages* is a reviewer's
invitation to open a Child Safety conversation. This is the declaration-accuracy half of POL-12(10a)
and REV-06, which both argued the point on product grounds only.

**Action.** Answer No/No, and **remove the Message branch before filing** so both answers are
defensible on inspection. Diarise a questionnaire re-run as a gate on any release that adds the
redemption link or the leaderboard. **Owner: console + product.**

---

### BS-C-11 · C · 2.3.3 requires screenshots of the app in use — and the app's core screen cannot be captured from a release build

**Issue.** Capture protection is enabled on the quiz and quiz-review screens on **both** platforms
(`quiz_screen.dart:69-70,74-79`; `quiz_review_screen.dart:64-65,69-72`). SEC-07 and part 16 §3 note
that this makes *Play pre-launch-report* screenshots black and say "note it in App access". Nobody has
written the consequence for the **marketing screenshots**: the App Store listing must show the app in
use, the app in use *is* the quiz, and a screenshot taken on a production build is a black rectangle.

**Clause.** > "Screenshots should show the app in use, and not merely the title art, login page, or
splash screen." — 2.3.3, https://developer.apple.com/app-store/review/guidelines/
Plus 2.3.10: iOS screenshots must be captured on iOS — no Android chrome (POL-12(6) states this rule;
it does not state the capture-protection interaction).

**Evidence.** `lib/features/quiz/screens/quiz_screen.dart:69-70,74-79`;
`lib/features/quiz/screens/screen_protection.dart:30-37` (PARTS 01/06, re-confirmed SOURCE).

**Action.** Add a documented **"listing-assets build"** to the release runbook: a build with
`preventScreenshotOn` compiled out or flag-disabled, used only to capture the quiz/review frames, on
an iOS device at 6.9"/6.5" (and 13" iPad only if BS-C-01 is declined). It must be a *separate,
never-shipped* build, and the runbook must say so. If POL-08's recommendation lands and the iOS leg
is dropped, iOS capture becomes free and only Android needs the workaround. **Owner: release +
design.**

---

### BS-C-12 · B · Nobody has reserved the app name, and "Level Up" is generic enough to already be taken

**Issue.** IOS-11 rates the three-brand-string inconsistency **E** (`Info.plist:8` "Level Up App",
`:16` `level_up_app`, ARB "Level Up" / "ليفل أب"). The *submission* risk is larger and has a different
shape: the App Store name is reserved when the app record is created, first-come, and "Level Up" is a
common product name across education and fitness. If it is unavailable the team discovers it on the
day they try to create the record — after the icon, the screenshots and the Notes are done.

Related, and also unlisted: 2.3.8 requires > "your metadata, including app name and icons (small,
large, Apple Watch app, alternate icons, etc.), are similar to avoid creating confusion" — so a store
name of "Level Up: …" beside a home-screen name of "Level Up App" is a mismatch to settle **before**
reservation, not after. And 4.1(c): > "You cannot use another developer's icon, brand, or product name
in your app's icon or name, without approval from the developer." — nobody has done trademark
clearance for "Level Up" in Egypt or in the App Store's education category.

**Clause.** W4: > "The name must be at least two characters and no more than 30 characters." Subtitle:
> "This can't be longer than 30 characters." Plus 2.3.8 and 4.1(c), verbatim above (W1).
Also 5.1.4(b), which constrains the listing copy for this audience: > "Apps not in the Kids Category
cannot include any terms in app name, subtitle, icon, screenshots or description that imply the main
audience for the app is children."

**Evidence.** `ios/Runner/Info.plist:7-8,15-16`; `lib/l10n/app_en.arb:3`, `lib/l10n/app_ar.arb:3`
(SOURCE, this session); `android/app/src/main/AndroidManifest.xml:27` (PARTS 03).

**Action.** This week, independent of everything else: **create the App Store Connect record to reserve
the name** (reserving costs nothing and does not commit to a submission date) and reserve the Play
listing title; pick **one** brand string and align `CFBundleDisplayName`, `CFBundleName`, the Android
label and the ARB; add `ar.lproj/InfoPlist.strings` with the Arabic display name (IOS-07 already asks
for `CFBundleLocalizations`); run a basic trademark check. Note "App" in the display name reads as
filler — the home screen truncates around 12 characters and "Level Up App" will render as "Level Up
App" or worse. **Owner: owner.**

---

### BS-C-13 · D · App ID and app-name reservation are two separate irreversible steps, and only one is listed

**Issue.** IOS-08 says the App ID `com.levelup.levelUpApp` "must be registered (irreversible after
first upload)". It does not say that the **name reservation** is a *second*, independent first-come
reservation made when the ASC record is created (BS-C-12), nor that the bundle id's mixed case is
preserved forever. Apple permits alphanumerics, hyphens and periods in a bundle id; case is legal and
there is **no rule against mixed case** — but `com.levelup.levelUpApp` (iOS) against
`com.levelup.level_up_app` (Android) is two identities to type correctly into every console, CI secret
and analytics property for the life of the product.

**Evidence.** `ios/Runner.xcodeproj/project.pbxproj:371`; `android/app/build.gradle.kts:43` (PARTS 04).

**Action.** Do both reservations in the same sitting, record both strings in `docs/DECISIONS.md`
(IOS-17 already asks for this), and never put either in user-facing copy (POL-12(6)). **Owner: owner.**

---

### BS-C-14 · C · 5.1.1(i) requires the privacy policy to state retention and deletion — which Seif has not answered, so the policy is backend-blocked, not hosting-blocked

**Issue.** POL-04's action list puts "hosted privacy policy + terms + support + web deletion URLs" at
order 3 with owner "product/legal → frontend", implying a writing-and-hosting task. The clause makes
it a **backend-dependent** task:

> "Explain its data retention/deletion policies and describe how a user can revoke consent and/or
> request deletion of the user's data." — 5.1.1(i), third bullet,
> https://developer.apple.com/app-store/review/guidelines/

Parts 05 Q4–Q7 (retention periods, log/IP retention, backups, subprocessors) are **unanswered**, and
DECL-* found "quiz attempts kept forever" contradicts a blanket deletion claim. So the policy cannot
be written truthfully today — and a policy that *is* written today will contain sentences the backend
contradicts, which is exactly the false-declaration failure mode POL-11 warns about elsewhere.

**Evidence.** PARTS 05 Q4–Q7; PARTS 14 DECL-* ("blanket deletion vs quiz attempts kept forever");
`contract/openapi.yaml:996-1024` (erasure scope described only in confirm-screen copy, not as a data
schedule) (SOURCE).

**Action.** Promote Q4–Q7 out of the "backend questions" bucket onto the **submission critical path**,
above the privacy-policy drafting task, in `store_readiness_state.md`'s NEXT EXACT ACTIONS. The policy
also has to satisfy BS-C-08 (the parent as a data subject) and BS-C-07 (the stated purpose of DOB).
**Owner: Seif → legal.**

---

### BS-C-15 · C · Removing the stub tabs is a nav-bar redesign, not a route deletion — and nobody has costed it

**Issue.** POL-09, POL-12(10a), FE-10 and REV-06 all recommend hiding or removing the Leaderboard and
Message tabs. Read as a routing change that is two `StatefulShellBranch` deletions. It is not:
`MainShell` hardcodes **five** destinations in a fixed list and positions the raised centre "Learn"
button at `static const _centreIndex = 2` inside an `Expanded`-per-slot `Row`
(`main_shell.dart:35,56-62,64-80`). Drop two branches and the centre index is wrong, the raised bump
sits off-centre, and the bar's painted shape — which is a designed Figma surface, not a
`NavigationBar` — no longer matches its background. There are no iPad/width breakpoints to absorb it
(BS-C-01).

**Why it matters for review timing.** It converts an "easy win" that three parts recommend into a
design task with a Figma dependency, on the critical path of two separate policy findings. If that is
not known now, it surfaces in the last week.

**Evidence.** `lib/features/shell/main_shell.dart:35,56-62,64-80` (SOURCE, this session).

**Action.** Cost it as a design change: either a 3-slot bar with the centre bump re-derived, or keep 5
slots and re-purpose the two — but decide now, because POL-09, POL-12(10a) and BS-C-10(b) all depend
on it. **Owner: design + frontend.**

---

### BS-C-16 · D · The September-2026 age-rating questions are live today, and two of them have no honest "yes"

**Issue.** Part 08 note 7 records *"beginning in September 2026, responses will be required when
submitting new apps or updates"* in the future tense. **It is 2026-09-22 — they are required now.**
The current questionnaire (W3) carries, under In-App Controls and Capabilities:
- **Parental Controls** — "Settings or tools that allow parents/guardians to monitor, manage, or
  restrict a child's access…" → **No.** The app has none; the parent's phone number is not a control.
- **Age Assurance** — "Mechanism to confirm an individual's age meets the age requirement…" → **No.**
  There is no age floor at all (FE-15) and the DOB is inert (BS-C-07).
- **Social Media Disabled for Users Under 13** — "Users under 13 don't have access to social media
  capabilities." → cannot be answered "yes": there is no under-13 determination in the app, so the
  app cannot assert that under-13s are excluded from anything.

**Why it matters.** POL-05 and POL-12(4) frame the age story around *territories and assurance laws*.
This is the questionnaire, which applies on every storefront including Egypt-only, and three honest
"No" answers next to a 13+ rating and a mandatory DOB is a coherent-looking but slightly odd picture
that is easiest to explain if BS-C-07's age floor exists.

**Evidence.** W3 (verbatim definitions); FE-15 (PARTS 01); BS-C-07 evidence (SOURCE).

**Action.** Answer all three No, and note in Notes §5 that the product's stated minimum age is 13 and
is enforced at registration **if and when** BS-C-07's floor ships. **Owner: console.**

---

### BS-C-17 · D · TestFlight is the only way to de-risk S2, and the schedule has zero days for it

**Issue.** REV-30 correctly notes that ITMS validation bites on the first TestFlight upload too. What
is not listed: **external** TestFlight groups go through Apple's Beta App Review — a separate queue
with its own turnaround — while **internal** testers (App Store Connect users on the team) do not.
Given that iOS has never been built at all (IOS-01) and every iOS verdict in this audit is a
projection (part 12's thin-evidence item 9), the first honest artefact-level statement about the iOS
app is days away at best, and the plan has not budgeted for it.

**Evidence.** External; PARTS 16 REV-30; PARTS 04 IOS-01.

**Action.** Sequence explicitly: Mac release build → internal TestFlight (no review) → device
walkthrough against §1B → fix → external TestFlight only if an Egyptian pilot is wanted → submit. Put
the internal-TestFlight step into `store_readiness_state.md`'s NEXT EXACT ACTIONS, because it is the
step that converts every SOURCE-level iOS claim into ARTEFACT/DEVICE. **Owner: owner.**

---

### BS-C-18 · F/G · Things I checked adversarially and would **not** reject on

Recorded so nobody re-opens them.

| Topic | Verdict | Basis |
|---|---|---|
| **2.4.1 iPad** | **Not a requirement.** > "iPhone apps should run on iPad whenever possible." (W1) — an encouragement. Shipping iPhone-only is clean. | W1 |
| **3.2.2(vi)** | **G.** Verbatim (W1) it is about *"collecting funds within the app for charities and fundraisers"* — not rewards-for-installs. The brief's premise is wrong. | W1 |
| **3.2.2(vii)** | **G.** > "Artificially manipulating a user's visibility, status, or rank on **other services**" — a first-party leaderboard is not another service. | W1 |
| **Refer a Friend / 5.3** | **G today.** `referralCode` is collected and never transmitted (FE-13 / PRIV-*), `profileReferAFriend` routes to `referUnavailable` ("Inviting friends isn't available yet.", `app_en.arb:507-508,607`). 5.3 governs real-money gaming and lotteries; a points board has no consideration and no prize. **Becomes live** if "Top Student" ever carries a real prize — then local promotion law and a sponsor disclosure apply. | W1, SOURCE |
| **4.2 Minimum Functionality** | **F.** Even after the full stub cull, release 1 is login → subject tree → MCQ quiz → answer review → flashcards → profile. That is not "a repackaged website" (W1, 4.2) and not "a collection of links" (4.2.2). 4.2.3(i) passes — the app needs no other app. | W1 |
| **4.2.2 / 4.2.3 / 4.5.1 / 5.6.3** | **G**, as the brief assumed: no web wrapper, no companion-app dependency, no Apple services, no discovery fraud. | W1, PARTS |
| **Export compliance annual self-classification** | **G** with `ITSAppUsesNonExemptEncryption=false`. The annual obligation attaches only to a *non-exempt* answer. IOS-04 / POL-12(2) already own the plist key. | PARTS 08 item 11 |
| **Mixed-case bundle id** | **F.** No Apple rule. Noted in BS-C-13 only as an operational inconsistency. | — |
| **Dynamic Type / VoiceOver** | **F for rejection, real for complaints.** No guideline mandates Dynamic Type support or SVG accessibility labels; Accessibility Nutrition Labels are optional (PARTS 11 §8). FE-16 / BUG-002 stay quality findings — except where they meet BS-C-02, which makes them a 2.1 *appearance* problem. | PARTS |
| **Sign in with Apple (4.8)** | **G**, confirmed unchanged: own account system only. Keep the redemption page on phone-OTP (POL-12(10e)). | PARTS 08 item 2 |

---

## What would still stop me, in order, if every listed fix landed

1. `TARGETED_DEVICE_FAMILY = "1,2"` with no iPad screenshots and no iPad layout. (BS-C-01/02)
2. Delete-account tested on the only review credential. (BS-C-06)
3. An empty "Sign-in required" pair. (BS-C-05)
4. An unanswered Content Rights question with unknown question-bank provenance. (BS-C-04)
5. A privacy policy that cannot truthfully state retention. (BS-C-14)

---

## Cross-references — where this part sharpens, not repeats

| New ID | Existing ID it touches | What is new |
|---|---|---|
| BS-C-01 | FE-17, part 04 §1 device family | The **ASC screenshot gate**; the recommendation to drop iPad |
| BS-C-02 | part 16 §3 "Split View expected to work", IOS-05 | iPadOS 26 **removed the opt-out**; it is no longer optional |
| BS-C-06 | API-03, POL-04, POL-03 notes §6 | The reviewer **credential** consequence; the sacrificial 4th number |
| BS-C-07 | POL-05, FE-15 | The **5.1.4(a) "only for the purpose"** clause; DOB is inert in `lib/` |
| BS-C-08 | POL-11 / DECL-* parentPhone rows | Reframed as **5.1.2(i) third-party consent**, not a declaration row |
| BS-C-09 | POL-12(9) | Contests applies **at HEAD**, board hidden, on the definition's own wording |
| BS-C-10 | POL-12(10a), REV-06, RED-01 | The **questionnaire answers** those findings change |
| BS-C-11 | SEC-07, part 16 §3 | **Marketing screenshots**, not pre-launch reports |
| BS-C-12 | IOS-11 | **Name reservation** and 2.3.8/4.1(c), not just string inconsistency |
| BS-C-15 | POL-09, REV-06 | Removing tabs is a **design** change (`_centreIndex = 2`) |
| BS-C-16 | POL-05, part 08 note 7 | The September-2026 questions are **live today** |

---

## UNVERIFIED after this pass

1. **TN3192's exact wording** on `UIRequiresFullScreen` (BS-C-02) — JS-rendered body; the deprecation
   is certain, the precise "ignored from version X" sentence is not quoted here.
2. **Whether "Level Up" is available** as an App Store name — requires signing into App Store Connect.
3. **Question-bank provenance** (BS-C-04) — owner knowledge, not researchable.
4. **Whether Apple's Beta App Review turnaround** for external TestFlight is materially different from
   App Review's in 2026 (BS-C-17) — not published; plan for "another queue", not a number.
5. **Everything iOS remains SOURCE-only.** Nothing in this part has been built, archived or run. All
   of BS-C-01/02/03/11 become ARTEFACT or DEVICE claims only after the first Mac build.
