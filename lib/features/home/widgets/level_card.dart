import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Points per level, CLIENT-SIDE and provisional.
///
/// TODO(contract): confirm level thresholds with Seif — `GET /me` returns
/// `level` and `points` but NOT the threshold for the next level, so the app
/// cannot draw a progress bar from the server's own numbers. The contract's
/// prose says "1–12, thresholds every 500 points"; the Figma frame shows
/// "2,450 / 5,000", which contradicts it (5,000 is the post-level-12 BADGE
/// cadence, not a level threshold). 500 follows the contract, not the mock.
/// See docs/DESIGN_ISSUES.md #13.
///
/// This constant drives the BAR ONLY. `level`, `points` and `badges` themselves
/// are rendered exactly as the server returned them and are never recomputed —
/// if this constant is wrong, a bar is slightly off; nothing a student is scored
/// on changes.
const kPointsPerLevel = 500;

/// The top level in the contract's scheme; past it students earn badges, not
/// levels, so there is no "next level" to progress toward.
const kMaxLevel = 12;

/// How far [totalPoints] has progressed through [level], as 0.0–1.0.
///
/// Clamped on both ends so a server/constant mismatch can only ever produce a
/// full or empty bar — never an overflowing one, and never a crash.
double levelProgressFraction({required int level, required int totalPoints}) {
  if (level >= kMaxLevel) return 1;
  final earnedInLevel = totalPoints - (level - 1) * kPointsPerLevel;
  return (earnedInLevel / kPointsPerLevel).clamp(0, 1).toDouble();
}

/// The points total at which [level] gives way to the next one.
int nextLevelThreshold(int level) => level * kPointsPerLevel;

/// Level card · Figma `337:5336`.
///
/// Everything numeric here is SERVER-AUTHORITATIVE and display-only: `LEVEL n`,
/// the points balance and the badge count come straight from `GET /me`. The one
/// derived value is the progress bar's fill, from [kPointsPerLevel] above.
class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.totalPoints,
  });

  final int level;
  final int totalPoints;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    final nextLevel = level >= kMaxLevel ? kMaxLevel : level + 1;
    final fraction = levelProgressFraction(
      level: level,
      totalPoints: totalPoints,
    );

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(13, 9, 13, 16),
      decoration: BoxDecoration(
        color: ext.cardFill,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                // TODO(design-asset): real level medallion (Figma node 337:5338
                // "Level badges") — blocked by export-disabled + View-only seat.
                // See docs/DESIGN_ISSUES.md #1.
                Icon(Icons.emoji_events, size: 56, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    label: l10n.currentLevel,
                    value: l10n.levelLabel(level),
                  ),
                ),
                // The frame's 0.3px divider between the two stats.
                VerticalDivider(width: 21, thickness: 0.3, color: cs.primary),
                Expanded(
                  child: _Stat(
                    label: l10n.pointsBalance,
                    value: l10n.pointsValue(totalPoints),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.levelProgress(level),
                style: TextStyle(fontSize: 11, color: ext.mutedText),
              ),
              Text(
                l10n.levelProgress(nextLevel),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ext.mutedText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // LinearProgressIndicator mirrors itself under RTL via Directionality,
          // so the bar fills from the correct edge in Arabic for free.
          LinearProgressIndicator(
            value: fraction,
            minHeight: 10,
            backgroundColor: ext.progressTrack,
            color: cs.primary,
            borderRadius: BorderRadius.circular(52),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              l10n.levelProgressPoints(totalPoints, nextLevelThreshold(level)),
              style: TextStyle(fontSize: 10, color: ext.mutedText),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small label above its headline value — "current level / LEVEL 8".
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: ext.cardLabel),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ext.textPrimary,
          ),
        ),
      ],
    );
  }
}
