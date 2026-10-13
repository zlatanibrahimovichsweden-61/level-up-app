import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../models/quiz.dart';
import '../models/quiz_mode.dart';
import '../models/quiz_setup_args.dart';
import '../notifier/quiz_setup_notifier.dart';
import '../widgets/limit_sheet.dart';
import '../widgets/quiz_error_copy.dart';
import 'quiz_screen.dart' show QuizScreenArgs;

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

  /// The gap between chips, across and down (`146:2315` auto layout).
  static const _chipGap = 15.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;
    final offline = ref.watch(isOnlineProvider).value == false;
    final creation = ref.watch(quizSetupProvider);

    ref.listen<AsyncValue<Quiz?>>(quizSetupProvider, _onCreationChanged);

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: l10n.quizSetupTitle,
          backKey: const Key('quiz_setup_back'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (offline) const OfflineBanner(),

              // Scope header — light 146:2287, dark 337:6268: the subject
              // ("Biology") over the scope ("Cell Membrane"). No quiz endpoint
              // returns a subject, so the Learn stack hands over the name from
              // the subjects list the student tapped through. On a cold deep
              // link there is no list and no name, and the scope stands alone.
              // API→UI Wave 11; the subject used to be dropped.
              Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.fromSTEB(
                  22,
                  16,
                  16,
                  13.18,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ext.quizDivider,
                      width: elevation.quizSetupDividerWidth,
                    ),
                  ),
                ),
                // Both lines are server copy, already in the content language
                // (adr-018): rendered verbatim, never looked up in the ARB.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.args.subjectName case final subject?)
                      Text(
                        subject,
                        style: AppType.captionRegular.copyWith(
                          color: ext.quizSetupSubject,
                        ),
                      ),
                    Text(
                      widget.args.scopeName,
                      style: AppType.h2.copyWith(color: ext.quizSetupScope),
                    ),
                  ],
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
                        style: AppType.h3.copyWith(color: ext.textPrimary),
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // The frame's chip is 171, two to a row with a 15
                          // gap (357) in the frame's 362. On a phone narrower
                          // than 397 dp the two no longer fit, so each chip
                          // takes half of what the row has - restoring the
                          // drawn two-up layout instead of one chip per row.
                          // At or above 397 dp this is exactly 171, so the
                          // frame width is unchanged. Widths below the
                          // frame's are derived, not drawn.
                          final chipWidth = math.max(
                            0.0,
                            math.min(
                              _LengthChip.frameWidth,
                              (constraints.maxWidth - _chipGap) / 2,
                            ),
                          );
                          return Wrap(
                            spacing: _chipGap,
                            runSpacing: _chipGap,
                            children: [
                              for (final length in QuizLength.values)
                                _LengthChip(
                                  label: l10n.quizSizeOption(length.value),
                                  selected: _length == length,
                                  width: chipWidth,
                                  onTap: creation.isLoading
                                      ? null
                                      : () => setState(() => _length = length),
                                ),
                            ],
                          );
                        },
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
                          style: AppType.bodyMedium.copyWith(
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
                child: PrimaryCta(
                  enabled: !offline && !creation.isLoading,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _start() {
    ref
        .read(quizSetupProvider.notifier)
        .create(
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
  void _onCreationChanged(AsyncValue<Quiz?>? previous, AsyncValue<Quiz?> next) {
    if (!mounted) return;

    // Only a SETTLED result acts. Riverpod keeps the previous error on the
    // loading state (`AsyncLoading` copies it forward), so a second Start
    // after a 403 went loading-with-that-403 and then error-with-a-new-one,
    // and each opened a card: two, stacked (W11-6, device-found in the API→UI
    // Wave 11 walk).
    if (next.isLoading) return;

    if (next.value case final quiz?) {
      // Reset first: coming back to setup must not re-push the same session.
      ref.read(quizSetupProvider.notifier).reset();
      // The subject rides along for the result's "Subject — Scope" line;
      // display only, it was never part of the request (API→UI Wave 13).
      context.push(
        '/quiz/${quiz.id}',
        extra: QuizScreenArgs(quiz: quiz, subjectName: widget.args.subjectName),
      );
      return;
    }

    if (next.error case final ApiException error when opensLimitSheet(error)) {
      LimitSheet.show(context, error);
    }
  }
}

/// One length option · Figma `146:2315` (unselected) / `146:2316` (selected).
///
/// 171 x 45 at radius 10, and **no hairline in either frame** - the chip is
/// raised off the page by the same tight black shadow on both canvases
/// (`337:6289` keeps it; it is one of the few dark surfaces that does, and it
/// carries no Glass). The border this used to draw was the light frame's
/// neighbour, not its own.
class _LengthChip extends StatelessWidget {
  const _LengthChip({
    required this.label,
    required this.selected,
    required this.width,
    required this.onTap,
  });

  /// The frame's chip width (`146:2315` / `146:2316`).
  static const frameWidth = 171.0;

  final String label;
  final bool selected;

  /// [frameWidth] where the row has room for two, narrower where it has not.
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return Semantics(
      button: true,
      selected: selected,
      child: ElevatedSurface(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        width: width,
        height: 45,
        color: selected ? theme.colorScheme.primary : ext.quizOptionFill,
        shadows: elevation.lengthChipShadows,
        // Null while a creation is in flight, which also drops the ink. The
        // frame draws no disabled chip, so the look is unchanged (R10 dims a
        // treatment; here there is nothing to dim).
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: AppType.h3.copyWith(
              color: selected ? theme.colorScheme.onPrimary : ext.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
