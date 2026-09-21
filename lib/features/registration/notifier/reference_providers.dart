import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reference_models.dart';
import '../repository/reference_repository.dart';

/// The reusable reference pickers — one provider per `/reference/*` endpoint.
/// Day 3's geography/academic screens consume these; Day 2 ships them so those
/// screens can drop straight in.
///
/// These are plain (non-autoDispose) [FutureProvider]s so their results CACHE
/// for the session: the reference sets are closed and rarely change, and each
/// family key caches independently. `AsyncValue` maps directly onto the
/// loading / data(empty) / error(→ offline) states the consuming screens render
/// through the shared `StateWidget`.
///
/// 🔴 **Every provider here sets `retry: _noRetry`, and none may be added
/// without it.** Riverpod 3 retries a failed provider build automatically —
/// `ProviderContainer.defaultRetry` is ten retries at 200 ms doubling to a
/// 6.4 s ceiling, and it gives up only on a Dart `Error`, which an
/// `AppException` is not. The schedule is 200 · 400 · 800 · 1600 · 3200 ·
/// 6400 · 6400 · 6400 · 6400 · 6400 ms, so one failed picker is **eleven
/// requests — one initial plus ten retries — over about thirty-eight
/// seconds**, and the registration screens mount four of these at once.
///
/// The user-visible half is worse than the traffic. While a retry is pending
/// `triggerRetry` returns `AsyncLoading(error: …, retrying: true)` rather than
/// `AsyncError` — so `ReferenceDropdown`'s `AsyncError` arm never matches and
/// the field shows its SPINNER instead of the offline message and its Retry
/// button. Every one of these pickers already has a working
/// `onRetry: () => ref.invalidate(…)` wired at the call site; auto-retry was
/// the only thing keeping it out of reach.

/// Filter tuple for the cities picker. A record → structural equality, so the
/// family caches one entry per (country, governorate) pair.
typedef CitiesQuery = ({String countryCode, String? governorateId});

/// Filter + cursor tuple for the schools search. `cursor == null` is the first
/// page; follow [CursorPage.nextCursor] for subsequent pages (Day 3 wires the
/// infinite-scroll on top of this).
typedef SchoolsQuery = ({
  String? q,
  String? governorateId,
  String? cityId,
  String? cursor,
  int? limit,
});

/// `GET /reference/countries`.
final countriesProvider = FutureProvider<List<Country>>(
  (ref) => ref.watch(referenceRepositoryProvider).getCountries(),
  retry: _noRetry,
);

/// `GET /reference/countries/{code}/governorates` — keyed by country code.
final governoratesProvider = FutureProvider.family<List<NamedRef>, String>(
  (ref, countryCode) =>
      ref.watch(referenceRepositoryProvider).getGovernorates(countryCode),
  retry: _noRetry,
);

/// `GET /reference/cities` — keyed by [CitiesQuery].
final citiesProvider = FutureProvider.family<List<NamedRef>, CitiesQuery>(
  (ref, query) => ref
      .watch(referenceRepositoryProvider)
      .getCities(
        countryCode: query.countryCode,
        governorateId: query.governorateId,
      ),
  retry: _noRetry,
);

/// `GET /reference/schools` — cursor-paginated, keyed by [SchoolsQuery].
final schoolsProvider =
    FutureProvider.family<CursorPage<NamedRef>, SchoolsQuery>(
      (ref, query) => ref
          .watch(referenceRepositoryProvider)
          .searchSchools(
            q: query.q,
            governorateId: query.governorateId,
            cityId: query.cityId,
            cursor: query.cursor,
            limit: query.limit,
          ),
      retry: _noRetry,
    );

/// `GET /reference/education-systems`.
final educationSystemsProvider = FutureProvider<List<EducationSystemRef>>(
  (ref) => ref.watch(referenceRepositoryProvider).getEducationSystems(),
  retry: _noRetry,
);

/// `GET /reference/universities` — nested university → faculty → year tree.
final universitiesProvider = FutureProvider<List<UniversityRef>>(
  (ref) => ref.watch(referenceRepositoryProvider).getUniversities(),
  retry: _noRetry,
);

/// `GET /reference/avatars`.
///
/// `retry: _noRetry` for the same reason `meProvider`, `subjectsProvider`,
/// `subjectTreeProvider`, the two mistakes notifiers and `leaderboardProvider`
/// all set it: **Riverpod 3 retries a failed provider build automatically,
/// with exponential backoff**, and the project rule is that retry is a
/// user-tapped button, never silent.
///
/// Measured before this line existed — a failing `getAvatars` was called **7
/// times in ~15 seconds** off a single sheet open, backing off 200 ms → 6.4 s
/// and continuing. Behind a modal the student may have already walked away
/// from, that is a background network loop nobody asked for, and it is why the
/// error view was so hard to see: while Riverpod is retrying, the state stays
/// `AsyncLoading` carrying the error rather than becoming `AsyncError`.
///
/// The other six providers in this file carried the same defect and were left
/// alone by that pass because they belong to the registration wizard. They all
/// set `retry: _noRetry` now — see the file-level note above for the count that
/// applies to each of them.
final avatarsProvider = FutureProvider<List<Avatar>>(
  (ref) => ref.watch(referenceRepositoryProvider).getAvatars(),
  retry: _noRetry,
);

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
