import 'package:flutter/material.dart';

/// Design tokens — PLACEHOLDERS.
///
/// TODO(figma): replace with the real values from the Level Up Figma file
/// (fileKey P6044i0giD9TmdQ7C2AmLq). The file carries light + dark canvases and
/// School (green) / University (purple) accents. Pull via the Figma MCP
/// `get_variable_defs` (needs a layer selected in the Figma desktop app), then
/// wire tokens here by their Figma variable names. Never inline raw hex at a
/// call site — widgets read Theme.of(context), always.
class AppColors {
  AppColors._();

  // School track accent (green) — from the "Start learning" button. PLACEHOLDER.
  static const schoolSeed = Color(0xFF2E4A3E);

  // University track accent (purple) — from the points pill. PLACEHOLDER.
  static const universitySeed = Color(0xFF9B7ED9);
}
