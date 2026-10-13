import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';

import 'journey_harness.dart';

/// Journey 3: Profile -> Edit Profile -> change the name -> Save -> back.
///
/// Also walks the two ways OUT of a dirty form (the discard guard, from the
/// back chip and from the OS Back), the empty-name pre-flight (no request),
/// and checks that the one write carries only the field that changed and that
/// every screen that shows the name shows the server's.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('profile edit in $locale', (tester) async {
      await walkProfileEdit(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('profile edit in the dark canvas in $locale', (tester) async {
      await walkProfileEdit(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('profile edit at 2.0x text in $locale', (tester) async {
      await walkProfileEdit(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownProfileOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownProfileOverflowsAtTwoTimes = <String>{};

/// A name the journey saves. Not a real person.
const newName = 'Journey Student';

Finder _field(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

Future<void> walkProfileEdit(
  WidgetTester tester, {
  required String locale,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await bootJourney(
    tester,
    locale: locale,
    signedIn: true,
    theme: theme,
    textScale: textScale,
    size: size,
  );

  // --- Home shows the server's name ------------------------------------------
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(find.text(mockStudentName), findsWidgets);

  // --- Account tab = the Profile hub (no extra request: /me is shared) -------
  await tapOn(tester, find.text(l.navAccount).last);
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);
  expect(find.text(mockStudentName), findsWidgets);
  expect(j.requests.count('GET', '/me'), 1);

  // --- The pencil opens Edit Profile, pushed over the hub --------------------
  await tapOn(tester, find.byKey(const Key('profile_edit_button')));
  expect(j.location, '/profile/edit');
  expect(find.byType(EditProfileScreen), findsOneWidget);
  expect(
    tester.widget<EditableText>(_field('edit_name_field')).controller.text,
    mockStudentName,
    reason: 'the form is seeded from the profile already in memory',
  );
  expect(j.requests.count('GET', '/me'), 1, reason: 'no fetch of its own');

  // --- A dirty form guards the back chip -------------------------------------
  await tester.enterText(_field('edit_name_field'), newName);
  await settle(tester, const Duration(milliseconds: 200));
  await tapBackChip(tester, key: const Key('edit_profile_back'));
  expect(find.text(l.discardChangesTitle), findsOneWidget);
  // Keep editing: still on the form, the typed name intact.
  await tapOn(tester, find.byKey(const Key('discard_keep_editing')));
  expect(j.location, '/profile/edit');
  expect(find.text(l.discardChangesTitle), findsNothing);
  expect(
    tester.widget<EditableText>(_field('edit_name_field')).controller.text,
    newName,
  );

  // ... and the OS Back (PopScope) asks the same question.
  expect(await systemBack(tester, j), isFalse, reason: 'the app handled it');
  expect(find.text(l.discardChangesTitle), findsOneWidget);
  expect(j.location, '/profile/edit');

  // Discard: back on the hub, nothing sent, the name unchanged.
  await tapOn(tester, find.byKey(const Key('discard_confirm')));
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);
  expect(find.text(mockStudentName), findsWidgets);
  expect(find.text(newName), findsNothing);
  expect(j.requests.count('PATCH', '/me'), 0);

  // --- A clean form leaves without a question --------------------------------
  await tapOn(tester, find.byKey(const Key('profile_edit_button')));
  expect(j.location, '/profile/edit');
  expect(await systemBack(tester, j), isFalse);
  expect(find.text(l.discardChangesTitle), findsNothing);
  expect(j.location, '/account');

  // --- An empty name is refused on the device --------------------------------
  await tapOn(tester, find.byKey(const Key('profile_edit_button')));
  await tester.enterText(_field('edit_name_field'), '   ');
  await tapOn(tester, find.text(l.saveChanges));
  expect(find.text(l.invalidName), findsOneWidget);
  expect(j.location, '/profile/edit');
  expect(j.requests.count('PATCH', '/me'), 0);

  // --- Save the new name -----------------------------------------------------
  await tester.enterText(_field('edit_name_field'), newName);
  await tapOn(tester, find.text(l.saveChanges));
  await pumpUntil(tester, find.byType(ProfileScreen), journey: j);
  expect(j.location, '/account', reason: 'Save returns to where it came from');
  expect(find.byType(EditProfileScreen), findsNothing);
  expect(j.requests.count('PATCH', '/me'), 1);
  expect(
    j.requests.lastBodyKeys('PATCH', '/me'),
    {'name'},
    reason: 'a save sends only what the student changed',
  );

  // The hub re-read /me and shows the server's name; so does Home.
  await settle(tester);
  expect(j.requests.count('GET', '/me'), 2);
  expect(find.text(newName), findsWidgets);
  expect(find.text(mockStudentName), findsNothing);
  await tapOn(tester, find.text(l.navHome).last);
  expect(j.location, '/home');
  expect(find.text(newName), findsWidgets);
  expect(find.text(mockStudentName), findsNothing);
  expect(
    j.requests.count('GET', '/me'),
    2,
    reason: 'one re-read, not one per screen',
  );

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'profile-edit $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
