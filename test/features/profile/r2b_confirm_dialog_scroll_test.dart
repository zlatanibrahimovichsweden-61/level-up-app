import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/profile/widgets/profile_confirm_dialog.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart' show loadAppFonts;

/// The Profile confirmation dialog (Go to Uni, Logout) scrolls when it is taller
/// than the screen allows. At the OS's largest text on a 360 x 640 phone the
/// English Go to Uni card (title, body, warning, "unavailable" reason, Confirm)
/// overflowed the bottom by 13 px (E1 journey sweep); a card that fits is not
/// scrollable and is laid out as before.
void main() {
  setUpAll(loadAppFonts);

  /// The Go to Uni dialog exactly as Profile shows it, over a page with a
  /// button that opens it.
  Future<ValueNotifier<bool?>> pumpDialog(
    WidgetTester tester, {
    required Size size,
    String locale = 'en',
    double textScale = 1.0,
    bool logout = false,
    bool confirmEnabled = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    if (textScale != 1.0) {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }
    final result = ValueNotifier<bool?>(null);
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    result.value = await ProfileConfirmDialog.show(
                      context,
                      logout
                          ? ProfileConfirmDialog(
                              title: l10n.logoutTitle,
                              body: l10n.logoutBody,
                              cancelLabel: l10n.logoutNo,
                              cancelKey: const Key('logout_no'),
                              confirmLabel: l10n.logoutYes,
                              confirmKey: const Key('logout_confirm'),
                              tone: ProfileConfirmTone.destructive,
                              confirmEnabled: true,
                            )
                          : ProfileConfirmDialog(
                              title: l10n.goToUniTitle,
                              body: l10n.goToUniBody,
                              note: l10n.goToUniWarning,
                              confirmLabel: l10n.goToUniConfirm,
                              confirmKey: const Key('go_to_uni_confirm'),
                              confirmEnabled: confirmEnabled,
                              disabledReason: l10n.goToUniUnavailable,
                            ),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  /// The card itself: the dialog's own Material (the `Dialog` widget fills the
  /// screen, insets and all).
  Rect card(WidgetTester tester) => tester.getRect(
    find
        .descendant(of: find.byType(Dialog), matching: find.byType(Material))
        .first,
  );

  Finder scroller() => find.descendant(
    of: find.byType(Dialog),
    matching: find.byType(Scrollable),
  );

  double extent(WidgetTester tester) =>
      tester.state<ScrollableState>(scroller()).position.maxScrollExtent;

  for (final locale in ['en', 'ar']) {
    testWidgets('Go to Uni at 360x640 and the largest text ($locale): no '
        'overflow, every line reachable', (tester) async {
      final l10n = lookupAppLocalizations(Locale(locale));
      await pumpDialog(
        tester,
        size: const Size(360, 640),
        locale: locale,
        textScale: 2.0,
      );
      expect(tester.takeException(), isNull, reason: 'layout overflow');

      // Everything the student is told, and the control, can be scrolled to
      // and sits inside the card and the screen when it is.
      final dialog = card(tester);
      expect(dialog.top, greaterThanOrEqualTo(0));
      expect(dialog.bottom, lessThanOrEqualTo(640));
      for (final finder in [
        find.text(l10n.goToUniUnavailable),
        find.byKey(const Key('go_to_uni_confirm')),
      ]) {
        await tester.ensureVisible(finder);
        await tester.pump();
        final rect = tester.getRect(finder);
        expect(rect.bottom, lessThanOrEqualTo(dialog.bottom + 0.01));
        expect(rect.top, greaterThanOrEqualTo(dialog.top - 0.01));
      }
    });
  }

  testWidgets('a confirm that is enabled can be reached and tapped when the '
      'card scrolls', (tester) async {
    // Enabled, the "unavailable" reason is not drawn, so the card is shorter
    // than the disabled one: the smallest phone makes it scroll.
    final result = await pumpDialog(
      tester,
      size: const Size(320, 568),
      textScale: 2.0,
      confirmEnabled: true,
    );
    expect(extent(tester), greaterThan(0), reason: 'this card scrolls');

    await tester.ensureVisible(find.byKey(const Key('go_to_uni_confirm')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('go_to_uni_confirm')));
    await tester.pumpAndSettle();
    expect(result.value, isTrue);
    expect(find.byType(Dialog), findsNothing);
  });

  for (final locale in ['en', 'ar']) {
    for (final logout in [false, true]) {
      testWidgets('a card that fits does not scroll, as before '
          '(${logout ? 'Logout' : 'Go to Uni'}, $locale, 412x915)', (
        tester,
      ) async {
        await pumpDialog(
          tester,
          size: const Size(412, 915),
          locale: locale,
          logout: logout,
        );
        expect(tester.takeException(), isNull);
        expect(extent(tester), 0);

        // 345 wide on the 402 frame, 28.5 in from each side: the same card.
        final rect = card(tester);
        expect(rect.width, 412 - 2 * 28.5);
        expect(rect.center.dx, 206);
      });
    }
  }
}
