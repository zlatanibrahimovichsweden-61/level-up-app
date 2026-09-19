/// The only place in the app that turns a [FigmaShadow] into paint.
///
/// Two rules are implemented here once so no call site has to remember them:
///
/// * **The sigma conversion** (edit1.md R3). Figma's "Blur" is a CSS blur
///   radius; Flutter's `blurRadius` is not. See [FigmaShadow.sigma] and
///   `kFigmaBlurToSigma`.
/// * **Knockout** (edit1.md R4). Every drop shadow in the design file carries
///   `showShadowBehindNode: false`, so an outer shadow is never visible through
///   its own surface. That is invisible on an opaque card and glaringly wrong
///   on the 20%- and 30%-alpha surfaces the dark canvas is built from — which
///   is most of this design. The shadow is therefore clipped to the region
///   *outside* the shape before it is drawn, rather than drawn under a fill and
///   hoped about.
library;

import 'package:flutter/widgets.dart';

import '../../theme/app_elevation.dart';

/// Paints [shadows] for [shape], in list order, bottom first.
///
/// [shape] is in the canvas's own coordinates. Outer and inner shadows may be
/// mixed in one list; each is handled by its own rule.
void paintFigmaShadows(Canvas canvas, Path shape, List<FigmaShadow> shadows) {
  if (shadows.isEmpty) return;
  for (final shadow in shadows) {
    if (shadow.inset) {
      _paintInset(canvas, shape, shadow);
    } else {
      _paintOuter(canvas, shape, shadow);
    }
  }
}

/// Grows [path] by [amount] logical pixels on every side, or shrinks it when
/// [amount] is negative. Returns an empty path if it would vanish.
///
/// **Stated approximation.** CSS spread also grows a corner radius by the same
/// amount; this scales the whole path about its centre, so a radius grows
/// proportionally instead. Every spread in the design file is between -1.06 and
/// 0 pixels, where the two differ by a fraction of a pixel underneath a blur —
/// and the alternative, re-deriving each shape's geometry, would mean this
/// helper could only accept rounded rectangles. The limitation is written down
/// rather than hidden, per the project's "never invent, state what you did"
/// rule.
Path spreadPath(Path path, double amount) {
  if (amount == 0) return path;
  final bounds = path.getBounds();
  if (bounds.isEmpty) return path;
  final sx = (bounds.width + 2 * amount) / bounds.width;
  final sy = (bounds.height + 2 * amount) / bounds.height;
  if (sx <= 0 || sy <= 0) return Path();
  final matrix = Matrix4.identity()
    ..translateByDouble(bounds.center.dx, bounds.center.dy, 0, 1)
    ..scaleByDouble(sx, sy, 1, 1)
    ..translateByDouble(-bounds.center.dx, -bounds.center.dy, 0, 1);
  return path.transform(matrix.storage);
}

/// A rectangle guaranteed to contain [shape] and everything [shadow] can paint
/// around it: the offset, the spread and the blur's own reach (3 sigma covers
/// more than 99.7% of a Gaussian).
Rect _reach(Path shape, FigmaShadow shadow) => shape.getBounds().inflate(
  shadow.offset.distance + shadow.spread.abs() + shadow.sigma * 3 + 1,
);

void _paintOuter(Canvas canvas, Path shape, FigmaShadow shadow) {
  final paint = Paint()..color = shadow.color;
  if (shadow.sigma > 0) {
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.sigma);
  }
  final shifted = spreadPath(shape.shift(shadow.offset), shadow.spread);

  canvas.save();
  // R4: everything inside the surface's own outline is knocked out, so a
  // translucent fill composites over the page, never over its own shadow.
  canvas.clipPath(
    Path.combine(
      PathOperation.difference,
      Path()..addRect(_reach(shape, shadow)),
      shape,
    ),
  );
  canvas.drawPath(shifted, paint);
  canvas.restore();
}

void _paintInset(Canvas canvas, Path shape, FigmaShadow shadow) {
  final paint = Paint()..color = shadow.color;
  if (shadow.sigma > 0) {
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.sigma);
  }
  // CSS inset semantics: fill everything OUTSIDE the offset, spread-shrunk
  // shape, then clip that to the shape. What survives is a shadow cast inward
  // from the edge — a real inset, not an outer shadow imitating one (R7).
  final hole = spreadPath(shape.shift(shadow.offset), -shadow.spread);
  final region = Path.combine(
    PathOperation.difference,
    Path()..addRect(_reach(shape, shadow)),
    hole,
  );

  canvas.save();
  canvas.clipPath(shape);
  canvas.drawPath(region, paint);
  canvas.restore();
}
