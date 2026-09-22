# Part 04 — iOS project audit (subagent report, persisted verbatim) — HEAD bf967d6, 2026-09-21

**Verification level: SOURCE only.** Windows host, no Xcode, no iOS engine artefacts in `C:\flutter\bin\cache\artifacts\engine`. Nothing was built, archived or validated by Apple tooling. Plugin sources read from `C:\Users\musta\AppData\Local\Pub\Cache\hosted\pub.dev\`; Flutter SDK `C:\flutter` (3.44.7 stable).

Severity legend: **A** upload/validation or build blocker · **B** App Review rejection likely · **C** wrong runtime behaviour on iOS · **D** must be settled before first submission (config/process) · **E** should-fix · **F** informational · **G** cannot be determined without a Mac.

## 1. Resolved values

| Item | Value | Evidence |
|---|---|---|
| Bundle id | `com.levelup.levelUpApp` (tests: `.RunnerTests`) — not `com.example` | `ios/Runner.xcodeproj/project.pbxproj:371,550,572` |
| Android id (for comparison) | `com.levelup.level_up_app` | `android/app/build.gradle.kts:43` |
| Display name / CFBundleName | `Level Up App` / `level_up_app` (Android label `level_up_app`; ARB `appTitle` = "Level Up"/"ليفل أب") | `ios/Runner/Info.plist:8,16`; `AndroidManifest.xml:27`; `lib/l10n/app_en.arb:3` |
| Version / build | `$(FLUTTER_BUILD_NAME)`=1.0.0, `$(FLUTTER_BUILD_NUMBER)`=1 ← `pubspec.yaml:19` `1.0.0+1`; no `MARKETING_VERSION` on Runner | `Info.plist:19-24`; `pbxproj:364,543,565`; `ios/Flutter/Generated.xcconfig:8-9` |
| Min iOS | `IPHONEOS_DEPLOYMENT_TARGET = 13.0` (all 3 configs); `AppFrameworkInfo.plist` `MinimumOSVersion 13.0`; tool floor 13.0 | `pbxproj:349,475,526`; `ios/Flutter/AppFrameworkInfo.plist:23-24`; `flutter_tools/lib/src/darwin/darwin.dart:79` |
| Effective pod floor | 13.0 (shared_preferences_foundation, url_launcher_ios podspecs = 13.0; others 12.0) | podspec lines in §4 |
| Device family | `"1,2"` iPhone + iPad | `pbxproj:353,479,532` |
| Swift / bitcode | `SWIFT_VERSION 5.0`; `ENABLE_BITCODE NO` | `pbxproj:374,554,575`; `:365,544,566` |
| Signing | no `DEVELOPMENT_TEAM`; `CODE_SIGN_STYLE` only on RunnerTests; Runner `CODE_SIGN_IDENTITY[sdk=iphoneos*] = "iPhone Developer"` | `pbxproj:383,400,415`; `:335,455,512` |
| Configurations | Debug / Release / Profile (both targets) | `pbxproj:595-598,605-608` |
| Script phases | "Run Script" → `xcode_backend.sh build`; "Thin Binary" → `embed_and_thin`; `ENABLE_USER_SCRIPT_SANDBOXING = NO` | `pbxproj:241-255,225-240`; `:340,460,517` |
| Entitlements | none (`*.entitlements` absent; no `CODE_SIGN_ENTITLEMENTS`) — no push, no Associated Domains | `find ios -type f` |
| Dependency manager | CocoaPods path (`swift_package_manager_enabled.ios = false`); **no Podfile, no Pods, no Podfile.lock** | `.flutter-plugins-dependencies`; `ios/Flutter/Debug.xcconfig:1`, `Release.xcconfig:1` |
| Native iOS plugins | connectivity_plus 7.3.0, device_info_plus 13.2.0, flutter_secure_storage_darwin 0.3.2, screen_protector 1.5.3, shared_preferences_foundation 2.5.6, sqflite_darwin 2.4.3+1, url_launcher_ios 6.4.1; path_provider_foundation 2.6.0 is Dart-FFI only | `ios/Runner/GeneratedPluginRegistrant.m:54-60` (ignored file); `pubspec.lock` |
| Xcode floor in tool | required ≥15, recommended ≥16; explicit Xcode 26 handling present | `flutter_tools/lib/src/macos/xcode.dart:24,28`; `ios/mac.dart:322-329` |

## 2. Info.plist key-by-key (`ios/Runner/Info.plist`, 49 lines)

Present: `CFBundleDevelopmentRegion=$(DEVELOPMENT_LANGUAGE)`→`en`, `CFBundleDisplayName` (`:7-8`), `CFBundleExecutable`, `CFBundleIdentifier=$(PRODUCT_BUNDLE_IDENTIFIER)`, `CFBundleName` (`:15-16`), `CFBundlePackageType APPL`, `CFBundleShortVersionString`/`CFBundleVersion` (`:19-24`), `CFBundleSignature ????`, `LSRequiresIPhoneOS`, `UILaunchStoryboardName LaunchScreen`, `UIMainStoryboardFile Main`, iPhone orientations P/LL/LR (`:31-36`), iPad orientations all four (`:37-43`), `CADisableMinimumFrameDurationOnPhone true`, `UIApplicationSupportsIndirectInputEvents true`.

Absent: `NSAppTransportSecurity` (default ATS, no exceptions — correct), every `NS*UsageDescription` (none needed), `ITSAppUsesNonExemptEncryption`, `LSApplicationQueriesSchemes`, `CFBundleURLTypes`, `UIBackgroundModes`, `UIRequiresFullScreen`, `CFBundleLocalizations`, `UIStatusBarStyle`, `FLTEnableImpeller`, `UIApplicationSceneManifest`, `CFBundleIconName` (injected by actool), `UIRequiredDeviceCapabilities`, `LSSupportsOpeningDocumentsInPlace`. Versus the 3.44.7 template the only differences are the two name strings and the missing `UIApplicationSceneManifest` block.

## 3. Findings

| ID | Sev | Area | Issue | Evidence | Remediation | Owner |
|---|---|---|---|---|---|---|
| IOS-01 | A | Build | iOS target has never been built: no Podfile/Pods/Podfile.lock, no `#include? Pods-Runner.*.xcconfig`, no CocoaPods or SPM references in the pbxproj. First `flutter build ios/ipa` on a Mac will copy the Podfile template, append the Pods includes to `Debug/Release.xcconfig`, run `pod install`. | `ios/Flutter/Debug.xcconfig:1`; `flutter_tools/lib/src/macos/cocoapods.dart:262-264,288-290`; `templates/cocoapods/Podfile-ios:2,30-37` | Perform the local release build; commit `ios/Podfile`, `Podfile.lock`, the rewritten xcconfigs and whatever IOS-05 rewrites. | Owner (Mac) |
| IOS-02 | B | Icons | App icon is the Flutter placeholder: all 15 PNGs md5-identical to `flutter_template_images-5.0.0` (1024 `c785f893…`, 180 `e419d22a…`). LaunchImage PNGs are the template 1×1 transparent stubs (`978c1bee…`). | md5 table; `LaunchScreen.storyboard:22,35` | Supply the real icon set; add launch-screen background (light+dark). iOS 18 dark/tinted variants absent — optional. | Design + dev |
| IOS-03 | A (likely) | Privacy manifest | `device_info_plus` 13.2.0 reads `NSFileSystemFreeSize`/`NSFileSystemSize` (Disk-space required-reason category) on every `iosInfo` call, and its bundled `PrivacyInfo.xcprivacy` declares **no** `NSPrivacyAccessedAPITypes`. The app calls `plugin.iosInfo` at OTP verify. Apple rejects undeclared required-reason API use since 2024-05-01 (ITMS-91053). No app-level `ios/Runner/PrivacyInfo.xcprivacy` exists either. | `…\device_info_plus-13.2.0\ios\device_info_plus\Sources\device_info_plus\FPPDeviceInfoPlusPlugin.m:38,42-43,67-68`; manifest parse (§4); `lib/features/auth/repository/device_info_provider.dart:22-23` | The app only uses `info.model` (`:23`). Options: (a) drop `device_info_plus` on iOS (send `platform` only, or `utsname` via another route); (b) upgrade/patch when upstream declares DiskSpace; (c) app-level manifest — only if a truthful reason code applies (the app never uses disk size, so none does). Also add an app-level manifest for `NSPrivacyCollectedDataTypes`. Confirm via Xcode's archive Privacy Report (G). | Dev; product for (a) |
| IOS-04 | D | Export compliance | `ITSAppUsesNonExemptEncryption` absent → App Store Connect asks per build. All traffic is HTTPS (exempt). | grep none under `ios/`; `app_config.dart:43-44,54` | Add `<key>ITSAppUsesNonExemptEncryption</key><false/>`; answer "No" in ASC. | Dev |
| IOS-05 | D | UIScene | Not migrated: no `UIApplicationSceneManifest`, no `SceneDelegate.swift`, `AppDelegate` is the pre-3.38 shape. 3.44.7 enables auto-migration by default on every iOS build; the **first Mac build will rewrite two tracked files** (`AppDelegate.swift`, `Info.plist`). Apple mandates UIScene from Xcode 27 / iOS 27 SDK — not a blocker for an Xcode 26 build. | `ios/Runner/AppDelegate.swift:5,10`; `flutter_tools/lib/src/features.dart:283-285`; `ios/mac.dart:185-188`; `migrations/uiscene_migration.dart:32-46,214-231,262-284` | Let the tool migrate on the Mac, review the diff, commit. | Dev |
| IOS-06 | C | Keychain | Code assumes secure storage is wiped on uninstall (`secure_storage.dart:66-69`, `device_info_provider.dart:11`). On iOS, Keychain items survive app deletion; `first_unlock_this_device` only blocks backup/other-device migration. No first-launch guard exists. Result: uninstall→reinstall on the same iPhone (or a hand-me-down family iPad) silently resumes the previous student's session with stale tokens + device_id. | `lib/core/storage/secure_storage.dart:31-34,64,66-69`; `…\flutter_secure_storage_darwin-0.3.2\darwin\…\FlutterSecureStorage.swift:96,223` | On first run after install (flag in `shared_preferences`, which *is* wiped on uninstall) call `SecureStorage.clear()`; product must decide whether `device_id` should survive reinstall on iOS (adr-019). Device-verify (G). | Dev + product |
| IOS-07 | D | Localization | Bundle declares only `en`/`Base` (`knownRegions`, single `Base.lproj`, no `CFBundleLocalizations`), while Dart supports `ar`+`en` with Arabic default. App Store listing will show "Languages: English" only; iOS Settings per-app language switcher will not appear; system alerts stay English. | `pbxproj:186-191`; `find ios -name "*.lproj"`; `lib/l10n/app_localizations.dart:96-99`; `lib/core/providers/locale_provider.dart:24` | Add `CFBundleLocalizations` = [`ar`,`en`]; add `ar` to `knownRegions` (and `ar.lproj/InfoPlist.strings` with Arabic `CFBundleDisplayName` if wanted). | Dev; product for names |
| IOS-08 | D | Signing/process | No `DEVELOPMENT_TEAM`, no `ExportOptions.plist`, `docs/RELEASE_SIGNING.md` is Android-only. `flutter build ipa` needs a team/App ID; App ID `com.levelup.levelUpApp` must be registered (irreversible after first upload). | `pbxproj` (no `DEVELOPMENT_TEAM`); `docs/RELEASE_SIGNING.md:1,80-89` | Register the App ID (no capabilities), set team, document iOS signing alongside Android. | Owner |
| IOS-09 | C | Release entrypoint | Same trap as Android: `Generated.xcconfig` shows `FLUTTER_TARGET=lib\main.dart`; a flagless `flutter build ipa --release` ships the dev flavour (staging host). | `ios/Flutter/Generated.xcconfig:6`; `app_config.dart:47-54`; `docs/RELEASE_SIGNING.md:53-61`; `tool/verify_guards.ps1:217-221` | Every iOS release command: `flutter build ipa --release -t lib/main_prod.dart`; the workflow guard already covers `ipa`/`ios` per the Android part. | Dev |
| IOS-10 | D | Min iOS vs support | Project floor 13.0, but Flutter's current docs list iOS 15–27 supported, "14 and earlier" unsupported (**UNVERIFIED for 3.44.7 specifically** — the tool constant is 13.0). | docs.flutter.dev/reference/supported-platforms (fetched 2026-09-21); `darwin.dart:79` | Confirm the 3.44.x floor from release notes on the Mac and raise `IPHONEOS_DEPLOYMENT_TARGET` + Podfile `platform` to match. | Dev |
| IOS-11 | E | Naming | Product name inconsistent: `Level Up App` (iOS display) vs `level_up_app` (`CFBundleName`, Android label) vs "Level Up" (ARB). | `Info.plist:8,16`; `AndroidManifest.xml:27`; `app_en.arb:3` | Decide the brand string once; align all three. | Product |
| IOS-12 | E | Launch screen | Template launch screen: white background with an invisible 1×1 image → white flash before the dark canvas on cold start in dark theme. | `ios/Runner/Base.lproj/LaunchScreen.storyboard:22,35` | Provide launch assets/background colours per appearance; keep `Main.storyboard`. | Design + dev |
| IOS-13 | E | Symbols | No `--obfuscate`/`--split-debug-info`; Release `DEBUG_INFORMATION_FORMAT=dwarf-with-dsym` gives native dSYMs only; Dart frames need `--split-debug-info`. No crash reporter. Not an Apple requirement. | `pbxproj:514`; `docs/STORE_READINESS.md:190` | Decide and record release flags; archive symbols per build. | Owner |
| IOS-14 | F | Build number | `1.0.0+1` fine for first upload; each later upload of the same short version needs a higher `CFBundleVersion`. | `pubspec.yaml:19` | Bump `+N` per upload. | Dev |
| IOS-15 | F | screen_protector | iOS: Dart `preventScreenshotOn/Off` (`screen_protection.dart:34,37`) → `ScreenProtectorKit.enabledPreventScreenshot()` from ScreenProtectorKit 1.5.1 (secure-text-field layer technique; source not in pub cache, UNVERIFIED). Native side always answers `true`; missing plugin surfaces as unawaited `MissingPluginException`. ScreenProtectorKit's privacy-manifest status: unknown. | `quiz_screen.dart:69-70,78`; `…\screen_protector-1.5.3\ios\screen_protector\Sources\screen_protector\ScreenProtectorPlugin.swift:121-131`; `screen_protector.podspec:19` | Device-verify on iOS 26; never promise a hard block. See Apple policy part (2.5.1 DTS statement). | Dev (device) |
| IOS-16 | F | Xcode/SDK | Nothing pins Xcode; 3.44.7 tool requires ≥15, recommends ≥16, has explicit Xcode 26 / iOS 26 code paths. | `xcode.dart:24,28`; `ios/mac.dart:322-329`; `features.dart:259-265` | Build with Xcode 26.x; plan the UIScene move before Xcode 27. | Owner |
| IOS-17 | F | Cross-platform id | iOS `com.levelup.levelUpApp` ≠ Android `com.levelup.level_up_app`. Legal, but two identities to track. | `pbxproj:371`; `build.gradle.kts:43` | Record both in `docs/DECISIONS.md`. | Owner |

