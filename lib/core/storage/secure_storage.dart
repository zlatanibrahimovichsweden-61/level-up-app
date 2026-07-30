import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Typed wrapper over FlutterSecureStorage. Raw storage never leaks out of
/// core. Tokens live in Keychain/Keystore only — mandatory (minors' data).
/// Never log token values.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage =
          storage ?? const FlutterSecureStorage(iOptions: _iosOptions);

  /// iOS Keychain policy. Both values are deliberate; do not drop back to the
  /// plugin defaults.
  ///
  /// - `first_unlock_this_device` — the `_this_device` suffix is the load-bearing
  ///   part. Without it the Keychain item is eligible for an encrypted iCloud/
  ///   iTunes backup and can be RESTORED ONTO A DIFFERENT PHONE. Because
  ///   `device_id` lives in this same store, it restores too, so the server sees
  ///   the same device and adr-019's `session_superseded` eviction never fires —
  ///   a restored backup would silently inherit a live session. `first_unlock`
  ///   (rather than `unlocked`) is required so the token is still readable after
  ///   a reboot without the user having opened the app, which the refresh path
  ///   depends on.
  /// - `synchronizable: false` — never sync the tokens to iCloud Keychain.
  ///
  /// Android needs NO options here. flutter_secure_storage 10.x rewrote the
  /// Android backend after Jetpack Security was deprecated: storage is always
  /// encrypted (AES-GCM payload, RSA-OAEP key wrap, keys in the KeyStore).
  /// `AndroidOptions.encryptedSharedPreferences` is DEPRECATED in 10.x — setting
  /// it opts back into the old Jetpack path. Do not add it.
  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    synchronizable: false,
  );

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
