/// One board row, mounted directly: its text colours, the caller's fill and
/// its geometry, each against the frame.
///
/// None of these had been read off the frame until the Wave 06 device walk
/// (2026-09-25), which read `134:3537` / `134:3553` (light) and `337:5629` /
/// `337:5637` (dark). The build had the points a shade lighter than the name,
/// the caller's row three units of red off, a 36 avatar at 48 and 10 between
/// rows — W06-2, W06-3 and W06-4.
library;

import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/leaderboard/widgets/board_avatar.dart';
import 'package:level_up_app/features/leaderboard/widgets/leaderboard_row.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart';
import 'leaderboard_fixtures.dart';

void main() {
  Widget host(
    Widget child, {
    Brightness brightness = Brightness.light,
    String locale = 'en',
  }) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale(locale),
    home: Scaffold(
      body: Center(child: SizedBox(width: 362, child: child)),
    ),
  );

  Color? colourOf(WidgetTester tester, Finder text) =>
      tester.widget<Text>(text).style?.color;

  // entry(4) scores 1000 - 4 * 10.
  final points = find.textContaining('960');

  // ------------------------------------------------------------ W06-2 ------
  // Rank, name and points share ONE colour per canvas: `#4F4F4F` in light
  // (`134:3541` / `134:3544` / `134:3539`), `#FCFBF9` in dark (`337:5633` /
  // `337:5636` / `337:5631`). The points are not quieter than the name.
  for (final (brightness, hex, label) in [
    (Brightness.light, const Color(0xFF4F4F4F), '#4F4F4F'),
    (Brightness.dark, const Color(0xFFFCFBF9), '#FCFBF9'),
  ]) {
    testWidgets('${brightness.name} · rank, name and points are all $label', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(LeaderboardRow(entry: entry(4)), brightness: brightness),
      );

      expect(colourOf(tester, find.text('4')), hex);
      expect(colourOf(tester, find.text('Student 4')), hex);
      expect(colourOf(tester, points), hex);
    });
  }

  // ------------------------------------------------------------ W06-3 ------
  testWidgets('the caller\'s own row is #DBB0FF on both canvases', (
    tester,
  ) async {
    for (final b in Brightness.values) {
      await tester.pumpWidget(
        host(LeaderboardRow(entry: entry(4, isMe: true)), brightness: b),
      );

      final surface = tester.widget<ElevatedSurface>(
        find.byType(ElevatedSurface),
      );
      // `134:3554` light, `337:5638` dark. It was #D8B0FF until the walk read
      // the row; the #D8B0FF reading belonged to nothing in the frame.
      expect(surface.color, const Color(0xFFDBB0FF), reason: b.name);
      expect(colourOf(tester, find.text('You')), const Color(0xFFFCFBF9));
      expect(colourOf(tester, points), const Color(0xFFFCFBF9));
    }
  });

  // ------------------------------------------------------------ W06-4 ------
  group('geometry · 134:3542 "Person"', () {
    testWidgets('a 32 avatar starting 40 in, the rank centred on 22', (
      tester,
    ) async {
      await tester.pumpWidget(host(LeaderboardRow(entry: entry(4))));

      final row = tester.getRect(find.byType(LeaderboardRow));
      final avatar = tester.getRect(find.byType(BoardAvatar));
      final rank = tester.getRect(find.text('4'));

      expect(avatar.size, const Size(32, 32));
      // `left-[11.08%]` of 362 = 40.1.
      expect(avatar.left - row.left, 40);
      // The digit's centre in the frame: 22.2 for "4", 22.7 for "10".
      expect(rank.center.dx - row.left, 22);
    });

    testWidgets('Arabic mirrors it: the avatar ends 40 from the right', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(LeaderboardRow(entry: entry(4)), locale: 'ar'),
      );

      final row = tester.getRect(find.byType(LeaderboardRow));
      final avatar = tester.getRect(find.byType(BoardAvatar));

      expect(avatar.size, const Size(32, 32));
      expect(row.right - avatar.right, 40);
    });
  });

  // ------------------------------------------------------------ a11y -------
  // TalkBack: a row is one stop reading "rank, name, points", and the avatar
  // photo is not a stop of its own. Asserted on `flagsCollection` (the flags
  // Android maps to a role), not on `isSemantics(isImage: false)` - the lesson
  // of BUG-021/024.
  for (final locale in ['en', 'ar']) {
    group('semantics · $locale', () {
      testWidgets('an ordinary row is one node: rank, name, points', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          host(LeaderboardRow(entry: entry(4)), locale: locale),
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(LeaderboardRow)),
        );

        final node = tester.getSemantics(find.byType(LeaderboardRow));
        final data = node.getSemanticsData();
        expect(data.label.split('\n'), [
          '4',
          'Student 4',
          l10n.leaderboardPoints(960),
        ]);
        expect(
          node.childrenCount,
          0,
          reason: 'nothing keeps a node of its own',
        );
        expect(data.flagsCollection.isImage, isFalse, reason: 'avatar photo');
        expect(data.flagsCollection.isButton, isFalse);
        expect(data.flagsCollection.isSelected, Tristate.isFalse);
        handle.dispose();
      });

      testWidgets('the caller\'s row reads "You" and stays selected', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          host(LeaderboardRow(entry: entry(4, isMe: true)), locale: locale),
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(LeaderboardRow)),
        );

        final node = tester.getSemantics(find.byType(LeaderboardRow));
        final data = node.getSemanticsData();
        // The name is replaced by "You", never repeated beside it.
        expect(data.label.split('\n'), [
          '4',
          l10n.leaderboardYou,
          l10n.leaderboardPoints(960),
        ]);
        expect(node.childrenCount, 0);
        expect(data.flagsCollection.isImage, isFalse);
        expect(data.flagsCollection.isSelected, Tristate.isTrue);
        handle.dispose();
      });
    });
  }

  // The row owns its node. In the board it sits in a list item that is already
  // a semantics boundary, but nothing about the row may DEPEND on that: laid
  // side by side in a plain column (no boundary around each), two rows must
  // still read as two nodes, not run together into one long sentence.
  testWidgets('two rows in a plain column are two nodes, not one', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 362,
            child: Column(
              children: [
                LeaderboardRow(entry: entry(4)),
                LeaderboardRow(entry: entry(5, isMe: true)),
              ],
            ),
          ),
        ),
      ),
    );
    final l10n = AppLocalizations.of(
      tester.element(find.byType(LeaderboardRow).first),
    );

    final first = tester.getSemantics(find.text('Student 4'));
    final second = tester.getSemantics(find.text(l10n.leaderboardYou));
    expect(first.id, isNot(second.id));
    expect(first.getSemanticsData().label.split('\n'), [
      '4',
      'Student 4',
      l10n.leaderboardPoints(960),
    ]);
    expect(second.getSemanticsData().label.split('\n'), [
      '5',
      l10n.leaderboardYou,
      l10n.leaderboardPoints(950),
    ]);
    handle.dispose();
  });

  // Last, because it loads the real fonts for the rest of this isolate.
  group("in the app's own fonts", () {
    // The placeholder test face draws every glyph a full em wide, so "200"
    // would wrap in ANY 28 column there. Inter is what the phone draws.
    setUpAll(loadAppFonts);

    testWidgets('a three-digit rank still fits its column on one line', (
      tester,
    ) async {
      // The board shows up to rank 200 (the contract's display bound), which
      // the frame never draws. Moving the avatar to 40 must not cost the
      // column its three digits.
      await tester.pumpWidget(host(LeaderboardRow(entry: entry(200))));

      expect(tester.takeException(), isNull);
      final rank = tester.getRect(find.text('200'));
      final avatar = tester.getRect(find.byType(BoardAvatar));
      expect(rank.right, lessThanOrEqualTo(avatar.left));
      // One line: taller would mean the digits wrapped.
      expect(rank.height, lessThan(30));
    });
  });
}
