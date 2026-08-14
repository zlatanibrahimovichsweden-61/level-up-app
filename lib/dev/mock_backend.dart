/// Throwaway on-device preview harness — NOT production code.
///
/// A hand-rolled Dio interceptor that answers the stable `/auth/*` and
/// `/reference/*` endpoints with contract-faithful canned JSON, so the whole
/// login → OTP → registration walk can be driven on a real device with no
/// server and no network at all (`AppConfig.baseUrl` is still TBD).
///
/// Deliberately hand-rolled rather than `http_mock_adapter`: adding a
/// dev_dependency would mean editing `pubspec.yaml`, and this harness is meant
/// to be 100% additive — two new files, zero edits to anything that ships.
///
/// Referenced ONLY by `lib/main_mock.dart`. Nothing under `lib/features` or
/// `lib/core` knows this file exists; injection happens through a single
/// `dioProvider` override in that entrypoint's `ProviderScope`.
///
/// Shapes are taken from `contract/openapi.yaml` (pinned `ee2ed8f`,
/// v1.1.0-m1 — see `contract/SOURCE.md`) so the canned JSON parses into the
/// REAL freezed models — if a model changes and the mock stops parsing, that is
/// the harness doing its job.
///
/// The harness is deliberately STRICT where the server is strict, not merely
/// permissive: it rejects `schoolName` and both-cities the way v1.1 does. A
/// mock that echoed whatever it was handed would let a device walkthrough
/// confirm the OLD contract.
library;

import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/interceptors/error_interceptor.dart';

