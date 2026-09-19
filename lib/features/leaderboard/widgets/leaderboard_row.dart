import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../models/leaderboard_models.dart';
import 'board_avatar.dart';

/// One ordinary ranked row, below the podium.
///
/// The caller's own row is the same row with a filled background — it is a real
/// board entry the server marked `isMe`, never a synthetic self-rank strip. If
/// the student is not inside the rendered board, no highlighted row appears at
/// all, which is the correct outcome rather than a missing feature.
///
/// [LeaderboardEntry.rank] is printed as it arrives. It is the student's exact
/// position in the visible population, so it must not be replaced with the
/// row's index in the list — the two coincide today only because the board
/// starts at rank 1.
class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({super.key, required this.entry});

  final LeaderboardEntry entry;

  static const _avatarDiameter = 36.0;

  /// Figma `134:3538` (an ordinary row) and `134:3554` (the caller's own) are
  /// the same rectangle — 362 × 48, radius 12 — and differ only in fill. The
  /// height is FIXED in the frame rather than driven by content, so it is fixed
  /// here too: a long name must not make one row taller than its neighbours.
  static const _height = 48.0;
  static const _radius = 12.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    final isMe = entry.isMe;
    final foreground = isMe ? ext.podiumOnAccent : ext.textPrimary;
    // The points column is a shade quieter than the name in the frame, on both
    // the plain and the highlighted row.
    final secondary = isMe ? ext.podiumOnAccent : ext.textSecondary;

    return Semantics(
      selected: isMe,
      child: Container(
        height: _height,
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
        decoration: BoxDecoration(
          // The frame fills an ordinary row `#FFFFFF`; [cardFill] is `#FDFDFD`,
          // 2/255 away, and is reused rather than adding a fourth near-white to
          // the palette — the same call [bodyMuted] documents. It also gives
          // the dark canvas a sane value, which a literal white would not.
          color: isMe ? ext.podiumAccent : ext.cardFill,
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${entry.rank}',
                textAlign: TextAlign.center,
                style: AppType.bodyMediumStrong.copyWith(color: foreground),
              ),
            ),
            const SizedBox(width: 8),
            BoardAvatar(url: entry.avatarUrl, diameter: _avatarDiameter),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                // The frame labels the caller's own row "You" rather than
                // repeating their name back at them.
                isMe ? l10n.leaderboardYou : entry.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.bodyMediumStrong.copyWith(color: foreground),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.leaderboardPoints(entry.points),
              style: AppType.bodyMedium.copyWith(color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}
