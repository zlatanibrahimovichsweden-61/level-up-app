import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';

/// One stat card · Figma `661:8571` (light) / `661:8579` (dark).
///
/// **The one OPAQUE surface in the profile block.** Every other dark card here
/// is a 20% wash under Glass; `661:8579` is solid `#27282C` with no Glass and
/// the same black shadow light carries. It is also the node that settled
/// docs/DESIGN_ISSUES.md #47 — a dark card with a measurable black shadow on
/// it, which is what refuted the cream `elevationShadow` this widget used to
/// paint. The blur is **2**, not the 1 that shipped.
///
/// Takes [value] as an already-formatted string and prints it. There is no
/// arithmetic in this widget and there must never be any: the frame's stat
/// cards are the exact place this repo has been burned before (`seif_fight.md`
/// S12 — quiz points rendered ~20× the contract's award because the design
/// promised a figure the server never sent). Whatever the server returned goes
/// on screen; if the server returns nothing, the card does not exist.
class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({super.key, required this.label, required this.value});

  final String label;

  /// Server-authoritative and pre-formatted (locale grouping happens in the
  /// ARB placeholder, not here).
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return ElevatedSurface(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsetsDirectional.all(12),
      color: ext.profileStatFill,
      shadows: elevation.profileStatShadows,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppType.h3.copyWith(color: ext.profileStatLabel),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppType.displayLarge.copyWith(color: ext.profileStatValue),
          ),
        ],
      ),
    );
  }
}