/// Builds the Dio that replaces the real client for the mock run.
///
/// The chain is [MockBackendInterceptor] then the REAL [ErrorInterceptor], so
/// any non-2xx the mock produces still maps to the typed `AppException`
/// hierarchy exactly as it would in production.
///
/// There is no `AuthInterceptor`: the mock never answers 401, so the Bearer +
/// refresh/retry path is unreachable here anyway, and leaving it out keeps the
/// harness from depending on `AuthController`/`AuthRepository` wiring.
Dio buildMockDio({Duration latency = const Duration(milliseconds: 300)}) {
  final dio = Dio(
    BaseOptions(
      // Never resolved — the interceptor short-circuits every request before it
      // reaches a socket. Present only so Dio can build absolute URIs.
      baseUrl: 'http://mock.local/api/v1',
      headers: const {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    MockBackendInterceptor(latency: latency),
    ErrorInterceptor(),
  ]);
  return dio;
}

/// Short-circuits every request with a canned response.
///
/// [latency] is real (not zero) on purpose: the loading state of every picker
/// and button is part of what this harness exists to let you look at.
class MockBackendInterceptor extends Interceptor {
  MockBackendInterceptor({this.latency = const Duration(milliseconds: 300)});

  final Duration latency;

  /// Which track this mock session is. Set by the OTP code you enter (see
  /// [_kAuthenticatedCode] / [_kUniversityCode]) or by what you register as,
  /// then honoured by `GET /me` and the whole catalog — so one build walks
  /// either track without an edit or a reinstall.
  ///
  /// In production this is never a client choice: the server derives scope from
  /// the token (adr-013). The switch exists only because there is no server.
  String _track = 'school';

  bool get _isUniversity => _track == 'university';

  // ---- quiz session state -------------------------------------------------
  //
  // In production every one of these lives server-side; they are here because
  // the quiz endpoints are the first stateful thing this harness has had to
  // fake. See the trigger table on [_createQuiz] for how to reach each error.

  /// Live quizzes by id, holding the correct option per question (which the
  /// client is never told until it submits) and the answers so far.
  final _quizzes = <String, _MockQuiz>{};

  /// Free plan: 50 questions/WEEK. Incremented by each quiz's length, so the
  /// second 30-question quiz in a session trips `weekly_question_limit_reached`
  /// and the limit sheet is reachable without editing anything.
  int _questionsUsedThisWeek = 0;

  /// Mutable so `finish` can move it and `GET /me` reflects the award — the
  /// only way to see on device that finishing invalidates the profile. Starts
  /// where [_profile] starts.
  int _totalPoints = 1250;

  /// Questions this student has answered, in any quiz. `GET
  /// /questions/{id}/explanation` 403s for anything not in here, which is the
  /// contract's own rule ("question not yet answered by the caller").
  final _answeredQuestions = <String>{};

  /// How many times each question's explanation has been requested. The FIRST
  /// request answers `202 generating`; every later one answers `200 ready` —
  /// so the polling path is walked every single time, not just occasionally.
  final _explanationRequests = <String, int>{};

  /// The `geography.city` this session registered with, in whichever arm of the
  /// adr-028 §1 union it used. Null until a registration happens, in which case
  /// `GET /me` falls back to the coded fixture.
  Map<String, dynamic>? _registeredCity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(latency);

    final path = options.path;
    final method = options.method.toUpperCase();
    final query = options.queryParameters;
    final body = options.data is Map
        ? Map<String, dynamic>.from(options.data as Map)
        : const <String, dynamic>{};

    // ---- auth -------------------------------------------------------------
    if (method == 'POST' && path == '/auth/otp/request') {
      return _ok(handler, options, 202, <String, dynamic>{
        'resendAfterSeconds': 60,
        'expiresInSeconds': 300,
      });
    }

    if (method == 'POST' && path == '/auth/otp/verify') {
      final code = body['code'] as String? ?? '';
      final phone = body['phone'] as String? ?? '+201001234567';
      // The two magic codes land you straight on /home with a full session, one
      // per track; every other 6-digit code forks to registration so the wizard
      // can be walked.
      if (code == _kAuthenticatedCode || code == _kUniversityCode) {
        _track = code == _kUniversityCode ? 'university' : 'school';
        return _ok(handler, options, 200, <String, dynamic>{
          'result': 'authenticated',
          'tokens': _tokenPair(),
          'profile': _isUniversity
              ? _universityProfile(phone: phone)
              : _schoolProfile(phone: phone),
        });
      }
      return _ok(handler, options, 200, <String, dynamic>{
        'result': 'registrationRequired',
        'registrationToken': 'mock.registration.token',
        'expiresInSeconds': 600,
      });
    }

    if (method == 'POST' && path == '/auth/register') {
      // v1.1 rejects these server-side; the mock's job is to be strict exactly
      // where the server is strict, or a device walkthrough would confirm the
      // OLD contract and hide every fix this day made.
      final rejected = _registerViolations(body);
      if (rejected != null) {
        return _validationFailed(handler, options, rejected);
      }

      // Registering as a university student makes the rest of the session
      // university — otherwise the Learn tab would contradict what you just
      // signed up as.
      _track = body['track'] == 'university' ? 'university' : 'school';
      // Remembered so a LATER `GET /me` echoes the city the student actually
      // registered with. A free-text registration whose profile comes back
      // coded on the next fetch would prove nothing.
      _registeredCity = _cityFromRegistration(body);
      return _ok(handler, options, 201, <String, dynamic>{
        'result': 'authenticated',
        'tokens': _tokenPair(),
        'profile': _profileFromRegistration(body),
      });
    }

    if (method == 'POST' && path == '/auth/refresh') {
      return _ok(handler, options, 200, _tokenPair());
    }

    if (method == 'POST' && path == '/auth/logout') {
      return _ok(handler, options, 204, null);
    }

    // ---- profile ----------------------------------------------------------
    // Home is powered entirely by GET /me, so without this the whole tab
    // renders its error state on device.
    if (method == 'GET' && path == '/me') {
      const phone = '+201021871999';
      return _ok(
        handler,
        options,
        200,
        // Reads the LIVE total, which `finish` moves. Re-fetching after a quiz
        // therefore shows the award, exactly as it will in production.
        _isUniversity
            ? _universityProfile(
                phone: phone,
                totalPoints: _totalPoints,
                city: _registeredCity,
              )
            : _schoolProfile(
                phone: phone,
                totalPoints: _totalPoints,
                city: _registeredCity,
              ),
      );
    }

    if (method == 'GET' && path == '/me/entitlements') {
      return _ok(handler, options, 200, <String, dynamic>{
        'items': _entitlements,
      });
    }

    // ---- catalog ----------------------------------------------------------
    // The Learn tab. Server-scoped in production — the client sends no scope
    // params, so there is nothing to branch on here either.
    if (method == 'GET' && path == '/catalog/subjects') {
      return _ok(
        handler,
        options,
        200,
        _isUniversity ? _universitySubjects : _subjects,
      );
    }

    final tree = RegExp(r'^/catalog/subjects/([^/]+)/tree$').firstMatch(path);
    if (method == 'GET' && tree != null) {
      final subjectId = tree.group(1)!;
      // The contract's `oneOf`: same endpoint, a different shape per track.
      final body = _isUniversity
          ? _universitySubjectTrees[subjectId]
          : _schoolSubjectTree(subjectId);
      // A subject outside the caller's scope — the contract's 403. Reachable
      // here by deep-linking an id that isn't in the mock's list, or by asking
      // for the other track's subjects.
      if (body == null) {
        return _problem(
          handler,
          options,
          403,
          'insufficient_scope',
          'Subject $subjectId is not in scope',
        );
      }
      return _ok(handler, options, 200, body);
    }

    // ---- quiz -------------------------------------------------------------
    // The whole Day 7 engine. `AppConfig.baseUrl` is still TBD, so without
    // these four handlers no quiz screen can be run on a device at all.
    //
    // Unlike the catalog handlers above, these are STATEFUL: a quiz remembers
    // which option is correct, which questions have been answered, and whether
    // it has been finished — because that is the only way the idempotency
    // guarantee, the graded state and the summary can be exercised for real.
    if (method == 'POST' && path == '/quizzes') {
      return _createQuiz(handler, options, body);
    }

    final answers = RegExp(r'^/quizzes/([^/]+)/answers$').firstMatch(path);
    if (method == 'POST' && answers != null) {
      return _submitAnswer(handler, options, answers.group(1)!, body);
    }

    final finish = RegExp(r'^/quizzes/([^/]+)/finish$').firstMatch(path);
    if (method == 'POST' && finish != null) {
      return _finishQuiz(handler, options, finish.group(1)!);
    }

    final explanation = RegExp(
      r'^/questions/([^/]+)/explanation$',
    ).firstMatch(path);
    if (method == 'GET' && explanation != null) {
      return _explanation(handler, options, explanation.group(1)!);
    }

    // ---- reference --------------------------------------------------------
    if (method == 'GET' && path == '/reference/countries') {
      return _ok(handler, options, 200, _countries);
    }

    final governorates = RegExp(
      r'^/reference/countries/([^/]+)/governorates$',
    ).firstMatch(path);
    if (method == 'GET' && governorates != null) {
      // Codes normalize case-insensitively, so `eg` is accepted as `EG`
      // (contract-changelog 2026-07-30). Comparing the raw path segment would
      // hand `eg` an empty governorate list instead of Cairo.
      final code = governorates.group(1)?.toUpperCase();
      final failure = _referenceCountryFailure(handler, options, code);
      if (failure) return;
      // Contract: bare array, EMPTY for non-EG.
      return _ok(
        handler,
        options,
        200,
        code == 'EG' ? _egGovernorates : <dynamic>[],
      );
    }

    if (method == 'GET' && path == '/reference/cities') {
      final code = (query['countryCode'] as String?)?.toUpperCase();
      final failure = _referenceCountryFailure(handler, options, code);
      if (failure) return;
      return _ok(
        handler,
        options,
        200,
        _citiesFor(
          countryCode: code,
          governorateId: query['governorateId'] as String?,
        ),
      );
    }

    if (method == 'GET' && path == '/reference/schools') {
      final q = query['q'] as String?;
      // The school search has no countryCode to key a failure off, so its
      // trigger is the search box itself — see the table on
      // [_referenceCountryFailure].
      if (q != null && q.trim() == _kRateLimitTrigger) {
        return _rateLimited(handler, options);
      }
      return _ok(
        handler,
        options,
        200,
        _schoolPage(
          q: q,
          cursor: query['cursor'] as String?,
          limit: query['limit'] as int? ?? 20,
        ),
      );
    }

    if (method == 'GET' && path == '/reference/education-systems') {
      return _ok(handler, options, 200, _educationSystems);
    }

    if (method == 'GET' && path == '/reference/universities') {
      return _ok(handler, options, 200, _universities);
    }

    if (method == 'GET' && path == '/reference/avatars') {
      return _ok(handler, options, 200, _avatars);
    }

    // Anything not mocked fails loudly as a contract-shaped 404 rather than
    // hanging on a socket — an unmocked call should be obvious, not silent.
    return _problem(
      handler,
      options,
      404,
      'not_found',
      'No mock for $method $path',
    );
  }

  /// The adr-028 rules `POST /auth/register` now enforces, as a
  /// `ProblemDetails.errors` field map — or null when the body is acceptable.
  ///
  /// Everything here is a rule the REAL server applies. Under v1.0 the mock
  /// echoed whatever it was sent, so a body that v1.1 rejects would have
  /// sailed through a device walkthrough.
  Map<String, List<String>>? _registerViolations(Map<String, dynamic> body) {
    final errors = <String, List<String>>{};

    // `schoolName` was removed from the contract entirely — it is now an
    // UNKNOWN PROPERTY, and unknown properties are rejected, not ignored.
    if (body.containsKey('schoolName')) {
      errors['schoolName'] = ['Unknown property (removed in v1.1, adr-028 §2)'];
    }

    // adr-028 §1: exactly one of cityId / cityName.
    final hasCityId = (body['cityId'] as String?)?.isNotEmpty ?? false;
    final hasCityName = (body['cityName'] as String?)?.isNotEmpty ?? false;
    if (hasCityId && hasCityName) {
      errors['cityName'] = ['Supply cityId OR cityName, not both'];
    } else if (!hasCityId && !hasCityName) {
      errors['cityId'] = ['At least one of cityId / cityName is required'];
    }
    if (hasCityName && (body['cityName']! as String).length > 100) {
      errors['cityName'] = ['maxLength 100'];
    }

    if (body['track'] == 'school') {
      // adr-010, UNCHANGED by adr-028.
      final requiresGovernorate = body['countryCode'] == 'EG';
      final hasGovernorate =
          (body['governorateId'] as String?)?.isNotEmpty ?? false;
      if (requiresGovernorate && !hasGovernorate) {
        errors['governorateId'] = ['Required when countryCode is EG'];
      }
      if (!requiresGovernorate && hasGovernorate) {
        errors['governorateId'] = ['Not allowed outside Egypt'];
      }
      // adr-028 §2: schoolId is accepted-or-absent for Egypt. Outside Egypt
      // the coded list is empty, so an id there cannot refer to anything.
      final hasSchool = (body['schoolId'] as String?)?.isNotEmpty ?? false;
      if (!requiresGovernorate && hasSchool) {
        errors['schoolId'] = ['The coded school list is Egypt-only'];
      }
    }

    return errors.isEmpty ? null : errors;
  }

  /// `400 validation_failed` carrying the contract's field map, so the screens'
  /// per-field inline errors are exercised rather than just the banner.
  void _validationFailed(
    RequestInterceptorHandler handler,
    RequestOptions options,
    Map<String, List<String>> errors,
  ) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 400,
          data: <String, dynamic>{
            'title': 'Validation failed',
            'status': 400,
            'code': 'validation_failed',
            'errors': errors,
          },
        ),
      ),
      true,
    );
  }

  /// The `/reference/*` failure paths v1.1 added, keyed off `countryCode` so
  /// every one is reachable from the registration form itself. Returns true
  /// when it has answered the request.
  ///
  /// **Trigger table — how to reach each error path on a device:**
  ///
  /// | Outcome | How to reach it |
  /// |---|---|
  /// | `404 country_not_found` | pick **Unknown Country** in the Country dropdown — a well-formed code (`XX`) that is not in the coded list |
  /// | `400 validation_failed` | pick **Bad Country Code** — a malformed code (`EGY`, not ISO 3166-1 alpha-2 shape). The 400/404 split is the contract's, and it is easy to get backwards |
  /// | `429 rate_limited` | pick **Rate Limited** — governorates AND cities then answer 429 with `Retry-After: 30` |
  /// | `429` on schools | type `429` in the school search box |
  ///
  /// The first two rows are the REAL server behaviour, not invented triggers:
  /// they are what `XX` and `EGY` genuinely return. They are reachable here
  /// only because the mock's country list carries those rows, since the picker
  /// never lets a student type a code.
  bool _referenceCountryFailure(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String? countryCode,
  ) {
    // Codes normalize case-insensitively (`eg` is accepted as `EG`).
    final code = countryCode?.trim().toUpperCase();
    if (code == null) return false;

    if (code == _kRateLimitedCountry) {
      _rateLimited(handler, options);
      return true;
    }
    // Malformed — NOT ISO 3166-1 alpha-2 shape. This is the 400, not the 404.
    if (code.length != 2 || !RegExp(r'^[A-Z]{2}$').hasMatch(code)) {
      _problem(
        handler,
        options,
        400,
        'validation_failed',
        '"$countryCode" is not an ISO 3166-1 alpha-2 country code',
      );
      return true;
    }
    // Well-formed but unrecognised — this one is the 404 (adr-028 §3).
    // Checked against the REAL launch set, not `_countries`: the trigger rows
    // live in that list so the picker can offer them, and would otherwise
    // recognise themselves.
    if (!_kLaunchCountries.contains(code)) {
      _problem(
        handler,
        options,
        404,
        'country_not_found',
        'Country "$code" is not in the coded list',
      );
      return true;
    }
    return false;
  }

  /// `429 rate_limited` + `Retry-After`, the unauthenticated per-IP limit on
  /// `/reference/*`. The header is sent as delta-seconds, the only form the
  /// client parses (a date form would mean trusting the device clock).
  void _rateLimited(
    RequestInterceptorHandler handler,
    RequestOptions options,
  ) => _problem(
    handler,
    options,
    429,
    'rate_limited',
    'Too many requests to /reference/* from this IP',
    headers: <String, List<String>>{
      'retry-after': ['30'],
    },
  );

  /// `POST /quizzes` → `201 Quiz`, or one of the three failures below.
  ///
  /// **Trigger table — how to reach each error path on a device:**
  ///
  /// | Outcome | How to reach it |
  /// |---|---|
  /// | `201` | any lesson/lecture whose pool ≥ the chosen length |
  /// | `422 not_enough_questions` | pick a scope whose counter total is smaller than the length — e.g. any `0 / 0` lesson at any length, or a `20`-question lesson at 30 |
  /// | `403 weekly_question_limit_reached` | start quizzes until 50 questions are used in the session (two 30s, or five 10s) |
  /// | `403 subscription_required` | any lesson under **الكيمياء** (school) or **الفسيولوجي** (university) — those two subjects are the mock's paid scopes |
  ///
  /// The pool size is read from the SAME `questionCounter.total` the catalog
  /// screens just showed the student, so a 422 always agrees with the number
  /// on the row they tapped. That is deliberate: a mock that disagreed with
  /// its own catalog would teach the wrong lesson about the 422.
  void _createQuiz(
    RequestInterceptorHandler handler,
    RequestOptions options,
    Map<String, dynamic> body,
  ) {
    final lessonId = body['lessonId'] as String?;
    final lectureId = body['lectureId'] as String?;
    final length = (body['length'] as num?)?.toInt() ?? 10;
    final scopeId = lessonId ?? lectureId;

    // The mock's paid scopes. In production this is an entitlement check the
    // server makes; here it is a documented prefix so the sheet's second copy
    // variant is reachable.
    if (scopeId != null &&
        (scopeId.startsWith('chem-') || scopeId.startsWith('physio-'))) {
      return _problem(
        handler,
        options,
        403,
        'subscription_required',
        'This scope needs an active base_subscription',
      );
    }

    // Free plan: baseSubscription is inactive in [_entitlements], so the weekly
    // cap applies. Checked BEFORE the pool so the limit sheet wins over a 422,
    // which is the order that matters to a student who has run out.
    if (_questionsUsedThisWeek + length > _kFreeWeeklyQuestions) {
      return _problem(
        handler,
        options,
        403,
        'weekly_question_limit_reached',
        'Free plan allows $_kFreeWeeklyQuestions questions per week',
      );
    }

    final pool = _poolSize(scopeId, isUniversity: _isUniversity);
    if (pool < length) {
      return _problem(
        handler,
        options,
        422,
        'not_enough_questions',
        'Scope pool holds $pool questions, $length were requested',
      );
    }

    _questionsUsedThisWeek += length;

    final quiz = _MockQuiz.build(
      id: 'quiz-${_quizzes.length + 1}',
      mode: body['mode'] as String? ?? 'normal',
      quizType: body['quizType'] as String?,
      scopeName: _scopeName(scopeId, isUniversity: _isUniversity),
      length: length,
    );
    _quizzes[quiz.id] = quiz;

    return _ok(handler, options, 201, quiz.toJson());
  }

  /// `POST /quizzes/{quizId}/answers` → `200 AnswerResult`.
  ///
  /// Idempotent on `(quizId, questionId)`, exactly as the contract specifies:
  /// a replay returns the ORIGINAL `correct`/`correctOptionId`, and
  /// `pointsDelta` is `0` because nothing new was awarded — the contract's own
  /// wording for the field is "0 on retry replay".
  void _submitAnswer(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String quizId,
    Map<String, dynamic> body,
  ) {
    final quiz = _quizzes[quizId];
    if (quiz == null) {
      return _problem(handler, options, 404, 'not_found', 'No quiz $quizId');
    }
    if (quiz.finished) {
      return _problem(
        handler,
        options,
        409,
        'quiz_already_finished',
        'Quiz $quizId is closed',
      );
    }

    final questionId = body['questionId'] as String? ?? '';
    final optionId = body['optionId'] as String? ?? '';
    final correctOptionId = quiz.correctOption[questionId];
    if (correctOptionId == null) {
      return _problem(
        handler,
        options,
        404,
        'not_found',
        'Question $questionId is not in quiz $quizId',
      );
    }

    final replay = quiz.answers.containsKey(questionId);
    if (!replay) quiz.answers[questionId] = optionId;
    _answeredQuestions.add(questionId);

    // The grade is always the ORIGINAL choice's grade — a replay that sent a
    // different optionId does not get re-marked.
    final correct = quiz.answers[questionId] == correctOptionId;

    return _ok(handler, options, 200, <String, dynamic>{
      'correct': correct,
      'correctOptionId': correctOptionId,
      'pointsDelta': replay ? 0 : (correct ? 1 : 0),
      // Every third question has no explanation, so the "panel not offered"
      // path is visible on device too.
      'explanationAvailable': quiz.explanationAvailable(questionId),
    });
  }

  /// `POST /quizzes/{quizId}/finish` → `200 QuizSummary`. Idempotent — the
  /// summary is computed once and replayed, so points cannot be awarded twice.
  void _finishQuiz(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String quizId,
  ) {
    final quiz = _quizzes[quizId];
    if (quiz == null) {
      return _problem(handler, options, 404, 'not_found', 'No quiz $quizId');
    }

    if (quiz.summary == null) {
      final score = quiz.answers.entries
          .where((e) => quiz.correctOption[e.key] == e.value)
          .length;
      final before = _totalPoints;
      // +1 per correct, server-side — the ONLY place points are decided.
      _totalPoints += score;

      quiz.finished = true;
      quiz.summary = <String, dynamic>{
        'quizId': quiz.id,
        'score': score,
        'totalQuestions': quiz.questions.length,
        'answeredCount': quiz.answers.length,
        'pointsAwarded': score,
        'totalPoints': _totalPoints,
        'level': _levelFor(_totalPoints),
        'leveledUp': _levelFor(_totalPoints) > _levelFor(before),
        'newBadge': false,
        'questions': <dynamic>[
          for (final question in quiz.questions)
            <String, dynamic>{
              'questionId': question['id'],
              'answered': quiz.answers.containsKey(question['id']),
              'correct': quiz.answers.containsKey(question['id'])
                  ? quiz.answers[question['id']] ==
                        quiz.correctOption[question['id']]
                  : null,
            },
        ],
      };
    }

    return _ok(handler, options, 200, quiz.summary);
  }

  /// `GET /questions/{questionId}/explanation` → `403`, `202`, then `200`.
  ///
  /// The three states in the order a student meets them: asking before
  /// answering is refused, the first request after answering is still
  /// generating, and the poll two seconds later succeeds. Nothing here is
  /// random — the polling path is walked on every question, every run.
  void _explanation(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String questionId,
  ) {
    if (!_answeredQuestions.contains(questionId)) {
      return _problem(
        handler,
        options,
        403,
        'insufficient_scope',
        'Question $questionId has not been answered by the caller',
      );
    }

    final hits = (_explanationRequests[questionId] ?? 0) + 1;
    _explanationRequests[questionId] = hits;

    if (hits == 1) {
      return _ok(handler, options, 202, <String, dynamic>{
        'status': 'generating',
      });
    }
    return _ok(handler, options, 200, <String, dynamic>{
      'status': 'ready',
      'text':
          'الإجابة الصحيحة تعتمد على أن $questionId يقيس فهم المفهوم '
          'الأساسي في هذا الدرس. الخيارات الأخرى تبدو معقولة لكنها تخلط بين '
          'تعريفين مختلفين.',
    });
  }

  void _ok(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    Object? data,
  ) {
    handler.resolve(
      Response<dynamic>(
        requestOptions: options,
        statusCode: status,
        data: data,
      ),
    );
  }

  /// RFC 9457 ProblemDetails, rejected THROUGH the real ErrorInterceptor
  /// (`callFollowingErrorInterceptor: true`) so it arrives at the repository as
  /// a typed `AppException`, exactly as a real failure would.
  void _problem(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    String code,
    String detail, {
    Map<String, List<String>>? headers,
  }) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: <String, dynamic>{
            'title': detail,
            'status': status,
            'code': code,
            'detail': detail,
          },
          // Carried so `Retry-After` reaches the real ErrorInterceptor's
          // parser rather than being invented on the client side.
          headers: headers == null ? null : Headers.fromMap(headers),
        ),
      ),
      true,
    );
  }
}

