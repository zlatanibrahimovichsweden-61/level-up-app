import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/quiz.dart';
import '../models/quiz_mode.dart';
import '../models/quiz_setup_args.dart';
import '../notifier/quiz_setup_notifier.dart';
import '../widgets/limit_sheet.dart';
import '../widgets/quiz_error_copy.dart';

/// `/quiz/setup` · Figma `135:1622` (school) / `309:5771` (university).
///
/// **One screen, both tracks.** There is no `if (track ==)` anywhere below: the
/// only divergence is which [QuizSetupArgs] constructor the Learn stack used,
/// and the repository reads that. School arrives with a `lessonId`, university
/// with a `lectureId` plus the `quizType` chosen on the Lectures tab row — and
/// the two frames are pixel-identical, so there is nothing to branch on.
///
/// **Two things the frame draws are deliberately absent:**
/// - the QUESTION POOL PROGRESS card (`146:2293`) — nothing in the contract
///   exposes a per-scope pool size or how much of it a student has used, and
///   `POST /quizzes` only reveals it after the fact via 422. seif_fight S15.
/// - the "Questions: 10 · Points: +30" preview (`146:2343`) — the contract
///   awards `0 or 1` per question, so a 10-question quiz can award at most 10.
///   The app never predicts a points figure. seif_fight S12.
///
/// The frame also draws the bottom nav bar, but this route lives OUTSIDE the
/// shell on purpose (a pre-Day-7 decision): taking a quiz is a full-screen
/// task, not a tab.
class QuizSetupScreen extends ConsumerStatefulWidget {
  const QuizSetupScreen({super.key, required this.args});

  final QuizSetupArgs args;

  @override
  ConsumerState<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends ConsumerState<QuizSetupScreen> {
  /// Ephemeral UI state — `setState`, never a provider. It is not server data,
  /// and the frame pre-selects 30.
  QuizLength _length = defaultQuizLength;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final offline = ref.watch(isOnlineProvider).value == false;
    final creation = ref.watch(quizSetupProvider);

    ref.listen<AsyncValue<Quiz?>>(quizSetupProvider, _onCreationChanged);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizSetupTitle)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (offline) const OfflineBanner(),

            // Scope header — 146:2287. The frame also shows the SUBJECT above
            // the scope name ("Biology" / "Cell Membrane"), but no quiz
            // endpoint returns a subject: `Quiz` carries only `scopeName`, and
            // plumbing it from the catalog would mean changing the Learn stack.
            // Scope alone, flagged in docs/DESIGN_ISSUES.md.
            Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.fromSTEB(22, 16, 16, 13.18),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ext.quizDivider, width: 1.18),
                ),
              ),
              child: Text(
                // Server copy, already in the content language (adr-018) —
                // rendered verbatim, never looked up in the ARB.
                widget.args.scopeName,
                style: TextStyle(
                  fontSize: 20,
                  height: 28 / 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 25, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.selectQuizSize,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ext.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        for (final length in QuizLength.values)
                          _LengthChip(
                            label: l10n.quizSizeOption(length.value),
                            selected: _length == length,
                            onTap: creation.isLoading
                                ? null
                                : () => setState(() => _length = length),
                          ),
                      ],
                    ),

                    // 422 and every other non-sheet failure, inline. A 422
                    // says the pool is smaller than the chosen length — the
                    // student picks a shorter quiz; the app never silently
                    // retries with a smaller number on their behalf.
                    if (creation.error case final error?
                        when !opensLimitSheet(error)) ...[
                      const SizedBox(height: 20),
                      Text(
                        quizErrorMessage(l10n, error),
                        style: TextStyle(
                          fontSize: 14,
                          color: ext.quizWrongBorder,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
              child: FilledButton(
                // Disabled while offline (the request would fail anyway) and
                // while one is already in flight.
                onPressed: offline || creation.isLoading ? null : _start,
                child: creation.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.startLearning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _start() {
    ref.read(quizSetupProvider.notifier).create(
          scope: widget.args,
          length: _length,
          // Day 7 offers one mode. `offeredQuizModes` is the single place that
          // changes when a second is enabled — the repository, the models and
          // this call site all already carry all three.
          mode: offeredQuizModes.single,
        );
  }

  /// Navigation and the paywall sheet are side effects of the command
  /// completing, so they belong in a listener rather than in `build` — building
  /// a widget must never push a route.
  void _onCreationChanged(
    AsyncValue<Quiz?>? previous,
    AsyncValue<Quiz?> next,
  ) {
    if (!mounted) return;

    if (next.value case final quiz?) {
      // Reset first: coming back to setup must not re-push the same session.
      ref.read(quizSetupProvider.notifier).reset();
      context.push('/quiz/${quiz.id}', extra: quiz);
      return;
    }

    if (next.error case final ApiException error when opensLimitSheet(error)) {
      LimitSheet.show(context, error);
    }
  }
}

/// One length option · Figma `146:2315` (unselected) / `146:2316` (selected).
class _LengthChip extends StatelessWidget {
  const _LengthChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? theme.colorScheme.primary : ext.quizOptionFill,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            height: 45,
            width: 171,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ext.quizOptionBorder, width: 0.5),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : ext.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
