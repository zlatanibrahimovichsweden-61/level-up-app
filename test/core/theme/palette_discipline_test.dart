import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/profile/widgets/profile_stat_card.dart';

/// The standing rule from Day 7b — *"every new colour becomes a token in
/// AppColors; no hex at a call site"* — as a test rather than a grep somebody
/// has to remember to run.
///
/// It exists because the rule failed quietly for two months. Six call sites
/// were painting light-measured values on both canvases: one literal `#FCFBF9`
/// and five `Colors.black` shadows. Nothing caught them, because a hardcoded
/// colour compiles, analyses clean and looks perfect — on the canvas it was
/// measured against. A whole theme was unreachable at the time, so nobody ever
/// saw the other one.
void main() {
  /// Every Dart file under `lib/`, minus the palette itself. `lib/core/theme/`
  /// is where colour literals are SUPPOSED to live, so it is the one exemption.
  List<File> callSiteSources() => Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.replaceAll(r'\', '/').contains('lib/core/theme/'))
      .toList();

  /// `path:line — text` for every line matching [pattern], so a failure names
  /// the file to fix instead of just saying a count went up.
  List<String> hits(RegExp pattern) => [
        for (final file in callSiteSources())
          ...file.readAsLinesSync().indexed.where((e) => pattern.hasMatch(e.$2)).map(
              (e) => '${file.path}:${e.$1 + 1} — ${e.$2.trim()}'),
      ];

  group('no colour is decided outside the palette', () {
    test('no raw hex at a call site', () {
      expect(hits(RegExp(r'0xFF|Color\(0x')), isEmpty);
    });

    test('no raw black or white at a call site', () {
      // Shadows were the last holdout and the most damaging, because black is
      // the one colour that looks like a safe universal default and is not:
      // it means "further from the light" on a canvas that has somewhere
      // further to go, and nothing at all on one that does not.
      expect(hits(RegExp(r'Colors\.black|Colors\.white')), isEmpty);
    });

    test('the status bar is styled in exactly one place', () {
      // Nine screens draw their own header. A per-screen overlay style would be
      // nine copies of one rule, and the first one anybody forgot would leave a
      // student on dark-on-dark glyphs.
      final files = hits(RegExp(r'SystemUiOverlayStyle|SystemChrome'))
          .map((h) => h.split(' — ').first.split(':').first.replaceAll(r'\', '/'))
          .toSet();

      expect(files, {'lib/app.dart'});
    });
  });

  group('elevationShadow', () {
    test('is a different colour on each canvas — that is the entire point', () {
      // If these are ever equalised, one of the two canvases has lost its
      // elevation: black does not read on `#232428`, cream does not read on
      // `#FCFBF9`.
      expect(AppColors.light.elevationShadow,
          isNot(AppColors.dark.elevationShadow));
    });

    test('carries no alpha of its own — the call site owns the depth', () {
      // The five shadows are measured at two depths (0.15 and 0.25). Baking one
      // into the token would silently restyle the onboarding sheet to the
      // cards' depth.
      expect(AppColors.light.elevationShadow.a, 1.0);
      expect(AppColors.dark.elevationShadow.a, 1.0);
    });

    test('is wired into copyWith and lerp', () {
      const probe = Color(0xFF010203);
      expect(AppColors.light.copyWith(elevationShadow: probe).elevationShadow,
          probe);

      final mid = AppColors.light.lerp(AppColors.dark, 0.5);
      expect(mid.elevationShadow, isNot(AppColors.light.elevationShadow),
          reason: 'a token missing from lerp silently stops animating');
    });
  });

  group('a card on each canvas', () {
    // The end of the wire. `ProfileStatCard` is the smallest of the five
    // components using the token and they all use the identical expression, so
    // this is the one that proves the value actually reaches a `BoxShadow`.
    Future<BoxShadow> shadowOf(WidgetTester tester, Brightness brightness) async {
      await tester.pumpWidget(MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        home: const ProfileStatCard(label: 'Points', value: '3,700'),
      ));

      final box = tester.widget<Container>(find.byType(Container));
      return ((box.decoration! as BoxDecoration).boxShadow!).single;
    }

    testWidgets('light draws the frame-measured black at 25%', (tester) async {
      final shadow = await shadowOf(tester, Brightness.light);

      expect(shadow.color,
          AppColors.light.elevationShadow.withValues(alpha: 0.25));
      expect(shadow.blurRadius, 1, reason: 'Figma 661:8571 — unchanged');
    });

    testWidgets('dark draws the canvas shadow, not the light one',
        (tester) async {
      final shadow = await shadowOf(tester, Brightness.dark);

      expect(
        shadow.color,
        AppColors.dark.elevationShadow.withValues(alpha: 0.25),
      );
      expect(
        shadow.color,
        isNot(AppColors.light.elevationShadow.withValues(alpha: 0.25)),
        reason: 'this is the defect: the dark card used to paint a black '
            'shadow measured on the cream canvas, which is invisible',
      );
      expect(shadow.blurRadius, 1, reason: 'the DEPTH does not change canvas');
    });
  });
}
