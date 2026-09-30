import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/flashcards/models/flashcard.dart';
import 'package:level_up_app/features/flashcards/repository/flashcards_repository.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';

/// The two `stable` Flashcards operations, served by the on-device mock.
///
/// The harness is the only place the study surface can be walked with more than
/// a one-row list: the one staging account has no University catalog. So these
/// pin the behaviour the contract actually specifies - the weekly preview, the
/// short page that is NOT the end, the refusal that is deliberately
/// indistinguishable, the latest-wins grade - and drive it through the REAL
/// [FlashcardsRepository] and [QuizRepository], which also proves the requests
/// the app builds are the ones the mock understands.
///
/// Every test gets a FRESH interceptor (`buildMockDio` per session), so the
/// weekly allowance, the charged cards and the grades all start empty.
void main() {
  group('GET /flashcards/lectures/{id}/cards - paging', () {
    test(
      '24 cards page 10 / 10 / 4 by cursor, and hasMore says when to stop',
      () async {
        final s = await _Session.university();

        final first = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        expect(first.items, hasLength(10));
        expect(first.hasMore, isTrue);
        expect(first.nextCursor, isNotNull);

        final second = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          cursor: first.nextCursor,
          pageSize: 10,
        );
        expect(second.items, hasLength(10));
        expect(second.hasMore, isTrue);
        expect(second.nextCursor, isNotNull);

        final third = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          cursor: second.nextCursor,
          pageSize: 10,
        );
        expect(third.items, hasLength(4));
        expect(third.hasMore, isFalse);
        expect(third.nextCursor, isNull);

        // Stable and resumable: one contiguous run, nothing repeated or skipped.
        expect(
          [...first.items, ...second.items, ...third.items].map((c) => c.id),
          [for (var n = 1; n <= 24; n++) _cardId('anatomy-l1', n)],
        );
      },
    );

    for (final (lecture, count) in const [
      ('anatomy-l2', 10), // exactly one round
      ('anatomy-l3', 4), // a short round
      ('anatomy-l4', 1), // a single card
      ('physio-l2', 3),
    ]) {
      test(
        '$lecture serves its $count card(s) as ONE page, hasMore false',
        () async {
          final s = await _Session.university();

          final page = await s.cards.getFlashcardsForLecture(
            lecture,
            pageSize: 10,
          );

          expect(page.items, hasLength(count));
          expect(page.hasMore, isFalse);
          expect(page.nextCursor, isNull);
        },
      );
    }

    test(
      'a lecture with no cards is 200 with empty items - not an error',
      () async {
        final s = await _Session.university();

        for (final lecture in const ['physio-l3', 'biochem-l1']) {
          final page = await s.cards.getFlashcardsForLecture(lecture);
          expect(page.items, isEmpty, reason: lecture);
          expect(page.hasMore, isFalse, reason: lecture);
          expect(page.nextCursor, isNull, reason: lecture);
        }
      },
    );

    test('the default pageSize is 20', () async {
      final s = await _Session.university();

      final page = await s.cards.getFlashcardsForLecture('anatomy-l1');

      expect(page.items, hasLength(20));
      expect(page.hasMore, isTrue);
    });

    test(
      'pageSize 1 and pageSize 50 (the contract maximum) are accepted',
      () async {
        final s = await _Session.university();

        final one = await s.cards.getFlashcardsForLecture(
          'anatomy-l3',
          pageSize: 1,
        );
        expect(one.items, hasLength(1));
        expect(one.hasMore, isTrue);

        final all = await s.cards.getFlashcardsForLecture(
          'anatomy-l3',
          pageSize: 50,
        );
        expect(all.items, hasLength(4));
        expect(all.hasMore, isFalse);
      },
    );

    test('the wire shape is {id, front, back, imageUrl, selfGrade}', () async {
      final dio = await _universityDio();

      final res = await dio.get<Map<String, dynamic>>(
        '/flashcards/lectures/anatomy-l3/cards',
      );

      expect(res.statusCode, 200);
      expect(
        res.data!.keys,
        unorderedEquals(<String>['items', 'nextCursor', 'hasMore']),
      );
      final items = (res.data!['items']! as List<dynamic>)
          .cast<Map<String, dynamic>>();
      expect(items, isNotEmpty);
      for (final card in items) {
        expect(
          card.keys,
          unorderedEquals(<String>[
            'id',
            'front',
            'back',
            'imageUrl',
            'selfGrade',
          ]),
        );
        // `null` is the answer in every environment today, and legal.
        expect(card['imageUrl'], isNull);
        // Never graded, so no value - present-and-null, not absent.
        expect(card['selfGrade'], isNull);
      }
    });
  });

  group('GET /flashcards/lectures/{id}/cards - scope and validation', () {
    test('the School track is insufficient_scope', () async {
      final s = _Session.school();

      await expectLater(
        s.cards.getFlashcardsForLecture('anatomy-l1'),
        throwsA(_apiError(403, 'insufficient_scope')),
      );
    });

    test('an unknown lecture id is insufficient_scope', () async {
      final s = await _Session.university();

      for (final id in const [
        'no-such-lecture',
        // Well-formed and unassigned: a UUID grants nothing by being valid.
        '0197b2f3-9999-7cc3-9b4e-000000000001',
        // Another cohort's id - a School lesson is no University lecture.
        'bio-u1-c1-l1',
      ]) {
        await expectLater(
          s.cards.getFlashcardsForLecture(id),
          throwsA(_apiError(403, 'insufficient_scope')),
          reason: id,
        );
      }
    });

    test(
      'every cause answers with ONE byte-identical body that names no id',
      () async {
        final school = _Session.school().dio;
        final university = await _universityDio();

        final bodies = <Map<String, dynamic>>[
          // The School track.
          await _problemBody(
            () => school.get<Object?>('/flashcards/lectures/anatomy-l1/cards'),
          ),
          // An id that names nothing.
          await _problemBody(
            () => university.get<Object?>(
              '/flashcards/lectures/no-such-lecture/cards',
            ),
          ),
          // Another cohort's lecture.
          await _problemBody(
            () => university.get<Object?>(
              '/flashcards/lectures/bio-u1-c1-l1/cards',
            ),
          ),
          // Grading a card that was never shown - the contract folds it in.
          await _problemBody(
            () => university.put<Object?>(
              '/flashcards/cards/anatomy-l1-c01/self-grade',
              data: <String, dynamic>{'grade': 'gotIt'},
            ),
          ),
          // Grading a card that does not exist.
          await _problemBody(
            () => university.put<Object?>(
              '/flashcards/cards/no-such-card/self-grade',
              data: <String, dynamic>{'grade': 'gotIt'},
            ),
          ),
        ];

        expect(bodies.first['code'], 'insufficient_scope');
        for (final body in bodies) {
          expect(body, bodies.first);
        }
        // No existence probe: nothing the caller sent comes back to them.
        final text = jsonEncode(bodies.first);
        for (final echoed in const [
          'no-such-lecture',
          'no-such-card',
          'anatomy-l1',
          'bio-u1-c1-l1',
        ]) {
          expect(text, isNot(contains(echoed)));
        }
      },
    );

    test(
      'a refused caller gets the scope refusal even with a bad query',
      () async {
        final s = _Session.school();

        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l1', pageSize: 0),
          throwsA(_apiError(403, 'insufficient_scope')),
        );
      },
    );

    test('pageSize outside 1..50 is validation_failed on pageSize', () async {
      final s = await _Session.university();

      for (final pageSize in const [0, 51, -1, 1000]) {
        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l1', pageSize: pageSize),
          throwsA(_invalidFields(['pageSize'])),
          reason: 'pageSize $pageSize',
        );
      }
    });

    test(
      'a pageSize that is not an integer is validation_failed too',
      () async {
        final dio = await _universityDio();

        for (final raw in const ['abc', '10.5', '']) {
          final failure = await _rejection(
            dio.get<Object?>(
              '/flashcards/lectures/anatomy-l1/cards',
              queryParameters: <String, dynamic>{'pageSize': raw},
            ),
          );
          expect(
            failure,
            _invalidFields(['pageSize']),
            reason: 'pageSize "$raw"',
          );
        }
      },
    );

    test('a malformed cursor is validation_failed on cursor', () async {
      final s = await _Session.university();

      for (final cursor in const ['not-a-cursor', 'bm90LWEtY3Vyc29y', '']) {
        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l1', cursor: cursor),
          throwsA(_invalidFields(['cursor'])),
          reason: 'cursor "$cursor"',
        );
      }
    });

    test(
      'a cursor issued for another lecture is refused, not followed',
      () async {
        final s = await _Session.university();
        final first = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );

        await expectLater(
          s.cards.getFlashcardsForLecture(
            'anatomy-l2',
            cursor: first.nextCursor,
            pageSize: 10,
          ),
          throwsA(_invalidFields(['cursor'])),
        );
      },
    );

    test(
      'a hand-altered cursor offset outside the list is validation_failed',
      () async {
        final s = await _Session.university();
        final first = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );

        // The mock's cursor is `<lecture>:<offset>` in base64url - by design, so
        // an altered one fails here as an altered signed one fails on the server.
        for (final offset in const [999, -1]) {
          await expectLater(
            s.cards.getFlashcardsForLecture(
              'anatomy-l1',
              cursor: _withOffset(first.nextCursor!, offset),
            ),
            throwsA(_invalidFields(['cursor'])),
            reason: 'offset $offset',
          );
        }
      },
    );
  });

  group('GET /flashcards/lectures/{id}/cards - the shared weekly allowance', () {
    test(
      'a charged card re-delivers free: page 1 twice spends the allowance ONCE',
      () async {
        final s = await _Session.university();

        final first = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        final again = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        expect(again.items.map((c) => c.id), first.items.map((c) => c.id));

        // 10 spent. Charged twice it would be 20, and the second of these two
        // quizzes (30 + 10 = 40 more) could not fit.
        await s.spend(QuizLength.thirty);
        await s.spend(QuizLength.ten);
        // ... and exactly 50 is used now, so one more unit anywhere is over.
        await expectLater(
          s.spend(QuizLength.ten),
          throwsA(_apiError(403, 'weekly_question_limit_reached')),
        );
      },
    );

    test(
      'ONE allowance across both surfaces: cards spend what quizzes draw from',
      () async {
        final s = await _Session.university();

        await s.spend(QuizLength.thirty);
        final page = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 20,
        );
        expect(page.items, hasLength(20));

        // 30 (quiz) + 20 (cards) = 50: the QUIZ side is now out of allowance.
        await expectLater(
          s.spend(QuizLength.ten),
          throwsA(_apiError(403, 'weekly_question_limit_reached')),
        );
      },
    );

    test(
      'a drained allowance truncates the page to the affordable prefix',
      () async {
        final s = await _Session.university();
        // 30 + 10 from quizzes, then 4 + 1 from other lectures' cards = 45 used.
        await s.spend(QuizLength.thirty);
        await s.spend(QuizLength.ten);
        await s.cards.getFlashcardsForLecture('anatomy-l3');
        await s.cards.getFlashcardsForLecture('anatomy-l4');

        final page = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );

        // 5 units were left: SHORTER than the page, and not the end of the list.
        expect(page.items.map((c) => c.id), [
          for (var n = 1; n <= 5; n++) _cardId('anatomy-l1', n),
        ]);
        expect(page.hasMore, isTrue);
        expect(page.nextCursor, isNotNull);

        // The cursor points at the first card NOT delivered: it is exactly the
        // one a fresh student gets after being handed the first five cards.
        final fresh = await _Session.university();
        final afterFive = await fresh.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 5,
        );
        expect(page.nextCursor, afterFive.nextCursor);

        // The allowance is spent, so following it delivers nothing.
        await expectLater(
          s.cards.getFlashcardsForLecture(
            'anatomy-l1',
            cursor: page.nextCursor,
            pageSize: 10,
          ),
          throwsA(_apiError(403, 'flashcard_subscription_required')),
        );

        // The five already charged still re-deliver free, and still stop there.
        final replay = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        expect(replay.items.map((c) => c.id), page.items.map((c) => c.id));
        expect(replay.hasMore, isTrue);
      },
    );

    test(
      'a truncated FINAL page still says hasMore: branch on hasMore, not on the page end',
      () async {
        final s = await _Session.university();
        // 30 + 10 from quizzes, then 4 + 1 + 3 from three short lectures = 48.
        await s.spend(QuizLength.thirty);
        await s.spend(QuizLength.ten);
        await s.cards.getFlashcardsForLecture('anatomy-l3');
        await s.cards.getFlashcardsForLecture('anatomy-l4');
        await s.cards.getFlashcardsForLecture('physio-l2');
        // A cursor at card 21 - the last four - minted by another student.
        final atTwentyOne = await (await _Session.university()).cards
            .getFlashcardsForLecture('anatomy-l1', pageSize: 20);

        final page = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          cursor: atTwentyOne.nextCursor,
          pageSize: 10,
        );

        // 2 units left for 4 cards: the page reaches the end of the LIST, yet
        // two cards were not delivered, so the list is not finished.
        expect(page.items.map((c) => c.id), [
          _cardId('anatomy-l1', 21),
          _cardId('anatomy-l1', 22),
        ]);
        expect(page.hasMore, isTrue);
        expect(page.nextCursor, isNotNull);
      },
    );

    test(
      'the prefix stops at the first unaffordable card, even when later cards are free',
      () async {
        final s = await _Session.university();
        // Cards 7-10 charged, cards 1-6 not: a cursor at card 6 from another
        // student reaches past the hole.
        final atSix = await (await _Session.university()).cards
            .getFlashcardsForLecture('anatomy-l1', pageSize: 6);
        await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          cursor: atSix.nextCursor,
          pageSize: 4,
        );
        // 4 + 6 = 10 units from cards, 40 from quizzes: nothing is left.
        await s.cards.getFlashcardsForLecture('anatomy-l2', pageSize: 6);
        await s.spend(QuizLength.thirty);
        await s.spend(QuizLength.ten);

        // Card 1 cannot be paid for, and the prefix is empty: 403, although
        // cards 7-10 of this very page are free.
        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l1', pageSize: 10),
          throwsA(_apiError(403, 'flashcard_subscription_required')),
        );
      },
    );

    test(
      'zero deliverable cards is flashcard_subscription_required, never an empty page',
      () async {
        final s = await _Session.university();
        await s.spend(QuizLength.fifty);

        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l1'),
          throwsA(_apiError(403, 'flashcard_subscription_required')),
        );
        // Not a one-off: nothing was charged or half-recorded by the refusal.
        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l1'),
          throwsA(_apiError(403, 'flashcard_subscription_required')),
        );

        // An empty lecture has nothing to charge, so it is still a plain 200.
        final empty = await s.cards.getFlashcardsForLecture('physio-l3');
        expect(empty.items, isEmpty);
        expect(empty.hasMore, isFalse);
      },
    );

    test(
      'a page of charged cards is delivered in full at zero allowance',
      () async {
        final s = await _Session.university();
        await s.spend(QuizLength.thirty);
        await s.spend(QuizLength.ten);
        // The last 10 units buy anatomy-l2 whole.
        final bought = await s.cards.getFlashcardsForLecture('anatomy-l2');
        expect(bought.items, hasLength(10));

        final replay = await s.cards.getFlashcardsForLecture('anatomy-l2');
        expect(replay.items.map((c) => c.id), bought.items.map((c) => c.id));
        expect(replay.hasMore, isFalse);

        // ... while a lecture never shown is out of reach.
        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l3'),
          throwsA(_apiError(403, 'flashcard_subscription_required')),
        );
      },
    );
  });

  group('PUT /flashcards/cards/{id}/self-grade', () {
    test(
      'gotIt then again: 204 both times, and the LATEST is echoed on re-fetch',
      () async {
        final s = await _Session.university();
        final page = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        expect(page.items.map((c) => c.selfGrade), everyElement(isNull));
        final one = page.items[0].id;
        final two = page.items[1].id;

        await s.cards.setSelfGrade(one, FlashcardSelfGrade.gotIt);
        await s.cards.setSelfGrade(two, FlashcardSelfGrade.again);
        var refetched = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        expect(refetched.items[0].selfGrade, FlashcardSelfGrade.gotIt);
        expect(refetched.items[1].selfGrade, FlashcardSelfGrade.again);
        // A property of the card the student graded, not of the page.
        expect(
          refetched.items.skip(2).map((c) => c.selfGrade),
          everyElement(isNull),
        );

        // A second grade REPLACES the first: no history, no score.
        await s.cards.setSelfGrade(one, FlashcardSelfGrade.again);
        refetched = await s.cards.getFlashcardsForLecture(
          'anatomy-l1',
          pageSize: 10,
        );
        expect(refetched.items[0].selfGrade, FlashcardSelfGrade.again);
      },
    );

    test('is idempotent, and answers 204 with no body', () async {
      final s = await _Session.university();
      final page = await s.cards.getFlashcardsForLecture('anatomy-l3');
      final id = page.items.first.id;

      for (var attempt = 0; attempt < 2; attempt++) {
        final res = await s.dio.put<Object?>(
          '/flashcards/cards/$id/self-grade',
          data: <String, dynamic>{'grade': 'gotIt'},
        );
        expect(res.statusCode, 204, reason: 'attempt $attempt');
        expect(res.data, isNull, reason: 'attempt $attempt');
      }

      final refetched = await s.cards.getFlashcardsForLecture('anatomy-l3');
      expect(refetched.items.first.selfGrade, FlashcardSelfGrade.gotIt);
    });

    test(
      'grading a card that was never shown is insufficient_scope, NOT flashcard_subscription_required',
      () async {
        final s = await _Session.university();

        await expectLater(
          s.cards.setSelfGrade(
            _cardId('anatomy-l1', 1),
            FlashcardSelfGrade.gotIt,
          ),
          throwsA(_apiError(403, 'insufficient_scope')),
        );
      },
    );

    test(
      'a card past the delivered prefix is out of reach; one inside it is not',
      () async {
        final s = await _Session.university();
        await s.spend(QuizLength.thirty);
        await s.spend(QuizLength.ten);
        await s.cards.getFlashcardsForLecture('anatomy-l3');
        await s.cards.getFlashcardsForLecture('anatomy-l4');
        // 5 of the 24 were delivered, then the allowance ran out.
        await s.cards.getFlashcardsForLecture('anatomy-l1', pageSize: 10);

        await s.cards.setSelfGrade(
          _cardId('anatomy-l1', 5),
          FlashcardSelfGrade.gotIt,
        );
        await expectLater(
          s.cards.setSelfGrade(
            _cardId('anatomy-l1', 6),
            FlashcardSelfGrade.gotIt,
          ),
          throwsA(_apiError(403, 'insufficient_scope')),
        );
      },
    );

    test('an unknown card id is insufficient_scope', () async {
      final s = await _Session.university();
      await s.cards.getFlashcardsForLecture('anatomy-l1');

      await expectLater(
        s.cards.setSelfGrade('no-such-card', FlashcardSelfGrade.again),
        throwsA(_apiError(403, 'insufficient_scope')),
      );
    });

    test(
      'the School track is insufficient_scope, even for a card charged earlier',
      () async {
        final s = await _Session.university();
        final id = (await s.cards.getFlashcardsForLecture(
          'anatomy-l3',
        )).items.first.id;

        // The same mock session becomes a School student.
        await s.logIn(_schoolCode);

        await expectLater(
          s.cards.setSelfGrade(id, FlashcardSelfGrade.gotIt),
          throwsA(_apiError(403, 'insufficient_scope')),
        );
        await expectLater(
          s.cards.getFlashcardsForLecture('anatomy-l3'),
          throwsA(_apiError(403, 'insufficient_scope')),
        );
      },
    );

    test(
      'a grade that is missing or not gotIt/again is validation_failed on grade',
      () async {
        final s = await _Session.university();
        final id = (await s.cards.getFlashcardsForLecture(
          'anatomy-l3',
        )).items.first.id;
        await s.cards.setSelfGrade(id, FlashcardSelfGrade.gotIt);

        for (final data in <Map<String, dynamic>?>[
          null, // no body at all
          <String, dynamic>{}, // grade missing
          <String, dynamic>{'grade': null},
          <String, dynamic>{'grade': ''},
          <String, dynamic>{'grade': 'maybe'},
          <String, dynamic>{'grade': 'GOTIT'}, // the enum is case-sensitive
          <String, dynamic>{'grade': 1},
        ]) {
          final failure = await _rejection(
            s.dio.put<Object?>('/flashcards/cards/$id/self-grade', data: data),
          );
          expect(failure, _invalidFields(['grade']), reason: '$data');
        }

        // A rejected grade changes nothing.
        final refetched = await s.cards.getFlashcardsForLecture('anatomy-l3');
        expect(refetched.items.first.selfGrade, FlashcardSelfGrade.gotIt);
      },
    );

    test(
      'the gate is checked BEFORE the grade, so a bad grade on a foreign card is still a 403',
      () async {
        final dio = await _universityDio();

        final failure = await _rejection(
          dio.put<Object?>(
            '/flashcards/cards/anatomy-l1-c01/self-grade',
            data: <String, dynamic>{'grade': 'maybe'},
          ),
        );

        expect(failure, _apiError(403, 'insufficient_scope'));
      },
    );
  });

  group('fixtures', () {
    /// `flashcardCount` as `getSubjectTree` declares it, per lecture. Written
    /// out on purpose: it pins the counts the Flash Card Setup screen shows.
    const declared = <String, int>{
      'anatomy-l1': 24,
      'anatomy-l2': 10,
      'anatomy-l3': 4,
      'anatomy-l4': 1,
      'physio-l1': 12,
      'physio-l2': 3,
      'physio-l3': 0,
      'biochem-l1': 0,
      'biochem-l2': 0,
      'biochem-l3': 0,
    };

    /// Every lecture of every University subject, as the Learn tab is handed it.
    Future<List<Map<String, dynamic>>> allLectures() async {
      final dio = await _universityDio();
      final subjects = (await dio.get<List<dynamic>>(
        '/catalog/subjects',
      )).data!.cast<Map<String, dynamic>>();
      final lectures = <Map<String, dynamic>>[];
      for (final subject in subjects) {
        final tree = await dio.get<Map<String, dynamic>>(
          '/catalog/subjects/${subject['id']}/tree',
        );
        lectures.addAll(
          (tree.data!['lectures']! as List<dynamic>)
              .cast<Map<String, dynamic>>(),
        );
      }
      return lectures;
    }

    /// Every card a lecture holds, in one page. A FRESH session per call: all
    /// 54 cards together cost more than one week's allowance.
    Future<List<FlashcardCard>> deckOf(String lecture) async {
      final s = await _Session.university();
      final page = await s.cards.getFlashcardsForLecture(lecture, pageSize: 50);
      expect(page.hasMore, isFalse, reason: lecture);
      return page.items;
    }

    test(
      'the tree declares the counts the study surface was specified with',
      () async {
        final lectures = await allLectures();

        expect({
          for (final l in lectures)
            l['id']! as String: l['flashcardCount']! as int,
        }, declared);
      },
    );

    test(
      'every lecture flashcardCount equals the cards it serves, and hasFlashcards agrees',
      () async {
        final lectures = await allLectures();
        expect(lectures, hasLength(declared.length));

        for (final lecture in lectures) {
          final id = lecture['id']! as String;
          final count = lecture['flashcardCount']! as int;

          expect((await deckOf(id)).length, count, reason: id);
          expect(lecture['hasFlashcards'], count > 0, reason: id);
        }
      },
    );

    test(
      'card ids are unique, readable and named after their lecture',
      () async {
        final ids = <String>[];
        for (final lecture in declared.keys) {
          final deck = await deckOf(lecture);
          for (var n = 1; n <= deck.length; n++) {
            expect(deck[n - 1].id, _cardId(lecture, n));
          }
          ids.addAll(deck.map((c) => c.id));
        }

        expect(ids, hasLength(54));
        expect(ids.toSet(), hasLength(ids.length));
      },
    );

    test('the deck exercises what the study surface must render', () async {
      final cards = <FlashcardCard>[
        for (final lecture in declared.keys) ...await deckOf(lecture),
      ];
      final arabic = RegExp(r'[؀-ۿ]');

      // Never empty, and never an image today.
      for (final card in cards) {
        expect(card.front.trim(), isNotEmpty, reason: card.id);
        expect(card.back.trim(), isNotEmpty, reason: card.id);
        expect(card.imageUrl, isNull, reason: card.id);
        expect(card.selfGrade, isNull, reason: card.id);
      }

      // `back` may hold several answers: at least one is a multi-line block.
      expect(cards.where((c) => c.back.split('\n').length >= 3), isNotEmpty);
      // A long prompt, that wraps to two or three lines on a phone.
      expect(cards.any((c) => c.front.length >= 100), isTrue);
      // Arabic on both sides of at least two cards, for the RTL card face.
      expect(
        cards
            .where((c) => arabic.hasMatch(c.front) && arabic.hasMatch(c.back))
            .length,
        greaterThanOrEqualTo(2),
      );
    });
  });
}

