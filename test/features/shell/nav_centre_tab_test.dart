import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/shell/main_shell.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// DESIGN_ISSUES #38: on the centre (Learn) tab the BACKGROUND carries the
/// selected state, not the glyph. The build used to do the inverse — hold the
/// circle at one fill and recolour the glyph with the accent.
///
/// A golden shows the pixels but not the rule, so this test states it: across
/// the idle→selected transition the accent lands on the CIRCLE, and the glyph
/// never takes the accent colour at all (it goes grey → white).

const _paths = ['/t0', '/t1', '/t2', '/t3', '/t4'];
const _centre = 2;

GoRouter _router(String initial) => GoRouter(
      initialLocation: initial,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, navigationShell) =>
              MainShell(navigationShell: navigationShell),
          branches: [
            for (final path in _paths)
              StatefulShellBranch(
                routes: [
                  GoRoute(path: path, builder: (_, _) => const SizedBox.expand()),
                ],
              ),
          ],
        ),
      ],
    );

Future<void> _pump(WidgetTester tester, {required bool centreSelected}) async {
  await tester.pumpWidget(
    MaterialApp.router(
      locale: const Locale('en'),
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router(_paths[centreSelected ? _centre : 0]),
    ),
  );
  await tester.pumpAndSettle();
}

/// The centre tab's circle — the only `AnimatedContainer` in the bar.
Color _circleFill(WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find.byType(AnimatedContainer),
  );
  return (container.decoration! as BoxDecoration).color!;
}

/// The tint applied to the Learn glyph. `ColorFilter` exposes no accessor for
/// its colour, but it implements `==`, so comparing whole filters against a
/// rebuilt one is exact.
ColorFilter? _glyphTint(WidgetTester tester) {
  final svg = tester.widget<SvgPicture>(
    find.byWidgetPredicate(
      (w) =>
          w is SvgPicture &&
          w.bytesLoader is SvgAssetLoader &&
          (w.bytesLoader as SvgAssetLoader).assetName ==
              'assets/icons/nav/learn.svg',
    ),
  );
  return svg.colorFilter;
}

ColorFilter _tint(Color color) => ColorFilter.mode(color, BlendMode.srcIn);

void main() {
  const palette = AppColors.light;

  testWidgets('idle centre tab: lavender circle, grey glyph', (tester) async {
    await _pump(tester, centreSelected: false);

    expect(_circleFill(tester), palette.navCentreIdleFill);
    expect(_glyphTint(tester), _tint(palette.mutedText));
  });

  testWidgets('selecting the centre tab fills the CIRCLE with the accent',
      (tester) async {
    await _pump(tester, centreSelected: true);

    expect(
      _circleFill(tester),
      palette.navAccent,
      reason: 'selection must land on the circle, not the glyph',
    );
  });

  testWidgets('the glyph never takes the accent — it goes grey to white',
      (tester) async {
    await _pump(tester, centreSelected: false);
    expect(_glyphTint(tester), _tint(palette.mutedText));
    expect(_glyphTint(tester), isNot(_tint(palette.navAccent)));

    await _pump(tester, centreSelected: true);
    expect(_glyphTint(tester), _tint(palette.navCentreGlyphOn));
    expect(
      _glyphTint(tester),
      isNot(_tint(palette.navAccent)),
      reason: 'tinting the glyph with the accent is the pre-Day-7b bug',
    );
  });

  testWidgets('the circle carries no border — the frame draws none',
      (tester) async {
    await _pump(tester, centreSelected: false);

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect((container.decoration! as BoxDecoration).border, isNull);
  });
}
