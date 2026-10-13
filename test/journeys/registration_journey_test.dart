import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';

import 'journey_harness.dart';

/// Journey 1b: a NEW student, phone to Home.
///
/// Any code that is not one of the mock's magic ones means "no account for this
/// phone", so the OTP step forks to the registration wizard. The journey walks
/// it as a student does, through the real pickers (the date dialog, the
/// dropdown menus, the school search sheet), once per track:
///
///   OTP -> Sign Up_1 (identity) -> Choose Your Track -> School | University
///   details -> Start learning -> Home.
///
/// It also asserts what must NOT happen on the way: nothing is sent until the
/// last step; an incomplete form is refused on the device with no request; and
/// the one `POST /auth/register` carries the fields of the CHOSEN track only
/// (the other track's are omitted, never sent as null) and none of the
/// registration state outlives the sign-up.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    for (final track in RegTrack.values) {
      journeyTest('register a ${track.name} student in $locale', (
        tester,
      ) async {
        await walkRegistration(tester, locale: locale, track: track);
      });
    }
  }

  for (final locale in journeyLocales) {
    for (final track in RegTrack.values) {
      journeyTest('register a ${track.name} student, dark, in $locale', (
        tester,
      ) async {
        await walkRegistration(
          tester,
          locale: locale,
          track: track,
          theme: ThemeMode.dark,
        );
      });
    }
  }

  for (final locale in journeyLocales) {
    for (final track in RegTrack.values) {
      journeyTest('register a ${track.name} student at 2.0x text in $locale', (
        tester,
      ) async {
        await walkRegistration(
          tester,
          locale: locale,
          track: track,
          textScale: 2.0,
          knownOverflows: knownRegistrationOverflowsAtTwoTimes,
        );
      });
    }
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownRegistrationOverflowsAtTwoTimes = <String>{};

/// The mock forks any 6-digit code that is not one of its magic ones.
const _otpRegistration = '333333';

/// A name and a parent's phone the journey registers. Not real people.
const _studentName = 'Journey Student';
const _parentPhone = '010000000002';

// The mock's reference fixtures (`lib/dev/mock_backend.dart`), per language.
String _governorate(String locale) => locale == 'ar' ? 'القاهرة' : 'Cairo';
String _city(String locale) => locale == 'ar' ? 'مدينة نصر' : 'Nasr City';
String _educationSystem(String locale) =>
    locale == 'ar' ? 'الوطني عربي' : 'National (Arabic)';
String _school(String locale, int i) =>
    locale == 'ar' ? 'مدرسة رقم $i الرسمية' : 'Al Nasr Language School $i';
String _university(String locale) =>
    locale == 'ar' ? 'جامعة القاهرة' : 'Cairo University';
String _faculty(String locale) =>
    locale == 'ar' ? 'كلية الطب البشري' : 'Faculty of Human Medicine';

/// Opens a dropdown field and picks [option] from its menu.
Future<void> _pick(WidgetTester tester, String fieldKey, String option) async {
  await tapOn(tester, find.byKey(Key(fieldKey)));
  // The open menu is the LAST thing in the tree with that text (the field
  // itself may show it once chosen).
  await tapOn(tester, find.text(option).last);
}

/// Picks 15 October 2010 in the date dialog, in the dialog's own language.
Future<void> _pickBirthDate(WidgetTester tester) async {
  await tapOn(tester, find.byKey(const Key('field-dateOfBirth')));
  final material = MaterialLocalizations.of(
    tester.element(find.byType(Scaffold).first),
  );
  // The dialog opens on its year grid.
  final year = find.text(material.formatYear(DateTime(2010)));
  // On the smallest phone at the largest text the grid is a row or two tall and
  // the row of 2010 starts below its fold, so it is not built yet. The student
  // scrolls THE GRID (not the page behind the dialog, which is what `tapOn`
  // would scroll) until the year is there.
  if (year.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      year,
      52,
      scrollable: find.descendant(
        of: find.byType(YearPicker),
        matching: find.byType(Scrollable),
      ),
    );
  }
  await tapOn(tester, year);
  await tapOn(tester, find.text(material.formatDecimal(15)));
  await tapOn(tester, find.text(material.okButtonLabel));
}

bool _enabled(WidgetTester tester, String label) {
  final button = find.widgetWithText(FilledButton, label);
  expect(button, findsWidgets, reason: 'no "$label" button');
  return tester.widget<FilledButton>(button.first).onPressed != null;
}

