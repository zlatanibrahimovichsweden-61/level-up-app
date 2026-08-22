import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// One titled block of the Settings screen — Languages, Mode, Rank,
/// Notification Preferences.
///
/// The frame groups each block's rows inside a single outlined card rather than
/// giving every row its own, which is the one place Settings departs from the
/// Profile hub's list. The card reuses the hub's surface (`cardFill`) and 0.5px
/// `profileRowBorder` so the two screens read as the same family.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.note,
  });

  final String title;

  /// Rows, drawn with a hairline between each — a separator, not a border, so
  /// the outer card keeps its single outline.
  final List<Widget> children;

  /// An optional line under the card explaining why the block is the shape it
  /// is (a disabled section's reason, a save failure).
  final Widget? note;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 10),
          child: Text(
            title,
            style: AppType.h3.copyWith(color: ext.textPrimary),
          ),
        ),
        Container(
          // Clipped, so a row's ink splash cannot paint over the card's
          // rounded corners.
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ext.cardFill,
            border: Border.all(color: ext.profileRowBorder, width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: ext.profileRowBorder,
                  ),
                children[i],
              ],
            ],
          ),
        ),
        if (note != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
            child: note,
          ),
      ],
    );
  }
}
