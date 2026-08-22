# Wave 4 — Documentation + Audit Protocol

**Documentation only. Zero application code changed.** Verified by `git status`:
nothing under `lib/`, `test/` or `pubspec.*` was modified.

---

## What existed before

27 files in `docs/`, 26 in `.ai/audits/current/`. The audit found the problem was
not missing documentation — it was **no single place that said what is true now**.

| Problem | Evidence |
| --- | --- |
| No canonical project-state document | Wave status was spread across 4 Fable verdicts and 3 remediation reports |
| Frozen test counts presented as live | `ci.yml:52` ("806"), `ci.yml:127` ("792-case"), `PROJECT_GUIDE.md:96` ("~730") — actual 849 |
| A historical log readable as current state | `PROGRESS.md` carries dated counts with no banner saying so |
| An open Fable finding not in any risk register | **W3-1** existed only inside the Wave-3 verdict |
| A published claim that was factually wrong | 3C's "referenced in exactly three places" (W3-4) |
| No named ownership for blocked work | 3D and `/subscription` had reasons but no owner or next action |

**Not a problem, deliberately left alone:** the twelve `day*_brief.md` files and
the Wave 0–3 audit reports. They are dated records. Editing them to match today
would destroy the traceability the protocol depends on.

---

## Created

| File | Purpose |
| --- | --- |
| `docs/WAVE_STATUS.md` | **Single source of project truth.** Wave-by-wave status, the verification ladder, open findings, ratchets. Explicitly wins over any other document. |
| `docs/RISKS.md` | Active risk register. Eight live risks, each with impact, evidence, **owner**, next action, status. Closed risks listed separately with what closed them. |

## Updated

| File | Change |
| --- | --- |
| `docs/AGENT_WORKFLOW.md` | Canonical DISCOVER→…→NEXT WAVE loop with success and stop conditions per step; the DO-NOT-GUESS protocol (7 classes); Claude's autonomy boundaries and the stop-and-ask list; batch discipline |
| `docs/AUDIT_PROTOCOL.md` | The ten-item Fable handoff contract; "Fable verifies, never trusts"; severity weighting; the post-verdict loop |
| `docs/PROJECT_GUIDE.md` | Index now points at `WAVE_STATUS.md` and `RISKS.md` first; the validation contract and verification ladder added; stale "~730" removed |
| `docs/PROGRESS.md` | Banner marking it a **historical log**, with dated counts left intentionally unedited |
| `.github/workflows/ci.yml` | Two stale test counts removed from comments (W3-6) |
| `.ai/audits/current/wave3-implementation.md` | 3C record corrected (W3-4) — see below |

## Removed

None. No document was deleted. Two were reframed rather than rewritten
(`PROGRESS.md`, the 3C section), because deleting a wrong claim hides that it
was ever made.

---

## The correction I had to make about my own work (W3-4)

Wave 3 rejected the "ScreenState duplication" finding and supported it with:
*"`ScreenState` referenced in exactly three places."*

**That was wrong. It appears in 18 files.** The scan was
`grep -rn "ScreenState" lib | head -12` and I read a truncated result as a
complete one.

The **conclusion survives** — no screen `switch`es on `ScreenState`, so there is
nothing to centralise, and Fable independently confirmed the no-refactor verdict.
But it rested on a number that was not true.

Corrected in place with the original claim preserved and struck, not silently
edited. A wrong number that produced a right answer is still a wrong number, and
the next reader needs to know which half to trust.

---

## W3-1 — found open, deliberately NOT fixed

Fable's Wave-3 review raised **W3-1 (MEDIUM)**: `OtpNotifier.verify` calls
`ref.read(...)` after two `await`s, before the `_disposed` guard. This
contradicts Wave 3's own premise, stated in `edit_profile_notifier.dart` source,
that `ref` is dead after disposal.

**Both cannot be true.** Either the OTP path throws in exactly the scenario 3A
was written to fix, or `EditProfileNotifier` accepted a staleness cost for
nothing.

**Wave 4 did not touch it.** The brief is explicit that a bug found during
documentation work is recorded and reported, not silently patched — and the fix
direction genuinely depends on an unanswered question: `Ref.read`-after-dispose
semantics in `flutter_riverpod` 3.3.2. That is one pub-cache lookup the
developer can do and the audit environment cannot.

Recorded as **R-2 (OPEN, MEDIUM)** in `docs/RISKS.md` and under Open Findings in
`docs/WAVE_STATUS.md`.

---

## Wave 3D remains BLOCKED

Recorded in `WAVE_STATUS.md` in terms that resist a future wave marking it done:
the ratchet stays at **153**, the five unblocking inputs are named, and the
reason is externally confirmed — Figma defines one text style, bound to an
imported component, and no layer encodes a typographic role.

---

## Validation

Documentation-only. No application code changed, so **no behavioural change is
possible from this wave**. The suite should read exactly as it did before Wave 4.

Two edited files are not Markdown and are worth naming: `.github/workflows/ci.yml`
(comment text only — no step, trigger or command altered) and
`wave3-implementation.md` (an audit record). Neither is executed by the suite.
