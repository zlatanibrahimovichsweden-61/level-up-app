import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The vendored contract is a byte copy of upstream, and `contract/SOURCE.md`
/// says which one.
///
/// **The gap this closes.** Upstream stores the four mobile contract files as
/// LF. A copy taken from a Windows checkout (`core.autocrlf=true`) arrives as
/// CRLF, and the only thing that noticed before was
/// `contract_models_test.dart`, failing most of its bindings with a message
/// about a missing `required:` list — true of the regex, misleading about the
/// cause. An uncommitted 2026-10-07 edition of `SOURCE.md` even claimed
/// "CRLF exactly as upstream stores them", and nothing compared that sentence
/// to the bytes.
/// This guard names the real fault: a CR byte in a vendored file, or a
/// `SOURCE.md` whose stated version is not the one in `openapi.yaml`.
///
/// **What it does NOT protect:**
/// - *Identity with upstream.* It cannot reach the upstream repository, so it
///   cannot prove the bytes equal `git rev-parse <pin>:<file>`. That check is
///   the re-vendor's own step (`SOURCE.md` records it), not this test's.
/// - *A hand edit that keeps LF.* Editing a vendored file in place passes
///   here; `git diff -- contract/` is what shows it.
/// - *The pinned commit.* Only the version line is cross-checked; the commit
///   line must merely be present and look like a commit id.
void main() {
  const vendored = [
    'contract/openapi.yaml',
    'contract/contract-changelog.md',
    'contract/error-codes.md',
    'contract/realtime.md',
  ];

  test('every vendored contract file is LF, as upstream stores it', () {
    for (final path in vendored) {
      final bytes = File(path).readAsBytesSync();
      final crs = bytes.where((b) => b == 0x0D).length;
      expect(
        crs,
        0,
        reason:
            '$path holds $crs CR bytes. Upstream stores it as LF; re-copy '
            'it with `git -C <clone> show <pin>:<file> > $path`, never from '
            "a clone's checkout.",
      );
    }
  });

  test(
    'SOURCE.md states the info.version the vendored openapi.yaml carries',
    () {
      final spec = File('contract/openapi.yaml').readAsStringSync();
      final source = File('contract/SOURCE.md').readAsStringSync();

      final version = RegExp(
        r'^  version: (\S+)$',
        multiLine: true,
      ).firstMatch(spec)?.group(1);
      final stated = RegExp(
        r'^info\.version at this pin: (\S+)$',
        multiLine: true,
      ).firstMatch(source)?.group(1);
      final pinned = RegExp(
        r'^Pinned commit: ([0-9a-f]{7,40})\b',
        multiLine: true,
      ).firstMatch(source)?.group(1);

      expect(version, isNotNull, reason: 'openapi.yaml has no info.version');
      expect(
        pinned,
        isNotNull,
        reason: 'SOURCE.md has no "Pinned commit: <sha>" line',
      );
      expect(
        stated,
        version,
        reason:
            'SOURCE.md and openapi.yaml disagree about the pinned version: '
            'one was re-vendored without the other',
      );
    },
  );
}
