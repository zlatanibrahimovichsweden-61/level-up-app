import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'question_option_tile.dart';
import 'question_renderer.dart';

/// A/B/C/D, positional. Latin in both languages — the standard MCQ convention,
/// and the frame's own choice; the RTL layout puts the badge at the start edge
/// rather than translating the letters.
const _letters = ['A', 'B', 'C', 'D'];

/// The MCQ question renderer · Figma `308:5180` (question card) ·
/// `308:5152` (options) · `159:1852` (the photo variant).
///
/// The ONLY [QuestionRenderer] that exists. It renders the question card, the
/// optional image, and one [QuestionOptionTile] per option; the shell around it
/// renders everything else.
class McqRenderer extends QuestionRenderer {
  const McqRenderer();

  @override
  Widget build(BuildContext context, QuestionPresentation presentation) =>
      _McqBody(presentation: presentation);
}

class _McqBody extends StatelessWidget {
  const _McqBody({required this.presentation});

  final QuestionPresentation presentation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);
    final question = presentation.question;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Question card — 308:5180.
        Container(
          padding: const EdgeInsetsDirectional.all(20.5),
          decoration: BoxDecoration(
            color: ext.quizOptionFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ext.quizOptionBorder, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.questionLabel(presentation.position),
                style: TextStyle(
                  fontSize: 12,
                  height: 18 / 12,
                  color: ext.quizExplanationBody,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                // The contract allows `<u>…</u>` and nothing else in this
                // field. Rendered as plain text for now: no underline parser
                // exists yet, and stripping or misparsing markup would be worse
                // than showing the tags the server actually sent.
                question.text,
                style: TextStyle(
                  fontSize: 18,
                  height: 26 / 18,
                  fontWeight: FontWeight.w600,
                  color: ext.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // The "with photo" variant — same screen, an image block between the
        // question and the options. Only drawn when the server sent one.
        if (question.imageUrl case final imageUrl?) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              // A question is readable without its illustration, so a failed
              // image degrades to a placeholder instead of blocking the answer.
              placeholder: (_, _) => Container(
                height: 180,
                color: ext.quizOptionFill,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (_, _, _) => Container(
                height: 180,
                color: ext.quizOptionFill,
                alignment: Alignment.center,
                child: Icon(Icons.image_not_supported_outlined,
                    color: ext.mutedText),
              ),
              imageBuilder: (context, provider) => Semantics(
                label: l10n.questionImage,
                image: true,
                child: Image(image: provider, fit: BoxFit.cover),
              ),
            ),
          ),
        ],

        const SizedBox(height: 25),

        // Built from the options the server sent — `minItems: 2`, NOT a fixed
        // four. A three-option question renders three tiles.
        for (final (index, option) in question.options.indexed) ...[
          if (index > 0) const SizedBox(height: 12),
          QuestionOptionTile(
            letter: index < _letters.length
                ? _letters[index]
                : '${index + 1}',
            text: option.text,
            state: _stateFor(option.id),
            onTap: presentation.isInteractive
                ? () => presentation.onSelect(option.id)
                : null,
          ),
        ],
      ],
    );
  }

  /// Ungraded: only the uncommitted selection is highlighted.
  ///
  /// Graded: the correct option is always revealed, and the student's own
  /// choice is marked wrong if it was. Everything else stays neutral — which is
  /// exactly what the frame draws.
  OptionTileState _stateFor(String optionId) {
    final grade = presentation.grade;
    if (grade == null) {
      return presentation.selectedOptionId == optionId
          ? OptionTileState.selected
          : OptionTileState.idle;
    }
    if (optionId == grade.correctOptionId) return OptionTileState.correct;
    if (optionId == presentation.committedOptionId) {
      return OptionTileState.incorrect;
    }
    return OptionTileState.idle;
  }
}
