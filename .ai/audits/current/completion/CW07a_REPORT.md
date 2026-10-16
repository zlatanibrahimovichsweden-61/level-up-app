# CW07a — Notifications inbox from the Home bell (report)

**Status:** IMPLEMENTED, gated, **UNCOMMITTED**. Not walked on a physical device. See §8 for the owner's next step.
**Wave brief:** `CW07a_PLAN.md`. **Started:** 2026-10-10T05:53:56Z (baseline). **Gate:** §5.
**Roles:**
- Opus planned, verified and ran the AVD visual check.
- Sonnet subagents implemented: increment A (data layer), increment B (UI) and the review fix round.
- The review was Sonnet: 3 lenses, each finding checked by an adversarial verifier.
- Fable was not engaged; no checkpoint was agreed for this wave.

**Verification levels used here:** SOURCE, FIGMA-READ, BUILD, and **AVD** (an Android emulator, which is not DEVICE).
There is no CI run, because nothing is pushed.

## 1. Phase 1 — CW02 disposition (re-verified 2026-10-10 before any edit)

**Tree.** `merged` @ `b227f61` = `origin/merged`; nothing staged; 61 status lines; 11 untracked. The per-file blob list
(58 files) matched the CW02 final check exactly. The only post-gate change was `docs/KNOWN_BUGS.md` (BUG-026,
records-only).

**Records.** An independent read-only verifier (Sonnet) checked `CW02_REPORT.md` §§9–12 and `COMPLETION_STATE.md`
against the gate logs and files, and found **no contradicted claim**:
- 2225/0/0 for both validate scripts;
- the per-file counts 61/24/5;
- the O10-1 fix and its mutations M1–M3;
- the 23/7/29 split;
- BUG-026;
- SQ-31 not filed;
- the peer's `test-results.md` blob `57716a44`.

**Nits it raised**, and what was done about them:
- §2 and §3 headings read as "final". They are now marked as superseded first-close snapshots.
- `04_COMPLETION_ROADMAP.md:75` "Q-B batch" is left, as before.
- An intermediate 2199 gate is not narrated. Accepted.
- `CLAUDE.md` versus D-024 on which file is the source of truth is O-5.

**Disposition.** **No blocker.** CW02 stays PASS WITH WARNINGS, uncommitted, awaiting the owner. Open items:
- UI-1 (minor, DG-03);
- UI-2 nit;
- F1 (the proposed SQ-31);
- Fable #3–#5, #7 hand-over notes, and #6 (the `test-results.md` commit order);
- BUG-026 belongs to CW04.

**Risks this wave adds to CW02.**
- **Entanglement.** CW07a adds a third concern to the 7 files N-26 and CW02 already share, and to `app_router.dart`.
  It is handled by pre-wave copies and additive-only blocks (§4). The commit order becomes N-26 → CW02 → CW07a.
- **Upstream contract moved.** It is now `cc2a29d`, 3.48.0-m1; the pin is still `eddb6ac`, 3.46.0-m1 (§7).
  3.47.0-m1 adds new suggested `account_banned` copy with a support e-mail, so CW02's banned notice (built verbatim from
  `eddb6ac`) will differ once the contract is re-vendored.

## 2. Selection (Phase 2–3)

Five candidates were scouted read-only and ranked by an adversarial critic. The table is in `CW07a_PLAN.md` §1.
- **Chosen: the notifications inbox.** It has a real frame (`180:8386`, University twin `309:9525`), its operations are
  stable, and every string it shows has sourced EN and AR.
- **Support tickets (CW12, text-only) would be worth more**, but about 25–30 strings have no Arabic source.
- **CW18a, the next roadmap wave,** is a configuration wave, not a screen wave. It remains the next non-screen wave.

## 3. What was built (visible)

- **Route.** `/notifications` is a top-level route pushed over the shell. It is authenticated by default-deny, and CW02's
  return-to-target never remembers it (pinned).
- **Home bell.** The bell now opens the inbox.
  - The tap target is 48×48 while the drawn chip stays 37; both bell goldens are byte-identical.
  - It is one semantics node: a button labelled with `notifications`.
  - The unread dot stays off (CW07b).
