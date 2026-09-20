/// The quiz flow's elevated surfaces, mounted directly where they can be.
///
/// The screens themselves are covered by `quiz_setup_screen_test.dart`,
/// `quiz_screen_test.dart` and `quiz_result_screen_test.dart`, which drive the
/// real router; this file pins the things those tests do not look at — the
/// fills, the shadows, the Glass and the hairlines — for the widgets that can
/// be mounted on their own.
///
/// Two of these have caught a real class of bug before, so they are worth
/// spelling out:
///
///  * **an empty dark shadow list is a READING, not a gap.** Four of edit4's
///    surfaces carry no shadow on the dark canvas and elevate with Glass
///    instead; a well-meaning "restore the shadow" is what these assert
///    against.
///  * **the AI card's blur is the wrapper's 3, not 1.5**, and its colour is
///    the measured black rather than the cream a withdrawn derivation put
///    there (DESIGN_ISSUES #47, D-009).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/quiz/models/explanation_state.dart';
import 'package:level_up_app/features/quiz/widgets/ai_explanation_panel.dart';
import 'package:level_up_app/features/quiz/widgets/question_option_tile.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

void main() {
  Widget host(Widget child, {required Brightness brightness}) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  AppElevation elevations(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppElevation>()!;

  // ---------------------------------------------------------------- #14 -----
  group('AiExplanationPanel · 159:1811 light / 337:9270 dark', () {
    Widget panel(ExplanationState state) =>
        AiExplanationPanel(state: state, onRequest: () {});

    /// Outer first, inner second — the outer container wraps the body card.
    List<ElevatedSurface> surfaces(WidgetTester tester) => tester
        .widgetList<ElevatedSurface>(find.byType(ElevatedSurface))
        .toList();

    testWidgets('light: a 0.5 green hairline, no Glass, no back-light', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          panel(const ExplanationLoaded('why')),
          brightness: Brightness.light,
        ),
      );

      final outer = surfaces(tester).first;
      final ext = colours(Brightness.light);

      expect(outer.color, ext.aiPanelOuterFill);
      expect(outer.side?.color, ext.aiPanelOuterBorder);
      expect(outer.side?.width, 0.5);
      expect(outer.glass, isNull);
      expect(outer.backlights, isEmpty);
    });

    testWidgets('dark: NO hairline, G18 Glass and the lavender back-light', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          panel(const ExplanationLoaded('why')),
          brightness: Brightness.dark,
        ),
      );

      final outer = surfaces(tester).first;
      final ext = colours(Brightness.dark);
      final e = elevations(Brightness.dark);

      expect(outer.color, ext.aiPanelOuterFill);
      // `337:9270` draws no outline at all. The token is null to say so, and
      // the widget has to have a null branch for it.
      expect(ext.aiPanelOuterBorder, isNull);
      expect(outer.side, isNull);
      expect(outer.glass, e.aiPanelGlass);
      expect(outer.backlights, [e.aiPanelBacklight]);
    });

    for (final b in Brightness.values) {
      // One test per canvas rather than a loop inside one. `MaterialApp`
      // lerps its theme over `kThemeAnimationDuration`, so re-pumping the
      // same app with the other brightness reads the OLD canvas on the
      // frame the assertion runs.
      testWidgets('${b.name}: the inner card carries the WRAPPER\'s '
          'shadow — blur 3, black', (tester) async {
        await tester.pumpWidget(
          host(panel(const ExplanationLoaded('why')), brightness: b),
        );

        final inner = surfaces(tester).last;
        expect(inner.color, colours(b).aiPanelCardFill);
        expect(inner.shadows, elevations(b).aiPanelCardShadows);
        expect(inner.shadows, hasLength(1));

        final shadow = inner.shadows.single;
        // The wrapper `159:1825` / `337:9278`, not the 1.5 the old inline
        // BoxShadow carried.
        expect(shadow.blur, 3);
        expect(shadow.inset, isFalse);
        // Black on BOTH canvases. The cream derivation is withdrawn.
        expect(shadow.color.r, 0);
        expect(shadow.color.g, 0);
        expect(shadow.color.b, 0);
        expect(shadow.color.a, closeTo(0.25, 0.005));
      });

      testWidgets('${b.name}: the inner card is glassed only where the '
          'frame says so', (tester) async {
        await tester.pumpWidget(
          host(panel(const ExplanationLoaded('why')), brightness: b),
        );

        expect(surfaces(tester).last.glass, elevations(b).aiPanelCardGlass);
        expect(
          surfaces(tester).last.glass,
          b == Brightness.dark ? isNotNull : isNull,
        );
      });
    }

    testWidgets('all four states still render, and only three draw the card', (
      tester,
    ) async {
      // Idle collapses to a text button, so it has the outer surface only.
      await tester.pumpWidget(
        host(panel(const ExplanationIdle()), brightness: Brightness.dark),
      );
      expect(surfaces(tester), hasLength(1));
      expect(find.byType(TextButton), findsOneWidget);

      for (final state in <ExplanationState>[
        const ExplanationPending(),
        const ExplanationLoaded('why'),
        const ExplanationFailed('explanation_timeout'),
      ]) {
        await tester.pumpWidget(
          host(panel(state), brightness: Brightness.dark),
        );
        await tester.pump();
        expect(surfaces(tester), hasLength(2), reason: '$state');
      }
    });

    testWidgets('the back-light is on the OUTER surface, the one whose '
        'frost makes it visible', (tester) async {
      // The earlier version of this test walked both surfaces asserting
      // "if it has a back-light it has Glass", which cannot fail: the
      // primitive asserts exactly that, so `pumpWidget` would already have
      // thrown. What is worth pinning is WHICH surface carries it - R6
      // puts a back-light behind one specific covering surface, and the
      // inner card is not it.
      await tester.pumpWidget(
        host(
          panel(const ExplanationLoaded('why')),
          brightness: Brightness.dark,
        ),
      );

      final all = surfaces(tester);
      expect(all, hasLength(2));
      expect(all.first.backlights, hasLength(1));
      expect(all.last.backlights, isEmpty);
      // And it is the FROSTIER of the two - G18 outside, G5 inside - which
      // is what turns a hard lavender ellipse into a haze.
      expect(all.first.glass!.frost, greaterThan(all.last.glass!.frost));
    });
  });

  // ---------------------------------------------------------------- #47 -----
  group('QuestionOptionTile · 308:5153 light / 337:6440 dark', () {
    Widget tile(OptionTileState state) => QuestionOptionTile(
      letter: 'A',
      text: 'Nucleus',
      state: state,
      onTap: () {},
    );

    /// The TILE's own outline. Read off `Ink`, which is not a `Container`:
    /// the first `Container` inside the tile is the A/B/C/D badge, and
    /// reading that one by mistake is how a test could pass while the tile
    /// kept the wrong hairline.
    BoxDecoration inkDecoration(WidgetTester tester) =>
        tester
                .widget<Ink>(
                  find.descendant(
                    of: find.byType(QuestionOptionTile),
                    matching: find.byType(Ink),
                  ),
                )
                .decoration!
            as BoxDecoration;

    /// The A/B/C/D ring, which keeps `quizOptionBorder`.
    BoxDecoration badgeDecoration(WidgetTester tester) =>
        tester
                .widget<Container>(
                  find
                      .descendant(
                        of: find.byType(QuestionOptionTile),
                        matching: find.byType(Container),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;

    testWidgets('the dark idle hairline is LAVENDER, not the green ring\'s '
        'value', (tester) async {
      await tester.pumpWidget(
        host(tile(OptionTileState.idle), brightness: Brightness.dark),
      );

      final ext = colours(Brightness.dark);
      final border = inkDecoration(tester).border! as Border;

      // `337:6440`. `quizOptionBorder` is still `#4B675E` in dark and is now
      // the A/B/C/D ring's value alone.
      expect(border.top.color, ext.quizOptionTileBorder);
      expect(border.top.color, isNot(ext.quizOptionBorder));
      expect(border.top.width, 0.5);

      // And the RING moved with it, under the owner's 2026-09-20 ruling
      // on DESIGN_ISSUES #83. `337:6447` draws the ungraded ring in the
      // same lavender at 50% as the tile outline.
      final ring = badgeDecoration(tester).border! as Border;
      expect(ring.top.color, ext.quizOptionBadgeRing);
      expect(ring.top.color, ext.quizOptionTileBorder);
      expect(ring.top.width, 1.18);
      // The SHARED token did not move with it - that was the whole point
      // of giving the ring its own. Four other surfaces still read it.
      expect(ext.quizOptionBorder, isNot(ext.quizOptionBadgeRing));
      expect(ext.quizOptionBorder, const Color(0xFF4B675E));
    });

    testWidgets('light is unchanged — both tokens are the same green there', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(tile(OptionTileState.idle), brightness: Brightness.light),
      );

      final ext = colours(Brightness.light);
      // All three are the same green in light, which is why the light
      // canvas is byte-identical after both of this wave's border moves.
      expect(ext.quizOptionTileBorder, ext.quizOptionBorder);
      expect(ext.quizOptionBadgeRing, ext.quizOptionBorder);
      expect(
        (inkDecoration(tester).border! as Border).top.color,
        ext.quizOptionTileBorder,
      );
      expect(
        (badgeDecoration(tester).border! as Border).top.color,
        ext.quizOptionBadgeRing,
      );
    });

    testWidgets('the graded states are untouched by this wave', (tester) async {
      // D-010 was scoped to the REVIEW rows. If these ever move it is a new
      // designer question, not a consistency fix made here.
      final ext = colours(Brightness.dark);
      for (final (state, fill) in [
        (OptionTileState.correct, ext.quizCorrectFill),
        (OptionTileState.incorrect, ext.quizWrongFill),
      ]) {
        await tester.pumpWidget(host(tile(state), brightness: Brightness.dark));
        final material = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(QuestionOptionTile),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(material.color, fill);
      }
      // And the semantic hues are still canvas-independent.
      expect(ext.quizCorrectFill, colours(Brightness.light).quizCorrectFill);
      expect(ext.quizWrongFill, colours(Brightness.light).quizWrongFill);
    });
  });
}
