import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/mistakes/models/mistakes_tree.dart';
import 'package:level_up_app/features/mistakes/repository/mistakes_repository.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:mocktail/mocktail.dart';

import 'mistakes_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// The repository's job: parse the contract's two shapes, and surface failures
/// as the typed `AppException` the UI branches on.
///
/// The rules being guarded here are the ones the contract states in prose and
/// that a client can silently get wrong: empty is NORMAL, the tree is
/// server-summed, and the two `403`s are different states.
void main() {
  late _MockDio dio;
  late MistakesRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = MistakesRepository(dio);
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

  group('getMistakes — the overview', () {
    test('parses the bare array in the order the server sent it', () async {
      when(
        () => dio.get<List<dynamic>>('/me/mistakes'),
      ).thenAnswer((_) async => response(mistakesOverviewJson()));

      final result = await repo.getMistakes();

      expect(result, hasLength(3));
      // Server order preserved — `name` asc then `id`. The client must not sort.
      expect(result.map((s) => s.name), ['Biology', 'Chemistry', 'Physics']);
      expect(result.first.mistakeCount, 20);
    });

    test('an empty list is a NORMAL response, not an error', () async {
      when(
        () => dio.get<List<dynamic>>('/me/mistakes'),
      ).thenAnswer((_) async => response(<dynamic>[]));

      // A student with nothing outstanding. Clients MUST NOT render
      // empty-as-error (openapi.yaml:895-897).
      expect(await repo.getMistakes(), isEmpty);
    });

    test('sends NO scope parameters — the server derives scope', () async {
      when(
        () => dio.get<List<dynamic>>(any()),
      ).thenAnswer((_) async => response(mistakesOverviewJson()));

      await repo.getMistakes();

      // Exactly this path, no query string.
      verify(() => dio.get<List<dynamic>>('/me/mistakes')).called(1);
    });

    test(
      'term keys decode whether null, absent or populated (S42 is open)',
      () async {
        when(
          () => dio.get<List<dynamic>>('/me/mistakes'),
        ).thenAnswer((_) async => response(mistakesOverviewJson()));

        final result = await repo.getMistakes();

        // Explicit null — the school case the contract calls out.
        expect(result[0].termId, isNull);
        expect(result[0].termNumber, isNull);
        // Keys OMITTED entirely: they are in `properties` but not `required`.
        // Until S42 is answered the tolerant reading must not throw.
        expect(result[1].termId, isNull);
        expect(result[1].termNumber, isNull);
        // Populated, as a university subject would be.
        expect(result[2].termId, 'term-uuid-1');
        expect(result[2].termNumber, 2);
      },
    );

    test('a 403 surfaces as a typed ApiException carrying its code', () async {
      when(() => dio.get<List<dynamic>>('/me/mistakes')).thenThrow(
        failure(const ApiException(status: 403, code: 'insufficient_scope')),
      );

      // On THIS route `insufficient_scope` means "no active enrolment to scope
      // a history against" — NOT a membership refusal about a subject. The
      // repository's job is only to preserve the code so the screen can tell
      // the two routes' meanings apart.
      await expectLater(
        repo.getMistakes(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'insufficient_scope')
              .having((e) => e.status, 'status', 403),
        ),
      );
    });

    test('account_pending_deletion is preserved, not collapsed', () async {
      when(() => dio.get<List<dynamic>>('/me/mistakes')).thenThrow(
        failure(
          const ApiException(status: 403, code: 'account_pending_deletion'),
        ),
      );

      // Neither Mistakes route is on adr-114's four-route allowlist, so this is
      // reachable. It must reach the global interceptor intact — do not log out
      // and do not retry.
      await expectLater(
        repo.getMistakes(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'account_pending_deletion',
          ),
        ),
      );
    });
  });

  group('getMistakesForSubject — the tree', () {
    test('decodes the SCHOOL branch, three levels deep', () async {
      when(
        () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/sub-bio'),
      ).thenAnswer((_) async => response(schoolMistakesTreeJson()));

      final tree = await repo.getMistakesForSubject('sub-bio');

      expect(tree, isA<SchoolMistakesTree>());
      final school = tree as SchoolMistakesTree;
      expect(school.track, Track.school);
      expect(school.mistakeCount, 20);
      expect(school.units, hasLength(2));
      expect(school.units.first.chapters, hasLength(2));
      expect(school.units.first.chapters.first.lessons.first.name, 'Genetics');
      expect(school.units.first.chapters.first.lessons.first.mistakeCount, 3);
    });

    test('decodes the UNIVERSITY branch — flat, and no quizTypes', () async {
      when(
        () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/sub-phys'),
      ).thenAnswer((_) async => response(universityMistakesTreeJson()));

      final tree = await repo.getMistakesForSubject('sub-phys');

      expect(tree, isA<UniversityMistakesTree>());
      final uni = tree as UniversityMistakesTree;
      expect(uni.track, Track.university);
      expect(uni.lectures, hasLength(2));
      expect(uni.lectures.last.mistakeCount, 15);
    });

    test(
      'an in-scope subject with no mistakes is a NORMAL 200, not an error',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/clean'),
        ).thenAnswer((_) async => response(emptySchoolMistakesTreeJson()));

        final tree = await repo.getMistakesForSubject('clean');

        // openapi.yaml:960-964 — mistakeCount 0 + empty units. Branch on the
        // STATUS, never on emptiness: the 403 below is a different state and
        // both are reachable with an empty history.
        expect(tree.mistakeCount, 0);
        expect((tree as SchoolMistakesTree).units, isEmpty);
      },
    );

    test('the university empty tree is equally normal', () async {
      when(
        () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/clean-uni'),
      ).thenAnswer((_) async => response(emptyUniversityMistakesTreeJson()));

      final tree = await repo.getMistakesForSubject('clean-uni');

      expect(tree.mistakeCount, 0);
      expect((tree as UniversityMistakesTree).lectures, isEmpty);
    });

    test(
      'an out-of-scope subjectId is 403, NOT an empty tree — different state',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/nope'),
        ).thenThrow(
          failure(const ApiException(status: 403, code: 'insufficient_scope')),
        );

        await expectLater(
          repo.getMistakesForSubject('nope'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              'insufficient_scope',
            ),
          ),
        );
      },
    );

    test('an unknown track is contract drift and throws loudly', () async {
      when(
        () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/weird'),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{
          'track': 'apprenticeship',
          'mistakeCount': 1,
          'units': <dynamic>[],
        }),
      );

      // Fails with a typed error rather than rendering an empty screen.
      await expectLater(
        repo.getMistakesForSubject('weird'),
        throwsA(isA<UnknownException>()),
      );
    });

    test(
      'the client performs NO arithmetic — a parent count is rendered verbatim',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/odd'),
        ).thenAnswer(
          (_) async => response(schoolMistakesTreeInconsistentJson()),
        );

        final tree =
            await repo.getMistakesForSubject('odd') as SchoolMistakesTree;

        // The server owns the summing (openapi.yaml:953-957). Even when the
        // parent disagrees with its children, the client reports the SERVER's
        // number and never recomputes one from the other.
        expect(tree.mistakeCount, 99);
        expect(tree.units.first.mistakeCount, 42);
        final childSum = tree.units.first.chapters.fold<int>(
          0,
          (sum, c) => sum + c.mistakeCount,
        );
        expect(childSum, 7, reason: 'fixture sanity: children really sum to 7');
        expect(
          tree.units.first.mistakeCount,
          isNot(childSum),
          reason: 'the client must not "correct" a parent from its descendants',
        );
      },
    );
  });

  group('failure boundary (F-7-01)', () {
    test('a parse failure becomes UnknownException, body-free', () async {
      when(
        () => dio.get<List<dynamic>>('/me/mistakes'),
      ).thenAnswer((_) async => response(<dynamic>[<String, dynamic>{}]));

      try {
        await repo.getMistakes();
        fail('expected an UnknownException');
      } on UnknownException catch (e) {
        // runtimeType only. Response bodies carry minors' data and must never
        // leak into an error detail.
        expect(e.detail, startsWith('parse: '));
        expect(e.detail, isNot(contains('Biology')));
        expect(e.detail, isNot(contains('mistakeCount')));
      }
    });

    test('a tree parse failure is wrapped the same way', () async {
      when(
        () => dio.get<Map<String, dynamic>>('/me/mistakes/subjects/bad'),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{
          'track': 'school',
          'units': 'not-a-list',
        }),
      );

      await expectLater(
        repo.getMistakesForSubject('bad'),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail,
            'detail',
            startsWith('parse: '),
          ),
        ),
      );
    });
  });
}
