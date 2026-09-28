/// The Subjects card's colours against the frames, on both canvases.
///
/// Read in API→UI Wave 07 (2026-09-25) off `135:618` (school light),
/// `404:6978` (university light, identical) and `337:5732` (dark). The dark
/// card already matched. The light card drew its title and chevron near-black,
/// filled the bar green and ran it on a `#D1D1D1` track "because no light
/// Learn frame exists". Both light frames exist.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/catalog/widgets/subject_card.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

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
}
