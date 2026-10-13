import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import 'catalog_scaffold.dart';

/// One row of the drill-down lists · Figma `337:5926` (Units `337:5894`,
/// Chapters `337:6047`, Lessons `337:6143` — all three use this same row).
///
/// Numbered badge · name · optional progress bar + caption · chevron.
///
/// [index] is the row's 1-based position, exactly as the frame draws it. It is
/// presentational — a list ordinal, not a server value — so computing it here is
/// not the client inventing data.
///
/// [progress] is nullable BECAUSE THE CONTRACT MAKES IT SO. `SchoolSubjectTree`
/// carries `questionCounter` on LESSONS only; units and chapters have no counter
/// of any kind, so there is nothing to draw their bars from. The frame shows a
/// percentage on all three levels; we render it only where the server supplies
/// the numbers, and do NOT aggregate child counters to fake the other two — the
/// contract's rule is "render the number and a clamped fraction, no other client
/// math". See docs/DESIGN_ISSUES.md #16.
///
/// **The caption is display-only.** `questionCounter` "never locks retakes", so
/// this row never takes an `enabled` flag: a fully-answered lesson is exactly
/// as tappable as an untouched one, and [onTap] being nullable does NOT relax
/// that rule - see its own doc.
///
/// ---
///
/// **The Mistakes flow (Day 10) reuses this row rather than copying it.** Its
/// frame `404:6642` measures 363 x 78 at radius 16 with a 0.5px inner border,
/// which is this widget exactly; only the fill and the trailing label differ.
/// Those arrive as [palette] and [countLabel]. Cloning the widget would have
/// duplicated the badge, the RTL mirroring, the 2-line ellipsis and the
/// locale-aware digits - four things that are already right here.
class TreeListRow extends StatelessWidget {
  const TreeListRow({
    super.key,
    required this.index,
    required this.name,
    required this.onTap,
    this.progress,
    this.caption,
    this.countLabel,
    this.palette = TreeRowPalette.catalog,
  });

  final int index;
  final String name;

  /// 0.0–1.0, or null when the contract supplies no progress for this level.
  final double? progress;

  /// Trailing micro-label beside the bar. Only rendered with [progress].
  final String? caption;

  /// A standalone count line under the name, rendered when there is no
  /// [progress] bar to hang a [caption] off.
  ///
  /// This is the Mistakes rows' red "N mistakes". It is deliberately a second
  /// slot rather than a reuse of [caption]: [caption] means "the trailing half
  /// of a progress readout" and only ever appears beside the bar, and the
  /// Mistakes frames draw **no bar at any level** - the contract gives their
  /// tree no `questionCounter` at all.
  final String? countLabel;

  /// Which surface this row is drawn on. Resolved to tokens inside, so no call
  /// site decides a colour.
  final TreeRowPalette palette;

  /// `null` makes the row inert: no ripple, no chevron, nothing that reads as
  /// tappable.
  ///
  /// WARNING: **this is not an `enabled` flag and must never be used as one.**
  /// The catalog rows pass a callback unconditionally, because
  /// `questionCounter` never locks a retake. The one caller that passes `null`
  /// is the Mistakes leaf, where there is no destination to go to at all - the
  /// replay quiz is a later day. A row that kept its chevron and swallowed the
  /// tap would read to a student as a bug, which is the defect
  /// `_MistakesButton`'s own comment warns about. Owner ruling 2026-09-12.
  final VoidCallback? onTap;

  // The Mistakes row's geometry, from `404:6642` (light) and every light row
  // frame of the family (API→UI Wave 16). The row is 363 x 78 with a 0.5
  // border; inside it the badge, the text and the 28-dp chevron sit in one
  // container 17 from the start and the top and 12 from the END (it is 334
  // wide), so the chevron ends 12 from the row's edge, not 17. The name's
  // 21-dp line is centred 28.0 below the row's top and the count's 10.62-dp
  // line 46.5; the badge and the chevron are centred at 37.0.
  //
  // In the scale's lines (name 24, count 18) the text block is 42 tall, and
  // centred on the badge at 37 it starts at 16: the name's centre lands on
  // 28.0, and the bottom inset of 20 makes the row the frame's 78. The two
  // centres are 18.5 apart but the two lines 21, so the count is lifted
  // 2.5 into the name line's trailing space rather than the name pushed up
  // off its centre. The row still grows with its text (BUG-002 measured no
  // overflow at 1.3 or 2.0); the badge and chevron stay centred on the text.
  //
  // The paddings exclude the 0.5 border, which the container adds.
  static const _mistakesPadding = EdgeInsetsDirectional.fromSTEB(
    16.5,
    15.5,
    11.5,
    19.5,
  );
  static const _countLift = -2.5;

