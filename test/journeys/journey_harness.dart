/// Shared harness for the cross-feature JOURNEY tests (`test/journeys/`).
///
/// What makes these different from every other widget test in the suite:
///
/// - They boot **`LevelUpApp` itself** (the root widget, not a hand-rolled
///   `MaterialApp`), through the REAL `routerProvider`, the real redirect
///   guard, the real repositories and the real freezed models.
/// - The only thing replaced is the network: `dioProvider` is overridden with
///   [buildMockDio] (`lib/dev/mock_backend.dart`, the same canned backend
///   `lib/main_mock.dart` runs on a device), so a journey walks several
///   features in one session exactly as a student does, and a request the app
///   was never meant to send is counted rather than hidden behind a stub.
/// - Secure storage is an in-memory fake ([MemorySecureStorage]), the device
///   info is a constant and connectivity is a constant `true`. Nothing else is
///   stubbed: no repository, no notifier, no router.
///
/// **Privacy.** The mock's phone number and tokens are fixtures, but nothing in
/// this directory prints a phone number, an OTP code, a token or a request
/// body: [RequestLog] records `METHOD /path` and nothing else.
///
/// **Time.** Mock responses arrive after [journeyLatency] of fake time, so a
/// bare `pumpAndSettle` (which only waits for FRAMES) can return before a
/// response lands. Use [settle] / [pumpUntil] instead.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/app.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/quiz/screens/screen_protection.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import '../goldens/golden_harness.dart' show loadAppFonts;

/// How long the mock takes to answer, in FAKE time. Short, so a journey is
/// fast, but not zero, so the loading states are really on screen first.
const journeyLatency = Duration(milliseconds: 30);

/// The mock's magic OTP codes (`lib/main_mock.dart`, "At the OTP screen").
const otpSchool = '000000';
const otpUniversity = '111111';
const otpInvalid = '999999';
const otpBanned = '222222';

/// Logical sizes. [pixel8] is the project's reference device (1080x2400 at
/// 2.625), the default for every journey; the narrower ones are what a large
/// share of Egyptian students actually hold.
const pixel8 = Size(412, 915);
const phone390 = Size(390, 844);
const phone375 = Size(375, 812);
const phone360 = Size(360, 800);

/// The total points the mock's `GET /me` starts at
/// (`lib/dev/mock_backend.dart`, `_totalPoints`). A journey asserts the
/// server's NEW total against it after a quiz; if the mock's fixture moves,
/// those assertions fail loudly and this is the one number to update.
const mockStartingPoints = 1250;

/// A phone number the app accepts (`Phone.tryParse`): the staging smoke
/// account's shape, eleven digits after +20 so no real mobile can have it.
const journeyPhone = '010000000001';

/// Loads the REAL bundled fonts (Inter, Tajawal, Cairo, MaterialIcons).
///
/// Call it from `setUpAll` in every journey file. Without it the test
/// framework paints every string in its placeholder face, whose glyphs are
/// roughly half as wide again as Inter - so any width-sensitive claim (an
/// overflow above all) would be about the placeholder, not about the app. It
/// also stubs `path_provider` for the avatar images.
Future<void> loadJourneyFonts() => loadAppFonts();

/// The two locales every journey runs in.
const journeyLocales = ['en', 'ar'];

/// Localisations for [locale], for finders that must follow the language.
AppLocalizations l10nFor(String locale) =>
    lookupAppLocalizations(Locale(locale));

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// Tokens in memory only. A [SecureStorage] by interface, so the app cannot
/// tell it from the Keystore-backed one; nothing is ever written to disk.
class MemorySecureStorage implements SecureStorage {
  MemorySecureStorage({String? access, String? refresh})
    : _access = access,
      _refresh = refresh;

  String? _access;
  String? _refresh;
  String? _deviceId;

  /// Whether a session is stored (never exposes the value).
  bool get hasSession => _access != null && _access!.isNotEmpty;

  /// How many times the tokens were cleared (sign-out) and written (sign-in).
  int clearTokensCalls = 0;
  int writeTokensCalls = 0;

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    writeTokensCalls++;
    _access = access;
    _refresh = refresh;
  }

  @override
  Future<String?> readAccessToken() async => _access;

  @override
  Future<String?> readRefreshToken() async => _refresh;

  @override
  Future<void> clearTokens() async {
    clearTokensCalls++;
    _access = null;
    _refresh = null;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _deviceId = null;
  }

  @override
  Future<String> readOrCreateDeviceId() async => _deviceId ??= 'journey-device';
}

