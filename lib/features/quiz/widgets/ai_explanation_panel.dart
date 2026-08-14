import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/explanation_state.dart';

/// The AI EXPLANATION panel · Figma `159:1811`.
///
/// **One section, not two.** The frame draws two labelled bodies — "WHY IS THIS
/// WRONG?" and "WHY IS THE CORRECT ANSWER RIGHT?" — but
/// `GET /questions/{questionId}/explanation` returns a single `text` string
/// (`openapi.yaml:914`–`919`, required `[status, text]`). There is no second
/// field and no delimiter, so splitting one string across two headings would
/// mean inventing a response format GPT-4o-mini never promised to produce.
/// Owner decision: render the text verbatim under the shared header and omit
/// both sub-headings. Logged as docs/seif_fight.md S17 — when Seif splits the
/// field, this becomes two of the same card.
///
/// Never renders as a failure. An explanation is an extra; a student who cannot
/// get one still has a working quiz, so [ExplanationFailed] — including the
/// contract's own expected `403` before answering — reads as "not available".
class AiExplanationPanel extends StatelessWidget {
  const AiExplanationPanel({
    super.key,
    required this.state,
    required this.onRequest,
  });

  final ExplanationState state;

  /// Fetch on demand — the contract generates once and caches, so nothing is
  /// requested until the student asks for it.
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(16.679),
      decoration: BoxDecoration(
        color: ext.quizOptionFill,
        borderRadius: BorderRadius.circular(16.179),
        border: Border.all(color: ext.quizOptionBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 26.55,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8.089),
              Expanded(
                child: Text(
                  l10n.aiExplanation,
                  style: TextStyle(
                    fontSize: 13.145,
                    height: 19.718 / 13.145,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.134),
          switch (state) {
            // Collapsed until asked — exhaustive, no `default:`.
            ExplanationIdle() => Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: onRequest,
                child: Text(l10n.showExplanation),
              ),
            ),
            ExplanationPending() => _Body(
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.explanationGenerating,
                      style: _bodyStyle(ext),
                    ),
                  ),
                ],
              ),
            ),
            ExplanationLoaded(:final text) => _Body(
              child: Text(text, style: _bodyStyle(ext)),
            ),
            ExplanationFailed() => _Body(
              child: Text(l10n.explanationUnavailable, style: _bodyStyle(ext)),
            ),
          },
        ],
      ),
    );
  }

  TextStyle _bodyStyle(AppColors ext) => TextStyle(
    fontSize: 13.145,
    height: 21.033 / 13.145,
    color: ext.quizExplanationBody,
  );
}

/// The inner card the frame draws around each explanation body (`159:1826`).
class _Body extends StatelessWidget {
  const _Body({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(12.134),
      decoration: BoxDecoration(
        color: ext.quizOptionFill,
        borderRadius: BorderRadius.circular(20.224),
        boxShadow: [
          // Figma `drop-shadow(0.02px 0.02px 1.5px rgba(0,0,0,0.25))`. The
          // DEPTH is this component's and stays here; the shadow's colour is
          // the canvas's and comes from the palette, because a black shadow
          // does not exist on a `#232428` page.
          BoxShadow(
            color: ext.elevationShadow.withValues(alpha: 0.25),
            blurRadius: 1.5,
            offset: const Offset(0.02, 0.02),
          ),
        ],
      ),
      child: child,
    );
  }
}
