import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/catalog/models/catalog_module.dart';
import 'package:level_up_app/features/catalog/widgets/module_picker.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'module_fixtures.dart';

/// The pill row on its own: order, the START edge, what a pill says to a screen
/// reader, the tap target - at text scale 1.3 in both languages - and the light
/// pill style the designer drew (Figma `1411:16920` / `1411:17138`). The dark
/// style and the Arabic frame are still PROVISIONAL (DG-26).
void main() {
  Finder pill(String id) => find.byKey(Key('module_pill_$id'));

  /// The surface a pill draws: its fill, hairline, shadows and Glass.
  ElevatedSurface surfaceOf(WidgetTester tester, String id) =>
      tester.widget<ElevatedSurface>(
        find.descendant(of: pill(id), matching: find.byType(ElevatedSurface)),
      );

  Text labelOf(WidgetTester tester, String id) => tester.widget<Text>(
    find.descendant(of: pill(id), matching: find.byType(Text)),
  );

  Future<void> pumpPicker(
    WidgetTester tester, {
    required List<CatalogModule> modules,
    String? selectedId,
    ValueChanged<String?>? onChanged,
    String locale = 'en',
    ThemeData? theme,
    double scale = 1.3,
  }) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        theme: theme ?? AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          // A Column that stretches, as the Subjects screen hosts it.
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModulePicker(
                modules: modules,
                selectedId: selectedId,
                onChanged: onChanged ?? (_) {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final (locale, all) in [('en', 'All subjects'), ('ar', 'كل المواد')]) {
    group(locale, () {
      testWidgets('"All subjects" first, then one pill per module in the '
          'server\'s order, the names verbatim', (tester) async {
        await pumpPicker(tester, modules: u1Modules(), locale: locale);

        expect(find.text(all), findsOneWidget);
        expect(find.text('Foundation Module'), findsOneWidget);
        expect(find.text('Cardiovascular Module'), findsOneWidget);

        final allX = tester.getCenter(pill('all')).dx;
        final foundationX = tester.getCenter(pill('mod-foundation')).dx;
        final cardioX = tester.getCenter(pill('mod-cardio')).dx;
        if (locale == 'en') {
          expect(allX, lessThan(foundationX));
          expect(foundationX, lessThan(cardioX));
        } else {
          // RTL: the row starts at the RIGHT edge with no direction code.
          expect(allX, greaterThan(foundationX));
          expect(foundationX, greaterThan(cardioX));
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('starts at the START edge, 20 in', (tester) async {
        await pumpPicker(tester, modules: u1Modules(), locale: locale);

        final rect = tester.getRect(pill('all'));
        if (locale == 'en') {
          expect(rect.left, closeTo(20, 0.01));
        } else {
          expect(rect.right, closeTo(360 - 20, 0.01));
        }
      });

      testWidgets('lays out at text scale 1.3 without overflow', (
        tester,
      ) async {
        await pumpPicker(tester, modules: u1Modules(), locale: locale);

        expect(tester.takeException(), isNull);
        // Each pill is a 48 tap target at the very least.
        for (final id in ['all', 'mod-foundation', 'mod-cardio']) {
          expect(
            tester.getSize(pill(id)).height,
            greaterThanOrEqualTo(48),
            reason: '$id tap target',
          );
        }
      });

      testWidgets('a long module name wraps inside the pill instead of '
          'overflowing or growing past the screen', (tester) async {
        final long = module(
          id: 'mod-long',
          name:
              'Musculoskeletal Locomotor and Integumentary Systems Foundation '
              'Module',
        );
        await pumpPicker(
          tester,
          modules: [long, ...u1Modules()],
          locale: locale,
        );

        expect(tester.takeException(), isNull);
        final rect = tester.getRect(pill('mod-long'));
        expect(rect.width, lessThanOrEqualTo(360 - 2 * 20 + 0.01));
        expect(
          rect.height,
          greaterThan(48),
          reason: 'two lines make the pill taller, not clipped',
        );
      });

      testWidgets('tapping a pill reports its id; All reports null', (
        tester,
      ) async {
        final taps = <String?>[];
        await pumpPicker(
          tester,
          modules: u1Modules(),
          selectedId: 'mod-foundation',
          onChanged: taps.add,
          locale: locale,
        );

        await tester.tap(pill('all'));
        await tester.pump();
        await tester.ensureVisible(pill('mod-cardio'));
        await tester.pumpAndSettle();
        await tester.tap(pill('mod-cardio'));
        await tester.pump();

        expect(taps, [null, 'mod-cardio']);
      });

      testWidgets('each pill is ONE button node; only the chosen one is '
          'selected', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpPicker(
          tester,
          modules: u1Modules(),
          selectedId: 'mod-foundation',
          locale: locale,
        );

        final expected = {
          'all': all,
          'mod-foundation': 'Foundation Module',
          'mod-cardio': 'Cardiovascular Module',
        };
        for (final entry in expected.entries) {
          await tester.ensureVisible(pill(entry.key));
          await tester.pumpAndSettle();
          final node = tester.getSemantics(pill(entry.key));
          expect(node.flagsCollection.isButton, isTrue, reason: entry.key);
          expect(
            node.flagsCollection.isSelected,
            entry.key == 'mod-foundation' ? Tristate.isTrue : Tristate.isFalse,
            reason: '${entry.key} selected flag',
          );
          expect(node.label, entry.value, reason: '${entry.key} label');
          expect(
            node.getSemanticsData().hasAction(SemanticsAction.tap),
            isTrue,
            reason: '${entry.key} is tappable',
          );
        }
        handle.dispose();
      });

      testWidgets('with no selection, All subjects is the selected pill', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpPicker(tester, modules: u1Modules(), locale: locale);

        expect(
          tester.getSemantics(pill('all')).flagsCollection.isSelected,
          Tristate.isTrue,
        );
        expect(
          tester
              .getSemantics(pill('mod-foundation'))
              .flagsCollection
              .isSelected,
          Tristate.isFalse,
        );
        handle.dispose();
      });
    });
  }

  group('the light pill is the frame\'s (1411:16920 / 1411:17138)', () {
    const light = AppColors.light;

    testWidgets('the SELECTED pill: #384F47 fill, white SemiBold 14 label, no '
        'border, no shadow, no Glass', (tester) async {
      await pumpPicker(tester, modules: u1Modules(), scale: 1);

      final surface = surfaceOf(tester, 'all'); // null selection = All.
      expect(surface.color, light.modulePillSelectedFill);
      expect(surface.color, const Color(0xFF384F47));
      expect(surface.side, isNull, reason: 'the selected pill has no border');
      expect(surface.shadows, isEmpty, reason: 'the frame draws no shadow');
      expect(surface.glass, isNull);
      expect(surface.shape, isA<StadiumBorder>());

      final label = labelOf(tester, 'all');
      expect(
        label.style,
        AppType.labelLarge.copyWith(color: light.modulePillSelectedLabel),
      );
      expect(label.style!.color, const Color(0xFFFFFFFF));
      expect(label.style!.fontSize, AppType.labelLarge.fontSize);
    });

    testWidgets('an IDLE pill: white fill, 1 px #DEDEDE border, #384F47 label, '
        'no shadow', (tester) async {
      await pumpPicker(tester, modules: u1Modules(), scale: 1);

      final surface = surfaceOf(tester, 'mod-foundation');
      expect(surface.color, light.modulePillIdleFill);
      expect(surface.color, const Color(0xFFFFFFFF));
      expect(surface.side, isNotNull);
      expect(surface.side!.color, light.modulePillIdleBorder);
      expect(surface.side!.color, const Color(0xFFDEDEDE));
      expect(surface.side!.width, 1);
      expect(surface.shadows, isEmpty, reason: 'the frame draws no shadow');
      expect(surface.glass, isNull, reason: 'Glass is dark only');
      expect(surface.shape, isA<StadiumBorder>());

      final label = labelOf(tester, 'mod-foundation');
      expect(
        label.style,
        AppType.labelLarge.copyWith(color: light.modulePillIdleLabel),
      );
      expect(label.style!.color, const Color(0xFF384F47));
    });

    testWidgets('choosing a pill moves the look, not the size: the label and '
        'the pill are the same width selected or idle', (tester) async {
      Future<(Size, Size, Size, Size)> measure(String? selectedId) async {
        await pumpPicker(
          tester,
          modules: u1Modules(),
          selectedId: selectedId,
          scale: 1,
        );
        return (
          tester.getSize(
            find.descendant(of: pill('all'), matching: find.byType(Text)),
          ),
          tester.getSize(pill('all')),
          tester.getSize(
            find.descendant(
              of: pill('mod-foundation'),
              matching: find.byType(Text),
            ),
          ),
          tester.getSize(pill('mod-foundation')),
        );
      }

      // First "All subjects" is chosen, then "Foundation".
      final allChosen = await measure(null);
      final foundationChosen = await measure('mod-foundation');

      expect(
        foundationChosen.$1.width,
        allChosen.$1.width,
        reason: '"All subjects" label width, selected vs idle',
      );
      expect(foundationChosen.$2.width, allChosen.$2.width);
      expect(
        foundationChosen.$3.width,
        allChosen.$3.width,
        reason: '"Foundation Module" label width, idle vs selected',
      );
      expect(foundationChosen.$4.width, allChosen.$4.width);
      // Neither does the height move.
      expect(foundationChosen.$2.height, allChosen.$2.height);
      expect(foundationChosen.$4.height, allChosen.$4.height);
    });
  });

  group('the dark pill is the look it had before the frame, unchanged', () {
    const dark = AppColors.dark;

    testWidgets('SELECTED: the same purple fill and dark label as before; '
        'no border, shadow or Glass', (tester) async {
      await pumpPicker(
        tester,
        modules: u1Modules(),
        theme: AppTheme.dark,
        scale: 1,
      );

      final surface = surfaceOf(tester, 'all');
      expect(surface.color, dark.notificationChipSelectedFill);
      expect(surface.color, const Color(0xFFAE87E7));
      expect(surface.side, isNull);
      expect(surface.shadows, isEmpty);
      expect(surface.glass, isNull);
      expect(
        labelOf(tester, 'all').style,
        AppType.labelLarge.copyWith(color: dark.notificationChipSelectedLabel),
      );
      expect(labelOf(tester, 'all').style!.color, const Color(0xFF232428));
    });

    testWidgets('IDLE: the same 20% fill under Glass G5 as before; still no '
        'border, no shadow', (tester) async {
      await pumpPicker(
        tester,
        modules: u1Modules(),
        theme: AppTheme.dark,
        scale: 1,
      );

      final surface = surfaceOf(tester, 'mod-foundation');
      expect(surface.color, dark.notificationChipIdleFill);
      expect(surface.color, const Color(0x3327282C));
      expect(surface.side, isNull, reason: 'dark has no border token');
      expect(surface.shadows, isEmpty);
      expect(surface.glass, isNotNull);
      expect(surface.glass, same(AppElevation.dark.notificationChipIdleGlass));
      expect(
        labelOf(tester, 'mod-foundation').style,
        AppType.labelLarge.copyWith(color: dark.notificationChipIdleLabel),
      );
      expect(
        labelOf(tester, 'mod-foundation').style!.color,
        const Color(0xFFFCFBF9),
      );
    });
  });

  testWidgets('draws in the dark canvas too, selected and idle, with no '
      'exception', (tester) async {
    await pumpPicker(
      tester,
      modules: u1Modules(),
      selectedId: 'mod-cardio',
      theme: AppTheme.dark,
    );

    expect(tester.takeException(), isNull);
    expect(pill('all'), findsOneWidget);
  });

  testWidgets('a module name is never looked up in the ARB: an Arabic UI '
      'shows the server\'s string as sent', (tester) async {
    await pumpPicker(
      tester,
      modules: [module(id: 'm', name: 'Foundation Module')],
      locale: 'ar',
    );

    expect(find.text('Foundation Module'), findsOneWidget);
  });
}
