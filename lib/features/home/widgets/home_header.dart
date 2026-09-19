import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';

/// Home header · Figma `59:1439` (light) / `337:5323` (dark) — avatar +
/// "Welcome back, {name}" + the bell chip, over a hairline bottom rule.
///
/// The bell is intentionally INERT: there is no notifications endpoint in the
/// contract and no inbox screen yet, so it does nothing. It is not wired to a
/// dead route on purpose — a tap that navigates nowhere is worse than a tap
/// that visibly does nothing.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.hasUnreadNotifications = false,
  });

  final String name;
  final String avatarUrl;

  /// Whether to draw the unread dot over the bell.
  ///
  /// TODO(contract): permanently `false` — there is no notifications endpoint
  /// in the contract, so nothing can set it. The frame draws the dot, but
  /// rendering it unconditionally would be a permanent "you have mail" lie.
  /// Confirm with Seif whether an unread count is coming
  /// (docs/DESIGN_ISSUES.md #41).
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ext.secondaryButtonBorder, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          _Avatar(url: avatarUrl),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.homeWelcome,
                  style: AppType.captionRegular.copyWith(
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // labelLarge: the frame's 14px semi-bold name. h3 (18) made
                  // the greeting the same style as a section title. SF-04.
                  style: AppType.labelLarge.copyWith(color: ext.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _BellChip(
            hasUnread: hasUnreadNotifications,
            semanticLabel: l10n.notifications,
          ),
        ],
      ),
    );
  }
}

/// The bell · Figma `59:1466` (light) / `337:5330` (dark). Three parts, only
/// one of which is the asset: a 36.5 ring, the `mingcute:notification-fill`
/// glyph, and the unread dot.
///
/// The ring and the dot are drawn in Flutter rather than baked into the SVG on
/// purpose — the ring is decoration and the dot is STATE. Keeping the asset's
/// own 37 viewBox as the layout box means the frame's dot centre (23.5, 11.5)
/// drops in without rescaling.
///
/// The ring's fill is its own token, not the page background: the dark frame
/// washes `#232428` at 20% over the page and lights the disc with Glass **G5**,
/// which is a surface sitting on the background rather than a hole in it.
class _BellChip extends StatelessWidget {
  const _BellChip({required this.hasUnread, required this.semanticLabel});

  final bool hasUnread;
  final String semanticLabel;

  static const _box = 37.0;
  static const _ring = 36.5;
  static const _dotRadius = 3.0;
  static const _dotCentreX = 23.5;
  static const _dotCentreY = 11.5;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;

    return SizedBox(
      width: _box,
      height: _box,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ElevatedSurface(
            width: _ring,
            height: _ring,
            shape: const CircleBorder(),
            color: ext.homeBellFill,
            side: BorderSide(color: ext.bellRing, width: 0.5),
            glass: elevation.homeBellGlass,
            child: const SizedBox.expand(),
          ),
          SvgPicture.asset(
            'assets/icons/notification.svg',
            width: _box,
            height: _box,
            colorFilter: ColorFilter.mode(ext.bellGlyph, BlendMode.srcIn),
            semanticsLabel: semanticLabel,
          ),
          if (hasUnread)
            PositionedDirectional(
              start: _dotCentreX - _dotRadius,
              top: _dotCentreY - _dotRadius,
              child: Container(
                width: _dotRadius * 2,
                height: _dotRadius * 2,
                decoration: BoxDecoration(
                  color: ext.bellUnreadDot,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The profile avatar, cached. Falls back to a neutral person glyph while
/// loading and if the URL fails — a broken-image icon on a student's own face
/// is a worse failure mode than a plain placeholder.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});
  final String url;

  static const _size = 51.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        // Decode at the size actually drawn. Without this the avatar is
        // decoded at its FULL source resolution regardless of the 51dp it
        // occupies — a 1024px source costs ~4 MB of heap instead of ~110 KB.
        // On the low-end Android handsets this app targets, that is real.
        // Scaled by the device pixel ratio so it stays sharp on 2x/3x screens.
        memCacheWidth: (_size * MediaQuery.devicePixelRatioOf(context)).round(),
        placeholder: (_, _) => _Fallback(size: _size, color: ext.cardFill),
        errorWidget: (_, _, _) => _Fallback(size: _size, color: ext.cardFill),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: size,
      height: size,
      color: color,
      child: Icon(Icons.person, size: size * 0.6, color: ext.mutedText),
    );
  }
}