  // The catalog rows end the same way (DESIGN_ISSUES #100, owner ruling
  // 2026-09-27): in every catalog row frame, light and dark (Units `135:1064`,
  // Chapters `135:1302`, Lessons `308:4769`, Lectures `309:5656`; `337:5926`,
  // `348:7457`, `348:7527`, `349:16001`), the content is one container 17 from
  // the start and 334 wide in a 363 row, so the 28-dp chevron ends 12 from the
  // row's end and the text column is 242 wide. The build padded 16.5 on both
  // sides and ended the chevron 17 in, with a 237 column. The top and bottom
  // stay 16.5: these rows keep their own height.
  static const _catalogPadding = EdgeInsetsDirectional.fromSTEB(
    16.5,
    16.5,
    11.5,
    16.5,
  );

  /// The gap between the progress bar and its caption.
  static const _captionGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;
    final (
      fill,
      border,
      content,
      badgeFill,
      chevron,
      progressColor,
    ) = switch (palette) {
      // Its own tokens since 2026-09-19, read off the row frames rather than
      // borrowed from the card and field palettes: the light hairline is the
      // green `#4B675E`, not the grey `fieldBorder`, and the light disc is the
      // lavender `#F4E6FF`, not `cardFill` (edit3.md #42). The chevron and the
      // bar followed in API→UI Wave 08: see [AppColors.treeRowChevron] and
      // [AppColors.treeRowProgress].
      TreeRowPalette.catalog => (
        ext.treeRowFill,
        ext.treeRowBorder,
        ext.textPrimary,
        ext.treeRowBadgeFill,
        ext.treeRowChevron,
        ext.treeRowProgress,
      ),
      // Every Mistakes value comes from the Mistakes palette, never the
      // catalog's: in light the foreground is the green the pink needs, and in
      // dark the row, hairline, text and disc are all read off the dark frame
      // `404:7765`. See [AppColors.mistakesRowFill].
      //
      // The chevron is the frame's stroke colour (API→UI Wave 16; it was the
      // content colour). The Mistakes tree never passes a [progress] (no bar
      // at any level), so its progress colour is the theme primary it always
      // had and is never drawn.
      TreeRowPalette.mistakes => (
        ext.mistakesRowFill,
        ext.mistakesRowBorder,
        ext.mistakesContent,
        ext.mistakesBadgeFill,
        ext.mistakesRowChevron,
        cs.primary,
      ),
    };

