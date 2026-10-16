import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'module_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// `CatalogRepository.getModules` - `GET /catalog/modules`, the same request
/// and error-wrapping pattern as `getSubjects`.
void main() {
  late _MockDio dio;
  late CatalogRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = CatalogRepository(dio);
  });

  Response<T> response<T>(T data) => Response<T>(
    requestOptions: RequestOptions(path: '/catalog/modules'),
    statusCode: 200,
    data: data,
  );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: '/catalog/modules'),
    error: mapped,
  );

  test('parses the bare array, in the order the server sent it', () async {
    when(() => dio.get<List<dynamic>>('/catalog/modules')).thenAnswer(
      (_) async => response(<dynamic>[
        moduleJson(
          id: 'mod-1',
          name: 'Foundation Module',
          displayOrder: 1,
          termNumber: 1,
          subjectIds: const ['uni-physio'],
        ),
        moduleJson(
          id: 'mod-2',
          name: 'Cardiovascular Module',
          displayOrder: 2,
          subjectIds: const ['uni-physio', 'uni-anatomy'],
        ),
      ]),
    );

    final result = await repo.getModules();

    expect(result.map((m) => m.name), [
      'Foundation Module',
      'Cardiovascular Module',
    ]);
    expect(result.first.termNumber, 1);
    expect(result.last.termNumber, isNull);
    expect(result.last.subjectIds, ['uni-physio', 'uni-anatomy']);
  });

  test('a school student\'s [] is an empty list, not an error', () async {
    when(
      () => dio.get<List<dynamic>>('/catalog/modules'),
    ).thenAnswer((_) async => response(<dynamic>[]));

    expect(await repo.getModules(), isEmpty);
  });

  test('sends NO scope parameters - exactly this path, no query', () async {
    when(
      () => dio.get<List<dynamic>>(any()),
    ).thenAnswer((_) async => response(<dynamic>[]));

    await repo.getModules();

    verify(() => dio.get<List<dynamic>>('/catalog/modules')).called(1);
    verifyNever(
      () => dio.get<List<dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    );
  });

  test('offline surfaces as OfflineException', () async {
    when(
      () => dio.get<List<dynamic>>('/catalog/modules'),
    ).thenThrow(failure(const OfflineException()));

    expect(repo.getModules, throwsA(isA<OfflineException>()));
  });

  test('a 401 the interceptors mapped arrives as the typed ApiException', () {
    when(() => dio.get<List<dynamic>>('/catalog/modules')).thenThrow(
      failure(const ApiException(status: 401, code: 'authentication_required')),
    );

    expect(
      repo.getModules,
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
    );
  });

  test('a bypassed interceptor chain still ends as UnknownException', () {
    when(() => dio.get<List<dynamic>>('/catalog/modules')).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/catalog/modules')),
    );

    expect(repo.getModules, throwsA(isA<UnknownException>()));
  });

  test('schema drift (a missing subjectIds) is wrapped as UnknownException '
      'and leaks no body', () async {
    when(() => dio.get<List<dynamic>>('/catalog/modules')).thenAnswer(
      (_) async => response(<dynamic>[
        <String, dynamic>{
          'id': 'mod-1',
          'name': 'Secret Module Name',
          'displayOrder': 1,
        },
      ]),
    );

    await expectLater(
      repo.getModules,
      throwsA(
        isA<UnknownException>().having(
          (e) => e.detail,
          'detail',
          // The runtime type only - never a value out of the body.
          allOf(startsWith('parse: '), isNot(contains('Secret Module Name'))),
        ),
      ),
    );
  });
}
