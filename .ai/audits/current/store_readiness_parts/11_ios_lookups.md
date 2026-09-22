# Part 11 — iOS unresolved-item lookups (Wave 1-C), 2026-09-22

**Scope:** resolves the items part 04 (`04_ios_src.md` §3/§6) left UNVERIFIED, using official/primary sources only.
Does not re-audit `ios/`. **Verification level: SOURCE** (fetched documents / repo files / API responses, dated
2026-09-22), never higher — nothing here was built or run on Apple tooling.

Method note: every quote below was either read from a raw HTTP fetch (`curl`) I inspected myself, or a GitHub API
response. Two places where only a summarizing fetch tool was available are flagged explicitly as lower-confidence.

Severity legend (same as part 04): **A** upload/validation/build blocker · **B** App Review rejection likely ·
**C** wrong runtime behaviour · **D** must be settled before first submission · **E** should-fix · **F** informational
· **G** cannot be determined without a Mac.

## 1. Flutter 3.44.x documented iOS floor (resolves IOS-10)

| Claim | Source | Date fetched | Quote (≤25 words) |
|---|---|---|---|
| Current docs floor is iOS 15, not 13/14 | `docs.flutter.dev/reference/supported-platforms`, raw HTML line 475 | 2026-09-22 | "Supported 15 to 27 · CI tested 18 and 26 · Unsupported 14 and earlier" |
| **3.44.7 tool constant is still 13.0** (pinned tag, exact match to local SDK) | `github.com/flutter/flutter` tag `3.44.7`, `packages/flutter_tools/lib/src/darwin/darwin.dart:79` | 2026-09-22 | `ios => Version(13, 0, null),` |
| **flutter/flutter `master` has already bumped the same constant to 15.0** — not yet in any shipped 3.44.x | same file, `master` branch | 2026-09-22 | `ios => Version(15, 0, null),` |
| No 3.4x breaking-change entry exists for this | `docs.flutter.dev/release/breaking-changes` (full link list scanned) | 2026-09-22 | iOS-tagged entries present: `ios-flutterviewcontroller-splashscreenview-nullable`, `network-policy-ios-android`, `uiscenedelegate` — none about deployment target |
| 3.44.0 release notes do not mention it either | `docs.flutter.dev/release/release-notes/release-notes-3.44.0` | 2026-09-22 | fetch-tool summary found no iOS-floor text on the page (medium confidence, not raw-diffed) |
| **The tool does not warn below 15 — it silently no-ops** unless the target is 8/9/11/12 | `github.com/flutter/flutter` tag `3.44.7`, `packages/flutter_tools/lib/src/ios/migrations/ios_deployment_target_migration.dart` (full file read) | 2026-09-22 | migrator only rewrites `IPHONEOS_DEPLOYMENT_TARGET = 8.0/9.0/11.0/12.0` → `13.0`, prints `'Updating minimum iOS deployment target to 13.0.'`; a project already at 13.0 (this repo's case) matches none of those patterns and is left untouched, silently |

**Verdict — IOS-10 fully resolved:** Flutter's *documentation* floor (15) and the *3.44.7 tool's* floor (13.0) disagree
today, and the tool gives **no warning** for a 13.0 target — it only auto-repairs pre-13.0 stragglers. The 15.0 floor
already exists on `master`, meaning a future stable release (post-3.44) will likely raise the effective floor and/or
start warning. This app's `IPHONEOS_DEPLOYMENT_TARGET = 13.0` (pbxproj:349,475,526) is below Flutter's *documented*
support line today and will need to move before upgrading past whatever release ships the `Version(15,0,null)` change.

New finding **IOS-18** (Sev D): raise `IPHONEOS_DEPLOYMENT_TARGET` (and `AppFrameworkInfo.plist` `MinimumOSVersion`,
Podfile `platform :ios`) to at least 15.0 proactively — it is already outside Flutter's documented support window and
the tool will not catch it. Owner: Dev.

## 2. Flutter engine `PrivacyInfo.xcprivacy` (resolves the "not cached, unverified" line in part 04 §4)

Fetched verbatim, byte-identical, from both the pinned tag and `master`:
`github.com/flutter/flutter` → `engine/src/flutter/shell/platform/darwin/ios/framework/PrivacyInfo.xcprivacy`
(tag `3.44.7`, and `master`, both 2026-09-22, both 845 bytes, identical content).

| Key | Value |
|---|---|
| `NSPrivacyTracking` | `false` |
| `NSPrivacyTrackingDomains` | `[]` |
| `NSPrivacyCollectedDataTypes` | `[]` |
| `NSPrivacyAccessedAPITypes` | `NSPrivacyAccessedAPICategoryFileTimestamp` → reasons `0A2A.1`, `C617.1`; `NSPrivacyAccessedAPICategorySystemBootTime` → reason `35F9.1` |

**Verdict:** PASS. The Flutter engine ships a compliant, declared manifest for the only required-reason APIs it
touches. Add to part 04 §5 PASS list.

## 3. `device_info_plus` DiskSpace declaration (resolves/upgrades IOS-03)

| Check | Source | Date | Result |
|---|---|---|---|
| Latest released version | `pub.dev/api/packages/device_info_plus` | 2026-09-22 | `13.2.0`, published `2026-06-26T12:36:05Z` — **same version already pinned by this app**; no newer release exists to upgrade to |
| Latest manifest (main branch = same 13.2.0, confirmed via `pubspec.yaml` on `main`) | `raw.githubusercontent.com/fluttercommunity/plus_plugins/main/.../ios/device_info_plus/Sources/device_info_plus/PrivacyInfo.xcprivacy` | 2026-09-22 | `NSPrivacyAccessedAPITypes` is still an **empty array** `<array/>` |
| Latest source still calls the undeclared API | same repo, `FPPDeviceInfoPlusPlugin.m:38-43` | 2026-09-22 | `fsAttributes[NSFileSystemFreeSize]`, `fsAttributes[NSFileSystemSize]` via `attributesOfFileSystemForPath:` — unchanged from part 04's pub-cache read |
| Open issues for "ITMS-91053"/"DiskSpace" | GitHub Search API, `repo:fluttercommunity/plus_plugins` | 2026-09-22 | **1 hit**, issue #2751 "Create ITMS privacy manifest for Apple builds" (opened 2024-03-24, **closed**); 0 hits for "DiskSpace" alone |
| Issue #2751 substance | `github.com/fluttercommunity/plus_plugins/issues/2751` + comments | 2026-09-22 | Maintainer (`miquelbeltran`, 2024-03-25): *"Looking at the codebase, I cannot find a single use of the APIs like systemSize by the plugins."* Issue closed on that basis. |
| Timeline gap that reopens the question | tag `device_info_plus-v11.5.0` ("Add storage information" per changelog) | tagged 2025-06-16T10:08:52Z (per annotated-tag API) | The disk-space feature (`freeDiskSize`/`totalDiskSpace`) was **added over a year after** the issue was closed on "no such API use exists" grounds — the manifest was never revisited afterward. |

**Verdict — IOS-03 upgraded from "likely (A)" to "confirmed current, latest version" (A):** this is not a stale
pub-cache artifact; the exact same gap exists in the latest released version (13.2.0, June 2026) and on `main` today,
and it is not currently tracked by any open upstream issue. Part 04's remediation options (a) drop the plugin on iOS,
(b) wait for an upstream fix, (c) app-level manifest with a truthful reason — still stand; (b) has no ETA since
nobody upstream is currently tracking it. Recommend flagging a fresh issue upstream referencing the exact lines, or
proceeding with (a)/(c).

## 4. `screen_protector` / `ScreenProtectorKit` (resolves/upgrades IOS-15)

| Fact | Source | Date | Value |
|---|---|---|---|
| `screen_protector` latest version | `pub.dev/api/packages/screen_protector` | 2026-09-22 | `1.5.3`, published `2026-07-14T16:03:14Z`; Android + iOS; **not discontinued** (no `discontinued` tag on `pub.dev/api/packages/screen_protector/score`) |
| `ScreenProtectorKit` latest release | GitHub API `releases/latest`, `prongbang/ScreenProtectorKit` | 2026-09-22 | tag `1.5.2`, published `2026-06-17T15:22:54Z` |
| `PrivacyInfo.xcprivacy` in `ScreenProtectorKit` | GitHub API contents listing of the repo root and `Sources/ScreenProtectorKit/` | 2026-09-22 | **Absent.** Repo root has only `.gitignore, .swiftpm, Frameworks, LICENSE, Makefile, Package.swift, README.md, ScreenProtectorKit.podspec, Sources, Tests`; `Sources/ScreenProtectorKit/` has exactly two Swift files, no manifest anywhere. |
| Screenshot-block mechanism, historical | GitHub issue `prongbang/ScreenProtectorKit#7`, "This library is an incorrect way of detecting screenshots, apple warning!!!" (opened 2024-10-29, closed 2026-01-29) | 2026-09-22 | Reporter: *"this uses UITextfield and adds it as a sublayer, which apple is warning not to do."* Quotes an Apple DTS engineer from **`forums.developer.apple.com/forums/thread/722333`** (not 824922 — see below): *"There is no intended functionality to prevent a screenshot... UIViews are intended to only be added to other views via addSubview() and related methods, not via their layers."* |
| Maintainer's fix | same issue, comment by `prongbang`, 2026-01-29 | 2026-09-22 | *"I have fixed the issue in version 1.5.1 by removing the function that Apple warns is not the correct way to detect screenshots."* |
| Residual technique in current source | `raw.githubusercontent.com/prongbang/ScreenProtectorKit/master/Sources/ScreenProtectorKit/ScreenProtectorKit.swift` (883 lines, read in full) | 2026-09-22 | The public-facing block mechanism now delegates to a separate imported package, `import ScreenPreventerKit` (not audited — outside the given scope). However `ScreenProtectorKit.swift` itself still walks the view tree for `UITextField` where `textField.isSecureTextEntry` (line 601) inside a function literally named `preventIOS16Crash()` — i.e. the secure-text-field trick's *side effects* are still being patched around, three lines quoted: `pendingSecureTextFieldStyleRepair` (224, 258), `if let textField = view as? UITextField, textField.isSecureTextEntry` (601). |
| Other live issues worth flagging | GitHub issues API, `prongbang/ScreenProtectorKit`, all states | 2026-09-22 | #12 open "Unknown layout attribute, iOS18"; #11 open "disablePreventScreenshot() leaves residual overlay causing black screen with SFSafariViewController (v1.5.1)"; **#8 closed "iPhone OS 26.0: App crashes on launch due to recursive safe area/trait updates when ScreenProtectorKit is active"** — directly relevant to this app's iOS 26 target. |
| Task's given Apple forum URL | `developer.apple.com/forums/thread/824922` | attempted 2026-09-22 | **UNVERIFIED — blocked.** Direct `curl` returns HTTP 200 but a bot-check interstitial (`<title>Security Verification</title>`, 3.7 KB, no article body). An earlier summarizing fetch produced a fluent "quote" from this URL that I could **not** independently confirm and am treating as unreliable; do not cite it. The verified DTS quote above (via thread/722333, relayed inside GitHub issue #7) is the trustworthy substitute — but note it is a **second-hand quote inside a GitHub issue**, not a first-party Apple fetch. |

**Verdict:** IOS-15 upgraded from "unknown" to "confirmed no manifest, historically-flagged technique, partially
remediated, residual code present, and a known iOS 26 crash report exists in the tracker." New finding **IOS-19**
(Sev B/C): before shipping, either device-test against the closed iOS-26-crash issue #8's scenario, or evaluate
dropping ScreenProtectorKit's screenshot-block feature given Apple's own DTS objects to the underlying technique in
principle (per part 04's existing "never promise a hard block" framing — this is now sourced, not speculative).

## 5. Apple's third-party-SDK named list (resolves the path_provider_foundation question)

Fetched raw HTML of `developer.apple.com/support/third-party-SDK-requirements/`, 2026-09-22.

**Present, byte-matched against the page's own SDK-name list:** Flutter, connectivity_plus, device_info_plus,
url_launcher, url_launcher_ios, sqflite, path_provider, path_provider_ios, shared_preferences_ios, file_picker,
package_info_plus, and `image_picker_ios` (note: the list has `image_picker_ios`, not bare `image_picker`).

**Absent:** `flutter_secure_storage` (in any spelling) does not appear on the list at all.

Operative sentence on when the requirement fires, quoted verbatim from the page's second paragraph:

> "Signatures are also required in these cases where the listed SDKs are used as binary dependencies."

This is Apple's own wording — the *signature* requirement (ITMS-91065 per real-world reports found via search, e.g.
`developer.apple.com/forums/thread/813411`) is explicitly conditioned on binary-dependency usage. The page's
manifest-requirement sentence is not itself conditioned on binary-vs-source in as many words, but Apple's automated
scanner operates against compiled `.framework` bundles inside the archive — a live example from
`fluttercommunity/plus_plugins#3749` (closed, opened 2026-01-26, `device_info_plus ^12.3.0`) shows the actual
rejection text names a concrete path: *"Your app includes 'Frameworks/package_info_plus.framework/package_info_plus'... an SDK identified... as a commonly used third-party SDK."* `path_provider_foundation` 2.6.0 ships **no podspec, no
native bundle, no framework** (Dart-FFI only, confirmed independently in part 04's pub-cache read) — there is no
`Frameworks/path_provider_foundation.framework/...` path for the archive scanner to find, so by the same mechanism
demonstrated in that real rejection, it should not trigger ITMS-91061/91065. **This is an inference from Apple's own
"binary dependencies" wording plus a real-world example, not a sentence where Apple explicitly discusses Dart FFI —
flag as [INFERRED], not a direct Apple statement.**

Note also: `device_info_plus` main branch's `pubspec.yaml` (fetched 2026-09-22) depends only on
`device_info_plus_platform_interface`, `ffi`, `file` — **no transitive `package_info_plus` dependency** at 13.2.0, so
issue #3749 does not implicate this app's pinned version; it is cited only as evidence for how the binary-path
mechanism behaves.

## 6. Xcode 26 / UIScene requirement dates (resolves/upgrades IOS-05)

| Claim | Source | Date | Quote |
|---|---|---|---|
| Xcode 26 / iOS 26 SDK floor for App Store Connect uploads | `developer.apple.com/news/upcoming-requirements/` | fetched 2026-09-22 (via summarizing fetch — **medium confidence, not raw-diffed**) | "Since April 28, 2026: Apps uploaded to App Store Connect must be built with Xcode 26 or later using an SDK for iOS 26, iPadOS 26, tvOS 26, visionOS 26, or watchOS 26." |
| No UIScene item on that specific page | same page/fetch | 2026-09-22 | fetch tool explicitly reported no UIScene/UIApplicationSceneManifest text present |
| Flutter's actual UIScene migration doc (**the task's given URL, `.../uiscene-migration`, 404s — correct slug found**) | `docs.flutter.dev/release/breaking-changes/uiscenedelegate` | 2026-09-22 | "As of the Flutter 3.41 release, UIScene support is the default for iOS apps, and eligible apps are migrated automatically." "In Flutter 3.41 and later, if your project uses an unmodified AppDelegate, Flutter migrates it automatically... If your project uses a custom AppDelegate... complete the following manual migration steps." |
| Apple's UIScene mandate date, as stated by Flutter's own docs | same page | 2026-09-22 | "Beginning with Xcode 27 (iOS 27 SDK), Apple mandates the UIScene lifecycle for UIKit apps. Flutter apps built with Xcode 27 that do not adopt UIScene fail to launch on startup." |

**Verdict:** confirms IOS-05 exactly as written (Xcode 27/iOS 27 SDK, not a blocker for an Xcode 26 build) — now
sourced against Flutter's own published breaking-change doc rather than only tool source reading. The correct doc
slug is `uiscenedelegate`, for the record — file this correction if `04_ios_src.md` or any other part cites
`uiscene-migration`.

## 7. CocoaPods vs SwiftPM default in 3.44.x (resolves the `swift_package_manager_enabled.ios = false` question)

Source-verified (not just the summarizing fetch) directly against the pinned tag:

`github.com/flutter/flutter` tag `3.44.7`, `packages/flutter_tools/lib/src/features.dart`:
```
const swiftPackageManager = Feature(
  name: 'support for Swift Package Manager for iOS and macOS',
  configSetting: 'enable-swift-package-manager',
  environmentOverride: 'FLUTTER_SWIFT_PACKAGE_MANAGER',
  master: FeatureChannelSetting(available: true, enabledByDefault: true),
  beta: FeatureChannelSetting(available: true, enabledByDefault: true),
  stable: FeatureChannelSetting(available: true, enabledByDefault: true),
);
```
`stable: enabledByDefault: true` — **SwiftPM is on by default in Flutter 3.44.7 stable**, confirmed at the exact pinned
tag. Cross-checked against `docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers` (fetched
2026-09-22, summarizing tool): *"As of the 3.44 release, Flutter's Swift Package Manager (SwiftPM) support is on by
default... Flutter falls back to CocoaPods if any of your project dependencies do not support Swift Package
Manager."*

**Interpreting the project's `swift_package_manager_enabled.ios = false`:** this reflects the *project's current,
never-built state* (no `Package.swift`, no `.swiftpm`, per part 04's IOS-01 finding that the iOS target has never
been built) — not a persistent opt-out. It is expected, not a deviation. New finding **IOS-20** (Sev F,
informational, augments IOS-01): the first Mac build under 3.44.7 may therefore produce a **hybrid CocoaPods+SwiftPM**
setup (the tool's `SwiftPackageManagerIntegrationMigration` migrator runs alongside the Podfile-template step already
noted in IOS-01) rather than pure CocoaPods, depending on which of the app's 7 native plugins have adopted SwiftPM
manifests upstream — not checked here, out of this task's scope. CocoaPods must still be installed on the build Mac
regardless, per the doc quote above. Owner: Dev, to confirm at first build.

## 8. iOS 26 / App Store News, Jun–Sep 2026 (icons, Liquid Glass, privacy manifests)

Raw HTML of `developer.apple.com/news/` fetched and grep'd directly (not just summarized), 2026-09-22. Confirmed
titles + `article-date` values, in order:

- "Build for iPhone Duo with new resources" — September 18, 2026
- "Get ready with the latest beta releases" — September 16, 2026
- "Get your subscriptions ready for iOS 27" — September 16, 2026
- "Updates to App Tracking Transparency in the European Union" — September 16, 2026
- "Get ready for iPhone Duo" — September 9, 2026
- "App Store submissions now open for the latest OS releases" — September 9, 2026
- "Design kits for iOS, iPadOS, and macOS 27 are here" — June 23, 2026 (Liquid Glass updates to the *design kits*,
  i.e. Figma/Sketch resources — not an app-facing submission mandate)
- Plus routine items (age ratings, license agreement, Rosetta deprecation, Sign in with Apple domain) not relevant here.

**None found** for: app-icon format changes, Icon Composer requirement, a Liquid Glass *adoption deadline* for
submitted apps, or a privacy-manifest policy update, in the Jun–Sep 2026 window. The only items worth watching are
the iOS 27 / "iPhone Duo" items above, which are informational for this Wave (no action required now).

---

## New/updated findings summary

| ID | Sev | Area | Resolves | Status |
|---|---|---|---|---|
| IOS-18 | D | Min iOS | IOS-10 | New — raise deployment target off 13.0; Flutter's documented floor is already 15, tool floor will follow on `master` |
| IOS-19 | B/C | screen_protector | IOS-15 | New — no manifest confirmed at latest tag; iOS 26 crash issue found in tracker (#8, closed); residual `isSecureTextEntry` code remains post "fix" |
| IOS-20 | F | Build/SPM | IOS-01 | New — SwiftPM is on-by-default in 3.44.7; first Mac build may go hybrid CocoaPods+SwiftPM, not pure CocoaPods |
| IOS-03 | A | Privacy manifest | — | Upgraded: confirmed current at latest released (13.2.0) and `main`; upstream issue tracking it is closed on stale grounds |
| IOS-05 | D | UIScene | — | Confirmed against Flutter's own breaking-change doc (correct slug: `uiscenedelegate`) |

## Remaining UNVERIFIED after this pass

- Apple DTS quote at the task's literal URL `developer.apple.com/forums/thread/824922` — blocked by a bot-check
  interstitial on direct fetch; do not trust any prior paraphrase of it. The equivalent, verified quote lives at
  `forums.developer.apple.com/forums/thread/722333`, relayed second-hand inside a GitHub issue.
- `docs.flutter.dev/release/release-notes/release-notes-3.44.0` — only checked via a summarizing fetch tool, not
  raw-diffed line by line, for the absence of iOS-floor text.
- `developer.apple.com/news/upcoming-requirements/` — same caveat, summarizing fetch only, not raw-verified for the
  UIScene-absence claim (the Xcode-26-floor quote itself is very likely accurate; it matches independently-known
  public information, but was not re-verified via raw HTML in this session).
- Whether any of the app's 7 native iOS plugins (connectivity_plus, device_info_plus, flutter_secure_storage_darwin,
  screen_protector, shared_preferences_foundation, sqflite_darwin, url_launcher_ios) already ship a `Package.swift` —
  not checked; relevant to how "hybrid" the first Mac build's dependency setup will be (IOS-20).
- `ScreenPreventerKit` (the package `ScreenProtectorKit` now delegates to for the actual block mechanism) — not
  fetched or audited; out of this task's given scope but a natural follow-up for IOS-19.
