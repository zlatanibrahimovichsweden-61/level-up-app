import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/models/explanation_state.dart';
import 'package:level_up_app/features/quiz/widgets/ai_explanation_panel.dart';
import 'package:level_up_app/features/quiz/widgets/question_option_tile.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../flashcards/reading_order.dart';

/// BUG-020, the part the flashcard and catalog fixes left open: the quiz's
/// OPTION labels and the AI explanation's BODY are the question's content, in
/// the question's language (`getExplanation`: "in the question's own
/// language"), which need not be the app's. The stem above them already takes
/// its own direction (`QuestionStemText`); these take the same rule and stay
/// aligned at the app's start. The A/B/C/D badge, the tile's mirroring and the
/// panel's own copy stay the app's.
///
/// First-strong direction reads an Arabic sentence that opens on a Latin term
/// as left-to-right - the rule the stem already has, reused as the owner asked.
void main() {
  Widget host(String locale, Widget child, {double width = 360}) => MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale(locale),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  );

  Widget tile(String text, {OptionTileState state = OptionTileState.idle}) =>
      QuestionOptionTile(letter: 'A', text: text, state: state, onTap: () {});

  Widget panel(String text) =>
      AiExplanationPanel(state: ExplanationLoaded(text), onRequest: () {});

  // (app language, content, the direction the CONTENT reads in)
  const cases = [
    ('en', 'الكيمياء', TextDirection.rtl),
    ('ar', 'Biology', TextDirection.ltr),
    ('en', 'Biology', TextDirection.ltr),
    ('ar', 'الكيمياء', TextDirection.rtl),
    // No letters at all: the app's own direction.
    ('en', '12', TextDirection.ltr),
    ('ar', '12', TextDirection.rtl),
  ];

  group('an option', () {
    for (final (locale, text, direction) in cases) {
      testWidgets('$locale app · "$text" reads ${direction.name}, aligned at '
          'the app\'s start', (tester) async {
        await tester.pumpWidget(host(locale, tile(text)));

        final label = tester.widget<Text>(find.text(text));
        expect(label.textDirection, direction);
        expect(
          label.textAlign,
          locale == 'ar' ? TextAlign.right : TextAlign.left,
        );
        expect(tester.takeException(), isNull);
      });
    }

    for (final (locale, text, direction) in [
      // The "?" that the Arabic app drew at the START of an English option.
      ('ar', 'What is it?', TextDirection.ltr),
      // The full stop that the English app drew at the right end of an Arabic
      // one.
      ('en', 'الكيمياء (1).', TextDirection.rtl),
    ]) {
      testWidgets('$locale app · "$text" keeps its marks in reading order', (
        tester,
      ) async {
        await tester.pumpWidget(host(locale, tile(text)));

        expectReadingOrder(
          tester.renderObject<RenderParagraph>(find.text(text)),
          text,
          direction,
        );
      });
    }

    for (final locale in ['en', 'ar']) {
      for (final state in OptionTileState.values) {
        testWidgets('$locale app · ${state.name} · the badge and the label '
            'sit where they always did, whatever the label says', (
          tester,
        ) async {
          // The same tile with a Latin label and an Arabic one: the badge's
          // side, the label's start edge and the tile's height do not move.
          Future<(Rect, Rect, Rect)> geometry(String text) async {
            await tester.pumpWidget(host(locale, tile(text, state: state)));
            return (
              tester.getRect(find.byType(QuestionOptionTile)),
              tester.getRect(
                find.descendant(
                  of: find.byType(QuestionOptionTile),
                  matching: find.byWidgetPredicate(
                    (w) =>
                        w is Container &&
                        w.constraints ==
                            const BoxConstraints.tightFor(
                              width: 28,
                              height: 28,
                            ),
                  ),
                ),
              ),
              tester.getRect(find.text(text)),
            );
          }

          final latin = await geometry('Biology');
          final arabic = await geometry('الكيمياء');

          // Same tile, same badge - the 28 disc on the app's start side.
          expect(latin.$1.size, arabic.$1.size);
          final tileRect = latin.$1;
          expect(latin.$2, arabic.$2);
          expect(latin.$2.size, const Size(28, 28));
          if (locale == 'ar') {
            expect(latin.$2.right, lessThan(tileRect.right));
            expect(tileRect.right - latin.$2.right, lessThan(24));
          } else {
            expect(latin.$2.left, greaterThan(tileRect.left));
            expect(latin.$2.left - tileRect.left, lessThan(24));
          }
          // The label starts on the same side in both: 12 after the badge.
          if (locale == 'ar') {
            expect(latin.$3.right, arabic.$3.right);
          } else {
            expect(latin.$3.left, arabic.$3.left);
          }
        });
      }
    }
  });

  group('the explanation body', () {
    for (final (locale, text, direction) in cases) {
      testWidgets('$locale app · "$text" reads ${direction.name}, aligned at '
          'the app\'s start', (tester) async {
        await tester.pumpWidget(host(locale, panel(text)));

        final body = tester.widget<Text>(find.text(text));
        expect(body.textDirection, direction);
        expect(
          body.textAlign,
          locale == 'ar' ? TextAlign.right : TextAlign.left,
        );
        expect(tester.takeException(), isNull);
      });
    }

    for (final (locale, text, direction) in [
      // A sentence that wraps to several lines, the "?" that the Arabic app
      // drew at the START of its last line.
      (
        'ar',
        'Which plane divides the body into right and left parts?',
        TextDirection.ltr,
      ),
      // The full stop that the English app drew at the right end.
      (
        'en',
        'المستوى السهمي يقسم الجسم إلى جزأين أيمن وأيسر.',
        TextDirection.rtl,
      ),
    ]) {
      testWidgets('$locale app · a wrapped explanation keeps its marks in '
          'reading order', (tester) async {
        await tester.pumpWidget(host(locale, panel(text)));

        final lines = expectReadingOrder(
          tester.renderObject<RenderParagraph>(find.text(text)),
          text,
          direction,
        );
        expect(lines, greaterThan(1), reason: 'it must actually wrap');
      });
    }

    for (final locale in ['en', 'ar']) {
      testWidgets('$locale app · the panel\'s own copy stays the app\'s', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(locale, panel('Which plane divides the body?')),
        );

        final l10n = AppLocalizations.of(
          tester.element(find.byType(AiExplanationPanel)),
        );
        // The title is app copy: no content direction, no forced alignment.
        final title = tester.widget<Text>(find.text(l10n.aiExplanation));
        expect(title.textDirection, isNull);
        expect(title.textAlign, isNull);
      });
    }
  });
}
