import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';

/// The frame's one vertical rhythm on this screen: **25** from the title bar to
/// the first heading, from a heading to its control, and from a control to the
/// next heading — every gap of `Frame 1000003054` and of each block inside it
/// (`176:1840`, dark `337:8141`, Arabic `549:21759`).
///
/// **Measured to ink, not to boxes.** Figma trims each heading's box to the cap
/// height (`leadingTrim: CAP_HEIGHT`, 13 tall), so its 25s run from a heading's
/// BASELINE and to a heading's CAP TOP. Flutter lays `AppType.h3` out in a
/// 24-high line with Inter's baseline 19.22 down it (ascender 1984, descender
/// 494 on a 2048 em, the leading split in that proportion) and the caps 13.10
/// above the baseline (1490 / 2048 x 18). A box-to-box gap is therefore the 25
/// less the part of the line on that side of the ink — which is what the build
/// had wrong: 10 under a heading (baseline to control 14.8) and 24 between
/// blocks (control to cap top 30.1). API→UI Wave 21.
///
/// Arabic headings fall back to Tajawal, whose ink sits differently in the same
/// line; the gaps are the English ones, the same trade every screen makes.
const double kSettingsRhythm = 25;

/// From the top of an `h3` line to Inter's cap top: 19.22 − 13.10.
const double kSettingsHeadingCapTop = 6.12;

/// From Inter's baseline to the bottom of an `h3` line: 24 − 19.22.
const double kSettingsHeadingBelowBaseline = 4.78;

/// A block's title: Inter Semi Bold 18 (`h3`), its control 25 under the
/// baseline ([kSettingsRhythm]).
///
/// **Flush with the content edge.** Every frame puts the heading's box on the
/// card's edge — x 20 in English (`642:8518`), right edge 382 in Arabic
/// (`549:21816`). The build inset it 4 on both sides from Day 8, before a frame
/// had been read. API→UI Wave 21.
///
/// Marked as a HEADER for screen readers, and its own node, so a student can
/// jump between the four blocks.
///
/// Its colour stays [AppColors.textPrimary] (`#0E0E0E` in light) where the frame
/// reads `#000000`, as every heading and title in the app does
/// (docs/DESIGN_ISSUES.md #109).
class SettingsHeading extends StatelessWidget {
  const SettingsHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: kSettingsRhythm - kSettingsHeadingBelowBaseline,
      ),
      child: Semantics(
        container: true,
        header: true,
        child: Text(text, style: AppType.h3.copyWith(color: ext.textPrimary)),
      ),
    );
  }
}

/// One titled block of the Settings screen — Rank, and (blocked) Mode.
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

  /// Dark-canvas back-lights behind this card's frost, passed by the screen
  /// rather than chosen by the card (edit5.md §7.5.3). Only the Notification
  /// Preferences block had one, and it was removed on 2026-10-15 (no Settings
  /// frame draws it), so no screen passes any today.
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
    final hasBorder = border != null && borderWidth > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsHeading(title),
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
          // The rows sit INSIDE the hairline, as the frame's do (`642:8522` at
          // 0.5 in from `642:8521`'s edge), so a row keeps the frame's own 16 /
          // 14 padding on both canvases — dark has no hairline and no inset.
          child: Padding(
            padding: EdgeInsets.all(hasBorder ? borderWidth : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The divider is UNCHANGED. The frame's reading was taken in
                // API→UI Wave 21 — `#4B675E` at 50%, 0.2 dp, both canvases
                // (`176:2387`, `337:8196`) — and recorded in
                // docs/DESIGN_ISSUES.md #109 rather than built: a 0.2 dp line is
                // half a pixel on the phones this ships to.
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
        ),
        // Not in the frame: the build's own line under a card — a disabled
        // block's reason, a failed save. Flush with the heading and the card
        // since the heading moved onto the edge (API→UI Wave 21; it was
        // inset 4 like the old heading).
        if (note != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 8),
            child: note,
          ),
      ],
    );
  }
}
