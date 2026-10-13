/// Shared rig for the E4 session / auth / privacy / unintended-network audit.
///
/// Nothing here is product code and nothing here touches a real network:
///
/// * [MemoryFss] is an in-memory `FlutterSecureStorage`, so the REAL
///   `SecureStorage` wrapper (token keys, `clearTokens` keeping `device_id`)
///   is what the app talks to.
/// * [FakeServer] is a Dio `HttpClientAdapter`. It enforces token validity the
///   way a server would (a stale or missing Bearer on a protected path is a
///   `401 authentication_required`, `/auth/refresh` mints or refuses), and
///   forwards everything else to the repo's own canned backend
///   (`lib/dev/mock_backend.dart`) so real screens get real-shaped answers.
///   It records `method + path + a verdict on the Bearer` for every call and
///   NEVER the body, the query values or the token text.
/// * [Tripwire] is an `HttpOverrides` that records (and refuses) any
///   `dart:io` HTTP request that is NOT routed through Dio: image loads,
///   packages that open their own client, anything. It records the host only.
/// * The unmodified production `dioProvider` / `refreshDioProvider` are used:
///   the fake adapter is swapped in by a `ProviderObserver` the moment the
///   provider creates its `Dio`, so the real interceptor chain, the real
///   refresh closure (`requestTokenRefresh` on the bare client) and the real
///   router are all in play. Nothing about the Dio graph is overridden: until
///   E4-01 was fixed this rig had to swap in a release-semantics `dioProvider`
///   to audit anything past the first 401, and that blind spot is gone.
///
/// Sentinel strings below are fabricated test values. They are never real
/// phone numbers, tokens or ids.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override, ProviderBase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/app.dart';
import 'package:level_up_app/core/config/app_config.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';

/// Fabricated, obviously-fake values. Used to prove they never reach a sink.
const kSentinelPhoneLocal = '01000000099';
const kSentinelPhoneE164 = '+201000000099';
const kSentinelAccess = 'SENTINEL.ACCESS.TOKEN.0001';
const kSentinelRefresh = 'SENTINEL.REFRESH.TOKEN.0001';

// ---------------------------------------------------------------------------
// Storage
// ---------------------------------------------------------------------------

/// An in-memory `FlutterSecureStorage`. Only the four methods the wrapper uses.
class MemoryFss implements FlutterSecureStorage {
  final Map<String, String> data = {};
  int reads = 0;
  int writes = 0;
  int deletes = 0;
  int deleteAlls = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName;
    final key = invocation.namedArguments[#key] as String?;
    if (name == #read) {
      reads++;
      return Future<String?>.value(data[key]);
    }
    if (name == #write) {
      writes++;
      data[key!] = invocation.namedArguments[#value] as String;
      return Future<void>.value();
    }
    if (name == #delete) {
      deletes++;
      data.remove(key);
      return Future<void>.value();
    }
    if (name == #deleteAll) {
      deleteAlls++;
      data.clear();
      return Future<void>.value();
    }
    return super.noSuchMethod(invocation);
  }
}

// ---------------------------------------------------------------------------
// The recorded call
// ---------------------------------------------------------------------------

class ApiCall {
  ApiCall({
    required this.seq,
    required this.method,
    required this.path,
    required this.bearer,
    required this.retried,
    required this.snapshot,
    required this.queryKeys,
  });

  final int seq;
  final String method;

  /// Path only, exactly as the repository passed it (no host, no query).
  final String path;

  /// `none` (no Authorization header), `valid` (the server's current access
  /// token) or `stale` (anything else). Never the token text.
  final String bearer;

  /// Dio's `__retried` marker: the interceptor's one allowed replay.
  final bool retried;

  /// `auth=<status type>; at=<router location or ->` when the call was made.
  final String snapshot;

  final List<String> queryKeys;

  String get key => '$method $path';

  @override
  String toString() =>
      '#$seq $key bearer=$bearer${retried ? ' RETRY' : ''} [$snapshot]';
}

// ---------------------------------------------------------------------------
// The fake server
// ---------------------------------------------------------------------------

ResponseBody jsonBody(
  int status,
  Object? data, {
  Map<String, List<String>> headers = const {},
}) => ResponseBody.fromString(
  data == null ? '' : jsonEncode(data),
  status,
  headers: {
    if (data != null) Headers.contentTypeHeader: [Headers.jsonContentType],
    ...headers,
  },
);

ResponseBody problem(int status, String code, {Map<String, Object?>? extra}) =>
    jsonBody(status, <String, Object?>{
      'type': 'about:blank',
      'title': 'dev-facing title',
      'status': status,
      'code': code,
      ...?extra,
    });

typedef Override4 = FutureOr<ResponseBody?> Function(RequestOptions options);

class FakeServer implements HttpClientAdapter {
  FakeServer() : _mock = buildMockDio(latency: Duration.zero);

