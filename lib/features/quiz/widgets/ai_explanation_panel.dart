import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
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
///
/// Two of those failures carry a "try again" beside that line, and only two:
/// see [ExplanationFailed.isRetryable] for which, and why the list is an
/// allowlist rather than an exclusion.
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
    final elevation = theme.extension<AppElevation>()!;
    final l10n = AppLocalizations.of(context);

    final outerBorder = ext.aiPanelOuterBorder;
    final backlight = elevation.aiPanelBacklight;

    return ElevatedSurface(
      width: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.179),
      ),
      padding: const EdgeInsetsDirectional.all(16.679),
      color: ext.aiPanelOuterFill,
      // Light `159:1811` outlines the panel; dark `337:9270` does NOT, and
      // the token is null there to say so. A null border is a reading.
      side: outerBorder == null
          ? null
          : BorderSide(color: outerBorder, width: 0.5),
      // G18 - the frostiest Glass in the file, which is what makes the
      // lavender ellipse behind the header glyph read as a haze rather than
      // as a shape.
      glass: elevation.aiPanelGlass,
      backlights: [?backlight],
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
                  style: AppType.h4.copyWith(color: theme.colorScheme.primary),
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
            // The copy is the same either way — an explanation is an extra, and
            // losing one must never read as a broken quiz. What changes is
            // whether there is anything to tap: the contract's failure UX for
            // the poll cap IS a "try again", and a `429` recovers on its own
            // after the window. Every other code is terminal for this question,
            // including `account_pending_deletion`, which must never show one.
            ExplanationFailed(:final isRetryable) => _Body(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.explanationUnavailable,
                      style: _bodyStyle(ext),
                    ),
                  ),
                  if (isRetryable)
                    TextButton(
                      key: const Key('explanation_retry'),
                      onPressed: onRequest,
                      child: Text(l10n.retry),
                    ),
                ],
              ),
            ),
          },
        ],
      ),
    );
  }

  TextStyle _bodyStyle(AppColors ext) =>
      AppType.bodyMedium.copyWith(color: ext.quizExplanationBody);
}

/// The inner card the frame draws around each explanation body (`159:1826`).
///
/// **Its shadow is not its own.** Figma hangs a `drop-shadow` filter on the
/// wrapper `159:1825` / `337:9278` that groups the inner cards, so what the
/// eye reads as each card's shadow is the wrapper's, seen around each card's
/// outline. Drawn here as the card's own, knocked out behind the fill (R4) -
/// which matters, because in dark that fill is only 20% opaque and an
/// unclipped shadow would show straight through it.
///
/// Two numbers in the old comment here were wrong and are worth naming. The
/// blur is **3**, not 1.5 - the wrapper's, not a guess at the card's. And the
/// colour is black on both canvases: the cream `elevationShadow` came from
/// "a black shadow does not exist on a dark page", a derivation the thirteen
/// dark frames refuted (DESIGN_ISSUES #47 superseded, D-009).
class _Body extends StatelessWidget {
  const _Body({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return ElevatedSurface(
      width: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.224),
      ),
      padding: const EdgeInsetsDirectional.all(12.134),
      color: ext.aiPanelCardFill,
      shadows: elevation.aiPanelCardShadows,
      glass: elevation.aiPanelCardGlass,
      child: child,
    );
  }
}
