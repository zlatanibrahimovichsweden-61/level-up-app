# Endpoint → UI destination mapping (contract 3.23.0-m1)

**Date:** 2026-09-24 · **Stage:** Phase 1 · **Level:** SOURCE + Figma metadata (nothing run on a device)
**UI source: Figma MCP** (connector `whoami` = Ahmed Mohamed / reputitous@gmail.com; file
`P6044i0giD9TmdQ7C2AmLq`). Reads succeed. The page listing only shows `0:1` "Assets / component";
the screen frames live on a page the listing does not return (DESIGN_ISSUES:1979 calls it `design`),
but every node id below was fetched directly, by id, in this session. `310:10280` (the "light mode"
parent) is too large to fetch (SSE transport error). The MCP does not show Figma Glass effects
(memory `figma-mcp-is-seifs-account`), so dark-canvas elevation still needs the Chrome/desktop
route in COMPARE.

Only endpoints that are **not** already connected to UI are listed here. The 23 connected ones are
in `api_ui_endpoint_inventory.md`.

## 1. Stable endpoints with an existing design destination

### Flashcards — `getFlashcardsForLecture` + `setFlashcardSelfGrade`

```text
GET /flashcards/lectures/{lectureId}/cards   (stable, cursor + pageSize)
PUT /flashcards/cards/{flashcardId}/self-grade (stable)
        ↓ FlashcardsRepository (flashcards_repository.dart:65, :104)   ✔ built + tested
        ↓ LectureFlashcardsNotifier (lecture_flashcards_notifier.dart:69, setSelfGrade :164) ✔ built + tested
        ↓ Screen                                                      ✘ none (no lib/features/flashcards/screens/)
        ↓ Entry point: University → Lectures view → a lecture with Lecture.hasFlashcards
                                                                      ✘ hasFlashcards parsed (subject_tree.dart:140), read by no widget
        ↓ Mock backend route                                          ✘ none
```

- **Design evidence:** Figma `225:5582` (layer mistakenly named "Quiz page"), university flow only.
  Rendered this session: title "Flash cards", close ×, a save/bookmark icon and a share icon in the
  header, a progress bar "1/10", one card (image + prompt "What is A ?"), a back chevron button and a
  **Confirm** CTA, bottom nav with Learn selected. `222:5252` is an empty leftover frame.
- **What the design does not show:** the card's reverse side, and **any self-grade control** —
  the contract's second operation has no visible affordance in the one frame found. The
  bookmark/share icons have no contract operation for flashcards.
- **Action:** **NEW SCREEN REQUIRED** (screen designed, not built). Needs design clarification for
  the reverse side + self-grade before the self-grade half can be built without inventing UI.

### Account deletion — `requestAccountDeletion` + `cancelAccountDeletion`

- **Contract:** stable since 3.x (answers S38); 30-day grace; during grace every authenticated
  operation except an exact four returns `403 account_pending_deletion`, and the client **must route
  to a cancel screen drawn from `GET /me.pendingDeletion.effectiveAt`**.
- **Flutter:** `pendingDeletion` modelled (`student_profile.dart:77-105`), never read; error copy on
  5 screens via `isAccountPendingDeletion()`; no repository method, no screen, no route.
- **Design evidence:** **NOT FOUND.** Settings `176:1840` / `309:8452` has Languages · Mode · Rank ·
  Notification Preferences and no delete row; no deletion or pending-deletion frame was found.
- **Action:** **DESIGN DOES NOT CURRENTLY SUPPORT IT** → **REQUIRES PRODUCT DECISION.**
  Store-mandatory (Google Play; Apple 5.1.1(v)) — `docs/STORE_READINESS.md` §6, DESIGN_ISSUES #62.

### Push token — `registerFcmToken`

- **Contract:** stable since 3.18.0-m1; `204`, `400 validation_failed` for a bad token.
- **Flutter:** nothing; no push package in `pubspec.yaml`. Settings' four notification toggles
  render disabled with hard-coded `value: true` (`settings_screen.dart:319-397`).
- **Design evidence:** Settings "Notification Preferences" (`176:1840` / `309:8452`) and the
  Notifications inbox (`180:8386` / `309:9525`) exist; **the token call itself has no UI**. The
  toggles have no contract storage — registering a token does not make them work.
