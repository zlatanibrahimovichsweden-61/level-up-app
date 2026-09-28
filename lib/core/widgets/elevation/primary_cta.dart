/// The call-to-action elevation wrapper.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/app_elevation.dart';
import '../../theme/glass_mapping.dart';
import 'figma_shadow_painter.dart';

/// Which CTA a button is, in the design's terms.
enum CtaTone {
  /// The filled primary button. The only tone that carries the dark canvas's
  /// glow.
  primary,

  /// The filled destructive button — the Logout dialog's red "No"
  /// (`Frame 1000003068`). Same shadow as [primary], no glow: the frame draws
  /// none.
  destructive,

  /// A filled brand button the frame draws with [primary]'s shadow and WITHOUT
  /// the dark glow: the Logout dialog's "Yes" (`Frame 427319502` in `180:4704`
  /// and `337:7783`, edit2 #12). API→UI Wave 19.
  shadowOnly,

  /// The outlined secondary button (onboarding, login). Its own shadow token.
  outline,
}

/// Paints a CTA's shadow — and, on the dark canvas, its glow — **outside** the
/// button, leaving the button itself untouched.
///
/// **Why a wrapper and not the button theme.** `ButtonStyle.backgroundBuilder`
/// is the natural place for this, and it does not work:
/// `ButtonStyleButton` defaults to `Clip.antiAlias` when a background builder
/// is present, so anything drawn outside the button's own bounds — which is
/// the entire point of a drop shadow — is clipped away (verified in the SDK
/// 3.44.7 source, `button_style_button.dart`). Wrapping instead keeps the
/// child's ink, its semantics and its own layout exactly as they were.
///
/// The radius matches the `FilledButton` theme's shape, so the halo follows the
/// button's corners rather than a rectangle behind them.
class PrimaryCta extends StatelessWidget {
  const PrimaryCta({
    super.key,
    required this.child,
    this.tone = CtaTone.primary,
    this.enabled = true,
  });

  final Widget child;
  final CtaTone tone;

  /// When false every alpha is multiplied by 0.45 — the project's existing
  /// disabled convention (`kProfileDisabledOpacity`, and the FilledButton
  /// theme's own disabled colours). Figma draws no disabled state, so this is
  /// the build's convention applied consistently, not an invented value
  /// (edit1.md R10).
  final bool enabled;

  /// `FilledButtonThemeData`'s `RoundedRectangleBorder(radius: 20)`.
  static const _radius = 20.0;

  /// `kProfileDisabledOpacity`.
  static const _disabledOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elevation = theme.extension<AppElevation>()!;
    final dim = enabled ? 1.0 : _disabledOpacity;

    final shadows = tone == CtaTone.outline
        ? elevation.outlineCtaShadows
        : elevation.primaryCtaShadows;

    // The glow is the primary tone's alone: the destructive button and the
    // outline button have none in any frame.
    final glowBlur = tone == CtaTone.primary
        ? elevation.primaryCtaGlowLayerBlur
        : null;

    return CustomPaint(
      painter: _CtaPainter(
        shadows: dim == 1
            ? shadows
            : [
                for (final s in shadows)
                  FigmaShadow(
                    color: s.color.withValues(alpha: s.color.a * dim),
                    offset: s.offset,
                    blur: s.blur,
                    spread: s.spread,
                    inset: s.inset,
                  ),
              ],
        // Figma's layer-blur panel value, halved into a sigma exactly as
        // Figma's own CSS export halves it.
        glowSigma: glowBlur == null ? null : glowBlur * kFigmaBlurToSigma,
        glowColor: theme.colorScheme.primary.withValues(alpha: dim),
      ),
      child: child,
    );
  }
}

class _CtaPainter extends CustomPainter {
  const _CtaPainter({
    required this.shadows,
    required this.glowSigma,
    required this.glowColor,
  });

  final List<FigmaShadow> shadows;
  final double? glowSigma;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final shape = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(PrimaryCta._radius),
        ),
      );

    paintFigmaShadows(canvas, shape, shadows);

    final sigma = glowSigma;
    if (sigma != null && sigma > 0) {
      canvas.save();
      // Outside the button only, like the shadow: the fill is opaque, so
      // anything painted under it is invisible anyway, and clipping keeps the
      // two effects on the same rule.
      canvas.clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(shape.getBounds().inflate(sigma * 3 + 1)),
          shape,
        ),
      );
      canvas.drawPath(
        shape,
        Paint()
          ..color = glowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CtaPainter old) =>
      !listEquals(old.shadows, shadows) ||
      old.glowSigma != glowSigma ||
      old.glowColor != glowColor;
}
