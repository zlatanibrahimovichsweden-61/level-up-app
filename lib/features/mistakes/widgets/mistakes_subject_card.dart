import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/mistakes_subject.dart';

/// One cell of the Mistakes overview grid · Figma `404:6322` (light) /
/// `404:7637` (dark), both named "Container".
///
/// Deliberately NOT `SubjectCard`, and deliberately the same SHAPE as it. The
/// geometry is identical — 173 × 89 at radius 10.7, which is already what
/// `SubjectCard.aspectRatio` and `CatalogBlock`'s default radius carry — but the
/// content is not: a pink ground instead of the catalog surface, a red count
/// instead of a progress bar, no `questionCounter` anywhere, because this
/// tree has none at any level, and a large chevron on the card's middle where
/// the Subjects card has a small one on the title's line (`135:626`).
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

  /// Figma card 173 × 89. The FLOOR, not the height: the card grows with its
  /// text, and the overview gives a row its taller card (BUG-002, API→UI
  /// Wave 15). At 89 an Arabic card overflowed from text scale 1.3, and every
  /// card at 2.0.
  static const minHeight = 89.0;

  // The frame's text block is placed absolutely (`404:6325`, 9 in, 24.61
  // down), and its line boxes are Figma's: 14.85 for a 16 title and 10.62
  // for a 14 count, both smaller than their glyphs (#68). The build's lines
  // are the scale's (h3 24, labelLarge 18), so they are placed by the
  // frame's line CENTRES rather than its boxes:
  //   "Biology"      24.61 + 2.12 + 14.85 / 2                = 34.155
  //   "20 questions" 24.61 + 26.60 + 2.57 + 2.69 + 10.62 / 2 = 61.783
  // A centred block had them at 30.44 and 61.44: the title 3.7 high.
  static const _titleCentre = 24.606 + 2.122 + 14.854 / 2;
  static const _countCentre = 24.606 + 26.604 + 2.574 + 2.69 + 10.618 / 2;
  static const _titleLine = 24.0; // AppType.h3, 18 × 24/18
  static const _countLine = 18.0; // AppType.labelLarge, 14 × 18/14
  static const _start = 9.0;
  static const _top = _titleCentre - _titleLine / 2;
  static const _gap = _countCentre - _countLine / 2 - (_top + _titleLine);
  static const _bottom = minHeight - _countCentre - _countLine / 2;

  // The chevron (`404:6533`): a 13 × 27 box 148 in, so 12 from the end,
  // centred on the CARD 0.44 high (`top: calc(50% - 0.44px)`) rather than on
  // the title's line. The text stops where the box starts.
  static const _chevronWidth = 13.0;
  static const _chevronHeight = 27.0;
  static const _chevronEnd = 173 - 148 - _chevronWidth;
  static const _chevronLift = 0.44;
  static const _textEnd = 173 - 148.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final elevation = Theme.of(context).extension<AppElevation>()!;
    final rtl = Directionality.of(context) == TextDirection.rtl;

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
    //
    // `MergeSemantics` + `button: true`, the sibling `_MistakesButton`'s fix:
    // `ElevatedSurface` adds no semantics of its own and its `InkWell` gives
    // a tap ACTION, not the button FLAG. Without both, TalkBack read the name
    // and the count as two texts and never said "button" (API→UI Wave 15).
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: ElevatedSurface(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.7),
          ),
          color: ext.mistakesCardFill,
          shadows: elevation.mistakesCardShadows,
          glass: elevation.mistakesCardGlass,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: minHeight),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    _start,
                    _top,
                    _textEnd,
                    _bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        // Already in the content language (adr-018) —
                        // rendered verbatim, never looked up in the ARB.
                        subject.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        // Frame: Inter 700 / 16. `AppType` has no 16/700
                        // entry, and the scale is the designer's — extending
                        // it is not this day's call. Mapped to the nearest
                        // existing style by ROLE ("card titles, course
                        // names"), which is the ruling docs/DESIGN_ISSUES.md
                        // #57 already made for the review screen. Re-logged
                        // as #68, not re-derived.
                        style: AppType.h3.copyWith(color: ext.mistakesContent),
                      ),
                      const SizedBox(height: _gap),
                      Text(
                        // Rendered verbatim from the server. It is never
                        // summed, reconciled against a retake pool, or
                        // derived from anything — the contract sums and
                        // forbids the rest (adr-133).
                        l10n.mistakeCount(subject.mistakeCount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        // Frame: Cairo 600 / 14 at a 10.62px line height.
                        // Neither travels: Cairo is not in the design system
                        // and adding a second family on inference is the
                        // Wave-3D trap (#68), and a 10.62px line box on a
                        // 14px glyph clips its own descenders, which is a
                        // Figma artefact rather than intent.
                        style: AppType.labelLarge.copyWith(
                          color: ext.mistakesCount,
                        ),
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: 0,
                  bottom: 2 * _chevronLift,
                  end: _chevronEnd,
                  child: Center(
                    // The frame's `weui:arrow-filled`, which is the shared
                    // `chevron.svg` (it points right as drawn), stretched
                    // into the frame's 13 × 27 box. Not `forwardChevron`:
                    // that Material glyph drew 4.9 × 8 on the title's line
                    // where the frame draws 8 × 14.3 on the card's middle.
                    // `vector_graphics` derives an SVG's width from its
                    // height, so the box is filled rather than sized.
                    // Forward is left in Arabic: flipped, as
                    // `profile_menu_row.dart`'s chevron is.
                    child: Transform.flip(
                      flipX: rtl,
                      child: SizedBox(
                        key: const Key('mistakes_card_chevron'),
                        width: _chevronWidth,
                        height: _chevronHeight,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset(
                            'assets/icons/chevron.svg',
                            // The card's merged label names it; the glyph
                            // would add an image to it.
                            excludeFromSemantics: true,
                            colorFilter: ColorFilter.mode(
                              ext.mistakesCardChevron,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
