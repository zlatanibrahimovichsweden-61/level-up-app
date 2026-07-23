import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/otp_args.dart';
import '../../features/auth/notifier/auth_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';

/// The auth routes — reachable while signed out. Everything else requires auth.
const _authRoutes = {'/login', '/otp', '/register'};

/// Pure redirect decision (unit-tested directly). Returns the path to redirect
/// to, or null to stay.
/// - `unknown` (first frame, token read pending) → wait, don't redirect.
/// - signed out on a protected route → /login.
/// - signed in sitting on /login → /home.
String? authRedirect(AuthStatus status, String matchedLocation) {
  final atAuthRoute = _authRoutes.contains(matchedLocation);
  if (status is AuthUnknown) return null;
  if (status is AuthUnauthenticated && !atAuthRoute) return '/login';
  if (status is AuthAuthenticated && matchedLocation == '/login') return '/home';
  return null;
}

/// go_router skeleton. Routes mirror the build plan. A ShellRoute wraps the
/// bottom-nav destinations (home / profile / settings).
///
/// The [AuthController] is the single source of auth truth: a `ValueNotifier`
/// mirror feeds `refreshListenable`, so any auth-state change (e.g. forceLogout
/// on `session_superseded`) re-runs [authRedirect] and lands the user on /login.
/// TODO(deep-link): register the Paymob return route scheme once Seif provides
/// it (contract says "returns via deep link" but the scheme/host is TBD).
final routerProvider = Provider<GoRouter>((ref) {
  // Mirror AuthController state into a Listenable go_router can watch.
  final authListenable = ValueNotifier<AuthStatus>(ref.read(authControllerProvider));
  ref.listen<AuthStatus>(authControllerProvider, (_, next) {
    authListenable.value = next;
  });
  ref.onDispose(authListenable.dispose);

  return GoRouter(
    // The guard decides; onboarding ('/') stays deferred behind the guard.
    initialLocation: '/login',
    refreshListenable: authListenable,
    redirect: (context, state) =>
        authRedirect(ref.read(authControllerProvider), state.matchedLocation),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Placeholder('Onboarding')),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/otp',
        builder: (_, state) => OtpScreen(args: state.extra! as OtpArgs),
      ),
      GoRoute(path: '/register', builder: (_, _) => const _Placeholder('Register')),
      GoRoute(path: '/track-select', builder: (_, _) => const _Placeholder('Track select')),
      GoRoute(path: '/home', builder: (_, _) => const _Placeholder('Home')),
      GoRoute(path: '/catalog', builder: (_, _) => const _Placeholder('Subjects')),
      GoRoute(path: '/quiz/:quizId', builder: (_, _) => const _Placeholder('Quiz')),
      GoRoute(path: '/subscription', builder: (_, _) => const _Placeholder('Subscription')),
      GoRoute(path: '/subscription/return', builder: (_, _) => const _Placeholder('Paymob return')),
      GoRoute(path: '/profile', builder: (_, _) => const _Placeholder('Profile')),
      GoRoute(path: '/settings', builder: (_, _) => const _Placeholder('Settings')),
    ],
  );
});

/// Temporary destination so the skeleton runs. Replaced screen-by-screen.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — not built yet')),
    );
  }
}
