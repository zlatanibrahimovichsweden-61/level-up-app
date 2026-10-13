import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/answer_result.dart';
import '../models/quiz_question.dart';
import '../models/quiz_review_args.dart';
import '../widgets/question_stem_text.dart';
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

  /// `162:2787` → `162:2511`: the pills end 14.18 above the first row. The
  /// filter row already spends 8 of it, the 48 tap target's slack under a 32
  /// pill.
  static const _pillsToRows = 14.18 - (_FilterChip._tapTarget - 32) / 2;

  /// `162:2511`'s `gap-[19px]`.
  static const _rowGap = 19.0;

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              title: l10n.quizReviewTitle,
              // `maybePop`, as the shared title bar did. There is no
              // `PopScope` on this screen, so it is the same as `pop` today and
              // keeps behaving if one is ever added.
              onBack: () => Navigator.of(context).maybePop(),
            ),
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
                        _pillsToRows,
                        20,
                        24,
                      ),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: _rowGap),
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

/// `162:2405` / `337:6817`: 63 tall with a 1.18 rule, the 35 chip 21 in and
/// centred on the bar, "Quiz Review" centred over the whole width.
///
/// Its own bar, not the shared `TitledChrome` it used to be: that one is 59
/// tall with no rule and is shared with Settings and the Account shells, whose
/// frames were not re-read here (API→UI Wave 14). The quiz page and the result
/// build their bars the same way.
class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  static const _height = 63.0;
  static const _rule = 1.18;
  static const _start = 21.0;
  static const _chip = 35.0;

  /// The chip's row is centred 0.59 below the bar's middle: 31.5 + 0.59 −
  /// 17.5 = 14.59 from the top.
  static const _top = _height / 2 + 0.59 - _chip / 2;

  /// Clear of the chip on BOTH sides, so the title stays centred.
  static const _inset = _chip + 8;

  /// The chip's padded 48 box reaches this far past it on every side (O-15).
  /// The bar's insets give it back, its floor grows to the box and the
  /// title's inset takes it, so the chip and the title keep their pixels.
  static const _slop = CircleBackButton.tapSlop;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      key: const Key('quiz_review_header'),
      // Container adds the rule's width to its padding, so the bottom padding
      // is what is left of the frame's 63.
      padding: const EdgeInsetsDirectional.fromSTEB(
        _start - _slop,
        _top - _slop,
        _start - _slop,
        _height - _top - _chip - _rule - _slop,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ext.quizHeaderRule, width: _rule),
        ),
      ),
      // A floor, not a height: a larger text scale grows the bar.
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: CircleBackButton.tapTarget,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _inset + _slop),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                // Inter 700/22 in the frame; the scale has no 22 (#57).
                style: AppType.h2.copyWith(color: ext.quizReviewTitle),
              ),
            ),
            PositionedDirectional(
              start: 0,
              child: CircleBackButton(
                // A test leaves the screen the way a student does. On the
                // drawn chip, not the 48 box around it (O-15).
                chipKey: const Key('quiz_review_back'),
                tapTargetSize: MaterialTapTargetSize.padded,
                onPressed: onBack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `162:2787` / `337:6824`. Three chips: `All (n)` · `Correct` · `Wrong`,
/// 8 apart, the pills 25 under the header's rule.
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

  /// The rule → pill gap, less the tap target's slack above the pill.
  static const _top = 25 - (_FilterChip._tapTarget - 32) / 2;
  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(20, _top, 20, 0),
      child: Row(
        children: [
          _FilterChip(
            label: l10n.quizReviewFilterAll(total),
            selected: selected == _ReviewFilter.all,
            onTap: () => onChanged(_ReviewFilter.all),
          ),
          const SizedBox(width: _gap),
          // `resultCorrect` / `resultWrong` rather than new keys: the result
          // screen one push back already labels these two buckets with exactly
          // these words, in both languages, human-written. A second pair would
          // be the same string translated twice.
          _FilterChip(
            label: l10n.resultCorrect,
            // `162:2788`: a 16 disc, an 8 tick.
            badge: (color: ext.successBadge, icon: Icons.check, size: 8),
            selected: selected == _ReviewFilter.correct,
            onTap: () => onChanged(_ReviewFilter.correct),
          ),
          const SizedBox(width: _gap),
          _FilterChip(
            label: l10n.resultWrong,
            // `162:2792`: a 16 disc holding the rows' own 14 ✕ box.
            badge: (color: ext.quizWrongBadge, icon: Icons.close, size: 14),
            selected: selected == _ReviewFilter.wrong,
            onTap: () => onChanged(_ReviewFilter.wrong),
          ),
        ],
      ),
    );
  }
}

