import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/registration/models/registration_body.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/notifier/registration_submit_notifier.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'registration_harness.dart';

/// CW02 slice C: the two registration submits are NOT return-target landings.
/// `registrationRequired` means no account existed for that phone, so a new
/// registrant is never the student whose session ended; a 201 clears whatever a
/// signed-out bounce remembered and goes to `/home`. (The only landing that
/// returns a student to where they were is the OTP sign-in success Continue.)
///
/// The submit notifier is replaced by a fake that can be flipped to "201, the
/// session is live" on demand — the request itself, and the tokens, are covered
/// by `registration_submit_notifier_test.dart`; this file is only about WHERE
/// the success goes.
class _SubmitsOnDemand extends RegistrationSubmitNotifier {
  void succeed() => state = const AsyncData(RegistrationSubmitted());
}

/// The server id of the student whose session ended (O-10: a return target is
/// bound to one). Any string will do — the target only compares ids.
const _endedSessionStudent = 'student-whose-session-ended';

class _MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

class _FakeBody extends Fake implements RegistrationBody {}

/// `deviceInfoProvider` is overridden rather than left to fall through to
/// DeviceInfoPlugin, which throws MissingPluginException under `flutter test`.
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');

void main() {
  late MockReferenceRepository reference;

  setUp(() {
    reference = MockReferenceRepository();
    stubReferenceHappyPath(reference);
  });

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required String path,
    required Widget screen,
    required RegTrack track,
    String? remembered,
  }) async {
    final container = ProviderContainer(
      overrides: [
        referenceRepositoryProvider.overrideWithValue(reference),
        registrationSubmitProvider.overrideWith(_SubmitsOnDemand.new),
      ],
    );
    addTearDown(container.dispose);

    container.read(registrationControllerProvider.notifier)
      ..start(regArgs)
      ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
      ..setTrack(track);
    if (remembered != null) {
      // Bound to a student whose session ended, so the "cleared" assertion
      // below is observable: an unbound target is never returned to anybody.
      container.read(returnTargetProvider)
        ..sessionEnding(_endedSessionStudent)
        ..remember(remembered);
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: path,
            routes: [
              GoRoute(path: path, builder: (_, _) => screen),
              GoRoute(path: '/login', builder: (_, _) => marker('LOGIN')),
              GoRoute(path: '/home', builder: (_, _) => marker('HOME')),
              GoRoute(path: '/message', builder: (_, _) => marker('MESSAGE')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> succeed(WidgetTester tester, ProviderContainer container) async {
    (container.read(registrationSubmitProvider.notifier) as _SubmitsOnDemand)
        .succeed();
    await tester.pumpAndSettle();
  }

  final landings = {
    'School': (
      path: '/register/school',
      screen: const SchoolDetailScreen(),
      track: RegTrack.school,
    ),
    'University': (
      path: '/register/university',
      screen: const UniversityDetailScreen(),
      track: RegTrack.university,
    ),
  };

  for (final MapEntry(key: name, value: landing) in landings.entries) {
    group('$name registration landing', () {
      testWidgets('goes Home even with a target remembered, and clears it', (
        tester,
      ) async {
        final container = await pump(
          tester,
          path: landing.path,
          screen: landing.screen,
          track: landing.track,
          remembered: '/message',
        );

        await succeed(tester, container);

        expect(find.text('HOME'), findsOneWidget);
        expect(find.text('MESSAGE'), findsNothing);
        // Cleared: nothing is left for a later sign-in landing either — not even
        // for the student the target was bound to.
        expect(
          container
              .read(returnTargetProvider)
              .consume(studentId: _endedSessionStudent, fallback: 'none'),
          'none',
        );
      });

      testWidgets('goes Home when nothing is remembered', (tester) async {
        final container = await pump(
          tester,
          path: landing.path,
          screen: landing.screen,
          track: landing.track,
        );

        await succeed(tester, container);

        expect(find.text('HOME'), findsOneWidget);
      });
    });
  }

  // O10-1. The screens above `clear()` the target on success, but a registration
  // whose screen has already gone (the student left the wizard while the POST
  // was in flight) never reaches that code, and the session it starts is live
  // all the same. `markAuthenticated` is the one point every completed sign-in
  // passes through, and it reports to `ReturnTarget.sessionStarted`; registration
  // carries no student id, so a target bound to anybody is dropped (fail
  // closed). This drives the REAL submit notifier with no screen mounted at all.
  group('a registration that completes while its screen is gone', () {
    late _MockRegistrationRepository repo;
    late _MockSecureStorage storage;

    setUpAll(() => registerFallbackValue(_FakeBody()));

    setUp(() {
      repo = _MockRegistrationRepository();
      storage = _MockSecureStorage();
      when(() => storage.readAccessToken()).thenAnswer((_) async => null);
      when(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      ).thenAnswer((_) async {});
      when(() => repo.register(any())).thenAnswer(
        (_) async =>
            AuthResult.authenticated(
                  tokens: const TokenPair(
                    accessToken: 'access.jwt',
                    accessExpiresInSeconds: 900,
                    refreshToken: 'refresh.jwt',
                    refreshExpiresInSeconds: 5184000,
                  ),
                  profile: const {'id': 'student-1'},
                )
                as AuthenticatedResult,
      );
    });

    test('still drops a target bound to another student — the screen\'s own '
        'clear() never runs', () async {
      final container = ProviderContainer(
        overrides: [
          registrationRepositoryProvider.overrideWithValue(repo),
          secureStorageProvider.overrideWithValue(storage),
          deviceInfoProvider.overrideWith((ref) async => _device),
        ],
      );
      addTearDown(container.dispose);

      // A complete, valid Egyptian school draft (the same shape the submit
      // notifier's own tests seed).
      container.read(registrationControllerProvider.notifier)
        ..start(regArgs)
        ..setIdentity(name: 'Nour Hassan', parentPhone: '+2010000000001')
        ..setTrack(RegTrack.school)
        ..setDateOfBirth(DateTime(2009, 5, 1))
        ..setCountry(countryCode: 'EG', requiresGovernorate: true)
        ..setGovernorate('gov-cairo')
        ..setCity('city-nasr')
        ..setSchool('school-42')
        ..setStage('secondary1')
        ..setEducationSystem('ig');

      // Let the controller finish its cold-start token read first, so the
      // sign-in below is the only thing that can move it to authenticated.
      container.read(authControllerProvider);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(authControllerProvider),
        isA<AuthUnauthenticated>(),
      );

      // A student's session ended, and its location was remembered.
      container.read(returnTargetProvider)
        ..sessionEnding(_endedSessionStudent)
        ..remember('/learn');

      await container.read(registrationSubmitProvider.notifier).submit();

      // The registration really did start a session…
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
      expect(
        container.read(registrationSubmitProvider).value,
        isA<RegistrationSubmitted>(),
      );
      // …and no screen was there to clear the target, yet it is gone: not even
      // the student it was bound to gets it.
      expect(
        container
            .read(returnTargetProvider)
            .consume(studentId: _endedSessionStudent, fallback: 'none'),
        'none',
      );
    });
  });
}
