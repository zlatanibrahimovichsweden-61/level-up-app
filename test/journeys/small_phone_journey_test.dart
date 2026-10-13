import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'back_navigation_journey_test.dart' as back;
import 'banned_journey_test.dart' as banned;
import 'double_tap_journey_test.dart' as doubletap;
import 'journey_harness.dart';
import 'learning_loop_journey_test.dart' as loop;
import 'legal_journey_test.dart' as legal;
import 'notifications_journey_test.dart' as notifications;
import 'offline_journey_test.dart' as offline;
import 'profile_edit_journey_test.dart' as profile;
import 'registration_journey_test.dart' as registration;
import 'settings_support_journey_test.dart' as settings;
import 'sign_out_guard_journey_test.dart' as signout;
import 'signed_out_journey_test.dart' as signedout;
import 'university_journey_test.dart' as university;

/// The same journeys on the screens students actually hold: 360 x 800 (the most
/// common Android size in Egypt), the shorter 360 x 640 and the smallest
/// still-supported 320 x 568, at 1.0x and at the OS's largest text, in both
/// languages - and with the phone turned on its side, which neither platform
/// config forbids.
///
/// Everything the journeys assert about behaviour is re-asserted; what these
/// runs add is layout. A journey that walks the whole app must report NO
/// overflow ([knownSmallPhoneOverflows] is empty and stays so, on the offline
/// walk too: the catalog message scrolls when the room is short), and must still
/// be COMPLETABLE (every control reachable and answering a tap - the offline
/// walk taps Retry at every offline step, landscape 640 x 360 included).
///
/// Every combination walks every journey, the SIGN-IN ones included. Two of
/// them used to be left out because a sign-in could not be completed there (the
/// OTP success view's "Continue" could not be tapped when the view was taller
/// than the screen - landscape, and 568 dp high at 2.0x text - and onboarding's
/// "Log In" was pushed out of reach at 320 x 568 and 2.0x text); both screens
/// scroll now, and the exclusions are gone.
void main() {
  setUpAll(loadJourneyFonts);

  // --- Portrait ---------------------------------------------------------------
  const portrait = <String, Size>{
    '360x800': phone360,
    '360x640': Size(360, 640),
    '320x568': Size(320, 568),
  };
  for (final entry in portrait.entries) {
    for (final locale in journeyLocales) {
      for (final scale in const [1.0, 2.0]) {
        _registerJourneys(
          '${entry.key} ${scale}x $locale',
          locale: locale,
          scale: scale,
          size: entry.value,
        );
      }
    }
  }

  // --- Landscape: a phone on its side ----------------------------------------
  const landscape = <String, Size>{
    '915x412': Size(915, 412),
    '640x360': Size(640, 360),
  };
  for (final entry in landscape.entries) {
    for (final locale in journeyLocales) {
      _registerJourneys(
        'landscape ${entry.key} 1.0x $locale',
        locale: locale,
        scale: 1.0,
        size: entry.value,
      );
    }
  }

  // --- The back matrix on the screens most likely to break it --------------------
  // (a dead chip, a dialog that does not fit, a list that scrolled a row away):
  // the short portrait phone at the largest text, the smallest phone, and a phone
  // on its side.
  const backCombos = <(String, Size, double)>[
    ('360x640 2.0x', Size(360, 640), 2.0),
    ('320x568 1.0x', Size(320, 568), 1.0),
    ('landscape 915x412 1.0x', Size(915, 412), 1.0),
  ];
  for (final (tag, size, scale) in backCombos) {
    for (final locale in journeyLocales) {
      journeyTest('back from the Account hub screens, $tag $locale', (
        tester,
      ) async {
        await back.walkAccountDoors(
          tester,
          locale: locale,
          textScale: scale,
          size: size,
          knownOverflows: knownSmallPhoneOverflows,
        );
      });
      journeyTest('back through the Learn drill-down, $tag $locale', (
        tester,
      ) async {
        await back.walkLearnDrillDown(
          tester,
          locale: locale,
          textScale: scale,
          size: size,
          knownOverflows: knownSmallPhoneOverflows,
        );
      });
      journeyTest('leaving a quiz in progress, $tag $locale', (tester) async {
        await back.walkQuizExit(
          tester,
          locale: locale,
          size: size,
          knownOverflows: knownSmallPhoneOverflows,
        );
      });
      journeyTest('roots, cold links and unknown routes, $tag $locale', (
        tester,
      ) async {
        await back.walkRootsAndDeadEnds(
          tester,
          locale: locale,
          size: size,
          knownOverflows: knownSmallPhoneOverflows,
        );
      });
    }
  }

  // --- Onboarding on the smallest screen at the largest text ---------------------
  // Both buttons of the bottom sheet reach Login on a 320 x 568 phone at 2.0x
  // text: "Log In", the last control, used to be pushed past the screen.
  for (final locale in journeyLocales) {
    final labels = <String, String Function(AppLocalizations)>{
      'Get Started': (l) => l.getStarted,
      'Log In': (l) => l.logIn,
    };
    for (final entry in labels.entries) {
      journeyTest('320x568 2.0x $locale: ${entry.key} reaches Login', (
        tester,
      ) async {
        final j = await bootJourney(
          tester,
          locale: locale,
          textScale: 2.0,
          size: const Size(320, 568),
        );
        await tapOn(tester, find.text(entry.value(l10nFor(locale))));
        expect(j.location, '/login');
        expect(find.byType(LoginScreen), findsOneWidget);
        expectCleanJourney(
          j,
          knownOverflows: knownSmallPhoneOverflows,
          label: 'small-phone onboarding ${entry.key} $locale',
        );
        await endJourney(tester);
      });
    }
  }
}