/// Enter this at the OTP screen to skip registration and land on `/home` as a
/// SCHOOL student.
const _kAuthenticatedCode = '000000';

/// Same, but as a UNIVERSITY student — the whole session (Home's Learning Tools
/// section, the Learn tab's lecture trees) follows from this one code.
const _kUniversityCode = '111111';

/// The mock's real launch countries. The rows beyond these in [_countries]
/// exist only to make v1.1's new `/reference/*` failures reachable from the
/// picker; see [MockBackendInterceptor._referenceCountryFailure].
const _kLaunchCountries = {'EG', 'AE'};

/// Country code whose geography lookups answer `429 rate_limited`.
const _kRateLimitedCountry = 'ZZ';

/// Type this in the school search box to get the same 429 there.
const _kRateLimitTrigger = '429';

// ---------------------------------------------------------------------------
// Canned data
// ---------------------------------------------------------------------------

Map<String, dynamic> _tokenPair() => <String, dynamic>{
  'accessToken': 'mock.access.token',
  'accessExpiresInSeconds': 900,
  'refreshToken': 'mock.refresh.token',
  'refreshExpiresInSeconds': 5184000,
};

final _countries = <dynamic>[
  <String, dynamic>{
    'code': 'EG',
    'nameAr': 'مصر',
    'nameEn': 'Egypt',
    'requiresGovernorate': true,
  },
  <String, dynamic>{
    'code': 'AE',
    'nameAr': 'الإمارات العربية المتحدة',
    'nameEn': 'United Arab Emirates',
    'requiresGovernorate': false,
  },
  // --- v1.1 error-path triggers (see _referenceCountryFailure) -------------
  //
  // Not real countries. A student never types a country code — the picker is
  // the only way in — so the only way to reach the new 400/404/429 responses on
  // a device is to put a row in this list for each. They sort last and say what
  // they do.
  <String, dynamic>{
    'code': _kRateLimitedCountry,
    'nameAr': 'محدود المعدل (تجريبي: 429)',
    'nameEn': 'Rate Limited (mock: 429)',
    'requiresGovernorate': true,
  },
  <String, dynamic>{
    'code': 'XX',
    'nameAr': 'دولة غير معروفة (تجريبي: 404)',
    'nameEn': 'Unknown Country (mock: 404)',
    'requiresGovernorate': false,
  },
  <String, dynamic>{
    'code': 'EGY',
    'nameAr': 'رمز دولة غير صالح (تجريبي: 400)',
    'nameEn': 'Bad Country Code (mock: 400)',
    'requiresGovernorate': false,
  },
];

