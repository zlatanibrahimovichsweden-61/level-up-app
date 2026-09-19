import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/widgets/catalog_scaffold.dart';
import '../models/mistakes_subject.dart';

/// One cell of the Mistakes overview grid · Figma `404:6322` (light) /
/// `404:7637` (dark), both named "Container".
///
/// Deliberately NOT `SubjectCard`, and deliberately the same SHAPE as it. The
/// geometry is identical — 173 × 89 at radius 10.7, which is already what
/// `SubjectCard.aspectRatio` and `CatalogBlock`'s default radius carry — but the
/// content is not: a pink ground instead of the catalog surface, a red count
/// instead of a progress bar, and no `questionCounter` anywhere, because this
/// tree has none at any level.
///
/// ---
///
/// 🔴 **The caption says MISTAKES, not "questions".** The frame captions it
/// `20 questions`, and that string is false: [MistakesSubject.mistakeCount] is
/// how many questions the student CURRENTLY has wrong, not how many the subject
/// contains. On a 400-question subject with 20 mistakes, the frame's copy does
/// not merely read vaguely — it inverts the one number this whole flow exists
/// to show. Built as `l10n.mistakeCount`; logged as docs/DESIGN_ISSUES.md #59.
///
/// The frames also write "1 questions", so the key is an ICU `plural` and the
/// Arabic carries all six categories (#66).
class MistakesSubjectCard extends StatelessWidget {
  const MistakesSubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  final MistakesSubject subject;
  final VoidCallback onTap;

  /// Figma card 173 × 89 — the same ratio the catalog grid already uses.
  static const aspectRatio = 173 / 89;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;

    // Figma gives this card two drop shadows, both pure `#000000` at 25%
    // (X 0.53/Y 0/blur 1.06/spread −0.53 and X 0/Y 0.53/blur 1.59), and BOTH
    // are now drawn, exactly, on both canvases.
    //
    // This used to collapse them into one `Material` elevation under the cream
    // `elevationShadow`, on the strength of #47's "black is nothing on the dark
    // canvas". The 2026-09-17 re-read overturned that: the dark frame carries
    // the same black pair, and it lands because the dark card is a 30% wash
    // over the page rather than an opaque fill (#69, #72). The primitive knocks
    // each shadow out behind the shape (edit1.md R4), so the 30% fill
    // composites over the PAGE and not over its own shadow — which is the whole
    // reason a `Material` elevation could never have drawn this correctly.
    //
    // Dark adds Glass **G5** on top; light has none.
    return ElevatedSurface(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.7)),
      color: ext.mistakesCardFill,
      shadows: elevation.mistakesCardShadows,
      glass: elevation.mistakesCardGlass,
      onTap: onTap,
      padding: const EdgeInsetsDirectional.fromSTEB(9, 11, 9, 11),
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
                  // Frame: Inter 700 / 16. `AppType` has no 16/700 entry,
                  // and the scale is the designer's — extending it is not
                  // this day's call. Mapped to the nearest existing style
                  // by ROLE ("card titles, course names"), which is the
                  // ruling docs/DESIGN_ISSUES.md #57 already made for the
                  // review screen. Re-logged as #68, not re-derived.
                  style: AppType.h3.copyWith(color: ext.mistakesContent),
                ),
              ),
              Icon(
                forwardChevron(context),
                size: 16,
                color: ext.mistakesContent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            // Rendered verbatim from the server. It is never summed,
            // reconciled against a retake pool, or derived from anything —
            // the contract sums and forbids the rest (adr-133).
            l10n.mistakeCount(subject.mistakeCount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // Frame: Cairo 600 / 14 at a 10.62px line height. Neither
            // travels: Cairo is not in the design system and adding a
            // second family on inference is the Wave-3D trap (#68), and a
            // 10.62px line box on a 14px glyph clips its own descenders,
            // which is a Figma artefact rather than intent.
            style: AppType.labelLarge.copyWith(color: ext.mistakesCount),
          ),
        ],
      ),
    );
  }
}
