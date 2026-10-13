import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_typography.dart';
import 'elevation/elevated_surface.dart';

// The chrome a study session shares: the quiz question screen (`159:845`) and
// the flashcards study screen (`225:5582`) draw the SAME header, close ✕, title
// style, progress row and previous-button pill — the two frames differ only in
// the progress FILL colour and in what sits between the header and the button
// row. So the chrome lives here, parameterised on exactly those differences,
// and each screen keeps its own body and action row.
//
// It was three private widgets in `quiz_screen.dart` and moved here unchanged
// (API→UI Wave 22) — except the previous pill's glyph, which was drawn at about
// half the frame's size and now takes it (see [StudyPreviousButton]). The token
// names keep their `quiz…` prefix (`quizHeaderRule`,
// `quizHeaderGlyph`, `quizProgressCounter`, `quizPrevButton…`): the flashcards
// frames were compared against the quiz's and every one of those values is
// identical, so renaming them would be churn, not a fix.

/// The session header · Figma `159:1224` (light) / `337:9202` (dark) for the
/// quiz, `225:5602` for flashcards.
///
/// Its own container rather than an `AppBar`, so it can be the frame's: the ✕
/// box 16 in and 16 down, the title centred on it, the progress row 12 under
/// it, and a 1.18 rule closing the header at 89.18. The app bar put the ✕ 3 dp
/// off both ways and the card 8 dp high, and drew no rule (API→UI Wave 12).
///
/// The frame's three trailing icons are deliberately absent. Bookmark
/// (`295:3108`) and share (`295:3110`): all three favourite endpoints are
/// `draft` and there is no sharing story or endpoint at all; `isFavorite` is
/// parsed into the model regardless (seif_fight S11). The AI "sparkle-cap"
/// (`295:3103`): owner ruling 2026-09-26 — the frame shows it before the
/// question is answered, which the contract forbids, and after grading it
/// would only duplicate the panel's "Show explanation" (DESIGN_ISSUES #95). The
/// flashcards frame draws the bookmark and share glyphs too (`503:6807`,
/// `503:6811`) and they are absent for the same reasons.
///
/// The ✕ is a close, not a back: [onClose] is expected to end the session (the
/// quiz asks first, because its progress is in memory and cannot be reopened).
///
/// The title is centred, as the quiz's is. The flashcards frame's sits 26.5 dp
/// left of the screen centre (`225:5607`), which reads as a side effect of its
/// `SPACE_BETWEEN` row rather than intent; centring it is the quiz's behaviour
/// carried over unchanged, and worth confirming with the designer.
class StudySessionHeader extends StatelessWidget {
  const StudySessionHeader({
    super.key,
    required this.title,
    required this.onClose,
    required this.position,
    required this.total,
    required this.progressFill,
    this.headerKey,
    this.closeKey,
    this.showCounter = true,
  });

  /// The screen title, already localised ("Quiz", "Flashcards"). Ellipsised on
  /// one line, clear of the ✕ on both sides.
  final String title;

  /// Tapping the ✕.
  final VoidCallback onClose;

  /// 1-based position for the `n/total` counter and the bar's value.
  final int position;

  /// The denominator: what was DELIVERED, not what was requested. The bar is
  /// empty (not an error) when it is 0 or less.
  final int total;

  /// The bar's FILL — the one colour the two frames disagree on. The quiz
  /// passes `AppColors.quizProgressFill`, flashcards
  /// `AppColors.flashcardProgressFill`.
  final Color progressFill;

  /// Put on the header's `Container` (not on this widget), because the quiz's
  /// tests read the container's decoration and rect by this key.
  final Key? headerKey;

  /// Put on the ✕'s `IconButton`.
  final Key? closeKey;

  /// False while there is no denominator yet (a round still loading): the
  /// header keeps its height and its empty track, and the `n/total` counter is
  /// simply not drawn, rather than reading a made-up "0/0".
  final bool showCounter;

  /// The frame's ✕ box (`159:1227`).
  static const _glyph = 30.0;

  /// Android's minimum touch target, kept, and centred on the ✕ box.
  static const _target = 48.0;

