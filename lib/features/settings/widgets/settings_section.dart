import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';

/// One titled block of the Settings screen — Rank, Notification Preferences,
/// and (blocked) Mode.
///
/// The frame groups a block's rows inside a single outlined card rather than
/// giving every row its own, which is the one place Settings departs from the
/// Profile hub's list.
///
/// **Two things about the card moved in edit5, and both were readings, not
/// preferences.** Its light hairline is the lavender `#AE87E7` the frame draws
/// (`176:1840`), not the Profile hub's purple-grey `#7070A0` it had been
/// borrowing; and in dark it has NO hairline at all, taking **G16** over a 20%
/// wash instead (`642:8583`, `337:8195`). The two canvases now differ the way
/// every other surface in this wave does — shadow-and-hairline in light,
/// Glass in dark.
///
/// **Languages and Mode are not drawn inside a card in Figma.** Languages no
/// longer is here either: it is a `SegmentedTrack` (edit5 #50, owner decision
/// 2026-09-17). Mode still is, because the frame's three-swatch control cannot
/// be built against a two-palette app (docs/DESIGN_ISSUES.md #45) and giving
/// the stand-in rows no card would be styling half of a blocked component.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.note,
    this.backlights = const [],
  });

  final String title;

  /// Rows, drawn with a hairline between each — a separator, not a border, so
  /// the outer card keeps its single outline.
  final List<Widget> children;

  /// An optional line under the card explaining why the block is the shape it
  /// is (a disabled section's reason, a save failure).
  final Widget? note;

  /// Dark-canvas back-lights behind this card's frost. Only Notification
  /// Preferences has one, and which one depends on the student's track, so the
  /// screen passes it rather than the card choosing (edit5.md §7.5.3).
  ///
  /// Empty on the light canvas always: `ElevatedSurface` asserts a back-light
  /// is never handed over without a [GlassStyle] to be seen through
  /// (edit1.md R6).
  final List<Backlight> backlights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final border = ext.settingsSectionBorder;
    final borderWidth = elevation.settingsSectionBorderWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 10),
          child: Text(
            title,
            style: AppType.h3.copyWith(color: ext.textPrimary),
          ),
        ),
        ElevatedSurface(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Clipped, so a row's ink splash cannot paint over the card's
          // rounded corners.
          clipBehavior: Clip.antiAlias,
          color: ext.settingsSectionFill,
          // Null in dark, where the frame hides the stroke entirely. Both
          // halves are checked: the colour token and the width token go to
          // null and 0 together, and a 0-wide `BorderSide` would still be a
          // decision the frame did not make.
          side: border == null || borderWidth <= 0
              ? null
              : BorderSide(color: border, width: borderWidth),
          glass: elevation.settingsSectionGlass,
          backlights: backlights,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The divider is UNCHANGED and deliberately so: no frame
              // reading for it was taken, on either canvas, and swapping it
              // to the card's new lavender because the outline moved would
              // be inferring a value from a sibling. Recorded in
              // docs/DESIGN_ISSUES.md #72.
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: ext.profileRowBorder,
                  ),
                children[i],
              ],
            ],
          ),
        ),
        if (note != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
            child: note,
          ),
      ],
    );
  }
}