/// Records `METHOD /path` for every request that reaches the (mock) network
/// layer, plus the NAMES of the top-level keys of its JSON body (never a
/// value, a query or a header): a journey may be asked to prove a request was
/// NOT sent, or that a write carried only the field the student changed, but
/// never what a request carried.
class RequestLog extends Interceptor {
  final entries = <String>[];

  /// `METHOD /path` -> the body key names of each such request, in order.
  final bodyKeys = <String, List<Set<String>>>{};

  /// The query parameters whose VALUES are safe to keep (an enum or a number,
  /// never anything a student typed or an identifier). Every other parameter
  /// is dropped.
  static const _safeQuery = {'language', 'scope', 'category', 'limit'};

  /// `METHOD /path` -> the safe query parameters of each such request.
  final queries = <String, List<Map<String, String>>>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final entry = '${options.method.toUpperCase()} ${options.path}';
    entries.add(entry);
    final data = options.data;
    if (data is Map) {
      bodyKeys.putIfAbsent(entry, () => []).add({
        for (final key in data.keys) key.toString(),
      });
    }
    queries.putIfAbsent(entry, () => []).add({
      for (final e in options.queryParameters.entries)
        if (_safeQuery.contains(e.key)) e.key: '${e.value}',
    });
    handler.next(options);
  }

  /// The safe query parameters of the most recent `METHOD /path` request.
  Map<String, String>? lastQuery(String method, String path) {
    final all = queries['${method.toUpperCase()} $path'];
    return all == null || all.isEmpty ? null : all.last;
  }

  /// The body key names of the most recent `METHOD /path` request, or null
  /// when there was none (or it carried no JSON object).
  Set<String>? lastBodyKeys(String method, String path) {
    final all = bodyKeys['${method.toUpperCase()} $path'];
    return all == null || all.isEmpty ? null : all.last;
  }

  /// How many requests matched [method] and (exactly) [path].
  int count(String method, String path) =>
      entries.where((e) => e == '${method.toUpperCase()} $path').length;

  /// How many requests whose path starts with [prefix], any method.
  int countPrefix(String prefix) =>
      entries.where((e) => e.split(' ').last.startsWith(prefix)).length;

  /// A copy of everything so far, for before/after comparisons.
  List<String> snapshot() => List<String>.of(entries);
}

/// Records the calls screenshot protection would have made.
class RecordingProtection extends ScreenProtection {
  int enableCalls = 0;
  int disableCalls = 0;

  @override
  Future<void> enable() async => enableCalls++;

  @override
  Future<void> disable() async => disableCalls++;
}

/// The device's connection, as a journey sees it: one switch that drives BOTH
/// halves of "offline" the way a real handset does.
///
/// - `isOnlineProvider` (what the screens read to draw the offline banner and
///   disable their primary action) follows [connectivity];
/// - while off, every request that reaches the network layer is rejected with a
///   `connectionError`, which the app's own `ErrorInterceptor` maps to its
///   `NetworkException` - exactly what a dead radio produces. The request is
///   still COUNTED by [RequestLog] (it was attempted), so a journey can tell
///   "never tried" from "tried and failed".
///
/// Starts online, so a journey that never touches it behaves as before.
class NetworkSwitch extends Interceptor {
  NetworkSwitch({bool online = true}) : _online = online;

  bool _online;
  final _changes = StreamController<bool>.broadcast();

  bool get online => _online;

  /// The stream behind `isOnlineProvider`: the current value first, then every
  /// change.
  Stream<bool> get connectivity async* {
    yield _online;
    yield* _changes.stream;
  }

  /// Flips the connection and tells every listener.
  void setOnline(bool value) {
    _online = value;
    _changes.add(value);
  }

  /// Tears the stream down with the journey.
  Future<void> close() => _changes.close();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_online) return handler.next(options);
    // `true`: the error continues to the interceptors after this one, so the
    // app's ErrorInterceptor maps it as it would a real socket failure.
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
      true,
    );
  }
}

