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
    this.renderer = const McqRenderer(),
  });

  final Quiz quiz;

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
      child: _QuizView(renderer: widget.renderer),
    );
  }
}

class _QuizView extends ConsumerWidget {
  const _QuizView({required this.renderer});

  final QuestionRenderer renderer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

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
            appBar: AppBar(
              // Close, not back — the frame draws an X, because leaving ends
              // the session rather than stepping back through it.
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  if (await _confirmExit(context, l10n) && context.mounted) {
                    context.pop();
                  }
                },
              ),
              title: Text(l10n.quizTitle),
              // The frame's bookmark (295:3139) and share (159:1731) icons are
              // deliberately absent: all three favourite endpoints are `draft`
              // and there is no sharing story or endpoint at all. `isFavorite`
              // is parsed into the model regardless. seif_fight S11.
              bottom: _ProgressBar(session: session),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        20,
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

/// Thin progress bar + `n/total` counter · Figma `308:5256`.
class _ProgressBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProgressBar({required this.session});

  final QuizSession session;

  @override
  Size get preferredSize => const Size.fromHeight(30);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(52),
              child: LinearProgressIndicator(
                // Denominator is the questions DELIVERED — a short pool shows
                // 1/7, not 1/10.
                value: session.progress,
                minHeight: 8,
                backgroundColor: ext.progressTrack,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.quizProgress(session.position, session.total),
            style: AppType.captionSmall.copyWith(color: ext.mutedText),
          ),
        ],
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

/// What `/quiz/:quizId/result` is pushed with.
///
/// [scopeName] rides along because `QuizSummary` carries no scope of its own —
/// the result screen would otherwise have nothing to title itself with.
@immutable
class QuizResultArgs {
  const QuizResultArgs({
    required this.summary,
    required this.scopeName,
    required this.review,
  });

  final QuizSummary summary;
  final String scopeName;

  /// Handed straight on to `/quiz/:quizId/result/review` when the student taps
  /// Review Questions. Required, not nullable: the result screen is reachable
  /// only from a finished session, and a finished session always has one — so a
  /// null here would mean a bug, not a legitimate state the CTA must hide for.
  final QuizReviewArgs review;
}
