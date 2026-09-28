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

  /// Figma `134:3543`, 32 square, starting 40.1 from the row's leading edge
  /// (`134:3542`, `left-[11.08%]`). It was 36 at 48 until the Wave 06 walk
  /// (W06-4).
  static const _avatarDiameter = 32.0;

  /// The rank's column. The frame's digit is centred about 22 in from the
  /// edge (22.2 for "4", 22.7 for "10"), and the avatar starts at 40. The
  /// column keeps its 28 so it still holds "200" (the display bound, which
  /// the frame never draws); the leading pad and the gap take the difference.
  static const _rankColumn = 28.0;
  static const _leadingPad = 8.0;
  static const _rankToAvatar = 4.0;

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
    // One colour for rank, name and points, on both rows and both canvases:
    // the frame draws the points no quieter than the name (W06-2).
    final foreground = isMe ? ext.podiumOnAccent : ext.leaderboardRowText;

    return Semantics(
      selected: isMe,
      child: ElevatedSurface(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        height: _height,
        padding: const EdgeInsetsDirectional.fromSTEB(_leadingPad, 0, 16, 0),
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
              width: _rankColumn,
              child: Text(
                '${entry.rank}',
                textAlign: TextAlign.center,
                style: AppType.bodyMediumStrong.copyWith(color: foreground),
              ),
            ),
            const SizedBox(width: _rankToAvatar),
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
              style: AppType.bodyMedium.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
