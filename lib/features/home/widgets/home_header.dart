import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Home header · Figma `337:5323` — avatar + "Welcome back, {name}" + bell,
/// over a hairline bottom rule.
///
/// The bell is intentionally INERT: there is no notifications endpoint in the
/// contract and no inbox screen yet, so it renders without a badge and does
/// nothing. It is not wired to a dead route on purpose — a tap that navigates
/// nowhere is worse than a tap that visibly does nothing.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.name, required this.avatarUrl});

  final String name;
  final String avatarUrl;

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
                  style: TextStyle(fontSize: 12, color: ext.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ext.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // TODO(design-asset): real bell glyph (Figma node 337:5330,
          // mingcute:notification-fill) — blocked by export-disabled + View-only
          // seat. See docs/DESIGN_ISSUES.md #1.
          Icon(
            Icons.notifications,
            size: 36,
            color: ext.textPrimary,
            semanticLabel: l10n.notifications,
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
