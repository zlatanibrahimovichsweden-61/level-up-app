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

  test(
    'the first round asks for 10 cards, from the start of the deck',
    () async {
      // Asserted as the literal that reaches the repository, not as the constant
      // compared to itself. A round is ten cards (owner ruling 2026-09-29, the
      // frame's "1/10") and the contract says the same: contract-changelog
      // 2026-09-25, "one `pageSize=10` page per round, a short round when the
      // lecture has fewer cards". 10 is inside the endpoint's 1..50 bound; the
      // repository's own default of 20 is NOT what a round sends.
      stubFirst(page([card('a')], hasMore: false));
      final c = containerWith();

      await c.read(lectureFlashcardsProvider('lec-1').future);

      verify(
        () => repo.getFlashcardsForLecture('lec-1', cursor: null, pageSize: 10),
      ).called(1);
      expect(flashcardRoundSize, 10, reason: 'the frame shows 1/10');
      expect(
        FlashcardsRepository.defaultPageSize,
        20,
        reason: 'the repository default mirrors the contract and did not move',
      );
    },
  );

  test('an empty lecture is empty, not an error', () async {
    stubFirst(page([], hasMore: false));
    final c = containerWith();

    final state = await c.read(lectureFlashcardsProvider('lec-1').future);

    expect(state.isEmpty, isTrue);
    expect(c.read(lectureFlashcardsProvider('lec-1')).hasError, isFalse);
  });

  test('a SHORT first page still reports more, and loadMore appends', () async {
    // 🔴 The allowance-truncation case. Two cards came back for a 10-card
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
    // A failed append must not blank cards the student is already looking at
    // (they would re-deliver free within the week, but the view would still
    // collapse to an error), so the failure is carried beside them instead.
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
    // view. Here it is worse than cosmetic — some refusals on this endpoint
    // (`403 flashcard_subscription_required`) no retry can cure.
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

  group('the study round', () {
    // The Setup screen watches the position so it outlives the study screen;
    // these tests hold the same listener for the same reason. Without one this
    // autoDispose provider would be dropped the moment a write returned.
    ProviderSubscription<String?> holdPosition(
      ProviderContainer c, [
      String lectureId = 'lec-1',
    ]) => c.listen(flashcardRoundPositionProvider(lectureId), (_, _) {});

    void stubAt(String? cursor, CursorPage<FlashcardCard> result) {
      when(
        () => repo.getFlashcardsForLecture(
          any(),
          cursor: cursor,
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async => result);
    }

    test('with no stored position a round starts at the start of the deck', () {
      final c = containerWith();

      expect(c.read(flashcardRoundPositionProvider('lec-1')), isNull);
    });

    test('a stored position is where the round STARTS', () async {
      stubAt('tok-7', page([card('h'), card('i')], hasMore: false));
      final c = containerWith();
      holdPosition(c);
      c.read(flashcardRoundPositionProvider('lec-1').notifier).moveTo('tok-7');

      final state = await c.read(lectureFlashcardsProvider('lec-1').future);

      expect(state.items.map((i) => i.id), ['h', 'i']);
      verify(
        () => repo.getFlashcardsForLecture(
          'lec-1',
          cursor: 'tok-7',
          pageSize: 10,
        ),
      ).called(1);
      verifyNever(
        () => repo.getFlashcardsForLecture(
          any(),
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      );
    });

    test(
      'finishRound stores the nextCursor while the server says hasMore',
      () async {
        stubFirst(page([card('a')], nextCursor: 'tok-1', hasMore: true));
        final c = containerWith();
        holdPosition(c);
        await c.read(lectureFlashcardsProvider('lec-1').future);

        c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();

        expect(c.read(flashcardRoundPositionProvider('lec-1')), 'tok-1');
      },
    );

    test('finishRound wraps to the start when the deck is exhausted', () async {
      // The second round of a deck: it started at 'tok-1' and the server says
      // there is nothing after it. The position goes back to null — the start.
      stubAt('tok-1', page([card('z')], hasMore: false));
      final c = containerWith();
      final position = holdPosition(c);
      c.read(flashcardRoundPositionProvider('lec-1').notifier).moveTo('tok-1');
      await c.read(lectureFlashcardsProvider('lec-1').future);
      expect(position.read(), 'tok-1');

      c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();

      expect(position.read(), isNull);
    });

    test('finishRound follows hasMore, not the size of the round', () async {
      // A SHORT round (1 card for a 10-card request) whose hasMore is true
      // must still advance: items.length < 10 is not the end of the deck.
      stubFirst(page([card('a')], nextCursor: 'tok-1', hasMore: true));
      final c = containerWith();
      holdPosition(c);
      final round = await c.read(lectureFlashcardsProvider('lec-1').future);
      expect(round.items.length, lessThan(flashcardRoundSize));

      c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();

      expect(c.read(flashcardRoundPositionProvider('lec-1')), 'tok-1');
    });

    test(
      'after finishRound a FRESH build starts at the stored cursor',
      () async {
        stubFirst(
          page([card('a'), card('b')], nextCursor: 'tok-1', hasMore: true),
        );
        stubAt('tok-1', page([card('c')], hasMore: false));
        final c = containerWith();
        holdPosition(c); // Setup, still on the stack.

        // Round one: the study screen listens, finishes, and is popped.
        final study = c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});
        await c.read(lectureFlashcardsProvider('lec-1').future);
        c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();
        study.close();
        await pumpEventQueue();
        expect(c.exists(lectureFlashcardsProvider('lec-1')), isFalse);

        // Round two: the study screen is opened again from Setup.
        final second = await c.read(lectureFlashcardsProvider('lec-1').future);

        expect(second.items.map((i) => i.id), ['c']);
        verifyInOrder([
          () =>
              repo.getFlashcardsForLecture('lec-1', cursor: null, pageSize: 10),
          () => repo.getFlashcardsForLecture(
            'lec-1',
            cursor: 'tok-1',
            pageSize: 10,
          ),
        ]);
      },
    );

    test('the position is per lecture', () async {
      stubFirst(page([card('a')], nextCursor: 'tok-1', hasMore: true));
      final c = containerWith();
      holdPosition(c);
      holdPosition(c, 'lec-2');
      await c.read(lectureFlashcardsProvider('lec-1').future);

      c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();

      expect(c.read(flashcardRoundPositionProvider('lec-1')), 'tok-1');
      expect(c.read(flashcardRoundPositionProvider('lec-2')), isNull);
    });

    test('the position resets to the start once nothing listens', () async {
      final c = containerWith();
      final position = holdPosition(c);
      c.read(flashcardRoundPositionProvider('lec-1').notifier).moveTo('tok-1');
      expect(position.read(), 'tok-1');

      // Setup leaves the stack.
      position.close();
      await pumpEventQueue();
      expect(c.exists(flashcardRoundPositionProvider('lec-1')), isFalse);

      expect(c.read(flashcardRoundPositionProvider('lec-1')), isNull);
    });

    test('finishRound with no delivered round moves nothing', () async {
      // The first page failed: there is no round to advance past.
      when(
        () => repo.getFlashcardsForLecture(
          any(),
          cursor: 'tok-7',
          pageSize: any(named: 'pageSize'),
        ),
      ).thenThrow(const OfflineException());
      final c = containerWith();
      holdPosition(c);
      c.read(flashcardRoundPositionProvider('lec-1').notifier).moveTo('tok-7');
      c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});
      await pumpEventQueue();
      expect(c.read(lectureFlashcardsProvider('lec-1')).hasError, isTrue);

      c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();

      expect(
        c.read(flashcardRoundPositionProvider('lec-1')),
        'tok-7',
        reason: 'a round that never arrived must not be skipped',
      );
    });

    test('refresh retries the SAME round, not the start of the deck', () async {
      stubAt('tok-7', page([card('h')], hasMore: false));
      final c = containerWith();
      holdPosition(c);
      c.read(flashcardRoundPositionProvider('lec-1').notifier).moveTo('tok-7');
      c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});
      await c.read(lectureFlashcardsProvider('lec-1').future);

      await c.read(lectureFlashcardsProvider('lec-1').notifier).refresh();

      verify(
        () => repo.getFlashcardsForLecture(
          'lec-1',
          cursor: 'tok-7',
          pageSize: 10,
        ),
      ).called(2);
      verifyNever(
        () => repo.getFlashcardsForLecture(
          any(),
          cursor: null,
          pageSize: any(named: 'pageSize'),
        ),
      );
    });

    test('a preview-truncated round advances INTO the 403 it will meet', () async {
      // The weekly preview paid for 3 of 10 cards: a short round, hasMore true,
      // nextCursor at the first card NOT delivered. Finishing it must store
      // that cursor — wrapping to the start would re-serve cards just seen and
      // hide the student's real allowance state. The next round then starts at
      // the undelivered card and the server answers 403.
      stubFirst(
        page(
          [card('a'), card('b'), card('c')],
          nextCursor: 'tok-4',
          hasMore: true,
        ),
      );
      when(
        () => repo.getFlashcardsForLecture(
          any(),
          cursor: 'tok-4',
          pageSize: any(named: 'pageSize'),
        ),
      ).thenThrow(
        const ApiException(
          status: 403,
          code: 'flashcard_subscription_required',
        ),
      );
      final c = containerWith();
      holdPosition(c);
      final study = c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});
      await c.read(lectureFlashcardsProvider('lec-1').future);
      c.read(lectureFlashcardsProvider('lec-1').notifier).finishRound();
      study.close();
      await pumpEventQueue();
      expect(c.read(flashcardRoundPositionProvider('lec-1')), 'tok-4');

      c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});
      await pumpEventQueue();

      final state = c.read(lectureFlashcardsProvider('lec-1'));
      expect(state, isA<AsyncError<LectureFlashcards>>());
      expect(state.isLoading, isFalse);
    });

    test(
      '403 flashcard_subscription_required settles on AsyncError, once',
      () async {
        // The first page of a round refused because the free weekly preview is
        // used up. The code must reach the surface intact (it picks the copy),
        // and there must be no automatic retry: no retry can cure this, and with
        // auto-retry the surface would sit on its skeleton instead of showing it.
        when(
          () => repo.getFlashcardsForLecture(
            any(),
            cursor: null,
            pageSize: any(named: 'pageSize'),
          ),
        ).thenThrow(
          const ApiException(
            status: 403,
            code: 'flashcard_subscription_required',
          ),
        );
        final c = containerWith();
        c.listen(lectureFlashcardsProvider('lec-1'), (_, _) {});

        await pumpEventQueue();

        final state = c.read(lectureFlashcardsProvider('lec-1'));
        expect(state, isA<AsyncError<LectureFlashcards>>());
        expect(state.isLoading, isFalse);
        expect(state.error, isA<ApiException>());
        final error = state.error! as ApiException;
        expect(error.status, 403);
        expect(error.code, 'flashcard_subscription_required');
        verify(
          () => repo.getFlashcardsForLecture(
            any(),
            cursor: null,
            pageSize: any(named: 'pageSize'),
          ),
        ).called(1);
      },
    );
  });
}
