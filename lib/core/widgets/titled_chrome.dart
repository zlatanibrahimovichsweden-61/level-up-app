import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
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
/// discovered.
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
  /// does rather than by calling the router.
  final Key? backKey;

  /// Defaults to `maybePop`. Screens with something to guard pass their own.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 8),
          child: SizedBox(
            height: 35,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: ext.textPrimary,
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  child: CircleBackButton(
                    key: backKey,
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
