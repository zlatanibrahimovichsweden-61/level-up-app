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

  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  Future<String?> readAccessToken() => _storage.read(key: _kAccess);
  Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);

  Future<void> clear() => _storage.deleteAll();
}
