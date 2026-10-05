import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
// CROSS-FEATURE IMPORT, and deliberate: "disabled" has to LOOK the same on
// every surface of this cluster, so the opacity is the one Step 1 fixed rather
// than a second constant that could drift from it by 0.05 and make two screens
// disagree about what unavailable means.
import '../../profile/widgets/profile_menu_row.dart'
    show kProfileDisabledOpacity;

/// The frame's row padding, 16 / 14 (`642:8522`, `176:2387`). It was 16.5 /
/// 14.5, which folded the card's 0.5 hairline into every row's top and bottom;
/// [SettingsSection] now insets its rows by the hairline instead, so the frame's
/// 52-high row holds on both canvases (API→UI Wave 21).
const _rowPadding = EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14);

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
                      border: Border.all(
                        color: ext.profileRowBorder,
                        width: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // The frame's row label — see [SettingsSwitchRow]. Mode has
                    // no rows in Figma (#45), so this stand-in takes the label
                    // every other row in these cards is drawn with.
                    style: AppType.bodyLarge.copyWith(
                      color: ext.settingsRowLabel,
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
                decoration: BoxDecoration(
                  color: colour,
                  shape: BoxShape.circle,
                ),
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
///
/// **The label is the frame's, since API→UI Wave 21:** Inter Regular 16 in
/// `#384F47` light / `#FCFBF9` dark on every row of both cards (`642:8524`,
/// `176:2393`; dark `642:8586`, `337:8198`) — [AppType.bodyLarge] in
/// [AppColors.settingsRowLabel]. It was `h3` (18 / 600) in [AppColors.textPrimary].
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
  /// answer from four words, so the explanation is part of the control rather
  /// than a tooltip. ⚠️ The "Hide my points" line is stale: under adr-111 a
  /// score-hidden student is taken off the board, not listed without a score
  /// (docs/KNOWN_BUGS.md BUG-017, waiting on the owner's wording).
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
                  style: AppType.bodyLarge.copyWith(
                    color: ext.settingsRowLabel,
                  ),
                ),
                if (help != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    help!,
                    style: AppType.captionRegular.copyWith(color: ext.hint),
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

    final control = SettingsToggle(value: value);

    // ONE tree for every state (API→UI Wave 21). A Rank save turns its row
    // disabled and back; with a tree per state the row's semantics node was
    // destroyed and rebuilt twice per flip, and a screen reader's focus went
    // with it. Only what differs changes: the pointer gate, the dimming, the
    // ink.
    //
    // [SettingsToggle] only paints, so the ROW says what a switch says: its
    // toggled state, enabled or not, and — only when enabled — the tap that
    // flips it; disabled, [disabledHint] gives the reason. `MergeSemantics`
    // folds the label and the help line in exactly once: the disabled row used
    // to add `label:` on top of its own `Text` and was announced
    // "Announcements, Announcements" (docs/KNOWN_BUGS.md BUG-018).
    //
    // Enabled, the whole row is the target, not just the 48 x 24 switch — the
    // label and its explanation are the part a student actually reads.
    return MergeSemantics(
      child: Semantics(
        toggled: value,
        enabled: _enabled,
        hint: _enabled ? null : disabledHint,
        child: IgnorePointer(
          ignoring: !_enabled,
          child: Opacity(
            opacity: _enabled ? 1 : kProfileDisabledOpacity,
            // No `InkWell` at all when disabled: a dead control is
            // structurally dead, not a live one with a null callback.
            child: _enabled
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onChanged!(!value),
                      child: row(control),
                    ),
                  )
                : row(control),
          ),
        ),
      ),
    );
  }
}

/// The frame's switch — `Button` `642:8525` (Rank) and `176:2394`…`176:2421`
/// (Notification Preferences), dark `642:8587` / `337:8199`: a 48 x 24 stadium
/// with a 16 dp knob 4 dp in from the end. It replaced Flutter's stock
/// `Switch` in API→UI Wave 21 (owner ruling 2026-09-29): Material 3's is 52 x 32
/// with a knob that grows, and no theme value makes it the frame's shape.
///
/// **Paint only.** It has no gesture and no semantics of its own: the row it
/// sits in is the tap target and says "switch, on" ([SettingsSwitchRow]).
///
/// **ON is the only state the design draws.** The track is `#AE87E7` on both
/// canvases and the knob `#FFFFFF`. OFF moves the knob to the other end over
/// [AppColors.settingsToggleOffTrack], a stand-in grey until the designer draws
/// it (docs/DESIGN_ISSUES.md #107).
///
/// **The knob's ends are PHYSICAL, not directional.** The Arabic frame mirrors
/// the row — the switch moves to the left edge (`549:21822`) — but keeps the ON
/// knob on the switch's RIGHT (`549:21823`, 4 in from the right end), exactly
/// as in English. Built as drawn, like the Languages track's fixed order.
class SettingsToggle extends StatelessWidget {
  const SettingsToggle({super.key, required this.value});

  final bool value;

  /// The frame's `Button`: 48 x 24.
  static const size = Size(48, 24);

  /// The knob (`Container` inside `Button`): 16 x 16, 4 in from the end.
  static const knob = 16.0;
  static const inset = 4.0;

  /// Material's own toggle duration, since the frame specifies no motion.
  static const _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return AnimatedContainer(
      duration: _duration,
      curve: Curves.easeOut,
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(inset),
      decoration: BoxDecoration(
        color: value ? ext.settingsToggleOnTrack : ext.settingsToggleOffTrack,
        borderRadius: BorderRadius.circular(size.height / 2),
      ),
      child: AnimatedAlign(
        duration: _duration,
        curve: Curves.easeOut,
        // `Alignment`, never `AlignmentDirectional` — see the class doc.
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          key: const Key('settings_toggle_knob'),
          width: knob,
          height: knob,
          decoration: BoxDecoration(
            color: ext.settingsToggleKnob,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
