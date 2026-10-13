import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart';
import '../flashcards/reading_order.dart';

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

  // BUG-020, the part the flashcard fix left open (KNOWN_BUGS.md): a catalog
  // row's NAME is the content's language (adr-018), which need not be the app's
  // - an Arabic lecture in the English app, an English one in the Arabic app.
  // Laid out in the app's direction, a name's neutral punctuation lands at the
  // wrong end ("?" at the START of an English name in the Arabic app). The name
  // takes `contentTextDirection` and stays aligned at the app's start; the
  // badge, the chevron and the row's mirroring stay the app's.
  //
  // Caveat, recorded with the rule: first-strong direction reads an Arabic
  // sentence that opens on a Latin term as left-to-right.
  group(
    'BUG-020: the name takes its own direction, aligned at the app start',
    () {
      Future<void> pumpName(
        WidgetTester tester, {
        required String locale,
        required String name,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(locale),
            home: Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 363,
                  child: TreeListRow(index: 3, name: name, onTap: () {}),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      Rect rowRect(WidgetTester tester) =>
          tester.getRect(find.byType(TreeListRow));
      Rect chevronRect(WidgetTester tester) => tester.getRect(
        find.descendant(
          of: find.byType(TreeListRow),
          matching: find.byType(Icon),
        ),
      );
      Rect badgeRect(WidgetTester tester) => tester.getRect(
        find.descendant(
          of: find.byType(TreeListRow),
          matching: find.byType(ElevatedSurface),
        ),
      );

      // (app language, name, the direction the NAME reads in)
      for (final (locale, name, direction) in [
        ('en', 'الخلية والأنسجة', TextDirection.rtl),
        ('ar', 'Cell Biology', TextDirection.ltr),
        ('en', 'Cell Biology', TextDirection.ltr),
        ('ar', 'الخلية والأنسجة', TextDirection.rtl),
        // No letters at all: the app's own direction.
        ('en', '2024', TextDirection.ltr),
        ('ar', '2024', TextDirection.rtl),
      ]) {
        testWidgets('$locale app · "$name" reads ${direction.name}', (
          tester,
        ) async {
          await pumpName(tester, locale: locale, name: name);

          final text = tester.widget<Text>(find.text(name));
          expect(text.textDirection, direction);
          // At the APP's start, whatever the name's own direction is.
          expect(
            text.textAlign,
            locale == 'ar' ? TextAlign.right : TextAlign.left,
          );

          // The name begins where the text column does: 12 after the badge.
          final name_ = tester.getRect(find.text(name));
          if (locale == 'ar') {
            expect(badgeRect(tester).left - name_.right, closeTo(12, 0.01));
          } else {
            expect(name_.left - badgeRect(tester).right, closeTo(12, 0.01));
          }
          expect(tester.takeException(), isNull);
        });
      }

      for (final (locale, name, direction) in [
        // The "?" that the Arabic app drew at the START of an English name.
        ('ar', 'What is a cell?', TextDirection.ltr),
        ('ar', 'Cell (part 1).', TextDirection.ltr),
        // The full stop that the English app drew at the right end of an Arabic
        // name.
        ('en', 'الخلية (الجزء 1).', TextDirection.rtl),
      ]) {
        testWidgets('$locale app · "$name" keeps its marks in reading order', (
          tester,
        ) async {
          await pumpName(tester, locale: locale, name: name);

          expectReadingOrder(
            tester.renderObject<RenderParagraph>(find.text(name)),
            name,
            direction,
          );
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('the badge and the chevron stay the app\'s: English app, '
          'Arabic name', (tester) async {
        await pumpName(tester, locale: 'en', name: 'الخلية والأنسجة');

        expect(
          badgeRect(tester).left - rowRect(tester).left,
          closeTo(17, 0.01),
        );
        expect(
          rowRect(tester).right - chevronRect(tester).right,
          closeTo(12, 0.01),
        );
      });

      testWidgets('the badge and the chevron stay the app\'s: Arabic app, '
          'English name', (tester) async {
        await pumpName(tester, locale: 'ar', name: 'Cell Biology');

        expect(
          rowRect(tester).right - badgeRect(tester).right,
          closeTo(17, 0.01),
        );
        expect(
          chevronRect(tester).left - rowRect(tester).left,
          closeTo(12, 0.01),
        );
      });
    },
  );

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

  // RESPONSIVE.md #12 (measured 2026-09-25 with the app's own fonts): the
  // caption beside a progress bar overflowed 17 px at 320 dp and 2.0x in
  // English, and at 250 dp from 1.3x. The caption now takes at most the room the
  // row has and ellipsises past it. A caption that fits is laid out exactly as
  // it always was.
  //
  // Last in the file, because it loads the real fonts for the rest of this
  // isolate - the test face draws every glyph a full em wide and would turn
  // every row here into an overflow case.
  group('the caption gives way instead of overflowing (RESPONSIVE #12)', () {
    setUpAll(loadAppFonts);

    Future<AppLocalizations> pumpRow(
      WidgetTester tester, {
      required String locale,
      required double width,
      required double scale,
      int answered = 480,
      int total = 480,
    }) async {
      final l10n = await AppLocalizations.delegate.load(Locale(locale));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(locale),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: TreeListRow(
                  index: 1,
                  name: 'Cell Biology',
                  progress: 0.45,
                  caption: l10n.questionsCount(answered, total),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return l10n;
    }

    /// The width the caption would take with all the room it wanted.
    double naturalWidth(WidgetTester tester, String caption) {
      final paragraph = tester.renderObject<RenderParagraph>(
        find.text(caption),
      );
      final painter = TextPainter(
        text: paragraph.text,
        textDirection: paragraph.textDirection,
        textScaler: paragraph.textScaler,
        maxLines: 1,
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    Rect barRect(WidgetTester tester) => tester.getRect(
      find.descendant(
        of: find.byType(TreeListRow),
        matching: find.byType(LinearProgressIndicator),
      ),
    );

    for (final locale in ['en', 'ar']) {
      final rtl = locale == 'ar';

      // Wide enough: the caption is laid out in full, the bar fills the rest -
      // what the row always did. (Every size here fits in the app's fonts.)
      for (final (width, scale) in [(411.0, 1.0), (375.0, 1.0), (363.0, 1.3)]) {
        testWidgets('$width dp · $locale · ${scale}x · unchanged: whole '
            'caption, bar fills the rest', (tester) async {
          final l10n = await pumpRow(
            tester,
            locale: locale,
            width: width,
            scale: scale,
          );
          final caption = l10n.questionsCount(480, 480);
          final text = tester.getRect(find.text(caption));
          final bar = barRect(tester);

          expect(tester.takeException(), isNull);
          expect(
            text.width,
            closeTo(naturalWidth(tester, caption), 0.01),
            reason: 'not ellipsised',
          );
          // 8 between the bar and the caption, and nothing left over.
          if (rtl) {
            expect(bar.left - text.right, closeTo(8, 0.01));
          } else {
            expect(text.left - bar.right, closeTo(8, 0.01));
          }
        });
      }

      // The narrow cases: nothing overflows, the caption stays inside the text
      // column and ellipsises, and the bar takes what is left (it may take
      // none).
      // The widths are the ROW's: a screen minus the list's two 20 gutters, so
      // RESPONSIVE.md's "320 dp" screen is a 280 row and its "250 dp" one 210.
      for (final (width, scale, answered, total) in [
        // A 4-digit counter on a 320 dp screen at 2.0x: RESPONSIVE.md's
        // measured 17 px. (A 3-digit one fits there; it is below.)
        (280.0, 2.0, 1234, 5678),
        (280.0, 1.3, 1234, 5678),
        (280.0, 2.0, 480, 480),
        (210.0, 1.3, 480, 480), // the measured "from 1.3x" (a 250 dp screen)
        (210.0, 2.0, 480, 480),
        (320.0, 2.0, 480, 480),
        (250.0, 2.0, 480, 480),
      ]) {
        testWidgets('$width dp · $locale · ${scale}x · $answered/$total · no '
            'overflow, caption inside the row', (tester) async {
          final l10n = await pumpRow(
            tester,
            locale: locale,
            width: width,
            scale: scale,
            answered: answered,
            total: total,
          );
          final caption = l10n.questionsCount(answered, total);
          final row = tester.getRect(find.byType(TreeListRow));
          final text = tester.getRect(find.text(caption));
          final bar = barRect(tester);
          final chevron = tester.getRect(
            find.descendant(
              of: find.byType(TreeListRow),
              matching: find.byType(Icon),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(row.left <= text.left && text.right <= row.right, isTrue);
          // Clear of the chevron, on the side it is not.
          if (rtl) {
            expect(text.left, greaterThanOrEqualTo(chevron.right));
          } else {
            expect(text.right, lessThanOrEqualTo(chevron.left));
          }
          // The bar never overlaps the caption.
          expect(bar.width, greaterThanOrEqualTo(0));
          if (rtl) {
            expect(bar.left, greaterThanOrEqualTo(text.right));
          } else {
            expect(bar.right, lessThanOrEqualTo(text.left));
          }
        });
      }
    }
  });
}
