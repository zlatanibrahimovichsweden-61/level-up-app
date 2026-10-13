import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/study_session_chrome.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The `n/total` counter in the study header's progress row (RESPONSIVE.md
/// #2 / CW17 `resp-q2`). The header is shared by the quiz question screen
/// (`308:5264` / `348:7709`) and the flashcards study screen (`225:5613`).
///
/// The row is the frame's 18 dp counter line with the bar centred on it. It was
/// a fixed `SizedBox(height: 18)` around a 10/14 `captionSmall`, so from a text
/// scale of about 1.3 the counter's line outgrew the box: the paragraph was
/// clamped to 18 while its glyphs kept their natural 28 at 2.0x (42 at 3.0x),
/// drawn off the bar's centre and, at the largest sizes, over the header's rule.
/// The 18 is now the row's FLOOR: identical at the default scale, and the row
/// (and so the header) grows to hold the counter at a larger one.
///
/// THIS FILE is the half that fails WITHOUT the change to
/// `lib/core/widgets/study_session_chrome.dart` (`SizedBox(height: 18)` ->
/// `ConstrainedBox(constraints: BoxConstraints(minHeight: 18))`): 2.0x and 3.0x,
/// where the counter's line outgrows 18. The default-scale and 1.3x pins are in
/// `w4_study_progress_row_test.dart` and pass either way. The same 2.0x case on
/// the two REAL screens (EN and AR each) is in `quiz_screen_test.dart` and
/// `flashcard_study_screen_test.dart` ("2x text · the counter is drawn whole")
/// and fails, and passes, with this file.
///
/// MEASURED, not inferred: the test font and Inter share the line box (`height`
/// x font size x scale), so the natural height is read off a `TextPainter`
/// laid out with the paragraph's own inputs - a paragraph's own rect is clamped
/// to the room it is given and cannot show a spill.
void main() {
  Future<AppLocalizations> pumpHeader(
    WidgetTester tester, {
    required String locale,
    required double scale,
    int position = 3,
    int total = 10,
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.physicalSize = const Size(402, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.platformDispatcher.textScaleFactorTestValue = scale;

    await tester.pumpWidget(
      MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StudySessionHeader(
                headerKey: const Key('study_header'),
                title: 'Quiz',
                onClose: () {},
                position: position,
                total: total,
                progressFill: const Color(0xFF5A7F73),
              ),
            ],
          ),
        ),
      ),
    );
    return AppLocalizations.of(tester.element(find.byType(StudyProgressBar)));
  }

  double naturalHeight(WidgetTester tester, Finder text) {
    final paragraph = tester.renderObject<RenderParagraph>(text);
    final painter = TextPainter(
      text: paragraph.text,
      textDirection: paragraph.textDirection,
      textScaler: paragraph.textScaler,
    )..layout();
    final height = painter.height;
    painter.dispose();
    return height;
  }

  for (final locale in ['en', 'ar']) {
    group(locale, () {
      for (final scale in [2.0, 3.0]) {
        testWidgets('${scale}x · the counter is drawn WHOLE: its box holds '
            'its natural line', (tester) async {
          final l10n = await pumpHeader(tester, locale: locale, scale: scale);
          final counter = find.text(l10n.quizProgress(3, 10));

          final natural = naturalHeight(tester, counter);
          expect(
            tester.getRect(counter).height,
            greaterThanOrEqualTo(natural - 0.01),
            reason: 'a clamped box paints its glyphs outside it',
          );
          expect(tester.takeException(), isNull);
        });

        testWidgets('${scale}x · the bar stays centred on the counter '
            'line, and the header holds both', (tester) async {
          final l10n = await pumpHeader(tester, locale: locale, scale: scale);
          final counter = find.text(l10n.quizProgress(3, 10));
          final natural = naturalHeight(tester, counter);

          final counterRect = tester.getRect(counter);
          final bar = tester.getRect(find.byType(LinearProgressIndicator));
          final header = tester.getRect(find.byKey(const Key('study_header')));

          // Centred on the line the glyphs really occupy.
          expect(
            bar.center.dy,
            moreOrLessEquals(counterRect.top + natural / 2, epsilon: 0.51),
          );
          // And the header's own bottom padding (12) and rule (1.18) still sit
          // below that line, so nothing is drawn over the rule.
          expect(
            counterRect.top + natural,
            lessThanOrEqualTo(header.bottom - 12 - 1.18 + 0.01),
          );
          // It only ever GREW: never shorter than the frame's 89.18.
          expect(header.height, greaterThanOrEqualTo(89.18 - 0.01));
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('2.0x · dark canvas: the same, the counter whole', (
        tester,
      ) async {
        final l10n = await pumpHeader(
          tester,
          locale: locale,
          scale: 2.0,
          brightness: Brightness.dark,
        );
        final counter = find.text(l10n.quizProgress(3, 10));

        expect(
          tester.getRect(counter).height,
          greaterThanOrEqualTo(naturalHeight(tester, counter) - 0.01),
        );
        expect(tester.takeException(), isNull);
      });
    });
  }
}
