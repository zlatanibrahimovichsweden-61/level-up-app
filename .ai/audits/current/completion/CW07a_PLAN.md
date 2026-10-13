# CW07a — Notifications inbox from the Home bell (wave brief)

**Status:** FORMULATED and STARTED 2026-10-10 on the owner's instruction of 2026-10-10 ("NEXT PHASE — close CW02 safely,
then implement real Figma screens", Phase 4: "Begin implementation of the selected screen in this task"). Uncommitted.
**Wave ID:** `CW07a` is a split of roadmap wave CW07 (`04_COMPLETION_ROADMAP.md:80`), following the roadmap's own split
convention (CW08a/b, CW16a/b, CW18a/b, `:98-102`). **CW07a** is the inbox screen and the bell entry. **CW07b** is the
rest of CW07: the bell unread dot, the Message tab composition and the kinds whose copy is still missing. The committed
roadmap is not edited; the split is recorded here and in `COMPLETION_STATE.md`.
**Contract:** `eddb6ac` (3.46.0-m1), unchanged. **Figma file:** `P6044i0giD9TmdQ7C2AmLq`.
**Base:** `merged` @ `b227f61` plus the uncommitted N-26 and CW02 sets. Baseline: 2026-10-10T05:53:56Z, 62 status lines
(the 61 recorded at the CW02 close plus this wave's `cw07a_prewave/` record folder), 58 changed-file blobs equal to the CW02
final check.

## 1. Why this screen, and why now

The owner asked for a real Figma-backed screen that can be built without a major backend decision. Five candidates
were scouted read-only (Sonnet scouts plus an adversarial ranker, 2026-10-10). The workflow's raw results are in the
session scratchpad, not in the repo; the ranking is summarised here:

| Rank | Candidate | Verdict | Deciding evidence |
|---|---|---|---|
| 1 | **CW07a Notifications inbox, bell → pushed screen** | Ready with gated defaults | Figma `180:8386` and University twin `309:9525` are read. The 3 operations are stable (`openapi.yaml:1147,1226,1245`). **Every string the slice shows already has EN and AR text:** existing ARB keys, admin-written server text, or contract-approved text. |
| 2 | CW12 Support tickets, text only | Ready on everything except copy | Frames exist (`178:2800`, `178:3222`, `178:3378`), and the 5 operations are stable and never Terms-gated for text (`openapi.yaml:2661-2675`). But about 25–30 strings (form labels, status pills for `open`/`in_progress`/`pending`, the composer, the closed notice) have **no Arabic anywhere**. The status labels also have no EN text. Recommended as the next screen wave once the owner rules on Arabic. |
| 3 | CW15 Refer-a-friend screen | Blocked on copy and dependency | The hero copy is held (H-01). Share needs a new dependency (N-12). The Arabic labels have no source. |
| 4 | CW09 Friends hub | Blocked | DR-08 (phone lookup for minors), no entry point (DG-43), Terms-before-UGC order, about two-thirds of the frames missing. |
| 5 | CW16a history/favourites, CW04 legal viewer | No Figma source | NEW FRAME REQUIRED (DG-23, DG-25, DG-05). |

**Sequencing.** The roadmap's next scheduled wave, CW18a (`:93`), is a configuration wave: a flavor boot assertion and
fail-closed config. **It is not a screen wave.** It stays the next non-screen wave. The protocol allows one screen wave
plus one non-screen wave at a time (`:140`), so CW07a does not displace it. CW07a comes ahead of the roadmap's
CW04→CW05→CW06 chain because each of those is blocked:
- CW04: the Terms step has no frame, and the Markdown dependency is an owner call.
- CW05: Seif's copy.
- CW06: the support channel.

The only plan edge into CW07 is CW05 ..> CW07, a compliance ordering for the grace-window 403. CW07a meets it locally
(the screen shows `accountPendingDeletion`, with no retry and no sign-out), so it needs no CW05 code.

## 2. Figma source (read 2026-10-10 with the Figma MCP, `get_design_context` and `get_metadata`)

| Node | What it is | Use |
|---|---|---|
| `180:8386` | Notifications, School, light, EN | **Primary target.** https://www.figma.com/design/P6044i0giD9TmdQ7C2AmLq/?node-id=180-8386 |
| `309:9525` | Notifications, University, light, EN | Read node-for-node identical to `180:8386` (scout read); no track difference |
| `180:8528` / `180:8529` / `180:8533` | Header: 35 back chip, centred title "Notifications" 22 SemiBold | Existing `TitledChrome` + `CircleBackButton` |
| `180:8554` | Chip row: 40 high, gap 8, horizontal scroll | Chips All / Announcements / Support / System |
| `180:8555` / `180:8556` | Selected chip: fill `#AE87E7`, label `#FCFBF9` 16 SemiBold, padding 12/6, stadium | |
| `180:8557` (+ `180:8711` icon, `180:8558` label) | Idle chip: fill `#FCFBF9`, inset shadow (0,−1) blur 3.3 black 25%, 16×16 glyph (`#384F47`) + 4 gap + label `#384F47` 14 SemiBold | |
| `180:8844` | Row list, gap 16; 25 below the chip row | |
| `180:8743` | Row: fill `#FCFBF9`, 1.2 border `rgba(124,58,237,0.2)`, radius 16.27, inset shadow (0,−0.5) blur 2.5 black 25%, padding 16.26 | |
| `180:8851` | 40 disc `#F4E6FF`, glyph about 29 (black) | |
| `180:8750` / `180:8755` | Title 18 SemiBold black; body 12 Medium `#636363`, 2 lines in the frame | |
| `180:8752` | Unread dot 8.12, `#7070A0`, 6.1 from the top, end-aligned in the title row. Read rows hide it (`309:5603`) | |
| `180:8757` / `180:8758` / `180:8760` | Pill 19.3 high, stadium, label 10.17 SemiBold; time 11.18 SemiBold `#3A3A50`; meta row 8.13 top padding, 8.13 gap | |
| Pills | Announcements `#D0D0FF`/`#7070A0` (`180:8757`); System `#C3FDD8`/`#00A73E` (`180:8791`); Support `#CEF8FF`/`#466EB6` (`180:8807`) | |
| `59:1466` / dark `337:5330` | The Home bell (already built, inert) | Gains a tap target only |

**Assets.** The three category glyphs are vendored from the frame's own SVG exports (MCP asset URLs, fetched
2026-10-10):
- `streamline-plump:announcement-megaphone-solid`
- `bx:support`
- `lets-icons:setting-fill`

