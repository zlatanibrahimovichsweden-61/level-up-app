import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_notifications.dart' as mock;
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/notifications/screens/notifications_screen.dart';

import 'journey_harness.dart';

/// Journey 5: Home bell -> notifications inbox -> back.
///
/// The bell opens the inbox over the shell; the inbox lists the server's
/// announcements in the UI language; a tap on an unread row marks it read ON
/// THE SERVER (and only then does its dot go); a filter chip asks the server
/// for that category; the back chip and the OS Back both return to Home.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('notifications inbox in $locale', (tester) async {
      await walkNotifications(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('notifications inbox in the dark canvas in $locale', (
      tester,
    ) async {
      await walkNotifications(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('notifications inbox at 2.0x text in $locale', (tester) async {
      await walkNotifications(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownNotificationOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownNotificationOverflowsAtTwoTimes = <String>{};

/// Fixture 1's title, per UI language (`lib/dev/mock_notifications.dart`).
const _firstTitle = {
  'en': 'New Biology Quiz Available!',
  'ar': 'اختبار جديد في الأحياء!',
};

Future<void> walkNotifications(
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
  expect(
    j.requests.countPrefix('/me/notifications'),
    0,
    reason: 'Home does not fetch the inbox',
  );

  // --- The bell opens the inbox, pushed over Home --------------------------
  await tapOn(tester, find.byKey(const Key('home_bell')));
  await pumpUntil(tester, find.byType(NotificationsScreen), journey: j);
  expect(j.location, '/notifications');
  expect(j.requests.count('GET', '/me/notifications'), 1);
  expect(
    j.requests.lastQuery('GET', '/me/notifications')?['category'],
    isNull,
    reason: 'the All tab asks for no category',
  );
  await pumpUntil(tester, find.text(_firstTitle[locale]!), journey: j);

  // --- Tapping an unread row marks it read on the server -------------------
  final firstRow = find.byKey(ValueKey(mock.mockNotificationId(1)));
  expect(firstRow, findsOneWidget);
  final unreadBefore = find
      .byKey(const Key('notification_unread_dot'))
      .evaluate()
      .length;
  expect(unreadBefore, greaterThan(0));
  expect(j.requests.countPrefix('/me/notifications/'), 0);

  await tapOn(tester, firstRow);
  expect(
    j.requests.count(
      'POST',
      '/me/notifications/${mock.mockNotificationId(1)}/read',
    ),
    1,
  );
  expect(
    find.byKey(const Key('notification_unread_dot')).evaluate().length,
    unreadBefore - 1,
    reason: 'one row stopped being unread',
  );
  // Reading an already-read row sends nothing more.
  await tapOn(tester, firstRow);
  expect(j.requests.countPrefix('/me/notifications/'), 1);

  // --- A filter chip asks the server for that category ---------------------
  await tapOn(tester, find.byKey(const Key('notification_chip_announcements')));
  await settle(tester);
  expect(j.requests.count('GET', '/me/notifications'), 2);
  expect(
    j.requests.lastQuery('GET', '/me/notifications')?['category'],
    'announcements',
  );
  await tapOn(tester, find.byKey(const Key('notification_chip_all')));
  await settle(tester);
  expect(j.location, '/notifications');

  // --- Back chip -> Home ----------------------------------------------------
  await tapBackChip(tester, key: const Key('notifications_back'));
  expect(j.location, '/home');
  expect(find.byType(HomeScreen), findsOneWidget);
  expect(find.byType(NotificationsScreen), findsNothing);

  // --- And the OS Back does the same ------------------------------------------
  await tapOn(tester, find.byKey(const Key('home_bell')));
  expect(j.location, '/notifications');
  expect(await systemBack(tester, j), isFalse);
  expect(j.location, '/home');
  expect(find.text(l.navHome), findsWidgets);
  expect(j.exits, isEmpty);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'notifications $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
