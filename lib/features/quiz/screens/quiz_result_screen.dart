import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../l10n/app_localizations.dart';
import '../models/quiz_summary.dart';
import 'quiz_screen.dart' show QuizResultArgs;
import '../widgets/ai_education_glyph.dart';

/// `/quiz/:quizId/result` · Figma `159:1964` (school) / `309:6375`
/// (university), dark `337:6628` / `349:14522`. The university frames equal
/// the school ones value for value.
///
/// Renders [QuizSummary] and nothing else. Every number on this screen came
/// from `POST /quizzes/{quizId}/finish`; the only arithmetic is bucket
/// derivation the contract explicitly enables (`wrong` and `skipped`) and the
/// ring's fraction, which cannot be drawn without dividing two server integers.
///
/// **Things the frame draws that are deliberately different:**
/// - **No "Pass".** The ring reads `50%` and the frame writes `Pass` under it.
///   There is no pass threshold anywhere in the contract, so the word is
///   omitted rather than guessed. seif_fight S13.
/// - **A third Skipped figure**, when `answeredCount < totalQuestions`. The
///   frame has two buckets and nowhere to put unanswered questions, which the
///   contract records as unanswered — *not* wrong (DESIGN_ISSUES #29).
/// - **No level number, points total or Level Progress meter.** Contract
///   3.0.0-m1 (adr-102) removed `totalPoints` and `level` from the summary —
///   they are state, read from `GET /me` — and the owner ruled the element out
///   (D-006, DESIGN_ISSUES #50).
/// - **Type sizes stay on the scale** where the frame goes past it: the
///   figure's 64 ExtraBold (owner ruling, DESIGN_ISSUES #97), the numbers'
///   Cairo 22, the rewards runs' 19.45 and the CTA's 22.
///
/// "Review Questions" is live: reviewing the quiz JUST finished needs no
/// endpoint, because its questions and grades ride here on `args.review`.
///
/// `leveledUp` and `newBadge` are parsed and not celebrated: the frame has no
/// level-up or badge state to render. Flagged in docs/DESIGN_ISSUES.md.
class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key, required this.args});

  final QuizResultArgs args;

  /// `159:2354` / `159:2344`: 25 between the ring, the buckets, the rewards
  /// card and the CTA.
  static const _gap = 25.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);
    final summary = args.summary;

    return PopScope(
      // The quiz behind this screen is finished and cannot be re-entered. Back
      // goes to Learn, never into a closed session.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                // Both names are server copy (adr-018), rendered verbatim. The
                // scope rode in from the `Quiz` the session was built from; the
                // subject from the Learn stack, via setup (API→UI Wave 13).
                // A cold deep link to setup had no subject: the scope alone.
                subtitle: switch (args.subjectName) {
                  final subject? => l10n.quizResultSubtitle(
                    subject,
                    args.scopeName,
                  ),
                  null => args.scopeName,
                },
                // NOT `maybePop`: the finished quiz and its setup screen are
                // both still on the stack, and `_leave` is what steps over
                // them. Same reason the `PopScope` above intercepts.
                onBack: () => _leave(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  // 18.18 under the rule: the ring group (`159:2241`) starts
                  // at 154.18 under a header that ends at 136.
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    20,
                    18.18,
                    20,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PercentageRing(summary: summary),
                      const SizedBox(height: _gap),

                      // Two buckets, or three when the student finished early.
                      Row(
                        children: [
                          Expanded(
                            child: _ScoreCard(
                              icon: Icons.check,
                              badgeColor: ext.successBadge,
                              value: summary.score,
                              label: l10n.resultCorrect,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ScoreCard(
                              icon: Icons.close,
                              badgeColor: ext.quizWrongBadge,
                              // answeredCount - score. NOT totalQuestions -
                              // score: questions the student never reached are
                              // skipped, and calling them mistakes would be a
                              // lie.
                              value: summary.wrong,
                              label: l10n.resultWrong,
                            ),
                          ),
                          if (summary.skipped > 0) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ScoreCard(
                                icon: Icons.remove,
                                badgeColor: ext.mutedText,
                                value: summary.skipped,
                                label: l10n.resultSkipped,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: _gap),
                      _RewardsCard(summary: summary),
                      const SizedBox(height: _gap),

                      // The only exit besides the back chip. The frames draw
                      // no "Back to Learn" link under it; the one the app drew
                      // is gone (owner ruling, API→UI Wave 13).
                      PrimaryCta(
                        child: FilledButton(
                          // Reviewing the quiz JUST FINISHED needs no endpoint
                          // — the questions and their grades are already in
                          // hand, carried here on `args.review`. Reviewing from
                          // HISTORY still needs `GET /quizzes/{quizId}`, which
                          // is draft; seif_fight S14 was narrowed, not closed.
                          onPressed: () => context.push(
                            '/quiz/${summary.quizId}/result/review',
                            extra: args.review,
                          ),
                          // `159:2345`: the `tdesign:ai-education` glyph
                          // (`159:2348`), 10 before the label. The same drawing
                          // the AI panel and the review rows ship, in the
                          // label's own colour; the label names the button.
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AiEducationGlyph(
                                color: theme.colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 10),
                              Flexible(child: Text(l10n.reviewQuestions)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// `go`, not `pop`: the setup screen and the finished quiz are both still on
  /// the stack, and neither is somewhere a student should land after finishing.
  void _leave(BuildContext context) => context.go('/learn');
}

/// The header block · Figma `159:2246` (light) / `337:6656` (dark).
///
/// The frame's own container rather than the shared `TitledChrome`, because
/// this one holds two lines: "Quiz Complete!" over "Subject — Scope", the
/// back chip centred on the pair, and a 1.18 rule closing the block at 92
/// (API→UI Wave 13). The frame's row also puts the pair 73 after the chip,
/// which lands it ~11 dp right of the screen's centre line; the pair is
/// centred here, as every other title in the app is.
class _Header extends StatelessWidget {
  const _Header({required this.subtitle, required this.onBack});

  final String subtitle;
  final VoidCallback onBack;

  /// `162:2376` starts 20 under the status bar and 21 in from the edge.
  static const _top = 20.0;
  static const _start = 21.0;

  /// The title (31) and subtitle (21) boxes of `162:2375`. A floor, not a
  /// height, so a larger text scale grows the header instead of clipping it.
  static const _block = 52.0;

  static const _rule = 1.18;
  static const _height = 92.0;

  /// Clear of the 35 dp chip on BOTH sides, so the pair stays centred.
  static const _inset = 35.0 + 8;

  /// The chip's padded 48 box reaches this far past it (O-15). The side
  /// insets give it back and the pair's inset takes it, so nothing moves; the
  /// 52 block already holds the box's height.
  static const _slop = CircleBackButton.tapSlop;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      key: const Key('quiz_result_header'),
      // Container adds the rule's width to its padding, so the bottom padding
      // is what is left of the frame's 92.
      padding: const EdgeInsetsDirectional.fromSTEB(
        _start - _slop,
        _top,
        _start - _slop,
        _height - _top - _block - _rule,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ext.quizHeaderRule, width: _rule),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _block),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _inset + _slop),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.quizCompleteTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    // The frame sets Inter 700/22; the scale has no 22, so this
                    // is the app's screen title (h2), as on every title bar.
                    style: AppType.h2.copyWith(color: ext.quizResultTitle),
                  ),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppType.bodyMedium.copyWith(
                      color: ext.quizResultSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 0,
              child: CircleBackButton(
                // A test leaves the screen the way a student does. On the
                // drawn chip, not the 48 box around it (O-15).
                chipKey: const Key('quiz_result_back'),
                tapTargetSize: MaterialTapTargetSize.padded,
                onPressed: onBack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The percentage ring · Figma `159:2241` / `337:6649`. Score over total, no
/// verdict.
class _PercentageRing extends StatelessWidget {
  const _PercentageRing({required this.summary});

  final QuizSummary summary;

  /// The group's 192 box, which is the ring's OUTER edge.
  static const _size = 192.0;

  /// The track in the SVG export runs from radius 86.154 to 96.
  static const _stroke = 96 - 86.154;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: SizedBox.square(
        dimension: _size,
        child: CustomPaint(
          key: const Key('quiz_result_ring'),
          painter: ResultRingPainter(
            fraction: summary.fraction,
            strokeWidth: _stroke,
            trackColor: ext.progressTrack,
            fillFrom: ext.resultRingFillFrom,
            fillTo: ext.resultRingFillTo,
          ),
          child: Center(
            child: Text(
              // Latin digits in Arabic too, consistent with every other number
              // in the app (the Home counters, the catalog's `{answered} /
              // {total}`). Arabic-Indic digits are a project-wide migration
              // tracked as docs/DESIGN_ISSUES.md #19 — doing it for this one
              // string would make the result screen inconsistent with itself.
              '${(summary.fraction * 100).round()}%',
              // The frame's figure is Inter 800/64, past the top of the scale:
              // the scale's largest stays (owner ruling, DESIGN_ISSUES #97).
              style: AppType.displayLarge.copyWith(
                color: ext.resultPercentText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the score ring as the frames' SVG export draws it (`159:2240`,
/// `337:6650`): a full track, and over it an arc from 12 o'clock with round
/// caps, filled with the export's radial gradient.
///
/// **Anticlockwise, in both languages** (owner ruling 2026-09-26): the frame
/// fills the left half at 50%. A dial is not text, so Arabic does not mirror
/// it. Material's `CircularProgressIndicator` goes clockwise and has no
/// gradient, which is why this is a painter.
///
/// The gradient is the export's own, not an approximation: `radialGradient`
/// centred on the ring, `rotate(-162.326) scale(154.807 854.217)` in the
/// frame's 192-unit space, `#AE87E7` at 0.1439 to `#7070A0` at 1. It is scaled
/// with the ring, so the colours land where the frame puts them.
@visibleForTesting
class ResultRingPainter extends CustomPainter {
  const ResultRingPainter({
    required this.fraction,
    required this.strokeWidth,
    required this.trackColor,
    required this.fillFrom,
    required this.fillTo,
  });

  /// Score over total, 0..1, from the server's two integers.
  final double fraction;
  final double strokeWidth;
  final Color trackColor;
  final Color fillFrom;
  final Color fillTo;

  /// The arc's sweep in radians. Negative: anticlockwise, on a canvas where a
  /// positive sweep turns clockwise.
  double get sweepAngle => -2 * math.pi * fraction.clamp(0.0, 1.0);

  static const _frame = 192.0;
  static const _gradientDegrees = -162.326;
  static const _gradientScaleX = 154.807;
  static const _gradientScaleY = 854.217;
  static const _innerStop = 0.143906;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = trackColor,
    );
    if (sweepAngle == 0) return;

    final k = size.shortestSide / _frame;
    final gradientSpace = Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..rotateZ(_gradientDegrees * math.pi / 180)
      ..scaleByDouble(_gradientScaleX * k, _gradientScaleY * k, 1, 1);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.radial(
          Offset.zero,
          1,
          [fillFrom, fillTo],
          const [_innerStop, 1],
          TileMode.clamp,
          gradientSpace.storage,
        ),
    );
  }

  @override
  bool shouldRepaint(ResultRingPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.fillFrom != fillFrom ||
      oldDelegate.fillTo != fillTo;
}

/// One bucket · Figma `159:2289` (light) / `337:6667` (dark).
///
/// 175.5 x 118 at radius 16, and **no border in either frame**. Padding 12 on
/// every side, 8 between the badge, the number and the label (API→UI Wave 13;
/// it was 16 top and bottom, 8 then 4).
///
/// Light elevates with a tight black shadow; dark carries no shadow at all
/// and elevates with G5 Glass over a 20% fill instead (edit1.md R1). The
/// third "Skipped" bucket, which the frame never draws, takes the same
/// treatment as the two it does - DESIGN_ISSUES #29 covers its existence.
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.icon,
    required this.badgeColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color badgeColor;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return ElevatedSurface(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsetsDirectional.all(12),
      color: ext.resultCardFill,
      shadows: elevation.resultBucketShadows,
      glass: elevation.resultBucketGlass,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // `159:2312`: 27.994 with a 14 glyph. Its 1.18 stroke is the fill's
          // own colour, so it draws nothing and is not drawn.
          Container(
            key: const Key('result_bucket_badge'),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 8),
          Text('$value', style: AppType.h2.copyWith(color: badgeColor)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            // Inter 600/18 in the frame: exactly h3.
            style: AppType.h3.copyWith(color: ext.resultBucketLabel),
          ),
        ],
      ),
    );
  }
}

/// REWARDS EARNED · Figma `159:2252` (light) / `337:6680` (dark).
///
/// 363 wide at radius **15** - not the 16 every other card on this screen
/// uses, and not a typo in the frame; it is read. No border in either
/// canvas. Dark adds G14 (a frostier G5) plus back-light B6, the lavender
/// ellipse that reads as a haze at the card's top-start corner.
///
/// The frame's card is a fixed 138 because it also holds a Level Progress
/// meter. That meter is deliberately absent: `QuizSummary` stopped carrying
/// `level` and `totalPoints` at contract 3.0.0-m1, and the owner ruled the
/// element out rather than refetching state to draw it (D-006, DESIGN_ISSUES
/// #50). Without it the card hugs its content.
class _RewardsCard extends StatelessWidget {
  const _RewardsCard({required this.summary});

  final QuizSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    final l10n = AppLocalizations.of(context);
    final backlight = elevation.rewardsCardBacklight;

    return ElevatedSurface(
      width: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // `159:2256` sits 13 in and 3 down, and its column pads 12 more: the
      // title lands 13 from the start edge and 15 from the top.
      padding: const EdgeInsetsDirectional.fromSTEB(13, 15, 13, 15),
      color: ext.resultCardFill,
      shadows: elevation.rewardsCardShadows,
      glass: elevation.rewardsCardGlass,
      backlights: [?backlight],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rewardsEarned,
            // Inter 400/14 in the frame: exactly bodyMedium.
            style: AppType.bodyMedium.copyWith(color: ext.resultRewardsTitle),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // The star sits on its own 33 x 33 disc (`337:6685`): pale lilac
              // in light, a 20% neutral with its own G5 in dark. The glyph is
              // the frame's rounded star (`159:2331`), not Material's.
              _StarDisc(
                child: SvgPicture.asset(
                  'assets/icons/result_star.svg',
                  width: 19.437,
                  height: 19.437,
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(
                    ext.resultStarGlyph,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // `Flexible`, and deliberately WITHOUT an ellipsis: the one thing
              // on this row that must survive is the number, and an ellipsis
              // could eat its digits. The row hard-overflowed at text scale
              // 1.3 before it was Flexible; the two runs now wrap instead.
              Flexible(
                child: Semantics(
                  key: const Key('result_points'),
                  container: true,
                  // One phrase to TalkBack, as the line used to be.
                  label: l10n.pointsAwarded(summary.pointsAwarded),
                  excludeSemantics: true,
                  // `159:2333`: two runs, 10 apart - "+200" bold in the
                  // accent, "Points" regular in the plain ink.
                  child: Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        // Verbatim from the server. The app has no points
                        // formula and must never appear to: the design's
                        // "+200" is roughly 20x what the contract can award.
                        // seif_fight S12.
                        l10n.pointsAwardedValue(summary.pointsAwarded),
                        key: const Key('result_points_value'),
                        // A leading "+" takes the paragraph's direction, so in
                        // Arabic it painted after the digits: "3+" (BUG-003).
                        textDirection: TextDirection.ltr,
                        style: AppType.h2.copyWith(
                          color: ext.resultPointsValue,
                        ),
                      ),
                      Text(
                        l10n.pointsAwardedUnit,
                        key: const Key('result_points_unit'),
                        style: AppType.bodyLarge.copyWith(
                          color: ext.resultPointsUnit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The 33 x 33 disc behind the rewards star · Figma `337:6685`.
///
/// A circle, which is why the radius is not a number here: `CircleBorder`
/// cannot drift the way a hand-written 16.5 could.
class _StarDisc extends StatelessWidget {
  const _StarDisc({required this.child});

  final Widget child;

  static const _diameter = 33.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return ElevatedSurface(
      shape: const CircleBorder(),
      width: _diameter,
      height: _diameter,
      color: ext.resultStarDiscFill,
      glass: elevation.resultStarDiscGlass,
      child: Center(child: child),
    );
  }
}
