import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/study_session_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/widgets/catalog_states.dart';
import '../models/flashcard.dart';
import '../notifier/lecture_flashcards_notifier.dart';
import '../widgets/flashcard_again_button.dart';
import '../widgets/flashcard_flip_card.dart';
import '../widgets/flashcards_error_copy.dart';

/// The flashcards study round · Figma `225:5582` (light, the updated layout).
///
/// Dark (`337:14475`) and Arabic (`549:28041`) are older layouts; both are built
/// from the light one with the app's own theme tokens and directional insets
/// (owner ruling 2026-09-29).
///
/// **One round = one page of cards** ([flashcardRoundSize]; a short round when
/// the lecture has fewer). The card on screen is `_index`; which face is up is
/// `_flipped`. Both are ephemeral local state, and neither is a server fact.
///
/// **Grading is non-optimistic.** "Got it" and the restart button each `PUT` the
/// card's self-grade and move on ONLY when the server has accepted it. While the
/// request is out the card, "<" and the restart button are inert and "Got it"
/// shows its busy state; on failure the student stays on the card with the
/// mapped message under it, everything re-enabled — tapping again is the retry.
/// The exception is a refusal a second try cannot change
/// (`insufficient_scope`, `account_pending_deletion`): the message stays and
/// "Got it" and the restart button stay off for that card, while the flip, "<"
/// and ✕ still work. After the LAST card [LectureFlashcardsNotifier.finishRound] moves the round
/// position on and the route pops back to the screen the student came from. No
/// completion screen: none is designed and no wording exists.
///
/// The route sits inside the shell (the nav bar stays), so the bottom inset is
/// the shell's, not this screen's.
///
/// **Deliberately absent**: the frame's bookmark and share icons (no endpoint,
/// no sharing story — see [StudySessionHeader]); any price, upgrade or
/// checkout wording (the app is purchase-silent); screen-capture protection
/// (owner ruling — unlike the quiz, nothing here is the question bank).
class FlashcardStudyScreen extends ConsumerStatefulWidget {
  const FlashcardStudyScreen({
    super.key,
    required this.subjectId,
    required this.lectureId,
  });

  final String subjectId;
  final String lectureId;

