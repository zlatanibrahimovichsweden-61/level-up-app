/// Throwaway on-device preview data for the friend graph and for reporting a
/// student - NOT production code.
///
/// Answers the twelve operations the app may call - the eleven friend-graph
/// operations other than the phone lookup, and `POST /student-reports`
/// (`contract/openapi.yaml:2983-3364`, `:3663`, all `x-stability: stable`) - for
/// `lib/dev/mock_backend.dart`, which owns the request plumbing. This file holds
/// the data and the contract's rules; the interceptor turns a
/// [MockFriendsReply] into a Dio response. It is shaped exactly like
/// `mock_support.dart`: one `handle(method, path, query, body)` that returns
/// `null` for a route it does not serve.
///
/// 🔴 **`POST /friends/phone-lookup` is deliberately NOT served** (DR-08: minors
/// and an exact-phone lookup need a legal decision first). [MockFriendsGraph.handle]
/// returns `null` for it, so it falls through to the generic 404 and a screen
/// that calls it by mistake fails loudly instead of previewing a feature that
/// is not approved. Nothing else in this file knows about phone numbers.
///
/// **Everything below is MOCK SAMPLE DATA, not product data.** The twenty-two
/// friends reuse the invented Arabic board peers `mock_backend.dart` already
/// serves (so the RTL row layout is exercised), every other student is
/// `Sample Student <n>`, and avatars come from the same placeholder host the
/// rest of the harness uses. No phone number, e-mail address or real person
/// appears anywhere.
///
/// Strict where the server is strict, per `mock_backend.dart`'s own rule:
/// - lists are pages of **20** with no `limit`, ordered as the contract says
///   (friends by `name` then `studentId`; requests and blocks newest first);
///   `cursor` is opaque to the app - here a keyset in disguise, bound to the
///   list it was issued for - and a token this mock did not issue is
///   `400 validation_failed` on field `cursor`;
/// - `GET /friend-requests` REQUIRES `direction` (`incoming` / `outgoing`);
/// - suggestions are **bounded to 100 in total**, never include the caller, a
///   friend, anyone with a pending request either way, or anyone blocked, and
///   that eligibility is recomputed on every request - so a suggestion you send
///   a request to, or block, disappears and the 101st takes its place;
/// - `friend_target_unavailable` is ONE answer for an unknown id, the caller's
///   own id, a pending-deletion account, a student on the other Track and a
///   student the caller blocked - the mock never says which;
/// - `blockStudent` and `reportStudent` answer for every well-formed id
///   (`204` / `202`) and store nothing for an unknown or own id;
/// - `removeFriend` and `unblockStudent` are idempotent `204`;
/// - friend, request and block WRITES share one budget of
///   [kMockFriendsSocialWriteLimit] per [kMockFriendsWriteWindowSeconds]
///   seconds, `reportStudent` has its own (the chat budget), and an exhausted
///   one is `429 rate_limited` with `Retry-After`. The contract does not say
///   whether a rejected write spends budget; here every write that reaches the
///   limiter does, and a refused one does not.
///
/// **Trigger table - how to reach each path on a device:**
///
/// | To get | Do this |
/// |---|---|
/// | A second page of friends | Scroll: 22 friends, 20 + 2 |
/// | A friend with no `points` key | Every fifth friend (5, 10, 15, 20) hides their score |
/// | `404 friend_target_unavailable` on send | Send to suggestion number [kMockFriendsGoneSuggestion] (`mockFriendsSuggestionId`), the other-track student, the pending-deletion student, an unknown id, or [kMockFriendsSelfId] |
/// | ... on accept | Accept incoming request [kMockFriendsGoneRequest] (its sender left; the request is deleted) |
/// | `409 already_friends` | Send to any friend |
/// | `409 friend_request_already_pending` | Send to the sender of an outgoing request |
/// | `201 accepted` from a send | Send to the sender of an incoming request |
/// | `404 friend_request_not_found` | Cancel / accept / decline any id that is not a request in that role (or answer one twice) |
/// | A hidden block | Block [mockFriendsOtherTrackStudentId]: stored, never listed |
/// | `429 rate_limited` | Make [kMockFriendsSocialWriteLimit] social writes (or reports) inside a minute |
///
/// State is per [MockFriendsGraph] instance, so friendships, requests, blocks
/// and reports persist for the life of one mock session (one `buildMockDio`)
/// and a fresh session starts from the fixtures again.
library;

