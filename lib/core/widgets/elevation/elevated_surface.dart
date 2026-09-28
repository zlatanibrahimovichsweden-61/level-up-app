/// The one widget a component uses to be raised off the page.
library;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/app_elevation.dart';
import 'figma_shadow_painter.dart';
import 'glass_surface.dart';

/// A shaped surface that carries the design's elevation: drop shadows, inner
/// shadows, Figma Glass, lavender back-lights and hairline borders.
///
/// **Geometry stays at the call site; effects come from tokens.** A component
/// still owns its size and its radius, exactly as it does today — what it stops
/// owning is the shadow. Pass the `AppElevation` token for this component, and
/// the two canvases differ correctly without the widget knowing which one it is
/// on: light gets shadows and no Glass, dark gets Glass, a back-light and
/// whatever shadow its own frame kept.
///
/// Paint order, bottom to top (edit1.md §7.4 c): outer shadows (knocked out) ·
/// clip · backdrop frost · back-lights · fill · inner shadows · Glass rim ·
/// hairline border(s) · ink and child.
///
/// It adds **no semantics of its own** — a raised rectangle is not a control.
/// Wrap it, or pass [onTap] and let the `InkWell` carry the affordance.
class ElevatedSurface extends StatelessWidget {
  const ElevatedSurface({
    super.key,
    required this.child,
    required this.shape,
    this.color,
    this.side,
    this.topSide,
    this.shadows = const [],
    this.glass,
    this.backlights = const [],
    this.backdrop = GlassBackdrop.uniform,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;

  /// `RoundedRectangleBorder`, `StadiumBorder`, `CircleBorder` — directional
  /// radii included, which is why the shape is resolved with the ambient
  /// [TextDirection] rather than at the call site.
  final ShapeBorder shape;

  /// The fill. May be translucent: the knockout above is what makes a 20% wash
  /// composite over the page instead of over its own shadow.
  final Color? color;

  /// A uniform hairline. Any width, including the design's 0.03.
  final BorderSide? side;

  /// A top-only hairline — the light search field draws one. Clipped to the
  /// shape, so it stops at the corner arcs.
  final BorderSide? topSide;

  /// Outer and inset shadows together, in Figma's own order.
  final List<FigmaShadow> shadows;

  /// Null on a canvas whose frame has no Glass. That is a reading, not a gap.
  final GlassStyle? glass;

  /// Requires [glass]: a back-light is only visible through a frost (R6).
  final List<Backlight> backlights;

  final GlassBackdrop backdrop;

  /// Optional ink. The splash paints above the fill and below the child.
  final VoidCallback? onTap;

  final Clip clipBehavior;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    assert(
      backlights.isEmpty || glass != null,
      'A back-light is a solid ellipse made visible by the covering surface\'s '
      'frost (edit1.md R6). Without a GlassStyle it would render as a hard '
      'lavender blob. Pass the surface\'s glass token, or drop the back-light.',
    );

    final direction = Directionality.of(context);
    final outer = <FigmaShadow>[
      for (final s in shadows)
        if (!s.inset) s,
    ];
    final inset = <FigmaShadow>[
      for (final s in shadows)
        if (s.inset) s,
    ];

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: onTap, customBorder: shape, child: content),
      );
    }

    Widget surface = CustomPaint(
      painter: _SurfacePainter(
        shape: shape,
        direction: direction,
        color: color,
        side: side,
        topSide: topSide,
        insetShadows: inset,
        glass: glass,
        backlights: backlights,
      ),
      child: content,
    );

    final frost = glass?.frostSigma ?? 0;
    if (backdrop == GlassBackdrop.content && frost > 0) {
      surface = Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: frost, sigmaY: frost),
              child: const SizedBox.expand(),
            ),
          ),
          surface,
        ],
      );
    }

    Widget clipped = ClipPath(
      clipper: _ShapeClipper(shape, direction),
      clipBehavior: clipBehavior,
      child: surface,
    );

    if (width != null || height != null) {
      clipped = SizedBox(width: width, height: height, child: clipped);
    }

    return CustomPaint(
      painter: _OuterShadowPainter(
        shape: shape,
        direction: direction,
        shadows: outer,
      ),
      child: clipped,
    );
  }
}

class _ShapeClipper extends CustomClipper<Path> {
  const _ShapeClipper(this.shape, this.direction);

  final ShapeBorder shape;
  final TextDirection direction;

  @override
  Path getClip(Size size) =>
      shape.getOuterPath(Offset.zero & size, textDirection: direction);

  @override
  bool shouldReclip(_ShapeClipper old) =>
      old.shape != shape || old.direction != direction;
}

/// Everything under the child, in one painter: back-lights, fill, inner
/// shadows, the Glass rim and the hairlines.
class _SurfacePainter extends CustomPainter {
  const _SurfacePainter({
    required this.shape,
    required this.direction,
    required this.color,
    required this.side,
    required this.topSide,
    required this.insetShadows,
    required this.glass,
    required this.backlights,
  });

  final ShapeBorder shape;
  final TextDirection direction;
  final Color? color;
  final BorderSide? side;
  final BorderSide? topSide;
  final List<FigmaShadow> insetShadows;
  final GlassStyle? glass;
  final List<Backlight> backlights;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = shape.getOuterPath(rect, textDirection: direction);

    // Clipped here as well as by the ClipPath above, so the painter is correct
    // on its own — a caller passing Clip.none still gets a rim that does not
    // spill over the edge.
    canvas.save();
    canvas.clipPath(path);

    final style = glass;
    if (style != null && backlights.isNotEmpty) {
      paintBacklights(canvas, size, backlights, style, direction);
    }

    if (color != null) {
      canvas.drawPath(path, Paint()..color = color!);
    }

    paintFigmaShadows(canvas, path, insetShadows);

    if (style != null) {
      paintGlassRim(canvas, path, style);
    }

    final uniform = side;
    if (uniform != null &&
        uniform.style != BorderStyle.none &&
        uniform.width > 0) {
      // Inset by half the stroke so the full width lands INSIDE the shape
      // rather than half of it being clipped away.
      canvas.drawPath(
        spreadPath(path, -uniform.width / 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = uniform.width
          ..color = uniform.color,
      );
    }

    final top = topSide;
    if (top != null && top.style != BorderStyle.none && top.width > 0) {
      final y = top.width / 2;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..strokeWidth = top.width
          ..color = top.color,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SurfacePainter old) =>
      old.shape != shape ||
      old.direction != direction ||
      old.color != color ||
      old.side != side ||
      old.topSide != topSide ||
      !listEquals(old.insetShadows, insetShadows) ||
      old.glass != glass ||
      !listEquals(old.backlights, backlights);
}

class _OuterShadowPainter extends CustomPainter {
  const _OuterShadowPainter({
    required this.shape,
    required this.direction,
    required this.shadows,
  });

  final ShapeBorder shape;
  final TextDirection direction;
  final List<FigmaShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    if (shadows.isEmpty) return;
    paintFigmaShadows(
      canvas,
      shape.getOuterPath(Offset.zero & size, textDirection: direction),
      shadows,
    );
  }

  @override
  bool shouldRepaint(_OuterShadowPainter old) =>
      old.shape != shape ||
      old.direction != direction ||
      !listEquals(old.shadows, shadows);
}