- **Action:** **REQUIRES PRODUCT DECISION** — needs a Firebase project + platform config the app
  does not have (owner/Seif), a permission-prompt moment, and an answer on the toggles. Not a
  screen of its own.

### Home "Top Student" — `getLeaderboard` (added during COMPARE, 2026-09-24)

- **Contract:** `GET /leaderboard` stable, deployed on staging (2026-09-22), already consumed by the
  Leaderboard tab.
- **Flutter:** Home renders the block as a `ComingSoonSection` (`home_screen.dart:127-131`); the
  class comment (`:27`) says Top Student has "no endpoint yet" — true until D-008 closed on
  2026-09-22, stale since.
- **Design evidence:** Figma Home draws a Top Student block (school `59:1439`; block node `337:5460`
  as cited in the DESIGN_ISSUES #72 back-light table, row B3; university `125:2373`).
- **Action:** **IMPLEMENT IN EXISTING SCREEN** — the one open input is which `scope` and how many
  rows the block shows; read it off the frame in the wave, don't guess.

## 2. ENDPOINTS WITH NO CURRENT UI DESTINATION

```text
Endpoint: GET /me/entitlements (getMyEntitlements)
Contract status: stable
Purpose: the student's active entitlements (baseSubscription / flashcard_subscription), expiry, grace
Flutter implementation: repository + entitlementsProvider built and tested; never watched (B)
Potential UI location: none that is allowed — the app is purchase-silent (adr-049 §3)
Why no UI link exists: gating is done by server 403s on the gated operations; no design shows plan state
Figma evidence: no subscription / plan / price frame found anywhere
Action: DESIGN DOES NOT CURRENTLY SUPPORT IT (keep as data layer; never render price or upgrade)
```

```text
Endpoint: GET /leaderboard/me (getMyRank)
Contract status: stable (x-behaviour-changed)
Purpose: caller's exact rank in the visible population, uncapped
Flutter implementation: none — deliberately (D-008, DECISIONS.md:463-464)
Potential UI location: Leaderboard own-row, or a Profile rank card
Why no UI link exists: owner decision — no synthetic self-rank row; own row shown only when inside the page
Figma evidence: NOT FOUND — Leaderboard 133:3117 has podium + rows 4-12, no pinned/highlighted self row
Action: REQUIRES PRODUCT DECISION (currently decided: do not build)
```

```text
Endpoint: POST + DELETE /me/deletion-request
Contract status: stable
Purpose: start / cancel account deletion (30-day grace)
Flutter implementation: none (model field only)
Potential UI location: Settings or Profile (request); a global cancel screen (mandated by contract)
Why no UI link exists: no design; S38 was only answered 2026-09-12
Figma evidence: NOT FOUND
Action: REQUIRES PRODUCT DECISION + design (store-mandatory)
```

```text
Endpoint: PUT /me/fcm-token
Contract status: stable
Purpose: register the device push token
Flutter implementation: none
Potential UI location: none visible — app start / after login plumbing; Settings toggles are adjacent
Why no UI link exists: no Firebase setup; toggles have nothing to persist to
Figma evidence: Settings Notification Preferences 176:1840 (toggles only)
Action: REQUIRES PRODUCT DECISION (Firebase project, prompt timing)
```

Draft operations (not buildable — listed so the destination is ready when they go stable):

| Endpoint(s) | Future destination | Figma evidence | Action |
| --- | --- | --- | --- |
| notifications ×3 | Home bell → Notifications inbox; unread dot on bell | **FOUND** `180:8386` / `309:9525`: filter chips All · Announcements · Support · System · Promotions, rows with icon, title, body, category pill, relative time, unread dot | FUTURE FEATURE. ⚠ sample rows include "Premium Offer — 40% Off!" / "Upgrade to Premium" (Promotions) and "Daily Streak! 🔥" — a promotion row conflicts with purchase-silent, and streak has no contract field: both need owner rulings before this is built |
| `GET`/`POST /me/terms-acceptance` | a first-use Terms gate | only passive consent text `82:1086` on Login `82:819`; no checkbox, no screen | FUTURE FEATURE + DESIGN DOES NOT SUPPORT IT; Terms text itself missing (S30) |
| `PUT /me/avatar` | Edit Profile avatar sheet "Upload Photo" (disabled today) | **FOUND** `180:3989` / `216:3158` | FUTURE FEATURE |
| favourites ×3 | quiz header bookmark; Profile "Favorite questions" | bookmark `295:3139` (day7 brief); Profile `166:4416` | FUTURE FEATURE |
| `GET /quizzes` | Home "Continue Learning" | no history-list frame found | FUTURE FEATURE; design incomplete |
| `GET /quizzes/{id}` | cold re-open of Result/Review | Review `162:2377` exists (in-memory today) | FUTURE FEATURE |
| `GET /catalog/modules` | none | NOT FOUND (the agent's "subject tree = modules" reading is rejected by the lead) | FUTURE FEATURE |
| recovery ×4 | "lost my phone" from Login/OTP | weak: OTP `82:1171` carries recovery-variant copy; no flow | FUTURE FEATURE |

## 3. Designed screens with no backing operation (reverse direction)

Figma has these screens and the contract has **no** operation for them (tags checked:
auth, catalog, commerce, entitlements, flashcards, leaderboard, profile, quiz, reference):

| Screen | Figma (school / university) | App today |
| --- | --- | --- |
| Your progress | `309:9671`, `334:3453` / `310:10166`, `334:3622` | disabled Profile row |
| Friends | `216:3784` / `309:6906` | shell, no entry point |
| Refer a Friend | `176:2425` / `309:8565` | shell, Share disabled |
| Customer Support (+ chat, + create ticket) | `178:2800`, `178:3518`, `296:3154`, `178:3222`, `178:3378` / `309:8713`, `309:8915`, `309:9146`, `309:8819`, `180:7154` | shell, Create Ticket disabled |
| Messages (12 frames) | `162:2797`, `166:3156`, `215:2628`, `166:4260`, `166:4319`, `171:5031` / `309:6654`, `309:7340`, `309:7490`, `180:7398`, `309:7722`, `309:7778` | `/message` placeholder |

⚠ **Open design question:** Figma has **both** a Notifications inbox (`180:8386`) and a Messages set,
while the code's `/message` tab doc-comment calls itself "the in-app inbox". Which one the draft
notification operations feed is not settled by the frames. Needs design clarification.

## 4. Figma screen index (node ids fetched this session)

Onboarding `459:43885`, `337:15648`, `337:15650` · Login `82:819` (dark `337:15652`) · OTP
`82:1171`, success `155:786`, error `82:1170` (dark `337:19271`) · Sign Up 1 `337:15875` · track
`337:15947` · registration complete `337:5269` / `337:10373` · Home `59:1439` / `125:2373` ·
Leaderboard `133:3117` / `134:3626` · Subjects `134:3837`, `336:4452` / `308:4521`, `336:3844` ·
school tree `135:815`, `135:1270`, `135:1485`, `336:4644`, `336:4797`, `336:4893` · university
lectures `180:5208`, `180:5354`, `336:4145` · Quiz setup `135:1622` / `309:5771` · Quiz question
`159:845`, `159:1431`, `159:1695` (AI), `159:1852`, `216:2973` (photo) / `309:5878`, `309:5994`,
`309:6113` (AI), `309:6256`, `309:7648` · limit `199:2335` / `225:6634`, `225:7001` · Result
`159:1964` / `309:6375`, `309:6488` · Review `162:2377` (dark `337:6705`, RTL `549:20324`) ·
Flashcards `225:5582` · Mistakes `404:6292`, `404:6539`, `404:6677`, `404:6762`, `404:6853` /
`404:7110`, `404:7181`, `404:7234` · Profile `166:4416` / `309:7940` · Edit Profile `176:1201`,
`180:3989`, `216:3158` / `309:8268`, `180:6349`, `309:8099` · Settings `176:1840` / `309:8452` · Go to
Uni dialog `180:4301` · Logout dialog `180:4598` / `309:9366` · Notifications `180:8386` / `309:9525`.
Dark and RTL groups exist for many screens (e.g. Mistakes dark `404:7428`, DESIGN_ISSUES #63);
they were not enumerated in this stage.
