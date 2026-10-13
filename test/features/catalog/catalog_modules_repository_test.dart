import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/catalog/repository/catalog_modules_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// `listModules` (CW16b data layer).
///
/// The rules guarded here are the ones the contract states in PROSE and that a
/// client can silently get wrong:
/// - the answer is a BARE array, not a page envelope;
/// - an EMPTY array is a normal answer (a school student always gets one);
/// - the order is the server's (`displayOrder`, then `name`) and is never
///   re-sorted here;
/// - the call carries no scope parameter at all.
void main() {
  late _MockDio dio;
  late CatalogModulesRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = CatalogModulesRepository(dio);
  });

  Response<List<dynamic>> response(List<dynamic>? data) =>
      Response<List<dynamic>>(
        requestOptions: RequestOptions(path: '/catalog/modules'),
        statusCode: 200,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: '/x'),
    error: mapped,
  );

  Map<String, dynamic> moduleJson(
    String id, {
    int displayOrder = 1,
    String name = 'Basic Sciences',
    List<String> subjectIds = const ['uni-anatomy'],
  }) => <String, dynamic>{
    'id': id,
    'name': name,
    'displayOrder': displayOrder,
    'termId': null,
    'termNumber': null,
    'subjectIds': subjectIds,
  };

  void stub(List<dynamic>? data) {
    when(
      () => dio.get<List<dynamic>>('/catalog/modules'),
    ).thenAnswer((_) async => response(data));
  }

  test('GETs /catalog/modules with no query parameter at all', () async {
    stub(const []);

    await repo.listModules();

    // The server derives scope from the token (adr-013): nothing to send. The
    // stub and this verify name the path alone, and mocktail matches an
    // invocation's named arguments exactly, so a call that added a
    // `queryParameters` would match neither and fail.
    verify(() => dio.get<List<dynamic>>('/catalog/modules')).called(1);
  });

  test('decodes the bare array into modules', () async {
    stub([
      moduleJson('m-1'),
      moduleJson('m-2', displayOrder: 2, name: 'Molecular Biology'),
    ]);

    final modules = await repo.listModules();

    expect(modules.map((m) => m.id), ['m-1', 'm-2']);
    expect(modules.last.name, 'Molecular Biology');
    expect(modules.first.subjectIds, ['uni-anatomy']);
  });

  test('an EMPTY array is a normal answer: school students get []', () async {
    stub(const []);

    expect(await repo.listModules(), isEmpty);
  });

  test('a body-less 200 reads as empty, like the subjects list', () async {
    stub(null);

    expect(await repo.listModules(), isEmpty);
  });

  test('keeps the order the server sent', () async {
    // Ordered by displayOrder then name SERVER-side; a list that arrives with a
    // higher displayOrder first must come out in that same order.
    stub([
      moduleJson('late', displayOrder: 9),
      moduleJson('early', displayOrder: 1),
    ]);

    expect((await repo.listModules()).map((m) => m.id), ['late', 'early']);
  });

  test('a module filed with no subject is kept', () async {
    stub([moduleJson('m-1', subjectIds: const [])]);

    expect((await repo.listModules()).single.subjectIds, isEmpty);
  });

  test('surfaces the mapped failures untouched', () async {
    for (final error in <AppException>[
      const UnauthorizedException(code: 'authentication_required'),
      const UnauthorizedException(code: 'session_superseded'),
      const ApiException(status: 403, code: 'account_pending_deletion'),
      const OfflineException(),
      const NetworkException(detail: 'timeout'),
      const ApiException(status: 500, code: 'internal_error'),
    ]) {
      when(
        () => dio.get<List<dynamic>>('/catalog/modules'),
      ).thenThrow(failure(error));

      await expectLater(
        repo.listModules(),
        throwsA(same(error)),
        reason: error.code,
      );
    }
  });

  test('a DioException that bypassed the interceptor is Unknown', () async {
    when(
      () => dio.get<List<dynamic>>('/catalog/modules'),
    ).thenThrow(DioException(requestOptions: RequestOptions(path: '/x')));

    await expectLater(repo.listModules(), throwsA(isA<UnknownException>()));
  });

  group('schema drift is wrapped, not leaked', () {
    Future<UnknownException> parseFailure(List<dynamic> body) async {
      stub(body);
      try {
        await repo.listModules();
      } on UnknownException catch (e) {
        return e;
      }
      fail('expected the drifted payload to throw UnknownException');
    }

    test('a module missing a required field', () async {
      final e = await parseFailure([
        moduleJson('m-1', name: 'a-module-name')..remove('subjectIds'),
      ]);

      expect(e.detail, startsWith('parse: '));
      expect(e.detail, isNot(contains('a-module-name')));
    });

    test('an element that is not an object', () async {
      final e = await parseFailure(['not an object']);

      expect(e.detail, startsWith('parse: '));
    });
  });

  test('the Riverpod provider builds the repository over dioProvider', () {
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    expect(
      container.read(catalogModulesRepositoryProvider),
      isA<CatalogModulesRepository>(),
    );
  });
}