const _phone = '+201001234567';

/// The mock's magic OTP codes: they land the session on `/home` with a full
/// session, on the University and the School track respectively.
const _universityCode = '111111';
const _schoolCode = '000000';

String _cardId(String lecture, int n) =>
    '$lecture-c${n.toString().padLeft(2, '0')}';

/// A signed-in University student on a fresh mock, as a raw client.
Future<Dio> _universityDio() async {
  final dio = buildMockDio(latency: Duration.zero);
  await _logIn(dio, _universityCode);
  return dio;
}

Future<void> _logIn(Dio dio, String code) async {
  await dio.post<Object?>(
    '/auth/otp/verify',
    data: <String, dynamic>{'phone': _phone, 'code': code},
  );
}

/// One mock student: a fresh interceptor (so a fresh weekly allowance, fresh
/// charged cards and fresh grades) driven through the REAL repositories.
class _Session {
  _Session._(this.dio)
    : cards = FlashcardsRepository(dio),
      quizzes = QuizRepository(dio);

  /// The default track of a fresh mock is School - no sign-in needed.
  factory _Session.school() => _Session._(buildMockDio(latency: Duration.zero));

  static Future<_Session> university() async =>
      _Session._(await _universityDio());

  final Dio dio;
  final FlashcardsRepository cards;
  final QuizRepository quizzes;

