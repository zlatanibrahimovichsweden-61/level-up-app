import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/catalog_module.dart';

/// The University module picker: **All subjects** first, then one pill per
/// module in the order the server sent them, scrolling sideways when they do
/// not fit.
///
/// **Light frames exist; dark and Arabic do not.** The designer drew the row in
/// Figma `1411:16920` (All subjects chosen) and `1411:17138` (a module chosen),
/// light and English only. They settle where it sits (between the search field
/// and the grid), that "All subjects" is the first pill and chosen by default,
/// the gaps (25 above and 25 below the drawn pill) and the LIGHT pill style.
///
/// 🔴 **Still PROVISIONAL** (designer item DG-26, docs/DESIGN_ISSUES.md #134),
/// each marked `PROVISIONAL(design): DG-26` where it is made: the DARK pill
/// style (the look it had before the frame, unchanged), a long module name (the
/// cap-and-wrap), a module with no loaded subjects (the empty state), search
/// inside a chosen view, and the row over the subjects' loading / error view.
///
/// **"All subjects" is permanent, and it is not a module.** The contract has no
/// such entry in `GET /catalog/modules` - `GET /catalog/subjects` IS that view -
/// and it says the picker MUST offer it, because a subject filed in zero
/// modules is legal and a module-only picker would silently hide content. So
/// `selectedId == null` is All, exactly as for `NotificationFilterChips`'
/// category.
///
/// A module's [CatalogModule.name] is server copy, already in the content
/// language: it is drawn verbatim and never looked up in the ARB.
///
/// The row starts at the START edge, so it begins at the right in Arabic with
/// no direction-specific code.
class ModulePicker extends StatelessWidget {
  const ModulePicker({
    super.key,
    required this.modules,
    required this.selectedId,
    required this.onChanged,
  });

  /// The modules in the server's order. Never re-sorted here.
  final List<CatalogModule> modules;

  /// The chosen module's id; `null` = All subjects.
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  /// Pill -> pill gap (8, as in the notification filter row this re-creates).
  static const _gap = 8.0;

  /// The side padding the Subjects screen uses for its search field and cards.
  static const _sidePadding = 20.0;

  /// The frame's visual gap, measured to the DRAWN pill: 25 from the search
  /// field's bottom to the pill's top, and 25 from the pill's bottom to the
  /// first card's top (Figma `1411:16920`, `1411:17138`).
  static const visualGap = 25.0;

  /// The pill's drawn height at text scale 1.0. The frames draw the selected
  /// pill 33 tall with no border (`1411:17130`) and the idle pill 35 tall
  /// including a 1 px border outside the 14 / 8 padding (`1411:17132`); the app
  /// equalises both to this 35 so the row does not jump when the choice changes
  /// (the selected pill is 2 dp taller than drawn and the idle pill about 2 dp
  /// narrower). A minimum - a larger text scale grows the pill, it never clips
  /// it.
  static const pillHeight = 35.0;

  /// The pill's tap target (Material and both platforms floor it at 48 / 44).
  /// The pill is drawn [pillHeight] tall inside it, centred.
  static const tapTarget = 48.0;

