import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/home/widgets/home_header.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The bell's unread dot is GATED, and a golden can only show that it is
/// missing — not that it is missing *on purpose*. This test names the reason:
/// there is no notifications endpoint in the contract, so nothing can set the
/// flag, and the frame's dot must not be drawn unconditionally.

Future<void> _pump(
  WidgetTester tester, {
  required bool hasUnread,
  Brightness brightness = Brightness.light,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: HomeHeader(
          name: 'Yara',
          avatarUrl: '',
          hasUnreadNotifications: hasUnread,
        ),
      ),
    ),
  );
  // MaterialApp animates a theme swap, so a single pump would sample the
  // palette mid-lerp and the dot would be neither hue.
  await tester.pumpAndSettle();
}

/// Every circular `Container` inside the bell chip that is filled with [color].
Finder _dotsColoured(Color color) => find.byWidgetPredicate((w) {
  if (w is! Container) return false;
  final decoration = w.decoration;
  return decoration is BoxDecoration &&
      decoration.shape == BoxShape.circle &&
      decoration.color == color;
});

void main() {
  testWidgets('the unread dot does NOT render while the flag is false', (
    tester,
  ) async {
    await _pump(tester, hasUnread: false);

    expect(_dotsColoured(AppColors.light.bellUnreadDot), findsNothing);
  });

  testWidgets('false is the DEFAULT — nothing has to opt out', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // No hasUnreadNotifications argument at all — exactly how Home builds
        // it, since the contract gives it nothing to pass.
        home: const Scaffold(
          body: HomeHeader(name: 'Yara', avatarUrl: ''),
        ),
      ),
    );
    await tester.pump();

    expect(_dotsColoured(AppColors.light.bellUnreadDot), findsNothing);
  });

  testWidgets('the dot renders when the flag is true, in the canvas hue', (
    tester,
  ) async {
    // Guards the widget itself, not the app: when an endpoint does arrive, this
    // is what flipping the flag must produce.
    await _pump(tester, hasUnread: true);
    expect(_dotsColoured(AppColors.light.bellUnreadDot), findsOneWidget);

    // The dot is NOT a fixed "notification orange" — it changes hue with the
    // canvas (#E67E22 light, #AE87E7 dark).
    await _pump(tester, hasUnread: true, brightness: Brightness.dark);
    expect(_dotsColoured(AppColors.dark.bellUnreadDot), findsOneWidget);
    expect(_dotsColoured(AppColors.light.bellUnreadDot), findsNothing);
  });
}
