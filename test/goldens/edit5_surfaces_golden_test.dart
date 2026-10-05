/// Dark-canvas goldens for the edit5 wave · `edit5.md` §11.3.
///
/// **Dark only**, for the reason `edit3_surfaces_golden_test.dart` and
/// `edit4_surfaces_golden_test.dart` both give: the light canvas draws these
/// surfaces with a drop shadow and nothing else, so a light baseline would pin
/// a flat rectangle plus a blur that `figma_shadow_painter_test.dart` already
/// covers by value. Glass rims and back-lights exist only in dark.
///
/// **Why a golden at all when the values are asserted?**
/// `profile_elevation_test.dart` proves the header is handed G15 and the B7
/// back-light. It cannot prove what those two produce *together* — a frosted
/// lavender ellipse under a 20% wash inside a rim — because that is the
/// output of `paintBacklights` and `paintGlassRim` compositing, not a field on
/// a widget. This baseline is the only place that lands.
///
/// **What is deliberately NOT here: the Settings language track.**
/// `edit5.md` §11.3 offers one. It would photograph the same `SegmentedTrack`
/// with the same `pillTrack*` tokens that `quiz_type_tabs_dark.png` already
/// pins — two labels' worth of different text over identical elevation. A
/// third baseline of the same pixels is a file to regenerate, not a check.
/// The Settings track's own claims (order, keys, RTL, tokens, semantics) are
/// asserted by value in `test/features/settings/settings_elevation_test.dart`.
///
/// **Why the OTP baseline is a SCREEN and the other two are widgets.** The
/// surface worth photographing there is the digit cell - G19 over a 20% fill
/// is the only place in the app that combination appears - and `_DigitBox` is
/// private to `otp_screen.dart`, reached only through `Pinput.builder`. A
/// local stand-in would photograph a copy of the code rather than the code,
/// so the real screen is pumped instead and the surface is sized to the part
/// of it this edit touched.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/profile/widgets/profile_header_card.dart';
import 'package:level_up_app/features/settings/widgets/settings_section.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'golden_harness.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('profile header card · dark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 160));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      goldenApp(
        brightness: Brightness.dark,
        child: const SizedBox(
          width: 363,
          child: ProfileHeaderCard(
            // The URL is deliberately unresolvable: `CachedNetworkImage` falls
            // back to its placeholder, which is what a golden should capture
            // anyway (a real avatar would make the baseline depend on a
            // network fetch). The harness stubs `path_provider` so the cache
            // manager does not throw on the way there.
            name: 'Ahmed Mohamed',
            avatarUrl: 'https://example.invalid/avatar.png',
            levelLabel: 'Level 8',
            editLabel: 'Edit profile',
            onEdit: _noop,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProfileHeaderCard),
      matchesGoldenFile('profile_header_dark.png'),
    );
  });

  testWidgets('settings section · dark, with the school back-light', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(402, 260));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      goldenApp(
        brightness: Brightness.dark,
        child: SizedBox(
          width: 362,
          child: SettingsSection(
            title: 'Notification Preferences',
            // The school ellipse, `348:8975` at (0, 33) — the one back-light
            // in the app flush with its surface's start edge, which is what
            // makes it worth a baseline: it is the case where the frost has
            // no margin to fade into on the leading side.
            backlights: [
              AppElevation.dark.notificationPreferencesBacklightSchool!,
            ],
            children: const [
              _Row('Announcements'),
              _Row('Promotions'),
              _Row('Support'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SettingsSection),
      matchesGoldenFile('settings_section_dark.png'),
    );
  });

  testWidgets('OTP code card and digit cells · dark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_MockAuthRepository()),
        secureStorageProvider.overrideWithValue(_MockSecureStorage()),
        deviceInfoProvider.overrideWith(
          (ref) async =>
              const DeviceInfo(deviceId: 'golden', platform: 'android'),
        ),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        // NOT `goldenApp`: that helper centres its child inside a 12dp
        // padding and a second `Scaffold`, which is right for a widget and
        // wrong for a screen - it would narrow the content box by 24 and
        // photograph a layout no device produces.
        child: MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RepaintBoundary(
            // 21 seconds on the clock so the timer pill is in frame with its
            // dark inner bevel; the countdown is run out at the end of the
            // body, which is where the notifier cancels its own timer.
            child: OtpScreen(
              args: OtpArgs(
                phone: '+201021871999',
                resendAfterSeconds: 21,
                expiresInSeconds: 300,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(OtpScreen),
      matchesGoldenFile('otp_dark.png'),
    );

    await tester.pump(const Duration(seconds: 21));
    await tester.pump();
  });
}

/// A stand-in row. The real `SettingsSwitchRow` needs localizations; what this
/// baseline is for is the CARD — G16's frost, the missing hairline and the
/// back-light under them. (Re-captured in API→UI Wave 21 when the heading
/// moved onto the card's edge and 25 above it.)
class _Row extends StatelessWidget {
  const _Row(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16.5, 14.5, 16.5, 14.5),
    child: Text(label, style: AppTheme.dark.textTheme.titleMedium),
  );
}

void _noop() {}
