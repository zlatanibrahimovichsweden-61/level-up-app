import 'package:flutter/material.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../l10n/app_localizations.dart';

/// The free-plan limit sheet · Figma `199:2335` (school) ·
/// `225:6634` / `225:7001` (university).
///
/// Opened by the two 403s on `POST /quizzes` that are not inline errors:
/// `weekly_question_limit_reached` and `subscription_required`. Same sheet,
/// different heading and body.
///
/// **Purchase-silent (adr-049 §3).** The frames draw an "Upgrade To Premium"
/// button over a benefits list; the contract forbids both — the app never
/// shows a paywall, a price, an upgrade link or where to buy. The sheet
/// explains the 403 and offers "Not now", nothing else (D-007,
/// docs/DESIGN_ISSUES.md #51).
///
/// **Weekly, not daily.** The frame family says "Daily Limit Reached"; the
/// contract says *"Free plan: 50 questions/WEEK"* and names the code
/// `weekly_question_limit_reached`. The server owns the rule and the code name
/// agrees with it, so the copy says weekly (docs/seif_fight.md S16).
///
/// **The "QUESTIONS 50/50" bar is not built.** Nothing in the contract exposes
/// how many questions a student has used or what their cap is — the 403 is the
/// only signal, and it arrives without numbers. Drawing a bar would mean
/// fabricating both ends of it, exactly as with the setup screen's pool card
/// (docs/seif_fight.md S15).
class LimitSheet extends StatelessWidget {
  const LimitSheet({super.key, required this.code});

  /// `weekly_question_limit_reached` or `subscription_required`.
  final String code;

  /// Shows the sheet for [error]. Dismissible — the student must be able to
  /// get back to what they were doing, and there is nothing else to do here.
  static Future<void> show(BuildContext context, ApiException error) {
    // `Rectangle 6427` in the light Limitation frame: 50% #313131 over a page
    // blurred at sigma 5.75.
    //
    // **The dark scrim is BLOCKED, not absent.** No dark Limitation frame
    // exists in the file, so `limitSheetScrim` is null on that canvas and the
    // sheet keeps the framework's default barrier there — a gap recorded in
    // docs/DESIGN_ISSUES.md, not a design decision.
    return showAppModalSheet<void>(
      context: context,
      scrim: Theme.of(context).extension<AppElevation>()!.limitSheetScrim,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => LimitSheet(code: error.code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    final isSubscription = code == 'subscription_required';
    final title = isSubscription
        ? l10n.subscriptionRequiredTitle
        : l10n.freeUsageReachedTitle;
    final body = isSubscription
        ? l10n.subscriptionRequiredBody
        : l10n.weeklyLimitBody;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.h2.copyWith(color: ext.quizWrongBorder),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
            ),
            const SizedBox(height: 20),
            // No CTA. The frames draw "Upgrade To Premium" over a benefits
            // list; adr-049 §3 forbids both. Dismissal is the only action.
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.notNow),
            ),
          ],
        ),
      ),
    );
  }
}
