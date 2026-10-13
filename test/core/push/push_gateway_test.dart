import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/push/push_gateway.dart';

import '../../guards/rules.dart';

/// The seam's contract with the rest of the app: a Noop that can never produce
/// a token, a tap payload that holds only strings, and - mechanised, because a
/// prose rule here would decay - no entrypoint hands out a different gateway.
void main() {
  group('NoopPushGateway', () {
    test('has no token', () async {
      expect(await const NoopPushGateway().currentToken(), isNull);
    });

    test('never refreshes and never taps', () async {
      const gateway = NoopPushGateway();

      expect(await gateway.tokenRefreshes.isEmpty, isTrue);
      expect(await gateway.taps.isEmpty, isTrue);
    });
  });

  group('PushTap', () {
    test('keeps string-to-string entries and drops everything else', () {
      final tap = PushTap.fromData(<Object?, Object?>{
        'kind': 'support_ticket_replied',
        'ticketId': 'abc',
        'count': 3,
        7: 'numeric key',
        'nested': <String, String>{'a': 'b'},
        'nothing': null,
      });

      expect(tap.data, {'kind': 'support_ticket_replied', 'ticketId': 'abc'});
      expect(tap.kind, 'support_ticket_replied');
    });

    test('the kept map cannot be mutated', () {
      final tap = PushTap.fromData(<Object?, Object?>{'kind': 'x'});

      expect(() => tap.data['kind'] = 'y', throwsUnsupportedError);
    });

    test('a payload without a kind has none', () {
      expect(const PushTap({}).kind, isNull);
    });

    test('toString reports the kind only, never an id', () {
      const tap = PushTap({
        'kind': 'support_ticket_replied',
        'ticketId': 'ticket-secret-id',
      });

      expect(tap.toString(), 'PushTap(kind: support_ticket_replied)');
      expect(tap.toString(), isNot(contains('ticket-secret-id')));
    });
  });

  group('no real flavor is given a token-capable gateway', () {
    // The entrypoints are where provider overrides live. The gateway's own
    // provider defaults to the Noop; handing out anything else is a decision
    // that needs the owner (BACKEND_HANDOFF.md:486, D-023 / R-9) and the SDK
    // (CW08b) - so until then no entrypoint may mention the gateway at all.
    const entrypoints = <String>[
      'lib/bootstrap.dart',
      'lib/main.dart',
      'lib/main_dev.dart',
      'lib/main_mock.dart',
      'lib/main_prod.dart',
      'lib/main_staging.dart',
    ];

    for (final path in entrypoints) {
      test('$path does not mention the push gateway', () {
        final code = stripComments(File(path).readAsStringSync());

        expect(code, isNot(contains('pushGatewayProvider')));
        expect(code, isNot(contains('PushGateway')));
        expect(code, isNot(contains('core/push/')));
      });
    }

    test('the seam is Firebase-free: no dependency, no import', () {
      // The SDK is CW08b and needs the owner's authorisation (BH-G8). Until
      // then nothing may pull it in - not through pubspec.yaml, and not through
      // an import that a transitive package happens to provide.
      final pubspec = stripComments(File('pubspec.yaml').readAsStringSync());
      expect(
        RegExp(r'^\s*firebase_\w+\s*:', multiLine: true).hasMatch(pubspec),
        isFalse,
        reason: 'pubspec.yaml declares a firebase_* dependency',
      );

      final importing = libSources()
          .where((s) => RegExp(r'package:firebase_').hasMatch(s.text))
          .map((s) => s.path)
          .toList();
      expect(importing, isEmpty);
    });

    test('the only gateway implementations are the Noop and test fakes', () {
      final implementers = libSources()
          .where((s) => RegExp(r'implements\s+PushGateway\b').hasMatch(s.text))
          .map((s) => s.path)
          .toList();

      expect(implementers, ['lib/core/push/push_gateway.dart']);
    });
  });
}
