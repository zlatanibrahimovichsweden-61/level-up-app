import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/quiz/models/answer_result.dart';
import 'package:level_up_app/features/quiz/models/quiz.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_question.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';

import 'quiz_fixtures.dart';

/// Every assertion below traces to a line in `contract/openapi.yaml`. The point
/// is not that the generated code works — it is that the SHAPES match the
/// contract, so a drift shows up here rather than on a student's screen.
void main() {
  group('Quiz', () {
    test('parses a school quiz — no quizType at all', () {
      final parsed = Quiz.fromJson(quizJson());

      expect(parsed.id, 'quiz-1');
      expect(parsed.mode, QuizMode.normal);
      expect(parsed.quizType, isNull);
      expect(parsed.scopeName, 'Cell Structure');
      expect(parsed.questions, hasLength(3));
      expect(parsed.createdAt, DateTime.utc(2026, 7, 30, 9));
    });

    test('parses a university quiz — quizType maps by member name', () {
      final parsed = Quiz.fromJson(quizJson(quizType: 'midTermRevision'));

      expect(parsed.quizType, QuizType.midTermRevision);
    });

    test(
      'questionCount reads the questions DELIVERED, not the length asked for',
      () {
        // A short pool is contract-legal: `POST /quizzes` may return fewer than
        // `length`. The counter must say 7, never 10.
        expect(Quiz.fromJson(quizJson(questionCount: 7)).questionCount, 7);
      },
    );

    test('a missing required field throws rather than defaulting', () {
      final json = quizJson()..remove('scopeName');

      expect(() => Quiz.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('all three contract modes parse', () {
      for (final (wire, mode) in const [
        ('normal', QuizMode.normal),
        ('retakeWrong', QuizMode.retakeWrong),
        ('favorites', QuizMode.favorites),
      ]) {
        expect(Quiz.fromJson(quizJson(mode: wire)).mode, mode);
      }
    });

    test('round-trips through encode/decode', () {
      final parsed = Quiz.fromJson(quizJson());
      // Through jsonEncode, not raw toJson: the project generates with
      // `explicitToJson: false` (see subject_tree.g.dart), so toJson leaves
      // nested models as objects and jsonEncode is what resolves them. That is
      // the actual serialization path, so it is the one worth asserting.
      final again = Quiz.fromJson(
        jsonDecode(jsonEncode(parsed.toJson())) as Map<String, dynamic>,
      );

      expect(again, parsed);
    });
  });

  group('QuizQuestion', () {
    test('parses isFavorite — required, so the model must carry it', () {
      final parsed = QuizQuestion.fromJson(
        questionJson('q1', isFavorite: true),
      );

      expect(parsed.isFavorite, isTrue);
    });

    test('imageUrl is null on a text-only question', () {
      expect(QuizQuestion.fromJson(questionJson('q1')).imageUrl, isNull);
    });

    test('imageUrl parses when present — the "with photo" variant', () {
      final parsed = QuizQuestion.fromJson(
        questionJson('q1', imageUrl: 'https://cdn.example/q1.webp'),
      );

      expect(parsed.imageUrl, 'https://cdn.example/q1.webp');
    });

    test(
      'carries NO correctness — the contract never ships it with questions',
      () {
        final json = questionJson('q1');
        final options = json['options']! as List<dynamic>;

        for (final option in options.cast<Map<String, dynamic>>()) {
          expect(option.keys, unorderedEquals(<String>['id', 'text']));
        }
      },
    );

    test('minItems is 2, not 4 — a three-option question parses', () {
      final parsed = QuizQuestion.fromJson(questionJson('q1', optionCount: 3));

      expect(parsed.options, hasLength(3));
    });
  });

  group('AnswerResult', () {
    test('parses the graded response', () {
      final parsed = AnswerResult.fromJson(answerResultJson());

      expect(parsed.correct, isTrue);
      expect(parsed.correctOptionId, 'q1-opt0');
      expect(parsed.pointsDelta, 1);
      expect(parsed.explanationAvailable, isTrue);
    });

    test('a wrong answer still reveals correctOptionId', () {
      final parsed = AnswerResult.fromJson(
        answerResultJson(correct: false, pointsDelta: 0),
      );

      expect(parsed.correct, isFalse);
      expect(parsed.correctOptionId, 'q1-opt0');
      expect(parsed.pointsDelta, 0);
    });

    test('pointsDelta of 0 on a replay parses as 0, not as absent', () {
      expect(
        AnswerResult.fromJson(answerResultJson(pointsDelta: 0)).pointsDelta,
        0,
      );
    });
  });

  group('QuizSummary', () {
    test('parses every required field, newBadge and recap rows included', () {
      final parsed = QuizSummary.fromJson(quizSummaryJson());

      expect(parsed.quizId, 'quiz-1');
      expect(parsed.score, 5);
      expect(parsed.totalQuestions, 10);
      expect(parsed.answeredCount, 8);
      expect(parsed.pointsAwarded, 5);
      expect(parsed.leveledUp, isFalse);
      expect(parsed.newBadge, isFalse);
      expect(parsed.questions, hasLength(10));
    });

    // 3.0.0-m1 (adr-102) removed `totalPoints` and `level`. A server still on
    // the 2.x shape sends them anyway; json_serializable ignores unknown keys,
    // so the client must not break in either direction.
    test(
      'a 2.x body still carrying totalPoints and level parses unchanged',
      () {
        final stale = quizSummaryJson()
          ..['totalPoints'] = 1255
          ..['level'] = 3;

        final parsed = QuizSummary.fromJson(stale);

        expect(parsed.pointsAwarded, 5);
        expect(parsed.leveledUp, isFalse);
        expect(parsed.toJson().containsKey('totalPoints'), isFalse);
        expect(parsed.toJson().containsKey('level'), isFalse);
      },
    );

    test('recap rows carry a null `correct` for unanswered questions', () {
      final parsed = QuizSummary.fromJson(quizSummaryJson());

      expect(parsed.questions[7].answered, isTrue); // q8 — the last answered
      expect(parsed.questions[8].answered, isFalse); // q9 — skipped
      expect(parsed.questions[8].correct, isNull);
    });

    // The bug this whole model exists to prevent.
    test('wrong is answeredCount - score, NOT totalQuestions - score', () {
      final parsed = QuizSummary.fromJson(quizSummaryJson());

      expect(parsed.wrong, 3); // 8 answered - 5 correct
      expect(parsed.wrong, isNot(5)); // what totalQuestions - score would say
      expect(parsed.skipped, 2); // 10 total - 8 answered
      // The three buckets account for every question, which is the whole point.
      expect(parsed.score + parsed.wrong + parsed.skipped, 10);
    });

    test('a fully-answered quiz has nothing skipped', () {
      final parsed = QuizSummary.fromJson(
        quizSummaryJson(score: 7, totalQuestions: 10, answeredCount: 10),
      );

      expect(parsed.wrong, 3);
      expect(parsed.skipped, 0);
    });

    test('a quiz answered perfectly but abandoned early', () {
      final parsed = QuizSummary.fromJson(
        quizSummaryJson(score: 4, totalQuestions: 10, answeredCount: 4),
      );

      expect(parsed.wrong, 0);
      expect(parsed.skipped, 6);
    });

    test('fraction is the ring, clamped, and never divides by zero', () {
      expect(QuizSummary.fromJson(quizSummaryJson()).fraction, 0.5);
      expect(
        QuizSummary.fromJson(
          quizSummaryJson(score: 0, totalQuestions: 0, answeredCount: 0),
        ).fraction,
        0,
      );
    });

    test('server drift cannot render a negative bucket', () {
      // score > answeredCount is impossible per the contract; if it ever
      // arrives, a 0 beats a "-2 wrong" on screen.
      final parsed = QuizSummary.fromJson(
        quizSummaryJson(score: 6, totalQuestions: 10, answeredCount: 4),
      );

      expect(parsed.wrong, 0);
    });

    test('round-trips through encode/decode', () {
      final parsed = QuizSummary.fromJson(quizSummaryJson());

      expect(
        QuizSummary.fromJson(
          jsonDecode(jsonEncode(parsed.toJson())) as Map<String, dynamic>,
        ),
        parsed,
      );
    });
  });

  group('QuizMode / QuizLength', () {
    test('carries all three contract values', () {
      expect(QuizMode.values, [
        QuizMode.normal,
        QuizMode.retakeWrong,
        QuizMode.favorites,
      ]);
    });

    test('but only normal is OFFERED today', () {
      expect(offeredQuizModes, [QuizMode.normal]);
    });

    test('length is exactly the contract enum 10/30/50', () {
      expect(QuizLength.values.map((l) => l.value), [10, 30, 50]);
      expect(defaultQuizLength, QuizLength.thirty);
    });
  });
}