/// Holds the answer to chosen requests until the journey lets them go.
///
/// The way to look at a screen while its own request is still in flight: with
/// the answer held, anything on screen came from somewhere ELSE - a cache, a
/// previous student, a previous session. The request is already counted by
/// [RequestLog] (this sits after it), so a journey can tell "asked, not
/// answered" from "never asked". Nothing is held unless a journey says so.
///
/// A request is named like [RequestLog] names it: `METHOD /path`, exact.
class ResponseGate extends Interceptor {
  final _held = <String, Completer<void>>{};

  String _key(String method, String path) => '${method.toUpperCase()} $path';

  /// From now on, requests for `METHOD path` wait in [onRequest] until
  /// [release]. Holding what is already held changes nothing.
  void hold(String method, String path) =>
      _held.putIfAbsent(_key(method, path), Completer<void>.new);

  /// Lets every waiting request for `METHOD path` through, and stops holding
  /// it.
  void release(String method, String path) =>
      _held.remove(_key(method, path))?.complete();

  /// Whether `METHOD path` is being held.
  bool isHolding(String method, String path) =>
      _held.containsKey(_key(method, path));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final held = _held[_key(options.method, options.path)];
    if (held != null) await held.future;
    handler.next(options);
  }
}

// ---------------------------------------------------------------------------
// The journey
// ---------------------------------------------------------------------------

/// A booted app and everything a test needs to inspect it.
class Journey {
  Journey._({
    required this.container,
    required this.requests,
    required this.storage,
    required this.protection,
    required this.network,
    required this.gate,
    required this.errors,
    required this.exits,
  });

  final ProviderContainer container;
  final RequestLog requests;

  /// The connection: `journey.network.setOnline(false)` drops it.
  final NetworkSwitch network;

  /// Holds the answer to chosen requests: `journey.gate.hold('GET', '/me')`.
  final ResponseGate gate;
  final MemorySecureStorage storage;
  final RecordingProtection protection;

  /// Every [FlutterErrorDetails] reported while this journey ran, as text.
  /// Overflows are in here (they are reported, not thrown).
  final List<String> errors;

  /// How many times the app asked the OS to close it (`SystemNavigator.pop`) —
  /// i.e. a system Back that nothing inside the app handled.
  final List<String> exits;

  GoRouter get router => container.read(routerProvider);

  /// Where the real router is now. `state.uri`, NOT
  /// `routerDelegate.currentConfiguration.uri`, which stays on the last
  /// declarative match after an imperative push.
  String get location => router.state.uri.toString();

  AuthStatus get auth => container.read(authControllerProvider);

  /// The overflow errors reported so far (the framework's own wording).
  List<String> get overflows =>
      errors.where((e) => e.contains('overflowed')).toList();

  /// Where the app is and what it has asked for, for a failure message. Never
  /// includes a request body, a phone number or a token.
  String diagnostics(WidgetTester tester) =>
      'router at $location; requests so far: ${requests.entries}; '
      'on screen: ${visibleTexts(tester).take(12).toList()}';
}

/// Per-test state shared between [journeyTest] and [bootJourney].
class _JourneyScope {
  final errors = <String>[];
  final exits = <String>[];
}

_JourneyScope? _scope;

/// `testWidgets` for a journey.
///
/// It owns the one thing that cannot live in a `setUp`: the framework-error
/// capture. Overflows are REPORTED by Flutter (not thrown), so a journey that
/// wants to say which screen overflowed has to see them; but every other
/// error must still fail the test the ordinary way. So `FlutterError.onError`
/// is replaced by a filter that records overflows and forwards everything else
/// to the handler the binding installed, and it is put back in a `finally`,
/// BEFORE the binding judges the test. Restoring it in `addTearDown` runs too
/// late, and a failing `expect` is then reported as the binding's "overrode
/// FlutterError.onError" assertion instead of as itself.
void journeyTest(
  String description,
  Future<void> Function(WidgetTester tester) body, {
  Timeout? timeout,
}) {
  testWidgets(description, (tester) async {
    final scope = _JourneyScope();
    final previousScope = _scope;
    _scope = scope;
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) {
        scope.errors.add(details.toString());
        return;
      }
      previousOnError?.call(details);
    };

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') {
          scope.exits.add(call.method);
        }
        return null;
      },
    );

    try {
      await body(tester);
    } finally {
      FlutterError.onError = previousOnError;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
      _scope = previousScope;
    }
  }, timeout: timeout ?? const Timeout(Duration(minutes: 3)));
}

