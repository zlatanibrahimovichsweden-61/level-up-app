import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/form_fields.dart';
import 'package:level_up_app/core/widgets/language_pill.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The three pieces of shared chrome edit2 moved onto `ElevatedSurface`.
///
/// They are checked through the `ElevatedSurface` they configure rather than
/// through recorded paint: the primitive's own painting is edit1's test, and
/// what can actually regress here is a widget reading the WRONG TOKEN — the
/// exact defect that shipped a cream back-chip fallback and a language pill
/// painted in the page colour.
void main() {
  Widget host(
    Widget child, {
    required Brightness brightness,
    TextDirection direction = TextDirection.ltr,
  }) {
    return MaterialApp(
      theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Directionality(
        textDirection: direction,
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }

  ElevatedSurface surfaceOf(WidgetTester tester, Type owner) => tester.widget(
    find.descendant(
      of: find.byType(owner),
      matching: find.byType(ElevatedSurface),
    ),
  );

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  AppElevation elevation(Brightness b) =>
      b == Brightness.light ? AppElevation.light : AppElevation.dark;

  // -------------------------------------------------------------------------
  group('CircleBackButton', () {
    for (final brightness in Brightness.values) {
      final canvas = brightness.name;

      testWidgets('$canvas · the standard variant takes the standard tokens', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(CircleBackButton(onPressed: () {}), brightness: brightness),
        );
        final surface = surfaceOf(tester, CircleBackButton);

        expect(surface.color, colours(brightness).backChipSurfaceFill);
        expect(surface.glass, elevation(brightness).backChipGlass);
        expect(surface.shadows, elevation(brightness).backChipShadows);
        expect(surface.shape, isA<CircleBorder>());
      });

      testWidgets('$canvas · the registration variant is a DIFFERENT chip', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            CircleBackButton(
              onPressed: () {},
              variant: BackChipVariant.registration,
            ),
            brightness: brightness,
          ),
        );
        final surface = surfaceOf(tester, CircleBackButton);

        expect(surface.color, colours(brightness).registrationBackChipFill);
        expect(surface.glass, elevation(brightness).registrationBackChipGlass);
      });
    }

    testWidgets(
      'dark elevates with Glass and NO shadow — a reading, not a gap',
      (tester) async {
        expect(AppElevation.dark.backChipShadows, isEmpty);
        expect(AppElevation.dark.backChipGlass, isNotNull);
        expect(AppElevation.light.backChipShadows, isNotEmpty);
        expect(AppElevation.light.backChipGlass, isNull);

        await tester.pumpWidget(
          host(CircleBackButton(onPressed: () {}), brightness: Brightness.dark),
        );
        expect(surfaceOf(tester, CircleBackButton).shadows, isEmpty);
      },
    );

    testWidgets('the two dark variants really are different values', (
      tester,
    ) async {
      expect(
        AppColors.dark.registrationBackChipFill,
        isNot(AppColors.dark.backChipSurfaceFill),
      );
      expect(
        AppElevation.dark.registrationBackChipGlass,
        isNot(AppElevation.dark.backChipGlass),
      );
    });

    testWidgets('the chevron still flips for RTL', (tester) async {
      await tester.pumpWidget(
        host(CircleBackButton(onPressed: () {}), brightness: Brightness.light),
      );
      final ltr = tester.widget<Transform>(
        find.descendant(
          of: find.byType(CircleBackButton),
          matching: find.byType(Transform),
        ),
      );

      await tester.pumpWidget(
        host(
          CircleBackButton(onPressed: () {}),
          brightness: Brightness.light,
          direction: TextDirection.rtl,
        ),
      );
      final rtl = tester.widget<Transform>(
        find.descendant(
          of: find.byType(CircleBackButton),
          matching: find.byType(Transform),
        ),
      );

      // The asset points END-ward, so LTR mirrors it and RTL does not.
      expect(ltr.transform, isNot(rtl.transform));
    });

    testWidgets('it is still a button, and still taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          CircleBackButton(onPressed: () => taps++),
          brightness: Brightness.light,
        ),
      );
      await tester.tap(find.byType(CircleBackButton));
      expect(taps, 1);
      // NOT an image. The chevron `SvgPicture` used to merge its own
      // `isImage` into this node, and Android then reported the chip as an
      // `ImageView` on every screen that has it (API→UI Wave 13 device walk;
      // the W11-7 mechanism).
      expect(
        tester.getSemantics(find.byType(CircleBackButton)),
        isSemantics(
          isButton: true,
          isImage: false,
          hasTapAction: true,
          label: const DefaultMaterialLocalizations().backButtonTooltip,
        ),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('FieldShell', () {
    testWidgets('light draws the 1.17338 hairline and no Glass', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const FieldShell(child: Text('x')), brightness: Brightness.light),
      );
      final surface = surfaceOf(tester, FieldShell);

      expect(surface.side!.width, 1.17338);
      expect(surface.side!.color, AppColors.light.fieldBorder);
      expect(surface.glass, isNull);
      expect(surface.color, AppColors.light.fieldFill);
    });

    testWidgets('dark draws the 0.03 seam under Glass', (tester) async {
      await tester.pumpWidget(
        host(const FieldShell(child: Text('x')), brightness: Brightness.dark),
      );
      final surface = surfaceOf(tester, FieldShell);

      expect(surface.side!.width, 0.03);
      expect(surface.glass, AppElevation.dark.fieldGlass);
      expect(surface.color, AppColors.dark.fieldFill);
    });

    for (final brightness in Brightness.values) {
      testWidgets('${brightness.name} · the error state keeps its own 1.5', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            const FieldShell(hasError: true, child: Text('x')),
            brightness: brightness,
          ),
        );
        final surface = surfaceOf(tester, FieldShell);
        final theme = brightness == Brightness.light
            ? AppTheme.light
            : AppTheme.dark;

        expect(surface.side!.width, 1.5);
        expect(surface.side!.color, theme.colorScheme.error);
      });
    }

    testWidgets('disabled dims the whole field and kills the tap', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          FieldShell(
            enabled: false,
            onTap: () => taps++,
            child: const Text('x'),
          ),
          brightness: Brightness.light,
        ),
      );

      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(FieldShell),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        0.6,
      );
      expect(surfaceOf(tester, FieldShell).onTap, isNull);

      await tester.tap(find.byType(FieldShell), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('it is still 60 tall and start-aligned', (tester) async {
      await tester.pumpWidget(
        host(const FieldShell(child: Text('x')), brightness: Brightness.light),
      );
      expect(tester.getSize(find.byType(FieldShell)).height, 60);
      expect(surfaceOf(tester, FieldShell).height, 60);
    });
  });

  // -------------------------------------------------------------------------
  group('LanguagePill', () {
    testWidgets('light draws the 0.629032 hairline and no Glass', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          LanguagePill(label: 'العربية', onTap: () {}),
          brightness: Brightness.light,
        ),
      );
      final surface = surfaceOf(tester, LanguagePill);

      expect(surface.side!.width, 0.629032);
      expect(surface.side!.color, AppColors.light.languagePillBorder);
      expect(surface.glass, isNull);
      expect(surface.color, AppColors.light.languagePillFill);
    });

    testWidgets('dark has NO border at all, and Glass instead', (tester) async {
      await tester.pumpWidget(
        host(
          LanguagePill(label: 'English', onTap: () {}),
          brightness: Brightness.dark,
        ),
      );
      final surface = surfaceOf(tester, LanguagePill);

      expect(AppColors.dark.languagePillBorder, isNull);
      expect(surface.side, isNull);
      expect(surface.glass, AppElevation.dark.languagePillGlass);
      // Not `background`: painting the page colour is what made it vanish.
      expect(surface.color, AppColors.dark.languagePillFill);
      expect(surface.color, isNot(AppColors.dark.background));
    });

    testWidgets('it is a stadium at the frame height, and taps', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          LanguagePill(label: 'English', onTap: () => taps++),
          brightness: Brightness.light,
        ),
      );
      final surface = surfaceOf(tester, LanguagePill);

      expect(surface.shape, isA<StadiumBorder>());
      expect(surface.height, 36.10);
      await tester.tap(find.byType(LanguagePill));
      expect(taps, 1);
    });

    testWidgets('it is ONE button node labelled by its text, not an image', (
      tester,
    ) async {
      // `ElevatedSurface` adds no semantics and the glyph's image semantics
      // used to win the merge: TalkBack said "English, image" and never
      // "button". Fable-eye audit 2026-10-06, FE-06.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          LanguagePill(label: 'English', onTap: () {}),
          brightness: Brightness.light,
        ),
      );

      final node = tester.getSemantics(find.byType(LanguagePill));
      expect(node.label, 'English');
      expect(node.flagsCollection.isButton, isTrue, reason: 'a button');
      expect(node.flagsCollection.isImage, isFalse, reason: 'not an image');
      handle.dispose();
    });
  });

  // -------------------------------------------------------------------------
  // CW17: the banner is built only while connectivity is down, so it appears
  // WITHOUT the student doing anything - which a screen reader never says
  // aloud unless the node is a live region. No copy of its own: the words are
  // the visible Text's.
  group('OfflineBanner', () {
    Widget bannerHost(String locale, {Brightness? brightness}) => MaterialApp(
      theme: (brightness ?? Brightness.light) == Brightness.light
          ? AppTheme.light
          : AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(locale),
      home: const Scaffold(body: Column(children: [OfflineBanner()])),
    );

    for (final locale in ['en', 'ar']) {
      testWidgets('$locale · one live-region node that says it is offline', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(bannerHost(locale));
        final l10n = AppLocalizations.of(
          tester.element(find.byType(OfflineBanner)),
        );
        expect(
          Directionality.of(tester.element(find.byType(OfflineBanner))),
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );

        final node = tester.getSemantics(find.byType(OfflineBanner));
        final flags = node.getSemanticsData().flagsCollection;
        expect(node.label, l10n.offline);
        expect(flags.isLiveRegion, isTrue, reason: 'announced when it appears');
        // Nothing else: not a button, not an image (the glyph is decoration).
        expect(flags.isButton, isFalse);
        expect(flags.isImage, isFalse);
        expect(node.childrenCount, 0, reason: 'one stop, not two');
        handle.dispose();
      });
    }

    testWidgets('it adds no pixel: full width, 38 tall, on both canvases', (
      tester,
    ) async {
      // 10 + the 18 line of `labelLarge` (14/18) + 10. The live region is a
      // semantics-only wrapper, so this is the height the banner always had.
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(bannerHost('en', brightness: brightness));

        final size = tester.getSize(find.byType(OfflineBanner));
        expect(size.width, 800, reason: brightness.name);
        expect(size.height, 38, reason: brightness.name);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
