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

  // TODO(contract): base URLs are PLACEHOLDERS. Seif's OpenAPI servers block is
  // `https://staging.TBD.example/api/v1` — the real staging/prod hosts are TBD
  // (announced via contract-changelog.md). Change request pending. Do NOT ship.
  static String _baseUrlFor(Flavor flavor) => switch (flavor) {
        Flavor.dev => 'https://staging.TBD.example/api/v1',
        Flavor.staging => 'https://staging.TBD.example/api/v1',
        Flavor.prod => 'https://TBD.example/api/v1',
      };
}
