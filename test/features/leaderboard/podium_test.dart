/// The podium's rank badges, mounted directly.
///
/// Each place has its own fill and stroke in both frames (`Ranks`, `134:3421`
/// light / `337:5577` dark). Until API→UI Wave 06 every badge took one
/// near-black stroke and places 2 and 3 shared one fill; these cases pin what
/// the frames draw.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/leaderboard/widgets/podium.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'leaderboard_fixtures.dart';

void main() {
  Widget host(Widget child, {required Brightness brightness}) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: Center(child: child)),
  );

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  /// The badge that carries [numeral]: the circle drawn right around it.
  BoxDecoration badge(WidgetTester tester, String numeral) {
    final box = tester.widget<Container>(
      find
          .ancestor(of: find.text(numeral), matching: find.byType(Container))
          .first,
    );
    return box.decoration! as BoxDecoration;
  }

  for (final brightness in Brightness.values) {
    testWidgets('${brightness.name} · each place has its own badge colours', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Podium(top: [entry(1), entry(2), entry(3)]),
          brightness: brightness,
        ),
      );
      final ext = colours(brightness);

      final first = badge(tester, '1');
      expect(first.color, ext.podiumFirstRing); // #FFCA28
      expect(first.border, Border.all(color: ext.textPrimary));

      final second = badge(tester, '2');
      expect(second.color, const Color(0xFFF4F4F4)); // 134:3426 / 337:5582
      expect(second.border, Border.all(color: const Color(0xFFDC4A22)));

      final third = badge(tester, '3');
      expect(third.color, const Color(0xFFFCFBF9)); // 134:3423 / 337:5579
      expect(third.border, Border.all(color: const Color(0xFFDEDEDE)));
    });
  }

  testWidgets('a tie keeps the PLACE colours; the numeral says the rank', (
    tester,
  ) async {
    // Dense ranking: two students on 990 share rank 1 and fill places 1 and 2.
    await tester.pumpWidget(
      host(
        Podium(top: [entry(1), entry(1, points: 990), entry(2, points: 980)]),
        brightness: Brightness.light,
      ),
    );

    final ones = find.text('1');
    expect(ones, findsNWidgets(2));
    // The tree runs 2 · 1 · 3 (the frame's layout), so the first '1' found is
    // place 2's badge and the second is the winner's.
    BoxDecoration at(int i) =>
        tester
                .widget<Container>(
                  find
                      .ancestor(
                        of: ones.at(i),
                        matching: find.byType(Container),
                      )
                      .first,
                )
                .decoration!
            as BoxDecoration;

    expect(at(0).border, Border.all(color: const Color(0xFFDC4A22)));
    expect(at(1).color, colours(Brightness.light).podiumFirstRing);
  });
}
