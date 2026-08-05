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

  group('Day-3 setters — school geography cascade (adr-010)', () {
    /// A seeded container with a fully-filled Egyptian geography branch.
    (ProviderContainer, RegistrationController) seededEgypt() {
      final container = _container();
      final controller = container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setCountry(countryCode: 'EG', requiresGovernorate: true)
        ..setGovernorate('gov-cairo')
        ..setCity('city-nasr')
        ..setSchool('school-42');
      return (container, controller);
    }

    test('setCountry records the adr-010 switch off the country row', () {
      final (container, controller) = seededEgypt();
      controller.setCountry(countryCode: 'AE', requiresGovernorate: false);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.countryCode, 'AE');
      expect(draft.requiresGovernorate, isFalse);
    });

    test('changing country CLEARS the whole geography branch', () {
      final (container, controller) = seededEgypt();
      controller.setCountry(countryCode: 'AE', requiresGovernorate: false);

      // Leaving these behind is what would put a FORBIDDEN field on the wire.
      final draft = container.read(registrationControllerProvider)!;
      expect(draft.governorateId, isNull);
      expect(draft.cityId, isNull);
      expect(draft.cityName, isNull);
      expect(draft.schoolId, isNull);
    });

    test('re-selecting the SAME country preserves the branch', () {
      final (container, controller) = seededEgypt();
      controller.setCountry(countryCode: 'EG', requiresGovernorate: true);

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.governorateId, 'gov-cairo');
      expect(draft.schoolId, 'school-42');
    });

    test('changing governorate clears city + school', () {
      final (container, controller) = seededEgypt();
      controller.setGovernorate('gov-giza');

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.governorateId, 'gov-giza');
      expect(draft.cityId, isNull);
      expect(draft.schoolId, isNull);
    });

    test('changing city clears the school (schools are filtered by city)', () {
      final (container, controller) = seededEgypt();
      controller.setCity('city-maadi');

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.cityId, 'city-maadi');
      expect(draft.schoolId, isNull);
    });

    test('blank free-text cityName normalizes to null (never sent empty)', () {
      // The normalization moved here from the deleted `setSchoolName` — same
      // rule, applied to the field adr-028 §1 actually introduced.
      final container = _container();
      final controller = container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setCountry(countryCode: 'AE', requiresGovernorate: false)
        ..setCityName('   ');
      expect(container.read(registrationControllerProvider)!.cityName, isNull);

      controller.setCityName('  Al Ain ');
      expect(
        container.read(registrationControllerProvider)!.cityName,
        'Al Ain',
      );
    });

    test('the city union is mutually exclusive on the controller', () {
      final (container, controller) = seededEgypt();

      controller.setCityName('Somewhere Uncoded');
      var draft = container.read(registrationControllerProvider)!;
      expect(draft.cityName, 'Somewhere Uncoded');
      expect(draft.cityId, isNull, reason: 'free text clears the coded id');
      expect(draft.schoolId, isNull, reason: 'schools are filtered by city');

      controller.setCity('city-nasr');
      draft = container.read(registrationControllerProvider)!;
      expect(draft.cityId, 'city-nasr');
      expect(draft.cityName, isNull, reason: 'the picker clears the free text');
    });
  });

  group('Day-3 setters — university cascade', () {
    (ProviderContainer, RegistrationController) seededUniversity() {
      final container = _container();
      final controller = container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine')
        ..setStudyYear('year-2');
      return (container, controller);
    }

    test('changing university clears faculty + year', () {
      final (container, controller) = seededUniversity();
      controller.setUniversity('uni-ain-shams');

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.universityId, 'uni-ain-shams');
      expect(draft.facultyId, isNull);
      expect(draft.studyYearId, isNull);
    });

    test('changing faculty clears the year', () {
      final (container, controller) = seededUniversity();
      controller.setFaculty('fac-pharmacy');

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.facultyId, 'fac-pharmacy');
      expect(draft.studyYearId, isNull);
    });

    test('re-selecting the same university preserves the cascade', () {
      final (container, controller) = seededUniversity();
      controller.setUniversity('uni-cairo');

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.facultyId, 'fac-medicine');
      expect(draft.studyYearId, 'year-2');
    });
  });

  group('Day-3 setters — misc', () {
    test('setDateOfBirth stores the calendar date', () {
      final container = _container();
      container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setDateOfBirth(DateTime(2009, 5, 1));

      expect(
        container.read(registrationControllerProvider)!.dateOfBirth,
        DateTime(2009, 5, 1),
      );
    });

    test('stage + educationSystem are stored as their wire values', () {
      final container = _container();
      container.read(registrationControllerProvider.notifier)
        ..start(_args)
        ..setStage('secondary1')
        ..setEducationSystem('ig');

      final draft = container.read(registrationControllerProvider)!;
      expect(draft.stage, 'secondary1');
      expect(draft.educationSystem, 'ig');
    });

    test('every Day-3 setter is a no-op without an active draft', () {
      final container = _container();
      container.read(registrationControllerProvider.notifier)
        ..setDateOfBirth(DateTime(2009, 5, 1))
        ..setCountry(countryCode: 'EG', requiresGovernorate: true)
        ..setGovernorate('gov-cairo')
        ..setCity('city-nasr')
        ..setSchool('school-42')
        ..setCityName('x')
        ..setStage('prep1')
        ..setEducationSystem('ib')
        ..setUniversity('uni-cairo')
        ..setFaculty('fac-medicine')
        ..setStudyYear('year-1');

      expect(container.read(registrationControllerProvider), isNull);
    });
  });
}