/// Boots `LevelUpApp` over the mock backend.
///
/// - [locale] `en`/`ar` is applied the way Settings applies it (the provider),
///   before the first frame.
/// - [signedIn] starts with a stored session, exactly like a returning student
///   (cold start resolves to `/home`); otherwise the app starts signed out on
///   onboarding.
/// - [theme] and [textScale] set the canvas and the OS text scale.
/// - [size] is the logical surface; a phone by default.
///
/// Errors reported by the framework are COLLECTED into [Journey.errors] rather
/// than failing the test on the spot, so a journey can say precisely which
/// screen overflowed. Call [expectCleanJourney] (or assert on the lists
/// yourself) at the end.
Future<Journey> bootJourney(
  WidgetTester tester, {
  String locale = 'en',
  bool signedIn = false,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  Duration latency = journeyLatency,
  bool online = true,
}) async {
  final scope =
      _scope ?? (throw StateError('bootJourney must run inside journeyTest'));
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  if (textScale != 1.0) {
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }

  final requests = RequestLog();
  final storage = MemorySecureStorage(
    access: signedIn ? 'journey.access' : null,
    refresh: signedIn ? 'journey.refresh' : null,
  );
  final protection = RecordingProtection();
  final network = NetworkSwitch(online: online);
  addTearDown(network.close);
  final gate = ResponseGate();

  final container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(storage),
      dioProvider.overrideWith((ref) {
        final dio = buildMockDio(latency: latency);
        // First in the chain, so every request is counted before the mock
        // short-circuits it.
        dio.interceptors.insert(0, requests);
        // Second, so a request is counted before it is refused.
        dio.interceptors.insert(1, network);
        // Third, so a held request is counted too, and a refused one (offline)
        // is refused at once rather than held.
        dio.interceptors.insert(2, gate);
        return dio;
      }),
      // The bare client used only by `POST /auth/refresh` reads `AppConfig` when
      // it is built, which a journey must not initialise (it is process-wide
      // static state). The mock never answers 401, so it is never used.
      refreshDioProvider.overrideWith((ref) => Dio()),
      deviceInfoProvider.overrideWith(
        (ref) async =>
            const DeviceInfo(deviceId: 'journey-device', platform: 'android'),
      ),
      isOnlineProvider.overrideWith((ref) => network.connectivity),
      screenProtectionProvider.overrideWithValue(protection),
    ],
  );
  addTearDown(container.dispose);

  container.read(localeProvider.notifier).select(Locale(locale));
  container.read(themeModeProvider.notifier).select(theme);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const LevelUpApp()),
  );
  final journey = Journey._(
    container: container,
    requests: requests,
    storage: storage,
    protection: protection,
    network: network,
    gate: gate,
    errors: scope.errors,
    exits: scope.exits,
  );
  await settle(tester);
  // The environment a journey asked for is the environment it got: a no-op
  // locale, canvas or text-scale setting would make every claim a journey
  // makes about "AR", "dark" or "2.0x" about something else.
  expect(
    directionOf(tester),
    locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
  );
  expect(
    brightnessOf(tester),
    theme == ThemeMode.dark ? Brightness.dark : Brightness.light,
  );
  expect(textScaleOf(tester), textScale);
  return journey;
}

/// Unmounts the app INSIDE the test and lets every disposal timer fire.
///
/// The providers a journey passes through are `autoDispose`. If the binding
/// unmounts the tree itself after the test body, the flutter vsync is already
/// gone, Riverpod schedules each disposal on a zero-length `Timer`, and the
/// binding reports it as pending. (The other suites work around that with
/// `holdBoards`/`holdProfile`; a journey must NOT, because it signs out and a
/// held provider is rebuilt by the sign-out instead of being dropped.)
/// Call this last.
///
/// **Do not end a journey on the OTP screen.** Unmounting the whole tree there
/// leaves the `autoDispose` OTP provider (and its one-second resend timer)
/// alive, and the binding then reports the timer as pending. A normal pop
/// disposes it (probed: `container.exists` is false right after the chip), so
/// this is the harness's limit and not the app's; finish on a later screen.
Future<void> endJourney(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

// ---------------------------------------------------------------------------
// Time
// ---------------------------------------------------------------------------

/// Pumps [duration] of fake time in 50 ms frames. Unlike `pumpAndSettle` this
/// advances timers that schedule no frame (the mock's response latency) and it
/// terminates in the presence of infinite animations (spinners, cursors).
Future<void> settle(
  WidgetTester tester, [
  Duration duration = const Duration(milliseconds: 800),
]) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < duration) {
    await tester.pump(step);
    elapsed += step;
  }
}

