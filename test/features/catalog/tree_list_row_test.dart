import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
  Widget host(
    TreeRowPalette palette, {
    required Brightness brightness,
    bool tappable = true,
    double? progress,
    String? caption,
    ThemeData? theme,
  }) => MaterialApp(
    theme:
        theme ??
        (brightness == Brightness.light ? AppTheme.light : AppTheme.dark),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: TreeListRow(
        index: 1,
        name: 'Cell Biology',
        palette: palette,
        progress: progress,
        caption: caption,
        onTap: tappable ? () {} : null,
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
  // API→UI Wave 08 (W08-3, W08-4). Read 2026-09-25 off the light row `135:1064`
  // (Units) / `309:5714` (Lectures) and the dark row `337:5926`: the chevron is
  // a STROKE in the row's own hairline colour, and the bar and its caption are
  // lavender on BOTH canvases. The build drew the chevron in `textPrimary` and
  // the bar in the theme primary, which is green in light.
  group('chevron and progress · 135:1064 / 337:5926', () {
    for (final (brightness, chevron) in [
      (Brightness.light, 0xFF4B675E), // 135:1078 stroke
      (Brightness.dark, 0xFFFCFBF9), // 337:5938 stroke
    ]) {
      testWidgets('${brightness.name}: the chevron is the frame\'s stroke', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(TreeRowPalette.catalog, brightness: brightness),
        );

        final icon = tester.widget<Icon>(
          find.descendant(
            of: find.byType(TreeListRow),
            matching: find.byType(Icon),
          ),
        );
        expect(icon.color, Color(chevron));
      });
    }

    for (final (brightness, track) in [
      (Brightness.light, 0xFFECECEC), // 135:1074
      (Brightness.dark, 0xFF2E2D32), // 337:5935
    ]) {
      testWidgets('${brightness.name}: the bar and its caption are lavender', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            TreeRowPalette.catalog,
            brightness: brightness,
            progress: 0.5,
            caption: '30 / 60 questions',
          ),
        );

        final bar = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(bar.color, const Color(0xFFAE87E7)); // 135:1075 / 337:5936
        expect(bar.backgroundColor, Color(track));
        expect(
          tester.widget<Text>(find.text('30 / 60 questions')).style!.color,
          const Color(0xFFAE87E7), // 135:1077 / 337:5937
        );
      });
    }

    testWidgets('the Mistakes chevron is its own stroke token (Wave 16)', (
      tester,
    ) async {
      // A probe colour, because in dark the token EQUALS mistakesContent
      // (#FCFBF9): only a distinct value shows which token the row reads.
      const probe = Color(0xFF123456);
      for (final brightness in Brightness.values) {
        final base = brightness == Brightness.light
            ? AppTheme.light
            : AppTheme.dark;
        await tester.pumpWidget(
          host(
            TreeRowPalette.mistakes,
            brightness: brightness,
            theme: base.copyWith(
              extensions: [
                for (final e in base.extensions.values)
                  e is AppColors ? e.copyWith(mistakesRowChevron: probe) : e,
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        final icon = tester.widget<Icon>(
          find.descendant(
            of: find.byType(TreeListRow),
            matching: find.byType(Icon),
          ),
        );
        expect(icon.color, probe);
      }
    });
  });

  // -------------------------------------------------------------------------
  // API→UI Wave 08 (W08-1). The row is an `InkWell`, which gives a node a tap
  // ACTION but not the button FLAG, so TalkBack read a row's name and never
  // said it could be pressed. `_MistakesButton` had the same gap and the same
  // fix.
  group('semantics', () {
    testWidgets('a row with somewhere to go is ONE button node', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          TreeRowPalette.catalog,
          brightness: Brightness.light,
          progress: 0.5,
          caption: '30 / 60 questions',
        ),
      );

      final node = tester.getSemantics(find.byType(TreeListRow));
      expect(node, isSemantics(isButton: true, hasTapAction: true));
      // One merged node: the disc's number, the name and the progress caption
      // are all on it, not scattered over siblings a screen reader steps
      // through one by one.
      expect(node.label, contains('1'));
      expect(node.label, contains('Cell Biology'));
      expect(node.label, contains('30 / 60 questions'));
      handle.dispose();
    });

    // W08-6, found on the Wave 08 device walk. The bar's own semantics carry
    // `SemanticsRole.progressBar` and a 0–100 range; merged into the row they
    // made Android expose every Lectures row as a `ProgressBar`, not a
    // `Button`, although the flag above was set. The caption already says the
    // progress in words, so the bar contributes nothing to the node.
    testWidgets('a row with a bar is still a button, not a progress bar', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          TreeRowPalette.catalog,
          brightness: Brightness.light,
          progress: 0.37,
          caption: '44 / 120 questions',
        ),
      );

      final node = tester.getSemantics(find.byType(TreeListRow));
      expect(node.role, isNot(SemanticsRole.progressBar));
      expect(node.value, isEmpty, reason: 'the bar\'s "37" led the label');
      expect(node.minValue, anyOf(isNull, isEmpty));
      expect(node.maxValue, anyOf(isNull, isEmpty));
      expect(node, isSemantics(isButton: true, hasTapAction: true));
      expect(node.label, contains('44 / 120 questions'));
      handle.dispose();
    });

    testWidgets('an inert row is NOT announced as a button', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          TreeRowPalette.mistakes,
          brightness: Brightness.light,
          tappable: false,
        ),
      );

      final node = tester.getSemantics(find.byType(TreeListRow));
      expect(node, isSemantics(isButton: false, hasTapAction: false));
      expect(node.label, contains('Cell Biology'));
      handle.dispose();
    });
  });

  // -------------------------------------------------------------------------
  // DESIGN_ISSUES #100, owner ruling 2026-09-27: every catalog row frame (light
  // `135:1064` `135:1302` `308:4769` `309:5656`, dark `337:5926` `348:7457`
  // `348:7527` `349:16001`) ends its content container, and the 28-dp chevron
  // with it, 12 from the row's end; the build ended it 17 in.
  group('#100: the catalog row ends its content 12 from its edge', () {
    Future<void> pumpRow(
      WidgetTester tester, {
      TextDirection direction = TextDirection.ltr,
      double? progress,
      String? caption,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Directionality(
            textDirection: direction,
            child: Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 363,
                  child: TreeListRow(
                    index: 1,
                    name: 'Cell Biology',
                    progress: progress,
                    caption: caption,
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Rect row(WidgetTester tester) => tester.getRect(find.byType(TreeListRow));
    Rect chevron(WidgetTester tester) => tester.getRect(
      find.descendant(
        of: find.byType(TreeListRow),
        matching: find.byType(Icon),
      ),
    );
    Rect badge(WidgetTester tester) => tester.getRect(
      find.descendant(
        of: find.byType(TreeListRow),
        matching: find.byType(ElevatedSurface),
      ),
    );

    testWidgets('the chevron ends 12 from the end; the disc still starts 17 '
        'in', (tester) async {
      await pumpRow(tester);

      expect(row(tester).right - chevron(tester).right, closeTo(12, 0.01));
      expect(chevron(tester).width, 28);
      expect(badge(tester).left - row(tester).left, closeTo(17, 0.01));
      // The top and bottom are unchanged: 16.5 + the 0.5 border around the
      // 40-dp disc.
      expect(row(tester).height, closeTo(74, 0.01));
    });

    testWidgets('mirrored in Arabic: the chevron ends 12 from the LEFT', (
      tester,
    ) async {
      await pumpRow(tester, direction: TextDirection.rtl);

      expect(chevron(tester).left - row(tester).left, closeTo(12, 0.01));
      expect(row(tester).right - badge(tester).right, closeTo(17, 0.01));
    });

    testWidgets('the text column is the frames\' 242, so the caption ends 12 '
        'before the chevron', (tester) async {
      await pumpRow(tester, progress: 0.8, caption: '80%');

      final name = tester.getRect(find.text('Cell Biology'));
      final caption = tester.getRect(find.text('80%'));
      // The column starts 12 after the disc and ends 12 before the chevron.
      expect(name.left - badge(tester).right, closeTo(12, 0.01));
      expect(chevron(tester).left - caption.right, closeTo(12, 0.01));
      expect(chevron(tester).left - 12 - name.left, closeTo(242, 0.01));
    });
  });

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
