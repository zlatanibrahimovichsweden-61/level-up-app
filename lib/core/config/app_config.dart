/// Flavor + runtime configuration.
///
/// One dependency graph, three entrypoints (main_dev / main_staging / main_prod).
/// Each entrypoint calls [AppConfig.init] before the app boots.
library;

import 'package:flutter/foundation.dart' show visibleForTesting;

enum Flavor { dev, staging, prod }

class AppConfig {
  AppConfig._({
    required this.flavor,
    required this.baseUrl,
    required this.isDev,
  });

  final Flavor flavor;
  final String baseUrl;
  final bool isDev;

  static AppConfig? _instance;
  static AppConfig get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('AppConfig.init() must be called before use.');
    }
    return i;
  }

  /// The config if [init] has run, else null. For code that may be built
  /// before `bootstrap()` has initialised it - a widget test that pumps the
  /// root widget on its own - and must degrade to "no environment" rather than
  /// throw. Everything that NEEDS the config keeps using [instance].
  static AppConfig? get maybeInstance => _instance;

  static void init(Flavor flavor) {
    _instance = AppConfig._(
      flavor: flavor,
      baseUrl: _baseUrlFor(flavor),
      isDev: flavor != Flavor.prod,
    );
  }

  /// Back to "never initialised", so a test that calls [init] cannot leak its
  /// flavor into the next one.
  @visibleForTesting
  static void resetForTesting() => _instance = null;

  /// The platform build flavors (`--flavor X`, read at runtime through
  /// `appFlavor`) the compiled [flavor] may run under.
  ///
  /// A MAPPING, not an equality, because Android has exactly two installable
  /// identities - `prod` and `staging` - and `Flavor.dev` is a runtime mode of
  /// the staging identity (D-021 Q2; `android/app/build.gradle.kts` has no `dev`
  /// product flavor). An equality check would reject every dev boot.
  static Set<String> platformFlavorsFor(Flavor flavor) => switch (flavor) {
    Flavor.dev || Flavor.staging => const {'staging'},
    Flavor.prod => const {'prod'},
  };

  /// Whether a build made with platform flavor [platformFlavor] may run the
  /// compiled [flavor]. An ABSENT platform flavor (null) is tolerated: iOS has
  /// no flavors until Wave 3, a bare `flutter run` passes none, and
  /// `flutter test` runs without one. Pure, so it is unit-tested directly.
  static bool platformFlavorAgrees(Flavor flavor, String? platformFlavor) =>
      platformFlavor == null ||
      platformFlavorsFor(flavor).contains(platformFlavor);

  /// Fails fast when the compiled [flavor] and the platform build flavor
  /// disagree: the build configuration chose one environment and the Dart
  /// entrypoint another, e.g. the production identity running the staging
  /// host. Called by `bootstrap()` before anything else initialises. Throws; it
  /// has no UI and no copy, because a student must never reach a screen that
  /// says it. The message names build configuration only, never user data.
  static void verifyPlatformFlavor(Flavor flavor, String? platformFlavor) {
    if (platformFlavorAgrees(flavor, platformFlavor)) return;
    throw StateError(
      'Flavor mismatch: the app was built with platform flavor '
      '"$platformFlavor" but its entrypoint compiles Flavor.${flavor.name} '
      '(accepts: ${platformFlavorsFor(flavor).join(', ')}). '
      'See docs/ENVIRONMENTS.md section 4.',
    );
  }

  /// The staging host, taken verbatim from the contract's `servers:` block
  /// (`contract/openapi.yaml:85`, contract v3.0.0-m1). This closes seif_fight
  /// S1 — the placeholder `staging.TBD.example` is gone and real requests are
  /// possible. `dev` deliberately resolves to the same host: there has only
  /// ever been one server, and the two flavors have pointed at the same URL
  /// since Day 0 (they differ in [isDev], not in host).
  static const String _stagingBaseUrl =
      'https://level-up-backend-staging.up.railway.app/api/v1';

  // TODO(contract): the PROD base URL is still a PLACEHOLDER. Seif's `servers:`
  // block lists staging only; the production host has not been announced (it
  // will arrive via contract-changelog.md). `.example` is a reserved TLD, so
  // this fails closed rather than leaking a minor's traffic somewhere real.
  // Do NOT ship a prod build until this is replaced.
  static String _baseUrlFor(Flavor flavor) => switch (flavor) {
    Flavor.dev => _stagingBaseUrl,
    Flavor.staging => _stagingBaseUrl,
    Flavor.prod => 'https://TBD.example/api/v1',
  };
}
