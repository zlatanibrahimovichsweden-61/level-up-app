<#
Level Up - Wave 2 guard proof.

    powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1

Answers the only question that matters about an automated rule: **does it
actually fail when the rule is broken?**

A guard that has only ever run against a clean codebase has never demonstrated
anything. This script breaks each rule on purpose, one at a time, and asserts
that the specific guard responsible goes red - then puts everything back.

METHOD
------
Most probes create a single scratch file (`lib/__guard_probe.dart`) containing a
deliberate violation, run `flutter test test/guards`, and check that the expected
test name appears in the failures. The scratch file is never imported by
anything, so it does not affect the app - the guards read it because they scan
`lib/` from disk, which is exactly the surface under test.

Two probes must edit a real file (`ci.yml`, `AndroidManifest.xml`). Those are
backed up to a temp file first and restored in a `finally` block with a SHA-256
comparison before the script exits, so an error or Ctrl-C cannot leave the repo
modified.

WHAT THIS DOES NOT PROVE
------------------------
That the guards catch every possible phrasing of a violation. It proves each one
fires on a representative case and that the clean tree passes - necessary, not
sufficient.
#>

$ErrorActionPreference = 'Continue'
$PSNativeCommandUseErrorActionPreference = $false

$root = (& git rev-parse --show-toplevel 2>$null)
if (-not $root) { $root = (Get-Location).Path }
Set-Location $root

$probe   = 'lib/__guard_probe.dart'
$results = @()

function Ok   ($m) { Write-Host "  PASS  $m" -ForegroundColor Green }
function Bad  ($m) { Write-Host "  FAIL  $m" -ForegroundColor Red }
function Info ($m) { Write-Host "        $m" -ForegroundColor DarkGray }

# Runs the guard suite; returns the raw output.
function RunGuards {
    return (& flutter test test/guards --no-pub --reporter expanded 2>&1) -join "`n"
}

# Records one probe result.
function Check($name, $output, $expectFragment) {
    $failed = $output -match '\[E\]' -or $output -match 'Some tests failed'
    $named  = $output -match [regex]::Escape($expectFragment)
    $good   = $failed -and $named
    if ($good) { Ok "$name - guard fired" }
    elseif ($failed) { Bad "$name - suite failed but NOT on the expected guard ('$expectFragment')" }
    else { Bad "$name - the violation was NOT detected. This guard proves nothing." }
    $script:results += [pscustomobject]@{ Rule = $name; Detected = $good }
}

Write-Host ''
Write-Host 'Wave 2 - guard proof' -ForegroundColor Cyan
Write-Host '===================='
Write-Host ''

# --- 0. clean baseline -------------------------------------------------------
Write-Host '[0] clean tree'
$out = RunGuards
if ($out -match 'All tests passed') {
    Ok 'guards pass on the clean tree'
} else {
    Bad 'guards are ALREADY failing - fix that before trusting this run'
    Write-Host $out
    exit 1
}
Write-Host ''

# --- 1..4 scratch-file probes ------------------------------------------------
$fileProbes = @(
    @{ Name = 'Bloc confined to quiz'
       Body = "import 'package:flutter_bloc/flutter_bloc.dart';`nvoid probe() {}"
       Expect = 'Bloc stays inside the quiz feature' },

    @{ Name = 'No provider mutation in initState'
       Body = "class P { void initState() { ref.read(x.notifier).start(); } }"
       Expect = 'no provider is mutated during initState' },

    @{ Name = 'Copy is localized'
       Body = "Widget probe() => Text('hardcoded english');"
       Expect = 'no NEW file introduces a hardcoded string' },

    @{ Name = 'fontSize ratchet'
       Body = "var s = TextStyle(fontSize: 99);"
       Expect = 'hardcoded fontSize does not increase' }
)

