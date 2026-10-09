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

Debug and profile builds are unaffected — `flutter run --flavor staging -t lib/main_staging.dart` still works with no keystore.

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
   flutter build apk --release --flavor prod -t lib/main_prod.dart
   keytool -printcert -jarfile build/app/outputs/flutter-apk/app-prod-release.apk
   ```

   **Both flags are required, and they must agree.** `--flavor prod` selects the
   production identity (`com.levelupworld.app`); `-t lib/main_prod.dart` selects the
   production configuration. Since 2026-10-06 (`DECISIONS.md` D-021, `ENVIRONMENTS.md` §4)
   Gradle refuses a release build without a flavor and refuses the `prod` flavor compiled
   from any other entrypoint, so the wrong pair fails the build instead of shipping. The
   history is why: `lib/main.dart` forwards to `main_dev.dart`, and on 2026-09-05 a flagless
   `flutter build apk --release` was unzipped and found to carry the live staging host in
   `lib/*/libapp.so` while the `-t lib/main_prod.dart` build did not. Every documented
   release command in this repo carries a coherent pair, and `test/guards/workflow_test.dart`
   fails if one stops doing so.

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
- The signing identity binds to `applicationId`. The value is **ratified**:
  `com.levelupworld.app` for production and `com.levelupworld.app.stg` for the single
  non-production app (`DECISIONS.md` D-021, 2026-10-06; set by the `prod` / `staging`
  product flavors in `android/app/build.gradle.kts`). The Kotlin `namespace` stays at the
  template value `com.levelup.level_up_app` on purpose — it is not shipped. The production
  keystore signs `com.levelupworld.app`; a staging QA build is a different package and may
  be signed by anything. The earlier rationale here — registering App Links for the Paymob
  return deep link — is **superseded**: no such deep link exists, the app is purchase-silent
  (adr-049 §3, `DECISIONS.md` D-007). The `applicationId` rule stands on its own: changing
  it after the first upload means a new listing.

## CI

CI exists and already builds a release APK, but it does **not** sign one. The
`build-release-apk` job (`.github/workflows/ci.yml:318-414`, `push` to `main` only) runs
`flutter build apk --release --no-pub --flavor prod -t lib/main_prod.dart` purely as a compile
gate and then proves via `aapt2` that the artefact is `com.levelupworld.app` and carries `INTERNET`. It references no secrets at all,
so what it produces is unsigned — deliberately, until there is a real distribution
channel.

When signing does land there, do not put the keystore in the repo to make builds work.
Inject it: base64 the `.jks` into an encrypted secret, write it and a generated
`key.properties` to disk in the job, and delete both afterwards.
