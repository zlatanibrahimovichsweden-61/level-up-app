import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/segmented_track.dart';
import '../../../l10n/app_localizations.dart';
import '../../quiz/models/quiz_type.dart';

/// The Lectures screen's quiz-type selector · Figma `Frame 1000003007`
/// (light `180:5337`, dark `337:11059` / `349:15962`) — 362 x 44 at radius 32.
///
/// **The quiz segments are driven entirely by `tree.quizTypes`.** A subject with
/// no practical component does not list `practicalRevision`, and its tab must
/// not appear — so the row is built from the server's list, never from a
/// hardcoded five.
///
/// The frame also draws a **"Flashcard"** tab, and it is built — but as a
/// [FlashcardsTab], never as a [QuizType]. The contract's `quizTypes` enum has
/// no flashcard value and must not be given one: a flashcard is not a kind of
/// quiz, and a `QuizType` member would invent a value the server has never
/// heard of. (The old reason for leaving the tab out — "no M1 content endpoint,
/// so it could not do anything" — stopped being true when `getFlashcardsForLecture`
/// and the self-grade operation went stable in 3.13.0-m1.) The tab is one more
/// [LecturesTab], sitting beside the quiz types in the same row, by the owner's
/// 2026-09-29 ruling (docs/DESIGN_ISSUES.md #18).
///
/// Whether it appears is the caller's decision, from `Lecture.hasFlashcards` —
/// [lecturesTabsFor] is the one place that rule lives.
///
/// Selecting a tab is local UI state — it re-fetches nothing. A quiz tab is
/// carried into the `/quiz/setup` hand-off; the Flashcard tab decides which
/// lectures are listed and where a row leads.
///
/// ---
///
/// **It is a segmented TRACK, not a row of chips** (owner decision, edit3.md
/// #9). Figma draws one continuous r32 groove with equal segments inside it,
/// not eight-pixel-spaced pills — and in dark both the groove and the selected
/// segment carry an inner shadow, with **opposite** y-offsets, which is what
/// makes the selection read as raised inside a sunken track.
///
/// The two land on opposite edges, and it is worth being exact because the
/// sign is easy to read backwards: an inner shadow offset by −y casts along
/// the **bottom** inside edge (Figma and CSS agree), so the track's (0, −3)
/// darkens its bottom and the selected segment's (0, +4) darkens its top.
/// Verified pixel-wise, not assumed — `test/goldens/quiz_type_tabs_dark.png`.
/// edit3.md §12's checklist describes the track's as a "top inner shadow",
/// which disagrees with §5's own measured value; the value was followed and
/// the discrepancy is logged as docs/DESIGN_ISSUES.md #77.
///
/// Both are `AppElevation` tokens. The shared [SegmentedTrack] primitive draws
/// all of it; Settings > Languages is the same Figma component and reuses the
/// same `pillTrack*` tokens (edit5).
///
/// **The groove scrolls rather than shrinking a label** — owner ruling
/// 2026-09-19, `docs/DECISIONS.md` D-012, prompted by this screen. Four quiz
/// types in Arabic do not fit a 375 dp phone at full type size, and the first
/// build resolved that by scaling the longest label down to ~10 dp and
/// swallowing the student's text-scale setting with it. The primitive now keeps
/// every label at full size and lets the track overflow; the geometry here is
/// unchanged, and on the configurations that DO fit nothing moved at all.
/// Details and the remaining designer questions: `docs/DESIGN_ISSUES.md` #81.
///
/// The class name is unchanged — tests find this by type. `tabs` / `selected` /
/// `onSelected` now carry a [LecturesTab] instead of a bare [QuizType], because
/// one segment of the row is not a quiz type.
class QuizTypeTabs extends StatelessWidget {
  const QuizTypeTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<LecturesTab> tabs;
  final LecturesTab selected;
  final ValueChanged<LecturesTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: SegmentedTrack<LecturesTab>(
        segments: tabs,
        selected: selected,
        onChanged: onSelected,
        labelOf: (tab) => tab.label(l10n),
        height: 44,
        style: SegmentedTrackStyle(
          trackColor: ext.pillTrackFill,
          trackRadius: 32,
          trackInsetShadows: elevation.pillTrackInsetShadows,
          // No idle fill is passed, and none can be: the primitive always
          // draws an unselected segment at zero alpha so the groove shows
          // through. This used to pass `ext.pillTrackFill` — an OPAQUE
          // colour — on the reading that the frame draws no separate idle
          // fill. That reading is right and the implementation was still
          // wrong: a full-height opaque segment covers the dark track's two
          // inner shadows, which is not the same thing as showing the track.
          // Owner ruling 2026-09-20, docs/DESIGN_ISSUES.md #84.
          selectedColor: ext.pillTrackSelectedFill,
          // The frame's 51/72; anything at or above half the 44 height is the
          // same stadium, and 22 is that half exactly.
          selectedRadius: 22,
          selectedInsetShadows: elevation.pillTrackSelectedInsetShadows,
          labelStyle: AppType.labelMedium,
          // Both READ off the Properties panel 2026-09-19, not inferred:
          // idle `180:5339` / `337:11091`, selected `180:5341` / `337:11095`.
          //
          // The idle light value is the surprise — `#384F47`, a dark green,
          // where the hand-rolled chips drew the grey `textSecondary`
          // `#2C2C2C`. Measured contrast on the track: idle 7.48:1 light,
          // 14.98:1 dark, both pass AA. The SELECTED label does not — Figma's
          // own `#FCFBF9` on its own `#AE87E7` is **2.74:1**, below even the
          // 3:1 large-text floor. That is the design's arithmetic, not a build
          // choice, so it is recorded for the designer in
          // docs/DESIGN_ISSUES.md #77 and drawn as measured.
          idleLabelColor: ext.pillTrackLabel,
          selectedLabelColor: ext.pillTrackSelectedLabel,
        ),
      ),
    );
  }
}

