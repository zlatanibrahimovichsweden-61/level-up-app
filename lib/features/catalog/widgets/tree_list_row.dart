import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
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
/// this row takes no `enabled` flag and no nullable `onTap`: a fully-answered
/// lesson is exactly as tappable as an untouched one.
class TreeListRow extends StatelessWidget {
  const TreeListRow({
    super.key,
    required this.index,
    required this.name,
    required this.onTap,
    this.progress,
    this.caption,
  });

  final int index;
  final String name;

  /// 0.0–1.0, or null when the contract supplies no progress for this level.
  final double? progress;

  /// Trailing micro-label beside the bar. Only rendered with [progress].
  final String? caption;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: ext.catalogCardFill,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ext.fieldBorder, width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsetsDirectional.all(16.5),
          child: Row(
            children: [
              _IndexBadge(index: index),
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
                      style: TextStyle(
                        fontSize: 16,
                        height: 21 / 16,
                        fontWeight: FontWeight.w600,
                        color: ext.textPrimary,
                      ),
                    ),
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
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
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
              const SizedBox(width: 12),
              Icon(forwardChevron(context), size: 28, color: ext.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

/// The frame's 40dp numbered circle (`337:5928`).
class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: 40,
      height: 40,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: ext.cardFill,
        shape: BoxShape.circle,
      ),
      child: Text(
        // Locale-aware digits: Arabic renders ١، ٢، ٣ rather than 1, 2, 3.
        MaterialLocalizations.of(context).formatDecimal(index),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ext.textPrimary,
        ),
      ),
    );
  }
}
