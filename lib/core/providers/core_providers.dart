import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/error_interceptor.dart';
import '../storage/secure_storage.dart';

/// Core dependency graph. Riverpod IS the DI container — no get_it.
/// Feature providers depend on these.

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioClient.create(
    auth: AuthInterceptor(storage),
    error: ErrorInterceptor(),
  );
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

/// Drives the Offline screen state. `true` = at least one active transport.
final isOnlineProvider = StreamProvider<bool>((ref) {
  final conn = ref.watch(connectivityProvider);
  return conn.onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));
});
