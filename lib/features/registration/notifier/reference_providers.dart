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
);

/// `GET /reference/countries/{code}/governorates` — keyed by country code.
final governoratesProvider = FutureProvider.family<List<NamedRef>, String>(
  (ref, countryCode) =>
      ref.watch(referenceRepositoryProvider).getGovernorates(countryCode),
);

/// `GET /reference/cities` — keyed by [CitiesQuery].
final citiesProvider = FutureProvider.family<List<NamedRef>, CitiesQuery>(
  (ref, query) => ref
      .watch(referenceRepositoryProvider)
      .getCities(
        countryCode: query.countryCode,
        governorateId: query.governorateId,
      ),
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
    );

/// `GET /reference/education-systems`.
final educationSystemsProvider = FutureProvider<List<EducationSystemRef>>(
  (ref) => ref.watch(referenceRepositoryProvider).getEducationSystems(),
);

/// `GET /reference/universities` — nested university → faculty → year tree.
final universitiesProvider = FutureProvider<List<UniversityRef>>(
  (ref) => ref.watch(referenceRepositoryProvider).getUniversities(),
);

/// `GET /reference/avatars`.
final avatarsProvider = FutureProvider<List<Avatar>>(
  (ref) => ref.watch(referenceRepositoryProvider).getAvatars(),
);
