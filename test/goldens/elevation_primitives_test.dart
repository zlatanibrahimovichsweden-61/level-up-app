// Platform-sensitive: the .png baselines were captured on Windows and Flutter
// goldens embed platform text shaping and anti-aliasing, so these fail on a
// Linux runner even when the code is correct. The tag lets CI select by
// intent rather than by directory — see dart_test.yaml.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';

import 'golden_harness.dart';

/// Four subjects that between them exercise every mechanism the elevation
/// primitives implement, in both canvases.
///
/// These are the only visual record of the tier-1 Glass model. The unit tests
/// prove the knockout and the mirroring on individual pixels; only a golden
/// shows what the rim light and the frosted back-light actually look like, and
/// only a golden fails when a later change to the model moves them.
void main() {
  setUpAll(loadAppFonts);

  AppColors paletteFor(Brightness b) =>
      b == Brightness.light ? AppColors.light : AppColors.dark;
  AppElevation elevationFor(Brightness b) =>
      b == Brightness.light ? AppElevation.light : AppElevation.dark;

  for (final MapEntry(key: canvas, value: brightness)
      in goldenBrightnesses.entries) {
    testWidgets('level card surface · $canvas', (tester) async {
      // The widest Glass in the file (G6, splay 1.00, frost 62) over the
      // biggest back-light (B1). In light this is a plain shadowed card: the
      // point of the pair is that the two canvases elevate by different
      // mechanisms and neither is a degraded version of the other.
      final palette = paletteFor(brightness);
      final elevation = elevationFor(brightness);

      await tester.pumpWidget(
        goldenApp(
          brightness: brightness,
          child: ElevatedSurface(
            width: 362,
            height: 171,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: palette.cardFill,
            shadows: elevation.levelCardShadows,
            glass: elevation.levelCardGlass,
            backlights: [
              if (elevation.levelCardBacklightSchool != null)
                elevation.levelCardBacklightSchool!,
            ],
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ElevatedSurface),
        matchesGoldenFile('elevation_level_card_$canvas.png'),
      );
    });

    testGoldenRow(canvas, brightness, paletteFor, elevationFor);

    testWidgets('inset track · $canvas', (tester) async {
      // The inset painter, which is the one effect that has no outer
      // equivalent: in dark this is a groove, in light a flat pill.
      final palette = paletteFor(brightness);
      final elevation = elevationFor(brightness);

      await tester.pumpWidget(
        goldenApp(
          brightness: brightness,
          child: ElevatedSurface(
            width: 300,
            height: 44,
            shape: const StadiumBorder(),
            color: palette.pillTrackFill,
            shadows: elevation.pillTrackInsetShadows,
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ElevatedSurface),
        matchesGoldenFile('elevation_inset_track_$canvas.png'),
      );
    });

    testWidgets('two-shadow card · $canvas', (tester) async {
      // The subject card: two shadows, one with a negative spread, IDENTICAL
      // on both canvases. This is the golden that would catch the cream
      // coming back.
      final palette = paletteFor(brightness);
      final elevation = elevationFor(brightness);

      await tester.pumpWidget(
        goldenApp(
          brightness: brightness,
          child: ElevatedSurface(
            width: 170,
            height: 120,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: palette.subjectCardFill,
            shadows: elevation.subjectCardShadows,
            glass: elevation.mistakesCardGlass,
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ElevatedSurface),
        matchesGoldenFile('elevation_two_shadow_card_$canvas.png'),
      );
    });
  }
}

/// A 20%-alpha leaderboard row: the commonest dark surface in the app, and the
/// one where a shadow showing through the fill would be most visible.
void testGoldenRow(
  String canvas,
  Brightness brightness,
  AppColors Function(Brightness) paletteFor,
  AppElevation Function(Brightness) elevationFor,
) {
  testWidgets('translucent row · $canvas', (tester) async {
    final palette = paletteFor(brightness);
    final elevation = elevationFor(brightness);

    await tester.pumpWidget(
      goldenApp(
        brightness: brightness,
        child: ElevatedSurface(
          width: 362,
          height: 64,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: palette.leaderboardRowFill,
          shadows: elevation.leaderboardListShadows,
          glass: elevation.leaderboardRowGlass,
          child: const SizedBox.expand(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ElevatedSurface),
      matchesGoldenFile('elevation_translucent_row_$canvas.png'),
    );
  });
}
