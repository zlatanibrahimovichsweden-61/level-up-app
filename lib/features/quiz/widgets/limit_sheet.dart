import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// The free-plan paywall sheet · Figma `199:2335` (school) ·
/// `225:6634` / `225:7001` (university).
///
/// Opened by the two 403s on `POST /quizzes` that are not inline errors:
/// `weekly_question_limit_reached` and `subscription_required`. Same sheet,
/// different heading and body.
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

  /// Shows the sheet for [error]. Dismissible — a student who is not going to
  /// pay right now must be able to get back to what they were doing.
  static Future<void> show(BuildContext context, ApiException error) {
    return showModalBottomSheet<void>(
      context: context,
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
            Container(
              padding: const EdgeInsetsDirectional.all(16),
              decoration: BoxDecoration(
                color: ext.quizOptionFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ext.quizOptionBorder, width: 0.5),
              ),
              child: Column(
                children: [
                  for (final benefit in [
                    l10n.benefitUnlimitedQuestions,
                    l10n.benefitAiExplanations,
                    l10n.benefitPrioritySupport,
                    l10n.benefitNoAds,
                  ])
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 22,
                            color: ext.successBadge,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              benefit,
                              style: AppType.labelLarge.copyWith(
                                color: ext.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              // Hands off to the existing /subscription placeholder and stops
              // there. Day 7 builds no purchase flow — Paymob is its own day,
              // and the app never confirms a payment in any case.
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/subscription');
              },
              child: Text(l10n.upgradeCta),
            ),
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
