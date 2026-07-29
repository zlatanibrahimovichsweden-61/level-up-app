import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// The repository's job: parse the contract's shapes, and surface failures as
/// the typed `AppException` the UI branches on. Anything Dio-shaped stops here.
void main() {
  late _MockDio dio;
  late CatalogRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = CatalogRepository(dio);
  });

  Response<T> response<T>(T data, {int status = 200, String path = '/x'}) =>
      Response<T>(
        requestOptions: RequestOptions(path: path),
        statusCode: status,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
        requestOptions: RequestOptions(path: '/x'),
        error: mapped,
      );

  group('getSubjects', () {
    test('parses the bare array', () async {
      when(() => dio.get<List<dynamic>>('/catalog/subjects'))
          .thenAnswer((_) async => response(subjectsJson()));

      final result = await repo.getSubjects();

      expect(result, hasLength(3));
      expect(result.first.name, 'Biology');
      expect(result.last.questionCounter.total, 0);
    });

    test('an empty catalog is an empty list, not an error', () async {
      when(() => dio.get<List<dynamic>>('/catalog/subjects'))
          .thenAnswer((_) async => response(<dynamic>[]));

      expect(await repo.getSubjects(), isEmpty);
    });

    test('sends NO scope parameters — the server derives scope (adr-013)',
        () async {
      when(() => dio.get<List<dynamic>>(any()))
          .thenAnswer((_) async => response(subjectsJson()));

      await repo.getSubjects();

      // Exactly this path, no query string.
      verify(() => dio.get<List<dynamic>>('/catalog/subjects')).called(1);
    });

    test('offline surfaces as OfflineException', () async {
      when(() => dio.get<List<dynamic>>('/catalog/subjects'))
          .thenThrow(failure(const OfflineException()));

      expect(repo.getSubjects, throwsA(isA<OfflineException>()));
    });
  });

  group('getSubjectTree', () {
    test('parses the school tree', () async {
      when(() => dio.get<Map<String, dynamic>>('/catalog/subjects/sub-1/tree'))
          .thenAnswer((_) async => response(schoolTreeJson()));

      final tree = await repo.getSubjectTree('sub-1');

      expect(tree.units, hasLength(2));
      expect(tree.units.first.chapters.first.lessons, hasLength(2));
    });

    test('403 surfaces as insufficient_scope, not a generic failure', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenThrow(
        failure(const ApiException(status: 403, code: 'insufficient_scope')),
      );

      await expectLater(
        () => repo.getSubjectTree('sub-9'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 403)
              .having((e) => e.code, 'code', 'insufficient_scope'),
        ),
      );
    });

    test('a university tree is refused, not half-parsed', () async {
      // The `oneOf`'s other branch. Parsing it as a school tree would throw a
      // raw TypeError out of generated code; this must be a typed AppException.
      when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => response(<String, dynamic>{
          'track': 'university',
          'quizTypes': <dynamic>['normal'],
          'lectures': <dynamic>[],
        }),
      );

      expect(
        () => repo.getSubjectTree('sub-uni'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('offline surfaces as OfflineException', () async {
      when(() => dio.get<Map<String, dynamic>>(any()))
          .thenThrow(failure(const OfflineException()));

      expect(
        () => repo.getSubjectTree('sub-1'),
        throwsA(isA<OfflineException>()),
      );
    });

    test('an unmapped Dio failure falls back to UnknownException', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/x')),
      );

      expect(
        () => repo.getSubjectTree('sub-1'),
        throwsA(isA<UnknownException>()),
      );
    });
  });
}
