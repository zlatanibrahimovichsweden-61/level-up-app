import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The drill-down row's PALETTE and its index disc · edit3.md #42.
///
/// Two things moved on 2026-09-19 and both are token reads, which is the class
/// of change that compiles, analyses clean and is wrong on one canvas only:
///
///  * the catalog row stopped borrowing `catalogCardFill` / `fieldBorder` and
///    took its own `treeRow*` tokens, because the row frames turn out to
///    specify a GREEN hairline and a LAVENDER disc that the borrowed grey
///    values never matched;
///  * the disc became an `ElevatedSurface`, so the dark 20% disc carries the
///    Glass rim that separates it from the opaque row under it.
///
/// The Mistakes palette is asserted alongside because the two share one widget
/// and the whole point of the tuple is that neither leaks into the other.
void main() {
  Widget host(TreeRowPalette palette, {required Brightness brightness}) =>
      MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TreeListRow(
            index: 1,
            name: 'Cell Biology',
            palette: palette,
            onTap: () {},
          ),
        ),
      );

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  /// The row's own fill — the `Material` the row is built on, not the disc's.
  Material rowMaterial(WidgetTester tester) => tester.widget(
    find
        .descendant(
          of: find.byType(TreeListRow),
          matching: find.byType(Material),
        )
        .first,
  );

  BoxDecoration rowDecoration(WidgetTester tester) =>
      tester
              .widget<Container>(
                find
                    .descendant(
                      of: find.byType(TreeListRow),
                      matching: find.byType(Container),
                    )
                    .first,
              )
              .decoration
          as BoxDecoration;

  ElevatedSurface disc(WidgetTester tester) => tester.widget(
    find.descendant(
      of: find.byType(TreeListRow),
      matching: find.byType(ElevatedSurface),
    ),
  );

  // -------------------------------------------------------------------------
  group('catalog palette · 337:5926', () {
    testWidgets('light: a GREEN hairline and a LAVENDER disc', (tester) async {
      await tester.pumpWidget(
        host(TreeRowPalette.catalog, brightness: Brightness.light),
      );

      final ext = colours(Brightness.light);
      expect(rowMaterial(tester).color, ext.treeRowFill);
      // `#4B675E`, the row frame's own green — NOT the grey `fieldBorder` this
      // row borrowed until edit3.
      expect(
        (rowDecoration(tester).border! as Border).top.color,
        ext.treeRowBorder,
      );
      expect(ext.treeRowBorder, const Color(0xFF4B675E));
      expect((rowDecoration(tester).border! as Border).top.width, 0.5);
      // `#F4E6FF`, not `cardFill`.
      expect(disc(tester).color, ext.treeRowBadgeFill);
      expect(ext.treeRowBadgeFill, const Color(0xFFF4E6FF));
    });

    testWidgets('dark: a CREAM hairline over the opaque row', (tester) async {
      await tester.pumpWidget(
        host(TreeRowPalette.catalog, brightness: Brightness.dark),
      );

      final ext = colours(Brightness.dark);
      expect(rowMaterial(tester).color, ext.treeRowFill);
      expect(
        (rowDecoration(tester).border! as Border).top.color,
        ext.treeRowBorder,
      );
      expect(ext.treeRowBorder, const Color(0xFFFCFBF9));
      expect(disc(tester).color, ext.treeRowBadgeFill);
    });
  });

  // -------------------------------------------------------------------------
  group('the index disc', () {
    testWidgets('dark: the disc carries Glass; the row stays flat', (
      tester,
    ) async {
      for (final palette in TreeRowPalette.values) {
        await tester.pumpWidget(host(palette, brightness: Brightness.dark));
        await tester.pumpAndSettle();

        final d = disc(tester);
        expect(
          d.glass,
          AppElevation.dark.treeRowBadgeGlass,
          reason: '$palette',
        );
        expect(d.glass, isNotNull, reason: '$palette');
        // The rim is the only elevation on this row — Figma draws no shadow
        // on it at either level, on either canvas.
        expect(d.shadows, isEmpty, reason: '$palette');
        expect(d.backlights, isEmpty, reason: '$palette');
        expect(d.shape, isA<CircleBorder>(), reason: '$palette');
      }
    });

    testWidgets('light: no Glass on either palette', (tester) async {
      for (final palette in TreeRowPalette.values) {
        await tester.pumpWidget(host(palette, brightness: Brightness.light));
        await tester.pumpAndSettle();
        expect(disc(tester).glass, isNull, reason: '$palette');
      }
      expect(AppElevation.light.treeRowBadgeGlass, isNull);
    });

    testWidgets('is still the frame\'s 40 dp circle with the row\'s digit', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(TreeRowPalette.catalog, brightness: Brightness.light),
      );

      expect(tester.getSize(find.byType(ElevatedSurface)), const Size(40, 40));
      expect(find.text('1'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  testWidgets('the Mistakes palette is untouched by the catalog move', (
    tester,
  ) async {
    // Its four values were read off `404:7765` on 2026-09-12 and the #70 ruling
    // is explicit that they do not move — edit3 adds disc Glass and nothing
    // else (edit3.md §10).
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        host(TreeRowPalette.mistakes, brightness: brightness),
      );
      await tester.pumpAndSettle();

      final ext = colours(brightness);
      expect(rowMaterial(tester).color, ext.mistakesRowFill);
      expect(
        (rowDecoration(tester).border! as Border).top.color,
        ext.mistakesRowBorder,
      );
      expect(disc(tester).color, ext.mistakesBadgeFill);
    }
  });
}
