<#
Level Up - full validation run (Windows / PowerShell).

    pwsh -File tool\validate.ps1
    # or, from Windows PowerShell 5.1:
    powershell -ExecutionPolicy Bypass -File tool\validate.ps1

The POSIX twin is tool/validate.sh; the two produce the same artefact.

What it does: runs the whole quality gate, NEVER stopping at the first failure,
and writes one self-contained record to

    .ai/audits/current/test-results.md

That file is the evidence the audit package rests on. Paste it back verbatim -
it carries the toolchain versions, so a reader can tell whether a failure is
the code or the SDK.

Exit code: 0 only if every step passed.

Note on goldens: the baselines in test/goldens were captured on Windows, so
this script runs them. They are expected to PASS here and expected to FAIL on a
Linux CI runner - that is the platform, not the code. See .github/workflows/ci.yml.
#>

$ErrorActionPreference = 'Continue'   # deliberate: continue past failures
$PSNativeCommandUseErrorActionPreference = $false

# --- locate repo root --------------------------------------------------------
$root = (& git rev-parse --show-toplevel 2>$null)
if (-not $root) { $root = (Get-Location).Path }
Set-Location $root

# Report destination. Overridable so the pre-push hook can reuse this script
# without dirtying the committed evidence file on every push:
#   $env:LEVELUP_VALIDATE_OUT = 'C:\temp\x.md'; .\tool\validate.ps1
$out = $env:LEVELUP_VALIDATE_OUT
if (-not $out) { $out = Join-Path $root '.ai/audits/current/test-results.md' }
$outDir = Split-Path -Parent $out
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$started  = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$body     = New-Object System.Text.StringBuilder

function Sec  ($t) { [void]$body.AppendLine("`n## $t`n") }
function Line ($t) { [void]$body.AppendLine($t) }
function Fence($t = 'text') { [void]$body.AppendLine('```' + $t) }
function Unfence { [void]$body.AppendLine('```') }
function Say  ($t) { Write-Host $t }

$fmtStatus = 'SKIPPED'; $anaStatus = 'SKIPPED'; $tstStatus = 'SKIPPED'
$anaIssues = '?';       $tstPass   = '?';       $tstFail   = '?'
$tstSkip   = '?'
$overall   = 0

Say "Level Up validation -> $out"
Say ''

# --- 1. environment ----------------------------------------------------------
Say '[1/5] environment'
Sec '1. Environment'
Fence
$branch = (& git rev-parse --abbrev-ref HEAD 2>$null); if (-not $branch) { $branch = '?' }
$commit = (& git rev-parse --short HEAD 2>$null);      if (-not $commit) { $commit = '?' }
$porcelain = (& git status --porcelain 2>$null)
$clean = if ([string]::IsNullOrWhiteSpace(($porcelain -join ''))) { 'yes' } else { 'NO - uncommitted changes present' }
$metaRev = ''
if (Test-Path '.metadata') {
  $m = Select-String -Path '.metadata' -Pattern '^\s*revision:\s*"(.*)"' | Select-Object -First 1
  if ($m) { $metaRev = $m.Matches[0].Groups[1].Value }
}
Line ("started (UTC)  : {0}" -f $started)
Line ("host os        : {0}" -f [System.Environment]::OSVersion.VersionString)
Line ("powershell     : {0}" -f $PSVersionTable.PSVersion)
Line ("repo root      : {0}" -f $root)
Line ("branch         : {0}" -f $branch)
Line ("commit         : {0}" -f $commit)
Line ("tree clean     : {0}" -f $clean)
Line (".metadata rev  : {0}" -f $metaRev)

# The pin is the single source of truth CI reads too (.flutter-version). A local
# SDK that differs means "works on my machine" is not evidence about CI. Warn
# rather than fail: a version mismatch is a setup issue, not a code defect.
$pinned = ''
if (Test-Path '.flutter-version') {
  $pinned = (Get-Content '.flutter-version' -Raw).Trim()
}
Line ("pinned version : {0}" -f $pinned)
Unfence

$localV = ''
$vOut = (& flutter --version 2>&1) -join "`n"
if ($vOut -match 'Flutter\s+([0-9]+\.[0-9]+\.[0-9]+)') { $localV = $Matches[1] }
if ($pinned -and $localV -and ($pinned -ne $localV)) {
  Say "  WARNING: local Flutter $localV != pinned $pinned (.flutter-version)"
  Line ''
  Line "> **Local Flutter $localV differs from the pin $pinned** (``.flutter-version``)."
  Line '> CI builds on the pin, so these results may not predict CI.'
}

