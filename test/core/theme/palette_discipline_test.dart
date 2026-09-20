import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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
      ...file
          .readAsLinesSync()
          .indexed
          .where((e) => pattern.hasMatch(e.$2))
          .map((e) => '${file.path}:${e.$1 + 1} — ${e.$2.trim()}'),
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
          .map(
            (h) => h.split(' — ').first.split(':').first.replaceAll(r'\', '/'),
          )
          .toSet();

      expect(files, {'lib/app.dart'});
    });
  });

  // The `elevationShadow` group lived here and is GONE too, deleted in the
  // same change as the token itself (2026-09-20, edit5's OTP chunk). It
  // asserted that the field differed per canvas, carried no alpha of its own,
  // and was wired into `copyWith` and `lerp` — three claims about a field
  // that no longer exists. The group was frozen precisely so nobody would
  // "correct" the cream dark value while call sites still painted it; the
  // last call site moved to `AppElevation.otpTimerInsetShadows`, so the field
  // and its pins went together. See the tombstone in `app_colors.dart` and
  // docs/DESIGN_ISSUES.md #47/#72.

  // The `a card on each canvas` group lived here and is GONE, replaced by
  // `test/features/profile/profile_stat_card_test.dart` (edit5.md §7.3.2).
  //
  // It pinned `ProfileStatCard`'s `Container` / `BoxShadow` — cream in dark,
  // blur 1 — as the proof that `elevationShadow` reached a real call site.
  // The card now draws `AppElevation.profileStatShadows` through
  // `ElevatedSurface`: the measured black on BOTH canvases, at the frame's
  // blur 2 (Figma `661:8571` / `661:8579`). Keeping the old group would pin
  // code that no longer exists; the new file asserts the new values, and the
  // group above still proves the token itself is wired.
}
