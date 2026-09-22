# Part 01 — Dart frontend audit (subagent report, persisted verbatim) — HEAD bf967d6, 2026-09-21

Verification level for everything below: **SOURCE** (read at HEAD). Nothing was built, run on a device, or checked in CI during this pass. No repo file was edited.

## 0. Re-verification of the prior registers' headline claims

| Claim (2026-08-23 / 2026-09-05) | Status at HEAD | Evidence |
|---|---|---|
| Account deletion absent | **CHANGED (worse for the frontend):** still no UI/route/repo method, but the contract now ships `POST`/`DELETE /me/deletion-request` as `x-stability: stable`, so this is no longer "blocked by contract" — it is an unbuilt frontend feature | `contract/openapi.yaml:993-1046` (`x-stability: stable` at `:996`, `:1044`); zero `deletion-request` call sites in `lib/` (only a doc comment at `lib/core/network/exceptions.dart:101`); `SecureStorage.clear()` still has 0 callers |
| Legal URLs are placeholders | **STILL TRUE** | `lib/features/auth/screens/login_screen.dart:43-46` `'https://levelup.example/legal/...'`, launched at `:118` |
| Stub screens ship | **STILL TRUE** (Support, Refer, Friends, Legal ×2, Leaderboard tab, Message tab, `/track-select`, Notifications toggles, Upload photo, Go to Uni, Favorites, Progress) | see §D |
| Image cache survives logout | **STILL TRUE** | 5 `CachedNetworkImage` sites; no `evictFromCache`/`DefaultCacheManager`/`imageCache` anywhere in `lib/`; `session_scope.dart:58-100` never touches it |
| Mock backend hardcoded OTPs/phone | **STILL TRUE**, dev-only | `lib/dev/mock_backend.dart:839` `'000000'`, `:843` `'111111'`, `:196` `'+201021871999'`; imported only by `lib/main_mock.dart:30` |
| `AppConfig.isDev` dead | **STILL TRUE** | defined `app_config.dart:18,33`; zero reads outside that file |
| No environment banner | **STILL TRUE** | no `Banner(`/`kDebugMode` in `lib/` (grep) |
| Prod URL `TBD.example` | **STILL TRUE** | `lib/core/config/app_config.dart:54` `Flavor.prod => 'https://TBD.example/api/v1'` |

## 1. Findings

### A — Blockers

**FE-01 · A · both · Config · Production base URL is a reserved placeholder.**
`app_config.dart:54` resolves `Flavor.prod` to `https://TBD.example/api/v1`. A `-t lib/main_prod.dart` release build cannot make a single request; every screen after Onboarding renders the error/offline state. Reviewer sees a dead app. Owner: backend (host) + config.

**FE-02 · A · both · Legal · Privacy policy is unreachable in-app, in both auth states.**
Pre-login the only privacy link is the `.example` URL (`login_screen.dart:45`, opened via `launchUrl(..., LaunchMode.externalApplication)` at `:118` with no `canLaunchUrl`/try-catch). Post-login `/legal/privacy` and `/legal/terms` render `ShellBody` with `legalNotPublished` = EN "This document hasn't been published yet." / AR "لم يتم نشر هذا المستند بعد." (`legal_document_screen.dart:47-51`, `app_en.arb:611`, `app_ar.arb:275`). Both routes are **auth-gated**: `_authRoutes = {'/', '/login', '/otp'}` (`app_router.dart:49`) and `authRedirect` sends unauthenticated users to `/login` (`:74`). Play's User Data policy requires a privacy policy link inside the app; Apple 5.1.1(i) requires it in-app and in metadata. Owner: product/legal (copy + hosted URL), then frontend.

**FE-03 · A · both · Account · No account-deletion path, and the contract now supports it.**
No row on the Profile hub (`profile_screen.dart:154-172` lists ten rows; none is delete), no repository method, no route. The contract's `requestAccountDeletion` mandates confirm-screen copy the app must show *before* calling (`openapi.yaml:1011-1018`: subscription forfeited, phone blocked for 30 days, new account starts from zero). Play (account-deletion requirement) and Apple 5.1.1(v) both require an in-app path. Also missing: the Play-mandated web deletion URL (external). Owner: frontend (screen + copy + `SecureStorage.clear()` choreography), product (copy sign-off), console (web URL).

**FE-04 · A · both · Account · Pending-deletion state is a dead end.**
`StudentProfile.pendingDeletion` is parsed (`student_profile.dart:77,99-104`) but never rendered; `isAccountPendingDeletion` maps every 403 to `accountPendingDeletion` = "Your account is scheduled for deletion. Cancel the request to use Level Up again." (`app_en.arb:659`), with Retry withheld — and there is no cancel screen (`exceptions.dart:127-129`, ARB description `:661` "route to the cancel screen, which does not exist yet"). A student who requested deletion elsewhere is told to cancel with nothing to tap. Owner: frontend.

