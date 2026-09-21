import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/flashcards/models/flashcard.dart';
import 'package:level_up_app/features/flashcards/notifier/lecture_flashcards_notifier.dart';
import 'package:level_up_app/features/flashcards/repository/flashcards_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements FlashcardsRepository {}

/// Cursor pagination over one lecture's cards.
///
/// The behaviour that matters here is the one the contract warns about twice: a
/// SHORT page is not the end of the list, so paging is driven by `hasMore` and
/// never by `items.length`.
void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  FlashcardCard card(String id, {FlashcardSelfGrade? grade}) => FlashcardCard(
    id: id,
    front: 'front $id',
    back: 'back $id',
    imageUrl: null,
    selfGrade: grade,
  );

  CursorPage<FlashcardCard> page(
    List<FlashcardCard> items, {
    String? nextCursor,
    required bool hasMore,
  }) => CursorPage(items: items, nextCursor: nextCursor, hasMore: hasMore);

  ProviderContainer containerWith() {
    final c = ProviderContainer(
      overrides: [flashcardsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    return c;
  }

  void stubFirst(CursorPage<FlashcardCard> result) {
    when(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: null,
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => result);
  }

  test('the first page lands as AsyncData', () async {
    stubFirst(page([card('a'), card('b')], hasMore: false));
    final c = containerWith();

    final state = await c.read(lectureFlashcardsProvider('lec-1').future);

    expect(state.items.map((i) => i.id), ['a', 'b']);
    expect(state.hasMore, isFalse);
    expect(state.isEmpty, isFalse);
  });

  test('the first page asks for 20 cards — the contract default', () async {
    // Asserted as the literal that reaches the repository, not as the constant
    // compared to itself. 20 is the contract's default and well inside its
    // 1..50 bound; the narrower cap matters because a page is charged per
    // distinct card against a 50/week allowance.
    stubFirst(page([card('a')], hasMore: false));
    final c = containerWith();

    await c.read(lectureFlashcardsProvider('lec-1').future);

    verify(
      () => repo.getFlashcardsForLecture('lec-1', cursor: null, pageSize: 20),
    ).called(1);
  });

  test('an empty lecture is empty, not an error', () async {
    stubFirst(page([], hasMore: false));
    final c = containerWith();

    final state = await c.read(lectureFlashcardsProvider('lec-1').future);

    expect(state.isEmpty, isTrue);
    expect(c.read(lectureFlashcardsProvider('lec-1')).hasError, isFalse);
  });

  test('a SHORT first page still reports more, and loadMore appends', () async {
    // 🔴 The allowance-truncation case. Two cards came back for a 20-card
    // request, and the list is NOT finished: hasMore says so, items.length
    // would lie. A consumer that stopped here would silently hide the rest of
    // the lecture from the student whose allowance is short.
    stubFirst(page([card('a'), card('b')], nextCursor: 'tok-1', hasMore: true));
    when(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: 'tok-1',
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => page([card('c')], hasMore: false));

    final c = containerWith();
    final first = await c.read(lectureFlashcardsProvider('lec-1').future);
    expect(first.items, hasLength(2));
    expect(first.hasMore, isTrue, reason: 'short page, but not the end');

    await c.read(lectureFlashcardsProvider('lec-1').notifier).loadMore();

    final after = c.read(lectureFlashcardsProvider('lec-1')).value!;
    expect(after.items.map((i) => i.id), ['a', 'b', 'c']);
    expect(after.hasMore, isFalse);
  });

  test('loadMore is a no-op once the server says there is no more', () async {
    stubFirst(page([card('a')], hasMore: false));
    final c = containerWith();
    await c.read(lectureFlashcardsProvider('lec-1').future);

    await c.read(lectureFlashcardsProvider('lec-1').notifier).loadMore();

    // Exactly one call: the initial build. No cursor request was made, so no
    // slice of the weekly allowance was spent on a page that does not exist.
    verify(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: null,
        pageSize: any(named: 'pageSize'),
      ),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('a failed append KEEPS the cards already paid for', () async {
    stubFirst(page([card('a')], nextCursor: 'tok-1', hasMore: true));
    when(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: 'tok-1',
        pageSize: any(named: 'pageSize'),
      ),
    ).thenThrow(const OfflineException());

    final c = containerWith();
    await c.read(lectureFlashcardsProvider('lec-1').future);
    await c.read(lectureFlashcardsProvider('lec-1').notifier).loadMore();

    final state = c.read(lectureFlashcardsProvider('lec-1')).value!;
    // These cards were already CHARGED against the weekly allowance. Throwing
    // them away on a failed append would make the student pay to see them
    // again, so the failure is carried beside them instead.
    expect(state.items.map((i) => i.id), ['a']);
    expect(state.appendError, isA<OfflineException>());
    expect(state.isLoadingMore, isFalse);
  });

  test('a grade landing MID-APPEND is not overwritten by the page', () async {
    // The append must merge onto the latest state, not onto the snapshot it
    // took before its await. A `setSelfGrade` that completes while page 2 is
    // in flight has already patched `items`; rebuilding from the stale
    // snapshot would silently discard the grade the server has accepted, and
    // the UI would show `null` for a card the student just graded.
    final gate = Completer<CursorPage<FlashcardCard>>();
    stubFirst(page([card('a')], nextCursor: 'tok-1', hasMore: true));
    when(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: 'tok-1',
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) => gate.future);
    when(
      () => repo.setSelfGrade('a', FlashcardSelfGrade.again),
    ).thenAnswer((_) async {});

    final c = containerWith();
    await c.read(lectureFlashcardsProvider('lec-1').future);
    final notifier = c.read(lectureFlashcardsProvider('lec-1').notifier);

    // Page 2 starts and parks on the gate.
    final appending = notifier.loadMore();
    // The student grades card 'a' while it is still in flight.
    await notifier.setSelfGrade('a', FlashcardSelfGrade.again);
    // Now let page 2 land on top.
    gate.complete(page([card('b')], hasMore: false));
    await appending;

    final state = c.read(lectureFlashcardsProvider('lec-1')).value!;
    expect(state.items.map((i) => i.id), ['a', 'b']);
    expect(
      state.items[0].selfGrade,
      FlashcardSelfGrade.again,
      reason: 'the mid-flight grade must survive the append',
    );
  });

  test('setSelfGrade patches the card only after the server accepts', () async {
    stubFirst(page([card('a'), card('b')], hasMore: false));
    when(
      () => repo.setSelfGrade('a', FlashcardSelfGrade.again),
    ).thenAnswer((_) async {});

    final c = containerWith();
    await c.read(lectureFlashcardsProvider('lec-1').future);
    await c
        .read(lectureFlashcardsProvider('lec-1').notifier)
        .setSelfGrade('a', FlashcardSelfGrade.again);

    final state = c.read(lectureFlashcardsProvider('lec-1')).value!;
    expect(state.items[0].selfGrade, FlashcardSelfGrade.again);
    // Only the graded card moved.
    expect(state.items[1].selfGrade, isNull);
  });

  test('a REFUSED grade changes nothing locally and propagates', () async {
    stubFirst(page([card('a')], hasMore: false));
    when(
      () => repo.setSelfGrade('a', FlashcardSelfGrade.gotIt),
    ).thenThrow(const ApiException(status: 403, code: 'insufficient_scope'));

    final c = containerWith();
    await c.read(lectureFlashcardsProvider('lec-1').future);

    await expectLater(
      c
          .read(lectureFlashcardsProvider('lec-1').notifier)
          .setSelfGrade('a', FlashcardSelfGrade.gotIt),
      throwsA(isA<ApiException>()),
    );

    // The UI must never show a grade the server does not hold.
    expect(
      c.read(lectureFlashcardsProvider('lec-1')).value!.items.single.selfGrade,
      isNull,
    );
  });

  test('a failed first page SETTLES on AsyncError — no auto-retry', () async {
    // Riverpod 3 retries a failed build with exponential backoff and keeps the
    // state on `AsyncLoading` CARRYING the error while it does. That is the
    // observable difference, and it is what this asserts: with auto-retry the
    // surface would sit on its skeleton forever instead of showing the error
    // view. Here it is worse than cosmetic — every silent retry that SUCCEEDS
    // can spend another slice of a 50/week allowance.
    when(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: null,
        pageSize: any(named: 'pageSize'),
      ),
    ).thenThrow(const OfflineException());

    final c = containerWith();
    // Hold a listener, as `catalog_notifier_test.dart` does. Without one this
    // autoDispose provider is disposed the moment the read releases, and no
    // retry could fire whether or not `retry: _noRetry` is set — the test would
    // then pass for the wrong reason.
    c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});

    await pumpEventQueue();

    final state = c.read(lectureFlashcardsProvider('lec-1'));
    expect(state, isA<AsyncError<LectureFlashcards>>());
    expect(state.isLoading, isFalse);
    expect(state.error, isA<OfflineException>());
    verify(
      () => repo.getFlashcardsForLecture(
        any(),
        cursor: null,
        pageSize: any(named: 'pageSize'),
      ),
    ).called(1);
  });
}
