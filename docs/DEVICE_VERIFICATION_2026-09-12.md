# Device verification — Day 10 Mistakes, and the release artefact

**Date:** 2026-09-12
**Hardware:** Pixel 8 (`shiba`, serial `45131FDJH0009G`), Android 17, API 37
**Builds:** `flutter build apk --debug -t lib/main_mock.dart` for the flow;
`flutter build apk --release -t lib/main_prod.dart` for the artefact checks
**Method:** every tap coordinate came from `adb shell uiautomator dump`, never from
eyeballing a screenshot. The hardware BACK key was not used — it kills the app.

This file records what was OBSERVED. It does not restate what the widget tests already
cover, and it is explicit about the cells that were **not** reached.

---

## Why a mock build was needed at all

The Mistakes flow has no reachable populated data on any real backend. `seif_fight.md`
**S44**: the only staging test account (`+2010000000001`, school track) has an empty
catalog, so it can never hold a graded wrong answer and **both** operations answer empty
regardless of deployment. Staging also cannot be logged into from here — the OTP is a real
SMS.

So `lib/dev/mock_backend.dart` was taught the two endpoints. It is reachable only from
`lib/main_mock.dart`; the shipped release artefact was scanned for `mock.local`,
`MockBackend` and `main_mock` and carries **zero hits in all three ABIs**.

### New fact — the endpoints ARE deployed on staging

Unauthenticated probes, 2026-09-12:

| Path | Status |
| --- | --- |
| `GET /api/v1/me/mistakes` | **401** |
| `GET /api/v1/me/mistakes/subjects/{id}` | **401** |
| `GET /api/v1/me/entitlements` | **401** |
| `GET /api/v1/me/definitely-not-a-route` | **404** |
| `GET /api/v1/me/mistakes/nonsense` | **404** |

The 404 contrast is what makes the 401 meaningful: an absent route answers 404, so **401
means the route exists**. `contract/SOURCE.md` records staging coverage of the eight
newly-stable operations as UNOBSERVED — for the Mistakes pair that is now settled.

It also means **`GET /me/entitlements` has been deployed since 2026-09-04**, when
`.ai/audits/current/smoke-staging-2026-09-04.md` recorded it as **404**.

---

## The flow — OBSERVED, DEVICE VERIFIED

All four theme × locale combinations, both tracks.

| Check | Result |
| --- | --- |
| Entry point on the Subjects header | Live; the coming-soon snackbar is gone |
| Routes keep the bottom nav, Learn active | Yes — confirms they are inside the Learn branch |
| Back chevron present and working | Yes — Lessons → Chapters → Units → overview |
| Tree still populated on the way back | Yes, no re-fetch skeleton at any level |
| Leaves inert | Yes — lesson/lecture rows report `clickable=false` in the hierarchy dump and draw no chevron, while every level above them does both |
| Empty tree | `No mistakes yet` — rendered as content, not as an error |
| Offline banner | Appears on a **true** disconnect |
| University tree | Flat lecture list (`محاضرات التشريح`), **no quizType tabs** |
| Server sums rendered verbatim | lessons 2+1=3 → chapter 3, chapters 3+1=4 → unit 4, units 4+3=7 → subject 7 |
| Dark mode | **Alive** — see below |

### The offline banner needed a real disconnect

Enabling airplane mode alone did **not** raise the banner, and that is correct behaviour,
not a defect: modern Android leaves Wi-Fi enabled in airplane mode, so
`connectivityProvider` still reported a live transport. With Wi-Fi actually disabled the
banner appeared and the grid shifted down to make room. Worth recording because the first
observation looked like a bug and was not.

### The Arabic plural — all six categories, on screen

`mistakeCount` is the project's first ICU plural. Observed:

| Count | Arabic | ICU category |
| --- | --- | --- |
| 1 | خطأ واحد | one |
| 2 | خطآن | two (dual) |
| 5, 7 | ‎5 أخطاء / 7 أخطاء | few |
| 34 | ‎34 خطأً | many |
| 100 | ‎100 خطأ | other |

Genuinely different words, and digits render **Western**, as specified. `zero` is
unreachable by design: the wire publishes `minimum: 1`, so a subject with nothing
outstanding is absent from the overview rather than present with `0`.

### RTL

Header title and cards right-aligned, row chevrons mirrored to the left, back chevron moved
to the right, bottom-nav order reversed. The grid itself mirrors — the first card moves from
x=285 to x=795.

---

## Dark mode — a previously recorded defect that no longer reproduces

