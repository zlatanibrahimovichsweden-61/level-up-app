# Store Readiness Register — Google Play & Apple App Store

**Created:** 2026-08-23 (initial full audit — Fable, Cowork session)
**Status:** LIVING DOCUMENT. Update on every store-relevant change.

> **Superseded on facts by `docs/STORE_READINESS_AUDIT_2026-09-05.md`.** That is a dated
> release/artefact audit: it built the release APK **and the project's first AAB**,
> unzipped both, ran the release build **on an emulator** (no physical device was
> available, and the artefact had to be re-signed with a throwaway key to install at all —
> so nothing there is a DEVICE-level claim), and re-verified the rows below. This
> file remains the authority on *policy* (Google/Apple rules, the data map, the
> pre-submission checklist); the audit is the authority on *what is actually true of the
> build*. Rows corrected on 2026-09-05 are marked **[2026-09-05]**. Verdict there:
> **NOT READY** — no production backend URL, no signing key, no store identity. Backend answers to the `UNKNOWN (backend)` rows (reviewer access, retention, hosting, Firebase, legal URLs; Seif, 2026-10-09) are in `docs/BACKEND_HANDOFF.md` — planned items there are not live.

**Scope rule:** the API contract is NOT ready and is OUT OF SCOPE — nothing here edits
`contract/`. Contract-dependent items are marked **BLOCKED BY CONTRACT**.
**Evidence tags:** `[GOOGLE]` official Google policy · `[APPLE]` official Apple policy ·
`[REPO]` repository evidence (path:line) · `[INFERENCE]` engineering inference ·
`[UNKNOWN]` cannot be established from this repo.
**Verification levels** (per WAVE_STATUS.md): SOURCE → BUILD → ARTEFACT → DEVICE → CI.

Policy research was performed 2026-08-23 against official sources (URLs in §16).
Policies drift; re-verify before submission.

---

## 1. Scorecard (2026-08-23)

| Area | Status | Blocking? |
| --- | --- | --- |
| Android target API (36) | 🟢 PASS (ARTEFACT VERIFIED) | — |
| Account deletion (both stores) | 🔴 FAIL — no UI, route or repository method; the contract has both endpoints since adr-114 (stable) **[2026-09-29]** | YES — submission blocker |
| Privacy policy (both stores) | 🔴 FAIL — placeholder URLs, stub screens | YES — submission blocker |
| iOS privacy manifest | 🔴 FAIL — no PrivacyInfo.xcprivacy | YES — upload blocker |
| iOS buildability (Podfile/Xcode 26) | 🔴 FAIL — never built | YES |
| Reviewer access (OTP bypass) | 🔴 FAIL — no mechanism | YES |
| Play AAB + Play App Signing | 🟡 PARTIAL — CI builds APK only | YES at submission |
| Data Safety form / App Privacy label | 🟡 READY TO DRAFT — inventory complete (§5), backend retention UNKNOWN | YES at submission |
| Prod base URL | 🔴 placeholder `TBD.example` | BLOCKED BY CONTRACT |
| Permissions posture | 🟢 EXCELLENT — INTERNET only, no iOS keys needed | — |
| Third-party data egress | 🟢 ZERO — no analytics/ads/crash SDKs | — |
| Secure transmission / storage | 🟢 HTTPS-only, Keychain/Keystore, backups disabled | — |
| Logging of personal data | 🟢 NONE (guard: `avoid_print` + CI analyze) | — |
| Logout | 🟡 works, but disk image cache survives (§6) | — |
| Children/audience declarations | 🟡 PRODUCT DECISIONS OPEN (§12/§14) | YES at submission |
| Release config safety **[2026-09-05]** | 🟡 fail-closed signing ARTEFACT-confirmed; documented release command shipped staging — fixed + guarded; prod APK/AAB proven free of staging and mock strings; staging/prod still indistinguishable on screen; still no mock-build guard | — |
| Export compliance (iOS) | 🟡 `ITSAppUsesNonExemptEncryption` not set | trivial fix |
| Crash visibility | 🟡 none — deliberate zero-SDK posture, but first release flies blind | decision |

