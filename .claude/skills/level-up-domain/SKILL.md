---
name: level-up-domain
description: Domain knowledge for the Level Up Flutter app (gamified MCQ app for Egyptian students, School/University tracks). Use this skill whenever working on ANY Level Up feature, screen, model, prompt, or code review — naming things, building quiz/flashcard/gamification/subscription/social features, handling points or levels, payments/entitlements (the app is purchase-silent per adr-049 §3 — never build a paywall or checkout), registration, or writing anything that touches the API. Also use it when reviewing designs or writing change requests, even if "Level Up" isn't mentioned but the work is in this project.
---

# Level Up — Domain Skill

Level Up is a production Flutter app (iOS + Android, one codebase) for Egyptian students: gamified MCQ practice with points, 12 levels, badges, live leaderboards, friend streaks, AI explanations, and paid subscriptions. Many users are **minors**; Arabic (RTL) is the primary audience. You own only the student-facing app — the server decides and validates, the app displays and interacts.

## Non-negotiable operating rules

These exist because getting them wrong creates legal exposure (minors' data), payment disputes, or silent contract drift that surfaces as production bugs.

1. **API contract is the single source of truth.** Build only against Seif's OpenAPI/Swagger. Never assume DB structure. Gap or mismatch → raise a change request to Seif; never work around silently. If code and contract disagree, the code is wrong.
2. **Server is authoritative.** Never compute points, levels, badges, or entitlements client-side — display what the API returns. Entitlement state comes from `GET /me/entitlements` (also embedded in `GET /me`); there is no `pending` state — an entitlement is active or it isn't (`contract/openapi.yaml:754`; adr-020 per `entitlement_state.dart:14`).
3. **The app is purchase-silent.** Per adr-049 §3 (contract 2.2.0-m1, 2026-08-19): no paywall, no price, no upgrade link, no where-to-buy, no voucher redemption — purchases happen on the website only (`x-consumers: [web]`). Never build a checkout hand-off, a payment webhook reference, or any purchase-related UI; a student past the free limit sees a neutral message only (`DECISIONS.md` D-007).
4. **Minors' data protection.** Tokens go in `flutter_secure_storage` (Keychain/Keystore) only. Never log personal data, credentials, tokens, or request/response bodies — not even in debug builds.
5. **Glossary verbatim** (below) in code, prompts, file names, and designs. No synonyms.
6. **Every screen** handles **loading / empty / error / offline**, in **AR (RTL) + EN (LTR)**. A screen isn't done until these exist.
7. **Artifact before code.** No screen before its Figma frame; no endpoint consumed before it's in the contract.
8. **Design tokens, never one-off values.**
9. **Camera-based streak is BLOCKED** pending privacy/legal review. Do not build it; do not even request camera permission.

## Glossary (binding — use these exact names)

API uses snake_case; Dart uses camelCase — bridge with `@JsonKey(name: '...')` in the model, nowhere else.

| Term | Meaning |
|---|---|
| **Track** | School or University. A student belongs to one (after optional one-way transfer). |
| **LearningItem** | Shared abstraction over study content. Two kinds: Question and Flashcard. |
| **Question** | MCQ, one correct of four, may include an image; may carry underline rich-text (underline only). |
| **Flashcard** | Anatomy Flashcard (University only; flip/reveal). Sibling of Question under LearningItem. |
| **school_points / university_points** | Points earned per track. |
| **total_points** | `school_points + university_points`. Drives levels, badges, main leaderboard. |
| **Level** | One of 12 levels, 500 points apart (Level 12 at 6,000 total_points). |
| **Badge** | Every additional 5,000 total_points after Level 12 (first at 11,000). |
| **base_subscription** | The main paid subscription (both tracks). |
| **flashcard_subscription** | Separate University-only subscription for Flashcards. Never call it "premium" or "anatomy plan". |
| **StreakPair** | Social streak between two friends (streak count, last interaction). |
| **ForwardedQuestion** | A question forwarded to a friend; answering it builds the StreakPair. |
| **Institution** | School/university with a read-only analytics dashboard. |
| **Track transfer** | One-time, one-way School → University; preserves points, resets friends. |
| **CustomerService / Ticket** | Web support role / student-filed support request (category, status, priority, threaded messages, attachments). |
| **Country / Governorate / City** | Registration geography. Egypt → +governorate +city; other → city only. Launch: EG, UAE, KSA. |

## Domain facts that shape features

- **School track:** Prep 1–3 + Secondary 1–3; systems National (AR/Languages), IG, American, IB. Content: Subject → Unit → Chapter → Lesson. Quiz = Subject → Chapter → Lesson → length (10/30/50).
- **University track:** Human Medicine + Pharmacy, Egypt-only, content per university. Content: Subject → Lecture. Quiz types: normal + mid-term/final/practical revision. Anatomy Flashcards gated by the `flashcard_subscription` entitlement (no in-app paywall UI — adr-049 §3).
- **Registration geography (School only):** country first (EG/UAE/KSA); Egypt adds governorate + city, others city only. University has no country step. Non-Egypt school students: school name is optional free text — never block submission on it.
- **Free wall:** 50 questions/week; past it the app shows a neutral limit message with no CTA, no price and no upgrade link — the mobile app never presents a paywall (adr-049 §3, D-007).
- **Entitlements:** `GET /me/entitlements` (embedded in `GET /me`) is the sole source of truth. There is no `pending` state — an entitlement is active or it isn't (`openapi.yaml:754`). Do not build a "Payment processing" UI state; it does not exist.
- **One active device:** on session takeover show a graceful "session ended on another device" → forced logout + re-OTP.
- **Per-lesson/lecture counter** (answered/total, e.g. 200/200) is informational only — never locks content; retakes allowed.
- **Quiz screenshot protection:** Android `FLAG_SECURE` (full block); iOS `screen_protector` secure-layer trick (blank captures + detection — not a hard block). Don't promise a hard block on iOS.
- **Leaderboards:** per track + per governorate (Egypt-only) + per country; live via SignalR; values always from server.
- **In-app inbox:** admin broadcasts + end-of-year promotion notification (3rd-secondary students get the School→University transfer prompt).

## Definition of Done (any screen/feature)

Matches the Figma design incl. states and RTL/LTR · consumes the API exactly per contract · handles loading/empty/error/offline · smooth on a mid-range Android device · works in Arabic and English · reviewed · any API/design gap raised with its owner (Seif = contract, UI/UX = design), never silently patched.

## When something is missing

Seif's OpenAPI contract and the Figma designs may not be available yet for a given feature. If asked to build against a missing artifact: stop, say which artifact is missing, and draft the change request or question instead of inventing endpoint shapes or designs. Inventing a plausible-looking response model is the most expensive mistake in this project — it silently becomes "the contract" in code.
