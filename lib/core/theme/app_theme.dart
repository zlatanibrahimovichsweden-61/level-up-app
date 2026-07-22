import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The two ThemeData objects. One screen widget renders BOTH themes at runtime
/// (MaterialApp.theme / darkTheme). Screens never hardcode a color — they read
/// Theme.of(context).colorScheme.
///
/// TODO(figma): seed colors, typography, spacing and radii are placeholders
/// until Figma tokens are pulled (see app_colors.dart). School vs University
/// accent switching will be layered on later as theme variants.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.schoolSeed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
