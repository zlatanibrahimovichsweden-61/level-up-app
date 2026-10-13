import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
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
        child: EnvironmentRibbon(child: child!),
      ),
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

/// The engineering-only environment marker (CW18a): a corner ribbon naming the
/// flavor on `Flavor.dev` and `Flavor.staging` builds, so a device that holds
/// one of them can be told apart at a glance. Dev and staging are one installed
/// identity (D-021 Q2), so this ribbon is the only place the difference shows.
///
/// - **Absent in production**, and absent whenever [AppConfig] has not been
///   initialised (a harness that pumps the root widget on its own), which
///   returns [child] untouched - no wrapper, so the production tree is exactly
///   what it was before the ribbon existed.
/// - **Driven by the [Flavor]**, not by `AppConfig.isDev`, which is true for
///   dev and staging alike and cannot tell them apart.
/// - **Stock Flutter [Banner]**: it paints its message itself, so there is no
///   `Text`, no string literal and no ARB key (the message is the flavor's own
///   name, upper-cased), and its painter reports no hit, so it never
///   intercepts a tap.
/// - **Colour**: [AppColors.destructive], the one saturated token that is the
///   same on both canvases, so the ribbon reads alike in light and dark and its
///   white label stays legible. It is an engineering marker, never a student
///   signal; no new token was added for it.
/// - **Corner**: the top RIGHT, physically, in both languages. Flutter's banner
///   paints a 45-degree band over roughly 40 <= x + y <= 57 (dp from the right
///   edge plus dp from the top edge, read from `banner.dart`), so it lies over
///   the OS status icons and the margin around them. The status-bar CLOCK is
///   the OS's, not the app's: it does not follow the language the student
///   picked in Settings, and on an Android device whose SYSTEM language is
///   left-to-right it is at the top LEFT (the walked configuration: an
///   English-locale emulator). A corner that followed the app's layout
///   direction put the ribbon over the clock in Arabic (readiness walk E3, AR
///   screens). A [Banner] has no
///   physical-corner value, only start/end resolved against its
///   `layoutDirection`, so the ribbon pins that to [TextDirection.ltr]: `topEnd`
///   then means the right corner in every locale. The message is the flavor's
///   own Latin name, so its `textDirection` is pinned too. The app's own
///   controls keep at least 20dp clear of the edge and start below the status
///   bar. In English the right corner is the END side (language pill and bell);
///   the closest one, the stadium-shaped language pill, has its nearest painted
///   point about 39dp plus the status-bar height from the corner, which is past
///   the band's outer edge on any status bar of about 18dp or more. In Arabic
///   the right corner is the START side, where the 35dp back chip sits (20dp
///   from the edge, 16dp below the status bar): its nearest painted point is
///   about 46dp plus the status-bar height from the corner, past the band's
///   outer edge on any status bar of about 11dp or more. This is layout
///   reasoning, not a device check. The bottom corners were rejected: the first
///   and last navigation tabs and their labels sit there.
///
/// **Known limit - the pin assumes a left-to-right SYSTEM language.** The
/// corner is decided by the app, not by the OS. A phone whose own language is
/// right-to-left may mirror its status bar (clock at the top right, which is
/// how Android's SystemUI is understood to behave; not observed here), and then
/// the pinned ribbon sits over that clock in BOTH app languages. The class does
/// not read the platform locale, because which corner the OS clock takes on a
/// right-to-left phone, on Android or on iOS, has not been checked on a device
/// and a guess would be worse than a stated gap. To close it: look at an
/// Arabic-system device, and if the clock is mirrored, choose the corner from
/// `PlatformDispatcher.locale` instead of the fixed right corner. The test
/// that pins the present behaviour is the "KNOWN LIMIT" one in
/// `test/core/config/w1_env_indicator_test.dart`.
class EnvironmentRibbon extends StatelessWidget {
  const EnvironmentRibbon({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final flavor = AppConfig.maybeInstance?.flavor;
    return switch (flavor) {
      Flavor.dev || Flavor.staging => Banner(
        message: flavor!.name.toUpperCase(),
        location: BannerLocation.topEnd,
        // Pinned, not inherited: with the ambient direction `topEnd` is the
        // top LEFT in Arabic, over the OS clock. See the class doc.
        layoutDirection: TextDirection.ltr,
        textDirection: TextDirection.ltr,
        color: Theme.of(context).extension<AppColors>()!.destructive,
        child: child,
      ),
      Flavor.prod || null => child,
    };
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
