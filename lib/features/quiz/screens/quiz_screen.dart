import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/notifier/me_notifier.dart';
import '../bloc/quiz_bloc.dart';
import '../models/explanation_state.dart';
import '../models/quiz.dart';
import '../models/quiz_review_args.dart';
import '../models/quiz_summary.dart';
import '../repository/quiz_repository.dart';
import '../widgets/ai_explanation_panel.dart';
import '../widgets/limit_sheet.dart';
import '../widgets/mcq_renderer.dart';
import '../widgets/question_renderer.dart';
import '../widgets/quiz_error_copy.dart';
import 'screen_protection.dart';

/// `/quiz/:quizId` · Figma `159:845` (base) · `159:1695` (with AI panel) ·
/// `159:1852` (with photo).
///
/// Owns the session SHELL — header, progress, `n/total`, Confirm/Next, the AI
/// panel, screenshot protection and the exit guard. The middle of the screen is
/// delegated to a [QuestionRenderer]; see `widgets/question_renderer.dart` for
/// why that boundary exists.
///
/// **One engine, both tracks.** Nothing below branches on school vs university:
/// the `Quiz` looks the same either way once created.
///
/// **State is in memory only.** Questions are never cached to Hive — the
/// contract frames the question bank as the product. If the app is killed the
/// session is gone (answers already submitted are safe server-side, but the
/// screen cannot be rebuilt: `GET /quizzes/{quizId}` is `draft`). The exit
/// dialog exists so that loss is never silent. docs/seif_fight.md S2.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({
    super.key,
    required this.quiz,
    this.subjectName,
    this.renderer = const McqRenderer(),
  });

  final Quiz quiz;

  /// Display only, never sent: the subject the Learn stack handed to setup,
  /// carried on to the result's "Subject — Scope" line (API→UI Wave 13). Null
  /// when setup had none, and the result then shows the scope alone.
  final String? subjectName;

  /// Injectable so the seam is real rather than nominal — and so a test can
  /// prove the shell does not depend on the MCQ renderer.
  final QuestionRenderer renderer;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late final ScreenProtection _protection;

  @override
  void initState() {
    super.initState();
    // Read (not watch) and hold the instance: dispose must be able to turn
    // protection off even if the provider container is already tearing down.
    _protection = ref.read(screenProtectionProvider);
    _protection.enable();
  }

  @override
  void dispose() {
    // OFF on the way out, unconditionally — every exit path (finish, back,
    // forced logout, pop) runs through here, so there is no route by which the
    // rest of the app inherits FLAG_SECURE.
    _protection.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizBloc>(
      create: (_) =>
          QuizBloc(repository: ref.read(quizRepositoryProvider))
            ..add(QuizStarted(widget.quiz)),
      child: _QuizView(
        renderer: widget.renderer,
        subjectName: widget.subjectName,
      ),
    );
  }
}

class _QuizView extends ConsumerWidget {
  const _QuizView({required this.renderer, this.subjectName});

