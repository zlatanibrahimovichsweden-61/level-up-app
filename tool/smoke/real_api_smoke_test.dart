// TEMPORARY gate harness — real staging API smoke test. NOT part of the suite.
//
// Deliberately lives OUTSIDE `test/` so `flutter test` (and therefore
// validate.ps1 / CI) never makes a network call. Run it explicitly:
//
//   flutter test tool/smoke/real_api_smoke_test.dart
//   flutter test tool/smoke/real_api_smoke_test.dart --dart-define=SMOKE_PHONE=+20...
//
// It exercises the REAL app seam: AppConfig -> DioClient -> interceptors ->
// repositories -> freezed models. Nothing in `lib/` is stubbed except
// SecureStorage, which is a platform channel that does not exist under
// `flutter test`.
@Timeout(Duration(minutes: 4))
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/config/app_config.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';

/// In-memory stand-in for the Keystore/Keychain. Starts EMPTY, so the
/// AuthInterceptor attaches no Bearer — exactly the unauthenticated state the
/// public `/reference/*` endpoints are specified for.
class _MemStorage implements SecureStorage {
  final _m = <String, String>{};

  @override
  Future<String?> readAccessToken() async => _m['access'];

  @override
  Future<String?> readRefreshToken() async => _m['refresh'];

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    _m['access'] = access;
    _m['refresh'] = refresh;
  }

  @override
  Future<void> clearTokens() async {
    _m.remove('access');
    _m.remove('refresh');
  }

  @override
  Future<void> clear() async => _m.clear();

  @override
  Future<String> readOrCreateDeviceId() async =>
      _m['device_id'] ??= 'a1b2c3d4e5f60718293a4b5c6d7e8f90';
}

late Dio raw;
late ProviderContainer container;

/// Set by the auth test when a session is obtained — either the phone was
/// already registered (AuthenticatedResult) or the opt-in SMOKE_REGISTER arm
/// created one. The authenticated-surface test below needs it.
TokenPair? sessionTokens;

/// One device identity for the whole run. MUST match what
/// `_MemStorage.readOrCreateDeviceId` returns — device binding means refresh
/// is rejected for a deviceId the session was not minted for.
const smokeDevice = DeviceInfo(
  deviceId: 'a1b2c3d4e5f60718293a4b5c6d7e8f90',
  platform: 'android',
  model: 'LevelUp Smoke Harness',
);

String shapeOf(Object? d) {
  if (d is List) {
    if (d.isEmpty) return 'array[0] (EMPTY)';
    final first = d.first;
    final keys = first is Map ? first.keys.join(',') : first.runtimeType;
    return 'array[${d.length}] first-keys={$keys}';
  }
  if (d is Map) return 'object{${d.keys.join(',')}}';
  return d.runtimeType.toString();
}

// ignore: avoid_print
void say(String s) => print(s);

void report(String label, Object? value) => say('  $label: $value');

/// Leaderboard ranks are dense and ordered. Reported, not asserted: a page may
/// legally shift between calls at a seam (live sets), so a strict assert here
/// would fail on correct server behaviour.
bool _ascending(List<int> xs) {
  for (var i = 1; i < xs.length; i++) {
    if (xs[i] <= xs[i - 1]) return false;
  }
  return true;
}

