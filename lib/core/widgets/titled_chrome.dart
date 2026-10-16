import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'circle_back_button.dart';

/// The Account cluster's title bar: a 35pt back chip pinned to the start edge
/// and a centred title, with the screen's body beneath it.
///
/// The frames draw this bar on every screen behind the Profile hub — Edit
/// Profile (`180:4012`), Setting (`176:1840`) and each of the shells — instead
/// of a Material `AppBar`: the title is centred and the affordance is the
/// registration flow's circular chip, neither of which `AppBar` gives without
/// being fought.
///
/// Used by Settings and the four shell screens. `EditProfileChrome` is the same
/// bar with its title hardcoded; it predates this widget and is left alone
/// because Day 8 step 3 does not touch step 2's files. Collapsing the two is a
/// one-file cleanup for whoever next opens Edit Profile — noted here rather
/// than done silently, so the duplication is deliberate and dated instead of
/// discovered. (Done in O-15: `EditProfileChrome` is now this widget.)
///
/// **Geometry (O-15).** The frame is a 35 bar 16 below the safe area, 20 in from
/// each side, 8 above the body. The chip is now a padded 48 box, so the bar is
/// at least 48 and every inset gives back [CircleBackButton.tapSlop]: at 1.0×
/// the chip, the title and the body sit on exactly the pixels they always had.
///
/// The title keeps clear of the 48 box on BOTH sides, so it stays centred and
/// never runs under the chip, and it wraps instead of ellipsising: a larger
/// text scale grows the bar rather than clipping a 52 px line in a 35 px box,
/// which is what it did at 2.0× (DESIGN_ISSUES #131 §11). The titles are short
/// static labels; at 1.0× every one fits on one line from 360 dp up (at 320
/// the Arabic "Edit Profile" takes two).
class TitledChrome extends StatelessWidget {
  const TitledChrome({
    super.key,
    required this.title,
    required this.child,
    this.backKey,
    this.onBack,
  });

  final String title;
  final Widget child;

  /// Key on the back chip, so a test can leave the screen the way a student
  /// does rather than by calling the router. It marks the drawn chip
  /// ([CircleBackButton.chipKey]), so a test that measures "the back chip"
  /// still measures the frame's 35, not the 48 target around it.
  final Key? backKey;

  /// Defaults to `maybePop`. Screens with something to guard pass their own.
  final VoidCallback? onBack;

  /// The frame's insets around its 35 bar.
  static const _side = 20.0;
  static const _top = 16.0;
  static const _bottom = 8.0;

  static const _slop = CircleBackButton.tapSlop;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            _side - _slop,
            _top - _slop,
            _side - _slop,
            _bottom - _slop,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: CircleBackButton.tapTarget,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CircleBackButton.tapTarget,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppType.h2.copyWith(color: ext.textPrimary),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  child: CircleBackButton(
                    chipKey: backKey,
                    tapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
