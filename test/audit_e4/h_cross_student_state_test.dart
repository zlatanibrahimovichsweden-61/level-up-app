/// E4 (c), the hard half: does ONE student's session survive into the NEXT
/// sign-in on the same handset?
///
/// `invalidateSessionScope` invalidates the session providers at sign-out, but
/// Riverpod 3 never DISPOSES an invalidated element that still has a listener:
/// it rebuilds it (one frame later, with no token) and carries the previous
/// value through the rebuild. `meProvider` was made autoDispose for exactly this
/// (BUG-015); `docs/KNOWN_BUGS.md` BUG-015 said of the other non-autoDispose
/// session providers (subjects, subject tree, Mistakes overview): "whether they
/// carry the same stale value across a sign-out is unproven". These tests
/// proved it (E4-04/E4-05: every one of H1-H6 passed on the broken behaviour),
/// and now pin the fix.
///
/// THE FIX: those three providers (and `entitlementsProvider`, E4-03) are
/// autoDispose. The sign-out unmounts the shell, the last listener leaving
/// drops the element, and the NEXT student's first read builds from nothing:
/// a loading state (their own request in flight), never the previous student's
/// rows, and never the previous session's 401. Every test below fails on the
/// plain providers (mutation: remove `.autoDispose` from one of them).
///
/// Student A is the repo mock's school student (Arabic subject names); student
/// B is its university student (a different subject set) with a different id.
/// Each hand-over is run with student A having LEFT the screen under test
/// (`left`) and with A still ON it when the session ends (`on screen`): the
/// second is the dangerous order, because a still-mounted listener is what made
/// the old providers rebuild and keep A's value.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/catalog/notifier/subject_tree_notifier.dart';
import 'package:level_up_app/features/catalog/notifier/subjects_notifier.dart';
import 'package:level_up_app/features/mistakes/notifier/mistakes_notifiers.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:pinput/pinput.dart';

import 'support/e4_support.dart';

/// Student A's school subjects (`lib/dev/mock_backend.dart`, `_subjects`).
const _schoolOnly = [
  'الأحياء',
  'الكيمياء',
  'الفيزياء',
  'الرياضيات',
  'الجغرافيا',
  'اللغة العربية',
];

/// Student B's university subjects (`_universitySubjects`).
const _universityOnly = ['التشريح', 'الفسيولوجي', 'الأنسجة'];

const _someoneElse = '0197b2f3-bbbb-7cc3-9b4e-00000000000b';

