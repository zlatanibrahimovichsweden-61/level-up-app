import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';

/// Typography's version of `palette_discipline_test.dart`, and deliberately its
/// twin — same exemption, same shape, same reasoning — so a reviewer who knows
/// one already knows this one.
///
/// The palette rule is the only rule this project has ever written that did not
/// decay: one guard, 36k lines, zero exceptions. Every rule left as prose
/// drifted. Typography was the worst case — `docs/RISKS.md` R-1 recorded **153
/// inline `fontSize` values across 49 files**, and a ratchet that could only
/// stop it getting worse, because there was no scale to migrate onto. Figma
/// defined exactly one text style and twelve day-briefs carried no numbers.
///
/// The designer supplied the scale on 2026-08-21 (`typography-style-inter.md`).
/// [AppType] transcribes it. This guard is what stops the 153 coming back.
void main() {
  /// Every Dart file under `lib/`, minus the design system itself.
  /// `lib/core/theme/` is where type metrics are SUPPOSED to live, so it is the
  /// one exemption — exactly as it is for colour.
  List<File> callSiteSources() => Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.endsWith('.g.dart'))
      .where((f) => !f.path.endsWith('.freezed.dart'))
      .where((f) => !f.path.replaceAll(r'\', '/').contains('lib/core/theme/'))
      .toList();

  /// `path:line — text` for every match, so a failure names the file to fix
  /// rather than just reporting that a number moved.
  List<String> hits(RegExp pattern) => [
    for (final file in callSiteSources())
      ...file
          .readAsLinesSync()
          .indexed
          .where((e) => pattern.hasMatch(e.$2))
          .map((e) => '${file.path}:${e.$1 + 1} — ${e.$2.trim()}'),
  ];

  group('no type metric is decided outside the scale', () {
    test('no fontSize at a call site', () {
      expect(
        hits(RegExp(r'fontSize:\s*[0-9]')),
        isEmpty,
        reason:
            'A font size was set at a call site. Sizes come from AppType '
            '(lib/core/theme/app_typography.dart), which transcribes the '
            "designer's scale. Pick the style whose ROLE matches the text — "
            'h1 for a page title, buttonLarge for a primary button label, '
            'captionRegular for helper text — and apply colour with '
            '.copyWith(color: ...). If no style fits, the scale needs a new '
            'entry from the designer; do not invent a size here.',
      );
    });

    test('no fontWeight at a call site', () {
      // Weight is half of a type style. Leaving it callable separately is how
      // the same nominal size ends up in four weights across four screens —
      // which is exactly what the 153 looked like: 18px existed at w400, w500,
      // w600 and bold simultaneously, and no two screens agreed.
      expect(
        hits(RegExp(r'fontWeight:\s*FontWeight\.')),
        isEmpty,
        reason:
            'A font weight was set at a call site. Weight belongs to the type '
            'style, not the widget. Choose the AppType entry that already '
            'carries the weight you want.',
      );
    });
  });

  group('the scale itself', () {
    test('every style sits on the sizes the designer specified', () {
      // The handoff closes with: "Do not create random font sizes inside
      // individual screens." The guard above enforces the "inside screens"
      // half. This half stops the scale itself from growing a size the
      // designer never issued — the more likely long-run failure, because it
      // looks legitimate: it is in the right file, in the right shape.
      // Not `const`: Dart forbids a const Set of doubles (no primitive
      // equality), which is why this is built at runtime.
      final allowed = <double>{28, 24, 20, 18, 16, 14, 12, 11, 10};

      const styles = <String, TextStyle>{
        'displayLarge': AppType.displayLarge,
        'h1': AppType.h1,
        'h2': AppType.h2,
        'h3': AppType.h3,
        'h4': AppType.h4,
        'bodyLarge': AppType.bodyLarge,
        'bodyMedium': AppType.bodyMedium,
        'bodyMediumStrong': AppType.bodyMediumStrong,
        'labelLarge': AppType.labelLarge,
        'labelMedium': AppType.labelMedium,
        'labelSmall': AppType.labelSmall,
        'buttonLarge': AppType.buttonLarge,
        'buttonMedium': AppType.buttonMedium,
        'buttonSmall': AppType.buttonSmall,
        'navActive': AppType.navActive,
        'navDefault': AppType.navDefault,
        'captionRegular': AppType.captionRegular,
        'captionSmall': AppType.captionSmall,
      };

      for (final entry in styles.entries) {
        expect(
          allowed,
          contains(entry.value.fontSize),
          reason:
              '${entry.key} is ${entry.value.fontSize}px, which is not on the '
              "designer's scale (28/24/20/18/16/14/12/10, plus 11 for bottom "
              'navigation only).',
        );
      }
    });

    test('no style names a font family', () {
      // Arabic has no Inter glyphs. `AppTheme` pairs `fontFamily: 'Inter'` with
      // `fontFamilyFallback: ['Tajawal', 'Cairo']`; a family named on the style
      // would win over that pairing and drop the fallback, so Arabic would
      // render tofu or silently fall to the platform default. Half this app's
      // users read Arabic, so this is a correctness test, not a tidiness one.
      for (final style in [
        AppType.displayLarge,
        AppType.h1,
        AppType.h2,
        AppType.h3,
        AppType.h4,
        AppType.bodyLarge,
        AppType.bodyMedium,
        AppType.bodyMediumStrong,
        AppType.labelLarge,
        AppType.labelMedium,
        AppType.labelSmall,
        AppType.buttonLarge,
        AppType.buttonMedium,
        AppType.buttonSmall,
        AppType.navActive,
        AppType.navDefault,
        AppType.captionRegular,
        AppType.captionSmall,
      ]) {
        expect(style.fontFamily, isNull);
        expect(style.fontFamilyFallback, isNull);
      }
    });

    test('no style carries a colour', () {
      // Colour and metrics are separate axes here. If a style carried a colour
      // it would be a colour decided outside AppColors for one theme only, and
      // the palette guard would not see it — it only reads call sites.
      for (final style in [
        AppType.displayLarge,
        AppType.h1,
        AppType.h2,
        AppType.h3,
        AppType.bodyLarge,
        AppType.bodyMedium,
        AppType.labelLarge,
        AppType.buttonLarge,
        AppType.navActive,
        AppType.captionRegular,
      ]) {
        expect(style.color, isNull);
      }
    });

    test('both themes serve the scale through TextTheme', () {
      // Screens use AppType directly, but framework widgets cannot — they read
      // TextTheme. If the bridge is dropped, an AlertDialog title or a
      // FilledButton label silently reverts to Material's stock sizes and the
      // app runs two type systems at once.
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(
          theme.textTheme.labelLarge?.fontSize,
          AppType.buttonLarge.fontSize,
        );
        expect(theme.textTheme.titleLarge?.fontSize, AppType.h2.fontSize);
        expect(
          theme.textTheme.bodyMedium?.fontSize,
          AppType.bodyMedium.fontSize,
        );
        // The two framework AlertDialogs follow the app's own dialogs (h2 over
        // bodyLarge) through dialogTheme, not through the bridge — otherwise
        // they drift back to h3 over 14px the moment someone "simplifies" the
        // theme. Fable style-fitting register SF-07.
        final dialog = theme.dialogTheme;
        expect(dialog.titleTextStyle?.fontSize, AppType.h2.fontSize);
        expect(dialog.titleTextStyle?.fontWeight, AppType.h2.fontWeight);
        expect(dialog.contentTextStyle?.fontSize, AppType.bodyLarge.fontSize);
        expect(
          dialog.contentTextStyle?.fontWeight,
          AppType.bodyLarge.fontWeight,
        );
      }
    });
  });
}
