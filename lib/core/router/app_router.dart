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
import '../../features/flashcards/screens/flashcard_setup_screen.dart';
import '../../features/flashcards/screens/flashcard_study_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/leaderboard/screens/leaderboard_screen.dart';
import '../../features/mistakes/screens/mistakes_overview_screen.dart';
import '../../features/mistakes/screens/mistakes_subject_screen.dart';
import '../../features/mistakes/screens/mistakes_tree_screens.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/quiz/models/quiz.dart';
import '../../features/quiz/models/quiz_review_args.dart';
import '../../features/quiz/models/quiz_setup_args.dart';
import '../../features/quiz/screens/quiz_result_screen.dart';
import '../../features/quiz/screens/quiz_review_screen.dart';
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
import '../../features/support/screens/create_support_ticket_screen.dart';
import '../../features/support/screens/support_ticket_screen.dart';
import '../../l10n/app_localizations.dart';
import 'return_target.dart';
import 'route_error_screen.dart';

/// The auth routes — reachable while signed out. Everything else requires auth.
/// The whole `/register` wizard is pre-auth: registration happens BEFORE any
/// account/token exists, so every `/register*` sub-route must stay reachable
/// while unauthenticated (see [_atAuthRoute]).
///
/// `/` (onboarding) is in this set, and it has to be: without it a signed-out
/// student landing on `/` is redirected to `/login` and never sees onboarding at
/// all.
const _authRoutes = {'/', '/login', '/login/otp'};

/// The legal documents (CW04a, owner D2 2026-10-10) — reachable signed out
/// too, though they are not part of signing in: Login links to them before any
/// account exists, and the contract serves them without sign-in
/// (`getLegalDocument`, `security: []`). Exact paths, not a `/legal` prefix,
/// so any other `/legal/…` location is still protected. Signed in they stay
/// reachable from Profile: neither is in [_signedInLandingRedirects].
const _publicDocumentRoutes = {'/legal/privacy', '/legal/terms'};

/// A location is an auth route if it is a known signed-out route OR anywhere in
/// the `/register` wizard (identity → track → Day-3 sub-flows). The public
/// legal documents pass the same way.
bool _atAuthRoute(String location) =>
    _authRoutes.contains(location) ||
    _publicDocumentRoutes.contains(location) ||
    location.startsWith('/register');

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

/// The location a signed-out bounce should remember, or null for "nothing worth
/// returning to" (unit-tested directly, like [authRedirect]).
///
/// **Only a location inside the tab shell** — one that matches under the
/// `StatefulShellRoute` — is remembered, and that is decided by asking the
/// router's own [configuration] what `uri` matches, not by a path list that
/// would drift as routes are added. Why only the shell:
/// - A shell location opened with `go` gets its whole parent stack built from
///   the path (`/learn/subject/1/unit/2` rebuilds `/learn` and `/learn/subject/1`
///   beneath it), the bottom nav, and a working back chip.
/// - Every top-level route outside it — `/profile*`, `/settings`, `/refer`,
///   `/support`, `/friends`, `/legal/*`, `/quiz*` — would
///   open with NOTHING beneath it, no nav bar, a dead back chip
///   (`TitledChrome` is `maybePop()`) and an Android BACK that exits the app. It
///   was `/home` before this existed, so those fall back to `/home`.
/// - That also covers what must never be remembered anyway: the auth routes
///   (`/`, `/login`, `/login/otp`, `/register*`), an unmatched location (no
///   match at all), and `/quiz*`, whose pages are built from an in-memory
///   `extra` that neither a sign-out nor go_router's refresh keeps.
///
/// Returns path PLUS query (`Uri.toString()`). In memory only — see
/// [ReturnTarget].
String? rememberableLocation(RouteConfiguration configuration, Uri uri) {
  // Not an app location at all (go_router's empty configuration is `Uri()`),
  // and `findMatch` asserts on a path that does not start with `/`.
  if (!uri.path.startsWith('/')) return null;
  final match = configuration.findMatch(uri);
  if (match.isError) return null;
  if (!match.routes.any((route) => route is StatefulShellRoute)) return null;
  return uri.toString();
}

/// The location actually ON SCREEN, or null while go_router has nothing to show
/// (before the first parse, or on its error page).
///
/// This is not `state.uri` of the redirect. When an auth flip makes go_router
/// refresh, it re-parses its STORED location, and a screen opened with `push`
/// is not stored — the redirect sees the base of the stack (`/learn`, not the
/// `/learn/mistakes` that Subjects pushed over it; the same blind spot as
/// `currentConfiguration.uri`). Pushes INSIDE the shell are common (Mistakes,
/// Lessons, Lectures), and the shell location on screen is the better place to
/// return to, so it is read from `router.state`, which is the topmost page —
/// but which throws on an empty or error configuration, hence the guard.
Uri? _shownLocation(GoRouter router) {
  final shown = router.routerDelegate.currentConfiguration;
  if (shown.isEmpty || shown.isError) return null;
  return router.state.uri;
}

