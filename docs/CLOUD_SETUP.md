# Working on Level Up in a Claude Code cloud session

A cloud session (claude.ai/code, or `claude --cloud` from a terminal) runs on a fresh Ubuntu 24.04
x86_64 VM with the repository cloned from GitHub. It has Python 3, Node 22, Java 21, git and gh, but
**no Flutter, Dart, Android SDK or PowerShell**. This page is what makes the Flutter half work, and
what stays local. Facts about the cloud VM come from the Claude Code docs pages "Cloud environments"
and "Claude Code on the web" (checked 2026-10-13); re-check them there if behaviour differs.

Branch for cloud work: **`cld`**. It holds `merged` (b227f61) plus every change that was still
uncommitted on the owner's machine on 2026-10-13, as reviewable commits. See
`.ai/audits/current/completion/CLD_NON_DART_FILE_INVENTORY.md` for what it contains and what was left out.

## 1. One-time setup (owner)

1. **GitHub access.** The repository is private. A cloud session can work in it only when the Claude
   GitHub App is installed on it (claude.ai/code prompts for this), or after `/web-setup` connects
   your `gh` login.
2. **Network access.** Keep the environment's default, **Trusted**. It allows everything the setup
   needs: `github.com` (the Flutter SDK clone), `storage.googleapis.com` (the Dart SDK and test
   artefacts the Flutter tool downloads) and `pub.dev` (packages). `None` breaks the setup.
3. **Environment variables and secrets: none.** The test suite never calls a backend (mock desks in
   `lib/dev/`), the staging host is compiled into `lib/core/config/`, and nothing reads an API key.
   Do not put tokens, phone numbers or test-account details in the environment: every member who uses
   a shared environment can read its variables.
4. **Setup script (recommended).** In the environment settings, put this in **Setup script**. A setup
   that finishes in about five minutes is snapshotted and reused, so later sessions start with the
   SDK already installed. Keep `FLUTTER_VERSION` equal to `.flutter-version`.

   ```bash
   #!/bin/bash
   set -euo pipefail
   FLUTTER_VERSION=3.44.7            # = .flutter-version
   FLUTTER_HOME=/opt/flutter
   git config --global --add safe.directory "$FLUTTER_HOME"
   if [ "$(git -C "$FLUTTER_HOME" describe --tags --exact-match 2>/dev/null)" != "$FLUTTER_VERSION" ]; then
     rm -rf "$FLUTTER_HOME"
     git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_HOME"
   fi
   export PATH="$FLUTTER_HOME/bin:$PATH" CI=true
   flutter --disable-analytics || true
   flutter --version
   flutter precache --universal --no-android --no-ios || true
   ```

   Without it the session still works: the SessionStart hook below installs the SDK on first start
   (several minutes, not cached).

## 2. What the repository does on its own

- `.claude/settings.json` registers a **SessionStart hook**, `tool/cloud/session_start.sh`. In a
  local session it exits at once (`CLAUDE_CODE_REMOTE` is not `true`). In a cloud session it runs
  `tool/cloud/setup.sh` (installs the pinned SDK if missing, idempotent), puts `flutter` and `dart` on
  `PATH` for every later command through `CLAUDE_ENV_FILE`, and runs `flutter pub get`. It never fails
  the session; a problem is printed instead.
- `tool/cloud/setup.sh` reads the version from `.flutter-version`, clones that tag of
  `github.com/flutter/flutter` into `/opt/flutter` (else `~/flutter`) and checks the framework commit
  (3.44.7 = `84fc5cbb223bc12f83d65b647ff8a56caf779ffd`, the commit published in Flutter's
  `releases_linux.json`). It refuses to run outside a cloud session unless
  `LEVELUP_ALLOW_LOCAL_SETUP=1`.
- `CLAUDE.md`, `.claude/skills/` and the rest of the repository arrive with the clone. Personal
  `~/.claude` memory, skills and settings, `.claude/settings.local.json` and user-scope MCP servers
  do **not** reach a cloud session.

## 3. Start a session on `cld`

- **Browser:** claude.ai/code, pick the repository, then change its branch selector to `cld`.
- **Terminal:** in a checkout on branch `cld` that is pushed and clean, run `claude --cloud "<task>"`.
  The VM clones the GitHub remote at the current branch, not your local files.
- **Back to the terminal:** `claude --teleport` (the branch must be pushed; local git state clean).

## 4. Commands in the cloud

| Purpose | Command |
|---|---|
| The gate (= CI's Linux `test` job) | `bash tool/cloud/check.sh` |
| The same gate, tests limited to a path | `bash tool/cloud/check.sh test/features/auth` |
| One test file | `flutter test --no-pub test/core/session/session_isolation_test.dart` |
| Analyze only | `flutter analyze --no-pub` |
| Regenerate freezed / json output | `dart run build_runner build --delete-conflicting-outputs` (a FULL build; `--build-filter` deletes unrelated generated files) |
| Regenerate localizations | `flutter gen-l10n` |

`tool/cloud/check.sh` runs: `flutter pub get`, lockfile unchanged, `flutter gen-l10n` up to date,
`dart format` over hand-written Dart, `flutter analyze`, and `flutter test --exclude-tags golden`. It
writes nothing into the repository. **Goldens are excluded on purpose**: their PNG baselines were
captured on Windows and fail on Linux even when the code is right (`dart_test.yaml`); CI runs them in
its Windows job. So a cloud PASS is not the full `validate.ps1` result; the owner's Windows run is.

Do not run `tool/validate.sh` in the cloud: it runs the goldens (they fail on Linux) and rewrites the
tracked `.ai/audits/current/test-results.md`.

## 5. Not available in the cloud (local only)

| Needs | Why | Where it runs |
|---|---|---|
| Golden tests (`--tags golden`) | Windows baselines | `tool/validate.ps1` on Windows; CI Windows job |
| `tool/validate.ps1`, `tool/verify_guards.ps1`, `tool/verify_release_manifest.ps1`, `tool/verify_session_regression.ps1` | PowerShell 5.1 scripts; no `pwsh` on the VM | owner's Windows machine |
| Android builds, emulator, USB phone | no Android SDK; `dl.google.com` is not on the default allowlist; no devices | owner's machine (see `docs/ENVIRONMENTS.md`) |
| iOS | needs macOS and Xcode | a Mac |
| Figma | the Figma connector is the owner's; not configured for cloud sessions | owner's desktop / Chrome route |
| Signed-in staging checks | forbidden without the owner's explicit authorization (OTP, test accounts) | never from the cloud by default |

## 6. Rules that still apply

Everything in `CLAUDE.md`. In particular: the contract in `contract/` is vendored and pinned
(3.46.0-m1) and is never edited; no commit or push to `merged`, `main` or `dev` without the owner's
word; never log or commit personal data, phone numbers, OTP codes or tokens; generated files are
committed, so regenerate and commit them with their source.
