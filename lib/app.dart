import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Root widget. One app, two themes (light/dark, system-driven), two locales
/// (AR default + RTL / EN + LTR). Direction is handled automatically by the
/// localization delegates — screens use EdgeInsetsDirectional, never Left/Right.
class LevelUpApp extends ConsumerWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // The Login language toggle drives this; Directionality follows the locale.
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
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
