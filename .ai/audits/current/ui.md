# Agent 3 — UI / Figma Fidelity

**Scope:** the residue of the design-fidelity process — every `TODO(design*)` /
`TODO(content)` / `TODO(legal)` marker, placeholder and unfinished UI reachable by a
user, golden-test coverage as regression insurance, cross-screen consistency (the
class of bug per-screen Figma extraction structurally cannot see), asset hygiene, and
state coverage against `.claude/skills/screen-states/SKILL.md`.

**Baseline:** dev @ e3651e6

**Repository areas inspected:**
`lib/core/router/app_router.dart` · `lib/core/theme/{app_colors,app_theme}.dart` ·
`lib/core/widgets/*` · all 24 files under `lib/features/*/screens/` · all 30 under
`lib/features/*/widgets/` · `lib/features/shell/main_shell.dart` ·
`test/goldens/*` · `pubspec.yaml` · `assets/**` ·
`docs/{DESIGN_ISSUES,ASSET_MANIFEST,day7b_design_fixes_brief}.md` ·
`.claude/skills/screen-states/SKILL.md`

**Method note:** no Figma frames were pulled. Every claim below is grounded in source.
Where the frame is the only arbiter (e.g. "is r15 vs r16 intentional?"), I read the
node id the code cites and report what the code asserts, not what the frame says.

---

## Headline

The design process here is unusually disciplined. Every placeholder is *deliberate,
documented, and refuses to invent data* — the `ShellBody` / `ComingSoonSection` /
`DisabledActionButton` family is a coherent, honest treatment of "no endpoint yet",
and I found **zero** grey-box or crash-on-missing-asset placeholders. Asset hygiene is
clean 1:1. The four registration pickers implement all four states correctly,
including empty-distinct-from-zero-items.

The real damage is in two narrow places: **one placeholder route the user can
actually reach through a paywall**, and **the Days 00–3 screens that the Day 7b
fidelity pass never revisited** — they still carry the pre-pass 24pt page inset, bare
`IconButton` back arrows, and hand-copied duplicates of widgets that were later
extracted to `core/widgets/`. Day 7b fixed sections A–D and stopped; the screens
before it drifted and stayed drifted.

---

## Findings

### F-3-01 [HIGH] [BUG] `/subscription` is user-reachable and lands on a dev placeholder

**Evidence:**
- `lib/core/router/app_router.dart:250` — `GoRoute(path: '/subscription', builder: (_, _) => const _Placeholder('Subscription'))`
- `lib/core/router/app_router.dart:339-350` — `_Placeholder` renders `AppBar(title: Text(title))` + `Center(child: Text('$title — not built yet'))`
- `lib/features/quiz/widgets/limit_sheet.dart:118-124` — the paywall sheet's **Upgrade** button: `Navigator.of(context).pop(); context.push('/subscription');`
- `lib/features/quiz/screens/quiz_setup_screen.dart:191-192` and `quiz_screen.dart:222-223` — `LimitSheet.show` fires on `weekly_question_limit_reached` / `subscription_required`

**Why it matters:** the Profile hub's Subscription row is correctly disabled
(`profile_screen.dart:244-249`, with the reasoning at :240-243), so the author
believed the route was unreachable. It is not. A free student who hits the weekly
question cap — the single most commercially important moment in the app — taps
"Upgrade" and gets a bare Material `AppBar` reading **"Subscription"** over the text
**"Subscription — not built yet"**. Both strings are hardcoded English: no `l10n`, so
an Arabic user gets Latin text in an LTR bar. No theme chrome, no back chip, none of
the `AppColors` treatment. This is the only place in the app where developer-facing
scaffolding is visible to an end user.

**Recommended fix:** point the Upgrade button at the same honest shell the rest of the
Account cluster uses — `ShellBody` + `TitledChrome` + a localized
`subscriptionUnavailable` string — or make it dismiss the sheet without navigating.
Delete `_Placeholder` once `/track-select` (F-3-12) goes with it.

**Risk of fixing:** low. `limit_sheet.dart` has no widget test asserting the push
target; `test/core/router/app_router_test.dart` should be checked for a `/subscription`
route assertion before the route is removed.

**Validation required:** confirm the `403` codes are actually returned by the mock
backend so the path can be walked (`lib/dev/mock_backend.dart`).

---

### F-3-02 [HIGH] [BUG] The login screen's three legal links open an unresolvable domain

**Evidence:**
- `lib/features/auth/screens/login_screen.dart:37-42` —
  `// TODO(legal): real legal URLs are TBD` then
  `'https://levelup.example/legal/user-agreement'`, `.../privacy`, `.../cookies`
- `lib/features/auth/screens/login_screen.dart:112` —
  `await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);`
- `lib/features/auth/screens/login_screen.dart:257-259` — all three wired into the
  "By continuing…" paragraph as live tap targets

**Why it matters:** `.example` is a reserved TLD that never resolves. This is not a
disabled control or an honest shell — it is a **live, tappable, styled link on the
first screen of the app** that kicks the student out to an external browser showing a
DNS failure. It is also the only `TODO(legal)` in the codebase, and
`DESIGN_ISSUES.md #9` marks it 🟡 with owner "Product/Legal" — i.e. blocked on nobody
in engineering, and drifting for that reason. Contrast `legal_document_screen.dart`,
which handles exactly the same missing-content problem correctly by saying so
(`l10n.legalNotPublished`).

