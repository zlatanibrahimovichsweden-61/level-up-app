/// Throwaway on-device preview data for quiz history, the quiz review, the
/// favourites pool and the Solved Questions number - NOT production code.
///
/// Answers the six operations of the CW16 data layer - `GET /quizzes`, `GET
/// /quizzes/{quizId}`, `PUT`/`DELETE /questions/{questionId}/favorite`, `GET
/// /me/favorites` and `GET /me/quiz-summary` (`contract/openapi.yaml`, all
/// `x-stability: stable`). It is a standalone class: `lib/dev/mock_backend.dart`
/// owns the request plumbing and turns a [MockQuizHistoryReply] into a Dio
/// response, exactly as it does for `mock_support.dart`. Nothing in the app
/// consumes these operations yet, so nothing needs this mock to be wired in
/// today; it exists so the repository has a contract-shaped server to be driven
/// against, and so a screen built later can be walked with more than one page.
///
/// `GET /me/quiz-summary` lives here rather than in a file of its own because
/// the number is DERIVED from the quiz fixtures below (distinct questions
/// answered correctly in any quiz, finished or not), so the history, the
/// reviews and the summary cannot disagree.
///
/// **Everything below is MOCK SAMPLE DATA, not product copy.** The subject
/// names, question stems, options and scope labels are short invented samples;
/// the real ones are written by Content and arrive from the server. No student
/// name, phone number or e-mail appears anywhere.
///
/// The fixtures are NOT the mock backend's own quiz session: a quiz finished
/// through `POST /quizzes/{id}/finish` in that harness does not appear in this
/// history. Linking the two would mean editing the interceptor's quiz state.
///
/// Strict where the server is strict, per `mock_backend.dart`'s own rule:
/// - the list is the caller's FINISHED quizzes only, ordered by when each was
///   STARTED (newest first, the quiz id as tie-break) - not by `finishedAt`,
///   which is why two fixtures share a start instant;
/// - pages are 20 unless `limit` says otherwise; `limit` is VALIDATED, NOT
///   CLAMPED (outside 1..100 is `400 validation_failed` on field `limit`);
/// - `cursor` is opaque to the app; here it is a keyset in disguise (the last
///   row served). A token this mock did not issue, or one issued for the other
///   list, is `400 validation_failed` on field `cursor`;
/// - an unknown, malformed or foreign quiz id is `403 insufficient_scope`, and
///   the caller's own OPEN quiz is `403 quiz_not_finished` - there is no `404`;
/// - a review reveals `correctOptionId` only for a question the student
///   answered; `correct` is the verdict recorded at submit time; a question
///   whose content no longer exists is omitted while `score` and
///   `totalQuestions` keep their frozen values;
/// - `subjectName` is `''` in the history and `null` in the review for the two
///   pooled modes and for a subject that cannot be resolved;
/// - favouriting and unfavouriting are idempotent `204`s. The contract
///   documents no other outcome for them (not even an unknown question id), so
///   the mock answers `204` for any id and only a fixture question has a row to
///   list. A repeated `PUT` keeps the original `favoritedAt`;
/// - the favourites list order is NOT stated by the contract. The mock serves
///   most recently favourited first (ties by `questionId` descending); a screen
///   must not depend on it.
///
/// State is per [MockQuizHistory] instance, so favouriting persists for the
/// life of one mock session and a fresh session starts from the fixtures again.
library;

import 'dart:convert';

/// What the mock answers, in terms the interceptor maps onto its own `_ok`,
/// `_validationFailed` and `_problem` helpers.
sealed class MockQuizHistoryReply {
  const MockQuizHistoryReply();
}

/// A success: [status] (`200` or `204`) and the JSON body, or `null` for `204`.
final class MockQuizHistoryOk extends MockQuizHistoryReply {
  const MockQuizHistoryOk(this.status, this.data);

