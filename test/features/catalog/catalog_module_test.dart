import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';

import 'module_fixtures.dart';

/// `CatalogModule` against `GET /catalog/modules` (`listModules`): required
/// `[id, name, displayOrder, subjectIds]`; `termId` / `termNumber` optional.
void main() {
  test('decodes every field of the contract item', () {
    final m = CatalogModule.fromJson(
      moduleJson(
        id: 'mod-1',
        name: 'Cardiovascular Module',
        displayOrder: 2,
        termId: 'term-opaque',
        termNumber: 3,
        subjectIds: const ['uni-physio', 'uni-anatomy'],
      ),
    );

    expect(m.id, 'mod-1');
    expect(m.name, 'Cardiovascular Module');
    expect(m.displayOrder, 2);
    expect(m.termId, 'term-opaque');
    expect(m.termNumber, 3);
    expect(m.subjectIds, ['uni-physio', 'uni-anatomy']);
  });

  test('termId and termNumber are optional - absent decodes to null, with '
      'NO default', () {
    final m = CatalogModule.fromJson(
      moduleJson(id: 'mod-1', name: 'Foundation Module'),
    );

    expect(m.termId, isNull);
    expect(m.termNumber, isNull);
  });

  test('an explicit null term is accepted too', () {
    final m = CatalogModule.fromJson(<String, dynamic>{
      ...moduleJson(id: 'mod-1', name: 'Foundation Module'),
      'termId': null,
      'termNumber': null,
    });

    expect(m.termId, isNull);
    expect(m.termNumber, isNull);
  });

  test('subjectIds may be empty (a module with no released subject)', () {
    final m = CatalogModule.fromJson(
      moduleJson(id: 'mod-1', name: 'Foundation Module'),
    );

    expect(m.subjectIds, isEmpty);
  });

  test('subjectIds keeps the order the server sent', () {
    final m = CatalogModule.fromJson(
      moduleJson(
        id: 'mod-1',
        name: 'Foundation Module',
        subjectIds: const ['c', 'a', 'b'],
      ),
    );

    expect(m.subjectIds, ['c', 'a', 'b']);
  });

  test('a missing subjectIds is a decode failure, not an empty list', () {
    // `subjectIds` is REQUIRED. Defaulting it to `[]` would turn contract drift
    // into a module that silently shows nothing.
    final json = moduleJson(id: 'mod-1', name: 'Foundation Module')
      ..remove('subjectIds');

    expect(() => CatalogModule.fromJson(json), throwsA(isA<TypeError>()));
  });

  for (final field in ['id', 'name', 'displayOrder']) {
    test('a missing $field is a decode failure', () {
      final json = moduleJson(id: 'mod-1', name: 'Foundation Module')
        ..remove(field);

      expect(() => CatalogModule.fromJson(json), throwsA(isA<TypeError>()));
    });
  }

  test('equal modules are equal (freezed value semantics)', () {
    final a = module(id: 'm', name: 'N', subjectIds: const ['x']);
    final b = module(id: 'm', name: 'N', subjectIds: const ['x']);

    expect(a, b);
  });
}
