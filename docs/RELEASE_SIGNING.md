# Android release signing

> Closes the "release builds are signed with the Android debug keystore" finding.
> Before this, `android/app/build.gradle.kts` carried the stock Flutter template's
> `signingConfig = signingConfigs.getByName("debug")`. The debug keystore ships with the
> Android SDK and its password (`android`) and alias (`androiddebugkey`) are public, so
> anyone could build a modified APK carrying a signature identical to ours — Android
> accepts that as an update over a sideloaded install with no tamper warning. Play
> Console also rejects debug-signed uploads outright.

## How it works now

`android/app/build.gradle.kts` reads `android/key.properties` at configuration time.

- **File present** → a `release` signing config is created and used for release builds.
- **File absent** → `signingConfigs.findByName("release")` returns `null`, the release
  build is left **unsigned**, and Gradle logs a warning.

It fails **closed**. An unsigned APK is obvious and refuses to install; a debug-signed one
looks fine and is the actual problem. Do not "fix" a failing release build by pointing
`signingConfig` back at the debug config.

Debug and profile builds are unaffected — `flutter run` still works with no keystore.

## One-time setup (per person who ships builds)

1. **Generate the keystore.** Keep it *outside* the repo.

   ```bash
   keytool -genkey -v \
     -keystore ~/keys/levelup-release.jks \
     -storetype JKS \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias levelup
   ```

2. **Create `android/key.properties`** from the template:

   ```bash
   cp android/key.properties.example android/key.properties
   ```

   Fill in `keyAlias`, `keyPassword`, `storeFile` (absolute path) and `storePassword`.

3. **Verify it took.** A signed release build reports a certificate that is *not*
   `CN=Android Debug`:

   ```bash
   flutter build apk --release -t lib/main_prod.dart
   keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
   ```

   **The `-t` is not optional.** `lib/main.dart` forwards to `main_dev.dart`
   (`lib/main.dart:4-6`), so a flagless `flutter build apk --release` compiles the
   **dev** flavor — which resolves `AppConfig.baseUrl` to the live staging host
   (`lib/core/config/app_config.dart:43-52`). That is not a theory: on 2026-09-05 both
   builds were made and unzipped, and `level-up-backend-staging.up.railway.app` is
   present in `lib/*/libapp.so` of the flagless build and absent from the
   `-t lib/main_prod.dart` one. Nothing in Gradle or Flutter stops it — there are no
   product flavors, only this argument — so every release command in this repo names
   the entrypoint, and `test/guards/workflow_test.dart` fails if one stops doing so.

   If the owner reads `CN=Android Debug, OU=Android, O=Android, L=Mountain View`, the
   keystore was not picked up — check that `key.properties` sits in `android/`, not
   `android/app/`.

## Rules

- **Never commit** `key.properties`, `*.jks` or `*.keystore`. All three are already
  ignored by `android/.gitignore` (lines 12–14, from the Flutter template).
  `key.properties.example` has a different filename, so it stays tracked — that is
  intentional and it must never hold real values.
- **Never rotate the keystore** once the app is live on Play. The signing key is the
  app's identity: losing it means you can never ship an update to an existing install,
  and leaking it means someone else can. Back it up somewhere durable and private
  (password manager or the owner's encrypted drive — not the repo, not Slack, not email).
- **Enrol in Play App Signing** when the Play Console listing is created. Google then
  holds the app signing key and you keep only an upload key, which *can* be rotated if it
  leaks. Strongly recommended before first release, and it makes rule 2 much less scary.
- The signing identity binds to `applicationId`. The **value** is already settled in code
  — `com.levelup.level_up_app` (`android/app/build.gradle.kts:43`), matching the
  `namespace` at `:28` and ARTEFACT-confirmed as the package name of the release APK on
  2026-09-05. Only the template's "specify your own" TODO comment above it (`:42`) is
  left over; it is stale, and deleting the comment must not be confused with changing the
  ID. Confirm the value is the one the business wants **before** generating the
  production keystore. The earlier rationale here —
  registering App Links for the Paymob return deep link — is **superseded**: no such deep
  link exists, the app is purchase-silent (adr-049 §3, `DECISIONS.md` D-007). The
  `applicationId` rule stands on its own: changing it afterwards means a new listing.

## CI

CI exists and already builds a release APK, but it does **not** sign one. The
`build-release-apk` job (`.github/workflows/ci.yml:318-414`, `push` to `main` only) runs
`flutter build apk --release --no-pub -t lib/main_prod.dart` purely as a compile gate and
then proves the artefact carries `INTERNET` via `aapt2`. It references no secrets at all,
so what it produces is unsigned — deliberately, until there is a real distribution
channel.

When signing does land there, do not put the keystore in the repo to make builds work.
Inject it: base64 the `.jks` into an encrypted secret, write it and a generated
`key.properties` to disk in the job, and delete both afterwards.
