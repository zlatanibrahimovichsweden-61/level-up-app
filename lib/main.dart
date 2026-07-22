// Default entrypoint so a bare `flutter run` works during development.
// The real flavor entrypoints are main_dev.dart / main_staging.dart /
// main_prod.dart — prefer `flutter run -t lib/main_dev.dart`.
import 'main_dev.dart' as dev;

void main() => dev.main();
