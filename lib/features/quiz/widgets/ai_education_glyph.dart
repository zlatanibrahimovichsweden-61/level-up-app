import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The frames' `tdesign:ai-education` glyph: a 26.55-dp Iconify box with the
/// asset drawn inside it at the frame's own scale.
///
/// Every instance read (the AI panel `159:1839` and dark `337:9272`, the
/// result CTA `159:2348` and dark `348:7871`, review `162:2589`) holds the
/// same group: 22.12 x 21.01, 2.215 from the box's left and 2.289 from its
/// top. `assets/icons/ai_education.svg` is that group at 1:1: its geometry
/// spans 22.12 x 21.01 from x 2.031, y 2.287 of a 27 x 25 viewBox. So the
/// asset is drawn 27 x 25, nudged right and down by the difference.
///
/// Boxing it into the 26.55 square instead drew it at 1.062x, because
/// `vector_graphics` derives the width from the height and ignores the width
/// passed with it (DESIGN_ISSUES #98, owner ruling 2026-09-27).
///
/// The box is what the frames' auto layout spaces and centres. The asset's
/// transparent margin overhangs it by 0.63 on the right; its ink does not.
/// The glyph is not direction-semantic, so it is not mirrored.
class AiEducationGlyph extends StatelessWidget {
  const AiEducationGlyph({super.key, required this.color});

  /// The ink colour, applied with `srcIn`.
  final Color color;

  /// The frames' Iconify box.
  static const box = 26.55;

  /// The asset's viewBox height; the width follows it (27).
  static const drawnHeight = 25.0;

  /// Where the asset's corner sits in the box: the frame's group offset less
  /// the asset's own geometry offset.
  static const left = 2.21500 - 2.03076;
  static const top = 2.28942 - 2.28735;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: box,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: left,
            top: top,
            child: SvgPicture.asset(
              'assets/icons/ai_education.svg',
              height: drawnHeight,
              // Whatever sits beside it (a title, a button label) names it.
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}
