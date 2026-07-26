import 'package:flutter/material.dart';

/// Brand accents. The primary accent FLIPS by theme — green in light, purple in
/// dark — so these are two distinct seeds, not one derived from the other.
/// (Verified from Figma Login: 82:819 light, 337:15652 dark.)
class Brand {
  Brand._();
  static const greenPrimary = Color(0xFF384F47); // light-theme primary
  static const purplePrimary = Color(0xFFAE87E7); // dark-theme primary
}

/// Custom design tokens that are NOT part of Material's ColorScheme
/// (cream background, field fill, link colour…). Carried as a ThemeExtension so
/// they switch automatically with theme brightness. Widgets read them via
/// `Theme.of(context).extension<AppColors>()!` — never a raw hex, never a
/// `light`/`dark` variable directly.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.fieldFill,
    required this.fieldBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.hint,
    required this.link,
    required this.secondaryButtonBorder,
    required this.legalText,
  });

  final Color background;
  final Color fieldFill;
  final Color fieldBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color hint;
  final Color link;
  final Color secondaryButtonBorder;

  /// "By continuing…" legal paragraph base text — green in light, cream in dark
  /// (the LINK spans use [link]).
  final Color legalText;

  /// Light palette — Figma Login 82:819.
  static const light = AppColors(
    background: Color(0xFFFCFBF9),
    fieldFill: Color(0xFFFDFDFD),
    fieldBorder: Color(0xFFD1D1D1),
    textPrimary: Color(0xFF0E0E0E),
    textSecondary: Color(0xFF2C2C2C),
    hint: Color(0xFF696969),
    link: Color(0xFFE67E22), // orange
    secondaryButtonBorder: Brand.greenPrimary,
    legalText: Brand.greenPrimary, // #384F47 green
  );

  /// Dark palette — Figma Login 337:15652.
  static const dark = AppColors(
    background: Color(0xFF232428),
    fieldFill: Color(0x33232428), // rgba(35,36,40,0.2)
    fieldBorder: Color(0xFFFCFBF9),
    textPrimary: Color(0xFFFCFBF9),
    textSecondary: Color(0xFFDCDCDC),
    hint: Color(0xFFFCFBF9),
    link: Color(0xFFAE87E7), // purple
    secondaryButtonBorder: Brand.greenPrimary, // green border kept in both
    legalText: Color(0xFFFCFBF9), // #FCFBF9 cream
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? fieldFill,
    Color? fieldBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? hint,
    Color? link,
    Color? secondaryButtonBorder,
    Color? legalText,
  }) {
    return AppColors(
      background: background ?? this.background,
      fieldFill: fieldFill ?? this.fieldFill,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hint: hint ?? this.hint,
      link: link ?? this.link,
      secondaryButtonBorder: secondaryButtonBorder ?? this.secondaryButtonBorder,
      legalText: legalText ?? this.legalText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      fieldFill: Color.lerp(fieldFill, other.fieldFill, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      link: Color.lerp(link, other.link, t)!,
      secondaryButtonBorder:
          Color.lerp(secondaryButtonBorder, other.secondaryButtonBorder, t)!,
      legalText: Color.lerp(legalText, other.legalText, t)!,
    );
  }
}