---

## 2. Google Play status

| Requirement | Status | Evidence | Action |
| --- | --- | --- | --- |
| Target API 36 by 2026-08-31 (new apps/updates) [GOOGLE answer/11926878] | **PASS** | targetSdk=36, minSdk=24 — ARTEFACT VERIFIED in `build/app/intermediates/merged_manifests/release/.../AndroidManifest.xml:9` (Flutter 3.44.7 defaults) [REPO] | Keep Flutter pinned ≥ current |
| AAB required; Play App Signing [GOOGLE] | **PARTIAL** **[2026-09-05]** | CI still builds APK only (`.github/workflows/ci.yml:377`), but the AAB is no longer unproven: `flutter build appbundle --release -t lib/main_prod.dart` was run on 2026-09-05 and produced a valid 58.6 MB bundle (single `base` module, 3 ABIs, `INTERNET` in the protobuf manifest, no staging/mock strings) [REPO, ARTEFACT] | Wire `appbundle` into CI; enroll Play App Signing at console setup |
| Account deletion: in-app path + public web deletion URL (deadline passed 2024-05-31; phone-OTP accounts explicitly count) [GOOGLE answer/13327111] | **FAIL** | The contract now has both halves: `POST /me/deletion-request` and `DELETE /me/deletion-request`, `x-stability: stable`, adr-114, 30-day grace window (`contract/openapi.yaml:1054-1130`) [REPO] **[2026-09-29]**. Still no UI row, no route, no repository method; no design or copy exists on the Figma page (API→UI Wave 21, 2026-09-29). Earlier (2026-09-05): no contract endpoint at all, filed as S38 | Needs a design and the adr-114 D3 confirm copy, then: request + confirm, the pending-deletion cancel screen, and the `403 account_pending_deletion` route |
| Data Safety form accurate + deletion questions [GOOGLE answer/10787469] | **PARTIAL** | Data inventory complete (§5); backend retention/deletion UNKNOWN | Draft form from §5; resolve UNKNOWNs with backend |
| Privacy policy: live non-PDF URL in Console AND link/text in-app [GOOGLE answer/10144311] | **FAIL** | `.example` placeholders `login_screen.dart:41-44`; in-app screens render "not published" `legal_document_screen.dart:28-56`; `/legal/*` routes auth-gated `app_router.dart:44-48,70` [REPO] | BLOCKED BY EXTERNAL ASSET (legal). Un-gate routes now |
| User Data: HTTPS, secure handling, no unexpected collection [GOOGLE] | **PASS** | HTTPS-only (`app_config.dart:44`), no cert overrides, no cleartext, Keychain/Keystore tokens, backups fully excluded (`data_extraction_rules.xml`) [REPO] | — |
| Permissions: restricted/sensitive | **PASS / N-A** | Merged release manifest: INTERNET + ACCESS_NETWORK_STATE (plugin-merged) only. No camera/photo/location/contacts/SMS/exact-alarm/FGS/QUERY_ALL_PACKAGES [REPO] | Avatar upload later: use Photo Picker, NOT READ_MEDIA_IMAGES (enforced since 2025-05-28) |
| Advertising ID / AD_ID | **PASS (verify at build)** | No ads/analytics SDKs; AD_ID absent from merged manifest [REPO] | Declare "no ad ID" in Console; re-verify merged manifest before each release |
| Target audience & children [GOOGLE answer/9867159] | **UNKNOWN / NEEDS HUMAN INPUT** | Audience includes 13–17 minors (pervasive `[REPO]`, e.g. `date_of_birth_field.dart:16-18` — no client age floor, server owns rule). 13–15/16–17 "may be considered children in some locales". No under-13 target | §14 product decisions: declared age groups, under-13 stance, store-listing art must not appeal to under-13s |
| App access (reviewer credentials, OTP bypass, English) [GOOGLE answer/15748846] | **FAIL** | Phone-OTP is the only auth; no demo/bypass account exists; staging enforces real OTP [REPO] | BLOCKED BY CONTRACT/backend: permanent review account + static OTP |
| Store listing assets (icon 512, feature graphic, ≥2 screenshots, descriptions, content rating) | **FAIL (not started)** | Default Flutter launcher icons; Android label `level_up_app` (`AndroidManifest.xml:27`) [REPO] | BLOCKED BY EXTERNAL ASSET; fix `android:label` now |
| Pre-launch report hygiene (cleartext, deobfuscation) | **PARTIAL** | No cleartext ✅; R8 off, no mapping file (`build.gradle.kts:63-71`) [REPO] | Decide R8/obfuscation (§9) |
| New-account testing gate (12 testers × 14 days for personal accounts created after 2023-11-13) [GOOGLE answer/14151465] | **UNKNOWN** | Play Console account age/type unknown | §14 — tell us which account will publish; may add ≥2 weeks |
| Developer verification (device install-blocking, first wave 2026-09-30) [GOOGLE] | **UNKNOWN** | Account verification state unknown | Verify account (D-U-N-S if org) |
| Sign-in policy | **PASS** | No Play rule requires third-party login; phone-OTP-only is acceptable [GOOGLE] | — |

