import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/home/widgets/level_card.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart';

/// The level card's headline in both locales (Fable-eye audit 2026-10-06,
/// FE-08).
///
/// "LEVEL 3" fits its half-width column; "المستوى 3" did not, and with
/// `maxLines: 1, overflow: ellipsis` every Arabic Home read "المستوى…" — the
/// level number gone, on a real Pixel 8 and the emulator, light and dark. The
/// headline now sits in a `FittedBox(scaleDown)`: whole in Arabic, untouched
/// in English.
///
/// The bundled fonts are loaded: the test font draws every glyph as a square
/// the size of the font, which would overflow BOTH locales and prove nothing
/// about the real widths.
void main() {
  setUpAll(loadAppFonts);

  Widget host(String locale, double width) => MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale(locale),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: const LevelCard(
            level: 3,
            totalPoints: 1250,
            track: Track.school,
          ),
        ),
      ),
    ),
  );

  // The headline only: in Arabic the bar's "المستوى 3" caption reads the same.
  Finder headline(String text) =>
      find.descendant(of: find.byType(FittedBox), matching: find.text(text));

  // 330 dp: narrower than the frame's 375, where the Arabic headline is
  // wider than its column in the real fonts too, so the old ellipsis is red.
  for (final (locale, text) in [('en', 'LEVEL 3'), ('ar', 'المستوى 3')]) {
    testWidgets('$locale: the headline is whole on a 330 dp phone', (
      tester,
    ) async {
      await tester.pumpWidget(host(locale, 330));
      await tester.pumpAndSettle();

      final paragraph = tester.renderObject<RenderParagraph>(headline(text));
      expect(paragraph.didExceedMaxLines, isFalse, reason: 'no ellipsis');

      // Painted inside the card, never past its edge.
      final painted = tester.getRect(headline(text));
      final card = tester.getRect(find.byType(LevelCard));
      expect(painted.left, greaterThanOrEqualTo(card.left));
      expect(painted.right, lessThanOrEqualTo(card.right));
    });
  }

  testWidgets('English renders at its full size; Arabic shrinks only as much '
      'as its column demands', (tester) async {
    await tester.pumpWidget(host('en', 360));
    await tester.pumpAndSettle();
    // `getRect` carries the FittedBox's transform; `getSize` is the unscaled
    // paragraph. Equal means no scaling happened.
    expect(
      tester.getRect(headline('LEVEL 3')).width,
      closeTo(tester.getSize(headline('LEVEL 3')).width, 0.01),
    );

    await tester.pumpWidget(host('ar', 360));
    await tester.pumpAndSettle();
    final painted = tester.getRect(headline('المستوى 3')).width;
    final natural = tester.getSize(headline('المستوى 3')).width;
    expect(painted, lessThan(natural), reason: 'it had to shrink');
    expect(painted, greaterThan(natural / 2), reason: 'and only a little');
  });
}
