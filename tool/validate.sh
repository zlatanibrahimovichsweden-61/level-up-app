#!/bin/sh
# Level Up — full validation run (POSIX / macOS / Linux / Git Bash on Windows).
#
#   sh tool/validate.sh
#
# Windows users: prefer tool/validate.ps1. This script works under Git Bash but
# PowerShell gives better console colours and identical output.
#
# What it does: runs the whole quality gate, NEVER stopping at the first
# failure, and writes a single self-contained record to
#
#     .ai/audits/current/test-results.md
#
# That file is the evidence the audit package rests on. Paste it back verbatim;
# it carries the toolchain versions, so a reader can tell whether a failure is
# the code or the SDK.
#
# Exit code: 0 only if every step passed. Non-zero otherwise (so it can be
# wired into CI later without change).

# NOTE: deliberately NO `set -e`. The point of this script is to continue past
# failures and report all of them.
set -u

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root" || exit 1

# Report destination. Overridable so the pre-push hook can reuse this script
# without dirtying the committed evidence file on every push:
#   LEVELUP_VALIDATE_OUT=/tmp/x.md sh tool/validate.sh
out="${LEVELUP_VALIDATE_OUT:-.ai/audits/current/test-results.md}"
out_dir="$(dirname "$out")"
tmp="$(mktemp -d 2>/dev/null || echo "${TMPDIR:-/tmp}/levelup-validate.$$")"
mkdir -p "$out_dir" "$tmp" || exit 1

started="$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date)"
body="$tmp/body.md"
: > "$body"

fmt_status="SKIPPED"
ana_status="SKIPPED"
tst_status="SKIPPED"
ana_issues="?"
tst_pass="?"
tst_fail="?"
tst_skip="?"
overall=0

say() { printf '%s\n' "$*"; }
sec() { printf '\n## %s\n\n' "$*" >> "$body"; }
fence_open()  { printf '```%s\n' "${1:-text}" >> "$body"; }
fence_close() { printf '```\n' >> "$body"; }

say "Level Up validation -> $out"
say ""

# ---------------------------------------------------------------------------
# 0. Environment
# ---------------------------------------------------------------------------
say "[1/5] environment"
sec "1. Environment"
fence_open text
{
  printf 'started (UTC)  : %s\n' "$started"
  printf 'host os        : %s\n' "$(uname -s -r 2>/dev/null || echo unknown)"
  printf 'repo root      : %s\n' "$root"
  printf 'branch         : %s\n' "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
  printf 'commit         : %s\n' "$(git rev-parse --short HEAD 2>/dev/null || echo '?')"
  printf 'tree clean     : %s\n' "$(test -z "$(git status --porcelain 2>/dev/null)" && echo yes || echo 'NO — uncommitted changes present')"
  printf '.metadata rev  : %s\n' "$(sed -n 's/^  revision: "\(.*\)"/\1/p' .metadata 2>/dev/null | head -1)"
  printf 'pinned version : %s\n' "$(tr -d '[:space:]' < .flutter-version 2>/dev/null)"
} >> "$body"
fence_close

# The pin is the single source of truth CI reads too. A local SDK that differs
# means "works on my machine" is not evidence about CI, so say so loudly — but
# warn rather than fail: an SDK mismatch is a setup issue, not a code defect.
pinned="$(tr -d '[:space:]' < .flutter-version 2>/dev/null || echo '')"
local_v="$(flutter --version 2>/dev/null | sed -n 's/^Flutter \([0-9.]*\).*/\1/p' | head -1)"
if [ -n "$pinned" ] && [ -n "$local_v" ] && [ "$pinned" != "$local_v" ]; then
  say "  WARNING: local Flutter $local_v != pinned $pinned (.flutter-version)"
  printf '\n> **Local Flutter %s differs from the pin %s** (`.flutter-version`).\n' \
    "$local_v" "$pinned" >> "$body"
  printf '> CI builds on the pin, so these results may not predict CI.\n' >> "$body"
fi

# ---------------------------------------------------------------------------
# 1. Toolchain
# ---------------------------------------------------------------------------
say "[2/5] toolchain versions"
sec "2. Toolchain"
fence_open text
flutter --version >> "$body" 2>&1
printf '\n' >> "$body"
dart --version    >> "$body" 2>&1
fence_close

# ---------------------------------------------------------------------------
# 2. Dependencies
# ---------------------------------------------------------------------------
say "[3/5] flutter pub get"
sec "3. Dependencies (\`flutter pub get\`)"
fence_open text
flutter pub get >> "$body" 2>&1
pub_rc=$?
fence_close
if [ $pub_rc -ne 0 ]; then
  printf '\n**`pub get` FAILED (exit %s).** Everything below is unreliable.\n' "$pub_rc" >> "$body"
  overall=1
fi
if ! git diff --quiet -- pubspec.lock 2>/dev/null; then
  printf '\n> **pubspec.lock changed during `pub get`** — the committed lockfile does not\n' >> "$body"
  printf '> match what this SDK resolves. Commit the new lock or reconcile the SDK version.\n' >> "$body"
