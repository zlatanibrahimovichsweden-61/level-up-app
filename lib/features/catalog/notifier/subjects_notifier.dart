import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subject.dart';
import '../repository/catalog_repository.dart';

/// `GET /catalog/subjects` — the Learn tab's landing list.
///
/// **autoDispose, and that is the session boundary** (E4-04/05, the same
/// remedy as `meProvider`, KNOWN_BUGS BUG-015). The list still survives tab
/// switches and the whole Units → Chapters → Lessons drill-down, because the
/// Learn branch and its Subjects screen stay mounted (a hidden tab's listener is
/// paused, not removed), so coming back up does not re-fetch or re-flash a
/// skeleton. What it no longer does is outlive the student: a sign-out unmounts
/// the shell and the last listener leaving drops the element, so the NEXT
/// student's first read builds from nothing. As a plain provider it was only
/// ever invalidated by `invalidateSessionScope`, which keeps the previous value
/// through the rebuild — the previous student's subjects and PROGRESS rendered
/// under the next one while their own request was in flight, and a rebuild made
/// with no token at the sign-out cached its 401 into the next session.
class SubjectsNotifier extends AsyncNotifier<List<Subject>> {
  /// Set when the provider is torn down, so a Retry still in flight does not
  /// write to a dead notifier. Re-armed on EVERY build: Riverpod 3 keeps this
  /// instance across rebuilds and runs the dispose callbacks on each one.
  bool _disposed = false;

  @override
  Future<List<Subject>> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return ref.watch(catalogRepositoryProvider).getSubjects();
  }

  /// User-tapped retry. Never auto-retried on failure — see [subjectsProvider].
  Future<void> refresh() async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(
      () => ref.read(catalogRepositoryProvider).getSubjects(),
    );
    if (_disposed) return;
    state = next;
  }
}

/// `retry: _noRetry` is NOT optional. Riverpod 3 retries a failed provider build
/// automatically with exponential backoff, and while it retries the state stays
/// `AsyncLoading` (carrying the error) instead of becoming `AsyncError` — the
/// screen would sit on its skeleton forever rather than showing error/offline,
/// and would keep hammering the endpoint on a dead network. Retry here is a
/// user-tapped button, never silent.
final subjectsProvider =
    AsyncNotifierProvider.autoDispose<SubjectsNotifier, List<Subject>>(
      SubjectsNotifier.new,
      retry: noCatalogRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? noCatalogRetry(int retryCount, Object error) => null;

/// The subject's display name, read from the ALREADY-LOADED subjects list.
///
/// Every drill-down header is titled after its subject ("Biology Units",
/// "Biology Lectures"), but the tree payload contains no subject name — only the
/// track and its children. Rather than add a second request for one string, the
/// name comes from the list the student just tapped through.
///
/// Returns null on a cold deep link, where that list was never fetched (or does
/// not contain this id). Callers fall back to a bare title; inventing a name
/// would be worse than showing none. Server copy, already in the content
/// language (adr-018) — never translated client-side.
String? cachedSubjectName(WidgetRef ref, String subjectId) {
  for (final subject
      in ref.watch(subjectsProvider).value ?? const <Subject>[]) {
    if (subject.id == subjectId) return subject.name;
  }
  return null;
}

// ---------------------------------------------------------------------------
// Client-side search
// ---------------------------------------------------------------------------

/// Filters an ALREADY-LOADED list. There is no search endpoint and none is
/// wanted: the per-student subject set is closed and small, so typing must not
/// cost a round trip on an Egyptian mobile connection.
///
/// Pure and total — no notifier, no state. An empty/blank query returns the
/// list unchanged (not an empty result).
List<Subject> filterSubjects(List<Subject> subjects, String query) {
  final needle = normalizeForSearch(query);
  if (needle.isEmpty) return subjects;
  return subjects
      .where((s) => normalizeForSearch(s.name).contains(needle))
      .toList(growable: false);
}

/// Case- and diacritic-insensitive normalisation, for matching only — never for
/// display.
///
/// Arabic is the primary audience, so the Arabic rules are the point, not an
/// afterthought: a student typing `مراجعه` must find `مُراجعة`. We strip the
/// harakat and tatweel, then fold the letter forms that students type
/// interchangeably (أ/إ/آ→ا, ى→ي, ة→ه). Latin folding covers the accents that
/// occur in transliterated subject names.
String normalizeForSearch(String input) {
  final buffer = StringBuffer();
  for (final rune in input.trim().toLowerCase().runes) {
    // Harakat (U+064B–U+065F), superscript alef (U+0670) and tatweel (U+0640)
    // carry no meaning for matching.
    if ((rune >= 0x064B && rune <= 0x065F) ||
        rune == 0x0670 ||
        rune == 0x0640) {
      continue;
    }
    final char = String.fromCharCode(rune);
    buffer.write(_fold[char] ?? char);
  }
  return buffer.toString();
}

const _fold = <String, String>{
  // Arabic letter forms students type interchangeably.
  'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ٱ': 'ا',
  'ى': 'ي', 'ئ': 'ي',
  'ؤ': 'و',
  'ة': 'ه',
  // Latin accents (already lower-cased above).
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'ñ': 'n',
};
