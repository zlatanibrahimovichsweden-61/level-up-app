/// Throwaway on-device preview harness — NOT production code.
///
/// A hand-rolled Dio interceptor that answers the stable surface — `/auth/*`,
/// `/reference/*`, `/me` (read and `PATCH`), `/me/entitlements`,
/// `/me/mistakes*`, `/leaderboard`, `/catalog/*`, the quiz loop and the two
/// flashcards operations (`/flashcards/lectures/{id}/cards`,
/// `/flashcards/cards/{id}/self-grade`) — with contract-faithful canned JSON,
/// so the login → OTP → registration → Home → quiz walk can be driven on a real
/// device with no server and no network at all.
///
/// Deliberately hand-rolled rather than `http_mock_adapter`: adding a
/// dev_dependency would mean editing `pubspec.yaml`, and this harness is meant
/// to be 100% additive — two new files, zero edits to anything that ships.
///
/// Referenced ONLY by `lib/main_mock.dart`. Nothing under `lib/features` or
/// `lib/core` knows this file exists; injection happens through a single
/// `dioProvider` override in that entrypoint's `ProviderScope`.
///
/// Shapes are taken from `contract/openapi.yaml` (written against `f462968`,
/// v3.27.0-m1; the pin has moved since — `contract/SOURCE.md` names the
/// current one) so the canned JSON parses into the REAL freezed models — if a
/// model changes and the mock stops parsing, that is the harness doing its job.
///
/// The harness is deliberately STRICT where the server is strict, not merely
/// permissive: it rejects `schoolName` and both-cities the way the contract has
/// since v1.1.0-m1 (adr-028). A
/// mock that echoed whatever it was handed would let a device walkthrough
/// confirm the OLD contract.
library;

