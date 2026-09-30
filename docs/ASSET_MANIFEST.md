# Front-end asset manifest — what to export & wire

_File key: `P6044i0giD9TmdQ7C2AmLq`. Export is UNBLOCKED (DESIGN_ISSUES #1 resolved)._
_Cowork cannot download to disk (its sandbox has no route to Figma's asset CDN — HTTP 000).
Claude Code has the working `download_assets` path (it pulled the first three on Day 00), so it
should export these. Format guidance verified by probing the nodes._

## Already downloaded ✅
| Asset | Node | File |
|---|---|---|
| Bird logo | `82:849` | `assets/images/bird_logo.svg` |
| OTP success badge | `82:1598` | `assets/images/success_badge.svg` |
| Onboarding illustration | `337:15166` | `assets/images/onboarding_illustration.svg` |

## Still needed — bundled brand art (currently Material placeholders)
| Asset | Node | Recommended format | Target file | Notes |
|---|---|---|---|---|
| Home "Learn Today" banner | `337:5486` | **PNG @2x + @3x** (photo-based promo, not vector) | `assets/images/home_banner.png` | Replaces `home_banner.dart` placeholder; also settle the carousel question |
| Level medallion / trophy | `337:5338` | **PNG @3x** (probed: its "SVG" is 1.7 MB embedding 2 PNGs — do NOT ship as SVG) | `assets/images/level_medallion.png` | Replaces `level_card.dart:78` placeholder |
| Notification bell | `337:5330` (`mingcute:notification-fill`) | **SVG** (true vector) | `assets/icons/bell.svg` | `home_header.dart:60` — or keep Material `Icons.notifications` (generic) |
| Nav glyph — Home | nav bar `348:6918` → `Footer/on` | **SVG** | `assets/icons/nav_home.svg` | 5 footer icons live inside the nav bar component |
| Nav glyph — Leaderboard | `material-symbols:social-leaderboard` in nav bar | **SVG** | `assets/icons/nav_leaderboard.svg` | |
| Nav glyph — Learn | `icon/footer/course` in nav bar | **SVG** | `assets/icons/nav_learn.svg` | center/elevated tab |
| Nav glyph — Message | `Footer/off` (4th) in nav bar | **SVG** | `assets/icons/nav_message.svg` | |
| Nav glyph — Account | `Footer/off` (5th) in nav bar | **SVG** | `assets/icons/nav_account.svg` | |
| Profile menu glyphs ×10 | inside `170:4933` — `lets-icons:setting-fill`, `stash:save-ribbon`, `game-icons:progression`, `ic:baseline-share` ×2, `fluent:payment-28-filled` (**dead** — the Profile "Subscription" row was removed, D-007; the app is purchase-silent, adr-049 §3 — do not export or wire this glyph), `ic:sharp-privacy-tip` ×2, `iconamoon:trend-up-bold`, `solar:logout-2-bold-duotone` | **SVG** (Iconify, true vector) | `assets/icons/profile/*.svg` | `profile_menu_row.dart` uses Material stand-ins (Day 8 step 1). All 35×35; the last two sit on a `#F4E6FF` disc drawn in Flutter, so export the glyph alone |
| Profile edit pencil | `170:4669` (`fluent:edit-16-filled`) | **SVG** | exported 2026-09-28 as `assets/icons/edit_pencil.svg` (Edit Profile's `176:1347`, 17 x 17, `currentColor`; API→UI Wave 20) | Edit Profile's avatar badge uses it; `profile_header_card.dart` is still `Icons.edit` |
| Flashcards "Again" restart glyph | `1229:8745` (`humbleicons:restart`, inside the 38 dp disc `1229:8739`) | **SVG** | exported 2026-09-29 as `assets/icons/flashcard_again.svg` (26 x 26 export incl. the 3.17 stroke bleed; stroke `currentColor`; API→UI Wave 22) | Tint with `AppColors.flashcardAgainGlyph` via a `ColorFilter`; the disc is `flashcardAgainFill`. The export's stroked bounds are 25.17, so Figma seats the 26 box at (6.42, 6.42) in the disc, not the centred (6, 6): a 0.42 dp difference, left as exported |

To export the nav glyphs, select each footer icon instance inside the nav-bar component
(`348:6918` dark; there is a light-mode nav bar variant too) and export the icon child as SVG.

## Optional / generic (Material is acceptable)
- Back chevron (`weui:arrow-filled`) — catalog/header. Material `Icons.arrow_back` is fine unless the
  designer wants the exact glyph.

## NOT bundled — runtime, from the API (do not download)
- **Avatars** — `GET /reference/avatars`, `StudentProfile.avatar.url` (via `cached_network_image`).
- **Question images** — `QuizQuestion.imageUrl` / `thumbnailUrl` (WebP, DO Spaces CDN) — Day 7.

## Deferred (screen not built yet)
- University Home "Learning Tools" card icons (Flash Card / Normal EX / Midterm / Final / Practices,
  Figma `image 74/76/77/78/80` in `125:2373`) — the section is stubbed; pull when it's built.
