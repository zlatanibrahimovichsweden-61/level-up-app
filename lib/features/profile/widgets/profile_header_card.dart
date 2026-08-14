import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Profile header · Figma `169:4609` — avatar, name, level chip, edit pencil.
///
/// Everything on it comes straight off `GET /me`: [name] is `name`, [avatarUrl]
/// is `avatar.url`, [level] is `level`. Nothing is derived — in particular the
/// level chip prints the server's integer, it does not infer one from points.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.levelLabel,
    required this.editLabel,
    required this.onEdit,
  });

  final String name;
  final String avatarUrl;

  /// Already-localized "Level 8" — the widget never formats a number itself.
  final String levelLabel;

  final String editLabel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: 104,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: ext.cardFill,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // Figma `169:4609`: 0.5 / 0.5 / 4, at 25%. The frame's "black" is
            // the light canvas's shadow; the token carries the dark one.
            color: ext.elevationShadow.withValues(alpha: 0.25),
            offset: const Offset(0.5, 0.5),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(url: avatarUrl),
          const SizedBox(width: 13.5),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TODO(design-asset): the frame's `Level badges` component
                    // is a gold 3D medallion with DIFFERENT artwork per level,
                    // filled with raster PNGs. The same asset gap Home's level
                    // card already carries (docs/DESIGN_ISSUES.md #43) —
                    // shipping one badge for all twelve looks right and is
                    // wrong, so a Material glyph stands in until the set lands.
                    Icon(Icons.emoji_events, size: 24, color: ext.homeAccent),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        levelLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ext.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Routes to /profile/edit. Step 1 lands it on a temporary screen;
          // Step 2 builds the real form against `PATCH /me`.
          IconButton(
            key: const Key('profile_edit_button'),
            onPressed: onEdit,
            tooltip: editLabel,
            icon: Icon(Icons.edit, size: 24, color: ext.homeAccent),
          ),
        ],
      ),
    );
  }
}

/// The student's avatar, cached and circular. Falls back to a neutral glyph
/// while loading and on failure — a broken-image icon where a student's own
/// face should be is a worse failure than a plain placeholder.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});
  final String url;

  static const _size = 69.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        placeholder: (_, _) => _Fallback(colour: ext.progressTrack),
        errorWidget: (_, _, _) => _Fallback(colour: ext.progressTrack),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.colour});
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: _Avatar._size,
      height: _Avatar._size,
      color: colour,
      child: Icon(
        Icons.person,
        size: _Avatar._size * 0.6,
        color: ext.mutedText,
      ),
    );
  }
}