import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/interceptors/error_interceptor.dart';
import 'mock_deletion.dart';
import 'mock_friends.dart';
import 'mock_legal.dart';
import 'mock_notifications.dart';
import 'mock_quiz_history.dart';
import 'mock_recovery.dart';
import 'mock_support.dart';
import 'mock_terms.dart';

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

  /// Flashcards this student has been CHARGED for this week — the ids the free
  /// preview has already delivered. Each one paid a unit of
  /// [_questionsUsedThisWeek] once, on first delivery; from then on it
  /// re-delivers free, and it is also the only set of cards the student may
  /// grade (`setFlashcardSelfGrade` refuses everything else). In production the
  /// server keeps this per student per week; here it lives and dies with the
  /// interceptor, and no week ever rolls over.
  ///
  /// Never consulted for a subscriber: the mock student holds no
  /// `flashcardSubscription` (see [_entitlements]), so every read is a preview.
  final _flashcardsChargedThisWeek = <String>{};

  /// The student's LATEST self-grade per card id (`gotIt` / `again`) — latest
  /// wins, no history, exactly as the contract stores it. A card absent from
  /// here is `selfGrade: null`.
  final _flashcardGrades = <String, String>{};

  /// The `geography.city` this session registered with, in whichever arm of the
  /// adr-028 §1 union it used. Null until a registration happens, in which case
  /// `GET /me` falls back to the coded fixture.
  Map<String, dynamic>? _registeredCity;

  /// What `PATCH /me` changed, per track, so the school student's edits never
  /// show on the university student after a log-out → log-in. Only the keys
  /// the student actually sent are here, and a present `email: null` is a
  /// CLEARED address, not an absent one (the contract's tri-state). Emptied by
  /// a registration, which is a different student.
  final _profileEdits = <String, Map<String, Object?>>{};

  /// The Notifications inbox (CW07a): `GET /me/notifications` and
  /// `POST /me/notifications/{id}/read`. Its fixtures and rules live in
  /// `mock_notifications.dart`; read marks persist for this session.
  final _notifications = MockNotificationsInbox();

  /// The student's support tickets (CW12a): `GET`/`POST /support/tickets`,
  /// `GET /support/tickets/{id}` and `GET`/`POST /support/tickets/{id}/messages`.
  /// Fixtures and rules live in `mock_support.dart`; creates and replies persist
  /// for this session.
  final _support = MockSupportDesk();

  /// Account deletion (CW05): `POST`/`DELETE /me/deletion-request`, the
  /// `pendingDeletion` on `GET /me`, and the default-deny `403
  /// account_pending_deletion`. Dormant until a deletion is requested - see
  /// `mock_deletion.dart`.
  final _deletion = MockAccountDeletion();

  /// The lost-phone recovery ladder (CW06): the four `/auth/recovery/*`
  /// operations and the magic phones and codes that reach each branch. Rules
  /// and state live in `mock_recovery.dart`.
  final _recovery = MockRecoveryLadder();

  /// The caller's Terms acceptance (CW04b): `GET`/`POST
  /// /me/terms-acceptance`. Rules and state live in `mock_terms.dart`.
  final _terms = MockTermsAcceptance();

  /// The friend graph and reporting (CW09 data layer): the eleven friend-graph
  /// operations other than the phone lookup, plus `POST /student-reports`.
  /// Fixtures and rules live in `mock_friends.dart`; friendships, requests,
  /// blocks and reports persist for this session.
  final _friends = MockFriendsGraph();

  /// Quiz history, the quiz review, favourites and the Solved Questions
  /// number (CW16 data layer): `GET /quizzes`, `GET /quizzes/{id}`, `PUT`/
  /// `DELETE /questions/{id}/favorite`, `GET /me/favorites` and `GET
  /// /me/quiz-summary`. Fixtures and rules live in `mock_quiz_history.dart`;
  /// favourites persist for this session. Its quizzes are its own: a quiz
  /// finished through `POST /quizzes/{id}/finish` does not appear in it.
  final _quizHistory = MockQuizHistory();

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

    // ---- account deletion (CW05) ------------------------------------------
    // Both operations are `stable`. While a request is pending this also
    // answers `403 account_pending_deletion` for every authenticated call
    // outside the contract's four-endpoint allowlist; with nothing pending it
    // answers only the two operations and everything else falls through.
    final deletionReply = _deletion.handle(method, path);
    if (deletionReply != null) {
      switch (deletionReply) {
        case MockDeletionOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockDeletionProblem(:final status, :final code, :final detail):
          return _problem(handler, options, status, code, detail);
      }
    }

    // ---- lost-phone recovery (CW06) ---------------------------------------
    // The four operations are `stable` and anonymous. The success of the last
    // step needs the session's profile, which only this interceptor can build.
    final recoveryReply = _recovery.handle(method, path, body);
    if (recoveryReply != null) {
      switch (recoveryReply) {
        case MockRecoveryOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockRecoveryValidation(:final errors):
          return _validationFailed(handler, options, errors);
        case MockRecoveryProblem(:final status, :final code, :final detail):
          return _problem(handler, options, status, code, detail);
        case MockRecoveryAuthenticated(:final phone):
          return _ok(handler, options, 200, <String, dynamic>{
            'result': 'authenticated',
            'tokens': _tokenPair(),
            'profile': _isUniversity
                ? _universityProfile(phone: phone)
                : _schoolProfile(phone: phone),
          });
      }
    }

    // ---- terms acceptance (CW04b) -----------------------------------------
    final termsReply = _terms.handle(method, path, body);
    if (termsReply != null) {
      switch (termsReply) {
        case MockTermsOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockTermsValidation(:final errors):
          return _validationFailed(handler, options, errors);
      }
    }

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
      // The wrong-code path — `400 otp_invalid` per the contract's verifyOtp —
      // so the OTP error state (`82:1439` / `337:19284`) can be walked.
      if (code == _kInvalidCode) {
        return _problem(
          handler,
          options,
          400,
          'otp_invalid',
          'The code is incorrect.',
        );
      }
      // The banned path — `403 account_banned` per the contract's verifyOtp
      // (the code was correct, it is consumed, no tokens or session are
      // issued) — so the OTP screen's inline banned state can be walked.
      if (code == _kBannedCode) {
        return _problem(
          handler,
          options,
          403,
          'account_banned',
          'The account has been banned.',
        );
      }
      // The two magic codes land you straight on /home with a full session, one
      // per track; `999999` is the wrong code and `222222` the banned account
      // (both above); every other 6-digit code forks to registration so the
      // wizard can be walked.
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
      _profileEdits.remove(_track);

      // spec-047: `inviteCodeApplied` rides the 201 only when the request
      // carried an `inviteCode`, and it never says why a code was not used.
      // The contract ignores case, spaces and hyphens, so this does too. The
      // ONE code the mock "recognises" is `ABCD2345` (eight characters from the
      // contract's `MyInvite.code` alphabet); every other code answers
      // `false`, and neither answer ever fails the registration.
      const recognisedInviteCode = 'ABCD2345';
      final sentInviteCode = body['inviteCode'];
      return _ok(handler, options, 201, <String, dynamic>{
        'result': 'authenticated',
        'tokens': _tokenPair(),
        'profile': _profileFromRegistration(body),
        if (sentInviteCode is String)
          'inviteCodeApplied':
              sentInviteCode.replaceAll(RegExp(r'[\s-]'), '').toUpperCase() ==
              recognisedInviteCode,
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
      return _ok(
        handler,
        options,
        200,
        _deletion.decorateProfile(_currentProfile()),
      );
    }

    // `updateMyProfile` (API→UI Wave 20). Contract-shaped: every field is
    // optional and an absent key is unchanged; `email: null` CLEARS the
    // address; a violation is `400 validation_failed` with the field map; the
    // answer is the updated profile, and a later `GET /me` agrees with it.
    //
    // **Trigger for the 400 arm:** save an e-mail that is not an address (no
    // `@`, or no dot after it). That is the contract's own `format: email`, so
    // it is what the real server rejects, not an invented magic value.
    if (method == 'PATCH' && path == '/me') {
      final rejected = _profilePatchViolations(body);
      if (rejected != null) {
        return _validationFailed(handler, options, rejected);
      }
      final edits = _profileEdits.putIfAbsent(
        _track,
        () => <String, Object?>{},
      );
      for (final key in _patchableProfileKeys) {
        if (body.containsKey(key)) edits[key] = body[key];
      }
      return _ok(handler, options, 200, _currentProfile());
    }

    if (method == 'GET' && path == '/me/entitlements') {
      return _ok(handler, options, 200, <String, dynamic>{
        'items': _entitlements,
      });
    }

    // ---- notifications inbox (CW07a) --------------------------------------
    // Both operations are `stable`; the data and the contract's rules (paging,
    // `limit`/`category`/`cursor` validation, idempotent read, 404) are in
    // `mock_notifications.dart`. `GET /me/notifications/unread-count` is not
    // served - the app does not call it yet - so it falls through to the
    // generic 404 below.
    final notificationsReply = _notifications.handle(method, path, query);
    if (notificationsReply != null) {
      switch (notificationsReply) {
        case MockNotificationsOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockNotificationsValidation(:final errors):
          return _validationFailed(handler, options, errors);
        case MockNotificationsProblem(
          :final status,
          :final code,
          :final detail,
        ):
          return _problem(handler, options, status, code, detail);
      }
    }

    // ---- support tickets (CW12a) ------------------------------------------
    // The five text-only operations are `stable`; the data and the contract's
    // rules (paging, cursor validation, create limits and the daily 429, the
    // closed-ticket 409, 404 for an unknown id) are in `mock_support.dart`.
    // `/support/attachments*` (photos, CW12b) is not served and falls through
    // to the generic 404 below.
    final supportReply = _support.handle(method, path, query, body);
    if (supportReply != null) {
      switch (supportReply) {
        case MockSupportOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockSupportValidation(:final errors):
          return _validationFailed(handler, options, errors);
        case MockSupportProblem(
          :final status,
          :final code,
          :final detail,
          :final retryAfterSeconds,
        ):
          return _problem(
            handler,
            options,
            status,
            code,
            detail,
            headers: retryAfterSeconds == null
                ? null
                : <String, List<String>>{
                    'retry-after': ['$retryAfterSeconds'],
                  },
          );
      }
    }

    // ---- friend graph + reporting (CW09 data layer) -----------------------
    // Twelve operations, all `stable`; the data and the contract's rules
    // (paging, the bounded suggestions, one 404 for many causes, the two write
    // budgets) are in `mock_friends.dart`. `POST /friends/phone-lookup` is NOT
    // served (DR-08) and falls through to the generic 404 below.
    final friendsReply = _friends.handle(method, path, query, body);
    if (friendsReply != null) {
      switch (friendsReply) {
        case MockFriendsOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockFriendsValidation(:final errors):
          return _validationFailed(handler, options, errors);
        case MockFriendsProblem(
          :final status,
          :final code,
          :final detail,
          :final retryAfterSeconds,
        ):
          return _problem(
            handler,
            options,
            status,
            code,
            detail,
            headers: retryAfterSeconds == null
                ? null
                : <String, List<String>>{
                    'retry-after': ['$retryAfterSeconds'],
                  },
          );
      }
    }

    // ---- quiz history, review, favourites, solved count (CW16a/b) ----------
    // Six `stable` operations; the data and the contract's rules (started-order
    // paging, `limit`/`cursor` validation, the two 403s on a review, idempotent
    // 204 favourites) are in `mock_quiz_history.dart`. `POST /quizzes` and the
    // rest of the quiz engine are not its routes and are handled further down.
    final quizHistoryReply = _quizHistory.handle(method, path, query);
    if (quizHistoryReply != null) {
      switch (quizHistoryReply) {
        case MockQuizHistoryOk(:final status, :final data):
          return _ok(handler, options, status, data);
        case MockQuizHistoryValidation(:final errors):
          return _validationFailed(handler, options, errors);
        case MockQuizHistoryProblem(:final status, :final code, :final detail):
          return _problem(handler, options, status, code, detail);
      }
    }

    // ---- leaderboard ------------------------------------------------------
    // `GET /leaderboard` — `x-stability: stable` at the 3.22.0-m1 pin
    // (`openapi.yaml:2007`), route deployed on staging (probed 2026-09-22, it
    // answers 401 rather than the 404 an absent route gives) and decoding
    // verified there through the real repository. This harness stands in for
    // the DATA, not for the endpoint: the one staging test account is alone on
    // its board, so a one-row page is all a real server can show and none of
    // the podium, the paging or the self-row highlight is reachable.
    //
    // `GET /leaderboard/me` is deliberately NOT served, because the app
    // deliberately does not call it (D-008; `openapi.yaml:2050` forbids a
    // synthetic self-rank row). A route here would invite one.
    //
    // Strict where the server is strict, per this file's own rule:
    //   * `scope` is REQUIRED and track-checked — a university scope on a
    //     school account is `400 validation_failed` on field `scope`, which is
    //     what the server answers and what `scopesFor` exists to prevent.
    //   * `limit` is VALIDATED, NOT CLAMPED (3.7.0-m1) — outside 1..100 is a
    //     400 on field `limit`, never a quiet reduction to 100.
    //   * `cursor` is opaque and scope-bound; an unknown one is `400
    //     validation_failed` on field `cursor`, so the notifier's
    //     expired-cursor -> page-one recovery is reachable on a device.
    if (method == 'GET' && path == '/leaderboard') {
      final scope = query['scope'] as String?;
      final allowed = _isUniversity
          ? const ['global', 'cohort']
          : const ['system', 'governorate'];
      if (scope == null || !allowed.contains(scope)) {
        return _validationFailed(handler, options, {
          'scope': ['Must be valid for the caller\'s track.'],
        });
      }
      final rawLimit = query['limit'];
      final limit = rawLimit == null
          ? 20
          : int.tryParse(rawLimit.toString()) ?? -1;
      if (limit < 1 || limit > 100) {
        return _validationFailed(handler, options, {
          'limit': ['Must be between 1 and 100.'],
        });
      }

      // The whole board, dense-ranked. Built fresh per request so the caller's
      // row carries the LIVE `_totalPoints` and moves up the board when a quiz
      // is finished — the same thing Home does, on a surface where it is far
      // more visible.
      final board = _leaderboard(
        isUniversity: _isUniversity,
        selfPoints: _totalPoints,
      );

      final cursor = query['cursor'] as String?;
      var start = 0;
      if (cursor != null) {
        final parsed = _decodeMockCursor(cursor, scope);
        if (parsed == null) {
          return _validationFailed(handler, options, {
            'cursor': ['Altered, expired, or issued for another scope.'],
          });
        }
        start = parsed;
      }
      if (start >= board.length) start = board.length;
      final end = (start + limit).clamp(0, board.length);
      final page = board.sublist(start, end);
      final hasMore = end < board.length;

      return _ok(handler, options, 200, <String, dynamic>{
        'items': page,
        'nextCursor': hasMore ? _encodeMockCursor(end, scope) : null,
        'hasMore': hasMore,
      });
    }

    // ---- mistakes ---------------------------------------------------------
    // Day 10's two operations, both `stable` at the 3.13.0-m1 pin.
    //
    // They are served here because they cannot be driven with real data: the
    // only staging test account has an empty catalog (seif_fight.md S44), so
    // both operations answer empty there regardless of deployment. Both routes
    // ARE deployed on staging - probed 2026-09-12, they answer 401 rather than
    // the 404 an absent route gives - so this harness stands in for the DATA,
    // not for the endpoints.
    if (method == 'GET' && path == '/me/mistakes') {
      return _ok(
        handler,
        options,
        200,
        _isUniversity ? _universityMistakes : _schoolMistakes,
      );
    }

    final mistakesTree = RegExp(
      r'^/me/mistakes/subjects/([^/]+)$',
    ).firstMatch(path);
    if (method == 'GET' && mistakesTree != null) {
      final subjectId = mistakesTree.group(1)!;

      // `insufficient_scope` carries TWO meanings behind one code string, and
      // the route decides which copy is shown. This is the subject-level one -
      // "not yours", no retry. The overview's enrolment-pending reading is the
      // other, and is not reachable from here.
      if (subjectId == 'sub-locked' || subjectId == 'uni-locked') {
        return _problem(
          handler,
          options,
          403,
          'insufficient_scope',
          'This subject is not in your scope.',
        );
      }

      return _ok(
        handler,
        options,
        200,
        _isUniversity
            ? _universityMistakesTrees[subjectId] ?? _emptyUniversityTree
            : _schoolMistakesTrees[subjectId] ?? _emptySchoolTree,
      );
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

    // ---- flashcards -------------------------------------------------------
    // The two `stable` Flashcards operations (spec-028), university track only.
    // STATEFUL for the same reason the quiz is: the free preview charges the
    // SAME weekly allowance quizzes draw from, a charged card re-delivers free,
    // and a grade is echoed back on the next read - none of which a canned
    // response could show. Trigger table on [_flashcardsForLecture].
    final flashcardCards = RegExp(
      r'^/flashcards/lectures/([^/]+)/cards$',
    ).firstMatch(path);
    if (method == 'GET' && flashcardCards != null) {
      return _flashcardsForLecture(
        handler,
        options,
        flashcardCards.group(1)!,
        query,
      );
    }

    final flashcardGrade = RegExp(
      r'^/flashcards/cards/([^/]+)/self-grade$',
    ).firstMatch(path);
    if (method == 'PUT' && flashcardGrade != null) {
      return _setFlashcardSelfGrade(
        handler,
        options,
        flashcardGrade.group(1)!,
        body,
      );
    }

    // ---- legal documents (CW04a) ------------------------------------------
    // `getLegalDocument` is `stable` and public. The labelled layout sample —
    // NOT legal text — and the contract's 400 are in `mock_legal.dart`.
    switch (const MockLegalDocuments().handle(method, path, query)) {
      case MockLegalOk(:final data):
        return _ok(handler, options, 200, data);
      case MockLegalValidation(:final errors):
        return _validationFailed(handler, options, errors);
      case null:
        break;
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

  /// This session's student as `GET /me` returns them: the LIVE total, which
  /// `finish` moves (so re-fetching after a quiz shows the award, exactly as it
  /// will in production), the registered city, and whatever `PATCH /me` changed.
  Map<String, dynamic> _currentProfile() {
    // The staging smoke account: eleven digits after +20, so no real Egyptian
    // mobile can have it (N-26 — the old sample here was a real number).
    const phone = '+2010000000001';
    final profile = _isUniversity
        ? _universityProfile(
            phone: phone,
            totalPoints: _totalPoints,
            city: _registeredCity,
          )
        : _schoolProfile(
            phone: phone,
            totalPoints: _totalPoints,
            city: _registeredCity,
          );
    final edits = _profileEdits[_track];
    if (edits == null) return profile;

    if (edits.containsKey('name')) profile['name'] = edits['name'];
    // Present-and-null is a cleared address, so this copies the null too.
    if (edits.containsKey('email')) profile['email'] = edits['email'];
    if (edits.containsKey('avatarId')) {
      final avatar = _avatars.cast<Map<String, dynamic>>().firstWhere(
        (a) => a['id'] == edits['avatarId'],
      );
      profile['avatar'] = <String, dynamic>{
        'type': 'default',
        'id': avatar['id'],
        'url': avatar['url'],
      };
    }
    final privacy = Map<String, dynamic>.from(profile['privacy'] as Map);
    for (final key in const ['leaderboardVisible', 'scoreHidden']) {
      if (edits.containsKey(key)) privacy[key] = edits[key];
    }
    profile['privacy'] = privacy;
    return profile;
  }

  /// The `PATCH /me` body's violations, as the contract's field map, or null.
  ///
  /// Only what the contract states: `name` is a string of at most 100
  /// characters, `email` is an address or null, the toggles are booleans.
  /// `avatarId` must be one of `GET /reference/avatars` (a closed set); whether
  /// the real server answers an unknown id with this 400 or with a 404 is open
  /// (`seif_fight.md` S45). The app cannot send one: it picks from that list.
  Map<String, List<String>>? _profilePatchViolations(
    Map<String, dynamic> body,
  ) {
    final errors = <String, List<String>>{};
    if (body.containsKey('name')) {
      final name = body['name'];
      if (name is! String || name.runes.length > 100) {
        errors['name'] = ['At most 100 characters'];
      }
    }
    if (body.containsKey('email')) {
      final email = body['email'];
      if (email != null && (email is! String || !_emailShape.hasMatch(email))) {
        errors['email'] = ['Not a valid email address'];
      }
    }
    if (body.containsKey('avatarId') &&
        !_avatars.cast<Map<String, dynamic>>().any(
          (a) => a['id'] == body['avatarId'],
        )) {
      errors['avatarId'] = ['Not one of the default avatars'];
    }
    for (final key in const ['leaderboardVisible', 'scoreHidden']) {
      if (body.containsKey(key) && body[key] is! bool) {
        errors[key] = ['Must be true or false'];
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
  ///
  /// 3.0.0-m1 (adr-102): the summary carries no `totalPoints` or `level` —
  /// those are state and are read from `GET /me`, which is why `_totalPoints`
  /// still moves here. `leveledUp` is the frozen event the contract keeps.
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

  /// `GET /flashcards/lectures/{lectureId}/cards` → `200 CursorPage` of
  /// `FlashcardCard`, or one of the failures below.
  ///
  /// **Trigger table — how to reach each outcome on a device:**
  ///
  /// | Outcome | How to reach it |
  /// |---|---|
  /// | `200`, full round | any lecture with cards, e.g. **المحاضرة الأولى: مقدمة** (24 cards: rounds of 10 / 10 / 4) |
  /// | `200`, empty | a lecture with no cards, e.g. **المحاضرة الثالثة: الجهاز التنفسي** — `items: []`, `hasMore: false`, and never a subscription refusal |
  /// | `200`, SHORT round with `hasMore: true` | spend the allowance to a figure that is not a multiple of the round: a 30-question and a 10-question quiz, then the 4-card **المحاضرة الثالثة: الأطراف السفلية** (44 used), then open the 24-card lecture — its first round holds only 6 cards |
  /// | `403 flashcard_subscription_required` | once 50 units are used, open any lecture you have not already been shown cards of |
  /// | `403 insufficient_scope` | the School track, or an id that names no lecture of the University catalog — one indistinguishable body |
  /// | `400 validation_failed` | `pageSize` outside 1..50, or a `cursor` that was altered or issued for another lecture (the app sends neither; tests do) |
  ///
  /// Everything here is a rule the REAL server applies (`openapi.yaml`,
  /// `getFlashcardsForLecture`):
  ///
  ///  * The mock student holds no `flashcardSubscription`, so every read is the
  ///    weekly PREVIEW: each card not already charged this week costs one unit
  ///    of the SAME allowance quizzes spend ([_questionsUsedThisWeek], cap
  ///    [_kFreeWeeklyQuestions]) — one allowance across both surfaces.
  ///  * A charged card re-delivers free, so paging back and forth never costs
  ///    twice, and a page made only of charged cards is delivered in full at
  ///    zero allowance.
  ///  * A page may come back SHORTER than `pageSize` and still not be the end:
  ///    the affordable PREFIX is delivered (it stops at the first card that
  ///    cannot be paid for), `hasMore` is true and `nextCursor` points at the
  ///    first card NOT delivered. Branch on `hasMore`, never on `items.length`.
  ///  * When ZERO cards of a non-empty page can be delivered the answer is `403
  ///    flashcard_subscription_required`, not an empty page - an empty `items`
  ///    means the lecture genuinely has no cards.
  ///  * `insufficient_scope` is byte-identical for every cause
  ///    ([_flashcardsOutOfScope]), and is decided BEFORE the query is looked at,
  ///    so a refused caller learns nothing from what a malformed query returns.
  void _flashcardsForLecture(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String lectureId,
    Map<String, dynamic> query,
  ) {
    if (!_isUniversity || !_isUniversityLecture(lectureId)) {
      return _flashcardsOutOfScope(handler, options);
    }
    final cards = _lectureFlashcards[lectureId] ?? const [];

    // Validated, not clamped - the same rule `/leaderboard` follows for `limit`.
    final rawPageSize = query['pageSize'];
    final pageSize = rawPageSize == null
        ? _kFlashcardsDefaultPageSize
        : int.tryParse(rawPageSize.toString()) ?? -1;
    if (pageSize < 1 || pageSize > _kFlashcardsMaxPageSize) {
      return _validationFailed(handler, options, {
        'pageSize': ['Must be between 1 and $_kFlashcardsMaxPageSize.'],
      });
    }

    // The cursor is bound to its lecture, so one issued for another lecture is
    // as unusable as an altered one - the contract's "malformed or foreign".
    final cursor = query['cursor'] as String?;
    var start = 0;
    if (cursor != null) {
      final parsed = _decodeMockCursor(cursor, lectureId);
      if (parsed == null || parsed < 0 || parsed > cards.length) {
        return _validationFailed(handler, options, {
          'cursor': ['Altered, expired, or issued for another lecture.'],
        });
      }
      start = parsed;
    }

    final end = (start + pageSize).clamp(0, cards.length);
    final delivered = <Map<String, dynamic>>[];
    for (final card in cards.sublist(start, end)) {
      final id = card['id']! as String;
      if (!_flashcardsChargedThisWeek.contains(id)) {
        // The prefix ends at the first card the allowance cannot pay for, even
        // if a later one on this page would have been free.
        if (_questionsUsedThisWeek >= _kFreeWeeklyQuestions) break;
        _flashcardsChargedThisWeek.add(id);
        _questionsUsedThisWeek++;
      }
      delivered.add(<String, dynamic>{
        ...card,
        'selfGrade': _flashcardGrades[id],
      });
    }

    if (delivered.isEmpty && end > start) {
      return _problem(
        handler,
        options,
        403,
        'flashcard_subscription_required',
        'The free weekly flashcard preview is used up',
      );
    }

    final next = start + delivered.length;
    final hasMore = next < cards.length;
    return _ok(handler, options, 200, <String, dynamic>{
      'items': delivered,
      'nextCursor': hasMore ? _encodeMockCursor(next, lectureId) : null,
      'hasMore': hasMore,
    });
  }

  /// `PUT /flashcards/cards/{flashcardId}/self-grade` → `204`, no body.
  ///
  /// Stores the student's LATEST grade for the card and nothing else: no
  /// history, no score, no schedule. Idempotent by construction - the same
  /// value twice is `204` both times.
  ///
  /// **Same gate as the card list**: the card must be one the student could be
  /// delivered right now, which for this mock student (no subscription) means
  /// one already CHARGED this week. Everything else - the School track, an id
  /// that names no card, and a real card that was never shown to them - is the
  /// same byte-identical `403 insufficient_scope`, and never
  /// `flashcard_subscription_required`: grading a card you were not shown has
  /// exhausted nothing, so offering a subscription would be false and would
  /// confirm the card exists.
  ///
  /// The `400 validation_failed` on field `grade` (missing, or not one of
  /// `gotIt` / `again`) is checked AFTER the gate, so a caller who may not touch
  /// the card learns nothing about it from which refusal they get. The app
  /// cannot send a bad grade - it encodes the closed enum - so only a test does.
  void _setFlashcardSelfGrade(
    RequestInterceptorHandler handler,
    RequestOptions options,
    String flashcardId,
    Map<String, dynamic> body,
  ) {
    if (!_isUniversity || !_flashcardsChargedThisWeek.contains(flashcardId)) {
      return _flashcardsOutOfScope(handler, options);
    }

    final grade = body['grade'];
    if (grade is! String || !_kFlashcardGrades.contains(grade)) {
      return _validationFailed(handler, options, {
        'grade': ['Must be one of ${_kFlashcardGrades.join(', ')}.'],
      });
    }

    _flashcardGrades[flashcardId] = grade;
    return _ok(handler, options, 204, null);
  }

  /// The flashcards `403 insufficient_scope`, the SAME body for every cause: the
  /// School track, another cohort's lecture, an unreleased term, an id that
  /// names nothing, and (grading only) a card never shown to the caller.
  ///
  /// The contract makes them "deliberately indistinguishable, permanently", so
  /// the detail here echoes no id and names no cause. A mock that answered them
  /// differently would let a device walk build the existence probe the contract
  /// forbids.
  void _flashcardsOutOfScope(
    RequestInterceptorHandler handler,
    RequestOptions options,
  ) => _problem(
    handler,
    options,
    403,
    'insufficient_scope',
    'Flashcards are not available for this request',
  );

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

/// Enter this at the OTP screen to get `400 otp_invalid` — the wrong-code state.
const _kInvalidCode = '999999';

/// Enter this at the OTP screen to get `403 account_banned` — the banned
/// account's sign-in, which the contract refuses only after a correct code.
const _kBannedCode = '222222';

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

/// `hasFlashcards` and `flashcardCount` are both contract-REQUIRED on this
/// object (`openapi.yaml:2891`), so both are always emitted, and
/// `hasFlashcards` is derived as the contract defines it: exactly
/// `flashcardCount > 0`. The count varies per lecture below for the same reason
/// `quizTypes` varies per subject: it decides whether an affordance is drawn,
/// and a mock that answered one value everywhere could never catch a surface
/// that ignores it. Content presence, never subscription state — a count is
/// correct for a free student too.
///
/// The count is DERIVED from [_lectureFlashcards] (a lecture with no deck has
/// none), never written beside the lecture: the tree and the cards the
/// flashcards arms serve therefore cannot disagree, which is the one
/// contradiction a device walk would otherwise expose as a setup screen
/// promising 24 cards and a round delivering 10.
Map<String, dynamic> _lecture(String id, String name, int answered, int total) {
  final flashcardCount = _lectureFlashcards[id]?.length ?? 0;
  return <String, dynamic>{
    'id': id,
    'name': name,
    'questionCounter': _counter(answered, total),
    'hasFlashcards': flashcardCount > 0,
    'flashcardCount': flashcardCount,
  };
}

/// Whether [lectureId] names a lecture of the mock's University catalog - the
/// one authority on which lecture ids exist. Walks the same
/// [_universitySubjectTrees] the Learn tab was handed, so a lecture is known to
/// the flashcards arms exactly when the student could have tapped it.
bool _isUniversityLecture(String lectureId) => _universitySubjectTrees.values
    .expand((tree) => (tree['lectures']! as List<dynamic>))
    .cast<Map<String, dynamic>>()
    .any((lecture) => lecture['id'] == lectureId);

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
      // 24 cards = three rounds of 10 / 10 / 4; 10 = exactly one round; 4 =
      // a short round; 1 = a single card.
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
      // A subject where SOME lectures have flashcards: physio-l3 has none,
      // so the Flashcard tab lists two of the three lectures.
      _lecture('physio-l1', 'المحاضرة الأولى: الدم', 80, 100),
      _lecture('physio-l2', 'المحاضرة الثانية: القلب', 100, 100),
      _lecture('physio-l3', 'المحاضرة الثالثة: الجهاز التنفسي', 60, 90),
    ],
  ),
  // Only one quiz type — the tab row degrades to a single tab. Also the
  // subject with NO flashcard content at all: the contract's "a faculty whose
  // whole tree returns `false` everywhere has no flashcard content, and the
  // surface should not be offered at all" case, which needs a subject to be
  // reachable on device.
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
// Flashcards - GET /flashcards/lectures/{id}/cards, PUT .../self-grade
// ---------------------------------------------------------------------------

/// `getFlashcardsForLecture`'s default `pageSize` (`openapi.yaml`, schema
/// `default: 20`) and its maximum - **50, not the shared `Limit`'s 100**.
const _kFlashcardsDefaultPageSize = 20;
const _kFlashcardsMaxPageSize = 50;

/// `FlashcardSelfGrade` - a CLOSED set of exactly two values.
const _kFlashcardGrades = {'gotIt', 'again'};

/// One deck of cards, ids minted from the lecture's own id and the card's
/// 1-based position (`anatomy-l1-c01`) - readable and stable, like the mock's
/// lecture ids. `imageUrl` is `null` on every card: the contract says `null` is
/// the answer in every environment today (no card-image CDN is provisioned) and
/// that it is not an error. `selfGrade` is deliberately absent - it is a
/// property of the READER and is stitched on at delivery time.
List<Map<String, dynamic>> _deck(
  String lectureId,
  List<(String, String)> cards,
) => <Map<String, dynamic>>[
  for (var i = 0; i < cards.length; i++)
    <String, dynamic>{
      'id': '$lectureId-c${(i + 1).toString().padLeft(2, '0')}',
      'front': cards[i].$1,
      'back': cards[i].$2,
      'imageUrl': null,
    },
];

/// The cards each lecture holds, keyed by lecture id - the ONE source of truth
/// for how many cards a lecture has: [_lecture] derives `flashcardCount` from
/// the length of these lists, so the catalog and the flashcards arms cannot
/// disagree. A lecture absent here is a real lecture with no cards
/// (`physio-l3`, all of `uni-biochem`), which is `200` with `items: []`.
///
/// The deck is written to exercise the shapes the study surface must render,
/// not just to fill the counts:
///  * `anatomy-l1-c06`, `-c14`, `-c15`, `anatomy-l2-c05` and `physio-l1-c07`
///    carry a MULTI-LINE `back` holding several answers - the contract says to
///    render `back` as a block, not as a single label;
///  * `anatomy-l1-c12` has a long `front` (about three lines on a phone);
///  * `anatomy-l1-c13`, `anatomy-l1-c14` and `physio-l1-c08` are Arabic on both
///    sides, so the RTL card face is reachable.
final _lectureFlashcards = <String, List<Map<String, dynamic>>>{
  // 24 cards = rounds of 10 / 10 / 4.
  'anatomy-l1': _deck('anatomy-l1', <(String, String)>[
    (
      'Describe the anatomical position.',
      'Standing upright and facing forward, feet together and flat on the '
          'floor, arms at the sides with the palms facing forward.',
    ),
    (
      'Which plane divides the body into right and left parts?',
      'The sagittal plane. The median (midsagittal) plane passes through the '
          'midline and divides the body into equal right and left halves.',
    ),
    (
      'Which plane divides the body into anterior and posterior parts?',
      'The coronal (frontal) plane.',
    ),
    (
      'Which plane divides the body into superior and inferior parts?',
      'The transverse (horizontal or axial) plane.',
    ),
    (
      'What does "proximal" mean?',
      'Nearer to the trunk or to the point of attachment of a limb. The '
          'opposite is distal.',
    ),
    (
      'Name the four quadrants of the abdomen.',
      'Right upper quadrant\n'
          'Left upper quadrant\n'
          'Right lower quadrant\n'
          'Left lower quadrant',
    ),
    (
      'Define "superficial" and "deep".',
      'Superficial means nearer to the surface of the body; deep means '
          'farther from the surface.',
    ),
    (
      'What is the difference between ipsilateral and contralateral?',
      'Ipsilateral refers to the same side of the body; contralateral refers '
          'to the opposite side.',
    ),
    (
      'Which movement decreases the angle between two bones at a joint?',
      'Flexion. Extension increases the angle.',
    ),
    (
      'What is abduction?',
      'Movement of a limb away from the median plane of the body. Adduction '
          'is movement toward it.',
    ),
    (
      'Which movement turns the palm to face anteriorly?',
      'Supination. Pronation turns the palm to face posteriorly.',
    ),
    (
      'A patient stands with the feet together, the arms at the sides and '
          'the palms forward. Which reference position is this, and why is '
          'it used?',
      'The anatomical position. Describing every structure against one agreed '
          'posture removes any doubt about terms such as anterior, posterior, '
          'left and right, whatever position the patient is actually in.',
    ),
    (
      'ما هو الوضع التشريحي؟',
      'وقوف الجسم منتصبًا مع النظر إلى الأمام، والذراعان بجانب الجسم، '
          'وراحتا اليدين إلى الأمام.',
    ),
    (
      'ما هي المستويات الثلاثة الرئيسية التي تقسم الجسم؟',
      'المستوى السهمي\n'
          'المستوى الإكليلي (الجبهي)\n'
          'المستوى المستعرض (الأفقي)',
    ),
    (
      'Name the four basic tissue types.',
      '1. Epithelial tissue\n'
          '2. Connective tissue\n'
          '3. Muscle tissue\n'
          '4. Nervous tissue',
    ),
    (
      'What are the two divisions of the skeleton?',
      'The axial skeleton (skull, vertebral column, ribs and sternum) and '
          'the appendicular skeleton (the limbs and their girdles).',
    ),
    ('How many bones are in the adult human skeleton?', '206.'),
    (
      'Which type of joint is the shoulder?',
      'A ball-and-socket synovial joint.',
    ),
    (
      'What is the function of articular cartilage?',
      'It covers the articulating surfaces of bones in synovial joints, '
          'reducing friction and absorbing load.',
    ),
    (
      'What connects muscle to bone?',
      'Tendons. Ligaments connect bone to bone.',
    ),
    (
      'Which body cavity contains the heart and lungs?',
      'The thoracic cavity. The heart lies in the mediastinum; each lung lies '
          'in its own pleural cavity.',
    ),
    (
      'Which membrane lines the abdominal cavity?',
      'The peritoneum: the parietal layer lines the wall of the cavity and '
          'the visceral layer covers the organs.',
    ),
    (
      'What does "lateral" mean?',
      'Away from the median plane, toward the side of the body. Medial means '
          'nearer to the median plane.',
    ),
    (
      'Name the two types of bone tissue.',
      'Compact (cortical) bone and spongy (cancellous or trabecular) bone.',
    ),
  ]),
  // 10 cards = exactly one round.
  'anatomy-l2': _deck('anatomy-l2', <(String, String)>[
    ('Which bone forms the skeleton of the arm?', 'The humerus.'),
    (
      'Name the two bones of the forearm.',
      'The radius (lateral) and the ulna (medial).',
    ),
    (
      'Which nerve is compressed in carpal tunnel syndrome?',
      'The median nerve.',
    ),
    (
      'Which nerve runs in the groove behind the medial epicondyle of the '
          'humerus?',
      'The ulnar nerve, which causes the tingling of the "funny bone".',
    ),
    (
      'Name the four rotator cuff muscles.',
      'Supraspinatus\n'
          'Infraspinatus\n'
          'Teres minor\n'
          'Subscapularis',
    ),
    (
      'Which muscle is the main flexor of the elbow?',
      'Brachialis. Biceps brachii and brachioradialis assist it.',
    ),
    (
      'Which muscle abducts the arm from 15 to 90 degrees?',
      'The deltoid. The supraspinatus initiates the first 15 degrees.',
    ),
    (
      'How many carpal bones are there?',
      'Eight, arranged in two rows of four.',
    ),
    (
      'Which artery becomes the brachial artery at the lower border of teres '
          'major?',
      'The axillary artery.',
    ),
    (
      'Which nerve supplies the extensor muscles of the arm and forearm?',
      'The radial nerve.',
    ),
  ]),
  // 4 cards = a short round.
  'anatomy-l3': _deck('anatomy-l3', <(String, String)>[
    ('Which is the longest bone in the body?', 'The femur.'),
    (
      'Name the two bones of the leg.',
      'The tibia (medial, weight-bearing) and the fibula (lateral).',
    ),
    (
      'Which is the largest nerve in the body, supplying the hamstrings?',
      'The sciatic nerve.',
    ),
    (
      'Which ligaments stop the tibia sliding on the femur?',
      'The cruciate ligaments. The anterior cruciate ligament resists forward '
          'sliding of the tibia; the posterior cruciate ligament resists '
          'backward sliding.',
    ),
  ]),
  // 1 card = a single-card round.
  'anatomy-l4': _deck('anatomy-l4', <(String, String)>[
    (
      'How many pairs of ribs are there, and which are true ribs?',
      'Twelve pairs. Ribs 1 to 7 are true ribs (attached directly to the '
          'sternum), ribs 8 to 10 are false ribs and ribs 11 and 12 are '
          'floating ribs.',
    ),
  ]),
  // 12 cards = a full round of 10 and a short one of 2.
  'physio-l1': _deck('physio-l1', <(String, String)>[
    (
      'What is the normal hematocrit range in an adult?',
      'Roughly 40 to 50 percent; slightly higher in men than in women.',
    ),
    (
      'Name the main components of blood plasma.',
      'Water (about 90 percent), plasma proteins (albumin, globulins, '
          'fibrinogen), electrolytes, nutrients, hormones and waste products.',
    ),
    ('Which plasma protein contributes most to oncotic pressure?', 'Albumin.'),
    (
      'Where are red blood cells produced in the adult?',
      'In the red bone marrow, stimulated by erythropoietin from the kidney.',
    ),
    ('What is the average lifespan of a red blood cell?', 'About 120 days.'),
    (
      'Which hormone regulates red blood cell production?',
      'Erythropoietin (EPO), released mainly by the kidneys in response to '
          'hypoxia.',
    ),
    (
      'List the steps of hemostasis in order.',
      '1. Vascular spasm\n'
          '2. Platelet plug formation\n'
          '3. Blood coagulation (clot formation)',
    ),
    (
      'ما هي وظيفة الهيموجلوبين؟',
      'ينقل الأكسجين من الرئتين إلى الأنسجة، ويساعد في نقل ثاني أكسيد '
          'الكربون عائدًا إلى الرئتين.',
    ),
    (
      'Which blood group is the universal donor of red cells?',
      'Group O negative: no A, B or Rh D antigens on the red cells.',
    ),
    (
      'Which blood group is the universal recipient?',
      'Group AB positive: no anti-A or anti-B antibodies in the plasma.',
    ),
    (
      'Which white blood cell is the most numerous?',
      'The neutrophil, about 60 to 70 percent of circulating leukocytes.',
    ),
    (
      'What is the role of vitamin K in coagulation?',
      'It is needed for the liver to make clotting factors II, VII, IX and X.',
    ),
  ]),
  // 3 cards = a short round.
  'physio-l2': _deck('physio-l2', <(String, String)>[
    (
      'Where does the cardiac impulse normally start?',
      'In the sinoatrial (SA) node, the natural pacemaker of the heart.',
    ),
    (
      'What is cardiac output?',
      'The volume of blood pumped by each ventricle per minute: stroke volume '
          'multiplied by heart rate, about 5 L/min at rest.',
    ),
    (
      'Which heart sound is caused by closure of the atrioventricular valves?',
      'The first heart sound (S1, "lub"). The second sound (S2, "dub") is '
          'closure of the aortic and pulmonary valves.',
    ),
  ]),
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

/// Every field `PATCH /me` accepts (`updateMyProfile`). Anything else in a body
/// is ignored, as the contract's open object allows.
const _patchableProfileKeys = [
  'name',
  'email',
  'avatarId',
  'leaderboardVisible',
  'scoreHidden',
];

/// The contract's `format: email`, read loosely: one `@`, no spaces, and a dot
/// in the part after it. Enough to make the 400 arm reachable from the form.
final _emailShape = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// The mock board's peers, highest first. Names are Arabic for the same reason
/// the catalog's are (adr-018): the content language is what a real board
/// returns, and it is the only way the RTL row layout gets exercised on device.
///
/// Twenty-two peers plus the caller is deliberate: at the notifier's
/// `_pageSize` of 20 that is two pages, so `hasMore`, `nextCursor` and the
/// append spinner are all reachable by scrolling — none of which a one-row
/// staging board can show.
const _boardPeers = <(String, int)>[
  ('مريم عبد الرحمن', 2140),
  ('يوسف الشناوي', 2020),
  ('حبيبة مصطفى', 1890),
  ('عمر خالد', 1720),
  ('سلمى الحديدي', 1610),
  ('كريم فتحي', 1540),
  ('نور الهدى سامي', 1495),
  ('آدم بركات', 1380),
  ('جنى الشريف', 1310),
  ('زياد منصور', 1205),
  ('ملك عادل', 1160),
  ('حمزة الديب', 1095),
  ('ريم العطار', 1040),
  ('طه إسماعيل', 980),
  ('ليلى مجدي', 925),
  ('أنس القاضي', 870),
  ('تالة حسن', 815),
  ('مازن رضا', 760),
  ('لمى أبو زيد', 705),
  ('سيف الدين طارق', 650),
  ('هنا وليد', 590),
  ('بلال عصام', 15),
];

/// One page-able board, dense-ranked, caller included.
///
/// Built per request rather than held as a constant so the caller's row carries
/// the LIVE total and CLIMBS when a quiz is finished on device — the board
/// re-sorts, the rank falls, and the highlighted row moves. That is the whole
/// point of putting the caller mid-board: the self-row sits between two
/// ordinary rows where its treatment is visible, and it does not stay put.
///
/// Dense ranking with no gaps is the contract's rule (`openapi.yaml:2758`),
/// and it is applied here rather than using the list index, so a points tie
/// renders the way the server would render it.
List<Map<String, dynamic>> _leaderboard({
  required bool isUniversity,
  required int selfPoints,
}) {
  final rows =
      <(String, int, bool, int)>[
        for (final (i, (name, points)) in _boardPeers.indexed)
          (name, points, false, i + 1),
        (
          isUniversity ? 'طالب جامعي تجريبي' : 'طالب تجريبي',
          selfPoints,
          true,
          0,
        ),
      ]..sort((a, b) {
        final byPoints = b.$2.compareTo(a.$2);
        // Stable tie-break so a tie with the caller does not reorder between
        // two requests and make the page seam look like a server fault.
        return byPoints != 0 ? byPoints : a.$1.compareTo(b.$1);
      });

  final out = <Map<String, dynamic>>[];
  var rank = 0;
  int? lastPoints;
  for (final (index, (name, points, isMe, seed)) in rows.indexed) {
    if (points != lastPoints) {
      rank = index + 1;
      lastPoints = points;
    }
    out.add(<String, dynamic>{
      'rank': rank,
      'studentId': isMe
          ? '0197b2f3-9999-7cc3-9b4e-000000000001'
          : '0197b2f3-7777-7cc3-9b4e-${seed.toString().padLeft(12, '0')}',
      'name': name,
      'avatarUrl': isMe
          ? 'https://picsum.photos/seed/levelup1/200'
          : 'https://picsum.photos/seed/board$seed/200',
      'points': points,
      'isMe': isMe,
    });
  }
  return out;
}

/// The mock's stand-in for the server's signed, expiring cursor.
///
/// It is base64 on purpose — NOT because the real token is (it is encrypted and
/// signed, `openapi.yaml:2057`), but so that a hand-altered one fails to decode
/// here exactly as an altered real one fails to verify there. The app must not
/// care either way: it echoes the string back unchanged, and the only thing it
/// is allowed to do with a rejection is ask for page one.
String _encodeMockCursor(int offset, String scope) =>
    base64Url.encode(utf8.encode('$scope:$offset'));

/// Returns the offset, or null when the cursor is malformed or was issued for
/// a different scope — both of which the contract answers with the same
/// `400 validation_failed` on field `cursor`, and both of which have the same
/// remedy.
int? _decodeMockCursor(String cursor, String scope) {
  try {
    final parts = utf8.decode(base64Url.decode(cursor)).split(':');
    if (parts.length != 2 || parts.first != scope) return null;
    return int.tryParse(parts.last);
  } on Object {
    return null;
  }
}

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
    // adr-165 D7. Optional on the wire, but the contract says it reads
    // `inactive` for EVERY student today — parent-report delivery is not
    // switched on and nothing is delivered to any parent. The mock sends the
    // value the real server sends rather than omitting it, so the decode path
    // is exercised in dev. There is no `pending` value.
    'parentReportStatus': 'inactive',
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

// ---------------------------------------------------------------------------
// Mistakes fixtures - GET /me/mistakes and /me/mistakes/subjects/{id}
// ---------------------------------------------------------------------------

/// One row of the overview.
///
/// `termId`/`termNumber` are adr-036 term signals: school subjects carry them
/// as null outright, university subjects carry a real term. Both keys are sent
/// explicitly rather than omitted, because the client models them as
/// optional-AND-nullable and the tolerant reading should be exercised.
Map<String, dynamic> _mistakesSubject(
  String id,
  String name,
  int mistakeCount, {
  String? termId,
  int? termNumber,
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'termId': termId,
  'termNumber': termNumber,
  'mistakeCount': mistakeCount,
};

int _sumMistakes(List<dynamic> nodes) => nodes.fold<int>(
  0,
  (a, n) => a + ((n as Map<String, dynamic>)['mistakeCount'] as int),
);

Map<String, dynamic> _mistakesLeaf(String id, String name, int count) =>
    <String, dynamic>{'id': id, 'name': name, 'mistakeCount': count};

/// Parents are SUMMED from their children rather than written by hand.
///
/// The server sums (openapi.yaml:953-957) and the client is forbidden from
/// doing arithmetic, so the fixture must arrive already correct. Computing it
/// here also means a later edit to a leaf cannot silently desynchronise the
/// parent - which is a different goal from the UNIT-test fixture, where the
/// parents deliberately DISAGREE with their children to prove the client
/// renders whatever the server sent.
Map<String, dynamic> _mistakesChapter(
  String id,
  String name,
  List<dynamic> lessons,
) => <String, dynamic>{
  'id': id,
  'name': name,
  'mistakeCount': _sumMistakes(lessons),
  'lessons': lessons,
};

Map<String, dynamic> _mistakesUnit(
  String id,
  String name,
  List<dynamic> chapters,
) => <String, dynamic>{
  'id': id,
  'name': name,
  'mistakeCount': _sumMistakes(chapters),
  'chapters': chapters,
};

Map<String, dynamic> _mistakesSchoolTree(List<dynamic> units) =>
    <String, dynamic>{
      'track': 'school',
      'mistakeCount': _sumMistakes(units),
      'units': units,
    };

Map<String, dynamic> _mistakesUniversityTree(List<dynamic> lectures) =>
    <String, dynamic>{
      'track': 'university',
      'mistakeCount': _sumMistakes(lectures),
      'lectures': lectures,
    };

/// A subject the student has nothing outstanding in. `200` with a zero count
/// and an empty child list - a NORMAL response, not an error and not a 403
/// (openapi.yaml:960-964). This is what the tree's `noMistakes` state renders.
final _emptySchoolTree = _mistakesSchoolTree(<dynamic>[]);
final _emptyUniversityTree = _mistakesUniversityTree(<dynamic>[]);

/// `GET /me/mistakes` - SCHOOL.
///
/// The counts walk the Arabic plural through every category the ARB declares,
/// because `mistakeCount` is this project's first ICU plural and Arabic's six
/// categories are genuinely different words: 1 -> one, 2 -> two, 3-10 -> few,
/// 11-99 -> many, 100+ -> other. `zero` is unreachable by design - the wire
/// publishes `minimum: 1` and a subject with nothing outstanding is ABSENT
/// from this array rather than present with `0` (openapi.yaml:915-920).
final _schoolMistakes = <dynamic>[
  _mistakesSubject('sub-chem', 'الكيمياء', 1),
  _mistakesSubject('sub-phys', 'الفيزياء', 2),
  _mistakesSubject('sub-bio', 'الأحياء', 7),
  _mistakesSubject('sub-math', 'الرياضيات', 34),
  _mistakesSubject('sub-geo', 'الجغرافيا', 100),
  // Listed with a live count, but its tree answers 200 / 0 / no units. That
  // is the documented race, not a contradiction: the count is recomputed on
  // every read and never cached, so two requests seconds apart may legitimately
  // disagree (openapi.yaml:882-886). It makes the tree empty state reachable
  // on a device without a second account.
  _mistakesSubject('sub-arabic', 'اللغة العربية', 5),
];

/// `GET /me/mistakes` - UNIVERSITY. Carries real term signals (adr-036).
final _universityMistakes = <dynamic>[
  _mistakesSubject(
    'uni-anatomy',
    'التشريح',
    3,
    termId: 'term-01HZY0',
    termNumber: 1,
  ),
  _mistakesSubject(
    'uni-physio',
    'الفسيولوجي',
    1,
    termId: 'term-01HZY0',
    termNumber: 1,
  ),
  _mistakesSubject(
    'uni-biochem',
    'الكيمياء الحيوية',
    12,
    termId: 'term-01HZY1',
    termNumber: 2,
  ),
  _mistakesSubject(
    'uni-histology',
    'الأنسجة',
    2,
    termId: 'term-01HZY1',
    termNumber: 2,
  ),
];

/// Per-subject school trees. Every total matches its overview row above, and
/// the tree is PRUNED: only branches that actually contain a mistake appear,
/// so there is no dead row to tap into.
final _schoolMistakesTrees = <String, Map<String, dynamic>>{
  'sub-chem': _mistakesSchoolTree(<dynamic>[
    _mistakesUnit('chem-u1', 'الوحدة الأولى', <dynamic>[
      _mistakesChapter('chem-u1-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('chem-u1-c1-l1', 'الدرس الأول', 1),
      ]),
    ]),
  ]),
  'sub-phys': _mistakesSchoolTree(<dynamic>[
    _mistakesUnit('phys-u1', 'الوحدة الأولى', <dynamic>[
      _mistakesChapter('phys-u1-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('phys-u1-c1-l1', 'الدرس الأول', 1),
        _mistakesLeaf('phys-u1-c1-l2', 'الدرس الثاني', 1),
      ]),
    ]),
  ]),
  // Two units deep, so the three-screen drill-down has something at every
  // level and the one-fetch-per-subject caching is visible on device.
  'sub-bio': _mistakesSchoolTree(<dynamic>[
    _mistakesUnit('bio-u1', 'الوحدة الأولى', <dynamic>[
      _mistakesChapter('bio-u1-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('bio-u1-c1-l1', 'الدرس الأول', 2),
        _mistakesLeaf('bio-u1-c1-l2', 'الدرس الثاني', 1),
      ]),
      _mistakesChapter('bio-u1-c2', 'الفصل الثاني', <dynamic>[
        _mistakesLeaf('bio-u1-c2-l1', 'الدرس الأول', 1),
      ]),
    ]),
    _mistakesUnit('bio-u2', 'الوحدة الثانية', <dynamic>[
      _mistakesChapter('bio-u2-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('bio-u2-c1-l1', 'الدرس الأول', 3),
      ]),
    ]),
  ]),
  'sub-math': _mistakesSchoolTree(<dynamic>[
    _mistakesUnit('math-u1', 'الوحدة الأولى', <dynamic>[
      _mistakesChapter('math-u1-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('math-u1-c1-l1', 'الدرس الأول', 10),
        _mistakesLeaf('math-u1-c1-l2', 'الدرس الثاني', 7),
      ]),
    ]),
    _mistakesUnit('math-u2', 'الوحدة الثانية', <dynamic>[
      _mistakesChapter('math-u2-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('math-u2-c1-l1', 'الدرس الأول', 9),
        _mistakesLeaf('math-u2-c1-l2', 'الدرس الثاني', 8),
      ]),
    ]),
  ]),
  // A three-digit total, so the widest count the plural can produce is on
  // screen next to the narrowest - the text-scaling and RTL case worth seeing.
  'sub-geo': _mistakesSchoolTree(<dynamic>[
    _mistakesUnit('geo-u1', 'الوحدة الأولى', <dynamic>[
      _mistakesChapter('geo-u1-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('geo-u1-c1-l1', 'الدرس الأول', 40),
        _mistakesLeaf('geo-u1-c1-l2', 'الدرس الثاني', 35),
      ]),
    ]),
    _mistakesUnit('geo-u2', 'الوحدة الثانية', <dynamic>[
      _mistakesChapter('geo-u2-c1', 'الفصل الأول', <dynamic>[
        _mistakesLeaf('geo-u2-c1-l1', 'الدرس الأول', 25),
      ]),
    ]),
  ]),
  // Deliberately absent -> falls through to the empty tree. See the note on
  // its overview row.
};

/// Per-subject university trees - a FLAT lecture list, and no `quizTypes`:
/// a mistakes tree is a history view, not a quiz-build tree.
final _universityMistakesTrees = <String, Map<String, dynamic>>{
  'uni-anatomy': _mistakesUniversityTree(<dynamic>[
    _mistakesLeaf('anatomy-lec1', 'المحاضرة الأولى', 2),
    _mistakesLeaf('anatomy-lec2', 'المحاضرة الثانية', 1),
  ]),
  'uni-physio': _mistakesUniversityTree(<dynamic>[
    _mistakesLeaf('physio-lec1', 'المحاضرة الأولى', 1),
  ]),
  'uni-biochem': _mistakesUniversityTree(<dynamic>[
    _mistakesLeaf('biochem-lec1', 'المحاضرة الأولى', 5),
    _mistakesLeaf('biochem-lec2', 'المحاضرة الثانية', 4),
    _mistakesLeaf('biochem-lec3', 'المحاضرة الثالثة', 3),
  ]),
  // 'uni-histology' absent -> empty tree, same purpose as sub-arabic.
};
