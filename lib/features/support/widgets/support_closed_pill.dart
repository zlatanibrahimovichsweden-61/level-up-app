import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// The Closed status pill · Figma `178:3131`: 23.974 high, at least 73.323
/// wide, a stadium filled with `#B6B6B6` at 13%, its label centred.
///
/// **Closed is the only status with a pill.** `open`, `in_progress` and
/// `pending` have no approved text in either language, so they get nothing
/// (CW12a_PLAN §4.3), and an unknown status is "in progress, not closed" and
/// gets nothing either. The caller decides whether to draw this; the widget
/// has no status of its own to branch on.
///
/// The label is `buttonSmall` (12 / 16, SemiBold), the nearest style on the
/// scale to the frame's 12 / 16 SemiBold. The height is a MINIMUM, so the pill
/// grows with the text scale instead of clipping its label.
class SupportClosedPill extends StatelessWidget {
  const SupportClosedPill({super.key});

  static const _minHeight = 23.974;
  static const _minWidth = 73.323;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      constraints: const BoxConstraints(
        minHeight: _minHeight,
        minWidth: _minWidth,
      ),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: ext.supportPillClosedFill,
        shape: const StadiumBorder(),
      ),
      // A Row, not an `alignment`: it centres the label on the minimum height
      // and on the minimum width, and lets the pill hug a longer label.
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              l10n.supportStatusClosed,
              textAlign: TextAlign.center,
              style: AppType.buttonSmall.copyWith(
                color: ext.supportPillClosedLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
