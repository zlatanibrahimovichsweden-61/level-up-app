import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The two ThemeData objects. ONE widget renders BOTH — MaterialApp picks
/// `theme` or `darkTheme` at runtime based on `themeMode` + system brightness.
/// Screens never hardcode a colour: standard slots come from
/// `Theme.of(context).colorScheme`, custom tokens from
/// `Theme.of(context).extension<AppColors>()!`.
///
/// The primary accent differs by theme (green light / purple dark) — that's a
/// deliberate design choice, carried by two seeds, not one inverted.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    primary: Brand.greenPrimary,
    ext: AppColors.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    primary: Brand.purplePrimary,
    ext: AppColors.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required AppColors ext,
  }) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: const Color(0xFFFCFBF9), // button label in both themes
          surface: ext.background,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // Inter for Latin UI; Arabic has no Inter glyphs, so it falls back to
      // Tajawal (Cairo as a secondary). Bundled — see pubspec fonts + assets/fonts.
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Tajawal', 'Cairo'],
      scaffoldBackgroundColor: ext.background,
      extensions: [ext], // <-- custom tokens travel with the theme
      appBarTheme: AppBarTheme(
        backgroundColor: ext.background,
        foregroundColor: ext.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFFFCFBF9),
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
