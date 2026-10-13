#!/usr/bin/env bash
# The Linux gate, for a Claude Code cloud session (or any Linux/macOS shell).
#
# Mirrors the `test` job of .github/workflows/ci.yml step for step: pub get,
# lockfile did not drift, localizations up to date, format (hand-written Dart
# only), analyze, then the whole suite EXCEPT goldens. Goldens are excluded on
# purpose: their .png baselines were captured on Windows and fail on Linux even
# when the code is right (dart_test.yaml). They run in CI's Windows job and in
# tool/validate.ps1 on the owner's machine.
#
# It writes nothing into the repository (unlike tool/validate.sh, which records
# .ai/audits/current/test-results.md and runs the goldens too).
#
# Usage: bash tool/cloud/check.sh            # full gate
#        bash tool/cloud/check.sh test/core  # same gate, tests limited to a path
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/../.." || exit 2
command -v flutter >/dev/null || { echo "flutter is not on PATH (see docs/CLOUD_SETUP.md)"; exit 2; }

fail=0
step() { printf '\n== %s\n' "$*"; }
bad() { echo "FAILED: $*"; fail=1; }

step "flutter pub get"
flutter pub get || bad "pub get"

step "lockfile did not drift"
git diff --quiet -- pubspec.lock || { git --no-pager diff --stat -- pubspec.lock; bad "pubspec.lock changed during pub get"; }

step "localizations are up to date"
if flutter gen-l10n; then
  git diff --quiet -- lib/l10n || { git --no-pager diff --stat -- lib/l10n; bad "lib/l10n is stale"; }
else
  bad "gen-l10n"
fi

step "format (hand-written Dart only)"
git ls-files -z '*.dart' \
  | grep -zZv -e '\.freezed\.dart$' -e '\.g\.dart$' -e '^lib/l10n/app_localizations' \
  | xargs -0 -r -s 7000 dart format --output=none --set-exit-if-changed -- \
  || bad "dart format (run the same pipeline without --output=none --set-exit-if-changed to fix)"

step "flutter analyze"
flutter analyze --no-pub || bad "analyze"

step "flutter test (goldens excluded)"
flutter test --no-pub --reporter expanded --exclude-tags golden "$@" || bad "tests"

if [ "$fail" -eq 0 ]; then echo; echo "LINUX GATE: PASS"; else echo; echo "LINUX GATE: FAIL"; fi
exit "$fail"
