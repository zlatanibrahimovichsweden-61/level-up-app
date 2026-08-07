import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
// CROSS-FEATURE IMPORT, and deliberate: "disabled" has to LOOK the same on
// every surface of this cluster, so the opacity is the one Step 1 fixed rather
// than a second constant that could drift from it by 0.05 and make two screens
// disagree about what unavailable means.
import '../../profile/widgets/profile_menu_row.dart' show kProfileDisabledOpacity;

const _rowPadding = EdgeInsetsDirectional.fromSTEB(16.5, 14.5, 16.5, 14.5);

/// A pick-one row — a language, a canvas.
///
/// The trailing indicator is the track picker's r=9.5 hollow ring
/// (`trackRadioRing`, Figma `82:1785`) rather than a Material `Radio`, so the
/// one "chosen from a short list" affordance in the app is the same shape
/// wherever it appears.
///
/// Always enabled: both languages and both canvases exist and work. Nothing in
/// this row type has a contract behind it to be missing.
class SettingsChoiceRow extends StatelessWidget {
  const SettingsChoiceRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.swatch,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// The Mode rows lead with a circle of the canvas they select — the frame's
  /// colour circles, of which there are two rather than three
  /// (`seif_fight.md` S26). It is the palette's own `background`, so the swatch
  /// cannot drift from the theme it stands for.
  final Color? swatch;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: _rowPadding,
            child: Row(
              children: [
                if (swatch != null) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: swatch,
                      shape: BoxShape.circle,
                      border: Border.all(color: ext.profileRowBorder, width: 0.5),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 21 / 18,
                      color: ext.textPrimary,
                    ),
                  ),
                ),
                _RadioRing(selected: selected, colour: ext.trackRadioRing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioRing extends StatelessWidget {
  const _RadioRing({required this.selected, required this.colour});

  final bool selected;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 19,
      height: 19,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colour),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

/// A labelled toggle, with the same disabled contract every unavailable control
/// in this cluster carries.
///
/// **A null [onChanged] is a real disabled state, not a no-op callback.** The
/// row is dimmed to [kProfileDisabledOpacity], wrapped in an [IgnorePointer] so
/// nothing in it can receive a gesture, and announced with [disabledHint] as
/// the reason. Four of the toggles on this screen have no endpoint to persist
/// them (`seif_fight.md` S28) and a switch that slides and then silently
/// forgets would be worse than one that visibly cannot move.
///
/// [disabledHint] is null while a save is IN FLIGHT: the row is briefly
/// non-interactive for a reason the student does not need announced, because it
/// is about to become interactive again on its own.
class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.label,
    required this.value,
    this.help,
    this.onChanged,
    this.disabledHint,
  });

  final String label;
  final bool value;

  /// The line under the label. These two toggles ask questions a student cannot
  /// answer from four words (adr-023: one controls being listed at all, the
  /// other controls whether the score shows), so the explanation is part of the
  /// control rather than a tooltip.
  final String? help;

  final ValueChanged<bool>? onChanged;
  final String? disabledHint;

  bool get _enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    Widget row(Widget control) => Padding(
      padding: _rowPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 21 / 18,
                    color: ext.textPrimary,
                  ),
                ),
                if (help != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    help!,
                    style: TextStyle(fontSize: 13, color: ext.hint),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          control,
        ],
      ),
    );

    final control = Switch(value: value, onChanged: onChanged);

    if (!_enabled) {
      // The switch's own node is excluded and replaced by one describing the
      // ROW: `onChanged: null` alone announces a disabled switch with no label
      // and no reason, which tells a student nothing about why.
      return Semantics(
        toggled: value,
        enabled: false,
        label: label,
        hint: disabledHint,
        child: IgnorePointer(
          child: Opacity(
            opacity: kProfileDisabledOpacity,
            child: row(ExcludeSemantics(child: control)),
          ),
        ),
      );
    }

    // Enabled: the whole row is the target, not just the 40pt switch — the
    // label and its explanation are the part a student actually reads, and
    // asking them to hit the control itself is a worse version of the same
    // gesture. The real Switch keeps its own semantics (it is what a screen
    // reader flips) and merges with the label, so the announcement is "Hide my
    // points, switch, off" rather than two disconnected nodes.
    return MergeSemantics(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged!(!value),
          child: row(control),
        ),
      ),
    );
  }
}