/// Pumps until [finder] matches (at least once), or fails with a message that
/// names where the router was. Bounded: a missing widget is a failure, never a
/// hang.
Future<void> pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
  String? reason,
  Journey? journey,
}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (finder.evaluate().isEmpty) {
    if (elapsed >= timeout) {
      fail(
        'Timed out after ${timeout.inSeconds}s waiting for '
        '${finder.describeMatch(Plurality.many)}'
        '${reason == null ? '' : ' ($reason)'}'
        '${journey == null ? '' : '; ${journey.diagnostics(tester)}'}',
      );
    }
    await tester.pump(step);
    elapsed += step;
  }
  // One more beat so the route transition that revealed it finishes.
  await settle(tester, const Duration(milliseconds: 400));
}

// ---------------------------------------------------------------------------
// Interaction
// ---------------------------------------------------------------------------

/// A lazily built list only builds the rows near the viewport, so a row the
/// student scrolled past (or one that a taller layout pushed below the fold) is
/// not in the tree at all. A student scrolls to it; so does this - up first (a
/// list that kept its place is more often scrolled down than up), then down.
/// Does nothing when [finder] already matches or there is no vertical list.
Future<void> _scrollIntoBuild(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isNotEmpty) return;
  final lists = find.byWidgetPredicate(
    (w) =>
        w is Scrollable &&
        (w.axisDirection == AxisDirection.down ||
            w.axisDirection == AxisDirection.up),
  );
  if (lists.evaluate().isEmpty) return;
  for (final delta in const [-300.0, 300.0]) {
    try {
      await tester.scrollUntilVisible(
        finder,
        delta,
        scrollable: lists.first,
        maxScrolls: 30,
      );
      return;
    } on Object {
      // Not in that direction: try the other one.
    }
  }
}

/// Taps [finder] the way a student does: scroll it into view if it is inside a
/// scrollable, then tap, then let the app react.
Future<void> tapOn(
  WidgetTester tester,
  Finder finder, {
  Duration then = const Duration(milliseconds: 800),
}) async {
  await _scrollIntoBuild(tester, finder);
  expect(finder, findsWidgets, reason: 'nothing to tap');
  final target = finder.first;
  // `ensureVisible` is a no-op outside a Scrollable and throws nothing there.
  // The settles around it are not decoration: a text field that just took
  // focus animates its own caret back into view (~100 ms), which would undo
  // the scroll below, and a tap sent while any of that is moving lands where
  // the target WAS. So let it finish first, scroll, then let that finish.
  await settle(tester, const Duration(milliseconds: 300));
  await tester.ensureVisible(target);
  await settle(tester, const Duration(milliseconds: 300));
  await tester.tap(target);
  await settle(tester, then);
}

/// Asserts that a tap at the centre of [finder] would reach it: after the
/// student has scrolled it into view (when it is inside a scrollable), the
/// widget is on screen and nothing - a bottom bar, a header - is drawn over it.
/// A control that is merely BUILT, but sits under the navigation bar, passes
/// `findsOneWidget` and still cannot be used; this is the check that fails
/// there. Does not tap.
Future<void> expectTappable(
  WidgetTester tester,
  Finder finder, {
  String? reason,
}) async {
  await _scrollIntoBuild(tester, finder);
  expect(finder, findsWidgets, reason: reason ?? 'nothing to tap');
  await settle(tester, const Duration(milliseconds: 300));
  await tester.ensureVisible(finder.first);
  await settle(tester, const Duration(milliseconds: 300));
  expect(
    finder.hitTestable(),
    findsWidgets,
    reason: reason ?? 'the control is built but a tap cannot reach it',
  );
}