import 'dart:convert';

/// What the mock answers, in terms the interceptor maps onto its own `_ok`,
/// `_validationFailed` and `_problem` helpers.
sealed class MockFriendsReply {
  const MockFriendsReply();
}

/// A success: [status] (`200`, `201`, `202` or `204`) and the JSON body, or
/// `null` for the two that carry none.
final class MockFriendsOk extends MockFriendsReply {
  const MockFriendsOk(this.status, this.data);

  final int status;
  final Object? data;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockFriendsValidation extends MockFriendsReply {
  const MockFriendsValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// Any other ProblemDetails: `404 friend_target_unavailable` /
/// `friend_request_not_found`, `409 already_friends` /
/// `friend_request_already_pending`, `429 rate_limited`. [retryAfterSeconds],
/// when set, is sent as the `Retry-After` header (delta-seconds, the only form
/// the client parses).
final class MockFriendsProblem extends MockFriendsReply {
  const MockFriendsProblem(
    this.status,
    this.code,
    this.detail, {
    this.retryAfterSeconds,
  });

  final int status;
  final String code;
  final String detail;
  final int? retryAfterSeconds;
}

// ---------------------------------------------------------------------------
// Ids and sizes - exposed so a test can name a student without a hard-coded UUID
// ---------------------------------------------------------------------------

/// The caller's own id. It is the id the mock leaderboard already gives the
/// caller's row, so the harness has one answer to "who am I".
const kMockFriendsSelfId = '0197b2f3-9999-7cc3-9b4e-000000000001';

/// How many friends the fixtures hold: more than a page of 20, so the first page
/// ends with `hasMore: true` and the second holds 2.
const kMockFriendsFriendCount = 22;

/// How many students the suggestion cohort holds: more than the contract's
/// bound of [kMockFriendsSuggestionBound], so the bound is reachable.
const kMockFriendsSuggestionPoolCount = 105;

/// "At most 100 students in total across all pages."
const kMockFriendsSuggestionBound = 100;

/// Pending requests TO the caller: 20 + 2.
const kMockFriendsIncomingCount = 22;

/// Pending requests FROM the caller: one short page.
const kMockFriendsOutgoingCount = 3;

/// Students the caller has blocked and that are listed: 20 + 1.
const kMockFriendsBlockedCount = 21;

/// The page size of every list (the operations take no `limit`).
const kMockFriendsPageSize = 20;

/// The suggestion (1-based, in ranking order) that has left the app since the
/// list was served: sending to it is `404 friend_target_unavailable`, after
/// which it is no longer listed.
const kMockFriendsGoneSuggestion = 3;

/// The incoming request (1-based, newest first) whose sender has left:
/// accepting it deletes the request and answers
/// `404 friend_target_unavailable`.
const kMockFriendsGoneRequest = 2;

/// Social writes (friend, request and block writes) allowed per window.
const kMockFriendsSocialWriteLimit = 30;

/// Chat writes (here: only reports) allowed per window.
const kMockFriendsChatWriteLimit = 30;

/// The rolling window both budgets are counted over.
const kMockFriendsWriteWindowSeconds = 60;

/// Student number [n] in the fixtures' numbering. Plain UUID-shaped strings:
/// the app treats `studentId` as an opaque handle.
String mockFriendsStudentId(int n) => '5f000000-0000-4000-8000-${_hex12(n)}';

/// Request number [n] in the fixtures' numbering.
String mockFriendsRequestId(int n) => '5f100000-0000-4000-8000-${_hex12(n)}';

/// Friend [k] (1-based, 1..[kMockFriendsFriendCount]).
String mockFriendsFriendId(int k) => mockFriendsStudentId(k);

/// Suggestion [k] (1-based, in ranking order).
String mockFriendsSuggestionId(int k) => mockFriendsStudentId(100 + k);

/// The sender of incoming request [k] (1-based, newest first).
String mockFriendsIncomingStudentId(int k) => mockFriendsStudentId(300 + k);

/// Incoming request [k] (1-based, newest first).
String mockFriendsIncomingRequestId(int k) => mockFriendsRequestId(k);

/// The recipient of outgoing request [k] (1-based, newest first).
String mockFriendsOutgoingStudentId(int k) => mockFriendsStudentId(400 + k);

/// Outgoing request [k] (1-based, newest first).
String mockFriendsOutgoingRequestId(int k) => mockFriendsRequestId(100 + k);

/// Blocked student [k] (1-based, most recently blocked first).
String mockFriendsBlockedId(int k) => mockFriendsStudentId(500 + k);

/// A real student on the other Track: never listed, never befriendable, and a
/// block of them is stored but hidden.
String mockFriendsOtherTrackStudentId() => mockFriendsStudentId(901);

/// A real student whose account is pending deletion: same treatment.
String mockFriendsPendingDeletionStudentId() => mockFriendsStudentId(902);

String _hex12(int n) => n.toRadixString(16).padLeft(12, '0');

/// One friend graph per mock session. See the file header.
class MockFriendsGraph {
  /// [clock] is the time source for timestamps and the write budgets; tests
  /// pass a fake one so a minute can pass without waiting.
  MockFriendsGraph({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
    _populate();
  }

  final DateTime Function() _clock;

  /// Every student the mock knows, by id. An id not in here is "unknown".
  final _people = <String, _Person>{};

  /// The cohort in suggestion-ranking order.
  final _cohort = <_Person>[];

  final _friends = <String, _FriendRow>{};
  final _incoming = <_RequestRow>[];
  final _outgoing = <_RequestRow>[];

  /// Blocked student id -> when. Includes hidden ones.
  final _blocks = <String, DateTime>{};

  /// Students the server no longer shows or accepts: pending deletion, or the
  /// other Track. Never listed anywhere, never befriendable.
  final _unavailable = <String>{};

  /// Students who are still in a list the client already holds but are no
  /// longer eligible: the first write that touches one answers
  /// `friend_target_unavailable` and moves it to [_unavailable].
  final _goneLater = <String>{};

  final _reported = <String>{};
  var _nextRequestNumber = 1000;

  late final _social = _Budget(
    _clock,
    kMockFriendsSocialWriteLimit,
    const Duration(seconds: kMockFriendsWriteWindowSeconds),
  );
  late final _chat = _Budget(
    _clock,
    kMockFriendsChatWriteLimit,
    const Duration(seconds: kMockFriendsWriteWindowSeconds),
  );

  static final _friendPath = RegExp(r'^/friends/([^/]+)$');
  static final _requestPath = RegExp(r'^/friend-requests/([^/]+)$');
  static final _acceptPath = RegExp(r'^/friend-requests/([^/]+)/accept$');
  static final _declinePath = RegExp(r'^/friend-requests/([^/]+)/decline$');
  static final _blockPath = RegExp(r'^/blocks/([^/]+)$');
  static final _uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{12}$',
  );

  /// Students the caller has reported so far, one id each (a repeat stores
  /// nothing). Exposed for tests: the contract says what is stored, and a
  /// `202` alone cannot show it.
  Set<String> get reportedStudentIds => Set.unmodifiable(_reported);

  /// Every student the caller has blocked, INCLUDING the ones `GET /blocks`
  /// hides (other Track, pending deletion). Exposed for tests: a hidden block is
  /// stored but invisible, so no list can show that it exists.
  Set<String> get blockedStudentIds => Set.unmodifiable(_blocks.keys);

  /// The reply for a friend-graph or report route, or `null` when [method] +
  /// [path] is not one of the twelve this mock serves (so the interceptor keeps
  /// looking - `POST /friends/phone-lookup` is deliberately not served).
  MockFriendsReply? handle(
    String method,
    String path,
    Map<String, dynamic> query,
    Map<String, dynamic> body,
  ) {
    switch (path) {
      case '/friends':
        return method == 'GET' ? _listFriends(query) : null;
      case '/friends/suggestions':
        return method == 'GET' ? _listSuggestions(query) : null;
      case '/friends/phone-lookup':
        return null;
      case '/friend-requests':
        if (method == 'GET') return _listRequests(query);
        if (method == 'POST') return _sendRequest(body);
        return null;
      case '/blocks':
        if (method == 'GET') return _listBlocks(query);
        if (method == 'POST') return _block(body);
        return null;
      case '/student-reports':
        return method == 'POST' ? _report(body) : null;
    }

    final friend = _friendPath.firstMatch(path);
    if (friend != null) {
      return method == 'DELETE' ? _removeFriend(_id(friend.group(1)!)) : null;
    }
    final accept = _acceptPath.firstMatch(path);
    if (accept != null) {
      return method == 'POST' ? _accept(_id(accept.group(1)!)) : null;
    }
    final decline = _declinePath.firstMatch(path);
    if (decline != null) {
      return method == 'POST' ? _decline(_id(decline.group(1)!)) : null;
    }
    final request = _requestPath.firstMatch(path);
    if (request != null) {
      return method == 'DELETE' ? _cancel(_id(request.group(1)!)) : null;
    }
    final block = _blockPath.firstMatch(path);
    if (block != null) {
      return method == 'DELETE' ? _unblock(_id(block.group(1)!)) : null;
    }
    return null;
  }

  // -------------------------------------------------------------------------
  // GET /friends
  // -------------------------------------------------------------------------

  MockFriendsReply _listFriends(Map<String, dynamic> query) {
    final rows = [
      for (final f in _friends.values)
        if (!_unavailable.contains(f.person.id)) f,
    ];
    return _page<_FriendRow>(
      rows: rows,
      tag: 'friends',
      descending: false,
      rawCursor: query['cursor'],
      keyOf: (f) => (primary: f.person.name, id: f.person.id),
      toJson: _friendJson,
    );
  }

  // -------------------------------------------------------------------------
  // GET /friends/suggestions
  // -------------------------------------------------------------------------

  MockFriendsReply _listSuggestions(Map<String, dynamic> query) {
    final pending = {
      for (final r in _incoming) r.person.id,
      for (final r in _outgoing) r.person.id,
    };
    // Eligibility is recomputed per request, so the 100-student bound slides:
    // whoever drops out is replaced by the next in the ranking.
    final eligible = <({int rank, _Person person})>[];
    for (final (rank, person) in _cohort.indexed) {
      final id = person.id;
      if (id == kMockFriendsSelfId ||
          _friends.containsKey(id) ||
          _unavailable.contains(id) ||
          _blocks.containsKey(id) ||
          pending.contains(id)) {
        continue;
      }
      eligible.add((rank: rank, person: person));
      if (eligible.length == kMockFriendsSuggestionBound) break;
    }
    return _page<({int rank, _Person person})>(
      rows: eligible,
      tag: 'suggestions',
      descending: false,
      rawCursor: query['cursor'],
      keyOf: (e) =>
          (primary: e.rank.toString().padLeft(6, '0'), id: e.person.id),
      toJson: (e) => _card(e.person),
    );
  }

  // -------------------------------------------------------------------------
  // GET /friend-requests
  // -------------------------------------------------------------------------

  MockFriendsReply _listRequests(Map<String, dynamic> query) {
    final direction = query['direction'];
    if (direction is! String ||
        (direction != 'incoming' && direction != 'outgoing')) {
      return MockFriendsValidation({
        'direction': [
          direction == null ? 'Required.' : 'Must be incoming or outgoing.',
        ],
      });
    }
    final source = direction == 'incoming' ? _incoming : _outgoing;
    return _page<_RequestRow>(
      rows: [
        for (final r in source)
          if (!_unavailable.contains(r.person.id)) r,
      ],
      tag: 'requests-$direction',
      descending: true,
      rawCursor: query['cursor'],
      keyOf: (r) => (primary: _epoch(r.createdAt), id: r.id),
      toJson: (r) => _requestJson(r, direction),
    );
  }

  // -------------------------------------------------------------------------
  // POST /friend-requests
  // -------------------------------------------------------------------------

  MockFriendsReply _sendRequest(Map<String, dynamic> body) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    final invalid = _studentIdProblem(body);
    if (invalid != null) return invalid;
    final id = (body['studentId'] as String).toLowerCase();

    // A student who left since the list was served: refuse, and stop listing.
    if (_goneLater.contains(id)) _markGone(id);
    if (_isUnavailable(id)) return _targetUnavailable();
    if (_friends.containsKey(id)) {
      return const MockFriendsProblem(
        409,
        'already_friends',
        'The two students are already friends',
      );
    }
    if (_outgoing.any((r) => r.person.id == id)) {
      return const MockFriendsProblem(
        409,
        'friend_request_already_pending',
        'A request to this student is already pending',
      );
    }

    // Their request is waiting: this send ACCEPTS it (adr-185 D7).
    final theirs = _incoming.where((r) => r.person.id == id).firstOrNull;
    if (theirs != null) {
      final friend = _befriend(theirs.person);
      return MockFriendsOk(201, <String, dynamic>{
        'status': 'accepted',
        'friend': _friendJson(friend),
      });
    }

    final row = _RequestRow(
      id: mockFriendsRequestId(_nextRequestNumber++),
      person: _people[id]!,
      createdAt: _stamp([..._incoming, ..._outgoing].map((r) => r.createdAt)),
    );
    _outgoing.add(row);
    return MockFriendsOk(201, <String, dynamic>{
      'status': 'pending',
      'request': _requestJson(row, 'outgoing'),
    });
  }

  // -------------------------------------------------------------------------
  // DELETE /friend-requests/{id}, POST .../accept, POST .../decline
  // -------------------------------------------------------------------------

  MockFriendsReply _cancel(String requestId) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    // Sender only: an INCOMING request is "not found" here.
    final row = _outgoing.where((r) => r.id == requestId).firstOrNull;
    if (row == null) return _requestNotFound();
    _outgoing.remove(row);
    return const MockFriendsOk(204, null);
  }

