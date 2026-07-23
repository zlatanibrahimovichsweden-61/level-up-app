import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';

const _args = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600, // 10-minute window
  phone: '+201021871999',
);

ProviderContainer _container() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('RegistrationController — seeding', () {
    test('build() starts null (no registration in progress)', () {
      final container = _container();
      expect(container.read(registrationControllerProvider), isNull);
    });

    test('start seeds token, phone, and a future deadline', () {
      final container = _container();
      final before = DateTime.now();
      container.read(registrationControllerProvider.notifier).start(_args);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.registrationToken, 'reg.token');
      expect(draft.phone, '+201021871999');
      expect(draft.isExpired, isFalse);
      // Deadline is ~now + expiresInSeconds (allow slack for test execution).
      expect(
        draft.tokenExpiresAt.isAfter(before.add(const Duration(seconds: 590))),
        isTrue,
      );
      // Day-3 fields default to null.
      expect(draft.name, isNull);
      expect(draft.track, isNull);
      expect(draft.dateOfBirth, isNull);
    });
  });

  group('RegistrationController — accumulation', () {
    test('setIdentity then setTrack accumulate onto the same draft', () {
      final container = _container();
      final notifier = container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setIdentity(
          name: 'Mostafa',
          parentPhone: '+201000000000',
          referralCode: 'FRIEND10',
        )
        ..setTrack(RegTrack.university);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.name, 'Mostafa');
      expect(draft.parentPhone, '+201000000000');
      expect(draft.referralCode, 'FRIEND10'); // collected (not submitted here)
      expect(draft.track, RegTrack.university);
      // Token + phone survive the accumulation.
      expect(draft.registrationToken, 'reg.token');
      expect(draft.phone, '+201021871999');
      // Reference the notifier so the cascade isn't flagged as unused.
      expect(notifier, isNotNull);
    });

    test('setIdentity/setTrack are no-ops without an active draft', () {
      final container = _container();
      container
          .read(registrationControllerProvider.notifier)
          .setTrack(RegTrack.school);
      expect(container.read(registrationControllerProvider), isNull);
    });
  });

  group('RegistrationController — idempotent re-entry', () {
    test('re-start with the SAME token preserves accumulated fields', () {
      final container = _container();
      final notifier = container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setIdentity(name: 'Mostafa', parentPhone: '+201000000000');

      // Back-navigation re-enters the identity screen → start() again.
      notifier.start(_args);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.name, 'Mostafa'); // NOT reset
    });

    test('start with a DIFFERENT token resets to a clean draft', () {
      final container = _container();
      final notifier = container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setIdentity(name: 'Mostafa', parentPhone: '+201000000000');

      notifier.start(
        const RegistrationArgs(
          registrationToken: 'other.token',
          expiresInSeconds: 600,
          phone: '+201111111111',
        ),
      );

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.registrationToken, 'other.token');
      expect(draft.name, isNull); // fresh
    });

    test('reset clears the draft', () {
      final container = _container();
      container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..reset();
      expect(container.read(registrationControllerProvider), isNull);
    });
  });

  group('RegistrationDraft — expiry guard', () {
    test('a past deadline is expired', () {
      final draft = RegistrationDraft(
        registrationToken: 't',
        tokenExpiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        phone: '+201021871999',
      );
      expect(draft.isExpired, isTrue);
    });

    test('a future deadline is not expired', () {
      final draft = RegistrationDraft(
        registrationToken: 't',
        tokenExpiresAt: DateTime.now().add(const Duration(minutes: 5)),
        phone: '+201021871999',
      );
      expect(draft.isExpired, isFalse);
    });

    test('start with an already-elapsed TTL yields an expired draft', () {
      final container = _container();
      container.read(registrationControllerProvider.notifier).start(
            const RegistrationArgs(
              registrationToken: 'reg.token',
              expiresInSeconds: -1, // already past
              phone: '+201021871999',
            ),
          );
      expect(container.read(registrationControllerProvider)!.isExpired, isTrue);
    });
  });
}