$i = 1
foreach ($p in $fileProbes) {
    Write-Host "[$i] probe: $($p.Name)"
    try {
        Set-Content -Path $probe -Value $p.Body -Encoding UTF8
        Check $p.Name (RunGuards) $p.Expect
    }
    finally {
        Remove-Item $probe -Force -ErrorAction SilentlyContinue
    }
    Write-Host ''
    $i++
}

# --- 5. CI path-argument probe (edits a real file) ---------------------------
Write-Host "[$i] probe: CI cannot silently skip tests"
$ci = '.github/workflows/ci.yml'
$ciHash = (Get-FileHash $ci -Algorithm SHA256).Hash
$ciBak = Join-Path ([System.IO.Path]::GetTempPath()) 'ci.yml.guardprobe.bak'
Copy-Item $ci $ciBak -Force
try {
    # Reintroduce exactly the bug Fable found: a hand-listed directory.
    (Get-Content $ci -Raw).Replace(
        'flutter test --no-pub --reporter expanded --exclude-tags golden',
        'flutter test --no-pub --reporter expanded test/core test/dev'
    ) | Set-Content $ci -Encoding UTF8 -NoNewline
    Check 'CI test discovery' (RunGuards) 'CI never passes a directory to flutter test'
}
finally {
    Copy-Item $ciBak $ci -Force
    if ((Get-FileHash $ci -Algorithm SHA256).Hash -eq $ciHash) {
        Info 'ci.yml restored (sha256 verified)'
    } else {
        Write-Host "  *** RESTORE FAILED - recover: Copy-Item '$ciBak' '$ci' -Force" -ForegroundColor Red
        exit 1
    }
    Remove-Item $ciBak -Force -ErrorAction SilentlyContinue
}
Write-Host ''
$i++

# --- 6. release INTERNET probe (edits a real file) ---------------------------
Write-Host "[$i] probe: release INTERNET permission (Tier-0 C-1)"
$man = 'android/app/src/main/AndroidManifest.xml'
$manHash = (Get-FileHash $man -Algorithm SHA256).Hash
$manBak = Join-Path ([System.IO.Path]::GetTempPath()) 'AndroidManifest.guardprobe.bak'
Copy-Item $man $manBak -Force
try {
    (Get-Content $man -Raw).Replace(
        '<uses-permission android:name="android.permission.INTERNET"/>', ''
    ) | Set-Content $man -Encoding UTF8 -NoNewline
    Check 'Release INTERNET permission' (RunGuards) 'the main manifest declares INTERNET'
}
finally {
    Copy-Item $manBak $man -Force
    if ((Get-FileHash $man -Algorithm SHA256).Hash -eq $manHash) {
        Info 'AndroidManifest.xml restored (sha256 verified)'
    } else {
        Write-Host "  *** RESTORE FAILED - recover: Copy-Item '$manBak' '$man' -Force" -ForegroundColor Red
        exit 1
    }
    Remove-Item $manBak -Force -ErrorAction SilentlyContinue
}
Write-Host ''

# --- final: clean tree again -------------------------------------------------
Write-Host '[final] tree restored'
$out = RunGuards
$restored = $out -match 'All tests passed'
if ($restored) { Ok 'guards pass again - nothing was left broken' }
else { Bad 'guards still failing after restore - INSPECT THE TREE'; Write-Host $out }

Remove-Item $probe -Force -ErrorAction SilentlyContinue

# --- summary -----------------------------------------------------------------
Write-Host ''
Write-Host '===================='
$results | ForEach-Object {
    $mark = if ($_.Detected) { 'detected' } else { 'NOT DETECTED' }
    Write-Host (" {0,-34} {1}" -f $_.Rule, $mark)
}
$all = ($results | Where-Object { -not $_.Detected }).Count -eq 0
Write-Host '===================='
if ($all -and $restored) {
    Write-Host 'RESULT: VERIFIED - every probed guard fails when its rule is broken' -ForegroundColor Green
    exit 0
}
Write-Host 'RESULT: NOT VERIFIED' -ForegroundColor Red
exit 1
