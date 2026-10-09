# Completion program — Deliverable A: verified baseline

**Captured:** 2026-10-09, 12:00–12:10 UTC, by the Opus control-plane session ("Level Up app store submission readiness").
**Method:** I re-ran every time-sensitive fact from the discovery report (`.ai/audits/current/PRE_EXECUTION_DISCOVERY.md`, 2026-10-08/09). Each row gives its evidence level (SOURCE / CONTRACT / BUILD / ARTEFACT / LIVE-PROBE / CI / DEVICE), and no level is rounded up.

## 1. Repository

| Fact | Value | Evidence |
| --- | --- | --- |
| Working directory | `F:\level\level_up\level_up_app` (the brief's `F:\level\level\level_up_app` does not exist; same repo) | SOURCE |
| Branch / HEAD | `merged` @ `8e641e92eefd` | `git rev-parse` |
| Upstream | `origin/merged` = `c87b90a`; `merged` is **1 ahead / 0 behind** (the ahead commit `8e641e9` is docs-only) | `git rev-list --left-right --count` |
| `main` | strict ancestor of `merged`, 32 commits behind (`--ff-only` promotion possible, on the owner's word only) | `git merge-base --is-ancestor` |
| `dev` | fully contained in `merged` (73 behind, 0 ahead); frozen | `git rev-list` |
| Tracked changes | Only the 5 `contract/*` files of the uncommitted 3.38 re-vendor (+1,498 / −217). The 4 vendored files are **blob-identical to upstream `65245be`** (3.38.0-m1). | `git hash-object` vs `git rev-parse 65245be:<file>` |
| Untracked | `PRE_EXECUTION_DISCOVERY.md`, `level_up_master_completion_roadmap.{html,json}` (stale, pinned `0df5cf4`), plus this `completion/` folder | `git status --short` |
| Diff fingerprint at start | `git diff \| sha256sum` = `abd1e1b1…b424e`; `git status --porcelain \| sha256sum` = `c59eb48b…3bb` | |
| Historical waves 20–22 | committed and pushed (`fa88b3a`, `af0eadb`, `a988a1f`); `wave_state.md` still says 20/21 are uncommitted (stale) | `git merge-base --is-ancestor` |
| Backup | `backup/2026-08-22-dirty-tree` = `e4006e7` (only Git copy of `tell_claude.md`), preserved | `git rev-parse` |
| Idle worktrees | `jovial-bhaskara-018e57` (`M tool/validate.sh`) and `angry-antonelli-cf9094` (`M .githooks/pre-commit`, `M tool/validate.sh`) hold the uncommitted `xargs -s 7000` patch; **not deleted** | `git -C <wt> status` |
| Peer sessions | 1, "Level Up discovery and audit", **idle** | `ListAgents` |

## 2. Contract

| Fact | Value | Evidence |
| --- | --- | --- |
| Committed pin | `0df5cf4` (3.28.0-m1) | `contract/SOURCE.md` at HEAD |
| Working-tree copy | `65245be` (3.38.0-m1), uncommitted | blob identity above |
| **Upstream HEAD** | **`eddb6aca993f` (3.46.0-m1)**, mirrored 2026-10-08T14:56:03Z from `level-up-backend@a158daa`. **Unchanged** since the discovery, and **equal to the owner's selected target** | `git ls-remote` at 2026-10-09T12:00:45Z |
| Census @ `eddb6ac` | 86 operations · 86 stable · 0 draft · 4 web-only (`listTerms`, `redeemSubscriptionCode`, `requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`) → **82 app-buildable** · 19 public | CONTRACT, PyYAML (`scratchpad/census.py`) |
| Census @ `65245be` | 77 · 53 stable · 24 draft · 4 web-only → 49 app-buildable · 18 public | CONTRACT |
| 3.38 → 3.46 | +9 operations (none removed); 24 draft→stable flips; 33 newly app-buildable | CONTRACT |
| Line endings | Upstream blobs are LF (0 CR bytes in `openapi.yaml@eddb6ac`); `contract/SOURCE.md` claims CRLF, which is false. That sentence is fixed in CW01. | CONTRACT |
| `servers:` @ `eddb6ac` | staging only: `https://level-up-backend-staging.up.railway.app/api/v1` | CONTRACT |
| Push token op | `registerFcmToken` = `PUT /me/fcm-token`, stable, no `x-consumers` key (= mobile) | CONTRACT |

## 3. Backend and hosts

| Fact | Value | Evidence |
| --- | --- | --- |
| Staging identity | `GET /health/version` → 200 `{"commit":"a158daa3…","environment":"Staging","builtAtUtc":"2026-10-08T15:16:14Z"}`. Staging serves the backend commit that `eddb6ac` mirrors | LIVE-PROBE, unauthenticated, 2026-10-09T12:00Z |
| Staging base URL in app | `https://level-up-backend-staging.up.railway.app/api/v1` | `lib/core/config/app_config.dart:44` |
| Production base URL in app | `https://TBD.example/api/v1` (fail-closed placeholder) | `app_config.dart:54` |
| Planned prod host | `api.level-upworld.com` is a **plan only**: DNS does not resolve (curl exit 6) | LIVE-PROBE 2026-10-09T12:00Z |
| Legal links in app | `https://levelup.example/legal/{user-agreement,privacy,cookies}` (placeholders) | `login_screen.dart:46-48` |

## 4. Identity and platforms

| Fact | Value | Evidence |
| --- | --- | --- |
| Android prod / staging | `com.levelupworld.app` / `com.levelupworld.app.stg`; labels "Level Up" / "Level Up STG"; guard `test/guards/android_identity_test.dart` | `android/app/build.gradle.kts:55,69-77` (SOURCE); applied and APK-verified on 2026-10-06 (env Wave 1) |
| Android SDKs | compileSdk 36 · minSdk 24 · targetSdk 36 | `build.gradle.kts:39,56-57` |
| Android signing | **no `android/key.properties`, no keystore**, so release builds are unsigned by design (AND-02 open) | SOURCE |
| On-disk AAB | `build/app/outputs/bundle/release/app-release.aab` (2026-10-04) carries **`com.levelup.level_up_app`**, the dropped id. **Never upload it.** No flavored AAB exists. | ARTEFACT (manifest bytes read 2026-10-09) |
| iOS bundle ids | **template** `com.levelup.levelUpApp` (+ `.RunnerTests`), so the ratified `com.levelupworld.app` / `.stg` are **not applied** | `project.pbxproj:371,550,572` / `:387,404,419` |
| iOS minimum | **13.0** (ratified 15.0 not applied) | `project.pbxproj:349,475,526`; `AppFrameworkInfo.plist:23-24` |
| iOS configs/schemes | Debug/Release/Profile, one `Runner` scheme, no flavors, no `DEVELOPMENT_TEAM`, no entitlements, no `Podfile`, no `PrivacyInfo.xcprivacy`; display name "Level Up App" | SOURCE |
| Apple tooling | none: this machine is Windows 11, with no macOS or Xcode. iOS has **never** been built. | SOURCE |

## 5. Firebase / push

No `google-services.json`, `GoogleService-Info.plist`, `firebase_options*.dart` or `firebase.json` anywhere. No Firebase, messaging, local-notification or SignalR dependency in `pubspec.yaml`. No `POST_NOTIFICATIONS` permission, no google-services Gradle plugin and no token-registration code. The only notification UI is the inert Settings toggles. (SOURCE, 2026-10-09.) The discovery report's statements all still hold.

## 6. Validation baseline (BUILD, this session)

Run on the main working tree at HEAD `8e641e9` **plus the uncommitted 3.38 contract files**, 2026-10-09T12:02–12:06Z. I used direct commands, **not** `validate.ps1`, so the tracked `test-results.md` was not rewritten.

| Gate | Command | Result |
| --- | --- | --- |
| Format (filesystem, so untracked files are included) | `dart format --set-exit-if-changed --output=none lib test tool` | 369 files, 0 changed, rc 0 |
| Analyze | `flutter analyze --no-pub` | No issues found, rc 0 |
| Full suite | `flutter test --no-pub` | **+2067: All tests passed** (0 failed) |
| Guards | `flutter test --no-pub test/guards` | **+122: All tests passed** |
| CI | `gh run list --branch merged` | latest run `c87b90a` success (2026-10-06); `8e641e9` not pushed |

These numbers are the floor for every completion wave.

## 7. Device

Physical Pixel 8: **not attached** at 2026-10-09T12:00:51Z (`adb devices -l` empty; adb at `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`, not on PATH). The discovery recorded it as intermittent. Every WALK re-checks. AVDs `Pixel_8` and `Medium_Phone_API_36.1` exist.

## 8. Differences from the discovery report

1. **Device:** the Fable appendix had it present on 2026-10-09; it is absent now.
2. **Blocking questions:** B-1, B-2 and B-3 are answered by the owner's 2026-10-09 brief:
   - pin target `eddb6ac`;
   - release 1 includes push, chat, the inbox and the Message tab;
   - deletion and banned handling are required;
   - Opus plans, Sonnet executes, Fable audits at checkpoints;
   - waves may be multi-screen or non-screen;
   - no commit without an owner request.

   The discovery verdict "NOT READY FOR WORKFLOW" is therefore resolved for planning. I-items remain.
3. **Brief's working-directory path:** `F:\level\level\level_up_app` is a typo for `F:\level\level_up\level_up_app`.
4. **Unchanged:** everything else re-checked (upstream HEAD, blob identity, staging commit, identities, Firebase absence, 2067/122 baseline) matches the report.

## 9. Contract re-vendor dry run at `eddb6ac` (BUILD; nothing committed, main tree untouched)

- **Setup:** a throwaway worktree at HEAD `8e641e9`, outside the repo (scratchpad). I copied the 4 contract files byte-for-byte with `git show eddb6ac:<file>`, and blob-checked each against `git rev-parse eddb6ac:<file>`. `SOURCE.md` was left at HEAD. Then `flutter pub get --offline`.
- **Results (2026-10-09T12:08–12:11Z):**

  | Gate | Result |
  | --- | --- |
  | Format | 369 files, 0 changed |
  | Analyze | No issues |
  | Contract-model guard | **14/14** |
  | Full suite | **+2067: All tests passed** |
  | Guards | **+122** |
  | Drift | `git status` shows only the 4 contract files; no codegen, l10n or model drift |

- **Meaning:** moving the vendored contract from 3.38 to 3.46 breaks no compile-time binding, model or guard in the app as it stands. That is expected, because the app consumes 26 operations and only `verifyOtp` (+`403 account_banned`, a *behavioural* change from 3.42) and registration (+optional `inviteCode`) changed.
- **Not covered by this result:** behavioural changes. `account_banned` handling is a CW02 item. Note also that the guard binds only 7 of the 34 response schemas that carry `required`; widening those bindings is CW01 scope.
- **Cleanup:** the throwaway worktree was removed after the run.
