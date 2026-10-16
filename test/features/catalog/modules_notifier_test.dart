import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/session/session_scope.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/notifier/modules_notifier.dart';
import 'package:level_up_app/features/catalog/notifier/subjects_notifier.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'module_fixtures.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

/// Sign-out's real session reset, run from a live ref.
final _sessionReset = Provider<void Function()>(
  (ref) =>
      () => invalidateSessionScope(ref),
);

/// The providers and the pure functions behind the University module picker.
///
/// Error paths read the STATE rather than awaiting `.future` - a rejected
/// future races provider teardown (the catalog suite learned this already).
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

  group('modulesProvider', () {
    test('emits loading, then the modules in the order served', () async {
      when(repo.getModules).thenAnswer((_) async => u1Modules());
      final container = makeContainer();

      expect(
        container.read(modulesProvider),
        isA<AsyncLoading<List<CatalogModule>>>(),
      );

      final loaded = await container.read(modulesProvider.future);
      expect(loaded.map((m) => m.name), [
        'Foundation Module',
        'Cardiovascular Module',
      ]);
    });

    test('[] is DATA that is empty, never an error', () async {
      when(repo.getModules).thenAnswer((_) async => <CatalogModule>[]);
      final container = makeContainer();

      expect(await container.read(modulesProvider.future), isEmpty);
      expect(container.read(modulesProvider).hasError, isFalse);
    });

    test('a failure settles on AsyncError - it does NOT auto-retry', () async {
      // Riverpod 3 retries a failed build with backoff and keeps the state
      // `AsyncLoading` (carrying the error) unless the provider opts out. The
      // first failure must be an AsyncError, and the endpoint hit once.
      when(repo.getModules).thenAnswer(
        (_) => Future<List<CatalogModule>>.error(const UnknownException()),
      );
      final container = makeContainer();
      container.listen(modulesProvider, (_, _) {});

      await pumpEventQueue();

      final state = container.read(modulesProvider);
      expect(state, isA<AsyncError<List<CatalogModule>>>());
      expect(state.isLoading, isFalse);
      verify(repo.getModules).called(1);
    });

    test('offline surfaces as OfflineException on the error state', () async {
      when(repo.getModules).thenAnswer(
        (_) => Future<List<CatalogModule>>.error(const OfflineException()),
      );
      final container = makeContainer();
      container.listen(modulesProvider, (_, _) {});

      await pumpEventQueue();

      expect(container.read(modulesProvider).error, isA<OfflineException>());
    });

    test('its failure never touches subjectsProvider', () async {
      when(repo.getModules).thenAnswer(
        (_) => Future<List<CatalogModule>>.error(const UnknownException()),
      );
      when(repo.getSubjects).thenAnswer((_) async => universitySubjects());
      final container = makeContainer();
      container
        ..listen(modulesProvider, (_, _) {})
        ..listen(subjectsProvider, (_, _) {});

      await pumpEventQueue();

      expect(container.read(modulesProvider).hasError, isTrue);
      final subjects = container.read(subjectsProvider);
      expect(subjects.hasError, isFalse);
      expect(subjects.requireValue, hasLength(4));
      verify(repo.getSubjects).called(1);
    });

    test('the subjects failing does not touch modulesProvider', () async {
      when(repo.getModules).thenAnswer((_) async => u1Modules());
      when(repo.getSubjects).thenAnswer(
        (_) => Future<List<Subject>>.error(const UnknownException()),
      );
      final container = makeContainer();
      container
        ..listen(modulesProvider, (_, _) {})
        ..listen(subjectsProvider, (_, _) {});

      await pumpEventQueue();

      expect(container.read(subjectsProvider).hasError, isTrue);
      expect(container.read(modulesProvider).requireValue, hasLength(2));
    });

    test(
      'survives losing its last listener (a tab switch): no re-fetch',
      () async {
        when(repo.getModules).thenAnswer((_) async => u1Modules());
        final container = makeContainer();

        final first = container.listen(modulesProvider, (_, _) {});
        await container.read(modulesProvider.future);
        first.close();
        await pumpEventQueue();

        container.read(modulesProvider);
        verify(repo.getModules).called(1);
      },
    );
  });

  group('selectedModuleProvider', () {
    test('starts on All subjects (null)', () {
      expect(makeContainer().read(selectedModuleProvider), isNull);
    });

    test('select(id) chooses a module and select(null) returns to All', () {
      final container = makeContainer();
      final notifier = container.read(selectedModuleProvider.notifier);

      notifier.select('mod-cardio');
      expect(container.read(selectedModuleProvider), 'mod-cardio');

      notifier.select('mod-foundation');
      expect(container.read(selectedModuleProvider), 'mod-foundation');

      notifier.select(null);
      expect(container.read(selectedModuleProvider), isNull);
    });
  });

  group('invalidateSessionScope', () {
    test('resets the chosen module: a fresh session shows All subjects', () {
      final container = makeContainer();
      container.read(selectedModuleProvider.notifier).select('mod-cardio');
      expect(container.read(selectedModuleProvider), 'mod-cardio');

      container.read(_sessionReset)();

      expect(container.read(selectedModuleProvider), isNull);
    });

    test('drops the modules: the next student gets their own fetch', () async {
      when(repo.getModules).thenAnswer((_) async => u1Modules());
      final container = makeContainer();
      await container.read(modulesProvider.future);
      verify(repo.getModules).called(1);

      // Student B signs in on the same handset.
      when(repo.getModules).thenAnswer((_) async => <CatalogModule>[]);
      container.read(_sessionReset)();

      expect(await container.read(modulesProvider.future), isEmpty);
      verify(repo.getModules).called(1);
    });
  });

  group(
    'pickableModules - the row appears only for SETTLED, non-empty data',
    () {
      final some = u1Modules();

      test('data with modules -> the modules', () {
        expect(pickableModules(AsyncData(some)), some);
      });

      test('[] -> null (a school student)', () {
        expect(pickableModules(const AsyncData(<CatalogModule>[])), isNull);
      });

      test('loading -> null', () {
        expect(
          pickableModules(const AsyncLoading<List<CatalogModule>>()),
          isNull,
        );
      });

      test('error -> null', () {
        expect(
          pickableModules(
            AsyncError<List<CatalogModule>>(
              const OfflineException(),
              StackTrace.empty,
            ),
          ),
          isNull,
        );
      });

      test('a RELOAD that still carries the old value -> null (Riverpod 3: '
          'isLoading is true while value holds the previous data)', () async {
        // The previous student's grouping must not show while the next one's is
        // fetched. Driven through a real provider, not a hand-built state.
        var calls = 0;
        final second = Completer<List<CatalogModule>>();
        when(repo.getModules).thenAnswer((_) {
          calls++;
          return calls == 1 ? Future.value(some) : second.future;
        });
        final container = makeContainer();
        container.listen(modulesProvider, (_, _) {});
        await container.read(modulesProvider.future);

        container.invalidate(modulesProvider);
        final reloading = container.read(modulesProvider);

        expect(reloading.isLoading, isTrue, reason: 'it is reloading');
        expect(
          reloading.hasValue,
          isTrue,
          reason: 'and still holds the old data',
        );
        expect(pickableModules(reloading), isNull);

        second.complete(<CatalogModule>[]);
        await pumpEventQueue();
        expect(pickableModules(container.read(modulesProvider)), isNull);
      });

      test(
        'a failed reload that still carries the old value -> null',
        () async {
          var calls = 0;
          when(repo.getModules).thenAnswer((_) {
            calls++;
            return calls == 1
                ? Future.value(some)
                : Future<List<CatalogModule>>.error(const UnknownException());
          });
          final container = makeContainer();
          container.listen(modulesProvider, (_, _) {});
          await container.read(modulesProvider.future);

          container.invalidate(modulesProvider);
          await pumpEventQueue();
          final failed = container.read(modulesProvider);

          expect(failed.hasError, isTrue);
          expect(pickableModules(failed), isNull);
        },
      );
    },
  );

  group('resolveSelectedModule', () {
    final modules = u1Modules();

    test('null (All subjects) -> null', () {
      expect(resolveSelectedModule(null, modules), isNull);
    });

    test('an id that is served -> that module', () {
      expect(
        resolveSelectedModule('mod-cardio', modules)?.name,
        'Cardiovascular Module',
      );
    });

    test('an id that is no longer served -> null, i.e. All subjects', () {
      expect(resolveSelectedModule('mod-gone', modules), isNull);
    });

    test('no modules at all -> null', () {
      expect(resolveSelectedModule('mod-cardio', const []), isNull);
    });
  });

  group('subjectsForModule', () {
    final subjects =
        universitySubjects(); // anatomy, physio, biochem, histology

    List<String> ids(List<Subject> list) => [for (final s in list) s.id];

    test('null (All subjects) -> the list, unchanged and in its own order', () {
      expect(subjectsForModule(null, subjects), same(subjects));
    });

    test('a module -> exactly its subjects', () {
      final foundation = u1Modules().first;

      expect(ids(subjectsForModule(foundation, subjects)), ['uni-physio']);
    });

    test('keeps the module\'s order as served and never re-sorts', () {
      // The subjects list is anatomy, physio, biochem, histology; the module
      // names them histology, anatomy, physio - and that is the order shown.
      final m = module(
        id: 'm',
        name: 'M',
        subjectIds: const ['uni-histology', 'uni-anatomy', 'uni-physio'],
      );

      expect(ids(subjectsForModule(m, subjects)), [
        'uni-histology',
        'uni-anatomy',
        'uni-physio',
      ]);
    });

    test('skips an id with no loaded subject', () {
      final m = module(
        id: 'm',
        name: 'M',
        subjectIds: const ['uni-physio', 'not-loaded', 'uni-anatomy'],
      );

      expect(ids(subjectsForModule(m, subjects)), [
        'uni-physio',
        'uni-anatomy',
      ]);
    });

    test('an id repeated in subjectIds yields its subject once', () {
      final m = module(
        id: 'm',
        name: 'M',
        subjectIds: const ['uni-physio', 'uni-physio', 'uni-anatomy'],
      );

      expect(ids(subjectsForModule(m, subjects)), [
        'uni-physio',
        'uni-anatomy',
      ]);
    });

    test('an empty module -> empty', () {
      final m = module(id: 'm', name: 'M');

      expect(subjectsForModule(m, subjects), isEmpty);
    });

    test('a module over an empty subject list -> empty', () {
      expect(subjectsForModule(u1Modules().first, const <Subject>[]), isEmpty);
    });

    test('returns the loaded subjects themselves - a module changes nothing '
        'about them', () {
      final physio = subjects[1];

      expect(
        subjectsForModule(u1Modules().first, subjects).single,
        same(physio),
      );
    });
  });
}