fi

# ---------------------------------------------------------------------------
# 3. Format
# ---------------------------------------------------------------------------
say "[4/5] dart format --set-exit-if-changed"
sec "4. Format (\`dart format --set-exit-if-changed --output=none\`)"
printf 'Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)\nis excluded — the generators format their own output.\n\n' >> "$body"

# NUL-delimited end to end. A bare `xargs` splits on whitespace, so a path
# containing a space becomes two nonexistent paths and the format check either
# errors confusingly or silently checks the wrong files. Wave 2 fixed exactly
# this in .githooks/pre-commit and missed it here, in the CANONICAL script that
# CI and the pre-push hook both depend on. `--` stops a file named `-x.dart`
# being read as an option. Guarded by test/guards/workflow_test.dart.
git ls-files -z '*.dart' \
  | grep -zZv -e '\.freezed\.dart$' -e '\.g\.dart$' \
  | grep -zZv -e '^lib/l10n/app_localizations' \
  > "$tmp/dartfiles.z" || true

# `wc -l` cannot count NUL-delimited records; count the terminators instead.
fmt_count="$(tr -dc '\0' < "$tmp/dartfiles.z" | wc -c | tr -d ' ')"

fence_open text
printf 'checking %s hand-written Dart files\n\n' "$fmt_count" >> "$body"
# Batched with -s. Under Git Bash `dart` is flutter/bin/dart, a bash script
# that execs dart.bat on MINGW, so every call goes through cmd.exe and its
# 8191-char command-line limit, far below the ~23k xargs assumes. One unbatched
# call over ~280 paths (~13k chars) died with "The command line is too long."
# and reported format FAIL on a fully formatted tree. Measured 2026-09-27:
# -s 8100 passes, -s 8200 fails; 7000 leaves headroom for a longer FLUTTER_ROOT,
# which dart.bat expands into the line twice.
#
# Batching must not hide a failure. xargs runs every batch and exits 123 if ANY
# of them exited 1-125 (124-127 for a batch that died or could not start), so a
# non-zero fmt_rc still means "some batch reported changes or errored". A shell
# loop over batches would keep only the LAST batch's status; do not write one.
xargs -0 -r -s 7000 dart format --output=none --set-exit-if-changed -- \
  < "$tmp/dartfiles.z" >> "$body" 2>&1
fmt_rc=$?
fence_close
if [ $fmt_rc -eq 0 ]; then
  fmt_status="PASS"
  printf '\nNo files need reformatting.\n' >> "$body"
else
  fmt_status="FAIL"
  overall=1
  printf '\n**Format check failed (exit %s).** Files listed above need `dart format`;\nany other output above is a batch that errored. Fix formatting with:\n\n' "$fmt_rc" >> "$body"
  # The hint must be as safe as the check it follows: NUL-delimited, the same
  # exclusions, and batched with the same -s. The old `dart format $(git
  # ls-files ...)` split paths on whitespace, missed the l10n exclusion, and on
  # Windows hit the same cmd.exe limit as the unbatched check did. Passed as a
  # %s argument so printf does not reinterpret its backslashes. The printed
  # text is code to the NUL-safety guard in test/guards/workflow_test.dart,
  # which is why it reads `xargs -0`.
  printf '```sh\n%s\n```\n' \
    "git ls-files -z '*.dart' | grep -zZv -e '\\.freezed\\.dart\$' -e '\\.g\\.dart\$' -e '^lib/l10n/app_localizations' | xargs -0 -r -s 7000 dart format --" \
    >> "$body"
fi

# ---------------------------------------------------------------------------
# 4. Analyze
# ---------------------------------------------------------------------------
say "[5/5] flutter analyze"
sec "5. Static analysis (\`flutter analyze\`)"
# Written to a log first, not piped: in POSIX sh `$?` after a pipeline is the
# LAST command's status, so `flutter analyze | tee` would report tee's success.
flutter analyze --no-pub > "$tmp/analyze.log" 2>&1
ana_rc=$?
fence_open text
cat "$tmp/analyze.log" >> "$body"
fence_close
if grep -q 'No issues found' "$tmp/analyze.log" 2>/dev/null; then
  ana_status="PASS"
  ana_issues="0"
else
  ana_issues="$(grep -oE '[0-9]+ issue' "$tmp/analyze.log" 2>/dev/null | tail -1 | grep -oE '[0-9]+' || echo '?')"
  if [ "$ana_rc" -eq 0 ]; then
    ana_status="PASS"
  else
    ana_status="FAIL"
    overall=1
  fi
fi

# ---------------------------------------------------------------------------
# 5. Tests
# ---------------------------------------------------------------------------
say "     flutter test --reporter=expanded"
sec "6. Tests (\`flutter test --reporter=expanded\`)"
printf 'Full suite, goldens included. Golden baselines were captured on Windows;\nif you are running this on Linux/macOS expect `test/goldens` to fail on pixel\ndifferences that are the platform, not the code.\n\n' >> "$body"