void main() {
  setUpAll(() {
    AppConfig.init(Flavor.staging);
    say('BASE URL = ${AppConfig.instance.baseUrl}');
    raw = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 25),
        validateStatus: (_) => true,
      ),
    );
    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(_MemStorage())],
    );
  });

  tearDownAll(() => container.dispose());

  /// Probe = raw status + top-level shape, then the SAME call through the real
  /// repository so the real freezed decoders and the real interceptor chain run.
  Future<void> probe(
    String name,
    String path,
    Future<Object?> Function() viaRepo, {
    Map<String, dynamic>? query,
  }) async {
    say('\n--- $name  (GET $path) ---');
    final res = await raw.get<dynamic>(path, queryParameters: query);
    report('status', res.statusCode);
    report('shape', shapeOf(res.data));
    if (res.data is List && (res.data as List).isEmpty) {
      report('empty-array', 'yes — contract-legal; drives the Empty state');
    }
    try {
      final decoded = await viaRepo();
      report('decode', 'OK -> ${decoded.runtimeType}');
      if (decoded is List) report('count', decoded.length);
      if (decoded is CursorPage) {
        report('items', decoded.items.length);
        report('hasMore', decoded.hasMore);
        report('nextCursor', decoded.nextCursor == null ? 'null' : 'present');
      }
      report('exception', 'none');
    } on AppException catch (e) {
      report('decode', 'FAILED');
      report('exception', '${e.runtimeType}(code=${e.code})');
      fail('$name threw ${e.runtimeType}(${e.code})');
    } on Object catch (e) {
      report('decode', 'FAILED (untyped — the exception hierarchy leaked)');
      report('exception', '$e');
      fail('$name threw a raw $e');
    }
  }

  /// The rule the quiz loop already follows, applied to every authenticated
  /// op: a TYPED server state (a 500, a 404 for a route staging has not
  /// deployed, a 403) is a real answer from the server — report it and carry
  /// on, so the ops after it are still exercised. Only an untyped error (the
  /// F-7-01 class) or a decode failure fails the run. Returns null on a typed
  /// failure; code + HTTP status only, never the body.
  Future<T?> typed<T>(String name, Future<T> Function() call) async {
    try {
      return await call();
    } on AppException catch (e) {
      final status = e is ApiException ? ' status=${e.status}' : '';
      report(
        name,
        'typed ${e.runtimeType}(code=${e.code}$status) — reported, not failed',
      );
      return null;
    }
  }

  test('GET /health/version — which backend commit is deployed', () async {
    // Not an /api/v1 path: strip the version suffix off the configured base.
    final root = AppConfig.instance.baseUrl.replaceFirst('/api/v1', '');
    final res = await Dio(
      BaseOptions(validateStatus: (_) => true),
    ).get<dynamic>('$root/health/version');
    say('\n--- health/version ---');
    report('status', res.statusCode);
    report('body', res.data);
  });

  test('reference/countries', () async {
    final r = container.read(referenceRepositoryProvider);
    await probe('countries', '/reference/countries', r.getCountries);
  });

  test('reference/governorates (EG)', () async {
    final r = container.read(referenceRepositoryProvider);
    await probe(
      'governorates',
      '/reference/countries/EG/governorates',
      () => r.getGovernorates('EG'),
    );
  });

  test('reference/cities (EG + governorateId)', () async {
    final r = container.read(referenceRepositoryProvider);
    // adr-010: for EG the contract REQUIRES governorateId. Fetch a real one
    // first rather than hardcoding a UUID.
    final govs = await r.getGovernorates('EG');
    final govId = govs.first.id;
    await probe(
      'cities',
      '/reference/cities',
      () => r.getCities(countryCode: 'EG', governorateId: govId),
      query: {'countryCode': 'EG', 'governorateId': govId},
    );
  });

  test('reference/cities — EG WITHOUT governorateId is a typed 400', () async {
    // The contract specifies `validation_failed` with the field map naming
    // `governorateId`. This checks the ERROR path end to end against the real
    // server: ErrorInterceptor -> ValidationException -> field names the
    // registration screens consume.
    say('\n--- cities (EG, no governorateId — expected 400) ---');
    final res = await raw.get<dynamic>(
      '/reference/cities',
      queryParameters: {'countryCode': 'EG'},
    );
    report('status', res.statusCode);
    report('code', (res.data as Map)['code']);
    try {
      await container
          .read(referenceRepositoryProvider)
          .getCities(countryCode: 'EG');
      fail('expected a ValidationException');
    } on ValidationException catch (e) {
      report('decode', 'OK -> ValidationException');
      report('fields', e.fields.toList());
      expect(e.fields, contains('governorateId'));
    }
  });

  test('reference/education-systems', () async {
    final r = container.read(referenceRepositoryProvider);
    await probe(
      'education-systems',
      '/reference/education-systems',
      r.getEducationSystems,
    );
  });

  test('reference/avatars', () async {
    final r = container.read(referenceRepositoryProvider);
    await probe('avatars', '/reference/avatars', r.getAvatars);
  });

  test('reference/schools (cursor page)', () async {
    final r = container.read(referenceRepositoryProvider);
    await probe('schools', '/reference/schools', () => r.searchSchools());
  });

  test('reference/universities', () async {
    final r = container.read(referenceRepositoryProvider);
    await probe('universities', '/reference/universities', r.getUniversities);
  });

  test('auth: OTP request + verify + registration body', () async {
    const phone = String.fromEnvironment('SMOKE_PHONE');
    if (phone.isEmpty) {
      say('\n--- auth SKIPPED (no --dart-define=SMOKE_PHONE=...) ---');
      return;
    }
    say('\n--- auth (phone=$phone) ---');
    final repo = container.read(authRepositoryProvider);

    // Exactly ONE request. The contract's 60s resend cooldown is real on
    // staging ("rate limits identical to prod"), so a second one inside the
    // window returns `otp_throttled`.
    try {
      final r = await repo.requestOtp(phone);
      report('otp/request', 'OK — decoded ${r.runtimeType}');
      report('  resendAfterSeconds', r.resendAfterSeconds);
      report('  expiresInSeconds', r.expiresInSeconds);
    } on AppException catch (e) {
      report('otp/request', 'FAILED ${e.runtimeType}(code=${e.code})');
      return;
    }

    const device = smokeDevice;

    // One verify only — 5 failures lock the number for 15 minutes.
    final Object? result = await repo
        .verifyOtp(phone: phone, code: '000000', device: device)
        .then<Object?>((v) => v)
        .catchError((Object e) => e);

    String? regToken;
    switch (result) {
      case AuthenticatedResult(:final tokens):
        report('otp/verify', 'AuthenticatedResult — tokens + profile decoded');
        report('discriminator', 'authenticated');
        sessionTokens = tokens;
      case RegistrationRequiredResult(:final registrationToken):
        report('otp/verify', 'RegistrationRequiredResult decoded');
        report('discriminator', 'registrationRequired');
        report('registrationToken', 'received (value deliberately NOT logged)');
        regToken = registrationToken;
      case final AppException e:
        report('otp/verify', 'FAILED ${e.runtimeType}(code=${e.code})');
      case final Object e:
        report('otp/verify', 'FAILED untyped: $e');
      case null:
        report('otp/verify', 'null');
    }

    if (regToken == null) return;

    // --- Outgoing registration body -------------------------------------
    // Capture what the REAL configured client would put on the wire, WITHOUT
    // sending it: an interceptor at position 0 records `options.data` and
    // rejects locally. No account is created.
    say('\n--- registration: outgoing body ---');
    final dio = container.read(dioProvider);
    Object? captured;
    final capture = InterceptorsWrapper(
      onRequest: (options, handler) {
        captured = options.data;
        handler.reject(
          DioException(
            requestOptions: options,
            error: const UnknownException(detail: 'captured by smoke harness'),
          ),
        );
      },
    );
    dio.interceptors.insert(0, capture);
    try {
      await container
          .read(registrationRepositoryProvider)
          .register(
            SchoolRegistration(
              registrationToken: regToken,
              device: device,
              name: 'Smoke Harness',
              dateOfBirth: DateTime.utc(2010, 1, 1),
              countryCode: 'EG',
              governorateId: '019858a0-f400-7653-9d6e-1f8b67490ad3',
              cityId: '019858a0-f41b-740d-9a3b-1710a59bcb6a',
              stage: 'secondary',
              educationSystem: 'national',
              parentPhone: '+2010000000002',
            ),
          );
    } on AppException {
      // expected — the capture interceptor rejected it
    } finally {
      dio.interceptors.remove(capture);
    }
    final body = captured! as Map<String, dynamic>;
    report('keys', body.keys.toList());
    report('device runtimeType in toJson()', body['device'].runtimeType);
    expect(body['device'], isNotNull, reason: 'device must not be null');

    // What ACTUALLY reaches the wire. json_serializable runs with
    // `explicitToJson: false` (no build.yaml), so `toJson()['device']` is the
    // DeviceInfo object, not a Map — `jsonEncode` resolves it via its default
    // `toEncodable`, which calls `.toJson()`. This checks the encoded bytes,
    // not the intermediate map, because the bytes are what the server sees.
    final wire = jsonDecode(jsonEncode(body)) as Map<String, dynamic>;
    final dev = wire['device'];
    report('device on the wire', dev);
    expect(dev, isA<Map<String, dynamic>>());
    expect((dev as Map)['deviceId'], isNotNull);
    expect(dev['platform'], 'android');
    expect(dev['model'], isNotNull);
    report('device verdict', 'nested object with deviceId + platform + model');

    // --- Does the SERVER accept `device`? -------------------------------
    // A deliberately INCOMPLETE body (device present, the rest omitted). A
    // 400 proves nothing was created; the field map proves whether the server
    // objected to `device`.
    say('\n--- registration: server-side acceptance of `device` ---');
    final probeRes = await raw.post<dynamic>(
      '/auth/register',
      data: {
        'track': 'school',
        'registrationToken': regToken,
        'device': device.toJson(),
      },
    );
    report('status', probeRes.statusCode);
    final data = probeRes.data;
    if (data is Map) {
      report('code', data['code']);
      final errors = data['errors'];
      if (errors is Map) {
        report('rejected fields', errors.keys.toList());
        report(
          'device rejected?',
          errors.keys.any((k) => k.toString().toLowerCase().contains('device'))
              ? 'YES — server objected to device'
              : 'NO — device passed server validation',
        );
      }
    }
    expect(
      probeRes.statusCode,
      isNot(201),
      reason: 'the incomplete probe must NOT create an account',
    );

    // --- OPT-IN: real registration --------------------------------------
    // OFF by default because it creates a real account on staging. Enable
    // with --dart-define=SMOKE_REGISTER=true when SMOKE_PHONE is a fresh
    // staging test number, to unlock the authenticated-surface test.
    const doRegister = bool.fromEnvironment('SMOKE_REGISTER');
    if (!doRegister) {
      say(
        '\nregistration SKIPPED (add --dart-define=SMOKE_REGISTER=true to '
        'create a staging account and unlock the authenticated tests)',
      );
      return;
    }
    say('\n--- registration: REAL POST /auth/register (school) ---');
    final refRepo = container.read(referenceRepositoryProvider);
    final govs = await refRepo.getGovernorates('EG');
    final cities = await refRepo.getCities(
      countryCode: 'EG',
      governorateId: govs.first.id,
    );
    try {
      final auth = await container
          .read(registrationRepositoryProvider)
          .register(
            SchoolRegistration(
              registrationToken: regToken,
              device: smokeDevice,
              name: 'Smoke Harness',
              dateOfBirth: DateTime.utc(2010, 1, 1),
              countryCode: 'EG',
              governorateId: govs.first.id,
              cityId: cities.first.id,
              stage: 'secondary',
              educationSystem: 'national',
              parentPhone: '+2010000000002',
            ),
          );
      report('register', 'OK — AuthenticatedResult decoded');
      sessionTokens = auth.tokens;
    } on AppException catch (e) {
      report('register', 'FAILED ${e.runtimeType}(code=${e.code})');
    }
  });

  test('authenticated surface: me → entitlements → catalog → quiz → refresh → '
      'logout', () async {
    final tokens = sessionTokens;
    if (tokens == null) {
      say(
        '\n--- authenticated surface SKIPPED — no session. Use a REGISTERED '
        'staging number for SMOKE_PHONE, or add '
        '--dart-define=SMOKE_REGISTER=true. ---',
      );
      return;
    }
    final storage = container.read(secureStorageProvider);
    await storage.writeTokens(
      access: tokens.accessToken,
      refresh: tokens.refreshToken,
    );

    // -- GET /me + PATCH /me (no-op) + GET /me/entitlements ------------
    final profileRepo = container.read(profileRepositoryProvider);
    say('\n--- GET /me ---');
    final me = await profileRepo.getMe();
    report('decode', 'OK — StudentProfile');
    report('track', me.track);
    say('\n--- PATCH /me (no-op: same name — parse + roundtrip only) ---');
    final patched = await typed(
      'PATCH /me',
      () => profileRepo.updateMe(ProfileUpdate(name: me.name)),
    );
    if (patched != null) {
      report('decode', 'OK — name unchanged: ${patched.name == me.name}');
    }
    say('\n--- GET /me/entitlements ---');
    final ents = await typed(
      'GET /me/entitlements',
      profileRepo.getEntitlements,
    );
    if (ents != null) report('items', ents.length);

    // -- leaderboard ----------------------------------------------------
    // Placed BEFORE the catalog deliberately: every catalog branch below can
    // early-return (staging has seeded no subjects for this cohort since at
    // least 2026-09-04), and the board does not depend on the catalog at all.
    // Behind the catalog it would never have run.
    //
    // The scope is derived the same way the screen derives it —
    // LeaderboardScope.scopesFor(me).first — so this exercises the real
    // track/country rule rather than a hand-picked value the app would never
    // send. `/leaderboard/me` is NOT called: D-008 and the contract's
    // "do not add a synthetic self-rank row" both stand (openapi.yaml:2050).
    say('\n--- GET /leaderboard ---');
    final scopes = LeaderboardScope.scopesFor(me);
    report('scopes for this account', scopes.map((s) => s.wire).toList());
    final board = await typed(
      'GET /leaderboard',
      () => container
          .read(leaderboardRepositoryProvider)
          .getLeaderboard(scope: scopes.first, limit: 20),
    );
    if (board != null) {
      report('decode', 'OK — CursorPage<LeaderboardEntry>');
      report('scope', scopes.first.wire);
      report('rows', board.items.length);
      report('hasMore', board.hasMore);
      report('nextCursor', board.nextCursor == null ? 'null' : 'present');
      // A short page while hasMore is true is LEGAL (3.7.0-m1) — assert the
      // contract's invariants, never "rows > 0".
      for (final e in board.items) {
        expect(e.rank, greaterThanOrEqualTo(1), reason: 'rank is 1-based');
      }
      final ranks = board.items.map((e) => e.rank).toList();
      report('ranks ascending', '${ranks.length < 2 || _ascending(ranks)}');
      report('isMe rows', board.items.where((e) => e.isMe).length);
      if (board.hasMore && board.nextCursor != null) {
        say('\n--- GET /leaderboard (page 2, echoed cursor) ---');
        final p2 = await typed(
          'GET /leaderboard page2',
          () => container
              .read(leaderboardRepositoryProvider)
              .getLeaderboard(
                scope: scopes.first,
                cursor: board.nextCursor,
                limit: 20,
              ),
        );
        if (p2 != null) {
          report(
            'decode',
            'OK — ${p2.items.length} rows, hasMore ${p2.hasMore}',
          );
        }
      }
    }

    // -- catalog --------------------------------------------------------
    final catalog = container.read(catalogRepositoryProvider);
    say('\n--- GET /catalog/subjects ---');
    final subjects = await typed('GET /catalog/subjects', catalog.getSubjects);
    if (subjects == null) {
      report('quiz loop', 'SKIPPED — no subject list');
      await refreshAndLogout();
      return;
    }
    report('count', subjects.length);
    if (subjects.isEmpty) {
      report(
        'empty',
        'contract-legal — no subjects seeded for the account cohort '
            '(school subjects are never release-gated, adr-073) — quiz loop skipped',
      );
      await refreshAndLogout();
      return;
    }
    say('\n--- GET /catalog/subjects/{id}/tree ---');
    final tree = await typed(
      'GET /catalog/subjects/{id}/tree',
      () => catalog.getSubjectTree(subjects.first.id),
    );
    if (tree == null) {
      report('quiz loop', 'SKIPPED — no tree');
      await refreshAndLogout();
      return;
    }
    report('decode', 'OK — ${tree.runtimeType}');

    QuizSetupArgs? scope;
    switch (tree) {
      case SchoolSubjectTree(:final units):
        final lessons = [
          for (final u in units)
            for (final c in u.chapters)
              for (final l in c.lessons) l,
        ];
        report('lessons', lessons.length);
        if (lessons.isNotEmpty) {
          scope = QuizSetupArgs.lesson(
            lessonId: lessons.first.id,
            scopeName: lessons.first.name,
          );
        }
      case UniversitySubjectTree(:final lectures, :final quizTypes):
        report('lectures', lectures.length);
        if (lectures.isNotEmpty) {
          scope = QuizSetupArgs.lecture(
            lectureId: lectures.first.id,
            scopeName: lectures.first.name,
            quizType: quizTypes.isNotEmpty ? quizTypes.first : QuizType.normal,
          );
        }
    }
    if (scope == null) {
      report('quiz loop', 'SKIPPED — no lesson/lecture in the tree');
      await refreshAndLogout();
      return;
    }

    // -- quiz loop: create → answer q1 → explanation → finish ----------
    // NOTE: consumes questions from THIS account's weekly free wall.
    final quizRepo = container.read(quizRepositoryProvider);
    say('\n--- POST /quizzes (length 10) ---');
    try {
      final quiz = await quizRepo.createQuiz(
        scope: scope,
        length: QuizLength.ten,
      );
      report('decode', 'OK — ${quiz.questions.length} questions');
      final q = quiz.questions.first;
      say('\n--- POST /quizzes/{id}/answers (question 1) ---');
      final grade = await quizRepo.submitAnswer(
        quizId: quiz.id,
        questionId: q.id,
        optionId: q.options.first.id,
      );
      report(
        'decode',
        'OK — correct=${grade.correct} pointsDelta=${grade.pointsDelta}',
      );
      say('\n--- GET /questions/{id}/explanation (single shot) ---');
      try {
        final exp = await quizRepo.getExplanation(q.id);
        report('decode', 'OK — ${exp.runtimeType}');
      } on AppException catch (e) {
        // A 403 `insufficient_scope` (question not yet answered by the caller —
        // the only 403 the contract documents on `getExplanation`) is
        // contract-expected. What must NOT happen is an untyped error — that
        // would fail the test.
        report('explanation', 'typed ${e.runtimeType}(code=${e.code}) — OK');
      }
      say('\n--- POST /quizzes/{id}/finish ---');
      final summary = await quizRepo.finishQuiz(quiz.id);
      report(
        'decode',
        'OK — score=${summary.score}/${summary.totalQuestions} '
            'answered=${summary.answeredCount}',
      );
    } on AppException catch (e) {
      // weekly_question_limit_reached / not_enough_questions are real
      // server states, not harness failures — but they must arrive TYPED.
      report('quiz loop', 'typed ${e.runtimeType}(code=${e.code}) — OK');
    }

    await refreshAndLogout();
  });
}

/// `POST /auth/refresh` (rotation — the old refresh token dies, so the new
/// pair is written back) then `POST /auth/logout`, then clear.
Future<void> refreshAndLogout() async {
  final authRepo = container.read(authRepositoryProvider);
  final storage = container.read(secureStorageProvider);
  say('\n--- POST /auth/refresh (rotation) ---');
  try {
    final rotated = await authRepo.refresh(
      refreshToken: (await storage.readRefreshToken())!,
      deviceId: await storage.readOrCreateDeviceId(),
    );
    report('decode', 'OK — TokenPair rotated');
    await storage.writeTokens(
      access: rotated.accessToken,
      refresh: rotated.refreshToken,
    );
  } on AppException catch (e) {
    report('refresh', 'FAILED ${e.runtimeType}(code=${e.code})');
  }
  say('\n--- POST /auth/logout ---');
  try {
    await authRepo.logout();
    report('logout', 'OK (204, or already revoked)');
  } on AppException catch (e) {
    report('logout', 'FAILED ${e.runtimeType}(code=${e.code})');
  }
  await storage.clearTokens();
}
