import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/segmented_track.dart';
import 'package:level_up_app/features/settings/widgets/settings_rows.dart';
import 'package:level_up_app/features/settings/widgets/settings_section.dart';
import 'package:mocktail/mocktail.dart';

import '../profile/profile_fixtures.dart';
import 'settings_harness.dart';

/// Settings' surfaces and its new language control · edit5 items #28 and #50.
///
/// Pumped through `settings_harness.dart`, which boots the real `LevelUpApp`:
/// the Notification Preferences back-light depends on `meProvider`'s track and
/// the canvas depends on `themeModeProvider`, so both have to be the app's own
/// rather than a hand-built `MaterialApp`'s.
void main() {
  Future<void> goDark(WidgetTester tester, ProviderContainer container) async {
    container.read(themeModeProvider.notifier).select(ThemeMode.dark);
    await tester.pumpAndSettle();
  }

  /// The section card whose title is [title]. Sections are identified by their
  /// heading because none of them carries a key, and the screen has four.
  ElevatedSurface cardFor(WidgetTester tester, String title) {
    final section = find.ancestor(
      of: find.text(title),
      matching: find.byType(SettingsSection),
    );
    return tester.widget<ElevatedSurface>(
      find
          .descendant(of: section, matching: find.byType(ElevatedSurface))
          .first,
    );
  }

  // ---------------------------------------------------------------------
  group('#28 the section card', () {
    testWidgets('light: the LAVENDER hairline, not the hub\'s purple-grey', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');
      final card = cardFor(tester, 'Rank');

      expect(card.color, AppColors.light.settingsSectionFill);
      expect(card.side, isNotNull);
      expect(card.side!.color, const Color(0xFFAE87E7));
      expect(
        card.side!.color,
        isNot(AppColors.light.profileRowBorder),
        reason:
            'it had been borrowing the Profile hub\'s #7070A0; `176:1840` '
            'draws #AE87E7',
      );
      expect(card.side!.width, AppElevation.light.settingsSectionBorderWidth);
      expect(card.side!.width, 0.5);
      expect(card.glass, isNull);
      expect(card.backlights, isEmpty);
    });

    testWidgets('dark: NO hairline at all, and G16 instead', (tester) async {
      final container = await pumpAppAt(tester, '/settings');
      await goDark(tester, container);

      final card = cardFor(tester, 'Rank');
      expect(
        card.side,
        isNull,
        reason: '`642:8583` hides the stroke; a 0-wide one is still a choice',
      );
      expect(card.glass, AppElevation.dark.settingsSectionGlass);
      expect(card.glass!.frost, 63, reason: 'G16 — frost 63, else G5');
      expect(card.color, AppColors.dark.settingsSectionFill);
    });
  });

  // ---------------------------------------------------------------------
  group('#28 the Notification Preferences back-light', () {
    testWidgets('light: none, on either track', (tester) async {
      await pumpAppAt(
        tester,
        '/settings',
        profile: settingsRepo(me: universityProfile()),
      );
      expect(cardFor(tester, 'Notification Preferences').backlights, isEmpty);
    });

    testWidgets('dark school: B8 at (0, 33)', (tester) async {
      final container = await pumpAppAt(
        tester,
        '/settings',
        profile: settingsRepo(me: schoolProfile()),
      );
      await goDark(tester, container);

      final light = cardFor(
        tester,
        'Notification Preferences',
      ).backlights.single;
      expect(light, AppElevation.dark.notificationPreferencesBacklightSchool);
      expect(light.offset, const Offset(0, 33));
      expect(light.size, const Size(100, 14));
    });

    testWidgets('dark university: B15, six pixels higher', (tester) async {
      final container = await pumpAppAt(
        tester,
        '/settings',
        profile: settingsRepo(me: universityProfile()),
      );
      await goDark(tester, container);

      final light = cardFor(
        tester,
        'Notification Preferences',
      ).backlights.single;
      expect(
        light,
        AppElevation.dark.notificationPreferencesBacklightUniversity,
      );
      expect(
        light.offset,
        const Offset(0, 27),
        reason: 'B15 and B8 are six pixels apart and both are kept verbatim',
      );
    });

    testWidgets('no back-light while /me has not answered', (tester) async {
      // The track is a server fact. Guessing one would put the haze at the
      // wrong height for half the students until the request lands.
      final repo = settingsRepo();
      when(repo.getMe).thenThrow(const NetworkException());

      final container = await pumpAppAt(tester, '/settings', profile: repo);
      await goDark(tester, container);

      expect(cardFor(tester, 'Notification Preferences').backlights, isEmpty);
    });

    testWidgets('Rank never gets one, on either canvas', (tester) async {
      final container = await pumpAppAt(tester, '/settings');
      await goDark(tester, container);
      expect(cardFor(tester, 'Rank').backlights, isEmpty);
    });
  });

  // ---------------------------------------------------------------------
  group('#50 Languages is a segmented track', () {
    Finder trackFinder() => find.byType(SegmentedTrack<Locale>);

    testWidgets('the card and the two choice rows are GONE', (tester) async {
      await pumpAppAt(tester, '/settings');

      expect(trackFinder(), findsOneWidget);
      expect(
        find.byType(SettingsSection),
        findsNWidgets(3),
        reason: 'Mode, Rank and Notification Preferences — Languages is out',
      );
      // Mode still has its two; Languages contributed two more before.
      expect(find.byType(SettingsChoiceRow), findsNWidgets(2));
    });

    testWidgets('both keys survive, and so do the endonyms', (tester) async {
      await pumpAppAt(tester, '/settings');

      expect(find.byKey(const Key('settings_language_en')), findsOneWidget);
      expect(find.byKey(const Key('settings_language_ar')), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
    });

    testWidgets('ENGLISH is the first segment — the frame\'s order', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');

      final english = tester.getRect(
        find.byKey(const Key('settings_language_en')),
      );
      final arabic = tester.getRect(
        find.byKey(const Key('settings_language_ar')),
      );
      expect(
        english.left,
        lessThan(arabic.left),
        reason:
            'the build listed Arabic first; `176:2373` precedes `176:2375` '
            'and `337:8179` precedes `337:8181`',
      );
      expect(
        english.width,
        closeTo(arabic.width, 0.5),
        reason: 'equal segments — the groove divides evenly',
      );
    });

    testWidgets('in Arabic English STAYS on the left — the frame\'s order', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings', locale: 'ar');

      final english = tester.getRect(
        find.byKey(const Key('settings_language_en')),
      );
      final arabic = tester.getRect(
        find.byKey(const Key('settings_language_ar')),
      );
      final track = tester.getRect(trackFinder());
      expect(
        english.left,
        lessThan(arabic.left),
        reason:
            '`549:21798` "الانجليزية" is at x 20 and `549:21796` "العربية" '
            'at x 201 — the Arabic frame does not mirror this control '
            '(owner ruling 2026-09-29; it mirrored until API→UI Wave 21)',
      );
      expect(english.left, closeTo(track.left, 0.5));
      expect(arabic.right, closeTo(track.right, 0.5));
    });

    testWidgets('the pin is local — the page around it is still RTL', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings', locale: 'ar');

      expect(
        Directionality.of(tester.element(find.text('اللغة'))),
        TextDirection.rtl,
      );
      expect(
        Directionality.of(tester.element(trackFinder())),
        TextDirection.ltr,
      );
    });

    testWidgets('the track takes the shared pillTrack tokens', (tester) async {
      final container = await pumpAppAt(tester, '/settings');

      SegmentedTrack<Locale> track() =>
          tester.widget<SegmentedTrack<Locale>>(trackFinder());

      expect(track().style.trackColor, AppColors.light.pillTrackFill);
      expect(track().style.trackColor, const Color(0xFFECECEC));
      expect(track().style.trackRadius, 32);
      expect(track().height, 44);
      expect(
        track().style.selectedColor,
        AppColors.light.pillTrackSelectedFill,
      );
      expect(track().style.idleLabelColor, AppColors.light.pillTrackLabel);
      expect(
        track().style.selectedLabelColor,
        AppColors.light.pillTrackSelectedLabel,
      );
      expect(
        track().style.trackInsetShadows,
        isEmpty,
        reason: 'the light groove is flat; the inner shadows are dark-only',
      );

      await goDark(tester, container);
      expect(
        track().style.trackInsetShadows,
        AppElevation.dark.pillTrackInsetShadows,
      );
      expect(
        track().style.selectedInsetShadows,
        AppElevation.dark.pillTrackSelectedInsetShadows,
      );
      expect(track().style.trackColor, AppColors.dark.pillTrackFill);
    });

    testWidgets('segment semantics: selected and mutually exclusive', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');
      final handle = tester.ensureSemantics();

      expect(
        tester.getSemantics(find.byKey(const Key('settings_language_en'))),
        isSemantics(
          isButton: true,
          isSelected: true,
          isInMutuallyExclusiveGroup: true,
          label: 'English',
        ),
      );
      expect(
        tester.getSemantics(find.byKey(const Key('settings_language_ar'))),
        isSemantics(
          isButton: true,
          isSelected: false,
          isInMutuallyExclusiveGroup: true,
          label: 'العربية',
        ),
      );
      // The tap ACTION, separately: `excludeSemantics: true` inside the
      // primitive drops the subtree's gesture, and a segment that announces
      // itself selectable with no way to select it is the failure that
      // re-declaration exists to prevent.
      for (final key in ['settings_language_en', 'settings_language_ar']) {
        expect(
          tester
              .getSemantics(find.byKey(Key(key)))
              .getSemanticsData()
              .hasAction(SemanticsAction.tap),
          isTrue,
          reason: key,
        );
      }
      handle.dispose();
    });

    testWidgets('tapping a segment still switches the locale', (tester) async {
      final container = await pumpAppAt(tester, '/settings');

      await tester.tap(find.byKey(const Key('settings_language_ar')));
      await tester.pumpAndSettle();
      expect(container.read(localeProvider), const Locale('ar'));
    });

    // One locale per test, not a loop: `pumpAppAt` builds its own
    // `ProviderContainer` and pushes a route through its own router, and a
    // second one over the same element tree leaves the first router alive —
    // `pumpAndSettle` then never returns.
    for (final locale in ['en', 'ar']) {
      testWidgets('text scale 1.3 does not overflow in $locale', (
        tester,
      ) async {
        // The primitive gives up its fixed WIDTH rather than shrinking a
        // label (D-012), so the failure mode to guard against is a HARD
        // overflow, not a clipped one. Errors are captured rather than left
        // to fail the test outright, so the assertion can say which appeared.
        //
        // Caveat the register already carries (#81): this binding's font is
        // ~1.5x wider than Inter, so "it fits here" is stricter than the
        // device and "it scrolls here" is not a device finding.
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) => errors.add(details.toString());
        addTearDown(() => FlutterError.onError = previous);

        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await pumpAppAt(tester, '/settings', locale: locale);

        expect(find.byType(SegmentedTrack<Locale>), findsOneWidget);
        expect(find.byKey(const Key('settings_language_en')), findsOneWidget);
        expect(
          errors.where((e) => e.contains('overflowed')),
          isEmpty,
          reason: 'the track scrolls instead of overflowing',
        );
      });
    }
  });
}
