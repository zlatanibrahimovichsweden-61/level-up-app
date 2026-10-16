import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_typography.dart';
import 'elevation/elevated_surface.dart';

/// The AR/EN language-toggle pill · Figma `82:1093` (light) / `340:19734`
/// (dark). Shows the OTHER language's endonym (its `label`) and flips the
/// locale on tap. Place it top-end so it sits at the right in LTR and the left
/// in RTL. Shared across auth + registration screens — this is the only copy.
///
/// Light is `#FCFBF9` under a **0.629032** `#4B675E` hairline. Dark is
/// `#232428` at 20% with **no outline at all** and Glass G3 — a weak rim
/// (intensity 0.25) instead of a border. All seven dark instances are
/// identical; the 2026-09-16 reading that had the OTP pills drawn solid was
/// wrong (edit2 §5 #33).
class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  /// Frame metrics. The frame's radius is exactly half the height, so the
  /// shape is a `StadiumBorder` and no radius constant is needed — it holds at
  /// any width and at any text scale.
  ///
  /// Public because a header row that holds the pill beside the back chip's
  /// 48 box (O-15) needs it to keep its other children where they were.
  static const height = 36.10;
  static const _inset = 14.47;
  static const _gap = 10.07;
  static const _iconSize = 20.13;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    // Null in the dark canvas ON PURPOSE: the frame draws no outline there.
    final border = ext.languagePillBorder;

    // One button node labelled by the text. `ElevatedSurface` adds no
    // semantics of its own, and the glyph's image semantics used to win the
    // merge: TalkBack announced the pill as an IMAGE with no button role
    // (Fable-eye audit 2026-10-06, FE-06).
    return Semantics(
      button: true,
      child: ElevatedSurface(
        shape: const StadiumBorder(),
        height: height,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: _inset),
        // `languagePillFill`, not `background`: the pill used to paint the page
        // colour, which is why it vanished into the page on the dark canvas.
        color: ext.languagePillFill,
        side: border == null
            ? null
            : BorderSide(
                color: border,
                width: elevation.languagePillBorderWidth,
              ),
        glass: elevation.languagePillGlass,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // meteor-icons:language — the 文A translate mark, STROKE-drawn at
            // 1.67742 with round caps. The hairline weight is the whole look,
            // so it is tinted, never re-rendered as a fill.
            SvgPicture.asset(
              'assets/icons/language.svg',
              width: _iconSize,
              height: _iconSize,
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(
                ext.languagePillContent,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: _gap),
            Text(
              label,
              style: AppType.labelLarge.copyWith(
                color: ext.languagePillContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
