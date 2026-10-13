# CW04a — Legal document viewer: implementation report (2026-10-10)

**Owner instruction:** "NEXT STEP — ACCEPT NNA, CLOSE BUG-027, AND IMPLEMENT CW04a LEGAL DOCUMENT VIEWER" (2026-10-10),
with decisions D1–D4 and C1–C3 answered. Brief: `CW04a_BRIEF.md` (formulated earlier the same day, now IMPLEMENTED).

**Status:** IMPLEMENTED, gated, **UNCOMMITTED**. Nothing staged, committed, pushed or sent.

**Verification level:** BUILD. Widget, unit and router tests, a mutation run and the full gates. No device walk,
no iOS, no TalkBack, no staging call in this pass. Figma was not opened: the connector needs re-authorising.

## 1. What was built

- **The screen:** `LegalDocumentScreen` (`lib/features/account_shells/screens/legal_document_screen.dart`). It is the
  same file and route as the old "not published yet" shell, now a viewer for `getLegalDocument`. It is one screen for
  both documents (`/legal/privacy`, `/legal/terms`) and keeps its `TitledChrome` back chip (`legal_back`).
- **API:** one operation, `getLegalDocument`.
  - `GET /reference/legal-documents/{document}?language=ar|en` (`contract/openapi.yaml:811`).
  - Stable, public (`security: []`), in the pinned 3.46.0-m1. No re-vendor.
  - The response is JSON `{document, version, language, title, contentMarkdown}`. All five are required, and
    `contentMarkdown` is "the approved text verbatim (Markdown, including its own `# ` title line)".
- **The payload is Markdown, as the contract says.** The staging bodies saved on 2026-10-08, re-measured by a
  read-only scout this pass, use:
  - H1 and H2 headings
  - `---` rules
  - bullet, nested and ordered lists
  - bold, including across a soft line break
  - three 2-column pipe tables (Privacy only)

  They contain no links, images or HTML. This pass did not call staging.
- **Data layer** (new, `lib/features/legal/`):

  | File | Role |
  | --- | --- |
  | `models/legal_document.dart` | the `LegalDocument` enum (terms, privacy: the wire values) and a strict `LegalDocumentContent` (a missing field fails; never an empty page) |
  | `repository/legal_repository.dart` | the main `dioProvider`, like the other `/reference` reads; typed `AppException`s passed on; nothing logged |
  | `notifier/legal_document_provider.dart` | `FutureProvider.autoDispose.family` keyed by (document, language), `retry: null` |
  | `legal_error_copy.dart` | the copy funnel (existing approved lines only) |
  | `legal_links.dart` | the link fence |
  | `widgets/legal_markdown.dart` | the renderer |

- **No cache and no `If-None-Match`.** No 304 can arrive. The document is fetched each time the viewer opens, so a
  404 is never cached (the contract says not to) and a new version shows on the next visit.

### States, all in English (LTR) and Arabic (RTL)

| State | Trigger | Shown | Retry |
| --- | --- | --- | --- |
| Loading | first fetch, and a Retry | spinner; bar names the document | — |
| Document | 200 | the served Markdown, whole and in order; bar keeps only the back chip (C3) | — |
| Unavailable | `404 legal_document_unavailable`, or a 200 whose text is blank | `legalNotPublished` "This document hasn't been published yet." | no |
| Offline | `NetworkException` (no connection, timeout) | `offline` | yes |
| Rate-limited | `429 rate_limited` | `rateLimitedIn(seconds)` when `Retry-After` came, else `rateLimited` | yes |
| Error | anything else (5xx, a `404 not_found`, a `400`, a body that breaks the contract) | `genericError` | yes |

- Retry only ever happens on the student's tap (`ref.invalidate`); nothing retries on its own.
- A language toggle while the viewer is open fetches the other language.
- **Copy:** existing keys only. No string was added to either ARB, and none changed (the hashes are in §6).

## 2. Owner decisions, as implemented

### D1 — Markdown package
- **Package:** `flutter_markdown_plus: ^1.0.12`, plus `markdown: ^7.3.1`.
  - Declared because the viewer names its node types. It was already that package's parser.
  - **Lock delta:** exactly these two packages (1.0.12, 7.3.1). Nothing else moved.