  /// How far the target reaches past the box on each side: 9.
  static const _overhang = (_target - _glyph) / 2;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      key: headerKey,
      // The frame's 16, less the target's overhang, so the box lands 16 in and
      // 16 down. The same at the end, which keeps the title on the screen's
      // centre line. 12 at the bottom: Container adds the rule's 1.18 to its
      // padding, and 12 + 1.18 is the frame's 13.18.
      padding: const EdgeInsetsDirectional.fromSTEB(
        16 - _overhang,
        16 - _overhang,
        16 - _overhang,
        12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ext.quizHeaderRule, width: 1.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _target,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  // Clear of the ✕ target on BOTH sides, so the title stays
                  // centred and a long one ellipsises instead of running
                  // under it.
                  padding: const EdgeInsets.symmetric(horizontal: _target),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // The frame sets Inter 600/22; the type scale has no 22,
                    // so this is the app's screen title (h2), as on every
                    // other title bar.
                    style: AppType.h2.copyWith(color: ext.textPrimary),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  child: IconButton(
                    key: closeKey,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: _target,
                      height: _target,
                    ),
                    // Framework-localised ("Close" / "إغلاق"), the name
                    // Material's own CloseButton carries.
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: onClose,
                    // The frame's own cross: 15 dp of 1.67 stroke, round
                    // caps. `Icons.close` was 14 dp of a heavier, square
                    // stroke, in #0E0E0E.
                    icon: SvgPicture.asset(
                      'assets/icons/quiz_close.svg',
                      width: _glyph,
                      height: _glyph,
                      // The tooltip names the button. Without this the
                      // glyph's own image semantics merge in and TalkBack
                      // reads an ImageView (W11-7).
                      excludeFromSemantics: true,
                      colorFilter: ColorFilter.mode(
                        ext.quizHeaderGlyph,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 12 under the box in the frame, less the target's overhang.
          const SizedBox(height: 12 - _overhang),
          StudyProgressBar(
            position: position,
            total: total,
            fill: progressFill,
            showCounter: showCounter,
          ),
        ],
      ),
    );
  }
}

/// Thin progress bar + `n/total` counter · Figma `308:5264` / `348:7709` for
/// the quiz, `225:5613` for flashcards.
///
/// The counter reads `AppLocalizations.quizProgress`, which is a bare
/// `{position}/{total}` — the flashcards frame draws the same "1/10".
class StudyProgressBar extends StatelessWidget {
  const StudyProgressBar({
    super.key,
    required this.position,
    required this.total,
    required this.fill,
    this.showCounter = true,
  });

  /// 1-based.
  final int position;

  /// The denominator — what was DELIVERED, so a short pool shows 1/7, not
  /// 1/10. 0 or less draws an empty bar.
  final int total;

  /// The bar's FILL; the track and the counter are the same in both frames.
  final Color fill;

  /// False draws the track alone, with no counter and no gap for one.
  final bool showCounter;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      // 20 from both screen edges, the frame's 362-wide row: the header's own
      // 7 plus 13.
      padding: const EdgeInsets.symmetric(horizontal: 20 - 7),
      child: ConstrainedBox(
        // The frame's row is its counter's 18 dp line; the bar is centred on
        // it. 18 is the row's FLOOR, not its height: the counter is
        // `captionSmall` (10/14), whose line grows with the text scale (28 at
        // 2.0x), and a fixed box clamped the paragraph while its glyphs kept
        // their natural size, off the bar's centre and over the header's rule.
        // Identical at the default scale.
        constraints: const BoxConstraints(minHeight: 18),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(52),
                child: LinearProgressIndicator(
                  value: total <= 0
                      ? 0
                      : (position / total).clamp(0, 1).toDouble(),
                  minHeight: 8,
                  backgroundColor: ext.progressTrack,
                  valueColor: AlwaysStoppedAnimation(fill),
                ),
              ),
            ),
            if (showCounter) ...[
              const SizedBox(width: 12),
              Text(
                l10n.quizProgress(position, total),
                style: AppType.captionSmall.copyWith(
                  color: ext.quizProgressCounter,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The previous-card pill · Figma `159:1920` (light) / `337:6464` (dark) for
/// the quiz, `225:5622` for flashcards.
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
/// `CircleBackButton` mirrors it: the asset points RIGHT, so "back" is its
/// flip in LTR and its unflipped self in RTL. Its colour was read in both
/// canvases - `159:1922` and `337:6466` both say cream. It is drawn at the
/// frame's 27 x 54 arrow box (`225:5623`), 4 dp under the pill's top; the quiz's
/// frame draws the same button, so the quiz's "<" takes the frame's size too.
///
/// Whether the pill is drawn at all is the CALLER's call: the quiz omits it on
/// the first question (and its 15 dp spacer with it) so the primary button
/// takes the whole row. This widget only knows enabled or in-flight.
class StudyPreviousButton extends StatelessWidget {
  const StudyPreviousButton({super.key, required this.onPressed});

  /// Null while something is in flight: the pill is dimmed to 0.45, reads as
  /// disabled to a screen reader, and has no ripple or tap target.
  final VoidCallback? onPressed;

  static const _width = 79.0;
  static const _height = 58.0;

  /// The frame's arrow box (`225:5623`, 27 x 54): `chevron.svg`'s 15 x 30
  /// viewBox at 1.8x, which draws the glyph at the frame's 16.57 x 28.64. It
  /// sits 4 dp under the pill's top and centred across it (x 26 in 79). The
  /// figures 16.57 x 28.64 are the GLYPH inside the asset (`225:5624`), not the
  /// box: sizing the asset to them drew the arrow at about half the frame's.
  static const _chevronWidth = 27.0;
  static const _chevronHeight = 54.0;
  static const _chevronTop = 4.0;

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
      // `previousPageTooltip`, NOT `backButtonTooltip`. These screens already
      // have a control that means "back" - the ✕ in the header, which LEAVES
      // the session - so announcing this one as "Back" would give a screen
      // reader two buttons with the same name and very different consequences.
      // Both strings are framework-localised, so neither needs an ARB entry.
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
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: _chevronTop),
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
      ),
    );
  }
}
