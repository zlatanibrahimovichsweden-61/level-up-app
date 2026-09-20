import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/profile/widgets/profile_stat_card.dart';

/// `ProfileStatCard`'s surface, on both canvases · edit5 item #23.
///
/// **This file replaces `palette_discipline_test.dart`'s `a card on each
/// canvas` group**, which pinned the opposite values: a `Container` with a
/// `BoxShadow`, cream in dark, at blur 1. All three were wrong and all three
/// were deliberate at the time — the card was the last proof that
/// `AppColors.elevationShadow` reached a call site, and `elevationShadow`'s
/// dark value is the cream derivation DESIGN_ISSUES #47 later overturned.
///
/// What the frame actually draws (Properties panel, edit5.md §5 #23):
///
/// * light `661:8571` — `#FCFBF9`, black 25% at (0.02, 0.02) blur **2**;
/// * dark `661:8579` — **opaque** `#27282C`, the SAME black shadow, no Glass.
///
/// The dark node is the evidence for the whole wave's "dark shadows are black"
/// rule, which is why its opacity and its shadow colour are both asserted here
/// rather than taken on trust from the token file.
void main() {
  /// `Color.fromRGBO(0, 0, 0, 0.25)`, the palette's own spelling — NOT
  /// `Color(0x40000000)`, which is 64/255 = 0.2510 and fails by one part in a
  /// thousand. Same constant `app_elevation_test.dart` uses.
  const black25 = Color.fromRGBO(0, 0, 0, 0.25);

  Future<ElevatedSurface> surfaceOf(
    WidgetTester tester,
    Brightness brightness,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        home: const Scaffold(
          body: Center(
            child: ProfileStatCard(label: 'Points', value: '3,700'),
          ),
        ),
      ),
    );
    return tester.widget<ElevatedSurface>(
      find.descendant(
        of: find.byType(ProfileStatCard),
        matching: find.byType(ElevatedSurface),
      ),
    );
  }

  group('the shadow is the frame\'s, on both canvases', () {
    for (final (name, brightness) in const [
      ('light', Brightness.light),
      ('dark', Brightness.dark),
    ]) {
      testWidgets('$name draws black 25% at (0.02, 0.02) blur 2', (
        tester,
      ) async {
        final surface = await surfaceOf(tester, brightness);
        final shadow = surface.shadows.single;

        expect(shadow.color, black25);
        expect(shadow.offset, const Offset(0.02, 0.02));
        expect(shadow.blur, 2);
        expect(
          shadow.inset,
          isFalse,
          reason: 'the stat card is raised, not recessed',
        );
      });
    }

    testWidgets('the two canvases carry the IDENTICAL shadow', (tester) async {
      final light = await surfaceOf(tester, Brightness.light);
      final dark = await surfaceOf(tester, Brightness.dark);

      // The inverse of what the deleted group asserted. `661:8579` is the node
      // that was measured to settle #47: the dark card's shadow is the same
      // black as light's, not a cream one derived from "black cannot read on a
      // dark canvas".
      expect(dark.shadows, light.shadows);
    });
  });

  group('the fill differs, and the dark one is opaque', () {
    testWidgets('light is #FCFBF9', (tester) async {
      final surface = await surfaceOf(tester, Brightness.light);
      expect(surface.color, const Color(0xFFFCFBF9));
      expect(surface.color, AppColors.light.profileStatFill);
    });

    testWidgets('dark is a SOLID #27282C — not the block\'s usual 20%', (
      tester,
    ) async {
      final surface = await surfaceOf(tester, Brightness.dark);
      expect(surface.color, const Color(0xFF27282C));
      expect(
        surface.color!.a,
        1.0,
        reason:
            'every other dark surface in this block is a 20% wash; `661:8579` '
            'is the exception and the exception is what makes its black '
            'shadow visible',
      );
    });
  });

  testWidgets('no Glass on either canvas', (tester) async {
    for (final brightness in Brightness.values) {
      final surface = await surfaceOf(tester, brightness);
      expect(
        surface.glass,
        isNull,
        reason:
            '`661:8579` carries no Glass effect. A rim here would be invented, '
            'and on an opaque fill it would read as a hairline nobody drew.',
      );
      expect(surface.backlights, isEmpty);
    }
  });

  testWidgets('the token, not a literal, is what reaches the surface', (
    tester,
  ) async {
    final surface = await surfaceOf(tester, Brightness.dark);
    expect(surface.shadows, AppElevation.dark.profileStatShadows);
    expect(surface.color, AppColors.dark.profileStatFill);
  });
}
