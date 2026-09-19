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

  group('the release build command names the production entrypoint', () {
    // There are no Gradle product flavors and no iOS schemes. The ONLY thing
    // deciding which backend a release artefact talks to is the `-t` argument,
    // and `lib/main.dart` forwards to `main_dev.dart` — so a flagless
    // `flutter build apk --release` compiles the dev flavor, which resolves
    // AppConfig.baseUrl to the live staging host.
    //
    // Verified at ARTEFACT level on 2026-09-05, not reasoned about: both APKs
    // were built and unzipped, and `level-up-backend-staging.up.railway.app`
    // is present in lib/*/libapp.so of the flagless build and absent from the
    // `-t lib/main_prod.dart` one. docs/RELEASE_SIGNING.md carried the flagless
    // command until that day, which is the whole argument for making this a
    // test instead of a sentence.
    // Scanned by tree, not by a hand-written file list. "We fixed the instance
    // we noticed" is how the xargs defect below recurred, and the same trap
    // applies here: a release command can be written into any doc or script.
    const operationalTrees = <String>['docs', 'tool', '.github', '.githooks'];
    const textExtensions = <String>['.md', '.ps1', '.sh', '.yml', '.yaml'];

    /// `flutter build apk|appbundle|ipa|ios` — the store-artefact commands.
    ///
    /// NOT anchored on `--release`: release is Flutter's DEFAULT build mode, so
    /// a bare `flutter build apk` is a release build too and must obey the same
    /// rule. Only an explicit `--debug`/`--profile` opts out.
    final buildCommand = RegExp(r'^flutter build (apk|appbundle|ipa|ios)\b');
    final notRelease = RegExp(r'--(debug|profile)\b');

    /// Accepts every spelling of the flag that actually works, so a legitimate
    /// `--target=./lib/main_prod.dart` or a Windows `lib\main_prod.dart` is not
    /// reported. A false positive would be the worse defect (ENFORCEMENT.md).
    final prodTarget = RegExp(
      '(?:-t|--target)[=\\s]+[\'"]?\\.?[\\\\/]?lib[\\\\/]main_prod\\.dart',
    );

    /// A line is a runnable command only if it *starts* one, once the shell,
    /// PowerShell, YAML and Markdown prefixes are stripped, and once repeated
    /// whitespace is collapsed (`flutter  build` is the same command).
    ///
    /// Prose that merely mentions a command mid-sentence — including the
    /// warning in RELEASE_SIGNING.md that explains this very hazard, and the
    /// table in the 2026-09-05 audit — is not a command and must not trip the
    /// guard, or documenting the rule would violate it.
    ///
    /// Known limit: a command hidden inside a wrapper (`sh -c "..."`,
    /// `cd x && flutter build`) or split across a line continuation is not
    /// seen. Nothing in this repository writes one that way; if that changes,
    /// widen this rather than trusting the prose.
    String? asCommand(String line) {
      var s = line.trim().replaceAll(RegExp(r'\s+'), ' ');
      for (final prefix in const ['- run: ', 'run: ', '> ', '- ', '* ', '& ']) {
        if (s.startsWith(prefix)) s = s.substring(prefix.length).trim();
      }
      if (s.startsWith(r'$ ')) s = s.substring(2).trim();
      return buildCommand.hasMatch(s) ? s : null;
    }

    /// Every runnable store-artefact build command in the operational trees.
    List<({String path, int line, String command})> releaseBuildCommands() {
      final found = <({String path, int line, String command})>[];
      for (final tree in operationalTrees) {
        final dir = Directory(tree);
        if (!dir.existsSync()) continue;
        for (final entity in dir.listSync(recursive: true)) {
          if (entity is! File) continue;
          final path = entity.path.replaceAll(r'\', '/');
          final hasKnownExtension = textExtensions.any(path.endsWith);
          final isExtensionless = !path.split('/').last.contains('.');
          if (!hasKnownExtension && !isExtensionless) continue;

          late final List<String> lines;
          try {
            lines = entity.readAsLinesSync();
          } on FileSystemException {
            continue; // not text; nothing to read
          }

          for (var i = 0; i < lines.length; i++) {
            final command = asCommand(lines[i]);
            if (command == null) continue;
            if (notRelease.hasMatch(command)) continue;
            found.add((path: path, line: i + 1, command: command));
          }
        }
      }
      return found;
    }

    test('every runnable release-build command targets lib/main_prod.dart', () {
      final offenders = [
        for (final c in releaseBuildCommands())
          if (!prodTarget.hasMatch(c.command))
            '  ${c.path}:${c.line}  ${c.command}',
      ];

      expect(
        offenders,
        isEmpty,
        reason:
            'A release build command does not name the production entrypoint:\n'
            '${offenders.join('\n')}\n'
            'Without `-t lib/main_prod.dart` the build compiles lib/main.dart, '
            'which forwards to main_dev.dart — so the shipped artefact talks to '
            'the staging backend. Add the flag. (Remember release is the '
            'DEFAULT build mode: a bare `flutter build apk` is a release too.)',
      );
    });

    test('the scan actually finds the release commands it is guarding', () {
      // The positive companion. The test above only proves that nothing it
      // FOUND was wrong, so on its own it stays green if the scan finds
      // nothing at all — a renamed doc, a reworded code fence, a changed file
      // extension. Same lesson as the xargs pair below: a negative rule needs
      // a positive one or deletion satisfies it.
      final found = releaseBuildCommands();

      expect(
        found.length,
        greaterThanOrEqualTo(3),
        reason:
            'Only ${found.length} release-build command(s) found across '
            '$operationalTrees. There should be at least three — the CI job, '
            'tool/verify_release_manifest.ps1, and docs/RELEASE_SIGNING.md. '
            'If the scan has stopped seeing them, the guard above is passing '
            'vacuously and protects nothing.\n'
            '${found.map((c) => '  ${c.path}:${c.line}').join('\n')}',
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

    test('every shell script that batches files is NUL-safe', () {
      // `xargs` without -0 splits on whitespace, so a path containing a space
      // becomes two nonexistent paths and the script silently checks the wrong
      // files — or errors in a way that looks unrelated.
      //
      // Wave 2 fixed this in .githooks/pre-commit and MISSED tool/validate.sh,
      // which is the canonical script CI and the pre-push hook both depend on.
      // Fable caught it. So the guard covers every shell entry point rather
      // than the one file that happened to be looked at, because "we fixed the
      // instance we noticed" is precisely how this recurred.
      const shellScripts = [
        '.githooks/pre-commit',
        '.githooks/pre-push',
        'tool/validate.sh',
      ];

      // Shell comments stripped: these files DISCUSS bare xargs in prose, and
      // prose must never satisfy — or trip — a structural rule. Same lesson as
      // the Wave-1 discipline-test bug and the ci.yml comment.
      String code(String path) => File(path)
          .readAsLinesSync()
          .where((l) => !RegExp(r'^\s*#').hasMatch(l))
          .join('\n');

      final offenders = <String>[];
      for (final path in shellScripts) {
        final src = code(path);
        // Any xargs invocation must carry -0. Matches `| xargs foo` and
        // `xargs foo < file`, both of which read a file list.
        for (final m in RegExp(r'xargs(\s+-\S+)*').allMatches(src)) {
          if (!m.group(0)!.contains('-0')) {
            offenders.add('$path: ${m.group(0)!.trim()}');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'A bare xargs splits on whitespace and breaks on filenames with '
            'spaces. Use NUL-delimited input end to end: `git ... -z` piped '
            'through `grep -zZv` into `xargs -0`.\n${offenders.join('\n')}',
      );
    });

    test('validate.sh feeds xargs a NUL-delimited list', () {
      // The negative test above proves no bare xargs remains. This proves the
      // positive: the canonical script actually builds a NUL-delimited list.
      // Without both, deleting the xargs call entirely would pass the guard.
      final src = File('tool/validate.sh').readAsStringSync();
      expect(
        src.contains('git ls-files -z'),
        isTrue,
        reason: 'validate.sh must produce a NUL-delimited file list',
      );
      expect(
        src.contains('xargs -0'),
        isTrue,
        reason: 'validate.sh must consume it with xargs -0',
      );
    });
  });
}
