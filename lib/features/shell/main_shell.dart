import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/elevation/figma_shadow_painter.dart';
import '../../l10n/app_localizations.dart';

/// The 5-tab bottom-nav shell · Figma nav `59:1264` (light) / `348:6686` (dark).
///
/// Home · Leaderboard · Learn (centre, raised into the bar's own notch) ·
/// Message · Account. Only Home is real so far; the other four are coming-soon
/// placeholders.
///
/// Built on `StatefulShellRoute.indexedStack`, so each tab keeps its own
/// Navigator and its own state: switching to Leaderboard and back must not
/// re-fetch `/me` or reset Home's scroll position.
///
/// The bar is hand-rolled rather than a Material `NavigationBar` because the
/// frame needs four things NavigationBar does not give: a thin top indicator
/// over the ACTIVE tab, a centre tab raised into a notch that is part of the
/// bar's own outline, 11px labels, and selection carried by the centre tab's
/// BACKGROUND rather than its glyph (see [_CentreTab]).
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Index of the centre tab, raised into the notch.
  static const _centreIndex = 2;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops that branch back to its root, which is
      // the behaviour every student already expects from other apps.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;
    // The bump must sit ABOVE the gesture inset, not inside it, so the inset is
    // added to the box's height and padded off the tab row rather than being
    // handled by a SafeArea that would also shrink the painted shape.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final destinations = <({String asset, String label})>[
      (asset: 'assets/icons/nav/home.svg', label: l10n.navHome),
      (asset: 'assets/icons/nav/leaderboard.svg', label: l10n.navLeaderboard),
      (asset: 'assets/icons/nav/learn.svg', label: l10n.navLearn),
      (asset: 'assets/icons/nav/message.svg', label: l10n.navMessage),
      (asset: 'assets/icons/nav/account.svg', label: l10n.navAccount),
    ];

    final row = Row(
      children: [
        for (var i = 0; i < destinations.length; i++)
          Expanded(
            child: i == _centreIndex
                ? _CentreTab(
                    asset: destinations[i].asset,
                    label: destinations[i].label,
                    selected: i == navigationShell.currentIndex,
                    onTap: () => _goBranch(i),
                  )
                : _NavTab(
                    asset: destinations[i].asset,
                    label: destinations[i].label,
                    selected: i == navigationShell.currentIndex,
                    onTap: () => _goBranch(i),
                  ),
          ),
      ],
    );

    return Scaffold(
      body: navigationShell,
      // NOT `extendBody: true`: the shaped bar would then let every screen's
      // content scroll under it, which is a layout change on five screens, not
      // a nav fix. The transparent area beside the bump shows the Scaffold's
      // own background instead.
      bottomNavigationBar: SizedBox(
        height: kNavTotalHeight + bottomInset,
        child: CustomPaint(
          painter: _NavBarPainter(
            fill: ext.navBarFill,
            shadows: elevation.navBarShadows,
          ),
          child: ClipPath(
            // Clips the ink splash to the bar's outline. The design does not
            // draw a pressed state (docs/DESIGN_ISSUES.md #37, open question),
            // so the existing ripple is kept as-is rather than replaced with a
            // second invention — it just no longer spills past the notch.
            clipper: const _NavBarClipper(),
            child: Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: row,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Bar geometry · Figma `Union` in every nav variant (59:1000 on Home) -----
//
// The bar is a Union of a 64×64 circle and a 375×96 rounded rect, so the raised
// centre is part of the bar's OWN outline rather than a circle floating over a
// square bar. Normalised to a 375×111 box with y=0 at the top of the bump, the
// export reads:
//
//   M187 0 C198.426 0 208.452 5.99 214.113 15
//   H345 C361.569 15 375 28.4315 375 45
//   V111 H0 V45 C0 28.4315 13.4315 15 30 15
//   H159.887 C165.548 5.99 175.574 0 187 0 Z
//
// [navBarPath] rebuilds that PARAMETRICALLY instead of replaying the literal
// coordinates: the radii and the bump stay fixed and only the straight runs
// grow with the width, so on a tablet the notch stays a true circle concentric
// with the (fixed r=26) centre button. Replaying the path scaled by width/375
// would stretch the notch into an ellipse and break that concentricity. At
// 375pt wide the two agree to within Figma's own half-pixel rounding of the
// centre (187 vs 187.5).

/// Height of the bar body, below the bump.
const kNavBarHeight = 96.0;

/// How far the notch rises above the bar's top edge.
const kNavBumpRise = 15.0;

/// Full height of the nav box, bump included. Excludes the safe-area inset.
const kNavTotalHeight = kNavBumpRise + kNavBarHeight; // 111

/// Radius of the notch cut into the bar's top edge.
const kNavNotchRadius = 32.0;

/// Radius of the bar's two top corners.
const kNavCornerRadius = 30.0;

/// Radius of the raised centre button. 6pt smaller than the notch, which is the
/// ring of bar visible around it.
const kNavCentreRadius = 26.0;

/// The bar's outline for a box of [size]. `size.height` may exceed
/// [kNavTotalHeight] when a gesture inset is present — the extra simply extends
/// the bottom edge, so the bar reaches the screen edge without moving the notch.
Path navBarPath(Size size) {
  final centreX = size.width / 2;
  // Half-chord of the notch circle at the bar's top edge.
  final halfChord = math.sqrt(
    kNavNotchRadius * kNavNotchRadius -
        math.pow(kNavNotchRadius - kNavBumpRise, 2),
  );
  const notch = Radius.circular(kNavNotchRadius);
  const corner = Radius.circular(kNavCornerRadius);

  return Path()
    ..moveTo(centreX, 0)
    ..arcToPoint(Offset(centreX + halfChord, kNavBumpRise), radius: notch)
    ..lineTo(size.width - kNavCornerRadius, kNavBumpRise)
    ..arcToPoint(
      Offset(size.width, kNavBumpRise + kNavCornerRadius),
      radius: corner,
    )
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..lineTo(0, kNavBumpRise + kNavCornerRadius)
    ..arcToPoint(const Offset(kNavCornerRadius, kNavBumpRise), radius: corner)
    ..lineTo(centreX - halfChord, kNavBumpRise)
    ..arcToPoint(Offset(centreX, 0), radius: notch)
    ..close();
}

/// Paints the bar: drop shadow, then fill. No top border — the frame has a
/// shadow under a shaped sheet, not a rule across a rectangle.
///
/// The shadow is [AppElevation.navBarShadows], painted by the shared
/// [paintFigmaShadows]. The two canvases genuinely differ here — light
/// `59:1264` is a cool grey-lilac at (0, 2.144) blur 16.08, dark `349:16719` a
/// lavender haze at a tenth alpha and blur 12.5 — which is why the painter
/// takes the token list rather than one colour with one geometry. The knockout
/// matters on this shape in particular: the old code drew an offset copy of the
/// whole path underneath the bar, so the shadow filled the notch's inner curve
/// instead of ringing it.
class _NavBarPainter extends CustomPainter {
  const _NavBarPainter({required this.fill, required this.shadows});

  final Color fill;
  final List<FigmaShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final path = navBarPath(size);
    paintFigmaShadows(canvas, path, shadows);
    canvas.drawPath(path, Paint()..color = fill);
  }

  @override
  bool shouldRepaint(_NavBarPainter oldDelegate) =>
      oldDelegate.fill != fill || !listEquals(oldDelegate.shadows, shadows);
}

class _NavBarClipper extends CustomClipper<Path> {
  const _NavBarClipper();

  @override
  Path getClip(Size size) => navBarPath(size);

  @override
  bool shouldReclip(_NavBarClipper oldClipper) => false;
}

// --- Tab vertical rhythm ----------------------------------------------------
//
// Fixed by the frame: the bar's top edge is at y=15 and the centre button is
// concentric with the notch, so its circle spans y=6…58. The label row is then
// shared by all five tabs so the labels line up despite the centre tab being
// anchored to the notch rather than to the bar body.
const _labelTop = 70.0;
const _glyphSlot = 24.0;
const _centreDiameter = kNavCentreRadius * 2; // 52
const _centreTop = kNavNotchRadius - kNavCentreRadius; // 6
const _ruleHeight = 2.0;
const _ruleWidth = 26.0;

/// One of the four ordinary tabs: the 26×2 top rule when selected, one glyph,
/// one label. There is no separate on/off artwork in the design — selection
/// only changes the tint.
class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.asset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    // Inactive is the shared muted grey in both canvases; active is the nav's
    // own accent, which flips green→purple (unlike Home).
    final color = selected ? ext.navAccent : ext.mutedText;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: kNavBumpRise),
            // The frame's 26×2 rounded rule over the selected tab.
            Container(
              width: _ruleWidth,
              height: _ruleHeight,
              decoration: BoxDecoration(
                color: selected ? ext.navAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(_ruleHeight / 2),
              ),
            ),
            const SizedBox(
              height: _labelTop - kNavBumpRise - _ruleHeight - _glyphSlot - 4,
            ),
            // BoxFit.contain, NOT a forced square: three of the five glyphs
            // have a non-square viewBox and stretch if boxed.
            // The outer `Semantics` above carries the tab's one label and its
            // button role. The glyph's own image semantics and the label's own
            // text node must NOT merge into it: with them, TalkBack read every
            // tab as an image called "Home, Home" (Fable-eye audit 2026-10-06,
            // FE-01) — the image flag outranks the button flag on Android.
            SvgPicture.asset(
              asset,
              width: _glyphSlot,
              height: _glyphSlot,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            ExcludeSemantics(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (selected ? AppType.navActive : AppType.navDefault)
                    .copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The centre (Learn) tab. It is the one tab whose BACKGROUND carries the
/// selected state: the circle fills with the accent and the glyph goes white.
/// Tinting the glyph and leaving the circle alone is the inverse of the design
/// (docs/DESIGN_ISSUES.md #38). The frame draws no border on this circle.
class _CentreTab extends StatelessWidget {
  const _CentreTab({
    required this.asset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final circleFill = selected ? ext.navAccent : ext.navCentreIdleFill;
    final glyphColor = selected ? ext.navCentreGlyphOn : ext.mutedText;
    final labelColor = selected ? ext.navAccent : ext.mutedText;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: _centreTop),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _centreDiameter,
              height: _centreDiameter,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleFill,
                shape: BoxShape.circle,
              ),
              // Same as [_NavTab]: one node, one label, button role (FE-01).
              child: SvgPicture.asset(
                asset,
                width: _glyphSlot,
                height: _glyphSlot,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(glyphColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: _labelTop - _centreTop - _centreDiameter),
            ExcludeSemantics(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (selected ? AppType.navActive : AppType.navDefault)
                    .copyWith(color: labelColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