- **Why this one:**
  - It is the stated successor of the discontinued `flutter_markdown` (Flutter team, discontinued).
  - Maintained (1.0.12, 2026-07-10). BSD-3-Clause; the parser is BSD-3-Clause too.
  - Pure Dart, no native code: plugin-free on all six platforms (an inference from its pub.dev tags).
  - Compatible: Dart ^3.4 and Flutter ≥ 3.27.1, against the pinned Flutter 3.44.7 / Dart 3.12.2. It builds and tests
    here (BUILD).
  - Narrowest choice: `markdown_widget` would pull in syntax highlighting, `visibility_detector` and
    `scroll_to_index`.
- **Untrusted content** (`legal_markdown.dart`):
  - **HTML is never interpreted.**
    - The package already shows an inline tag as its literal characters.
    - By default it silently drops an HTML block, and the words inside it. The viewer turns a block into a literal
      paragraph instead, so nothing the server sends disappears.
  - **No image is ever loaded.** An `img` builder replaces the package's image handling, so nothing is fetched
    or read and no address is even parsed. The image's alt text is set where the image was, in a line or in a
    heading, so no words are lost.
  - **Links:**
    - Only `https` with a host, or `mailto` with an address, opens, outside the app (`url_launcher`,
      `externalApplication`).
    - `http`, `javascript:`, `data:`, `file:`, `intent:`, relative links and anything unparsable do nothing.
    - There is no WebView.
    - Probed and pinned by tests.
- **Robust to malformed text** (review fixes):
  - The start-aligned table syntax *replaces* GFM's own inside the extension set. Adding it beside GFM's made the
    parser throw on any table whose header and delimiter column counts differ, taking the whole document down.
  - A footnote mark inside a heading no longer crashes the heading builder.
  - List numbers never split: the marker column grows with the text size, and a marker keeps to one line.
- **No other change to the text.** The package's own GFM parsing stands. A soft line break reads as a space, as
  Markdown says, which matters because the served text wraps at about 120 columns, including inside bold.
- **Standard Markdown semantics apply, as on any compliant renderer** (the review raised them; the verifier ruled
  them not defects):
  - table cells beyond the header's count are ignored;
  - a `[label]: destination` line is a link definition and does not show;
  - footnotes move to the end;
  - list items are numbered from the first item's number, as "N.";
  - an `http` or `www.` address is drawn as a link, but the fence does not open it.

  The served text uses none of these.

### D2 — `/legal/*` public
- **The change** (`app_router.dart`): one new constant, `_publicDocumentRoutes = {'/legal/privacy', '/legal/terms'}`,
  and one more clause in `_atAuthRoute`.
  - Exact paths, not a `/legal` prefix, so any other `/legal/…` stays protected.
  - Signed in, nothing changes: neither path is in `_signedInLandingRedirects`.
- **Not touched:** every other route and guard, the route declarations, and the CW02 / CW07a / CW12a hunks (§4).

### D3 — no Figma frame
- **Interim styling:** the existing `AppType` scale and theme only, with no new token and no colour literal:

  | Element | Style |
  | --- | --- |
  | Document heading | `h2` |
  | Section heading | `h3` |
  | Body | `bodyMedium` in `textSecondary` |
  | Bold | `bodyMediumStrong` |
  | Table header | `labelLarge` |
  | Rules and table lines | the theme's Material divider role, `ColorScheme.outlineVariant` |

  It is recorded for the designer as DG-05, still NEW FRAME REQUIRED (`03_DESIGNER_HANDOFF.md` §11). It is not a
  designer-approved design.
- **Two physical package defaults were made directional for Arabic:**
  - Table cells were left-aligned in both languages and now start at the reading edge. Columns already run right to
    left.
  - List markers kept their gap on the right; it now faces the text.

### D4 — Terms §4 (subscriptions)
- **Rendering:** the served text is rendered faithfully, whatever it says.
- **No purchase surface:** the viewer adds no control of its own besides the back chip. A test pins this: no
  buttons and one tap target.
- **Terms §4 today** (summarised from the 2026-10-08 payload): it names the two subscriptions and states their
  account-bound rules. It has no price, link or call to action. Nothing conflicts with purchase silence, so there
  was nothing to report.

### C1 / C2 / C3
- **C1:** Login's "User Agreement" opens the Terms viewer (`/legal/terms`). "Privacy Policy" opens `/legal/privacy`.
  Both are pushed, so back returns to Login.
