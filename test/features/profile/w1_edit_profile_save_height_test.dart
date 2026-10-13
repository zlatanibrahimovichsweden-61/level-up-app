import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';

import 'profile_harness.dart';

/// resp-q6 (Edit Profile part): the Save button's 60 is a MINIMUM.
///
/// It used to be `SizedBox(height: 60)`, a TIGHT constraint that handed the
/// button exactly 60 whatever its label needed, so a label that scaled up or
/// wrapped was clipped inside a fixed box. It is `ConstrainedBox(minHeight:
/// 60)` now: the frame's 60 at the default scale, growing when the label
/// needs more.
///
/// A caveat that applies to every width in a widget test (docs: "test-font
/// WIDTHS are ~1.5x Inter and must never be quoted as device facts"): the
/// test binding's font is far wider than the app's real ones, so whether the
/// label WRAPS at a given scale and width here says nothing about a device.
/// What these tests pin is structural: at 1.0x nothing moved, and when the
/// label does need more than 60 the button gives it that instead of clipping.
void main() {
  const saveKey = Key('edit_save_button');

  Size saveSize(WidgetTester tester) => tester.getSize(find.byKey(saveKey));

  /// Edit Profile pumped through the real router, at [scale] and [width].
  Future<List<String>> pumpAt(
    WidgetTester tester, {
    required String locale,
    double scale = 1.0,
    double? width,
  }) async {
    // Layout errors are collected so a test can say WHICH one appeared.
    //
    // The handler is put back as soon as the pumping is done - NOT in a
    // tearDown. The binding reports a failing `expect` through
    // FlutterError.onError, so a collector still installed while the
    // assertions run swallows the failure and the run then stalls on the
    // binding's own "overrode FlutterError.onError" assertion instead of
    // failing (seen when the fixed height was put back to prove this test).
    final errors = <String>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details.toString());

    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    try {
      await pumpEditProfile(tester, profile: profileRepo(), locale: locale);
      if (width != null) {
        // After the harness's own 800x1600 so the form is still tall enough.
        await tester.binding.setSurfaceSize(Size(width, 1600));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      }
    } finally {
      FlutterError.onError = previous;
    }
    expect(find.byType(EditProfileScreen), findsOneWidget);
    return errors;
  }

  group('1.0x: the frame is unchanged', () {
    for (final locale in ['en', 'ar']) {
      testWidgets('the Save button is exactly 60 tall ($locale)', (
        tester,
      ) async {
        final errors = await pumpAt(tester, locale: locale);

        expect(saveSize(tester).height, 60);
        expect(errors, isEmpty);
      });

      testWidgets('at the frame width too: 60 tall ($locale)', (tester) async {
        final errors = await pumpAt(tester, locale: locale, width: 402);

        expect(saveSize(tester).height, 60);
        expect(errors, isEmpty);
      });
    }
  });

  group('2.0x: the button never shrinks and never overflows', () {
    for (final locale in ['en', 'ar']) {
      testWidgets('wide: still at least 60, no overflow ($locale)', (
        tester,
      ) async {
        final errors = await pumpAt(tester, locale: locale, scale: 2.0);

        expect(saveSize(tester).height, greaterThanOrEqualTo(60));
        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
        expect(errors, isEmpty);
      });

      testWidgets('narrow, where the label needs more than 60: the button '
          'GROWS to hold it ($locale)', (tester) async {
        final errors = await pumpAt(
          tester,
          locale: locale,
          scale: 2.0,
          width: 360,
        );

        // Under the old fixed `SizedBox(height: 60)` this was exactly 60 with
        // the label spilling past it; as a minimum the button takes its
        // label's height.
        expect(saveSize(tester).height, greaterThan(60));
        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
        expect(errors, isEmpty);
      });
    }
  });
}
