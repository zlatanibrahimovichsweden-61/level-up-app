import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';

/// The "Create a New Ticket" card at the top of the support list · Figma
/// `178:3052`: 363 x 104 at radius 15, the headset disc at the start, a title
/// and a subtitle, and the round add button at the end.
///
/// **The whole card is ONE button.** The add button is drawn but is not a
/// control of its own: a second tap target for the same destination would make
/// a screen reader announce the card and then an unlabeled circle. So the
/// merged node reads the title and the subtitle together, and the glyphs are
/// excluded from semantics (an SVG inside a button turns the node into an
/// ImageView on Android).
///
/// The 104 is a MINIMUM: the card grows with the text scale rather than
/// clipping its two lines.
///
/// Dark has no frame: the card takes the support stand-ins (Glass G5, no
/// shadow) from [AppColors] / [AppElevation].
class SupportCreateCard extends StatelessWidget {
  const SupportCreateCard({super.key, required this.onTap});

  final VoidCallback onTap;

  static const _radius = 15.0;
  static const _minHeight = 104.0;

  /// `178:3057`: the headset disc is 69, drawn as the asset is.
  static const _discSize = 69.0;
  static const _discGap = 13.529;

  /// `178:3061` to `178:3065`.
  static const _lineGap = 10.824;

  /// `178:3066`: a 40 circle with a 23.3 plus.
  static const _addSize = 40.0;
  static const _plusSize = 23.3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return MergeSemantics(
      child: Semantics(
        button: true,
        child: ElevatedSurface(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          color: ext.supportCardFill,
          shadows: elevation.supportCreateCardShadows,
          glass: elevation.supportCreateCardGlass,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _minHeight),
            child: Padding(
              // 18 from the start edge; the add button is 24 from the end
              // (299 + 40 inside 363). The vertical padding only matters once
              // the text scale outgrows the minimum height.
              padding: const EdgeInsetsDirectional.fromSTEB(18, 8, 24, 8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/support_headset_disc.svg',
                    width: _discSize,
                    height: _discSize,
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(width: _discGap),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.supportCreateNewTicket,
                          style: AppType.h3.copyWith(
                            color: ext.supportCreateTitle,
                          ),
                        ),
                        const SizedBox(height: _lineGap),
                        Text(
                          l10n.supportDescribeYourIssue,
                          style: AppType.labelLarge.copyWith(
                            color: ext.supportCreateSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedSurface(
                    width: _addSize,
                    height: _addSize,
                    shape: const CircleBorder(),
                    color: ext.supportInk,
                    shadows: elevation.supportAddButtonShadows,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/support_add.svg',
                        // Height only: the glyph is square, and a width set
                        // beside a height is ignored by vector_graphics.
                        height: _plusSize,
                        colorFilter: ColorFilter.mode(
                          ext.supportOnInk,
                          BlendMode.srcIn,
                        ),
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
