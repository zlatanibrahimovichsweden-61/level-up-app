import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reference_models.dart';
import '../repository/reference_repository.dart';

/// Filter for the Egyptian coded-school search. A record → structural equality,
/// so the family caches one entry per distinct filter.
///
/// Egypt only: non-Egypt students type a free-text school name instead
/// (adr-010 — "never blocked"), so this notifier is never built for them.
typedef SchoolFilter = ({String? q, String? governorateId, String? cityId});

/// One page-accumulated view of `GET /reference/schools`.
///
/// [hasMore] comes from the server's `CursorPage.hasMore` — never inferred from
/// the page size — and [isLoadingMore] distinguishes "appending page 2" from
/// the initial load, so the list stays on screen while more arrives.
@immutable
class SchoolSearchResults {
  const SchoolSearchResults({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
    this.appendError,
  });

  final List<NamedRef> items;
  final bool hasMore;
  final bool isLoadingMore;

  /// A failed "load more". Kept HERE rather than flipping the whole
  /// `AsyncValue` to error, so the pages already on screen survive and the
  /// sheet can offer a retry for just the append.
  final Object? appendError;

  /// Drives the Empty state (distinct from a failed load).
  bool get isEmpty => items.isEmpty;

  SchoolSearchResults copyWith({
    List<NamedRef>? items,
    bool? hasMore,
    bool? isLoadingMore,
    Object? appendError,
    bool clearAppendError = false,
  }) {
    return SchoolSearchResults(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: clearAppendError ? null : (appendError ?? this.appendError),
    );
  }
}

/// Cursor pagination over the school search.
///
/// The contract's `CursorPage.nextCursor` is an OPAQUE keyset token — it is
/// followed, never parsed or constructed, and `null` means "no more pages".
/// Pages accumulate into one list because the picker is an infinite-scrolling
/// sheet, not a page-at-a-time list.
class SchoolSearchNotifier extends AsyncNotifier<SchoolSearchResults> {
  SchoolSearchNotifier(this.filter);

  final SchoolFilter filter;

  /// The cursor for the NEXT page; null once exhausted.
  String? _nextCursor;

  static const _pageSize = 20;

  @override
  Future<SchoolSearchResults> build() async {
    final page = await ref.read(referenceRepositoryProvider).searchSchools(
          q: filter.q,
          governorateId: filter.governorateId,
          cityId: filter.cityId,
          limit: _pageSize,
        );
    _nextCursor = page.nextCursor;
    return SchoolSearchResults(items: page.items, hasMore: page.hasMore);
  }

  /// Appends the next page. No-op when exhausted or already appending — and
  /// never a silent retry: a failure surfaces as an error the user re-triggers.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final cursor = _nextCursor;
    if (cursor == null) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearAppendError: true),
    );
    try {
      final page = await ref.read(referenceRepositoryProvider).searchSchools(
            q: filter.q,
            governorateId: filter.governorateId,
            cityId: filter.cityId,
            cursor: cursor,
            limit: _pageSize,
          );
      _nextCursor = page.nextCursor;
      state = AsyncData(
        SchoolSearchResults(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
        ),
      );
    } on Object catch (error) {
      // Keep the already-loaded pages visible; the sheet shows a retry for the
      // failed append rather than throwing the whole list away.
      state = AsyncData(
        current.copyWith(isLoadingMore: false, appendError: error),
      );
    }
  }

  /// Re-runs the first page (the user-tapped retry).
  Future<void> refresh() async {
    _nextCursor = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final schoolSearchProvider = AsyncNotifierProvider.autoDispose
    .family<SchoolSearchNotifier, SchoolSearchResults, SchoolFilter>(
  SchoolSearchNotifier.new,
);
