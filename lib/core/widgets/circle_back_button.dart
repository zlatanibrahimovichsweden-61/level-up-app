import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// The registration flow's circular back chip · Figma `90:208`.
///
/// A 35×35 filled circle with NO stroke, holding `weui:arrow-filled`. The soft
/// ring visible in the render reads as a shadow rather than a border
/// (docs/DESIGN_ISSUES.md #40, open question 3), so none is drawn.
///
/// Shared rather than re-declared per screen — this chip recurs across the
/// registration screens and drifted into a bare `IconButton` on at least one of
/// them once already.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  static const _size = 35.0;
  static const _chevronWidth = 15.0;
  static const _chevronHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    // The asset points RIGHT (it is the forward chevron), so back is its
    // mirror in LTR — and its unmirrored self in RTL, where back IS rightward.
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).backButtonTooltip,
      child: Material(
        color: ext.backChipFill,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: _size,
            height: _size,
            child: Center(
              child: Transform.flip(
                flipX: !rtl,
                child: SvgPicture.asset(
                  'assets/icons/chevron.svg',
                  width: _chevronWidth,
                  height: _chevronHeight,
                  colorFilter: ColorFilter.mode(
                    ext.backChipGlyph,
                    BlendMode.srcIn,
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
