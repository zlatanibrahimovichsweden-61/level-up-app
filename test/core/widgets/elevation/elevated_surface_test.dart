import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/glass_surface.dart';

void main() {
  const opaqueLavender = Color.fromRGBO(174, 135, 231, 1);

  Widget host(
    Widget child, {
    Brightness brightness = Brightness.light,
    TextDirection direction = TextDirection.ltr,
  }) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    home: Directionality(
      textDirection: direction,
      child: Scaffold(body: Center(child: child)),
    ),
  );

  group('it renders every shape the design uses', () {
    for (final entry in <String, ShapeBorder>{
      'rounded rectangle': RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      'stadium': const StadiumBorder(),
      'circle': const CircleBorder(),
      'directional radii': const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.horizontal(
          start: Radius.circular(20),
        ),
      ),
    }.entries) {
      testWidgets(entry.key, (tester) async {
        await tester.pumpWidget(
          host(
            ElevatedSurface(
              width: 120,
              height: 60,
              shape: entry.value,
              color: AppColors.light.cardFill,
              side: const BorderSide(width: 0.03),
              shadows: AppElevation.light.profileHeaderShadows,
              child: const SizedBox.expand(),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(ElevatedSurface), findsOneWidget);
      });
    }

    testWidgets('a top-only hairline renders without a uniform one', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          ElevatedSurface(
            width: 200,
            height: 44,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.light.topStudentFill,
            topSide: BorderSide(
              color: AppColors.light.topStudentBorder,
              width: AppElevation.light.topStudentBorderWidth,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('the backdrop is opt-in', () {
    testWidgets('uniform — the default — creates NO BackdropFilter', (
      tester,
    ) async {
      // The whole point of the tier-1 model: a BackdropFilter per surface,
      // including per list row, for a blur of a flat colour that cannot show.
      await tester.pumpWidget(
        host(
          ElevatedSurface(
            width: 120,
            height: 60,
            shape: const StadiumBorder(),
            color: AppColors.dark.profileHeaderFill,
            glass: AppElevation.dark.profileHeaderGlass,
            child: const SizedBox.expand(),
          ),
          brightness: Brightness.dark,
        ),
      );

      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('content — the onboarding sheet — creates exactly one', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          ElevatedSurface(
            width: 200,
            height: 120,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            color: AppColors.dark.sheetFill,
            glass: AppElevation.dark.onboardingSheetGlass,
            backdrop: GlassBackdrop.content,
            child: const SizedBox.expand(),
          ),
          brightness: Brightness.dark,
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });

  group('ink', () {
    testWidgets('onTap adds an InkWell over the fill and fires', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          ElevatedSurface(
            width: 120,
            height: 60,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.light.profileMenuRowFill,
            onTap: () => taps++,
            child: const SizedBox.expand(),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
      // Transparency, so the surface's own fill stays visible under the ink.
      expect(
        tester.widget<Material>(find.byType(Material).last).type,
        MaterialType.transparency,
      );

      await tester.tap(find.byType(ElevatedSurface));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('no onTap means no InkWell at all', (tester) async {
      await tester.pumpWidget(
        host(
          ElevatedSurface(
            width: 120,
            height: 60,
            shape: const CircleBorder(),
            color: AppColors.light.cardFill,
            child: const SizedBox.expand(),
          ),
        ),
      );
      expect(find.byType(InkWell), findsNothing);
    });
  });

  group('back-lights', () {
    // Painted directly rather than through the widget: the question is where
    // the lavender lands, and a pixel is the only answer that is not an
    // inference. Frost 0 keeps the ellipse hard-edged so the reading is exact.
    const surface = Size(100, 40);
    const glass = GlassStyle(
      frost: 0,
      refraction: 1,
      depth: 0,
      lightAngle: 0,
      lightIntensity: 0,
      dispersion: 0,
      splay: 0,
    );
    const light = Backlight(
      offset: Offset(10, 5),
      size: Size(20, 10),
      color: opaqueLavender,
    );

    Future<List<int>> alphaMap(TextDirection direction) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, surface.width, surface.height),
      );
      paintBacklights(canvas, surface, const [light], glass, direction);
      final image = await recorder.endRecording().toImage(
        surface.width.toInt(),
        surface.height.toInt(),
      );
      final data = (await image.toByteData())!;
      image.dispose();
      return [
        for (var i = 0; i < surface.width.toInt() * surface.height.toInt(); i++)
          data.getUint8(i * 4 + 3),
      ];
    }

    int at(List<int> alpha, int x, int y) =>
        alpha[y * surface.width.toInt() + x];

    testWidgets('LTR draws it at the measured offset', (tester) async {
      await tester.runAsync(() async {
        final alpha = await alphaMap(TextDirection.ltr);
        expect(at(alpha, 20, 10), 255, reason: 'centre of the ellipse');
        expect(at(alpha, 80, 10), 0, reason: 'nothing on the far side');
      });
    });

    testWidgets('RTL mirrors it, so the glow stays behind the leading edge', (
      tester,
    ) async {
      await tester.runAsync(() async {
        // x' = width - x - w = 100 - 10 - 20 = 70, so the centre moves to 80.
        final alpha = await alphaMap(TextDirection.rtl);
        expect(at(alpha, 80, 10), 255);
        expect(at(alpha, 20, 10), 0);
      });
    });

    testWidgets('the vertical offset is NOT mirrored', (tester) async {
      await tester.runAsync(() async {
        final alpha = await alphaMap(TextDirection.rtl);
        expect(at(alpha, 80, 10), 255);
        expect(at(alpha, 80, 30), 0, reason: 'y stays where Figma put it');
      });
    });

    testWidgets('a back-light without Glass trips the debug assert', (
      tester,
    ) async {
      // R6: the glow IS the ellipse seen through the frost. Without a
      // GlassStyle it would render as a hard lavender blob, which is a bug
      // that looks deliberate.
      await tester.pumpWidget(
        host(
          ElevatedSurface(
            width: 120,
            height: 60,
            shape: const StadiumBorder(),
            backlights: const [light],
            child: const SizedBox.expand(),
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });
  });

  testWidgets('it adds no semantics of its own', (tester) async {
    // A raised rectangle is not a control. If this ever changes, every card in
    // the app gains a node in the accessibility tree.
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        ElevatedSurface(
          width: 120,
          height: 60,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.light.cardFill,
          child: const Text('label'),
        ),
      ),
    );

    expect(find.bySemanticsLabel('label'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('label')),
      isSemantics(isButton: false, label: 'label'),
    );
    handle.dispose();
  });
}