Map<String, dynamic> _named(String id, String ar, String en) =>
    <String, dynamic>{'id': id, 'nameAr': ar, 'nameEn': en};

final _egGovernorates = <dynamic>[
  _named('0197b2f3-0001-7cc3-9b4e-000000000001', 'القاهرة', 'Cairo'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000002', 'الجيزة', 'Giza'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000003', 'الإسكندرية', 'Alexandria'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000004', 'الدقهلية', 'Dakahlia'),
  _named('0197b2f3-0001-7cc3-9b4e-000000000005', 'أسيوط', 'Asyut'),
];

/// EG cities are keyed by governorate (the contract 400s on EG without one);
/// non-EG countries get a flat list keyed by country code.
List<dynamic> _citiesFor({String? countryCode, String? governorateId}) {
  if (countryCode == 'EG') {
    return switch (governorateId) {
      '0197b2f3-0001-7cc3-9b4e-000000000001' => <dynamic>[
        _named(
          '0197b2f3-0002-7cc3-9b4e-000000000001',
          'مدينة نصر',
          'Nasr City',
        ),
        _named('0197b2f3-0002-7cc3-9b4e-000000000002', 'المعادي', 'Maadi'),
        _named(
          '0197b2f3-0002-7cc3-9b4e-000000000003',
          'مصر الجديدة',
          'Heliopolis',
        ),
      ],
      '0197b2f3-0001-7cc3-9b4e-000000000002' => <dynamic>[
        _named('0197b2f3-0002-7cc3-9b4e-000000000004', 'الدقي', 'Dokki'),
        _named(
          '0197b2f3-0002-7cc3-9b4e-000000000005',
          '٦ أكتوبر',
          '6th of October',
        ),
      ],
      '0197b2f3-0001-7cc3-9b4e-000000000003' => <dynamic>[
        _named('0197b2f3-0002-7cc3-9b4e-000000000006', 'سموحة', 'Smouha'),
        _named('0197b2f3-0002-7cc3-9b4e-000000000007', 'ميامي', 'Miami'),
      ],
      // A governorate with no cities — the Empty state, on purpose.
      '0197b2f3-0001-7cc3-9b4e-000000000005' => <dynamic>[],
      _ => <dynamic>[
        _named('0197b2f3-0002-7cc3-9b4e-000000000008', 'المنصورة', 'Mansoura'),
        _named('0197b2f3-0002-7cc3-9b4e-000000000009', 'طلخا', 'Talkha'),
      ],
    };
  }
  return <dynamic>[
    _named('0197b2f3-0003-7cc3-9b4e-000000000001', 'دبي', 'Dubai'),
    _named('0197b2f3-0003-7cc3-9b4e-000000000002', 'أبو ظبي', 'Abu Dhabi'),
    _named('0197b2f3-0003-7cc3-9b4e-000000000003', 'الشارقة', 'Sharjah'),
  ];
}

/// 47 schools — enough that a 20-per-page cursor walk needs three pages, so
/// "load more" and the final "no more results" both render.
final _allSchools = <Map<String, dynamic>>[
  for (var i = 1; i <= 47; i++)
    _named(
      '0197b2f3-0004-7cc3-9b4e-${i.toString().padLeft(12, '0')}',
      'مدرسة رقم $i الرسمية',
      'Al Nasr Language School $i',
    ),
];

/// `CursorPage<NamedRef>`. The cursor is an opaque base64 offset — the client
/// only ever echoes it back, which is exactly the contract's contract.
Map<String, dynamic> _schoolPage({
  String? q,
  String? cursor,
  required int limit,
}) {
  final needle = (q ?? '').trim().toLowerCase();
  final matches = needle.isEmpty
      ? _allSchools
      : _allSchools.where((s) {
          final en = (s['nameEn']! as String).toLowerCase();
          final ar = s['nameAr']! as String;
          return en.contains(needle) || ar.contains(needle);
        }).toList();

  final offset = _decodeCursor(cursor);
  final end = (offset + limit).clamp(0, matches.length);
  final page = matches.sublist(offset.clamp(0, matches.length), end);
  final hasMore = end < matches.length;

  return <String, dynamic>{
    'items': <dynamic>[...page],
    'nextCursor': hasMore ? _encodeCursor(end) : null,
    'hasMore': hasMore,
  };
}

String _encodeCursor(int offset) =>
    base64Url.encode(utf8.encode('offset:$offset'));

int _decodeCursor(String? cursor) {
  if (cursor == null || cursor.isEmpty) return 0;
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    return int.tryParse(decoded.split(':').last) ?? 0;
  } on FormatException {
    return 0;
  }
}