  final QuestionRenderer renderer;
  final String? subjectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<QuizBloc, QuizState>(
      // The contract's popup for an AI explanation the student is not
      // subscribed to. On the one transition into that state, so once per tap,
      // and not again when the student pages back to the question.
      listenWhen: _explanationJustLocked,
      listener: (context, _) => LimitSheet.showExplanation(context),
      child: _consumer(context, ref, l10n),
    );
  }

  Widget _consumer(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) => _onStateChanged(context, ref, state),
      builder: (context, state) {
        // Only one frame ever renders this — the Quiz is in hand before the
        // screen is pushed, so there is no fetch to wait through.
        if (state is! QuizActive) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = state.session;
        final bloc = context.read<QuizBloc>();

        return PopScope(
          // The exit guard. Progress is in memory and the quiz cannot be
          // reopened, so leaving must be a decision, not an accident.
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (await _confirmExit(context, l10n)) {
              if (context.mounted) context.pop();
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    session: session,
                    // Close, not back — the frame draws an X, because leaving
                    // ends the session rather than stepping back through it.
                    onClose: () async {
                      if (await _confirmExit(context, l10n) &&
                          context.mounted) {
                        context.pop();
                      }
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      // 25 under the header's rule: `159:1254` sits at
                      // 178.18 under a header ending at 153.18.
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        25,
                        20,
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          renderer.build(
                            context,
                            QuestionPresentation(
                              question: session.question,
                              position: session.position,
                              selectedOptionId: switch (state) {
                                QuizInProgress(:final selectedOptionId) =>
                                  selectedOptionId,
                                _ => null,
                              },
                              committedOptionId: session.committedOptionId,
                              grade: session.grade,
                              locked: state is AnswerConfirming,
                              onSelect: (optionId) =>
                                  bloc.add(OptionSelected(optionId)),
                            ),
                          ),

                          // Offered only once the server has said there is one
                          // to fetch — a panel that could only ever fail is
                          // worse than no panel.
                          if (session.grade?.explanationAvailable ?? false) ...[
                            const SizedBox(height: 25),
                            AiExplanationPanel(
                              state: session.explanation,
                              onRequest: () =>
                                  bloc.add(const ExplanationRequested()),
                            ),
                          ],

                          // `onRetry` is withheld — not the whole row — when
                          // the contract forbids retrying: the student still
                          // needs to read WHY the answer did not go through.
                          if (state case AnswerFailed(:final error)) ...[
                            const SizedBox(height: 16),
                            _RetryRow(
                              message: quizErrorMessage(l10n, error),
                              onRetry: suppressesRetry(error)
                                  ? null
                                  : () => bloc.add(const AnswerRetried()),
                            ),
                          ],
                          if (state case FinishFailed(:final error)) ...[
                            const SizedBox(height: 16),
                            _RetryRow(
                              message: quizErrorMessage(l10n, error),
                              onRetry: suppressesRetry(error)
                                  ? null
                                  : () => bloc.add(const QuizFinishRequested()),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _ActionBar(state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, WidgetRef ref, QuizState state) {
    switch (state) {
      case QuizCompleted(:final summary, :final scopeName, :final session):
        // The one Riverpod touch in the session: Home reads `/me`, and the
        // student's points and level just changed server-side. Invalidating is
        // correct rather than patching a local value — the server is
        // authoritative and the next read gets the truth.
        ref.invalidate(meProvider);
        // `pushReplacement`, so the finished quiz is not left on the stack for
        // Back to land on.
        context.pushReplacement(
          '/quiz/${summary.quizId}/result',
          extra: QuizResultArgs(
            summary: summary,
            scopeName: scopeName,
            subjectName: subjectName,
            // Narrowed here, at the last point the session is in hand. The
            // result screen never sees the session itself.
            review: QuizReviewArgs(
              questions: session.quiz.questions,
              grades: session.grades,
            ),
          ),
        );

      // A mid-quiz 403 on `POST /answers` is the same paywall as on setup.
      case AnswerFailed(:final error) when opensLimitSheet(error):
        LimitSheet.show(context, error as ApiException);

      case _:
        break;
    }
  }

  /// Pending → subscription-required on the question on screen: the tap that
  /// asked was just answered `403 subscription_required`. Comparing the SAME
  /// question is what keeps paging back to it from reopening the popup.
  static bool _explanationJustLocked(QuizState previous, QuizState current) =>
      previous is QuizActive &&
      current is QuizActive &&
      previous.session.question.id == current.session.question.id &&
      previous.session.explanation is ExplanationPending &&
      current.session.explanation is ExplanationSubscriptionRequired;

  Future<bool> _confirmExit(BuildContext context, AppLocalizations l10n) async {
    // No Figma frame draws this dialog, so it takes the app's own dialog
    // scrim rather than Material's default barrier - the same one the
    // logout and delete confirmations wear (edit2 §13). That is a
    // consistency choice between two existing values, not an invented one.
    final leave = await showAppDialog<bool>(
      context: context,
      scrim: Theme.of(context).extension<AppElevation>()!.logoutDialogScrim,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exitQuizTitle),
        content: Text(l10n.exitQuizBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.exitQuizStay),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.exitQuizLeave),
          ),
        ],
      ),
    );
    return leave ?? false;
  }
}

/// The session header · Figma `159:1224` (light) / `337:9202` (dark).
///
/// Its own container rather than an `AppBar`, so it can be the frame's: the ✕
/// box 16 in and 16 down, the title centred on it, the progress row 12 under
/// it, and a 1.18 rule closing the header at 89.18. The app bar put the ✕ 3 dp
/// off both ways and the card 8 dp high, and drew no rule (API→UI Wave 12).
///
/// The frame's three trailing icons are deliberately absent. Bookmark
/// (`295:3108`) and share (`295:3110`): all three favourite endpoints are
/// `draft` and there is no sharing story or endpoint at all; `isFavorite` is
/// parsed into the model regardless (seif_fight S11). The AI "sparkle-cap"
/// (`295:3103`): owner ruling 2026-09-26 — the frame shows it before the
/// question is answered, which the contract forbids, and after grading it
/// would only duplicate the panel's "Show explanation" (DESIGN_ISSUES #95).
class _Header extends StatelessWidget {
  const _Header({required this.session, required this.onClose});

  final QuizSession session;
  final VoidCallback onClose;

  /// The frame's ✕ box (`159:1227`).
  static const _glyph = 30.0;

