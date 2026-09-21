import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/notifier/reference_providers.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockReferenceRepo extends Mock implements ReferenceRepository {}

/// Every reference picker refuses Riverpod 3's automatic retry.
///
/// **Why this file exists at all.** Riverpod 3 retries a failed provider build
/// on its own — `ProviderContainer.defaultRetry` is ten retries at 200 ms
/// doubling to a 6.4 s ceiling, and it declines only for a Dart `Error`, which
/// an `AppException` is not. The schedule is 200 · 400 · 800 · 1600 · 3200 ·
/// 6400 · 6400 · 6400 · 6400 · 6400 ms, so a single failing picker is ELEVEN
/// requests — one initial plus ten retries — over roughly thirty-eight seconds,
/// and the registration screens mount four of these at once.
///
/// **What each test actually discriminates.** While a retry is pending Riverpod
/// keeps the state `AsyncLoading` *carrying* the error instead of moving it to
/// `AsyncError` (`element.dart`'s `triggerRetry`). That is the observable
/// difference, and it is why `isLoading` is asserted alongside the type: drop
/// `retry: _noRetry` from any of these providers and the state under assertion
/// becomes `AsyncLoading`, failing both. The `called(1)` is the third
/// discriminator — it catches a retry that has actually fired.
///
/// A listener is held for the duration of each test. Without one these builds
/// can settle and tear down before a retry could ever be scheduled, and the
/// test would pass whether or not the flag was set — the exact false green that
/// `lecture_flashcards_notifier_test.dart` was corrected for.
void main() {
  late _MockReferenceRepo repo;

  setUp(() => repo = _MockReferenceRepo());

  ProviderContainer containerWith() {
    final c = ProviderContainer(
      overrides: [referenceRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    return c;
  }

  /// Drives one provider to a failed build and proves the failure is TERMINAL:
  /// surfaced as `AsyncError`, not parked on a retrying `AsyncLoading`, and the
  /// repository called exactly once.
  Future<void> settlesOnError<T>(
    FutureProvider<T> provider,
    ProviderContainer c,
  ) async {
    c.listen(provider, (_, _) {});

    await pumpEventQueue();

    final state = c.read(provider);
    expect(
      state,
      isA<AsyncError<T>>(),
      reason: 'a retry would keep it loading',
    );
    expect(state.isLoading, isFalse, reason: 'no retry may be pending');
    expect(state.error, isA<OfflineException>());
  }

  group('no picker retries its own build', () {
    test('countriesProvider', () async {
      when(repo.getCountries).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(countriesProvider, c);

      verify(repo.getCountries).called(1);
    });

    test('governoratesProvider', () async {
      when(
        () => repo.getGovernorates(any()),
      ).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(governoratesProvider('EG'), c);

      verify(() => repo.getGovernorates('EG')).called(1);
    });

    test('citiesProvider', () async {
      when(
        () => repo.getCities(
          countryCode: any(named: 'countryCode'),
          governorateId: any(named: 'governorateId'),
        ),
      ).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(
        citiesProvider((countryCode: 'EG', governorateId: 'gov-cairo')),
        c,
      );

      verify(
        () => repo.getCities(countryCode: 'EG', governorateId: 'gov-cairo'),
      ).called(1);
    });

    test('schoolsProvider', () async {
      // No screen reads this one today — the school picker uses
      // `schoolSearchProvider`. It is held to the same rule anyway, so the
      // first surface to adopt it cannot inherit the defect.
      when(
        () => repo.searchSchools(
          q: any(named: 'q'),
          governorateId: any(named: 'governorateId'),
          cityId: any(named: 'cityId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(
        schoolsProvider((
          q: 'nasr',
          governorateId: null,
          cityId: null,
          cursor: null,
          limit: null,
        )),
        c,
      );

      verify(
        () => repo.searchSchools(
          q: 'nasr',
          governorateId: null,
          cityId: null,
          cursor: null,
          limit: null,
        ),
      ).called(1);
    });

    test('educationSystemsProvider', () async {
      when(repo.getEducationSystems).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(educationSystemsProvider, c);

      verify(repo.getEducationSystems).called(1);
    });

    test('universitiesProvider', () async {
      when(repo.getUniversities).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(universitiesProvider, c);

      verify(repo.getUniversities).called(1);
    });

    test('avatarsProvider — the one measured at seven calls in ~15s', () async {
      when(repo.getAvatars).thenThrow(const OfflineException());
      final c = containerWith();

      await settlesOnError(avatarsProvider, c);

      verify(repo.getAvatars).called(1);
    });
  });

  group('the terminal error is the one the screen renders', () {
    test('an offline build surfaces OfflineException, not a wrapper', () async {
      // `ReferenceDropdown` picks its copy by `isOffline(error)`, so the
      // exception type has to survive the provider boundary intact.
      when(repo.getCountries).thenThrow(const OfflineException());
      final c = containerWith();
      c.listen(countriesProvider, (_, _) {});

      await pumpEventQueue();

      expect(c.read(countriesProvider).error, isA<OfflineException>());
    });

    test('a 403 survives with its code, so copy can branch on it', () async {
      when(
        repo.getUniversities,
      ).thenThrow(const ApiException(status: 403, code: 'insufficient_scope'));
      final c = containerWith();
      c.listen(universitiesProvider, (_, _) {});

      await pumpEventQueue();

      expect(
        c.read(universitiesProvider).error,
        isA<ApiException>().having((e) => e.code, 'code', 'insufficient_scope'),
      );
    });
  });

  group('success still caches for the session', () {
    test(
      'a second read does NOT re-request — these are not autoDispose',
      () async {
        when(repo.getCountries).thenAnswer(
          (_) async => const [
            Country(
              code: 'EG',
              nameAr: 'مصر',
              nameEn: 'Egypt',
              requiresGovernorate: true,
            ),
          ],
        );
        final c = containerWith();

        await c.read(countriesProvider.future);
        await c.read(countriesProvider.future);

        // `_noRetry` must not have turned caching off: the reference sets are
        // closed and are deliberately fetched once per session.
        verify(repo.getCountries).called(1);
      },
    );
  });
}
