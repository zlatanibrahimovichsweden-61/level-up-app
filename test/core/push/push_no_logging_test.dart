import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../guards/rules.dart';

/// "Never log the token" as a test rather than a sentence in a doc comment.
///
/// A push token identifies one student's device and the tap payload carries
/// opaque ids, and many users are minors, so nothing under `lib/core/push/` may
/// reach a log: no `print`, no `debugPrint`, no `dart:developer` `log`, no
/// logging package. This reads the hand-written source with comments stripped
/// (a doc comment that merely *mentions* `print` must not trip it, and must not
/// be able to satisfy it either).
void main() {
  final files = Directory('lib/core/push')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('the push seam is actually being scanned', () {
    expect(
      files.map((f) => f.path.replaceAll(r'\', '/').split('/').last),
      containsAll([
        'push_gateway.dart',
        'push_lifecycle.dart',
        'push_tap_resolver.dart',
        'push_token_repository.dart',
      ]),
    );
  });

  final logging = <String, RegExp>{
    'print(': RegExp(r'\bprint\s*\('),
    'debugPrint(': RegExp(r'\bdebugPrint\w*\s*\('),
    'dart:developer': RegExp(r'dart:developer'),
    'log(': RegExp(r'(?<![\w.])log\s*\('),
    'Logger': RegExp(r'\bLogger\b'),
    'stderr/stdout': RegExp(r'\b(?:stderr|stdout)\b'),
    'package:logging': RegExp(r'package:logging'),
  };

  for (final file in files) {
    final path = file.path.replaceAll(r'\', '/');
    test('$path does not log', () {
      final code = stripComments(file.readAsStringSync());

      for (final entry in logging.entries) {
        expect(
          entry.value.hasMatch(code),
          isFalse,
          reason: '$path uses ${entry.key} - the token must never be logged.',
        );
      }
    });
  }
}
