import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../models/answer_result.dart';
import '../models/quiz_question.dart';
import '../models/quiz_review_args.dart';
import 'screen_protection.dart';

/// `/quiz/:quizId/result/review` · Figma `162:2377` (light) · `337:6705` (dark)
/// · `549:20324` (RTL).
///
/// **Consumes no endpoint.** Every value on this screen was already in hand
/// when `POST /quizzes/{quizId}/finish` returned: the questions and a grade per
/// committed question, carried forward from the session in [QuizReviewArgs].
/// Historical review — reaching this screen for any quiz but the one just
/// finished — needs `GET /quizzes/{quizId}`, which is `x-stability: draft`
/// (`openapi.yaml:1010`). See docs/seif_fight.md S14.
///
/// **Four states, and why three of them do not exist here.** Nothing is
/// fetched, so there is no loading, no error and no offline state to render —
/// the data arrived with the route. Only Empty is reachable, when a filter
/// selects no rows. This is stated rather than silently skipped, per the
/// `screen-states` skill.
///
/// **The frame draws no options and no answer text.** A row is question text
/// plus a right/wrong mark, so the student's own pick is never shown and is not
/// carried into [QuizReviewArgs]. `QuestionOptionTile` is deliberately not
/// reused: four fifths of it would be hidden.
///
/// Screenshot protection is wired here, not inherited. `QuizScreen` turns it
/// off in its own `dispose`, and the result screen between the two is
/// stateless — so without this the one screen that lists correct answers would
/// be the one screen a student could screenshot.
class QuizReviewScreen extends ConsumerStatefulWidget {
  const QuizReviewScreen({required this.args, super.key});

  final QuizReviewArgs args;

  @override
  ConsumerState<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

/// Which rows the filter row is showing. Ephemeral, local, and lost on pop —
/// so `setState`, not a notifier (`build-screen` Step 2).
enum _ReviewFilter { all, correct, wrong }

class _QuizReviewScreenState extends ConsumerState<QuizReviewScreen> {
  late final ScreenProtection _protection;
  _ReviewFilter _filter = _ReviewFilter.all;

  @override
  void initState() {
    super.initState();
    // Read (not watch) and hold the instance, exactly as QuizScreen does:
    // dispose must be able to turn protection off even if the provider
    // container is already tearing down.
    _protection = ref.read(screenProtectionProvider);
    _protection.enable();
  }

  @override
  void dispose() {
    _protection.disable();
    super.dispose();
  }

