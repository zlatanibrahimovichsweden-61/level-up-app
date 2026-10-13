import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/legal/models/terms_acceptance.dart';

import '../../dev/contract_inline.dart';

/// The `getTermsAcceptance` 200 body (CW04b data layer): four fields, all
/// required by the contract, three of them nullable.
///
/// Fixtures are the states the contract defines (`openapi.yaml:1083`): nothing
/// accepted, accepted and current, accepted an older version, and nothing
/// configured (inert).
void main() {
  const never = <String, dynamic>{
    'currentVersion': 'r4-2026-10-07',
    'acceptedVersion': null,
    'acceptedAtUtc': null,
    'isCurrent': false,
  };
  const current = <String, dynamic>{
    'currentVersion': 'r4-2026-10-07',
    'acceptedVersion': 'r4-2026-10-07',
    'acceptedAtUtc': '2026-10-08T09:30:00Z',
    'isCurrent': true,
  };
  const older = <String, dynamic>{
    'currentVersion': 'r5-2026-11-01',
    'acceptedVersion': 'r4-2026-10-07',
    'acceptedAtUtc': '2026-10-08T09:30:00.250Z',
    'isCurrent': false,
  };
  const inert = <String, dynamic>{
    'currentVersion': null,
    'acceptedVersion': null,
    'acceptedAtUtc': null,
    'isCurrent': false,
  };

  group('decoding the states the contract defines', () {
    test('nothing accepted yet: both acceptance fields are null', () {
      final t = TermsAcceptance.fromJson(never);
      expect(t.currentVersion, 'r4-2026-10-07');
      expect(t.acceptedVersion, isNull);
      expect(t.acceptedAtUtc, isNull);
      expect(t.isCurrent, isFalse);
      expect(t.isInert, isFalse);
    });

    test('accepted and current: the server time, as a UTC instant', () {
      final t = TermsAcceptance.fromJson(current);
      expect(t.acceptedVersion, t.currentVersion);
      expect(t.acceptedAtUtc, DateTime.utc(2026, 10, 8, 9, 30));
      expect(t.acceptedAtUtc!.isUtc, isTrue);
      expect(t.isCurrent, isTrue);
    });

    test('an older acceptance is kept as served, with its own time', () {
      final t = TermsAcceptance.fromJson(older);
      expect(t.acceptedVersion, 'r4-2026-10-07');
      expect(t.currentVersion, 'r5-2026-11-01');
      expect(t.acceptedAtUtc, DateTime.utc(2026, 10, 8, 9, 30, 0, 250));
      expect(t.isCurrent, isFalse);
    });

    test('nothing configured: the feature is inert', () {
      final t = TermsAcceptance.fromJson(inert);
      expect(t.currentVersion, isNull);
      expect(t.isInert, isTrue);
      expect(t.isCurrent, isFalse);
    });

    test('an offset in the time is normalised to the same UTC instant', () {
      final t = TermsAcceptance.fromJson({
        ...current,
        'acceptedAtUtc': '2026-10-08T11:30:00+02:00',
      });
      expect(t.acceptedAtUtc, DateTime.utc(2026, 10, 8, 9, 30));
      expect(t.acceptedAtUtc!.isUtc, isTrue);
    });
  });

  group('server is authoritative', () {
    test(
      'isCurrent is shown as served, never recomputed from the versions',
      () {
        // Equal versions and a served `false`: the server decides.
        final falseOnEqual = TermsAcceptance.fromJson({
          ...current,
          'isCurrent': false,
        });
        expect(falseOnEqual.currentVersion, falseOnEqual.acceptedVersion);
        expect(falseOnEqual.isCurrent, isFalse);

        // Different versions and a served `true`: still the server's word.
        final trueOnDifferent = TermsAcceptance.fromJson({
          ...older,
          'isCurrent': true,
        });
        expect(
          trueOnDifferent.currentVersion,
          isNot(trueOnDifferent.acceptedVersion),
        );
        expect(trueOnDifferent.isCurrent, isTrue);
      },
    );
  });

  group('strict where the contract is strict', () {
    for (final key in never.keys) {
      test('a body without `$key` is a typed failure, even for a nullable '
          'field (the key must be PRESENT)', () {
        expect(
          () => TermsAcceptance.fromJson({...current}..remove(key)),
          throwsA(isA<Object>()),
        );
        expect(
          () => TermsAcceptance.fromJson({...inert}..remove(key)),
          throwsA(isA<Object>()),
        );
      });
    }

    test('the failure for a missing key names the key and nothing else', () {
      try {
        TermsAcceptance.fromJson({...current}..remove('acceptedAtUtc'));
        fail('expected a FormatException');
      } on FormatException catch (e) {
        expect(e.message, contains('acceptedAtUtc'));
        expect(e.message, isNot(contains('r4-2026-10-07')));
      }
    });

    test('a mistyped field is a failure, not a default', () {
      expect(
        () => TermsAcceptance.fromJson({...current, 'isCurrent': 'true'}),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => TermsAcceptance.fromJson({...current, 'currentVersion': 4}),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => TermsAcceptance.fromJson({
          ...current,
          'acceptedAtUtc': 'not a time',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('value semantics', () {
    test('equal when every field is', () {
      expect(
        TermsAcceptance.fromJson(current),
        TermsAcceptance.fromJson(current),
      );
      expect(
        TermsAcceptance.fromJson(current).hashCode,
        TermsAcceptance.fromJson(current).hashCode,
      );
      expect(
        TermsAcceptance.fromJson(current),
        isNot(TermsAcceptance.fromJson(older)),
      );
    });

    test('toString carries the verdict only: no version, no time', () {
      final text = TermsAcceptance.fromJson(current).toString();
      expect(text, 'TermsAcceptance(isCurrent: true)');
      expect(text, isNot(contains('r4-2026-10-07')));
      expect(text, isNot(contains('2026')));
    });
  });

  group('the pinned contract', () {
    late ContractOperation get;

    setUpAll(() {
      get = ContractOperation.find(
        File('contract/openapi.yaml').readAsStringSync(),
        path: '/me/terms-acceptance',
        method: 'get',
      );
    });

    test('getTermsAcceptance is the stable, authenticated operation', () {
      expect(get.operationId, 'getTermsAcceptance');
      expect(get.isStable, isTrue);
      // Authenticated: the student comes from the access token.
      expect(get.isAnonymous, isFalse);
    });

    test('exactly the four fields the model takes are required, and they '
        'are all of them', () {
      final required = get.responseRequired('200');
      expect(required, [
        'currentVersion',
        'acceptedVersion',
        'acceptedAtUtc',
        'isCurrent',
      ]);
      expect(get.responseProperties('200').toSet(), required.toSet());
    });

    test('every contract-required field is a constructor parameter', () {
      final dart = File(
        'lib/features/legal/models/terms_acceptance.dart',
      ).readAsStringSync();
      expect(
        missingModelFields(
          dart,
          'TermsAcceptance',
          get.responseRequired('200'),
        ),
        isEmpty,
      );
    });
  });
}
