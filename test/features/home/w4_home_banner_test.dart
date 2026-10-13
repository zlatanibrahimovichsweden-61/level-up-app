import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/home/widgets/home_banner.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The Home banner placeholder (`337:5485`; artwork `337:5486` still pending)
/// - RESPONSIVE.md #7.
///
/// Its 140 was a fixed HEIGHT around `displayLarge` (28/34), which grows with
/// the system text scale and wraps in Arabic, so a larger scale let the title
/// spill out of the box. It is now the box's FLOOR: identical at the default
/// scale, and tall enough for its title at a larger one.
void main() {
  /// The height [finder]'s text needs at the width it was given - what its
  /// lines occupy, not the (clamped) size of its render box.
  double naturalHeight(WidgetTester tester, Finder finder) {
    final paragraph = tester.renderObject<RenderParagraph>(finder);
    final painter = TextPainter(
      text: paragraph.text,
      textDirection: paragraph.textDirection,
      textScaler: paragraph.textScaler,
      maxLines: paragraph.maxLines,
      locale: paragraph.locale,
    )..layout(maxWidth: paragraph.size.width);
    final height = painter.height;
    painter.dispose();
    return height;
  }

  Future<void> pumpBanner(
    WidgetTester tester, {
    required String locale,
    required double width,
    required double textScale,
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = Size(width, 900);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.platformDispatcher.textScaleFactorTestValue = textScale;

    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // Home lays it out in a scrolling column: unbounded height, 20 gutters.
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [HomeBanner()],
            ),
          ),
        ),
      ),
    );
  }

  for (final locale in ['en', 'ar']) {
    for (final width in [360.0, 375.0, 402.0, 411.0]) {
      testWidgets('$width dp · $locale · 1.0x · exactly 140 tall, as drawn', (
        tester,
      ) async {
        await pumpBanner(tester, locale: locale, width: width, textScale: 1.0);

        final box = tester.getRect(find.byType(HomeBanner));
        expect(box.height, 140);
        expect(box.width, width - 40);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$width dp · $locale · 2.0x · grows to hold its title', (
        tester,
      ) async {
        await pumpBanner(tester, locale: locale, width: width, textScale: 2.0);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(HomeBanner)),
        );

        final box = tester.getRect(find.byType(HomeBanner));
        final title = find.text(l10n.learnTodayLeadTomorrow);
        // The floor, never less.
        expect(box.height, greaterThanOrEqualTo(140));
        // The box holds the title's WHOLE height. A paragraph's own rect is
        // clamped to the room it is given, so it cannot show a spill; the
        // height its lines need is measured with a painter instead.
        expect(
          box.height,
          greaterThanOrEqualTo(naturalHeight(tester, title)),
          reason: 'nothing spills out of the box',
        );
        expect(tester.getRect(title).bottom, lessThanOrEqualTo(box.bottom));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('the same 140 on the dark canvas', (tester) async {
    await pumpBanner(
      tester,
      locale: 'en',
      width: 402,
      textScale: 1.0,
      brightness: Brightness.dark,
    );

    expect(tester.getRect(find.byType(HomeBanner)).height, 140);
  });
  // The floor must not turn into a "fill what you are given": offered a bounded
  // parent (a plain Align, not Home's scrolling column), the box is still the
  // 140 it always was.
  testWidgets('in a BOUNDED parent it is still exactly 140, not the room', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(402, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(alignment: Alignment.topCenter, child: HomeBanner()),
          ),
        ),
      ),
    );

    expect(tester.getRect(find.byType(HomeBanner)).height, 140);
  });
}
