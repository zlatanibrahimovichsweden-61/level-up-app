/// Throwaway preview entrypoint — NOT a shipping flavor.
///
///   `flutter run -t lib/main_mock.dart -d <device>`
///
/// Mirrors `bootstrap()` but swaps the network layer for the canned backend in
/// `lib/dev/mock_backend.dart`, so every built screen can be walked on a real
/// device while `AppConfig.baseUrl` is still TBD and no server exists.
///
/// This file and `lib/dev/mock_backend.dart` are the ONLY additions — nothing
/// that ships was edited. Injection is a single `dioProvider` override, which
/// is why no production file needed to learn about the mock: `AuthRepository`,
/// `ReferenceRepository` and `RegistrationRepository` all resolve their Dio
/// through that one provider.
///
/// Delete both files to remove the harness entirely.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/providers/core_providers.dart';
import 'core/storage/secure_storage.dart';
import 'dev/mock_backend.dart';

/// Start every launch signed out, at `/login`.
///
/// Without this, verifying with the magic code writes real tokens to the
/// Keystore, and the next launch resolves straight to `/home` — which makes the
/// flow you are trying to walk unreachable without uninstalling the app.
/// Clears ONLY the tokens (never `clear()`), so the `device_id` survives exactly
/// as `AuthController.forceLogout` requires. Flip to `false` if you want to
/// check that a session actually persists across restarts.
const kResetSessionOnLaunch = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Still needed: `refreshDioProvider` is not overridden and reads AppConfig
  // when it is first built.
  AppConfig.init(Flavor.dev);

  if (kResetSessionOnLaunch) {
    await SecureStorage().clearTokens();
  }

  runApp(
    ProviderScope(
      overrides: [dioProvider.overrideWith((ref) => buildMockDio())],
      child: const LevelUpApp(),
    ),
  );
}
