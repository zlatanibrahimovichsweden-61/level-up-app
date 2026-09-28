import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/widgets/limit_sheet.dart';
import 'package:mocktail/mocktail.dart';

import 'quiz_fixtures.dart';
import 'quiz_harness.dart';

const _schoolArgs = QuizSetupArgs.lesson(
  lessonId: 'lesson-9',
  scopeName: 'Cell Membrane',
);

const _universityArgs = QuizSetupArgs.lecture(
  lectureId: 'lecture-4',
  scopeName: 'Lecture 4 — The Thorax',
  quizType: QuizType.finalRevision,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_schoolArgs);
    registerFallbackValue(QuizLength.thirty);
    registerFallbackValue(QuizMode.normal);
  });

  Future<QuizHarness> openSetup(
    WidgetTester tester, {
    QuizSetupArgs args = _schoolArgs,
    MockQuizRepository? quiz,
    String locale = 'en',
    ThemeData? theme,
    bool online = true,
  }) async {
    final harness = await pumpQuizApp(
      tester,
      quiz: quiz,
      locale: locale,
      theme: theme,
      online: online,
    );
    harness.router.push('/quiz/setup', extra: args);
    await tester.pumpAndSettle();
    return harness;
  }

  group('rendering', () {
    testWidgets('titles itself with the scope and offers 10/30/50', (
      tester,
    ) async {
      await openSetup(tester);

      expect(find.text('Quiz Setup'), findsOneWidget);
      expect(find.text('Cell Membrane'), findsOneWidget);
      expect(find.text('Select Quiz Size'), findsOneWidget);
      expect(find.text('10 Questions'), findsOneWidget);
      expect(find.text('30 Questions'), findsOneWidget);
      expect(find.text('50 Questions'), findsOneWidget);
      expect(find.text('Start learning'), findsOneWidget);
    });

    // CONFLICT 1 + 6: neither has a contract source, so neither is drawn.
    testWidgets('shows NO points preview and NO question-pool card', (
      tester,
    ) async {
      await openSetup(tester);

      expect(find.textContaining('Points'), findsNothing);
      expect(find.textContaining('+30'), findsNothing);
      expect(find.textContaining('POOL'), findsNothing);
      expect(find.textContaining('remaining'), findsNothing);
    });

    testWidgets('without a subject (a cold deep link) the scope stands alone', (
      tester,
    ) async {
      await openSetup(tester);

      // The subject comes from the subjects list the student tapped through,
      // never from a quiz endpoint. With no list there is no name, and the
      // screen invents none.
      expect(find.text('Biology'), findsNothing);
      expect(find.text('Cell Membrane'), findsOneWidget);
    });

    testWidgets('30 is preselected, and tapping another length moves it', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(tester, quiz: quiz);

      // Proven by what gets sent rather than by poking at colours.
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();
      verify(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: QuizLength.thirty,
          mode: any(named: 'mode'),
        ),
      ).called(1);
    });
  });

  group('creating a quiz', () {
    testWidgets('school sends the lessonId and the chosen length', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('10 Questions'));
      await tester.pump();
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      final captured =
          verify(
                () => quiz.createQuiz(
                  scope: captureAny(named: 'scope'),
                  length: QuizLength.ten,
                  mode: QuizMode.normal,
                ),
              ).captured.single
              as QuizSetupArgs;

      expect(captured.lessonId, 'lesson-9');
      expect(captured.lectureId, isNull);
      expect(captured.quizType, isNull);
    });

    testWidgets('university sends the lectureId and quizType — SAME screen', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(tester, args: _universityArgs, quiz: quiz);

      // One engine: the university flow renders the identical screen.
      expect(find.text('Lecture 4 — The Thorax'), findsOneWidget);
      expect(find.text('Select Quiz Size'), findsOneWidget);

      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      final captured =
          verify(
                () => quiz.createQuiz(
                  scope: captureAny(named: 'scope'),
                  length: any(named: 'length'),
                  mode: any(named: 'mode'),
                ),
              ).captured.single
              as QuizSetupArgs;

      expect(captured.lectureId, 'lecture-4');
      expect(captured.quizType, QuizType.finalRevision);
      expect(captured.lessonId, isNull);
    });

    testWidgets('a created quiz pushes the taking screen', (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());
      when(
        () => quiz.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      ).thenAnswer((_) async => answerResult());

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizScreen), findsOneWidget);
    });

    testWidgets('Start hands the subject on to the quiz, display only '
        '(API→UI Wave 13)', (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(
        tester,
        quiz: quiz,
        args: const QuizSetupArgs.lesson(
          lessonId: 'lesson-9',
          scopeName: 'Cell Membrane',
          subjectName: 'Biology',
        ),
      );
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      // Display only: `POST /quizzes` is built from the scope's ids (the
      // repository tests pin the body); the name rides the navigation.
      final screen = tester.widget<QuizScreen>(find.byType(QuizScreen));
      expect(screen.subjectName, 'Biology');
    });
  });

  group('error states', () {
    testWidgets('422 not_enough_questions is inline and NEVER silently retried', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 422, code: 'not_enough_questions'),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining("doesn't have enough questions"),
        findsOneWidget,
      );
      expect(find.byType(LimitSheet), findsNothing);
      // Exactly one attempt: the student picks a shorter quiz, the app does not
      // quietly pick one for them.
      verify(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).called(1);
    });

    testWidgets(
      '403 weekly_question_limit_reached opens the sheet, WEEKLY copy',
      (tester) async {
        final quiz = MockQuizRepository();
        when(
          () => quiz.createQuiz(
            scope: any(named: 'scope'),
            length: any(named: 'length'),
            mode: any(named: 'mode'),
          ),
        ).thenThrow(
          const ApiException(
            status: 403,
            code: 'weekly_question_limit_reached',
          ),
        );

        await openSetup(tester, quiz: quiz);
        await tester.tap(find.text('Start learning'));
        await tester.pumpAndSettle();

        expect(find.byType(LimitSheet), findsOneWidget);
        expect(find.text('Free Usage Reached'), findsOneWidget);
        expect(find.textContaining('this week'), findsOneWidget);
        // The contract limit is weekly; the frame's "Daily" wording is not shipped.
        expect(find.textContaining('Daily'), findsNothing);
        expect(find.textContaining('daily'), findsNothing);
        // Glossary: base_subscription is never called "premium".
        expect(find.textContaining('Premium'), findsNothing);
        // No questions-used bar — the contract exposes neither number.
        expect(find.textContaining('50/50'), findsNothing);
        // adr-049 §3: nothing tells the student to upgrade, subscribe or buy.
        expect(find.textContaining('Upgrade'), findsNothing);
        expect(find.textContaining('Subscribe'), findsNothing);
        expect(find.textContaining('paid'), findsNothing);
        // adr-049 §3: purchase-silent. No CTA of any kind inside the sheet.
        expect(
          find.descendant(
            of: find.byType(LimitSheet),
            matching: find.byType(FilledButton),
          ),
          findsNothing,
        );
      },
    );

    testWidgets('403 subscription_required opens the same sheet, other copy', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 403, code: 'subscription_required'),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(find.byType(LimitSheet), findsOneWidget);
      expect(find.text('Subscription Required'), findsOneWidget);
      // adr-049 §3: nothing tells the student to upgrade, subscribe or buy.
      expect(find.textContaining('Upgrade'), findsNothing);
      expect(find.textContaining('Subscribe'), findsNothing);
      expect(find.textContaining('paid'), findsNothing);
      // adr-049 §3: purchase-silent. No CTA of any kind inside the sheet.
      expect(
        find.descendant(
          of: find.byType(LimitSheet),
          matching: find.byType(FilledButton),
        ),
        findsNothing,
      );
    });

    testWidgets('offline shows the banner and disables Start', (tester) async {
      await openSetup(tester, online: false);

      expect(find.byType(OfflineBanner), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('a request in flight shows a spinner and blocks a second tap', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 200), quizFor),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Start learning'), findsNothing);

      await tester.pumpAndSettle();
    });
  });

  group('states matrix', () {
    testWidgets('Arabic (RTL) renders the Arabic copy', (tester) async {
      await openSetup(tester, locale: 'ar');

      expect(find.text('إعداد الاختبار'), findsOneWidget);
      expect(find.text('اختر عدد الأسئلة'), findsOneWidget);
      expect(find.text('ابدأ التعلّم'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('اختر عدد الأسئلة'))),
        TextDirection.rtl,
      );
    });

    testWidgets('dark theme renders the same content', (tester) async {
      await openSetup(tester, theme: AppTheme.dark);

      expect(find.text('Select Quiz Size'), findsOneWidget);
      expect(find.text('Cell Membrane'), findsOneWidget);
    });

    testWidgets('Arabic + dark + offline all at once', (tester) async {
      await openSetup(
        tester,
        locale: 'ar',
        theme: AppTheme.dark,
        online: false,
      );

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.text('اختر عدد الأسئلة'), findsOneWidget);
    });

    testWidgets('an Arabic error is localized', (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 422, code: 'not_enough_questions'),
      );

      await openSetup(tester, quiz: quiz, locale: 'ar');
      await tester.tap(find.text('ابدأ التعلّم'));
      await tester.pumpAndSettle();

      expect(find.textContaining('أسئلة كافية'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------- #11 -----
  group('the length chips are raised, not outlined', () {
    ElevatedSurface chip(WidgetTester tester, String label) =>
        tester.widget<ElevatedSurface>(
          find
              .ancestor(
                of: find.text(label),
                matching: find.byType(ElevatedSurface),
              )
              .first,
        );

    testWidgets('171 x 45, no hairline, and the frame\'s own shadow', (
      tester,
    ) async {
      await openSetup(tester);

      final c = chip(tester, '10 Questions');
      expect(c.width, 171);
      expect(c.height, 45);
      // Neither frame draws one; the border this used to carry came from
      // reading a neighbour rather than the chip.
      expect(c.side, isNull);
      expect(
        c.shadows,
        AppTheme.light.extension<AppElevation>()!.lengthChipShadows,
      );
      expect(c.shadows, isNotEmpty);
    });

    testWidgets('dark keeps the same black shadow and takes no Glass', (
      tester,
    ) async {
      await openSetup(tester, theme: AppTheme.dark);

      final c = chip(tester, '10 Questions');
      // One of the few dark surfaces that elevates with a shadow rather than
      // with Glass — `337:6289` keeps it.
      expect(
        c.shadows,
        AppTheme.dark.extension<AppElevation>()!.lengthChipShadows,
      );
      expect(c.shadows, isNotEmpty);
      expect(c.glass, isNull);
    });

    testWidgets('selecting one swaps the fill without changing the shape', (
      tester,
    ) async {
      await openSetup(tester);
      final ext = AppTheme.light.extension<AppColors>()!;

      expect(chip(tester, '10 Questions').color, ext.quizOptionFill);
      await tester.tap(find.text('50 Questions'));
      await tester.pumpAndSettle();

      expect(
        chip(tester, '50 Questions').color,
        AppTheme.light.colorScheme.primary,
      );
      expect(chip(tester, '50 Questions').width, 171);
    });
  });

  // -------------------------------------------------------------- 7.10a -----
  group('the Start CTA wears the primary treatment', () {
    PrimaryCta cta(WidgetTester tester) => tester.widget<PrimaryCta>(
      find.ancestor(
        of: find.byType(FilledButton),
        matching: find.byType(PrimaryCta),
      ),
    );

    testWidgets('it is wrapped in the primary tone', (tester) async {
      await openSetup(tester);

      expect(cta(tester).tone, CtaTone.primary);
      expect(cta(tester).enabled, isTrue);
    });

    testWidgets('offline dims the treatment as well as the button', (
      tester,
    ) async {
      await openSetup(tester, online: false);

      // R10: the whole treatment at 0.45, not just the fill.
      expect(cta(tester).enabled, isFalse);
    });

    testWidgets('the limit sheet still carries no CTA at all', (tester) async {
      // adr-049: the app is purchase-silent, and the sheet is the one place a
      // CTA would read as a paywall. `PrimaryCta` must never reach it.
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 403, code: 'weekly_question_limit_reached'),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(find.byType(LimitSheet), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(LimitSheet),
          matching: find.byType(PrimaryCta),
        ),
        findsNothing,
      );
    });
  });

  // ------------------------------------------------ API→UI Wave 11 -----
  group('Wave 11: the header matches both frames', () {
    const withSubject = QuizSetupArgs.lesson(
      lessonId: 'lesson-9',
      scopeName: 'Cell Membrane',
      subjectName: 'Biology',
    );

    TextStyle style(WidgetTester tester, String text) =>
        tester.widget<Text>(find.text(text)).style!;

    BorderSide rule(WidgetTester tester) {
      final header = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Cell Membrane'),
              matching: find.byType(Container),
            )
            .first,
      );
      return ((header.decoration! as BoxDecoration).border! as Border).bottom;
    }

    testWidgets('the subject sits above the scope, as in 135:1622', (
      tester,
    ) async {
      await openSetup(tester, args: withSubject);

      expect(find.text('Biology'), findsOneWidget);
      expect(
        tester.getRect(find.text('Biology')).bottom,
        lessThanOrEqualTo(tester.getRect(find.text('Cell Membrane')).top),
      );
      // `146:2289`: Inter Regular 12, #4B675E. The scope `146:2291` is #384F47.
      expect(style(tester, 'Biology').color, const Color(0xFF4B675E));
      expect(style(tester, 'Biology').fontSize, 12);
      expect(style(tester, 'Biology').fontWeight, FontWeight.w400);
      expect(style(tester, 'Cell Membrane').color, const Color(0xFF384F47));
    });

    testWidgets('dark: subject and scope are both #FCFBF9, not the accent', (
      tester,
    ) async {
      await openSetup(tester, args: withSubject, theme: AppTheme.dark);

      // `337:6270` and `337:6272`. The scope used to take the primary, which
      // is lavender in dark.
      expect(style(tester, 'Cell Membrane').color, const Color(0xFFFCFBF9));
      expect(style(tester, 'Biology').color, const Color(0xFFFCFBF9));
    });

    testWidgets('the rule under the header: light 1.18 #CCD5D2', (
      tester,
    ) async {
      await openSetup(tester);

      expect(rule(tester).color, const Color(0xFFCCD5D2));
      expect(rule(tester).width, 1.18);
    });

    testWidgets('the rule under the header: dark 0.5 at 20% #CCD5D2', (
      tester,
    ) async {
      await openSetup(tester, theme: AppTheme.dark);

      // `337:6268`: rgba(204,213,210,0.2) at 0.5. It used to borrow the dark
      // progress track at the light width, from before the dark frame was read.
      expect(rule(tester).color, const Color(0x33CCD5D2));
      expect(rule(tester).width, 0.5);
    });

    testWidgets('Arabic keeps the subject above the scope', (tester) async {
      await openSetup(
        tester,
        args: const QuizSetupArgs.lesson(
          lessonId: 'lesson-9',
          scopeName: 'غشاء الخلية',
          subjectName: 'الأحياء',
        ),
        locale: 'ar',
      );

      expect(
        tester.getRect(find.text('الأحياء')).bottom,
        lessThanOrEqualTo(tester.getRect(find.text('غشاء الخلية')).top),
      );
      // Both start at the right edge in RTL.
      expect(
        tester.getRect(find.text('الأحياء')).right,
        moreOrLessEquals(tester.getRect(find.text('غشاء الخلية')).right),
      );
    });
  });

  group('Wave 11: the limit card (199:2335)', () {
    Future<void> openLimit(
      WidgetTester tester, {
      String locale = 'en',
      ThemeData? theme,
    }) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 403, code: 'weekly_question_limit_reached'),
      );
      await openSetup(tester, quiz: quiz, locale: locale, theme: theme);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.byType(LimitSheet), findsOneWidget);
    }

    Finder close() => find.byKey(const Key('limit_sheet_close'));

    /// The frame's own `akar-icons:cross` (`207:5904`), by asset.
    Finder cross() => find.descendant(
      of: close(),
      matching: find.byWidgetPredicate(
        (w) =>
            w is SvgPicture &&
            w.bytesLoader is SvgAssetLoader &&
            (w.bytesLoader as SvgAssetLoader).assetName ==
                'assets/icons/close_cross.svg',
      ),
    );

    /// The card itself: the dialog's own Material.
    Rect card(WidgetTester tester) => tester.getRect(
      find
          .descendant(of: find.byType(Dialog), matching: find.byType(Material))
          .first,
    );

    testWidgets('it is a centred card, not a bottom sheet', (tester) async {
      await openLimit(tester);

      final dialog = find.descendant(
        of: find.byType(LimitSheet),
        matching: find.byType(Dialog),
      );
      expect(dialog, findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);

      final card = tester.widget<Dialog>(dialog);
      expect(
        card.shape,
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      );
      // 345 wide on the 402 frame.
      expect(
        card.insetPadding,
        const EdgeInsets.symmetric(horizontal: 28.5, vertical: 24),
      );
      expect(card.backgroundColor, const Color(0xFFFCFBF9));
    });

    testWidgets('the title is #EF4444 with a 23 dp #3F3F3F ✕ before it', (
      tester,
    ) async {
      await openLimit(tester);

      expect(
        tester.widget<Text>(find.text('Free Usage Reached')).style!.color,
        const Color(0xFFEF4444),
      );
      final glyph = tester.widget<SvgPicture>(cross());
      expect(glyph.width, 23);
      expect(glyph.height, 23);
      expect(
        glyph.colorFilter,
        const ColorFilter.mode(Color(0xFF3F3F3F), BlendMode.srcIn),
      );
      expect(
        tester.getRect(close()).right,
        lessThanOrEqualTo(tester.getRect(find.text('Free Usage Reached')).left),
      );
    });

    // W11-5: the ✕ used to sit 7.6 dp inboard. `IconButton`'s padded 48 dp
    // target centred the 23 dp glyph 6.5 dp in from the frame's box.
    testWidgets('the ✕ lands on the frame\'s box, with a full 48 dp target', (
      tester,
    ) async {
      await openLimit(tester);

      final box = tester.getRect(cross());
      final target = tester.getRect(close());
      // Android's minimum touch target, kept.
      expect(target.size, const Size(48, 48));
      expect(target.center, box.center);
      // `207:5904`: the 23 dp box at 6 inside a row inset 18 → 24 from the
      // card's edge, centred on the 35 dp title row 20 below the top.
      expect(box.size, const Size(23, 23));
      expect(box.left - card(tester).left, 24);
      expect(box.center.dy - card(tester).top, 37.5);
    });

    testWidgets('Arabic mirrors the ✕: 24 from the right edge', (tester) async {
      await openLimit(tester, locale: 'ar');

      expect(card(tester).right - tester.getRect(cross()).right, 24);
      expect(tester.getRect(close()).size, const Size(48, 48));
    });

    // W11-6: a second 403 from the error state stacked two cards on device.
    testWidgets('a second 403 opens ONE card, not two', (tester) async {
      await openLimit(tester);
      await tester.tap(close());
      await tester.pumpAndSettle();
      expect(find.byType(LimitSheet), findsNothing);

      // Start again, from the error the first 403 left behind.
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.byType(LimitSheet), findsOneWidget);

      // One tap clears it: nothing is stacked underneath.
      await tester.tap(close());
      await tester.pumpAndSettle();
      expect(find.byType(LimitSheet), findsNothing);
      expect(find.text('Select Quiz Size'), findsOneWidget);
    });

    testWidgets('the ✕ is labelled and dismisses the card', (tester) async {
      await openLimit(tester);

      expect(find.byTooltip('Close'), findsOneWidget);
      await tester.tap(close());
      await tester.pumpAndSettle();

      expect(find.byType(LimitSheet), findsNothing);
      // Back on setup, free to pick another length or leave.
      expect(find.text('Select Quiz Size'), findsOneWidget);
    });

    // W11-7: the SVG glyph wraps itself in `Semantics(image: true)`, the flag
    // merged into the button, and TalkBack read the ✕ as an ImageView (device,
    // the Wave 11 re-walk). `isImage: false` is the regression guard.
    testWidgets('TalkBack reads the ✕ as a button, not an image', (
      tester,
    ) async {
      await openLimit(tester);

      expect(
        tester.getSemantics(close()),
        isSemantics(
          tooltip: 'Close',
          isButton: true,
          isImage: false,
          hasTapAction: true,
        ),
      );
    });

    testWidgets('"Not now" still dismisses it', (tester) async {
      await openLimit(tester);

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(find.byType(LimitSheet), findsNothing);
    });

    testWidgets('Arabic puts the ✕ on the right, before the title', (
      tester,
    ) async {
      await openLimit(tester, locale: 'ar');

      expect(find.byTooltip('إغلاق'), findsOneWidget);
      expect(
        tester.getRect(close()).left,
        greaterThanOrEqualTo(
          tester.getRect(find.text('انتهت أسئلتك المجانية')).right,
        ),
      );
    });

    testWidgets('dark: the page-fill card and a light ✕', (tester) async {
      await openLimit(tester, theme: AppTheme.dark);

      final card = tester.widget<Dialog>(
        find.descendant(
          of: find.byType(LimitSheet),
          matching: find.byType(Dialog),
        ),
      );
      expect(card.backgroundColor, const Color(0xFF232428));
      expect(
        tester.widget<SvgPicture>(cross()).colorFilter,
        const ColorFilter.mode(Color(0xFFFCFBF9), BlendMode.srcIn),
      );
    });
  });
}