  Future<void> logIn(String code) => _logIn(dio, code);

  /// Spends [length] units of the weekly allowance the way a student does: by
  /// starting a quiz. `anatomy-l2` holds a 120-question pool, so any length
  /// fits; it is also NOT one of the mock's paid scopes.
  Future<void> spend(QuizLength length) async {
    await quizzes.createQuiz(
      scope: const QuizSetupArgs.lecture(
        lectureId: 'anatomy-l2',
        scopeName: 'المحاضرة الثانية',
        quizType: QuizType.normal,
      ),
      length: length,
    );
  }
}

/// The mapped [AppException] behind a rejected mock call - the harness runs the
/// REAL ErrorInterceptor, so this is the type a screen would receive.
Future<AppException> _rejection(Future<Object?> call) async {
  try {
    await call;
  } on DioException catch (e) {
    return e.error! as AppException;
  }
  fail('expected the mock to reject this request');
}

/// The raw `ProblemDetails` body of a rejected call, for asserting that two
/// refusals are byte-identical rather than merely share a code.
Future<Map<String, dynamic>> _problemBody(
  Future<Object?> Function() call,
) async {
  try {
    await call();
  } on DioException catch (e) {
    return Map<String, dynamic>.from(e.response!.data! as Map);
  }
  fail('expected the mock to reject this request');
}

Matcher _apiError(int status, String code) => isA<ApiException>()
    .having((e) => e.status, 'status', status)
    .having((e) => e.code, 'code', code);

Matcher _invalidFields(List<String> fields) => isA<ValidationException>()
    .having((e) => e.status, 'status', 400)
    .having((e) => e.fields, 'fields', orderedEquals(fields));

/// The same cursor, pointing at [offset] instead. Leans on the mock's cursor
/// being `<scope>:<offset>` in base64url, which its own doc states.
String _withOffset(String cursor, int offset) {
  final scope = utf8.decode(base64Url.decode(cursor)).split(':').first;
  return base64Url.encode(utf8.encode('$scope:$offset'));
}
