import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../guards/rules.dart';

/// "Never log the transfer" as a test. The transfer flow touches a minor's
/// profile (name, phone, school, points) and a one-way account change, so none
/// of the new transfer files may reach a log: no `print`, no `debugPrint`, no
/// `dart:developer` `log`, no logging package. Hand-written source only,
/// comments stripped.
void main() {
  const files = <String>[
    'lib/features/profile/models/track_transfer_request.dart',
    'lib/features/profile/repository/track_transfer_repository.dart',
    'lib/features/profile/track_transfer_errors.dart',
  ];

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
    test('$path exists and does not log', () {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: '$path was moved or removed');

      final code = stripComments(file.readAsStringSync());
      for (final entry in logging.entries) {
        expect(
          entry.value.hasMatch(code),
          isFalse,
          reason:
              '$path uses ${entry.key} - nothing about a transfer may be logged.',
        );
      }
    });
  }
}
