import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/catalog/widgets/module_picker.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart';
import 'module_fixtures.dart';

/// The module pills, measured in the app's OWN fonts.
///
/// The placeholder test face draws every glyph a full em wide, so in
/// `module_picker_test.dart` even "Foundation Module" wraps at 1.3 on a 360 dp
/// screen. Inter, Tajawal and Cairo do not: this file loads them and checks the
/// real thing at the narrowest supported width, up to 2.0x text, in both
/// languages, light and dark. The widths are device-faithful; the heights are
/// the point - a pill is one line (a 48 tap target) at the scales a student
/// actually uses, and wraps instead of overflowing beyond that.
void main() {
  setUpAll(loadAppFonts);

  Finder pill(String id) => find.byKey(Key('module_pill_$id'));

  for (final language in ['en', 'ar']) {
    for (final (canvas, theme) in [
      ('light', AppTheme.light),
      ('dark', AppTheme.dark),
    ]) {
      for (final screenWidth in [320.0, 360.0]) {
        for (final scale in [1.0, 1.3, 2.0]) {
          testWidgets('fits · $language · $canvas · $screenWidth dp · '
              '${scale}x', (tester) async {
            tester.view.physicalSize = Size(screenWidth, 780);
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            await tester.pumpWidget(
              MaterialApp(
                locale: Locale(language),
                theme: theme,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, app) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(scale)),
                  child: app!,
                ),
                home: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ModulePicker(
                        modules: u1Modules(),
                        selectedId: 'mod-foundation',
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
            for (final id in ['all', 'mod-foundation', 'mod-cardio']) {
              final size = tester.getSize(pill(id));
              expect(size.height, greaterThanOrEqualTo(48), reason: id);
              expect(size.width, lessThanOrEqualTo(screenWidth - 40 + 0.01));
              if (scale <= 1.3) {
                expect(
                  size.height,
                  closeTo(48, 0.01),
                  reason: '$id is one line at ${scale}x',
                );
              }
            }
          });
        }
      }
    }
  }

  // The frame's pill is 35 tall (1411:17130 / 1411:17132), drawn inside a
  // 48 tap target. At the default text scale the drawn pill is exactly that,
  // selected or idle - choosing a pill must not make it grow.
  test(
    'the named geometry: 35 drawn, 48 tap, 25 visual gap, 18.5 to the box',
    () {
      expect(ModulePicker.pillHeight, 35);
      expect(ModulePicker.tapTarget, 48);
      expect(ModulePicker.visualGap, 25);
      // The pill sits centred in its box, (48 - 35) / 2 = 6.5 off each edge, so
      // a visual gap of 25 is 18.5 measured to the box.
      expect(ModulePicker.gapToTapBox, 18.5);
    },
  );

  for (final language in ['en', 'ar']) {
    for (final (canvas, theme) in [
      ('light', AppTheme.light),
      ('dark', AppTheme.dark),
    ]) {
      testWidgets('drawn 35 tall inside a 48 tap target, selected or idle · '
          '$language · $canvas · 1.0x', (tester) async {
        tester.view.physicalSize = const Size(360, 780);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            theme: theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ModulePicker(
                    modules: u1Modules(),
                    selectedId: 'mod-foundation',
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        for (final id in ['all', 'mod-foundation', 'mod-cardio']) {
          final box = tester.getRect(pill(id));
          final drawn = tester.getRect(
            find.descendant(
              of: pill(id),
              matching: find.byType(ElevatedSurface),
            ),
          );
          expect(drawn.height, closeTo(35, 0.01), reason: '$id drawn height');
          expect(box.height, greaterThanOrEqualTo(48), reason: '$id tap box');
          expect(
            drawn.center.dy,
            closeTo(box.center.dy, 0.01),
            reason: '$id is centred in its tap box',
          );
        }
      });
    }
  }

  for (final language in ['en', 'ar']) {
    testWidgets('no overflow at 1.3x, and a pill is never shorter than the '
        'frame\'s 35 · $language', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, app) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: app!,
          ),
          home: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ModulePicker(
                  modules: u1Modules(),
                  selectedId: 'mod-cardio',
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      for (final id in ['all', 'mod-foundation', 'mod-cardio']) {
        final drawn = tester.getSize(
          find.descendant(of: pill(id), matching: find.byType(ElevatedSurface)),
        );
        expect(drawn.height, greaterThanOrEqualTo(35), reason: id);
        expect(tester.getSize(pill(id)).height, greaterThanOrEqualTo(48));
      }
    });
  }
}
