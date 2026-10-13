import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/notification_models.dart';
import 'notification_category_style.dart';

/// The inbox's filter row · Figma `180:8554`: All · Announcements · Support ·
/// System, 8 apart, scrolling sideways when they do not fit.
///
/// **There is no Promotions chip.** The frame draws one, and the contract's
/// `category` enum has no such value (`system`, `announcements`, `support`);
/// the frame's offer rows are a surface the app never builds either
/// (adr-049 §3). Logged as DG-57.
///
/// `null` is **All** — the absence of a `category`, exactly as
/// [NotificationCategory] documents; there is no `all` value to select.
///
/// The row starts at the START edge, so it begins at the right in Arabic with
/// no direction-specific code. The pills sit 20 under the title bar's bottom
/// edge and the list begins 25 under them (the frame's two gaps, `180:8528`
/// ends at y=95, `180:8554` starts at y=115). Each gap is measured to the
/// DRAWN pill, so it is less the slack a chip's 48 tap target adds above and
/// below its 40, and the first also less the 8 `TitledChrome` already leaves
/// under the bar.
class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  /// The chosen category; `null` = All.
  final NotificationCategory? selected;
  final ValueChanged<NotificationCategory?> onChanged;

  /// The slack a chip's tap target adds above and below its drawn height.
  static const _slack = (_Chip._tapTarget - _Chip._height) / 2;

  /// `TitledChrome`'s own padding under the 35 title bar. The row is hosted
  /// beneath it, so that 8 is already part of the 20.
  static const _titleChromeBottom = 8.0;

  /// The title bar → pill gap, less the chrome's padding and that slack.
  static const _top = 20 - _titleChromeBottom - _slack;

  /// Space below the row before the first notification: the frame's 25, less
  /// the slack. The list uses it as its own top padding.
  static const bottomGap = 25 - _slack;

  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(20, _top, 20, 0),
      child: Row(
        children: [
          _Chip(
            key: const Key('notification_chip_all'),
            label: l10n.notifFilterAll,
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          for (final category in _chipOrder) ...[
            const SizedBox(width: _gap),
            _Chip(
              key: Key('notification_chip_${category.wire}'),
              label: category.label(l10n),
              glyph: category.glyphAsset,
              selected: selected == category,
              onTap: () => onChanged(category),
            ),
          ],
        ],
      ),
    );
  }
}

/// The frame's three category chips, in ITS order: Announcements · Support ·
/// System. That is not the enum's declaration order (`system`,
/// `announcements`, `support`), so the order is one explicit list here rather
/// than whatever the enum happens to declare.
const _chipOrder = [
  NotificationCategory.announcements,
  NotificationCategory.support,
  NotificationCategory.system,
];

/// One chip · `180:8555` (selected) / `180:8557` (idle).
///
/// Stadium, padding 12 / 6, drawn at least 40 tall; the TOUCH target is at
/// least 48 and the whole box takes the tap, not only the pill.
/// Idle is the raised surface: a tight inner shadow in light (`180:8557`), and
/// in dark a 20% fill under Glass with no shadow — a stand-in, there being no
/// dark frame (DG-35). Selected is purple and FLAT on both canvases.
///
/// **A separate widget from the quiz review's filter chip on purpose.** That
/// one is private to its screen, draws a coloured badge disc rather than a
/// glyph, is 32 tall and fills with a different light colour; reusing it would
/// have meant editing the quiz feature or bending four of its details.
class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.glyph,
  });

  final String label;

  /// The category's SVG; `null` on All, which draws no glyph.
  final String? glyph;
  final bool selected;
  final VoidCallback onTap;

  /// The pill's drawn height (`180:8554`: the row is 40 high). A MINIMUM, not
  /// a fixed box, so a larger text scale grows the chip instead of clipping the
  /// label.
  static const _height = 40.0;

  /// Material and both platforms' accessibility guidance floor a tap target at
  /// 48 / 44. The pill stays 40 tall; the target does not. Also a MINIMUM: the
  /// box grows with the pill at a larger text scale.
  static const _tapTarget = 48.0;

  static const _glyphSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final labelColor = selected
        ? ext.notificationChipSelectedLabel
        : ext.notificationChipIdleLabel;

    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        // Neither a SizedBox nor a Center hit-tests itself, so the 4 above and
        // below the pill would drop a tap. An opaque detector makes the whole
        // box the target (the Home bell does the same); the pill's InkWell is
        // deeper, wins any tap inside it and keeps the ripple, so `onTap`
        // fires once. Its own semantics are left to the InkWell.
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          excludeFromSemantics: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _tapTarget),
            child: Center(
              // No `width`/`height` on the surface on purpose: the pill's 40
              // is a MINIMUM, and the 48 above is a floor, not a fixed box.
              child: ElevatedSurface(
                shape: const StadiumBorder(),
                color: selected
                    ? ext.notificationChipSelectedFill
                    : ext.notificationChipIdleFill,
                // The selected chip has no shadow and no Glass in either canvas.
                shadows: selected
                    ? const []
                    : elevation.notificationChipIdleShadows,
                glass: selected ? null : elevation.notificationChipIdleGlass,
                onTap: onTap,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: _tapTarget,
                    minHeight: _height,
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (glyph case final glyph?) ...[
                        SvgPicture.asset(
                          glyph,
                          // Height only: the width is derived from it.
                          height: _glyphSize,
                          colorFilter: ColorFilter.mode(
                            labelColor,
                            BlendMode.srcIn,
                          ),
                          // The label names the chip; the glyph's own image
                          // semantics would turn the node into an ImageView.
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        label,
                        // The frame draws the selected label at 16 and the idle
                        // one at 14, both 600 — the scale's buttonLarge and
                        // labelLarge.
                        style:
                            (selected
                                    ? AppType.buttonLarge
                                    : AppType.labelLarge)
                                .copyWith(color: labelColor),
                      ),
                    ],
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
