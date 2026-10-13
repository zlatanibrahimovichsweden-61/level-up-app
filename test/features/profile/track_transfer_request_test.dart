import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/profile/models/track_transfer_request.dart';

/// The `POST /me/track-transfer` body (`transferToUniversity`).
///
/// The one rule that matters: `acknowledgeIrreversible` is `{ boolean, const:
/// true }` on the wire. The student's second confirm IS that `true`, so no
/// instance of the request may say anything else.
void main() {
  const request = TrackTransferRequest(
    universityId: '0197b2f3-0005-7cc3-9b4e-000000000001',
    facultyId: '0197b2f3-0006-7cc3-9b4e-000000000001',
    studyYearId: '0197b2f3-0007-7cc3-9b4e-000000000001',
  );

  group('toJson', () {
    test('is exactly the four contract keys', () {
      expect(request.toJson(), <String, dynamic>{
        'universityId': '0197b2f3-0005-7cc3-9b4e-000000000001',
        'facultyId': '0197b2f3-0006-7cc3-9b4e-000000000001',
        'studyYearId': '0197b2f3-0007-7cc3-9b4e-000000000001',
        'acknowledgeIrreversible': true,
      });
    });

    test('acknowledgeIrreversible is the boolean true, not a string or 1', () {
      final value = request.toJson()['acknowledgeIrreversible'];

      expect(value, isA<bool>());
      expect(value, isTrue);
    });

    test('there is no way to build a request that says otherwise', () {
      // A getter with no setter, and no constructor parameter: this is a
      // compile-time fact, restated at run time so a refactor to a freezed
      // `bool acknowledgeIrreversible` (settable to false) cannot slip by.
      expect(request.acknowledgeIrreversible, isTrue);
      for (final candidate in [
        request,
        const TrackTransferRequest(
          universityId: '',
          facultyId: '',
          studyYearId: '',
        ),
      ]) {
        expect(candidate.toJson()['acknowledgeIrreversible'], isTrue);
      }
    });

    test('every id reaches the wire untouched: no trimming, no validation', () {
      const odd = TrackTransferRequest(
        universityId: ' not-a-uuid ',
        facultyId: '',
        studyYearId: 'x',
      );

      expect(odd.toJson()['universityId'], ' not-a-uuid ');
      expect(odd.toJson()['facultyId'], '');
      expect(odd.toJson()['studyYearId'], 'x');
    });
  });

  group('the contract and the model agree', () {
    late String contract;
    late String operation;

    setUpAll(() {
      contract = File('contract/openapi.yaml').readAsStringSync();
      final start = contract.indexOf('operationId: transferToUniversity');
      expect(
        start,
        greaterThan(0),
        reason: 'the operation moved or was removed',
      );
      final end = contract.indexOf("'200':", start);
      operation = contract.substring(start, end);
    });

    test('the request body requires exactly the four keys toJson writes', () {
      final match = RegExp(
        r'required:\s*\[([^\]]*)\]',
      ).firstMatch(operation.substring(operation.indexOf('requestBody:')));
      expect(
        match,
        isNotNull,
        reason: 'no `required: [...]` on the request body',
      );

      final required = match!
          .group(1)!
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toSet();

      expect(request.toJson().keys.toSet(), required);
    });

    test('acknowledgeIrreversible is still `const: true` in the contract', () {
      expect(
        RegExp(
          r'acknowledgeIrreversible:\s*\{\s*type:\s*boolean,\s*const:\s*true',
        ).hasMatch(operation),
        isTrue,
        reason:
            'the contract no longer says `const: true` - the model\'s fixed '
            '`true` needs revisiting (docs/seif_fight.md), not a silent edit.',
      );
    });

    test('the success response is the StudentProfile schema', () {
      final start = contract.indexOf('operationId: transferToUniversity');
      final ok = contract.indexOf("'200':", start);
      final stop = contract.indexOf("'400':", ok);

      expect(
        contract.substring(ok, stop),
        contains("\$ref: '#/components/schemas/StudentProfile'"),
        reason:
            'the repository decodes the 200 with the existing StudentProfile.',
      );
    });
  });

  group('value semantics', () {
    test('equal when the three ids are equal', () {
      const same = TrackTransferRequest(
        universityId: '0197b2f3-0005-7cc3-9b4e-000000000001',
        facultyId: '0197b2f3-0006-7cc3-9b4e-000000000001',
        studyYearId: '0197b2f3-0007-7cc3-9b4e-000000000001',
      );

      expect(request, same);
      expect(request.hashCode, same.hashCode);
    });

    test('different when any id differs', () {
      const other = TrackTransferRequest(
        universityId: '0197b2f3-0005-7cc3-9b4e-000000000001',
        facultyId: '0197b2f3-0006-7cc3-9b4e-000000000001',
        studyYearId: '0197b2f3-0007-7cc3-9b4e-000000000002',
      );

      expect(request, isNot(other));
    });

    test('toString names the type and carries no id', () {
      expect(request.toString(), 'TrackTransferRequest');
    });
  });
}