## 4. Per-plugin privacy-manifest table (pub cache)

| Plugin | Manifest | AccessedAPITypes | Collected / Tracking | Podspec `resource_bundles` | Podspec min iOS | Required-reason APIs in source | Apple named-SDK list |
|---|---|---|---|---|---|---|---|
| connectivity_plus 7.3.0 | `ios/connectivity_plus/Sources/connectivity_plus/PrivacyInfo.xcprivacy` | none | [] / false | yes | 12.0 | none found | **yes** |
| device_info_plus 13.2.0 | `ios/device_info_plus/Sources/device_info_plus/PrivacyInfo.xcprivacy` | **none** | [] / false | yes | 12.0 | **`NSFileSystemFreeSize`, `NSFileSystemSize`** (`FPPDeviceInfoPlusPlugin.m:42-43`) — undeclared (IOS-03); also `identifierForVendor` (`:65`, not required-reason, not used by the app) | on Apple's list (per policy part) |
| flutter_secure_storage_darwin 0.3.2 | `darwin/…/Resources/PrivacyInfo.xcprivacy` | none | [] / false | yes | 12.0 | none (Keychain not required-reason) | no |
| path_provider_foundation 2.6.0 | none — Dart FFI, no native bundle/podspec | n/a | n/a | n/a | n/a | `NSSearchPathForDirectoriesInDomains` via FFI — not required-reason | (path_provider listed by Apple; FFI impl has no manifest — see policy) |
| screen_protector 1.5.3 | **none**; depends on ScreenProtectorKit 1.5.1 (status unknown) | — | — | none | 12.0 | none in plugin source | no |
| shared_preferences_foundation 2.5.6 | `darwin/…/Resources/PrivacyInfo.xcprivacy` | `UserDefaults` [`1C8F.1`] | [] / false | yes | 13.0 | `UserDefaults` — covered | listed as `shared_preferences_ios` (old name) |
| sqflite_darwin 2.4.3+1 | `darwin/…/Resources/PrivacyInfo.xcprivacy` | none | [] / false | yes | 12.0 | none found | listed as `sqflite` |
| url_launcher_ios 6.4.1 | `ios/url_launcher_ios/Sources/url_launcher_ios/Resources/PrivacyInfo.xcprivacy` | none | [] / false | yes | 13.0 | none | **yes** |
| country_flags, flutter_svg, pinput, cached_network_image, flutter_cache_manager | pure Dart | — | — | — | — | — | — |
| Flutter engine (`Flutter.xcframework`) | ships its own manifest upstream — **not cached on this machine, unverified** | | | | | | **yes** |

