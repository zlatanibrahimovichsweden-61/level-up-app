import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'golden_harness.dart';

/// The bottom nav bar, one golden per selected tab per canvas — ten in all.
///
/// These guard the three things section A changed and a widget test cannot
/// describe in a sentence: the notch path, the centre tab's fill inversion, and
/// that each tab carries the right (non-square) glyph.
///
/// Driven through a REAL `StatefulShellRoute.indexedStack` rather than a fake
/// `StatefulNavigationShell`, because that type cannot be constructed by hand —
/// but with five empty branches, so no auth, router guard or `/me` fetch is
/// involved.

const _branchPaths = ['/t0', '/t1', '/t2', '/t3', '/t4'];

GoRouter _shellRouter(String initial) => GoRouter(
      initialLocation: initial,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, navigationShell) =>
              MainShell(navigationShell: navigationShell),
          branches: [
            for (final path in _branchPaths)
              StatefulShellBranch(
                routes: [
                  GoRoute(path: path, builder: (_, _) => const SizedBox.expand()),
                ],
              ),
          ],
        ),
      ],
    );

void main() {
  setUpAll(loadAppFonts);

  for (final MapEntry(key: canvas, value: brightness)
      in goldenBrightnesses.entries) {
    for (var index = 0; index < _branchPaths.length; index++) {
      testWidgets('nav bar · $canvas · tab $index selected', (tester) async {
        // Tall enough for the bar (111) plus a little page above it, so the
        // bump's shadow is inside the capture.
        await tester.binding.setSurfaceSize(const Size(375, 200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MaterialApp.router(
            locale: const Locale('en'),
            theme: themeFor(brightness),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _shellRouter(_branchPaths[index]),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MainShell),
          matchesGoldenFile('nav_bar_${canvas}_tab$index.png'),
        );
      });
    }
  }
}
