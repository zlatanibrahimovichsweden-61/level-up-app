import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/notifier/subjects_notifier.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:level_up_app/features/profile/models/entitlement_state.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../features/catalog/catalog_fixtures.dart';
import '../../features/profile/profile_fixtures.dart';

/// Tier-0 finding C-2 — session data leakage across sign-outs.
///
/// `logout()` and `forceLogout()` used to clear the tokens and flip the auth
/// state, and nothing else. `meProvider`, `entitlementsProvider`,
/// `subjectsProvider` and the registration draft are all non-`autoDispose`, so
/// their values survived the sign-out **in memory** and were served to whoever
/// signed in next. On the shared handsets this app is used on, that is one
/// minor's name, date of birth, school, governorate, points and entitlements
/// handed to another student.
///
/// These tests fail against the pre-fix `AuthController`: without
/// `invalidateSessionScope`, the reads after logout return Student A's cached
/// values because a non-autoDispose provider keeps its state for the lifetime of
/// the container.
///
/// They deliberately drive the REAL `AuthController` against mocked
/// repositories rather than calling `invalidateSessionScope` directly — the bug
/// was never in the invalidation, it was that logout did not call it.
class _MockStorage extends Mock implements SecureStorage {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockCatalogRepository extends Mock implements CatalogRepository {}

/// Student B: the same contract shape, different human.
Map<String, dynamic> _studentBProfileJson() => <String, dynamic>{
  ...schoolProfileJson(),
  'id': '0197b2f3-9999-7cc3-9b4e-0000000000b2',
  'name': 'Sara Ibrahim',
  'phone': '+201119876543',
  'dateOfBirth': '2009-11-02',
  'level': 2,
  'points': <String, dynamic>{'school': 15, 'university': 0, 'total': 15},
};

StudentProfile _studentB() => StudentProfile.fromJson(_studentBProfileJson());

void main() {
  // EntitlementsNotifier installs an AppLifecycleListener in build().
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockStorage storage;
  late _MockAuthRepository authRepo;
  late _MockProfileRepository profileRepo;
  late _MockCatalogRepository catalogRepo;

  setUp(() {
    storage = _MockStorage();
    authRepo = _MockAuthRepository();
    profileRepo = _MockProfileRepository();
    catalogRepo = _MockCatalogRepository();

    // A live session: the controller resolves to authenticated on build.
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access-a');
    when(() => storage.clearTokens()).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    when(() => authRepo.logout()).thenAnswer((_) async {});
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        authRepositoryProvider.overrideWithValue(authRepo),
        profileRepositoryProvider.overrideWithValue(profileRepo),
        catalogRepositoryProvider.overrideWithValue(catalogRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// The controller starts `AuthUnknown` and resolves on a microtask. Forced
  /// logout is idempotent and no-ops when already unauthenticated, so a test
  /// that force-logs-out before this settles would be testing nothing.
  Future<void> settleAuth(ProviderContainer container) async {
    container.read(authControllerProvider);
    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(authControllerProvider),
      isA<AuthAuthenticated>(),
      reason: 'the session must be live before the sign-out under test',
    );
  }

  void stubStudentA() {
    when(profileRepo.getMe).thenAnswer((_) async => schoolProfile());
    when(
      profileRepo.getEntitlements,
    ).thenAnswer((_) async => <EntitlementState>[baseEntitlement]);
    when(catalogRepo.getSubjects).thenAnswer((_) async => subjects());
  }

  void stubStudentB() {
    when(profileRepo.getMe).thenAnswer((_) async => _studentB());
    when(
      profileRepo.getEntitlements,
    ).thenAnswer((_) async => <EntitlementState>[]);
    when(catalogRepo.getSubjects).thenAnswer((_) async => <Subject>[]);
  }

  group('Scenario A — normal sign-out on a shared device', () {
    test('Student B does not receive Student A profile', () async {
      final container = makeContainer();
      await settleAuth(container);

      stubStudentA();
      final a = await container.read(meProvider.future);
      expect(a.name, 'Ahmed Mohamed');
      expect(a.level, 8);

      await container.read(authControllerProvider.notifier).logout();

      // Student B signs in on the same handset.
      stubStudentB();
      final b = await container.read(meProvider.future);

      expect(
        b.name,
        'Sara Ibrahim',
        reason: 'Student A profile survived the sign-out — this is C-2',
      );
      expect(b.level, 2);
      expect(b.phone, isNot(a.phone));
      expect(b.dateOfBirth, isNot(a.dateOfBirth));
    });

    test('Student B does not inherit Student A entitlements', () async {
      final container = makeContainer();
      await settleAuth(container);

      stubStudentA();
      expect(await container.read(entitlementsProvider.future), isNotEmpty);

      await container.read(authControllerProvider.notifier).logout();

      stubStudentB();
      expect(
        await container.read(entitlementsProvider.future),
        isEmpty,
        reason: 'a paid entitlement leaked to an unpaid student',
      );
    });

    test('Student B does not inherit Student A subject catalogue', () async {
      final container = makeContainer();
      await settleAuth(container);

      stubStudentA();
      expect(await container.read(subjectsProvider.future), isNotEmpty);

      await container.read(authControllerProvider.notifier).logout();

      stubStudentB();
      expect(await container.read(subjectsProvider.future), isEmpty);
    });

    test('the profile is re-fetched, not served from cache', () async {
      final container = makeContainer();
      await settleAuth(container);

      stubStudentA();
      await container.read(meProvider.future);
      verify(profileRepo.getMe).called(1);

      await container.read(authControllerProvider.notifier).logout();

      stubStudentB();
      await container.read(meProvider.future);
      verify(profileRepo.getMe).called(1); // a SECOND call, not a cache hit
    });
  });

  group('Scenario B — forced logout during registration', () {
    const args = RegistrationArgs(
      registrationToken: 'reg-token-a',
      expiresInSeconds: 600,
      phone: '+201001234567',
    );

    test('a minor draft PII does not survive a forced logout', () async {
      final container = makeContainer();
      await settleAuth(container);

      container.read(registrationControllerProvider.notifier).start(args);
      expect(container.read(registrationControllerProvider), isNotNull);
      expect(
        container.read(registrationControllerProvider)!.phone,
        '+201001234567',
      );

      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);

      expect(
        container.read(registrationControllerProvider),
        isNull,
        reason: 'a half-filled minor registration draft outlived the session',
      );
    });

    test('a user-initiated sign-out also clears the draft', () async {
      final container = makeContainer();
      await settleAuth(container);

      container.read(registrationControllerProvider.notifier).start(args);
      expect(container.read(registrationControllerProvider), isNotNull);

      await container.read(authControllerProvider.notifier).logout();

      expect(container.read(registrationControllerProvider), isNull);
    });
  });

  group('forced logout is idempotent', () {
    // Load-bearing, not tidiness. Invalidating a session provider that still
    // has a listener rebuilds it; a rebuild with no token earns a 401; and
    // AuthInterceptor answers a 401 with no refresh token by calling
    // forceLogout again. Without the guard that is an unbounded loop.
    test('a repeat forced logout does not re-run the teardown', () async {
      final container = makeContainer();
      await settleAuth(container);

      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.supersededOtherDevice);

      verify(() => storage.clearTokens()).called(1);
    });

    test(
      'the FIRST reason wins — it is the one that ended the session',
      () async {
        final container = makeContainer();
        await settleAuth(container);

        final controller = container.read(authControllerProvider.notifier);
        await controller.forceLogout(LogoutReason.supersededOtherDevice);
        await controller.forceLogout(LogoutReason.sessionExpired);

        final status =
            container.read(authControllerProvider) as AuthUnauthenticated;
        expect(status.reason, LogoutReason.supersededOtherDevice);
      },
    );
  });

  // CW02 slice C. The router remembers where a signed-out student was heading
  // so the next sign-in can return there. It is NOT session-scoped — a forced
  // sign-out must leave it, and this group is what pins that (the discipline
  // scan does not see plain Providers) — while a student's own sign-out must
  // clear it. It holds a route string and the ending student's server id — no
  // other profile data can ride along.
  //
  // O-10: a forced sign-out binds it to the student whose session ends, and
  // only that student gets it back. The id comes from two places, in this
  // order: the one captured at sign-in (`markAuthenticated(studentId:)`) is
  // the first source; `/me` (a settled, successful read only) is the fallback
  // for a session restored at a cold start or begun by registration. This
  // group's `holdStudentA` exercises that fallback; the nested group on the id
  // captured at sign-in exercises the first source.
  // The router remembers the location AFTER the flip, which is why these tests
  // call `remember` after `forceLogout`, as the redirect does.
  group('the return target (deliberately not session-scoped)', () {
    /// Student A is signed in with `/me` loaded and kept alive, as Home keeps it.
    Future<StudentProfile> holdStudentA(ProviderContainer container) async {
      stubStudentA();
      container.listen(meProvider, (_, _) {});
      return container.read(meProvider.future);
    }

    test('a forced sign-out leaves the same holder, and the student who was '
        'signed out gets the location back', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      final target = container.read(returnTargetProvider);

      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      // The router's redirect, after the flip.
      target.remember('/learn/subject/42?tab=2');

      // Same holder (not invalidated and rebuilt), same value.
      expect(container.read(returnTargetProvider), same(target));
      expect(
        target.consume(studentId: studentA.id, fallback: 'none'),
        '/learn/subject/42?tab=2',
      );
    });

    test('...but a different student does not, and it is dropped', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      final target = container.read(returnTargetProvider);
      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      target.remember('/learn/subject/42?tab=2');

      expect(
        target.consume(studentId: _studentB().id, fallback: 'none'),
        'none',
      );
      expect(
        target.consume(studentId: studentA.id, fallback: 'none'),
        'none',
        reason: 'dropped by the first landing, not kept for the right student',
      );
    });

    test('a forced sign-out forgets a location left over from an earlier '
        'session', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      final target = container.read(returnTargetProvider);
      target.remember('/leaderboard'); // from an earlier session end

      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);

      expect(target.consume(studentId: studentA.id, fallback: 'none'), 'none');
    });

    test('a forced sign-out before `/me` ever loaded binds the target to '
        'nobody, and never starts a `/me` fetch to find out who', () async {
      final container = makeContainer();
      await settleAuth(container);
      stubStudentA(); // a fetch WOULD succeed, so only the guard can stop it

      final target = container.read(returnTargetProvider);
      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      target.remember('/learn');

      verifyNever(profileRepo.getMe);
      expect(
        target.consume(studentId: schoolProfile().id, fallback: 'none'),
        'none',
        reason: 'no known owner: not even student A gets it',
      );
    });

    // Riverpod 3 keeps the PREVIOUS value through a rebuild, so a `/me` that is
    // refreshing or has failed still has student A's profile in `.value`. Only a
    // settled, successful `/me` binds the target: if `meProvider` ever outlived
    // a sign-out, a later student forced out before their own `/me` settled
    // would otherwise bind their location to A's stale id and hand it to A.
    test('a forced sign-out while `/me` is REFRESHING binds the target to '
        'nobody, though student A is still its value', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      // A refresh from data: the new `/me` request is in flight.
      final refreshing = Completer<StudentProfile>();
      when(profileRepo.getMe).thenAnswer((_) => refreshing.future);
      container.refresh(meProvider);
      final me = container.read(meProvider);
      expect(me.isLoading, isTrue);
      expect(me.value?.id, studentA.id, reason: 'the previous value is kept');

      final target = container.read(returnTargetProvider);
      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      target.remember('/learn/subject/42?tab=2');

      expect(
        target.consume(studentId: studentA.id, fallback: 'none'),
        'none',
        reason: 'an unsettled `/me` must not bind, not even to the stale id',
      );

      // Settle the request so nothing is left pending at teardown.
      refreshing.complete(schoolProfile());
      await Future<void>.delayed(Duration.zero);
    });

    test('a forced sign-out after a FAILED `/me` refresh binds the target to '
        'nobody, though student A is still its value', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      // A refresh from data that fails: error state, previous value kept.
      when(profileRepo.getMe).thenAnswer((_) async => throw Exception('down'));
      container.refresh(meProvider);
      try {
        await container.read(meProvider.future);
      } on Exception catch (_) {
        // The failure is the point of this test.
      }
      final me = container.read(meProvider);
      expect(me.hasValue && me.hasError, isTrue);
      expect(me.isLoading, isFalse);
      expect(me.value?.id, studentA.id, reason: 'the previous value is kept');

      final target = container.read(returnTargetProvider);
      await container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      target.remember('/learn/subject/42?tab=2');

      expect(
        target.consume(studentId: studentA.id, fallback: 'none'),
        'none',
        reason: 'a failed `/me` must not bind, not even to the stale id',
      );

      // Let the rebuild `invalidateSessionScope` triggered finish.
      await Future<void>.delayed(Duration.zero);
    });

    // `forceLogout` is idempotent: the guard is what keeps a REPEAT call (a
    // burst of 401s) from running `sessionEnding` again. A second call that did
    // would find the post-invalidate `/me` still loading, bind nobody, and wipe
    // the location the router remembered for the first sign-out.
    test('a REPEAT forced sign-out neither re-binds nor forgets what the first '
        'one bound', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      // The rebuild `invalidateSessionScope` triggers stays loading.
      final pending = Completer<StudentProfile>();
      when(profileRepo.getMe).thenAnswer((_) => pending.future);

      final controller = container.read(authControllerProvider.notifier);
      final target = container.read(returnTargetProvider);
      await controller.forceLogout(LogoutReason.sessionExpired);
      target.remember('/learn'); // the router's bounce for the first one
      await controller.forceLogout(LogoutReason.supersededOtherDevice);

      expect(
        target.consume(studentId: studentA.id, fallback: 'none'),
        '/learn',
      );

      // Settle the request so nothing is left pending at teardown.
      pending.complete(schoolProfile());
      await Future<void>.delayed(Duration.zero);
    });

    // Two forced sign-outs in flight at once (two 401s): the guard in
    // `forceLogout` runs BEFORE the `await` on `clearTokens`, so it only stops
    // calls that arrive after the state flipped. Both of these pass it.
    test('two OVERLAPPING forced sign-outs both run through: the state ends '
        'signed out, and the binding survives', () async {
      final container = makeContainer();
      await settleAuth(container);

      final controller = container.read(authControllerProvider.notifier);
      controller.markAuthenticated(studentId: schoolProfile().id);

      // Hold `clearTokens` so the second call arrives while the first is still
      // awaiting it (the state is still authenticated).
      final clearing = Completer<void>();
      when(() => storage.clearTokens()).thenAnswer((_) => clearing.future);

      final target = container.read(returnTargetProvider);
      final first = controller.forceLogout(LogoutReason.sessionExpired);
      final second = controller.forceLogout(LogoutReason.supersededOtherDevice);
      expect(
        container.read(authControllerProvider),
        isA<AuthAuthenticated>(),
        reason: 'both calls are parked on clearTokens: nothing has flipped yet',
      );

      clearing.complete();
      await Future.wait([first, second]);

      final status = container.read(authControllerProvider);
      expect(status, isA<AuthUnauthenticated>());
      // Pinned AS BUILT: both calls passed the guard and each flipped, so the
      // reason the state ends with is the LAST call's, not the first's. This
      // documents current behaviour; it is not a statement of intent.
      expect(
        (status as AuthUnauthenticated).reason,
        LogoutReason.supersededOtherDevice,
      );
      verify(() => storage.clearTokens()).called(2);

      // The binding survived: after the router's remember (post-flip), the
      // student who was signed in gets the location back.
      target.remember('/learn');
      expect(
        target.consume(studentId: schoolProfile().id, fallback: 'none'),
        '/learn',
      );
    });

    // The id the sign-in response carried is captured by `markAuthenticated`
    // and is what `forceLogout` binds the target to: it needs no `/me` at all,
    // which matters after a return-to-target landing straight into a non-Home
    // branch (Home never mounts there, so `meProvider` never exists).
    group('the id captured at sign-in', () {
      test('binds the target with `/me` never created — and does not read it '
          'either', () async {
        final container = makeContainer();
        await settleAuth(container);
        stubStudentA(); // a `/me` fetch WOULD succeed: only the capture binds

        final controller = container.read(authControllerProvider.notifier);
        controller.markAuthenticated(studentId: schoolProfile().id);
        final target = container.read(returnTargetProvider);
        await controller.forceLogout(LogoutReason.sessionExpired);
        target.remember('/learn');

        verifyNever(profileRepo.getMe);
        expect(
          target.consume(studentId: schoolProfile().id, fallback: 'none'),
          '/learn',
        );
      });

      test('...and a different student does not get it', () async {
        final container = makeContainer();
        await settleAuth(container);

        final controller = container.read(authControllerProvider.notifier);
        controller.markAuthenticated(studentId: schoolProfile().id);
        final target = container.read(returnTargetProvider);
        await controller.forceLogout(LogoutReason.sessionExpired);
        target.remember('/learn');

        expect(
          target.consume(studentId: _studentB().id, fallback: 'none'),
          'none',
        );
      });

      test('does not leak into the next session: a sign-in that carries no id '
          'resets it', () async {
        final container = makeContainer();
        await settleAuth(container);

        final controller = container.read(authControllerProvider.notifier);
        controller.markAuthenticated(studentId: schoolProfile().id);
        await controller.forceLogout(LogoutReason.sessionExpired);

        // The next sign-in carried no id (e.g. registration), and `/me` never
        // existed: nobody to bind.
        controller.markAuthenticated();
        final target = container.read(returnTargetProvider);
        await controller.forceLogout(LogoutReason.sessionExpired);
        target.remember('/learn');

        expect(
          target.consume(studentId: schoolProfile().id, fallback: 'none'),
          'none',
        );
      });

      test('an id-less sign-in resets it even with no sign-out in between '
          '(it is always assigned)', () async {
        final container = makeContainer();
        await settleAuth(container);

        final controller = container.read(authControllerProvider.notifier);
        controller.markAuthenticated(studentId: schoolProfile().id);
        controller.markAuthenticated();
        final target = container.read(returnTargetProvider);
        await controller.forceLogout(LogoutReason.sessionExpired);
        target.remember('/learn');

        expect(
          target.consume(studentId: schoolProfile().id, fallback: 'none'),
          'none',
        );
      });

      test('is forgotten by a user-initiated sign-out — even if a slow '
          'cold-start token read lands afterwards and revives the '
          'session', () async {
        // `markAuthenticated` always assigns, so every ordinary route back to
        // "authenticated" resets the id by itself. The one that does not is the
        // controller's own initial token read: held up here until after the
        // sign-out, it flips the state to authenticated WITHOUT touching the
        // captured id, so only `logout()` forgetting it keeps it from binding.
        final tokenRead = Completer<String?>();
        when(
          () => storage.readAccessToken(),
        ).thenAnswer((_) => tokenRead.future);
        final container = makeContainer();

        final controller = container.read(authControllerProvider.notifier);
        controller.markAuthenticated(studentId: schoolProfile().id);
        await controller.logout();
        tokenRead.complete('access-a');
        await Future<void>.delayed(Duration.zero);
        expect(
          container.read(authControllerProvider),
          isA<AuthAuthenticated>(),
        );

        final target = container.read(returnTargetProvider);
        await controller.forceLogout(LogoutReason.sessionExpired);
        target.remember('/learn');

        expect(
          target.consume(studentId: schoolProfile().id, fallback: 'none'),
          'none',
        );
      });
    });

    test('a user-initiated sign-out clears it', () async {
      final container = makeContainer();
      await settleAuth(container);

      // Bound to a student, so a clear that missed the location would show.
      container.read(returnTargetProvider)
        ..sessionEnding(schoolProfile().id)
        ..remember('/learn');
      await container.read(authControllerProvider.notifier).logout();

      expect(
        container
            .read(returnTargetProvider)
            .consume(studentId: schoolProfile().id, fallback: 'none'),
        'none',
      );
    });

    test('...even one remembered by a forced sign-out that landed while the '
        'revoke was in flight', () async {
      final container = makeContainer();
      await settleAuth(container);
      final studentA = await holdStudentA(container);

      final revoke = Completer<void>();
      when(authRepo.logout).thenAnswer((_) => revoke.future);

      final controller = container.read(authControllerProvider.notifier);
      final signingOut = controller.logout();

      // A 401 forces the sign-out first; the router bounce remembers where.
      // (Bound to student A, who is also who would sign in next.)
      await controller.forceLogout(LogoutReason.sessionExpired);
      container.read(returnTargetProvider).remember('/learn');

      revoke.complete();
      await signingOut;

      expect(
        container
            .read(returnTargetProvider)
            .consume(studentId: studentA.id, fallback: 'none'),
        'none',
        reason: 'the student signed out on purpose; do not walk them back',
      );
    });
  });

  group('what must NOT be cleared', () {
    test('the device id is preserved — clearTokens, never clear', () async {
      final container = makeContainer();
      await settleAuth(container);

      await container.read(authControllerProvider.notifier).logout();

      verify(() => storage.clearTokens()).called(1);
      verifyNever(() => storage.clear());
    });
  });
}
