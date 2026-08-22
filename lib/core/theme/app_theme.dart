import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

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
      // The designer's scale (typography-style-inter.md, 2026-08-21) projected
      // onto Material's slots, so framework widgets stop drawing Material's
      // stock sizes while the screens around them use the handoff. Carries no
      // colour: `AppType` is metrics only, and ThemeData resolves the colour
      // for each slot from the colour scheme as before.
      textTheme: AppType.textTheme,
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
          // A disabled button keeps ITS OWN colours at reduced opacity rather
          // than falling through to Material's stock grey. Without these two
          // lines every disabled FilledButton in the app — OTP's Verify until
          // six digits are in, Sign Up's Continue, the track submit — renders
          // in a grey that belongs to no theme and reads as a different
          // control. The same rule is already stated per-instance in
          // `ProfileConfirmDialog`; stating it here is what makes it a rule.
          // The 0.45 matches `kProfileDisabledOpacity`, the constant the
          // Profile rows already dim by, so "disabled" looks the same
          // everywhere. Neither value is a Figma value — the frames carry no
          // disabled state — they are this project's existing convention.
          disabledBackgroundColor: primary.withValues(alpha: 0.45),
          disabledForegroundColor: const Color(
            0xFFFCFBF9,
          ).withValues(alpha: 0.7),
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // Every dialog lands on the SAME surface. `AlertDialog` with no theme
      // takes Material 3's seed-derived `surfaceContainerHigh` plus an
      // elevation tint — which is why the "Discard changes?" and "Leave quiz?"
      // dialogs rendered pale green on a cream app while `ProfileConfirmDialog`
      // two files away rendered on `cardFill`. Two dialog systems in one app.
      // Fixing it here rather than at the two call sites means any dialog added
      // later inherits the right surface instead of re-introducing the drift.
      // Values are `ProfileConfirmDialog`'s, which came from Figma `180:4445`.
      dialogTheme: DialogThemeData(
        backgroundColor: ext.cardFill,
        // M3 composites a primary-tinted overlay over `backgroundColor` in
        // proportion to elevation. That tint is the pale green; killing it is
        // the actual fix, not the background colour alone.
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      // The date picker is a THIRD dialog surface, and `DialogThemeData` does
      // not reach it — `DatePickerDialog` reads `DatePickerThemeData` instead.
      // Device-verified 2026-08-21: with only the block above in place, the
      // registration date-of-birth picker still sampled #E3EAE5 (M3's
      // seed-derived pale green) while the AlertDialog beside it sampled
      // #FDFDFD. Same two properties, same reasoning, no new colours — a
      // student should not be able to tell which framework widget they are
      // looking at.
      datePickerTheme: DatePickerThemeData(
        backgroundColor: ext.cardFill,
        surfaceTintColor: Colors.transparent,
        // The header inherits `backgroundColor` (M3 leaves
        // `headerBackgroundColor` transparent), so one value covers both halves.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
