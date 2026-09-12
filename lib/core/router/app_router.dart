import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account_shells/screens/customer_support_screen.dart';
import '../../features/account_shells/screens/friends_screen.dart';
import '../../features/account_shells/screens/legal_document_screen.dart';
import '../../features/account_shells/screens/refer_a_friend_screen.dart';
import '../../features/auth/models/otp_args.dart';
import '../../features/auth/notifier/auth_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/catalog/screens/chapters_screen.dart';
import '../../features/catalog/screens/lessons_screen.dart';
import '../../features/catalog/screens/subject_tree_screen.dart';
import '../../features/catalog/screens/subjects_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/mistakes/screens/mistakes_overview_screen.dart';
import '../../features/mistakes/screens/mistakes_subject_screen.dart';
import '../../features/mistakes/screens/mistakes_tree_screens.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/quiz/models/quiz.dart';
import '../../features/quiz/models/quiz_setup_args.dart';
import '../../features/quiz/screens/quiz_result_screen.dart';
import '../../features/quiz/screens/quiz_screen.dart';
import '../../features/quiz/screens/quiz_setup_screen.dart';
import '../../features/registration/models/registration_args.dart';
import '../../features/registration/screens/school_detail_screen.dart';
import '../../features/registration/screens/signup_identity_screen.dart';
import '../../features/registration/screens/signup_track_screen.dart';
import '../../features/registration/screens/university_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/shell/screens/tab_placeholder.dart';
import '../../l10n/app_localizations.dart';

/// The auth routes — reachable while signed out. Everything else requires auth.
/// The whole `/register` wizard is pre-auth: registration happens BEFORE any
/// account/token exists, so every `/register*` sub-route must stay reachable
/// while unauthenticated (see [_atAuthRoute]).
///
/// `/` (onboarding) is in this set, and it has to be: without it a signed-out
/// student landing on `/` is redirected to `/login` and never sees onboarding at
/// all.
const _authRoutes = {'/', '/login', '/otp'};

/// A location is an auth route if it is a known signed-out route OR anywhere in
/// the `/register` wizard (identity → track → Day-3 sub-flows).
bool _atAuthRoute(String location) =>
    _authRoutes.contains(location) || location.startsWith('/register');

/// The pre-auth landing routes an ALREADY-authenticated student must be bounced
/// off. Onboarding sells the app to someone who has not signed up; showing "Get
/// Started / Log In" to a student with a live session is worse than useless, and
/// a returning student cold-starting at `/` would otherwise sit on it.
///
/// This is why no "onboarding seen" flag is stored: auth state already answers
/// the question. First launch → unauthenticated → `/` renders. Returning →
/// authenticated → `/home` before paint.
const _signedInLandingRedirects = {'/', '/login'};

/// Pure redirect decision (unit-tested directly). Returns the path to redirect
/// to, or null to stay.
/// - `unknown` (first frame, token read pending) → wait, don't redirect.
/// - signed out on a protected route → /login.
/// - signed in sitting on a pre-auth landing route (`/` or `/login`) → /home.
String? authRedirect(AuthStatus status, String matchedLocation) {
  final atAuthRoute = _atAuthRoute(matchedLocation);
  if (status is AuthUnknown) return null;
  if (status is AuthUnauthenticated && !atAuthRoute) return '/login';
  if (status is AuthAuthenticated &&
      _signedInLandingRedirects.contains(matchedLocation)) {
    return '/home';
  }
  return null;
}