/// Taps the in-app back chip (the shared `CircleBackButton`). Prefers [key]
/// when the screen exposes one; otherwise the one chip on the visible route
/// (the finder skips off-stage tabs, so an `indexedStack` sibling's chip is
/// never matched).
Future<void> tapBackChip(WidgetTester tester, {Key? key}) async {
  final Finder chip = key != null
      ? find.byKey(key)
      : find.byType(CircleBackButton);
  await tapOn(tester, chip);
}

/// A router-level pop (`GoRouter.pop`): what any code calling `context.pop()`
/// does. Unlike [systemBack] it does NOT consult a `PopScope`, so use it only
/// on a screen with nothing to guard.
Future<void> routerPop(WidgetTester tester, Journey journey) async {
  journey.router.pop();
  await settle(tester);
}

/// The three ways a student (or the platform) leaves a pushed screen.
enum BackWay {
  /// The on-screen back chip.
  chip,

  /// The OS Back (hardware key / gesture): `didPopRoute`, seen by every
  /// `PopScope`.
  os,

  /// `GoRouter.pop()`, which skips `PopScope`.
  routerPop,
}

/// Leaves the current screen [way], and fails if nothing happened: a back chip
/// that does not move is a dead control, an OS Back that asks the OS to close
/// the app is NOT "leaving the screen" (use [systemBack] for that case).
Future<void> leave(
  WidgetTester tester,
  Journey journey,
  BackWay way, {
  Key? chipKey,
}) async {
  final before = journey.location;
  switch (way) {
    case BackWay.chip:
      await tapBackChip(tester, key: chipKey);
    case BackWay.os:
      final exited = await systemBack(tester, journey);
      expect(exited, isFalse, reason: 'OS Back at $before must stay in-app');
    case BackWay.routerPop:
      await routerPop(tester, journey);
  }
  expect(
    journey.location,
    isNot(before),
    reason: '$way at $before did not leave the screen (a dead back control)',
  );
}

/// The OS Back (Android hardware/gesture back): goes through the binding's
/// `didPopRoute`, so the router delegate and every `PopScope` see it exactly as
/// they do on a device. Returns true when NOTHING in the app handled it and the
/// OS was asked to close the app.
Future<bool> systemBack(WidgetTester tester, Journey journey) async {
  final before = journey.exits.length;
  await tester.binding.handlePopRoute();
  await settle(tester);
  return journey.exits.length > before;
}

/// Types [code] into the OTP boxes the way a student does (the sixth digit
/// auto-submits).
Future<void> enterOtp(WidgetTester tester, String code) async {
  await tester.enterText(find.byType(Pinput), code);
  await settle(tester);
}

/// From the Login form: types [journeyPhone], taps Send OTP and waits for the
/// OTP screen.
Future<void> requestOtpViaUi(
  WidgetTester tester,
  Journey journey, {
  required String locale,
}) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  await tester.enterText(find.byType(TextField), journeyPhone);
  await tapOn(tester, find.text(l10nFor(locale).sendOtp));
  await pumpUntil(tester, find.byType(OtpScreen), journey: journey);
}

/// Signs in the way a student does, from onboarding or Login: Log In, phone,
/// Send OTP, the mock code, the success view, Continue. Returns once [landing]
/// (`/home` by default) is the router location.
Future<void> signInViaUi(
  WidgetTester tester,
  Journey journey, {
  required String locale,
  String code = otpSchool,
  String landing = '/home',
}) async {
  final l = l10nFor(locale);
  if (journey.location == '/') {
    await tapOn(tester, find.text(l.logIn));
  }
  await requestOtpViaUi(tester, journey, locale: locale);
  await enterOtp(tester, code);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: journey);
  await tapOn(tester, find.text(l.continueLabel));
  await settle(tester, const Duration(seconds: 1));
  expect(journey.location, landing, reason: 'landing after sign-in');
}

/// The 1-based option number the mock grades correct for question [i]
/// (`lib/dev/mock_backend.dart`, `_MockQuiz.build`: correct index = i % 4).
int mockCorrectOption(int i) => i % 4 + 1;

