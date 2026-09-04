import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../models/quiz_summary.dart';
import 'quiz_screen.dart' show QuizResultArgs;

/// `/quiz/:quizId/result` · Figma `159:1964` (school) / `309:6375` (university).
///
/// Renders [QuizSummary] and nothing else. Every number on this screen came
/// from `POST /quizzes/{quizId}/finish`; the only arithmetic is bucket
/// derivation the contract explicitly enables (`wrong` and `skipped`) and the
/// ring's fraction, which cannot be drawn without dividing two server integers.
///
/// **Four things the frame draws are deliberately different:**
/// - **No "Pass".** The ring reads `50%` and the frame writes `Pass` under it.
///   There is no pass threshold anywhere in the contract, so the word is
///   omitted rather than guessed. seif_fight S13.
/// - **A third Skipped figure**, when `answeredCount < totalQuestions`. The
///   frame has two buckets and nowhere to put unanswered questions, which the
///   contract records as unanswered — *not* wrong.
/// - **"Review Questions" is disabled.** Reviewing needs
///   `GET /quizzes/{quizId}`, the only endpoint that returns correct answers
///   for a finished quiz, and it is `x-stability: draft`. seif_fight S14.
/// - **No level number or points total.** Contract 3.0.0-m1 (adr-102) removed
///   `totalPoints` and `level` from the summary — they are state, read from
///   `GET /me` — and the frames draw a partial-fill meter rather than numbers.
///   The line the app used to draw here is removed by owner ruling (D-006);
///   the meter itself is with the designer (DESIGN_ISSUES #50).
///
/// `leveledUp` and `newBadge` are parsed and not celebrated: the frame has no
/// level-up or badge state to render. Flagged in docs/DESIGN_ISSUES.md.
class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key, required this.args});

  final QuizResultArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);
    final summary = args.summary;

    return PopScope(
      // The quiz behind this screen is finished and cannot be re-entered. Back
      // goes to Learn, never into a closed session.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _leave(context),
          ),
          title: Text(l10n.quizCompleteTitle),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  // Scope only. `QuizSummary` carries no subject and no scope;
                  // this rode in from the `Quiz` the session was built from.
                  args.scopeName,
                  textAlign: TextAlign.center,
                  style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
                ),
                const SizedBox(height: 24),
                _PercentageRing(summary: summary),
                const SizedBox(height: 24),

                // Two buckets, or three when the student finished early.
                Row(
                  children: [
                    Expanded(
                      child: _ScoreCard(
                        icon: Icons.check,
                        badgeColor: ext.successBadge,
                        value: summary.score,
                        label: l10n.resultCorrect,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ScoreCard(
                        icon: Icons.close,
                        badgeColor: ext.quizWrongBadge,
                        // answeredCount - score. NOT totalQuestions - score:
                        // questions the student never reached are skipped, and
                        // calling them mistakes would be a lie.
                        value: summary.wrong,
                        label: l10n.resultWrong,
                      ),
                    ),
                    if (summary.skipped > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ScoreCard(
                          icon: Icons.remove,
                          badgeColor: ext.mutedText,
                          value: summary.skipped,
                          label: l10n.resultSkipped,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 24),
                _RewardsCard(summary: summary),
                const SizedBox(height: 24),

                Tooltip(
                  message: l10n.reviewQuestionsComingSoon,
                  child: FilledButton(
                    // Rendered so the screen matches the frame, disabled
                    // because the endpoint behind it is draft. Zero rework when
                    // it is promoted — this becomes an onPressed.
                    onPressed: null,
                    child: Text(l10n.reviewQuestions),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.reviewQuestionsComingSoon,
                  textAlign: TextAlign.center,
                  style: AppType.captionRegular.copyWith(color: ext.mutedText),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _leave(context),
                  child: Text(l10n.backToLearn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// `go`, not `pop`: the setup screen and the finished quiz are both still on
  /// the stack, and neither is somewhere a student should land after finishing.
  void _leave(BuildContext context) => context.go('/learn');
}

/// The percentage ring · Figma `159:1975`. Score over total, no verdict.
class _PercentageRing extends StatelessWidget {
  const _PercentageRing({required this.summary});

  final QuizSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;

    return Center(
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: summary.fraction,
                strokeWidth: 12,
                backgroundColor: ext.progressTrack,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ),
            Text(
              // Latin digits in Arabic too, consistent with every other number
              // in the app (the Home counters, the catalog's `{answered} /
              // {total}`). Arabic-Indic digits are a project-wide migration
              // tracked as docs/DESIGN_ISSUES.md #19 — doing it for this one
              // string would make the result screen inconsistent with itself.
              '${(summary.fraction * 100).round()}%',
              style: AppType.displayLarge.copyWith(color: ext.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/// One bucket · Figma `159:1990` / `159:2005`.
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.icon,
    required this.badgeColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color badgeColor;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: ext.quizOptionFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.quizOptionBorder, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 8),
          Text('$value', style: AppType.h2.copyWith(color: badgeColor)),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppType.labelLarge.copyWith(color: ext.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// REWARDS EARNED · Figma `159:2020`.
class _RewardsCard extends StatelessWidget {
  const _RewardsCard({required this.summary});

  final QuizSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: ext.quizOptionFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.quizOptionBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rewardsEarned,
            style: AppType.captionRegular.copyWith(
              color: ext.quizExplanationBody,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.star, size: 22, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                // Verbatim from the server. The app has no points formula and
                // must never appear to: the design's "+200" is roughly 20x what
                // the contract can award. seif_fight S12.
                l10n.pointsAwarded(summary.pointsAwarded),
                style: AppType.h2.copyWith(color: theme.colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
