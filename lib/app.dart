import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Root widget. One app, two themes (light/dark, student-selected), two locales
/// (AR default + RTL / EN + LTR). Direction is handled automatically by the
/// localization delegates — screens use EdgeInsetsDirectional, never Left/Right.
///
/// Both preferences are read from disk before `runApp` (see `bootstrap()`), so
/// the first frame is already the student's canvas and language.
class LevelUpApp extends ConsumerWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // The Login language toggle and the Settings Languages section drive this;
    // Directionality follows the locale.
    final locale = ref.watch(localeProvider);
    // Settings' Mode section drives this (Day 8 step 3). Light is still the
    // default — the provider's initial value, not a constant here.
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Both palettes have been here since Day 0; until Day 8 step 3 nothing
      // could select between them, which is why a whole dark theme was
      // unreachable on a device (docs/DESIGN_ISSUES.md #10). `ThemeMode.system`
      // is deliberately not used — the student picks, the OS does not.
      themeMode: themeMode,
      // The status bar, driven from the canvas — ONE place for the whole app.
      //
      // Most screens draw a custom header rather than an `AppBar`, so Flutter
      // has nothing to infer icon brightness from and the platform default
      // stands: dark glyphs, which vanish against the dark canvas. This is the
      // app's only `SystemUiOverlayStyle`; a per-screen one would be nine
      // copies of the same rule waiting to disagree.
      //
      // Read off `Theme.of` rather than off [themeMode] on purpose — it is the
      // brightness actually in force, so it stays right through the theme
      // animation and would still be right if `system` ever became selectable.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? _darkOverlay
            : _lightOverlay,
        child: child!,
      ),
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

/// System chrome over the cream canvas: dark glyphs.
///
/// Both status-bar keys are needed and they read backwards from each other.
/// `statusBarIconBrightness` is Android's and describes the ICONS;
/// `statusBarBrightness` is iOS's and describes the BACKGROUND behind them, so
/// a light background there yields dark glyphs. Setting only one leaves the
/// other platform on its default.
///
/// Android's navigation bar gets the same treatment, because a white system
/// bar under a `#232428` app is the identical defect one strip lower. Both bars
/// are set TRANSPARENT rather than to a canvas colour: Android 15 ignores the
/// colour entirely under mandatory edge-to-edge, and transparent is the value
/// that behaves the same before and after that. The icon brightness is what
/// actually carries the adaptation, and it still applies on 15+.
const _lightOverlay = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
);

/// System chrome over the `#232428` canvas: light glyphs. The mirror of
/// [_lightOverlay] — see its doc for why the two status-bar keys invert.
const _darkOverlay = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);
