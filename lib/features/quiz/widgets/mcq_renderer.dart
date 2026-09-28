import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import 'question_option_tile.dart';
import 'question_renderer.dart';
import 'question_stem_text.dart';

/// A/B/C/D, positional. Latin in both languages — the standard MCQ convention,
/// and the frame's own choice; the RTL layout puts the badge at the start edge
/// rather than translating the letters.
const _letters = ['A', 'B', 'C', 'D'];

/// The MCQ question renderer · Figma `308:5180` (question card) ·
/// `308:5152` (options) · `216:2973` / `159:1852` (the photo variant).
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
    final elevation = theme.extension<AppElevation>()!;
    final l10n = AppLocalizations.of(context);
    final question = presentation.question;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The "with photo" variant (`216:3012`): the image comes FIRST, 22
        // over the question card. It used to sit between the card and the
        // options (API→UI Wave 12). Only drawn when the server sent one.
        if (question.imageUrl case final imageUrl?) ...[
          Container(
            key: const Key('quiz_question_image'),
            // `216:3013`: radius 17 and 0.5 of #4B675E, the question card's
            // own hairline, so it takes the card's tokens. There is no dark
            // photo frame, so dark carries the card's dark hairline too.
            // Painted OVER the picture, so the image cannot cover it.
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: ext.quizQuestionCardBorder,
                width: elevation.quizQuestionCardBorderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                // A question is readable without its illustration, so a
                // failed image degrades to a placeholder instead of blocking
                // the answer. Both hold the frame's 189 dp box.
                placeholder: (_, _) => Container(
                  height: 189,
                  color: ext.quizOptionFill,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (_, _, _) => Container(
                  height: 189,
                  color: ext.quizOptionFill,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: ext.mutedText,
                  ),
                ),
                // The WHOLE image at the card's width, at its own shape: owner
                // ruling 2026-09-26. The frame crops its sample into a fixed
                // 360 x 189 box; a real question's diagram would lose labels
                // that way.
                imageBuilder: (context, provider) => Semantics(
                  label: l10n.questionImage,
                  image: true,
                  child: Image(image: provider, fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
        ],

        // Question card — 308:5180. Flat in both canvases: no shadow and no
        // Glass in either frame, only a hairline, and the hairline is the one
        // thing that differs. Light `308:5180` draws 0.5 of the green
        // `#4B675E`; dark `337:6434` draws **0.2** of lavender at 60% - the
        // thinnest stroke anywhere in the design, which is why its width is a
        // token rather than the 0.5 every other hairline uses.
        Container(
          key: const Key('quiz_question_card'),
          padding: const EdgeInsetsDirectional.all(20.5),
          decoration: BoxDecoration(
            color: ext.quizOptionFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ext.quizQuestionCardBorder,
              width: elevation.quizQuestionCardBorderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.questionLabel(presentation.position),
                style: AppType.captionRegular.copyWith(
                  color: ext.quizExplanationBody,
                ),
              ),
              // `159:1254`: 10 between the label and the question.
              const SizedBox(height: 10),
              // The contract allows `<u>…</u>` and nothing else in this field
              // (`openapi.yaml:2703`); the widget draws it as an underline and
              // sets the stem's own direction (API→UI Wave 14).
              QuestionStemText(
                question.text,
                style: AppType.h3.copyWith(color: ext.quizQuestionText),
              ),
            ],
          ),
        ),

        // `159:1260` sits 22 under the card (`216:3012`'s gap, too).
        const SizedBox(height: 22),

        // Built from the options the server sent — `minItems: 2`, NOT a fixed
        // four. A three-option question renders three tiles.
        for (final (index, option) in question.options.indexed) ...[
          if (index > 0) const SizedBox(height: 12),
          QuestionOptionTile(
            letter: index < _letters.length ? _letters[index] : '${index + 1}',
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