**Recommended fix:** until real URLs exist, render the three phrases as non-tappable
text, or route them to `/legal/privacy` and `/legal/terms` — the in-app screens that
already exist and already say the document is not published.

**Risk of fixing:** low; `url_launcher` stays a dependency for other uses.

**Validation required:** product/legal must supply the URLs. Engineering can ship the
non-tappable form today without waiting.

---

### F-3-03 [MEDIUM] [BUG] The 35×35 back chip is forked four ways; two forks are the drift the shared widget was created to stop

**Evidence:**
- Canonical: `lib/core/widgets/circle_back_button.dart:15-61` — 35×35, `backChipFill`,
  `assets/icons/chevron.svg`, RTL-mirrored. Its own doc at :12-14 says it exists
  because the chip *"drifted into a bare `IconButton` on at least one of them once
  already."*
- Correct users: `titled_chrome.dart:66`, `edit_profile_screen.dart:139`,
  `signup_track_screen.dart:72`.
- **Fork 1** — `lib/features/catalog/widgets/catalog_scaffold.dart:82-100`: a
  hand-rolled 35×35 `Container` using `ext.cardFill` (**not** `ext.backChipFill`) and
  a Material `Icons.arrow_back_ios` at size 18 (**not** `chevron.svg` at 15×30). In
  dark these tokens differ: `cardFill` is `0x33232428` (20% alpha) vs `backChipFill`
  `0xFF232428` (opaque) — `app_colors.dart:504` vs `:548`. The chip is
  **semi-transparent on all four catalog screens** and opaque everywhere else.
- **Fork 2** — `lib/features/registration/widgets/registration_chrome.dart:21-25`: a
  bare `IconButton(Icon(Icons.arrow_back))`. Used by `school_detail_screen.dart:106`
  and `university_detail_screen.dart:97`.
- **Fork 3** — `lib/features/registration/screens/signup_identity_screen.dart:120-126`:
  a second bare `IconButton(Icon(Icons.arrow_back))`, inline.

**Why it matters:** this is precisely the class of bug per-screen Figma extraction
cannot see — each screen looks plausible alone. Fork 2 and 3 sit **between** two
screens that do use the chip (`/register/track` → `/register/school`), so the
affordance visibly changes shape mid-wizard. Fork 1 changes the chip's opacity on a
whole tab.

**Recommended fix:** replace all three with `CircleBackButton`.
`catalog_scaffold.dart:90`'s `TODO(design-asset)` dies in the same edit — the shared
widget already renders the real glyph.

**Risk of fixing:** low; check `test/features/catalog/*` and
`test/features/registration/*` for finders on `IconButton` / `Icons.arrow_back`.

---

### F-3-04 [MEDIUM] [BUG] Page inset is 20 app-wide but 24 on five pre-Day-7b screens — and `otp_screen.dart` contradicts itself

**Evidence:** the outliers, all `EdgeInsetsDirectional.fromSTEB(24, …, 24, …)`:
`login_screen.dart:133` · `otp_screen.dart:95` · `otp_screen.dart:230` ·
`signup_identity_screen.dart:112` · `school_detail_screen.dart:102` ·
`university_detail_screen.dart:93`.

The rule they break, stated in the code itself at
`lib/features/auth/screens/otp_screen.dart:373-375`:

```
// Figma puts this block at x17.5/w363 of 402; built at 20, the app-wide
// horizontal padding.
padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
```

**The same file uses 24 at :95/:230 and 20 at :375.** 20 is used by 14 other sites
across home, catalog ×6, profile ×2, settings, quiz ×4, onboarding, track picker.
`day7b_design_fixes_brief.md` C4 records the identical correction being made for the
track picker: *"Side inset is 20 in the frame, 24 in code."*

**Why it matters:** the Day 7b pass established 20 as frame truth and corrected one
screen. The five screens built in Days 00–3 were out of that day's scope and were
never revisited. Login → OTP → identity → detail is a contiguous four-screen run at
24, and the OTP *success* view inside that run jumps to 20 — a visible 4pt content
shift on a single screen transition.

**Recommended fix:** change the six sites to 20. Confirm against the Day 0–3 frames
first; if any of those frames genuinely specifies 24 this is design intent and should
be recorded in `DESIGN_ISSUES.md` instead.

**Risk of fixing:** trivial mechanically. Will invalidate no goldens (none cover these
screens — see F-3-07).

**Validation required:** the frames. This is the one finding where a Figma pull is
worth the tokens, because it is a single number on five nodes.

---

### F-3-05 [MEDIUM] [QUALITY IMPROVEMENT] `_OfflineBanner` is duplicated byte-for-byte in two screens

**Evidence:**
- Shared: `lib/core/widgets/offline_banner.dart:11-45`
- Copy 1: `lib/features/auth/screens/login_screen.dart:272-300`
- Copy 2: `lib/features/auth/screens/otp_screen.dart:136-166`

All three are identical: `Material(cs.errorContainer)` → `symmetric(horizontal: 16,
vertical: 10)` → `Icons.wifi_off` 18 → gap 8 → `l10n.offline` 14/w600.

**Why it matters:** this is the exact pattern `day7b_design_fixes_brief.md` B3 called
out and deleted for `_LanguagePill` — *"Fixing one and not the other is how this
drifts again."* The shared widget was extracted; these two copies survived because
Day 7b's scope was the pill, not the banner. Two screens now silently opt out of any
future change to the offline cue.