  /// Android's minimum touch target, kept, and centred on the ✕ box.
  static const _target = 48.0;

  /// How far the target reaches past the box on each side: 9.
  static const _overhang = (_target - _glyph) / 2;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      key: const Key('quiz_header'),
      // The frame's 16, less the target's overhang, so the box lands 16 in and
      // 16 down. The same at the end, which keeps the title on the screen's
      // centre line. 12 at the bottom: Container adds the rule's 1.18 to its
      // padding, and 12 + 1.18 is the frame's 13.18.
      padding: const EdgeInsetsDirectional.fromSTEB(
        16 - _overhang,
        16 - _overhang,
        16 - _overhang,
        12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ext.quizHeaderRule, width: 1.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _target,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  // Clear of the ✕ target on BOTH sides, so the title stays
                  // centred and a long one ellipsises instead of running
                  // under it.
                  padding: const EdgeInsets.symmetric(horizontal: _target),
                  child: Text(
                    l10n.quizTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // The frame sets Inter 600/22; the type scale has no 22,
                    // so this is the app's screen title (h2), as on every
                    // other title bar.
                    style: AppType.h2.copyWith(color: ext.textPrimary),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  child: IconButton(
                    key: const Key('quiz_close'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: _target,
                      height: _target,
                    ),
                    // Framework-localised ("Close" / "إغلاق"), the name
                    // Material's own CloseButton carries.
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: onClose,
                    // The frame's own cross: 15 dp of 1.67 stroke, round
                    // caps. `Icons.close` was 14 dp of a heavier, square
                    // stroke, in #0E0E0E.
                    icon: SvgPicture.asset(
                      'assets/icons/quiz_close.svg',
                      width: _glyph,
                      height: _glyph,
                      // The tooltip names the button. Without this the
                      // glyph's own image semantics merge in and TalkBack
                      // reads an ImageView (W11-7).
                      excludeFromSemantics: true,
                      colorFilter: ColorFilter.mode(
                        ext.quizHeaderGlyph,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 12 under the box in the frame, less the target's overhang.
          const SizedBox(height: 12 - _overhang),
          _ProgressBar(session: session),
        ],
      ),
    );
  }
}

/// Thin progress bar + `n/total` counter · Figma `308:5264` / `348:7709`.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.session});