  /// A question with no entry in `grades` was never committed. That is the
  /// skipped state; the frame has no design for it (docs/DESIGN_ISSUES.md #55).
  bool _matches(QuizQuestion question) {
    final grade = widget.args.grades[question.id];
    return switch (_filter) {
      _ReviewFilter.all => true,
      _ReviewFilter.correct => grade?.correct ?? false,
      // Skipped is NOT wrong. The result screen's own three-bucket model
      // (correct / wrong / skipped) is the one this follows.
      _ReviewFilter.wrong => grade != null && !grade.correct,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questions = widget.args.questions;

    // The index is the row's "QUESTION n", so it must be the position in the
    // WHOLE quiz — filtering must not renumber the rows.
    final rows = <(int, QuizQuestion)>[
      for (var i = 0; i < questions.length; i++)
        if (_matches(questions[i])) (i + 1, questions[i]),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // `Icons.arrow_back` carries `matchTextDirection: true`, so it mirrors
        // itself in Arabic. (`Icons.arrow_back_ios_new` does not, which is why
        // catalog_scaffold.dart needs a helper and this does not.)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.quizReviewTitle),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FilterRow(
              selected: _filter,
              // Count on "All" only. The frame gives "Correct" and "Wrong" a
              // leading glyph and a bare label — do not invent counts for them.
              total: questions.length,
              onChanged: (filter) => setState(() => _filter = filter),
            ),
            Expanded(
              child: rows.isEmpty
                  ? _EmptyState(message: l10n.quizReviewEmpty)
                  : ListView.separated(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        4,
                        20,
                        24,
                      ),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final (number, question) = rows[index];
                        return _ReviewRow(
                          number: number,
                          question: question,
                          grade: widget.args.grades[question.id],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `162:2780` / `337:6825`. Three chips: `All (n)` · `Correct` · `Wrong`.
///
/// Partitioning is pure client-side filtering of data already in hand — no
/// request, no server round trip, nothing recomputed.
class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.total,
    required this.onChanged,
  });

  final _ReviewFilter selected;
  final int total;
  final ValueChanged<_ReviewFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
      child: Row(
        children: [
          _FilterChip(
            label: l10n.quizReviewFilterAll(total),
            selected: selected == _ReviewFilter.all,
            onTap: () => onChanged(_ReviewFilter.all),
          ),
          const SizedBox(width: 10),
          // `resultCorrect` / `resultWrong` rather than new keys: the result
          // screen one push back already labels these two buckets with exactly
          // these words, in both languages, human-written. A second pair would
          // be the same string translated twice.
          _FilterChip(
            label: l10n.resultCorrect,
            glyphColor: ext.successBadge,
            selected: selected == _ReviewFilter.correct,
            onTap: () => onChanged(_ReviewFilter.correct),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: l10n.resultWrong,
            glyphColor: ext.quizWrongBadge,
            glyph: Icons.close,
            selected: selected == _ReviewFilter.wrong,
            onTap: () => onChanged(_ReviewFilter.wrong),
          ),
        ],
      ),
    );
  }
}

/// Hug × 32, stadium, padding 6/12. Selected fills with
/// [AppColors.quizReviewFilterFill]; unselected is the raised cream surface
/// with the file's elevation shadow, per `162:2780`.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.glyphColor,
    this.glyph,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Set on "Correct" and "Wrong" only — a leading dot, or a ✕ for wrong.
  final Color? glyphColor;
  final IconData? glyph;

  /// The pill's drawn height (`162:2780`). It is a MINIMUM, not a fixed box:
  /// a 14px label in a 20px content box clips its own glyphs from text scale
  /// 1.15, and silently — the overflow is on a Row's cross axis, which
  /// RenderFlex does not report.
  static const _height = 32.0;

  /// The pill stays 32 tall; the TOUCH target does not. Material and both
  /// platforms' a11y guidance floor a tap target at 48/44dp.
  static const _tapTarget = 48.0;

  static const _glyph = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;