final _educationSystems = <dynamic>[
  <String, dynamic>{
    'code': 'nationalArabic',
    'nameAr': 'الوطني عربي',
    'nameEn': 'National (Arabic)',
  },
  <String, dynamic>{
    'code': 'nationalLanguages',
    'nameAr': 'الوطني لغات',
    'nameEn': 'National (Languages)',
  },
  <String, dynamic>{'code': 'ig', 'nameAr': 'آي جي', 'nameEn': 'IG'},
  <String, dynamic>{
    'code': 'american',
    'nameAr': 'أمريكي',
    'nameEn': 'American',
  },
  <String, dynamic>{
    'code': 'ib',
    'nameAr': 'البكالوريا الدولية',
    'nameEn': 'IB',
  },
];

Map<String, dynamic> _year(String id, int number, String status) =>
    <String, dynamic>{'id': id, 'yearNumber': number, 'status': status};

/// Two universities → Human Medicine + Pharmacy → data-driven years carrying
/// BOTH `active` and `soon`, so the year filtering is visible.
final _universities = <dynamic>[
  <String, dynamic>{
    'id': '0197b2f3-0005-7cc3-9b4e-000000000001',
    'nameAr': 'جامعة القاهرة',
    'nameEn': 'Cairo University',
    'faculties': <dynamic>[
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000001',
        'nameAr': 'كلية الطب البشري',
        'nameEn': 'Faculty of Human Medicine',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000001', 1, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000002', 2, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000003', 3, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000004', 4, 'soon'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000005', 5, 'soon'),
        ],
      },
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000002',
        'nameAr': 'كلية الصيدلة',
        'nameEn': 'Faculty of Pharmacy',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000006', 1, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000007', 2, 'soon'),
        ],
      },
    ],
  },
  <String, dynamic>{
    'id': '0197b2f3-0005-7cc3-9b4e-000000000002',
    'nameAr': 'جامعة عين شمس',
    'nameEn': 'Ain Shams University',
    'faculties': <dynamic>[
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000003',
        'nameAr': 'كلية الطب البشري',
        'nameEn': 'Faculty of Human Medicine',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000008', 1, 'active'),
          _year('0197b2f3-0007-7cc3-9b4e-000000000009', 2, 'soon'),
        ],
      },
      // A faculty whose years are ALL `soon` — the Empty year list.
      <String, dynamic>{
        'id': '0197b2f3-0006-7cc3-9b4e-000000000004',
        'nameAr': 'كلية الصيدلة',
        'nameEn': 'Faculty of Pharmacy',
        'years': <dynamic>[
          _year('0197b2f3-0007-7cc3-9b4e-000000000010', 1, 'soon'),
        ],
      },
    ],
  },
];

