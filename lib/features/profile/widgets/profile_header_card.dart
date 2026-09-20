import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';

/// Profile header · Figma `169:4609` (light) / `337:7455` (dark) — avatar,
/// name, level chip, edit pencil.
///
/// Everything on it comes straight off `GET /me`: [name] is `name`, [avatarUrl]
/// is `avatar.url`, [level] is `level`. Nothing is derived — in particular the
/// level chip prints the server's integer, it does not infer one from points.
///
/// **The card is the one translucent surface here that keeps its shadow.** Both
/// frames draw the same black (0.5, 0.5) blur 4 at 25%; dark adds **G15** and
/// the **B7** back-light (`348:8973`, 100x14 at (4, 11)) behind the avatar. All
/// three are `AppElevation` tokens and [ElevatedSurface] paints them — the
/// shadow knocked out so it cannot show through the 20% fill, and the
/// back-light frosted by the card's own Glass, which is what turns a hard
/// lavender ellipse into the haze the frame shows (edit1.md R4/R6).
///
/// The back-light's offset is DIRECTIONAL, so in Arabic it mirrors to sit
/// behind the avatar on the right (edit1.md R9 — an assumption, since no dark
/// RTL frame exists).
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
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final backlight = elevation.profileHeaderBacklight;

    return ElevatedSurface(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      height: 104,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
      color: ext.profileHeaderFill,
      shadows: elevation.profileHeaderShadows,
      glass: elevation.profileHeaderGlass,
      // Null on the light canvas, where the frame draws no ellipse. The
      // primitive asserts a back-light is never passed without Glass, so the
      // null-aware element drops it rather than the call site branching -
      // `level_card.dart`'s idiom, kept the same on both screens.
      backlights: [?backlight],
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
                  style: AppType.h3.copyWith(color: ext.textPrimary),
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
                        style: AppType.labelLarge.copyWith(
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
          _EditChip(label: editLabel, onTap: onEdit),
        ],
      ),
    );
  }
}

/// The pencil chip · Figma `166:4416` (light) / `337:7466` (dark).
///
/// It used to be a bare `IconButton` with a Material pencil and no surface at
/// all; the frame draws a 40x40 disc at radius 48.17 — cream with a very tight
/// (0.02833, 0.02833) blur-1.3 shadow in light, a 20% wash with the same shadow
/// plus **G5** in dark.
///
/// **The disc is 40 and the tap target is 48**, which is why the gesture region
/// is a box around the chip rather than the chip itself: growing the drawn disc
/// to 48 would be changing a read Figma value to satisfy a platform minimum,
/// and shrinking the target to 40 would fail that minimum. `IconButton` was
/// doing exactly this for free (48 of padding around a 24 glyph); the box keeps
/// it once the glyph is inside a sized surface.
class _EditChip extends StatelessWidget {
  const _EditChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  static const _size = 40.0;

  /// The platform minimum, not a frame value.
  static const _hitTarget = 48.0;

  /// The frame's vector is 20x20 at (10, 10) inside the 40 disc (`170:4674`).
  static const _glyph = 20.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          type: MaterialType.transparency,
          child: InkResponse(
            key: const Key('profile_edit_button'),
            onTap: onTap,
            customBorder: const CircleBorder(),
            radius: _hitTarget / 2,
            child: SizedBox.square(
              dimension: _hitTarget,
              child: Center(
                child: ElevatedSurface(
                  shape: const CircleBorder(),
                  width: _size,
                  height: _size,
                  color: ext.profileEditChipFill,
                  shadows: elevation.profileEditChipShadows,
                  glass: elevation.profileEditChipGlass,
                  child: Center(
                    // TODO(design-asset): the frame uses
                    // `fluent:edit-16-filled` (docs/ASSET_MANIFEST.md). A
                    // Material glyph stands in until the designer exports it;
                    // the COLOUR is read, the shape is not.
                    child: Icon(
                      Icons.edit,
                      size: _glyph,
                      color: ext.profileEditChipGlyph,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
        // See home_header.dart — decode at the drawn size, not the source's.
        memCacheWidth: (_size * MediaQuery.devicePixelRatioOf(context)).round(),
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
