# Part 02 — Android release artefact inspection (done by the lead, ARTEFACT level) — 2026-09-21

Built on this machine from HEAD bf967d6 with Flutter 3.44.7 / Dart 3.12.2:

```
flutter build apk --release -t lib/main_prod.dart        → build/app/outputs/flutter-apk/app-release.apk (60.7 MB, exit 0)
flutter build appbundle --release -t lib/main_prod.dart  → build/app/outputs/bundle/release/app-release.aab (59.0 MB, exit 0)
```

## aapt2 dump badging / permissions (APK)

| Field | Value |
| --- | --- |
| package | `com.levelup.level_up_app` |
| versionCode / versionName | `1` / `1.0.0` |
| minSdk / targetSdk / compileSdk | 24 / 36 / 36 (platformBuildVersionName 16) |
| uses-permission | `android.permission.INTERNET`, `android.permission.ACCESS_NETWORK_STATE`, `com.levelup.level_up_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (AndroidX-generated, normal) |
| application-label | `level_up_app` (identical in all 80+ locale rows — template label ships) |
| native-code | arm64-v8a, armeabi-v7a, x86_64 |
| densities | 160 240 320 480 640 |

## Merged manifest (aapt2 dump xmltree, APK)

- `<application>` name=`android.app.Application`, `allowBackup=false`, `fullBackupContent=false`, `dataExtractionRules=@xml`, `extractNativeLibs=false`, `appComponentFactory=androidx.core.app.CoreComponentFactory`. No `usesCleartextTraffic`, no `networkSecurityConfig`, no `debuggable`, no `localeConfig`, no `enableOnBackInvokedCallback`.
- `MainActivity` exported=true, launchMode=singleTop(1), `taskAffinity=""`, hardwareAccelerated=true, intent-filter MAIN/LAUNCHER only. **No VIEW/BROWSABLE intent-filter → no deep links / App Links.** No `screenOrientation` → all orientations allowed.
- `io.flutter.plugins.urllauncher.WebViewActivity` exported=false — **an embedded-WebView Activity ships in the binary via url_launcher_android** even though Dart only uses `LaunchMode.externalApplication`. Not a violation (never invoked) but it exists for a reviewer's static scan.
- `<queries>`: only `android.intent.action.PROCESS_TEXT` (Flutter text-selection default). No `QUERY_ALL_PACKAGES`.
- `androidx.startup.InitializationProvider` (exported=false) with ProcessLifecycleInitializer + ProfileInstallerInitializer; `androidx.profileinstaller.ProfileInstallReceiver` exported=true (AndroidX standard, shell-only broadcasts).
- uses-library androidx.window.extensions / sidecar (required=false, Flutter default).

## Signing

`apksigner verify --verbose app-release.apk` → `DOES NOT VERIFY / Missing META-INF/MANIFEST.MF`. The release artefact is **unsigned** because `android/key.properties` is absent and `build.gradle.kts:52-69` uses `signingConfigs.findByName("release")` (fail-closed, no debug fallback). ARTEFACT-confirmed, same as 2026-09-05. An upload key + Play App Signing enrolment are required before any upload.

## 16 KB page-size readiness

- `zipalign -c -P 16 -v 4 app-release.apk` → `Verification successful`.
- ELF `LOAD` segment `p_align` (llvm-readelf, AAB base/lib): libapp.so 0x10000 (arm64, x86_64) / 0x4000 (armeabi-v7a); libflutter.so 0x10000; libdartjni.so 0x4000; libdatastore_shared_counter.so 0x4000. All ≥ 16 KB → **compatible**. AGP 8.11.1 (app-metadata.properties).
- Native libs present: `libapp.so` (Dart AOT), `libflutter.so`, `libdartjni.so` (package `jni` — pulled by a plugin, see dependency part), `libdatastore_shared_counter.so` (androidx.datastore via shared_preferences_android).

## R8 / shrinking — CORRECTS the prior register

The AAB carries `BUNDLE-METADATA/com.android.tools/r8.json` with `isShrinkingEnabled:true, isObfuscationEnabled:true, isOptimizationsEnabled:true, minApiLevel 24, R8 8.11.18`, and `BUNDLE-METADATA/com.android.tools.build.obfuscation/proguard.map` (11.7 MB). `android/app/build.gradle.kts` contains **no** `isMinifyEnabled` line; the Flutter Gradle plugin turns it on: `FlutterPlugin.kt:215-225` sets `isMinifyEnabled = true` + Flutter proguard rules whenever `FlutterPluginUtils.shouldShrinkResources()` is true, and that function defaults to `true` (`FlutterPluginUtils.kt:209-215`). So **R8 is ON for every release build** (docs/STORE_READINESS.md §9 "R8/obfuscation: OFF" is stale at ARTEFACT level). Consequences: the AAB already embeds the mapping so Play Console deobfuscates crashes automatically; for APK side-loads keep `build/app/outputs/mapping/release/mapping.txt` (it is gitignored under build/). Native debug symbols are also embedded (`BUNDLE-METADATA/com.android.tools.build.debugsymbols/*/lib*.so.sym`) — good for Play's native-crash symbolication.

## Strings inside the shipped Dart snapshot (libapp.so arm64, AAB)

| Needle | Hits | Note |
| --- | --- | --- |
| `https://TBD.example/api/v1` | 1 | the ONLY API base URL in the prod artefact — placeholder ships; the app fails closed to error states |
| `https://levelup.example/legal/{privacy,user-agreement,cookies}` | 3 | placeholder legal URLs ship |
| `you@example.com` | 1 | email hint (harmless) |
| `01021871999` | 1 | login phone hint from ARB — real-looking number ships (see FE-18) |
| `railway.app`, `level-up-backend`, `http://`, `MockBackend`, `mock_backend`, `main_mock`, `111111`, `+2010`, `10.0.2.2`, `kDebugMode`, `debugShowCheckedModeBanner` | 0 | staging host and mock harness are NOT in the prod artefact (tree-shaken) — ARTEFACT proof of the `-t lib/main_prod.dart` isolation |
| `000000` | 1 | false positive (`00000000` inside a symbol) |
| `staging` | 1 | inside the Dart enum name `Flavor.staging` (no URL) |

Distinct URL literals in the snapshot: 11 — the two placeholder families above plus Flutter/Dart doc links and `https://pub.dev/` (from the licences page).

## AAB metadata

- `BundleConfig.pb`: bundletool 1.18.1, default uncompressed-glob list; `base/native.pb` lists the three ABI dirs. Single `base` module, no dynamic features.
- `dependencies.pb` (Maven graph shipped in the bundle for Play SDK Console): kotlin-stdlib 2.2.20, kotlinx-coroutines, androidx.* (core, lifecycle, activity, fragment, window, appcompat, browser, datastore, preference, startup, profileinstaller, exifinterface, recyclerview…), `com.google.crypto.tink:tink-android` + relinker (flutter_secure_storage), `com.google.code.gson:gson`, okio, io.flutter engine `1.0.0-69c8c61792f04cc809dfef0c910414fb9afc06cd`. **No Firebase, no Google Play services, no ads, no analytics, no Play Billing** — the zero-third-party-SDK posture holds at ARTEFACT level.
- `base/root/DebugProbesKt.bin` (kotlinx-coroutines debug probes resource) ships — cosmetic, common in Kotlin apps; D-level.
- `country_flags` ships every country's flag asset under `base/assets/flutter_assets/packages/country_flags/res/si/*.si` (~250 files) though the app only shows Egypt — size/bloat only.
- `version-control-info.textproto`: `NO_SUPPORTED_VCS_FOUND` (VCS metadata not embedded).
- `NOTICES.Z` (Flutter licence registry) is present → the standard `showLicensePage` data exists.

## Launcher / app icons — ARTEFACT-level proof they are the Flutter template

- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` md5 `57838d52c318faff743130c3fcfae0c6` == Flutter SDK template `templates/app/android.tmpl/.../mipmap-xxxhdpi/ic_launcher.png` md5 `57838d52…` (identical).
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png` md5 `c785f8932297af4acd5f5ccb7630f01c` == Flutter SDK module template `Icon-App-1024x1024@1x.png` (identical). Both icon sets last touched in scaffold commit `5e4a512`.
- No adaptive icon (`mipmap-anydpi-v26`) and no monochrome icon in `android/app/src/main/res/` (dirs: drawable, drawable-v21, mipmap-{m,h,xh,xxh,xxxh}dpi, values, values-night, xml).

## Not verifiable here

- iOS archive/IPA: **UNVERIFIED — REQUIRES LOCAL RELEASE BUILD on macOS/Xcode**.
- Behaviour of the release build on a device from THIS build (installing needs a signed APK; the artefact is unsigned by design) — DEVICE level not reached in this pass.
