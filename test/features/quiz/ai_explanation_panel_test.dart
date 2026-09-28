import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/models/explanation_state.dart';
import 'package:level_up_app/features/quiz/widgets/ai_explanation_panel.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:level_up_app/features/quiz/widgets/ai_education_glyph.dart';

/// The AI EXPLANATION panel's failure affordance.
///
/// The contract's failure UX for the poll cap IS a "try again" — there is no
/// terminal failure status on the wire, so the client's cap is the failure. But
/// only two codes may offer one, and the rest must not: `insufficient_scope`
/// means no explanation is available to this caller at all, and
/// `account_pending_deletion` is the code Phase 1 suppressed retry for
/// everywhere in the app.
void main() {
  /// Pumps the panel in one state. The tap-through case builds its own so it
  /// can count requests; everything else only looks at what is rendered.
  Future<void> pumpPanel(
    WidgetTester tester,
    ExplanationState state, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: theme ?? AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AiExplanationPanel(state: state, onRequest: () {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final retry = find.byKey(const Key('explanation_retry'));

  group('offers a try again', () {
    testWidgets('after the poll cap gives up', (tester) async {
      await pumpPanel(tester, const ExplanationFailed(explanationTimeoutCode));

      expect(retry, findsOneWidget);
      // The affordance is what changes; the copy does not. An explanation is an
      // extra, so losing one must never read as a broken quiz.
      expect(
        find.text('No explanation is available for this question.'),
        findsOneWidget,
      );
    });

    testWidgets('on a 429 — the same GET succeeds after the window', (
      tester,
    ) async {
      await pumpPanel(tester, const ExplanationFailed('rate_limited'));

      expect(retry, findsOneWidget);
    });

    testWidgets('and tapping it re-requests', (tester) async {
      var requests = 0;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AiExplanationPanel(
              state: const ExplanationFailed(explanationTimeoutCode),
              onRequest: () => requests++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(retry);
      await tester.pumpAndSettle();

      expect(requests, 1);
    });
  });

  group('does NOT offer one', () {
    testWidgets('for account_pending_deletion — adr-114', (tester) async {
      // Phase 1 suppressed Retry for this code at every funnel in the app. The
      // contract says outright do not retry, and nothing tapped here clears it.
      await pumpPanel(
        tester,
        const ExplanationFailed('account_pending_deletion'),
      );

      expect(retry, findsNothing);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('for insufficient_scope — no popup, no error toast', (
      tester,
    ) async {
      await pumpPanel(tester, const ExplanationFailed('insufficient_scope'));

      expect(retry, findsNothing);
    });

    // API→UI Wave 12 (owner ruling): the screen opens the contract's popup,
    // and the panel keeps the button the contract renders from
    // `explanationAvailable`. No "try again", and no "not available" either:
    // the popup has just said an explanation exists.
    testWidgets('for subscription_required — the popup explains, the '
        'button stays', (tester) async {
      await pumpPanel(tester, const ExplanationSubscriptionRequired());

      expect(retry, findsNothing);
      expect(find.text('Show explanation'), findsOneWidget);
      expect(
        find.text('No explanation is available for this question.'),
        findsNothing,
      );
    });

    testWidgets('for a code nobody has classified yet — default deny', (
      tester,
    ) async {
      // The allowlist's whole point: a code added later cannot quietly acquire
      // a retry button.
      await pumpPanel(tester, const ExplanationFailed('some_future_code'));

      expect(retry, findsNothing);
    });

    testWidgets('when the explanation actually loaded', (tester) async {
      await pumpPanel(
        tester,
        const ExplanationLoaded('Mitochondria make ATP.'),
      );

      expect(retry, findsNothing);
      expect(find.text('Mitochondria make ATP.'), findsOneWidget);
    });
  });

  // --------------------------------------------------- API→UI Wave 12 -----
  group('Wave 12: the header (159:1811 / 337:9271)', () {
    final glyph = find.byWidgetPredicate(
      (w) =>
          w is SvgPicture &&
          w.bytesLoader is SvgAssetLoader &&
          (w.bytesLoader as SvgAssetLoader).assetName ==
              'assets/icons/ai_education.svg',
    );

    // W12-3. It was Material's `Icons.school_outlined`. #98 (owner ruling
    // 2026-09-27): drawn at the frame's scale in its 26.55 box, 8.089 before
    // the title; boxed into the square it drew at 1.062x.
    testWidgets('light: the frame\'s ai-education glyph at the frame\'s scale, '
        '#384F47', (tester) async {
      await pumpPanel(tester, const ExplanationIdle());

      final svg = tester.widget<SvgPicture>(glyph);
      expect(svg.height, AiEducationGlyph.drawnHeight);
      expect(svg.width, isNull);
      final box = tester.getRect(find.byType(AiEducationGlyph));
      expect(box.size, const Size.square(26.55));
      expect(
        tester.getRect(find.text('AI EXPLANATION')).left - box.right,
        moreOrLessEquals(8.089, epsilon: 0.01),
      );
      expect(
        svg.colorFilter,
        const ColorFilter.mode(Color(0xFF384F47), BlendMode.srcIn),
      );
      // The title beside it names the panel; the glyph must not add an image.
      expect(svg.excludeFromSemantics, isTrue);
      expect(find.byIcon(Icons.school_outlined), findsNothing);
      expect(
        tester.widget<Text>(find.text('AI EXPLANATION')).style!.color,
        const Color(0xFF384F47),
      );
    });

    // W12-4. Dark took the lavender primary; `337:9271` draws #FCFBF9.
    testWidgets('dark: the glyph and the title are #FCFBF9', (tester) async {
      await pumpPanel(tester, const ExplanationIdle(), theme: AppTheme.dark);

      expect(
        tester.widget<SvgPicture>(glyph).colorFilter,
        const ColorFilter.mode(Color(0xFFFCFBF9), BlendMode.srcIn),
      );
      expect(
        tester.widget<Text>(find.text('AI EXPLANATION')).style!.color,
        const Color(0xFFFCFBF9),
      );
    });
  });
}
