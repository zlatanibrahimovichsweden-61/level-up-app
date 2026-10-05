import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing credentials. NEVER committed — `android/key.properties` and every
// keystore file are gitignored; see `android/key.properties.example` for the shape
// and `docs/RELEASE_SIGNING.md` for how to generate the keystore.
//
// Absent file => no release signingConfig => the release build is left UNSIGNED and
// fails loudly at install time. That is deliberate: the previous behaviour silently
// fell back to the Android debug keystore, whose password and alias are public, so
// anyone could sign a modified APK that Android would accept as an update to ours.
// Failing closed is correct here; failing back to debug keys is not.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        keystorePropertiesFile.inputStream().use { load(it) }
    }
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

android {
    // The Kotlin package / R class. Deliberately left at the template value: it is
    // never visible to a user or a store, and changing it would mean moving
    // MainActivity.kt for no benefit. The SHIPPED identity is `applicationId` below.
    namespace = "com.levelup.level_up_app"

    // Supported platform versions — ratified in docs/DECISIONS.md D-021 (2026-10-06),
    // evidence in docs/ENVIRONMENTS.md §3. Written as literals instead of inheriting
    // `flutter.compileSdkVersion` etc. so a routine Flutter upgrade cannot silently
    // move the supported range or the Play compliance posture. Flutter 3.44.7's own
    // defaults are these same three values; test/guards/android_identity_test.dart
    // checks that this file and the doc agree.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Production identity — D-021 Q1 (ratified 2026-10-06). The same string is the
        // iOS bundle id. Permanent after the first Play upload; do not edit without a
        // new DECISIONS.md entry.
        applicationId = "com.levelupworld.app"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Two installable identities — D-021 Q2 (two, not three): production and one
    // non-production app. There is no DEV identity: `Flavor.dev` and the mock harness
    // are runtime modes of the staging identity. Flutter requires the flavor name to
    // equal the `--flavor` argument and names the artefact after it
    // (app-prod-release.aab, app-staging-release.apk). The label comes from the
    // generated `app_name` resource, so the manifest never hardcodes a name.
    flavorDimensions += "env"
    productFlavors {
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Level Up")
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".stg" // com.levelupworld.app.stg
            resValue("string", "app_name", "Level Up STG")
        }
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // findByName, not getByName: resolves to null when key.properties is
            // absent, which yields an unsigned release build rather than a
            // debug-signed one. Do NOT "fix" this by pointing it back at
            // signingConfigs.getByName("debug").
            signingConfig = signingConfigs.findByName("release")
        }
    }
}

// Flavor <-> entrypoint coherence (docs/ENVIRONMENTS.md §4–5).
//
// The Flutter tool hands Gradle the Dart entrypoint as `-Ptarget` and the Flutter
// plugin falls back to lib/main.dart when `-t` is omitted. Until 2026-10-06 the `-t`
// file was the ONLY thing choosing the backend, and a flagless release build shipped
// the staging host (ARTEFACT-proven 2026-09-05). A text guard scanning the docs was the
// best available defence; this makes the invalid combination fail the BUILD instead.
//
// Rules: `prod` compiles lib/main_prod.dart and nothing else. `staging` compiles
// main_staging.dart, main_dev.dart or main.dart (which forwards to dev; both talk to
// the staging backend), plus main_mock.dart in debug/profile only — a release artefact
// must never carry the mock backend. The check is attached to the Flutter plugin's
// own per-variant Dart compile task (`compileFlutterBuild<Flavor><BuildType>`), which
// is the task that actually consumes the entrypoint and is in the task graph only for
// the variant being built. (Not `pre<Variant>Build`: AGP's shared `buildCMake<BuildType>`
// tasks depend on another variant's preBuild, so that anchor judged the wrong flavor.)
val flutterTarget: String = (project.findProperty("target") as String?) ?: "lib/main.dart"
val flutterEntrypoint: String = flutterTarget.replace('\\', '/').substringAfterLast('/')

fun allowedEntrypoints(flavor: String, buildType: String): Set<String> = when (flavor) {
    "prod" -> setOf("main_prod.dart")
    "staging" ->
        if (buildType == "release") setOf("main_staging.dart", "main_dev.dart", "main.dart")
        else setOf("main_staging.dart", "main_dev.dart", "main.dart", "main_mock.dart")
    else -> emptySet()
}

tasks.configureEach {
    val match = Regex("^compileFlutterBuild(Prod|Staging)(Debug|Profile|Release)$").matchEntire(name)
        ?: return@configureEach
    val flavor = match.groupValues[1].lowercase()
    val buildType = match.groupValues[2].lowercase()
    doFirst {
        val allowed = allowedEntrypoints(flavor, buildType)
        if (flutterEntrypoint !in allowed) {
            throw GradleException(
                "level_up_app: the '$flavor' flavor ($buildType) cannot be built from " +
                    "'$flutterTarget'. Allowed entrypoints for this flavor: " +
                    "${allowed.joinToString(", ")}. Pass a matching -t, e.g. " +
                    "`--flavor $flavor -t lib/${allowed.first()}`. See docs/ENVIRONMENTS.md §4."
            )
        }
    }
}

// Configuration-time warning so a missing keystore is obvious in the build log
// instead of surfacing as a confusing INSTALL_PARSE_FAILED_NO_CERTIFICATES later.
if (!hasReleaseKeystore) {
    logger.warn(
        "level_up_app: android/key.properties not found — release builds will be UNSIGNED. " +
            "See docs/RELEASE_SIGNING.md. (Debug and profile builds are unaffected.)"
    )
}

flutter {
    source = "../.."
}
