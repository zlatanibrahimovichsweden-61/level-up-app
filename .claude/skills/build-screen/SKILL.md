---
name: build-screen
description: The standard loop for building or modifying any Level Up Flutter screen from the API contract + Figma frame. Use this skill whenever implementing, changing, or reviewing any student-facing screen or feature — login, home, flashcards, quiz, subscription, profile, settings — even if the user just says "build the X screen", "add the Y page", or "implement this Figma frame" without mentioning a process. Also use it when resuming a half-built screen.
---

# Build a Level Up Screen — The Loop

Every screen follows the same lightweight loop. It exists because the two expensive failure modes in this project are (1) building against invented contract shapes and (2) shipping screens that miss states or break in Arabic. The loop closes both off cheaply, up front.

## Step 1 — Gather only what this screen needs

- **Contract:** read ONLY the endpoint sections this screen consumes (paths + referenced schemas) from Seif's OpenAPI spec. If the spec, endpoint, or a needed field is missing → STOP and draft a change request (see the `seif-api-contract` skill). Never invent shapes.
- **Design:** the specific Figma frame for this screen (see the `figma-frame` skill if pulling via MCP). No frame → say so and ask; don't design from imagination.
- **Glossary:** use `00_Project/Glossary.md` terms verbatim in class, field, file, and route names. No synonyms.

Irrelevant context competes with relevant context — don't load the whole contract or the whole vault.

## Step 2 — Plan before code

Lay out, in a short plan the user approves before any code:

- Route path + params (go_router; guard/deep-link behavior if any)
- State technique per the feature map in `01_Flutter_Specs/Tech_Stack.md`: Riverpod `AsyncNotifier` for async/server data, **Bloc only for the quiz engine**, `setState` only for ephemeral local UI
- Files to create under `lib/features/<feature>/` (models / repository / notifier / screens) per `01_Flutter_Specs/Architecture_and_Folders.md`
- Which of the 4 states need custom visuals vs. `StateWidget` defaults
- Any contract or design ambiguity — listed as questions, not guessed

## Step 3 — Build in small, verifiable increments

Order that works: models (freezed, `@JsonKey` snake_case bridge) → repository (throws typed `AppException`) → notifier/bloc → screen widget → wire route. Run `flutter analyze` between increments; zero errors before moving on.

Layering rule: widgets render state and dispatch intent; notifier/bloc orchestrates; repository is the only place that touches Dio/Hive; the server decides — never compute points/levels/entitlements client-side, display what the API returns. There is no entitlement `pending` state (`openapi.yaml:754`), and the app never builds a purchase/paywall surface (adr-049 §3).

Constraints that are always in force (they close off plausible-but-wrong paths):

- No new dependencies without asking
- No silent auto-retry; retry is a user-tapped button re-triggering the same request
- Tokens only via the secure-storage wrapper; never log personal data or bodies
- Design tokens from the theme, never one-off values
- All copy through `AppLocalizations` (ARB) — zero hardcoded strings

## Step 4 — Finish = states + both languages

A screen isn't done until loading / empty / error / offline all render, in AR (RTL) and EN (LTR). Run the `screen-states` skill checklist before calling it done. Create/update the screen's note from `04_Screens/_Screen_Note_Template.md` and flip its frontmatter booleans as verified.

## Step 5 — Close the loop

- List the edge cases NOT handled and why (surfacing them beats hiding them)
- Any durable decision → one line in `00_Project/Decisions_Log.md`
- Contract gaps discovered mid-build → change request to Seif, referenced in a code comment at the blocked site — never a silent TODO