They are tinted with tokens through `ColorFilter`, as `circle_back_button.dart:93` tints `chevron.svg`. The back arrow
(`weui:arrow-filled`) is the existing `chevron.svg`, which is the same path.

**Not drawn in Figma, and therefore not invented:** dark and Arabic frames (DG-35), and the empty, loading, error,
offline and load-more states (DG-08, DG-31).

## 3. Scope

**In scope (visible):**
1. **Route.** A new top-level `GoRoute('/notifications')` beside `/refer`, `/support` and `/friends` (pushed over the
   shell, as the frame has no nav bar).
   - It is authenticated only, through the existing default-deny redirect.
   - It is not a shell route, so CW02's return-to-target never remembers it.
2. **Home bell.** Tapping the bell pushes `/notifications`. The bell gets button semantics with the existing
   `notifications` label. The unread dot stays off (see out of scope), and the stale "no endpoint" docs are corrected.
3. **Screen.**
   - `TitledChrome` with the title `notifications`.
   - A chip row: All · Announcements · Support · System. All sends no `category`; each other chip sends its contract
     category and keeps its own cursor.
   - A row list with Load more.
4. **Row.**
   - The category glyph disc, the title, the body and the unread dot (`readAt == null`).
   - The category pill (the existing `notifAnnouncements` / `notifSupport` / `notifSystem` keys).
   - An absolute date and time from `createdAt`, via `intl` `DateFormat.yMMMd(locale).add_jm()`, following the
     `date_of_birth_field.dart:60` precedent.
5. **Rendered kinds.**
   - **`announcement`:** shows `titleEn`/`bodyEn` or `titleAr`/`bodyAr` by UI language, as plain text with line breaks
     kept and never auto-linked (`openapi.yaml:1168-1174`).
   - **`moderation_warning`:** shows the contract's client-approved EN and AR title and body **verbatim**
     (`openapi.yaml:1174-1185`), as 4 new ARB strings.
   - Every other kind is decoded and **ignored**, as the contract requires (`:1166-1168`): `enrolment_opened`,
     `support_ticket_replied`, `academic_year_opened` and any unknown kind. An unknown `category` value is ignored the
     same way.
6. **Tap.** An unread row calls `markNotificationRead`. A 204 or a 404 both leave the row shown as read: 204 is
   idempotent, and a 404 means not this student's or gone. Nothing navigates (DG-42: no target exists). A failure leaves
   the row unread with no retry.