/// One segment of the Lectures tab row: a quiz type, or the Flashcard tab.
///
/// A sealed pair rather than a sentinel `QuizType?`, so the two cases are named
/// at every use and a `switch` over it is exhaustive. It is what
/// `SegmentedTrack<T>` compares with `==` to decide which segment is selected,
/// hence the value equality below.
@immutable
sealed class LecturesTab {
  const LecturesTab();

  /// The segment's caption — the app owns both translations, because neither is
  /// server copy (the contract sends bare `quizTypes` values, and the Flashcard
  /// tab has no server representation at all).
  String label(AppLocalizations l10n) => switch (this) {
    QuizTab(:final type) => type.label(l10n),
    FlashcardsTab() => l10n.flashcardsTab,
  };
}

/// A segment standing for one contract [QuizType].
final class QuizTab extends LecturesTab {
  const QuizTab(this.type);

  final QuizType type;

  @override
  bool operator ==(Object other) => other is QuizTab && other.type == type;

  @override
  int get hashCode => Object.hash(runtimeType, type);
}

/// The Flashcard segment. **Not a [QuizType]** and never to become one — see
/// the class comment on [QuizTypeTabs].
final class FlashcardsTab extends LecturesTab {
  const FlashcardsTab();

  @override
  bool operator ==(Object other) => other is FlashcardsTab;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The tab row for one subject, in display order.
///
/// The quiz types come first, in **server order** (`tree.quizTypes`, never a
/// hardcoded five). The Flashcard tab is then inserted **second**, after the
/// first quiz type — Figma `180:5208` / `349:15962` / `337:11059` and the
/// prototype page all draw Normal · Flashcard · Midterm · Final · Practice;
/// `180:5354` alone puts it fourth, and the majority wins.
///
/// * [hasFlashcards] false → no Flashcard tab. The caller derives it from
///   `Lecture.hasFlashcards`: the contract says a faculty whose whole tree
///   returns false should not be offered the surface at all.
/// * No quiz types but flashcards → the Flashcard tab alone.
/// * No quiz types and no flashcards → empty, and the row is not drawn.
List<LecturesTab> lecturesTabsFor({
  required List<QuizType> quizTypes,
  required bool hasFlashcards,
}) {
  final tabs = <LecturesTab>[for (final type in quizTypes) QuizTab(type)];
  if (hasFlashcards) {
    tabs.insert(tabs.isEmpty ? 0 : 1, const FlashcardsTab());
  }
  return tabs;
}