  final Dio _mock;
  final List<ApiCall> calls = [];

  /// What the server currently accepts.
  String validAccess = kSentinelAccess;
  String validRefresh = kSentinelRefresh;

  /// `POST /auth/refresh` behaviour.
  bool refreshDead = false; // 401 refresh_token_invalid
  bool refreshSuperseded = false; // 401 session_superseded
  bool refreshOffline = false; // connection error
  Completer<void>? refreshGate; // hold the refresh until completed
  int refreshCount = 0;
  int _minted = 0;

  /// When true, EVERY protected call answers `401 session_superseded`.
  bool supersedeAll = false;

  /// When true the account is inside the deletion grace window: every
  /// protected call outside the contract's four-endpoint allowlist answers
  /// `403 account_pending_deletion` (openapi.yaml:62-71).
  bool pendingDeletion = false;

  /// When set, every protected call (valid Bearer) answers this status with an
  /// `internal_error` problem body - a sick server.
  int? protectedStatus;

  /// When true, every protected call fails at the transport (no response) - a
  /// dead network after the session started.
  bool protectedOffline = false;

  /// When set, the `profile.id` of every `authenticated` verify answer is
  /// replaced by this value. The repo's canned backend gives EVERY magic-code
  /// student the same id, so without this two sign-ins cannot be told apart.
  String? signInStudentId;

  /// Per-call scripted answers, `METHOD /path` -> body. Return null to fall
  /// through to the normal behaviour.
  final Map<String, Override4> scripted = {};

  /// Injected by the rig so each call carries the app state it was made in.
  String Function() snapshot = () => '-';

  int _seq = 0;

  /// Make the stored access token stale (the server rotated it).
  void expireAccess() => validAccess = 'ROTATED.ACCESS.${++_minted}';

  List<String> get keys => [for (final c in calls) c.key];
  int count(String key) => calls.where((c) => c.key == key).length;

  static bool _pendingAllowlisted(String method, String path) =>
      (method == 'GET' && path == '/me') ||
      (path == '/me/deletion-request' &&
          (method == 'POST' || method == 'DELETE')) ||
      (method == 'POST' && path == '/auth/logout');

  bool _needsAuth(String path) {
    if (path == '/auth/logout') return true;
    if (path.startsWith('/auth/')) return false;
    if (path.startsWith('/reference')) return false;
    if (path.startsWith('/legal')) return false;
    if (path.startsWith('/recovery')) return false;
    return true;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final method = options.method.toUpperCase();
    final path = options.path;
    final header = options.headers['Authorization'];
    final bearer = header == null
        ? 'none'
        : (header == 'Bearer $validAccess' ? 'valid' : 'stale');
    calls.add(
      ApiCall(
        seq: ++_seq,
        method: method,
        path: path,
        bearer: bearer,
        retried: options.extra['__retried'] == true,
        snapshot: snapshot(),
        queryKeys: options.queryParameters.keys.toList()..sort(),
      ),
    );

    final scriptedAnswer = await scripted['$method $path']?.call(options);
    if (scriptedAnswer != null) return scriptedAnswer;

    if (method == 'POST' && path == '/auth/refresh') {
      refreshCount++;
      await refreshGate?.future;
      if (refreshOffline) {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        );
      }
      if (refreshSuperseded) return problem(401, 'session_superseded');
      if (refreshDead) return problem(401, 'refresh_token_invalid');
      final body = options.data;
      final sent = body is Map ? body['refreshToken'] : null;
      if (sent != validRefresh) return problem(401, 'refresh_token_invalid');
      _minted++;
      validAccess = 'MINTED.ACCESS.$_minted';
      validRefresh = 'MINTED.REFRESH.$_minted';
      return jsonBody(200, <String, Object?>{
        'accessToken': validAccess,
        'accessExpiresInSeconds': 900,
        'refreshToken': validRefresh,
        'refreshExpiresInSeconds': 5184000,
      });
    }

    if (_needsAuth(path)) {
      if (supersedeAll) return problem(401, 'session_superseded');
      if (bearer != 'valid') return problem(401, 'authentication_required');
      if (pendingDeletion && !_pendingAllowlisted(method, path)) {
        return problem(403, 'account_pending_deletion');
      }
      if (protectedOffline) {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        );
      }
      final failWith = protectedStatus;
      if (failWith != null) return problem(failWith, 'internal_error');
    }

