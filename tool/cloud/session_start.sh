#!/usr/bin/env bash
# SessionStart hook (wired in .claude/settings.json). Cloud sessions only:
# in a local session (CLAUDE_CODE_REMOTE unset) it exits at once and changes
# nothing.
#
# In a Claude Code cloud session it makes sure the pinned Flutter SDK is
# installed (tool/cloud/setup.sh, idempotent and fast when the environment's
# setup script already did it), puts it on PATH for every later command through
# CLAUDE_ENV_FILE, and resolves dependencies. It never fails the session: a
# problem is reported and the session continues.
set -u
[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0

repo="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

if ! bash "$repo/tool/cloud/setup.sh" >&2; then
  echo "[levelup] Flutter SDK setup failed - see docs/CLOUD_SETUP.md (network access must allow github.com, storage.googleapis.com and pub.dev)."
  exit 0
fi

sdk=""
for d in "${FLUTTER_HOME:-}" /opt/flutter "$HOME/flutter"; do
  if [ -n "$d" ] && [ -x "$d/bin/flutter" ]; then sdk="$d"; break; fi
done
if [ -z "$sdk" ]; then
  echo "[levelup] Flutter SDK not found after setup - see docs/CLOUD_SETUP.md."
  exit 0
fi

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  grep -qxF "export PATH=\"$sdk/bin:\$PATH\"" "$CLAUDE_ENV_FILE" 2>/dev/null \
    || echo "export PATH=\"$sdk/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

version="$("$sdk/bin/flutter" --version 2>/dev/null | head -1)"
echo "Level Up cloud session: ${version:-Flutter} is on PATH ($sdk/bin). Gate: bash tool/cloud/check.sh (the CI Linux job; goldens excluded, they are Windows-only). Never run tool/*.ps1 here. See docs/CLOUD_SETUP.md."
exit 0
