<#
Level Up - Wave 2 guard proof.

    powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1

Answers the only question that matters about an automated rule: **does it
actually fail when the rule is broken?**

A guard that has only ever run against a clean codebase has never demonstrated
anything. This script breaks each rule on purpose, one at a time, and proves the
SPECIFIC guard responsible went red - then puts everything back.

HOW THE PROOF WORKS (Wave 2.1 - this is the part Fable rejected)
----------------------------------------------------------------
The first version ran the whole guard suite and concluded success from:

    (the suite went red) AND (the guard's name appears in the output)

That is not a proof. `--reporter expanded` prints EVERY test name as it runs,
passing or failing, so the second condition was true whenever the test merely
existed. The harness therefore proved "the suite became red" and attributed it
to whichever guard was being probed - a false PASS if any unrelated test failed.

The fix removes the ambiguity rather than pattern-matching harder: each probe
runs **only the one test under proof**, selected with `--plain-name`, so the
process exit code is unambiguous. Nothing else ran, so nothing else can explain
a non-zero exit.

Each probe is therefore a three-point proof:

    1. clean tree  -> the target test alone PASSES   (name is valid, guard green)
    2. violation   -> the target test alone FAILS    (the guard fired)
    3. restore     -> verified by SHA-256

Step 1 doubles as validation of the test name: if `--plain-name` matched
nothing, `flutter test` exits non-zero and step 1 fails loudly as a HARNESS
error, rather than silently making step 2 look like a successful proof.

METHOD
------
Four probes create a scratch file (`lib/__guard_probe.dart`) holding a
deliberate violation. It is never imported, so it cannot affect the app - the
guards see it because they scan `lib/` from disk, which is the surface under
test. It is gitignored so a crashed run cannot leave it staged.

Seven probes must edit a real file (`ci.yml`, `AndroidManifest.xml`,
`RELEASE_SIGNING.md`, `build.gradle.kts`, `bootstrap.dart`, `main_mock.dart`).
Those are backed up first and restored in a `finally` block with a SHA-256 comparison
before the script exits, so an error or Ctrl-C cannot leave the repo modified.

WHAT THIS DOES NOT PROVE
------------------------
That the guards catch every possible phrasing of a violation. It proves each one
fires on a representative case and stays green otherwise - necessary, not
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

# Runs the whole guard suite. Used only for the clean-tree bookends.
function RunAll {
    $out = (& flutter test test/guards --no-pub --reporter expanded 2>&1) -join "`n"
    return [pscustomobject]@{ Output = $out; Code = $LASTEXITCODE }
}

# Runs EXACTLY ONE test, selected by its full name. The exit code is then
# unambiguous: nothing else ran, so nothing else can explain a failure.
function RunOne($plainName) {
    $out = (& flutter test test/guards --no-pub --reporter expanded `
              --plain-name $plainName 2>&1) -join "`n"
    $code = $LASTEXITCODE
    # If the name matched nothing, flutter exits non-zero and says so. That is
    # indistinguishable from a real failure by exit code alone, so detect it.
    $matched = -not ($out -match 'No tests match')
    return [pscustomobject]@{ Output = $out; Code = $code; Matched = $matched }
}

# One probe: prove $plainName passes clean, fails under $applyViolation, and is
# restored afterwards. $applyViolation and $restore are script blocks.
function Probe($name, $plainName, $applyViolation, $restore) {
    $detected = $false
    $note     = ''

    # --- 1. the guard is green, and the name is real -------------------------
    $before = RunOne $plainName
    if (-not $before.Matched) {
        Bad "$name - HARNESS ERROR: no test matches '$plainName'"
        Info 'The probe proves nothing. Fix the name in this script.'
        $script:results += [pscustomobject]@{ Rule = $name; Detected = $false }
        return
    }
    if ($before.Code -ne 0) {
        Bad "$name - HARNESS ERROR: the guard is ALREADY failing before the probe"
        Info 'Fix that first; a red guard cannot prove anything about a violation.'
        $script:results += [pscustomobject]@{ Rule = $name; Detected = $false }
        return
    }
    Info "baseline: '$plainName' passes on the clean tree"

    # --- 2. break it ---------------------------------------------------------
    try {
        & $applyViolation
        $after = RunOne $plainName

        if (-not $after.Matched) {
            $note = 'the test stopped matching - the probe changed test selection'
        } elseif ($after.Code -ne 0) {
            $detected = $true
        } else {
            $note = 'the violation was NOT detected. This guard proves nothing.'
        }
    }
    finally {
        # --- 3. restore, always ----------------------------------------------
        & $restore
    }

    if ($detected) { Ok "$name - guard fired (that test alone, exit $($after.Code))" }
    else { Bad "$name - $note" }

    $script:results += [pscustomobject]@{ Rule = $name; Detected = $detected }
}

Write-Host ''
Write-Host 'Wave 2 - guard proof' -ForegroundColor Cyan
Write-Host '===================='
Write-Host ''

# --- 0. clean baseline -------------------------------------------------------
Write-Host '[0] clean tree'
$out = RunAll
if ($out.Output -match 'All tests passed') {
    Ok 'the whole guard suite passes on the clean tree'
} else {
    Bad 'guards are ALREADY failing - fix that before trusting this run'
    Write-Host $out.Output
    exit 1
}
Write-Host ''

# --- 1..4 scratch-file probes ------------------------------------------------
$fileProbes = @(
    @{ Name = 'Bloc confined to quiz'
       Body = "import 'package:flutter_bloc/flutter_bloc.dart';`nvoid probe() {}"
       Test = 'Bloc stays inside the quiz feature' },

    @{ Name = 'No provider mutation in initState'
       Body = "class P { void initState() { ref.read(x.notifier).start(); } }"
       Test = 'no provider is mutated during initState' },

    @{ Name = 'Copy is localized'
       Body = "Widget probe() => Text('hardcoded english');"
       Test = 'no NEW file introduces a hardcoded string' },

    @{ Name = 'fontSize ratchet'
       Body = "var s = TextStyle(fontSize: 99);"
       Test = 'hardcoded fontSize does not increase' },

    # A BoxShadow is the exact construct the 2026-09-16 audit found eleven of,
    # each carrying Figma's blur number in Flutter's blurRadius field - two
    # different units - under a colour that only read on one canvas. The last
    # of the eleven moved to AppElevation on 2026-09-20, so the ratchet became
    # zero-enforcement and this probe now checks a ban rather than a count.
    @{ Name = 'Elevation effects enforced at zero'
       Body = "var s = BoxShadow(blurRadius: 1);"
       Test = 'no raw elevation effect outside the two elevation folders' },

    # The RTL double flip Wave 07 removed: a conditional between mirror glyphs,
    # which Icon's matchTextDirection flips straight back.
    @{ Name = 'No mirror-glyph swap'
       Body = "IconData probe(bool rtl) => rtl ? Icons.chevron_left : Icons.chevron_right;"
       Test = 'no glyph is swapped for its mirror image' }
)

$i = 1
foreach ($p in $fileProbes) {
    Write-Host "[$i] probe: $($p.Name)"
    $body = $p.Body
    Probe $p.Name $p.Test `
        { Set-Content -Path $probe -Value $body -Encoding UTF8 } `
        { Remove-Item $probe -Force -ErrorAction SilentlyContinue }
    Write-Host ''
    $i++
}

# --- 7..11: probes that edit a real file -------------------------------------
# Backed up, restored in Probe's finally, then SHA-256 verified here.
$editProbes = @(
    @{ Name = 'CI test discovery'
       Test = 'CI never passes a directory to flutter test'
       Path = '.github/workflows/ci.yml'
       Bak  = 'ci.yml.guardprobe.bak'
       # Reintroduce verbatim the bug Fable found in Wave 2.
       From = 'flutter test --no-pub --reporter expanded --exclude-tags golden'
       To   = 'flutter test --no-pub --reporter expanded test/core test/dev'
       Label = 'CI cannot silently skip tests' },

    @{ Name = 'Release INTERNET permission'
       Test = 'the main manifest declares INTERNET'
       Path = 'android/app/src/main/AndroidManifest.xml'
       Bak  = 'AndroidManifest.guardprobe.bak'
       From = '<uses-permission android:name="android.permission.INTERNET"/>'
       To   = ''
       Label = 'release INTERNET permission (Tier-0 C-1)' },

    # Reintroduce the 2026-09-05 defect in its post-flavor form: the command
    # that was correct until 2026-10-06 (right entrypoint, no --flavor). Gradle
    # now refuses it, so a doc teaching it is wrong; the `--release` is dropped
    # too, because release is Flutter's default build mode and a guard that only
    # looked for `--release` would stay green here - the hole Fable found in the
    # first version of this guard.
    @{ Name = 'Release build: flavor present'
       Test = 'every runnable release-build command pairs --flavor with a matching entrypoint'
       Path = 'docs/RELEASE_SIGNING.md'
       Bak  = 'RELEASE_SIGNING.guardprobe.bak'
       From = 'flutter build apk --release --flavor prod -t lib/main_prod.dart'
       To   = 'flutter build apk -t lib/main_prod.dart'
       Label = 'release build carries --flavor' },

    # The combination D-021 makes impossible to ship: the production identity
    # compiled from the staging entrypoint. Gradle refuses it at build time; this
    # proves the text guard refuses it in a doc as well.
    @{ Name = 'Release build: flavor/entry mismatch'
       Test = 'every runnable release-build command pairs --flavor with a matching entrypoint'
       Path = 'docs/RELEASE_SIGNING.md'
       Bak  = 'RELEASE_SIGNING.guardprobe2.bak'
       From = 'flutter build apk --release --flavor prod -t lib/main_prod.dart'
       To   = 'flutter build apk --release --flavor prod -t lib/main_staging.dart'
       Label = 'release build pairs --flavor prod with main_prod.dart' },

    # The identity itself. Revert the ratified applicationId to the template
    # value - the most likely accidental edit (a template re-run or a rename).
    @{ Name = 'Android applicationId ratified'
       Test = 'the production applicationId is com.levelupworld.app'
       Path = 'android/app/build.gradle.kts'
       Bak  = 'build.gradle.kts.guardprobe.bak'
       From = 'applicationId = "com.levelupworld.app"'
       To   = 'applicationId = "com.levelup.level_up_app"'
       Label = 'applicationId is the D-021 value' },

    # CW18a, the Dart layer of the flavor contract. Delete the one call that
    # compares the compiled Flavor with the platform flavor: the app would boot
    # with an entrypoint its build configuration never chose (iOS has no Gradle
    # to refuse it). The unit tests of the comparison stay green - they test
    # the function, not that bootstrap() calls it - which is why this guard
    # reads the wiring.
    @{ Name = 'Boot platform-flavor check'
       Test = 'bootstrap() checks the platform flavor before it initialises anything'
       Path = 'lib/bootstrap.dart'
       Bak  = 'bootstrap.guardprobe.bak'
       From = 'AppConfig.verifyPlatformFlavor(flavor, platformFlavor);'
       To   = ''
       Label = 'bootstrap() verifies the platform flavor' },

    # CW18a. Turn the mock entrypoint's release refusal into a no-op: a release
    # artefact built from main_mock.dart would then run the canned backend.
    # Gradle refuses that build on Android only.
    @{ Name = 'Mock entrypoint release refusal'
       Test = 'main_mock refuses a release build before it touches config or tokens'
       Path = 'lib/main_mock.dart'
       Bak  = 'main_mock.guardprobe.bak'
       From = 'if (kReleaseMode) {'
       To   = 'if (false) {'
       Label = 'main_mock.dart refuses to run in release' }
)

foreach ($p in $editProbes) {
    Write-Host "[$i] probe: $($p.Label)"
    $path = $p.Path
    $from = $p.From
    $to   = $p.To
    $hash = (Get-FileHash $path -Algorithm SHA256).Hash
    $bak  = Join-Path ([System.IO.Path]::GetTempPath()) $p.Bak
    Copy-Item $path $bak -Force

    # Fail loudly if the probe would be a no-op: a Replace() that matches
    # nothing leaves the file untouched, the guard stays green, and the harness
    # would report "not detected" for the wrong reason.
    if ((Get-Content $path -Raw) -notlike "*$from*") {
        Bad "$($p.Name) - HARNESS ERROR: probe text not found in $path"
        Info 'The probe would be a no-op. Update the From string in this script.'
        $results += [pscustomobject]@{ Rule = $p.Name; Detected = $false }
        Remove-Item $bak -Force -ErrorAction SilentlyContinue
        Write-Host ''
        $i++
        continue
    }

    Probe $p.Name $p.Test `
        { (Get-Content $path -Raw).Replace($from, $to) |
            Set-Content $path -Encoding UTF8 -NoNewline } `
        { Copy-Item $bak $path -Force }

    if ((Get-FileHash $path -Algorithm SHA256).Hash -eq $hash) {
        Info "$path restored (sha256 verified)"
    } else {
        Write-Host "  *** RESTORE FAILED - recover: Copy-Item '$bak' '$path' -Force" -ForegroundColor Red
        exit 1
    }
    Remove-Item $bak -Force -ErrorAction SilentlyContinue
    Write-Host ''
    $i++
}

# --- final: clean tree again -------------------------------------------------
Write-Host '[final] tree restored'
Remove-Item $probe -Force -ErrorAction SilentlyContinue
$out = RunAll
$restored = $out.Output -match 'All tests passed'
if ($restored) { Ok 'the whole guard suite passes again - nothing was left broken' }
else { Bad 'guards still failing after restore - INSPECT THE TREE'; Write-Host $out.Output }

# --- summary -----------------------------------------------------------------
Write-Host ''
Write-Host '===================='
$results | ForEach-Object {
    $mark = if ($_.Detected) { 'detected' } else { 'NOT DETECTED' }
    Write-Host (" {0,-34} {1}" -f $_.Rule, $mark)
}
$passed = ($results | Where-Object { $_.Detected }).Count
$total  = $results.Count
Write-Host '===================='
Write-Host " $passed/$total guards proved"
if ($passed -eq $total -and $restored) {
    Write-Host 'RESULT: VERIFIED - each guard fails, in isolation, when its own rule is broken' -ForegroundColor Green
    exit 0
}
Write-Host 'RESULT: NOT VERIFIED' -ForegroundColor Red
exit 1