  final QuizSession session;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      // 20 from both screen edges, the frame's 362-wide row: the header's own
      // 7 plus 13.
      padding: const EdgeInsets.symmetric(horizontal: 20 - 7),
      child: SizedBox(
        // The frame's row is its counter's 18 dp line; the bar is centred on
        // it.
        height: 18,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(52),
                child: LinearProgressIndicator(
                  // Denominator is the questions DELIVERED — a short pool
                  // shows 1/7, not 1/10.
                  value: session.progress,
                  minHeight: 8,
                  backgroundColor: ext.progressTrack,
                  valueColor: AlwaysStoppedAnimation(ext.quizProgressFill),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.quizProgress(session.position, session.total),
              style: AppType.captionSmall.copyWith(
                color: ext.quizProgressCounter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back arrow + the primary action · Figma `159:1772`.
///
/// The primary action's label is the whole interaction model in one place:
/// Confirm while ungraded, Next once graded, Finish on the last question.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.state});

  final QuizActive state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<QuizBloc>();
    final session = state.session;
    final busy = state is AnswerConfirming || state is QuizFinishing;

    final (label, action) = switch (state) {
      QuizInProgress(:final canConfirm) when !session.isGraded => (
        l10n.confirm,
        // Enabled only by an uncommitted selection. Nothing was sent when the
        // student tapped an option; THIS is the only thing that submits.
        canConfirm ? () => bloc.add(const AnswerSubmitted()) : null,
      ),
      QuizInProgress() when session.isLast => (
        l10n.finishQuiz,
        () => bloc.add(const QuizFinishRequested()),
      ),
      QuizInProgress() => (
        l10n.next,
        () => bloc.add(const NextQuestionRequested()),
      ),
      AnswerConfirming() => (l10n.confirm, null),
      QuizFinishing() => (l10n.finishQuiz, null),
      AnswerFailed() => (l10n.confirm, null),
      FinishFailed() => (l10n.finishQuiz, null),
    };

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 20),
      child: Row(
        children: [
          // Directional: leads the row, so it sits on the right in RTL and the
          // chevron flips with the text direction rather than being mirrored
          // by hand.
          if (!session.isFirst) ...[
            _PreviousButton(
              onPressed: busy
                  ? null
                  : () => bloc.add(const PreviousQuestionRequested()),
            ),
            // Figma puts the pill at x 20 ending at 99 and starts the CTA at
            // 114.
            const SizedBox(width: 15),
          ],
          Expanded(
            child: PrimaryCta(
              enabled: !busy && action != null,
              child: FilledButton(
                onPressed: busy ? null : action,
                child: busy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The previous-question pill · Figma `159:1920` (light) / `337:6464` (dark).
///
/// A 79 x 58 rounded rectangle, not the Material tonal icon button that stood
/// here - which was roughly 40 dp round and carried M3's own tonal colours.
///
/// **The radius differs by canvas**: 9 light, 10 dark, both read off the
/// Properties panel on 2026-09-20. One dp on a 58-high pill is invisible, and
/// normalising it is still not this edit's call, so it lives in
/// [AppElevation.quizPrevButtonRadius] with both values.
///
/// The glyph is the shared `chevron.svg`, mirrored the way
/// [CircleBackButton] mirrors it: the asset points RIGHT, so "back" is its
/// flip in LTR and its unflipped self in RTL. Its colour was read in both
/// canvases - `159:1922` and `337:6466` both say cream.
class _PreviousButton extends StatelessWidget {
  const _PreviousButton({required this.onPressed});

  /// Null while an answer or a finish is in flight.
  final VoidCallback? onPressed;

  static const _width = 79.0;
  static const _height = 58.0;
  static const _chevronWidth = 16.57;
  static const _chevronHeight = 28.64;

  /// `kProfileDisabledOpacity`, the project's one disabled convention. Figma
  /// draws no disabled state for this chip (edit1.md R10).
  static const _disabledOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final busy = onPressed == null;

    return Semantics(
      button: true,
      enabled: !busy,
      // `previousPageTooltip`, NOT `backButtonTooltip`. This screen already
      // has a control that means "back" - the ✕ in the app bar, which LEAVES
      // the quiz - so announcing this one as "Back" would give a screen reader
      // two buttons with the same name and very different consequences. Both
      // strings are framework-localised, so neither needs an ARB entry.
      label: MaterialLocalizations.of(context).previousPageTooltip,
      child: Opacity(
        opacity: busy ? _disabledOpacity : 1,
        child: ElevatedSurface(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(elevation.quizPrevButtonRadius),
          ),
          width: _width,
          height: _height,
          color: ext.quizPrevButtonFill,
          shadows: elevation.quizPrevButtonShadows,
          glass: elevation.quizPrevButtonGlass,
          onTap: onPressed,
          child: Center(
            child: Transform.flip(
              flipX: !rtl,
              child: SvgPicture.asset(
                'assets/icons/chevron.svg',
                width: _chevronWidth,
                height: _chevronHeight,
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(
                  ext.quizPrevButtonGlyph,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryRow extends StatelessWidget {
  const _RetryRow({required this.message, required this.onRetry});

  final String message;

  /// Null when the contract forbids retrying this failure — the message is
  /// still rendered, without the button. The student is not left without a way
  /// out: the header's exit chip is unaffected.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: AppType.bodyMedium.copyWith(color: ext.quizWrongBorder),
          ),
        ),
        // A user-tapped button, never a silent auto-retry. The request it
        // re-sends is byte-identical; the server's idempotency key makes that
        // safe.
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
      ],
    );
  }
}

/// What setup pushes `/quiz/:quizId` with: the created [quiz], plus the
/// subject name setup was handed, which no quiz endpoint returns.
///
/// [subjectName] is display only. It exists so the result can draw the frame's
/// "Subject — Scope" line (`159:2250`); `POST /quizzes` never sees it, and the
/// `Quiz` model does not grow a field the contract does not have. A bare `Quiz`
/// in `extra` still opens the screen, with no subject (API→UI Wave 13).
@immutable
class QuizScreenArgs {
  const QuizScreenArgs({required this.quiz, this.subjectName});

  final Quiz quiz;
  final String? subjectName;
}

/// What `/quiz/:quizId/result` is pushed with.
///
/// [scopeName] rides along because `QuizSummary` carries no scope of its own —
/// the result screen would otherwise have nothing to title itself with.
/// [subjectName] rides the same way from setup, and is null when setup had
/// none (API→UI Wave 13).
@immutable
class QuizResultArgs {
  const QuizResultArgs({
    required this.summary,
    required this.scopeName,
    this.subjectName,
    required this.review,
  });

  final QuizSummary summary;
  final String scopeName;
  final String? subjectName;

  /// Handed straight on to `/quiz/:quizId/result/review` when the student taps
  /// Review Questions. Required, not nullable: the result screen is reachable
  /// only from a finished session, and a finished session always has one — so a
  /// null here would mean a bug, not a legitimate state the CTA must hide for.
  final QuizReviewArgs review;
}