    // One node, and a BUTTON when it goes somewhere. The `InkWell` gives the
    // row a tap action but not the button flag, so TalkBack read the name and
    // never said the row could be pressed; the merge is what keeps the disc's
    // number, the name, the caption and that flag on one node rather than
    // four. An inert row (no [onTap]) is merged too, and gets no flag.
    // API→UI Wave 08, the same fix `_MistakesButton` carries.
    return MergeSemantics(
      child: Semantics(
        button: onTap == null ? null : true,
        child: Material(
          color: fill,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // Null here yields no ripple and no splash: the row stops
            // responding to touch entirely, rather than responding and doing
            // nothing.
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: border, width: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: switch (palette) {
                TreeRowPalette.catalog => _catalogPadding,
                TreeRowPalette.mistakes => _mistakesPadding,
              },
              child: Row(
                children: [
                  _IndexBadge(index: index, fill: badgeFill, content: content),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // Server copy, already in the content language
                          // (adr-018).
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // Frame `404:6648` specifies Inter 600/16 in
                          // `#000000` for the Mistakes row name. Pure black is
                          // not in this palette at all and 16/600 is not in the
                          // scale; both are mapped to the nearest shipped
                          // values per the ruling docs/DESIGN_ISSUES.md #57
                          // already made. Logged as #68.
                          style: AppType.h3.copyWith(color: content),
                        ),
                        if (countLabel != null)
                          // Straight under the name, lifted so the two lines
                          // sit at the frame's centres - see [_countLift].
                          Transform.translate(
                            offset: const Offset(0, _countLift),
                            child: Text(
                              // Rendered verbatim from the server. Never
                              // summed from the children below it and never
                              // reconciled against a retake pool: the
                              // contract does the arithmetic and forbids the
                              // client repeating it (adr-133).
                              countLabel!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.labelLarge.copyWith(
                                color: ext.mistakesCount,
                              ),
                            ),
                          ),
                        if (progress != null) ...[
                          const SizedBox(height: 6),
                          // LayoutBuilder: the caption may take no more than
                          // the room the row has, so a narrow row at a large
                          // text scale ellipsises it instead of overflowing
                          // (RESPONSIVE.md #12). The bar still takes what the
                          // caption leaves, so a caption that fits changes
                          // nothing.
                          LayoutBuilder(
                            builder: (context, constraints) => Row(
                              children: [
                                Expanded(
                                  // The bar says nothing to a screen reader
                                  // when the caption beside it says it in
                                  // words. Its own semantics carry
                                  // `SemanticsRole.progressBar` and a 0–100
                                  // range, and merged into this row they made
                                  // Android expose every Lectures row as a
                                  // ProgressBar instead of a Button, "37" read
                                  // first (Wave 08 walk, W08-6). Without a
                                  // caption the bar is the only readout, so it
                                  // keeps them.
                                  child: ExcludeSemantics(
                                    excluding: caption != null,
                                    // Mirrors itself under RTL via
                                    // Directionality.
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: ext.progressTrack,
                                      color: progressColor,
                                      borderRadius: BorderRadius.circular(52),
                                    ),
                                  ),
                                ),
                                if (caption != null) ...[
                                  const SizedBox(width: _captionGap),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: math.max(
                                        0.0,
                                        constraints.maxWidth - _captionGap,
                                      ),
                                    ),
                                    child: Text(
                                      caption!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppType.captionSmall.copyWith(
                                        color: progressColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // No destination, no chevron. The affordance and the
                  // behaviour stay in step - see [onTap].
                  if (onTap != null) ...[
                    const SizedBox(width: 12),
                    Icon(forwardChevron, size: 28, color: chevron),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The frame's 40dp numbered circle (`337:5928` catalog, `404:7767` Mistakes).
///
/// The disc colour arrives as [fill] from the row's palette:
/// [AppColors.treeRowBadgeFill] on the catalog, [AppColors.mistakesBadgeFill]
/// on Mistakes.
///
/// This badge used to keep `cardFill` on both palettes, because the Mistakes
/// disc had not been read. The dark one now has (`404:7767`, `#27282C` at 20%)
/// and it differs from dark `cardFill`, so it is a token of its own. The light
/// Mistakes disc is still unread and keeps the value it always shipped with.
/// The digit follows the row's content colour.
///
/// **The disc is the one part of this row that is a raised surface.** In dark
/// both palettes wash it to 20% and light it with Glass **G5**; the row
/// underneath is opaque and flat on both canvases, so the rim is the only
/// thing separating the disc from it. Light has no Glass at all, and the
/// primitive draws none — `treeRowBadgeGlass` is null there.
class _IndexBadge extends StatelessWidget {
  const _IndexBadge({
    required this.index,
    required this.fill,
    required this.content,
  });

  final int index;
  final Color fill;
  final Color content;

  @override
  Widget build(BuildContext context) {
    final elevation = Theme.of(context).extension<AppElevation>()!;

    return ElevatedSurface(
      width: 40,
      height: 40,
      shape: const CircleBorder(),
      color: fill,
      glass: elevation.treeRowBadgeGlass,
      child: Align(
        alignment: AlignmentDirectional.center,
        child: Text(
          // Locale-aware formatting — grouping separators, not digit shapes.
          //
          // This comment used to claim Arabic renders ١، ٢، ٣ rather than 1, 2,
          // 3. It does not. `intl` formats `ar` with WESTERN digits in this app,
          // which two tests already assert (`lectures_screen_test.dart:294`,
          // `profile_screen_test.dart:534`) and which was seen on a Pixel 8 on
          // 2026-09-12: the Arabic Mistakes tree draws its badges as 1 and 2.
          //
          // `formatDecimal` is still the right call — it is what applies the
          // locale's grouping to numbers large enough to need it. Do not
          // "restore" Arabic-Indic digits here on the strength of the old
          // comment; that would be a product decision, and the shipped
          // behaviour is the one under test.
          MaterialLocalizations.of(context).formatDecimal(index),
          style: AppType.h4.copyWith(color: content),
        ),
      ),
    );
  }
}

/// Which surface a [TreeListRow] is drawn on.
///
/// An enum rather than three `Color` parameters, so the palette stays a
/// decision the design system makes and the call sites only name a role.
enum TreeRowPalette {
  /// The catalog drill-down - [AppColors.treeRowFill] on
  /// [AppColors.treeRowBorder].
  catalog,

  /// The Mistakes drill-down - the pink `404:6642` row in light, the dark
  /// `404:7765` row in dark. See [AppColors.mistakesRowFill].
  mistakes,
}
