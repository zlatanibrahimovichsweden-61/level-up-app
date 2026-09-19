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
    this.idleSegmentColor,
  });

  final Color trackColor;
  final double trackRadius;

  /// The groove the segments sit in. Dark only in every frame read so far.
  final List<FigmaShadow> trackInsetShadows;

  /// The fill of an UNSELECTED segment. Null means it shows the track.
  final Color? idleSegmentColor;

  final Color selectedColor;
  final double selectedRadius;

  /// The raised look of the selected segment.
  final List<FigmaShadow> selectedInsetShadows;

  /// Metrics only — the colour comes from [idleLabelColor] /
  /// [selectedLabelColor], so one style serves both states.
  final TextStyle labelStyle;
  final Color idleLabelColor;
  final Color selectedLabelColor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SegmentedTrackStyle &&
          other.trackColor == trackColor &&
          other.trackRadius == trackRadius &&
          listEquals(other.trackInsetShadows, trackInsetShadows) &&
          other.idleSegmentColor == idleSegmentColor &&
          other.selectedColor == selectedColor &&
          other.selectedRadius == selectedRadius &&
          listEquals(other.selectedInsetShadows, selectedInsetShadows) &&
          other.labelStyle == labelStyle &&
          other.idleLabelColor == idleLabelColor &&
          other.selectedLabelColor == selectedLabelColor;

  @override
  int get hashCode => Object.hash(
    trackColor,
    trackRadius,
    Object.hashAll(trackInsetShadows),
    idleSegmentColor,
    selectedColor,
    selectedRadius,
    Object.hashAll(selectedInsetShadows),
    labelStyle,
    idleLabelColor,
    selectedLabelColor,
  );
}

/// A track of equal-width segments, exactly one of them selected.
///
/// RTL comes free: the segments are a `Row`, so the first segment is the
/// leading one on either canvas — no mirroring code, and nothing to forget.
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
  final double height;

  /// The existing `ScopeToggle`'s duration, kept so the two controls do not
  /// animate at visibly different speeds while the migration is half done.
  static const _duration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();

    return ElevatedSurface(
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
    final idleFill = style.idleSegmentColor ?? style.selectedColor.withAlpha(0);

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: label,
      // The label here IS the child's text, so without this a screen reader
      // announces the segment twice.
      excludeSemantics: true,
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
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
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
