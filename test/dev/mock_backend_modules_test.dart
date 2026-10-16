import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';

/// The on-device preview harness must answer `GET /catalog/modules` in a shape
/// the REAL `CatalogModule` parses, per track: `[]` for a school student, and
/// for a University student the two modules that mirror Seif's staging account
/// U1 (his message of 2026-10-13). Test data, not a catalog.
void main() {
  Future<Dio> signedIn(String code) async {
    final dio = buildMockDio(latency: Duration.zero);
    await dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: <String, dynamic>{'phone': '+201001234567', 'code': code},
    );
    return dio;
  }

  Future<List<CatalogModule>> modulesOf(Dio dio) async {
    final res = await dio.get<List<dynamic>>('/catalog/modules');
    expect(res.statusCode, 200);
    return res.data!
        .map((e) => CatalogModule.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Subject>> subjectsOf(Dio dio) async =>
      (await dio.get<List<dynamic>>(
        '/catalog/subjects',
      )).data!.map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList();

  test(
    'a school student gets [] (the contract: school students get [])',
    () async {
      final dio = await signedIn('000000');

      expect(await modulesOf(dio), isEmpty);
    },
  );

  group('university mode (OTP code 111111)', () {
    test(
      'serves the two U1-like modules, in order, parsed by the real model',
      () async {
        final modules = await modulesOf(await signedIn('111111'));

        expect(modules.map((m) => m.name), [
          'Foundation Module',
          'Cardiovascular Module',
        ]);
        expect(modules.map((m) => m.displayOrder), [1, 2]);
        expect(modules.map((m) => m.termNumber), [1, 1]);
        expect(modules.map((m) => m.subjectIds), [
          ['uni-physio'],
          ['uni-physio'],
        ]);
        // `termId` is optional on the wire and is left out.
        expect(modules.every((m) => m.termId == null), isTrue);
      },
    );

    test('module ids are distinct and stable across requests', () async {
      final dio = await signedIn('111111');

      final first = (await modulesOf(dio)).map((m) => m.id).toList();
      final second = (await modulesOf(dio)).map((m) => m.id).toList();

      expect(first.toSet(), hasLength(2));
      expect(second, first);
    });

    test(
      'every module subject id names a subject the student is served',
      () async {
        final dio = await signedIn('111111');
        final served = (await subjectsOf(dio)).map((s) => s.id).toSet();

        for (final module in await modulesOf(dio)) {
          expect(served.containsAll(module.subjectIds), isTrue);
        }
      },
    );

    test('Histology, Anatomy and Biochemistry are in NO module - the '
        'permanent "All subjects" view is what shows them', () async {
      final dio = await signedIn('111111');
      final inAModule = {
        for (final module in await modulesOf(dio)) ...module.subjectIds,
      };
      final subjects = await subjectsOf(dio);

      expect(inAModule, {'uni-physio'});
      expect(
        subjects.map((s) => s.id).toSet().difference(inAModule),
        containsAll(['uni-histology', 'uni-anatomy', 'uni-biochem']),
      );
    });

    test('the mock\'s existing university subjects are untouched', () async {
      final subjects = await subjectsOf(await signedIn('111111'));

      expect(subjects.map((s) => s.id), [
        'uni-anatomy',
        'uni-physio',
        'uni-biochem',
        'uni-histology',
      ]);
    });
  });
}