- **Screen.** `TitledChrome` with "Notifications", then chips All · Announcements · Support · System. Each chip:
  - has its own glyph from the frame's SVGs;
  - is a whole ≥48 box hit-test;
  - grows with the text scale.
- **Rows.**
  - Category disc and glyph, title (`h3`), body (full text, line breaks kept, plain), unread dot (end side), category
    pill, and an absolute date/time (`intl`).
  - **Rendered kinds:** `announcement` (admin text in the UI language) and `moderation_warning` (the contract's
    client-approved EN and AR, verbatim).
  - **Ignored, per the contract:** `enrolment_opened`, `support_ticket_replied`, `academic_year_opened`, unknown kinds
    and unknown categories.
- **Interactions.**
  - Tap an unread row: one `markNotificationRead`; a 204 or 404 marks the row read; any other failure keeps it unread
    with no retry.
  - Load more appears only when `hasMore` and a cursor exist.
  - A page of only ignored items is walked automatically, bounded at 10 hops, and the walk is cancelled when a newer
    build supersedes it.
- **States** (EN/AR, light/dark):
  - loading;
  - empty per tab (`nothingHere`);
  - error + Retry;
  - offline + Retry;
  - pending deletion (text only: no Retry, no sign-out, no navigation);
  - rate-limited (no Retry);
  - append error (the rows stay, with an append-only Retry).
- **Tokens.** 17 colour tokens and 5 elevation tokens, named and documented, with light values from Figma and dark
  stand-ins copied from existing dark tokens. All are pinned by `app_colors_test` and `app_elevation_test`.
- **Mock.** `main_mock` serves both operations with 24 fixtures (every kind, an unknown kind, an unknown category,
  read/unread, two pages) and enforces the contract's validation.

**Files.**
- **New lib:**
  - `lib/features/notifications/`: models, repository, notifier, `notifications_error_copy.dart`,
    `screens/notifications_screen.dart` and `widgets/{notifications_inbox, notification_filter_chips,
    notification_row, notification_category_style}.dart` (1,560 lines);
  - `lib/dev/mock_notifications.dart` (399 lines).
- **New assets:** `assets/icons/notification_{announcement,support,system}.svg`.
- **New tests:**
  - `test/features/notifications/` (models, repository, notifier, screen, fixtures);
  - `test/dev/mock_backend_notifications_test.dart`;
  - `test/features/home/home_bell_test.dart`.
- **Modified, clean before this wave:**
  - `lib/core/theme/app_colors.dart` (+297/−2) and `app_elevation.dart` (+107);
  - `lib/features/home/widgets/home_header.dart` (+57/−11);
  - `test/core/theme/app_colors_test.dart` (+207), `app_elevation_test.dart` (+87/−1; the props ratchet 88 → 93);
  - `test/features/home/home_header_unread_test.dart` (comments only).