/// Called by the router's `redirect` whenever a SIGNED-OUT student is bounced.
///
/// A user-initiated sign-out remembers nothing (and `AuthController.logout`
/// has already cleared anything earlier). Otherwise the location is what was on
/// screen when that is a rememberable one — the session ended under the student
/// there — else the location being parsed (a cold start or a link followed while
/// signed out), when [rememberableLocation] allows it. A non-shell page pushed
/// over a shell page (`/support` over `/account`) is not rememberable, so the
/// shell page beneath it — the stored location — is what comes back.
///
/// When NO location is rememberable, the target is cleared, not kept: the newest
/// bounce wins, and an older target would otherwise send the next sign-in to a
/// place the student was not heading from this sign-out.
///
/// [router] is null only if go_router were to run a redirect before
/// `routerProvider` has the router in hand. It cannot today (the parser runs
/// only once the `Router` widget mounts, after the constructor), but the
/// redirect must degrade to "remember nothing", never throw.
///
/// Writes only to the plain [ReturnTarget] holder — never to Riverpod state,
/// because a redirect runs during navigation/build (BUG-001).
void _noteSignedOutBounce(
  ReturnTarget target,
  AuthUnauthenticated status,
  GoRouterState state,
  GoRouter? router,
) {
  if (router == null || status.reason == LogoutReason.userInitiated) return;
  final configuration = router.configuration;
  final shown = _shownLocation(router);
  final location =
      (shown == null ? null : rememberableLocation(configuration, shown)) ??
      rememberableLocation(configuration, state.uri);
  if (location != null) {
    target.remember(location);
  } else {
    target.clear();
  }
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

  // The args the OTP page was last opened with. go_router re-parses the STORED
  // location on every refresh, and the stored form drops an `extra` it cannot
  // JSON-encode — so the auth flip that a correct code causes rebuilt the OTP
  // page with a null `extra` (a red screen under the success view). The route
  // keeps what it was given; a fresh `go` with new args replaces it.
  //
  // Declared above the auth listener because that listener ends them (NR-29).
  OtpArgs? lastOtpArgs;

  ref.listen<AuthStatus>(authControllerProvider, (previous, next) {
    // The args carry the phone number the code was sent to, and this closure
    // outlives the session (`invalidateSessionScope` cannot reach it). They are
    // dropped when a session ENDS — the move into signed-out from any other
    // status — and kept across the flip a correct code causes (to
    // authenticated), where the success view still needs them. A repeat of
    // signed-out (the one-time message being consumed on Login) is not an end.
    if (next is AuthUnauthenticated && previous is! AuthUnauthenticated) {
      lastOtpArgs = null;
    }
    authListenable.value = next;
  });
  ref.onDispose(authListenable.dispose);

  // Read by the redirect below to see what is on screen. Assigned by the
  // `return` at the end; go_router never runs a redirect inside its constructor.
  GoRouter? router;

  return router = GoRouter(
    initialLocation: '/',
    refreshListenable: authListenable,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider);
      final destination = authRedirect(status, state.matchedLocation);
      // A signed-out redirect IS the bounce to /login. Remember where from.
      if (destination != null && status is AuthUnauthenticated) {
        try {
          _noteSignedOutBounce(
            ref.read(returnTargetProvider),
            status,
            state,
            router,
          );
        } catch (_) {
          // Remembering where the student was heading is a convenience. If it
          // fails for any reason the bounce to /login must still happen, so the
          // failure is dropped: not rethrown, and not logged (a location can
          // carry a student's own ids).
        }
      }
      return destination;
    },
    // A location no route matches. A signed-out student is normally sent to
    // /login by `authRedirect` before this renders. Two edges are not bounced:
    // while the status is still `AuthUnknown` (a cold start, before the stored
    // token is read) `authRedirect` waits, so an unmatched cold-start location
    // would show this page until the read resolves and the bounce runs; and
    // `_atAuthRoute` treats every `/register…` location as an auth route, so an
    // unmatched `/register…` path is not bounced. Neither is reachable through
    // any URL or deep-link entry point the app ships (no intent filters beyond
    // MAIN/LAUNCHER, no URL types in Info.plist), and every in-app `/register`
    // navigation is a fixed valid path. Only a platform route override can
    // supply such a cold-start location — go_router honours the platform's
    // default route over `initialLocation`, so an explicit launch carrying a
    // route, or a test harness (`defaultRouteNameTestValue`), reaches it.
    errorBuilder: (_, _) => const RouteErrorScreen(),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const OnboardingScreen()),
      // OTP is nested under /login (BUG-005). As a top-level route opened with
      // `push`, the location stayed `/login`; verifying flipped auth, the
      // redirect below sent a signed-in student on `/login` to `/home`, and
      // the success view was never seen. `/login/otp` is not a landing route,
      // so the redirect leaves it alone until "Continue" goes to /home.
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'otp',
            // No args at all (never opened from Login) → back to Login rather
            // than a null-check crash.
            redirect: (_, state) =>
                state.extra is OtpArgs || lastOtpArgs != null ? null : '/login',
            builder: (_, state) {
              final extra = state.extra;
              if (extra is OtpArgs) lastOtpArgs = extra;
              return OtpScreen(args: lastOtpArgs!);
            },
          ),
        ],
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
              // UN-GATED 2026-09-22. D-008 is closed: `GET /leaderboard` is
              // `x-stability: stable` at the pin 768e67d (3.22.0-m1,
              // `contract/openapi.yaml:2007`), and the audit that the gate was
              // actually waiting on — the board against the six behavioural
              // changes it predates — is `docs/D008_LEADERBOARD_AUDIT.md`.
              //
              // Un-gating was never a revert, which is why the stability flip
              // on 2026-09-12 did not by itself reopen this route.
              GoRoute(
                path: '/leaderboard',
                builder: (_, _) => const LeaderboardScreen(),
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
                      // Flashcards — a university lecture's Setup, and the
                      // study round pushed over it. Both stay INSIDE the Learn
                      // branch (every flashcard frame draws the bar with Learn
                      // active), so the nav bar stays put like the drill-down
                      // above. The ids ride in the PATH only: go_router drops a
                      // non-JSON `extra` on an auth refresh (BUG-005), and
                      // neither screen needs anything the two ids do not give.
                      // The lecture is found by scanning the cached subject
                      // tree, exactly as the other levels do.
                      GoRoute(
                        path: 'lecture/:lectureId/flashcards',
                        builder: (_, state) => FlashcardSetupScreen(
                          subjectId: state.pathParameters['subjectId']!,
                          lectureId: state.pathParameters['lectureId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'study',
                            builder: (_, state) => FlashcardStudyScreen(
                              subjectId: state.pathParameters['subjectId']!,
                              lectureId: state.pathParameters['lectureId']!,
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
        builder: (_, state) => switch (state.extra) {
          final QuizSetupArgs args => QuizSetupScreen(args: args),
          _ => const _QuizUnavailableScreen(),
        },
      ),
      // The `Quiz` rides as `extra` because quiz state is IN MEMORY ONLY:
      // questions are never cached, and `GET /quizzes/{quizId}` is `draft`, so
      // a cold deep-link to this path has nothing to rebuild from. It says so
      // rather than rendering an empty quiz.
      GoRoute(
        path: '/quiz/:quizId',
        builder: (_, state) => switch (state.extra) {
          // Setup's launch: the quiz plus the subject for the result's line.
          final QuizScreenArgs args => QuizScreen(
            quiz: args.quiz,
            subjectName: args.subjectName,
          ),
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
            builder: (_, state) => switch (state.extra) {
              final QuizResultArgs args => QuizResultScreen(args: args),
              _ => const _QuizUnavailableScreen(),
            },
            routes: [
              // Nested under the result for the same reason the result is
              // nested under the quiz: review belongs to the quiz just
              // finished and is reachable from nowhere else. Reviewing from
              // history needs `GET /quizzes/{quizId}`, which is draft —
              // seif_fight S14.
              //
              // Like its two ancestors this does NOT force-unwrap `extra`.
              // The review payload is in-memory only, so a cold deep-link or a
              // process restart lands here with nothing to rebuild from; it
              // says so rather than throwing a cast error.
              GoRoute(
                path: 'review',
                builder: (_, state) => switch (state.extra) {
                  final QuizReviewArgs args => QuizReviewScreen(args: args),
                  _ => const _QuizUnavailableScreen(),
                },
              ),
            ],
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
      // The support tickets' other two screens (CW12a), flat siblings of
      // `/support` and pushed over the shell the same way: the frames draw no
      // nav bar. Authenticated by the default-deny redirect; not shell
      // locations, so return-to-target never remembers them. `ticketId` is the
      // server's handle, never the `TK-n` reference.
      GoRoute(
        path: '/support/new',
        builder: (_, _) => const CreateSupportTicketScreen(),
      ),
      GoRoute(
        path: '/support/tickets/:ticketId',
        builder: (_, state) =>
            SupportTicketScreen(ticketId: state.pathParameters['ticketId']!),
      ),
      // No entry point in the app — the Profile frame draws no Friends row (see
      // FriendsScreen). Routed so the built screen is reachable and testable
      // the day a design gives it a door.
      GoRoute(path: '/friends', builder: (_, _) => const FriendsScreen()),
      // The notifications inbox (CW07a), pushed from the Home bell over the
      // shell like `/support`: the frame draws no nav bar. Authenticated by the
      // default-deny redirect; not a shell location, so return-to-target never
      // remembers it.
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationsScreen(),
      ),
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

/// A cold deep-link to `/quiz/setup` (no `QuizSetupArgs` in `extra`),
/// `/quiz/:quizId` (no `Quiz`), `/quiz/:quizId/result` (no `QuizResultArgs`) or
/// `/quiz/:quizId/result/review` (no `QuizReviewArgs`).
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