## 5. PASS with evidence

1. Bundle id is not `com.example.*` (`pbxproj:371`).
2. 1024×1024 marketing icon present, RGB, no alpha; `ios-marketing` entry in `Contents.json:111-116` (content is still the placeholder, IOS-02).
3. iPad: all four orientations, `UIRequiresFullScreen` absent → multitasking-compatible; `TARGETED_DEVICE_FAMILY "1,2"`. No Dart orientation lock. Landscape/iPad rendering untested (G).
4. ATS default, all hosts HTTPS. `http://mock.local` only in the mock flavour.
5. No purpose strings needed: no camera/photo/location/Bluetooth/contacts/local-network API in any plugin source.
6. url_launcher: single call, `LaunchMode.externalApplication`; `canLaunchUrl` never used → `LSApplicationQueriesSchemes` not required; no universal links / URL schemes.
7. Keychain policy: `first_unlock_this_device` + `synchronizable:false` → `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`, non-migratable backups. (Persistence across uninstall is IOS-06.)
8. `ENABLE_BITCODE = NO`; Release `SUPPORTED_PLATFORMS = iphoneos`, `VALIDATE_PRODUCT = YES`; `EXCLUDED_ARCHS` armv7/i386.
9. No `UIBackgroundModes`, no entitlements, no `CFBundleURLTypes`.
10. `CFBundleIconName` injected by actool.
11. Template files match 3.44.7 except documented deltas.
12. Generated files correctly git-ignored (`ios/.gitignore:21-28`, `.gitignore:30`).
13. Nothing DEBUG-gated in AppDelegate/plist; `DEBUG=1` only in the Debug config.

## 6. Cannot verify without macOS/Xcode — REQUIRES LOCAL RELEASE BUILD

- `pod install` success, `Podfile.lock`, effective deployment target.
- Compile of all seven Swift/ObjC plugins under Xcode 26 / iOS 26 SDK; UIScene auto-migration applied; app launch.
- Built `Info.plist` contents (`CFBundleIconName`, `MinimumOSVersion` rewrite, `DTSDKName`).
- Xcode archive **Privacy Report**: whether Apple flags `device_info_plus` (IOS-03) and the Flutter engine manifest.
- Code signing (team, App ID, provisioning), Transporter/ASC validation, ITMS messages.
- Keychain survival across uninstall on a device (IOS-06); screen_protector behaviour on iOS 26 (IOS-15).
- iPad Split View/landscape layouts, text scaling on iOS; launch-screen appearance; Impeller rendering of the Glass/backdrop effects.
- App Store Connect answers: export compliance, languages, privacy labels, age rating.
- Flutter 3.44.7's *documented* iOS floor (13 vs 15) — IOS-10.
