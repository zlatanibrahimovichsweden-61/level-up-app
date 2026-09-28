import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';
import 'profile_harness.dart';

/// Log out, sign a different student in, same process · API→UI Wave 19,
/// KNOWN_BUGS BUG-015 (device-proven 2026-09-20 on a tablet and again as W05-3).
///
/// Router-driven on purpose. The bug needs Home and Profile MOUNTED and
/// watching `meProvider` when the sign-out invalidates it: that is what makes
/// Riverpod rebuild it with no token, one frame before the shell unmounts, and
/// carry the result into the next session. `session_isolation_test.dart` reads
/// the provider with no widget listening, so it never engaged the mechanism.
///
/// Student A is the school fixture ("Ahmed Mohamed"), B the university one
/// ("Mona Adel"). The sign-in is `markAuthenticated`, exactly what the OTP
/// `authenticated` fork calls after it writes the tokens.
void main() {
  late MockAuthRepository auth;

  setUp(() {
    auth = MockAuthRepository();
    when(auth.logout).thenAnswer((_) async {});
  });

  /// A `/me` stub that answers for whoever is signed in. [tokenless] is what
  /// a request with no token gets: the mock backend answers the student it
  /// still has (A), staging answers 401 `authentication_required`.
  ({
    MockProfileRepository repo,
    void Function(String) signInAs,
    void Function() signOut,
  })
  server({
    required StudentProfile? Function() tokenless,
    Future<StudentProfile> Function()? secondStudent,
  }) {
    var who = 'A';
    var signedIn = true;
    final repo = MockProfileRepository();
    when(repo.getMe).thenAnswer((_) async {
      if (!signedIn) {
        final answer = tokenless();
        if (answer == null) {
          throw const UnauthorizedException(code: 'authentication_required');
        }
        return answer;
      }
      if (who == 'A') return schoolProfile();
      return secondStudent != null
          ? await secondStudent()
          : universityProfile();
    });
    when(repo.getEntitlements).thenAnswer((_) async => [baseEntitlement]);
    return (
      repo: repo,
      signInAs: (s) {
        who = s;
        signedIn = true;
      },
      signOut: () => signedIn = false,
    );
  }

  /// Account tab → Logout → Yes, the way a student does it.
  Future<void> logOut(WidgetTester tester, void Function() signOut) async {
    await openAccountTab(tester);
    await tapProfileKey(tester, 'profile_row_logout');
    signOut(); // the tokens go as the dialog confirms
    await tapProfileKey(tester, 'logout_confirm');
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  }

  for (final (shape, tokenless) in [
    ('the mock: a token-less /me answers the first student', schoolProfile),
    ('staging: a token-less /me is a 401', () => null),
  ]) {
    testWidgets('the second student sees their own profile on Home and on '
        'Profile ($shape)', (tester) async {
      final s = server(tokenless: tokenless);
      final container = await pumpProfileApp(
        tester,
        profile: s.repo,
        auth: auth,
        keepProfile: false,
      );
      expect(find.text('Ahmed Mohamed'), findsOneWidget);

      await logOut(tester, s.signOut);

      s.signInAs('B');
      container.read(authControllerProvider.notifier).markAuthenticated();
      await tester.pumpAndSettle();

      // Home: B's name, not A's and not an error.
      expect(find.text('Mona Adel'), findsOneWidget);
      expect(find.text('Ahmed Mohamed'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);

      // Profile.
      await openAccountTab(tester);
      expect(find.text('Mona Adel'), findsOneWidget);
      expect(find.text('Ahmed Mohamed'), findsNothing);

      holdProfile(container); // the teardown trap, see [holdProfile]
    });
  }

  testWidgets('the sign-out drops the first student\'s profile from memory', (
    tester,
  ) async {
    final s = server(tokenless: schoolProfile);
    final container = await pumpProfileApp(
      tester,
      profile: s.repo,
      auth: auth,
      keepProfile: false,
    );
    expect(container.exists(meProvider), isTrue);

    await logOut(tester, s.signOut);

    // Tier-0 C-2: nothing of A survives the session, readable or not.
    expect(container.exists(meProvider), isFalse);
  });

  testWidgets('while the second student\'s /me is in flight, nothing of the '
      'first shows', (tester) async {
    final second = Completer<StudentProfile>();
    final s = server(
      tokenless: schoolProfile,
      secondStudent: () => second.future,
    );
    final container = await pumpProfileApp(
      tester,
      profile: s.repo,
      auth: auth,
      keepProfile: false,
    );

    await logOut(tester, s.signOut);

    s.signInAs('B');
    container.read(authControllerProvider.notifier).markAuthenticated();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Loading, with no previous value: a refetch at sign-in alone would keep
    // A as the provider's value and paint A's name until B's arrived.
    final me = container.read(meProvider);
    expect(me.isLoading, isTrue);
    expect(me.value, isNull);
    expect(find.text('Ahmed Mohamed'), findsNothing);

    second.complete(universityProfile());
    await tester.pumpAndSettle();
    expect(find.text('Mona Adel'), findsOneWidget);

    holdProfile(container);
  });
}
