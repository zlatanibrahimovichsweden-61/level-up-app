import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
// CROSS-FEATURE IMPORT, deliberate — the same reason `settings_rows.dart`
// carries it: unavailable must look identical everywhere in this cluster, so
// the dim is Step 1's constant and not a second one beside it.
import '../../profile/widgets/profile_menu_row.dart'
    show kProfileDisabledOpacity;

/// The body of a shell screen: an icon, one explanatory line, and — where the
/// frame draws one — the screen's primary control, disabled.
///
/// **These are shells, not mocks.** No referral code, no ticket list, no friend
/// rows: every one of those would be data we invented for a feature with no
/// endpoint, and a student who reads an invented code and shares it has been
/// actively lied to. An empty, honest screen is the rule this repo has followed
/// since Day 7's "Review Questions" (S14), applied to a whole screen instead of
/// a button.
class ShellBody extends StatelessWidget {
  const ShellBody({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;

  /// One line. Says the thing is not available — it does not describe a feature
  /// that does not exist yet.
  final String message;

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: ext.mutedText),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: ext.textSecondary),
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// A primary button that renders and cannot be pressed.
///
/// Hand-drawn rather than a `FilledButton(onPressed: null)` for one structural
/// reason: `ButtonStyleButton` builds an [InkWell], and the whole disabled
/// contract in this cluster is that a dead control has **no ink response
/// anywhere in its subtree** — which is what the widget tests assert. A
/// disabled Material button also merely ignores its callback; it stays in the
/// tap-target tree. This one is wrapped in an [IgnorePointer] and announced
/// with its reason.
///
/// Metrics are Edit Profile's Save button (h60, r20) so the cluster's primary
/// control is one shape.
class DisabledActionButton extends StatelessWidget {
  const DisabledActionButton({
    super.key,
    required this.label,
    required this.disabledHint,
  });

  final String label;
  final String disabledHint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      enabled: false,
      label: label,
      hint: disabledHint,
      child: IgnorePointer(
        child: Opacity(
          opacity: kProfileDisabledOpacity,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: cs.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