### B — High

**FE-05 · B · both · Lifecycle · Default entrypoint is dev; release-only breakage.**
`lib/main.dart:4-6` re-exports `main_dev.dart`; `Flavor.dev` and `staging` both resolve to the live staging host (`app_config.dart:51-53`). A flagless `flutter build apk|appbundle|ipa` ships staging. Mitigated only by a docs/tool scan guard (`test/guards/workflow_test.dart:234`), not by code. Owner: config/frontend.

**FE-06 · B · both · Privacy · `CachedNetworkImage` disk + memory cache survives logout and account switch.**
`invalidateSessionScope` (`session_scope.dart:58-100`) drops 12 providers but no image cache; sites: `home_header.dart:171`, `profile_header_card.dart:207`, `edit_profile_screen.dart:556`, `avatar_sheets.dart:396`, `mcq_renderer.dart:90` (question images — "the bank is the product"). On a shared handset the previous minor's avatar and cached question images remain on disk. `session_isolation_test.dart` proves provider isolation only. Owner: frontend.

**FE-07 · B · both · Privacy · Freezed `toString()` interpolates tokens and PII.**
`token_pair.freezed.dart:39-41` `'TokenPair(accessToken: $accessToken, ... refreshToken: $refreshToken ...)'`; `student_profile.freezed.dart` has 19 generated `toString`s (name, phone, DOB). No `print`/`Logger`/`LogInterceptor` exists in `lib/` today (grep clean), so there is no current sink — but any future crash reporter or `debugPrint` leaks them. `AppException.toString()` is safe (`exceptions.dart:15` code only). Owner: frontend (`@Freezed(toStringOverride: false)` or explicit overrides).

**FE-08 · B · both · Reviewer flow · Subscription-gated content with no in-app path and no reviewer account.**
Purchase-silence is correctly implemented (`limit_sheet.dart:91-96` no CTA; `profile_screen.dart:241-242` Subscription row absent; grep of `lib/` and both ARBs finds no price/EGP/Paymob/Fawry/Vodafone/InstaPay/website/upgrade copy). But the user-visible copy names the entitlement — `subscriptionRequiredBody` "This lesson needs an active subscription." (`app_en.arb:484`), `errorSubscriptionRequired` (`:495`), AR `:202,:207` — without saying where it is obtained. Apple 3.1.1/3.1.3 reviewers will ask how a user subscribes; Play will need the same in review notes. Needs App Review notes + an *entitled* demo account (phone-OTP only auth, `auth_repository.dart:29-47`). Owner: console/backend.

**FE-09 · B · Android · Store identity is the template.**
`AndroidManifest.xml:27` `android:label="level_up_app"`; `ios/Runner/Info.plist:16` `CFBundleName` `level_up_app` (display name "Level Up App" at `:8`); launcher icons untouched since scaffold commit `5e4a512` (`git log` on `mipmap-hdpi/ic_launcher.png` and `AppIcon.appiconset`). Play rejects stock Flutter icons as placeholder content; Apple 2.3.8/4.0. Owner: config/design.

### C — Medium

**FE-10 · C · both · UX · Two of five bottom-nav tabs are "Coming soon" placeholders.**
`/leaderboard` → `LeaderboardPlaceholderScreen`, `/message` → `MessagePlaceholderScreen` (`app_router.dart:168-171, 268-271`; `tab_placeholder.dart:30-33` renders `comingSoon` = "Coming soon" / "قريبًا"). The real `LeaderboardScreen` exists but is not imported by the router (0 references). Apple 2.1 (completeness) / Play "Minimum functionality" risk. Owner: frontend (D-008 audit then swap).

**FE-11 · C · both · UX · Three "Coming soon" cards on Home.** Daily Tasks, Continue Learning, Top Student (`home_screen.dart:92-131`, `coming_soon_section.dart`); "See All" is inert (`:37`). Combined with FE-10 the first-run impression is a partially built app. Owner: frontend/backend.

**FE-12 · C · both · UX · Stub screens reachable from Profile.** Refer a Friend (`/refer`, "Inviting friends isn't available yet." + disabled "Share invite"), Customer Support (`/support`, "Support isn't available yet." + disabled "Create Ticket"), disabled rows Favorites/Progress ("Not available yet"), Go to Uni dialog ("Switching tracks isn't available yet."), Upload photo ("Uploading your own photo isn't available yet.", `avatar_sheets.dart:137-138`), four disabled notification toggles ("Notification settings aren't available yet.", `settings_screen.dart:357-393`). Arabic equivalents at `app_ar.arb:223,233,245,267,270-275`. Owner: product (hide vs ship).

