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
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
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

    const device = DeviceInfo(
      deviceId: 'a1b2c3d4e5f60718293a4b5c6d7e8f90',
      platform: 'android',
      model: 'LevelUp Smoke Harness',
    );

    // One verify only — 5 failures lock the number for 15 minutes.
    final Object? result = await repo
        .verifyOtp(phone: phone, code: '000000', device: device)
        .then<Object?>((v) => v)
        .catchError((Object e) => e);

    String? regToken;
    switch (result) {
      case AuthenticatedResult():
        report('otp/verify', 'AuthenticatedResult — tokens + profile decoded');
        report('discriminator', 'authenticated');
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
  });
}
