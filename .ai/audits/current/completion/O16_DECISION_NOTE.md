# O-16 — the Login consent sentence (decision note)

**Status: PENDING. Nothing here is approved.** The owner asked (2026-10-11) to keep O-16 open and to prepare the
evidence for review. The build keeps the current line in the meantime: it adds no words and links only to documents
that exist.

## 1. What the student sees now (uncommitted CW04a build)

| | Sentence as rendered | Links |
| --- | --- | --- |
| **English** (left to right) | By continuing, you agree to our **User Agreement** and **Privacy Policy** | "User Agreement" opens the Terms document (`/legal/terms`); "Privacy Policy" opens the Privacy document (`/legal/privacy`) |
| **Arabic** (right to left) | بالمتابعة، فإنك توافق على **اتفاقية المستخدم** و **سياسة الخصوصية** | the same two documents, in Arabic |

The bold words are the links. The line sits under the Login buttons (Figma `82:1086` in `82:819`).

**How this was captured:** a throwaway widget test in a scratchpad copy (not in the repo) opened the real Login
route, signed out, in English and in Arabic. It read the line's text pieces in order on 2026-10-10 (UTC). It found
exactly two links and the text direction shown above. This was a test render, not a phone.

## 2. Where each piece comes from

The sentence is four existing strings joined with single spaces (`login_screen.dart` `_LegalLine`, around line 377).
No string was written for it.

| Piece | Key | English | Arabic |
| --- | --- | --- | --- |
| Opening | `legalPrefix` | By continuing, you agree to our | بالمتابعة، فإنك توافق على |
| Link 1 | `userAgreement` | User Agreement | اتفاقية المستخدم |
| Joiner | `legalAnd` | and | و |
| Link 2 | `privacyPolicy` | Privacy Policy | سياسة الخصوصية |

Each string was in the app before CW04a (`app_en.arb:36-40`, `app_ar.arb:19-23`). The repo has no record of anyone
approving these four as one sentence. Two keys stay in the files, unused, for when a cookie document exists:
`cookiePolicy` and `legalSeparator`.

## 3. Earlier versions, for comparison

| Version | English | Arabic |
| --- | --- | --- |
| Figma `82:1086`. Quoted from `DESIGN_ISSUES.md` #9, read 2026-09-24; Figma was not reopened for this note. | By Continue to join or sign in, you agree to Level Up's User Agreement, Privacy Policy, and Cookie Policy. | none drawn |
| Last committed build (`b227f61`). Put together from the source, not rendered. | By continuing, you agree to our User Agreement, Privacy Policy and Cookie Policy | بالمتابعة، فإنك توافق على اتفاقية المستخدم، سياسة الخصوصية و سياسة ملفات تعريف الارتباط |
| Now (CW04a, uncommitted) | By continuing, you agree to our User Agreement and Privacy Policy | بالمتابعة، فإنك توافق على اتفاقية المستخدم و سياسة الخصوصية |

The committed Cookie Policy link went to a placeholder `levelup.example` address that never loaded. CW04a removed
the link and its clause on the owner's instruction (C2), because no cookie document exists.

## 4. What needs a decision

1. **English:** approve the sentence in §1, or supply new wording.
2. **Arabic:** approve the sentence in §1, or supply new wording. Points for the reviewer; these are observations,
   not proposals:
   - It is a word-for-word join of separate strings. Nobody wrote or reviewed it as one Arabic sentence.
   - "و" ("and") stands alone with a space on each side; it is usually written joined to the next word. The committed
     line spaced it the same way.
3. **The first link's label:** it says "User Agreement" but opens the Terms document. Once that document loads, its
   own heading is the page title (decision C3), so the two names can differ. Is "User Agreement" the right label?
4. **Cookies:** should the consent mention cookies at all? There is no cookie document today. The legal-documents
   endpoint serves only `terms` and `privacy`, so adding one needs legal text and backend support first.
5. The sentence is consent copy for students, many of them minors. Its wording is product/legal's call, not the
   build's (`DESIGN_ISSUES.md` #9).

## 5. The owner's options

- **A. Approve both sentences as they are.** Close O-16 and record who approved them and when; the designer
  redraws `82:1086` with two links (`03_DESIGNER_HANDOFF.md` §11).
- **B. Supply new English and Arabic wording.** It goes into the language files as new approved strings, with a
  small code change and test updates. A redraw follows.
- **C. Keep it pending (the current state).** The current line stays and nothing changes.

## 6. What this note does not change

- No code or language-file change was made for O-16. The only edits were record and test-name wording: the
  CW04a route test and report no longer call these pieces "approved".
- The legal documents from the server are shown as served (CW04a D4); nothing in them was edited, hidden or
  summarised.
- No cookie document or address was invented, and the placeholder address is not coming back.

**Pins:**
- `test/features/legal/legal_routes_test.dart` checks, in English and Arabic, that the line has two links, no Cookie
  Policy and the four pieces in reading order.
- The same file checks that no placeholder legal address is left in `lib/`.
