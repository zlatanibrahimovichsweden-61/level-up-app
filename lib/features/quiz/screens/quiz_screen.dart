import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/study_session_chrome.dart';
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
                  StudySessionHeader(
                    headerKey: const Key('quiz_header'),
                    closeKey: const Key('quiz_close'),
                    title: l10n.quizTitle,
                    // Denominator is the questions DELIVERED — a short pool
                    // shows 1/7, not 1/10.
                    position: session.position,
                    total: session.total,
                    progressFill: Theme.of(
                      context,
                    ).extension<AppColors>()!.quizProgressFill,
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
            StudyPreviousButton(
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
