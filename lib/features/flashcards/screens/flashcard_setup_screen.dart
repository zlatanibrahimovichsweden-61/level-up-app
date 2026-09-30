import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_text_direction.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/models/subject_tree.dart';
import '../../catalog/notifier/subject_tree_notifier.dart';
import '../../catalog/notifier/subjects_notifier.dart';
import '../../catalog/widgets/catalog_states.dart';
import '../notifier/lecture_flashcards_notifier.dart'
    show flashcardRoundPositionProvider, lectureFlashcardsProvider;

/// `/learn/subject/:subjectId/lecture/:lectureId/flashcards` · Figma `1234:8797`
/// (light only).
///
/// The frame is the quiz setup's (`135:1622`) with the size chips swapped for one
/// informational pill: title, back chip, subject caption, scope heading, hairline
/// and Start button are the same values, so they are built from the same widgets
/// and tokens as `QuizSetupScreen` rather than re-derived. The block is copied
/// (not shared) on purpose — refactoring the quiz file is not this screen's job.
///
/// **Nothing here reads the flashcards endpoint.** `GET
/// /flashcards/lectures/{id}/cards` charges the weekly preview per card
/// delivered, and merely opening Setup must cost the student nothing. The count
/// on the pill is [Lecture.flashcardCount] from the cached subject tree —
/// informational and uncharged (contract 3.27.0-m1), not a round size and not the
/// student's remaining allowance. The study screen is the only surface that
/// fetches cards.
///
/// **The pill is not a control.** It carries no size selector (the changelog:
/// "No size selector") — a round is `flashcardRoundSize` cards whatever the deck
/// holds — so it is plain text to a screen reader: no button flag, no tap.
///
/// **Setup owns the round position.** [flashcardRoundPositionProvider] is
/// autoDispose; watching it here keeps "where the next round starts" alive across
/// every round studied from this screen, and popping Setup drops it, so the next
/// visit starts at the beginning of the deck again. The study screen must not be
/// its only listener.
///
/// **In the Learn branch, not beside `/quiz`.** Every flashcard frame draws the
/// bottom nav bar with Learn active, so this is a push onto the branch's own
/// Navigator (the bar stays, [SafeArea] leaves the bottom inset to the shell).
///
/// **Purchase-silent** (adr-049 §3): no price, upgrade line or limit sheet. A
/// student whose free preview is used up learns that on the study screen, where
/// the server says so; Setup never predicts it.
class FlashcardSetupScreen extends ConsumerStatefulWidget {
  const FlashcardSetupScreen({
    super.key,
    required this.subjectId,
    required this.lectureId,
  });

  final String subjectId;
  final String lectureId;

  @override
  ConsumerState<FlashcardSetupScreen> createState() =>
      _FlashcardSetupScreenState();
}

class _FlashcardSetupScreenState extends ConsumerState<FlashcardSetupScreen> {
  /// True from Start until the future `push` returned completes. A plain field,
  /// not state: nothing on screen depends on it. It exists because the button
  /// stays live through the push transition, so a second tap would stack a second
  /// study screen — and the student would then have to finish, or back out of,
  /// two of them.
  ///
  /// It is NOT "the study screen is gone". go_router completes the `push` future
  /// when the route STARTS to pop (`Route.didPop`), not when the exit transition
  /// has finished and the route has left the tree. For those ~300 ms the flag is
  /// already false while the old study screen is still mounted and still holds
  /// [lectureFlashcardsProvider]; the popped route ignores pointers, so a tap in
  /// that window reaches Start. [_start] therefore does not lean on this flag for
  /// that case — it drops the old round itself.
  bool _studying = false;

