import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// The AR/EN language-toggle pill · Figma `82:1093` (light) / `337:19693`
/// (dark). Shows the OTHER language's endonym (its `label`) and flips the
/// locale on tap. Place it top-end so it sits at the right in LTR and the left
/// in RTL. Shared across auth + registration screens — this is the only copy.
class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  /// Frame metrics. The radius is exactly half the height — a full stadium, so
  /// it holds at any width.
  static const _height = 36.10;
  static const _radius = _height / 2; // 18.05
  static const _inset = 14.47;
  static const _gap = 10.07;
  static const _iconSize = 20.13;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    // Null in the dark canvas ON PURPOSE: the frame draws no outline there.
    final border = ext.languagePillBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_radius),
      child: Container(
        height: _height,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: _inset),
        decoration: BoxDecoration(
          color: ext.background,
          border: border == null ? null : Border.all(color: border),
          borderRadius: BorderRadius.circular(_radius),
        ),
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
