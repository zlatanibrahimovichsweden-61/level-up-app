import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/dev/mock_support.dart' as mock;
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/features/settings/screens/settings_screen.dart';
import 'package:level_up_app/features/support/screens/create_support_ticket_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';

import 'journey_harness.dart';

/// Journey 4: Settings and Support.
///
/// Account -> Settings -> switch language -> switch canvas -> flip the two
/// privacy switches -> back -> Customer Support -> create a ticket (empty
/// submit refused on the device first) -> its thread -> reply -> back to the
/// list (the new ticket is on it) -> open an existing ticket -> back -> back.
///
/// Language and canvas are CLIENT preferences: switching them must send no
/// request. The privacy switches are the one server write on Settings, and
/// each must send only its own field.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('settings and support in $locale', (tester) async {
      await walkSettingsAndSupport(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('settings and support starting dark, in $locale', (
      tester,
    ) async {
      await walkSettingsAndSupport(
        tester,
        locale: locale,
        theme: ThemeMode.dark,
      );
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('settings and support at 2.0x text in $locale', (tester) async {
      await walkSettingsAndSupport(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownSettingsOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownSettingsOverflowsAtTwoTimes = <String>{};

const _ticketSubject = 'Journey question';
const _ticketDetails = 'This ticket was written by a journey test.';
const _replyText = 'A reply from the journey test.';

Finder _field(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

Future<void> walkSettingsAndSupport(
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
  final nextTheme = theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

  final j = await bootJourney(
    tester,
    locale: locale,
    signedIn: true,
    theme: theme,
    textScale: textScale,
    size: size,
  );
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);

  // --- Account -> Settings ---------------------------------------------------
  await tapOn(tester, find.text(from.navAccount).last);
  expect(j.location, '/account');
  await tapOn(tester, find.byKey(const Key('profile_row_settings')));
  expect(j.location, '/settings');
  expect(find.byType(SettingsScreen), findsOneWidget);
  expect(find.text(from.profileSettings), findsWidgets);

  // --- Language: a client preference, no request -----------------------------
  final before = j.requests.snapshot();
  await tapOn(tester, find.byKey(Key('settings_language_$other')));
  expect(j.container.read(localeProvider).languageCode, other);
  expect(find.text(to.profileSettings), findsWidgets);
  expect(find.text(from.profileSettings), findsNothing);
  expect(
    directionOf(tester),
    other == 'ar' ? TextDirection.rtl : TextDirection.ltr,
  );
  expect(j.location, '/settings', reason: 'a language change stays put');

  // --- Canvas: a client preference, no request -------------------------------
  await tapOn(tester, find.byKey(Key('settings_mode_${nextTheme.name}')));
  expect(j.container.read(themeModeProvider), nextTheme);
  expect(
    brightnessOf(tester),
    nextTheme == ThemeMode.dark ? Brightness.dark : Brightness.light,
  );
  expect(j.location, '/settings');
  expect(
    j.requests.snapshot(),
    before,
    reason: 'language and canvas are device preferences: nothing is sent',
  );

  // --- The two privacy switches: each writes ONLY its own field -------------
  expect(j.requests.count('PATCH', '/me'), 0);
  await tapOn(tester, find.byKey(const Key('settings_leaderboard_visible')));
  expect(j.requests.count('PATCH', '/me'), 1);
  expect(j.requests.lastBodyKeys('PATCH', '/me'), {'leaderboardVisible'});
  await tapOn(tester, find.byKey(const Key('settings_score_hidden')));
  expect(j.requests.count('PATCH', '/me'), 2);
  expect(j.requests.lastBodyKeys('PATCH', '/me'), {'scoreHidden'});
  // Put them back, so the journey leaves the account as it found it.
  await tapOn(tester, find.byKey(const Key('settings_leaderboard_visible')));
  await tapOn(tester, find.byKey(const Key('settings_score_hidden')));
  expect(j.requests.count('PATCH', '/me'), 4);
  expect(find.byKey(const Key('settings_rank_error')), findsNothing);

  // --- Back to the hub, in the new language ----------------------------------
  await tapBackChip(tester, key: const Key('settings_back'));
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);
  expect(find.text(to.profileTitle), findsWidgets);

  // --- Customer Support: the list ----------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_support')));
  await pumpUntil(tester, find.byType(CustomerSupportScreen), journey: j);
  expect(j.location, '/support');
  expect(find.text(to.supportRecentTickets), findsOneWidget);
  await pumpUntil(
    tester,
    find.byKey(Key('support_ticket_row_${mock.mockSupportTicketId(1)}')),
    journey: j,
  );
  expect(j.requests.count('GET', '/support/tickets'), 1);

  // --- Create a ticket: an empty submit is refused on the device -------------
  await tapOn(tester, find.byKey(const Key('support_create_card')));
  expect(j.location, '/support/new');
  expect(find.byType(CreateSupportTicketScreen), findsOneWidget);
  await tapOn(tester, find.byKey(const Key('support_submit')));
  expect(find.text(to.fieldRequired), findsNWidgets(2));
  expect(j.requests.count('POST', '/support/tickets'), 0);

  await tester.enterText(_field('support_subject_field'), _ticketSubject);
  await tester.enterText(_field('support_details_field'), _ticketDetails);
  await tapOn(tester, find.byKey(const Key('support_submit')));
  final newTicket = mock.mockSupportTicketId(mock.kMockSupportTicketCount + 1);
  await pumpUntil(tester, find.byType(SupportTicketScreen), journey: j);

  // The form is REPLACED by the new ticket's thread.
  expect(j.location, '/support/tickets/$newTicket');
  expect(find.byType(CreateSupportTicketScreen), findsNothing);
  expect(j.requests.count('POST', '/support/tickets'), 1);
  expect(j.requests.lastBodyKeys('POST', '/support/tickets'), {
    'subject',
    'details',
  });
  await pumpUntil(tester, find.text(_ticketDetails), journey: j);

  // --- Reply ------------------------------------------------------------------
  await tester.enterText(_field('support_composer_field'), _replyText);
  await settle(tester, const Duration(milliseconds: 200));
  await tapOn(tester, find.byKey(const Key('support_send')));
  await pumpUntil(tester, find.text(_replyText), journey: j);
  expect(j.requests.count('POST', '/support/tickets/$newTicket/messages'), 1);
  expect(
    j.requests.lastBodyKeys('POST', '/support/tickets/$newTicket/messages'),
    {'body'},
  );
  expect(find.byKey(const Key('support_send_error')), findsNothing);

  // --- Back: the thread -> the list (with the new ticket on it) -----------------
  await tapBackChip(tester, key: const Key('support_thread_back'));
  expect(j.location, '/support', reason: 'not back to the form just sent');
  expect(find.byType(CustomerSupportScreen), findsOneWidget);
  await pumpUntil(
    tester,
    find.byKey(Key('support_ticket_row_$newTicket')),
    journey: j,
  );

  // --- An existing ticket opens its thread; Back returns to the list --------------
  await tapOn(
    tester,
    find.byKey(Key('support_ticket_row_${mock.mockSupportTicketId(1)}')),
  );
  await pumpUntil(tester, find.byType(SupportTicketScreen), journey: j);
  expect(j.location, '/support/tickets/${mock.mockSupportTicketId(1)}');
  expect(await systemBack(tester, j), isFalse);
  expect(j.location, '/support');

  // --- Back: the list -> the hub ----------------------------------------------------
  await tapBackChip(tester, key: const Key('support_back'));
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);
  expect(j.exits, isEmpty);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'settings-support $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