**Recommended fix:** delete both privates, import `core/widgets/offline_banner.dart`.

**Risk of fixing:** low; `test/features/auth/*` may find `_OfflineBanner` by private
type name.

---

### F-3-06 [MEDIUM] [QUALITY IMPROVEMENT] `FieldShell` is re-implemented inline four times

**Evidence:**
- Shared: `lib/core/widgets/form_fields.dart:61-72` — h60, `symmetric(horizontal: 14)`,
  `fieldFill`, `fieldBorder` @1.17, radius 20.
- `login_screen.dart:327-334` — same five values, hand-written.
- `signup_identity_screen.dart:244-252`, `:284-292`, `:329-337` — same five values ×3.

**Why it matters:** same drift class as F-3-05. The values agree *today*, which is
what makes it dangerous — a token change to `fieldBorder`'s width or the radius will
silently fix four fields and miss four others. Note `subjects_screen.dart:120-122`
deliberately does **not** use `FieldShell` and says why (56/r15 vs 60/r20, Figma
`337:5723`) — that one is a documented exception, not drift.

**Recommended fix:** wrap the four in `FieldShell`.

---

### F-3-07 [MEDIUM] [QUALITY IMPROVEMENT] Goldens cover 0% of RTL and 0% of text scaling, and nothing runs them

**Evidence:**
- `test/goldens/golden_harness.dart:69-73` — `goldenApp({..., Locale locale = const Locale('en')})`. The parameter exists; **no test passes anything but the default.**
- `test/goldens/design_goldens_test.dart:116` and `nav_bar_golden_test.dart:54` —
  `locale: const Locale('en')` hardcoded. The track-screen golden uses its own
  `MaterialApp.router` and does not take the harness's `locale` at all.
- Zero references to `textScaler` anywhere in `test/` or `lib/`.
- No `.github/` — goldens run only when a developer types `flutter test`.

**Why it matters:** Arabic is the project's stated baseline, not an edge case
(`_AGENT_CONTEXT.md`, and the `screen-states` skill devotes a third of its text to
RTL). The nine golden surfaces include `LanguagePill` (whose entire purpose is the
locale toggle), `CircleBackButton`'s mirrored chevron inside the track golden, and the
nav bar's notch — all three are RTL-sensitive, and none is captured in RTL. The
harness already supports it; the tests just never ask. Doubling the existing golden
count costs one `for` loop.

Second gap: goldens render in Inter. In Arabic the app falls back to Tajawal
(`app_theme.dart:47-48`), which has different metrics — so even the *spacing* the
harness doc (`golden_harness.dart:16-19`) says goldens exist to guard is unguarded in
the locale that matters most.

**Recommended fix:** add `for (final locale in ['en', 'ar'])` around the existing
loop; give the track-screen test the harness's locale. Then the top-10 below.

---

#### Top 10 candidates for new goldens, ranked by visual complexity × regression likelihood

| # | Widget | `file` | Why it earns a golden |
|---|---|---|---|
| 1 | `_TrackCard` **selected** state | `signup_track_screen.dart:180-250` | The one *invented* state in the app (day7b C2: "the frame only draws both cards unselected"). Gradient-border + `CustomPainter` + a state nobody has specced = the highest-churn pixels in the repo. Only the unselected state is captured. |
| 2 | `ProfileMenuRow` × 3 tones | `profile_menu_row.dart:59-135` | 10 instances on the Account tab; carries `chipped` disc / bare-glyph branching, a `Transform.flip` chevron, a 0.5px border and a disabled opacity. Six `TODO(design-asset)` glyphs land here — the golden is what makes swapping them safe. |
| 3 | `QuestionOptionTile` × 4 states | `question_option_tile.dart` (191 LOC) | idle / selected / correct / wrong, each with its own fill+border token pair that `app_colors.dart` deliberately keeps identical across canvases. Highest semantic cost of a regression: a wrong answer rendering green. |
| 4 | `FieldShell` × {enabled, error, disabled} | `form_fields.dart:61-95` | Every registration field. Border flips 1.17 → 1.5 and colour on error; disabled wraps in `Opacity(0.6)`. Four inline clones (F-3-06) make drift likely. |
| 5 | `CircleBackButton` in LTR **and** RTL | `circle_back_button.dart` | The `Transform.flip(flipX: !rtl)` logic is the single most bug-prone line in the theme layer, and F-3-03 shows the chip already forked three times. |
| 6 | `SettingsSection` with 3 rows + note | `settings_section.dart` + `settings_rows.dart` (230 LOC) | Clipped card, 0.5px dividers, disabled switches. Newest surface (Day 8 step 3), zero pixel coverage. |
| 7 | `HomeBanner` + `ComingSoonSection` | `home_banner.dart`, `coming_soon_section.dart` | Five of the seven blocks on Home. Both are placeholder-shaped, so a golden is what proves the placeholder still *looks* deliberate when the real content lands. |
| 8 | `AiExplanationPanel` | `ai_explanation_panel.dart` (154 LOC) | Radii 16.179 / 20.224 — hand-transcribed decimals nobody will ever notice regressing. |
| 9 | `SubjectCard` + `TreeListRow` | `subject_card.dart:32,69`, `tree_list_row.dart:54,61,96` | The Learn tab's entire visual surface. Carries `DESIGN_ISSUES #15/#16/#19` (8.56dp caption, unsupplied progress %, Arabic digits) — all three are pixel questions. |
| 10 | `ProfileHeaderCard` + `ProfileStatCard` | `profile_header_card.dart:39`, `profile_stat_card.dart:34` | The only two shadow-bearing surfaces outside `edit_profile`. `elevationShadow` is a `TODO(design)` *derived* value (`app_colors.dart:426`) — a golden pins what "derived" currently means so a later real value is a visible diff. |

