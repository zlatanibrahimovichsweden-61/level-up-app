import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/catalog/notifier/subject_tree_notifier.dart';
import 'package:level_up_app/features/catalog/notifier/subjects_notifier.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

/// Notifier-level behaviour: the state sequence the widgets branch on, and the
/// caching rule the whole drill-down depends on.
///
/// Error paths read the STATE rather than awaiting `.future` — a rejected
/// future races provider teardown, which is what the registration suite already
/// learned the hard way.
void main() {
  late _MockCatalogRepository repo;

  setUp(() {
    repo = _MockCatalogRepository();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('subjectsProvider', () {
    test('emits loading then the subjects', () async {
      when(repo.getSubjects).thenAnswer((_) async => subjects());
      final container = makeContainer();

      expect(container.read(subjectsProvider), isA<AsyncLoading<List<Subject>>>());

      final loaded = await container.read(subjectsProvider.future);
      expect(loaded, hasLength(3));
      expect(container.read(subjectsProvider).value, hasLength(3));
    });

    test('an empty catalog is DATA that is empty, never an error', () async {
      when(repo.getSubjects).thenAnswer((_) async => <Subject>[]);
      final container = makeContainer();

      expect(await container.read(subjectsProvider.future), isEmpty);
      expect(container.read(subjectsProvider).hasError, isFalse);
    });

    test('a failure settles on AsyncError — it does NOT auto-retry', () async {
      // Regression guard for the Riverpod-3 behaviour found in the Day-4 sweep:
      // without `retry: noCatalogRetry` the provider retries with backoff and
      // the state stays AsyncLoading(error:), so the screen would show an
      // endless skeleton instead of the error view, while hammering the API.
      when(repo.getSubjects).thenAnswer(
        (_) => Future<List<Subject>>.error(const UnknownException()),
      );
      final container = makeContainer();
      container.listen(subjectsProvider, (_, _) {});

      await pumpEventQueue();

      final state = container.read(subjectsProvider);
      expect(state, isA<AsyncError<List<Subject>>>());
      expect(state.isLoading, isFalse);
      verify(repo.getSubjects).called(1);
    });

    test('offline surfaces as OfflineException so the UI can pick its view',
        () async {
      when(repo.getSubjects).thenAnswer(
        (_) => Future<List<Subject>>.error(const OfflineException()),
      );
      final container = makeContainer();
      container.listen(subjectsProvider, (_, _) {});

      await pumpEventQueue();

      expect(container.read(subjectsProvider).error, isA<OfflineException>());
    });

    test('refresh re-requests — the only way a retry ever happens', () async {
      when(repo.getSubjects).thenAnswer((_) async => subjects());
      final container = makeContainer();
      await container.read(subjectsProvider.future);

      await container.read(subjectsProvider.notifier).refresh();

      verify(repo.getSubjects).called(2);
    });
  });

  group('subjectTreeProvider', () {
    test('fetches the tree ONCE and serves every later read from cache',
        () async {
      when(() => repo.getSubjectTree('sub-1'))
          .thenAnswer((_) async => schoolTree());
      final container = makeContainer();

      // Units, Chapters and Lessons each watch the same provider.
      await container.read(subjectTreeProvider('sub-1').future);
      container.read(subjectTreeProvider('sub-1'));
      container.read(subjectTreeProvider('sub-1'));
      final third = await container.read(subjectTreeProvider('sub-1').future);

      expect((third as SchoolSubjectTree).units, hasLength(2));
      verify(() => repo.getSubjectTree('sub-1')).called(1);
    });

    test('is keyed by subjectId — a different subject is its own fetch',
        () async {
      when(() => repo.getSubjectTree(any()))
          .thenAnswer((_) async => schoolTree());
      final container = makeContainer();

      await container.read(subjectTreeProvider('sub-1').future);
      await container.read(subjectTreeProvider('sub-2').future);

      verify(() => repo.getSubjectTree('sub-1')).called(1);
      verify(() => repo.getSubjectTree('sub-2')).called(1);
    });

    test('a failure settles on AsyncError — no silent auto-retry', () async {
      when(() => repo.getSubjectTree(any())).thenAnswer(
        (_) => Future<SchoolSubjectTree>.error(
          const ApiException(status: 403, code: 'insufficient_scope'),
        ),
      );
      final container = makeContainer();
      container.listen(subjectTreeProvider('sub-9'), (_, _) {});

      await pumpEventQueue();

      final state = container.read(subjectTreeProvider('sub-9'));
      expect(state, isA<AsyncError<SubjectTree>>());
      expect(
        (state.error! as ApiException).code,
        'insufficient_scope',
      );
      verify(() => repo.getSubjectTree('sub-9')).called(1);
    });

    test('offline surfaces as OfflineException', () async {
      when(() => repo.getSubjectTree(any())).thenAnswer(
        (_) => Future<SchoolSubjectTree>.error(const OfflineException()),
      );
      final container = makeContainer();
      container.listen(subjectTreeProvider('sub-1'), (_, _) {});

      await pumpEventQueue();

      expect(
        container.read(subjectTreeProvider('sub-1')).error,
        isA<OfflineException>(),
      );
    });

    test('refresh re-requests that subject only', () async {
      when(() => repo.getSubjectTree('sub-1'))
          .thenAnswer((_) async => schoolTree());
      final container = makeContainer();
      await container.read(subjectTreeProvider('sub-1').future);

      await container.read(subjectTreeProvider('sub-1').notifier).refresh();

      verify(() => repo.getSubjectTree('sub-1')).called(2);
    });
  });

  group('client-side search', () {
    test('a blank query returns the whole list, not nothing', () {
      expect(filterSubjects(subjects(), ''), hasLength(3));
      expect(filterSubjects(subjects(), '   '), hasLength(3));
    });

    test('matches a substring, case-insensitively', () {
      expect(
        filterSubjects(subjects(), 'BIO').single.name,
        'Biology',
      );
      expect(filterSubjects(subjects(), 'sic').single.name, 'Physics');
    });

    test('ignores Arabic diacritics and alef/ya/ta-marbuta forms', () {
      // A student typing bare letters must still find the vowelled name.
      final list = [
        const Subject(
          id: 'x',
          name: 'مُراجَعَة الأحياء',
          questionCounter: QuestionCounter(answered: 0, total: 0),
        ),
      ];

      expect(filterSubjects(list, 'مراجعه'), hasLength(1));
      expect(filterSubjects(list, 'الاحياء'), hasLength(1));
      expect(filterSubjects(list, 'كيمياء'), isEmpty);
    });

    test('no match returns empty — the screen shows a no-results message', () {
      expect(filterSubjects(subjects(), 'zzz'), isEmpty);
    });
  });
}