**FE-13 · C · both · UX · Registration collects a referral code it discards.** `signup_identity_screen.dart:46,86` collects `referralCodeOptional` "Referral Code (Optional)" (`app_en.arb:104`); `registration_draft.dart:17` "collected but NOT submitted". A visible field with no effect is a functional dead end a reviewer can trip. Owner: product/frontend.

**FE-14 · C · both · Errors · No global error handlers.** No `FlutterError.onError`, `PlatformDispatcher.instance.onError`, `runZonedGuarded`, or `ErrorWidget.builder` in `lib/` (grep). In release a build-phase throw renders a blank grey box; unawaited platform-channel futures (`quiz_screen.dart:70` `_protection.enable()`, `login_screen.dart:118` `launchUrl`) throw unhandled if the plugin/handler is missing. No crash reporting exists (no sentry/crashlytics in `pubspec.lock`), which is privacy-positive but leaves review crashes invisible. Owner: frontend.

**FE-15 · C · both · Minors · No age floor, no consent surface.** DOB picker allows today → 100 years back (`date_of_birth_field.dart:32-40`, initial 15 y). `parentPhone` is required on both tracks (`school_registration.dart:66`, `university_registration.dart:62`) but nothing explains why, and there is no terms/privacy acknowledgement anywhere in the wizard (grep of `lib/features/registration/` for legal/consent/agree: none). The only "By continuing, you agree to…" line is on Login (`app_en.arb:36`) pointing at `.example`. Play Families / Apple 5.1.4 (Kids) exposure depends on declared target audience — flag for the console declaration. Owner: product/legal.

**FE-16 · C · both · Accessibility · Text scaling not handled.** No `textScaler`/`TextScaler`/`MediaQuery.textScaleFactor` in `lib/` (grep); `docs/RESPONSIVE.md:3-4` "Nothing here has been applied" — confirmed 0/11. `docs/KNOWN_BUGS.md:104-106` BUG-002 OPEN, device-verified overflow at 1.3× in Arabic. Owner: frontend.

**FE-17 · C · both · Orientation · No lock anywhere.** No `SystemChrome.setPreferredOrientations` in Dart (grep); iOS `Info.plist:31-43` allows landscape on iPhone and all four on iPad; Android has no `screenOrientation`. Every screen is a portrait Figma frame with hand-rolled headers; iPad review runs landscape. Owner: frontend/config.

**FE-18 · C · both · Legal · Login hint is a real-looking number that is also the mock's test number.** `phoneHint` = `01021871999` in both ARBs (`app_en.arb:32`, `app_ar.arb:15`); `mock_backend.dart:196` uses `+201021871999`. If that number belongs to a person, the hint publishes it. Owner: product.

### D — Low

**FE-19 · D · both · Routing · `/track-select` placeholder has a developer-label title.** `app_router.dart:133-136` `_Placeholder('Track select')` (hardcoded English in the app bar). Unreachable at HEAD (no `context.go('/track-select')` in `lib/`), so cosmetic unless a deep link hits it. Owner: frontend.

**FE-20 · D · both · Routing · `/friends` routed with no entry point** (`friends_screen.dart:15-19`). Harmless; no deep-link scheme is configured (Android intent-filter is MAIN/LAUNCHER only, `AndroidManifest.xml:50-53`; no associated domains in `Info.plist`). Owner: n/a.

**FE-21 · D · iOS · Config · `ITSAppUsesNonExemptEncryption` absent** from `Info.plist` (count 0) — every TestFlight upload will prompt. Owner: config.

**FE-22 · D · both · Config · `AppConfig.isDev` is dead and staging/prod builds are visually identical.** No banner, no flavor in Settings. Owner: frontend.

**FE-23 · D · both · Localization · Two hardcoded literals are allowlisted** (flag emoji `login_screen.dart:296`, `_Placeholder` title). The guard (`project_rules_test.dart:91-141`) allowlists rather than bans; fine, but the `'Track select'` literal is English-only.

### E — External / console-owned (not frontend code)

- Reviewer demo account with an active entitlement and a deterministic OTP (phone-OTP is the only login path). Prior audit B-5 still open.
- Play Data Safety and Apple Privacy Nutrition Labels: data actually sent is phone, name, DOB, parent phone, geography, school/university, `device.deviceId` (client-generated 32-hex, `secure_storage.dart:72-83`), `device.model` (`device_info_provider.dart:23,27`), plus quiz answers and self-grades. No advertising ID, no hardware identifier, no location, no contacts.
- Hosted privacy policy + terms URLs; web account-deletion URL (Play).
- iOS has no Podfile/never been built (prior B-7; not re-verified here — out of Dart scope).