- **Modified and SHARED** (additive blocks only; §5 step 9):
  - `lib/core/router/app_router.dart`;
  - `lib/dev/mock_backend.dart`;
  - `lib/l10n/app_en.arb` and `app_ar.arb` (3 keys appended);
  - the 3 generated `app_localizations*.dart` (regenerated);
  - `docs/DESIGN_ISSUES.md` (#130).
- **Records:** `CW07a_PLAN.md`, this file, `cw07a_prewave/`, and the `CW02_REPORT.md` §2/§3 heading notes.

## 4. Copy and design decisions

- **New strings:**
  - `notifFilterAll` (EN "All" from Figma `180:8556`; AR "الكل", the shipped word from `quizReviewFilterAll`). This is
    **derived**, for the owner to confirm.
  - `notifModerationWarningTitle/Body`, byte-equal to `openapi.yaml:1178-1185` (gate-checked).
  - Nothing else is new; every other string reuses an existing key.
- **Deviations from `180:8386`,** logged in `DESIGN_ISSUES.md` #130:
  - Promotions chip, "Premium Offer" and "Daily Streak" rows: dropped (purchase silence, DG-57).
  - "All (6)": shown as "All".
  - Relative times: replaced by an absolute date/time.
  - 2-line clip: replaced by full text (no detail view exists).
  - Border alpha: one value, 0.2.
  - Type: mapped to the handoff scale. The row is about 6 dp shorter than the frame (measured on the AVD: 118.5 versus
    124.3).
  - Dark canvas and Arabic: stand-ins.
  - States: no frames exist.
  - The unread dot has no accessibility label (no sourced copy).
  - **Contrast:**
    - the selected chip, cream on `#AE87E7`, is 2.74:1 in light (built as drawn);
    - the 10 px pill labels are 2.78–4.44:1;
    - all are designer questions.

## 5. Gate (BUILD)

Script `cw07a_gate.sh` (session scratchpad; log `cw07a_gate.log`), run on the final tree 2026-10-10T07:14:07–07:23:34Z,
HEAD `b227f61` = `origin/merged`, nothing staged, contract/ diff vs HEAD 0 files.

| Step | Result |
|---|---|
| Format (tracked + untracked hand-written Dart) | 0 changed (148 + 143 + 59 files) |
| gen-l10n drift | none (generated hash identical before/after) |
| ARB | en = ar = **276** keys, no duplicates; N-26 `phoneHint` and CW02 `errorAccountBanned` intact; `notifModerationWarningTitle/Body` **byte-equal to `openapi.yaml:1178-1185`** in EN and AR |
| pubspec / lock | unchanged |
| Analyze | 0 issues |
| Targeted, each alone | notifications +173 · mock inbox +39 · home +73 · shell +11 · app_router +11 · return_target +61 · session_scope_discipline +6 · account_pending_deletion +21 · goldens +43 (no png changed) · core/theme +103 |
| Guards / contract / pin | +124 / 14 of 14 / 2 of 2 |
| `validate.sh` (report redirected) | **OVERALL PASS, 2453 passed / 0 failed / 0 skipped** (07:17:35–07:20:37Z) |
| `validate.ps1` (report redirected) | **OVERALL PASS, 2453 / 0 / 0** (07:20:50–07:23:24Z) |
| Tracked `test-results.md` | unchanged (still the peer's blob `57716a44`) |
| Logging scan (2,461 added lines) | 0 |
| Purchase-silence scan | 0 (the widened scan's 3 hits are the mock's ignored `promotions` fixture and a doc comment saying there is no Promotions chip) |
| Separation | shared files: additions only — `app_router` +9, `mock_backend` +28, EN ARB +12, AR ARB +4 / 1 changed (the old last entry's trailing comma, JSON-required), generated +18/+10/+10, `DESIGN_ISSUES` +89; the other 50 N-26/CW02 files byte-identical to the baseline; every peer-added N-26 line intact; the old N-26 number appears in no CW07a file (only the 14 pre-existing dated records listed under O-9) |
| Fingerprint | changed-file blob list identical at gate start and end |

**Count reconciliation:** 2453 − 2225 = **228 new tests** = increment A 150 + increment B 56 (screen 49, bell 7) + fix round 22 (notifications +13, home +2, theme +7).

## 6. Review (Sonnet: 3 lenses + adversarial verifiers) and the fix round

- **Findings:** 0 blocker, 0 major, **4 verified minor**, and nits, all fixed:
  - the chip row sat 8 px low;
  - the chip touch target was layout-only (40 px hit area);
  - the fixed chip box contradicted text scaling;
  - the new tokens were not covered by the token guards.
- **Nits fixed:**
  - a misleading "warm tabs" comment, with the round-trip refetch now pinned exactly;
  - a `/notifications` return-to-target pin;
  - walk cancellation on a newer build (and a `refresh()` race);
  - a Load more button with no cursor;
  - a test name over-claiming "one POST";
  - the dot drifting at text scale;
  - "start side" corrected to "end side" in #130 and the plan;
  - stale header-test comments.
- **The lead's own AVD finding:** the bell exposed a second, unlabelled clickable node from the ring's ink. It is now a
  single node, pinned by a test.
- **Revert check:** every fix was checked by reverting it in a scratch copy, which turned its new test red. This was done
  by the fix implementer and is BUILD level.
- **Not fixed:**
  - The error, empty and offline states are not rendered on the dark canvas by any test. The loaded page is, in both
    canvases and both languages.
  - The 2× row overflow is a test-font artefact (Ahem glyphs are wider than Inter), so text-scale is tested on chips
    over an empty inbox.

## 7. Visual verification (AVD, not DEVICE)

- **Setup:** Pixel_8 AVD (Android 16 image `android-36.1`, 1080×2400, 420 dpi), running `flutter build apk --debug
  --flavor staging -t lib/main_mock.dart`. Sign-in: placeholder phone, mock code `000000`.
- **Screenshots** are in the session scratchpad `cw07a_avd/` (01–12):
  - Home;
  - inbox All;
  - after tap-to-read;
  - Support empty;
  - System;
  - All at the Load more button, and after Load more;
  - All in light AR, dark AR and dark EN;
  - Home in dark.
- **Observed and matching `180:8386`:**
  - header, chips, cards, disc and glyphs, unread dot, category pills;
  - RTL mirroring (chips from the right, dot at the end side, chevron mirrored);
  - dark stand-ins readable;
  - tap-to-read removes the dot and the row stops being a button;
  - Support's empty state (its only fixture is an ignored kind);
  - Load more appends page 2 and then disappears;
  - the read state persists on re-entry;
  - Latin digits in the Arabic dates.
- **Differences recorded:** row height about −6 dp (the type scale), and the §4 deviations.
- **Rerun after the fix round:** rebuilt APK on the final tree, fresh install (the emulator was out of space for an in-place update). Screenshot `12_final_inbox_light_en`. The bell is now a single labelled node, with no unlabelled child. Measured from the uiautomator bounds at 2.625 px/dp, the pill top sits **20.0 dp** under the back chip and the first row **24.95 dp** under the pills; the frame says 20 and 25. Chip tap boxes are 48 dp.
- **Physical device:** the Pixel 8 (`45131FDJH0009G`) is attached but **unauthorized** (the USB-debugging prompt has not
  been accepted). The DEVICE walk is **pending** the owner.

## 8. Remaining dependencies, risks, and the next action

- **Seif:**
  - `enrolment_opened` copy (SQ-20; its data key `track` is now documented upstream in 3.48.0-m1);
  - inbox seeds (SQ-16);
  - new and proposed: whether the unread count includes ignored kinds and whether silent marking is allowed (it gates
    the CW07b dot);
  - new and proposed: whether the `realtime.md` push text is also the inbox text for `support_ticket_replied` and
    `academic_year_opened`.
- **Designer:**
  - dark and AR Notifications frames (DG-35);
  - state frames (DG-08, DG-31);
  - icon-chip selected state;
  - full text versus 2 lines;
  - contrast of the selected chip and the pills;
  - unread accessibility label.
- **Owner:**
  - placement (H-17; the bell is the default, and the body is reusable for the Message tab);
  - the derived "All";
  - opting in to push-text reuse;
  - **re-vendoring 3.47/3.48.**
- **Upstream contract (not acted on).** 3.47.0-m1 and 3.48.0-m1 bring:
  - a BEHAVIOURAL `422 name_not_allowed` on the stable `completeRegistration` and `updateMyProfile`;
  - new `account_banned` copy with a support e-mail;
  - safe account-deletion confirm copy (unblocks CW05);
  - server-side push-token cleanup (answers a CW08a question);
  - a new stable `getAppVersionPolicy`;
  - draft daily tasks.
- **The real inbox is sparse.** Most students will see an empty inbox until admins broadcast or CW07b renders the other
  kinds.
- **Support is still a shell.** The approved `moderation_warning` text says "contact Support from the app".
  **Recommended next screen wave: CW12 text tickets**, once the owner rules on the Arabic copy.
- **Next action:** the owner reviews this report.
  - **Commit order (on request only):** N-26 → CW02 → CW07a, explicit paths, CW07a's shared-file hunks separable
    against `cw07a_prewave/`.
  - **WALK:** authorize the Pixel 8 USB prompt for a DEVICE walk.
  - **NEXT WAVE:** CW18a (non-screen) and/or CW12 (screen).