/// Plays the running quiz to its last question: picks the mock's correct option
/// for each question, confirms it, and moves on, stopping with the "Finish"
/// button on screen (NOT tapped). The caller is on `/quiz/<id>` already.
Future<void> answerQuizToFinish(
  WidgetTester tester,
  Journey journey, {
  required String locale,
  int length = 10,
}) async {
  final l = l10nFor(locale);
  for (var i = 1; i <= length; i++) {
    await pumpUntil(tester, find.text(l.questionLabel(i)), journey: journey);
    await tapOn(
      tester,
      find.text('الخيار رقم ${mockCorrectOption(i)} للسؤال $i'),
    );
    await tapOn(tester, find.text(l.confirm));
    await pumpUntil(
      tester,
      find.text(i == length ? l.finishQuiz : l.next),
      journey: journey,
    );
    if (i < length) await tapOn(tester, find.text(l.next));
  }
}

// ---------------------------------------------------------------------------
// Assertions
// ---------------------------------------------------------------------------

/// The text actually painted on screen, as plain strings, for diagnostics.
List<String> visibleTexts(WidgetTester tester) => [
  for (final e in find.byType(Text).evaluate()) ?(e.widget as Text).data,
];

/// The current text direction at the top of the tree.
TextDirection directionOf(WidgetTester tester) =>
    Directionality.of(tester.element(find.byType(Scaffold).first));

/// The text scale actually in force (what a 10pt run is scaled to, over 10).
double textScaleOf(WidgetTester tester) =>
    MediaQuery.textScalerOf(
      tester.element(find.byType(Scaffold).first),
    ).scale(10) /
    10;

/// The brightness actually in force.
Brightness brightnessOf(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(Scaffold).first)).brightness;

/// Fails if the journey reported a layout overflow that is not in the
/// [knownOverflows] ceiling.
///
/// [knownOverflows] lists substrings of an overflow's ORIGIN (see
/// [overflowOrigin]) for overflows that are a KNOWN, separately recorded
/// defect. It is a ratchet and not an endorsement: the journey still fails on
/// any NEW origin, and a fixed one simply stops appearing. The overflows that
/// were tolerated are printed (`OVERFLOW[label] ...`) so they stay visible.
///
/// A non-overflow framework error never gets here: [journeyTest] forwards it to
/// the binding, which fails the test on the spot.
void expectCleanJourney(
  Journey journey, {
  Set<String> knownOverflows = const {},
  String label = 'journey',
}) {
  final unexpected = <String>[];
  for (final overflow in journey.overflows) {
    final origin = overflowOrigin(overflow);
    final line = '${overflowAmount(overflow)} @ $origin';
    if (knownOverflows.any(origin.contains)) {
      debugPrint('OVERFLOW[$label] (known) $line');
    } else {
      unexpected.add(line);
    }
  }
  expect(unexpected, isEmpty, reason: 'unexpected layout overflow(s)');
}

/// "right 6.0px" - how far and on which side, from the framework's wording.
String overflowAmount(String overflow) {
  final m = RegExp(
    r'overflowed by ([\d.]+) pixels on the (\w+)',
  ).firstMatch(overflow);
  return m == null ? 'overflow' : '${m.group(2)} ${m.group(1)}px';
}

/// Where the overflowing widget was CREATED, from the "relevant error-causing
/// widget" line: `lib/features/...dart:LINE` for the app, the package
/// directory for a dependency (`pinput-6.0.2/lib/...`).
String overflowOrigin(String overflow) {
  final m = RegExp(r'file:///(\S+?\.dart):(\d+)').firstMatch(overflow);
  if (m == null) return 'unknown';
  final path = Uri.decodeFull(m.group(1)!);
  final pub = path.indexOf('/pub.dev/');
  final relative = pub >= 0
      ? path.substring(pub + '/pub.dev/'.length)
      : path.substring(path.contains('/lib/') ? path.indexOf('/lib/') + 1 : 0);
  return '$relative:${m.group(2)}';
}

/// The distinct origins of the overflows reported so far, for ratchet lists
/// and for reporting.
Set<String> overflowOrigins(Journey journey) => {
  for (final o in journey.overflows) overflowOrigin(o),
};

/// The mock school student's name (`_schoolProfile`), as `GET /me` returns it.
const mockStudentName = 'طالب تجريبي';

/// The mock university student's name (`_universityProfile`).
const mockUniversityStudentName = 'طالب جامعي تجريبي';
