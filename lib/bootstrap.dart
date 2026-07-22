import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

/// Shared boot sequence for all three flavors.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(flavor);
  runApp(const ProviderScope(child: LevelUpApp()));
}
