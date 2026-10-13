import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';

import '../quiz/quiz_history_contract.dart';

/// One element of `GET /catalog/modules`, shaped from the inline item schema in
/// `contract/openapi.yaml` (pin 3.46.0-m1): `id`, `name`, `displayOrder` and
/// `subjectIds` are required; `termId` and `termNumber` are optional and
/// nullable.
void main() {
  Map<String, dynamic> moduleJson({
    Object? termId = 'term-01HZY0',
    Object? termNumber = 1,
    List<String> subjectIds = const ['uni-anatomy', 'uni-physio'],
  }) => <String, dynamic>{
    'id': '6d000000-0000-4000-8000-000000000001',
    'name': 'Basic Sciences',
    'displayOrder': 1,
    'termId': termId,
    'termNumber': termNumber,
    'subjectIds': subjectIds,
  };

  test('decodes every field', () {
    final m = CatalogModule.fromJson(moduleJson());

    expect(m.id, '6d000000-0000-4000-8000-000000000001');
    expect(m.name, 'Basic Sciences');
    expect(m.displayOrder, 1);
    expect(m.termId, 'term-01HZY0');
    expect(m.termNumber, 1);
    expect(m.subjectIds, ['uni-anatomy', 'uni-physio']);
  });

  test('termId and termNumber may be null, and null is normal', () {
    final m = CatalogModule.fromJson(
      moduleJson(termId: null, termNumber: null),
    );

    expect(m.termId, isNull);
    expect(m.termNumber, isNull);
  });

  test('termId and termNumber may be ABSENT: they are not required', () {
    final json = moduleJson()
      ..remove('termId')
      ..remove('termNumber');

    final m = CatalogModule.fromJson(json);

    expect(m.termId, isNull);
    expect(m.termNumber, isNull);
  });

  test('subjectIds may be empty', () {
    final m = CatalogModule.fromJson(moduleJson(subjectIds: const []));

    expect(m.subjectIds, isEmpty);
  });

  test('subjectIds keeps the order the server sent', () {
    final m = CatalogModule.fromJson(
      moduleJson(subjectIds: const ['b', 'a', 'c']),
    );

    expect(m.subjectIds, ['b', 'a', 'c']);
  });

  test('every contract-required key is required', () {
    for (final key in ['id', 'name', 'displayOrder', 'subjectIds']) {
      final json = moduleJson()..remove(key);
      expect(
        () => CatalogModule.fromJson(json),
        throwsA(anything),
        reason: 'removing `$key`',
      );
    }
  });

  test('a subjectIds entry that is not a string is drift and throws', () {
    final json = moduleJson()..['subjectIds'] = [1, 2];

    expect(() => CatalogModule.fromJson(json), throwsA(anything));
  });

  test('a key this app predates is ignored, not an error', () {
    // `subjectIds` "may become embedded objects" is a contract note, not a
    // shape: an extra sibling key must not break the decode.
    final m = CatalogModule.fromJson(moduleJson()..['somethingAddedLater'] = 1);

    expect(m.name, 'Basic Sciences');
  });

  test('every required field of the listModules item is '
      'modelled', () {
    // READ from contract/openapi.yaml at run time, not hardcoded. The item is
    // an inline schema, which test/guards/contract_models_test.dart cannot
    // reach.
    const anchor = 'operationId: listModules';
    expect(
      requiredAfter(File('contract/openapi.yaml').readAsStringSync(), anchor),
      contains('subjectIds'),
      reason: 'the anchor lands on the item list',
    );

    expect(
      unmodelledFields(
        anchor: anchor,
        dartFile: 'lib/features/catalog/models/catalog_module.dart',
        className: 'CatalogModule',
      ),
      isEmpty,
    );
  });

  test('round-trips through jsonEncode', () {
    final m = CatalogModule.fromJson(moduleJson());

    expect(
      CatalogModule.fromJson(jsonDecode(jsonEncode(m)) as Map<String, dynamic>),
      m,
    );
  });
}