  /// [visualGap] measured to the 48 tap box instead of the drawn pill: the
  /// pill sits `(tapTarget - pillHeight) / 2` = 6.5 inside the box, which
  /// already spends part of the gap, so the box needs only `25 - 6.5` = 18.5
  /// of space between it and its neighbour. The Subjects screen puts this under
  /// the search field and this widget puts it under the row.
  ///
  /// The 25 visual gap is exact at text scale 1.0 only. At 1.3 the drawn pill
  /// grows (to about 39) inside the unchanged 48 tap box, so the visual gaps
  /// shrink to about 23 - no overflow, and the tap target stays at least 48.
  static const gapToTapBox = visualGap - (tapTarget - pillHeight) / 2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // PROVISIONAL(design): DG-26 - a pill never grows past the screen: a
        // long module name wraps inside it instead of producing a pill the
        // student has to scroll to read. No frame draws a long name.
        final maxPillWidth = constraints.maxWidth - 2 * _sidePadding;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // The frame's 25 below the drawn pill, measured to the tap box.
          padding: const EdgeInsetsDirectional.fromSTEB(
            _sidePadding,
            0,
            _sidePadding,
            gapToTapBox,
          ),
          child: Row(
            children: [
              _Pill(
                key: const Key('module_pill_all'),
                // Figma `1411:16920`: "All subjects" is the first pill and the
                // chosen one by default. The view name is the contract's and
                // Seif's; the Arabic (no Arabic frame) was confirmed by the
                // owner on 2026-10-15.
                label: l10n.allSubjects,
                selected: selectedId == null,
                maxWidth: maxPillWidth,
                onTap: () => onChanged(null),
              ),
              for (final module in modules) ...[
                const SizedBox(width: _gap),
                _Pill(
                  key: Key('module_pill_${module.id}'),
                  // Server copy, verbatim.
                  label: module.name,
                  selected: selectedId == module.id,
                  maxWidth: maxPillWidth,
                  onTap: () => onChanged(module.id),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// One pill.
///
/// **Light is the frame's** (Figma `1411:17130` selected / `1411:17132` idle).
/// The frames draw the selected pill 33 tall with no border and the idle pill 35
/// tall including a 1 px border outside the 14 / 8 padding; the app equalises
/// both to a 35 drawn height so choosing a pill moves the look and not the
/// layout (the selected pill is 2 dp taller than drawn and the idle pill about
/// 2 dp narrower). A stadium, padding 14 / 8, Inter SemiBold 14
/// ([AppType.labelLarge]) for the label, drawn at least 35 tall inside a tap
/// target of at least 48.
/// The selected pill is a flat `#384F47` with a white label; the idle pill is
/// white with a 1 px `#DEDEDE` border and a `#384F47` label. The frames draw no
/// shadow on either.
///
/// PROVISIONAL(design): DG-26 (dark) - there is no dark frame, so the dark pill
/// keeps the look it had before the light frame, unchanged: a purple flat fill
/// when selected, a 20% fill under Glass G5 and no border when idle (the
/// notification filter chip's values, `180:8555` / `180:8557`, which it was
/// built from). Only the label's size and the pill's height follow the frame in
/// dark too, as they are metrics and not colour.
///
/// Both heights are MINIMA, not fixed boxes, so a larger text scale grows the
/// pill instead of clipping its label.
class _Pill extends StatelessWidget {
  const _Pill({
    super.key,
    required this.label,
    required this.selected,
    required this.maxWidth,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final labelColor = selected
        ? ext.modulePillSelectedLabel
        : ext.modulePillIdleLabel;
    // Only the idle pill has a hairline, and only where a canvas draws one
    // (light); the selected pill never does.
    final idleBorder = ext.modulePillIdleBorder;

    // The label is the accessible name, and `button` + `selected` say what the
    // pill is and which one is chosen. Merged, so the pill is ONE node rather
    // than a button, a label and a tap action.
    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        // Neither a SizedBox nor a Center hit-tests itself, so the 6.5 above and
        // below the pill would drop a tap. An opaque detector makes the whole
        // box the target; the pill's InkWell is deeper, wins any tap inside it
        // and keeps the ripple, so `onTap` fires once. Its own semantics are
        // left to the InkWell.
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          excludeFromSemantics: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: ModulePicker.tapTarget,
              maxWidth: maxWidth,
            ),
            // `widthFactor: 1` so a bounded `maxWidth` does not make every
            // pill that wide: the pill is as wide as its label.
            child: Center(
              widthFactor: 1,
              child: ElevatedSurface(
                shape: const StadiumBorder(),
                color: selected
                    ? ext.modulePillSelectedFill
                    : ext.modulePillIdleFill,
                side: !selected && idleBorder != null
                    ? BorderSide(color: idleBorder, width: 1)
                    : null,
                // Neither pill has a shadow: the light frame draws none, and
                // dark's idle pill had none (Glass G5 lights it instead).
                shadows: const [],
                // The selected pill has no Glass in either canvas; the idle
                // one has it in dark only.
                glass: selected ? null : elevation.notificationChipIdleGlass,
                onTap: onTap,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: ModulePicker.tapTarget,
                    minHeight: ModulePicker.pillHeight,
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 14, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Flexible so a label wider than the pill's cap wraps.
                      Flexible(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          // The frame's label, Inter SemiBold 14, in BOTH
                          // states: a selected label in a bigger style made
                          // the pill grow when chosen.
                          style: AppType.labelLarge.copyWith(color: labelColor),
                        ),
                      ),
                    ],
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
