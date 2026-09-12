import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;
    final (fill, border, content) = switch (palette) {
      TreeRowPalette.catalog => (
        ext.catalogCardFill,
        ext.fieldBorder,
        ext.textPrimary,
      ),
      // The Mistakes row's three values are canvas-INDEPENDENT, so its
      // foreground has to be too: `ext.textPrimary` is `#FCFBF9` in dark and
      // measures 1.36:1 on the pink. See [AppColors.mistakesContent].
      TreeRowPalette.mistakes => (
        ext.mistakesCardFill,
        ext.mistakesRowBorder,
        ext.mistakesContent,
      ),
    };

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Null here yields no ripple and no splash: the row stops responding to
        // touch entirely, rather than responding and doing nothing.
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: border, width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsetsDirectional.all(16.5),
          child: Row(
            children: [
              _IndexBadge(index: index, content: content),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      // Server copy, already in the content language (adr-018).
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // Frame `404:6648` specifies Inter 600/16 in `#000000`
                      // for the Mistakes row name. Pure black is not in this
                      // palette at all and 16/600 is not in the scale; both are
                      // mapped to the nearest shipped values per the ruling
                      // docs/DESIGN_ISSUES.md #57 already made. Logged as #68.
                      style: AppType.h3.copyWith(color: content),
                    ),
                    if (countLabel != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        // Rendered verbatim from the server. Never summed from
                        // the children below it and never reconciled against a
                        // retake pool: the contract does the arithmetic and
                        // forbids the client repeating it (adr-133).
                        countLabel!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.labelLarge.copyWith(
                          color: ext.mistakesCount,
                        ),
                      ),
                    ],
                    if (progress != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            // Mirrors itself under RTL via Directionality.
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: ext.progressTrack,
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(52),
                            ),
                          ),
                          if (caption != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              caption!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.captionSmall.copyWith(
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // No destination, no chevron. The affordance and the behaviour
              // stay in step - see [onTap].
              if (onTap != null) ...[
                const SizedBox(width: 12),
                Icon(forwardChevron(context), size: 28, color: content),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The frame's 40dp numbered circle (`337:5928`).
///
/// The Mistakes frames draw this badge too, but their Properties panel never
/// gave its colours, so the disc keeps the shipped `cardFill` on both palettes
/// rather than gaining a fifth unmeasured token. Measured on the pink row:
/// **8.68:1** light, **4.33:1** dark. Only the digit follows the row's content
/// colour, which IS measured.
class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index, required this.content});

  final int index;
  final Color content;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: 40,
      height: 40,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(color: ext.cardFill, shape: BoxShape.circle),
      child: Text(
        // Locale-aware digits: Arabic renders ١، ٢، ٣ rather than 1, 2, 3.
        MaterialLocalizations.of(context).formatDecimal(index),
        style: AppType.h4.copyWith(color: content),
      ),
    );
  }
}

/// Which surface a [TreeListRow] is drawn on.
///
/// An enum rather than three `Color` parameters, so the palette stays a
/// decision the design system makes and the call sites only name a role.
enum TreeRowPalette {
  /// The catalog drill-down - `catalogCardFill` on `fieldBorder`.
  catalog,

  /// The Mistakes drill-down - the pink `404:6642` row. Canvas-independent in
  /// all three of its values; see [AppColors.mistakesCardFill].
  mistakes,
}