void _registerJourneys(
  String tag, {
  required String locale,
  required double scale,
  required Size size,
}) {
  journeyTest('signed-out journey, $tag', (tester) async {
    await signedout.walkSignedOut(
      tester,
      start: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('university learning loop, $tag', (tester) async {
    await university.walkUniversity(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('sign out and the guards, $tag', (tester) async {
    await signout.walkSignOut(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  for (final track in RegTrack.values) {
    journeyTest('register a ${track.name} student, $tag', (tester) async {
      await registration.walkRegistration(
        tester,
        locale: locale,
        track: track,
        textScale: scale,
        size: size,
        knownOverflows: knownSmallPhoneOverflows,
      );
    });
  }
  journeyTest('offline at every kind of step, $tag', (tester) async {
    await offline.walkOffline(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('a double tap sends one request, $tag', (tester) async {
    await doubletap.walkDoubleTaps(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('OS Back on the OTP success view, $tag', (tester) async {
    await back.walkOtpSuccessBack(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('two taps in one frame send one OTP request, $tag', (
    tester,
  ) async {
    await doubletap.walkSameFrameSendOtp(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('signed-out back chain, $tag', (tester) async {
    await back.walkSignedOutBackChain(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('banned account, $tag', (tester) async {
    await banned.walkBanned(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('legal documents signed out, $tag', (tester) async {
    await legal.walkLegalSignedOut(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });

  journeyTest('learning loop, $tag', (tester) async {
    await loop.walkLearningLoop(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('profile edit, $tag', (tester) async {
    await profile.walkProfileEdit(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('settings and support, $tag', (tester) async {
    await settings.walkSettingsAndSupport(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('notifications, $tag', (tester) async {
    await notifications.walkNotifications(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
  journeyTest('legal documents signed in, $tag', (tester) async {
    await legal.walkLegalSignedIn(
      tester,
      locale: locale,
      textScale: scale,
      size: size,
      knownOverflows: knownSmallPhoneOverflows,
    );
  });
}

/// Overflow origins tolerated on the small phones: NONE. The four that were
/// recorded as defects by the first sweep are fixed - the OTP code row (6 x 48 +
/// 5 x 8 = 328 dp, wider than the card on every phone under 396 dp), the OTP
/// success view, the onboarding bottom sheet and the Go to Uni confirm dialog -
/// and this set is the ratchet at zero. A NEW origin fails every walker; do not
/// add to it, fix the screen.
const knownSmallPhoneOverflows = <String>{};