---

### F-3-08 [MEDIUM] [BUG] `StateWidget`'s fallback branches render untranslated English

**Evidence:** `lib/core/widgets/state_widget.dart:36` `text: 'Empty'` · `:42`
`text: 'Offline'` · `:65` `child: const Text('Retry')` · `:40` renders
`messageKey` — a *localization key* — directly as user-facing text.

**Why it matters:** the class doc (`:8-9`) says the defaults are "deliberately plain"
because real screens override them, and today all four call sites
(`profile_screen.dart:73`, `edit_profile_screen.dart:72`, `catalog_states.dart:55`)
do override `empty`/`error`/`offline`. So this is **not user-visible today**. But it
is a loaded gun: the next screen that omits one argument ships raw English, and in the
`error` case ships the literal string `genericError` to a student. `catalog_states.dart:77-80`
explicitly notes `messageKey` "is a KEY, not user-facing copy" — the shared widget then
renders it as copy anyway.

**Recommended fix:** make `empty` / `error` / `offline` required, or resolve the key
through `AppLocalizations` in the fallback.

**Risk of fixing:** low — four call sites, all already passing the arguments.

---

### F-3-09 [LOW] [QUALITY IMPROVEMENT] Quiz screen loading is a bare spinner, against the project's own rule

**Evidence:** `lib/features/quiz/screens/quiz_screen.dart:100-103` —
`if (state is! QuizActive) return const Scaffold(body: Center(child: CircularProgressIndicator()));`

`.claude/skills/screen-states/SKILL.md`: *"Loading → skeleton/shimmer matching the
content layout (not a bare spinner)."*

**Why it matters:** barely. The comment at `:98-99` is correct — the `Quiz` is in hand
before the route is pushed, so this frame renders at most once and probably never.
Recorded for completeness because it is the only cell in the matrix below that fails
the rule outright.

---

### F-3-10 [LOW] [QUALITY IMPROVEMENT] `DESIGN_ISSUES.md`'s own grep list is stale

**Evidence:** `docs/DESIGN_ISSUES.md:529-537` lists four marker greps:
`TODO(design-asset)`, `TODO(design)`, `TODO(contract)`, `TODO(legal)`. The codebase
now also carries `TODO(content)` (`legal_document_screen.dart:19`) and
`TODO(deep-link)` (`app_router.dart:83`), neither of which the list finds.

