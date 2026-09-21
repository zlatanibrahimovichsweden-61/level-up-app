import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/models/explanation_state.dart';
import 'package:level_up_app/features/quiz/widgets/ai_explanation_panel.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

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
  Future<void> pumpPanel(WidgetTester tester, ExplanationState state) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
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

    testWidgets('for subscription_required — asking again fixes nothing', (
      tester,
    ) async {
      await pumpPanel(tester, const ExplanationFailed('subscription_required'));

      expect(retry, findsNothing);
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
}