// ---------------------------------------------------------------------------
// Catalog (Learn tab)
// ---------------------------------------------------------------------------

Map<String, dynamic> _counter(int answered, int total) => <String, dynamic>{
  'answered': answered,
  'total': total,
};

Map<String, dynamic> _subject(
  String id,
  String name,
  int answered,
  int total,
) => <String, dynamic>{
  'id': id,
  'name': name,
  'questionCounter': _counter(answered, total),
};

/// `name` arrives already in the content language (adr-018), so these are
/// Arabic — exactly what an Egyptian school student's catalog returns, and the
/// only way the RTL grid gets exercised on device.
///
/// The spread is deliberate: a fully-answered subject and a `0 / 0` subject both
/// appear, so it is visible on device that the counter locks nothing.
final _subjects = <dynamic>[
  _subject('sub-bio', 'الأحياء', 216, 480),
  _subject('sub-chem', 'الكيمياء', 480, 480), // finished — still fully tappable
  _subject('sub-phys', 'الفيزياء', 0, 0), // no questions yet — still tappable
  _subject('sub-math', 'الرياضيات', 95, 300),
  _subject('sub-geo', 'الجغرافيا', 40, 120),
  _subject('sub-arabic', 'اللغة العربية', 12, 150), // empty tree, on purpose
];

Map<String, dynamic> _lesson(String id, String name, int answered, int total) =>
    <String, dynamic>{
      'id': id,
      'name': name,
      'questionCounter': _counter(answered, total),
    };

/// Two units × two chapters × two-or-three lessons per subject — enough that
/// every level of the drill-down has something to show, and `الفيزياء`'s second
/// chapter is empty so the Lessons empty state is reachable on device.
List<dynamic> _schoolUnits(String prefix) => <dynamic>[
  <String, dynamic>{
    'id': '$prefix-u1',
    'name': 'الوحدة الأولى',
    'chapters': <dynamic>[
      <String, dynamic>{
        'id': '$prefix-u1-c1',
        'name': 'الفصل الأول',
        'lessons': <dynamic>[
          _lesson('$prefix-u1-c1-l1', 'الدرس الأول', 12, 40),
          _lesson('$prefix-u1-c1-l2', 'الدرس الثاني', 40, 40),
          _lesson('$prefix-u1-c1-l3', 'الدرس الثالث', 0, 25),
        ],
      },
      <String, dynamic>{
        'id': '$prefix-u1-c2',
        'name': 'الفصل الثاني',
        'lessons': <dynamic>[
          _lesson('$prefix-u1-c2-l1', 'الدرس الأول', 5, 30),
          _lesson('$prefix-u1-c2-l2', 'الدرس الثاني', 18, 35),
        ],
      },
    ],
  },
  <String, dynamic>{
    'id': '$prefix-u2',
    'name': 'الوحدة الثانية',
    'chapters': <dynamic>[
      <String, dynamic>{
        'id': '$prefix-u2-c1',
        'name': 'الفصل الأول',
        'lessons': <dynamic>[
          _lesson('$prefix-u2-c1-l1', 'الدرس الأول', 3, 20),
          _lesson('$prefix-u2-c1-l2', 'الدرس الثاني', 0, 0),
        ],
      },
      // A chapter with no lessons yet — the Lessons empty state.
      <String, dynamic>{
        'id': '$prefix-u2-c2',
        'name': 'الفصل الثاني',
        'lessons': <dynamic>[],
      },
    ],
  },
];

/// `SchoolSubjectTree` for a known subject, else null → `403`.
Map<String, dynamic>? _schoolSubjectTree(String subjectId) {
  final units = _subjectTrees[subjectId];
  if (units == null) return null;
  return <String, dynamic>{'track': 'school', 'units': units};
}

/// Keyed by `subjectId`; anything not in here answers `403 insufficient_scope`,
/// which is the contract's own response for an out-of-scope subject.
final _subjectTrees = <String, List<dynamic>>{
  'sub-bio': _schoolUnits('bio'),
  'sub-chem': _schoolUnits('chem'),
  'sub-phys': _schoolUnits('phys'),
  'sub-math': _schoolUnits('math'),
  'sub-geo': _schoolUnits('geo'),
  // A subject with no content published yet — the Units empty state.
  'sub-arabic': <dynamic>[],
};

// ---- university catalog ----------------------------------------------------

/// A first-year medical student's subjects — the server scopes these by
/// university/faculty/year, which is why they are a different set entirely from
/// the school list rather than the same subjects re-labelled.
final _universitySubjects = <dynamic>[
  _subject('uni-anatomy', 'التشريح', 132, 400),
  _subject('uni-physio', 'الفسيولوجي', 400, 400), // finished — still tappable
  _subject(
    'uni-biochem',
    'الكيمياء الحيوية',
    0,
    0,
  ), // untouched — still tappable
  _subject('uni-histology', 'الأنسجة', 58, 210),
];

Map<String, dynamic> _lecture(
  String id,
  String name,
  int answered,
  int total,
) => <String, dynamic>{
  'id': id,
  'name': name,
  'questionCounter': _counter(answered, total),
};

/// `UniversitySubjectTree` — flat, plus the quiz types THIS subject offers.
///
/// [quizTypes] deliberately varies per subject below: the tab row is built from
/// this list, so a subject without a practical component must not show a
/// Practice tab. Hardcoding five tabs would hide that bug on device.
Map<String, dynamic> _universityTree(
  String prefix,
  List<String> quizTypes,
  List<dynamic> lectures,
) => <String, dynamic>{
  'track': 'university',
  'quizTypes': quizTypes,
  'lectures': lectures,
};