# --- 2. toolchain ------------------------------------------------------------
Say '[2/5] toolchain versions'
Sec '2. Toolchain'
Fence
(& flutter --version 2>&1) | ForEach-Object { Line $_ }
Line ''
(& dart --version 2>&1)    | ForEach-Object { Line $_ }
Unfence

# --- 3. dependencies ---------------------------------------------------------
Say '[3/5] flutter pub get'
Sec '3. Dependencies (`flutter pub get`)'
Fence
(& flutter pub get 2>&1) | ForEach-Object { Line $_ }
$pubRc = $LASTEXITCODE
Unfence
if ($pubRc -ne 0) {
  Line ''
  Line "**``pub get`` FAILED (exit $pubRc).** Everything below is unreliable."
  $overall = 1
}
& git diff --quiet -- pubspec.lock 2>$null
if ($LASTEXITCODE -ne 0) {
  Line ''
  Line '> **pubspec.lock changed during `pub get`** - the committed lockfile does not'
  Line '> match what this SDK resolves. Commit the new lock or reconcile the SDK version.'
}

# --- 4. format ---------------------------------------------------------------
Say '[4/5] dart format --set-exit-if-changed'
Sec '4. Format (`dart format --set-exit-if-changed --output=none`)'
Line 'Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)'
Line 'is excluded - the generators format their own output.'
Line ''

$dartFiles = @(& git ls-files '*.dart') |
  Where-Object { $_ -notmatch '\.(freezed|g)\.dart$' } |
  Where-Object { $_ -notmatch '^lib/l10n/app_localizations' }
$fmtCount = $dartFiles.Count

Fence
Line ("checking {0} hand-written Dart files" -f $fmtCount)
Line ''
# Chunked: a single command line with ~180 paths can exceed the Windows limit.
$fmtRc = 0
for ($i = 0; $i -lt $dartFiles.Count; $i += 60) {
  $chunk = $dartFiles[$i..([Math]::Min($i + 59, $dartFiles.Count - 1))]
  (& dart format --output=none --set-exit-if-changed @chunk 2>&1) | ForEach-Object { Line $_ }
  if ($LASTEXITCODE -ne 0) { $fmtRc = 1 }
}
Unfence
if ($fmtRc -eq 0) {
  $fmtStatus = 'PASS'
  Line ''
  Line 'No files need reformatting.'
} else {
  $fmtStatus = 'FAIL'; $overall = 1
  Line ''
  Line '**Files above need `dart format`.** Fix with:'
  Line ''
  Line '```powershell'
  Line '$f = git ls-files "*.dart" | Where-Object { $_ -notmatch "\.(freezed|g)\.dart$" }'
  Line 'dart format @f'
  Line '```'
}

# --- 5. analyze --------------------------------------------------------------
Say '[5/5] flutter analyze'
Sec '5. Static analysis (`flutter analyze`)'
$analyzeLog = (& flutter analyze --no-pub 2>&1)
$anaRc = $LASTEXITCODE
Fence
$analyzeLog | ForEach-Object { Line $_ }
Unfence
$analyzeText = ($analyzeLog -join "`n")
if ($analyzeText -match 'No issues found') {
  $anaStatus = 'PASS'; $anaIssues = '0'
} else {
  $m = [regex]::Matches($analyzeText, '(\d+)\s+issue')
  if ($m.Count -gt 0) { $anaIssues = $m[$m.Count - 1].Groups[1].Value }
  if ($anaRc -eq 0) { $anaStatus = 'PASS' } else { $anaStatus = 'FAIL'; $overall = 1 }
}

# --- 6. tests ----------------------------------------------------------------
Say '      flutter test --reporter=expanded'
Sec '6. Tests (`flutter test --reporter=expanded`)'
Line 'Full suite, goldens included. The golden baselines were captured on Windows,'
Line 'so they are expected to pass here. On a Linux/macOS runner they fail on pixel'
Line 'differences that are the platform, not the code.'
Line ''

$testLog = (& flutter test --no-pub --reporter=expanded 2>&1)
$tstRc = $LASTEXITCODE
$testText = ($testLog -join "`n")

# The expanded reporter's running counter is "+<passed> ~<skipped> -<failed>:",
# the three parts in that fixed order with ~ and - INDEPENDENTLY optional.
#
# The 2026-09-12 defect read "-<failed>" as optional-directly-after "+<passed>".
# On a real failing line - "00:16 +355 ~1 -1:" - the "~1 " sits between them, so
# the failed group never matched and the summary reported "0 failed" while one
# test had failed. OVERALL was still FAIL (it keys off the exit code), so the
# gate held and only the human-readable line lied. The skipped count was never
# surfaced at all, in passing or failing runs.
#
# Anchored on the timestamp that opens every counter line, so a "+7" printed
# inside a test name or an expectation diff cannot be mistaken for a tally.
# Deliberately free of inline (?m) and of \d so the pattern string stays
# portable: test/guards/validate_reporting_test.dart extracts THIS literal and
# runs it against sample reporter output. The rule is mechanised, not prose.
$counterPattern = '^[ \t]*[0-9]{2,}:[0-9]{2}[ \t]*\+([0-9]+)(?:[ \t]*~([0-9]+))?(?:[ \t]*-([0-9]+))?'
$counters = [regex]::Matches($testText, $counterPattern,
                             [System.Text.RegularExpressions.RegexOptions]::Multiline)
