import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/home/widgets/coming_soon_section.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The Home placeholders' SURFACES · edit3.md #3.
///
/// The owner's 2026-09-17 decision is that a placeholder keeps its "Coming
/// soon" content and takes its section's Figma surface. That makes the surface
/// the thing worth testing, and the thing that can silently regress: every
/// value below is a token read, and reading the WRONG token compiles, analyses
/// clean and looks plausible on whichever canvas it was eyeballed against —
/// which is exactly how the cream back-chip and the page-coloured language pill
/// shipped (`shared_chrome_test.dart`).
///
/// Checked through the `ElevatedSurface` each surface configures, not through
/// recorded paint: the primitive's own painting is edit1's test.
void main() {
  Widget host(
    ComingSoonSurface surface,
    Track track, {
    required Brightness brightness,
  }) {
    return MaterialApp(
      theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ComingSoonSection(
          title: 'Daily Tasks',
          surface: surface,
          track: track,
        ),
      ),
    );
  }

  ElevatedSurface surfaceOf(WidgetTester tester) =>
      tester.widget(find.byType(ElevatedSurface));

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  AppElevation elevation(Brightness b) =>
      b == Brightness.light ? AppElevation.light : AppElevation.dark;

  double radiusOf(ElevatedSurface s) =>
      ((s.shape as RoundedRectangleBorder).borderRadius as BorderRadius)
          .topLeft
          .x;

  // -------------------------------------------------------------------------
  group('Daily Tasks · 308:4305 / 337:5357', () {
    for (final brightness in Brightness.values) {
      final canvas = brightness.name;

      testWidgets('$canvas · fill, radius and border come from the tokens', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            ComingSoonSurface.dailyTasks,
            Track.school,
            brightness: brightness,
          ),
        );

        final s = surfaceOf(tester);
        expect(s.color, colours(brightness).dailyTasksFill);
        expect(radiusOf(s), 15);
        expect(s.height, 96, reason: 'the 96 dp box is unchanged');

        if (brightness == Brightness.light) {
          // A green hairline on ALL FOUR sides, 0.302507 wide.
          expect(s.side?.color, colours(brightness).dailyTasksBorder);
          expect(s.side?.width, 0.302507);
        } else {
          // The dark frame HIDES the stroke. A null border here is the
          // reading, not a forgotten line — `dailyTasksBorderWidth` is 0 and
          // `dailyTasksBorder` is null in dark.
          expect(s.side, isNull);
        }
        expect(s.topSide, isNull, reason: 'this one is a full border, not top');
      });

      testWidgets('$canvas · Glass and the back-light are dark-only', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            ComingSoonSurface.dailyTasks,
            Track.school,
            brightness: brightness,
          ),
        );

        final s = surfaceOf(tester);
        expect(s.glass, elevation(brightness).dailyTasksGlass);
        expect(
          s.backlights,
          brightness == Brightness.dark
              ? [elevation(brightness).dailyTasksBacklightSchool]
              : isEmpty,
        );
      });
    }

    testWidgets('the two tracks take DIFFERENT back-lights', (tester) async {
      // B2 is 100x14 at (3, 0); B10 is 133x21 at (13, 0) — a different size AND
      // offset, kept verbatim rather than normalised (edit1.md R2).
      await tester.pumpWidget(
        host(
          ComingSoonSurface.dailyTasks,
          Track.school,
          brightness: Brightness.dark,
        ),
      );
      final school = surfaceOf(tester).backlights.single;

      await tester.pumpWidget(
        host(
          ComingSoonSurface.dailyTasks,
          Track.university,
          brightness: Brightness.dark,
        ),
      );
      final university = surfaceOf(tester).backlights.single;

      expect(school.size, const Size(100, 14));
      expect(school.offset, const Offset(3, 0));
      expect(university.size, const Size(133, 21));
      expect(university.offset, const Offset(13, 0));
    });
  });

  // Top Student's surface moved to `top_student_section_test.dart` with the
  // block itself (API→UI Wave 05).

  // -------------------------------------------------------------------------
  group('Continue Learning', () {
    for (final brightness in Brightness.values) {
      final canvas = brightness.name;

      testWidgets('$canvas · keeps its two shadows and takes NO Glass', (
        tester,
      ) async {
        // The one section whose dark card is opaque rather than a 20% wash, so
        // the frame's black shadows still land on something (edit1.md R1).
        await tester.pumpWidget(
          host(
            ComingSoonSurface.continueLearning,
            Track.school,
            brightness: brightness,
          ),
        );

        final s = surfaceOf(tester);
        expect(radiusOf(s), 13.7251);
        expect(s.shadows, elevation(brightness).continueLearningShadows);
        expect(s.shadows, hasLength(2));
        expect(s.glass, isNull);
        expect(s.backlights, isEmpty);
      });
    }

    testWidgets('the fill is the TRACK\'s, and school differs by canvas', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        for (final track in Track.values) {
          await tester.pumpWidget(
            host(
              ComingSoonSurface.continueLearning,
              track,
              brightness: brightness,
            ),
          );
          // `MaterialApp` lerps a theme change through `AnimatedTheme`, so a
          // single pump would still read the PREVIOUS canvas's tokens here.
          await tester.pumpAndSettle();
          expect(
            surfaceOf(tester).color,
            track == Track.school
                ? colours(brightness).continueLearningFillSchool
                : colours(brightness).continueLearningFillUniversity,
          );
        }
      }

      // The measurement behind the branch: school flips #F3E5FF -> #C4A8E3
      // between canvases, university is #DBB0FF on both.
      expect(
        colours(Brightness.light).continueLearningFillSchool,
        isNot(colours(Brightness.dark).continueLearningFillSchool),
      );
      expect(
        colours(Brightness.light).continueLearningFillUniversity,
        colours(Brightness.dark).continueLearningFillUniversity,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('the placeholder foreground (DESIGN_ISSUES #79)', () {
    /// The colour the "Coming soon" icon and caption are actually drawn in.
    Color captionColour(WidgetTester tester) =>
        tester.widget<Text>(find.text('Coming soon')).style!.color!;

    testWidgets('Continue Learning uses its CARD colour, not mutedText', (
      tester,
    ) async {
      // `mutedText` #B3B3B3 on the dark school fill #C4A8E3 measures 1.00:1 —
      // the same relative luminance, i.e. invisible. The card's own frames
      // caption it #2B2B2B, read 2026-09-19, and that is what it must use.
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(
          host(
            ComingSoonSurface.continueLearning,
            Track.school,
            brightness: brightness,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          captionColour(tester),
          colours(brightness).continueLearningContent,
          reason: '$brightness',
        );
        expect(captionColour(tester), isNot(colours(brightness).mutedText));
      }

      // The measured value itself, so a future edit cannot quietly relax it
      // back toward the page grey.
      expect(
        colours(Brightness.light).continueLearningContent,
        const Color(0xFF2B2B2B),
      );
      expect(
        colours(Brightness.dark).continueLearningContent,
        const Color(0xFF2B2B2B),
      );
    });

    testWidgets('the other two surfaces still use mutedText', (tester) async {
      // Unchanged by the #79 fix. They are near-white in light and a dark wash
      // in dark, which is what that grey was chosen against; where it still
      // fails in light it fails exactly as it did before this wave.
      for (final surface in [
        ComingSoonSurface.dailyTasks,
        ComingSoonSurface.plain,
      ]) {
        await tester.pumpWidget(
          host(surface, Track.school, brightness: Brightness.dark),
        );
        await tester.pumpAndSettle();
        expect(
          captionColour(tester),
          colours(Brightness.dark).mutedText,
          reason: '$surface',
        );
      }
    });
  });

  // -------------------------------------------------------------------------
  group('plain', () {
    testWidgets('is the pre-2026-09-17 box — no ElevatedSurface at all', (
      tester,
    ) async {
      // University Learning Tools. The frame gives it no surface of its own
      // (DESIGN_ISSUES #20), so it must NOT borrow a neighbour's.
      await tester.pumpWidget(
        host(
          ComingSoonSurface.plain,
          Track.university,
          brightness: Brightness.dark,
        ),
      );
      expect(find.byType(ElevatedSurface), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  testWidgets('every surface keeps the content, the height and the inertness', (
    tester,
  ) async {
    for (final surface in ComingSoonSurface.values) {
      await tester.pumpWidget(
        host(surface, Track.school, brightness: Brightness.light),
      );

      expect(find.text('Coming soon'), findsOneWidget, reason: '$surface');
      expect(find.text('See All'), findsOneWidget, reason: '$surface');
      expect(find.byIcon(Icons.schedule), findsOneWidget, reason: '$surface');
      // "See All" is inert — there is nothing to see all of yet — so nothing
      // in this section may be tappable.
      expect(find.byType(InkWell), findsNothing, reason: '$surface');
      expect(
        tester.getSize(find.byType(ComingSoonSection)).height,
        greaterThan(96),
        reason: '$surface: header + the 96 box',
      );
    }
  });

  // -------------------------------------------------------------------------
  // W05-1 (Wave 05 walk): every frame draws "See All" in the title's colour —
  // `59:2089` black in light, #FCFBF9 in `337:5456` — not `mutedText`.
  group('header', () {
    for (final brightness in Brightness.values) {
      testWidgets('${brightness.name} · See All wears the title colour', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            ComingSoonSurface.dailyTasks,
            Track.school,
            brightness: brightness,
          ),
        );
        await tester.pumpAndSettle();

        final seeAll = tester.widget<Text>(find.text('See All'));
        expect(seeAll.style?.color, colours(brightness).textPrimary);
        expect(
          seeAll.style?.color,
          tester.widget<Text>(find.text('Daily Tasks')).style?.color,
        );
      });
    }
  });
}
