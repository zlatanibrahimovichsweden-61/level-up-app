# Environment & Architecture chapter — state

**Chapter:** Identity / Flavors / Store-ready environment workflow · **Opened:** 2026-10-04
**Architecture record:** `docs/ENVIRONMENTS.md` · **Rubric:** `docs/STORE_READINESS_RUBRIC.md` ·
**Decision:** `docs/DECISIONS.md` D-021 (**ratified 2026-10-06**) · **Risk:** `docs/RISKS.md` R-9 (mitigating)
**Protocol per wave:** snapshot → read-only investigation → implementation → validation → post-wave
audit → focused commit → report (with rubric score, supported versions, backend sentence).

| Wave | Name | Status | Blocked by |
| --- | --- | --- | --- |
| 0 | Architecture & identity decision | **DONE 2026-10-04** — documentation only | — |
| 1 | Android environment architecture | **DONE 2026-10-06** — BUILD + ARTEFACT level; DEVICE not reached (no device attached) | — |
| 2 | Flutter environment contract | not started — **next** | Wave 1 ✅ |
| 3 | iOS environment architecture | not started | **a Mac with Xcode 26** (SOURCE-level authoring possible here, BUILD is not) |
| 4 | Cross-platform validation & release safety | not started | Waves 1–3 |

## Wave 0 record

- **Pre-wave snapshot:** branch `merged`, HEAD `03fd7cf`, dirty tree (20 modified + 4 untracked files
  belonging to the settings/elevation and wave-audit sessions), `git status --porcelain | sha1sum` =
  `7eff6bbde9b8cddd04a970c59da450ef90c93fc1`. Two Claude worktrees exist under `.claude/worktrees/`
  on `e71e9a1`; untouched.
- **Baseline validation (before any write):** `tool/validate.sh` with `LEVELUP_VALIDATE_OUT` redirected
  to the scratchpad → analyze PASS (0 issues), tests **2036 passed / 0 failed / 0 skipped**, format step
  **did not run** ("The command line is too long." — the known Git Bash / cmd.exe 8191-character limit
  on `dart format` with 320 files; `validate.sh` is not the Windows entry point). The canonical Windows
  run is `tool/validate.ps1`; its result is recorded in the Wave 0 report. The committed
  `test-results.md` was not touched.
- **Files added:** `docs/ENVIRONMENTS.md`, `docs/STORE_READINESS_RUBRIC.md`, this file. The input audit
  `.ai/audits/current/app_identity_environment_audit_2026-10-04.md` (written 2026-10-04 by the
  read-only investigation) is committed with the wave.
- **Files edited (append/insert only):** `docs/DECISIONS.md` (+D-021 proposed), `docs/RISKS.md` (+R-9),
  `docs/WAVE_STATUS.md` (+chapter pointer), `docs/PROJECT_GUIDE.md` (+index row).
- **No application code, Gradle, Xcode, Firebase or signing file was modified.** No secrets.
- **Commits:** `f4cd5a9` (chapter opened), `9d5a2ec` (DEVICE evidence for G-9).

## Inputs received for Wave 1

- **2026-10-04, DEVICE (Pixel 8, debug `main_mock` build of `f4cd5a9`, reported by the launcher-icon session):** the launcher label reads `level_up_app` in the app drawer, Recents and App info — DEVICE confirmation of audit gap G-9 (Android label hardcoded in `AndroidManifest.xml:27`, no `strings.xml`). **Closed by Wave 1** (per-flavor `resValue app_name`, ARTEFACT-confirmed labels "Level Up" / "Level Up STG").
- **Same report, SOURCE-confirmed here:** `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` has no `<monochrome>` layer, so Android 13+ themed icons fall back to a generic tile. Not an environment item — **deferred to the launcher-icon work**, recorded so it is not lost.
- **2026-10-06, the owner's D-021 answers:** Seif's written reply (`reply-2126-mostafa-final.md`, forwarded) — Q1 C with exact ids `com.levelupworld.app` / `com.levelupworld.app.stg`, Q2 two identities, Q3 "Level Up" / "Level Up STG", Q4 Android 24/36/36 + iOS rule, Q5 planned prod URL not live, Q6 backend mapping, Q7 backend positions — plus the owner's "Frontend decision — Q4 completion": `Flutter 3.44.7 · Android 24/36/36 · iOS 15.0`, with the request to verify the iOS dependency set against 15.0 (done: all floors ≤ 13.0, `ENVIRONMENTS.md` §3.2).

## Wave 1 record (2026-10-06)

