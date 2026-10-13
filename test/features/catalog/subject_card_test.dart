/// The Subjects card's colours against the frames, on both canvases.
///
/// Read in API→UI Wave 07 (2026-09-25) off `135:618` (school light),
/// `404:6978` (university light, identical) and `337:5732` (dark). The dark
/// card already matched. The light card drew its title and chevron near-black,
/// filled the bar green and ran it on a `#D1D1D1` track "because no light
/// Learn frame exists". Both light frames exist.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/widgets/subject_card.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../flashcards/reading_order.dart';
import 'catalog_fixtures.dart';

void main() {
  Widget host(Brightness brightness) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 173,
          height: 89,
          child: SubjectCard(subject: subjects().first, onTap: () {}),
        ),
      ),
    ),
  );

  // (canvas, title, chevron) — `135:625` / `135:626`, `337:5739` / `337:5740`.
  // The chevron's colour is its SVG fill (`weui:arrow-filled`).
  for (final (brightness, title, chevron) in [
    (Brightness.light, const Color(0xFF384F47), const Color(0xFF517066)),
    (Brightness.dark, const Color(0xFFFCFBF9), const Color(0xFFFCFBF9)),
  ]) {
    testWidgets('${brightness.name} · title, chevron and bar as drawn', (
      tester,
    ) async {
      await tester.pumpWidget(host(brightness));

      final name = subjects().first.name;
      expect(tester.widget<Text>(find.text(name)).style?.color, title);
      expect(tester.widget<Icon>(find.byType(Icon)).color, chevron);

      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      // `135:630` / `135:631` light, `337:5744` / `337:5745` dark: the same
      // track and fill on both canvases and both tracks.
      expect(bar.backgroundColor, const Color(0xFFECECEC));
      expect(bar.color, const Color(0xFFAE87E7));
    });
  }

  // BUG-020 remainder (KNOWN_BUGS.md): a subject's NAME is the content's
  // language (adr-018), which need not be the app's. It takes its own direction
  // and stays aligned at the app's start; the chevron and the card's mirroring
  // stay the app's. (First-strong direction reads an Arabic sentence that opens
  // on a Latin term as left-to-right - the rule the quiz stem already has.)
  group(
    'BUG-020: the name takes its own direction, aligned at the app start',
    () {
      Subject named(String name) => Subject.fromJson(<String, dynamic>{
        'id': 'sub-x',
        'name': name,
        'questionCounter': counterJson(216, 480),
      });

      Future<void> pumpCard(
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
                  width: 300,
                  child: SubjectCard(subject: named(name), onTap: () {}),
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
          expect(
            text.textAlign,
            locale == 'ar' ? TextAlign.right : TextAlign.left,
          );

          // The name begins at the card's inset: 9 from the app's start edge.
          final card = tester.getRect(find.byType(SubjectCard));
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
        testWidgets('$locale app · the chevron stays the app\'s, whatever the '
            'name says', (tester) async {
          // The same card with a name in each language: the glyph and its side
          // do not move.
          Future<(IconData?, double)> chevron(String name) async {
            await pumpCard(tester, locale: locale, name: name);
            final icon = tester.widget<Icon>(find.byType(Icon));
            final card = tester.getRect(find.byType(SubjectCard));
            final at = tester.getRect(find.byType(Icon));
            return (
              icon.icon,
              locale == 'ar' ? at.left - card.left : card.right - at.right,
            );
          }

          final latin = await chevron('Biology');
          final arabic = await chevron('الكيمياء');
          expect(latin.$1, arabic.$1);
          expect(latin.$2, arabic.$2);
          expect(latin.$2, closeTo(9, 0.01));
        });
      }
    },
  );
}
