/// The shared segmented control: one track, N equal segments, one selected.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/app_elevation.dart';
import 'elevated_surface.dart';

/// Everything the design says about a segmented track, so the control itself
/// says nothing about design.
///
/// Three screens draw this component — the quiz-type tabs, the leaderboard
/// scope toggle, and Settings > Language — and in Figma they are the same
/// control with different fills and inner shadows. Built three times they
/// drifted three ways; built once with a style object they cannot.
@immutable
class SegmentedTrackStyle {
  const SegmentedTrackStyle({
    required this.trackColor,
    required this.trackRadius,
    required this.selectedColor,
    required this.selectedRadius,
    required this.labelStyle,
    required this.idleLabelColor,
    required this.selectedLabelColor,
    this.trackInsetShadows = const [],
    this.selectedInsetShadows = const [],
    this.segmentPadding = const EdgeInsetsDirectional.symmetric(horizontal: 10),
  });

  final Color trackColor;
  final double trackRadius;

  /// The groove the segments sit in. Dark only in every frame read so far.
  final List<FigmaShadow> trackInsetShadows;

  // There is deliberately **no** idle-segment colour here. An unselected
  // segment is always [selectedColor] at zero alpha, so it cannot paint
  // over the groove — owner ruling 2026-09-20, docs/DESIGN_ISSUES.md #84.
  // This is a knob that was REMOVED, not one that was never added: it
  // existed, and one of the three call sites set it to an opaque colour.
  // See `_Segment.build` for the measurement that closed it.

  final Color selectedColor;
  final double selectedRadius;

  /// The raised look of the selected segment.
  final List<FigmaShadow> selectedInsetShadows;

  /// Metrics only — the colour comes from [idleLabelColor] /
  /// [selectedLabelColor], so one style serves both states.
  final TextStyle labelStyle;
  final Color idleLabelColor;
  final Color selectedLabelColor;

  /// The gap between a segment's edge and its label. Figma reads `Padding 10`
  /// on BOTH segment frames — idle `180:5338`, selected `180:5340` — each of
  /// them an auto-layout frame at `Fill (72.4px) x Fixed (44px)` inside the
  /// 362-wide groove.
  ///
  /// Horizontal only, on purpose. The frame's height is fixed at 44 and its
  /// label is 17 tall, so the vertical 10 drives nothing there either;
  /// modelling it here would only eat the headroom a large text scale needs.
  ///
  /// It became load-bearing when the labels stopped being shrunk: a segment in
  /// the scrolling fallback is exactly as wide as the longest label PLUS this,
  /// so this is what keeps two labels from touching.
  final EdgeInsetsGeometry segmentPadding;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SegmentedTrackStyle &&
          other.trackColor == trackColor &&
          other.trackRadius == trackRadius &&
          listEquals(other.trackInsetShadows, trackInsetShadows) &&
          other.selectedColor == selectedColor &&
          other.selectedRadius == selectedRadius &&
          listEquals(other.selectedInsetShadows, selectedInsetShadows) &&
          other.labelStyle == labelStyle &&
          other.idleLabelColor == idleLabelColor &&
          other.selectedLabelColor == selectedLabelColor &&
          other.segmentPadding == segmentPadding;

  @override
  int get hashCode => Object.hash(
    trackColor,
    trackRadius,
    Object.hashAll(trackInsetShadows),
    selectedColor,
    selectedRadius,
    Object.hashAll(selectedInsetShadows),
    labelStyle,
    idleLabelColor,
    selectedLabelColor,
    segmentPadding,
  );
}

/// A track of equal-width segments, exactly one of them selected.
///
/// RTL comes free: the segments are a `Row`, so the first segment is the
/// leading one on either canvas — no mirroring code, and nothing to forget.
///
/// ---
///
/// **A label is never shrunk to make it fit** — owner ruling 2026-09-19,
/// `docs/DECISIONS.md` D-012.
///
/// The first build wrapped every label in a `FittedBox(BoxFit.scaleDown)`,
/// which is what Figma's fixed 362 x 44 groove implies when the labels are
/// longer than the groove can hold. It cost two things the ruling puts above
/// that geometry: with four quiz types on a 375 dp phone the longest Arabic
/// label painted at **10.2 dp** inside a 16 dp box, and raising the system
/// text size from 1.0x to 1.3x moved it by **nothing at all** — a fixed
/// segment handed straight back whatever the scale added
/// (`docs/DESIGN_ISSUES.md` #81).
///
/// So the track keeps the design's shape and gives up only its fixed WIDTH.
/// Segments stay equal, every label paints at its full scaled size, and when
/// the labels genuinely do not fit the track scrolls — which is what the chip
/// row this replaced already did, on this same screen.
class SegmentedTrack<T> extends StatelessWidget {
  const SegmentedTrack({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
    required this.style,
    this.keyOf,
    this.height = 44,
  });