  MockFriendsReply _accept(String requestId) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    // Recipient only: an OUTGOING request is "not found" here.
    final row = _incoming.where((r) => r.id == requestId).firstOrNull;
    if (row == null) return _requestNotFound();

    // Eligibility is re-checked at accept time; if it no longer holds the
    // request is deleted and the answer is `friend_target_unavailable`.
    if (_goneLater.contains(row.person.id)) _markGone(row.person.id);
    if (_isUnavailable(row.person.id)) {
      _incoming.remove(row);
      return _targetUnavailable();
    }
    return MockFriendsOk(200, _friendJson(_befriend(row.person)));
  }

  MockFriendsReply _decline(String requestId) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    final row = _incoming.where((r) => r.id == requestId).firstOrNull;
    if (row == null) return _requestNotFound();
    _incoming.remove(row);
    return const MockFriendsOk(204, null);
  }

  // -------------------------------------------------------------------------
  // DELETE /friends/{studentId}
  // -------------------------------------------------------------------------

  MockFriendsReply _removeFriend(String studentId) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    // Idempotent, and the answer never depends on whether it existed.
    _friends.remove(studentId);
    return const MockFriendsOk(204, null);
  }

  // -------------------------------------------------------------------------
  // GET /blocks, POST /blocks, DELETE /blocks/{studentId}
  // -------------------------------------------------------------------------

  MockFriendsReply _listBlocks(Map<String, dynamic> query) {
    final rows = [
      for (final e in _blocks.entries)
        // A hidden block (other Track, pending deletion) is kept but not
        // listed, and is skipped without taking a page slot.
        if (!_unavailable.contains(e.key))
          (person: _people[e.key]!, blockedAt: e.value),
    ];
    return _page<({_Person person, DateTime blockedAt})>(
      rows: rows,
      tag: 'blocks',
      descending: true,
      rawCursor: query['cursor'],
      keyOf: (b) => (primary: _epoch(b.blockedAt), id: b.person.id),
      toJson: (b) => _card(b.person),
    );
  }

  MockFriendsReply _block(Map<String, dynamic> body) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    final invalid = _studentIdProblem(body);
    if (invalid != null) return invalid;
    final id = (body['studentId'] as String).toLowerCase();

    // `204` for every well-formed id; nothing is stored for one that names no
    // other student, so the answer reveals nothing.
    if (id == kMockFriendsSelfId || !_people.containsKey(id)) {
      return const MockFriendsOk(204, null);
    }
    if (_goneLater.contains(id)) _markGone(id);
    // A block removes any friendship and any pending request, either way.
    _friends.remove(id);
    _incoming.removeWhere((r) => r.person.id == id);
    _outgoing.removeWhere((r) => r.person.id == id);
    _blocks.putIfAbsent(id, () => _stamp(_blocks.values));
    return const MockFriendsOk(204, null);
  }

  MockFriendsReply _unblock(String studentId) {
    final limited = _spendSocial();
    if (limited != null) return limited;
    // Idempotent. Restores nothing: no friendship and no request comes back.
    _blocks.remove(studentId);
    return const MockFriendsOk(204, null);
  }

  // -------------------------------------------------------------------------
  // POST /student-reports
  // -------------------------------------------------------------------------

  MockFriendsReply _report(Map<String, dynamic> body) {
    // The CHAT budget, not the social one.
    final retry = _chat.spend();
    if (retry != null) return _rateLimited(retry);
    final invalid = _studentIdProblem(body);
    if (invalid != null) return invalid;
    final id = (body['studentId'] as String).toLowerCase();

    // `202` for every well-formed id. Stored only for a real, different
    // student, and once per (reporter, reported): the set makes a repeat a
    // no-op. No content is attached.
    if (id != kMockFriendsSelfId && _people.containsKey(id)) _reported.add(id);
    return const MockFriendsOk(202, null);
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// The decoded path segment; a malformed escape is kept as written (an id the
  /// mock does not know answers the same either way).
  String _id(String segment) {
    try {
      return Uri.decodeComponent(segment).toLowerCase();
    } on ArgumentError {
      return segment.toLowerCase();
    }
  }

  bool _isUnavailable(String id) =>
      id == kMockFriendsSelfId ||
      !_people.containsKey(id) ||
      _unavailable.contains(id) ||
      _blocks.containsKey(id);

  /// A student who has left: stop showing them anywhere, and drop whatever
  /// connects them to the caller.
  void _markGone(String id) {
    _goneLater.remove(id);
    _unavailable.add(id);
    _friends.remove(id);
    _incoming.removeWhere((r) => r.person.id == id);
    _outgoing.removeWhere((r) => r.person.id == id);
  }

  _FriendRow _befriend(_Person person) {
    _incoming.removeWhere((r) => r.person.id == person.id);
    _outgoing.removeWhere((r) => r.person.id == person.id);
    final row = _FriendRow(person: person, since: _truncated(_clock()));
    _friends[person.id] = row;
    return row;
  }

  MockFriendsReply? _spendSocial() {
    final retry = _social.spend();
    return retry == null ? null : _rateLimited(retry);
  }

  MockFriendsProblem _rateLimited(int retryAfterSeconds) => MockFriendsProblem(
    429,
    'rate_limited',
    'Too many writes',
    retryAfterSeconds: retryAfterSeconds,
  );

  MockFriendsProblem _targetUnavailable() => const MockFriendsProblem(
    404,
    'friend_target_unavailable',
    'This student cannot be sent a friend request',
  );

  MockFriendsProblem _requestNotFound() => const MockFriendsProblem(
    404,
    'friend_request_not_found',
    'No such pending friend request for this caller',
  );

  /// `400 validation_failed` on `studentId` when it is missing or not a UUID.
  MockFriendsValidation? _studentIdProblem(Map<String, dynamic> body) {
    final value = body['studentId'];
    if (value == null) {
      return const MockFriendsValidation({
        'studentId': ['Required.'],
      });
    }
    if (value is! String || !_uuid.hasMatch(value)) {
      return const MockFriendsValidation({
        'studentId': ['Must be a UUID.'],
      });
    }
    return null;
  }

  DateTime _truncated(DateTime at) => DateTime.fromMillisecondsSinceEpoch(
    at.toUtc().millisecondsSinceEpoch,
    isUtc: true,
  );

  /// A new instant for a request or a block: the clock, but never earlier than
  /// one second after the newest instant already in [existing]. A mock whose
  /// fixtures are dated in the future of a misset device clock would otherwise
  /// sort a brand-new row below them, and "newest first" is the behaviour being
  /// previewed.
  DateTime _stamp(Iterable<DateTime> existing) {
    final now = _truncated(_clock());
    var latest = _newest;
    for (final t in existing) {
      if (t.isAfter(latest)) latest = t;
    }
    final floor = latest.add(const Duration(seconds: 1));
    return now.isAfter(floor) ? now : floor;
  }

  // -------------------------------------------------------------------------
  // Paging - a keyset in disguise
  // -------------------------------------------------------------------------

  /// One page of [rows] in the list's own order. A keyset, not an offset: the
  /// cursor names the last row served, so a row that is added or removed
  /// between pages cannot repeat or skip another.
  MockFriendsReply _page<T>({
    required List<T> rows,
    required String tag,
    required bool descending,
    required Object? rawCursor,
    required _Key Function(T row) keyOf,
    required Map<String, dynamic> Function(T row) toJson,
  }) {
    final sorted = [...rows]
      ..sort((a, b) {
        final byKey = _compareKeys(keyOf(a), keyOf(b));
        return descending ? -byKey : byKey;
      });

    var start = 0;
    if (rawCursor != null) {
      final after = rawCursor is String ? _decodeCursor(rawCursor, tag) : null;
      if (after == null) {
        return const MockFriendsValidation({
          'cursor': ['Not a cursor this API issued.'],
        });
      }
      // The first row strictly AFTER the one the cursor names, in the list's own
      // order. If that row has since gone, the walk still resumes in place.
      start = sorted.indexWhere((row) {
        final byKey = _compareKeys(keyOf(row), after);
        return descending ? byKey < 0 : byKey > 0;
      });
      if (start < 0) start = sorted.length;
    }

    final end = (start + kMockFriendsPageSize).clamp(0, sorted.length);
    final hasMore = end < sorted.length;
    final page = sorted.sublist(start, end);
    return MockFriendsOk(200, <String, dynamic>{
      'items': [for (final row in page) toJson(row)],
      'nextCursor': hasMore ? _encodeCursor(tag, keyOf(page.last)) : null,
      'hasMore': hasMore,
    });
  }

  // -------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------

  Map<String, dynamic> _card(_Person p) => <String, dynamic>{
    'studentId': p.id,
    'name': p.name,
    'avatarUrl': p.avatarUrl,
  };

  Map<String, dynamic> _friendJson(_FriendRow f) => <String, dynamic>{
    'studentId': f.person.id,
    'name': f.person.name,
    'avatarUrl': f.person.avatarUrl,
    'level': f.person.level,
    // OMITTED, not null, when the friend hides their score.
    'points': ?f.person.points,
    'friendsSince': f.since.toIso8601String(),
  };

  Map<String, dynamic> _requestJson(_RequestRow r, String direction) =>
      <String, dynamic>{
        'requestId': r.id,
        'direction': direction,
        'student': _card(r.person),
        'createdAt': r.createdAt.toIso8601String(),
      };

  // -------------------------------------------------------------------------
  // Fixtures
  // -------------------------------------------------------------------------

  void _populate() {
    assert(
      _friendNames.length == kMockFriendsFriendCount,
      'the friend fixtures drifted from kMockFriendsFriendCount',
    );
    _Person person(int number) =>
        _people[mockFriendsStudentId(number)] = _Person(number);

    // The suggestion cohort first, so it ranks ahead of everyone else.
    for (var k = 1; k <= kMockFriendsSuggestionPoolCount; k++) {
      _cohort.add(person(100 + k));
    }
    _goneLater.add(mockFriendsSuggestionId(kMockFriendsGoneSuggestion));

    // Friends: the invented Arabic peers; 1 is the oldest friendship.
    for (var k = 1; k <= kMockFriendsFriendCount; k++) {
      final p = person(k);
      _cohort.add(p);
      _friends[p.id] = _FriendRow(
        person: p,
        since: _newest.subtract(Duration(days: 8 + k)),
      );
    }

    // Incoming: request 1 is the newest, a day apart.
    for (var k = 1; k <= kMockFriendsIncomingCount; k++) {
      final p = person(300 + k);
      _cohort.add(p);
      _incoming.add(
        _RequestRow(
          id: mockFriendsIncomingRequestId(k),
          person: p,
          createdAt: _newest.subtract(Duration(hours: k)),
        ),
      );
    }
    _goneLater.add(mockFriendsIncomingStudentId(kMockFriendsGoneRequest));

    // Outgoing.
    for (var k = 1; k <= kMockFriendsOutgoingCount; k++) {
      final p = person(400 + k);
      _cohort.add(p);
      _outgoing.add(
        _RequestRow(
          id: mockFriendsOutgoingRequestId(k),
          person: p,
          createdAt: _newest.subtract(Duration(days: k)),
        ),
      );
    }

    // Blocked: block 1 is the most recent.
    for (var k = 1; k <= kMockFriendsBlockedCount; k++) {
      final p = person(500 + k);
      _cohort.add(p);
      _blocks[p.id] = _newest.subtract(Duration(days: 3, hours: k));
    }

    // Real students the caller can never reach: other Track, pending deletion.
    // They are in no list and in no cohort.
    for (final number in [901, 902]) {
      _unavailable.add(person(number).id);
    }
  }
}