  final int status;
  final Object? data;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockQuizHistoryValidation extends MockQuizHistoryReply {
  const MockQuizHistoryValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// Any other ProblemDetails: `403 insufficient_scope`, `403 quiz_not_finished`.
final class MockQuizHistoryProblem extends MockQuizHistoryReply {
  const MockQuizHistoryProblem(this.status, this.code, this.detail);

  final int status;
  final String code;
  final String detail;
}

/// The id of finished-quiz fixture number [position] (1-based, 1 = the most
/// recently started). Exposed so a test can name a quiz without hard-coding a
/// UUID. The numbers COUNT DOWN with the position, so a newer quiz always has
/// the larger id - the order the server's tie-break (quiz id, descending)
/// resolves two quizzes started at the same instant into.
String mockHistoryQuizId(int position) =>
    '6a000000-0000-4000-8000-${(1000 - position).toRadixString(16).padLeft(12, '0')}';

/// The caller's own quiz that is NOT finished: absent from the history, a
/// `403 quiz_not_finished` as a review, and counted by the summary.
const kMockOpenQuizId = '6a000000-0000-4000-8000-0000000000ff';

/// The id of bank question number [number] (1-based, 1..[kMockQuestionCount]).
String mockHistoryQuestionId(int number) =>
    '6b000000-0000-4000-8000-${number.toRadixString(16).padLeft(12, '0')}';

/// The id of option [optionIndex] (0-based, 0..3) of bank question [number].
String mockHistoryOptionId(int number, int optionIndex) =>
    '6c000000-0000-4000-80${optionIndex.toString().padLeft(2, '0')}-'
    '${number.toRadixString(16).padLeft(12, '0')}';

/// How many finished quizzes the fixtures hold by default. More than a page of
/// 20, so the first page ends with `hasMore: true` and the second holds 6.
const kMockFinishedQuizCount = 26;

/// How many questions the bank holds: four subjects of six.
const kMockQuestionCount = 24;

/// How many questions are favourites by default: a page of 20 plus 2.
const kMockFavoriteCount = 22;

/// The fixture whose review omits its last question (the content is gone):
/// `totalQuestions` stays at the frozen value and `questions` is one shorter.
const kMockOmittedQuestionQuiz = 3;

/// The two fixtures that were started at the SAME instant, so the order between
/// them is the quiz-id tie-break and nothing else.
const kMockTieBreakQuizzes = [7, 8];

/// The normal-mode fixture whose subject can no longer be resolved:
/// `subjectName` is `''` in the history and `null` in the review.
const kMockUnresolvedSubjectQuiz = 11;

/// The bank's four subjects, by index. The last has no AI explanation, so an
/// answered question can still read `explanationAvailable: false`.
const _subjects = ['Physics', 'Biology', 'Chemistry', 'Mathematics'];
const _noExplanationSubject = 3;

/// One quiz-and-favourites desk per mock session. See the file header.
class MockQuizHistory {
  /// [finishedQuizzes] and [favorites] default to the full fixtures; a test (or
  /// a device run) can pass `0` to reach the empty states.
  MockQuizHistory({
    int finishedQuizzes = kMockFinishedQuizCount,
    int favorites = kMockFavoriteCount,
  }) : assert(finishedQuizzes >= 0 && finishedQuizzes <= 500),
       assert(favorites >= 0 && favorites <= kMockQuestionCount) {
    for (var position = 1; position <= finishedQuizzes; position++) {
      _quizzes.add(_buildFinishedQuiz(position));
    }
    _openQuiz = _buildOpenQuiz();
    for (var n = 1; n <= favorites; n++) {
      // Question 1 was favourited most recently; each later one an hour before.
      _favorites[mockHistoryQuestionId(n)] = _newestFavorite.subtract(
        Duration(hours: n - 1),
      );
    }
  }

  final _quizzes = <_MockQuiz>[];
  late final _MockQuiz _openQuiz;

  /// questionId -> when it was favourited.
  final _favorites = <String, DateTime>{};

  static const _pageSize = 20;
  static final _quizPath = RegExp(r'^/quizzes/([^/]+)$');
  static final _favoritePath = RegExp(r'^/questions/([^/]+)/favorite$');

  /// The reply for a quiz-history route, or `null` when [method] + [path] is
  /// not one of the six this mock serves (so the interceptor keeps looking -
  /// `POST /quizzes` and the other quiz-engine routes are not ours).
  MockQuizHistoryReply? handle(
    String method,
    String path,
    Map<String, dynamic> query,
  ) {
    if (method == 'GET') {
      if (path == '/quizzes') return _listHistory(query);
      if (path == '/me/favorites') return _listFavorites(query);
      if (path == '/me/quiz-summary') return _summary();
      final quiz = _quizPath.firstMatch(path);
      if (quiz != null) return _review(Uri.decodeComponent(quiz.group(1)!));
      return null;
    }
    final favorite = _favoritePath.firstMatch(path);
    if (favorite != null && (method == 'PUT' || method == 'DELETE')) {
      final id = Uri.decodeComponent(favorite.group(1)!);
      if (method == 'PUT') {
        _favorite(id);
      } else {
        _favorites.remove(id);
      }
      return const MockQuizHistoryOk(204, null);
    }
    return null;
  }

  // -------------------------------------------------------------------------
  // GET /quizzes
  // -------------------------------------------------------------------------

  MockQuizHistoryReply _listHistory(Map<String, dynamic> query) {
    final sorted = [..._quizzes]
      ..sort((a, b) {
        final byStart = b.startedAt.compareTo(a.startedAt);
        return byStart != 0 ? byStart : b.id.compareTo(a.id);
      });

    return _page<_MockQuiz, _HistoryCursor>(
      query,
      sorted: sorted,
      decode: _decodeHistoryCursor,
      encode: _encodeHistoryCursor,
      isAfter: (row, cursor) {
        final byStart = row.startedAt.compareTo(cursor.startedAt);
        return byStart != 0 ? byStart < 0 : row.id.compareTo(cursor.id) < 0;
      },
      toJson: (quiz) => quiz.historyJson(),
    );
  }

  // -------------------------------------------------------------------------
  // GET /me/favorites
  // -------------------------------------------------------------------------

  MockQuizHistoryReply _listFavorites(Map<String, dynamic> query) {
    final sorted =
        [
          for (final entry in _favorites.entries)
            (questionId: entry.key, favoritedAt: entry.value),
        ]..sort((a, b) {
          final byTime = b.favoritedAt.compareTo(a.favoritedAt);
          return byTime != 0 ? byTime : b.questionId.compareTo(a.questionId);
        });

    return _page<_FavoriteRow, _FavoriteCursor>(
      query,
      sorted: sorted,
      decode: _decodeFavoriteCursor,
      encode: _encodeFavoriteCursor,
      isAfter: (row, cursor) {
        final byTime = row.favoritedAt.compareTo(cursor.favoritedAt);
        return byTime != 0
            ? byTime < 0
            : row.questionId.compareTo(cursor.questionId) < 0;
      },
      toJson: (row) {
        final number = _questionNumber(row.questionId)!;
        return <String, dynamic>{
          'questionId': row.questionId,
          'text': _questionText(number),
          'subjectName': _subjects[_subjectOf(number)],
          'favoritedAt': row.favoritedAt.toIso8601String(),
        };
      },
    );
  }

  // -------------------------------------------------------------------------
  // GET /quizzes/{quizId}
  // -------------------------------------------------------------------------

  MockQuizHistoryReply _review(String quizId) {
    // Ownership first, then finished - the contract's check order. Another
    // student's quiz, a malformed id and an unknown id are all the same answer.
    final quiz = quizId == _openQuiz.id
        ? _openQuiz
        : _quizzes.where((q) => q.id == quizId).firstOrNull;
    if (quiz == null) {
      return const MockQuizHistoryProblem(
        403,
        'insufficient_scope',
        'No such quiz for this caller',
      );
    }
    if (!quiz.finished) {
      return const MockQuizHistoryProblem(
        403,
        'quiz_not_finished',
        'This quiz is not finished yet',
      );
    }
    return MockQuizHistoryOk(200, <String, dynamic>{
      'id': quiz.id,
      // `null` here, `''` in the history: the contract spells it both ways.
      'subjectName': quiz.subjectName,
      'scopeName': quiz.scopeName,
      'score': quiz.score,
      'totalQuestions': quiz.totalQuestions,
      'finishedAt': quiz.finishedAt!.toIso8601String(),
      'questions': [
        for (var k = 0; k < quiz.slots.length - quiz.omitted; k++)
          _reviewQuestionJson(k, quiz.slots[k]),
      ],
    });
  }

  Map<String, dynamic> _reviewQuestionJson(int index, _Slot slot) {
    final number = slot.questionNumber;
    final answered = slot.state != _Answer.unanswered;
    final correctIndex = _correctIndex(number);
    final selectedIndex = switch (slot.state) {
      _Answer.correct => correctIndex,
      _Answer.wrong => (correctIndex + 1) % 4,
      _Answer.unanswered => null,
    };
    return <String, dynamic>{
      'id': mockHistoryQuestionId(number),
      'order': index + 1,
      'text': _questionText(number),
      'imageUrl': null,
      'thumbnailUrl': null,
      'options': [
        for (var o = 0; o < 4; o++)
          <String, dynamic>{
            'id': mockHistoryOptionId(number, o),
            'text': 'Sample option ${'ABCD'[o]} for question $number',
          },
      ],
      'isFavorite': _favorites.containsKey(mockHistoryQuestionId(number)),
      'selectedOptionId': selectedIndex == null
          ? null
          : mockHistoryOptionId(number, selectedIndex),
      // Revealed ONLY for a question the student answered (adr-178 D1).
      'correctOptionId': answered
          ? mockHistoryOptionId(number, correctIndex)
          : null,
      'correct': answered ? slot.state == _Answer.correct : null,
      // Always false when unanswered; false for one subject even when answered,
      // because the feature is not enabled everywhere.
      'explanationAvailable':
          answered && _subjectOf(number) != _noExplanationSubject,
    };
  }

  // -------------------------------------------------------------------------
  // GET /me/quiz-summary
  // -------------------------------------------------------------------------

  /// DISTINCT questions answered correctly at least once, in any quiz, finished
  /// or not - including a question whose content has since gone from a review.
  MockQuizHistoryReply _summary() {
    final solved = <int>{
      for (final quiz in [..._quizzes, _openQuiz])
        for (final slot in quiz.slots)
          if (slot.state == _Answer.correct) slot.questionNumber,
    };
    return MockQuizHistoryOk(200, <String, dynamic>{
      'solvedQuestions': solved.length,
    });
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// `PUT`: idempotent. An already-favourite question keeps its `favoritedAt`.
  /// An id outside the bank is accepted (the contract documents no refusal) and
  /// simply not stored: there is no stem to list for it.
  void _favorite(String questionId) {
    if (_questionNumber(questionId) == null) return;
    _favorites.putIfAbsent(questionId, _stamp);
  }

  /// A new instant for a favourite: the clock, but never earlier than one
  /// second after the latest favourite already held, so "the one just added
  /// comes first" holds even on a misset device clock.
  DateTime _stamp() {
    final now = DateTime.now().toUtc();
    var latest = _newestFavorite;
    for (final at in _favorites.values) {
      if (at.isAfter(latest)) latest = at;
    }
    final floor = latest.add(const Duration(seconds: 1));
    return now.isAfter(floor) ? now : floor;
  }

  /// The 1-based bank number of [questionId], or `null` for an id outside the
  /// bank.
  int? _questionNumber(String questionId) {
    for (var n = 1; n <= kMockQuestionCount; n++) {
      if (mockHistoryQuestionId(n) == questionId) return n;
    }
    return null;
  }

  /// One keyset page of [sorted], honouring `limit` and `cursor` as the
  /// contract does. Every violation is collected into ONE `400`.
  MockQuizHistoryReply _page<T, C>(
    Map<String, dynamic> query, {
    required List<T> sorted,
    required C? Function(String cursor) decode,
    required String Function(T last) encode,
    required bool Function(T row, C cursor) isAfter,
    required Map<String, dynamic> Function(T row) toJson,
  }) {
    final errors = <String, List<String>>{};

    var limit = _pageSize;
    final rawLimit = query['limit'];
    if (rawLimit != null) {
      final parsed = int.tryParse(rawLimit.toString());
      if (parsed == null || parsed < 1 || parsed > 100) {
        errors['limit'] = ['Must be between 1 and 100.'];
      } else {
        limit = parsed;
      }
    }

    C? after;
    final rawCursor = query['cursor'];
    if (rawCursor != null) {
      after = rawCursor is String ? decode(rawCursor) : null;
      if (after == null) {
        errors['cursor'] = ['Not a cursor this API issued.'];
      }
    }
    if (errors.isNotEmpty) return MockQuizHistoryValidation(errors);

    // Keyset: the first row strictly AFTER the one the cursor names, in the
    // list's own order.
    var start = 0;
    if (after != null) {
      final cursor = after;
      start = sorted.indexWhere((row) => isAfter(row, cursor));
      if (start < 0) start = sorted.length;
    }
    final end = (start + limit).clamp(0, sorted.length);
    final hasMore = end < sorted.length;
    final page = sorted.sublist(start, end);

    return MockQuizHistoryOk(200, <String, dynamic>{
      'items': [for (final row in page) toJson(row)],
      'nextCursor': hasMore ? encode(page.last) : null,
      'hasMore': hasMore,
    });
  }

  // -------------------------------------------------------------------------
  // Fixtures
  // -------------------------------------------------------------------------

  _MockQuiz _buildFinishedQuiz(int position) {
    final p = position;
    final mode = p % 9 == 0
        ? 'retakeWrong'
        : p % 9 == 4
        ? 'favorites'
        : 'normal';
    final slots = <_Slot>[];
    String scopeName;
    String? subjectName;
    if (mode == 'normal') {
      final subject = p % 4;
      final count = 3 + p % 3;
      for (var k = 0; k < count; k++) {
        slots.add(
          _Slot(subject * 6 + 1 + (p + k) % 6, _AnswerOf.pattern(p + k)),
        );
      }
      scopeName = 'Lesson ${1 + p % 5}';
      subjectName = p == kMockUnresolvedSubjectQuiz ? null : _subjects[subject];
    } else {
      for (var k = 0; k < 5; k++) {
        slots.add(
          _Slot(
            1 + (p * 5 + k * 7) % kMockQuestionCount,
            _AnswerOf.pattern(p + k),
          ),
        );
      }
      // The contract does not say what `scopeName` holds for a pooled quiz, so
      // the fixtures cover a label and an empty string: a screen can rely on
      // neither.
      scopeName = mode == 'retakeWrong' ? 'Retake wrong' : '';
    }

    final tieBreak = p >= kMockTieBreakQuizzes.last ? 2 : 1;
    final startedAt = _newestStart.subtract(Duration(days: p - tieBreak));
    return _MockQuiz(
      id: mockHistoryQuizId(p),
      mode: mode,
      scopeName: scopeName,
      subjectName: subjectName,
      startedAt: startedAt,
      finishedAt: startedAt.add(const Duration(minutes: 25)),
      slots: slots,
      omitted: p == kMockOmittedQuestionQuiz ? 1 : 0,
    );
  }

  /// The caller's own open quiz: four questions, one unanswered, none of it
  /// finished. Its correct answers still count towards the summary.
  _MockQuiz _buildOpenQuiz() => _MockQuiz(
    id: kMockOpenQuizId,
    mode: 'normal',
    scopeName: 'Open quiz sample',
    subjectName: _subjects[0],
    startedAt: _newestStart.add(const Duration(hours: 1)),
    finishedAt: null,
    slots: const [
      _Slot(1, _Answer.correct),
      _Slot(2, _Answer.wrong),
      _Slot(3, _Answer.unanswered),
      _Slot(4, _Answer.correct),
    ],
    omitted: 0,
  );
}

// ---------------------------------------------------------------------------
// Rows
// ---------------------------------------------------------------------------

enum _Answer { correct, wrong, unanswered }

/// A rotation through the three states, 3 correct to 1 wrong to 1 unanswered
/// per five questions, so every state turns up in most quizzes.
abstract final class _AnswerOf {
  static _Answer pattern(int i) => switch (i % 5) {
    2 => _Answer.wrong,
    4 => _Answer.unanswered,
    _ => _Answer.correct,
  };
}

/// One question as a quiz served it: which bank question, and what happened.
class _Slot {
  const _Slot(this.questionNumber, this.state);

  final int questionNumber;
  final _Answer state;
}

class _MockQuiz {
  _MockQuiz({
    required this.id,
    required this.mode,
    required this.scopeName,
    required this.subjectName,
    required this.startedAt,
    required this.finishedAt,
    required this.slots,
    required this.omitted,
  });

  final String id;
  final String mode;
  final String scopeName;

  /// `null` when the quiz spans subjects or the subject is gone.
  final String? subjectName;
  final DateTime startedAt;
  final DateTime? finishedAt;

  /// Every question the quiz served, including the [omitted] trailing ones.
  final List<_Slot> slots;

  /// How many trailing questions have since lost their content.
  final int omitted;

  bool get finished => finishedAt != null;

  /// Frozen at finish: counts the omitted questions too.
  int get score => slots.where((s) => s.state == _Answer.correct).length;
  int get totalQuestions => slots.length;

  Map<String, dynamic> historyJson() => <String, dynamic>{
    'id': id,
    'subjectName': subjectName ?? '',
    'scopeName': scopeName,
    'mode': mode,
    'score': score,
    'totalQuestions': totalQuestions,
    'finishedAt': finishedAt!.toIso8601String(),
  };
}

typedef _FavoriteRow = ({String questionId, DateTime favoritedAt});

// ---------------------------------------------------------------------------
// Bank
// ---------------------------------------------------------------------------

/// The subject index (0..3) of bank question [number].
int _subjectOf(int number) => (number - 1) ~/ 6;

/// The 0-based index of the correct option; the client is never told until the
/// question is answered.
int _correctIndex(int number) => number % 4;

/// Plain text with, on every seventh question, the one markup the contract
/// allows in a stem: `<u>...</u>`.
String _questionText(int number) {
  final subject = _subjects[_subjectOf(number)];
  final named = number % 7 == 0 ? '<u>$subject</u>' : subject;
  return 'Sample question $number: which statement about $named is correct?';
}

/// Question 1 was favourited at this instant; each later one an hour earlier.
final _newestFavorite = DateTime.utc(2026, 10, 9, 8);

/// The most recently started finished quiz; each older one is a day earlier.
final _newestStart = DateTime.utc(2026, 10, 9, 10);

// ---------------------------------------------------------------------------
// Cursors - opaque to the app, a keyset here
// ---------------------------------------------------------------------------

typedef _HistoryCursor = ({DateTime startedAt, String id});

typedef _FavoriteCursor = ({DateTime favoritedAt, String questionId});

const _historyCursorTag = 'mock-quiz-history:';
const _favoriteCursorTag = 'mock-favorites:';

String _encodeHistoryCursor(_MockQuiz last) => base64Url.encode(
  utf8.encode(
    '$_historyCursorTag${last.startedAt.toIso8601String()}|${last.id}',
  ),
);

_HistoryCursor? _decodeHistoryCursor(String cursor) {
  final parts = _decodeParts(cursor, _historyCursorTag);
  if (parts == null) return null;
  final at = DateTime.tryParse(parts[0]);
  if (at == null || parts[1].isEmpty) return null;
  return (startedAt: at, id: parts[1]);
}

String _encodeFavoriteCursor(_FavoriteRow last) => base64Url.encode(
  utf8.encode(
    '$_favoriteCursorTag${last.favoritedAt.toIso8601String()}|${last.questionId}',
  ),
);

_FavoriteCursor? _decodeFavoriteCursor(String cursor) {
  final parts = _decodeParts(cursor, _favoriteCursorTag);
  if (parts == null) return null;
  final at = DateTime.tryParse(parts[0]);
  if (at == null || parts[1].isEmpty) return null;
  return (favoritedAt: at, questionId: parts[1]);
}

/// The two `|`-separated halves of a cursor that carries [tag], or `null` for a
/// token this mock did not issue for this list.
List<String>? _decodeParts(String cursor, String tag) {
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    if (!decoded.startsWith(tag)) return null;
    final parts = decoded.substring(tag.length).split('|');
    return parts.length == 2 ? parts : null;
  } on FormatException {
    return null;
  }
}
