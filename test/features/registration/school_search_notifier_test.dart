import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/notifier/school_search_notifier.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockReferenceRepo extends Mock implements ReferenceRepository {}

NamedRef _school(String id) =>
    NamedRef(id: id, nameAr: 'مدرسة $id', nameEn: 'School $id');

const _filter = (q: null, governorateId: 'gov-cairo', cityId: 'city-nasr');

void main() {
  late _MockReferenceRepo repo;

  setUp(() => repo = _MockReferenceRepo());

  /// The provider is autoDispose, so the container holds a subscription for the
  /// duration of the test — otherwise it is torn down the moment the first read
  /// settles and a pending load can never resolve.
  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [referenceRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(schoolSearchProvider(_filter), (_, _) {});
    return c;
  }

  /// Stubs the first page (no cursor) and, optionally, the second (with cursor).
  void stubPages({
    required CursorPage<NamedRef> first,
    CursorPage<NamedRef>? second,
    Object? secondThrows,
  }) {
    when(
      () => repo.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: null,
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => first);

    // Only stub the second page when the test actually exercises it: an
    // uncompleted `when(...)` leaves mocktail stuck in stubbing mode.
    if (secondThrows == null && second == null) return;

    final secondCall = when(
      () => repo.searchSchools(
        q: any(named: 'q'),
        governorateId: any(named: 'governorateId'),
        cityId: any(named: 'cityId'),
        cursor: 'cursor-page-2',
        limit: any(named: 'limit'),
      ),
    );
    if (secondThrows != null) {
      secondCall.thenThrow(secondThrows);
    } else {
      secondCall.thenAnswer((_) async => second!);
    }
  }

  group('first page', () {
    test('loads items and carries the server hasMore', () async {
      stubPages(
        first: CursorPage(
          items: [_school('a'), _school('b')],
          nextCursor: 'cursor-page-2',
          hasMore: true,
        ),
      );
      final c = container();

      final results = await c.read(schoolSearchProvider(_filter).future);

      expect(results.items.map((s) => s.id), ['a', 'b']);
      expect(results.hasMore, isTrue);
      expect(results.isEmpty, isFalse);
    });

    test('an empty result is Empty, not an error', () async {
      stubPages(first: const CursorPage(items: [], hasMore: false));
      final c = container();

      final results = await c.read(schoolSearchProvider(_filter).future);

      expect(results.isEmpty, isTrue);
      expect(results.hasMore, isFalse);
    });

    test('passes the governorate + city filters through', () async {
      stubPages(first: const CursorPage(items: [], hasMore: false));
      final c = container();
      await c.read(schoolSearchProvider(_filter).future);

      verify(
        () => repo.searchSchools(
          q: null,
          governorateId: 'gov-cairo',
          cityId: 'city-nasr',
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });

    test('a failed first page is an AsyncError (drives the Error/Offline view)',
        () async {
      when(
        () => repo.searchSchools(
          q: any(named: 'q'),
          governorateId: any(named: 'governorateId'),
          cityId: any(named: 'cityId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(const NetworkException(detail: 'timeout'));
      final c = container();

      // Read the STATE rather than `.future`: a rejected `.future` on an
      // autoDispose provider races the teardown.
      await pumpEventQueue();

      final state = c.read(schoolSearchProvider(_filter));
      expect(state.hasError, isTrue);
      expect(state.error, isA<NetworkException>());
    });
  });

  group('loadMore — opaque cursor pagination', () {
    test('appends the next page and follows nextCursor', () async {
      stubPages(
        first: CursorPage(
          items: [_school('a')],
          nextCursor: 'cursor-page-2',
          hasMore: true,
        ),
        second: CursorPage(items: [_school('b')], hasMore: false),
      );
      final c = container();
      await c.read(schoolSearchProvider(_filter).future);

      await c.read(schoolSearchProvider(_filter).notifier).loadMore();

      final results = c.read(schoolSearchProvider(_filter)).value!;
      expect(results.items.map((s) => s.id), ['a', 'b']);
      expect(results.hasMore, isFalse); // exhausted
    });

    test('is a no-op once hasMore is false', () async {
      stubPages(first: CursorPage(items: [_school('a')], hasMore: false));
      final c = container();
      await c.read(schoolSearchProvider(_filter).future);

      await c.read(schoolSearchProvider(_filter).notifier).loadMore();

      verify(
        () => repo.searchSchools(
          q: any(named: 'q'),
          governorateId: any(named: 'governorateId'),
          cityId: any(named: 'cityId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).called(1); // the first page only
    });

    test('a failed append keeps the loaded pages and reports appendError',
        () async {
      stubPages(
        first: CursorPage(
          items: [_school('a')],
          nextCursor: 'cursor-page-2',
          hasMore: true,
        ),
        secondThrows: const NetworkException(detail: 'timeout'),
      );
      final c = container();
      await c.read(schoolSearchProvider(_filter).future);

      await c.read(schoolSearchProvider(_filter).notifier).loadMore();

      final state = c.read(schoolSearchProvider(_filter));
      expect(state.hasError, isFalse); // the list survives
      expect(state.value!.items.map((s) => s.id), ['a']);
      expect(state.value!.appendError, isA<NetworkException>());
      expect(state.value!.isLoadingMore, isFalse);
      expect(state.value!.hasMore, isTrue); // retry is still offered
    });
  });

  group('refresh', () {
    test('re-runs the first page on user tap', () async {
      stubPages(first: CursorPage(items: [_school('a')], hasMore: false));
      final c = container();
      await c.read(schoolSearchProvider(_filter).future);

      await c.read(schoolSearchProvider(_filter).notifier).refresh();

      expect(c.read(schoolSearchProvider(_filter)).value!.items, hasLength(1));
      verify(
        () => repo.searchSchools(
          q: any(named: 'q'),
          governorateId: any(named: 'governorateId'),
          cityId: any(named: 'cityId'),
          cursor: null,
          limit: any(named: 'limit'),
        ),
      ).called(2);
    });
  });
}
