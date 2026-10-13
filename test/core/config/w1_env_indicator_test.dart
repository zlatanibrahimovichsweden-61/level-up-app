import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/app.dart';
import 'package:level_up_app/core/config/app_config.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';

import '../../features/settings/settings_harness.dart';

/// CW18a, environment indicator: a stock `Banner` ribbon on dev and staging
/// builds, wired into the REAL root widget (`LevelUpApp`), driven by the
/// compiled `Flavor` (not by `isDev`, which is true for both and tells them
/// apart not at all), absent in production and absent when `AppConfig` was
/// never initialised (every other harness that pumps `LevelUpApp`).
///
/// R2c (readiness E3): the ribbon is pinned to the top RIGHT in both languages.
/// It used to follow the layout direction, so in Arabic it sat at the top LEFT,
/// over the OS status-bar clock (which is the OS's, does not follow the app's
/// language, and is at the top left on an Android device whose SYSTEM language
/// is left-to-right, as on the walked emulator). The corner is asserted two
/// ways: on the painter's own parameters, and on the PIXELS of the rendered
/// frame, which is what a student's eye (and the clock) actually meet.
///
/// KNOWN LIMIT (pinned by the test of that name below): the pin assumes a
/// left-to-right SYSTEM language. On a phone whose own language is right-to-left
/// the OS may mirror its status bar (clock at the top right); the ribbon would
/// then sit over it in both app languages. Not checked on a device; to be
/// confirmed on an Arabic-system phone (see the `EnvironmentRibbon` doc for the
/// proposed follow-up).
void main() {
  // `AppConfig` is a process-wide singleton: a test that initialises it must
  // not leak the flavor into the next one.
  tearDown(AppConfig.resetForTesting);

  Finder ribbon() => find.byType(Banner);

  /// The painter the `Banner` actually draws with - where its corner, its
  /// colour and its (non-)interception of taps are decided.
  BannerPainter painter(WidgetTester tester) {
    final paint = tester.widget<CustomPaint>(
      find.descendant(of: ribbon(), matching: find.byType(CustomPaint)).first,
    );
    return paint.foregroundPainter! as BannerPainter;
  }

  /// The nearest repaint boundary above [finder]'s render object, as an image,
  /// with how many image pixels make one logical pixel. For the `Banner` that
  /// is the layer its foreground painter draws into: the whole frame, in
  /// PHYSICAL pixels, when the `RenderView` is the nearest boundary (the real
  /// app), and a sub-layer in logical pixels otherwise.
  Future<({ui.Image image, double scale})> capture(
    WidgetTester tester,
    Finder finder,
  ) async {
    RenderObject object = tester.element(finder.first).renderObject!;
    while (!object.isRepaintBoundary) {
      object = object.parent!;
    }
    final layer = object.debugLayer! as OffsetLayer;
    final image = (await tester.runAsync(
      () => layer.toImage(object.paintBounds),
    ))!;
    return (
      image: image,
      scale: object is RenderView ? tester.view.devicePixelRatio : 1.0,
    );
  }

  /// How many logical pixels in the 64 x 64 dp box at the top-left / top-right
  /// corner of [frame] are the ribbon's colour. The band is about 820 of them
  /// (between 40 and 57 dp from the corner along x + y), less the label.
  Future<int> ribbonPixels(
    WidgetTester tester,
    ({ui.Image image, double scale}) frame, {
    required bool right,
  }) async {
    final image = frame.image;
    final data = (await tester.runAsync(() => image.toByteData()))!;
    final want = AppTheme.light.extension<AppColors>()!.destructive;
    final wr = (want.r * 255).round();
    final wg = (want.g * 255).round();
    final wb = (want.b * 255).round();
    final box = (64 * frame.scale).round();
    final x0 = right ? image.width - box : 0;
    var count = 0;
    for (var y = 0; y < box; y++) {
      for (var x = x0; x < x0 + box; x++) {
        final i = (y * image.width + x) * 4;
        if ((data.getUint8(i) - wr).abs() <= 2 &&
            (data.getUint8(i + 1) - wg).abs() <= 2 &&
            (data.getUint8(i + 2) - wb).abs() <= 2) {
          count++;
        }
      }
    }
    return (count / (frame.scale * frame.scale)).round();
  }

  /// Below this the band is not there; the real figure is a few hundred.
  const present = 250;

  group('through the real LevelUpApp', () {
    testWidgets('dev shows a DEV ribbon', (tester) async {
      AppConfig.init(Flavor.dev);
      await pumpAppAt(tester, '/refer');

      expect(ribbon(), findsOneWidget);
      expect(tester.widget<Banner>(ribbon()).message, 'DEV');
    });

    testWidgets('staging shows a STAGING ribbon: dev and staging are told '
        'apart by the flavor, which isDev cannot do', (tester) async {
      AppConfig.init(Flavor.staging);
      await pumpAppAt(tester, '/refer');

      expect(ribbon(), findsOneWidget);
      expect(tester.widget<Banner>(ribbon()).message, 'STAGING');
      // The premise of the whole item: isDev is true for BOTH.
      expect(AppConfig.instance.isDev, isTrue);
    });

    testWidgets('prod shows no ribbon at all', (tester) async {
      AppConfig.init(Flavor.prod);
      await pumpAppAt(tester, '/refer');

      expect(ribbon(), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an uninitialised AppConfig shows no ribbon and does not '
        'throw: the other harnesses pump LevelUpApp without init', (
      tester,
    ) async {
      AppConfig.resetForTesting();
      expect(AppConfig.maybeInstance, isNull);

      await pumpAppAt(tester, '/refer');

      expect(ribbon(), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('English: the ribbon is at the top RIGHT', (tester) async {
      AppConfig.init(Flavor.dev);
      await pumpAppAt(tester, '/refer');

      expect(
        Directionality.of(tester.element(ribbon())),
        TextDirection.ltr,
        reason: 'the premise: an LTR page',
      );
      expect(painter(tester).location, BannerLocation.topEnd);
      expect(painter(tester).layoutDirection, TextDirection.ltr);

      final frame = await capture(tester, ribbon());
      expect(
        frame.image.width,
        tester.view.physicalSize.width.round(),
        reason: 'the whole frame, not a sub-layer',
      );
      expect(
        await ribbonPixels(tester, frame, right: true),
        greaterThan(present),
      );
      expect(await ribbonPixels(tester, frame, right: false), 0);
    });

    testWidgets('Arabic: the ribbon STAYS at the top RIGHT, off the OS clock '
        'at the top left (it used to follow the RTL layout to the left)', (
      tester,
    ) async {
      AppConfig.init(Flavor.dev);
      await pumpAppAt(tester, '/refer', locale: 'ar');

      // The premise: this really is a right-to-left page, so it is the pin and
      // not the language that keeps the ribbon on the right.
      expect(
        Directionality.of(tester.element(ribbon())),
        TextDirection.rtl,
        reason: 'the premise: an RTL page',
      );
      // The corner is resolved against a pinned LTR layout direction...
      expect(painter(tester).location, BannerLocation.topEnd);
      expect(painter(tester).layoutDirection, TextDirection.ltr);
      // ...and the label is Latin, so it reads left to right as well.
      expect(painter(tester).textDirection, TextDirection.ltr);

      // And what is on screen: ribbon pixels at the top right, none at the top
      // left where the clock is.
      final frame = await capture(tester, ribbon());
      expect(
        frame.image.width,
        tester.view.physicalSize.width.round(),
        reason: 'the whole frame, not a sub-layer',
      );
      expect(
        await ribbonPixels(tester, frame, right: true),
        greaterThan(present),
      );
      expect(await ribbonPixels(tester, frame, right: false), 0);
    });

    testWidgets('staging is pinned to the same corner as dev, in Arabic', (
      tester,
    ) async {
      AppConfig.init(Flavor.staging);
      await pumpAppAt(tester, '/refer', locale: 'ar');

      // The pixels are counted with the dev label only: the test font draws
      // every glyph of STAGING as a solid white box that covers the whole
      // visible band, so there is no ribbon colour left to count. The corner is
      // decided by the same two parameters whatever the label.
      expect(tester.widget<Banner>(ribbon()).message, 'STAGING');
      expect(painter(tester).location, BannerLocation.topEnd);
      expect(painter(tester).layoutDirection, TextDirection.ltr);
      expect(painter(tester).textDirection, TextDirection.ltr);
    });

    testWidgets('its colour is an existing AppColors token, on both canvases', (
      tester,
    ) async {
      AppConfig.init(Flavor.dev);
      await pumpAppAt(tester, '/refer');

      final light = Theme.of(tester.element(ribbon()));
      expect(painter(tester).color, light.extension<AppColors>()!.destructive);
      expect(
        AppTheme.dark.extension<AppColors>()!.destructive,
        AppTheme.light.extension<AppColors>()!.destructive,
        reason: 'one value on both canvases, so the ribbon reads the same',
      );
    });
  });

  group('EnvironmentRibbon on its own', () {
    // The framework's own "DEBUG" banner is another `Banner`; off, so the one
    // under test is the only one in the tree (LevelUpApp turns it off too).
    Widget host(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

    testWidgets('prod returns the child untouched: no wrapper in the tree', (
      tester,
    ) async {
      AppConfig.init(Flavor.prod);
      await tester.pumpWidget(
        host(const EnvironmentRibbon(child: SizedBox(key: Key('page')))),
      );

      expect(find.byKey(const Key('page')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(EnvironmentRibbon),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    for (final direction in TextDirection.values) {
      testWidgets('the corner is the top RIGHT whatever the ambient direction '
          'is (${direction.name})', (tester) async {
        AppConfig.init(Flavor.dev);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: Directionality(
              textDirection: direction,
              child: const Scaffold(
                body: EnvironmentRibbon(child: SizedBox.expand()),
              ),
            ),
          ),
        );

        final frame = await capture(tester, ribbon());
        expect(
          await ribbonPixels(tester, frame, right: true),
          greaterThan(present),
        );
        expect(await ribbonPixels(tester, frame, right: false), 0);
      });
    }

    testWidgets('KNOWN LIMIT: the corner does not follow the SYSTEM language '
        'either - an Arabic-system phone still gets the top RIGHT', (
      tester,
    ) async {
      // This pins what the code does today, not what a device is known to
      // need: whether an Arabic-system phone mirrors its clock to the top
      // right (where this ribbon would then sit) has not been looked at. If a
      // later change derives the corner from the platform locale, this is the
      // test to flip.
      tester.platformDispatcher.localeTestValue = const Locale('ar', 'EG');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      AppConfig.init(Flavor.dev);
      await tester.pumpWidget(
        host(const EnvironmentRibbon(child: SizedBox.expand())),
      );

      expect(
        tester.platformDispatcher.locale.languageCode,
        'ar',
        reason: 'the premise: the system language is Arabic',
      );
      expect(painter(tester).location, BannerLocation.topEnd);
      expect(painter(tester).layoutDirection, TextDirection.ltr);
      final frame = await capture(tester, ribbon());
      expect(
        await ribbonPixels(tester, frame, right: true),
        greaterThan(present),
      );
      expect(await ribbonPixels(tester, frame, right: false), 0);
    });

    testWidgets('a tap ON the ribbon reaches the page beneath it, in Arabic '
        'too', (tester) async {
      AppConfig.init(Flavor.staging);
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: EnvironmentRibbon(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => taps++,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      );

      // The ribbon is at the top right, so (width - 24, 24) is ON it; the same
      // tap on the other side would be on the page only.
      final size = tester.getSize(find.byType(EnvironmentRibbon));
      await tester.tapAt(Offset(size.width - 24, 24));
      expect(taps, 1);
      expect(painter(tester).hitTest(Offset(size.width - 24, 24)), isFalse);
    });

    testWidgets('a tap ON the ribbon reaches the page beneath it', (
      tester,
    ) async {
      AppConfig.init(Flavor.staging);
      var taps = 0;
      await tester.pumpWidget(
        host(
          EnvironmentRibbon(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps++,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );
      expect(ribbon(), findsOneWidget);

      // The strip is 12dp thick and runs at 45 degrees across the top-end
      // corner; its centre line is 34dp from the corner along the strip's own
      // axis, i.e. 24dp in from each edge. So (width - 24, 24) is ON the ribbon.
      final size = tester.getSize(find.byType(EnvironmentRibbon));
      await tester.tapAt(Offset(size.width - 24, 24));

      expect(taps, 1);
      // And the painter itself reports no hit anywhere, which is what lets the
      // tap through.
      expect(painter(tester).hitTest(const Offset(10, 10)), isFalse);
    });
  });
}
