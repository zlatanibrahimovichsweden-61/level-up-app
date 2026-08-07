import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// One stat card · Figma `661:8571`.
///
/// Takes [value] as an already-formatted string and prints it. There is no
/// arithmetic in this widget and there must never be any: the frame's stat
/// cards are the exact place this repo has been burned before (`seif_fight.md`
/// S12 — quiz points rendered ~20× the contract's award because the design
/// promised a figure the server never sent). Whatever the server returned goes
/// on screen; if the server returns nothing, the card does not exist.
class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;

  /// Server-authoritative and pre-formatted (locale grouping happens in the
  /// ARB placeholder, not here).
  final String value;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: ext.cardFill,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // Figma `661:8571`: 0.02 / 0.02 / 1, at 25%. Colour from the
            // canvas — see [AppColors.elevationShadow].
            color: ext.elevationShadow.withValues(alpha: 0.25),
            offset: const Offset(0.02, 0.02),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 16.5 / 18,
              color: ext.profileStatLabel,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 33 / 22,
              color: ext.profileStatValue,
            ),
          ),
        ],
      ),
    );
  }
}