final _universitySubjectTrees = <String, Map<String, dynamic>>{
  // The full set of four quiz types.
  'uni-anatomy': _universityTree(
    'anatomy',
    <String>['normal', 'midTermRevision', 'finalRevision', 'practicalRevision'],
    <dynamic>[
      _lecture('anatomy-l1', 'المحاضرة الأولى: مقدمة', 44, 120),
      _lecture('anatomy-l2', 'المحاضرة الثانية: الأطراف العلوية', 120, 120),
      _lecture('anatomy-l3', 'المحاضرة الثالثة: الأطراف السفلية', 0, 90),
      _lecture('anatomy-l4', 'المحاضرة الرابعة: الصدر', 12, 70),
    ],
  ),
  // No practical component — the Practice tab must NOT appear here.
  'uni-physio': _universityTree(
    'physio',
    <String>['normal', 'midTermRevision', 'finalRevision'],
    <dynamic>[
      _lecture('physio-l1', 'المحاضرة الأولى: الدم', 80, 100),
      _lecture('physio-l2', 'المحاضرة الثانية: القلب', 100, 100),
      _lecture('physio-l3', 'المحاضرة الثالثة: الجهاز التنفسي', 60, 90),
    ],
  ),
  // Only one quiz type — the tab row degrades to a single tab.
  'uni-biochem': _universityTree(
    'biochem',
    <String>['normal'],
    <dynamic>[
      _lecture('biochem-l1', 'المحاضرة الأولى: البروتينات', 0, 0),
      _lecture('biochem-l2', 'المحاضرة الثانية: الإنزيمات', 5, 50),
      _lecture('biochem-l3', 'المحاضرة الثالثة: الكربوهيدرات', 25, 50),
    ],
  ),
  // No lectures published yet — the university EMPTY state.
  'uni-histology': _universityTree('histology', <String>[
    'normal',
    'finalRevision',
  ], <dynamic>[]),
};

// ---------------------------------------------------------------------------
// Quiz
// ---------------------------------------------------------------------------

/// The contract's free-plan cap: "Free plan: 50 questions/WEEK". The error code
/// is `weekly_question_limit_reached` — weekly, not daily, whatever the limit
/// frame says (docs/seif_fight.md S16).
const _kFreeWeeklyQuestions = 50;

/// 12 levels, 500 points apart. Mirrored here ONLY so the mock's `finish` can
/// move `level` truthfully when points cross a boundary; the app itself never
/// computes this — it renders `QuizSummary.level`.
int _levelFor(int totalPoints) => (totalPoints ~/ 500 + 1).clamp(1, 12);

/// How many questions a scope actually holds — read from the SAME
/// `questionCounter.total` the catalog handed the Learn screens, so a 422 never
/// contradicts the row the student just tapped.
int _poolSize(String? scopeId, {required bool isUniversity}) {
  if (scopeId == null) return 0;

  if (isUniversity) {
    for (final tree in _universitySubjectTrees.values) {
      for (final lecture
          in (tree['lectures']! as List<dynamic>)
              .cast<Map<String, dynamic>>()) {
        if (lecture['id'] == scopeId) {
          return (lecture['questionCounter']! as Map<String, dynamic>)['total']
              as int;
        }
      }
    }
    return 0;
  }

  for (final units in _subjectTrees.values) {
    for (final unit in units.cast<Map<String, dynamic>>()) {
      for (final chapter
          in (unit['chapters']! as List<dynamic>)
              .cast<Map<String, dynamic>>()) {
        for (final lesson
            in (chapter['lessons']! as List<dynamic>)
                .cast<Map<String, dynamic>>()) {
          if (lesson['id'] == scopeId) {
            return (lesson['questionCounter']! as Map<String, dynamic>)['total']
                as int;
          }
        }
      }
    }
  }
  return 0;
}

/// `Quiz.scopeName` — server copy, already in the content language. Looked up
/// from the same catalog data, so the quiz titles itself with the lesson name
/// the student tapped rather than an id.
String _scopeName(String? scopeId, {required bool isUniversity}) {
  if (scopeId == null) return 'مراجعة';

  if (isUniversity) {
    for (final tree in _universitySubjectTrees.values) {
      for (final lecture
          in (tree['lectures']! as List<dynamic>)
              .cast<Map<String, dynamic>>()) {
        if (lecture['id'] == scopeId) return lecture['name']! as String;
      }
    }
    return 'محاضرة';
  }

  for (final units in _subjectTrees.values) {
    for (final unit in units.cast<Map<String, dynamic>>()) {
      for (final chapter
          in (unit['chapters']! as List<dynamic>)
              .cast<Map<String, dynamic>>()) {
        for (final lesson
            in (chapter['lessons']! as List<dynamic>)
                .cast<Map<String, dynamic>>()) {
          if (lesson['id'] == scopeId) return lesson['name']! as String;
        }
      }
    }
  }
  return 'درس';
}

/// One live quiz, holding the thing the client is never sent: which option is
/// correct.
///
/// This is the whole reason the harness is stateful. If the correct option were
/// generated at answer time, a replay could grade differently and the
/// idempotency guarantee would be untestable on device.
class _MockQuiz {
  _MockQuiz({
    required this.id,
    required this.questions,
    required this.correctOption,
    required this.body,
  });