/// Hug × 32, stadium, padding 6/12. Selected fills with
/// [AppColors.quizReviewFilterFill] and is FLAT in both canvases; idle is the
/// raised surface - a tight black shadow in light (`162:2782`), and in dark a
/// 20% fill with G5 Glass and no shadow at all (`337:6827`).
///
/// This used to be a `Material(elevation: selected ? 0 : 2, shadowColor: ...)`
/// - a Material approximation standing in for a measured Figma shadow, and
/// two of the seven raw elevation sites the ratchet was counting.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Set on "Correct" and "Wrong" only: a disc in the grade's colour with a
  /// cream glyph, as the rows' badges draw it.
  final ({Color color, IconData icon, double size})? badge;

  /// The pill's drawn height (`162:2780`). It is a MINIMUM, not a fixed box:
  /// a 14px label in a 20px content box clips its own glyphs from text scale
  /// 1.15, and silently — the overflow is on a Row's cross axis, which
  /// RenderFlex does not report.
  static const _height = 32.0;

  /// The pill stays 32 tall; the TOUCH target does not. Material and both
  /// platforms' a11y guidance floor a tap target at 48/44dp.
  static const _tapTarget = 48.0;

  static const _disc = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return Semantics(
      button: true,
      selected: selected,
      child: SizedBox(
        height: _tapTarget,
        child: Center(
          // No `width`/`height` on the surface on purpose: it would emit its
          // own `SizedBox`, and the pill's 32 is a MINIMUM while the 48 above
          // is the real box. Same reason the height was a constraint before.
          child: ElevatedSurface(
            shape: const StadiumBorder(),
            color: selected
                ? ext.quizReviewFilterFill
                : ext.reviewFilterIdleFill,
            // The selected pill has no shadow and no Glass in either frame.
            shadows: selected ? const [] : elevation.reviewFilterIdleShadows,
            glass: selected ? null : elevation.reviewFilterIdleGlass,
            onTap: onTap,
            // No `alignment` here: an Align fills the height it is offered, and
            // the Center above offers the tap target's 48, so the pill was
            // drawn 48 tall (device-measured, API→UI Wave 14). The Row centres
            // the label on the minimum by itself.
            child: Container(
              constraints: const BoxConstraints(minHeight: _height),
              padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (badge case final badge?) ...[
                    Container(
                      key: const Key('review_filter_badge'),
                      width: _disc,
                      height: _disc,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: badge.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badge.icon,
                        size: badge.size,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: AppType.labelLarge.copyWith(
                      // NOT `onPrimary`: it is the same cream in both themes,
                      // which is right on the light chip (5.97:1) and wrong on
                      // the dark chip's purple (2.74:1). See the token's field
                      // doc, and DESIGN_ISSUES #54 for what the dark frame
                      // itself specifies here.
                      color: selected
                          ? ext.quizReviewFilterLabel
                          : ext.reviewFilterIdleLabel,
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

/// One question, `162:2502` (correct) / `162:2563` (wrong) in light,
/// `337:6731` and its wrong twin in dark: 362 x 73, radius 16, 0.5px stroke.
///
/// **The dark rows changed on 2026-09-17 by designer ruling** - D-010, which
/// resolved DESIGN_ISSUES #53 in the opposite direction to its 2026-09-08
/// predecessor. They used to be the shipped quiz-page fills, opaque, on both
/// canvases, because "a correctness signal must not change with the canvas".
/// The ruling keeps that rule where it actually bites - the HUE - and takes
/// the frame's TREATMENT: the semantic fill at the frame's alpha, the 0.5
/// semantic stroke, and Glass. Green stays green and red stays red.
///
/// Two consequences worth naming, because both look like mistakes:
///
///  * **All three states take the same alpha and the same Glass**, including
///    the skipped row the frame never draws. The ruling's own emphasis was
///    that the rows be EQUAL in treatment rather than one opaque beside a
///    glassed neighbour, and it said the literal 20% yields to that where
///    the two conflict. Here they do not - 20% is both the frame's number
///    and the consistent one.
///  * **The foreground does not change with the grade.** Both drawn rows set
///    their question in `#384F47` (`162:2510`, `162:2572`) and "QUESTION n" in
///    `#4B675E`, cream in dark, so every row takes
///    [AppColors.quizReviewRowContent] and [AppColors.reviewRowLabel] - the
///    skipped row included, which gains no new signal from it. On the dark
///    composites the cream measures correct 8.24:1, wrong 9.11:1, skipped
///    14.84:1 (API→UI Wave 14; the wrong row used to take `textPrimary`).
///
/// The wrong row's HUE still does not follow the frame. `337:6731`'s twin
/// draws `#FDE9E8` with a `#921019` stroke, one hex digit from the shipped
/// pair; the owner ruled that drift unadopted and it stays open as
/// docs/DESIGN_ISSUES.md #52.
///
/// This ruling was scoped to these rows. It gives no instruction about the
/// quiz page's graded option tiles one tap away, which are unchanged - if
/// the two screens visibly disagree, that is a new question for the designer
/// with both renders side by side, not a reason to hold these.
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

  /// `162:2501`: the content row sits 8.5 inside the 0.5 stroke, 347.18 wide,
  /// badge and text pushed apart (`justify-between`) by what is left over.
  static const _start = 0.5 + 8.5;
  static const _badgeToText = 347.179 - 27.994 - 315.679;
  static const _end = 362 - _start - 347.179;

  /// `162:2500`: an 18 label box whose line sits 4.36 down in it, 7, then a
  /// 25.6 question line, the block centred in the row. On the scale's 16 and
  /// 24 lines (#57) the same line centres need 4.56 above the label and 4.44
  /// between the two.
  static const _aboveLabel = 4.56;
  static const _labelToQuestion = 4.44;

  /// `162:2589` is a 26.55 Iconify box, 10.33 under the stroke at x 324.5; the
  /// drawing inside it is 26.18 × 24.41, 0.18 in from the box's start. The
  /// glyph is sized by that drawing's HEIGHT: `vector_graphics` derives the
  /// width from the height and ignores a width passed with it, so the old
  /// 26.55 × 26.55 drew 28.67 × 26.55. The asset's 27 × 25 gives 26.36 wide.
  static const _aiHeight = 24.41;
  static const _aiTop = 0.5 + 10.33;
  static const _aiEnd = 362 - 0.5 - 324.5 - 0.18 - 26.18;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final (fill, border, badge, mark, semantic) = switch (grade?.correct) {
      true => (
        ext.reviewRowCorrectFill,
        ext.quizCorrectBorder,
        ext.successBadge,
        Icons.check,
        l10n.resultCorrect,
      ),
      false => (
        ext.reviewRowWrongFill,
        ext.quizWrongBorder,
        ext.quizWrongBadge,
        Icons.close,
        l10n.resultWrong,
      ),
      // Skipped. The frame has no state for this, so it takes the neutral
      // ungraded surface and shows no ✓/✕ at all rather than guessing at a
      // third signal colour. TODO(design): docs/DESIGN_ISSUES.md #55.
      null => (
        ext.reviewRowSkippedFill,
        ext.quizOptionBorder,
        null,
        null,
        l10n.resultSkipped,
      ),
    };
    final content = ext.quizReviewRowContent;

    // Wrong rows only, per the frame — AND only where the server actually has
    // an explanation. `explanationAvailable` is the contract's own gate
    // (`AnswerResult`), so drawing the glyph on every wrong row would promise a
    // thing the backend may not have. Non-interactive this day: no destination
    // frame exists for a tap. docs/DESIGN_ISSUES.md #56.
    final showAi =
        grade != null && !grade!.correct && grade!.explanationAvailable;

    return Semantics(
      label: semantic,
      child: ElevatedSurface(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: fill,
        side: BorderSide(color: border, width: 0.5),
        // Null in light, G5 in dark. This is the whole of D-010's change
        // beyond the fill alpha, and in dark it is what delineates the
        // skipped row at all - its composite is 1.01:1 against the page.
        glass: elevation.reviewRowGlass,
        child: Stack(
          children: [
            // The constraint wraps the padding rather than sitting inside it:
            // a MINIMUM, not a fixed height. The two lines leave 4 of slack at
            // 73, so from text scale ~1.1 the row grows (Android's largest
            // standard font setting is 1.30).
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _height),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  _start,
                  10,
                  _end,
                  10,
                ),
                child: Row(
                  children: [
                    Container(
                      key: const Key('review_row_badge'),
                      width: _circle,
                      height: _circle,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: badge,
                        shape: BoxShape.circle,
                        // `border-[#22c55e]` on a `#22c55e` disc: the ring is
                        // the badge's own colour. The skipped row has no fill,
                        // so its ring is the row's neutral stroke.
                        border: Border.all(color: badge ?? border, width: 1.18),
                      ),
                      child: mark == null
                          ? null
                          : Icon(
                              mark,
                              size: 14,
                              color: theme.colorScheme.onPrimary,
                            ),
                    ),
                    const SizedBox(width: _badgeToText),
                    Expanded(
                      child: Padding(
                        key: const Key('review_row_text'),
                        padding: const EdgeInsetsDirectional.only(
                          top: _aboveLabel,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.quizReviewQuestionLabel(number),
                              style: AppType.captionRegular.copyWith(
                                color: ext.reviewRowLabel,
                              ),
                            ),
                            const SizedBox(height: _labelToQuestion),
                            // Markup drawn, direction the stem's own: an
                            // Arabic stem in the English app truncates at its
                            // own end (API→UI Wave 14).
                            QuestionStemText(
                              question.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.h3.copyWith(color: content),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showAi)
              // Over the text column's top-end corner, beside the short label
              // and clear of the question line; it takes no width from the
              // text (`162:2589`).
              PositionedDirectional(
                top: _aiTop,
                end: _aiEnd,
                child: Semantics(
                  label: l10n.quizReviewAiAvailable,
                  child: SvgPicture.asset(
                    'assets/icons/ai_education.svg',
                    height: _aiHeight,
                    // Sized by height alone (see [_aiHeight]); `contain` keeps
                    // the 27×25 aspect if a parent ever boxes it.
                    fit: BoxFit.contain,
                    // The outer Semantics already labels it; without this the
                    // SvgPicture's own image semantics merge upward and the
                    // whole row is announced as an image.
                    excludeFromSemantics: true,
                    colorFilter: ColorFilter.mode(content, BlendMode.srcIn),
                  ),
                ),
              ),
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