  @override
  ConsumerState<FlashcardStudyScreen> createState() =>
      _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends ConsumerState<FlashcardStudyScreen> {
  // The frame's vertical rhythm under the header's rule (`225:5582`):
  //   rule -16- restart disc (38) -14- card -34- button row (60)
  static const _aboveDisc = 16.0;
  static const _discToCard = 14.0;
  static const _cardToRow = 34.0;
  static const _rowHeight = 60.0;

  /// The quiz's action row keeps 20 under itself (`_ActionBar`).
  static const _rowBottom = 20.0;

  /// The frame's card is 454 tall. It is the CEILING: the card shrinks first on
  /// a short screen, and on a tall one the spare room stays under the buttons.
  static const _cardMaxHeight = 454.0;

  /// A floor so a very short window scrolls instead of squeezing the card to a
  /// sliver. Not in the frame; the frame has no short-screen answer.
  static const _cardMinHeight = 200.0;

  /// Everything in the body that is not the card.
  static const _chrome =
      _aboveDisc +
      FlashcardAgainButton.discSize +
      _discToCard +
      _cardToRow +
      _rowHeight +
      _rowBottom;

  int _index = 0;
  bool _flipped = false;

  /// True from the moment a grade is sent until the server answers.
  bool _saving = false;

  /// The failure of the last grade, shown under the card until the next attempt
  /// or a move to another card.
  Object? _gradeError;

  /// Set by the first [_leave]. A popped route stays mounted for its whole
  /// reverse animation, so a second exit (the last grade landing mid-pop) would
  /// pop the screen UNDER this one as well.
  bool _leaving = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final offline = ref.watch(isOnlineProvider).value == false;
    final round = ref.watch(lectureFlashcardsProvider(widget.lectureId));

    final cards = switch (round) {
      AsyncData(:final value) => value.items,
      _ => null,
    };
    final hasCards = cards != null && cards.isNotEmpty;
    final index = hasCards ? math.min(_index, cards.length - 1) : 0;

    return Scaffold(
      body: SafeArea(
        // The nav shell owns the bottom inset (as `CatalogScaffold` does).
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (offline) const OfflineBanner(),
            StudySessionHeader(
              headerKey: const Key('flashcard_header'),
              closeKey: const Key('flashcard_close'),
              title: l10n.flashcardsTitle,
              // The ✕ leaves without asking: every grade was saved as it was
              // made, so there is nothing to lose (unlike the quiz).
              onClose: _leave,
              // The denominator is what was DELIVERED — a short round reads
              // 1/4, never 1/10 — and there is none until cards arrive.
              position: hasCards ? index + 1 : 0,
              total: hasCards ? cards.length : 0,
              showCounter: hasCards,
              progressFill: ext.flashcardProgressFill,
            ),
            Expanded(
              child: switch (round) {
                AsyncData(:final value) when value.items.isNotEmpty =>
                  _studyBody(
                    cards: value.items,
                    index: index,
                    offline: offline,
                  ),
                AsyncData() => CatalogMessage(
                  icon: Icons.inbox_outlined,
                  text: l10n.nothingHere,
                ),
                AsyncError(:final error) => _failure(l10n, error),
                _ => _sized(
                  (cardHeight) => Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      _aboveDisc + FlashcardAgainButton.discSize + _discToCard,
                      20,
                      0,
                    ),
                    child: CatalogBlock(
                      key: const Key('flashcard_skeleton'),
                      height: cardHeight,
                      radius: FlashcardFlipCard.radius,
                    ),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  /// The card and the controls, for a round that has cards.
  Widget _studyBody({
    required List<FlashcardCard> cards,
    required int index,
    required bool offline,
  }) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final card = cards[index];

    // The last grade's failure, as copy. Where it says a retry can only fail
    // the same way again (`insufficient_scope`, `account_pending_deletion`) the
    // message stays and the two grade controls stay off for THIS card; the
    // flip, "<" and the ✕ stay live, and another card clears it.
    final gradeError = _gradeError;
    final gradeCopy = gradeError == null
        ? null
        : flashcardsErrorCopy(l10n, gradeError);

    // A grade is a `PUT`: none is sent while the device is offline (the banner
    // says so), while another is still out, or after a refusal that a second
    // try cannot change.
    final canGrade = !_saving && !offline && (gradeCopy?.canRetry ?? true);

    return _sized(
      (cardHeight) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The disc is 38 dp inside a 48 dp target, so its margins come in by
          // the 5 dp the target overhangs: 16 under the rule, 20 from the end
          // edge, 14 above the card.
          const SizedBox(height: _aboveDisc - FlashcardAgainButton.overhang),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                end: 20 - FlashcardAgainButton.overhang,
              ),
              child: FlashcardAgainButton(
                key: const Key('flashcard_again'),
                onPressed: canGrade
                    ? () => _grade(cards, index, FlashcardSelfGrade.again)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: _discToCard - FlashcardAgainButton.overhang),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: SizedBox(
              height: cardHeight,
              // A fresh card is a fresh widget: it starts on its front, with no
              // half-finished turn carried over from the last one.
              child: KeyedSubtree(
                key: ValueKey(card.id),
                child: FlashcardFlipCard(
                  key: const Key('flashcard_card'),
                  front: card.front,
                  back: card.back,
                  imageUrl: card.imageUrl,
                  flipped: _flipped,
                  onFlip: _saving
                      ? null
                      : () => setState(() => _flipped = !_flipped),
                ),
              ),
            ),
          ),
          if (gradeCopy != null)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _cardToRow),
              child: Center(
                child: Padding(
                  // 20 + 14 = the frame's 34 for one line.
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                    vertical: 7,
                  ),
                  child: Semantics(
                    // Announced when it appears: the student is looking at the
                    // card, not at the space under it.
                    liveRegion: true,
                    child: Text(
                      gradeCopy.message,
                      key: const Key('flashcard_error'),
                      textAlign: TextAlign.center,
                      // Not `quizWrongBorder`: that red is 1.7:1 on the dark
                      // canvas. Nothing draws this line (DESIGN_ISSUES #119).
                      style: AppType.bodyMedium.copyWith(
                        color: ext.flashcardGradeError,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: _cardToRow),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              20,
              0,
              20,
              _rowBottom,
            ),
            child: Row(
              children: [
                // Omitted on the first card, as the quiz omits it on question
                // 1, so "Got it" takes the whole row. Local only: going back
                // grades nothing.
                if (index > 0) ...[
                  StudyPreviousButton(
                    onPressed: _saving ? null : () => _previous(index),
                  ),
                  const SizedBox(width: 15),
                ],
                Expanded(
                  child: PrimaryCta(
                    enabled: canGrade,
                    child: FilledButton(
                      key: const Key('flashcard_got_it'),
                      onPressed: canGrade
                          ? () => _grade(cards, index, FlashcardSelfGrade.gotIt)
                          : null,
                      child: _saving
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                // The spinner replaces the label, so it carries
                                // it: the button keeps its name while it is
                                // busy instead of reading as an unnamed control.
                                semanticsLabel: l10n.flashcardGotIt,
                              ),
                            )
                          : Text(l10n.flashcardGotIt),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sizes the card to the room there is, and scrolls if even the smallest card
  /// does not fit.
  Widget _sized(Widget Function(double cardHeight) child) {
    return LayoutBuilder(
      builder: (context, box) {
        final room = box.maxHeight - _chrome;
        final cardHeight = math.min(
          _cardMaxHeight,
          math.max(_cardMinHeight, room),
        );
        return SingleChildScrollView(child: child(cardHeight));
      },
    );
  }

  /// Loading the round failed: the mapped sentence, and Retry only where a
  /// retry can help.
  Widget _failure(AppLocalizations l10n, Object error) {
    final copy = flashcardsErrorCopy(l10n, error);
    return CatalogMessage(
      icon: isOffline(error) ? Icons.wifi_off : Icons.error_outline,
      text: copy.message,
      onRetry: copy.canRetry ? _retryRound : null,
    );
  }

  void _retryRound() {
    setState(() {
      _index = 0;
      _flipped = false;
      _gradeError = null;
    });
    unawaited(
      ref.read(lectureFlashcardsProvider(widget.lectureId).notifier).refresh(),
    );
  }

  void _previous(int index) {
    setState(() {
      _index = index - 1;
      _flipped = false;
      _gradeError = null;
    });
  }

  Future<void> _grade(
    List<FlashcardCard> cards,
    int index,
    FlashcardSelfGrade grade,
  ) async {
    if (_saving) return;
    // Held across the await: the screen may be gone by the time it answers, and
    // `ref` must not be touched then.
    final notifier = ref.read(
      lectureFlashcardsProvider(widget.lectureId).notifier,
    );
    final isLast = index >= cards.length - 1;

    setState(() {
      _saving = true;
      _gradeError = null;
    });
    try {
      await notifier.setSelfGrade(cards[index].id, grade);
    } on Object catch (error) {
      if (!mounted) return;
      // Stay on the card, everything back on. Nothing about the request or the
      // response is logged.
      setState(() {
        _saving = false;
        _gradeError = error;
      });
      return;
    }
    if (!mounted) return;

    if (isLast) {
      // Round over: record where the next one starts, then go back. `_saving`
      // stays true so a second tap during the pop cannot send another grade.
      // The grade WAS saved, so the round is over even when the student already
      // left with the ✕ or Back while it was out; `_leave` then does nothing
      // rather than pop the screen underneath as well.
      notifier.finishRound();
      _leave();
      return;
    }
    setState(() {
      _saving = false;
      _index = index + 1;
      _flipped = false;
    });
  }

  /// Back to the screen the student came from (Setup). Guarded for a route with
  /// nothing under it, where a bare pop would throw, and for a second call while
  /// the first is still animating out ([_leaving]).
  ///
  /// The system Back does not come through here, so a route that was popped that
  /// way is caught by its own state instead: it is no longer active, and a pop
  /// now would take the screen under it. A route merely covered (still active)
  /// is not that.
  void _leave() {
    if (_leaving) return;
    _leaving = true;
    if (ModalRoute.of(context)?.isActive == false) return;
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/learn/subject/${widget.subjectId}');
    }
  }
}
