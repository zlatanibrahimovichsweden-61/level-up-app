import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
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
    when(profileRepo.getEntitlements).thenAnswer(
      (_) async => <EntitlementState>[baseEntitlement],
    );
    when(catalogRepo.getSubjects).thenAnswer((_) async => subjects());
  }

  void stubStudentB() {
    when(profileRepo.getMe).thenAnswer((_) async => _studentB());
    when(profileRepo.getEntitlements).thenAnswer(
      (_) async => <EntitlementState>[],
    );
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

    test('the FIRST reason wins — it is the one that ended the session', () async {
      final container = makeContainer();
      await settleAuth(container);

      final controller = container.read(authControllerProvider.notifier);
      await controller.forceLogout(LogoutReason.supersededOtherDevice);
      await controller.forceLogout(LogoutReason.sessionExpired);

      final status =
          container.read(authControllerProvider) as AuthUnauthenticated;
      expect(status.reason, LogoutReason.supersededOtherDevice);
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
