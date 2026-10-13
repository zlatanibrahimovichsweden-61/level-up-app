import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../guards/rules.dart';

/// "Never log the code" as a test. The invite code identifies a student's
/// referral link and many users are minors, so nothing under
/// `lib/features/referral/` may reach a log: no `print`, no `debugPrint`, no
/// `dart:developer` `log`, no logging package. Hand-written source only, comments
/// stripped so prose that merely mentions `print` neither trips nor satisfies it.
void main() {
  final files = Directory('lib/features/referral')
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.replaceAll(r'\', '/'))
      .where((p) => p.endsWith('.dart'))
      .where((p) => !p.endsWith('.g.dart') && !p.endsWith('.freezed.dart'))
      .toList();

  test('the referral feature is actually being scanned', () {
    expect(
      files.map((p) => p.split('/').last),
      containsAll(['my_invite.dart', 'referral_repository.dart']),
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

  for (final path in files) {
    test('$path does not log', () {
      final code = stripComments(File(path).readAsStringSync());

      for (final entry in logging.entries) {
        expect(
          entry.value.hasMatch(code),
          isFalse,
          reason:
              '$path uses ${entry.key} - the invite code must never be logged.',
        );
      }
    });
  }
}