- **C2:** the Cookie Policy link is removed.
  - The clause goes with it, because claiming agreement to a document that does not exist is the misleading part.
  - The line now uses only existing fragments: `legalPrefix` + `userAgreement` + `legalAnd` + `privacyPolicy`.
  - The three `levelup.example` URLs and `url_launcher` are gone from Login.
  - `cookiePolicy` and `legalSeparator` stay in the ARBs for when a cookie document exists.
  - The links now carry link semantics.
  - **Still open:** product/legal approval of the resulting sentence in EN and AR (`DESIGN_ISSUES.md` #9 addendum),
    and the designer's redraw of `82:1086`.
- **C3:**
  - **Content shown:** the served `# ` heading is the visible title, rendered as part of the document. It is marked
    as a header and names the route for TalkBack. The bar has only the back chip, so there is no second visible
    title.
  - **Loading or failure:** the bar shows the existing "Privacy & policy" / "Terms & Conditions".
  - The payload is never edited.

## 3. Entry points

- **Signed out:** Login's two links lead to `/legal/terms` and `/legal/privacy`, and back returns to Login. A direct
  `go('/legal/…')` while signed out stays put.
- **Signed in:** the Profile rows (`profile_screen.dart`, unchanged) push the same routes, as before.

## 4. Files, by ownership (CW04a is its own change set)

**New, CW04a only:**
- `lib/features/legal/` — 6 files
- `lib/dev/mock_legal.dart`
- `test/features/legal/` — 4 files
- `test/dev/mock_backend_legal_test.dart`
- this report
- `cw04a_prewave/`

**Clean at HEAD before CW04a, so the whole diff is CW04a's:**
- `lib/features/account_shells/screens/legal_document_screen.dart` (rewritten)
- `lib/features/auth/screens/login_screen.dart` (+33 / −39)
- `pubspec.yaml` (+8)
- `pubspec.lock` (+16)
- `test/features/profile/profile_harness.dart` (+6)
- `test/features/settings/settings_harness.dart` (+6)

**Already modified by earlier waves; CW04a hunks measured against `cw04a_prewave/`:**

| File | CW04a part | Hunk isolation |
| --- | --- | --- |
| `lib/core/router/app_router.dart` | +13 / −2, **1 hunk** (`_publicDocumentRoutes`, `_atAuthRoute`) | Separate from every CW02 / CW07a / CW12a hunk at `-U3` (the nearest, CW02's imports, ends 5 lines above its context). The legal route declarations and the `LegalDocumentScreen` import are untouched. |
| `lib/dev/mock_backend.dart` | +13, 2 hunks | The legal hook sits alone before the reference block. The `import 'mock_legal.dart'` line joins the CW07a / CW12a import hunk, so staging it needs `git add -p` edit mode. That hunk already mixes those two waves. |
| `test/features/settings/shell_screens_test.dart` | +2 / −39, 5 hunks | The legal entries in the `shells` map sit next to CW12a's `/support` removal, so they share a hunk. The removed legal groups are separate. |
| `docs/DESIGN_ISSUES.md` | +10, 1 hunk (#9 addendum) | separate |
| `.ai/audits/current/completion/03_DESIGNER_HANDOFF.md` | +38, 1 hunk (§11, appended) | separate |
| `.ai/audits/current/completion/COMPLETION_STATE.md` | records | — |

**Moved out of the shell suite:** the legal routes left `shell_screens_test.dart` (7 tests). The viewer suites now
cover them; they are not shells any more.

**Not touched:** `contract/`, the ARBs and generated l10n, guards, tools, and every CW07a / CW12a / O-14 / O-15 file
other than the shared ones above.

## 5. Tests (CW04a)

| File | Tests | What it defends |
| --- | --- | --- |
| `test/features/legal/legal_document_screen_test.dart` | 47 | every state in EN and AR; the whole document in order and the heading as the one title (C3); heading semantics; RTL tables and markers; theme colours light/dark; literal HTML; no image, alt text kept (in a line, in a heading, with an unparsable address); a malformed table and a footnote in a heading do not crash; list numbers stay on one line and fit at 1.15× and 2.0× (EN, AR); the link fence on tap; no control but back; Retry shows loading; no auto-retry; language toggle refetch; 2.0× text on 320 dp with the bundled fonts (no overflow, scrolls to the last cell) |
| `test/features/legal/legal_routes_test.dart` | 14 | real router, signed out: User Agreement → Terms, Privacy → Privacy, back → Login (EN, AR); the line has two links, no Cookie Policy, the existing fragments in reading order (the sentence itself is not approved: O-16); links announced as links; direct signed-out access; `authRedirect` matrix (only the two exact paths public; 12 other routes still → `/login`; signed in unchanged); no `levelup.example` left in `lib/` |
| `test/features/legal/legal_repository_test.dart` | 23 | path and the single `language` parameter per document and language; strict decode (each missing field fails); typed failures passed on; the pinned contract still requires exactly the five fields; language mapping; the copy funnel EN/AR; Retry withheld only for unavailable; the link fence |
| `test/dev/mock_backend_legal_test.dart` | 5 | the mock's 200 is contract-shaped, labelled "not legal text", and carries every served construct; 400 outside the enums |
| (harness) `test/features/legal/legal_fixtures.dart` | — | the structural fixture (marker words, not legal text), scripted/quiet repositories, `holdLegalDocuments` |

**Mutation run (throwaway copy, 2026-10-10, after the review fixes):** 27 mutations, **27 caught**. The copy includes
`contract/`, and the unmutated copy passes 89 / 89 before and after. A first run of 22 mutations, before the review
fixes, also caught all 22. Failing tests per mutation:

| Mutation | Failing tests |
| --- | --- |
| router_not_public | 6 |
| router_prefix | 1 |
| login_ua_privacy | 2 |
| login_cookie_back | 2 |
| login_no_link_role | 2 |
| screen_double_title | 2 |
| screen_empty_shown | 2 |
| screen_offline_generic | 3 |
| copy_unavailable_generic | 4 |
| copy_retry_always | 3 |
| copy_rate_no_seconds | 5 |
| links_any_scheme | 3 |
| md_soft_break | 3 |
| md_tables_left | 2 |
| md_html_dropped | 1 |
| md_images_load | 2 |
| md_table_duplicate | 1 |
| md_heading_no_placeholder | 1 |
| md_heading_textcontent | 1 |
| md_indent_fixed | 3 |
| md_marker_wraps | 2 |
| md_link_unfenced | 1 |
| md_no_heading_semantics | 1 |
| provider_auto_retry | 6 |
| repo_no_language | 8 |
| model_lenient | 1 |
| mock_unlabelled | 4 |

## 6. Validation

Fresh runs on the final code, 2026-10-10. Records went to scratch (`LEVELUP_VALIDATE_OUT`); the tracked
`.ai/audits/current/test-results.md` is unchanged (blob `57716a44`).

| Check | Exit | Result |
| --- | --- | --- |
| `validate.sh` (20:11:41–20:17:04Z) | 0 | **3168 passed / 0 failed / 0 skipped**, OVERALL PASS; format 326 tracked files, 0 changed; analyze 0 issues |
| `validate.ps1` (20:17:04–20:22:15Z) | 0 | **3168 / 0 / 0**, OVERALL PASS; format 0 changed; analyze 0 |
| `dart format` on the 80 untracked `.dart` files (validate formats tracked files only) | 0 | 0 changed |
| `flutter analyze` (whole project) | 0 | no issues |
| `flutter gen-l10n` | 0 | no drift: the five l10n files are byte-identical before and after |
| Guards (`test/guards`) | 0 | 124 |
| `contract_models_test` / `contract_pin_test` | 0 / 0 | 14 / 2 |
| CW04a suites (viewer / routes / repository / mock) | 0 | 47 / 14 / 23 / 5 = 89 |
| NNA suites (refusal / school pick) | 0 | 35 / 16 |
| Support suite (`test/features/support`) | 0 | 472, unchanged |
| O-15 five-file suite | 0 | 125, unchanged |
| Settings suite (shells moved out) | 0 | `shell_screens_test.dart` 13 (was 20) |
| `git diff --check` | 0 | clean |

- **Counts:** 3168 = 3063 (the NNA gate) + 89 (CW04a) + 23 (NNA follow-ups: +7 refusal, +16 school pick) − 7 (legal
  shell tests moved out).
- **`pubspec.lock` notice:** both scripts flag that the lock differs from the committed one. That is the two new
  packages: commit `pubspec.lock` together with `pubspec.yaml` (the CI lockfile check needs both). `git diff
  pubspec.lock` is the 16 lines for `flutter_markdown_plus` 1.0.12 and `markdown` 7.3.1 only.
- **l10n blob ids, unchanged since before NNA (post-O-14):**

  | File | Blob |
  | --- | --- |
  | `app_en.arb` | `ae66b44c` |
  | `app_ar.arb` | `8c6f3f89` |
  | `app_localizations.dart` | `9795a74d` |
  | `app_localizations_en.dart` | `84085641` |
  | `app_localizations_ar.dart` | `5e18a63e` |
- **`contract/`:** untouched; pin 3.46.0-m1 (`eddb6ac`).
- **Not done:**
  - Pixel 8, iOS, TalkBack, VoiceOver
  - AVD walk
  - staging read
  - Figma
  - store readiness was not re-scored

## 7. Independent review

A read-only workflow: 4 Sonnet reviewers (NNA logic, CW04a safety and fidelity, routing and states, scope and
ownership) plus 1 skeptical verifier. 10 findings; the verifier confirmed 6, all fixed with tests; it rejected 4.

| # | Finding | Severity | Verdict | Disposition |
| --- | --- | --- | --- | --- |
| 1 | NNA: Start learning did nothing after the student backed out in flight and the refusal landed later | low | real | fixed: the refusal is restated on every tap; +2 tests (`NNA_REPORT.md` §10.4) |
| 2 | A second table syntax made the parser throw on a malformed table, taking the whole document down | high | real | fixed: one table syntax, swapped inside the extension set; test |
| 3 | A footnote mark inside a heading crashed the heading builder | medium | real | fixed: placeholder for heading text; test |
| 4 | List numbers of 10 or more wrapped at 1.15× and above | medium | real | fixed: the marker column grows with the text, one line; 6 tests |
| 5 | Alt text lost in a heading and with an unparsable address | low | real | fixed: an `img` builder; test |
| 6 | GFM drops extra cells, link-definition lines, moves footnotes | low | not a defect | standard Markdown semantics; recorded (§2 D1) |
| 7 | Ordered-list numerals regenerated | low | not a defect | standard; recorded |
| 8 | `http` / `www.` links drawn but not opened | low | not a defect | the owner's safe-link rule; recorded |
| 9 | Retry showed the old failure, not loading | low | real | fixed: `skipLoadingOnRefresh: false`; test |
| 10 | The report's hash section was a placeholder | low | not a defect (in progress) | §6 now carries the hashes |

The scope reviewer also confirmed by its own diffs that:
- the router change is only the CW04a hunk;
- the shared-file edits are CW04a-only;
- the lock delta is exactly the two packages;
- `contract/` is untouched.

## 8. Open items, risks and what was not done

- **Copy approval:** the Login sentence without the Cookie clause (EN + AR) is still to be approved by product/legal.
  The Arabic "و" stands apart, as it did before.
- **Design (DG-05):** viewer styles, the bar without a title, table behaviour on 320 dp, and Arabic tables.
  `03_DESIGNER_HANDOFF.md` §11 is a draft, not sent.
- **Contract (for Seif, not filed):** the contract says only "Markdown". The viewer shows HTML as literal text and
  never interprets it; a line in the contract saying no HTML or images are served would settle it. Who approved
  r4, and whether production serves the same version, is still open (S30 / E-2). The prod host `TBD.example`
  (`app_config.dart:54`) is CW18b.
- **Not built (out of scope):** the Terms acceptance step (CW04b: `getTermsAcceptance` / `acceptTerms`), the cookie
  document, an on-device cache or `If-None-Match`.
- **List numbering:** an ordered list is numbered by the package from its own start number, as "N." (a ")"
  delimiter would read as "."). The served text uses "1." only.
- **Not verified:** a staging read of the documents (public and read-only, but not run in this pass), Pixel 8, iOS,
  TalkBack (heading navigation, the link role on Login), VoiceOver, the AVD walk on `main_mock`, and Figma.
- **Store readiness:** not re-scored. Last recorded Play 44% / Apple 20%.

## 9. Git state at hand-back (2026-10-10T20:27Z)

- **Branch:** `merged` @ `b227f61`, level with `origin/merged` (0 / 0). Staged 0, stash 0. Nothing committed, pushed,
  merged, rebased, amended, reset, stashed or cleaned. Nothing sent to Seif or the designer.
- **Status:** 124 → **152 lines** (97 M, 55 ??). Of the 28 new lines, 17 are this pass and 11 are another session's (below).
- **This pass — newly modified (were clean at HEAD):**
  - NNA: `registration_draft.dart`, `registration_draft.freezed.dart`, `registration_controller.dart`
  - CW04a: `legal_document_screen.dart`, `login_screen.dart`, `pubspec.yaml`, `pubspec.lock`, `profile_harness.dart`,
    `settings_harness.dart`
- **This pass — new untracked:**
  - `lib/features/legal/`, `lib/dev/mock_legal.dart`, `test/features/legal/`, `test/dev/mock_backend_legal_test.dart`
  - `test/features/registration/school_pick_survives_return_test.dart`
  - this report, `cw04a_prewave/`, `nna2_prewave/`
- **This pass — already modified, now carrying more:**
  - `app_router.dart` (+ the CW04a hunk)
  - `mock_backend.dart` (+ the legal hook and import)
  - `shell_screens_test.dart` (legal routes moved out)
  - `registration_submit_notifier.dart`, `school_detail_screen.dart`, `signup_identity_screen.dart`,
    `registration_name_not_allowed_test.dart` (NNA)
  - `docs/KNOWN_BUGS.md`, `docs/DESIGN_ISSUES.md`, `03_DESIGNER_HANDOFF.md`, `COMPLETION_STATE.md`,
    `NNA_REPORT.md`, `CW04a_BRIEF.md`
- **Not this session's.** Between 20:13 and 20:23Z, during the final gate, another session changed:
  - modified: `CLAUDE.md`, `.claude/skills/seif-api-contract/SKILL.md`, `docs/AGENT_WORKFLOW.md`,
    `docs/DECISIONS.md`, `docs/ENVIRONMENTS.md`, `docs/PROJECT_GUIDE.md`, `docs/RISKS.md`, `docs/STORE_READINESS.md`
    and `docs/seif_fight.md`
  - new: `docs/BACKEND_HANDOFF.md` and `docs/SEIF_REPLY_2026-10-09.md`

  They were left untouched. None overlaps a file this pass edited (each of those still carries this pass's text,
  with this session's mtimes). `docs/ENVIRONMENTS.md` is read by `android_identity_test`, and it changed after the
  final gate, so the guards were re-run at 20:26Z: 124 / 124 pass.
- **Tracked `test-results.md`:** unchanged (`57716a44`).

## 10. Focused re-check (2026-10-11, owner instruction "Safe Follow-up: O-17, Final Focused Review, and Designer Handoff")

No CW04a code changed. A read-only Sonnet reviewer re-verified the viewer in the current tree, from the source and by
running the four test files: 47 / 14 / 23 / 5, all pass. Every claim holds:
- the real `getLegalDocument` call, with exactly the five required fields;
- only `/legal/privacy` and `/legal/terms` are public (exact paths; `/legal`, `/legal/cookies`, `/legal/user-agreement`
  and `/legal/terms/extra` still go to Login, and so do 12 other protected routes);
- every state, in EN and AR, with no automatic retry;
- raw HTML stays inert, no image loads, no WebView;
- only `https` (with a host) and `mailto` links open, outside the app, and nothing is logged;
- no invented legal text, the mock is labelled and reachable only from the mock entry point, and there is no purchase
  UI;
- `pubspec.yaml` and `pubspec.lock` agree: only the two packages were added, at 1.0.12 and 7.3.1.

**One correction, wording only.** The route test "the line has two links and no Cookie Policy, in the approved words"
and §5's row called the Login line's pieces "approved". Each string predates CW04a, but the sentence they make is not
approved: O-16 is pending (`O16_DECISION_NOTE.md`). The test is renamed "…from the existing fragments…" and §5 now
says so. The test body is unchanged.

**Findings recorded, not changed** (low or informational; none affects the served documents, which contain no HTML,
images or links):
1. **Inside an HTML block, the tags are literal but Markdown still applies.** `<div>**bold**</div>` shows `<div>`
   and `</div>` as text, but the words in between are bold, and a `[label](https://…)` inside becomes a link, which
   still passes the link fence. No words are lost; only the emphasis markers are consumed. §1's "literal characters"
   holds for the tags only. Changing it would mean showing the block as plain text (`md.Text`). That would be a
   CW04a code change, so it was not made in this pass.
2. A bare `http://` or `www.` address is drawn as a link but does nothing on tap. This is GFM autolinking plus the
   fence (§2 D1), and it is safe.
3. `app_en.arb`'s description of `legalNotPublished` still says no text has been supplied (S30). It is documentation
   only; changing it would regenerate the localization files, so it was left alone.
4. The repository tests stub Dio, so the HTTP 404 → `ApiException(legal_document_unavailable)` step is the existing
   generic `ErrorInterceptor`'s, which carries `code` through. It is not exercised end to end in the legal tests.
5. A served document without a leading `# ` heading would have no visible title, because the bar is empty once a
   document loads (C3). The contract promises the `# ` line.

**Fresh gate:** together with O-17; see `NNA_REPORT.md` §11.5.
