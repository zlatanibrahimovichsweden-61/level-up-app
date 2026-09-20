import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
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
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final isMe = entry.isMe;
    final foreground = isMe ? ext.podiumOnAccent : ext.textPrimary;
    // The points column is a shade quieter than the name in the frame, on both
    // the plain and the highlighted row.
    final secondary = isMe ? ext.podiumOnAccent : ext.textSecondary;

    return Semantics(
      selected: isMe,
      child: ElevatedSurface(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        height: _height,
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
        // `leaderboardRowFill` now, not `cardFill`: the frame fills an
        // ordinary row pure white in light and a 20% wash in dark, and the
        // near-white `cardFill` was standing in for the first of those.
        color: isMe ? ext.podiumAccent : ext.leaderboardRowFill,
        // Figma hangs one soft drop shadow on the whole vertical stack
        // (`133:3117`), not on each row. The stack here is a
        // `ListView.separated`, so a single shadow behind it would be
        // covered by the rows themselves; drawn per row, knocked out
        // behind each fill, it lands where the frame's does. Both canvases
        // keep it - this is one of the few dark surfaces that does.
        shadows: elevation.leaderboardListShadows,
        // The caller's own row (`134:3554`) carries NO Glass in the frame,
        // where every other row does. It is the one opaque lilac row in a
        // column of translucent ones, which is the point of it.
        glass: isMe ? null : elevation.leaderboardRowGlass,
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
