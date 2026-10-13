#!/usr/bin/env bash
# Installs the pinned Flutter SDK for a Claude Code cloud session (Ubuntu, x86_64).
#
# Two ways to run it, both cloud-only:
#   1. Environment "Setup script" (claude.ai/code environment settings): paste
#        bash "$CLAUDE_PROJECT_DIR/tool/cloud/setup.sh" || bash tool/cloud/setup.sh
#      or the self-contained snippet in docs/CLOUD_SETUP.md. A setup that
#      finishes in about five minutes is snapshotted and reused by later sessions.
#   2. Automatically, from tool/cloud/session_start.sh (the SessionStart hook in
#      .claude/settings.json) when no SDK is found.
#
# What it does, and nothing else:
#   - reads the version from .flutter-version (the single source of truth that
#     CI and tool/validate.* also read);
#   - shallow-clones that tag of github.com/flutter/flutter into $FLUTTER_HOME
#     (default /opt/flutter, else $HOME/flutter when /opt is not writable);
#   - lets the tool fetch its Dart SDK and test artefacts (storage.googleapis.com);
#   - turns analytics off; runs `flutter pub get` when called inside the repo.
# Both hosts are on the default "Trusted" network allowlist; pub.dev is too.
#
# It refuses to run outside a cloud session (CLAUDE_CODE_REMOTE != true) so it
# can never rewrite a developer's machine; LEVELUP_ALLOW_LOCAL_SETUP=1 overrides.
# Idempotent: an existing SDK at the pinned version is left alone. Exits non-zero
# only when the SDK cannot be installed (a failed setup script stops the session
# from starting, which is better than a session that silently has no SDK).
set -euo pipefail

log() { printf '[levelup-setup] %s\n' "$*" >&2; }

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ] && [ "${LEVELUP_ALLOW_LOCAL_SETUP:-}" != "1" ]; then
  log "not a cloud session (CLAUDE_CODE_REMOTE != true); nothing to do"
  exit 0
fi

repo="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$repo" ] || [ ! -f "$repo/.flutter-version" ]; then
  repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd || true)"
fi
version=""
if [ -n "$repo" ] && [ -f "$repo/.flutter-version" ]; then
  version="$(tr -d '[:space:]' < "$repo/.flutter-version")"
fi
version="${LEVELUP_FLUTTER_VERSION:-${version:-3.44.7}}"

if [ -z "${FLUTTER_HOME:-}" ]; then
  if mkdir -p /opt/flutter-probe 2>/dev/null && rmdir /opt/flutter-probe 2>/dev/null; then
    FLUTTER_HOME=/opt/flutter
  else
    FLUTTER_HOME="$HOME/flutter"
  fi
fi

# The SDK may be cloned by root (setup script) and used by another user (the
# session): git refuses "dubious ownership" and the flutter tool cannot read its
# own version. Scope the exception to the SDK checkout only.
git config --global --get-all safe.directory 2>/dev/null | grep -qxF "$FLUTTER_HOME" \
  || git config --global --add safe.directory "$FLUTTER_HOME"

have=""
if [ -x "$FLUTTER_HOME/bin/flutter" ]; then
  have="$(git -C "$FLUTTER_HOME" describe --tags --exact-match 2>/dev/null || true)"
fi
if [ "$have" != "$version" ]; then
  if [ -e "$FLUTTER_HOME" ]; then
    # Only ever replace something that is itself a Flutter checkout.
    if [ ! -x "$FLUTTER_HOME/bin/flutter" ] || [ ! -d "$FLUTTER_HOME/.git" ]; then
      log "ABORT: $FLUTTER_HOME exists and is not a Flutter SDK checkout; set FLUTTER_HOME elsewhere"
      exit 1
    fi
    log "replacing $FLUTTER_HOME (found '${have:-unknown}', want $version)"
    rm -rf "$FLUTTER_HOME"
  fi
  log "cloning Flutter $version into $FLUTTER_HOME"
  git clone --quiet --depth 1 --branch "$version" https://github.com/flutter/flutter.git "$FLUTTER_HOME"
fi
# Integrity: the framework commit published for this release
# (storage.googleapis.com/flutter_infra_release/releases/releases_linux.json,
# checked 2026-10-13; it equals the github tag).
case "$version" in
  3.44.7) expect=84fc5cbb223bc12f83d65b647ff8a56caf779ffd ;;
  *) expect="" ;;
esac
head_rev="$(git -C "$FLUTTER_HOME" rev-parse HEAD)"
if [ -n "$expect" ] && [ "$head_rev" != "$expect" ]; then
  log "ABORT: Flutter $version checkout is at $head_rev, expected $expect"
  exit 1
fi

export PATH="$FLUTTER_HOME/bin:$PATH"
export CI=true  # no interactive prompts from the flutter tool
flutter --disable-analytics >/dev/null 2>&1 || true
dart --disable-analytics >/dev/null 2>&1 || true
flutter --version   # first run downloads the Dart SDK
# Test artefacts (flutter_tester, fonts, sky_engine). Best effort: `flutter test`
# fetches whatever is still missing on first use.
flutter precache --universal --no-android --no-ios >/dev/null 2>&1 \
  || log "precache skipped (flutter test will fetch artefacts on first use)"

if [ -n "$repo" ] && [ -f "$repo/pubspec.yaml" ]; then
  log "flutter pub get in $repo"
  (cd "$repo" && flutter pub get)
fi
log "done: $(flutter --version 2>/dev/null | head -1)"
log "add to PATH: export PATH=\"$FLUTTER_HOME/bin:\$PATH\""
