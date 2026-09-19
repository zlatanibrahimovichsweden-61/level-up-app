---
name: screen-states
description: Verify a Level Up screen handles all required states and both languages before calling it done. Use this skill whenever finishing, reviewing, or "polishing" any screen; whenever the user says a screen is done, ready, or needs a check; and whenever adding error/loading/empty/offline handling or Arabic/RTL support to existing UI.
---

# Screen States & Language Verification

Definition of Done for every Level Up screen: **loading / empty / error / offline, each in AR (RTL) and EN (LTR)** — 8 checks. Skipping these is how screens ship that work only on the happy path, only in English, only on good Wi-Fi. Egyptian mobile networks and Arabic are the baseline here, not edge cases.

## The 4 states — how they must be implemented

The shared sealed `ScreenState<T>` lives ONCE in `core/models/screen_state.dart`; the shared `StateWidget<T>` in `core/widgets/` is the only place that switches on it. If you find a screen re-deriving its own state enum or booleans, fix that first.

- **Loading** → skeleton/shimmer matching the content layout (not a bare spinner).
- **Empty** → distinct from error; localized message + illustration. `data` that `isEmpty` is Empty, not Loaded.
- **Error** → localized message + retry button. Retry re-triggers the same failed request on user tap — never silent auto-retry. Never four booleans (`isLoading`, `hasError`…) — they permit impossible combinations.
- **Offline** → its own view/banner driven by `OfflineException` / connectivity, not a generic error.

There is no subscription-pending special case to handle: entitlement state is binary — active or not (`openapi.yaml:754`) — and the mobile app shows no purchase or payment-status UI of any kind (adr-049 §3, purchase-silent).

## The language pass

All copy through `AppLocalizations.of(context)`; both `app_en.arb` and `app_ar.arb` have every key (missing AR keys fail silently to EN — grep for the keys).

RTL is structural — check for these in the diff, they're the usual leaks:

- `EdgeInsets.only(left:/right:)` → must be `EdgeInsetsDirectional.only(start:/end:)`
- `Alignment.centerLeft` → `AlignmentDirectional.centerStart` (same for `Positioned`, `BorderRadius`)
- Direction-semantic icons (back arrows, chevrons) must mirror under RTL
- Hardcoded `TextDirection` anywhere → remove; locale drives `Directionality`
- Swipe/drawer gesture directions flip

## How to verify

1. Grep the screen's widgets for the RTL leaks above and for hardcoded strings.
2. Confirm the notifier/bloc actually emits all four states (e.g., what does it emit on `OfflineException`? on an empty list?).
3. Run the app (or widget tests) with locale `ar`, walk the four states, then repeat with `en`.
4. Record the result: flip the 8 frontmatter booleans (`loading_en` … `offline_ar`) in the screen's note under `04_Screens/`.

Report as a checklist of the 8 cells with pass/fail and what was fixed. If any cell can't be verified (e.g., no way to trigger empty), say so explicitly rather than checking it optimistically.
