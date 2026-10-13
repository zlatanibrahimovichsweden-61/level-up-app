# CW04a — Legal document viewer: implementation brief

**Status:** **IMPLEMENTED 2026-10-10, uncommitted** — see `CW04a_REPORT.md`. The owner answered every blocker in §8
the same day ("NEXT STEP — ACCEPT NNA, CLOSE BUG-027, AND IMPLEMENT CW04a"): D1 a maintained Markdown package
(`flutter_markdown_plus`), D2 `/legal/*` public, D3 interim styling from the existing scale, D4 render the served text
faithfully, C1 User Agreement → Terms, C2 remove the Cookie link, C3 the document heading is the one visible title.
Where the build differs from this brief: no ETag / `If-None-Match` cache (each open fetches; a 404 is never cached),
and no mock switch for the error states (the widget tests cover them). The rest of this brief is kept as written.

*Original status:* FORMULATED 2026-10-10, **not started**. The owner instruction ("NEXT STEP — IMPLEMENT `name_not_allowed`
SAFELY, THEN PREPARE THE NEXT SCREEN WAVE", §F) says to scout and formulate only. Build starts on `START WAVE CW04a`
after the blockers in §8 are answered.

Evidence was gathered on 2026-10-10 by reading the repo, plus three read-only Sonnet scouts (roadmap, routes, contract).
Figma was not opened: the connector needs re-authorising. Frame ids below come from the repo's records.

## 1. Which wave, and why this one

- **Wave:** CW04, "Legal viewer, Terms acceptance, settings entry (T10)" (`04_COMPLETION_ROADMAP.md:77`). Its readiness
  column reads:
  - READY INDEPENDENT WORK for the viewer, repository, route and links
  - DESIGN REQUIRED for the Terms step
  - OWNER DECISION REQUIRED for the gate shape

  §5a lists "The CW04 viewer, repository, signed-out route and link replacement" as implementable now (`:200`).
- **Split (proposed, same pattern as CW07a / CW12a):** CW04a is the viewer. CW04b, the Terms acceptance step
  (`getTermsAcceptance` / `acceptTerms`, DG-06, gate shape H-05), is **out of scope** here.
- **Why it is next:** it is the only screen wave the roadmap marks READY that is not already built. CW02, CW07a and
  CW12a are built and uncommitted. In the roadmap's serial order it comes straight after CW18a (`:135`). It hard-gates
  CW12b photos and CW13 (`:115`). It is the in-app half of the P0 store item E-2.
- **Excluded screen waves, each with its blocker:**

  | Wave | Blocker |
  | --- | --- |
  | CW05 deletion | Seif's safe copy (SQ-03), DG-01/02 |
  | CW06 recovery | SQ-12, DG-04, CW05 |
  | CW07b Message tab / bell dot | O-12, Seif's unread-count question |
  | CW09 friends | DR-08, SQ-07, CW04 first |
  | CW10 chat | CW09, staging hub, SignalR dependency |
  | CW11 | CW10 |
  | CW12b, CW13 | CW04, H-16 |
  | CW14 | N-09, H-13 |
  | CW15 | H-01, CW04 |
  | CW16a | DESIGN REQUIRED (DG-23; the favourites frames 296:3154 / 309:9146 are only *suspected*, DG table not updated) |
  | CW16b | N-17 |
  | CW17 | needs all feature waves |

## 2. Screen, states, entry and exit

- **Screen:** `LegalDocumentScreen` (`lib/features/account_shells/screens/legal_document_screen.dart`) is today a shell
  showing "This document hasn't been published yet." It becomes the viewer. It stays one screen for both documents
  (`terms`, `privacy`), keeping its `TitledChrome` and back key `legal_back`.
- **Entry points:**
  - **Profile (signed in):** "Privacy & policy" goes to `/legal/privacy` (`profile_screen.dart:295`) and "Terms &
    Conditions" to `/legal/terms` (`:304`). Figma rows `170:4901` and `170:4912`.
  - **Login (signed out):** the line "By continuing, you agree to our User Agreement, Privacy Policy and Cookie
    Policy" (`login_screen.dart:46-48`, `:275-279`, `:410-417`; Figma `82:1086` inside Login `82:819`). Today each
    link opens `https://levelup.example/legal/…` in the browser, a host that never resolves (the prod `libapp.so`
    carries it, PRE_EXECUTION_DISCOVERY.md). After CW04a the links open the in-app viewer.
  - **This needs `/legal/*` reachable while signed out.** Today `_authRoutes = {'/', '/login', '/login/otp'}`
    (`app_router.dart:57`), so a signed-out student is redirected to `/login`.
- **Exit:** the back chip pops to the caller (Profile or Login).
- **States** (every screen needs loading / empty / error / offline in AR and EN):

  | State | Trigger | Copy |
  | --- | --- | --- |
  | Loading | first fetch | none (progress only) |
  | Content | 200 | `contentMarkdown` rendered in the UI language (`language=ar\|en` from the app locale) |
  | Unavailable | 404 `legal_document_unavailable` ("never an empty 200") | existing `legalNotPublished`; not cached |
  | Offline | no connectivity / transport | existing `offline` + `retry` |
  | Rate limited | 429 `rate_limited` | existing `rateLimited` / `rateLimitedIn` (no countdown, user-tapped retry) |
  | Error | anything else, incl. a 400 | existing `genericError` + `retry` |

  A language switch while the screen is open re-fetches in the other language. AR renders RTL, tables included. The
  screen is checked at text scale 2.0×.
- **Caching:** send `If-None-Match` with the held ETag; a 304 keeps the held body (`Cache-Control: public,
  max-age=3600`). Proposed: in memory only, no disk cache (decision D1, §8).

## 3. Copy

- **No new copy is proposed.** The document text is server-provided: the contract calls it "the approved text
  verbatim", with its own `# ` title. The app never writes legal copy, and the shell's own comment forbids it.
- **Existing keys reused** (in both ARBs; this brief did not re-verify their approval record):
  - `profilePrivacyPolicy`, `profileTermsConditions` (bar titles)
  - `legalNotPublished` (unavailable)
  - `offline`, `retry`, `genericError`, `rateLimited`, `rateLimitedIn`
  - `legalPrefix`, `userAgreement`, `privacyPolicy`, `cookiePolicy`, `legalAnd`, `legalSeparator` (Login line)
- **Owner approvals needed:**
  - **C1:** does "User Agreement" on Login open the `terms` document? The contract has only `terms` and `privacy`.
  - **C2:** the Cookie Policy link. There is no cookie document (the `document` enum is `terms|privacy`; H-05 holds
    it). Dropping it changes the Login sentence ("…Privacy Policy and Cookie Policy"), which then needs re-approved
    EN + AR wording.
  - **C3:** the bar title against the document's own `# ` heading. They read twice, so this is a design question that
    goes with DG-05.

## 4. API and contract

- **Operation:** `getLegalDocument`, `GET /reference/legal-documents/{document}?language=ar|en` (`contract/openapi.yaml`,
  path `:811`).
  - stable, `x-consumers: [mobile, web]`, public (`security: []`)
  - 200 `{document, version, language, title, contentMarkdown}`
  - ETag / 304; 400 `validation_failed`; 404 `legal_document_unavailable`; 429 `rate_limited`
  - It sits in the pinned 3.46.0-m1, so no re-vendor is needed.
- **Staging (API level, 2026-10-08, PRE_EXECUTION_DISCOVERY.md):** 200 for terms and privacy in AR and EN, `version
  r4-2026-10-07`, with ETag and `Cache-Control`. The text uses headings, tables and horizontal rules. That is a probe
  finding; the contract says only "Markdown". This pass did not re-probe.
- **Network:** add a `LegalRepository` in the existing reference/Dio pattern (typed `AppException`s, 304 handling, no
  body logging). Add a provider with `retry: (_, _) => null` (guard-enforced).
- **Out of scope:**
  - `getTermsAcceptance` / `acceptTerms` (CW04b)
  - `terms_acceptance_required` (CW12b / CW13)
  - the prod host `TBD.example` in `app_config.dart:54` (CW18b)

## 5. Mock backend

- Serve `/reference/legal-documents/{terms|privacy}?language=ar|en` from a new `lib/dev/mock_legal.dart`, hooked into
  `mock_backend.dart` the way `mock_support.dart` is.
- Serve 200 with an ETag, and 304 on a matching `If-None-Match`. Add a magic switch for 404 / 429 / offline, so every
  state is walkable on the AVD.
- **The mock body is NOT legal text.** It is an obviously labelled structural sample (heading, paragraph, list, table,
  rule), so nobody mistakes it for reviewed copy. The mock never ships (`main_mock` only).

## 6. Figma and design gaps

- **DG-05 "Legal document viewer" is NEW FRAME REQUIRED** (`03_DESIGNER_HANDOFF.md:68`): no frame exists. The
  designer is to supply heading, table and rule styles "from the existing scale", but the batch has not been sent.
- **Known frames:** Profile rows `170:4901` / `170:4912`; Login consent line `82:1086` (in `82:819`).
- **Gap the owner must rule on (D3, §8):** build the body with the existing `AppType` scale and theme tokens as an
  interim and flag it, or wait for DG-05. Unresolved either way:
  - dark canvas: the existing `TitledChrome` tokens cover it
  - AR table direction
  - wide tables at 320 dp (horizontal scroll or wrap)

## 7. Tests and gates

- **Repository:** decode 200; send `If-None-Match` and reuse the body on 304; 404 → a typed "unavailable" error; 400;
  429 with and without `Retry-After`; offline; a body never logged.
- **Screen**, each in EN and AR:
  - every state in §2
  - RTL and table direction
  - text scale 2.0× at 320 dp with no overflow, using real fonts (`loadAppFonts`)
  - the language toggle re-fetches
  - semantics: the heading levels are announced as headings
- **Router (real `routerProvider`):** a signed-out student reaches `/legal/terms` and `/legal/privacy` from Login and
  comes back to Login. A signed-in student still reaches them from Profile. No other route becomes public.
- **Guards:**
  - a ratchet or grep that no `levelup.example` legal URL is left in `lib/`
  - `contract_models_test` bindings for the new model, with a mutation probe
  - ARB parity
  - the purchase-silence scan (see D4)
  - the text and fontSize ratchets
- **Gates:** both validate scripts OVERALL PASS with exact counts; `flutter analyze` 0; format 0; `gen-l10n` no
  drift; `git diff --check` clean; pre-wave backups; a mutation run proving the new tests fail.
- **Walk:** EN and AR, light and dark, on the AVD against `main_mock`. Optionally a signed-out read on staging, since
  the operation is public and read-only, if the owner allows it. Device / iOS / TalkBack are reported as not done unless
  done.

## 8. Blockers (answer before START WAVE CW04a)

| Id | Decision | Owner of it | Why it blocks |
| --- | --- | --- | --- |
| D1 | **Markdown rendering (N-12):** approve a rendering package (a new dependency; maintenance to be checked at the time), or a hand-written renderer for the constructs actually served (headings, paragraphs, lists, tables, rules, emphasis) | owner | No markdown package is in `pubspec.yaml` / `pubspec.lock`; no new dependency without asking |
| D2 | Make `/legal/terms` and `/legal/privacy` public (signed-out) routes | owner (lock L-AUTH-ROUTER) | `app_router.dart` already holds uncommitted CW02 / CW07a / CW12a hunks; committing that stack first is the safe order |
| D3 | Body styling without DG-05: an interim from the existing scale (flagged) or wait for the designer | owner / designer | Visual interpretation not in Figma is an owner call (CLAUDE.md rule 5) |
| D4 | Rendering the served Terms §4 "Subscriptions" prose is consistent with purchase silence (no price, link or call to action, API-level 2026-10-09) | owner | adr-049 §3; the scan needs a content-level note |
| C1–C3 | §3 copy questions (User Agreement → terms; the Cookie link; the double title) | owner / designer | Login line copy and the screen's title |

**Not blocking the build, but open:** who approved r4 and whether production serves the same version (S30, Seif /
legal); the public web URL the store consoles need (E-2, web half); the legal entity name.

## 9. Definition of done

1. Signed-out from Login and signed-in from Profile, a student reads Terms and Privacy in the UI language, rendered
   in-app from `getLegalDocument`. Each state in §2 renders in AR (RTL) and EN, light and dark.
2. A 404 shows "unavailable", never an empty page. A 304 reuses the held text. Nothing is logged.
3. No `levelup.example` legal link remains, and the Cookie link follows the owner's C2 ruling.
4. No new copy without owner EN + AR approval. No legal text in the app or the mock.
5. The tests in §7 pass and are proven to fail by mutation. Both validate scripts PASS with exact counts.
6. The CW04a report and COMPLETION_STATE are written. Nothing is committed or pushed without an owner request.
