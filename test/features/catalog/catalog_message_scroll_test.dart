import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// [CatalogMessage] (the icon, the line and the Retry button of an empty,
/// failed or offline catalog screen) used to be a centred, non-scrolling
/// Column: on a phone on its side, or the smallest phone at the largest text,
/// it overflowed and the Retry button was drawn under the bottom bar where no
/// tap reaches it. It scrolls when the room is short and is exactly where it was
/// when it fits.
void main() {
  const line = 'No connection, please try again';

  Future<void> pump(
    WidgetTester tester, {
    required double room,
    required String locale,
    VoidCallback? onRetry,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: room,
                child: CatalogMessage(
                  icon: Icons.wifi_off,
                  text: line,
                  onRetry: onRetry,
                ),
              ),
              // What a bottom bar does: it draws over anything that spills.
              const ColoredBox(
                color: Colors.black,
                child: SizedBox(height: 56),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
  }

  for (final locale in ['en', 'ar']) {
    testWidgets('$locale: with room to spare it is centred and does not '
        'scroll', (tester) async {
      await pump(tester, room: 400, locale: locale, onRetry: () {});

      final content = Rect.fromPoints(
        tester.getTopLeft(find.byIcon(Icons.wifi_off)),
        tester.getBottomRight(find.byType(FilledButton)),
      );
      expect(content.center.dy, moreOrLessEquals(200, epsilon: 0.5));
      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scrollable.position.maxScrollExtent, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$locale: with too little room it scrolls, overflows nothing '
        'and Retry can be reached and tapped', (tester) async {
      var retries = 0;
      await pump(tester, room: 120, locale: locale, onRetry: () => retries++);
      expect(tester.takeException(), isNull, reason: 'no overflow');

      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scrollable.position.maxScrollExtent, greaterThan(0));

      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pump();
      expect(find.byType(FilledButton).hitTestable(), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      expect(retries, 1);
    });
  }

  testWidgets('with no Retry (a refused subject) it is just as reachable', (
    tester,
  ) async {
    await pump(tester, room: 60, locale: 'en');
    expect(tester.takeException(), isNull);
    expect(find.byType(FilledButton), findsNothing);
    await tester.ensureVisible(find.text(line));
    await tester.pump();
    expect(find.text(line).hitTestable(), findsOneWidget);
  });

  testWidgets('in a parent that gives it NO height (a ListView) it takes its '
      'own height instead of throwing', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ListView(
            children: [
              CatalogMessage(
                icon: Icons.wifi_off,
                text: line,
                onRetry: () => retries++,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    // An infinite centring floor would throw during layout.
    expect(tester.takeException(), isNull);
    expect(find.text(line), findsOneWidget);
    expect(find.byType(FilledButton).hitTestable(), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(retries, 1);
    // It is as tall as its content, not stretched to anything.
    expect(tester.getSize(find.byType(CatalogMessage)).height, lessThan(300));
  });
}
