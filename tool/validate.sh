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

out_dir=".ai/audits/current"
out="$out_dir/test-results.md"
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
} >> "$body"
fence_close

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

git ls-files '*.dart' \
  | grep -v -E '\.(freezed|g)\.dart$' \
  | grep -v -E '^lib/l10n/app_localizations' > "$tmp/dartfiles.txt"
fmt_count="$(wc -l < "$tmp/dartfiles.txt" | tr -d ' ')"

fence_open text
printf 'checking %s hand-written Dart files\n\n' "$fmt_count" >> "$body"
xargs dart format --output=none --set-exit-if-changed < "$tmp/dartfiles.txt" >> "$body" 2>&1
fmt_rc=$?
fence_close
if [ $fmt_rc -eq 0 ]; then
  fmt_status="PASS"
  printf '\nNo files need reformatting.\n' >> "$body"
else
  fmt_status="FAIL"
  overall=1
  printf '\n**Files above need `dart format`.** Fix with:\n\n' >> "$body"
  printf '```sh\ndart format $(git ls-files "*.dart" | grep -vE "\\.(freezed|g)\\.dart$")\n```\n' >> "$body"
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

# The expanded reporter's running counter is `+<passed> -<failed>:`. Take the
# last one it printed; that is the final tally.
last="$(grep -oE '\+[0-9]+( -[0-9]+)?' "$tmp/test.log" | tail -1)"
tst_pass="$(printf '%s' "$last" | grep -oE '\+[0-9]+' | tr -d '+')"
tst_fail="$(printf '%s' "$last" | grep -oE '\-[0-9]+' | tr -d '-')"
[ -z "$tst_pass" ] && tst_pass="?"
[ -z "$tst_fail" ] && tst_fail="0"

if [ "$tst_rc" -eq 0 ]; then
  tst_status="PASS"
else
  tst_status="FAIL"
  overall=1
fi

printf '**%s passed, %s failed** (exit %s)\n\n' "$tst_pass" "$tst_fail" "$tst_rc" >> "$body"

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
  printf '| `flutter test` | **%s** | %s passed / %s failed |\n' "$tst_status" "$tst_pass" "$tst_fail"
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
say " tests    : $tst_status ($tst_pass passed / $tst_fail failed)"
say "--------------------------------------------------"
if [ "$overall" -eq 0 ]; then say " OVERALL  : PASS"; else say " OVERALL  : FAIL"; fi
say ""
say "Written to $out — paste that file back."

exit "$overall"