void main() {
  Future<void> uiSignIn(
    WidgetTester tester,
    AppRig rig, {
    required String code,
  }) async {
    if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
      await tester.tap(find.text('Log In'));
      await pumpFrames(tester, frames: 5);
    }
    await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
    await pumpFrames(tester, frames: 3);
    await tester.tap(find.text('Send OTP'));
    await pumpFrames(tester, frames: 8);
    expect(find.byType(OtpScreen), findsOneWidget);
    await tester.enterText(find.byType(Pinput), code);
    await pumpFrames(tester, frames: 10);
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 25);
  }

  List<String> shown(WidgetTester tester, List<String> needles) {
    final texts = <String>[
      for (final t in tester.widgetList<Text>(find.byType(Text)))
        if (t.data != null) t.data!,
    ];
    return [
      for (final needle in needles)
        if (texts.any((s) => s == needle)) needle,
    ];
  }

  /// Student A works through Learn, Mistakes and one subject tree, and ends on
  /// [endAt] (default: the Learn list, having left the other two).
  Future<AppRig> studentAWorks(
    WidgetTester tester, {
    String endAt = '/learn',
  }) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await uiSignIn(tester, rig, code: '000000');
    expect(rig.location, '/home');

    final router = rig.container.read(routerProvider);
    router.go('/learn');
    await pumpFrames(tester, frames: 20);
    expect(shown(tester, _schoolOnly), isNotEmpty, reason: 'A saw subjects');
    router.go('/learn/mistakes');
    await pumpFrames(tester, frames: 20);
    router.go('/learn/subject/sub-bio');
    await pumpFrames(tester, frames: 20);
    router.go('/learn');
    await pumpFrames(tester, frames: 15);
    if (endAt != '/learn') {
      router.go(endAt);
      await pumpFrames(tester, frames: 20);
    }
    return rig;
  }

  /// The server ends A's session while A is on [endAt].
  ///
  /// Invalidating the provider of the screen A is ON makes it ask again, so the
  /// 401 reaches the interceptor. It has to be that one: a listener under an
  /// opened drill-down (the Learn list below the Mistakes overview) is paused,
  /// and a paused provider is not rebuilt, so it would never ask.
  Future<void> serverEndsSession(
    WidgetTester tester,
    AppRig rig, {
    String endAt = '/learn',
  }) async {
    rig.server.expireAccess();
    rig.server.refreshDead = true;
    switch (endAt) {
      case '/learn/mistakes':
        rig.container.invalidate(mistakesOverviewProvider);
      case '/learn/subject/sub-bio':
        rig.container.invalidate(subjectTreeProvider('sub-bio'));
      default:
        rig.container.invalidate(subjectsProvider);
    }
    await pumpFrames(tester, frames: 40);
    await tester.pump(const Duration(seconds: 10));
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    rig.server.refreshDead = false;
  }

  /// How student A's session ends before B signs in.
  Future<void> endA(
    WidgetTester tester,
    AppRig rig, {
    required bool forced,
    String endAt = '/learn',
  }) async {
    if (forced) {
      await serverEndsSession(tester, rig, endAt: endAt);
    } else {
      // Account > Sign Out calls exactly this.
      unawaited(rig.container.read(authControllerProvider.notifier).logout());
      await pumpFrames(tester, frames: 40);
      expect(rig.auth, isA<AuthUnauthenticated>());
      expect(rig.location, '/login');
    }
  }

  e4Widgets(
    'H1 E4-04a (fixed): after a forced sign-out the catalogue, Mistakes '
    'overview and subject-tree providers do not EXIST any more - nothing of '
    "the previous student's data is left in memory",
    (tester) async {
      final rig = await studentAWorks(tester);
      await serverEndsSession(tester, rig);
      final c = rig.container;

      // Dropped, not merely rebuilt: an element that still existed would hold
      // A's value through its error (Riverpod 3 keeps the last value).
      expect(c.exists(subjectsProvider), isFalse);
      expect(c.exists(mistakesOverviewProvider), isFalse);
      expect(c.exists(subjectTreeProvider('sub-bio')), isFalse);
      await tearDownTree(tester, rig);
    },
  );

  for (final endAt in ['/learn/mistakes', '/learn/subject/sub-bio']) {
    e4Widgets('H1b E4-04a (fixed): the same when A is still ON $endAt at the '
        'end - the provider of that very screen was listened to the whole '
        'time, and is gone after the sign-out', (tester) async {
      final rig = await studentAWorks(tester, endAt: endAt);
      final c = rig.container;
      // The screen is up and its provider is alive and listened to.
      expect(
        c.exists(
          endAt.contains('mistakes')
              ? mistakesOverviewProvider
              : subjectTreeProvider('sub-bio'),
        ),
        isTrue,
        reason: 'A is on $endAt',
      );

      await serverEndsSession(tester, rig, endAt: endAt);

      expect(c.exists(subjectsProvider), isFalse);
      expect(c.exists(mistakesOverviewProvider), isFalse);
      expect(c.exists(subjectTreeProvider('sub-bio')), isFalse);
      await tearDownTree(tester, rig);
    });
  }

  e4Widgets('H2 E4-04b (fixed): a DIFFERENT student signing in after a forced '
      'end opens Learn on THEIR OWN request - a loading state, never the '
      "previous session's error and never the previous student's rows", (
    tester,
  ) async {
    final rig = await studentAWorks(tester);
    await serverEndsSession(tester, rig);

    // B signs in: another student, the university track, another id.
    rig.server.signInStudentId = _someoneElse;
    await uiSignIn(tester, rig, code: '111111');
    expect(rig.auth, isA<AuthAuthenticated>());
    expect(rig.location, '/home');

    // B's answer is slow: held open until released.
    final subjectsGate = Completer<void>();
    rig.server.scripted['GET /catalog/subjects'] = (o) async {
      await subjectsGate.future;
      return null;
    };
    final router = rig.container.read(routerProvider);
    final before = rig.server.calls.length;
    router.go('/learn');
    await pumpFrames(tester, frames: 15);

    // Learn asked on open - there was no dead error to sit on.
    expect(
      rig.server.calls.skip(before).map((c) => c.key),
      contains('GET /catalog/subjects'),
      reason: "B's request is in flight and has not been answered",
    );
    // ...and while it is in flight there is neither an error nor A's data.
    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Retry'), findsNothing);
    expect(shown(tester, _schoolOnly), isEmpty, reason: 'A visible to B');
    expect(shown(tester, _universityOnly), isEmpty, reason: 'not answered yet');

    subjectsGate.complete();
    await pumpFrames(tester, frames: 20);
    expect(find.text('Something went wrong'), findsNothing);
    expect(shown(tester, _universityOnly), isNotEmpty, reason: 'B loads');
    expect(shown(tester, _schoolOnly), isEmpty);
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });

  e4Widgets('H3 E4-04c (fixed): the SAME via a normal sign-out while the Learn '
      'tab is the CURRENT tab, then sign in again WITHOUT restarting the app - '
      'Learn loads by itself, no "Something went wrong", no Retry needed', (
    tester,
  ) async {
    final rig = await studentAWorks(tester);

    // Profile -> Sign Out calls exactly this.
    unawaited(rig.container.read(authControllerProvider.notifier).logout());
    await pumpFrames(tester, frames: 40);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');

    await uiSignIn(tester, rig, code: '000000'); // the same student again
    final router = rig.container.read(routerProvider);
    final before = rig.server.calls.length;
    router.go('/learn');
    await pumpFrames(tester, frames: 25);

    expect(
      rig.server.calls.skip(before).map((c) => c.key),
      contains('GET /catalog/subjects'),
      reason: 'Learn must ask on open in the new session',
    );
    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Retry'), findsNothing);
    expect(shown(tester, _schoolOnly), isNotEmpty);
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });

  for (final forced in [true, false]) {
    final how = forced ? 'server ends the session' : 'Account > Sign Out';

    for (final onScreen in [false, true]) {
      final where = onScreen ? 'A still on the screen' : 'A left the screen';

      e4Widgets('H4 E4-05 (fixed) [$how; $where]: student B sees NONE of '
          "student A's per-subject Mistakes counts while B's own "
          'GET /me/mistakes is still in flight', (tester) async {
        final endAt = onScreen ? '/learn/mistakes' : '/learn';
        final rig = await studentAWorks(tester, endAt: endAt);
        await endA(tester, rig, forced: forced, endAt: endAt);

        rig.server.signInStudentId = _someoneElse;
        await uiSignIn(tester, rig, code: '111111'); // B: another student
        expect(rig.auth, isA<AuthAuthenticated>());

        // B's answer is slow: held open until released.
        final gate = Completer<void>();
        rig.server.scripted['GET /me/mistakes'] = (o) async {
          await gate.future;
          return null;
        };
        final before = rig.server.calls.length;
        rig.container.read(routerProvider).go('/learn/mistakes');
        await pumpFrames(tester, frames: 12);
        expect(
          rig.server.calls.skip(before).map((c) => c.key),
          contains('GET /me/mistakes'),
          reason: "B's request is in flight and has not been answered",
        );

        // Nothing on this screen may have come from A: no rows, no counts.
        expect(shown(tester, _schoolOnly), isEmpty, reason: "A's rows on B");
        expect(find.textContaining('34 mistakes'), findsNothing);
        expect(find.textContaining('100 mistakes'), findsNothing);
        expect(find.text('Something went wrong'), findsNothing);

        // B's own data replaces the skeleton once it lands.
        gate.complete();
        await pumpFrames(tester, frames: 20);
        expect(shown(tester, _schoolOnly), isEmpty);
        expect(shown(tester, _universityOnly), isNotEmpty);
        await tester.pump(const Duration(seconds: 5));
        await tearDownTree(tester, rig);
      });

      e4Widgets('H5 E4-05b (fixed) [$how; $where]: student B sees NONE of '
          "student A's subject tree (A's units) while B's own "
          'GET .../tree is still in flight', (tester) async {
        final endAt = onScreen ? '/learn/subject/sub-bio' : '/learn';
        final rig = await studentAWorks(tester, endAt: endAt);
        await endA(tester, rig, forced: forced, endAt: endAt);

        rig.server.signInStudentId = _someoneElse;
        await uiSignIn(tester, rig, code: '111111');

        final gate = Completer<void>();
        rig.server.scripted['GET /catalog/subjects/sub-bio/tree'] = (o) async {
          await gate.future;
          return null;
        };
        final before = rig.server.calls.length;
        rig.container.read(routerProvider).go('/learn/subject/sub-bio');
        await pumpFrames(tester, frames: 12);
        expect(
          rig.server.calls.skip(before).map((c) => c.key),
          contains('GET /catalog/subjects/sub-bio/tree'),
        );

        expect(
          shown(tester, ['الوحدة الأولى', 'الوحدة الثانية']),
          isEmpty,
          reason: "A's tree is visible to B while B's own answer is in flight",
        );

        // B is a university student: the server's real answer for this id.
        gate.complete();
        await pumpFrames(tester, frames: 20);
        expect(shown(tester, ['الوحدة الأولى']), isEmpty);
        expect(
          find.text("This subject isn't part of your course."),
          findsOneWidget,
        );
        await tester.pump(const Duration(seconds: 5));
        await tearDownTree(tester, rig);
      });
    }
  }

  for (final forced in [false, true]) {
    final how = forced
        ? 'the server ends the session while A is on Account'
        : 'A signs out from Account';

    e4Widgets('H6 E4-05c (fixed) [$how]: student B opening Learn sees NONE of '
        "student A's subject list or A's progress (answered / total "
        "questions) while B's own GET /catalog/subjects is still in flight", (
      tester,
    ) async {
      final rig = await studentAWorks(tester);
      final router = rig.container.read(routerProvider);
      // A leaves Learn for the Account tab (the Learn branch stays alive in
      // the tab shell, its listener paused), then the session ends.
      router.go('/account');
      await pumpFrames(tester, frames: 15);
      if (forced) {
        rig.server.expireAccess();
        rig.server.refreshDead = true;
        rig.container.invalidate(meProvider);
        await pumpFrames(tester, frames: 40);
        await tester.pump(const Duration(seconds: 10));
        expect(rig.auth, isA<AuthUnauthenticated>());
        rig.server.refreshDead = false;
      } else {
        unawaited(rig.container.read(authControllerProvider.notifier).logout());
        await pumpFrames(tester, frames: 40);
        expect(rig.auth, isA<AuthUnauthenticated>());
      }
      expect(rig.location, '/login');

      rig.server.signInStudentId = _someoneElse;
      await uiSignIn(tester, rig, code: '111111'); // B: another student

      final gate = Completer<void>();
      rig.server.scripted['GET /catalog/subjects'] = (o) async {
        await gate.future;
        return null;
      };
      final before = rig.server.calls.length;
      router.go('/learn');
      await pumpFrames(tester, frames: 15);
      expect(
        rig.server.calls.skip(before).map((c) => c.key),
        contains('GET /catalog/subjects'),
        reason: "B's request is in flight and has not been answered",
      );

      // Not one of A's rows, and none of A's progress.
      expect(shown(tester, _schoolOnly), isEmpty, reason: "A's rows on B");
      expect(find.text('216 / 480 questions'), findsNothing);
      expect(find.text('480 / 480 questions'), findsNothing);
      expect(shown(tester, _universityOnly), isEmpty);

      gate.complete();
      await pumpFrames(tester, frames: 20);
      expect(shown(tester, _schoolOnly), isEmpty);
      expect(shown(tester, _universityOnly), isNotEmpty);
      await tester.pump(const Duration(seconds: 5));
      await tearDownTree(tester, rig);
    });
  }
}
