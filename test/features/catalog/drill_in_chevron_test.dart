/// The drill-in chevron points FORWARD: right in English, left in Arabic.
///
/// Every Material chevron carries `matchTextDirection: true`, so [Icon] mirrors
/// it in RTL by itself. `forwardChevron()` used to swap the glyph for RTL as
/// well, and the two flips cancelled: the chevron pointed right in both
/// languages. That was proven on a tablet (2026-09-20) and fixed in API→UI Wave
/// 07.
///
/// The check is made on what gets DRAWN, not on which glyph was picked: the
/// glyph's own direction, reversed if [Icon] wrapped it in its mirroring
/// [Transform]. Asserting the glyph alone would have passed the broken helper.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/catalog/widgets/subject_card.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/features/mistakes/widgets/mistakes_subject_card.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../mistakes/mistakes_fixtures.dart';
import 'catalog_fixtures.dart';

void main() {
  Widget host(Widget child, {required String locale}) => MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale(locale),
    home: Scaffold(
      body: Center(child: SizedBox(width: 173, height: 89, child: child)),
    ),
  );

  /// True when the chevron inside [owner] is drawn pointing RIGHT.
  bool drawnPointingRight(WidgetTester tester, Finder owner) {
    // The Mistakes overview card draws the frame's own `weui:arrow-filled`
    // (the shared `chevron.svg`, which points right as drawn) rather than a
    // Material glyph (API→UI Wave 15). An SVG is not mirrored by anything
    // but its own ancestors, so it points right unless a Transform between
    // it and [owner] flips it.
    final svg = find.descendant(of: owner, matching: find.byType(SvgPicture));
    if (svg.evaluate().isNotEmpty) {
      expect(svg, findsOneWidget);
      final loader = tester.widget<SvgPicture>(svg).bytesLoader;
      expect((loader as SvgAssetLoader).assetName, 'assets/icons/chevron.svg');
      expect(
        find.descendant(of: owner, matching: find.byType(Icon)),
        findsNothing,
      );
      final flipped = tester
          .widgetList<Transform>(
            find.descendant(
              of: owner,
              matching: find.ancestor(
                of: svg,
                matching: find.byType(Transform),
              ),
            ),
          )
          .where((t) => t.transform.storage[0] < 0)
          .length;
      return flipped.isEven;
    }

    final icon = find.descendant(of: owner, matching: find.byType(Icon));
    expect(icon, findsOneWidget);

    final glyph = tester.widget<Icon>(icon).icon;
    final bool glyphPointsRight;
    if (glyph == Icons.chevron_right) {
      glyphPointsRight = true;
    } else if (glyph == Icons.chevron_left) {
      glyphPointsRight = false;
    } else {
      fail('unexpected drill-in glyph: $glyph');
    }

    // `Icon` mirrors a matchTextDirection glyph with a Transform whose x scale
    // is -1 (flutter/lib/src/widgets/icon.dart).
    final mirrored = tester
        .widgetList<Transform>(
          find.descendant(of: icon, matching: find.byType(Transform)),
        )
        .any((t) => t.transform.storage[0] < 0);

    return glyphPointsRight != mirrored;
  }

  final sites = <String, (Widget, Type)>{
    'SubjectCard (Subjects grid)': (
      SubjectCard(subject: subjects().first, onTap: () {}),
      SubjectCard,
    ),
    'TreeListRow (Units, Chapters, Lessons)': (
      TreeListRow(index: 1, name: 'Cell Biology', onTap: () {}),
      TreeListRow,
    ),
    'MistakesSubjectCard (Mistakes overview)': (
      MistakesSubjectCard(subject: mistakesOverview().first, onTap: () {}),
      MistakesSubjectCard,
    ),
  };

  for (final MapEntry(key: name, value: (widget, type)) in sites.entries) {
    group(name, () {
      testWidgets('points RIGHT in English', (tester) async {
        await tester.pumpWidget(host(widget, locale: 'en'));
        expect(drawnPointingRight(tester, find.byType(type)), isTrue);
      });

      testWidgets('points LEFT in Arabic', (tester) async {
        await tester.pumpWidget(host(widget, locale: 'ar'));
        expect(
          drawnPointingRight(tester, find.byType(type)),
          isFalse,
          reason:
              'forward is LEFT in RTL. A glyph swapped for RTL AND mirrored by '
              'Icon points right again.',
        );
      });
    });
  }
}
