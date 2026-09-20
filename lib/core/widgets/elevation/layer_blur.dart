/// Figma's **layer blur**, as opposed to its background blur.
library;

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// Blurs the child ITSELF, at [sigma], and optionally fades it to [opacity].
///
/// **Layer blur is not background blur.** Figma's background blur is what
/// `GlassStyle.frost` models — it blurs what is *behind* a surface, and the
/// surface stays sharp. Layer blur blurs the layer's own pixels; the thing you
/// are looking at goes soft. `ImageFiltered` is Flutter's version of exactly
/// that, and `BackdropFilter` is the other one. Reaching for the wrong one
/// produces a plausible picture of the wrong effect, which is why they are
/// named apart here.
///
/// **σ = B/2** (edit1.md R3). Figma's panel reports a blur DIAMETER; Flutter's
/// `ImageFilter.blur` takes a standard deviation. Every call site passes the
/// sigma, already halved, so the conversion happens once at the token and not
/// once per use.
///
/// **`TileMode.decal`, not the default `clamp`.** `clamp` smears the edge
/// pixels outward for ever, so a blurred illustration would bleed a band of
/// its own border colour across the card behind it. `decal` treats everything
/// outside the child as transparent, which is what Figma's layer blur does and
/// what a glow has to do to read as a glow.
///
/// This lives in `lib/core/widgets/elevation/` because that folder and
/// `lib/core/theme/` are the only two the elevation guard exempts from the
/// `ImageFilter.blur` ban (`test/guards/project_rules_test.dart`). A blur
/// written at a call site is the same defect class as a shadow written at one.
class LayerBlur extends StatelessWidget {
  const LayerBlur({
    super.key,
    required this.sigma,
    required this.child,
    this.opacity = 1.0,
  }) : assert(sigma >= 0),
       assert(opacity >= 0 && opacity <= 1);

  /// The Gaussian standard deviation, i.e. Figma's blur value halved.
  final double sigma;

  /// Figma's layer opacity, applied OVER the blur so the two compose the way
  /// they do in the file: a 53% layer that is also blurred, not a blur of
  /// something already faded (which would be the same image at a different
  /// alpha, and is not what the panel describes).
  final double opacity;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // A zero-sigma `ImageFilter.blur` is a real compositing layer that does
    // nothing, so the no-op case is skipped rather than paid for.
    Widget out = sigma <= 0
        ? child
        : ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: sigma,
              sigmaY: sigma,
              tileMode: ui.TileMode.decal,
            ),
            child: child,
          );
    if (opacity < 1) out = Opacity(opacity: opacity, child: out);
    return out;
  }
}