    return Semantics(
      button: true,
      selected: selected,
      child: SizedBox(
        height: _tapTarget,
        child: Center(
          child: Material(
            color: selected ? ext.quizReviewFilterFill : ext.quizOptionFill,
            shape: const StadiumBorder(),
            elevation: selected ? 0 : 2,
            shadowColor: ext.elevationShadow,
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onTap,
              child: Container(
                constraints: const BoxConstraints(minHeight: _height),
                padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (glyphColor != null) ...[
                      glyph == null
                          ? Container(
                              width: _glyph,
                              height: _glyph,
                              decoration: BoxDecoration(
                                color: glyphColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Icon(glyph, size: _glyph + 4, color: glyphColor),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      label,
                      style: AppType.labelLarge.copyWith(
                        // NOT `onPrimary`: it is #FCFBF9 in both themes, which is
                        // right on the light chip (5.97:1) and wrong on the dark
                        // chip's purple (2.74:1). See the token's field doc.
                        color: selected
                            ? ext.quizReviewFilterLabel
                            : ext.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One question, `162:2502` (correct) / `162:2563` (wrong): 73 tall, radius 16,
/// 0.5px border.
///
/// The three fills come straight from the shipped quiz-page tokens. The review
/// frame draws a fourth pair for the wrong row (`#FDE9E8` / `#921019`, opaque)
/// that differs from the shipped pair by one hex digit and by opacity; that
/// reads as drift, and the owner chose the shipped values. See
/// docs/DESIGN_ISSUES.md #52.
class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.number,
    required this.question,
    required this.grade,
  });

  final int number;
  final QuizQuestion question;

  /// Null means the question was never committed — the skipped state.
  final AnswerResult? grade;

  static const _height = 73.0;
  static const _circle = 28.0;
  static const _aiGlyph = 26.55;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;

    // `content` is per-state because the FILLS behave differently, and a
    // foreground has to follow the fill it sits on:
    //   - quizCorrectFill is opaque #BFFFC3 in BOTH canvases, so its foreground
    //     must also be fixed. A flipping one puts cream on mint in dark —
    //     measured 1.11:1, i.e. invisible.
    //   - quizWrongFill (30% alpha) and quizOptionFill DO follow the canvas, so
    //     theirs is textPrimary, which follows with them (6.94:1 dark).
    final (
      fill,
      border,
      badge,
      mark,
      content,
      semantic,
    ) = switch (grade?.correct) {
      true => (
        ext.quizCorrectFill,
        ext.quizCorrectBorder,
        ext.successBadge,
        Icons.check,
        ext.quizReviewRowContent,
        l10n.resultCorrect,
      ),
      false => (
        ext.quizWrongFill,
        ext.quizWrongBorder,
        ext.quizWrongBadge,
        Icons.close,
        ext.textPrimary,
        l10n.resultWrong,
      ),
      // Skipped. The frame has no state for this, so it takes the neutral
      // ungraded surface and shows no ✓/✕ at all rather than guessing at a
      // third signal colour. TODO(design): docs/DESIGN_ISSUES.md #55.
      null => (
        ext.quizOptionFill,
        ext.quizOptionBorder,
        null,
        null,
        ext.textPrimary,
        l10n.resultSkipped,
      ),
    };

    // Wrong rows only, per the frame — AND only where the server actually has
    // an explanation. `explanationAvailable` is the contract's own gate
    // (`AnswerResult`), so drawing the glyph on every wrong row would promise a
    // thing the backend may not have. Non-interactive this day: no destination
    // frame exists for a tap. docs/DESIGN_ISSUES.md #56.
    final showAi =
        grade != null && !grade!.correct && grade!.explanationAvailable;

    return Semantics(
      label: semantic,
      child: Container(
        // A MINIMUM, not a fixed height. At 73 the two lines have 13px of
        // slack, which text scale 1.35 exhausts — one RenderFlex overflow per
        // row, and Android's largest standard font setting is already 1.30.
        constraints: const BoxConstraints(minHeight: _height),
        padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: _circle,
              height: _circle,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: badge,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 1.18),
              ),
              child: mark == null
                  ? null
                  : Icon(mark, size: 14, color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quizReviewQuestionLabel(number),
                    // Same `content` as the question: textSecondary is #DCDCDC
                    // in dark, which on the correct row's mint measures 1.20:1.
                    // Hierarchy here comes from size and weight, not colour —
                    // the frame specifies no colour for this label.
                    style: AppType.captionRegular.copyWith(color: content),
                  ),
                  Text(
                    question.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.h3.copyWith(color: content),
                  ),
                ],
              ),
            ),
            if (showAi) ...[
              const SizedBox(width: 8),
              Semantics(
                label: l10n.quizReviewAiAvailable,
                child: SvgPicture.asset(
                  'assets/icons/ai_education.svg',
                  width: _aiGlyph,
                  height: _aiGlyph,
                  // The glyph's viewBox is 27×25, not square — box it and it
                  // stretches. Same reason main_shell.dart does this.
                  fit: BoxFit.contain,
                  // The outer Semantics already labels it; without this the
                  // SvgPicture's own image semantics merge upward and the whole
                  // row is announced as an image.
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(content, BlendMode.srcIn),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The only reachable non-content state: a filter that selects no rows.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppType.bodyLarge.copyWith(color: ext.mutedText),
        ),
      ),
    );
  }
}