if ($counters.Count -eq 0) {
  # Unanchored fallback, so an unexpected prefix degrades to a reading rather
  # than to nothing. Still the corrected shape - never the pre-fix one.
  $counters = [regex]::Matches($testText,
    '\+([0-9]+)(?:[ \t]*~([0-9]+))?(?:[ \t]*-([0-9]+))?')
}
if ($counters.Count -gt 0) {
  $last = $counters[$counters.Count - 1]
  $tstPass = $last.Groups[1].Value
  $tstSkip = if ($last.Groups[2].Success) { $last.Groups[2].Value } else { '0' }
  $tstFail = if ($last.Groups[3].Success) { $last.Groups[3].Value } else { '0' }
} else { $tstPass = '?'; $tstSkip = '?'; $tstFail = '?' }

# The gate. The exit code stays authoritative and nothing here can make a
# failing run pass; these are additional ways to FAIL, never a way to PASS:
#   - a tally that reports failures even if the exit code somehow said 0
#   - a tally that could not be parsed ('?' is treated as failure, never as 0)
#   - a run that ended without the reporter's completion line, i.e. it crashed
#     or was cut short partway through
$sawCompletion = ($testText -match 'All tests passed!') -or
                 ($testText -match 'Some tests failed\.')
if     ($tstRc -ne 0)        { $tstStatus = 'FAIL'; $overall = 1 }
elseif ($tstFail -ne '0')    { $tstStatus = 'FAIL'; $overall = 1 }
elseif ($tstPass -eq '?')    { $tstStatus = 'FAIL'; $overall = 1 }
elseif (-not $sawCompletion) { $tstStatus = 'FAIL'; $overall = 1 }
else                         { $tstStatus = 'PASS' }

Line ("**{0} passed, {1} failed, {2} skipped** (exit {3})" -f $tstPass, $tstFail, $tstSkip, $tstRc)
Line ''
if ($tstFail -ne '0') {
  Line '### Failing tests'
  Line ''
  Fence
  $failing = $testLog | Where-Object { $_ -match '\[E\]\s*$' }
  if ($failing) { $failing | ForEach-Object { Line $_ } }
  else { Line '(could not extract names - see the full log below)' }
  Unfence
}
Line ''
Line '### Full test output'
Line ''
Fence
$testLog | ForEach-Object { Line $_ }
Unfence

# --- assemble ----------------------------------------------------------------
$finished = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$head = New-Object System.Text.StringBuilder
[void]$head.AppendLine("# Validation run - $started")
[void]$head.AppendLine('')
[void]$head.AppendLine('Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a')
[void]$head.AppendLine('failure (toolchain, branch, commit, full output) is in this one file.')
[void]$head.AppendLine('')
[void]$head.AppendLine('| Step | Result | Detail |')
[void]$head.AppendLine('| --- | --- | --- |')
[void]$head.AppendLine("| ``dart format`` | **$fmtStatus** | $fmtCount hand-written files checked |")
[void]$head.AppendLine("| ``flutter analyze`` | **$anaStatus** | $anaIssues issue(s) |")
[void]$head.AppendLine("| ``flutter test`` | **$tstStatus** | $tstPass passed / $tstFail failed / $tstSkip skipped |")
[void]$head.AppendLine('')
if ($overall -eq 0) { [void]$head.AppendLine('**OVERALL: PASS**') }
else                { [void]$head.AppendLine('**OVERALL: FAIL** - see the failing sections below.') }
[void]$head.AppendLine('')
[void]$head.AppendLine("Started $started - finished $finished")
[void]$head.AppendLine('')
[void]$head.AppendLine('---')

Set-Content -Path $out -Value ($head.ToString() + $body.ToString()) -Encoding UTF8

Say ''
Say '--------------------------------------------------'
Say " format   : $fmtStatus"
Say " analyze  : $anaStatus ($anaIssues issues)"
Say " tests    : $tstStatus ($tstPass passed / $tstFail failed / $tstSkip skipped)"
Say '--------------------------------------------------'
if ($overall -eq 0) { Say ' OVERALL  : PASS' } else { Say ' OVERALL  : FAIL' }
Say ''
Say "Written to $out - paste that file back."

exit $overall