  Future<void> _start() async {
    if (_studying) return;
    _studying = true;
    try {
      // Every Start begins a round afresh at the stored position. A study
      // screen that is still leaving (see [_studying]) keeps the previous
      // round's provider alive, and a second screen would re-attach to it — the
      // finished round again — instead of building at the position
      // `finishRound` has just written. Only a provider that already exists is
      // invalidated, so this reads nothing and creates nothing: the one fetch
      // is still the new study screen's own build.
      final round = lectureFlashcardsProvider(widget.lectureId);
      if (ref.exists(round)) ref.invalidate(round);
      // The ids ride in the PATH only. A non-JSON `extra` is dropped by
      // go_router on an auth refresh (BUG-005), and the study screen needs
      // nothing that is not in these two ids.
      await context.push<void>(
        '/learn/subject/${widget.subjectId}/lecture/${widget.lectureId}'
        '/flashcards/study',
      );
    } finally {
      _studying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(subjectTreeProvider(widget.subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;
    final subjectName = cachedSubjectName(ref, widget.subjectId);

    // Held for as long as Setup is mounted, whatever state the tree is in —
    // the position must survive a retry, an offline flip and the study screen
    // being pushed over this one. See the class doc.
    ref.watch(flashcardRoundPositionProvider(widget.lectureId));

    return Scaffold(
      body: SafeArea(
        bottom: false, // the nav shell owns the bottom inset
        child: TitledChrome(
          title: l10n.flashcardSetupTitle,
          backKey: const Key('flashcard_setup_back'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (offline) const OfflineBanner(),
              Expanded(
                child: CatalogAsyncView<SubjectTree>(
                  value: tree,
                  // Never empty: a tree with no lectures simply does not hold
                  // this lecture, which is the scope refusal below.
                  isEmpty: (_) => false,
                  emptyMessage: l10n.nothingHere,
                  onRetry: () => ref
                      .read(subjectTreeProvider(widget.subjectId).notifier)
                      .refresh(),
                  skeleton: const _SetupSkeleton(),
                  onLoaded: (data) {
                    final lecture = switch (data) {
                      UniversitySubjectTree(:final lectures) =>
                        lectures
                            .where((entry) => entry.id == widget.lectureId)
                            .firstOrNull,
                      // Flashcards are a university-track surface; a school
                      // tree carries no lecture at all.
                      SchoolSubjectTree() => null,
                    };
                    if (lecture == null) {
                      // The same answer the server gives for a lecture that is
                      // not the student's: one message, no Retry, and no
                      // attempt to say which of the causes it was
                      // (`openapi.yaml:1883-1889`).
                      return CatalogMessage(
                        icon: Icons.error_outline,
                        text: l10n.errorInsufficientScope,
                      );
                    }
                    return _SetupBody(
                      lecture: lecture,
                      subjectName: subjectName,
                      // Offline: the study screen's first request would fail.
                      // Nothing to study: a round of zero cards is not a round.
                      canStart: !offline && lecture.flashcardCount > 0,
                      onStart: _start,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The loaded frame: scope block, count pill, helper, Start.
class _SetupBody extends StatelessWidget {
  const _SetupBody({
    required this.lecture,
    required this.subjectName,
    required this.canStart,
    required this.onStart,
  });

  final Lecture lecture;
  final String? subjectName;
  final bool canStart;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final ui = Directionality.of(context);
    // The line's own direction, at the app's start (BUG-020).
    TextDirection own(String text) => contentTextDirection(text, fallback: ui);
    final start = ui == TextDirection.ltr ? TextAlign.left : TextAlign.right;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subject over lecture · Figma `1234:8826`. Both lines are server copy,
        // already in the content language (adr-018): rendered verbatim, never
        // looked up in the ARB. On a cold deep link the subjects list was never
        // fetched, there is no subject name, and the lecture stands alone.
        // Each takes its own direction, so a name in the other language keeps
        // its punctuation in place; alignment stays the app's start.
        _ScopeFrame(
          key: const Key('flashcard_setup_scope'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subjectName case final subject?)
                Text(
                  subject,
                  textDirection: own(subject),
                  textAlign: start,
                  style: AppType.captionRegular.copyWith(
                    color: ext.quizSetupSubject,
                  ),
                ),
              Text(
                lecture.name,
                textDirection: own(lecture.name),
                textAlign: start,
                style: AppType.h2.copyWith(color: ext.quizSetupScope),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            // The content column · `1234:8831`: 20 in from each side, 20 under
            // the hairline. Start is NOT pinned to the bottom — the frame's
            // column is a hug-height stack with a 60 gap, so it follows the
            // helper.
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CountPill(
                  key: const Key('flashcard_setup_pill'),
                  label: l10n.flashcardSetupCount(lecture.flashcardCount),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.flashcardSetupHelper,
                  key: const Key('flashcard_setup_helper'),
                  style: AppType.captionRegular.copyWith(
                    color: ext.flashcardSetupHelper,
                  ),
                ),
                const SizedBox(height: 60),
                PrimaryCta(
                  enabled: canStart,
                  child: FilledButton(
                    key: const Key('flashcard_setup_start'),
                    onPressed: canStart ? onStart : null,
                    child: Text(l10n.startLearning),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The hairline block under the header · Figma `1234:8826`, identical to the quiz
/// setup's (`146:2287`): padding 22/16/16/13.18 and a bottom rule.
class _ScopeFrame extends StatelessWidget {
  const _ScopeFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(22, 16, 16, 13.18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ext.quizDivider,
            width: elevation.quizSetupDividerWidth,
          ),
        ),
      ),
      child: child,
    );
  }
}

/// "24 Flash Cards" · Figma `1234:8847`: 45 tall, radius 10, a 0.5 hairline,
/// label centred in [AppType.h3].
///
/// A plain box around a [Text] — deliberately not an `ElevatedSurface`, a chip
/// or a button. The frame's drop shadow on this pill is `visible: false`, and the
/// pill selects nothing.
class _CountPill extends StatelessWidget {
  const _CountPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      // `minHeight`, not `height`: the frame's 45 holds at the default text
      // size, and a larger system font grows the pill instead of clipping it.
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ext.flashcardSetupPillFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ext.flashcardSetupPillBorder, width: 0.5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppType.h3.copyWith(color: ext.flashcardSetupPillText),
      ),
    );
  }
}

/// Loading shape: the frame's blocks in the frame's places, so nothing jumps when
/// the tree lands.
class _SetupSkeleton extends StatelessWidget {
  const _SetupSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _ScopeFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatalogBlock(width: 72, height: 12, radius: 4),
              SizedBox(height: 6),
              CatalogBlock(width: 180, height: 24, radius: 6),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CatalogBlock(height: 45, radius: 10),
              SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: CatalogBlock(width: 220, height: 12, radius: 4),
              ),
              SizedBox(height: 60),
              CatalogBlock(height: 60, radius: 20),
            ],
          ),
        ),
      ],
    );
  }
}
