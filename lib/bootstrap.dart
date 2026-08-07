import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/providers/core_providers.dart';
import 'core/storage/preferences_store.dart';

/// Shared boot sequence for all three flavors.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(flavor);

  // Awaited BEFORE runApp, and that ordering is the feature.
  //
  // Loading the store from inside a provider would work and would be less code,
  // but the first frame would then paint the DEFAULT canvas in the DEFAULT
  // language and flip to the student's choice once the future resolved. A
  // visible flash of the wrong theme on every cold start is a worse defect than
  // the one persistence exists to fix, so the cost is paid here — where the
  // native splash screen is still up and nobody can see it — and both
  // preference controllers stay synchronous.
  final preferences = await PreferencesStore.load();

  runApp(
    ProviderScope(
      overrides: [preferencesStoreProvider.overrideWithValue(preferences)],
      child: const LevelUpApp(),
    ),
  );
}
