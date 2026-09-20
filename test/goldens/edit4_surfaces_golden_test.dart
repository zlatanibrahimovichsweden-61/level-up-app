/// Dark-canvas goldens for the edit4 wave · `edit4.md` §11.3.
///
/// **Dark only, for the same reason `edit3_surfaces_golden_test.dart` is.**
/// The light canvas draws these surfaces with a drop shadow and nothing else,
/// so a light baseline would pin a flat rectangle and a blur that the shadow
/// painter already has its own unit tests for. Everything this wave actually
/// added — Glass rims, back-lights, inner shadows — exists only in dark.
///
/// **What is NOT here, and why.** `edit4.md` §11.3 also asks for a rewards-card
/// golden. `_RewardsCard` is private to `quiz_result_screen.dart` and the
/// screen around it needs a GoRouter and a repository, which the golden harness
/// deliberately does not carry. Making the card public to photograph it would
/// change production code for a test's convenience. Its surface, its Glass, its
/// back-light and its star disc are asserted by value in
/// `test/features/quiz/quiz_result_screen_test.dart` instead.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/widgets/scope_toggle.dart';
import 'package:level_up_app/features/quiz/models/explanation_state.dart';
import 'package:level_up_app/features/quiz/widgets/ai_explanation_panel.dart';

import 'golden_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('AI explanation panel · dark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 220));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      goldenApp(
        brightness: Brightness.dark,
        child: const SizedBox(
          width: 363,
          // Loaded rather than idle: idle collapses to a text button and the
          // inner card — the thing carrying the blur-3 wrapper shadow and its
          // own G5 — never mounts.
          child: AiExplanationPanel(
            state: ExplanationLoaded(
              'Cytosine does not pair with Adenine. In DNA, Adenine always '
              'pairs with Thymine through two hydrogen bonds.',
            ),
            onRequest: _noop,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(AiExplanationPanel),
      matchesGoldenFile('ai_panel_dark.png'),
    );
  });

  testWidgets('leaderboard scope toggle · dark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      goldenApp(
        brightness: Brightness.dark,
        child: SizedBox(
          width: 362,
          child: ScopeToggle(
            // The UNIVERSITY pair, deliberately. Measured 2026-09-20 at this
            // width in this binding: the school pair `System | Governorate`
            // overflows by 101 dp and the groove scrolls, so a baseline built
            // from it would photograph the scrolling fallback rather than the
            // control. That overflow is a real finding and is recorded in
            // docs/DESIGN_ISSUES.md #81 — it is not what this golden is for.
            //
            // The test binding's font is ~1.5x wider than Inter (D-012), so
            // what a device does is a separate question and is not settled
            // here either way.
            scopes: const [LeaderboardScope.global, LeaderboardScope.cohort],
            // Not the first segment: a selected first segment sits in the
            // track's own rounded corner where the two radii overlap, which
            // hides exactly the inner-shadow boundary this baseline exists to
            // pin. Same reasoning as the quiz-type tabs' golden.
            selected: LeaderboardScope.cohort,
            onChanged: _ignore,
            labelFor: _label,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ScopeToggle),
      matchesGoldenFile('scope_toggle_dark.png'),
    );
  });
}

void _noop() {}

void _ignore(LeaderboardScope _) {}

String _label(LeaderboardScope scope) => switch (scope) {
  LeaderboardScope.global => 'Global',
  LeaderboardScope.cohort => 'Cohort',
  LeaderboardScope.system => 'System',
  LeaderboardScope.governorate => 'Governorate',
};