## 3. Apple App Store status

| Requirement | Status | Evidence | Action |
| --- | --- | --- | --- |
| Built with Xcode 26 / iOS 26 SDK (since 2026-04-28) [APPLE upcoming-requirements] | **FAIL** | iOS never built: no Podfile/Pods anywhere under `ios/` [REPO] | Stand up macOS/Xcode 26 build; CI later |
| Privacy manifest + required-reason APIs (since 2024-05-01); Flutter, connectivity_plus, device_info_plus, shared_preferences on Apple's named SDK list [APPLE] | **FAIL** | No `PrivacyInfo.xcprivacy` anywhere under `ios/` [REPO] | Update plugins (current majors ship manifests); add app-level manifest; check Xcode aggregated privacy report at archive |
| App Privacy nutrition label | **PARTIAL** | Inventory ready (§5): Contact Info, Identifiers, User Content — linked to identity, no tracking | Draft from §5 |
| 5.1.1(v) account deletion in-app (since 2022-06-30; deactivation insufficient) [APPLE] | **FAIL** | Same evidence as Play row [REPO] | §6 |
| 4.8 Login Services | **PASS / N-A** | Own phone-OTP system = "your company's own account setup and sign-in systems" exemption; no third-party login present [APPLE + REPO] | If Google/Facebook login is ever added, Sign in with Apple becomes mandatory |
| ATT / 5.1.2 | **PASS / N-A** | Zero tracking SDKs [REPO] | Answer "no tracking" everywhere; do not add NSUserTrackingUsageDescription |
| Purpose strings | **PASS / N-A** | No protected-resource APIs used; Info.plist correctly has zero NS*UsageDescription keys [REPO] | Future avatar upload: PHPicker (no permission) preferred |
| 2.1 reviewer demo account | **FAIL** | Same OTP-bypass gap as Play [REPO] | Same fix; note in App Review Information |
| Export compliance | **PARTIAL** | `ITSAppUsesNonExemptEncryption` absent from `Info.plist` [REPO]; HTTPS-only qualifies as exempt [APPLE] | Add key =false — can be done NOW |
| New age ratings (13+/16+/18+, questionnaire mandatory since 2026-01-31) [APPLE] | **PENDING** | First submission will answer it; expect 13+ | §14 confirm minimum age |
| Kids Category | **N-A** | 13+ audience; do NOT opt in; avoid "for kids" metadata (2.3.8) | — |
| Texas SB 2420 / Declared Age Range APIs (enforcement 2026-06-04; Utah/Louisiana analogues) [APPLE] | **UNKNOWN / LIKELY N-A** | Egypt-focused product ([INFERENCE] from governorates/+20); if App Store territories exclude US states, no obligation | §14 territory decision |
| 2.1/2.3 completeness & metadata | **FAIL today** | Stub screens ship: Customer Support disabled shell (`customer_support_screen.dart:9-11`), legal stubs, Refer-a-Friend shell, permanently disabled "Upload photo" row (`avatar_sheets.dart:126-148`) [REPO] | Hide or finish shells before submission — reviewers reject visible dead ends |
| Support URL + Privacy Policy URL in App Store Connect | **FAIL** | No support channel exists in-app or in repo [REPO] | BLOCKED BY EXTERNAL ASSET |
| 4.2 minimum functionality | **PASS (expected)** | Native quiz/catalog/leaderboard app, 36k lines [REPO] | Ensure real content depth at review time |
| iPad / orientations | **PARTIAL** | All four iPhone orientations enabled (`Info.plist:31-36`) but custom headers never tested landscape; iPad compat-mode untested [REPO] | Lock portrait (product decision) or test landscape |

