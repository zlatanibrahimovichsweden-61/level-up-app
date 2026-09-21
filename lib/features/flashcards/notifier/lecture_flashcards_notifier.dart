import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/flashcard.dart';
import '../repository/flashcards_repository.dart';

/// One page-accumulated view of `GET /flashcards/lectures/{lectureId}/cards`.
///
/// 🔴 [hasMore] comes from the server's `CursorPage.hasMore` and is NEVER
/// inferred from `items.length`. On this endpoint that is not a style
/// preference: when the weekly allowance cannot pay for a whole page the server
/// deliberately returns a SHORT page with `hasMore: true`, so a client that
/// stopped when `items.length < pageSize` would silently truncate the lecture
/// for exactly the students who are already the most constrained.
///
/// [isLoadingMore] distinguishes "appending the next page" from the initial
/// load, so cards already on screen stay put while more arrive. Shaped after
/// [LeaderboardResults] and `SchoolSearchResults`, which solve the same problem.
@immutable
class LectureFlashcards {
  const LectureFlashcards({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
    this.appendError,
  });

  final List<FlashcardCard> items;
  final bool hasMore;
  final bool isLoadingMore;

  /// A failed "load more". Kept HERE rather than flipping the whole
  /// `AsyncValue` to error, so the pages already delivered survive — which
  /// matters more here than anywhere else in the app, because on this endpoint
  /// those cards have already been CHARGED against the weekly allowance and
  /// throwing them away would make the student pay to see them again.
  final Object? appendError;

  /// Drives the Empty state, which on this endpoint means the lecture genuinely
  /// has no active cards. It never means the allowance ran out: that is
  /// `403 flashcard_subscription_required`, never an empty page.
  bool get isEmpty => items.isEmpty;

  LectureFlashcards copyWith({
    List<FlashcardCard>? items,
    bool? hasMore,
    bool? isLoadingMore,
    Object? appendError,
    bool clearAppendError = false,
  }) {
    return LectureFlashcards(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: clearAppendError ? null : (appendError ?? this.appendError),
    );
  }
}

/// Cursor pagination over one lecture's flashcards.
///
/// `nextCursor` is the contract's OPAQUE keyset token — followed, never parsed
/// or constructed, and `null` means no more pages.
///
/// **This notifier deliberately does NOT decide when to page.** `loadMore` is
/// called by whatever surface consumes it; whether that is an infinite scroll,
/// a "next" control or a prefetch threshold is a UX decision that belongs with
/// the screen, which does not exist yet.
class LectureFlashcardsNotifier extends AsyncNotifier<LectureFlashcards> {
  LectureFlashcardsNotifier(this.lectureId);

  final String lectureId;

  /// The cursor for the NEXT page; null once exhausted.
  String? _nextCursor;

  /// True once this notifier has been disposed — see [loadMore] and [refresh].
  bool _disposed = false;

  @override
  Future<LectureFlashcards> build() async {
    // Registered before the first await so a dispose during the initial page
    // load is still recorded.
    ref.onDispose(() => _disposed = true);
    final page = await ref
        .read(flashcardsRepositoryProvider)
        .getFlashcardsForLecture(
          lectureId,
          pageSize: FlashcardsRepository.defaultPageSize,
        );
    _nextCursor = page.nextCursor;
    return LectureFlashcards(items: page.items, hasMore: page.hasMore);
  }

  /// Appends the next page. No-op when exhausted or already appending — and
  /// never a silent retry: a failure surfaces as [LectureFlashcards.appendError]
  /// for the consumer to re-trigger.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final cursor = _nextCursor;
    if (cursor == null) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearAppendError: true),
    );
    try {
      final page = await ref
          .read(flashcardsRepositoryProvider)
          .getFlashcardsForLecture(
            lectureId,
            cursor: cursor,
            pageSize: FlashcardsRepository.defaultPageSize,
          );
      _nextCursor = page.nextCursor;
      // autoDispose: leaving the surface while a page is in flight disposes
      // this notifier mid-await, and the assignment would throw on a dead one.
      if (_disposed) return;
      // Merge onto the LATEST state, never onto the pre-await snapshot. A
      // `setSelfGrade` that lands while the page is in flight has already
      // patched `items`, and rebuilding from `current` would silently throw
      // that patch away — the same defensive re-read [setSelfGrade] does after
      // its own await. Null means a `refresh` took the state back to
      // `AsyncLoading` and now owns it, so this page is no longer ours to add.
      final latest = state.value;
      if (latest == null) return;
      state = AsyncData(
        LectureFlashcards(
          items: [...latest.items, ...page.items],
          hasMore: page.hasMore,
        ),
      );
    } on Object catch (error) {
      if (_disposed) return;
      final latest = state.value;
      if (latest == null) return;
      state = AsyncData(
        latest.copyWith(isLoadingMore: false, appendError: error),
      );
    }
  }

  /// Re-runs the first page (the user-tapped retry).
  Future<void> refresh() async {
    _nextCursor = null;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(build);
    if (_disposed) return;
    state = result;
  }

  /// Records the student's latest grade for one card and reflects it locally.
  ///
  /// The server answers `204` and echoes the value back on the next page, so
  /// there is nothing to decode; the local patch exists so the surface does not
  /// have to refetch a page it has already been charged for.
  ///
  /// The write is awaited and its failure PROPAGATES rather than being swallowed
  /// into state: the caller is a discrete user action with its own affordance,
  /// unlike [loadMore]. Local state is only patched once the server has
  /// accepted, so a failed grade never leaves the UI showing one the server
  /// does not hold.
  Future<void> setSelfGrade(String cardId, FlashcardSelfGrade grade) async {
    await ref.read(flashcardsRepositoryProvider).setSelfGrade(cardId, grade);
    if (_disposed) return;
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        items: [
          for (final card in current.items)
            if (card.id == cardId) card.copyWith(selfGrade: grade) else card,
        ],
      ),
    );
  }
}

/// One notifier per lecture, so moving between lectures keeps each page warm
/// and a cursor can never cross lectures.
final lectureFlashcardsProvider = AsyncNotifierProvider.autoDispose
    .family<LectureFlashcardsNotifier, LectureFlashcards, String>(
      LectureFlashcardsNotifier.new,
      // Riverpod 3 retries a failed build automatically with backoff, and while
      // it retries the state stays `AsyncLoading` — so a consumer would sit on
      // its skeleton instead of showing the error view. Worse here than
      // elsewhere: every silent retry that SUCCEEDS can spend another slice of
      // a 50/week allowance. Retry is a user-tapped button.
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
