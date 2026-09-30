import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The frame's avatar disc: a circle filled with a radial gradient, the avatar
/// image clipped inside it. Edit Profile's 151 dp avatar (`176:1343`) and every
/// 69 dp cell of the Choose Avatar picker (`180:4277`…) draw the same fill, on
/// both tracks and both canvases (API→UI Wave 20).
///
/// The gradient only shows where the image does not cover the disc: behind a
/// transparent avatar, and while nothing has loaded. An opaque photo hides it.
class AvatarDisc extends StatelessWidget {
  const AvatarDisc({super.key, required this.size, required this.child});

  final double size;

  /// The image, clipped to the disc.
  final Widget child;

  /// The frame's `gradientTransform` (`176:1343`, the same on `180:4277`),
  /// inverted: the centre sits at (0.526, 0.538) of the box and the radius is
  /// 0.5 / 0.6791 = 0.736 of its side. Geometry, not colour, so it lives here;
  /// the two colours are [AppColors.avatarDiscInner] and
  /// [AppColors.avatarDiscOuter].
  static const center = Alignment(0.0513, 0.0769);
  static const radius = 0.7362;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors: [ext.avatarDiscInner, ext.avatarDiscOuter],
        ),
      ),
      child: ClipOval(child: child),
    );
  }
}
