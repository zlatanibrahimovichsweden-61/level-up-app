import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/deletion/models/deletion_window.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

import '../../dev/contract_inline.dart';

/// The `requestAccountDeletion` 202 body (CW05 data layer): `{requestedAt,
/// effectiveAt}`, both required, both UTC.
void main() {
  const body = <String, dynamic>{
    'requestedAt': '2026-10-12T08:00:00Z',
    'effectiveAt': '2026-11-11T08:00:00Z',
  };

  group('decoding', () {
    test('both instants, as UTC', () {
      final w = DeletionWindow.fromJson(body);
      expect(w.requestedAt, DateTime.utc(2026, 10, 12, 8));
      expect(w.effectiveAt, DateTime.utc(2026, 11, 11, 8));
      expect(w.requestedAt.isUtc, isTrue);
      expect(w.effectiveAt.isUtc, isTrue);
    });

    test('effectiveAt is taken as served - nothing here adds days', () {
      // The contract says requestedAt + 30 days, but that is the server's
      // arithmetic: an effectiveAt that is NOT 30 days on is shown as served.
      final w = DeletionWindow.fromJson({
        ...body,
        'effectiveAt': '2026-10-13T08:00:00Z',
      });
      expect(w.effectiveAt, DateTime.utc(2026, 10, 13, 8));
    });

    test(
      'offsets and fractional seconds are normalised to the same instant',
      () {
        final w = DeletionWindow.fromJson({
          'requestedAt': '2026-10-12T10:00:00.500+02:00',
          'effectiveAt': '2026-11-11T08:00:00.500Z',
        });
        expect(w.requestedAt, DateTime.utc(2026, 10, 12, 8, 0, 0, 500));
        expect(w.requestedAt.isUtc, isTrue);
      },
    );

    for (final key in body.keys) {
      test('a body without `$key` is a typed failure', () {
        expect(
          () => DeletionWindow.fromJson({...body}..remove(key)),
          throwsA(isA<TypeError>()),
        );
      });
    }

    test('a null or unparseable instant is a failure, not a default', () {
      expect(
        () => DeletionWindow.fromJson({...body, 'effectiveAt': null}),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => DeletionWindow.fromJson({...body, 'requestedAt': 'tomorrow'}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('reuse of the existing PendingDeletion', () {
    test('pending is the model GET /me already decodes, not a copy of it', () {
      final w = DeletionWindow.fromJson(body);

      // The same fact from the other source: GET /me's `pendingDeletion`.
      final fromMe = PendingDeletion.fromJson({
        'effectiveAt': body['effectiveAt'],
      });

      expect(w.pending, isA<PendingDeletion>());
      expect(w.pending, fromMe);
      expect(w.pending.effectiveAt, w.effectiveAt);
    });

    test('the 202 body decodes through PendingDeletion too: requestedAt is '
        'the one field it has no place for', () {
      final fromBody = PendingDeletion.fromJson(body);
      expect(fromBody.effectiveAt, DeletionWindow.fromJson(body).effectiveAt);
    });
  });

  group('value semantics', () {
    test('equal when both instants are', () {
      expect(DeletionWindow.fromJson(body), DeletionWindow.fromJson(body));
      expect(
        DeletionWindow.fromJson(body).hashCode,
        DeletionWindow.fromJson(body).hashCode,
      );
      expect(
        DeletionWindow.fromJson(body),
        isNot(
          DeletionWindow.fromJson({
            ...body,
            'effectiveAt': '2026-11-12T08:00:00Z',
          }),
        ),
      );
    });

    test('toString prints no time', () {
      final text = DeletionWindow.fromJson(body).toString();
      expect(text, 'DeletionWindow()');
      expect(text, isNot(contains('2026')));
    });
  });

  group('the pinned contract', () {
    late ContractOperation post;

    setUpAll(() {
      post = ContractOperation.find(
        File('contract/openapi.yaml').readAsStringSync(),
        path: '/me/deletion-request',
        method: 'post',
      );
    });

    test('requestAccountDeletion is stable and authenticated, answers 202 '
        'with exactly these two required fields', () {
      expect(post.operationId, 'requestAccountDeletion');
      expect(post.isStable, isTrue);
      expect(post.isAnonymous, isFalse);
      expect(post.responseRequired('202'), ['requestedAt', 'effectiveAt']);
      expect(post.responseProperties('202'), ['requestedAt', 'effectiveAt']);
    });

    test('every contract-required field is a constructor parameter', () {
      final dart = File(
        'lib/features/deletion/models/deletion_window.dart',
      ).readAsStringSync();
      expect(
        missingModelFields(
          dart,
          'DeletionWindow',
          post.responseRequired('202'),
        ),
        isEmpty,
      );
    });

    test('and 409 is the answer to a request that is already pending', () {
      expect(post.hasResponse('409'), isTrue);
      expect(post.text, contains('deletion_already_requested'));
    });
  });
}