// ---------------------------------------------------------------------------
// Cursors - opaque to the app, a keyset here
// ---------------------------------------------------------------------------

typedef _Key = ({String primary, String id});

int _compareKeys(_Key a, _Key b) {
  final byPrimary = a.primary.compareTo(b.primary);
  return byPrimary != 0 ? byPrimary : a.id.compareTo(b.id);
}

/// Fixed-width so that string order is time order.
String _epoch(DateTime at) =>
    at.millisecondsSinceEpoch.toString().padLeft(15, '0');

const _cursorTag = 'mock-friends:';

String _encodeCursor(String list, _Key last) => base64Url.encode(
  utf8.encode('$_cursorTag$list:${last.primary}|${last.id}'),
);

/// A cursor is bound to the list it was issued for: one from another list, or
/// one this mock never issued, is rejected - and both have the same remedy.
_Key? _decodeCursor(String cursor, String list) {
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    final prefix = '$_cursorTag$list:';
    if (!decoded.startsWith(prefix)) return null;
    final rest = decoded.substring(prefix.length);
    final bar = rest.lastIndexOf('|');
    if (bar <= 0 || bar == rest.length - 1) return null;
    return (primary: rest.substring(0, bar), id: rest.substring(bar + 1));
  } on FormatException {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Rolling write budgets
// ---------------------------------------------------------------------------

/// "At most [limit] writes per student per [window]." A refused write does not
/// spend budget.
class _Budget {
  _Budget(this._clock, this.limit, this.window);

  final DateTime Function() _clock;
  final int limit;
  final Duration window;
  final _spent = <DateTime>[];

  /// Spends one write, or returns the whole seconds to wait (at least 1) when
  /// the budget is exhausted.
  int? spend() {
    final now = _clock();
    _spent.removeWhere((at) => now.difference(at) >= window);
    if (_spent.length >= limit) {
      final waitMs =
          window.inMilliseconds - now.difference(_spent.first).inMilliseconds;
      final seconds = (waitMs / 1000).ceil();
      return seconds < 1 ? 1 : seconds;
    }
    _spent.add(now);
    return null;
  }
}

// ---------------------------------------------------------------------------
// Rows
// ---------------------------------------------------------------------------

class _Person {
  _Person(this.number)
    : id = mockFriendsStudentId(number),
      name = _nameFor(number),
      avatarUrl = 'https://picsum.photos/seed/friends$number/200',
      level = 1 + (number * 5) % 14,
      // Every fifth student hides their score: the key is OMITTED on the wire.
      points = number % 5 == 0 ? null : 120 + number * 83;

  final int number;
  final String id;
  final String name;
  final String avatarUrl;
  final int level;
  final int? points;
}

class _FriendRow {
  const _FriendRow({required this.person, required this.since});

  final _Person person;
  final DateTime since;
}

class _RequestRow {
  const _RequestRow({
    required this.id,
    required this.person,
    required this.createdAt,
  });

  final String id;
  final _Person person;
  final DateTime createdAt;
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

/// The newest fixture instant; everything else is dated back from here.
final _newest = DateTime.utc(2026, 10, 9, 12);

/// The friends' names: the invented Arabic peers `mock_backend.dart` already
/// serves on its leaderboard, in the same order.
const _friendNames = <String>[
  'مريم عبد الرحمن',
  'يوسف الشناوي',
  'حبيبة مصطفى',
  'عمر خالد',
  'سلمى الحديدي',
  'كريم فتحي',
  'نور الهدى سامي',
  'آدم بركات',
  'جنى الشريف',
  'زياد منصور',
  'ملك عادل',
  'حمزة الديب',
  'ريم العطار',
  'طه إسماعيل',
  'ليلى مجدي',
  'أنس القاضي',
  'تالة حسن',
  'مازن رضا',
  'لمى أبو زيد',
  'سيف الدين طارق',
  'هنا وليد',
  'بلال عصام',
];

String _nameFor(int number) {
  if (number >= 1 && number <= _friendNames.length) {
    return _friendNames[number - 1];
  }
  // Suggestion 7: long enough to wrap, so a row's two-line layout is reachable.
  if (number == 107) {
    return 'Sample Student With An Unusually Long Display Name '
        'That Has To Wrap Over Two Lines';
  }
  return 'Sample Student $number';
}
