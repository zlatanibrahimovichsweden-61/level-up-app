import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/notifier/reference_providers.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:mocktail/mocktail.dart';

/// `status: active | soon` on the School stages and education systems
/// (`listSchoolStages`, `listEducationSystems`; contract 3.52.0-m1) — the data
/// layer: the two models, the repository call and the two providers.
///
/// The contract gives no `example` for either response, so the fixtures follow
/// its SCHEMA: `listSchoolStages` is a bare array of `{stage, status}`, both
/// required; `listEducationSystems` items are `{code, nameAr, nameEn, status}`,
/// all four required.

class _MockDio extends Mock implements Dio {}

class _MockReferenceRepo extends Mock implements ReferenceRepository {}

Response<T> _ok<T>(T data) => Response<T>(
  requestOptions: RequestOptions(path: '/'),
  statusCode: 200,
  data: data,
);

DioException _dioError(Object mapped) => DioException(
  requestOptions: RequestOptions(path: '/'),
  error: mapped, // the ErrorInterceptor already put an AppException here
);

/// The six stages in the contract's fixed order, as the wire carries them.
List<Map<String, dynamic>> _wireStages({
  Map<String, String> status = const {},
}) => [
  for (final stage in const [
    'prep1',
    'prep2',
    'prep3',
    'secondary1',
    'secondary2',
    'secondary3',
  ])
    {'stage': stage, 'status': status[stage] ?? 'active'},
];