    final forwarded = await _forward(options);
    // A sign-in minted tokens: the server now accepts exactly those.
    if (method == 'POST' && path == '/auth/otp/verify') {
      _adoptSignInTokens(forwarded);
      final data = forwarded.$1;
      final id = signInStudentId;
      if (id != null && data is Map && data['profile'] is Map) {
        return jsonBody(200, <String, Object?>{
          ...data.cast<String, Object?>(),
          'profile': <String, Object?>{
            ...(data['profile'] as Map).cast<String, Object?>(),
            'id': id,
          },
        });
      }
    }
    return forwarded.$2;
  }

  void _adoptSignInTokens((Object?, ResponseBody) forwarded) {
    final data = forwarded.$1;
    if (data is Map && data['tokens'] is Map) {
      final t = data['tokens'] as Map;
      validAccess = t['accessToken'] as String;
      validRefresh = t['refreshToken'] as String;
    }
  }

  Future<(Object?, ResponseBody)> _forward(RequestOptions o) async {
    try {
      final r = await _mock.request<dynamic>(
        o.path,
        data: o.data,
        queryParameters: o.queryParameters,
        options: Options(method: o.method),
      );
      return (
        r.data,
        jsonBody(
          r.statusCode ?? 200,
          r.data,
          headers: {
            for (final e in r.headers.map.entries)
              if (e.key.toLowerCase() == 'retry-after') e.key: e.value,
          },
        ),
      );
    } on DioException catch (e) {
      final r = e.response;
      if (r == null) rethrow;
      return (
        r.data,
        jsonBody(
          r.statusCode ?? 500,
          r.data,
          headers: {
            for (final h in r.headers.map.entries)
              if (h.key.toLowerCase() == 'retry-after') h.key: h.value,
          },
        ),
      );
    }
  }

  @override
  void close({bool force = false}) {}
}

// ---------------------------------------------------------------------------
// The dart:io tripwire
// ---------------------------------------------------------------------------

class TripwireHit {
  const TripwireHit(this.kind, this.host);
  final String kind; // `client-created` or `request`
  final String host;
  @override
  String toString() => '$kind $host';
}

class Tripwire extends HttpOverrides {
  final List<TripwireHit> hits = [];

  List<TripwireHit> get requests =>
      hits.where((h) => h.kind == 'request').toList();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    hits.add(const TripwireHit('client-created', '-'));
    return _DeadClient(hits);
  }
}

class _DeadClient implements HttpClient {
  _DeadClient(this._hits);
  final List<TripwireHit> _hits;

  Future<HttpClientRequest> _fail(Object? host) {
    _hits.add(TripwireHit('request', '$host'));
    return Future<HttpClientRequest>.error(
      const SocketException('E4 tripwire: no real network in this audit'),
    );
  }

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) => _fail(host);
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => _fail(url.host);
  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _fail(host);
  @override
  Future<HttpClientRequest> getUrl(Uri url) => _fail(url.host);
  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _fail(host);
  @override
  Future<HttpClientRequest> postUrl(Uri url) => _fail(url.host);
  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _fail(host);
  @override
  Future<HttpClientRequest> putUrl(Uri url) => _fail(url.host);
  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _fail(host);
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _fail(url.host);
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _fail(host);
  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _fail(url.host);
  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _fail(host);
  @override
  Future<HttpClientRequest> headUrl(Uri url) => _fail(url.host);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter) return null;
    if (invocation.memberName == #close) return null;
    return null;
  }
}

// ---------------------------------------------------------------------------
// Observer: which providers get created, and where the fake adapter goes in
// ---------------------------------------------------------------------------

final class RigObserver extends ProviderObserver {
  RigObserver(this._adapter);
  final HttpClientAdapter _adapter;

  /// Every provider that was created, as `Type#argument-free label`.
  final List<ProviderBase<Object?>> added = [];
  final List<String> failures = [];

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    added.add(context.provider);
    // The production factories build a Dio; give each the fake adapter before
    // anything can use it. (Both `dioProvider` and `refreshDioProvider`.)
    if (value is Dio) value.httpClientAdapter = _adapter;
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // Type only: errors can carry user data.
    failures.add('${context.provider.runtimeType}: ${error.runtimeType}');
  }

  bool wasCreated(ProviderBase<Object?> provider) => added.any(
    (p) => identical(p, provider) || identical((p as dynamic).from, provider),
  );
}