7. **States.**
   - **Loading:** the existing `StateWidget` default.
   - **Empty:** `nothingHere` per tab, only when `hasMore == false` and nothing renderable is left.
   - **Error:** `genericError` + Retry.
   - **Offline:** `offline` + Retry.
   - **Pending deletion:** `accountPendingDeletion`, with no Retry, no sign-out and no navigation.
   - **Load-more failure:** the rows stay, and a Retry is offered for the append only.
8. **Paging.** Every list decision branches on `hasMore`, never on `items.length` (`:1165`). When a page has nothing
   renderable but `hasMore` is true, the next page is fetched automatically, bounded the way
   `leaderboard_notifier.dart:99-127` bounds its short-page walk.
9. **Coverage:** EN LTR and AR RTL; light and dark.
10. **Mock.** `main_mock` serves `GET /me/notifications` (cursor, limit, category, validation) and
    `POST /me/notifications/{id}/read` (204 idempotent, 404 unknown). The fixtures cover:
    - every kind, including one unknown kind;
    - read and unread items;
    - more than one page.

**Out of scope (CW07b or later):**
- The bell **unread dot** and `getUnreadNotificationCount`. Every student gets an `enrolment_opened` welcome item, and it
  has no copy (SQ-20), so a dot driven by the server count would stay lit over an inbox that shows nothing.
- The Message tab and `MessagePlaceholderScreen` (H-17, D-023).
- The Promotions chip and the "Premium Offer" and "Daily Streak" rows (DG-57; purchase silence, adr-049 §3).
- The "All (6)" count (no such total exists).
- Relative time.
- Row navigation.
- The Settings notification toggles (H-07).
- Push, chat and new dependencies.

## 4. Copy sources (no string is written by this wave)

| String | EN / AR source |
|---|---|
| Title, bell semantics | `notifications` (`app_en.arb` / `app_ar.arb`, existing) = Figma `180:8533` |
| Announcements / Support / System (chips and pills) | `notifAnnouncements` / `notifSupport` / `notifSystem` (existing) = Figma `180:8558`, `180:8730`, `180:8738` |
| All | **New key, derived:** EN "All" is Figma `180:8556` without "(6)"; AR "الكل" is the word already shipped in `quizReviewFilterAll`. Flagged for owner confirmation. |
| Empty / error / offline / retry / load more / pending deletion | `nothingHere`, `genericError`, `offline`, `retry`, `loadMore`, `accountPendingDeletion` (existing) |
| `moderation_warning` title and body | 4 new keys, copied character-for-character from `openapi.yaml:1178-1185` (client-approved 2026-10-07). Precedent: D-015, and CW02's `errorAccountBanned` |
| `announcement` text | Server data at runtime |
| Date and time | `intl` CLDR formatting; no words written |

## 5. Design decisions taken for this wave (each logged for the designer in `docs/DESIGN_ISSUES.md`)

