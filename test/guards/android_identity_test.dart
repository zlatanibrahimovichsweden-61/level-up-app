import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards on the Android platform identity and the supported versions.
///
/// Both were ratified by the owner on 2026-10-06 (docs/DECISIONS.md D-021) after
/// two and a half months in which the shipped identity was `flutter create`
/// template output nobody had chosen. The applicationId becomes permanent at
/// the first Play upload and keys every later Firebase registration, so an
/// accidental edit — a template re-run, a "helpful" rename, a copy-paste from
/// another project — must fail the suite, not surface in a store console.
///
/// Every assertion reads the real files from disk. Comment lines are stripped
/// first: the Gradle file EXPLAINS the rules in prose, and prose must never
/// satisfy or trip a structural check (same lesson as ci.yml's comments).
void main() {
  const gradlePath = 'android/app/build.gradle.kts';
  const manifestPath = 'android/app/src/main/AndroidManifest.xml';
  const environmentsPath = 'docs/ENVIRONMENTS.md';

  const prodId = 'com.levelupworld.app';
  const stagingSuffix = '.stg';
  const flavorIds = <String, String>{
    'prod': prodId,
    'staging': '$prodId$stagingSuffix',
  };

  String stripLineComments(String src) => src
      .split('\n')
      .where((l) => !RegExp(r'^\s*//').hasMatch(l))
      .map((l) => l.replaceFirst(RegExp(r'\s//.*$'), ''))
      .join('\n');

  late String gradle;
  late String manifest;
  late String environments;

  setUpAll(() {
    gradle = stripLineComments(File(gradlePath).readAsStringSync());
    manifest = File(manifestPath).readAsStringSync();
    environments = File(environmentsPath).readAsStringSync();
  });

  group('the Android identity is the ratified one (D-021 Q1/Q2)', () {
    test('the production applicationId is $prodId', () {
      final ids = RegExp(
        r'applicationId\s*=\s*"([^"]+)"',
      ).allMatches(gradle).map((m) => m.group(1)!).toList();

      expect(
        ids,
        equals([prodId]),
        reason:
            '$gradlePath must declare exactly one applicationId and it must be '
            'the ratified production id. Found: $ids. Changing it is a new '
            'DECISIONS.md entry, not an edit — it is permanent after the first '
            'Play upload.',
      );
    });

    test('exactly two flavors exist, prod and staging, in the env dimension', () {
      final flavors = RegExp(
        r'create\("([a-z]+)"\)\s*\{\s*dimension\s*=\s*"env"',
      ).allMatches(gradle).map((m) => m.group(1)!).toSet();

      expect(
        flavors,
        equals({'prod', 'staging'}),
        reason:
            'D-021 Q2 chose TWO installable identities. There is no dev flavor: '
            'Flavor.dev and the mock harness are runtime modes of the staging '
            'identity. Found flavors: $flavors',
      );
      expect(
        gradle.contains('flavorDimensions += "env"'),
        isTrue,
        reason: 'the flavors must share the single "env" dimension',
      );
    });

    test('staging carries the $stagingSuffix suffix and prod carries none', () {
      final suffixes = RegExp(
        r'applicationIdSuffix\s*=\s*"([^"]+)"',
      ).allMatches(gradle).map((m) => m.group(1)!).toList();
      expect(
        suffixes,
        equals([stagingSuffix]),
        reason:
            'exactly one applicationIdSuffix, "$stagingSuffix", on the staging '
            'flavor. Found: $suffixes',
      );

      // And it sits inside the staging block, not the prod one.
      final stagingBlock = RegExp(
        r'create\("staging"\)\s*\{([^}]*)\}',
      ).firstMatch(gradle)?.group(1);
      expect(stagingBlock, isNotNull);
      expect(
        stagingBlock,
        contains('applicationIdSuffix = "$stagingSuffix"'),
        reason: 'the suffix belongs to the staging flavor',
      );
    });

    test('display names are generated per flavor; the manifest reads them', () {
      final names = {
        for (final m in RegExp(
          r'create\("([a-z]+)"\)\s*\{[^}]*resValue\("string",\s*"app_name",\s*"([^"]+)"\)',
        ).allMatches(gradle))
          m.group(1)!: m.group(2)!,
      };

      expect(
        names,
        equals({'prod': 'Level Up', 'staging': 'Level Up STG'}),
        reason:
            'D-021 Q3: "Level Up" for production, "Level Up STG" for the '
            'non-production app. Found: $names',
      );
      expect(
        manifest.contains('android:label="@string/app_name"'),
        isTrue,
        reason:
            'the manifest must read the generated resource; a hardcoded label '
            'would show the same name for both identities (device-confirmed '
            'gap G-9, 2026-10-04)',
      );
      expect(
        RegExp(r'android:label="[^@]').hasMatch(manifest),
        isFalse,
        reason: 'no hardcoded android:label anywhere in the main manifest',
      );
    });

    test('the build-time flavor/entrypoint coherence check is present', () {
      // The Gradle check is what turns "a prod artefact talking to staging"
      // from a documented hazard into an impossible build. If it is deleted,
      // the text scan in workflow_test.dart is the only thing left, and that
      // one cannot see a developer's terminal.
      expect(
        gradle.contains('findProperty("target")'),
        isTrue,
        reason: 'the Gradle script must read the Flutter entrypoint (-Ptarget)',
      );
      expect(
        RegExp(r'"prod"\s*->\s*setOf\("main_prod\.dart"\)').hasMatch(gradle),
        isTrue,
        reason:
            'the prod flavor must accept lib/main_prod.dart and nothing else',
      );
      expect(
        gradle.contains('throw GradleException('),
        isTrue,
        reason: 'a mismatch must fail the build, not log a warning',
      );
    });
  });

  group('supported Android versions are pinned and match the record (Q4)', () {
    int literal(String key) {
      final m = RegExp('$key\\s*=\\s*(\\d+)').firstMatch(gradle);
      expect(
        m,
        isNotNull,
        reason:
            '$key must be a literal in $gradlePath, not inherited from '
            'flutter.* — inheriting lets a routine Flutter upgrade silently '
            'change the supported range (docs/ENVIRONMENTS.md §3.4)',
      );
      return int.parse(m!.group(1)!);
    }

    test('minSdk 24 / targetSdk 36 / compileSdk 36 are literals', () {
      expect(literal('minSdk'), equals(24));
      expect(literal('targetSdk'), equals(36));
      expect(literal('compileSdk'), equals(36));
      expect(
        RegExp(
          r'flutter\.(minSdkVersion|targetSdkVersion|compileSdkVersion)',
        ).hasMatch(gradle),
        isFalse,
        reason: 'no SDK level may be inherited from the Flutter extension',
      );
    });

    test('docs/ENVIRONMENTS.md §3 states the same three numbers', () {
      // The doc is what the owner ratified and what the store audit quotes;
      // the Gradle file is what ships. They must be the same thing.
      int documented(String label) {
        final m = RegExp('$label:\\s+API (\\d+)').firstMatch(environments);
        expect(m, isNotNull, reason: '§3 must carry a "$label: API n" line');
        return int.parse(m!.group(1)!);
      }

      expect(documented('Minimum'), equals(literal('minSdk')));
      expect(documented('Target'), equals(literal('targetSdk')));
      expect(documented('Compile'), equals(literal('compileSdk')));
    });
  });

  group('the Firebase slot cannot mix identities (ENVIRONMENTS.md §5, §7)', () {
    test('a per-flavor google-services.json names its own flavor id', () {
      // Passes vacuously until Firebase is registered — recorded here so the
      // rule exists BEFORE the first file lands, not after the first mix-up.
      // The file is per-flavor by Gradle convention (android/app/src/<flavor>/),
      // and a production project's file in the staging source set would route
      // staging pushes through the production Firebase app.
      for (final entry in flavorIds.entries) {
        final file = File('android/app/src/${entry.key}/google-services.json');
        if (!file.existsSync()) continue;

        final json =
            jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
        final packages = [
          for (final client in (json['client'] as List? ?? const []))
            // ignore: avoid_dynamic_calls
            (client
                as Map)['client_info']?['android_client_info']?['package_name'],
        ];
        expect(
          packages,
          everyElement(equals(entry.value)),
          reason:
              '${file.path} must register only ${entry.value}; found $packages',
        );
      }
    });

    test('no google-services.json sits in src/main (shared across flavors)', () {
      expect(
        File('android/app/src/main/google-services.json').existsSync(),
        isFalse,
        reason:
            'a Firebase file in src/main merges into EVERY flavor; it belongs in '
            'android/app/src/<flavor>/',
      );
    });
  });
}
