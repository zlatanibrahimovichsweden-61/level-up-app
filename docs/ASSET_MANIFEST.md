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
| Profile menu glyphs ×10 | inside `170:4933` — `lets-icons:setting-fill`, `stash:save-ribbon`, `game-icons:progression`, `ic:baseline-share` ×2, `fluent:payment-28-filled`, `ic:sharp-privacy-tip` ×2, `iconamoon:trend-up-bold`, `solar:logout-2-bold-duotone` | **SVG** (Iconify, true vector) | `assets/icons/profile/*.svg` | `profile_menu_row.dart` uses Material stand-ins (Day 8 step 1). All 35×35; the last two sit on a `#F4E6FF` disc drawn in Flutter, so export the glyph alone |
| Profile edit pencil | `170:4669` (`fluent:edit-16-filled`) | **SVG** | `assets/icons/profile/edit.svg` | `profile_header_card.dart` — currently `Icons.edit` |

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
