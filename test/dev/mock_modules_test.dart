import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_modules.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/repository/catalog_modules_repository.dart';

/// `GET /catalog/modules`, served by the standalone on-device mock
/// (`lib/dev/mock_modules.dart`).
///
/// A school student always gets `[]`, and Seif's seed-account table
/// (`docs/BACKEND_HANDOFF.md` BH-H1, not probed by this repo) describes no module
/// grouping for its one university account (U1), so nothing says staging can
/// show a module picker real groups, a shared `displayOrder`, a module with no
/// term or a module with no subjects; this mock is how a screen gets them.
/// These pin what the contract specifies - school gets `[]`, the university answer is
/// a bare array ordered by `displayOrder` then `name`, `termId`/`termNumber`
/// nullable, `subjectIds` possibly empty, a subject in zero modules legal - and
/// drive it through the REAL [CatalogModulesRepository], which also proves the
/// request the app builds is the one the mock understands.
///
/// Each session here wires the mock into a Dio of its own the way the
/// interceptor does, with the REAL `ErrorInterceptor` after it, so the rules
/// are tested alone. That `mock_backend.dart` dispatches to it is proven by
/// `mock_backend_quiz_history_test.dart`.
void main() {
  group('university', () {
    test('answers the four fixture modules', () async {
      final modules = await _Session(university: true).repo.listModules();

      expect(modules, hasLength(4));
      expect(modules.map((m) => m.name).toSet(), hasLength(4));
      for (final m in modules) {
        expect(m.name, isNotEmpty);
      }
    });

    test('ordered by displayOrder, then name - not by declaration', () async {
      final modules = await _Session(university: true).repo.listModules();

      expect(modules.map((m) => m.name), [
        'Basic Sciences',
        // displayOrder 2 twice: name decides.
        'Microscopic Studies',
        'Molecular Biology',
        'Electives',
      ]);
      // The fixtures are declared as 1, 2, 3, 4: the served order differs.
      expect(modules.map((m) => m.id), [
        mockModuleId(1),
        mockModuleId(3),
        mockModuleId(2),
        mockModuleId(4),
      ]);
      for (var i = 1; i < modules.length; i++) {
        expect(
          modules[i].displayOrder,
          greaterThanOrEqualTo(modules[i - 1].displayOrder),
        );
      }
      expect(modules[1].displayOrder, modules[2].displayOrder);
    });

    test('a module may have no term, and no subjects', () async {
      final modules = await _Session(university: true).repo.listModules();

      final electives = modules.firstWhere((m) => m.name == 'Electives');
      expect(electives.termId, isNull);
      expect(electives.termNumber, isNull);
      expect(electives.subjectIds, isEmpty);

      final termed = modules.where((m) => m.name != 'Electives');
      for (final m in termed) {
        expect(m.termId, isNotNull, reason: m.name);
        expect(m.termNumber, anyOf(1, 2), reason: m.name);
      }
      expect(termed.map((m) => m.termNumber).toSet(), {
        1,
        2,
      }, reason: 'both terms are covered');
    });

    test('a subject is filed in at most one module, and one in none', () async {
      final modules = await _Session(university: true).repo.listModules();

      final filed = [for (final m in modules) ...m.subjectIds];
      expect(filed.toSet(), hasLength(filed.length), reason: 'no repeats');
      expect(filed, isNot(contains(kMockUnfiledModuleSubject)));
    });

    test('the sample JSON is plain data: it survives jsonEncode', () {
      final reply = const MockModules().handle(
        'GET',
        '/catalog/modules',
        university: true,
      );

      final json = jsonDecode(jsonEncode((reply! as MockModulesOk).data));

      expect(json, isA<List<dynamic>>());
      expect(json as List<dynamic>, hasLength(4));
    });

    test('every key is sent, termId and termNumber as explicit nulls', () {
      final reply = const MockModules().handle(
        'GET',
        '/catalog/modules',
        university: true,
      );

      for (final m in (reply! as MockModulesOk).data) {
        expect(m.keys.toSet(), {
          'id',
          'name',
          'displayOrder',
          'termId',
          'termNumber',
          'subjectIds',
        });
      }
    });
  });

  group('school', () {
    test('gets the empty array: a normal answer, not an error', () async {
      final modules = await _Session(university: false).repo.listModules();

      expect(modules, isEmpty);
    });
  });

  group('the mock backend\'s own university catalog', () {
    test('every filed subject exists in GET /catalog/subjects', () async {
      // The module fixtures name the ids of mock_backend.dart's four university
      // subjects. If that file renames one, the picker would show a module
      // pointing at nothing - caught here, not on a device.
      final dio = buildMockDio(latency: Duration.zero);
      await dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: <String, dynamic>{'phone': '+201001234567', 'code': '111111'},
      );
      final subjectIds = (await dio.get<List<dynamic>>('/catalog/subjects'))
          .data!
          .map((e) => Subject.fromJson(e as Map<String, dynamic>).id)
          .toSet();
      final modules = await _Session(university: true).repo.listModules();

      final filed = {for (final m in modules) ...m.subjectIds};
      expect(subjectIds.containsAll(filed), isTrue, reason: '$filed');
      // The subject filed nowhere is real, and "All subjects" (the catalog
      // itself) is a strict superset of what the modules cover.
      expect(subjectIds, contains(kMockUnfiledModuleSubject));
      expect(subjectIds.length, greaterThan(filed.length));
      expect(
        filed.union({kMockUnfiledModuleSubject}),
        subjectIds,
        reason: 'the fixtures account for every university subject',
      );
    });
  });

  group('routing', () {
    test('serves GET /catalog/modules and nothing else', () {
      const mock = MockModules();

      expect(
        mock.handle('GET', '/catalog/modules', university: true),
        isNotNull,
      );
      expect(mock.handle('POST', '/catalog/modules', university: true), isNull);
      expect(mock.handle('GET', '/catalog/subjects', university: true), isNull);
      expect(
        mock.handle('GET', '/catalog/modules/abc', university: true),
        isNull,
      );
      expect(mock.handle('GET', '/me/quiz-summary', university: true), isNull);
    });

    test(
      'a route it does not serve is the interceptor\'s generic 404',
      () async {
        final dio = _Session(university: true).dio;

        try {
          await dio.get<Object?>('/catalog/subjects');
          fail('expected the generic 404');
        } on DioException catch (e) {
          expect(e.response?.statusCode, 404);
        }
      },
    );

    test(
      'every request gets the same answer: the mock holds no state',
      () async {
        final a = await _Session(university: true).repo.listModules();
        final b = await _Session(university: true).repo.listModules();

        expect(a, b);
        expect(
          const MockModules().handle(
            'GET',
            '/catalog/modules',
            university: true,
          ),
          isA<MockModulesOk>(),
        );
      },
    );
  });

  test('decodes through the real model, keys and nulls included', () async {
    final modules = await _Session(university: true).repo.listModules();

    expect(modules.first, isA<CatalogModule>());
    expect(modules.first.subjectIds, ['uni-anatomy']);
    expect(modules.first.termId, 'term-01HZY0');
  });
}

/// One mock session: [MockModules] behind the same wiring the interceptor uses
/// (the reply resolved, then the REAL `ErrorInterceptor`), driven by the REAL
/// repository. [university] is the mock session's track.
class _Session {
  _Session({required bool university}) {
    dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api/v1'))
      ..interceptors.addAll([_Route(university), ErrorInterceptor()]);
    repo = CatalogModulesRepository(dio);
  }

  late final Dio dio;
  late final CatalogModulesRepository repo;
}

class _Route extends Interceptor {
  _Route(this._university);

  final bool _university;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final reply = const MockModules().handle(
      options.method.toUpperCase(),
      options.path,
      university: _university,
    );
    switch (reply) {
      case MockModulesOk(:final data):
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: data,
          ),
        );
      case null:
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              requestOptions: options,
              statusCode: 404,
              data: <String, dynamic>{
                'title': 'Not served',
                'status': 404,
                'code': 'not_found',
              },
            ),
          ),
          true,
        );
    }
  }
}