  final List<T> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T segment) labelOf;

  /// Lets a screen keep the test keys it already had when its hand-rolled
  /// control is replaced by this one.
  final Key? Function(T segment)? keyOf;

  final SegmentedTrackStyle style;

  /// Figma's 44, and fixed rather than a minimum.
  ///
  /// Only the WIDTH was costing readability. Vertically the label has room to
  /// roughly **3x** before it meets the groove — measured, not assumed, and far
  /// past the 1.3x that `docs/RESPONSIVE.md` tests at — so letting the groove breathe
  /// vertically as well would buy nothing and would change a Figma value for it.
  final double height;

  /// The existing `ScopeToggle`'s duration, kept so the two controls do not
  /// animate at visibly different speeds while the migration is half done.
  static const _duration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();

    final track = ElevatedSurface(
      height: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.trackRadius),
      ),
      color: style.trackColor,
      shadows: style.trackInsetShadows,
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _Segment<T>(
                key: keyOf?.call(segment),
                label: labelOf(segment),
                selected: segment == selected,
                onTap: () => onChanged(segment),
                style: style,
                duration: _duration,
              ),
            ),
        ],
      ),
    );

    // Three mechanisms, each doing one job; the `LayoutBuilder` is only there
    // to hand the third one the width it has to work with.
    //
    // `IntrinsicWidth` asks the `Row` how wide it WANTS to be. A row of flex-1
    // children answers `n x widest child` — equal segments sized to the
    // longest label, which is the same "Fill" rule the Figma frame uses, and
    // the reason nothing here has to measure a `TextPainter` by hand.
    //
    // `minWidth` puts the groove back to the full available width whenever
    // that is the larger of the two. This is the common case and it lays out
    // exactly as it did before the ruling: one groove spanning the row, the
    // segments dividing it equally, nothing to scroll.
    //
    // `SingleChildScrollView` is therefore inert until the labels genuinely do
    // not fit, at which point the groove runs past the edge and the overflow
    // is visible and draggable instead of being absorbed by shrinking type.
    // In RTL it starts at the trailing edge on its own, for the same reason
    // the `Row` does.
    //
    // The selected segment never needs scrolling into view: on first build it
    // is the leading one, and after that it is whichever one the student just
    // tapped, which they could only tap because it was on screen.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.hasBoundedWidth ? constraints.maxWidth : 0.0,
          ),
          child: IntrinsicWidth(child: track),
        ),
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.style,
    required this.duration,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final SegmentedTrackStyle style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    // **Always transparent** — owner ruling 2026-09-20,
    // docs/DESIGN_ISSUES.md #84.
    //
    // A segment is the full height of the groove it sits in, so an OPAQUE
    // idle fill paints over the track's inner shadows and flattens the
    // idle half of the control. The style used to expose an
    // `idleSegmentColor` for this and the quiz-type tabs set it to the
    // track's own colour, which looks correct on a light canvas — there
    // the track has no inner shadows and both fills are the same grey —
    // and is a real defect in dark.
    //
    // Measured before the knob was removed: rendering the dark
    // scope-toggle golden both ways differs in **2087 pixels**, every one
    // of them inside the idle segment, concentrated in the two inset-shadow
    // bands. At (34, 12) the opaque version painted the flat track where
    // the transparent one paints the lavender inner glow.
    //
    // [SegmentedTrackStyle.selectedColor] at zero alpha rather than a bare
    // transparent, so the tween below runs one colour's alpha up instead of
    // cross-fading through a third hue.
    final idleFill = style.selectedColor.withAlpha(0);

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: label,
      // The label here IS the child's text, so without this a screen reader
      // announces the segment twice.
      excludeSemantics: true,
      // Excluding the subtree also drops the `GestureDetector`'s tap ACTION,
      // which left this node a button carrying no actions at all: a screen
      // reader could announce which quiz type was selected and offer no way to
      // change it. Re-declared here rather than by dropping the exclusion,
      // which would bring the double announcement back.
      onTap: onTap,
      // The whole segment is the target, not just the label — a 44pt-high
      // segment whose tappable area is the text is a 12pt-high target.
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: TweenAnimationBuilder<double>(
          duration: duration,
          curve: Curves.easeOut,
          tween: Tween<double>(end: selected ? 1 : 0),
          builder: (context, t, _) => ElevatedSurface(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(style.selectedRadius),
            ),
            color: Color.lerp(idleFill, style.selectedColor, t),
            // The token's own lerp rule: same-length lists interpolate, and
            // lists of different lengths swap at the midpoint.
            shadows: FigmaShadow.lerpList(
              const [],
              style.selectedInsetShadows,
              t,
            ),
            // No `FittedBox`. The label is laid out at whatever size the
            // style and the student's text scale ask for, and the track above
            // widens to hold it — see the class doc and D-012.
            child: Center(
              child: Padding(
                padding: style.segmentPadding,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: style.labelStyle.copyWith(
                    color: Color.lerp(
                      style.idleLabelColor,
                      style.selectedLabelColor,
                      t,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
