import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/quiz/models/answer_result.dart';
import 'package:level_up_app/features/quiz/models/explanation_result.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';

/// The harness must answer all four quiz endpoints in shapes the REAL models
/// parse, and must reach every error path — otherwise the quiz cannot be walked
/// on a device, which is the entire reason it exists (`AppConfig.baseUrl` is
/// still TBD).
///
/// Driven through the real [QuizRepository] wherever possible, so this also
/// proves the request bodies the app builds are the ones the mock understands.
void main() {
  /// The mock's school lesson ids come from the catalog: `bio-u1-c1-l1` has a
  /// 40-question pool, which is why a 30-question quiz fits and 50 does not.
  const bigLesson = QuizSetupArgs.lesson(
    lessonId: 'bio-u1-c1-l1',
    scopeName: 'الدرس الأول',
  );

  /// `bio-u2-c1-l2` is the `0 / 0` lesson — an empty pool at any length.
  const emptyLesson = QuizSetupArgs.lesson(
    lessonId: 'bio-u2-c1-l2',
    scopeName: 'الدرس الثاني',
  );

  QuizRepository repo() => QuizRepository(buildMockDio(latency: Duration.zero));

  group('POST /quizzes', () {
    test('parses into a Quiz with the requested number of questions', () async {
      final quiz = await repo().createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );

      expect(quiz.id, isNotEmpty);
      expect(quiz.mode, QuizMode.normal);
      expect(quiz.questions, hasLength(10));
      // Titled with the lesson name the student tapped, not an id.
      expect(quiz.scopeName, 'الدرس الأول');
    });

    test('questions ship WITHOUT correct answers', () async {
      final dio = buildMockDio(latency: Duration.zero);
      final res = await dio.post<Map<String, dynamic>>(
        '/quizzes',
        data: <String, dynamic>{
          'mode': 'normal',
          'length': 10,
          'lessonId': 'bio-u1-c1-l1',
        },
      );

      final questions = res.data!['questions']! as List<dynamic>;
      for (final question in questions.cast<Map<String, dynamic>>()) {
        expect(question.containsKey('correctOptionId'), isFalse);
        for (final option
            in (question['options']! as List<dynamic>)
                .cast<Map<String, dynamic>>()) {
          expect(option.keys, unorderedEquals(<String>['id', 'text']));
        }
      }
    });

    test('a photo question is reachable — the 159:1852 variant', () async {
      final quiz = await repo().createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );

      expect(quiz.questions.any((q) => q.imageUrl != null), isTrue);
    });

    test('422 not_enough_questions on an empty pool', () async {
      expect(
        () => repo().createQuiz(scope: emptyLesson, length: QuizLength.ten),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 422)
              .having((e) => e.code, 'code', 'not_enough_questions'),
        ),
      );
    });

    test('422 when the length exceeds a non-empty pool', () async {
      // 40 questions in `bio-u1-c1-l1`; 50 does not fit.
      expect(
        () => repo().createQuiz(scope: bigLesson, length: QuizLength.fifty),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'not_enough_questions',
          ),
        ),
      );
    });

    test('403 subscription_required on a paid scope', () async {
      expect(
        () => repo().createQuiz(
          scope: const QuizSetupArgs.lesson(
            lessonId: 'chem-u1-c1-l1',
            scopeName: 'الدرس الأول',
          ),
          length: QuizLength.ten,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 403)
              .having((e) => e.code, 'code', 'subscription_required'),
        ),
      );
    });

    test(
      '403 weekly_question_limit_reached once 50 questions are used',
      () async {
        final quiz = repo();

        // 30 + 30 > 50: the second quiz trips the free-plan cap.
        await quiz.createQuiz(scope: bigLesson, length: QuizLength.thirty);

        expect(
          () => quiz.createQuiz(scope: bigLesson, length: QuizLength.thirty),
          throwsA(
            isA<ApiException>()
                .having((e) => e.status, 'status', 403)
                .having((e) => e.code, 'code', 'weekly_question_limit_reached'),
          ),
        );
      },
    );
  });

  group('POST /quizzes/{quizId}/answers', () {
    test('grades, and reveals correctOptionId only now', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );
      final question = created.questions.first;

      final result = await quiz.submitAnswer(
        quizId: created.id,
        questionId: question.id,
        optionId: question.options.first.id,
      );

      expect(result, isA<AnswerResult>());
      expect(result.correctOptionId, isNotEmpty);
      expect(
        result.correct,
        result.correctOptionId == question.options.first.id,
      );
      expect(result.pointsDelta, result.correct ? 1 : 0);
    });

    test('a replay returns the ORIGINAL grade and awards nothing', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );
      final question = created.questions.first;
      // Pick the option the mock marked correct, so the first call awards 1 and
      // the replay's zero is unambiguous.
      final first = await quiz.submitAnswer(
        quizId: created.id,
        questionId: question.id,
        optionId: question.options.first.id,
      );

      final replay = await quiz.submitAnswer(
        quizId: created.id,
        questionId: question.id,
        optionId: question.options.first.id,
      );

      expect(replay.correct, first.correct);
      expect(replay.correctOptionId, first.correctOptionId);
      // Never double-awarded — the contract's own wording for the field is
      // "0 on retry replay".
      expect(replay.pointsDelta, 0);
    });

    test('a replay with a DIFFERENT option does not re-grade', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );
      final question = created.questions.first;

      final first = await quiz.submitAnswer(
        quizId: created.id,
        questionId: question.id,
        optionId: question.options[0].id,
      );
      final second = await quiz.submitAnswer(
        quizId: created.id,
        questionId: question.id,
        optionId: question.options[3].id,
      );

      expect(second.correct, first.correct);
    });

    test('409 quiz_already_finished after finish', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );
      await quiz.finishQuiz(created.id);

      expect(
        () => quiz.submitAnswer(
          quizId: created.id,
          questionId: created.questions.first.id,
          optionId: created.questions.first.options.first.id,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 409)
              .having((e) => e.code, 'code', 'quiz_already_finished'),
        ),
      );
    });
  });

  group('POST /quizzes/{quizId}/finish', () {
    test('summarises a PARTIALLY answered quiz truthfully', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );

      // Answer 6 of 10, leaving 4 untouched.
      for (final question in created.questions.take(6)) {
        await quiz.submitAnswer(
          quizId: created.id,
          questionId: question.id,
          optionId: question.options.first.id,
        );
      }

      final summary = await quiz.finishQuiz(created.id);

      expect(summary, isA<QuizSummary>());
      expect(summary.totalQuestions, 10);
      expect(summary.answeredCount, 6);
      expect(summary.skipped, 4);
      expect(summary.wrong, 6 - summary.score);
      expect(summary.pointsAwarded, summary.score);
      // Recap rows carry a null `correct` for everything unanswered.
      expect(summary.questions.where((q) => !q.answered), hasLength(4));
      expect(
        summary.questions
            .where((q) => !q.answered)
            .every((q) => q.correct == null),
        isTrue,
      );
    });

    test('is idempotent — a repeat call replays the same summary', () async {
      final dio = buildMockDio(latency: Duration.zero);
      final quiz = QuizRepository(dio);
      Future<Object?> liveTotal() async =>
          ((await dio.get<Map<String, dynamic>>('/me')).data!['points']
              as Map<String, dynamic>)['total'];

      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );
      await quiz.submitAnswer(
        quizId: created.id,
        questionId: created.questions.first.id,
        optionId: created.questions.first.options.first.id,
      );

      final first = await quiz.finishQuiz(created.id);
      final totalAfterFirst = await liveTotal();
      final second = await quiz.finishQuiz(created.id);

      expect(second, first);
      // Critically: the live total did not move a second time. It lives on
      // GET /me — the summary no longer carries it (3.0.0-m1, adr-102).
      expect(await liveTotal(), totalAfterFirst);
    });

    test(
      'the award reaches GET /me — what invalidating the profile shows',
      () async {
        final dio = buildMockDio(latency: Duration.zero);
        final quiz = QuizRepository(dio);

        final before =
            (await dio.get<Map<String, dynamic>>('/me')).data!['points']
                as Map<String, dynamic>;

        final created = await quiz.createQuiz(
          scope: bigLesson,
          length: QuizLength.ten,
        );
        for (final question in created.questions) {
          await quiz.submitAnswer(
            quizId: created.id,
            questionId: question.id,
            optionId: question.options.first.id,
          );
        }
        final summary = await quiz.finishQuiz(created.id);

        final after =
            (await dio.get<Map<String, dynamic>>('/me')).data!['points']
                as Map<String, dynamic>;

        expect(summary.pointsAwarded, greaterThan(0));
        expect(
          after['total'],
          (before['total']! as int) + summary.pointsAwarded,
        );
      },
    );
  });

  group('GET /questions/{questionId}/explanation', () {
    test('403 before the student has answered — expected, not a bug', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );

      expect(
        () => quiz.getExplanation(created.questions.first.id),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 403)
              .having((e) => e.code, 'code', 'insufficient_scope'),
        ),
      );
    });

    test('202 then 200 — the polling path is walkable', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );
      final question = created.questions.first;
      await quiz.submitAnswer(
        quizId: created.id,
        questionId: question.id,
        optionId: question.options.first.id,
      );

      final generating = await quiz.getExplanation(question.id);
      final ready = await quiz.getExplanation(question.id);

      expect(generating, isA<ExplanationGenerating>());
      expect(ready, isA<ExplanationReady>());
      expect((ready as ExplanationReady).text, isNotEmpty);
    });

    test('some questions report no explanation at all', () async {
      final quiz = repo();
      final created = await quiz.createQuiz(
        scope: bigLesson,
        length: QuizLength.ten,
      );

      final results = <bool>[];
      for (final question in created.questions) {
        final result = await quiz.submitAnswer(
          quizId: created.id,
          questionId: question.id,
          optionId: question.options.first.id,
        );
        results.add(result.explanationAvailable);
      }

      // Both branches of the app's "is the panel offered?" decision are
      // reachable in a single walk.
      expect(results, contains(true));
      expect(results, contains(false));
    });
  });

  test('both tracks reach the quiz endpoints (000000 / 111111)', () async {
    for (final (code, scope) in const [
      (
        '000000',
        QuizSetupArgs.lesson(lessonId: 'bio-u1-c1-l1', scopeName: 'x'),
      ),
      (
        '111111',
        QuizSetupArgs.lecture(
          lectureId: 'anatomy-l1',
          scopeName: 'x',
          quizType: QuizType.midTermRevision,
        ),
      ),
    ]) {
      final dio = buildMockDio(latency: Duration.zero);
      // The OTP code is what flips the mock session's track.
      await dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: <String, dynamic>{'code': code, 'phone': '+201001234567'},
      );

      final quiz = await QuizRepository(
        dio,
      ).createQuiz(scope: scope, length: QuizLength.ten);

      expect(quiz.questions, hasLength(10));
      expect(quiz.scopeName, isNotEmpty);
    }
  });
}
