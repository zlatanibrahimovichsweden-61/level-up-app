import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../models/leaderboard_models.dart';
import 'board_avatar.dart';

/// The top-three podium.
///
/// This is **not a second ranking**. The contract is explicit that the podium
/// and the rows below it are *"two visual treatments of the same ordered list,
/// not two ranking systems"* — so this widget takes the first three entries of
/// the one board and nothing else. It issues no call of its own.
///
/// The frame draws rank 2 · 1 · 3 left-to-right with the winner raised and
/// larger. Under RTL that order mirrors, which is correct: the centre stays the
/// winner and the reading order of 2 and 3 follows the locale.
///
/// The frame's subtitle reads "level 7,3000Pts", but `LeaderboardEntry` carries
/// no `level` — the endpoint never sends one. Only [LeaderboardEntry.points] is
/// rendered; the level half is not approximated from anything else.
class Podium extends StatelessWidget {
  const Podium({super.key, required this.top});

  /// The first up-to-three rows of the board, already in rank order.
  final List<LeaderboardEntry> top;

  /// Measured off Figma `133:3117`, whose frame is **402pt wide** — not the
  /// 375 a phone mock usually implies. The winner's avatar disc (`134:3419`) is
  /// 129.35; the runner-up frames (`134:3497`, `134:3468`) are 82 square.
  ///
  /// The winner's enclosing `Profile` node reads 162.15 × 157.3, which is the
  /// bounding box including the crown overlap and the ring's outer bleed — the
  /// disc itself is the 129 figure, and that is what this widget draws.
  static const _winnerDiameter = 129.0;
  static const _runnerUpDiameter = 82.0;

  @override
  Widget build(BuildContext context) {
    if (top.isEmpty) return const SizedBox.shrink();

    final first = top.first;
    final second = top.length > 1 ? top[1] : null;
    final third = top.length > 2 ? top[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: second == null
              ? const SizedBox.shrink()
              : _PodiumPlace(
                  entry: second,
                  diameter: _runnerUpDiameter,
                  place: 2,
                ),
        ),
        Expanded(
          child: _PodiumPlace(
            entry: first,
            diameter: _winnerDiameter,
            place: 1,
          ),
        ),
        Expanded(
          child: third == null
              ? const SizedBox.shrink()
              : _PodiumPlace(
                  entry: third,
                  diameter: _runnerUpDiameter,
                  place: 3,
                ),
        ),
      ],
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  const _PodiumPlace({
    required this.entry,
    required this.diameter,
    required this.place,
  });

  final LeaderboardEntry entry;
  final double diameter;

  /// 1, 2 or 3 — the podium position, which selects the ring colour and width.
  ///
  /// Deliberately NOT [LeaderboardEntry.rank]: the ring is a property of the
  /// podium slot, and reading it off the server's rank would break the moment
  /// a board legitimately starts somewhere other than 1.
  final int place;

  /// `134:3429` / `134:3426` — 30 square with a 1px border, both places.
  static const _badgeSize = 30.0;
  static const _badgeBorder = 1.0;

  bool get _isWinner => place == 1;

  /// Ring widths are Figma's inner strokes: 5.23 / 3 / 2 on `134:3418`,
  /// `134:3497`, `134:3468`. The winner's is rounded to 5.
  double get _ringWidth => switch (place) {
    1 => 5,
    2 => 3,
    _ => 2,
  };

  Color _ringColor(AppColors ext) => switch (place) {
    1 => ext.podiumFirstRing,
    2 => ext.podiumSecondRing,
    _ => ext.podiumThirdRing,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isWinner)
          // TODO(design-asset): the frame has a `Crown` layer inside `Top 3`
          // (Figma `133:3117`) that has not been exported yet. A Material
          // glyph stands in, the same way the five nav glyphs did before their
          // export landed — a placeholder, not a design choice. Tinted with
          // the winner's own ring colour so the stand-in is at least the right
          // gold rather than a second invented one.
          Icon(Icons.emoji_events, size: 32, color: ext.podiumFirstRing),
        SizedBox(height: _isWinner ? 4 : 0),
        // The rank badge overlaps the avatar's lower edge, so the stack is
        // allowed to paint outside its box.
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            BoardAvatar(
              url: entry.avatarUrl,
              diameter: diameter,
              ringColor: _ringColor(ext),
              ringWidth: _ringWidth,
            ),
            Positioned(
              bottom: -_badgeSize / 3,
              child: _RankBadge(rank: entry.rank, isWinner: _isWinner),
            ),
          ],
        ),
        const SizedBox(height: _badgeSize / 3 + 8),
        Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppType.bodyMediumStrong.copyWith(color: ext.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.leaderboardPoints(entry.points),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppType.captionRegular.copyWith(color: ext.textSecondary),
        ),
      ],
    );
  }
}

/// The small numbered disc on the avatar's lower edge — `134:3429` (winner,
/// gold) and `134:3426` (second and third, neutral). Both are 30 square with a
/// 1px black hairline; only the fill changes.
class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.isWinner});

  final int rank;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: _PodiumPlace._badgeSize,
      height: _PodiumPlace._badgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isWinner ? ext.podiumFirstRing : ext.podiumBadgeIdle,
        // The frame's hairline is `#000000`, which is not a palette token and
        // must not become one — [textPrimary] is the file's approved near-black
        // and is 14/255 away from it on the light canvas.
        border: Border.all(
          color: ext.textPrimary,
          width: _PodiumPlace._badgeBorder,
        ),
      ),
      child: Text(
        '$rank',
        style: AppType.captionSmall.copyWith(color: ext.textPrimary),
      ),
    );
  }
}
