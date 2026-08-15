import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards on the enforcement infrastructure itself.
///
/// Wave 2 added CI checks, a pinned SDK and a release-permission gate. All
/// three are ordinary text files that a future edit can quietly weaken, and
/// none of them is exercised by the app's own tests. So they get guards too —
/// otherwise the thing protecting the codebase is the one part of it with no
/// protection.
void main() {
  /// YAML full-line comments removed.
  ///
  /// Load-bearing: `ci.yml` explains the old broken command *in a comment*
  /// ("flutter test test/core test/dev test/features"). A naive scan would find
  /// that prose and conclude the bug is still present — or worse, a future
  /// naive scan would find a comment and conclude the fix is present when it is
  /// not. Same lesson as the Wave-1 discipline-test bug, different file format.
  String ciYaml() => File(
    '.github/workflows/ci.yml',
  ).readAsLinesSync().where((l) => !RegExp(r'^\s*#').hasMatch(l)).join('\n');

  group('test discovery cannot silently omit tests', () {
    test('CI never passes a directory to flutter test', () {
      // The original command enumerated three directories by hand and silently
      // skipped test/widget_test.dart, which sits at the root of test/. A test
      // that is never run is worse than one that fails, because it reports
      // success. Discovery must come from the repository, not from a list.
      final bad = RegExp(
        r'flutter test[^\n]*\stest/',
      ).allMatches(ciYaml()).map((m) => m.group(0)!.trim()).toList();

      expect(
        bad,
        isEmpty,
        reason:
            'CI passes an explicit path to `flutter test`, which silently '
            'skips anything outside it. Use `flutter test` with no path and '
            'select with --tags / --exclude-tags instead.\n${bad.join('\n')}',
      );
    });

    test('CI runs the whole suite minus goldens, and the goldens by tag', () {
      final yaml = ciYaml();
      expect(
        yaml.contains('--exclude-tags golden'),
        isTrue,
        reason: 'the Linux gate must run everything except goldens',
      );
      expect(
        yaml.contains('--tags golden'),
        isTrue,
        reason: 'the Windows job must run the goldens',
      );
    });

    test('every golden test file carries the golden tag', () {
      // Selection is by tag now, so an untagged golden would run on the Linux
      // runner and fail for platform reasons that look like a real regression.
      final untagged = Directory('test/goldens')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('_test.dart'))
          .where((f) => !f.readAsStringSync().contains("@Tags(['golden'])"))
          .map((f) => f.path)
          .toList();

      expect(
        untagged,
        isEmpty,
        reason:
            'Golden test files must be annotated @Tags([\'golden\']) so CI can '
            'select them by intent. Untagged: ${untagged.join(', ')}',
      );
    });
  });

  group('the pinned SDK version has one source of truth', () {
    test('.flutter-version exists and is a plain version', () {
      final f = File('.flutter-version');
      expect(f.existsSync(), isTrue, reason: '.flutter-version is the pin');
      expect(
        RegExp(r'^\d+\.\d+\.\d+$').hasMatch(f.readAsStringSync().trim()),
        isTrue,
        reason:
            '.flutter-version must contain exactly one x.y.z and nothing '
            'else — CI reads it verbatim',
      );
    });

    test('CI reads the pin from the file rather than hardcoding it', () {
      final yaml = ciYaml();
      expect(
        yaml.contains('.flutter-version'),
        isTrue,
        reason: 'CI must read .flutter-version, not carry its own copy',
      );
      expect(
        RegExp(r'flutter-version:\s*["\x27]?\d+\.\d+\.\d+').hasMatch(yaml),
        isFalse,
        reason:
            'CI hardcodes an SDK version. That is the drift this file exists '
            'to prevent — read it from .flutter-version instead.',
      );
    });
  });

  group('release networking protection (Tier-0 C-1) stays intact', () {
    test('the main manifest declares INTERNET', () {
      // The permission lived only in src/debug and src/profile, which never
      // merge into release, so every network call failed in a release build
      // while development worked perfectly. src/main is the only source set
      // that reaches every build type. Cheap to check locally; CI checks the
      // built artefact too.
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(
        manifest.contains('android.permission.INTERNET'),
        isTrue,
        reason:
            'android/app/src/main/AndroidManifest.xml no longer declares '
            'INTERNET. Release networking is broken. Declaring it in '
            'src/debug or src/profile does NOT count — see Tier-0 C-1.',
      );
    });

    test('CI still inspects the built artefact, not just the source', () {
      final yaml = ciYaml();
      expect(
        yaml.contains('aapt2'),
        isTrue,
        reason:
            'The APK-level permission check was removed. Source inspection is '
            'not proof — C-1 was a defect the source could not reveal.',
      );
      expect(
        yaml.contains('android.permission.INTERNET'),
        isTrue,
        reason: 'the fast source-level manifest check was removed from CI',
      );
    });
  });

  group('canonical validation stays canonical', () {
    test('both validate scripts exist', () {
      expect(File('tool/validate.ps1').existsSync(), isTrue);
      expect(File('tool/validate.sh').existsSync(), isTrue);
    });

    test('the pre-push hook reuses validate.sh instead of its own checks', () {
      // A hook with its own copy of format/analyze/test drifts from CI, and
      // then a green hook stops meaning anything.
      final hook = File('.githooks/pre-push').readAsStringSync();
      expect(
        hook.contains('tool/validate.sh'),
        isTrue,
        reason: 'pre-push must delegate to the canonical validation script',
      );
    });

    test('PowerShell scripts are pure ASCII', () {
      // Windows PowerShell 5.1 reads a .ps1 without a BOM as ANSI, not UTF-8.
      // A typographic character (em-dash, curly quote) is then mis-decoded into
      // bytes that can break quote pairing and produce a parse error a hundred
      // lines away from the real cause.
      //
      // This is not theoretical: all four tool/*.ps1 scripts contained em-dashes
      // and three of them worked by luck. The fourth failed with "The string is
      // missing the terminator" pointing at a line that was perfectly valid.
      // ASCII-only removes the dependency on how the file happens to be decoded.
      final offenders = <String>[];
      for (final f in Directory(
        'tool',
      ).listSync().whereType<File>().where((f) => f.path.endsWith('.ps1'))) {
        final bytes = f.readAsBytesSync();
        final bad = bytes.where((b) => b > 127).length;
        if (bad > 0) offenders.add('${f.path} ($bad non-ASCII bytes)');
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'PowerShell scripts must be ASCII-only. Replace em-dashes and '
            'curly quotes with ASCII equivalents.\n${offenders.join('\n')}',
      );
    });

    test('hooks are NUL-safe, not whitespace-split', () {
      // `xargs` without -0 splits on whitespace, so a path containing a space
      // becomes two nonexistent paths and the hook checks the wrong thing.
      final hook = File('.githooks/pre-commit').readAsStringSync();
      expect(
        hook.contains('xargs -0'),
        isTrue,
        reason: 'pre-commit must use NUL-delimited file lists',
      );
      expect(
        RegExp(r'\|\s*xargs\s+(?!-0)').hasMatch(hook),
        isFalse,
        reason: 'a bare xargs remains in pre-commit — it splits on whitespace',
      );
    });
  });
}
