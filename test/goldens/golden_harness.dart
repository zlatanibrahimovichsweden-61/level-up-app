import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// Shared harness for the Day 7b goldens.
///
/// Deliberately package-free — Flutter's own `matchesGoldenFile` plus a
/// `FontLoader`, no golden_toolkit. Regenerate with:
///
///     flutter test --update-goldens test/goldens
///
/// The bundled fonts MUST be loaded first. Without them every string renders in
/// the test framework's placeholder face, at which point a golden guards
/// colours and boxes but says nothing about spacing — which is most of what
/// this pass changed.
///
/// Loaded from `FontManifest.json` rather than a hardcoded list, so this covers
/// Inter/Tajawal/Cairo *and* MaterialIcons. Missing the last one is quiet and
/// costly: `Icons.*` render as empty squares and a golden of the level card
/// would then bless a blank box where the medallion placeholder should be.
Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final manifest =
      json.decode(await rootBundle.loadString('FontManifest.json')) as List;
  for (final family in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(family['family'] as String);
    for (final font in (family['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }

  _stubPathProvider();
}

/// `HomeHeader` carries a `CachedNetworkImage`, whose cache manager reaches for
/// `path_provider` on first build. Unstubbed that throws a
/// `MissingPluginException` and fails the test around it — nothing to do with
/// the pixels under inspection. The avatar itself still falls back to its
/// placeholder, which is what the golden should capture anyway.
void _stubPathProvider() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (_) async => '.dart_tool/golden_cache',
      );
}

/// The two canvases every golden is captured in.
const goldenBrightnesses = <String, Brightness>{
  'light': Brightness.light,
  'dark': Brightness.dark,
};

ThemeData themeFor(Brightness brightness) =>
    brightness == Brightness.light ? AppTheme.light : AppTheme.dark;

/// Wraps [child] in the real app theme + localizations, centred on the canvas
/// background so a widget's own fill is distinguishable from the page's.
///
/// The `RepaintBoundary` is what keeps a capture tight: `matchesGoldenFile`
/// snapshots the nearest enclosing boundary, so without one every golden is the
/// whole surface with the subject adrift in the middle of it.
Widget goldenApp({
  required Widget child,
  required Brightness brightness,
  Locale locale = const Locale('en'),
}) {
  final theme = themeFor(brightness);
  return MaterialApp(
    locale: locale,
    theme: theme,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(
        child: RepaintBoundary(
          // The canvas fill has to be INSIDE the boundary. Outside it, the
          // capture is transparent-backed, and a dark-canvas golden then reads
          // as cream-on-white — which hides exactly the light/dark contrast
          // these goldens exist to check.
          child: ColoredBox(
            color: theme.scaffoldBackgroundColor,
            child: Padding(padding: const EdgeInsets.all(12), child: child),
          ),
        ),
      ),
    ),
  );
}
