import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/flashcard.dart';
import '../repository/flashcards_repository.dart';

/// How many cards one study round holds — the frame's "1/10" (owner ruling
/// 2026-09-29).
///
/// Matches `contract/contract-changelog.md`, 2026-09-25 (`3.27.0-m1`,
/// `flashcardCount`): the round follows `getFlashcardsForLecture`'s `hasMore`,
/// "one `pageSize=10` page per round, a short round when the lecture has fewer
/// cards". Deliberately NOT [FlashcardsRepository.defaultPageSize], which stays
/// 20 because it mirrors the contract's own default for the parameter.
///
/// It is also a REQUEST, not a promise: the server may return fewer cards (a
/// lecture with fewer than ten, or a weekly-preview truncation), so a screen
/// sizes its progress from `items.length`, never from this constant.
const flashcardRoundSize = 10;

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
  /// `AsyncValue` to error, so the pages already delivered survive on screen.
  /// (Refetching them would not cost the student anything — a card already
  /// charged this week re-delivers free — but a failed append must not blank
  /// cards the student is already looking at.)
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
/// **The study ROUND.** The study screen (`FlashcardStudyScreen`) pages by
/// ROUND, not by scrolling: a round is one page of [flashcardRoundSize] cards
/// starting at the lecture's [flashcardRoundPositionProvider] cursor (`null` =
/// the start of the deck). [build] fetches exactly that page; once the student
/// has graded the last card the study screen calls [finishRound], which moves
/// the position on so the NEXT round — a fresh build — continues where this one
/// stopped, and wraps to the start after the last page.
///
/// **[loadMore] has no production caller today.** Only tests call it, and the
/// study screen must not: it still asks for
/// [FlashcardsRepository.defaultPageSize] (20), not [flashcardRoundSize], and it
/// moves the cursor [finishRound] reads. Calling it during a round would grow
/// the round past its ten cards and shift the next round's start to the end of
/// the appended page. (The same goes for [LectureFlashcards.isLoadingMore] and
/// [LectureFlashcards.appendError], which only [loadMore] sets.) Whoever wires a
/// consumer to it decides when to page — infinite scroll, a "next" control or a
/// prefetch threshold — and should first reconcile that page size with the
/// round's.
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
    // `read`, not `watch`: the position moves when a round FINISHES, and a
    // watch would rebuild this notifier — refetching a round the student has
    // just completed — the instant [finishRound] wrote it.
    final start = ref.read(flashcardRoundPositionProvider(lectureId));
    final page = await ref
        .read(flashcardsRepositoryProvider)
        .getFlashcardsForLecture(
          lectureId,
          cursor: start,
          pageSize: flashcardRoundSize,
        );
    _nextCursor = page.nextCursor;
    return LectureFlashcards(items: page.items, hasMore: page.hasMore);
  }

  /// Marks the current round complete: call it once, after the LAST card has
  /// been graded and before the study screen returns to the screen it came
  /// from.
  ///
  /// Records where the NEXT round starts in [flashcardRoundPositionProvider]:
  /// the page's `nextCursor` when the server said `hasMore`, and `null` (wrap to
  /// the start of the deck) when it did not. It branches on
  /// [LectureFlashcards.hasMore] and never on `items.length`.
  ///
  /// A weekly-preview-truncated round is `hasMore: true` with a `nextCursor` at
  /// the first card that was NOT delivered. Storing that cursor is correct: the
  /// next round starts exactly there and meets
  /// `403 flashcard_subscription_required` from the server, which is the true
  /// state of the student's allowance. Wrapping to the start instead would hide
  /// that and re-serve cards the student has just seen.
  ///
  /// A no-op when there is no delivered round (still loading, errored, or
  /// disposed) — there is nothing to advance past.
  void finishRound() {
    if (_disposed) return;
    final current = state.value;
    if (current == null) return;
    ref
        .read(flashcardRoundPositionProvider(lectureId).notifier)
        .moveTo(current.hasMore ? _nextCursor : null);
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

/// Where the NEXT study round of one lecture starts: the opaque `nextCursor`
/// the last finished round ended on, or `null` for the start of the deck.
///
/// Written only by [LectureFlashcardsNotifier.finishRound]; read (never
/// watched) by [LectureFlashcardsNotifier.build]. The cursor is the contract's
/// keyset token — stored and replayed, never parsed or constructed.
///
/// **Its lifetime is the whole point.** It is autoDispose, so it lives exactly
/// as long as something listens: the Setup screen watches it, which keeps the
/// position alive while Setup is on the stack (across every round the student
/// studies from it), and leaving Setup drops the position — the next visit
/// starts at the beginning of the deck again. The study screen must NOT be the
/// only listener, or the position would die with it before Setup ever saw it.
class FlashcardRoundPositionNotifier extends Notifier<String?> {
  FlashcardRoundPositionNotifier(this.lectureId);

  final String lectureId;

  @override
  String? build() => null;

  /// Sets where the next round starts (`null` = the start of the deck). The
  /// only production caller is [LectureFlashcardsNotifier.finishRound];
  /// screens do not move the position themselves.
  @visibleForTesting
  void moveTo(String? cursor) => state = cursor;
}

/// One position per lecture, so a cursor can never cross lectures.
final flashcardRoundPositionProvider = NotifierProvider.autoDispose
    .family<FlashcardRoundPositionNotifier, String?, String>(
      FlashcardRoundPositionNotifier.new,
      // `build` cannot fail; stated anyway so no provider in this feature
      // carries Riverpod 3's default automatic retry.
      retry: _noRetry,
    );

/// One notifier per lecture, so a cursor can never cross lectures.
///
/// autoDispose: the notifier and the round it holds are dropped as soon as
/// nothing listens, so leaving the study surface discards the cards and a
/// re-entry fetches the round again. That refetch is not a second charge — a
/// card already delivered this week re-delivers free — and the round it fetches
/// is the one at [flashcardRoundPositionProvider], which is why the position
/// lives in its own provider rather than here.
final lectureFlashcardsProvider = AsyncNotifierProvider.autoDispose
    .family<LectureFlashcardsNotifier, LectureFlashcards, String>(
      LectureFlashcardsNotifier.new,
      // Riverpod 3 retries a failed build automatically with backoff, and while
      // it retries the state stays `AsyncLoading` — so a consumer would sit on
      // its skeleton instead of showing the error view. Worse here than
      // elsewhere: two of this endpoint's refusals
      // (`403 flashcard_subscription_required`, `403 insufficient_scope`) are
      // ones no retry can cure, so the student would wait on a skeleton for an
      // answer that never changes. Retry is a user-tapped button.
      retry: _noRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? _noRetry(int retryCount, Object error) => null;