// ---------------------------------------------------------------------------
// The rig
// ---------------------------------------------------------------------------

class AppRig {
  AppRig({
    this.signedIn = false,
    this.storedAccess,
    this.withRefreshToken = true,
    this.onlineStream,
    List<Override> overrides = const [],
  }) {
    fss = MemoryFss();
    storage = SecureStorage(fss);
    server = FakeServer();
    tripwire = Tripwire();
    observer = RigObserver(server);
    extraOverrides = overrides;
  }

  late final MemoryFss fss;
  late final SecureStorage storage;
  late final FakeServer server;
  late final Tripwire tripwire;
  late final RigObserver observer;
  late final List<Override> extraOverrides;
  final bool signedIn;

  /// What the keystore holds at launch when [signedIn]: defaults to the
  /// server's current access token; pass something else for a STALE token.
  final String? storedAccess;

  /// False: the keystore has an access token but no refresh token.
  final bool withRefreshToken;

  /// Replaces the connectivity stream (default: online, once).
  final Stream<bool>? onlineStream;
  late final ProviderContainer container;
  HttpOverrides? _previousOverrides;

  /// Builds the container only (no widgets), for tests that drive the real
  /// providers and the real Dio chain directly in plain async tests.
  Future<void> bootHeadless() async {
    await _prepare();
    addTearDown(() {
      container.dispose();
      dispose();
    });
  }

  /// Builds the container and pumps the real [LevelUpApp]. Does NOT settle:
  /// callers decide how many frames to run, so request ordering stays visible.
  Future<void> boot(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    Size? size,
  }) async {
    await _prepare();
    addTearDown(dispose);
    if (size != null) {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }
    container.read(localeProvider.notifier).select(locale);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const LevelUpApp(),
      ),
    );
  }

  Future<void> _prepare() async {
    // `prod` resolves to a reserved `.example` host: even if the fake adapter
    // were bypassed, nothing real could be reached by name.
    AppConfig.init(Flavor.prod);
    _previousOverrides = HttpOverrides.current;
    HttpOverrides.global = tripwire;

    if (signedIn) {
      await storage.writeTokens(
        access: storedAccess ?? server.validAccess,
        refresh: server.validRefresh,
      );
      if (!withRefreshToken) await fss.delete(key: 'refresh_token');
      await storage.readOrCreateDeviceId();
    }

    container = ProviderContainer(
      observers: [observer],
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        isOnlineProvider.overrideWith(
          (ref) => onlineStream ?? Stream.value(true),
        ),
        // The platform plugin has no channel under `flutter test`. The
        // device id is still the REAL one from the real wrapper.
        deviceInfoProvider.overrideWith((ref) async {
          final id = await ref
              .watch(secureStorageProvider)
              .readOrCreateDeviceId();
          return DeviceInfo(deviceId: id, platform: 'android');
        }),
        ...extraOverrides,
      ],
    );
    server.snapshot = () {
      final status = container.read(authControllerProvider);
      final at = container.exists(routerProvider)
          ? _safeLocation(container.read(routerProvider))
          : '-';
      return 'auth=${status.runtimeType}; at=$at';
    };
  }

  static String _safeLocation(dynamic router) {
    try {
      final cfg = router.routerDelegate.currentConfiguration;
      if (cfg.isEmpty || cfg.isError) return '-';
      return router.state.uri.path as String;
    } catch (_) {
      return '-';
    }
  }

  String get location => _safeLocation(container.read(routerProvider));

  AuthStatus get auth => container.read(authControllerProvider);

  bool _disposed = false;
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    HttpOverrides.global = _previousOverrides;
    AppConfig.resetForTesting();
  }
}

/// Bounded frames. `pumpAndSettle` is not used for the signed-in app: skeleton
/// shimmers and the OTP cursor never let it settle.
Future<void> pumpFrames(
  WidgetTester tester, {
  int frames = 20,
  Duration step = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(step);
  }
}

/// Tears the widget tree down and lets Riverpod's disposal timers run, so a
/// test ends with nothing pending.
Future<void> tearDownTree(WidgetTester tester, AppRig rig) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 5));
  rig.container.dispose();
  await tester.pump(const Duration(seconds: 5));
}

/// Every widget test in this audit runs under this wall-clock bound: a hang in
/// fake-async code (an `await` on something that needs a pumped frame) must
/// fail in two minutes, not sit for the binding's ten.
const kE4Timeout = Timeout(Duration(minutes: 2));

void e4Widgets(String description, WidgetTesterCallback body) =>
    testWidgets(description, body, timeout: kE4Timeout);
