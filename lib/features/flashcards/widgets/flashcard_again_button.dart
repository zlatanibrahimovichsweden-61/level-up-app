import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';

/// The restart ("again") button · Figma `1229:8739`.
///
/// A 38 dp disc holding the `humbleicons:restart` glyph, pinned to the END edge
/// of the study screen. Tapping it records the card as "again" and moves on —
/// the screen decides what that means; this widget is only the control.
///
/// **Hit target.** The disc is 38 dp, under Android's 48 dp minimum, so the
/// tappable box is 48 dp centred on it. The extra 5 dp on each side is INSIDE
/// this widget's own size (a `Stack` does not hit-test outside its bounds), so
/// the caller lays out a 48 dp box and pulls its margins in by 5 to keep the
/// disc where the frame puts it.
///
/// **Semantics.** One button labelled [AppLocalizations.flashcardAgain]; the
/// glyph is excluded, because a bare arrow has no name of its own.
///
/// **No shadow.** The frame draws none (`1229:8739` carries no effects), so the
/// disc takes no elevation token. It has no dark-canvas frame either: the dark
/// fill is a stand-in already recorded on the token
/// (`AppColors.flashcardAgainFill`).
///
/// **Not mirrored in RTL.** The glyph is a circular arrow, not a directional
/// chevron; nothing about "start again" flips with reading direction.
class FlashcardAgainButton extends StatelessWidget {
  const FlashcardAgainButton({super.key, required this.onPressed});

  /// Null while something is in flight (or the device is offline): the disc is
  /// dimmed, inert, and reads as disabled to a screen reader.
  final VoidCallback? onPressed;

  /// The frame's disc (`1229:8739`, 38 x 38).
  static const discSize = 38.0;

  /// Android's minimum touch target, centred on the disc.
  static const targetSize = 48.0;

  /// How far the target reaches past the disc on each side: 5.
  static const overhang = (targetSize - discSize) / 2;

  /// The export is the glyph's 26 dp box (22 dp of stroke plus its 3.17 bleed).
  static const _glyphSize = 26.0;

  /// The project's one disabled convention (`kProfileDisabledOpacity`).
  static const _disabledOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);
    final enabled = onPressed != null;

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: l10n.flashcardAgain,
      onTap: onPressed,
      excludeSemantics: true,
      child: SizedBox(
        width: targetSize,
        height: targetSize,
        child: GestureDetector(
          // Opaque, so the 5 dp ring around the disc is live too.
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : _disabledOpacity,
              child: ElevatedSurface(
                shape: const CircleBorder(),
                width: discSize,
                height: discSize,
                color: ext.flashcardAgainFill,
                onTap: onPressed,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/flashcard_again.svg',
                    width: _glyphSize,
                    height: _glyphSize,
                    excludeFromSemantics: true,
                    colorFilter: ColorFilter.mode(
                      ext.flashcardAgainGlyph,
                      BlendMode.srcIn,
                    ),
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
