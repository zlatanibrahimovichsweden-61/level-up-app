import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/otp_args.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';

/// go_router skeleton. Routes mirror the build plan. A ShellRoute wraps the
/// bottom-nav destinations (home / profile / settings).
///
/// TODO(auth): add `redirect` guard reading token state (secure storage) —
/// unauthenticated → /login; authenticated hitting /login → /home. Lands with
/// the forced-logout screen (session_superseded) in the next brief.
/// TODO(deep-link): register the Paymob return route scheme once Seif provides
/// it (contract says "returns via deep link" but the scheme/host is TBD).
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Onboarding is deferred; Login is the entry point until the auth guard lands.
    initialLocation: '/login',
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