**Why it matters:** this list is the project's own index of unfinished UI. An index
that misses two categories is how the legal-copy blocker (`seif_fight.md` S30, "a
milestone-1 blocker with no owner") stays invisible.

---

### F-3-11 [LOW] [OPTIONAL IMPROVEMENT] `.gitkeep` files ship in the app bundle

**Evidence:** `pubspec.yaml:95-98` declares `assets/images/`, `assets/icons/`,
`assets/icons/nav/`. Flutter bundles every file in a declared directory.
`assets/icons/.gitkeep` and `assets/images/.gitkeep` are both present on disk and both
now non-empty directories.

**Why it matters:** two zero-byte entries in the asset manifest. Cosmetic; noted only
because the directories are no longer empty so the files have no remaining purpose.

---

### F-3-12 [LOW] [BUG] `/track-select` is a dead route wired to the same English placeholder

**Evidence:** `lib/core/router/app_router.dart:128` —
`GoRoute(path: '/track-select', builder: (_, _) => const _Placeholder('Track select'))`.
Nothing in `lib/` navigates to it (grep of all `context.go`/`context.push` targets
returns no match). `day7b_design_fixes_brief.md` assumption 7 explicitly deferred it:
*"The orphan `/track-select` route at `app_router.dart:121` **stays** — out of scope
this day."*

**Why it matters:** not user-visible (unreachable, and the app has no deep-link
scheme registered — `TODO(deep-link)` at `:83`). It is dead weight that keeps
`_Placeholder` alive, which is what makes F-3-01 possible. Delete both together.

---

## Deliverable 1 — the 28 design/content/legal markers

17 `TODO(design)` · 6 `TODO(design-asset)` · 4 `TODO(content)` · 1 `TODO(legal)`,
counted by `grep -ro` and reconciled line-by-line. Of the 4 `TODO(content)` **only one
is an actual marker**; the other three are cross-references in prose
(`legal_document_screen.dart:15`, `profile_screen.dart:166`, `:253`) — worth knowing,
because the count overstates the work.

**Visible?** = does a user see something wrong or unfinished today.

| # | `file:line` | Kind | What is unresolved | Blocked on | Visible? | Sev |
|---|---|---|---|---|---|---|
| 1 | `login_screen.dart:37` | legal | 3 live links → unresolvable `levelup.example` | **Product/Legal** | **YES — first screen, live tap target** | **HIGH** |
| 2 | `legal_document_screen.dart:19` | content | approved AR+EN privacy & terms copy | **Nobody owns it** (seif_fight S30) | Yes — but *honestly*: screen says "not published" | MED |
| 3 | `profile_screen.dart:166` | content (ref) | doc-table cross-ref to #2 | — | No | — |
| 4 | `profile_screen.dart:253` | content (ref) | comment cross-ref to #2 | — | No | — |
| 5 | `legal_document_screen.dart:15` | content (ref) | doc-comment framing of #2 | — | No | — |
| 6 | `catalog_scaffold.dart:90` | design-asset | real back glyph; Material stands in | **Nobody — `chevron.svg` already in repo** | Yes — wrong glyph + wrong fill token on 4 screens (F-3-03) | MED |
| 7 | `home_banner.dart:15` | design-asset | banner artwork `337:5486` + slide source | Designer **+** product (no content endpoint) | Yes — themed box + `Icons.auto_stories_outlined`; reads as deliberate | LOW |
| 8 | `level_card.dart:77` | design-asset | per-level medallion set (12 @3x PNGs) | **Designer** (DESIGN_ISSUES #43, BLOCKED) | Yes — `Icons.emoji_events` 56px in `homeAccent` | LOW |
| 9 | `profile_header_card.dart:73` | design-asset | same medallion set, 24px instance | **Designer** — same blocker as #8 | Yes — same trophy glyph | LOW |
| 10 | `edit_profile_screen.dart:557` | design-asset | `fluent:edit-16-filled` pencil `170:4669` | **Designer** (in ASSET_MANIFEST, unexported) | Yes — `Icons.edit`, visually close | LOW |
| 11 | `profile_menu_row.dart:87` | design-asset | 10 per-row Iconify glyphs | **Designer** (in ASSET_MANIFEST, unexported) | Yes — 10 Material stand-ins on the Account tab | LOW |
| 12 | `app_colors.dart:103` | design | `cardFill` light: palette `#FDFDFD` vs frame `59:1439` `#FCFBF9` | **Nobody — frame value is known** | Yes, 1/255 per channel. Imperceptible | LOW |
| 13 | `app_colors.dart:453` | design | the value site for #12 | — | as #12 | LOW |
| 14 | `app_colors.dart:301` | design | `navShadow` blur/opacity read off filter bounds, not a token | **Designer** (DESIGN_ISSUES #37 Q2) | Yes — nav shadow may be wrong depth | LOW |
| 15 | `app_colors.dart:481` | design | `navShadow` light value site | Designer | as #14 | LOW |
| 16 | `app_colors.dart:542` | design | `navShadow` dark value site | Designer | as #14 | LOW |
| 17 | `main_shell.dart:150` | design | `_shadowOffsetY 4` / `_shadowSigma 10` — same open question | Designer | as #14 | LOW |
| 18 | `app_colors.dart:344` | design | `backChipFill` dark is a **fallback** — no dark frame | **Designer** (DESIGN_ISSUES #40) | Yes — the back chip on every dark Account screen | LOW |
| 19 | `app_colors.dart:548` | design | `backChipFill` dark value site | Designer | as #18 | LOW |
| 20 | `app_colors.dart:351` | design | `backChipGlyph` dark is a fallback (cream, for contrast) | Designer | as #18 | LOW |
| 21 | `app_colors.dart:549` | design | `backChipGlyph` dark value site | Designer | as #18 | LOW |
| 22 | `app_colors.dart:426` | design | `elevationShadow` dark **derived**, not measured — no dark frame for any of 5 components | **Designer** (DESIGN_ISSUES #47) | Yes — 5 shadows on the dark canvas render as a cream rim light | LOW |
| 23 | `app_colors.dart:557` | design | `elevationShadow` dark value site | Designer | as #22 | LOW |
| 24 | `profile_menu_row.dart:179` | design | chevron tint read off the render (`#7070A0`), node carries no bound variable | **Designer** (confirm the token) | Yes — 8 chevrons on the Account tab | LOW |
| 25 | `date_of_birth_field.dart:10` | design | DOB is in neither Figma frame; contract requires it | **Designer** (DESIGN_ISSUES #2) | Yes — a field the design does not draw | MED |
| 26 | `school_detail_screen.dart:123` | design | DOB call site, school track | Designer | as #25 | MED |
| 27 | `university_detail_screen.dart:114` | design | DOB call site, university track | Designer | as #25 | MED |
| 28 | `university_detail_screen.dart:203` | design | `governorateId` not in Figma; contract-required, must precede City | **Designer** (DESIGN_ISSUES #3) | Yes — a dropdown the design does not draw | MED |

**Reading of the table.** Three clusters, and they need three different escalations:

- **Blocked on the designer (14 markers, all LOW-visible):** the medallion set, the
  Profile glyph set, the nav shadow, and the three dark-canvas fallbacks. Every one
  renders a *reasonable* fallback. No grey boxes anywhere. This cluster is healthy —
  it is a design backlog, not an engineering defect.
- **Blocked on nobody (3 markers):** #6 (the chevron asset is already in the repo),
  #12/#13 (the frame value is known and written in the comment). These are 15-minute
  fixes that have been open since Day 7b because they fell outside its section list.
- **Contract-vs-design conflicts (4 markers, #25-28):** the app deliberately renders
  fields the design does not draw, because the contract requires them. Correctly
  handled and correctly documented. These will never close until the designer redraws
  the frames — they should be reclassified as `PRODUCT DECISION`, not left as TODOs
  that read like engineering debt.

---

## Deliverable 2 — placeholder / unfinished UI beyond the TODOs

| Surface | `file:line` | Reachable how | Verdict |
|---|---|---|---|
| `_Placeholder('Subscription')` | `app_router.dart:250`, `:339-350` | **Quiz paywall → Upgrade** (`limit_sheet.dart:123`) | **F-3-01 — HIGH** |
| `_Placeholder('Paymob return')` | `app_router.dart:251` | Deep link only; no scheme registered (`TODO(deep-link)` :83) | Unreachable |
| `_Placeholder('Track select')` | `app_router.dart:128` | Nothing navigates here | **F-3-12 — dead route** |
| `LeaderboardPlaceholderScreen` | `tab_placeholder.dart:42-48` | **Nav tab 2 — one tap** | Localized, themed, honest. Acceptable |
| `MessagePlaceholderScreen` | `tab_placeholder.dart:54-60` | **Nav tab 4 — one tap** | Same. Acceptable |
| `ComingSoonSection` ×4-5 | `home_screen.dart:85,95,103,105` | **Home, every session** | 4 of Home's 7 blocks. `coming_soon_section.dart:9-20` explains the refusal to render the frame's mock rows. Correct call |
| `_QuizUnavailableScreen` | `app_router.dart:309-336` | Cold deep-link to `/quiz/:id` | Deliberate, explained, offers a way out |
| `ShellBody` ×4 | `refer/support/friends/legal` screens | Profile hub rows (Friends: no entry point, by design) | The best-executed placeholder pattern in the repo |
| `Mistakes` button → snackbar | `subjects_screen.dart:96-100` | **Learn tab** | Renders enabled, does nothing but `SnackBar(comingSoon)`. Borderline — an enabled control that no-ops. Cf. `DisabledActionButton`, which the Account cluster uses for exactly this |
| `reviewQuestionsComingSoon` | `quiz_result_screen.dart:118,129` | After every quiz | Localized + explained. Fine |
| `🇪🇬` raw glyph | `login_screen.dart:338` | Login | Legitimately non-translatable. Not a finding |

**No `Placeholder()` widget, no empty `Container()`, no `SizedBox.shrink()` used as a
stand-in anywhere in `lib/`.** Grepped and confirmed.

---

## Deliverable 3 — consistency table

Values from source. `▲` marks an outlier I consider a fidelity bug; `=` marks a
difference I checked and found to be **design intent**, cited to a Figma node in the
code.

| Screen | H page pad | Section gap | Card radius | Button h | Field h | Section header | Back treatment |
|---|---|---|---|---|---|---|---|
| Onboarding `/` | 20 | 10/20 | 20 | 60 (theme) | — | — | none |
| Login `/login` | **24 ▲** | 8/16 | 20 | 60 | 60 (inline ▲) | — | none |
| OTP input `/otp` | **24 ▲** | 12/16/32 | 16 (pin) | 60 | 56 (pin) | — | `AppBar()` |
| OTP success | **20** (self-contradicts ▲) | 14/18 | 16 | 60 | — | — | none (correct) |
| Signup identity `/register` | **24 ▲** | 8/16 | 20 | 60 | 60 (inline ×3 ▲) | — | bare `IconButton` **▲** |
| Track picker `/register/track` | 20 | 16 | 25 = | 60 | — | — | `CircleBackButton` ✔ |
| School detail | **24 ▲** | 16/28 | 20 | 60 | 60 (`FieldShell`) | — | bare `IconButton` **▲** |
| University detail | **24 ▲** | 16/28 | 20 | 60 | 60 (`FieldShell`) | — | bare `IconButton` **▲** |
| Home `/home` | 20 | **25** | 15 | — | — | 18 / w700 | none (tab root) |
| Learn `/learn` | 20 | — | 10.7 / 15 = | 35 (Mistakes) | 56 = (search) | 22 / w600 | hand-rolled chip **▲** |
| Subject tree / chapters / lessons | 20 | — | 16 | — | — | 22 / w600 | hand-rolled chip **▲** |
| Quiz setup | 20 | 20 | 10 | 60 | — | 18 / w600 | `AppBar()` |
| Quiz | 20 | — | 16 / 52 | 60 | — | — | `AppBar` + `Icons.close` = |
| Quiz result | 20 | 16 | 16 | 60 | — | — | `AppBar` + guarded pop |
| Account `/account` | 20 | **16** / 20 | 15 = / 16 = | 60 | — | 18 / w500 rows | `AppBar` (tab root) |
| Edit profile | 20 | 16 | 20 | 60 | 60 (`FieldShell`) | 22 / w600 | `CircleBackButton` ✔ |
| Settings | 20 | **24** | 16 | — | — | 18 / w600 | `CircleBackButton` ✔ |
| Refer / Support / Friends / Legal | 24 (`ShellBody` centred) | — | 20 | 60 | — | 22 / w600 | `CircleBackButton` ✔ |
| Leaderboard / Message | — | 16 | — | — | — | — | `AppBar` |

**What the table says.**

1. **H page padding is the one clean outlier signal.** 20 appears on 14 sites across
   every feature; 24 appears on exactly the six pre-Day-7b sites listed in F-3-04, and
   `otp_screen.dart:375` names 20 as "the app-wide horizontal padding" while its own
   sibling views use 24. High confidence this is drift, not intent.
2. **Back treatment is the second.** Four implementations for one 35×35 Figma
   component — F-3-03.
3. **Button height 60 / radius 20 is perfectly consistent** — enforced from
   `app_theme.dart:57-66`'s `filledButtonTheme`, and `DisabledActionButton`
   (`shell_body.dart:94-100`) hand-matches it and says so at :69-70. No finding.
4. **Field height 60 / radius 20 / border 1.17 is consistent in value** but
   re-implemented four times (F-3-06). `subjects_screen.dart` deviates to 56/r15 and
   cites `337:5723` — verified intent.
5. **Card radius splits 15 vs 16 and this is NOT a bug.** Home's cards are r15
   (`level_card.dart:69`, `home_banner.dart:31`, `coming_soon_section.dart:61`,
   `profile_header_card.dart:39`); list-row surfaces are r16
   (`profile_menu_row.dart:59`, `settings_section.dart:56`, `profile_stat_card.dart:34`,
   `tree_list_row.dart:54`). Both values are Figma-cited at their sites, including the
   two that sit on the *same* Profile screen (`169:4609` r15 vs `661:8571` r16). I
   checked this specifically because it looked like the classic outlier and it is not.
6. **Vertical rhythm genuinely differs per screen** (Home 25, Settings 24, Profile 16,
   registration 16/28, quiz 20). Each traces to its own frame. I do not have grounds to
   call any of these drift, and will not manufacture one.
7. **Section-header treatment is bimodal and coherent:** 22/w600 = *screen title bar*
   (`titled_chrome.dart:58-62`, `catalog_scaffold.dart:70-73`,
   `edit_profile_screen.dart:131-135` — all three identical); 18/w600 = *in-page
   section* (`settings_section.dart:42-46`, `quiz_setup_screen.dart:101-105`;
   `coming_soon_section.dart:42-46` uses w700 — a one-widget deviation, too small to
   call). The one real issue here is that `TitledChrome` and `EditProfileChrome` are
   duplicate implementations of the same bar; `titled_chrome.dart:15-20` already
   documents this as deliberate-and-dated. Respecting that.

---

## Deliverable 4 — states matrix vs `screen-states/SKILL.md`

`✔` implemented · `n/a` state cannot occur (justify) · `✗` missing · `~` partial.
"Empty" is scored strictly: a `data` that is empty must produce a **distinct** empty
branch, not a blank Loaded.

| Screen | Loading | Empty | Error | Offline | Notes |
|---|---|---|---|---|---|
| Onboarding `/` | n/a | n/a | n/a | n/a | Static; no request |
| Login `/login` | ✔ inline | n/a | ✔ `:194-205` | ✔ banner + button disabled `:130,207` | Banner is a private copy (F-3-05) |
| OTP `/otp` | ✔ inline | n/a | ✔ `:274` mapped by code | ✔ `:90`, resend disabled `:122` | Same |
| Signup identity | ✔ submit spinner | n/a | ✔ `SubmitFailureBanner` | ✔ `:109` | |
| Track picker | n/a | n/a | n/a | ✔ `:62` | No fetch on this screen |
| School detail | ✔ per-picker | ✔ `reference_dropdown.dart:118` | ✔ `:113` | ✔ `:114` offline-vs-generic by type | **Model implementation.** All 4, per field |
| University detail | ✔ | ✔ | ✔ | ✔ | Same shared `ReferenceDropdown` |
| School picker sheet | ✔ | ✔ `school_picker_field.dart:226` | ✔ `:219` | ✔ `:221` | |
| Home `/home` | ✔ `_Skeleton` `:53,116` | **n/a** | ✔ retry `:55-58` | ✔ banner `:49` + `_Failure` `:183,200` | `/me` is one object — empty is not a reachable state |
| Leaderboard | ✗ | ✗ | ✗ | ✗ | Placeholder screen; 0/4 by design |
| Learn `/learn` | ✔ `_SubjectsSkeleton` | ✔ `isEmpty: (d) => d.isEmpty` `:67` | ✔ + scope-403 has **no** retry `catalog_states.dart:62-64` | ✔ `:66` | |
| Subject tree | ✔ | ✔ `:51` switch on track | ✔ | ✔ | |
| Chapters | ✔ | ✔ `:54` | ✔ | ✔ | |
| Lessons | ✔ | ✔ `:55` | ✔ | ✔ | |
| Message | ✗ | ✗ | ✗ | ✗ | Placeholder; 0/4 by design |
| Account `/account` | ✔ `_Skeleton` `:76` | n/a | ✔ `:77-81` | ✔ `:82-86` + banner `:71` | |
| Edit profile | ✔ `EditProfileChrome(_Skeleton)` | n/a | ✔ `:76` | ✔ `:83` | Chrome present in every state so the user can always leave |
| Settings | ~ Rank block only | n/a | ~ Rank block only | ✔ banner `:50` | **Deliberate** — `settings_screen.dart:33-36` explains why the page is not behind one `StateWidget` |
| Quiz setup | ✔ button spinner | n/a | ✔ inline `:127-137` | ✔ banner `:65` + disabled `:148` | |
| Quiz `/quiz/:id` | **~ bare spinner** `:101` | n/a | ✔ inline `:177,184` | ~ inline via `quizErrorMessage` → `l10n.offline`; **no banner** | F-3-09 |
| Quiz result | n/a | n/a | n/a | n/a | Renders entirely from `extra` |
| Subscription | ✗ | ✗ | ✗ | ✗ | **F-3-01** |
| Refer / Support / Friends / Legal | n/a ×4 | n/a ×4 | n/a ×4 | n/a ×4 | No request by design (`shell_body.dart:11-17`) |

**Verdict.** Every screen that *makes a request* implements all four states, and the
`empty ≠ zero-items` distinction the skill explicitly calls out is honoured everywhere
it can occur — all four catalog screens, all reference dropdowns, and the school search
sheet. This is stronger state coverage than most production Flutter apps.

The only genuine gaps are: the three placeholder/dev routes (0/4 each — F-3-01 is the
one that matters), the quiz screen's bare spinner and missing offline banner (F-3-09),
and Settings' partial coverage, which is argued for in the source and I accept.

**Not verifiable without running:** the AR/EN half of the skill's 8-cell rule. Every
screen uses `AppLocalizations` and `EdgeInsetsDirectional`, and both ARBs carry the
keys — but "renders correctly in RTL" is a pixel claim, and F-3-07 shows there is no
golden in `ar` to make it for me. **Under "Validation Required".**

---

## Deliverable 5 — asset hygiene

Compared `assets/**` on disk against `pubspec.yaml:94-98` and against every string
literal in `lib/` and `test/`.

| Check | Result |
|---|---|
| On disk, never referenced | **None.** All 13 SVGs resolve to a call site |
| Referenced, not on disk | **None.** All 10 `SvgPicture.asset` paths exist. No dynamic/interpolated paths anywhere — grep confirms every one is a literal |
| Near-duplicates | **None.** `chevron.svg` is correctly shared by `CircleBackButton` (flipped) and `profile_menu_row.dart:191` (flipped the other way), and both sites document the flip |
| Nested dirs declared | **Both.** `assets/icons/` **and** `assets/icons/nav/` are declared (`pubspec.yaml:96,98`). This is the recursion trap the file warns about and `day7b_design_fixes_brief.md:116-117` flags; it is correctly handled |
| Fonts | All 10 `.ttf` declared individually under `fonts:` (`:107-129`). `assets/fonts/` is *not* an asset dir, so `assets/fonts/README.md` is correctly excluded from the bundle |
| Dead weight | Two zero-byte `.gitkeep` files bundled (F-3-11) |

**No finding above LOW.** Asset hygiene is clean — which is worth stating plainly,
because `ASSET_MANIFEST.md` lists ~18 assets still to export and the natural assumption
would be that some are half-wired. None are: every unexported asset is a Material
stand-in with a `TODO(design-asset)` next to it, not a broken path.

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

- **RTL fidelity is unverified end-to-end.** Zero RTL goldens, zero
  `integration_test/`, no CI. The code reads RTL-clean (directional insets throughout,
  three separate deliberate chevron flips), but nothing *proves* it and nothing would
  catch a regression.
- **Text scaling is entirely unaddressed** — 0 `textScaler` references. Several
  surfaces are fixed-height with text inside: `home_banner.dart:26` (h140),
  `coming_soon_section.dart:57` (h96), `profile_header_card.dart:35` (h104),
  `form_fields.dart:62` (h60, 18pt text), `settings_rows.dart` (21/18 line height).
  At 1.3× system text scale these will overflow. Outside my scope to prove; flagged.
- **The medallion is blocked and will stay blocked.** DESIGN_ISSUES #43 has been open
  since Day 7b with two unanswered questions to the designer and one to Seif. It is
  the most visually significant unfinished element (Home's hero card + the Profile
  header), and nothing in the repo can unblock it.
- **`_Placeholder` will grow another user-reachable caller** unless it is deleted.
  It has already acquired one silently.

## Deferred Improvements

- Collapse `TitledChrome` / `EditProfileChrome` (`titled_chrome.dart:15-20` already
  dates and justifies the duplication — this is a note, not a finding).
- `subjects_screen.dart:96-100`'s enabled-but-inert Mistakes button should adopt the
  Account cluster's `DisabledActionButton` treatment.
- `coming_soon_section.dart:44` uses `w700` where every other in-page section header
  uses `w600`.

## Recommendations (ranked)

1. **F-3-01** — fix the `/subscription` paywall dead-end. One route, and it is on the
   revenue path.
2. **F-3-02** — make the three login legal links non-tappable, or point them at the
   in-app `/legal/*` screens that already exist. Today they eject a first-time user
   into a DNS error.
3. **F-3-03 + F-3-04** — one "finish Day 7b on Days 00–3" commit: six paddings 24→20,
   three back buttons → `CircleBackButton`. Small, mechanical, closes the largest
   consistency gap and kills one `TODO(design-asset)` for free.
4. **F-3-07** — wrap the existing golden loop in `for (final locale in ['en','ar'])`.
   Doubles pixel coverage into the locale that is the project's stated baseline, for
   roughly ten lines.
5. **F-3-05 + F-3-06** — delete the six duplicated widget bodies. Same drift the Day 7b
   brief already fought once.
6. **F-3-08** — make `StateWidget`'s `empty`/`error`/`offline` required.
7. Add goldens 1–3 from the ranked list (`_TrackCard` selected, `ProfileMenuRow`,
   `QuestionOptionTile`) — the three surfaces where a silent regression costs most.
8. **F-3-10 / F-3-11 / F-3-12** — housekeeping; bundle with any of the above.
9. Reclassify markers #25-28 from `TODO(design)` to a `PRODUCT DECISION` entry. They
   are not engineering debt and will never close as TODOs.
