import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Typed wrapper over FlutterSecureStorage. Raw storage never leaks out of
/// core. Tokens live in Keychain/Keystore only — mandatory (minors' data).
/// Never log token values.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kDeviceId = 'device_id';

  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  Future<String?> readAccessToken() => _storage.read(key: _kAccess);
  Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);

  /// Logout MUST use this, NOT [clear]: it deletes only the tokens and preserves
  /// `_kDeviceId`. Wiping the device id would make the next login look like a
  /// brand-new device and mis-trigger the `session_superseded` eviction (adr-019).
  Future<void> clearTokens() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  /// Full wipe of ALL keys, including the device id. Use only for a true reset
  /// (e.g. account deletion / reinstall semantics) — never for logout; use
  /// [clearTokens] there.
  Future<void> clear() => _storage.deleteAll();

  /// The stable device-binding id (adr-019). Generated once and persisted, so
  /// it survives app restarts; because secure storage is cleared on uninstall
  /// it regenerates on reinstall — exactly what the device-eviction flow needs.
  /// A NEW id later evicts the old session (`session_superseded`).
  ///
  /// 32 hex chars (128 bits) — well under the contract's `deviceId` maxLength 64.
  Future<String> readOrCreateDeviceId() async {
    final existing = await _storage.read(key: _kDeviceId);
    if (existing != null && existing.isNotEmpty) return existing;

    final rng = Random.secure();
    final id = List<String>.generate(
      32,
      (_) => rng.nextInt(16).toRadixString(16),
    ).join();
    await _storage.write(key: _kDeviceId, value: id);
    return id;
  }
}
