import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/quiz/models/quiz_history_item.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_question.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_page.dart';

import '../../guards/rules.dart';
import 'quiz_history_contract.dart';

/// `QuizHistoryItem` (`listQuizHistory`) and `QuizReview` (`getQuizReview`),
/// decoded from payloads shaped from `contract/openapi.yaml` (pin 3.46.0-m1):
/// every key below appears in the schema and every required key is present.
void main() {
  Map<String, dynamic> historyJson({
    String subjectName = 'Physics',
    String mode = 'normal',
    int score = 3,
    int totalQuestions = 5,
  }) => <String, dynamic>{
    'id': '6a000000-0000-4000-8000-0000000003e7',
    'subjectName': subjectName,
    'scopeName': 'Lesson 2',
    'mode': mode,
    'score': score,
    'totalQuestions': totalQuestions,
    'finishedAt': '2026-10-09T10:25:00Z',
  };

  group('QuizHistoryItem', () {
    test('decodes every required field', () {
      final item = QuizHistoryItem.fromJson(historyJson());

      expect(item.id, '6a000000-0000-4000-8000-0000000003e7');
      expect(item.subjectName, 'Physics');
      expect(item.scopeName, 'Lesson 2');
      expect(item.mode, QuizMode.normal);
      expect(item.score, 3);
      expect(item.totalQuestions, 5);
      expect(item.finishedAt, DateTime.utc(2026, 10, 9, 10, 25));
      expect(item.finishedAt.isUtc, isTrue);
    });

    test('all three contract modes decode to the shared QuizMode enum', () {
      for (final mode in QuizMode.values) {
        expect(
          QuizHistoryItem.fromJson(historyJson(mode: mode.name)).mode,
          mode,
        );
      }
    });

    test('an unknown mode is contract drift and throws, not coerced', () {
      expect(
        () => QuizHistoryItem.fromJson(historyJson(mode: 'speedrun')),
        throwsArgumentError,
      );
    });

    test('an empty subjectName is kept as empty and means "no subject"', () {
      // retakeWrong / favorites quizzes span subjects, and a subject that can
      // no longer be resolved reads the same: `''`, not null and not absent.
      final item = QuizHistoryItem.fromJson(
        historyJson(subjectName: '', mode: 'favorites'),
      );

      expect(item.subjectName, '');
      expect(item.hasSubject, isFalse);
      expect(
        QuizHistoryItem.fromJson(historyJson()).hasSubject,
        isTrue,
        reason: 'a named subject',
      );
    });

    test('score and totalQuestions are the frozen values, untouched', () {
      // No clamping, no recount: a review may hold fewer questions than this.
      final item = QuizHistoryItem.fromJson(
        historyJson(score: 7, totalQuestions: 4),
      );

      expect(item.score, 7);
      expect(item.totalQuestions, 4);
    });

    test('every contract-required key is required', () {
      for (final key in historyJson().keys) {
        final json = historyJson()..remove(key);
        expect(
          () => QuizHistoryItem.fromJson(json),
          throwsA(anything),
          reason: 'removing `$key`',
        );
      }
    });

    test('a key this app predates is ignored, not an error', () {
      final item = QuizHistoryItem.fromJson(
        historyJson()..['somethingAddedLater'] = true,
      );

      expect(item.id, isNotEmpty);
    });

    test('round-trips through jsonEncode', () {
      final item = QuizHistoryItem.fromJson(historyJson());

      expect(
        QuizHistoryItem.fromJson(
          jsonDecode(jsonEncode(item)) as Map<String, dynamic>,
        ),
        item,
      );
    });
  });

  // -------------------------------------------------------------------------

  Map<String, dynamic> optionJson(String question, int i) => <String, dynamic>{
    'id': '$question-opt$i',
    'text': 'Option $i',
  };

  /// A review question: the `QuizQuestion` keys plus the four review keys.
  /// [pick] is the option index the student chose (null = unanswered) and
  /// [correctIndex] the right one; the server only reveals the right one for a
  /// question that was answered.
  Map<String, dynamic> reviewQuestionJson(
    String id, {
    int order = 1,
    int? pick,
    int correctIndex = 0,
    bool explanationAvailable = true,
    bool isFavorite = false,
    String? imageUrl,
  }) {
    final answered = pick != null;
    return <String, dynamic>{
      'id': id,
      'order': order,
      'text': 'Question $id?',
      'imageUrl': imageUrl,
      'thumbnailUrl': null,
      'options': [for (var i = 0; i < 4; i++) optionJson(id, i)],
      'isFavorite': isFavorite,
      'selectedOptionId': answered ? '$id-opt$pick' : null,
      'correctOptionId': answered ? '$id-opt$correctIndex' : null,
      'correct': answered ? pick == correctIndex : null,
      'explanationAvailable': answered && explanationAvailable,
    };
  }

  Map<String, dynamic> reviewJson({
    String? subjectName = 'Physics',
    List<Map<String, dynamic>>? questions,
    int score = 1,
    int totalQuestions = 3,
  }) => <String, dynamic>{
    'id': '6a000000-0000-4000-8000-0000000003e7',
    'subjectName': subjectName,
    'scopeName': 'Lesson 2',
    'score': score,
    'totalQuestions': totalQuestions,
    'finishedAt': '2026-10-09T10:25:00Z',
    'questions':
        questions ??
        [
          reviewQuestionJson('q1', order: 1, pick: 0, correctIndex: 0),
          reviewQuestionJson('q2', order: 2, pick: 1, correctIndex: 3),
          reviewQuestionJson('q3', order: 3),
        ],
  };

  group('QuizReview', () {
    test('decodes the envelope', () {
      final review = QuizReview.fromJson(reviewJson());

      expect(review.id, '6a000000-0000-4000-8000-0000000003e7');
      expect(review.subjectName, 'Physics');
      expect(review.scopeName, 'Lesson 2');
      expect(review.score, 1);
      expect(review.totalQuestions, 3);
      expect(review.finishedAt, DateTime.utc(2026, 10, 9, 10, 25));
      expect(review.questions, hasLength(3));
    });

    test('subjectName is null for a pooled quiz or a vanished subject', () {
      // Required but nullable: the key is present with a null value. The
      // history spells the same situation `''`.
      final review = QuizReview.fromJson(reviewJson(subjectName: null));

      expect(review.subjectName, isNull);
    });

    test('the question half decodes exactly as the taking screen\'s model', () {
      final json = reviewQuestionJson(
        'q1',
        order: 4,
        pick: 2,
        correctIndex: 2,
        isFavorite: true,
        imageUrl: 'https://cdn.example/q1.webp',
      );

      final q = QuizReviewQuestion.fromJson(json);

      // Same JSON object, same QuizQuestion: nothing re-modelled.
      expect(q.question, QuizQuestion.fromJson(json));
      expect(q.question.id, 'q1');
      expect(q.question.order, 4);
      expect(q.question.options, hasLength(4));
      expect(q.question.isFavorite, isTrue);
      expect(q.question.imageUrl, 'https://cdn.example/q1.webp');
    });

    test('an answered question carries the pick, the key and the verdict', () {
      final q = QuizReviewQuestion.fromJson(
        reviewQuestionJson('q1', pick: 1, correctIndex: 3),
      );

      expect(q.selectedOptionId, 'q1-opt1');
      expect(q.correctOptionId, 'q1-opt3');
      expect(q.correct, isFalse);
      expect(q.explanationAvailable, isTrue);
    });

    test('an unanswered question reveals NOTHING', () {
      // adr-178 D1: the correct answer is withheld unless it was answered.
      final q = QuizReviewQuestion.fromJson(reviewQuestionJson('q3'));

      expect(q.selectedOptionId, isNull);
      expect(q.correctOptionId, isNull);
      expect(q.correct, isNull);
      expect(q.explanationAvailable, isFalse);
    });

    test('selectedOptionId and correct are contract-optional: absent reads '
        'as unanswered', () {
      final json = reviewQuestionJson('q3')
        ..remove('selectedOptionId')
        ..remove('correct');

      final q = QuizReviewQuestion.fromJson(json);

      expect(q.selectedOptionId, isNull);
      expect(q.correct, isNull);
      expect(q.isAnswered, isFalse);
    });

    test('an unanswered question is never wrong; it is only under "all"', () {
      // The contract's own client-side filter: "wrong" means answered AND
      // incorrect (`selectedOptionId != null && correct == false`).
      final right = QuizReviewQuestion.fromJson(
        reviewQuestionJson('a', pick: 0, correctIndex: 0),
      );
      final wrong = QuizReviewQuestion.fromJson(
        reviewQuestionJson('b', pick: 1, correctIndex: 0),
      );
      final skipped = QuizReviewQuestion.fromJson(reviewQuestionJson('c'));

      expect(
        [right.isAnswered, wrong.isAnswered, skipped.isAnswered],
        [true, true, false],
      );
      expect(
        [right.isCorrect, wrong.isCorrect, skipped.isCorrect],
        [true, false, false],
      );
      expect(
        [right.isWrong, wrong.isWrong, skipped.isWrong],
        [false, true, false],
      );
    });

    test('correct is the verdict recorded at submit time, never recomputed '
        'from the option ids', () {
      // The contract: `correctOptionId` is the CURRENT correct option while
      // `correct` is the verdict recorded when the answer was submitted, "never
      // recomputed". A question edited after the answer makes them disagree.
      // Case 1: the student's pick IS the current key, the recorded verdict is
      // still "wrong" (the key was edited TO their pick after they answered).
      final pickIsKeyButWrong = reviewQuestionJson(
        'a',
        pick: 2,
        correctIndex: 2,
      )..['correct'] = false;
      // Case 2: the pick is NOT the current key, the recorded verdict is still
      // "right" (the key was edited AWAY from their pick).
      final pickIsNotKeyButRight = reviewQuestionJson(
        'b',
        pick: 1,
        correctIndex: 3,
      )..['correct'] = true;

      final a = QuizReviewQuestion.fromJson(pickIsKeyButWrong);
      final b = QuizReviewQuestion.fromJson(pickIsNotKeyButRight);

      // Case 1: ids agree, verdict says wrong.
      expect(a.selectedOptionId, a.correctOptionId);
      expect(a.correct, isFalse);
      expect(a.isCorrect, isFalse);
      expect(a.isWrong, isTrue);
      // Case 2: ids disagree, verdict says right.
      expect(b.selectedOptionId, isNot(b.correctOptionId));
      expect(b.correct, isTrue);
      expect(b.isCorrect, isTrue);
      expect(b.isWrong, isFalse);
    });

    test('the recorded verdict also decides the "wrong" filter and survives '
        'the round trip', () {
      final review = QuizReview.fromJson(
        reviewJson(
          questions: [
            reviewQuestionJson('a', order: 1, pick: 2, correctIndex: 2)
              ..['correct'] = false,
            reviewQuestionJson('b', order: 2, pick: 1, correctIndex: 3)
              ..['correct'] = true,
            reviewQuestionJson('c', order: 3, pick: 0, correctIndex: 1),
            reviewQuestionJson('d', order: 4),
          ],
          totalQuestions: 4,
        ),
      );

      // Wrong = answered and recorded incorrect: a (ids agree) and c (ids
      // disagree, recorded false). b is right despite the ids; d is skipped.
      expect(
        review.questions.where((q) => q.isWrong).map((q) => q.question.id),
        ['a', 'c'],
      );
      expect(
        review.questions.where((q) => q.isCorrect).map((q) => q.question.id),
        ['b'],
      );

      final wire = jsonDecode(jsonEncode(review)) as Map<String, dynamic>;
      final back = QuizReview.fromJson(wire);
      expect(back, review);
      final questions = (wire['questions'] as List)
          .cast<Map<String, dynamic>>();
      expect(questions[0]['correct'], isFalse);
      expect(questions[1]['correct'], isTrue);
    });

    test('a review with fewer questions than totalQuestions keeps both', () {
      // A question whose content no longer exists is omitted from `questions`;
      // `score` and `totalQuestions` keep the values frozen at finish.
      final review = QuizReview.fromJson(
        reviewJson(
          questions: [reviewQuestionJson('q1', pick: 0)],
          score: 2,
          totalQuestions: 3,
        ),
      );

      expect(review.questions, hasLength(1));
      expect(review.score, 2);
      expect(review.totalQuestions, 3);
    });

    test('an empty questions list is legal', () {
      final review = QuizReview.fromJson(reviewJson(questions: const []));

      expect(review.questions, isEmpty);
    });

    test('order is carried, not re-sorted', () {
      final review = QuizReview.fromJson(
        reviewJson(
          questions: [
            reviewQuestionJson('late', order: 9),
            reviewQuestionJson('early', order: 1),
          ],
        ),
      );

      expect(review.questions.map((q) => q.question.id), ['late', 'early']);
    });

    test('every contract-required envelope key is required', () {
      for (final key in reviewJson().keys) {
        // `subjectName` is required but NULLABLE: removing the key reads as the
        // same null the server sends, so it is the one key allowed to survive.
        if (key == 'subjectName') continue;
        final json = reviewJson()..remove(key);
        expect(
          () => QuizReview.fromJson(json),
          throwsA(anything),
          reason: 'removing `$key`',
        );
      }
    });

    test('a question missing explanationAvailable throws', () {
      final q = reviewQuestionJson('q1', pick: 0)
        ..remove('explanationAvailable');

      expect(() => QuizReviewQuestion.fromJson(q), throwsA(anything));
    });

    test('a question missing the correctOptionId KEY throws; a null VALUE '
        'does not', () {
      // Required but nullable. A null value is the normal "unanswered, answer
      // withheld" case; a missing key would read as the same null and hide the
      // correct answer of an answered question without a signal, so it is
      // drift. Both the answered and the unanswered question must carry it.
      for (final pick in <int?>[1, null]) {
        final q = reviewQuestionJson('q1', pick: pick, correctIndex: 3)
          ..remove('correctOptionId');
        expect(
          () => QuizReviewQuestion.fromJson(q),
          throwsA(isA<FormatException>()),
          reason: pick == null ? 'unanswered' : 'answered',
        );
      }

      final withheld = QuizReviewQuestion.fromJson(reviewQuestionJson('q3'));
      expect(withheld.correctOptionId, isNull);
    });

    test('a review whose question drops correctOptionId fails as a whole', () {
      final json = reviewJson(
        questions: [
          reviewQuestionJson('q1', pick: 0),
          reviewQuestionJson('q2', order: 2, pick: 1)
            ..remove('correctOptionId'),
        ],
      );

      expect(() => QuizReview.fromJson(json), throwsA(anything));
    });

    test('every key of the contract\'s review-only required list is required '
        'on a question', () {
      // `required: [correctOptionId, explanationAvailable]` in the allOf.
      for (final key in ['correctOptionId', 'explanationAvailable']) {
        final q = reviewQuestionJson('q1', pick: 0)..remove(key);
        expect(
          () => QuizReviewQuestion.fromJson(q),
          throwsA(anything),
          reason: 'removing `$key`',
        );
      }
    });

    test('a question missing a QuizQuestion field throws', () {
      for (final key in ['id', 'order', 'text', 'options', 'isFavorite']) {
        final q = reviewQuestionJson('q1', pick: 0)..remove(key);
        expect(
          () => QuizReviewQuestion.fromJson(q),
          throwsA(anything),
          reason: 'removing `$key`',
        );
      }
    });

    test('round-trips through jsonEncode, review keys included', () {
      final review = QuizReview.fromJson(reviewJson());

      final wire = jsonDecode(jsonEncode(review)) as Map<String, dynamic>;
      final back = QuizReview.fromJson(wire);

      expect(back, review);
      // The question objects stay FLAT on the wire, as the contract has them.
      final first = (wire['questions'] as List).first as Map<String, dynamic>;
      expect(first['id'], 'q1');
      expect(first['selectedOptionId'], 'q1-opt0');
      expect(first.containsKey('question'), isFalse);
    });
  });

  // -------------------------------------------------------------------------

  group('agreement with the pinned contract', () {
    // The field lists are READ from contract/openapi.yaml at run time, never
    // hardcoded here: re-vendor a contract that adds a required field to one of
    // these shapes and this fails until the model catches up.
    late String yaml;

    setUpAll(() {
      yaml = File('contract/openapi.yaml').readAsStringSync();
    });

    /// The components-level schemas, checked with the SAME helpers and the same
    /// class scoping as `test/guards/contract_models_test.dart` - the two rows
    /// that file should gain (see the integration request) would pass today.
    void expectComponentModelled(String schema, String dart, String cls) {
      final required = contractRequiredFields(yaml, [schema]);
      final body = dartClassBody(File(dart).readAsStringSync(), cls);
      expect(body, isNotNull, reason: '$dart declares no class $cls');
      expect([
        for (final f in required)
          if (!dartDeclaresField(body!, f)) f,
      ], isEmpty);
    }

    test('QuizHistoryItem takes every required field', () {
      expectComponentModelled(
        'QuizHistoryItem',
        'lib/features/quiz/models/quiz_history_item.dart',
        'QuizHistoryItem',
      );
    });

    test('QuizReview takes every required field', () {
      expectComponentModelled(
        'QuizReview',
        'lib/features/quiz/models/quiz_review_page.dart',
        'QuizReview',
      );
    });

    // The review-only half of QuizReview.questions[] sits in an `allOf` list,
    // which the guard's key-path navigator cannot enter.
    const reviewQuestionAnchor = '\n    QuizReview:\n';

    test('the review-only half of QuizReview.questions[] is modelled', () {
      // Canary: the anchor lands on the allOf extension's own list, not on the
      // envelope's.
      expect(
        requiredAfter(yaml, reviewQuestionAnchor),
        contains('explanationAvailable'),
      );
      expect(
        unmodelledFields(
          anchor: reviewQuestionAnchor,
          dartFile: 'lib/features/quiz/models/quiz_review_page.dart',
          className: 'QuizReviewQuestion',
        ),
        isEmpty,
      );
    });

    test('the check can fail: an invented required field is reported', () {
      final doctored = yaml.replaceFirst(
        'required: [correctOptionId, explanationAvailable]',
        'required: [inventedField, correctOptionId, explanationAvailable]',
      );
      expect(doctored, isNot(yaml), reason: 'the doctoring found its target');

      expect(
        unmodelledFields(
          anchor: reviewQuestionAnchor,
          dartFile: 'lib/features/quiz/models/quiz_review_page.dart',
          className: 'QuizReviewQuestion',
          yaml: doctored,
        ),
        ['inventedField'],
      );
    });
  });
}
