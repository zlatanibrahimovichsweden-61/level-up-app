import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/otp_args.dart';
import '../../features/auth/notifier/auth_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/registration/models/registration_args.dart';
import '../../features/registration/screens/signup_identity_screen.dart';
import '../../features/registration/screens/signup_track_screen.dart';

/// The auth routes — reachable while signed out. Everything else requires auth.
/// The whole `/register` wizard is pre-auth: registration happens BEFORE any
/// account/token exists, so every `/register*` sub-route must stay reachable
/// while unauthenticated (see [_atAuthRoute]).
const _authRoutes = {'/login', '/otp'};

/// A location is an auth route if it is a known signed-out route OR anywhere in
/// the `/register` wizard (identity → track → Day-3 sub-flows).
bool _atAuthRoute(String location) =>
    _authRoutes.contains(location) || location.startsWith('/register');

/// Pure redirect decision (unit-tested directly). Returns the path to redirect
/// to, or null to stay.
/// - `unknown` (first frame, token read pending) → wait, don't redirect.
/// - signed out on a protected route → /login.
/// - signed in sitting on /login → /home.
String? authRedirect(AuthStatus status, String matchedLocation) {
  final atAuthRoute = _atAuthRoute(matchedLocation);
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
      // Registration wizard (Day 2 front two screens + Day-3 sub-flow stubs).
      // `/register` seeds the draft from the OTP `extra`; back-navigation re-enters
      // with a null extra and uses the already-seeded draft.
      GoRoute(
        path: '/register',
        builder: (_, state) =>
            SignupIdentityScreen(args: state.extra as RegistrationArgs?),
      ),
      GoRoute(
        path: '/register/track',
        builder: (_, _) => const SignupTrackScreen(),
      ),
      GoRoute(
        path: '/register/school',
        builder: (_, _) => const _Placeholder('School flow'),
      ),
      GoRoute(
        path: '/register/university',
        builder: (_, _) => const _Placeholder('University flow'),
      ),
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
