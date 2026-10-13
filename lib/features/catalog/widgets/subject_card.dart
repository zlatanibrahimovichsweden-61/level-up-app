import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_text_direction.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject.dart';
import 'catalog_scaffold.dart';

/// One cell of the Subjects grid · Figma `135:618` (light) / `337:5732` (dark).
///
/// Name + chevron, a progress bar, and the `{answered} / {total} questions`
/// caption. The counter is DISPLAY ONLY (contract: "never locks retakes") — this
/// card is fully tappable at `0 / 0` and at `480 / 480` alike. Nothing here
/// reads the counter to decide anything.
///
/// **It elevates the same way on both canvases, and it is the only card in
/// this wave that does so with no Glass at all.** The two frames carry the
/// identical pair of black drop shadows; the dark card is an OPAQUE `#27282C`
/// rather than a translucent wash, so the black lands on something without
/// needing a rim to separate it from the page (edit1.md R1). The Mistakes
/// overview card keeps the same black pair on both canvases too, but its dark
/// fill is 30% and it takes Glass on top — which is the distinction, not the
/// shadows. That measurement is what withdrew the cream-shadow derivation,
/// DESIGN_ISSUES #47.
class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.subject, required this.onTap});

  final Subject subject;
  final VoidCallback onTap;

  /// Figma card 173 × 89. The FLOOR, not the height: the card grows with its
  /// text and the grid gives a row its taller card — the rule D-018 set for
  /// the Mistakes card, applied here for BUG-002's second half (Fable-eye
  /// audit 2026-10-06, FE-09). At the old fixed 173/89 aspect the card was
  /// 78 tall on a 360 dp phone and its caption overflowed from text scale 1.3
  /// (2.7 px in English, every card in Arabic).
  static const minHeight = 89.0;

  /// The frame's inset (`135:618`): 9 at the sides, 11 top and bottom.
  static const _padding = EdgeInsetsDirectional.fromSTEB(9, 11, 9, 11);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;
    final ui = Directionality.of(context);
    final counter = subject.questionCounter;

    // `MergeSemantics` + `button: true`, the Mistakes card's and TreeListRow's
    // fix: `ElevatedSurface` adds no semantics and its `InkWell` gives a tap
    // ACTION, not the button FLAG, so the bar's own progress semantics won the
    // merge and TalkBack read every card as a PROGRESS BAR (Fable-eye audit
    // 2026-10-06, FE-03). The bar is display-only and is excluded below.
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: ElevatedSurface(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.7),
          ),
          color: ext.subjectCardFill,
          shadows: elevation.subjectCardShadows,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: _padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          // Already in the content language (adr-018) — rendered
                          // verbatim, never looked up in the ARB.
                          subject.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          // Its OWN direction, so a name in the other language
                          // keeps its punctuation in place (BUG-020), aligned
                          // at the app's start. The chevron beside it stays
                          // the app's.
                          textDirection: contentTextDirection(
                            subject.name,
                            fallback: ui,
                          ),
                          textAlign: ui == TextDirection.ltr
                              ? TextAlign.left
                              : TextAlign.right,
                          style: AppType.h3.copyWith(
                            color: ext.subjectCardTitle,
                          ),
                        ),
                      ),
                      Icon(
                        forwardChevron,
                        size: 16,
                        color: ext.subjectCardChevron,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Mirrors itself under RTL via Directionality, so the bar fills
                  // from the correct edge in Arabic for free.
                  ExcludeSemantics(
                    child: LinearProgressIndicator(
                      value: counter.fraction,
                      minHeight: 4,
                      backgroundColor: ext.catalogTrack,
                      // Lavender on BOTH canvases and both tracks (`135:631`,
                      // `404:6989`, `337:5745`) — not the theme primary, which is
                      // green in light.
                      color: ext.subjectCardProgress,
                      borderRadius: BorderRadius.circular(52),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.questionsCount(counter.answered, counter.total),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // The frame specifies 8.56dp; raised to 10 — 8.5dp is below any
                    // readable minimum on a real phone. Flagged to the designer.
                    style: AppType.captionSmall.copyWith(color: ext.cardLabel),
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
