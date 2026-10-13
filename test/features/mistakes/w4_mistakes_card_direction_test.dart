import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/mistakes/models/mistakes_subject.dart';
import 'package:level_up_app/features/mistakes/widgets/mistakes_subject_card.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../flashcards/reading_order.dart';

/// BUG-020 remainder (KNOWN_BUGS.md): a Mistakes card's subject NAME is the
/// content's language (adr-018), which need not be the app's. It takes its own
/// direction and stays aligned at the app's start; the count under it (app
/// copy), the chevron and the card's mirroring stay the app's. First-strong
/// direction reads an Arabic sentence that opens on a Latin term as
/// left-to-right - the rule the quiz stem already has.
void main() {
  Future<void> pumpCard(
    WidgetTester tester, {
    required String locale,
    required String name,
    double width = 320,
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
              width: width,
              child: MistakesSubjectCard(
                subject: MistakesSubject(
                  id: 's-1',
                  name: name,
                  mistakeCount: 3,
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  // (app language, name, the direction the NAME reads in)
  for (final (locale, name, direction) in [
    ('en', 'الكيمياء', TextDirection.rtl),
    ('ar', 'Biology', TextDirection.ltr),
    ('en', 'Biology', TextDirection.ltr),
    ('ar', 'الكيمياء', TextDirection.rtl),
    // No letters at all: the app's own direction.
    ('en', '2024', TextDirection.ltr),
    ('ar', '2024', TextDirection.rtl),
  ]) {
    testWidgets('$locale app · "$name" reads ${direction.name}', (
      tester,
    ) async {
      await pumpCard(tester, locale: locale, name: name);

      final text = tester.widget<Text>(find.text(name));
      expect(text.textDirection, direction);
      // At the APP's start, whatever the name's own direction is.
      expect(text.textAlign, locale == 'ar' ? TextAlign.right : TextAlign.left);

      // The name begins at the card's inset: 9 from the app's start edge.
      final card = tester.getRect(find.byType(MistakesSubjectCard));
      final rect = tester.getRect(find.text(name));
      if (locale == 'ar') {
        expect(card.right - rect.right, closeTo(9, 0.01));
      } else {
        expect(rect.left - card.left, closeTo(9, 0.01));
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final (locale, name, direction) in [
    // The "?" that the Arabic app drew at the START of an English name.
    ('ar', 'What is it?', TextDirection.ltr),
    // The full stop that the English app drew at the right end of an Arabic
    // name.
    ('en', 'الكيمياء (1).', TextDirection.rtl),
  ]) {
    testWidgets('$locale app · "$name" keeps its marks in reading order', (
      tester,
    ) async {
      await pumpCard(tester, locale: locale, name: name);

      expectReadingOrder(
        tester.renderObject<RenderParagraph>(find.text(name)),
        name,
        direction,
      );
    });
  }

  for (final locale in ['en', 'ar']) {
    testWidgets('$locale app · the count and the chevron stay the app\'s, '
        'whatever the name says', (tester) async {
      Future<(Rect, Rect)> geometry(String name) async {
        await pumpCard(tester, locale: locale, name: name);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(MistakesSubjectCard)),
        );
        return (
          tester.getRect(find.text(l10n.mistakeCount(3))),
          tester.getRect(find.byKey(const Key('mistakes_card_chevron'))),
        );
      }

      final latin = await geometry('Biology');
      final arabic = await geometry('الكيمياء');
      // The count is app copy at the app's start; the chevron is on the
      // app's end. Neither moves with the name's language.
      expect(latin.$1, arabic.$1);
      expect(latin.$2, arabic.$2);
    });
  }
}