Future<void> walkRegistration(
  WidgetTester tester, {
  required String locale,
  required RegTrack track,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await bootJourney(
    tester,
    locale: locale,
    theme: theme,
    textScale: textScale,
    size: size,
  );

  // --- Onboarding -> Login -> a number nobody has registered ------------------------
  await tapOn(tester, find.text(l.getStarted));
  expect(j.location, '/login');
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, _otpRegistration);
  await pumpUntil(tester, find.byType(SignupIdentityScreen), journey: j);
  expect(j.location, '/register');
  expect(j.auth, isA<AuthUnauthenticated>(), reason: 'no account yet');
  expect(j.storage.hasSession, isFalse);
  expect(j.requests.count('POST', '/auth/otp/verify'), 1);
  // The wizard was seeded at the OTP step with the proven phone and a token.
  final seeded = j.container.read(registrationControllerProvider);
  expect(seeded, isNotNull);
  expect(seeded!.registrationToken, isNotEmpty);

  // --- Sign Up_1: an empty form is refused on the device ----------------------------------
  await tapOn(tester, find.widgetWithText(FilledButton, l.continueLabel));
  expect(j.location, '/register', reason: 'an empty identity does not pass');
  expect(find.byType(SignupTrackScreen), findsNothing);

  await tester.enterText(find.byType(TextField).at(0), _studentName);
  await tester.enterText(find.byType(TextField).at(1), _parentPhone);
  await tapOn(tester, find.widgetWithText(FilledButton, l.continueLabel));
  expect(j.location, '/register/track');
  expect(find.byType(SignupTrackScreen), findsOneWidget);

  // --- Choose Your Track: Continue waits for a choice ------------------------------------------
  expect(_enabled(tester, l.continueLabel), isFalse);
  final trackLabel = track == RegTrack.school
      ? l.trackSchool
      : l.trackUniversity;
  await tapOn(tester, find.text(trackLabel));
  expect(_enabled(tester, l.continueLabel), isTrue);
  await tapOn(tester, find.widgetWithText(FilledButton, l.continueLabel));

  // --- The track's details form ----------------------------------------------------------------
  if (track == RegTrack.school) {
    await pumpUntil(tester, find.byType(SchoolDetailScreen), journey: j);
    expect(j.location, '/register/school');
  } else {
    await pumpUntil(tester, find.byType(UniversityDetailScreen), journey: j);
    expect(j.location, '/register/university');
  }
  await settle(tester, const Duration(seconds: 1));

  // Nothing has been sent but the code: identity and track are local.
  expect(j.requests.countPrefix('/auth/register'), 0);

  // An untouched form is refused with its field errors, and nothing is sent.
  await tapOn(tester, find.text(l.startLearning));
  expect(j.requests.count('POST', '/auth/register'), 0);
  expect(find.text(l.fieldRequired), findsWidgets);
  expect(find.byType(HomeScreen), findsNothing);

  await _pickBirthDate(tester);
  if (track == RegTrack.school) {
    // Egypt is the default country; the school is chosen by search.
    await _pick(tester, 'field-governorateId', _governorate(locale));
    await _pick(tester, 'field-cityId', _city(locale));
    await _pick(tester, 'field-educationSystem', _educationSystem(locale));
    await _pick(tester, 'field-stage', l.stageSecondary1);
    await tapOn(tester, find.byKey(const Key('field-schoolId')));
    await pumpUntil(tester, find.text(_school(locale, 1)), journey: j);
    await tapOn(tester, find.text(_school(locale, 1)));
    expect(j.requests.count('GET', '/reference/schools'), greaterThan(0));
  } else {
    await _pick(tester, 'field-universityId', _university(locale));
    await _pick(tester, 'field-facultyId', _faculty(locale));
    await _pick(tester, 'field-studyYearId', l.studyYearNumber(1));
    await _pick(tester, 'field-governorateId', _governorate(locale));
    await _pick(tester, 'field-cityId', _city(locale));
  }
  expect(j.requests.count('POST', '/auth/register'), 0, reason: 'not yet');

  // --- Start learning: ONE request, then Home -----------------------------------------------------
  await tapOn(tester, find.text(l.startLearning));
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');
  expect(j.requests.count('POST', '/auth/register'), 1);
  expect(j.auth, isA<AuthAuthenticated>());
  expect(j.storage.hasSession, isTrue);
  expect(j.storage.writeTokensCalls, 1);

  // The body carried the chosen track's fields and the other's NOT AT ALL.
  final sent = j.requests.lastBodyKeys('POST', '/auth/register')!;
  expect(sent, containsAll(<String>['registrationToken', 'name', 'device']));
  const schoolOnly = {'educationSystem', 'stage', 'schoolId'};
  const universityOnly = {'universityId', 'facultyId', 'studyYearId'};
  if (track == RegTrack.school) {
    expect(sent, containsAll(schoolOnly));
    expect(sent.intersection(universityOnly), isEmpty);
  } else {
    expect(sent, containsAll(universityOnly));
    expect(sent.intersection(schoolOnly), isEmpty);
  }

  // The registration state (a token, a phone, a minor's details) is dropped
  // once it has been spent, not kept for the rest of the session.
  await settle(tester);
  // (Compared to null rather than matched with isNull: a failed matcher
  // prints the object, and this one is a minor's registration details.)
  expect(
    j.container.read(registrationControllerProvider) == null,
    isTrue,
    reason: 'the spent draft must not outlive the sign-up',
  );

  // The new student is signed in for real: Home is theirs and the app works.
  expect(j.requests.count('GET', '/me'), greaterThanOrEqualTo(1));
  await tapOn(tester, find.text(l.navLearn).last);
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/learn');
  expect(j.exits, isEmpty);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'register-${track.name} $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
