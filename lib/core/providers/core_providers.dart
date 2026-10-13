import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/notifier/auth_controller.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../network/dio_client.dart';
import '../network/interceptors/error_interceptor.dart';
import '../storage/preferences_store.dart';
import '../storage/secure_storage.dart';

/// Core dependency graph. Riverpod IS the DI container — no get_it.
/// Feature providers depend on these.

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

/// The device-preferences store, loaded before `runApp` and injected by
/// `bootstrap()` as an override. It is not constructed here because
/// [PreferencesStore.load] is async and the whole point is that the first frame
/// already knows the answer — a provider that loaded it lazily would paint the
/// default canvas first and flip a frame later.
///
/// **Null means "this launch does not persist preferences."** Widget tests pump
/// the real [LevelUpApp] and must not have to stub a plugin channel to do it, so
/// the unoverridden default is null: the two preference controllers then fall
/// back to their defaults and skip the write. Every entrypoint overrides it;
/// only tests see the null.
final preferencesStoreProvider = Provider<PreferencesStore?>((ref) => null);

/// The bare client used ONLY for `POST /auth/refresh` — no AuthInterceptor, so a
/// 401 during refresh cannot re-enter the retry path.
final refreshDioProvider = Provider<Dio>((ref) {
  return DioClient.createBare(error: ErrorInterceptor());
});

// Explicit left-side type: this file and auth_repository.dart import each other
// (the repository watches dioProvider; dioProvider uses requestTokenRefresh), so
// the annotation keeps type inference from ever looping between them.
final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  // The refresh runs on the bare client and NEVER through authRepositoryProvider.
  // That repository watches THIS provider, so reading it from here is a provider
  // cycle: harmless in release, but in a debug build `Ref.read` asserts and
  // throws `CircularDependencyError`, the interceptor swallows it, and an
  // expired access token can never be refreshed (E4-01). The bare client is a
  // leaf that depends on nothing, so watching it closes no loop.
  final refreshDio = ref.watch(refreshDioProvider);
  return DioClient.create(
    storage: ref.watch(secureStorageProvider),
    authController: ref.read(authControllerProvider.notifier),
    refresh: ({required refreshToken, required deviceId}) =>
        requestTokenRefresh(
          refreshDio,
          refreshToken: refreshToken,
          deviceId: deviceId,
        ),
    error: ErrorInterceptor(),
  );
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

/// Drives the Offline screen state. `true` = at least one active transport.
final isOnlineProvider = StreamProvider<bool>((ref) {
  final conn = ref.watch(connectivityProvider);
  return conn.onConnectivityChanged.map(
    (results) => results.any((r) => r != ConnectivityResult.none),
  );
});
