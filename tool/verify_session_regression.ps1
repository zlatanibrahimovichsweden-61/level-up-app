<#
Level Up - Wave 1 session-isolation regression proof (Tier-0 C-2).

    powershell -ExecutionPolicy Bypass -File tool\verify_session_regression.ps1

Answers the only question that matters about a regression test: **does it
actually fail against the bug it claims to catch?**

A regression test that passes against the broken code proves nothing. This
script proves it empirically:

  1. back up  lib/features/auth/notifier/auth_controller.dart
  2. restore the committed (pre-fix) version from HEAD  -> OLD behaviour
  3. run test/core/session/   -> MUST FAIL
  4. put the fixed file back
  5. run test/core/session/   -> MUST PASS

HEAD (e3651e6) predates the Tier-0 work, so its AuthController clears the
tokens, flips the auth state, and does nothing else - the exact bug.

SAFETY: the restore runs in a `finally` block, so the working copy is put back
even on an error or Ctrl-C. The backup is a plain file you can see and restore
by hand, not an entry on the git stash stack. The script verifies the restore by
comparing SHA-256 before exiting, and refuses to finish quietly if it fails.

Only `flutter test` is run. `dart format` is NOT run while the old file is in
place - HEAD's copy predates the tall-style reformat and would report a false
failure.
#>

$ErrorActionPreference = 'Continue'
$PSNativeCommandUseErrorActionPreference = $false

$root = (& git rev-parse --show-toplevel 2>$null)
if (-not $root) { $root = (Get-Location).Path }
Set-Location $root

$target = 'lib/features/auth/notifier/auth_controller.dart'
$backup = Join-Path ([System.IO.Path]::GetTempPath()) 'auth_controller.tier0.bak'
$suite  = 'test/core/session/'

function Ok   ($m) { Write-Host "  PASS  $m" -ForegroundColor Green }
function Bad  ($m) { Write-Host "  FAIL  $m" -ForegroundColor Red }
function Info ($m) { Write-Host "        $m" -ForegroundColor DarkGray }

if (-not (Test-Path $target)) { Write-Host "cannot find $target" -ForegroundColor Red; exit 1 }

# Pre-flight: a stale lock does not block this script any more (nothing here
# writes the index), but it WILL block the commit that follows, so say so now
# rather than letting it surface later as a confusing failure.
$lock = '.git/index.lock'
if (Test-Path $lock) {
    $age = (Get-Date) - (Get-Item $lock).LastWriteTime
    Write-Host ''
    Write-Host "  NOTE: $lock exists (age $([int]$age.TotalMinutes) min)." -ForegroundColor Yellow
    if ($age.TotalMinutes -gt 10) {
        Write-Host '  It is almost certainly stale - a git process was killed while holding it.' -ForegroundColor Yellow
        Write-Host '  This script does not need the index, so it will continue, but git commit' -ForegroundColor Yellow
        Write-Host "  will fail until you run:  Remove-Item $lock" -ForegroundColor Yellow
    } else {
        Write-Host '  It is recent - another git process may genuinely be running. Check before deleting.' -ForegroundColor Yellow
    }
}

Write-Host ''
Write-Host 'Wave 1 - session isolation regression proof' -ForegroundColor Cyan
Write-Host '============================================'
Write-Host ''

$originalHash = (Get-FileHash $target -Algorithm SHA256).Hash
Copy-Item $target $backup -Force
Info "backed up to $backup"
Info "sha256 $($originalHash.Substring(0,16))..."
Write-Host ''

$oldFailed = $false
$newPassed = $false
$restored  = $false

try {
    # --- OLD behaviour -------------------------------------------------------
    Write-Host '[1/2] OLD behaviour (AuthController from HEAD, no invalidation)'

    # `git show` READS a blob and never touches .git/index, so it cannot be
    # blocked by an index.lock and cannot leave one behind. `git checkout -- `
    # would do both: it writes the index, so a stale lock from any other tool
    # (an IDE indexing in the background, or a git process that was killed) aborts
    # this script before it can prove anything. That is not a hypothetical - it
    # is how this script failed the first time it was run.
    $oldSource = (& git show "HEAD:$target") -join "`n"
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($oldSource)) {
        throw "could not read HEAD:$target - is the file committed?"
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText(
        (Resolve-Path $target).Path, $oldSource + "`n", $utf8NoBom)

    if ((Get-FileHash $target -Algorithm SHA256).Hash -eq $originalHash) {
        throw 'HEAD version is identical to the working copy - the fix appears to be committed already. Point this script at the right baseline before trusting it.'
    }
    Info 'reverted to the committed pre-fix AuthController (read from HEAD, index untouched)'

    & flutter test $suite
    $oldRc = $LASTEXITCODE

    if ($oldRc -ne 0) {
        $oldFailed = $true
        Ok 'the suite FAILED against the old behaviour - the tests genuinely catch the bug'
    } else {
        Bad 'the suite PASSED against the old behaviour - THE TESTS PROVE NOTHING'
        Info 'They do not detect the leak. They must be strengthened, not accepted.'
    }
    Write-Host ''
}
finally {
    # --- restore, always -----------------------------------------------------
    Copy-Item $backup $target -Force
    $restoredHash = (Get-FileHash $target -Algorithm SHA256).Hash
    $restored = ($restoredHash -eq $originalHash)
    if ($restored) {
        Info "restored $target (sha256 verified)"
    } else {
        Write-Host ''
        Write-Host "  *** RESTORE FAILED ***" -ForegroundColor Red
        Write-Host "  Recover by hand:  Copy-Item '$backup' '$target' -Force" -ForegroundColor Red
    }
}

if (-not $restored) { exit 1 }

# --- NEW behaviour -----------------------------------------------------------
Write-Host '[2/2] NEW behaviour (Tier-0 fix in place)'
& flutter test $suite
$newRc = $LASTEXITCODE

if ($newRc -eq 0) {
    $newPassed = $true
    Ok 'the suite PASSED with the fix in place'
} else {
    Bad "the suite FAILED with the fix in place (exit $newRc)"
}

Remove-Item $backup -Force -ErrorAction SilentlyContinue

Write-Host ''
Write-Host '============================================'
Write-Host " old behaviour -> tests fail : $(if ($oldFailed) {'YES'} else {'NO'})"
Write-Host " new behaviour -> tests pass : $(if ($newPassed) {'YES'} else {'NO'})"
Write-Host " working copy restored       : $(if ($restored) {'YES'} else {'NO'})"
Write-Host '============================================'

if ($oldFailed -and $newPassed -and $restored) {
    Write-Host 'RESULT: VERIFIED - the regression tests genuinely protect against C-2' -ForegroundColor Green
    exit 0
}
Write-Host 'RESULT: NOT VERIFIED' -ForegroundColor Red
exit 1
