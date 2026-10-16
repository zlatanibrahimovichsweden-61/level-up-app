import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/catalog_module.dart';
import '../models/subject.dart';
import '../repository/catalog_repository.dart';
import 'subjects_notifier.dart';

/// `GET /catalog/modules` - the University module picker's grouping.
///
/// 🔴 **A module is navigation and nothing else** (adr-036 §3): it never scopes
/// content, gates an entitlement, enters a leaderboard key or a progress
/// counter. This provider therefore feeds ONE thing, the pill row on the
/// Subjects screen.
///
/// **It is separate from [subjectsProvider] on purpose, and the screen never
/// waits for it.** Its failure, its latency and its `[]` (every school student,
/// and a University student with no modules) must leave the subjects list
/// exactly as it was, so the two are independent providers and the Subjects
/// screen only draws the row from settled, non-empty data
/// ([pickableModules]).
///
/// Non-`autoDispose`, like [subjectsProvider], so the grouping survives a tab
/// switch and the Units -> Lectures drill-down without a re-fetch. It is
/// per-student, so `invalidateSessionScope` drops it.
///
/// `retry: noCatalogRetry` is NOT optional: Riverpod 3 would otherwise retry a
/// failed build with backoff and leave the state `AsyncLoading`, never settling
/// on `AsyncError`. It is never retried silently by Riverpod. A FAILED read is
/// fetched again only when the student taps the Subjects screen's Retry, or
/// when the connection comes back while that screen is mounted (owner decision
/// 2026-10-15, SEIF1014 follow-up); until then a failure simply means no row
/// (the screen is as it is for a school student).
final modulesProvider = FutureProvider<List<CatalogModule>>(
  (ref) => ref.watch(catalogRepositoryProvider).getModules(),
  retry: noCatalogRetry,
);

/// The chosen module's id; `null` is **All subjects**.
///
/// Lives in a provider rather than in the screen's `State` so the choice
/// survives `context.go` into a subject and back (the screen is rebuilt on
/// return). It holds an ID, never a [CatalogModule]: whether that module is
/// still served is decided at read time by [resolveSelectedModule].
///
/// Per-student, so `invalidateSessionScope` resets it - a fresh session shows
/// All subjects.
class SelectedModuleNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  /// `null` selects All subjects.
  void select(String? moduleId) => state = moduleId;
}

final selectedModuleProvider =
    NotifierProvider<SelectedModuleNotifier, String?>(
      SelectedModuleNotifier.new,
    );

/// The modules the picker may draw, or `null` when it must not draw at all.
///
/// The row appears ONLY for settled, non-empty data. That is stricter than
/// `value != null`: in Riverpod 3 a provider that is reloading (a new session
/// after an invalidation) still carries the OLD `value` with `isLoading` true,
/// and a failed one can keep its last value too, so reading `value` alone could
/// show the previous student's grouping. Loading, reloading, error, offline and
/// `[]` all return `null` - which is "the screen exactly as it is for a school
/// student".
List<CatalogModule>? pickableModules(AsyncValue<List<CatalogModule>> modules) {
  if (modules.isLoading || modules.hasError || !modules.hasValue) return null;
  final data = modules.requireValue;
  return data.isEmpty ? null : data;
}

/// The module with [selectedId], or `null` (= All subjects).
///
/// A selection that is no longer served - the id left the response, or the
/// list was replaced by another student's - falls back to All subjects rather
/// than to an empty screen.
CatalogModule? resolveSelectedModule(
  String? selectedId,
  List<CatalogModule> modules,
) {
  if (selectedId == null) return null;
  for (final module in modules) {
    if (module.id == selectedId) return module;
  }
  return null;
}

/// The subjects a module shows, from the ALREADY-LOADED [subjects].
///
/// `null` is All subjects: the list unchanged. Otherwise the module's
/// `subjectIds` are walked IN THE ORDER SERVED and each id is replaced by the
/// loaded subject carrying it. The contract promises no order for `subjectIds`,
/// so this never re-sorts. An id with no loaded subject (the subject did not
/// load, or is not in the list) is skipped, and an id repeated in `subjectIds`
/// yields its subject once.
///
/// Pure and total. It only chooses which loaded subjects to list: the module
/// never changes a subject, its counter, or whether it can be opened.
List<Subject> subjectsForModule(CatalogModule? module, List<Subject> subjects) {
  if (module == null) return subjects;

  final byId = <String, Subject>{};
  for (final subject in subjects) {
    byId.putIfAbsent(subject.id, () => subject);
  }
  final emitted = <String>{};
  return [
    for (final id in module.subjectIds)
      if (emitted.add(id)) ?byId[id],
  ];
}