/// go_router skeleton. Routes mirror the build plan. A ShellRoute wraps the
/// bottom-nav destinations (home / profile / settings).
///
/// The [AuthController] is the single source of auth truth: a `ValueNotifier`
/// mirror feeds `refreshListenable`, so any auth-state change (e.g. forceLogout
/// on `session_superseded`) re-runs [authRedirect] and lands the user on /login.
final routerProvider = Provider<GoRouter>((ref) {
  // Mirror AuthController state into a Listenable go_router can watch.
  final authListenable = ValueNotifier<AuthStatus>(
    ref.read(authControllerProvider),
  );
  ref.listen<AuthStatus>(authControllerProvider, (_, next) {
    authListenable.value = next;
  });
  ref.onDispose(authListenable.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authListenable,
    redirect: (context, state) =>
        authRedirect(ref.read(authControllerProvider), state.matchedLocation),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const OnboardingScreen()),
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
      // The two track-detail forms (Figma 337:5269 / 337:10373). Both end in
      // `POST /auth/register`, which returns tokens — so the student leaves
      // these screens already authenticated, straight to /home.
      GoRoute(
        path: '/register/school',
        builder: (_, _) => const SchoolDetailScreen(),
      ),
      GoRoute(
        path: '/register/university',
        builder: (_, _) => const UniversityDetailScreen(),
      ),
      GoRoute(
        path: '/track-select',
        builder: (_, _) => const _Placeholder('Track select'),
      ),
      // The signed-in app lives inside the 5-tab nav shell. `indexedStack`
      // keeps one Navigator per branch, so each tab preserves its own state
      // (and Home does not re-fetch `/me`) when the student switches tabs.
      // Home is branch 0 → the tab you land on after login.
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              // The real LeaderboardScreen is built and tested, but
              // `GET /leaderboard` is `x-stability: draft` AT OUR PIN. It is
              // already `stable` upstream (3.5.0-m1); this stays on the
              // placeholder until `contract/` is re-vendored and the board is
              // audited against the behavioural changes it predates — the swap
              // is one line, the audit is not. D-008 + its 2026-09-10
              // Correction.
              GoRoute(
                path: '/leaderboard',
                builder: (_, _) => const LeaderboardPlaceholderScreen(),
              ),
            ],
          ),
          // Learn — the catalog browse stack. The drill-down routes are NESTED
          // inside the branch, so each level pushes onto the Learn branch's own
          // Navigator: the nav bar stays put and switching tabs mid-drill-down
          // preserves where you were.
          //
          // Every level carries its ids in the PATH, and all three read the one
          // `subjectTreeProvider(subjectId)` — the ids select from the cached
          // tree, they are not fetch keys for per-level requests.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                builder: (_, _) => const SubjectsScreen(),
                routes: [
                  // Mistakes — INSIDE the Learn branch, not beside /quiz.
                  // Every frame in the family draws the bottom nav bar with
                  // Learn active, so these are pushes onto this branch's own
                  // Navigator: the bar stays put and the header's back chevron
                  // appears because the branch can pop.
                  //
                  // Same architecture as the catalog stack below it — the
                  // subject route fetches the whole pruned tree once and the
                  // nested levels are VIEWS over that one cached object, not
                  // fetch keys. University stops at the subject route; its tree
                  // is flat, so the two nested routes are simply never reached
                  // on that track.
                  GoRoute(
                    path: 'mistakes',
                    builder: (_, _) => const MistakesOverviewScreen(),
                    routes: [
                      GoRoute(
                        path: 'subject/:subjectId',
                        builder: (_, state) => MistakesSubjectScreen(
                          subjectId: state.pathParameters['subjectId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'unit/:unitId',
                            builder: (_, state) => MistakesChaptersScreen(
                              subjectId: state.pathParameters['subjectId']!,
                              unitId: state.pathParameters['unitId']!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'chapter/:chapterId',
                                builder: (_, state) => MistakesLessonsScreen(
                                  subjectId: state.pathParameters['subjectId']!,
                                  unitId: state.pathParameters['unitId']!,
                                  chapterId: state.pathParameters['chapterId']!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ONE route for both tracks: the screen loads the tree and
                  // switches on the contract's `track` discriminator — school
                  // continues into the nested unit/chapter/lesson routes below,
                  // university stops here with a flat lecture list. The
                  // university path is intentionally shorter, so those nested
                  // routes are simply never reached on that track.
                  GoRoute(
                    path: 'subject/:subjectId',
                    builder: (_, state) => SubjectTreeScreen(
                      subjectId: state.pathParameters['subjectId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'unit/:unitId',
                        builder: (_, state) => ChaptersScreen(
                          subjectId: state.pathParameters['subjectId']!,
                          unitId: state.pathParameters['unitId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'chapter/:chapterId',
                            builder: (_, state) => LessonsScreen(
                              subjectId: state.pathParameters['subjectId']!,
                              unitId: state.pathParameters['unitId']!,
                              chapterId: state.pathParameters['chapterId']!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/message',
                builder: (_, _) => const MessagePlaceholderScreen(),
              ),
            ],
          ),
          // Account — the tab root IS the Profile hub (Figma `166:4416`). One
          // screen for both tracks, powered by the `/me` the Home tab already
          // fetched: switching to this tab costs no request.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // OUTSIDE the shell on purpose: taking a quiz is a full-screen task, not a
      // tab. (The frames draw the nav bar; the routing decision predates them
      // and stands.) Both tracks route here — the only difference is which
      // QuizSetupArgs constructor the Learn stack used.
      GoRoute(
        path: '/quiz/setup',
        builder: (_, state) =>
            QuizSetupScreen(args: state.extra! as QuizSetupArgs),
      ),
      // The `Quiz` rides as `extra` because quiz state is IN MEMORY ONLY:
      // questions are never cached, and `GET /quizzes/{quizId}` is `draft`, so
      // a cold deep-link to this path has nothing to rebuild from. It says so
      // rather than rendering an empty quiz.
      GoRoute(
        path: '/quiz/:quizId',
        builder: (_, state) => switch (state.extra) {
          final Quiz quiz => QuizScreen(quiz: quiz),
          _ => const _QuizUnavailableScreen(),
        },
        routes: [
          // Nested so the result belongs to its quiz, but pushed with
          // `pushReplacement` — the finished session must not sit under it for
          // Back to land on, and the screen's own PopScope sends Back to
          // /learn.
          GoRoute(
            path: 'result',
            builder: (_, state) =>
                QuizResultScreen(args: state.extra! as QuizResultArgs),
          ),
        ],
      ),
      // `/profile` is the same hub as the `/account` tab, reachable outside the
      // shell (deep links, and the parent of `/profile/edit`). `/profile/edit`
      // is NESTED so the pencil pushes a child of the profile it came from.
      //
      // Note there is deliberately NO route for `Logout` or `Go to Uni`: their
      // frames render Profile with a modal on top, so they are dialogs. Giving
      // a modal a route would put it in the back stack and let a cold link land
      // on a bare "are you sure?" with nothing behind it.
      GoRoute(
        path: '/profile',
        builder: (_, _) => const ProfileScreen(),
        routes: [
          // The real form against `PATCH /me` (Day 8 step 2) — the last stable
          // endpoint in the contract.
          GoRoute(path: 'edit', builder: (_, _) => const EditProfileScreen()),
        ],
      ),
      // The real Settings screen (Day 8 step 3). Languages and Mode are client
      // preferences; Rank writes the two adr-023 privacy fields through the
      // same `PATCH /me` Edit Profile uses.
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      // The Account cluster's SHELLS — designed screens with no endpoint
      // behind them. Each renders its frame's shape with every control
      // disabled; none of them fetches anything, because there is nothing to
      // fetch (seif_fight.md S5, S30, S33, S36).
      //
      // Outside the nav shell, like `/profile/edit`: they are pushed from the
      // Account tab and cover the nav bar, rather than being tabs themselves.
      GoRoute(path: '/refer', builder: (_, _) => const ReferAFriendScreen()),
      GoRoute(
        path: '/support',
        builder: (_, _) => const CustomerSupportScreen(),
      ),
      // No entry point in the app — the Profile frame draws no Friends row (see
      // FriendsScreen). Routed so the built screen is reachable and testable
      // the day a design gives it a door.
      GoRoute(path: '/friends', builder: (_, _) => const FriendsScreen()),
      // Two paths, one screen: the documents differ by title and by nothing
      // else until somebody supplies the copy.
      GoRoute(
        path: '/legal/privacy',
        builder: (_, _) =>
            const LegalDocumentScreen(document: LegalDocument.privacy),
      ),
      GoRoute(
        path: '/legal/terms',
        builder: (_, _) =>
            const LegalDocumentScreen(document: LegalDocument.terms),
      ),
    ],
  );
});

/// A cold deep-link to `/quiz/:quizId` with no `Quiz` in `extra`.
///
/// Unrecoverable by design, not by omission: quiz state is in memory only
/// (questions are never cached — the contract frames the bank as the product),
/// and the endpoint that could rebuild a session, `GET /quizzes/{quizId}`, is
/// `x-stability: draft`. So this says so and offers the way back, rather than
/// rendering an empty quiz or spinning forever.
class _QuizUnavailableScreen extends StatelessWidget {
  const _QuizUnavailableScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.genericError, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/learn'),
                child: Text(l10n.backToLearn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Temporary destination so the skeleton runs. Replaced screen-by-screen.
///
/// [title] is a DEVELOPER label naming the unbuilt route, not product copy —
/// it only reaches the app bar so a half-built build is navigable. The body
/// uses the existing `comingSoon` key, because that line is the one a student
/// actually reads, in an app whose baseline locale is Arabic.
///
/// Only `/track-select` uses it now. `/subscription` and `/subscription/return`
/// went with the purchase surface (adr-049 — the app is purchase-silent;
/// D-007), which settled the product decision Wave 3 recorded in
/// `.ai/audits/current/wave3-implementation.md`: removed, not built.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(AppLocalizations.of(context).comingSoon)),
    );
  }
}
