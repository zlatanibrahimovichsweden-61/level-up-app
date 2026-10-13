/// E4 (f), (i) and the privacy half of (j): what can leave the device or
/// reach a log, and where the app keeps anything.
///
/// Static censuses (`P1`-`P6`) read `lib/` and the platform manifests; the
/// dynamic probes (`P7`, `P8`) run the real app on the real wiring with
/// sentinel values and prove none of them reaches a captured log or a store it
/// should not.
///
/// A census that fails is not necessarily a defect: it means a NEW sink or
/// store has appeared and somebody has to look at it and add it to the list
/// below with a reason.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/preferences_store.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/phone.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/otp_notifier.dart';
import 'package:level_up_app/features/legal/models/terms_acceptance.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/registration/models/registration_draft.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/dart_source.dart';
import 'support/e4_support.dart';

void main() {
  // ---------------------------------------------------------------------------
  // (f) logs
  // ---------------------------------------------------------------------------
  group('(f) logging', () {
    test('P1 there is NO logging sink anywhere in lib/ (dev harness included): '
        'no print, debugPrint, developer.log, Logger, stdout/stderr, '
        'FlutterError hooks, zone/dispatcher error hooks, Dio logger, '
        'ProviderObserver', () {
      final forbidden = <String, RegExp>{
        'print(': RegExp(r'(^|[^\w.])print\s*\('),
        'debugPrint': RegExp(r'\bdebugPrint\w*\b'),
        'dart:developer': RegExp(r'dart:developer'),
        'developer.log': RegExp(r'\bdeveloper\s*\.\s*log\b'),
        'log(': RegExp(r'(^|[^\w.])log\s*\('),
        'Logger': RegExp(r'\bLogger\b|\bLogging\b|package:logging'),
        'stdout/stderr': RegExp(r'\b(stdout|stderr)\b'),
        'FlutterError hooks': RegExp(
          r'FlutterError\s*\.\s*(onError|reportError|dumpErrorToConsole|'
          r'presentError)',
        ),
        'PlatformDispatcher': RegExp(r'PlatformDispatcher'),
        'runZonedGuarded': RegExp(r'runZonedGuarded|Zone\s*\.\s*current'),
        'debugLogDiagnostics': RegExp(r'debugLogDiagnostics'),
        'Dio logger': RegExp(r'LogInterceptor|PrettyDioLogger'),
        'ProviderObserver': RegExp(r'ProviderObserver'),
        'debugDump': RegExp(r'\bdebugDump\w*\b'),
      };
      final hits = <String>[];
      for (final entry in libCode().entries) {
        final code = blankStrings(entry.value);
        for (final rule in forbidden.entries) {
          for (final m in rule.value.allMatches(code)) {
            final line = '\n'.allMatches(code.substring(0, m.start)).length + 1;
            hits.add('${entry.key}:$line  ${rule.key}');
          }
        }
      }
      expect(
        hits,
        isEmpty,
        reason: 'logging sink(s) in lib/:\n${hits.join('\n')}',
      );
    });

    test('P2 no analytics / crash-reporting / logging SDK is declared or '
        'locked (each would be a network sink the app does not own)', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final lock = File('pubspec.lock').readAsStringSync();
      final sdk = RegExp(
        r'sentry|crashlytics|firebase|analytics|mixpanel|amplitude|datadog|'
        r'bugsnag|appsflyer|adjust_sdk|segment|posthog|instabug|logger\b|'
        r'talker|onesignal|branch_sdk|clarity|smartlook',
        caseSensitive: false,
      );
      final declared = <String>[
        for (final line in pubspec.split('\n'))
          if (RegExp(r'^  [a-z_0-9]+:').hasMatch(line) &&
              sdk.hasMatch(line.split(':').first))
            line.trim(),
      ];
      final locked = <String>[
        for (final line in lock.split('\n'))
          if (RegExp(r'^  [a-z_0-9]+:$').hasMatch(line) &&
              sdk.hasMatch(line.trim()))
            line.trim(),
      ];
      expect(declared, isEmpty);
      expect(locked, isEmpty);
    });

    test('P3 exceptions never put `detail` (or field messages) into '
        'toString - an unhandled one would print it', () {
      const secret = 'SENTINEL-DETAIL-0099';
      final all = <AppException>[
        const OfflineException(),
        const NetworkException(detail: secret),
        const ApiException(status: 500, code: 'internal_error', detail: secret),
        const UnauthorizedException(
          code: 'authentication_required',
          detail: secret,
        ),
        const ValidationException(
          errors: {
            'name': [secret],
          },
          detail: secret,
        ),
        const RateLimitedException(detail: secret),
        const UnknownException(detail: secret),
      ];
      for (final e in all) {
        expect(e.toString(), 'AppException(${e.code})');
        expect(e.toString(), isNot(contains(secret)));
      }
    });

    test('P3b every hand-written toString() override in lib/ is on the '
        'reviewed list (a new one must be read for personal data)', () {
      const reviewed = {
        'lib/core/network/exceptions.dart', // AppException(code)
        'lib/core/push/push_gateway.dart', // PushTap(kind)
        'lib/core/push/push_tap_resolver.dart', // PushTapOpen / TargetNotBuilt
        'lib/core/theme/app_elevation.dart', // theme tokens
        // Redacted on purpose (their own doc comments say so):
        'lib/features/deletion/models/deletion_window.dart',
        'lib/features/friends/models/friend_models.dart',
        'lib/features/legal/models/terms_acceptance.dart',
        'lib/features/profile/models/track_transfer_request.dart',
        'lib/features/recovery/models/recovery_models.dart',
        'lib/features/recovery/notifier/recovery_flow_notifier.dart',
        'lib/features/referral/models/my_invite.dart',
        'lib/features/registration/models/registration_validation.dart',
        // Localised copy, not a student's data.
        'lib/features/flashcards/widgets/flashcards_error_copy.dart',
        // E4-02, fixed in R2c: these used to print credentials / personal data
        // and now say their type and nothing else (see P3d and
        // test/core/privacy/credential_models_redaction_test.dart).
        'lib/features/auth/models/auth_result.dart',
        'lib/features/auth/models/device_info.dart',
        'lib/features/auth/models/phone.dart',
        'lib/features/auth/models/token_pair.dart',
        'lib/features/profile/models/profile_update.dart',
        'lib/features/registration/models/registration_draft.dart',
        // The last four that printed personal data (integration round 2): the
        // profile record and its free-text city, the two POST /auth/register
        // bodies and another student's leaderboard row. Now their type name
        // only (test/core/privacy/credential_models_redaction_test.dart).
        'lib/features/leaderboard/models/leaderboard_models.dart',
        'lib/features/profile/models/student_profile.dart',
        'lib/features/registration/models/school_registration.dart',
        'lib/features/registration/models/university_registration.dart',
        // Text a student wrote (a ticket's subject, details and reply body),
        // and the avatar a student uploaded (the review of that round).
        // ProfileAvatar lives in student_profile.dart, listed above.
        'lib/features/support/models/support_models.dart',
      };
      final overrides = <String>{
        for (final entry in libCode().entries)
          if (RegExp(
            r'String\s+toString\s*\(\s*\)\s*(=>|\{)',
          ).hasMatch(entry.value))
            entry.key,
      };
      expect(
        overrides.difference(reviewed),
        isEmpty,
        reason: 'a new toString() override needs reviewing',
      );
      expect(reviewed.difference(overrides), isEmpty, reason: 'stale entry');
    });

    test('P3d E4-02 (fixed in R2c): the credential- and personal-data-bearing '
        'value objects no longer stringify their secrets, like the redacted '
        'friends / referral / recovery / terms models', () {
      const phone = '+201000000099';
      const access = 'SENTINEL-ACCESS-TOKEN';
      const refresh = 'SENTINEL-REFRESH-TOKEN';
      const regToken = 'SENTINEL-REGISTRATION-TOKEN';
      const name = 'SENTINEL NAME';
      const email = 'sentinel@example.test';
      const deviceId = 'SENTINEL-DEVICE-ID';

      final stringified = <String, String>{
        'TokenPair': const TokenPair(
          accessToken: access,
          accessExpiresInSeconds: 900,
          refreshToken: refresh,
          refreshExpiresInSeconds: 5184000,
        ).toString(),
        'AuthResult.authenticated': AuthResult.fromJson(<String, Object?>{
          'result': 'authenticated',
          'tokens': <String, Object?>{
            'accessToken': access,
            'accessExpiresInSeconds': 900,
            'refreshToken': refresh,
            'refreshExpiresInSeconds': 5184000,
          },
          'profile': <String, Object?>{'name': name, 'email': email},
        }).toString(),
        'AuthResult.registrationRequired':
            AuthResult.fromJson(<String, Object?>{
              'result': 'registrationRequired',
              'registrationToken': regToken,
              'expiresInSeconds': 600,
            }).toString(),
        'DeviceInfo': const DeviceInfo(
          deviceId: deviceId,
          platform: 'android',
          model: 'SENTINEL-MODEL',
        ).toString(),
        'RegistrationDraft': RegistrationDraft(
          registrationToken: regToken,
          tokenExpiresAt: DateTime(2030),
          phone: phone,
          name: name,
        ).toString(),
        'Phone': Phone.tryParse('01000000099').toString(),
        'ProfileUpdate': const ProfileUpdate(
          name: name,
          email: EmailSet(email),
        ).toString(),
        'EmailSet': const EmailSet(email).toString(),
      };

      // The fix: none of them carries a sentinel any more.
      const secrets = [
        phone,
        '1000000099',
        access,
        refresh,
        regToken,
        name,
        email,
        deviceId,
        'SENTINEL-MODEL',
      ];
      // The probe itself: every sentinel a string carries. One function, used
      // for the real models and for the control below, so the control proves
      // THIS check can fail rather than restating that a string contains the
      // text it was built from.
      List<String> leaks(String printed) => [
        for (final secret in secrets)
          if (printed.contains(secret)) secret,
      ];

      for (final entry in stringified.entries) {
        expect(
          leaks(entry.value),
          isEmpty,
          reason: '${entry.key} prints a secret',
        );
      }

      // Controls: the probe can tell (a deliberately leaky string is caught,
      // and a clean one is not), and the already-redacted models stay clean.
      expect(leaks('Leaky(token: $access, email: $email)'), [access, email]);
      expect(leaks('Clean(<redacted>)'), isEmpty);
      final redacted = <String>[
        const TermsAcceptance(
          currentVersion: 'v1',
          acceptedVersion: 'v1',
          acceptedAtUtc: null,
          isCurrent: true,
        ).toString(),
        const OtpArgs(
          phone: phone,
          resendAfterSeconds: 60,
          expiresInSeconds: 300,
        ).toString(),
        otpProvider(
          const OtpArgs(
            phone: phone,
            resendAfterSeconds: 60,
            expiresInSeconds: 300,
          ),
        ).toString(),
      ];
      for (final r in redacted) {
        expect(r, isNot(contains(phone)));
      }
    });

    test(
      'P3c OBSERVATION E4-O3: generated freezed toString() of the personal '
      'models prints every field - safe ONLY because nothing logs; this '
      'test pins that no model is ever interpolated into an exception '
      'detail, so the day a logger appears is the day it must be revisited',
      () {
        // Every `detail:` in lib/ is a literal, a runtimeType or a contract enum.
        final dynamicDetails = <String>[];
        for (final entry in libCode(includeDev: false).entries) {
          for (final m in RegExp(
            r'detail:\s*([^,)\n]+)',
          ).allMatches(entry.value)) {
            final expr = m.group(1)!;
            if (!expr.contains(r'$')) continue;
            const allowed = [r'${e.runtimeType}', r'$track'];
            if (!allowed.any(expr.contains)) {
              dynamicDetails.add('${entry.key}: $expr');
            }
          }
        }
        expect(dynamicDetails, isEmpty);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // (i) storage
  // ---------------------------------------------------------------------------
  group('(i) storage', () {
    test('P4 only the two wrappers touch a store: flutter_secure_storage in '
        'secure_storage.dart, shared_preferences in preferences_store.dart, '
        'no file, database or other cache', () {
      final files = libCode();
      bool imports(String pkg, String path) =>
          files[path]!.contains('package:$pkg/');
      final secure = <String>[
        for (final e in files.entries)
          if (e.value.contains('package:flutter_secure_storage/')) e.key,
      ];
      final prefs = <String>[
        for (final e in files.entries)
          if (e.value.contains('package:shared_preferences/')) e.key,
      ];
      expect(secure, ['lib/core/storage/secure_storage.dart']);
      expect(prefs, ['lib/core/storage/preferences_store.dart']);
      expect(imports('flutter_secure_storage', secure.single), isTrue);

      final other = RegExp(
        r"package:(path_provider|sqflite|hive\w*|isar\w*|drift\w*|sembast|"
        r"objectbox|realm|localstorage|get_storage|flutter_cache_manager)/|"
        r'\b(File|Directory|RandomAccessFile|IOSink)\s*\(|dart:io',
      );
      final hits = <String>[
        for (final e in files.entries)
          if (!e.key.startsWith('lib/dev/') &&
              other.hasMatch(blankStrings(e.value)))
            '${e.key}: ${other.firstMatch(blankStrings(e.value))!.group(0)}',
      ];
      expect(hits, isEmpty, reason: hits.join('\n'));
    });

    test('P4b the wrappers\' key sets are exactly the reviewed ones', () {
      final secure = File(
        'lib/core/storage/secure_storage.dart',
      ).readAsStringSync();
      final prefs = File(
        'lib/core/storage/preferences_store.dart',
      ).readAsStringSync();
      Set<String> keys(String src, String prefix) => {
        for (final m in RegExp(
          "static const _k\\w+ = '([^']+)'",
        ).allMatches(src))
          if (m.group(1)!.startsWith(prefix)) m.group(1)!,
      };
      expect(keys(secure, ''), {'access_token', 'refresh_token', 'device_id'});
      expect(keys(prefs, 'pref.'), {'pref.theme_mode', 'pref.locale'});
    });

    test('P5 platform artefacts (SOURCE): Android backup is off in every '
        'channel, no cleartext, INTERNET is the only permission; iOS has no '
        'ATS exception; the live base URLs are https', () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      final stripped = manifest.replaceAll(
        RegExp(r'<!--.*?-->', dotAll: true),
        '',
      );
      expect(stripped, contains('android:allowBackup="false"'));
      expect(stripped, contains('android:fullBackupContent="false"'));
      expect(stripped, contains('android:dataExtractionRules='));
      expect(stripped, isNot(contains('usesCleartextTraffic')));
      expect(stripped, isNot(contains('networkSecurityConfig')));
      expect(
        RegExp(
          r'<uses-permission android:name="([^"]+)"',
        ).allMatches(stripped).map((m) => m.group(1)).toList(),
        ['android.permission.INTERNET'],
      );
      // Only the launcher activity is exported.
      expect(RegExp(r'android:exported="true"').allMatches(stripped).length, 1);

      final rules = File(
        'android/app/src/main/res/xml/data_extraction_rules.xml',
      ).readAsStringSync().replaceAll(RegExp(r'<!--.*?-->', dotAll: true), '');
      for (final channel in ['cloud-backup', 'device-transfer']) {
        final block = RegExp(
          '<$channel>(.*?)</$channel>',
          dotAll: true,
        ).firstMatch(rules)!.group(1)!;
        for (final domain in [
          'root',
          'file',
          'database',
          'sharedpref',
          'external',
        ]) {
          expect(
            block,
            contains('<exclude domain="$domain"'),
            reason: '$channel keeps $domain',
          );
        }
        expect(block, isNot(contains('<include')));
      }

      for (final flavorDir in ['debug', 'profile']) {
        final m = File('android/app/src/$flavorDir/AndroidManifest.xml')
            .readAsStringSync()
            .replaceAll(RegExp(r'<!--.*?-->', dotAll: true), '');
        expect(
          RegExp(
            r'<uses-permission android:name="([^"]+)"',
          ).allMatches(m).map((x) => x.group(1)).toList(),
          ['android.permission.INTERNET'],
          reason: '$flavorDir manifest adds a permission',
        );
      }

      final plist = File('ios/Runner/Info.plist').readAsStringSync();
      expect(plist, isNot(contains('NSAllowsArbitraryLoads')));
      expect(plist, isNot(contains('NSAppTransportSecurity')));

      final config = File('lib/core/config/app_config.dart').readAsStringSync();
      for (final m in RegExp(r"'(https?://[^']+)'").allMatches(config)) {
        expect(m.group(1), startsWith('https://'));
      }
    });
  });

  // ---------------------------------------------------------------------------
  // (h)/(f) unintended network: what can leave NOT through Dio
  // ---------------------------------------------------------------------------
  group('(h) network sinks that bypass Dio', () {
    test('P6 the image loaders and the external-link launcher are exactly the '
        'reviewed sites (each fetches a server-supplied URL with no '
        'Authorization header, outside the Dio chain)', () {
      const reviewed = {
        'lib/features/flashcards/widgets/flashcard_flip_card.dart',
        'lib/features/home/widgets/home_header.dart',
        'lib/features/leaderboard/widgets/board_avatar.dart',
        'lib/features/profile/screens/edit_profile_screen.dart',
        'lib/features/profile/widgets/avatar_sheets.dart',
        'lib/features/profile/widgets/profile_header_card.dart',
        'lib/features/quiz/widgets/mcq_renderer.dart',
        'lib/features/support/widgets/support_message_row.dart',
      };
      final sinks = RegExp(
        r'Image\s*\.\s*network|CachedNetworkImage\b|NetworkImage\b|'
        r'HttpClient\b|package:http/|WebView|launchUrl|launchUrlString|'
        r'\bWebSocket\b|Socket\.connect|package:web_socket',
      );
      final launchOnly = <String>{};
      final found = <String>{};
      for (final e in libCode(includeDev: false).entries) {
        final code = blankStrings(e.value);
        for (final m in sinks.allMatches(code)) {
          final t = m.group(0)!;
          if (t.startsWith('launchUrl')) {
            launchOnly.add(e.key);
          } else if (!t.startsWith('import')) {
            found.add(e.key);
          }
        }
      }
      // `cached_network_image` is imported at the same sites it is used.
      found.removeWhere((p) => p == 'lib/features/legal/legal_links.dart');
      expect(found, reviewed);
      expect(launchOnly, {'lib/features/legal/legal_links.dart'});
    });
  });

  // ---------------------------------------------------------------------------
  // (f) dynamic leak probe
  // ---------------------------------------------------------------------------
  group('(f) dynamic leak probe', () {
    e4Widgets('P7 a full sign-in / profile / forced sign-out journey with '
        'sentinel values prints NOTHING that contains a sentinel, a token, '
        'or the phone number, and reports no framework error', (tester) async {
      final printed = <String>[];
      final oldDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) =>
          printed.add(message ?? '');

      final rig = AppRig();
      late List<String> minted;

      Future<void> journey() async {
        // Positive controls: both channels demonstrably reach `printed`.
        // ignore: avoid_print
        print('E4-CONTROL-PRINT');
        debugPrint('E4-CONTROL-DEBUGPRINT');

        await rig.boot(tester);
        await pumpFrames(tester);
        await tester.tap(find.text('Log In'));
        await pumpFrames(tester, frames: 5);
        await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
        await pumpFrames(tester, frames: 3);
        await tester.tap(find.text('Send OTP'));
        await pumpFrames(tester, frames: 8);
        expect(find.byType(OtpScreen), findsOneWidget);
        await tester.enterText(find.byType(Pinput), '000000');
        await pumpFrames(tester, frames: 10);
        await tester.tap(find.text('Continue'));
        await pumpFrames(tester, frames: 25);
        expect(find.byType(HomeScreen), findsOneWidget);
        for (final route in [
          '/profile',
          '/profile/edit',
          '/settings',
          '/notifications',
          '/support',
          '/learn',
          '/leaderboard',
        ]) {
          rig.container.read(routerProvider).go(route);
          await pumpFrames(tester, frames: 12);
        }
        // A failing request, then a forced sign-out.
        minted = [
          (await rig.storage.readAccessToken())!,
          (await rig.storage.readRefreshToken())!,
        ];
        rig.server.expireAccess();
        rig.server.refreshDead = true;
        rig.container.invalidate(meProvider);
        await pumpFrames(tester, frames: 30);
        expect(rig.auth, isA<AuthUnauthenticated>());
      }

      await runZoned(
        journey,
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) => printed.add(line),
        ),
      );
      // Restored here, not in a tearDown: the binding checks foundation
      // variables before teardowns run.
      debugPrint = oldDebugPrint;

      expect(printed, contains('E4-CONTROL-PRINT'));
      expect(printed, contains('E4-CONTROL-DEBUGPRINT'));
      final sentinels = [
        kSentinelPhoneLocal,
        kSentinelPhoneE164,
        kSentinelPhoneLocal.substring(1),
        ...minted,
        'Bearer',
      ];
      for (final line in printed) {
        for (final s in sentinels) {
          expect(
            line,
            isNot(contains(s)),
            reason: 'a log line carried a sentinel',
          );
        }
      }
      // The SVG decoder's `unhandled element <filter/>` warning is the one
      // known framework line; it names an SVG tag.
      final interesting = printed
          .where(
            (l) =>
                !l.startsWith('unhandled element') &&
                !l.startsWith('E4-CONTROL-'),
          )
          .toList();
      expect(interesting, isEmpty, reason: 'the app printed: $interesting');
      expect(tester.takeException(), isNull);
      await tearDownTree(tester, rig);
    });

    e4Widgets('P8 after a full journey the only things persisted are the three '
        'keystore keys and the two preference keys - and a forced sign-out '
        'leaves ONLY the device id and the preferences', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final store = await PreferencesStore.load();
      final prefs = await SharedPreferences.getInstance();

      final rig = AppRig(
        overrides: [preferencesStoreProvider.overrideWithValue(store)],
      );
      await rig.boot(tester);
      await pumpFrames(tester);
      expect(
        rig.fss.data,
        isEmpty,
        reason: 'a signed-out cold start stores nothing',
      );
      await tester.tap(find.text('Log In'));
      await pumpFrames(tester, frames: 5);
      await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
      await pumpFrames(tester, frames: 3);
      await tester.tap(find.text('Send OTP'));
      await pumpFrames(tester, frames: 8);
      await tester.enterText(find.byType(Pinput), '000000');
      await pumpFrames(tester, frames: 10);
      await tester.tap(find.text('Continue'));
      await pumpFrames(tester, frames: 25);

      // Preferences the student may change.
      rig.container.read(localeProvider.notifier).select(const Locale('ar'));
      rig.container.read(themeModeProvider.notifier).select(ThemeMode.dark);
      await pumpFrames(tester, frames: 10);

      expect(rig.fss.data.keys.toSet(), {
        'access_token',
        'refresh_token',
        'device_id',
      });
      expect(prefs.getKeys(), {'pref.theme_mode', 'pref.locale'});
      expect(prefs.getString('pref.locale'), 'ar');
      expect(prefs.getString('pref.theme_mode'), 'dark');

      // Nothing sensitive in the clear store.
      final token = rig.fss.data['access_token']!;
      for (final k in prefs.getKeys()) {
        final v = prefs.get(k).toString();
        expect(v, isNot(contains(token)));
        expect(v, isNot(contains(kSentinelPhoneLocal)));
      }

      // Forced sign-out.
      rig.server.expireAccess();
      rig.server.refreshDead = true;
      rig.container.invalidate(meProvider);
      await pumpFrames(tester, frames: 30);
      expect(rig.auth, isA<AuthUnauthenticated>());
      expect(rig.fss.data.keys.toSet(), {'device_id'});
      expect(prefs.getKeys(), {'pref.theme_mode', 'pref.locale'});
      await tearDownTree(tester, rig);
    });
  });
}
