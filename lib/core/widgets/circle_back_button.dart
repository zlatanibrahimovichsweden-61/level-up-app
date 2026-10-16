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
///
/// **The tap target (O-15).** The drawn chip is 35, under the 48 that Material
/// and Android's accessibility checks ask for. [MaterialTapTargetSize.padded]
/// lays the chip out in a [tapTarget] box instead — the chip keeps its 35 and
/// its look, the box is the finger's. The box only works if the bar around it
/// is at least 48 tall too: a render box refuses a pointer outside its own
/// size, so a 48 box inside a 35 bar is still a 35 target (D-013,
/// DESIGN_ISSUES #80). A call site that switches to padded therefore takes
/// [tapSlop] (or, for an off-centre box, twice it) off the insets around the
/// chip and grows its bar to 48, so the chip lands on exactly the pixels it had.
///
/// [MaterialTapTargetSize.shrinkWrap], the default, is the old 35 box; the
/// call sites that still use it are listed in DESIGN_ISSUES #132.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({
    super.key,
    required this.onPressed,
    this.variant = BackChipVariant.standard,
    this.tapTargetSize = MaterialTapTargetSize.shrinkWrap,
    this.chipAlignment = AlignmentDirectional.center,
    this.chipKey,
  });

  final VoidCallback onPressed;

  /// [BackChipVariant.standard] everywhere except the four registration frames.
  final BackChipVariant variant;

  /// [MaterialTapTargetSize.padded] for a [tapTarget] box around the chip.
  final MaterialTapTargetSize tapTargetSize;

  /// Where the chip sits inside the padded box; ignored when shrink-wrapped.
  ///
  /// Centred in a `Stack` bar, where the box can spill [tapSlop] past the chip
  /// on every side. In a `Row`, whose next child must not move, the chip goes
  /// flush to one edge and the box spills twice [tapSlop] the other way —
  /// the Home bell's layout.
  final AlignmentDirectional chipAlignment;

  /// Key on the DRAWN chip. A screen's tests measure the chip the frame draws
  /// and tap it the way a student does; once padded, the widget's own [key]
  /// is the whole 48 box, which is the target, not the chip.
  final Key? chipKey;

  /// The drawn chip.
  static const double chipSize = 35;

  /// Material's minimum interactive dimension.
  static const double tapTarget = kMinInteractiveDimension;

  /// How far a centred padded box reaches past the chip on each side: 6.5.
  static const double tapSlop = (tapTarget - chipSize) / 2;

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
    final label = MaterialLocalizations.of(context).backButtonTooltip;

    final chip = ElevatedSurface(
      key: chipKey,
      shape: const CircleBorder(),
      width: chipSize,
      height: chipSize,
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
    );

    if (tapTargetSize == MaterialTapTargetSize.shrinkWrap) {
      return Semantics(button: true, label: label, child: chip);
    }

    // The bell's arrangement (`home_header.dart`): the chip keeps its ink, a
    // plain detector takes the rest of the box, and this one labelled node —
    // the whole box — carries the tap. Left in, the chip's InkWell would add a
    // second, unlabelled clickable node inside it.
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: tapTarget,
          child: Align(
            alignment: chipAlignment,
            child: ExcludeSemantics(child: chip),
          ),
        ),
      ),
    );
  }
}