## 4. Privacy & Data Safety detail — see §5 data map

Both declarations derive from §5. Key declaration facts: no tracking, no ads, no
third-party sharing, all traffic to first-party API over HTTPS, tokens in
Keychain/Keystore, backups disabled. UNKNOWN (backend): retention periods,
deletion semantics, server-side logging, hosting subprocessors (Railway staging
today — prod host unknown).

## 5. Data-flow inventory

All server data flows through `https://level-up-backend-staging.up.railway.app/api/v1`
(staging; prod UNKNOWN). No third-party SDK receives anything. Nothing is logged
client-side (zero logging in lib/ — CI-enforced `avoid_print`).

| Data | Source | Stored on device | Leaves device | Endpoint | Play category | Apple category | Deletion behavior |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Phone number (student) | login | in-memory only | YES | /auth/otp/* | Personal info: Phone | Contact Info | UNKNOWN (no deletion endpoint) |
| Parent/guardian phone | registration (mandatory) | draft in memory | YES | /auth/register | Personal info: Phone | Contact Info | UNKNOWN; not even readable back (`GET /me` omits it — S20) |
| Full name | registration | memory | YES | /auth/register, PATCH /me | Personal info: Name | Contact Info | editable; deletion UNKNOWN |
| Date of birth (minors) | registration (mandatory) | memory | YES | /auth/register | Personal info | Sensitive-adjacent | immutable in-app; UNKNOWN |
| Email (optional) | edit profile only | memory | YES | PATCH /me | Personal info: Email | Contact Info | user-clearable (JSON null) ✅ |
| School / governorate / city / stage / university / faculty / year | registration | memory | YES | /auth/register | Personal info | Other User Data | immutable in-app |
| Device ID (app-generated random 128-bit, NOT hardware ID) | `secure_storage.dart:72-83` | secure storage, survives logout | YES | otp/verify, register | Device or other IDs | Identifiers | survives logout by design; cleared only by unused `clear()` |
| Device model + platform | device_info_plus (`device_info_provider.dart:19-26`) | no | YES | same | Device or other IDs | Identifiers | — |
| Auth/refresh tokens | server | flutter_secure_storage (Keychain `first_unlock_this_device`, non-sync) | YES (headers) | all | not user data per se | — | cleared on logout ✅ |
| Theme + locale | user | shared_preferences | no | — | none | — | survives logout (deliberate, non-PII) |
| Avatar images (minor's likeness) + question images | server | **cached_network_image disk cache — SURVIVES LOGOUT** (no `emptyCache()` call in lib/) | fetch only | GET /me → avatar.url | Photos (cached) | User Content | ❌ not cleared — gap, see §6 |
| Quiz answers / scores / leaderboard rank | user activity | memory | YES | /quizzes/*, /leaderboard | App activity | Usage Data | UNKNOWN |
| Privacy toggles (`leaderboardVisible`, `scoreHidden`) | settings | server-side | YES | PATCH /me | — | — | ✅ user-controllable |
| IP address / server logs | implicit | — | YES | all | UNKNOWN | UNKNOWN | UNKNOWN — ask backend |

Not collected anywhere: location, contacts, photos (upload disabled), microphone,
biometrics, advertising ID, clipboard, SMS-read (OTP is typed manually via pinput).

## 6. Account creation / login / logout / deletion

- **Creation/login:** phone+OTP only (`auth_repository.dart:29,52`); registration is
  server-forked from verify. No password, no email login (adr-019).
- **Logout:** ✅ exists (`profile_screen.dart:283-289` → `auth_controller.dart:76-85`):
  best-effort `POST /auth/logout`, clears both tokens, resets 11 session providers,
  router bounces to /login. Gaps: **image disk cache survives** (minor's avatar on a
  shared device — HIGH, fixable now); `device_id` survives (deliberate, documented).
- **Deletion:** ❌ **DOES NOT EXIST** — no UI, no method, no route, no contract
  endpoint, and it has never been filed in `docs/seif_fight.md`. `SecureStorage.clear()`
  exists for exactly this (`secure_storage.dart:61-64`) and has zero call sites.
  Required by BOTH stores (Play answer/13327111 incl. web URL; Apple 5.1.1(v)).
  **What can be built now:** UI entry point, confirmation flow, local-wipe
  choreography (tokens + prefs + image cache + full secure-storage clear + session
  reset), route, copy in both ARB files. **BLOCKED BY CONTRACT:** the actual
  `DELETE /me` (or equivalent) call. **BLOCKED BY EXTERNAL ASSET:** the web
  deletion-request URL Play requires.
- **[2026-09-29] The contract side is done.** `POST /me/deletion-request` (request, 30-day grace
  window) and `DELETE /me/deletion-request` (cancel) are `x-stability: stable` (adr-114,
  `contract/openapi.yaml:1054-1130`). What is left is the app's: a design and the adr-114 D3 confirm
  copy (none on the Figma page, API→UI Wave 21), then the request flow, the pending-deletion cancel
  screen and the `403 account_pending_deletion` route, plus the local wipe above.

## 7. Permissions

Android release manifest (ARTEFACT VERIFIED): `INTERNET`, `ACCESS_NETWORK_STATE`
(merged by connectivity_plus). iOS: zero usage-description keys, correctly, since no
protected resource is touched. No runtime permission requests exist in Dart. This is
the strongest compliance area — keep it: any future permission must arrive with its
purpose string / Play declaration in the same commit (add to review checklist).

## 8. Reviewer-access status

Both stores will log in as a fresh user. Today a reviewer: launches ✅ → login
requires a real Egyptian phone receiving a real OTP from staging ❌ dead end.
Needs (BLOCKED BY CONTRACT/backend): permanent review account, fixed phone, static
OTP, valid for the entire review window, documented in both consoles. The catalog is
**not** entitlement-gated (adr-091, `openapi.yaml:785` — "browse-only … NOT
entitlement-gated"), so what the account actually needs is **seeded subjects** for the
reviewer's cohort — (education system, stage) for School, (university, faculty, year)
for University — so the catalog and quiz content are reachable at all; a
pre-provisioned entitlement only governs the quiz weekly-question-limit /
`flashcard_subscription` checks, not catalog visibility. Also: reviewers will tap
Customer Support (disabled shell), Privacy & Policy ("not published"), Refer a
Friend (shell), Upload photo (disabled) — each is rejection bait under
Apple 2.1/Play broken-functionality policy.

## 9. Release configuration status

- Signing: fail-closed (`build.gradle.kts:19-25,63-71`), keystore gitignored ✅.
  **[2026-09-05]** Confirmed at ARTEFACT level, not just read: with no `key.properties`
  present, `apksigner verify` on the built release APK returns `DOES NOT VERIFY` /
  `Missing META-INF/MANIFEST.MF`. It really does fail closed — it does not quietly fall
  back to the public debug keystore. A keystore must be provisioned before any upload.
- **[2026-09-05] Release-entrypoint defect — FOUND AND FIXED.** The release command in
  `docs/RELEASE_SIGNING.md:49` omitted `-t lib/main_prod.dart`. Since `lib/main.dart`
  forwards to `main_dev.dart`, following this repo's own signing doc produced a release
  APK carrying the **live staging hostname** — proven by building both artefacts and
  unzipping them. Fixed, and mechanised as a guard in `test/guards/workflow_test.dart`
  (proven able to fail). See the 2026-09-05 audit §4.3.
- CI: analyze+test+l10n+format gates; release APK compile gate on main with aapt2
  INTERNET proof (`ci.yml:377,387-414`) ✅. Gaps: builds APK not AAB; no artifact.
- Flavors: prod URL fails closed to `TBD.example` ✅ deliberate; but `AppConfig.isDev`
  is dead code — staging and prod builds are behaviorally identical (no banner/tag);
  and nothing prevents `flutter build --release -t lib/main_mock.dart` (convention
  only). Mock backend contains hardcoded OTPs `000000`/`111111` and a
  real-looking personal phone `mock_backend.dart:196` (scrub to placeholder).
- R8/obfuscation: OFF; no `--obfuscate`/`--split-debug-info`; no crash reporting →
  zero production diagnostics. Decision needed (§14): stay zero-SDK (privacy-ideal,
  blind) vs add crash reporting (changes BOTH store privacy declarations).
- Latent: freezed `toString()` interpolates raw tokens (`token_pair.freezed.dart:40`)
  — harmless while logging is zero; becomes a leak the day any error reporter is
  added. Override `toString` before ever adding one.

## 10. Security status

HTTPS-only, no cert overrides/trust-all, no cleartext, no network_security_config
(platform default = blocked cleartext, fine), tokens Keychain/Keystore, iOS Keychain
`first_unlock_this_device` + non-synchronizable, Android backup + device-transfer
fully excluded, single-flight token refresh, no secrets in repo, no WebView, no
deep links (no hijack surface), FLAG_SECURE on quiz screens. No pinning (acceptable;
[INFERENCE] not required by either store).

## 11. Metadata / legal requirements (external assets needed)

Privacy policy (live URL, non-PDF, names the store-listing entity, covers minors +
parentPhone + retention/deletion), Terms/User Agreement, Cookie policy (or drop the
link), account-deletion web URL, support URL/email, store descriptions (EN+AR),
icon 512px, feature graphic 1024×500, ≥2 screenshots per platform, iOS Support URL.
App display name decision ("Level Up App"? Android label currently `level_up_app`).

## 12. Future-risk items (architectural)

| Risk | Cost | Note |
| --- | --- | --- |
| Account deletion not designed in (no local-wipe orchestrator; `clear()` uncalled) | HIGH | design now (§6) |
| Legal/config URLs hardcoded in `login_screen.dart` (not centralized) | MEDIUM | move to a `LegalLinks`/AppConfig surface now |
| No environment indicator; staging≈prod | MEDIUM | gate a banner on `isDev` (it exists, unused) |
| Image cache not in session-scope wipe list | MEDIUM | add to logout + future deletion |
| No crash/symbolication path | MEDIUM | decision §14 |
| Under-13 registrants possible (no age floor, server "owns" rule that contract doesn't state) | HIGH | product/legal decision + seif_fight item |
| parentPhone collected but never displayable/correctable (S20) | MEDIUM | data-subject-rights problem; already filed |
| Push notifications planned (`PUT /me/fcm-token`, stable since at least 3.23.0-m1 **[2026-09-29]**; still no preference storage, S28) → will add Firebase, POST_NOTIFICATIONS, privacy-manifest changes, Data Safety changes | MEDIUM | plan declarations with the feature, not after |
| ~~Payments planned (`POST /checkout/sessions` draft)~~ **Historical — the path was removed at contract 2.2.0-m1 (adr-049 §3), not merely left draft.** The app is purchase-silent: no paywall, no price, no checkout of any kind; all purchases happen on the website (`x-consumers: [web]`). The Play Billing / Apple IAP digital-goods fork therefore does **not** apply to this mobile client. **Open question (not yet reviewed):** whether either store's external-purchase-link policy (Play external offers / Apple 3.1.1–3.1.3) has any bearing on an app that names a purchase-silent state with no in-app link at all — flag for a compliance read before submission. | LOW (was HIGH) | note only — there is no in-app purchase surface to route through Billing/IAP |
| No guard against building `main_mock.dart` in release | LOW | cheap CI/guard test |
| iOS landscape enabled, untested | LOW | lock portrait or test |

## 13. BLOCKED BY CONTRACT

~~Account-deletion endpoint~~ (stable since adr-114 **[2026-09-29]**); reviewer OTP-bypass account; prod base URL;
~~push-token endpoint (draft)~~ (stable; preferences still have no storage, S28); avatar upload (draft, moderated); backend retention/deletion/log
answers for both privacy forms; server-side age rule confirmation.

**Resolved by removal, not a contract dependency any more:** `checkout (draft)` — dropped from
this list because `POST /checkout/sessions` was deleted at contract 2.2.0-m1; the app is
purchase-silent (adr-049 §3), so there is no checkout surface left to block on.

## 14. BLOCKED BY PRODUCT DECISION (owner: Yousef)

1. Declared target-audience age groups (Play) & minimum age (Apple rating) — and the
   under-13 stance (hard floor? parental consent? server rule?).
2. Crash reporting: stay zero-SDK or add (privacy declarations change).
3. App display name + store listing identity (entity name must match privacy policy).
4. Distribution territories (Egypt-only? affects Texas/Utah obligations, French
   encryption declaration).
5. Publish account type (org vs personal — 12-tester/14-day gate; D-U-N-S).
6. Portrait-lock vs landscape support.
7. Ship v1 with stub screens hidden, or finish Support/Referral first.

## 15. Pre-submission checklist (living)

- [ ] Account deletion: UI + local wipe (NOW, needs a design) · endpoint ✅ (stable, adr-114) · web URL (ASSET)
- [ ] Privacy policy live URL wired in-app (un-gate `/legal/*`, replace `.example`)
- [ ] Terms live; cookie link resolved or removed
- [ ] Support channel real (URL/email) + shells hidden or finished
- [ ] Reviewer account + static OTP on prod backend; documented in both consoles
- [ ] Prod base URL real; verify no staging reference in release build
- [ ] `flutter build appbundle` path + Play App Signing enrolled
- [ ] iOS: build on Xcode 26; Podfile committed; PrivacyInfo.xcprivacy (app + plugin
      manifests verified via Xcode privacy report); `ITSAppUsesNonExemptEncryption=false`
- [ ] Data Safety form + App Privacy label filed from §5; backend UNKNOWNs resolved
- [ ] Target-audience + content-rating questionnaires (both stores)
- [ ] Logout clears image cache; deletion calls `SecureStorage.clear()`
- [ ] Scrub real phone from `mock_backend.dart`; guard against mock entrypoint release
- [ ] `android:label` + iOS display name final; icons/screenshots/descriptions EN+AR
- [ ] R8/obfuscation decision executed; if crash SDK added, redo both privacy forms
- [ ] Re-verify target API deadline & policy pages (they moved in 2026)

## 16. Policy sources (retrieved 2026-08-23)

Google: answer/11926878 (target API), 13327111 (account deletion), 10144311 (user
data/privacy policy), 10787469 (data safety), 16935362 (photo/video permissions),
15748846 (app access), 9867159 (target audience), 6048248 (AD_ID), 14151465
(testing requirements), 9842757 (pre-launch), developer.android.com/guide/app-bundle.
Apple: developer.apple.com/news/upcoming-requirements (Xcode 26 SDK floor
2026-04-28; age ratings 2026-01-31), app-store/review/guidelines (2.1, 2.3, 4.2,
4.8, 5.1.1(i,v), 5.1.2), support/third-party-SDK-requirements (privacy manifests),
support/offering-account-deletion-in-your-app, app-store/app-privacy-details,
documentation/bundleresources (ITSAppUsesNonExemptEncryption), news re Texas SB 2420.
