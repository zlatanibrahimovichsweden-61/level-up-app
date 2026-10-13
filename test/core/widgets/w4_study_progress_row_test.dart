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
/// THIS FILE pins what must NOT change - the default scale, and 1.3x, where
/// the counter still just fits - and passes with or without the change to
/// `study_session_chrome.dart`. The sizes that DO change (2.0x, 3.0x) are in
/// `w4_study_progress_row_grows_test.dart`.
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
      testWidgets('1.0x · the row is exactly the frame\'s 18, the bar 8 on '
          'its centre, the header 89.18', (tester) async {
        final l10n = await pumpHeader(tester, locale: locale, scale: 1.0);

        final row = tester.getRect(
          find
              .descendant(
                of: find.byType(StudyProgressBar),
                matching: find.byType(Row),
              )
              .first,
        );
        final bar = tester.getRect(find.byType(LinearProgressIndicator));
        final counter = tester.getRect(find.text(l10n.quizProgress(3, 10)));

        expect(row.height, 18);
        expect(bar.height, 8);
        expect(bar.center.dy, row.center.dy);
        expect(counter.height, 14);
        expect(counter.center.dy, row.center.dy);
        // The header around it: 16 - 9 + 48 + 3 + 18 + 12 + the 1.18 rule.
        expect(
          tester.getRect(find.byKey(const Key('study_header'))).height,
          moreOrLessEquals(89.18, epsilon: 0.01),
        );
        expect(tester.takeException(), isNull);
      });

      for (final scale in [1.3]) {
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

        testWidgets('${scale}x · the bar stays centred on the counter\'s '
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

      testWidgets('no counter (a round still loading): the 18 row and the '
          'bar alone, at any scale', (tester) async {
        // The loading shape: the header with showCounter false has no text to
        // grow, so the row is the frame's 18 at any scale.
        tester.view.physicalSize = const Size(402, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
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
                    position: 0,
                    total: 0,
                    progressFill: const Color(0xFF5A7F73),
                    showCounter: false,
                  ),
                ],
              ),
            ),
          ),
        );

        final row = tester.getRect(
          find
              .descendant(
                of: find.byType(StudyProgressBar),
                matching: find.byType(Row),
              )
              .first,
        );
        expect(row.height, 18);
        expect(tester.takeException(), isNull);
      });
    });
  }
}
