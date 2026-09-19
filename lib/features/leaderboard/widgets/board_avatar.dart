import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A student's avatar on the board.
///
/// `avatarUrl` is `required` on `LeaderboardEntry`, so there is no "missing
/// avatar" case in the contract — but the URL still points at a CDN that can be
/// slow or unreachable, and a board row must render either way. Both the
/// loading and the failed state fall back to the same neutral placeholder
/// rather than a broken-image glyph.
///
/// Deliberately no name initials in the fallback: these are minors, and a
/// placeholder that spells out a student's initials leaks more than a blank
/// circle does.
class BoardAvatar extends StatelessWidget {
  const BoardAvatar({
    super.key,
    required this.url,
    required this.diameter,
    this.ringColor,
    this.ringWidth = 0,
  });

  final String url;
  final double diameter;
  final Color? ringColor;
  final double ringWidth;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ext.progressTrack,
        border: ringColor != null && ringWidth > 0
            ? Border.all(color: ringColor!, width: ringWidth)
            : null,
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          // Both failure and in-flight render the same neutral circle, so a
          // slow CDN never shows a broken-image glyph mid-scroll.
          errorBuilder: (_, _, _) => _Placeholder(color: ext.mutedText),
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : _Placeholder(color: ext.mutedText),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.contain,
    child: Icon(Icons.person, color: color),
  );
}
