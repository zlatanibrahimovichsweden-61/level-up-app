# Part 03 — Android project audit (subagent report, persisted verbatim) — HEAD bf967d6, 2026-09-21

Read-only. Verification levels: **SOURCE** (read), **ARTEFACT** (inspected a built output). Artefacts inspected: `build/app/outputs/flutter-apk/app-release.apk` (2026-09-21 20:07), `build/app/outputs/bundle/release/app-release.aab` (20:08); merged-manifest intermediates date from 2026-08-14 (manifest tasks up-to-date since).

Severity key: **A** upload/launch blocker · **B** must fix before launch · **C** should fix · **D** verify/advisory · **E** hygiene · **F** doc-only · **G** informational.

## 1. Findings

| ID | Sev | Area | Issue | Evidence | Remediation | Owner |
|---|---|---|---|---|---|---|
| AND-01 | A | Config | Prod flavor points at a reserved placeholder host, so every `-t lib/main_prod.dart` artefact (incl. today's APK/AAB) cannot reach any backend. | `lib/core/config/app_config.dart:54` `'https://TBD.example/api/v1'`; comment `:46-50` "Do NOT ship a prod build until this is replaced" | Get the prod `servers:` entry from Seif's contract; replace; add a guard that fails a release build while `.example` remains. | Seif (contract) / owner |
| AND-02 | A | Signing | No release keystore exists; today's release outputs are unsigned and Play will reject them. Fail-closed behaviour is correct and ARTEFACT-confirmed. | `android/key.properties` absent; `android/app/build.gradle.kts:19-25` (`hasReleaseKeystore`), `:52-61` (config created only if file exists), `:69` `signingConfigs.findByName("release")` → null; `:76-81` warning; `build/app/outputs/apk/release/output-metadata.json` → `"outputFile": "app-release-unsigned.apk"` | Follow `docs/RELEASE_SIGNING.md` §"One-time setup"; enrol Play App Signing (upload key only). | Owner |
| AND-03 | B | Store identity | Launcher icon is the stock Flutter icon at all five densities; no adaptive icon (`mipmap-anydpi-v26` absent), no monochrome layer for Android 13 themed icons. | md5 identical project vs `C:\flutter\packages\flutter_tools\templates\app\android.tmpl`: hdpi `13e9c72e…`, mdpi `62703444…`, xhdpi `a0a8db59…`, xxhdpi `afe1b655…`, xxxhdpi `57838d52…`; `android/app/src/main/res/` has only `mipmap-*dpi/ic_launcher.png`; artefact `application: icon='res/9w.png'` | Supply brand icon; generate adaptive (foreground/background/monochrome) + 512 px Play icon. | Designer / owner |
| AND-04 | B | Store identity | App name is the project slug, hardcoded and unlocalised (no `strings.xml`, no `values-ar`). Ships in the artefact for all 85 AndroidX locales. | `android/app/src/main/AndroidManifest.xml:27` `android:label="level_up_app"`; aapt2 badging `application-label:'level_up_app'` … `application-label-ar:'level_up_app'` | Decide product name (EN + AR); move label to `res/values/strings.xml` + `values-ar/strings.xml`. | Product / app |
| AND-05 | B | Review | The only external hand-off (url_launcher) opens placeholder legal URLs; a Play reviewer following Privacy Policy gets a dead `.example` link. | `lib/features/auth/screens/login_screen.dart:44-46` (`levelup.example/legal/…`), `:118` `launchUrl(... LaunchMode.externalApplication)` | Real hosted Privacy Policy/Terms URLs (same URL goes in the Console listing). | Product / legal |
| AND-06 | C | Docs vs artefact | Project docs say R8 is OFF and there is no mapping file. The artefact proves R8 **is on** (Flutter's Gradle plugin enables it unless `-Pshrink=false`), and the AAB carries the mapping. | Docs: `docs/STORE_READINESS.md:68` "R8 off, no mapping file", `:190` "R8/obfuscation: OFF"; `.ai/audits/current/known-issues.md:131` K-17. Truth: `FlutterPluginUtils.kt:209-216` (default `true`), `FlutterPlugin.kt:215-226` (`isMinifyEnabled = true`, `isShrinkResources`, `proguard-android-optimize.txt` + `flutter_proguard_rules.pro`); AAB `BUNDLE-METADATA/com.android.tools/r8.json` `"isShrinkingEnabled":true,"isObfuscationEnabled":true,…"version":"8.11.18"`; AAB `BUNDLE-METADATA/com.android.tools.build.obfuscation/proguard.map` (11,773,699 B); `build/app/outputs/mapping/release/mapping.txt` | Correct the documents; record that Play ingests the AAB-embedded map automatically; keep the Dart `--obfuscate` question (AND-12) separate. | Docs owner |
| AND-07 | C | CI | CI builds an APK only, never an AAB, uploads no artefact, injects no signing. Play requires an AAB. | `.github/workflows/ci.yml:377` `flutter build apk --release --no-pub -t lib/main_prod.dart`; `:310-316` "No artefact is uploaded"; `docs/RELEASE_SIGNING.md:93-102` | Add an `appbundle` job (secrets-injected keystore, `-t lib/main_prod.dart`), upload the AAB + `mapping` as artefacts. | DevOps |
| AND-08 | C | Enforcement | The permission proof only checks that INTERNET is *present*; nothing asserts the permission set is *exactly* the expected one, so a future plugin adding `AD_ID`, `READ_PHONE_STATE`, `POST_NOTIFICATIONS` etc. passes silently. `allowBackup`/`dataExtractionRules`/`taskAffinity`/`exported` are prose-only rules with no guard test. | `ci.yml:397` `grep -q 'android.permission.INTERNET'`; `tool/verify_release_manifest.ps1:93`; `test/guards/workflow_test.dart:109-145`; grep of `test/` for `allowBackup|data_extraction_rules|signingConfig` → no hits | Extend the aapt2 step to diff `aapt2 dump permissions` against an allow-list; add a guard test that parses the manifest + `data_extraction_rules.xml`. | App / DevOps |
| AND-09 | D | Android 16 | `android:enableOnBackInvokedCallback` is not declared. With targetSdk 36, Android 16 enables predictive back by default, so back behaviour differs between API 33–35 (legacy) and 36 (predictive). App uses `PopScope` only (3 sites, zero `WillPopScope`). SOURCE-level only. | `AndroidManifest.xml:33-54` (attribute absent); `grep WillPopScope lib/` → 0, `PopScope(` → 3 | Declare the attribute explicitly (`true`); DEVICE-verify back gesture through go_router on an API 36 device. | App |
| AND-10 | D | Android 15 | Edge-to-edge is enforced for targetSdk ≥ 35; app neither opts out nor sets `SystemUiMode`. Inset handling exists (`viewPaddingOf`, 26 files with `SafeArea`) but is not DEVICE-verified on API 35/36. | `lib/features/shell/main_shell.dart:54`; `grep SystemUiMode lib/` → 0; `res/values/styles.xml` has no `windowOptOutEdgeToEdgeEnforcement` | DEVICE walk on an Android 15/16 device (3-button + gesture nav), both themes. | App |
| AND-11 | D | Locale/RTL | `android:supportsRtl` absent (defaults false) and no `android:localeConfig` (Android 13 per-app language). Flutter renders RTL itself; only system surfaces (App Info, per-app language picker) do not reflect AR. | manifest `:26-32`; `lib/l10n/app_ar.arb`; `lib/app.dart:59` | Add `android:supportsRtl="true"` and `res/xml/locales_config.xml` (ar, en) if per-app language is wanted. | App |
| AND-12 | D | Hardening | Dart AOT is not obfuscated: no `--obfuscate --split-debug-info` on any release command. Not a Play requirement. | `ci.yml:377`; `tool/verify_release_manifest.ps1:60`; `docs/RELEASE_SIGNING.md:49`; `docs/STORE_READINESS.md:190-192` | Owner decision; if enabled, archive the `split-debug-info` symbols per release. | Owner |
| AND-13 | D | Screenshots | FLAG_SECURE is scoped to the quiz screen by design and cleared in `dispose`; any answer-bearing screen that is a separate route (Review/Result, Mistakes) inherits no protection. | `lib/features/quiz/screens/screen_protection.dart:17-18`, `:34-37`; `quiz_screen.dart:74-80`; plugin `ScreenProtectorPlugin.kt:27-30`; `.ai/audits/current/known-issues.md:132` K-18 | Confirm intended scope covers Review/Mistakes; if not, enable on those routes too. | Product / app |
| AND-14 | E | Gradle | Machine-specific workarounds committed: JVM-target validation downgraded to warning (JDK 21 vs target 17), Kotlin incremental off, `-Xmx8G`. | `android/gradle.properties:13`, `:20`, `:1`; `ci.yml:329`, `:344-348` | Install JDK 17 locally / `flutter config --jdk-dir`, then drop `:14-20`. | DevOps |
| AND-15 | E | Gradle | Template leftover: "Specify your own unique Application ID" TODO (ID is already settled). | `android/app/build.gradle.kts:42` | Delete the comment. | App |
| AND-16 | F | Docs | `RELEASE_SIGNING.md` generates a JKS keystore; modern `keytool` warns JKS is proprietary and recommends PKCS12. Play accepts both. | `docs/RELEASE_SIGNING.md:30-35` | Switch the doc to `-storetype PKCS12`. | Docs |
| AND-17 | G | Versioning | `versionCode` pipeline: `pubspec.yaml:19` `1.0.0+1` → `local.properties` → `FlutterExtension.kt:60-67` → `build.gradle.kts:48-49` → artefact `versionCode='1'`. Nothing bumps it. | as cited | Bump `+N` per upload (or `--build-number` in CI). | DevOps |
| AND-18 | G | Toolchain | AGP 8.11.1 / Gradle 8.14 / Kotlin 2.2.20 sit at Flutter 3.44.7's warn thresholds (no warnings) but one major behind the SDK template (AGP 9.0.1 / Gradle 9.1.0 / Kotlin 2.3.20). | `android/settings.gradle.kts:22-23`; `gradle-wrapper.properties:5`; `DependencyVersionChecker.kt:94-109`; `gradle_utils.dart:36-52` | Schedule after launch. | App |

## 2. PASS with evidence

- **INTERNET in `src/main`**: `AndroidManifest.xml:19`; ARTEFACT `aapt2 dump permissions` → `android.permission.INTERNET`. Debug/profile manifests add only INTERNET.
- **Exact permission set (ARTEFACT)**: `INTERNET`, `ACCESS_NETWORK_STATE` (connectivity_plus), `com.levelup.level_up_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (androidx.core 1.18.0, signature-level). No `AD_ID`, `POST_NOTIFICATIONS`, `FOREGROUND_SERVICE*`, `SCHEDULE_EXACT_ALARM`, `QUERY_ALL_PACKAGES`, media/storage, phone-state.
- **Backup / device-transfer fully disabled**: `AndroidManifest.xml:30-32`; `res/xml/data_extraction_rules.xml:19-25` cloud-backup and `:26-32` device-transfer each exclude `root, file, database, sharedpref, external`. Covers flutter_secure_storage prefs, shared_preferences DataStore file + legacy sharedpref, sqflite DB. Merged manifest carries the attributes.
- **No cleartext**: no `usesCleartextTraffic`, no `networkSecurityConfig`; base URLs HTTPS; `http://mock.local` only in `lib/dev/mock_backend.dart:49`.
- **Not debuggable**: aapt2 badging has no `application-debuggable`.
- **Exported components**: `MainActivity` exported with MAIN/LAUNCHER only; url_launcher `WebViewActivity` `exported="false"`; `InitializationProvider` `exported="false"`; `ProfileInstallReceiver` exported but `DUMP`-guarded (AndroidX standard). No services. No deep links / App Links / VIEW filters.
- **Task hijack mitigations**: `taskAffinity=""` `:37`, `launchMode="singleTop"` `:36`.
- **`<queries>`**: only `PROCESS_TEXT` (Flutter template). url_launcher_android 6.3.32 contributes **no** `<queries>`; the app never calls `canLaunchUrl`.
- **SDK levels (ARTEFACT)**: min 24 / target 36 / compile 36.
- **16 KB readiness (ARTEFACT)**: AGP 8.11.1 ≥ 8.5.1; `zipalign -c -P 16 -v 4` OK; ELF LOAD alignment 0x10000 / 0x4000 on all 12 `.so`; `extractNativeLibs="false"`; NDK 28.2.13676358.
- **R8 mapping + native symbols ship in the AAB** → the pre-launch "no deobfuscation file" warning is avoided.
- **ABIs**: arm64-v8a, armeabi-v7a, x86_64 (Flutter default); no app-level `abiFilters`/`splits`.
- **Orientation / large screens (Android 16)**: no `screenOrientation`/`resizeableActivity`; `configChanges` includes orientation set. Resizable and unlocked.
- **Native layer minimal**: `MainActivity.kt:1-5` bare `FlutterActivity`; no custom Application; no app-side platform channels.
- **Signing fail-closed** (SOURCE + ARTEFACT); keystore ignore rules `android/.gitignore:12-14`; `git ls-files android/` — 21 files, no secrets.
- **Release entrypoint guarded**: `test/guards/workflow_test.dart:147-273`; CI, `verify_release_manifest.ps1:60`, `RELEASE_SIGNING.md:49` comply.
- **CI hygiene**: Flutter pinned via `.flutter-version` and guarded; INTERNET proven with aapt2 (`ci.yml:387-414`); JDK 17 on the release job.
- **Data Safety inputs**: `deviceId` app-generated (`device_info_provider.dart:9-18`); only `androidInfo.model` read (`:26-27`). No `ANDROID_ID`/IMEI/serial.

## 3. Plugin-introduced manifest content (pub cache)

| Plugin (Android impl) | `<uses-permission>` | `<queries>` | Components | Native `.so` / notes |
|---|---|---|---|---|
| connectivity_plus 7.3.0 | `ACCESS_NETWORK_STATE` | — | — | none; androidx.core 1.18.0 |
| device_info_plus 13.2.0 | — | — | — | none |
| flutter_secure_storage 10.3.1 | — | — | — | Tink 1.21.0, AndroidKeyStore; minSdk 23 |
| jni 1.0.0 | — | — | — | **`libdartjni.so`** (CMake, `flutter.ndkVersion`); 16 KB-aligned |
| jni_flutter 1.0.1 | — | — | — | none |
| path_provider_android 2.3.1 | no `android/` dir (Dart-over-jni) | — | — | none |
| screen_protector 1.5.3 | — | — | — | sets/clears `FLAG_SECURE` (`ScreenProtectorPlugin.kt:27-30, 38-40`); `isRecording` unsupported |
| shared_preferences_android 2.4.27 | — | — | — | androidx.datastore 1.1.7 → **`libdatastore_shared_counter.so`**; androidx.preference 1.2.1 |
| sqflite_android 2.4.3 | — | — | — | platform SQLite |
| url_launcher_android 6.3.32 | — | **none** | `activity io.flutter.plugins.urllauncher.WebViewActivity` `exported="false"` | androidx.browser 1.9.0 |
| AndroidX transitives | `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | — | `InitializationProvider`; `ProfileInstallReceiver` (DUMP-guarded); `uses-library androidx.window.{extensions,sidecar}` required=false | — |
| Dart-only: flutter_svg, country_flags, pinput, cached_network_image, dio, go_router, riverpod, bloc | — | — | — | — |

## 4. Resolved SDK / toolchain numbers

Flutter 3.44.7 / Dart 3.12.2 / engine `69c8c617`; compileSdk 36; minSdk 24; targetSdk 36; NDK 28.2.13676358; AGP 8.11.1; Gradle 8.14; Kotlin 2.2.20; Java target 17 (local JDK 21, validation relaxed); R8 8.11.18 shrink+obfuscate on; build-tools 36.1.0; applicationId/namespace `com.levelup.level_up_app`; versionCode 1 / 1.0.0.

## 5. Could not determine

- Flutter engine embedding AAR manifest not directly read (inferred from merged output).
- tink-android / datastore AAR manifests not in the Gradle module cache.
- AAB protobuf manifest not decoded (no bundletool/java on PATH); APK from the same build used as proxy.
- Whether R8 re-ran today (mapping.txt mtime 2026-08-14, UP-TO-DATE task); artefact content authoritative.
- DEVICE-level behaviour on Android 15/16 (edge-to-edge, predictive back via go_router).
- Route structure of Review/Result/Mistakes vs `QuizScreen` FLAG_SECURE lifetime (AND-13).
- Play Console facts (account age/type, Play App Signing, Data Safety form).