## 2. PASS with evidence

- **Token storage:** Keychain `first_unlock_this_device`, `synchronizable: false` (`secure_storage.dart:31-34`); Android flutter_secure_storage 10.x default encrypted backend; `allowBackup=false`, `fullBackupContent=false`, `dataExtractionRules` present (`AndroidManifest.xml:30-32`, `res/xml/data_extraction_rules.xml`).
- **Logout choreography:** best-effort `POST /auth/logout`, tokens cleared, 12 providers invalidated, router redirects (`auth_controller.dart:76-85`, `session_scope.dart`); `device_id` preserved on purpose (`:42-45`). Discipline guard: `session_scope_discipline_test.dart`.
- **Refresh:** single-flight, loop-safe, bare Dio for `/auth/refresh`, forced logout on `refresh_token_invalid`/`session_superseded`, offline never logs out (`auth_interceptor.dart:116-156`).
- **Entitlement is server-authoritative and refreshed on resume:** `AppLifecycleListener(onResume: refresh)` (`me_notifier.dart:58`); `GET /me` refresh is user-tapped only (`:22-29`); `retry: _noRetry` on all async providers (commit `bf967d6`).
- **Purchase-silent:** no paywall/CTA/price/link (`limit_sheet.dart:91-96`; ARB grep clean for EGP/Paymob/Fawry/Vodafone/InstaPay/website/اشتراك-with-price/كود/ادفع/شراء/سعر/جنيه).
- **Logging:** no `print`/`debugPrint`/`Logger`/`LogInterceptor`/`dart:developer` in `lib/`; parse errors carry only `runtimeType` (`auth_repository.dart:45`); server `title`/`detail` never rendered (`exceptions.dart:5-6`, `home_screen.dart:229-231`, `quiz_error_copy.dart:10-34` falls through to `genericError`).
- **Networking:** HTTPS only (only `http://` is the mock's `mock.local`, `mock_backend.dart:49`); no `badCertificateCallback`/`HttpClient` overrides; 15 s/20 s timeouts (`dio_client.dart:16-18`); offline via `connectivity_plus` stream (`core_providers.dart:55-60`).
- **Permissions:** no `permission_handler`, camera, image_picker, location, contacts, microphone, share, webview, firebase, or notification packages in `pubspec.lock` (direct deps listed: 20, none of those). No `Clipboard.*` usage. No FCM/notification permission code.
- **Screenshot protection:** quiz screens only, enabled in `initState`, disabled unconditionally in `dispose` (`quiz_screen.dart:63-79`); Android FLAG_SECURE, iOS secure-layer (`screen_protection.dart:30-37`).
- **Dev harness isolation:** `lib/dev/mock_backend.dart` is imported only by `lib/main_mock.dart` (and tests); a `-t lib/main_prod.dart` build tree-shakes it out. Guard: `workflow_test.dart:234` "every runnable release-build command targets lib/main_prod.dart".
- **Localization:** both ARBs present, parity guard-enforced (`project_rules_test.dart:278`); `Directionality` via locale delegates, `EdgeInsetsDirectional` throughout; light/dark themes student-selected (`app.dart:33-39`); status/nav bar chrome adapts (`app.dart:79-95`). 43 explicit `Semantics`/`semanticsLabel` sites incl. disabled-button hints (`shell_body.dart:89-94`).
- **UGC/moderation:** the only peer-visible UGC is `entry.name` on the leaderboard (`leaderboard_row.dart:89`, `podium.dart:154`), which is not routed at HEAD (FE-10); avatars are server catalogue only (upload disabled). No report/block UI exists — becomes relevant when FE-10 ships (Apple 1.2).
- **No test data / Lorem ipsum in shipping code:** grep of `lib/` (excluding `dev/`) finds only `emailHint` `you@example.com` and the `.example` URLs already listed.

## 3. Could not determine (SOURCE-only session)

- Whether the `.example` legal URLs and `TBD.example` host fail closed on device (DNS behaviour of reserved TLD; `launchUrl` exception path) — DEVICE.
- Whether iOS `preventScreenshotOn` behaves on current iOS/Flutter versions — DEVICE.
- Whether the stock launcher icons are byte-identical to the Flutter template (only "never modified since scaffold" is proven).
- Whether Android 15 edge-to-edge and predictive back regress any screen — DEVICE (prior W-14 still open).
- Play target-audience / Families declaration intent (drives FE-15 severity) — product decision, not in repo.
