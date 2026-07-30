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
    namespace = "com.levelup.level_up_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.levelup.level_up_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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
