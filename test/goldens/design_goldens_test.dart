// Platform-sensitive: the .png baselines were captured on Windows and Flutter
// goldens embed platform text shaping and anti-aliasing, so these fail on a
// Linux runner even when the code is correct. The tag lets CI select by
// intent rather than by directory — see dart_test.yaml.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/widgets/language_pill.dart';
import 'package:level_up_app/features/home/widgets/home_header.dart';
import 'package:level_up_app/features/home/widgets/level_card.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'golden_harness.dart';

/// Goldens for the other three Day 7b surfaces, in both canvases.
///
/// Two of the subjects are private widgets (`_TrackCard`, `_BellChip`), so they
/// are located by runtime type name. That keeps the capture tight on the thing
/// under test — the whole track screen would drag in the language pill, and the
/// whole header would drag in a network avatar.
Finder _byPrivateType(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

const _args = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600,
  phone: '+201021871999',
);

void main() {
  setUpAll(loadAppFonts);

  for (final MapEntry(key: canvas, value: brightness)
      in goldenBrightnesses.entries) {
    testWidgets('level card · $canvas', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 220));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        goldenApp(
          brightness: brightness,
          // Mid-level student: the bar is partly filled, so the purple fill and
          // the track behind it are both visible.
          child: const LevelCard(level: 8, totalPoints: 3700),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LevelCard),
        matchesGoldenFile('level_card_$canvas.png'),
      );
    });

    testWidgets('language pill · $canvas', (tester) async {
      await tester.pumpWidget(
        goldenApp(
          brightness: brightness,
          child: LanguagePill(label: 'English', onTap: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // Guards the border being present in light and ABSENT in dark.
      await expectLater(
        find.byType(LanguagePill),
        matchesGoldenFile('language_pill_$canvas.png'),
      );
    });

    testWidgets('home header bell · $canvas', (tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 120));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        goldenApp(
          brightness: brightness,
          child: const HomeHeader(name: 'Yara', avatarUrl: ''),
        ),
      );
      await tester.pumpAndSettle();

      // Ring + glyph — and, because hasUnreadNotifications defaults to false,
      // NO dot. That absence is the point of this golden.
      //
      // Captured at header level rather than chip level: `_BellChip` is private
      // and has no repaint boundary of its own, so a finder on it would snapshot
      // the whole surface anyway. The avatar resolves to its offline
      // placeholder, which is deterministic.
      await expectLater(
        find.byType(HomeHeader),
        matchesGoldenFile('home_header_bell_$canvas.png'),
      );
    });

    testWidgets('track card, unselected · $canvas', (tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [
          // Otherwise the real connectivity EventChannel is subscribed and
          // throws MissingPluginException under the test binding.
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );
      addTearDown(container.dispose);
      container.read(registrationControllerProvider.notifier).start(_args);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('en'),
            theme: themeFor(brightness),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: GoRouter(
              initialLocation: '/register/track',
              routes: [
                GoRoute(
                  path: '/register/track',
                  builder: (_, _) => const SignupTrackScreen(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Both cards unselected: gradient border in light, none in dark,
      // radius 25, the illustrations in their leading slots — plus, for free,
      // the C3 back chip and the C4 side inset.
      //
      // Screen-level rather than card-level for the same reason as the bell:
      // `_TrackCard` is private and carries no repaint boundary, so a finder on
      // it snapshots the enclosing surface regardless.
      await expectLater(
        _byPrivateType('_TrackCard').first,
        matchesGoldenFile('track_screen_$canvas.png'),
      );
    });
  }
}