- **Pre-wave snapshot:** branch `merged`, HEAD `9d5a2ec`, dirty tree = the same 20 modified + 7 untracked
  files of other sessions (`git status --porcelain | sha1sum` = `d7dd51b3018462827f5c483a9bc1779fcbcd30bd`);
  no `index.lock`; two Claude worktrees on `e71e9a1`, untouched. Peer session "Store readiness audit" was
  idle; it was sent the file list before any edit and did not request a hold.
- **Read-only investigation:** Gradle/manifest/scripts/CI/hook/guard sources; Flutter tool and Gradle
  plugin (`-Ptarget` is how the entrypoint reaches Gradle, default `lib/main.dart`); every tracked
  reference to the old ids and to release commands; iOS podspec floors re-read for the 15.0 question;
  Play listing URLs for all three ids (404).
- **Implementation (Android only; no Dart app code, no iOS file, no Firebase, no signing file touched):**
  `android/app/build.gradle.kts` — ratified `applicationId`, `flavorDimensions("env")`, flavors `prod` /
  `staging` (`.stg`, per-flavor `app_name`), SDK literals 24/36/36, Gradle flavor ⇄ entrypoint check;
  `AndroidManifest.xml` label → `@string/app_name`; `test/guards/workflow_test.dart` rule evolved to
  flavor/entry coherence (+ detector self-test, dated records skipped); `test/guards/android_identity_test.dart`
  new (9 tests); `tool/verify_guards.ps1` 8 → 11 probes; `tool/verify_release_manifest.ps1` prod flavor +
  package assertion; `.github/workflows/ci.yml` `--flavor prod` + package assertion; `.githooks/pre-push`
  trigger list + `android/ ios/ tool/ .github/ .githooks/`; docs: `ENVIRONMENTS.md` (rewritten for the
  ratified state), `DECISIONS.md` D-021 (ratified), `RISKS.md` R-9 (mitigating), `WAVE_STATUS.md`,
  `ENFORCEMENT.md`, `RELEASE_SIGNING.md`, `STORE_READINESS_RUBRIC.md` (re-score), `flutter_frontend_workflow.md`
  (one sentence).
- **One defect found and fixed inside the wave:** the coherence check was first anchored on
  `pre<Variant>Build`; the first `assembleProdRelease` failed because AGP's shared `buildCMakeRelease`
  task depends on `preStagingReleaseBuild`, so the staging rule judged a prod build. Re-anchored on
  Flutter's own `compileFlutterBuild<Variant>` task (in the graph only for the variant being built);
  confirmed with `gradlew --dry-run`. Recorded in the Gradle comment so it is not "simplified" back.
- **Validation:** see `env_wave1_report.md` — `validate.ps1` OVERALL PASS (2046 / 0 / 0); two release
  APKs + one debug APK built and `aapt2`-inspected; four invalid combinations refused at BUILD level;
  `verify_guards.ps1` result recorded in the report.
- **Post-wave audit:** diff confined to the announced files; secret scan over added lines clean (prose
  mentions of "keystore"/"secret" only); no `google-services.json`, plist, `.jks` or `key.properties`
  anywhere in the tree; other sessions' dirty files untouched and unstaged.
- **Not reached:** DEVICE level — no Android device was attached during the wave (`adb devices` empty).
  Installing both identities side by side on the Pixel 8 is queued for Wave 4 (or any session with the
  device: `flutter build apk --debug --flavor prod -t lib/main_prod.dart` and the staging debug APK
  already in `build/app/outputs/flutter-apk/app-staging-debug.apk`).
- **Commits:** two, recorded in the report — the D-021 ratification (DECISIONS.md alone) and the
  Android implementation with its docs.

## Open items carried to Wave 2

- Boot assertion: compiled `Flavor` ⇄ platform flavor (needs a value from Gradle — e.g. `buildConfigField`
  or `resValue "flavor"` — plus the iOS equivalent later).
- `.example`-in-prod → build-time failure; `main_mock` release refusal in Dart (cross-platform; Gradle
  already refuses it on Android); `isDev` indicator so dev and staging (same identity now) are told apart
  on screen; keep the planned production URL **out** of the code until the contract's `servers:` carries it.
  **Withdrawn from Wave 2 (2026-10-06):** the per-flavor website / `/redeem` URL slot — it contradicts the
  contract's purchase-silence rule (`contract-changelog.md:360`, adr-049 §3); `RISKS.md` R-10, owner + Seif
  decision, nothing built. Wave 3 input: `RISKS.md` R-11 (`device_info_plus` required-reason API; the
  archive's Privacy Report is the proof).
- Decide whether `lib/main.dart` stays (it is harmless under the flavor rule; see `ENVIRONMENTS.md` §4.3).
