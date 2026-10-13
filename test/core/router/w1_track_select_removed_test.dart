import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements SecureStorage {}

/// `/track-select` was a placeholder route ("Coming soon") that nothing in the
/// app navigated to. A student chooses a Track in the registration wizard
/// (`/register/track`); the only later change is the Profile "Go to Uni" flow,
/// which is a dialog, not a route. The dead route and its `_Placeholder` widget
/// are gone, and this pins that they stay gone: an unmatched location is the
/// router's error page, not a screen that says "Coming soon".
void main() {
  // `GoRouter` initialises the widgets binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoRouter router;

  setUp(() {
    // The auth controller reads the stored token as the router is built; the
    // platform plugin is not there in a test.
    final storage = _MockSecureStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    router = container.read(routerProvider);
  });

  /// Every path the route tree declares, parents joined to children.
  Set<String> declaredPaths() {
    final paths = <String>{};

    void walk(List<RouteBase> routes, String prefix) {
      for (final route in routes) {
        switch (route) {
          case StatefulShellRoute(:final branches):
            for (final branch in branches) {
              walk(branch.routes, prefix);
            }
          case GoRoute(:final path, routes: final children):
            final full = path.startsWith('/') ? path : '$prefix/$path';
            paths.add(full);
            walk(children, full);
          default:
            break;
        }
      }
    }

    walk(router.configuration.routes, '');
    return paths;
  }

  test('no route declares /track-select', () {
    final paths = declaredPaths();

    // The walk really found the app, so an empty set cannot pass this.
    expect(paths, containsAll(['/home', '/register/track', '/profile/edit']));
    expect(paths, isNot(contains('/track-select')));
  });

  test('/track-select matches nothing: it is the error page, not a screen', () {
    expect(
      router.configuration.findMatch(Uri.parse('/track-select')).isError,
      isTrue,
    );
  });

  test('the real Track choice is still routed', () {
    expect(
      router.configuration.findMatch(Uri.parse('/register/track')).isError,
      isFalse,
    );
  });
}
