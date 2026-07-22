import 'bootstrap.dart';
import 'core/config/app_config.dart';

/// Prod flavor entrypoint:  flutter run -t lib/main_prod.dart --release
void main() => bootstrap(Flavor.prod);
