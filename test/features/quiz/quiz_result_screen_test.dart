import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_review_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';

import '../../core/visual_order.dart';
import 'quiz_fixtures.dart';
import 'quiz_harness.dart';
import 'package:level_up_app/features/quiz/widgets/ai_education_glyph.dart';

void main() {
  Future<QuizHarness> openResult(
    WidgetTester tester, {
    required QuizSummary summary,
    String scopeName = 'Cell Structure',
    String? subjectName,
    String locale = 'en',
    ThemeData? theme,
    QuizReviewArgs? review,
  }) async {
    final harness = await pumpQuizApp(tester, locale: locale, theme: theme);
    harness.router.push(
      '/quiz/quiz-1/result',
      extra: QuizResultArgs(
        summary: summary,
        scopeName: scopeName,
        subjectName: subjectName,
        review: review ?? quizReviewArgs(),
      ),
    );
    await tester.pumpAndSettle();
    return harness;
  }

  /// The result screen is taller than the 800x600 test viewport, so the
  /// bottom CTA has to be scrolled to before it can be tapped - exactly as a
  /// student would. Same helper, same reason, as `quiz_screen_test.dart`.
  ///
  /// It became necessary on 2026-09-20: the 33 dp star disc and the
  /// `TitledChrome` header together pushed "Review Questions" from y 559-619
  /// to y 570-630, so its CENTRE landed exactly on the viewport edge. On a
  /// 375 x 812 phone the whole screen still fits without scrolling.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // MANDATED TEST 2 — a partially-answered quiz.
  group('a PARTIALLY answered quiz', () {
    testWidgets('wrong is answeredCount - score, and Skipped is rendered', (
      tester,
    ) async {
      // 10 questions, 8 answered, 5 correct.
      // Correct 5 · Wrong 3 (8 - 5) · Skipped 2 (10 - 8).
      await openResult(tester, summary: quizSummary());

      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Wrong'), findsOneWidget);
      expect(find.text('Skipped'), findsOneWidget);

      expect(find.text('3'), findsOneWidget); // 8 answered - 5 correct
      expect(find.text('2'), findsOneWidget); // 10 total - 8 answered

      // Exactly ONE "5" on screen — the score. `totalQuestions - score` is
      // also 5, so the bug would put a second one in the Wrong card and this
      // assertion would fail. Rendering 5 wrong would call two questions the
      // student never reached mistakes.
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('the three buckets account for every question', (tester) async {
      final summary = quizSummary();
      await openResult(tester, summary: summary);

      expect(summary.score + summary.wrong + summary.skipped, 10);
      expect(summary.wrong, 3);
      expect(summary.skipped, 2);
    });

    testWidgets('a fully answered quiz renders NO Skipped card', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 7, totalQuestions: 10, answeredCount: 10),
      );

      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Wrong'), findsOneWidget);
      // The frame has two buckets; a third that always reads 0 is noise.
      expect(find.text('Skipped'), findsNothing);
    });

    testWidgets('a quiz abandoned after one question is still truthful', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(
          score: 1,
          totalQuestions: 10,
          answeredCount: 1,
          pointsAwarded: 1,
        ),
      );

      expect(find.text('Skipped'), findsOneWidget);
      expect(find.text('9'), findsOneWidget); // skipped
      expect(find.text('0'), findsOneWidget); // wrong — not 9
    });
  });

  group('what the frame draws but the contract cannot back', () {
    // CONFLICT 2 / S13.
    testWidgets('renders the percentage ring but NO Pass/Fail verdict', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('Pass'), findsNothing);
      expect(find.text('Fail'), findsNothing);
      expect(find.textContaining('Pass'), findsNothing);
    });

    // CONFLICT 3 / S14 is now NARROWED, not open: review-from-result shipped on
    // Day 8-9 with no endpoint at all. The live CTA is asserted in the
    // 'Review Questions' group below. What stays blocked on the draft
    // `GET /quizzes/{quizId}` is review from HISTORY, which has no entry point
    // on this screen to assert.

    // CONFLICT 1 / S12.
    testWidgets('points come from the server verbatim, never computed', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, pointsAwarded: 5),
      );

      // Two runs since API→UI Wave 13 (the frame's "+200" and "Points").
      expect(find.text('+5'), findsOneWidget);
      expect(find.text('Points'), findsOneWidget);
      // The design's figure for a 10-question quiz. The contract awards at most
      // one point per question, so it can never appear.
      expect(find.text('+200'), findsNothing);
      expect(find.text('+30'), findsNothing);
    });

    // 3.0.0-m1 (adr-102) / D-006: the summary no longer carries the student's
    // standing, and the frame draws no level number or points total.
    testWidgets('no level number or points total is rendered', (tester) async {
      await openResult(tester, summary: quizSummary(pointsAwarded: 5));

      expect(find.text('+5'), findsOneWidget);
      expect(find.text('Level Progress'), findsNothing);
      expect(find.textContaining('Level'), findsNothing);
      expect(find.textContaining(RegExp(r'\d+ points')), findsNothing);
    });

    testWidgets('with no subject in hand, the scope stands alone', (
      tester,
    ) async {
      // QuizSummary carries neither; both ride in from the launch. A cold deep
      // link to setup never had a subject, and nothing is guessed for it.
      await openResult(tester, summary: quizSummary());

      expect(find.text('Cell Structure'), findsOneWidget);
      expect(find.textContaining('—'), findsNothing);
    });
  });

  group('Review Questions', () {
    testWidgets('is LIVE and opens the review screen', (tester) async {
      // It shipped disabled behind a Tooltip until Day 8-9, on the reading that
      // review needed the draft `GET /quizzes/{quizId}`. It does not: the quiz
      // just finished is still in hand.
      final harness = await openResult(tester, summary: quizSummary());

      final cta = find.widgetWithText(FilledButton, 'Review Questions');
      expect(cta, findsOneWidget);
      expect(tester.widget<FilledButton>(cta).onPressed, isNotNull);
      expect(find.byType(Tooltip), findsNothing);
      expect(find.textContaining('coming soon'), findsNothing);

      await tapVisible(tester, cta);

      expect(find.byType(QuizReviewScreen), findsOneWidget);
      expect(harness.router.state.uri.path, '/quiz/quiz-1/result/review');
    });

    testWidgets('review is pushed, so Back returns to the result', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      await tapVisible(
        tester,
        find.widgetWithText(FilledButton, 'Review Questions'),
      );
      expect(find.byType(QuizReviewScreen), findsOneWidget);

      // The back chip, not a Material arrow: all three screens in this flow
      // moved onto the shared `TitledChrome` header on 2026-09-20
      // (owner ruling, DESIGN_ISSUES #82).
      await tester.tap(find.byType(CircleBackButton));
      await tester.pumpAndSettle();

      // Back out of review lands on the result, NOT on Learn — the result's own
      // PopScope only governs the result screen's own Back.
      expect(find.byType(QuizReviewScreen), findsNothing);
      expect(find.byType(QuizResultScreen), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('Back leaves for Learn, never into the finished quiz', (
      tester,
    ) async {
      final harness = await openResult(tester, summary: quizSummary());

      await tester.tap(find.byType(CircleBackButton));
      await tester.pumpAndSettle();

      expect(find.byType(QuizResultScreen), findsNothing);
      expect(find.byType(QuizScreen), findsNothing);
      expect(
        harness.router.routerDelegate.currentConfiguration.uri.path,
        '/learn',
      );
    });
  });

  group('states matrix', () {
    testWidgets('Arabic (RTL)', (tester) async {
      await openResult(tester, summary: quizSummary(), locale: 'ar');

      expect(find.text('أنهيت الاختبار!'), findsOneWidget);
      expect(find.text('صحيحة'), findsOneWidget);
      expect(find.text('خاطئة'), findsOneWidget);
      expect(find.text('متروكة'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('صحيحة'))),
        TextDirection.rtl,
      );
    });

    testWidgets('dark theme', (tester) async {
      await openResult(tester, summary: quizSummary(), theme: AppTheme.dark);

      expect(find.text('Quiz Complete!'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('a zero-question quiz draws an empty ring, not a crash', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(
          score: 0,
          totalQuestions: 0,
          answeredCount: 0,
          pointsAwarded: 0,
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('Skipped'), findsNothing);
    });

    testWidgets('leveledUp and newBadge parse but celebrate nothing', (
      tester,
    ) async {
      // The contract goes to the trouble of telling us; the frame has no state
      // to render for either. Flagged in DESIGN_ISSUES rather than invented.
      await openResult(
        tester,
        summary: quizSummary(leveledUp: true, newBadge: true),
      );

      expect(find.textContaining('Level up'), findsNothing);
      expect(find.textContaining('Badge'), findsNothing);
      expect(find.text('Quiz Complete!'), findsOneWidget);
    });
  });

  // ------------------------------------------------------------ #15 / #16 ---
  group('the result cards are raised, not outlined', () {
    List<ElevatedSurface> surfaces(WidgetTester tester) => tester
        .widgetList<ElevatedSurface>(find.byType(ElevatedSurface))
        .toList();

    ElevatedSurface bucket(WidgetTester tester, String label) =>
        tester.widget<ElevatedSurface>(
          find
              .ancestor(
                of: find.text(label),
                matching: find.byType(ElevatedSurface),
              )
              .first,
        );

    testWidgets('light: every bucket has a shadow and no hairline', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      final e = AppTheme.light.extension<AppElevation>()!;
      for (final label in ['Correct', 'Wrong']) {
        final b = bucket(tester, label);
        expect(b.side, isNull, reason: label);
        expect(b.shadows, e.resultBucketShadows, reason: label);
        expect(b.shadows, isNotEmpty, reason: label);
        expect(b.glass, isNull, reason: label);
      }
    });

    testWidgets('dark: every bucket has Glass and NO shadow', (tester) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
        theme: AppTheme.dark,
      );

      final e = AppTheme.dark.extension<AppElevation>()!;
      for (final label in ['Correct', 'Wrong']) {
        final b = bucket(tester, label);
        // `337:6667` carries no shadow at all. The empty list is a reading.
        expect(b.shadows, isEmpty, reason: label);
        expect(b.glass, e.resultBucketGlass, reason: label);
        expect(b.glass, isNotNull, reason: label);
      }
    });

    testWidgets('the Skipped bucket takes the same treatment, and only '
        'appears when the quiz ended early', (tester) async {
      // 10 questions, 8 answered, 5 correct.
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 8, totalQuestions: 10),
      );
      final skipped = bucket(tester, 'Skipped');
      expect(
        skipped.shadows,
        AppTheme.light.extension<AppElevation>()!.resultBucketShadows,
      );
      expect(skipped.side, isNull);

      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );
      expect(find.text('Skipped'), findsNothing);
    });

    testWidgets('the rewards card is radius 15 and carries the star disc', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      final card = tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: find.text('REWARDS EARNED'),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );
      final radius = (card.shape as RoundedRectangleBorder).borderRadius
          .resolve(TextDirection.ltr);
      // 15, not the 16 every other card on this screen uses. It is read.
      expect(radius.topLeft.x, 15);
      expect(card.side, isNull);

      final disc = tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: svgAsset(_star),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );
      expect(disc.shape, isA<CircleBorder>());
      expect(disc.width, 33);
      expect(disc.height, 33);
      expect(
        disc.color,
        AppTheme.light.extension<AppColors>()!.resultStarDiscFill,
      );
    });

    testWidgets('dark: the rewards card takes G14 and the lavender '
        'back-light', (tester) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
        theme: AppTheme.dark,
      );

      final e = AppTheme.dark.extension<AppElevation>()!;
      final card = tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: find.text('REWARDS EARNED'),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );

      expect(card.glass, e.rewardsCardGlass);
      expect(card.backlights, [e.rewardsCardBacklight]);
      expect(card.shadows, isEmpty);
      // Every back-light in the file needs a frost to be seen through (R6).
      for (final s in surfaces(tester)) {
        if (s.backlights.isNotEmpty) expect(s.glass, isNotNull);
      }
    });

    testWidgets('the rewards row survives a large text scale without a hard '
        'overflow', (tester) async {
      // The 33 dp star disc replaced a 22 dp glyph, which cost the points
      // label 11 dp on a row that was ALREADY overflowing by 11 px at text
      // scale 1.3 - Android's largest standard font setting. Measured at
      // 375 x 812: 11 px before this wave, 22 px after it, 0 px once the label
      // became `Flexible`.
      //
      // Scales past 1.3 are here because RESPONSIVE.md tests at 1.3 and the
      // failure mode is a cliff, not a slope: it either wraps or it clips.
      await tester.binding.setSurfaceSize(const Size(375, 812));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final scale in [1.0, 1.3, 2.0, 3.0]) {
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) =>
            errors.add(details.exceptionAsString());

        await openResult(tester, summary: quizSummary(pointsAwarded: 200));
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        await tester.pumpAndSettle();

        FlutterError.onError = previous;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        expect(
          errors.where((e) => e.contains('overflow')),
          isEmpty,
          reason: 'text scale $scale overflowed',
        );
      }
    });

    testWidgets('D-006 still holds — no level, no points total, no meter', (
      tester,
    ) async {
      // The frame draws a Level Progress meter inside the very card this wave
      // rebuilt. Restyling a card is not a licence to put it back.
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      expect(find.textContaining('Level'), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });

  // -------------------------------------------------------------- 7.10a -----
  group('the Review Questions CTA wears the primary treatment', () {
    testWidgets('it is wrapped, and nothing else on the screen is', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      final cta = tester.widget<PrimaryCta>(
        find.ancestor(
          of: find.widgetWithText(FilledButton, 'Review Questions'),
          matching: find.byType(PrimaryCta),
        ),
      );
      expect(cta.tone, CtaTone.primary);
      // One treatment per screen. (The bare "Back to Learn" link that used to
      // sit under it is gone: API→UI Wave 13, owner ruling.)
      expect(find.byType(PrimaryCta), findsOneWidget);
    });
  });

  // ------------------------------------------------ API→UI Wave 13 -----
  group('Wave 13: the frames (159:1964 · 337:6628)', () {
    const header = Key('quiz_result_header');
    const ring = Key('quiz_result_ring');
    const pointsValue = Key('result_points_value');
    const pointsUnit = Key('result_points_unit');

    QuizSummary answeredAll() =>
        quizSummary(score: 5, answeredCount: 10, totalQuestions: 10);

    TextStyle styleOf(WidgetTester tester, Finder f) =>
        tester.widget<Text>(f).style!;

    Finder card(String label) => find
        .ancestor(of: find.text(label), matching: find.byType(ElevatedSurface))
        .first;

    ResultRingPainter painter(WidgetTester tester) =>
        tester.widget<CustomPaint>(find.byKey(ring)).painter!
            as ResultRingPainter;

    // ---------------------------------------------------------- W13-1 ---
    testWidgets('the subtitle is "Subject — Scope", inside the header, '
        '#4B675E', (tester) async {
      await openResult(tester, summary: quizSummary(), subjectName: 'Biology');

      final subtitle = find.text('Biology — Cell Structure');
      expect(
        find.descendant(of: find.byKey(header), matching: subtitle),
        findsOneWidget,
      );
      final style = styleOf(tester, subtitle);
      expect(style.color, const Color(0xFF4B675E));
      expect(style.fontSize, AppType.bodyMedium.fontSize);
      expect(style.fontWeight, AppType.bodyMedium.fontWeight);
      // The scope is drawn once, inside the line, not again below it.
      expect(find.text('Cell Structure'), findsNothing);
    });

    testWidgets('Arabic: the subject line reads الأحياء — الدرس الأول', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(),
        subjectName: 'الأحياء',
        scopeName: 'الدرس الأول',
        locale: 'ar',
      );

      expect(find.text('الأحياء — الدرس الأول'), findsOneWidget);
    });

    // ---------------------------------------------------------- W13-2 ---
    testWidgets('the header is the frame\'s block: 92 tall, closed by the '
        'rule, the chip centred on the title block', (tester) async {
      await openResult(tester, summary: quizSummary(), subjectName: 'Biology');

      final box = tester.widget<Container>(find.byKey(header));
      final rule =
          ((box.decoration! as BoxDecoration).border! as Border).bottom;
      expect(rule.color, const Color.fromRGBO(124, 58, 237, 0.1));
      expect(rule.width, 1.18);

      final r = tester.getRect(find.byKey(header));
      expect(r.height, moreOrLessEquals(92, epsilon: 0.01));
      final chip = tester.getRect(find.byType(CircleBackButton));
      expect(chip.left, moreOrLessEquals(21, epsilon: 0.01));
      // 20 down to a 52 dp title block, the 35 dp chip on its centre line.
      expect(chip.center.dy - r.top, moreOrLessEquals(46, epsilon: 0.01));

      expect(
        styleOf(tester, find.text('Quiz Complete!')).color,
        const Color(0xFF384F47),
      );
    });

    testWidgets('dark: title #FCFBF9, subtitle #EEEEEE, same rule', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(),
        subjectName: 'Biology',
        theme: AppTheme.dark,
      );

      expect(
        styleOf(tester, find.text('Quiz Complete!')).color,
        const Color(0xFFFCFBF9),
      );
      expect(
        styleOf(tester, find.text('Biology — Cell Structure')).color,
        const Color(0xFFEEEEEE),
      );
      final box = tester.widget<Container>(find.byKey(header));
      expect(
        ((box.decoration! as BoxDecoration).border! as Border).bottom.color,
        const Color.fromRGBO(124, 58, 237, 0.1),
      );
    });

    // ---------------------------------------------------------- W13-3 ---
    testWidgets('the rhythm: rule → ring 18.18, then 25 · 25 · 25', (
      tester,
    ) async {
      await openResult(tester, summary: answeredAll());

      final h = tester.getRect(find.byKey(header));
      final ringRect = tester.getRect(find.byKey(ring));
      final bucket = tester.getRect(card('Correct'));
      final rewards = tester.getRect(card('REWARDS EARNED'));
      final cta = tester.getRect(find.byType(PrimaryCta));

      expect(ringRect.top - h.bottom, moreOrLessEquals(18.18, epsilon: 0.01));
      expect(ringRect.size, const Size(192, 192));
      expect(bucket.top - ringRect.bottom, moreOrLessEquals(25, epsilon: 0.01));
      expect(rewards.top - bucket.bottom, moreOrLessEquals(25, epsilon: 0.01));
      expect(cta.top - rewards.bottom, moreOrLessEquals(25, epsilon: 0.01));
    });

    // ---------------------------------------------------------- W13-4 ---
    testWidgets('the ring: stroke 9.85 on the track, anticlockwise from 12, '
        'the lavender gradient; the figure #3D3D3D', (tester) async {
      await openResult(tester, summary: answeredAll());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      final p = painter(tester);
      expect(p.fraction, 0.5);
      expect(p.strokeWidth, moreOrLessEquals(9.846, epsilon: 0.001));
      expect(p.trackColor, const Color(0xFFECECEC));
      expect(p.fillFrom, const Color(0xFFAE87E7));
      expect(p.fillTo, const Color(0xFF7070A0));
      // Anticlockwise (owner ruling): a negative sweep of half a turn.
      expect(p.sweepAngle, moreOrLessEquals(-math.pi, epsilon: 1e-9));

      final figure = styleOf(tester, find.text('50%'));
      expect(figure.color, const Color(0xFF3D3D3D));
      // 64 ExtraBold in the frame; the scale's largest style stays (ruling).
      expect(figure.fontSize, AppType.displayLarge.fontSize);
    });

    testWidgets('dark: the #2E2D32 track, the same gradient, a cream figure', (
      tester,
    ) async {
      await openResult(tester, summary: answeredAll(), theme: AppTheme.dark);

      final p = painter(tester);
      expect(p.trackColor, const Color(0xFF2E2D32));
      expect(p.fillFrom, const Color(0xFFAE87E7));
      expect(p.fillTo, const Color(0xFF7070A0));
      expect(styleOf(tester, find.text('50%')).color, const Color(0xFFFCFBF9));
    });

    testWidgets(
      'Arabic: still anticlockwise (owner ruling: a dial, not text)',
      (tester) async {
        await openResult(tester, summary: answeredAll(), locale: 'ar');

        expect(
          painter(tester).sweepAngle,
          moreOrLessEquals(-math.pi, epsilon: 1e-9),
        );
      },
    );

    // ---------------------------------------------------------- W13-5 ---
    testWidgets('buckets: padding 12, a 28 badge with a 14 glyph, 8 · 8, the '
        'label h3 #384F47', (tester) async {
      await openResult(tester, summary: answeredAll());

      final c = tester.getRect(card('Correct'));
      final badge = find.descendant(
        of: card('Correct'),
        matching: find.byKey(const Key('result_bucket_badge')),
      );
      final b = tester.getRect(badge);
      expect(b.size, const Size(28, 28));
      expect(b.top - c.top, moreOrLessEquals(12, epsilon: 0.01));
      expect(
        tester
            .widget<Icon>(
              find.descendant(of: badge, matching: find.byType(Icon)),
            )
            .size,
        14,
      );

      final number = tester.getRect(
        find.descendant(of: card('Correct'), matching: find.text('5')),
      );
      final label = find.descendant(
        of: card('Correct'),
        matching: find.text('Correct'),
      );
      expect(number.top - b.bottom, moreOrLessEquals(8, epsilon: 0.01));
      expect(
        tester.getRect(label).top - number.bottom,
        moreOrLessEquals(8, epsilon: 0.01),
      );
      expect(
        c.bottom - tester.getRect(label).bottom,
        moreOrLessEquals(12, epsilon: 0.01),
      );

      final style = styleOf(tester, label);
      expect(style.color, const Color(0xFF384F47));
      expect(style.fontSize, AppType.h3.fontSize);
      expect(style.fontWeight, AppType.h3.fontWeight);
    });

    testWidgets('dark: the bucket label is cream', (tester) async {
      await openResult(tester, summary: answeredAll(), theme: AppTheme.dark);

      expect(
        styleOf(tester, find.text('Wrong')).color,
        const Color(0xFFFCFBF9),
      );
    });

    // ---------------------------------------------------------- W13-6 ---
    testWidgets('rewards: a lavender bodyMedium title, the frame\'s star, '
        'gap 10, and two runs', (tester) async {
      await openResult(
        tester,
        summary: quizSummary(
          score: 5,
          answeredCount: 10,
          totalQuestions: 10,
          pointsAwarded: 5,
        ),
      );

      final titleFinder = find.text('REWARDS EARNED');
      final title = styleOf(tester, titleFinder);
      expect(title.color, const Color(0xFFAE87E7));
      expect(title.fontSize, AppType.bodyMedium.fontSize);
      expect(title.fontWeight, AppType.bodyMedium.fontWeight);

      // The card's own inset: 13 in from the start, 15 down, 16 to the row.
      final cardRect = tester.getRect(card('REWARDS EARNED'));
      final t = tester.getRect(titleFinder);
      expect(t.left - cardRect.left, moreOrLessEquals(13, epsilon: 0.01));
      expect(t.top - cardRect.top, moreOrLessEquals(15, epsilon: 0.01));

      expect(find.byIcon(Icons.star), findsNothing);
      final star = tester.widget<SvgPicture>(svgAsset(_star));
      expect(star.width, moreOrLessEquals(19.437, epsilon: 0.001));
      expect(
        star.colorFilter,
        const ColorFilter.mode(Color(0xFF7070A0), BlendMode.srcIn),
      );
      final disc = tester.getRect(
        find
            .ancestor(
              of: svgAsset(_star),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );
      expect(disc.top - t.bottom, moreOrLessEquals(16, epsilon: 0.01));

      final value = find.byKey(pointsValue);
      final unit = find.byKey(pointsUnit);
      expect(tester.widget<Text>(value).data, '+5');
      expect(tester.widget<Text>(unit).data, 'Points');
      final v = styleOf(tester, value);
      expect(v.color, const Color(0xFFAE87E7));
      expect(v.fontSize, AppType.h2.fontSize);
      expect(v.fontWeight, AppType.h2.fontWeight);
      final u = styleOf(tester, unit);
      expect(u.color, const Color(0xFF010101));
      expect(u.fontSize, AppType.bodyLarge.fontSize);
      expect(u.fontWeight, AppType.bodyLarge.fontWeight);

      expect(
        tester.getRect(value).left - disc.right,
        moreOrLessEquals(10, epsilon: 0.01),
      );
      expect(
        tester.getRect(unit).left - tester.getRect(value).right,
        moreOrLessEquals(10, epsilon: 0.01),
      );

      // TalkBack still hears the one phrase.
      expect(
        tester.getSemantics(find.byKey(const Key('result_points'))),
        isSemantics(label: '+5 Points'),
      );
    });

    testWidgets('dark: the "Points" run is cream, the rest stays lavender', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(pointsAwarded: 5),
        theme: AppTheme.dark,
      );

      expect(
        styleOf(tester, find.byKey(pointsUnit)).color,
        const Color(0xFFFCFBF9),
      );
      expect(
        styleOf(tester, find.byKey(pointsValue)).color,
        const Color(0xFFAE87E7),
      );
      expect(
        styleOf(tester, find.text('REWARDS EARNED')).color,
        const Color(0xFFAE87E7),
      );
      expect(
        tester.widget<SvgPicture>(svgAsset(_star)).colorFilter,
        const ColorFilter.mode(Color(0xFF7070A0), BlendMode.srcIn),
      );
    });

    testWidgets('Arabic: "+3" keeps its sign on the left (BUG-003)', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(pointsAwarded: 3),
        locale: 'ar',
      );

      final value = find.byKey(pointsValue);
      expect(tester.widget<Text>(value).data, '+3');
      // Painted order: the "+" (offset 0) to the LEFT of the "3" (offset 1).
      // The device drew "3+" before this (2026-09-20 tablet walk; Wave 13
      // baseline walk, x 847-873 vs 813-840).
      expect(
        glyphLeft(tester, value, 0),
        lessThan(glyphLeft(tester, value, 1)),
      );
      // And the word follows it in reading order: to its left in RTL.
      final unit = find.byKey(pointsUnit);
      expect(tester.widget<Text>(unit).data, 'نقطة');
      expect(
        tester.getRect(unit).right,
        lessThanOrEqualTo(tester.getRect(value).left),
      );
    });

    // ---------------------------------------------------------- W13-7 ---
    for (final dark in [false, true]) {
      testWidgets('${dark ? 'dark' : 'light'}: the CTA leads with the '
          'ai-education glyph in #FCFBF9, 10 before the label', (tester) async {
        await openResult(
          tester,
          summary: answeredAll(),
          theme: dark ? AppTheme.dark : null,
        );

        final button = find.widgetWithText(FilledButton, 'Review Questions');
        final icon = find.descendant(
          of: button,
          matching: svgAsset('assets/icons/ai_education.svg'),
        );
        expect(icon, findsOneWidget);
        final svg = tester.widget<SvgPicture>(icon);
        // #98 (owner ruling 2026-09-27): the frame's scale in its 26.55 box;
        // boxed into the square it drew at 1.062x.
        expect(svg.height, AiEducationGlyph.drawnHeight);
        expect(svg.width, isNull);
        expect(svg.excludeFromSemantics, isTrue);
        expect(
          svg.colorFilter,
          const ColorFilter.mode(Color(0xFFFCFBF9), BlendMode.srcIn),
        );
        final box = tester.getRect(
          find.descendant(of: button, matching: find.byType(AiEducationGlyph)),
        );
        expect(box.width, closeTo(26.55, 0.01));
        expect(box.height, closeTo(26.55, 0.01));
        expect(
          tester.getRect(find.text('Review Questions')).left - box.right,
          moreOrLessEquals(10, epsilon: 0.01),
        );
      });
    }

    // ---------------------------------------------------------- W13-8 ---
    testWidgets('no "Back to Learn" link: the frames draw one CTA (owner '
        'ruling)', (tester) async {
      await openResult(tester, summary: answeredAll());

      expect(find.text('Back to Learn'), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });
  });
}

const _star = 'assets/icons/result_star.svg';

Finder svgAsset(String asset) => find.byWidgetPredicate(
  (w) =>
      w is SvgPicture &&
      w.bytesLoader is SvgAssetLoader &&
      (w.bytesLoader as SvgAssetLoader).assetName == asset,
);