`device-walkthrough-2026-08-04` recorded **"dark mode dead on device"** as one of three
confirmed bugs. It had never been re-confirmed, and the standing instruction was to treat
it as suspect because widget tests passing is not evidence.

**It does not reproduce.** Settings → Mode → Dark switches the whole app to the `#232428`
canvas with cream text and the purple nav accent, and the Mistakes family renders correctly
on it. Closed by observation, 2026-09-12.

This also confirms `DESIGN_ISSUES.md` **#70**'s corrected analysis empirically: the pink
card carried unchanged onto the dark canvas reads as a distinct surface, exactly as the
measured 11.06:1 predicted. The computed ratios were independently re-derived this session
and every figure in #70/#71 reproduced exactly — 11.06, 6.30, 4.40, 2.68, 4.61, 1.36, 1.91.

`#71` is also visible rather than merely calculated: the red count on the pink card reads
faint at a glance, in both canvases.

---

## What was NOT verified, and why

| Cell | Status |
| --- | --- |
| **Error state + retry button** | **BLOCKED.** The mock resolves every request locally, so no request can fail; staging cannot be logged into without a real OTP. Stays BUILD-verified. |
| `403 insufficient_scope` copy (both readings) | **BLOCKED** for the same reason — the mock's 403 subject id is not reachable from any screen. |
| Repeated-entry duplicate fetches | **INFERRED only.** Back-navigation re-rendered every level instantly with no skeleton, consistent with the cached tree, but no request log was captured on device. The `called(1)` assertion in the widget tests remains the real evidence. |
| Release APK on device | **NOT INSTALLED.** It is unsigned (below), and its prod host is a placeholder, so a login could not have been completed. `RISKS.md` **R-4** stays open. |

---

## BUG-002 — text scale, Arabic only

Found here, filed in `KNOWN_BUGS.md`. Measured with
`adb shell settings put system font_scale`:

| Locale | 1.0 | 1.15 | 1.2 | 1.3 | 2.0 |
| --- | --- | --- | --- | --- | --- |
| Arabic | clean | clean | clean | **1 card overflows by 2.7px** | **all 6 overflow, 14-27px** |
| English | clean | — | — | clean | — |

English at 1.3 is clean, so an English-only pass would have called the screen fine. At 2.0
the count captions are unreadable and the bottom-nav labels collide as well — this is a
whole-app class of defect, not a Mistakes one. `docs/RESPONSIVE.md` Rule 4 (clamp at 1.3)
is still **proposed and unapplied**, and would not by itself fix this, since 1.3 is exactly
where it appears.

---

## Release artefact — ARTEFACT VERIFIED

`flutter build apk --release -t lib/main_prod.dart`, then unzipped and inspected.

| Check | Result |
| --- | --- |
| `package` | `com.levelup.level_up_app` |
| `versionCode` / `versionName` | `1` / `1.0.0` (from `pubspec.yaml`) |
| `targetSdkVersion` / `compileSdk` | 36 / 36 |
| `INTERNET` permission | **PRESENT** — the Tier-0 C-1 guard holds at artefact level |
| other permissions | `ACCESS_NETWORK_STATE`, `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` — both plugin-merged |
| `android:debuggable` | **ABSENT** — correct |
| ABIs | `arm64-v8a`, `armeabi-v7a`, `x86_64` — 64-bit present |
| **staging host in `lib/*/libapp.so`** | **0 hits in all three ABIs** |
| `TBD.example` in `lib/*/libapp.so` | **1 hit in each** — see below |
| mock/dev contamination | 0 hits for `mock.local`, `MockBackend`, `main_mock` |
| Signature | **`DOES NOT VERIFY` — `Missing META-INF/MANIFEST.MF`.** No v1 block; `apksigner` rejects it. Unsigned, by the fail-closed design in `build.gradle.kts` (no `key.properties` → `findByName("release")` → null) |
| `application-label` | `level_up_app` **in every locale, including `ar`** |

### The blocker this proves

The staging URL is genuinely absent from a `-t lib/main_prod.dart` build — the release
entrypoint rule works. But `app_config.dart:54` resolves production to
`https://TBD.example/api/v1`, and that placeholder **is embedded in the shipped binary**.
A production build is therefore installable and completely non-functional: every network
call fails against a reserved-TLD host that does not resolve.

This is a **BACKEND DEPENDENCY**, not a client defect — the contract's `servers:` block
lists staging only and the production host has not been announced. The in-code comment
already says *"Do NOT ship a prod build until this is replaced."*

Repository inspection cannot prove Play Console compliance, and nothing above should be
read as doing so.
