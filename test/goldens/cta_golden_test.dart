// Platform-sensitive: see the header of design_goldens_test.dart and
// dart_test.yaml. Windows baselines.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/profile/widgets/profile_confirm_dialog.dart';

import 'golden_harness.dart';

/// The CTA's elevation, which is the one thing in edit2 that paints OUTSIDE its
/// widget and therefore the one thing a clipping ancestor can silently delete.
///
/// Two subjects:
///
/// * the bare CTA, enabled and disabled, on both canvases — light is a tight
///   dark drop shadow, dark adds the lavender glow (`348:8909`), and disabled
///   dims both at the project's 0.45;
/// * the **confirm dialog**, because that is where the risk actually lives:
///   the glow reaches ~12dp (3σ at σ=4) and the dialog only has 18dp of side
///   padding, so a golden is the cheapest way to prove the halo is intact and
///   that the red destructive button has a shadow and **no** glow.
void main() {
  setUpAll(loadAppFonts);

  for (final MapEntry(key: canvas, value: brightness)
      in goldenBrightnesses.entries) {
    for (final enabled in [true, false]) {
      final state = enabled ? 'enabled' : 'disabled';

      testWidgets('primary CTA · $canvas · $state', (tester) async {
        await tester.pumpWidget(
          goldenApp(
            brightness: brightness,
            child: SizedBox(
              // Room for the halo to be visible around the button rather than
              // cropped at the boundary.
              width: 280,
              height: 120,
              child: Center(
                child: PrimaryCta(
                  enabled: enabled,
                  child: SizedBox(
                    width: 220,
                    child: FilledButton(
                      onPressed: enabled ? () {} : null,
                      child: const Text('Continue', style: AppType.buttonLarge),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(PrimaryCta),
          matchesGoldenFile('cta_primary_${canvas}_$state.png'),
        );
      });
    }

    for (final tone in ProfileConfirmTone.values) {
      testWidgets('confirm dialog · $canvas · ${tone.name}', (tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 420));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          goldenApp(
            brightness: brightness,
            child: ProfileConfirmDialog(
              title: 'Log out',
              body: 'Are you sure you want to log out of your account?',
              confirmLabel: 'Log out',
              tone: tone,
              confirmEnabled: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(ProfileConfirmDialog),
          matchesGoldenFile('confirm_dialog_${canvas}_${tone.name}.png'),
        );
      });
    }
  }
}