void main() {
  group('SchoolStageRef', () {
    test('decodes {stage, status}', () {
      expect(
        SchoolStageRef.fromJson({'stage': 'secondary2', 'status': 'active'}),
        const SchoolStageRef(stage: 'secondary2', status: 'active'),
      );
      expect(
        SchoolStageRef.fromJson({'stage': 'prep1', 'status': 'soon'}).status,
        'soon',
      );
    });

    test('round-trips to the wire shape', () {
      const ref = SchoolStageRef(stage: 'prep3', status: 'soon');
      expect(SchoolStageRef.fromJson(ref.toJson()), ref);
      expect(ref.toJson(), {'stage': 'prep3', 'status': 'soon'});
    });

    test('tolerates a status and a stage this build has never seen', () {
      // Kept Strings on purpose: a value the server adds one day must not throw
      // the whole list away. The UI refuses it (disabled) instead.
      final ref = SchoolStageRef.fromJson({
        'stage': 'prep9',
        'status': 'paused',
      });
      expect(ref.stage, 'prep9');
      expect(ref.status, 'paused');
    });

    test('a missing status throws — contract drift surfaces', () {
      expect(
        () => SchoolStageRef.fromJson({'stage': 'prep1'}),
        throwsA(anything),
      );
    });

    test('a missing stage throws', () {
      expect(
        () => SchoolStageRef.fromJson({'status': 'active'}),
        throwsA(anything),
      );
    });
  });

  group('EducationSystemRef', () {
    test('decodes {code, nameAr, nameEn, status}', () {
      expect(
        EducationSystemRef.fromJson({
          'code': 'ig',
          'nameAr': 'آي جي',
          'nameEn': 'IG',
          'status': 'soon',
        }),
        const EducationSystemRef(
          code: 'ig',
          nameAr: 'آي جي',
          nameEn: 'IG',
          status: 'soon',
        ),
      );
    });

    test('tolerates a code and a status this build has never seen', () {
      final ref = EducationSystemRef.fromJson({
        'code': 'stem',
        'nameAr': 'ستيم',
        'nameEn': 'STEM',
        'status': 'paused',
      });
      expect(ref.code, 'stem');
      expect(ref.status, 'paused');
    });

    test('a missing status throws — it is contract-required', () {
      expect(
        () => EducationSystemRef.fromJson({
          'code': 'ig',
          'nameAr': 'آي جي',
          'nameEn': 'IG',
        }),
        throwsA(anything),
      );
    });
  });

  group('ReferenceRepository.getSchoolStages', () {
    late _MockDio dio;
    late ReferenceRepository repo;

    setUp(() {
      dio = _MockDio();
      repo = ReferenceRepository(dio);
    });

    test('GETs /reference/school-stages and keeps the served order', () async {
      when(() => dio.get<List<dynamic>>('/reference/school-stages')).thenAnswer(
        (_) async => _ok<List<dynamic>>(
          _wireStages(status: {'prep1': 'soon', 'secondary1': 'soon'}),
        ),
      );

      final stages = await repo.getSchoolStages();

      expect(stages.map((s) => s.stage), [
        'prep1',
        'prep2',
        'prep3',
        'secondary1',
        'secondary2',
        'secondary3',
      ]);
      expect(stages.map((s) => s.status), [
        'soon',
        'active',
        'active',
        'soon',
        'active',
        'active',
      ]);
      verify(
        () => dio.get<List<dynamic>>('/reference/school-stages'),
      ).called(1);
    });

    test('an item without status is drift: UnknownException, no body in the '
        'detail', () async {
      when(() => dio.get<List<dynamic>>('/reference/school-stages')).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {'stage': 'prep1'},
        ]),
      );

      await expectLater(
        repo.getSchoolStages(),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail,
            'detail',
            allOf(startsWith('parse:'), isNot(contains('prep1'))),
          ),
        ),
      );
    });

    test('offline maps to OfflineException', () async {
      when(
        () => dio.get<List<dynamic>>('/reference/school-stages'),
      ).thenThrow(_dioError(const OfflineException()));

      await expectLater(
        repo.getSchoolStages(),
        throwsA(isA<OfflineException>()),
      );
    });

    test('429 rate_limited keeps its type and Retry-After', () async {
      when(() => dio.get<List<dynamic>>('/reference/school-stages')).thenThrow(
        _dioError(const RateLimitedException(retryAfter: Duration(seconds: 7))),
      );

      await expectLater(
        repo.getSchoolStages(),
        throwsA(
          isA<RateLimitedException>().having(
            (e) => e.retryAfter,
            'retryAfter',
            const Duration(seconds: 7),
          ),
        ),
      );
    });

    test(
      'a bare/unmapped DioException falls back to UnknownException',
      () async {
        when(
          () => dio.get<List<dynamic>>('/reference/school-stages'),
        ).thenThrow(_dioError('not an AppException'));

        await expectLater(
          repo.getSchoolStages(),
          throwsA(isA<UnknownException>()),
        );
      },
    );
  });

  group('ReferenceRepository.getEducationSystems', () {
    late _MockDio dio;
    late ReferenceRepository repo;

    setUp(() {
      dio = _MockDio();
      repo = ReferenceRepository(dio);
    });

    test('carries each row\'s status', () async {
      when(
        () => dio.get<List<dynamic>>('/reference/education-systems'),
      ).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {
            'code': 'nationalArabic',
            'nameAr': 'الوطني عربي',
            'nameEn': 'National (Arabic)',
            'status': 'active',
          },
          {'code': 'ig', 'nameAr': 'آي جي', 'nameEn': 'IG', 'status': 'soon'},
        ]),
      );

      final systems = await repo.getEducationSystems();

      expect(systems.map((s) => (s.code, s.status)), [
        ('nationalArabic', 'active'),
        ('ig', 'soon'),
      ]);
    });

    test('a row without status is drift: UnknownException', () async {
      when(
        () => dio.get<List<dynamic>>('/reference/education-systems'),
      ).thenAnswer(
        (_) async => _ok<List<dynamic>>([
          {'code': 'ig', 'nameAr': 'آي جي', 'nameEn': 'IG'},
        ]),
      );

      await expectLater(
        repo.getEducationSystems(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('the two status providers', () {
    late _MockReferenceRepo repo;

    setUp(() => repo = _MockReferenceRepo());

    ProviderContainer containerWith() {
      final c = ProviderContainer(
        overrides: [referenceRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('schoolStagesProvider opts out of retry: the first failure is an '
        'AsyncError, with the repository called once', () async {
      when(repo.getSchoolStages).thenThrow(const OfflineException());
      final c = containerWith();
      c.listen(schoolStagesProvider, (_, _) {});

      await pumpEventQueue();

      final state = c.read(schoolStagesProvider);
      expect(state, isA<AsyncError<List<SchoolStageRef>>>());
      expect(state.isLoading, isFalse, reason: 'no retry may be pending');
      expect(state.error, isA<OfflineException>());
      verify(repo.getSchoolStages).called(1);
    });

    test('educationSystemsProvider still opts out of retry', () async {
      when(repo.getEducationSystems).thenThrow(const OfflineException());
      final c = containerWith();
      c.listen(educationSystemsProvider, (_, _) {});

      await pumpEventQueue();

      final state = c.read(educationSystemsProvider);
      expect(state, isA<AsyncError<List<EducationSystemRef>>>());
      expect(state.isLoading, isFalse);
      verify(repo.getEducationSystems).called(1);
    });

    test('schoolStagesProvider is autoDispose: a second visit asks the '
        'server again', () async {
      when(repo.getSchoolStages).thenAnswer(
        (_) async => [
          for (final s in _wireStages()) SchoolStageRef.fromJson(s),
        ],
      );
      final c = containerWith();

      final first = c.listen(schoolStagesProvider, (_, _) {});
      await c.read(schoolStagesProvider.future);
      first.close();
      await pumpEventQueue(); // the last listener left: the value is dropped

      final second = c.listen(schoolStagesProvider, (_, _) {});
      await c.read(schoolStagesProvider.future);
      second.close();

      verify(repo.getSchoolStages).called(2);
    });

    test('educationSystemsProvider is autoDispose: a second visit asks the '
        'server again', () async {
      when(repo.getEducationSystems).thenAnswer(
        (_) async => const [
          EducationSystemRef(
            code: 'nationalArabic',
            nameAr: 'الوطني عربي',
            nameEn: 'National (Arabic)',
            status: 'active',
          ),
        ],
      );
      final c = containerWith();

      final first = c.listen(educationSystemsProvider, (_, _) {});
      await c.read(educationSystemsProvider.future);
      first.close();
      await pumpEventQueue();

      final second = c.listen(educationSystemsProvider, (_, _) {});
      await c.read(educationSystemsProvider.future);
      second.close();

      verify(repo.getEducationSystems).called(2);
    });

    test('while one visit lasts the answer is NOT fetched again', () async {
      // The other half of the contract: autoDispose must not turn every read
      // into a request. Two reads under one listener are one request.
      when(repo.getSchoolStages).thenAnswer(
        (_) async => [
          for (final s in _wireStages()) SchoolStageRef.fromJson(s),
        ],
      );
      final c = containerWith();

      final visit = c.listen(schoolStagesProvider, (_, _) {});
      await c.read(schoolStagesProvider.future);
      await c.read(schoolStagesProvider.future);
      visit.close();

      verify(repo.getSchoolStages).called(1);
    });
  });
}
