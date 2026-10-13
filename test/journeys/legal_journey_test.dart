import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/account_shells/screens/legal_document_screen.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';

import 'journey_harness.dart';

/// Journey 6: the legal documents, signed out and signed in.
///
/// Signed out, they are reachable from Login's consent line (the routes are
/// public); signed in, from the Profile hub. Either way the viewer asks the
/// server for the document in the UI LANGUAGE, shows it, and both ways out
/// (back chip, OS Back) return to the screen it came from. Viewing a document
/// never changes the session.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('legal documents, signed out, in $locale', (tester) async {
      await walkLegalSignedOut(tester, locale: locale);
    });

    journeyTest('legal documents, signed in, in $locale', (tester) async {
      await walkLegalSignedIn(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('legal documents in the dark canvas in $locale', (
      tester,
    ) async {
      await walkLegalSignedOut(tester, locale: locale, theme: ThemeMode.dark);
      await walkLegalSignedIn(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('legal documents at 2.0x text in $locale', (tester) async {
      await walkLegalSignedOut(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownLegalOverflowsAtTwoTimes,
      );
      await walkLegalSignedIn(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownLegalOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownLegalOverflowsAtTwoTimes = <String>{};

/// The mock's document title for [document].
String mockLegalTitle(String document) =>
    'Mock sample ($document) - not legal text';

Finder _title(String document) =>
    find.text(mockLegalTitle(document), findRichText: true);

Future<void> walkLegalSignedOut(
  WidgetTester tester, {
  required String locale,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final other = locale == 'en' ? 'ar' : 'en';
  final from = l10nFor(locale);
  final to = l10nFor(other);
  final j = await bootJourney(
    tester,
    locale: locale,
    theme: theme,
    textScale: textScale,
    size: size,
  );

  // Onboarding -> Login.
  await tapOn(tester, find.text(from.logIn));
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  const path = '/reference/legal-documents';

  // --- User Agreement -> Terms of Use ------------------------------------------
  await tapOn(tester, find.byKey(const Key('login_legal_terms')));
  await pumpUntil(tester, _title('terms'), journey: j);
  expect(j.location, '/legal/terms');
  expect(find.byType(LegalDocumentScreen), findsOneWidget);
  expect(j.requests.count('GET', '$path/terms'), 1);
  expect(j.requests.lastQuery('GET', '$path/terms'), {'language': locale});
  expect(j.auth, isA<AuthUnauthenticated>(), reason: 'a document is public');
  expect(j.storage.hasSession, isFalse);

  // The back chip returns to the form it came from.
  await tapBackChip(tester, key: const Key('legal_back'));
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);

  // --- Privacy Policy, and the OS Back --------------------------------------------
  await tapOn(tester, find.byKey(const Key('login_legal_privacy')));
  await pumpUntil(tester, _title('privacy'), journey: j);
  expect(j.location, '/legal/privacy');
  expect(j.requests.count('GET', '$path/privacy'), 1);
  expect(await systemBack(tester, j), isFalse);
  expect(j.location, '/login');
  expect(j.exits, isEmpty);

  // --- Another language asks for another document -----------------------------------
  await tapOn(tester, find.text(from.switchLanguage));
  expect(find.text(to.loginSubtitle), findsOneWidget);
  await tapOn(tester, find.byKey(const Key('login_legal_terms')));
  await pumpUntil(tester, _title('terms'), journey: j);
  expect(j.requests.count('GET', '$path/terms'), 2);
  expect(j.requests.lastQuery('GET', '$path/terms'), {'language': other});
  await tapBackChip(tester, key: const Key('legal_back'));
  expect(j.location, '/login');

  // Nothing here signed anyone in.
  expect(j.auth, isA<AuthUnauthenticated>());
  expect(j.requests.countPrefix('/auth'), 0);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'legal-signed-out $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}

Future<void> walkLegalSignedIn(
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
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  await tapOn(tester, find.text(l.navAccount).last);
  expect(find.byType(ProfileScreen), findsOneWidget);
  const path = '/reference/legal-documents';

  // --- Privacy & policy: back chip -------------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_privacy')));
  await pumpUntil(tester, _title('privacy'), journey: j);
  expect(j.location, '/legal/privacy');
  expect(j.requests.lastQuery('GET', '$path/privacy'), {'language': locale});
  await tapBackChip(tester, key: const Key('legal_back'));
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);

  // --- Terms & Conditions: OS Back -------------------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_terms')));
  await pumpUntil(tester, _title('terms'), journey: j);
  expect(j.location, '/legal/terms');
  expect(j.requests.lastQuery('GET', '$path/terms'), {'language': locale});
  expect(await systemBack(tester, j), isFalse);
  expect(j.location, '/account');
  expect(j.exits, isEmpty);

  // Still signed in, and the same documents are served from cache this time
  // (the viewer's provider is keyed by document and language).
  expect(j.auth, isA<AuthAuthenticated>());
  expect(j.storage.hasSession, isTrue);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'legal-signed-in $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
