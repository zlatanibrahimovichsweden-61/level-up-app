import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// How one option is currently being presented.
///
/// Exhaustive and without a `default:` anywhere it is switched on, so a fifth
/// presentation cannot be added without every site being made to decide.
enum OptionTileState {
  /// Untouched — and also what a non-chosen, non-correct option looks like
  /// after grading. The frame draws those identically (`308:5153`).
  idle,

  /// Chosen but NOT sent. **This state is not in the Figma frame** — the design
  /// only draws idle, correct and incorrect — so it is Material's selection
  /// convention expressed in existing tokens (the primary accent), not an
  /// invented palette. Flagged in docs/DESIGN_ISSUES.md.
  selected,

  /// The correct answer, revealed by `AnswerResult.correctOptionId`. Shown on
  /// every graded question, whether or not the student picked it.
  correct,

  /// The student's own wrong choice.
  incorrect,
}

/// One answer row · Figma `308:5153` (idle) · `308:5158` (wrong) ·
/// `308:5166` (correct).
///
/// Every colour comes from [AppColors]; the correct/wrong tokens are identical
/// in light and dark on purpose, because a correctness signal must not flip
/// with the theme.
class QuestionOptionTile extends StatelessWidget {
  const QuestionOptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
  });

  /// Positional A/B/C/D, derived from the option's index at render time — the
  /// contract sends no letter, and deriving it keeps the badge correct in RTL
  /// without the server knowing about presentation.
  final String letter;

  final String text;
  final OptionTileState state;

  /// Null makes the row inert — a graded question, or a submit in flight.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    final (fill, border, borderWidth) = switch (state) {
      OptionTileState.idle => (ext.quizOptionFill, ext.quizOptionBorder, 0.5),
      OptionTileState.selected => (
        ext.quizOptionFill,
        theme.colorScheme.primary,
        1.5,
      ),
      OptionTileState.correct => (
        ext.quizCorrectFill,
        ext.quizCorrectBorder,
        1.0,
      ),
      OptionTileState.incorrect => (
        ext.quizWrongFill,
        ext.quizWrongBorder,
        1.0,
      ),
    };

    // Announced to screen readers so a blind student learns the outcome the
    // colours convey. Silent while ungraded — there is nothing to report yet.
    final semantics = switch (state) {
      OptionTileState.idle || OptionTileState.selected => null,
      OptionTileState.correct => l10n.answerCorrect,
      OptionTileState.incorrect => l10n.answerWrong,
    };

    return Semantics(
      button: onTap != null,
      selected: state != OptionTileState.idle,
      value: semantics,
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: borderWidth),
            ),
            child: Padding(
              // Directional throughout: in RTL the badge sits on the right and
              // the label runs from it, with no mirrored copy of this widget.
              padding: const EdgeInsetsDirectional.all(16.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Badge(letter: letter, state: state),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: AppType.h3.copyWith(color: ext.textPrimary),
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

/// The 28px leading circle: a letter while ungraded, a state icon once graded.
///
/// That swap is what the Figma `Icon` nodes (`308:5160` / `308:5168`) are,
/// versus the letter `text` nodes (`308:5155` / `308:5176`).
class _Badge extends StatelessWidget {
  const _Badge({required this.letter, required this.state});

  final String letter;
  final OptionTileState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;

    final (fill, border, icon) = switch (state) {
      OptionTileState.idle => (null, ext.quizOptionBorder, null),
      OptionTileState.selected => (
        theme.colorScheme.primary,
        theme.colorScheme.primary,
        null,
      ),
      OptionTileState.correct => (
        ext.successBadge,
        ext.successBadge,
        Icons.check,
      ),
      OptionTileState.incorrect => (
        ext.quizWrongBadge,
        ext.quizWrongBadge,
        Icons.close,
      ),
    };

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1.18),
      ),
      child: icon != null
          ? Icon(icon, size: 14, color: theme.colorScheme.onPrimary)
          : Text(
              letter,
              style: AppType.labelMedium.copyWith(
                color: state == OptionTileState.selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
    );
  }
}