  /// Builds [length] questions. Every fourth carries an `imageUrl` so the
  /// "with photo" variant is reachable, and the correct option rotates so a
  /// student cannot pass by always tapping A.
  factory _MockQuiz.build({
    required String id,
    required String mode,
    required String? quizType,
    required String scopeName,
    required int length,
  }) {
    final questions = <Map<String, dynamic>>[];
    final correct = <String, String>{};

    for (var i = 1; i <= length; i++) {
      final questionId = '$id-q$i';
      final correctIndex = i % 4;
      correct[questionId] = '$questionId-o$correctIndex';
      questions.add(<String, dynamic>{
        'id': questionId,
        'order': i,
        'text':
            'السؤال $i: أي من الخيارات التالية يصف <u>التركيب</u> بشكل صحيح؟',
        // Every fourth question has a photo — the `159:1852` variant.
        'imageUrl': i % 4 == 0
            ? 'https://picsum.photos/seed/levelup-q$i/640/360'
            : null,
        'thumbnailUrl': null,
        'options': <dynamic>[
          for (var o = 0; o < 4; o++)
            <String, dynamic>{
              'id': '$questionId-o$o',
              'text': 'الخيار رقم ${o + 1} للسؤال $i',
            },
        ],
        // Parsed by the model, rendered nowhere — see CONFLICT 4 / S11. Varied
        // anyway so the field is not accidentally constant in the harness.
        'isFavorite': i % 5 == 0,
      });
    }

    return _MockQuiz(
      id: id,
      questions: questions,
      correctOption: correct,
      body: <String, dynamic>{
        'id': id,
        'mode': mode,
        // Null-aware element: the key is omitted entirely for a school quiz,
        // rather than sent as an explicit null.
        'quizType': ?quizType,
        'scopeName': scopeName,
        'questions': questions,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  final String id;
  final List<Map<String, dynamic>> questions;

  /// questionId → the correct optionId. Never serialized into [body].
  final Map<String, String> correctOption;
  final Map<String, dynamic> body;

  /// questionId → the optionId the student committed to.
  final answers = <String, String>{};

  bool finished = false;

  /// Cached so repeat `finish` calls replay the same summary, as the contract
  /// promises — and so points are awarded exactly once.
  Map<String, dynamic>? summary;

  /// Every third question has no explanation, so the app's "panel not offered"
  /// branch is reachable without waiting for a server that never says no.
  bool explanationAvailable(String questionId) {
    final index = questions.indexWhere((q) => q['id'] == questionId);
    return index >= 0 && (index + 1) % 3 != 0;
  }

  Map<String, dynamic> toJson() => body;
}

/// NOTE: these are remote URLs — the only thing in this harness that is not
/// offline. Nothing renders them today (the avatar grid was deliberately not
/// built), so the mock is still fully usable on a plane.
final _avatars = <dynamic>[
  for (var i = 1; i <= 6; i++)
    <String, dynamic>{
      'id': '0197b2f3-0008-7cc3-9b4e-${i.toString().padLeft(12, '0')}',
      'url': 'https://picsum.photos/seed/levelup$i/200',
    },
];

// ---------------------------------------------------------------------------
// StudentProfile
// ---------------------------------------------------------------------------

/// Echoes the submitted registration back as a `StudentProfile`, so what lands
/// on `/home` reflects what you actually typed.
/// The adr-028 §1 union, echoed back in the arm the registration actually used.
///
/// The coded arm is a full `NamedRef`; the free-text arm is `{ name }` and
/// carries NO id, which is the only thing `ProfileCity.fromJson` discriminates
/// on. Echoing a coded city for a free-text registration would make the union's
/// second arm unreachable on a device — the exact case that used to throw.
Map<String, dynamic> _cityFromRegistration(Map<String, dynamic> body) {
  final cityName = body['cityName'] as String?;
  if (cityName != null && cityName.isNotEmpty) {
    return <String, dynamic>{'name': cityName};
  }
  final cityId = body['cityId'] as String?;
  return cityId == null
      ? _codedCity
      : _named(cityId, 'مدينة مختارة', 'Selected City');
}

Map<String, dynamic> _profileFromRegistration(Map<String, dynamic> body) {
  final isUniversity = body['track'] == 'university';
  return _profile(
    track: isUniversity ? 'university' : 'school',
    name: body['name'] as String? ?? 'Mock Student',
    phone: '+201001234567',
    dateOfBirth: body['dateOfBirth'] as String? ?? '2008-01-01',
    countryCode: isUniversity ? 'EG' : (body['countryCode'] as String? ?? 'EG'),
    city: _cityFromRegistration(body),
    school: isUniversity
        ? null
        : <String, dynamic>{
            // Null when the student skipped it — Egypt included since
            // adr-028 §2. There is no `schoolName` counterpart any more.
            'school': body['schoolId'] == null
                ? null
                : _named(
                    body['schoolId']! as String,
                    'مدرسة مختارة',
                    'Selected School',
                  ),
            'stage': body['stage'] ?? 'secondary1',
            'educationSystem': body['educationSystem'] ?? 'nationalLanguages',
          },
    university: !isUniversity
        ? null
        : <String, dynamic>{
            'university': _named(
              body['universityId']! as String,
              'جامعة مختارة',
              'Selected University',
            ),
            'faculty': _named(
              body['facultyId']! as String,
              'كلية مختارة',
              'Selected Faculty',
            ),
            'yearNumber': 1,
          },
  );
}

/// The coded arm of the city union — a full `NamedRef`, the default for a
/// session that did not register (the magic OTP codes).
final _codedCity = _named(
  '0197b2f3-0002-7cc3-9b4e-000000000001',
  'مدينة نصر',
  'Nasr City',
);

Map<String, dynamic> _schoolProfile({
  required String phone,
  int totalPoints = 1250,
  Map<String, dynamic>? city,
}) => _profile(
  track: 'school',
  totalPoints: totalPoints,
  name: 'طالب تجريبي',
  phone: phone,
  dateOfBirth: '2008-05-14',
  countryCode: 'EG',
  city: city,
  school: <String, dynamic>{
    'school': _named(
      '0197b2f3-0004-7cc3-9b4e-000000000001',
      'مدرسة رقم ١',
      'Al Nasr Language School 1',
    ),
    'stage': 'secondary2',
    'educationSystem': 'nationalLanguages',
  },
  university: null,
);

/// The university counterpart — a first-year medical student. `school` is null
/// and the `university` block is populated, exactly as the contract specifies.
Map<String, dynamic> _universityProfile({
  required String phone,
  int totalPoints = 1250,
  Map<String, dynamic>? city,
}) => _profile(
  track: 'university',
  totalPoints: totalPoints,
  name: 'طالب جامعي تجريبي',
  phone: phone,
  dateOfBirth: '2005-03-02',
  countryCode: 'EG',
  city: city,
  school: null,
  university: <String, dynamic>{
    'university': _named(
      '0197b2f3-0005-7cc3-9b4e-000000000001',
      'جامعة القاهرة',
      'Cairo University',
    ),
    'faculty': _named(
      '0197b2f3-0006-7cc3-9b4e-000000000001',
      'كلية الطب البشري',
      'Faculty of Human Medicine',
    ),
    'yearNumber': 1,
  },
);

Map<String, dynamic> _profile({
  required String track,
  required String name,
  required String phone,
  required String dateOfBirth,
  required String countryCode,
  required Map<String, dynamic>? school,
  required Map<String, dynamic>? university,
  Map<String, dynamic>? city,
  int totalPoints = 1250,
}) {
  return <String, dynamic>{
    'id': '0197b2f3-9999-7cc3-9b4e-000000000001',
    'track': track,
    'name': name,
    'phone': phone,
    'email': null,
    'dateOfBirth': dateOfBirth,
    'avatar': <String, dynamic>{
      'type': 'default',
      'id': '0197b2f3-0008-7cc3-9b4e-000000000001',
      'url': 'https://picsum.photos/seed/levelup1/200',
    },
    'geography': <String, dynamic>{
      'countryCode': countryCode,
      'governorate': countryCode == 'EG' ? _egGovernorates.first : null,
      // adr-028 §1 union — a NamedRef when the student picked from the list,
      // `{ name }` when they used the "my city isn't listed" fallback.
      'city': city ?? _codedCity,
    },
    'school': school,
    'university': university,
    // Server-authoritative — the app must display these, never recompute them.
    // The pools are per-track (adr-003), so the points sit in the one the
    // student actually earns in; `total` is the server's own sum.
    //
    // [totalPoints] MOVES when a quiz is finished. That is what makes "finish
    // invalidates /me so Home shows the new points" something you can watch
    // happen on a device rather than something a test asserts in the dark.
    'points': <String, dynamic>{
      'school': track == 'school' ? totalPoints : 0,
      'university': track == 'university' ? totalPoints : 0,
      'total': totalPoints,
    },
    'level': _levelFor(totalPoints),
    'badges': 0,
    'privacy': <String, dynamic>{
      'leaderboardVisible': true,
      'scoreHidden': false,
    },
    'entitlements': _entitlements,
    'createdAt': '2026-07-26T10:00:00Z',
  };
}

/// Shared by the `/me` embed and `GET /me/entitlements` — the same student can't
/// have two different subscription truths depending on which call you made.
final _entitlements = <dynamic>[
  <String, dynamic>{
    'type': 'baseSubscription',
    'active': false,
    'expiresAt': null,
    'inGrace': false,
    'graceEndsAt': null,
  },
];
