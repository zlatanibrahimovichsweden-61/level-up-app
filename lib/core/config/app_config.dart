/// Flavor + runtime configuration.
///
/// One dependency graph, three entrypoints (main_dev / main_staging / main_prod).
/// Each entrypoint calls [AppConfig.init] before the app boots.
library;

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

  static void init(Flavor flavor) {
    _instance = AppConfig._(
      flavor: flavor,
      baseUrl: _baseUrlFor(flavor),
      isDev: flavor != Flavor.prod,
    );
  }

  /// The staging host, taken verbatim from the contract's `servers:` block
  /// (`contract/openapi.yaml:64`, contract v2.1.0-m1). This closes seif_fight
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