flutter test --no-pub --reporter=expanded > "$tmp/test.log" 2>&1
tst_rc=$?

# The expanded reporter's running counter is `+<passed> ~<skipped> -<failed>:`,
# the three parts in that fixed order with ~ and - INDEPENDENTLY optional.
#
# The 2026-09-12 defect read `-<failed>` as optional-directly-after `+<passed>`.
# On a real failing line - `00:16 +355 ~1 -1:` - the `~1 ` sits between them, so
# the failed count never matched and the summary said `0 failed` while one test
# had failed. The skipped count was never surfaced at all. The PowerShell twin
# carried the identical defect and is fixed the same way.
#
# Anchored on the timestamp that opens every counter line, so a `+7` printed
# inside a test name or an expectation diff cannot be mistaken for a tally.
last="$(grep -oE '^[[:blank:]]*[0-9]{2,}:[0-9]{2}[[:blank:]]*\+[0-9]+( ~[0-9]+)?( -[0-9]+)?' "$tmp/test.log" | tail -1)"
# Unanchored fallback, so an unexpected prefix degrades to a reading rather than
# to nothing. Still the corrected shape - never the pre-fix one.
[ -z "$last" ] && last="$(grep -oE '\+[0-9]+( ~[0-9]+)?( -[0-9]+)?' "$tmp/test.log" | tail -1)"
tst_pass="$(printf '%s' "$last" | grep -oE '\+[0-9]+' | tr -d '+')"
tst_skip="$(printf '%s' "$last" | grep -oE '~[0-9]+' | tr -d '~')"
tst_fail="$(printf '%s' "$last" | grep -oE '\-[0-9]+' | tr -d '-')"
[ -z "$tst_pass" ] && tst_pass="?"
[ -z "$tst_skip" ] && tst_skip="0"
[ -z "$tst_fail" ] && tst_fail="0"
# An unparseable tally must never read as "zero failures".
[ "$tst_pass" = "?" ] && tst_fail="?"

# The gate. The exit code stays authoritative and nothing here can make a
# failing run pass; these are additional ways to FAIL, never a way to PASS:
#   - a tally that reports failures even if the exit code somehow said 0
#   - a tally that could not be parsed ('?' is failure, never 0)
#   - a run that ended without the reporter's completion line, i.e. it crashed
#     or was cut short partway through
saw_completion=0
grep -qE 'All tests passed!|Some tests failed\.' "$tmp/test.log" && saw_completion=1

if [ "$tst_rc" -ne 0 ] || [ "$tst_fail" != "0" ] || [ "$tst_pass" = "?" ] \
   || [ "$saw_completion" -ne 1 ]; then
  tst_status="FAIL"
  overall=1
else
  tst_status="PASS"
fi

printf '**%s passed, %s failed, %s skipped** (exit %s)\n\n' "$tst_pass" "$tst_fail" "$tst_skip" "$tst_rc" >> "$body"

if [ "$tst_fail" != "0" ]; then
  printf '### Failing tests\n\n' >> "$body"
  fence_open text
  grep -E '\[E\]$' "$tmp/test.log" >> "$body" 2>/dev/null || printf '(could not extract names — see the full log below)\n' >> "$body"
  fence_close
fi

printf '\n### Full test output\n\n' >> "$body"
fence_open text
cat "$tmp/test.log" >> "$body"
fence_close

# ---------------------------------------------------------------------------
# Assemble: header + summary table on top, body underneath.
# ---------------------------------------------------------------------------
finished="$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date)"
{
  printf '# Validation run — %s\n\n' "$started"
  printf 'Produced by `tool/validate.sh`. Self-contained: everything needed to judge a\n'
  printf 'failure (toolchain, branch, commit, full output) is in this one file.\n\n'
  printf '| Step | Result | Detail |\n'
  printf '| --- | --- | --- |\n'
  printf '| `dart format` | **%s** | %s hand-written files checked |\n' "$fmt_status" "$fmt_count"
  printf '| `flutter analyze` | **%s** | %s issue(s) |\n' "$ana_status" "$ana_issues"
  printf '| `flutter test` | **%s** | %s passed / %s failed / %s skipped |\n' "$tst_status" "$tst_pass" "$tst_fail" "$tst_skip"
  printf '\n'
  if [ "$overall" -eq 0 ]; then
    printf '**OVERALL: PASS**\n'
  else
    printf '**OVERALL: FAIL** — see the failing sections below.\n'
  fi
  printf '\nStarted %s · finished %s\n' "$started" "$finished"
  printf '\n---\n'
  cat "$body"
} > "$out"

rm -rf "$tmp" 2>/dev/null

say ""
say "--------------------------------------------------"
say " format   : $fmt_status"
say " analyze  : $ana_status ($ana_issues issues)"
say " tests    : $tst_status ($tst_pass passed / $tst_fail failed / $tst_skip skipped)"
say "--------------------------------------------------"
if [ "$overall" -eq 0 ]; then say " OVERALL  : PASS"; else say " OVERALL  : FAIL"; fi
say ""
say "Written to $out — paste that file back."

exit "$overall"