1. **Dark canvas.** There is no dark frame, so the stand-ins reuse established dark treatments:
   - rows, idle chips and the disc take the `#27282C` 20% + Glass treatment of `reviewFilterIdle*` and `treeRowBadgeFill`;
   - the selected chip takes `quizReviewFilter*` dark (purple, `#232428` label, DESIGN_ISSUES #54 contrast precedent);
   - the text takes `textPrimary` and `textSecondary` dark;
   - the unread dot takes `Brand.purplePrimary` (the bell's own dark dot);
   - pills keep their light pastel pairs in both canvases, as `cardLabel` does.
2. **Type, mapped to the handoff scale** (`app_typography.dart`; there is no 10.17 or 11.18 style):
   - title `h3`; body `labelMedium`; pill `labelSmall`; time `labelMedium`;
   - idle chip `labelLarge`; selected chip `buttonLarge` (the frame draws the selected label 16).
3. **Full text, no clipping.** The frame clips the body at 2 lines, but no detail view exists (DG-42), and the
   `moderation_warning` body is five sentences. Titles and bodies therefore render in full.
4. **One border alpha.** Rows use one border, 0.2, which is 4 of the 6 frame rows. The frame's 0.15 rows are not
   consistently the read rows (`309:5595` is read at 0.2).
5. **Selected-chip contrast.** Cream on `#AE87E7` is about 2.7:1. It is built as drawn in light and logged as an
   accessibility question.

## 6. Files

**New:**
- `lib/features/notifications/`: models, repository, notifier, screen, widgets and error copy;
- `assets/icons/notification_{announcement,support,system}.svg`;
- `test/features/notifications/*`;
- `test/dev/mock_backend_notifications_test.dart`.

**Modified, clean before this wave:**
- `lib/features/home/widgets/home_header.dart` (bell tap, docs);
- `lib/core/theme/app_colors.dart` and `app_elevation.dart` (named tokens);
- possibly `test/features/home/*` and `test/guards/contract_models_test.dart`.

**Modified and SHARED with uncommitted N-26 / CW02 hunks.** Pre-wave copies are in `cw07a_prewave/`, with blob ids in
`SHA_LIST.txt`. This wave's hunks are additions in their own blocks:
- `lib/core/router/app_router.dart`: one route block;
- `lib/dev/mock_backend.dart`: one dispatch block and one fixture block;
- `lib/l10n/app_en.arb` and `app_ar.arb`: keys appended at the end;
- the 3 generated `app_localizations*.dart`: regenerated, never spliced;
- `docs/DESIGN_ISSUES.md`: one new entry.

**Not touched:**
- `session_scope.dart` (the providers are autoDispose);
- `contract/`;
- `test-results.md` (every validate run uses `LEVELUP_VALIDATE_OUT` outside the repo);
- the CW02 test files, unless a guard demands it, which would be reported.

## 7. Contract and backend dependencies, open questions

- **No blocker.** All operations used are `x-stability: stable` with no `x-consumers`.
- **Seif:**
  - SQ-20: `enrolment_opened` copy and data keys.
  - SQ-16: staging inbox seeds.
  - New, proposed: does `unreadCount` count kinds a client ignores, and may a client mark them read silently? This
    gates the CW07b dot.
  - New, proposed: is the `realtime.md:97-102` push text for `support_ticket_replied` and `academic_year_opened` also
    the inbox text?
- **Designer:**
  - dark and Arabic frames (DG-35);
  - the state frames (DG-08, DG-31);
  - the selected-chip state for chips with icons;
  - full-text versus 2-line rows;
  - contrast of the selected chip;
  - an unread accessibility label (no EN or AR source exists, so none is shipped).
- **Owner:**
  - placement (H-17; the bell is the default, and the body is reusable for a tab);
  - the derived "All" string;
  - whether to opt in to the push strings for the two ignored kinds.

## 8. Acceptance criteria

1. The bell opens the inbox; back returns to Home. On `main_mock`, the All tab shows the rendered fixtures newest
   first. No unknown, `enrolment_opened`, `support_ticket_replied` or `academic_year_opened` item appears.
2. Each chip requests its own `category` and shows its own rows, or the per-tab empty state.
3. Tapping an unread row marks it read: the dot disappears, and the call is made once.
4. Loading, empty, error, offline, pending-deletion and append-failure states render in EN and AR.
5. RTL mirrors the layout: the chip row starts at the right, and the dot sits at the END side (right in English, left
   in Arabic; corrected 2026-10-10 after review, which found "start side" here was wrong).
6. Both canvases render with no hardcoded colour or `fontSize` outside `lib/core/theme/`.
7. No personal data, notification text or ids are logged. The purchase-silence scan is 0. ARB parity holds with no
   duplicate keys.
8. Gates:
   - `dart format` 0 changed; `flutter analyze` 0; gen-l10n no drift;
   - guards green; contract 14/14 or more (plus any new binding); pin 2/2;
   - `validate.sh` and `validate.ps1` OVERALL PASS with a count of 2225 + the new tests, 0 failed, 0 skipped;
   - the tracked `test-results.md` unchanged.
9. The N-26 and CW02 hunks in the shared files are byte-identical to `cw07a_prewave/`, except for this wave's added
   blocks (checked by diff).
10. **Visual verification.**
    - An AVD run of `main_mock` with screenshots of All, a filtered tab, a read/unread row, AR and dark, compared
      against `180:8386`.
    - A physical device is attached but unauthorized, so the Pixel 8 walk stays pending until the owner authorises
      USB debugging.
    - Level: AVD ≠ DEVICE; reported as such.

## 9. Rollback boundaries and risks

- **Rollback.**
  - Delete `lib/features/notifications/`, the 3 SVGs, the new tests and the new token fields.
  - Restore the shared files from `cw07a_prewave/` (blob ids recorded).
  - Revert `home_header.dart` to HEAD.
  - No migration, no dependency, no contract change.
- **Risks:**
  - Shared-file entanglement: the commit order is N-26 → CW02 → CW07a.
  - A sparse real inbox (most real students see an empty inbox until admins broadcast or CW07b lands).
  - The approved `moderation_warning` text tells students to "contact Support from the app" while Support is still a
    shell. CW12 should follow.
  - The intl Arabic digits question (#19).
  - Golden churn on the Home bell (none expected; the visuals are unchanged).
