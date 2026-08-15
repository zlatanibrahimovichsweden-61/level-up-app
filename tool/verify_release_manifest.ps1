<#
Level Up - release manifest verification (Tier-0 finding C-1).

    powershell -ExecutionPolicy Bypass -File tool\verify_release_manifest.ps1

Builds a release APK and proves that the SHIPPED artefact declares
android.permission.INTERNET.

Why this needs its own script: C-1 is invisible to every other gate. The
permission lived only in `src/debug` and `src/profile`, which merge into their
own build types and never into release. So the app worked perfectly in
development, compiled cleanly, analysed clean, and passed 792 tests - and would
have failed every network call the moment a release build reached a device.
`flutter analyze` cannot see it. The test suite cannot see it. Only a release
build can.

Checks source first (fast, no build), then the merged manifest, then the APK
itself via aapt2 - three levels, weakest to strongest. The APK check is the only
one that is actual proof, because it inspects what the manifest merger really
produced rather than what the source claims.

Exit code 0 only if the strongest available check passed.
#>

$ErrorActionPreference = 'Continue'
$PSNativeCommandUseErrorActionPreference = $false

$root = (& git rev-parse --show-toplevel 2>$null)
if (-not $root) { $root = (Get-Location).Path }
Set-Location $root

$PERM = 'android.permission.INTERNET'
$failed = $false

function Ok   ($m) { Write-Host "  PASS  $m" -ForegroundColor Green }
function Bad  ($m) { Write-Host "  FAIL  $m" -ForegroundColor Red }
function Info ($m) { Write-Host "        $m" -ForegroundColor DarkGray }

Write-Host ''
Write-Host 'Level Up - release INTERNET permission verification' -ForegroundColor Cyan
Write-Host '===================================================='
Write-Host ''

# --- 1. Source ---------------------------------------------------------------
Write-Host '[1/3] source manifest (src/main)'
$mainManifest = 'android/app/src/main/AndroidManifest.xml'
if ((Test-Path $mainManifest) -and (Select-String -Path $mainManifest -SimpleMatch $PERM -Quiet)) {
  Ok "src/main declares $PERM"
} else {
  Bad "src/main does NOT declare $PERM"
  Info 'Declaring it in src/debug and src/profile is not enough - those source'
  Info 'sets never merge into release. It must be in src/main.'
  $failed = $true
}
Write-Host ''

# --- 2. Release build --------------------------------------------------------
Write-Host '[2/3] release build'
Info 'flutter build apk --release -t lib/main_prod.dart  (this takes a few minutes)'
& flutter build apk --release -t lib/main_prod.dart
$buildRc = $LASTEXITCODE

if ($buildRc -ne 0) {
  Bad "release build FAILED (exit $buildRc)"
  Info 'Cannot verify the shipped artefact without a build. The source check'
  Info 'above still stands, but it is NOT proof - report this as NOT VERIFIED.'
  Write-Host ''
  Write-Host 'RESULT: NOT VERIFIED (build failed)' -ForegroundColor Yellow
  exit 1
}
Ok 'release APK built'
Write-Host ''

# --- 3. The artefact itself --------------------------------------------------
Write-Host '[3/3] the shipped artefact'
$apk = 'build/app/outputs/flutter-apk/app-release.apk'
$verifiedStrong = $false

if (Test-Path $apk) {
  $sdk = $env:ANDROID_HOME
  if (-not $sdk) { $sdk = $env:ANDROID_SDK_ROOT }
  if (-not $sdk) { $sdk = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }

  $aapt2 = $null
  if (Test-Path (Join-Path $sdk 'build-tools')) {
    $aapt2 = Get-ChildItem -Path (Join-Path $sdk 'build-tools') -Recurse -Filter 'aapt2.exe' -ErrorAction SilentlyContinue |
      Sort-Object FullName | Select-Object -Last 1
  }

  if ($aapt2) {
    Info "aapt2: $($aapt2.FullName)"
    $perms = & $aapt2.FullName dump permissions $apk 2>&1
    if ($perms -match [regex]::Escape($PERM)) {
      Ok "the release APK declares $PERM  <-- this is the proof"
      $verifiedStrong = $true
    } else {
      Bad "the release APK does NOT declare $PERM"
      Info 'The source says one thing and the built artefact says another -'
      Info 'something is stripping it during the merge.'
      $perms | ForEach-Object { Info $_ }
      $failed = $true
    }
  } else {
    Info 'aapt2 not found - falling back to the merged manifest'
  }
} else {
  Info "APK not found at $apk - falling back to the merged manifest"
}

if (-not $verifiedStrong -and -not $failed) {
  $merged = Get-ChildItem -Path 'build/app/intermediates' -Recurse -Filter 'AndroidManifest.xml' -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match 'release' } | Select-Object -First 1
  if ($merged) {
    Info "merged manifest: $($merged.FullName)"
    if (Select-String -Path $merged.FullName -SimpleMatch $PERM -Quiet) {
      Ok "the merged release manifest declares $PERM"
      $verifiedStrong = $true
    } else {
      Bad "the merged release manifest does NOT declare $PERM"
      $failed = $true
    }
  } else {
    Info 'no merged release manifest found either'
  }
}

Write-Host ''
Write-Host '===================================================='
if ($failed) {
  Write-Host 'RESULT: FAILED - release networking is broken' -ForegroundColor Red
  exit 1
} elseif ($verifiedStrong) {
  Write-Host 'RESULT: VERIFIED - the release artefact can reach the network' -ForegroundColor Green
  exit 0
} else {
  Write-Host 'RESULT: NOT VERIFIED - source looks right, artefact unchecked' -ForegroundColor Yellow
  Write-Host 'Report this as NOT VERIFIED, not as a pass.' -ForegroundColor Yellow
  exit 1
}
