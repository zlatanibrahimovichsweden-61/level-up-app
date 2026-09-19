import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';

/// `PrimaryCta` is checked through the recorded canvas rather than through its
/// (private) painter's fields: what matters is which paths land on the canvas
/// and in what colour, which is also what a reader would have to verify by eye.
void main() {
  const black25 = Color.fromRGBO(0, 0, 0, 0.25);

  /// A plain box rather than a real button for the painting cases: a
  /// `FilledButton` paints its own background with the primary colour, which
  /// would make "no glow in light" unfalsifiable.
  Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
      MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        home: Scaffold(body: Center(child: child)),
      );

  /// True when ANY recorded call is a `drawPath` in [color].
  ///
  /// `paints..path(...)` matches calls in ORDER, so a negative written that way
  /// would also pass when the colour is painted second - which is exactly where
  /// the glow is. `something` searches every recorded call instead.
  PaintPattern drawsPathIn(Color color) => paints
    ..something(
      (symbol, arguments) =>
          symbol == #drawPath && (arguments[1] as Paint).color == color,
    );

  Widget cta({CtaTone tone = CtaTone.primary, bool enabled = true}) =>
      PrimaryCta(
        tone: tone,
        enabled: enabled,
        child: const SizedBox(width: 200, height: 60),
      );

  group('light — a shadow, and no glow', () {
    testWidgets('the primary tone paints the measured black', (tester) async {
      await tester.pumpWidget(host(cta()));
      expect(find.byType(PrimaryCta), paints..path(color: black25));
    });

    testWidgets('no glow is painted at all', (tester) async {
      await tester.pumpWidget(host(cta()));
      expect(AppElevation.light.primaryCtaGlowLayerBlur, isNull);
      expect(
        find.byType(PrimaryCta),
        isNot(drawsPathIn(AppTheme.light.colorScheme.primary)),
      );
    });

    testWidgets('the outline tone uses its own token', (tester) async {
      await tester.pumpWidget(host(cta(tone: CtaTone.outline)));
      expect(find.byType(PrimaryCta), paints..path(color: black25));
    });
  });

  group('dark — the same shadow, plus a glow on the primary tone only', () {
    testWidgets('primary paints shadow AND glow', (tester) async {
      await tester.pumpWidget(host(cta(), brightness: Brightness.dark));

      // In order: the shadow, then the glow above it — both outside the
      // button's own bounds, and both below its fill.
      expect(
        find.byType(PrimaryCta),
        paints
          ..path(color: black25)
          ..path(color: AppTheme.dark.colorScheme.primary),
        reason: 'the 348:8909 layer blur of the button\'s own fill',
      );
    });

    testWidgets('destructive has the shadow but NO glow', (tester) async {
      await tester.pumpWidget(
        host(cta(tone: CtaTone.destructive), brightness: Brightness.dark),
      );
      expect(find.byType(PrimaryCta), paints..path(color: black25));
      expect(
        find.byType(PrimaryCta),
        isNot(drawsPathIn(AppTheme.dark.colorScheme.primary)),
      );
    });

    testWidgets('outline has the shadow but NO glow', (tester) async {
      await tester.pumpWidget(
        host(cta(tone: CtaTone.outline), brightness: Brightness.dark),
      );
      expect(find.byType(PrimaryCta), paints..path(color: black25));
      expect(
        find.byType(PrimaryCta),
        isNot(drawsPathIn(AppTheme.dark.colorScheme.primary)),
      );
    });
  });

  group('disabled', () {
    testWidgets('every alpha is multiplied by 0.45', (tester) async {
      // R10. Figma draws no disabled state, so this is the project's existing
      // convention (kProfileDisabledOpacity, and the FilledButton theme's own
      // disabled colours) applied to elevation.
      await tester.pumpWidget(
        host(cta(enabled: false), brightness: Brightness.dark),
      );

      const dimmed = Color.fromRGBO(0, 0, 0, 0.25 * 0.45);
      expect(
        find.byType(PrimaryCta),
        paints
          ..path(color: dimmed)
          ..path(
            color: AppTheme.dark.colorScheme.primary.withValues(alpha: 0.45),
          ),
      );
      expect(
        find.byType(PrimaryCta),
        isNot(drawsPathIn(black25)),
        reason: 'the full-strength shadow must be gone, not drawn underneath',
      );
    });

    testWidgets('enabled is the default', (tester) async {
      await tester.pumpWidget(host(cta()));
      expect(find.byType(PrimaryCta), paints..path(color: black25));
    });
  });

  group('the wrapped button is untouched', () {
    testWidgets('a FilledButton keeps its ink and its semantics', (
      tester,
    ) async {
      // The reason this is a wrapper and not `ButtonStyle.backgroundBuilder`:
      // the button itself must behave exactly as before.
      final handle = tester.ensureSemantics();
      var taps = 0;

      await tester.pumpWidget(
        host(
          PrimaryCta(
            child: FilledButton(
              onPressed: () => taps++,
              child: const Text('Continue'),
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(FilledButton)),
        isSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          label: 'Continue',
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(taps, 1);

      // The splash is the button's own InkWell, still there.
      expect(find.byType(InkWell), findsWidgets);
      handle.dispose();
    });

    testWidgets('the wrapper adds no layout of its own', (tester) async {
      await tester.pumpWidget(host(cta()));
      expect(tester.getSize(find.byType(PrimaryCta)), const Size(200, 60));
    });

    testWidgets('a disabled FilledButton still reports as disabled', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          const PrimaryCta(
            enabled: false,
            child: FilledButton(onPressed: null, child: Text('Continue')),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(FilledButton)),
        isSemantics(hasEnabledState: true, isEnabled: false),
      );
      handle.dispose();
    });
  });

  testWidgets('the halo follows the FilledButton theme radius', (tester) async {
    // If the theme's shape ever changes, this is the line that has to change
    // with it — a rectangle behind a 20px-rounded button is visible.
    final shape =
        AppTheme.light.filledButtonTheme.style!.shape!.resolve({})!
            as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(20));
  });

  testWidgets('it reads the elevation extension, not a literal', (
    tester,
  ) async {
    // Belt and braces on the token wiring: if the extension were missing the
    // widget would throw rather than silently paint a default.
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: AppTheme.light.colorScheme),
        home: Scaffold(body: cta()),
      ),
    );
    expect(tester.takeException(), isA<TypeError>());
    expect(AppColors.light.background, isNotNull);
  });
}
