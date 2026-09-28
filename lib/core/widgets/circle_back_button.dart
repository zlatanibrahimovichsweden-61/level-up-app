import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import 'elevation/elevated_surface.dart';

/// Which of the design's two back chips this is.
///
/// They are not one chip seen on two canvases: the registration frames draw a
/// different neutral AND a different Glass from every other screen, so the
/// variant is a design distinction the widget has to be told about, not
/// something it can derive from the theme.
enum BackChipVariant {
  /// Learn (Subjects/Units/Chapters/Lessons/Lectures), Mistakes, Setup, Result,
  /// Leaderboard, Settings, Edit Profile. Light `90:208` · dark `404:7424`
  /// (`#27282C` at 20%, Glass G5).
  standard,

  /// The four registration frames: Sign Up_1 `337:15875`, Sign Up_2
  /// `337:15947`, School `337:5269`, University `337:10373`. Dark `337:19690`
  /// is `#333439` at 20% under Glass G2 — a lighter disc with a weaker rim.
  registration,
}

/// The circular back chip · Figma `90:208` (light) / `404:7424` (dark).
///
/// A 35×35 filled circle with NO stroke, holding `weui:arrow-filled`. The soft
/// ring in the light render is the chip's drop shadow — (0.02833, 0.02833) blur
/// 1.3, black 25% — not a border, which is why none is drawn (this supersedes
/// the open question in docs/DESIGN_ISSUES.md #40: the ring is measured now).
///
/// **The dark chip carries no shadow at all** and elevates with Figma Glass
/// over a 20%-alpha fill instead (edit1.md R1). An empty shadow list on that
/// canvas is a reading, not a gap — do not "restore" one.
///
/// Shared rather than re-declared per screen. It had already drifted into a
/// bare `IconButton` on one registration screen and into a Material
/// `Icons.arrow_back_ios_new` in `CatalogHeader`; both are now this widget.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({
    super.key,
    required this.onPressed,
    this.variant = BackChipVariant.standard,
  });

  final VoidCallback onPressed;

  /// [BackChipVariant.standard] everywhere except the four registration frames.
  final BackChipVariant variant;

  static const _size = 35.0;
  static const _chevronWidth = 15.0;
  static const _chevronHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    // The asset points RIGHT (it is the forward chevron), so back is its
    // mirror in LTR — and its unmirrored self in RTL, where back IS rightward.
    final rtl = Directionality.of(context) == TextDirection.rtl;

    final registration = variant == BackChipVariant.registration;

    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).backButtonTooltip,
      child: ElevatedSurface(
        shape: const CircleBorder(),
        width: _size,
        height: _size,
        color: registration
            ? ext.registrationBackChipFill
            : ext.backChipSurfaceFill,
        shadows: elevation.backChipShadows,
        glass: registration
            ? elevation.registrationBackChipGlass
            : elevation.backChipGlass,
        onTap: onPressed,
        child: Center(
          child: Transform.flip(
            flipX: !rtl,
            child: SvgPicture.asset(
              'assets/icons/chevron.svg',
              width: _chevronWidth,
              height: _chevronHeight,
              // The Semantics above names the chip. Without this the glyph's
              // own image semantics merge in and TalkBack reads an ImageView
              // on every screen with the chip (API→UI Wave 13; W11-7).
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(ext.backChipGlyph, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
