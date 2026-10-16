import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/glass_mapping.dart';

/// Every elevation token, pinned to the Figma value it was read from.
///
/// This is `app_colors_test.dart`'s twin and exists for the same reason the
/// Mistakes group there exists: four tokens once shipped with dark == light on
/// an observation nobody had measured, and only a test that states the number
/// can stop a later tidy-up from quietly carrying one value across another.
///
/// Node ids are in a trailing comment on each expectation, so re-reading a
/// value means opening one frame rather than the whole file.
void main() {
  final light = AppElevation.light;
  final dark = AppElevation.dark;

  const black25 = Color.fromRGBO(0, 0, 0, 0.25);
  const black15 = Color.fromRGBO(0, 0, 0, 0.15);
  const black10 = Color.fromRGBO(0, 0, 0, 0.10);

  /// Figma's default Glass — 363 nodes carry it.
  const g5 = GlassStyle(
    frost: 4,
    refraction: 0.80,
    depth: 20,
    lightAngle: -45,
    lightIntensity: 0.80,
    dispersion: 0.50,
    splay: 0,
  );

  // -------------------------------------------------------------------------
  group('the blur conversion', () {
    test('kFigmaBlurToSigma is the CSS definition, not a tunable', () {
      // CSS: a blur radius B is a Gaussian with sigma = B/2, and Figma's
      // drop/inner-shadow "Blur" IS the CSS blur radius. If this is ever
      // "calibrated", every shadow in the app moves at once.
      expect(kFigmaBlurToSigma, 0.5);
    });

    test('sigma is NOT what BoxShadow would have produced', () {
      // The defect this whole layer exists to stop: `BoxShadow(blurRadius: B)`
      // converts with sigma = 0.57735*B + 0.5, so the file's commonest blur,
      // 1.3, renders at 1.25 instead of 0.65 — almost twice as soft.
      const shadow = FigmaShadow(
        color: black25,
        offset: Offset.zero,
        blur: 1.3,
      );
      expect(shadow.sigma, closeTo(0.65, 1e-9));
      expect(shadow.sigma, isNot(closeTo(0.57735 * 1.3 + 0.5, 0.01)));
    });

    test('frost converts with its own constant', () {
      expect(kGlassFrostToSigma, 0.5);
      expect(g5.frostSigma, 2); // frost 4
    });
  });

  // -------------------------------------------------------------------------
  group('edit2 — shell, auth, onboarding, registration', () {
    test('nav bar: the two canvases differ in colour AND blur', () {
      expect(light.navBarShadows, const [
        FigmaShadow(
          color: Color.fromRGBO(184, 184, 210, 0.5),
          offset: Offset(0, 2.144),
          blur: 16.08,
        ),
      ]); // 59:1264 Union
      expect(dark.navBarShadows, const [
        FigmaShadow(
          color: Color.fromRGBO(124, 58, 237, 0.1),
          offset: Offset(0, 2.144),
          blur: 12.5,
        ),
      ]); // 349:16719
    });

    test('the three CTA tokens', () {
      const cta = [
        FigmaShadow(color: black25, offset: Offset(0.5, 0.5), blur: 4),
      ];
      expect(light.primaryCtaShadows, cta); // 348:8911
      expect(dark.primaryCtaShadows, cta);
      expect(light.outlineCtaShadows, cta); // Frame 427319504
      expect(dark.outlineCtaShadows, cta);

      // The glow is the dark canvas's alone, and the number is a layer-blur
      // PANEL value: sigma is half of it.
      expect(light.primaryCtaGlowLayerBlur, isNull);
      expect(dark.primaryCtaGlowLayerBlur, 8); // 348:8909
    });

    test('back chip: light shadow, dark Glass — not a missing shadow', () {
      expect(light.backChipShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0.02833, 0.02833),
          blur: 1.3,
        ),
      ]); // 90:208
      expect(dark.backChipShadows, isEmpty); // 404:7424 draws none
      expect(light.backChipGlass, isNull);
      expect(dark.backChipGlass, g5);
    });

    test('the registration back chip is a different Glass from G5', () {
      expect(
        dark.registrationBackChipGlass,
        const GlassStyle(
          frost: 20,
          refraction: 1,
          depth: 36,
          lightAngle: 22,
          lightIntensity: 0.25,
          dispersion: 0.70,
          splay: 0.16,
        ),
      ); // 337:19690
      expect(light.registrationBackChipGlass, isNull);
    });

    test('language pill: G3 differs from G5 only in lightIntensity', () {
      expect(
        dark.languagePillGlass,
        const GlassStyle(
          frost: 4,
          refraction: 0.80,
          depth: 20,
          lightAngle: -45,
          lightIntensity: 0.25,
          dispersion: 0.50,
          splay: 0,
        ),
      ); // 340:19734
      expect(dark.languagePillGlass!.frost, g5.frost);
      expect(dark.languagePillGlass!.lightIntensity, isNot(g5.lightIntensity));
      expect(light.languagePillBorderWidth, 0.629032); // 82:1093
      expect(dark.languagePillBorderWidth, 0); // 337:19693 — no outline
    });

    test('form fields: G4, and the 0.03 hairline kept verbatim', () {
      expect(
        dark.fieldGlass,
        const GlassStyle(
          frost: 0,
          refraction: 1,
          depth: 53,
          lightAngle: 28,
          lightIntensity: 0.25,
          dispersion: 0.50,
          splay: 0.97,
        ),
      ); // 348:8659
      expect(light.fieldBorderWidth, 1.17338); // Rectangle 9
      expect(
        dark.fieldBorderWidth,
        0.03,
        reason: 'not rounded to 0 or 0.5 — edit1.md R2',
      );
    });

    test('onboarding sheet: the only Glass in the light frames', () {
      const g1 = GlassStyle(
        frost: 80,
        refraction: 0.73,
        depth: 27,
        lightAngle: 37,
        lightIntensity: 0.95,
        dispersion: 0.62,
        splay: 0.76,
      );
      expect(light.onboardingSheetGlass, g1); // 459:43873
      expect(dark.onboardingSheetGlass, g1); // 337:15643

      const sheet = [
        FigmaShadow(color: black15, offset: Offset(0, -1.5), blur: 9.2),
      ];
      expect(light.onboardingSheetShadows, sheet);
      expect(dark.onboardingSheetShadows, sheet);
    });

    test('scrims: five frames, five readings', () {
      const scrim30 = Color.fromRGBO(49, 49, 49, 0.3);

      expect(
        light.limitSheetScrim,
        const ScrimStyle(color: Color.fromRGBO(49, 49, 49, 0.5), sigma: 5.75),
      );
      expect(
        dark.limitSheetScrim,
        isNull,
        reason: 'BLOCKED: no dark Limitation frame. Null is "not measured".',
      );

      expect(light.avatarActionSheetScrim, const ScrimStyle(color: scrim30));
      expect(
        dark.avatarActionSheetScrim,
        const ScrimStyle(color: scrim30, sigma: 14.7),
      );
      expect(
        dark.chooseAvatarSheetScrim,
        const ScrimStyle(color: scrim30, sigma: 13.4),
      );
      expect(
        dark.logoutDialogScrim,
        const ScrimStyle(color: Color.fromRGBO(49, 49, 49, 0.6), sigma: 9.95),
      );
      // A tenth of a pixel from the logout dialog's, and kept.
      expect(
        dark.goToUniversityDialogScrim,
        const ScrimStyle(color: Color.fromRGBO(49, 49, 49, 0.6), sigma: 10.05),
      );
      expect(light.logoutDialogScrim, const ScrimStyle(color: scrim30));
      expect(light.goToUniversityDialogScrim, const ScrimStyle(color: scrim30));
      expect(light.chooseAvatarSheetScrim, const ScrimStyle(color: scrim30));
    });
  });

  // -------------------------------------------------------------------------
  group('edit3 — home, catalog, mistakes', () {
    test('level card: light shadow, dark Glass plus a back-light', () {
      expect(light.levelCardShadows, const [
        FigmaShadow(color: black25, offset: Offset(0.5, 0.5), blur: 4),
      ]); // 308:4209
      expect(dark.levelCardShadows, isEmpty); // 337:5336
      expect(
        dark.levelCardGlass,
        const GlassStyle(
          frost: 62,
          refraction: 0.80,
          depth: 78,
          lightAngle: -45,
          lightIntensity: 0.80,
          dispersion: 0.50,
          splay: 1,
        ),
      ); // G6

      // B1 / B9 — two pixels apart, and both kept.
      expect(dark.levelCardBacklightSchool!.offset, const Offset(23, 25));
      expect(dark.levelCardBacklightUniversity!.offset, const Offset(23, 23));
      for (final b in [
        dark.levelCardBacklightSchool!,
        dark.levelCardBacklightUniversity!,
      ]) {
        expect(b.size, const Size(133, 21));
        expect(b.color, AppColors.dark.backlight);
      }
      expect(light.levelCardBacklightSchool, isNull);
    });

    test('daily tasks: G7, and two differently sized back-lights', () {
      expect(dark.dailyTasksGlass!.frost, 39); // G7, 337:5357
      expect(light.dailyTasksBorderWidth, 0.302507); // 308:4305
      expect(dark.dailyTasksBorderWidth, 0);

      expect(dark.dailyTasksBacklightSchool!.offset, const Offset(3, 0)); // B2
      expect(dark.dailyTasksBacklightSchool!.size, const Size(100, 14));
      expect(dark.dailyTasksBacklightUniversity!.offset, const Offset(13, 0));
      expect(dark.dailyTasksBacklightUniversity!.size, const Size(133, 21));
    });

    test('top student: same border width on both canvases', () {
      expect(light.topStudentBorderWidth, 1.20791); // 59:2090
      expect(dark.topStudentBorderWidth, 1.20791); // 337:5460
      expect(dark.topStudentGlass!.frost, 34); // G9
      expect(dark.topStudentBacklightSchool!.offset, const Offset(3, 7.57));
      expect(
        dark.topStudentBacklightSchool!.size,
        const Size(100, 14),
      ); // B3; the university block has none
    });

    test('continue learning: two shadows, one with a negative spread', () {
      const shadows = [
        FigmaShadow(color: black25, offset: Offset(0, 0.425436), blur: 1.27631),
        FigmaShadow(
          color: black25,
          offset: Offset(0.423807, 0),
          blur: 0.850872,
          spread: -0.425436,
        ),
      ];
      expect(light.continueLearningShadows, shadows);
      expect(dark.continueLearningShadows, shadows);
    });

    test('subjects search: the file\'s only 10% shadows', () {
      expect(light.subjectSearchShadows, const [
        FigmaShadow(color: black10, offset: Offset(0, 1), blur: 3),
        FigmaShadow(color: black10, offset: Offset(0, 1), blur: 2, spread: -1),
      ]); // 135:610
      expect(dark.subjectSearchShadows, isEmpty); // 337:5724
      expect(dark.subjectSearchGlass, g5);
      expect(dark.homeBellGlass, g5); // 337:5330
    });

    test('subject card: identical on both canvases — this is #34\'s proof', () {
      const shadows = [
        FigmaShadow(color: black25, offset: Offset(0, 0.530516), blur: 1.59155),
        FigmaShadow(
          color: black25,
          offset: Offset(0.528485, 0),
          blur: 1.06103,
          spread: -0.530516,
        ),
      ];
      expect(light.subjectCardShadows, shadows); // 135:618
      expect(dark.subjectCardShadows, shadows); // 337:5732
    });

    test('mistakes pill and card', () {
      const pill = [
        FigmaShadow(
          color: black25,
          offset: Offset(0.266667, 0.266667),
          blur: 2.13333,
        ),
      ];
      expect(light.mistakesPillShadows, pill);
      expect(dark.mistakesPillShadows, pill); // 404:7421
      expect(light.mistakesPillBorderWidth, 0.266667);
      expect(dark.mistakesPillGlass, g5);

      // Note the order: the x-offset shadow is FIRST here and second on the
      // subject card. Read as-is, not normalised.
      const card = [
        FigmaShadow(
          color: black25,
          offset: Offset(0.528485, 0),
          blur: 1.06103,
          spread: -0.530516,
        ),
        FigmaShadow(color: black25, offset: Offset(0, 0.530516), blur: 1.59155),
      ];
      expect(light.mistakesCardShadows, card); // 404:6322
      expect(dark.mistakesCardShadows, card); // 404:7637
      expect(dark.mistakesCardGlass, g5);
      expect(dark.treeRowBadgeGlass, g5); // 337:5926
    });

    test('the segmented pill track inverts its inner shadow when selected', () {
      expect(light.pillTrackInsetShadows, isEmpty);
      expect(light.pillTrackSelectedInsetShadows, isEmpty);
      expect(dark.pillTrackInsetShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0, -3),
          blur: 4,
          inset: true,
        ),
      ]); // 337:8177
      expect(dark.pillTrackSelectedInsetShadows, const [
        FigmaShadow(color: black25, offset: Offset(0, 4), blur: 4, inset: true),
      ]);
      // The sign flip is the effect: a raised pill inside a sunken groove.
      expect(dark.pillTrackInsetShadows.single.offset.dy, lessThan(0));
      expect(
        dark.pillTrackSelectedInsetShadows.single.offset.dy,
        greaterThan(0),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('edit4 — quiz, result, review, leaderboard', () {
    test('the five near-identical small shadows stay five tokens', () {
      // edit1.md #39. Same offset, five blurs. Normalising them to one would
      // be the tidiest possible way to lose a design.
      expect(light.reviewFilterIdleShadows.single.blur, 1.5); // 162:2782
      expect(light.leaderboardListShadows.single.blur, 1.6); // 133:3117
      expect(light.resultBucketShadows.single.blur, 2); // 159:2289
      expect(light.lengthChipShadows.single.blur, 2.3); // 146:2315
      expect(light.aiPanelCardShadows.single.blur, 3); // 159:1825

      for (final s in [
        light.reviewFilterIdleShadows,
        light.leaderboardListShadows,
        light.resultBucketShadows,
        light.lengthChipShadows,
        light.aiPanelCardShadows,
      ]) {
        expect(s.single.offset, const Offset(0.02, 0.02));
        expect(s.single.color, black25);
      }
    });

    test('length chips, AI panel and leaderboard list keep dark shadows', () {
      expect(dark.lengthChipShadows, light.lengthChipShadows); // 337:6289
      expect(dark.aiPanelCardShadows, light.aiPanelCardShadows); // 337:9278
      expect(dark.leaderboardListShadows, light.leaderboardListShadows);
    });

    test('AI panel: G18 outside, G5 inside, one back-light', () {
      expect(dark.aiPanelGlass!.frost, 33); // G18, 337:9270
      expect(dark.aiPanelCardGlass, g5); // 337:9279
      expect(dark.aiPanelBacklight!.offset, const Offset(5, 11.02)); // B5
      expect(dark.aiPanelBacklight!.size, const Size(100, 14));
    });

    test('quiz previous button: G13 confirms the angle convention', () {
      expect(light.quizPrevButtonShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0.02833, 0.02833),
          blur: 1.3,
        ),
      ]);
      expect(dark.quizPrevButtonShadows, isEmpty); // 337:6464
      expect(
        dark.quizPrevButtonGlass,
        const GlassStyle(
          frost: 45,
          refraction: 0.63,
          depth: 17,
          lightAngle: 51,
          lightIntensity: 0.80,
          dispersion: 0.50,
          splay: 0.48,
        ),
      );
      expect(light.quizQuestionCardBorderWidth, 0.5);
      expect(dark.quizQuestionCardBorderWidth, 0.2);
    });

    test('result buckets, rewards card and star disc', () {
      expect(dark.resultBucketShadows, isEmpty); // 337:6667
      expect(dark.resultBucketGlass, g5);
      expect(light.rewardsCardShadows, const [
        FigmaShadow(color: black25, offset: Offset(0.5, 0.5), blur: 4),
      ]); // 159:2252
      expect(dark.rewardsCardShadows, isEmpty); // 337:6680
      expect(dark.rewardsCardGlass!.frost, 54); // G14
      expect(dark.rewardsCardBacklight!.offset, const Offset(5, 11.83)); // B6
      expect(dark.resultStarDiscGlass, g5); // 337:6685
      expect(dark.reviewFilterIdleShadows, isEmpty); // 337:6827
      expect(dark.reviewFilterIdleGlass, g5);
    });

    test('the scope toggle is the file\'s only white inner shadow', () {
      expect(light.scopeTrackInsetShadows, isEmpty);
      expect(dark.scopeTrackInsetShadows, const [
        FigmaShadow(
          color: Color.fromRGBO(207, 179, 255, 0.1),
          offset: Offset(6, 1),
          blur: 4,
          inset: true,
        ),
        FigmaShadow(
          color: black25,
          offset: Offset(0, -2),
          blur: 4,
          inset: true,
        ),
      ]); // 337:5615
      expect(dark.scopeSelectedInsetShadows, const [
        FigmaShadow(
          color: Color.fromRGBO(255, 255, 255, 0.6),
          offset: Offset(1, -2),
          blur: 2,
          inset: true,
        ),
        FigmaShadow(color: black25, offset: Offset(0, 3), blur: 2, inset: true),
      ]);
      // Every one of them is an INNER shadow, which is the whole distinction
      // #34 rests on: no dark DROP shadow in the file is white or cream.
      for (final s in [
        ...dark.scopeTrackInsetShadows,
        ...dark.scopeSelectedInsetShadows,
      ]) {
        expect(s.inset, isTrue);
      }
    });

    test('a leaderboard row carries two different Glass effects', () {
      expect(dark.leaderboardRowGlass, g5); // 337:5630 rectangle
      expect(
        dark.leaderboardRowGroupGlass,
        const GlassStyle(
          frost: 4,
          refraction: 0.80,
          depth: 20,
          lightAngle: -45,
          lightIntensity: 0.80,
          dispersion: 0.50,
          splay: 0.31,
        ),
      ); // G10, the group at 337:5629
      expect(dark.leaderboardRowGlass, isNot(dark.leaderboardRowGroupGlass));
    });
  });

  // -------------------------------------------------------------------------
  group('edit5 — profile, settings, OTP, track card', () {
    test('profile header, edit chip and stat card keep a dark shadow', () {
      const header = [
        FigmaShadow(color: black25, offset: Offset(0.5, 0.5), blur: 4),
      ];
      expect(light.profileHeaderShadows, header); // 169:4609
      expect(dark.profileHeaderShadows, header); // 337:7455
      expect(dark.profileHeaderGlass!.frost, 57); // G15
      expect(dark.profileHeaderBacklight!.offset, const Offset(4, 11)); // B7

      const chip = [
        FigmaShadow(
          color: black25,
          offset: Offset(0.02833, 0.02833),
          blur: 1.3,
        ),
      ];
      expect(light.profileEditChipShadows, chip);
      expect(dark.profileEditChipShadows, chip); // 337:7466
      expect(dark.profileEditChipGlass, g5);

      const stat = [
        FigmaShadow(color: black25, offset: Offset(0.02, 0.02), blur: 2),
      ];
      expect(light.profileStatShadows, stat); // 661:8571
      expect(dark.profileStatShadows, stat); // 661:8579
      expect(dark.profileMenuRowGlass, g5);
      expect(dark.profileMenuIconDiscGlass, g5);
    });

    test('avatar badge', () {
      const badge = [
        FigmaShadow(
          color: black25,
          offset: Offset(0.0240833, 0.0240833),
          blur: 1.105,
        ),
      ];
      expect(light.avatarBadgeShadows, badge); // 180:3989
      expect(dark.avatarBadgeShadows, badge); // 337:7925
      expect(dark.avatarBadgeGlass, g5);
    });

    test('settings sections and their two back-lights', () {
      expect(light.settingsSectionBorderWidth, 0.5);
      expect(dark.settingsSectionBorderWidth, 0);
      expect(dark.settingsSectionGlass!.frost, 63); // G16
      expect(
        dark.notificationPreferencesBacklightSchool!.offset,
        const Offset(0, 33),
      ); // B8 — the one flush with the start edge
      expect(
        dark.notificationPreferencesBacklightUniversity!.offset,
        const Offset(0, 27),
      ); // B15
    });

    test('OTP: the timer inset and the one lavender drop shadow', () {
      expect(light.otpTimerInsetShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0, -1),
          blur: 4,
          inset: true,
        ),
      ]); // 332:3391
      expect(dark.otpTimerInsetShadows, const [
        FigmaShadow(
          color: Color.fromRGBO(198, 198, 198, 0.25),
          offset: Offset(-0.5, 0.5),
          blur: 1.2,
          inset: true,
        ),
      ]); // 337:19503

      expect(light.otpCardShadows, const [
        FigmaShadow(color: black25, offset: Offset(0.2, 0.2), blur: 4),
      ]); // 308:5114
      expect(dark.otpCardShadows, [
        FigmaShadow(
          color: AppColors.dark.otpCardGlow!,
          offset: const Offset(0.2, 0.2),
          blur: 7.9,
        ),
      ]); // 337:19501
      expect(
        dark.otpCardShadows.single.color,
        AppColors.dark.otpCardGlow,
        reason: 'the colour comes from the palette, not a second copy of it',
      );

      expect(light.otpDigitBorderWidth, 1.17333);
      expect(dark.otpDigitBorderWidth, 0.5);
      expect(dark.otpDigitGlass!.depth, 100); // G19 — the file's deepest
      expect(dark.otpDigitGlass!.dispersion, 0.65);
    });

    test('the two track cards carry two different Glass angles', () {
      expect(light.trackCardShadows, const [
        FigmaShadow(color: black25, offset: Offset(0.5, 0.5), blur: 4),
      ]); // 125:862
      expect(dark.trackCardShadows, isEmpty); // 337:15981
      expect(dark.trackCardGlassFirst!.lightAngle, 25); // G20
      expect(dark.trackCardGlassSecond, g5); // I337:15982;125:727
    });
  });

  // -------------------------------------------------------------------------
  group('API→UI Wave 22 — flashcards', () {
    test('the card is one INNER shadow, the same on both canvases', () {
      // `247:3260` (light) and `337:14513` (dark) both read INNER_SHADOW
      // #000000 @ 25%, offset (0, -1), blur 5.4, spread 0. The card stays
      // cream on the dark canvas, so nothing about its shadow flips.
      const inner = [
        FigmaShadow(
          color: black25,
          offset: Offset(0, -1),
          blur: 5.4,
          inset: true,
        ),
      ];
      expect(light.flashcardCardShadows, inner);
      expect(dark.flashcardCardShadows, inner);
      expect(light.flashcardCardShadows.single.inset, isTrue);
    });

    test('it is wired through copyWith and lerp', () {
      const probe = [
        FigmaShadow(color: black25, offset: Offset(9, 9), blur: 9),
      ];
      final one = light.copyWith(flashcardCardShadows: probe);
      expect(one.flashcardCardShadows, probe);
      expect(one.trackCardShadows, light.trackCardShadows);

      // Both canvases hold the same value, so light→dark would pass with a
      // lerp that ignored the token. Lerp towards a probe instead.
      final target = light.copyWith(flashcardCardShadows: const []);
      expect(light.lerp(target, 1).flashcardCardShadows, isEmpty);
      expect(light.lerp(target, 0).flashcardCardShadows, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('CW07a — the notifications inbox', () {
    test('light: two INNER shadows, no Glass (180:8743, 180:8557)', () {
      expect(light.notificationRowShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0, -0.5),
          blur: 2.5,
          inset: true,
        ),
      ]);
      expect(light.notificationChipIdleShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0, -1),
          blur: 3.3,
          inset: true,
        ),
      ]);
      expect(light.notificationRowGlass, isNull);
      expect(light.notificationDiscGlass, isNull);
      expect(light.notificationChipIdleGlass, isNull);
    });

    test('dark: no shadow and Glass G5 on all three - stand-ins, no dark '
        'frame exists (DG-35)', () {
      expect(dark.notificationRowShadows, isEmpty);
      expect(dark.notificationChipIdleShadows, isEmpty);
      expect(dark.notificationRowGlass, g5);
      expect(dark.notificationDiscGlass, g5);
      expect(dark.notificationChipIdleGlass, g5);
    });

    test('every one is wired through copyWith and lerp', () {
      const probeShadows = [
        FigmaShadow(color: black25, offset: Offset(9, 9), blur: 9),
      ];
      const probeGlass = GlassStyle(
        frost: 9,
        refraction: 0.1,
        depth: 9,
        lightAngle: 9,
        lightIntensity: 0.9,
        dispersion: 0.9,
        splay: 9,
      );
      final one = light.copyWith(
        notificationRowShadows: probeShadows,
        notificationChipIdleShadows: probeShadows,
        notificationRowGlass: probeGlass,
        notificationDiscGlass: probeGlass,
        notificationChipIdleGlass: probeGlass,
      );
      expect(one.notificationRowShadows, probeShadows);
      expect(one.notificationChipIdleShadows, probeShadows);
      expect(one.notificationRowGlass, probeGlass);
      expect(one.notificationDiscGlass, probeGlass);
      expect(one.notificationChipIdleGlass, probeGlass);
      // …and a neighbour is left alone.
      expect(one.flashcardCardShadows, light.flashcardCardShadows);

      // Light and dark differ in every one, so a lerp that ignored a token
      // would leave it at the start value.
      final end = light.lerp(dark, 1);
      expect(end.notificationRowGlass, g5);
      expect(end.notificationDiscGlass, g5);
      expect(end.notificationChipIdleGlass, g5);
      expect(end.notificationRowShadows, isEmpty);
      expect(end.notificationChipIdleShadows, isEmpty);
      final start = light.lerp(dark, 0);
      expect(start.notificationRowGlass, isNull);
      expect(start.notificationRowShadows, light.notificationRowShadows);
      expect(
        start.notificationChipIdleShadows,
        light.notificationChipIdleShadows,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('CW12a — the support tickets screens', () {
    const black13 = Color.fromRGBO(0, 0, 0, 0.13);

    test('light: three DROP and three INNER shadows, no Glass '
        '(178:3052, 178:3066, 178:3104, 178:3333, 178:3467, 178:3468)', () {
      expect(light.supportCreateCardShadows, const [
        FigmaShadow(color: black25, offset: Offset(0.5, 0.5), blur: 4),
      ]);
      expect(light.supportAddButtonShadows, const [
        FigmaShadow(color: black25, offset: Offset(0.028, 0.028), blur: 1.3),
      ]);
      expect(light.supportRowShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0.02, 0.02),
          blur: 2.8,
          inset: true,
        ),
      ]);
      expect(light.supportFieldSectionShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0.2, 0.2),
          blur: 3.4,
          inset: true,
        ),
      ]);
      expect(light.supportInputShadows, const [
        FigmaShadow(
          color: black25,
          offset: Offset(0, 0),
          blur: 3.3,
          inset: true,
        ),
      ]);
      // The composer bar sits at the bottom, so its drop shadow points UP.
      //
      // Both composer shadows are exported as CSS drop-shadow FILTERS
      // (`drop-shadow-[0px_-1px_1.85px…]`, `drop-shadow-[0.2px_0.2px_0.8px…]`),
      // whose third value is half the Figma blur: the primary CTA is blur 4 and
      // node 348:8911 exports it as `drop-shadow-[0.5px_0.5px_2px]`. So the
      // blurs are 2 x 1.85 = 3.7 and 2 x 0.8 = 1.6. The other support shadows
      // are box-shadows (`shadow-[…]`) and stay 1:1.
      expect(light.primaryCtaShadows.single.blur, 4);
      expect(light.supportComposerBarShadows, const [
        FigmaShadow(color: black10, offset: Offset(0, -1), blur: 3.7),
      ]);
      expect(light.supportComposerFieldShadows, const [
        FigmaShadow(color: black13, offset: Offset(0.2, 0.2), blur: 1.6),
      ]);
      expect(light.supportCreateCardGlass, isNull);
      expect(light.supportRowGlass, isNull);
      expect(light.supportFieldSectionGlass, isNull);
      expect(light.supportComposerBarGlass, isNull);
    });

    test('the three inner shadows are inset, the four others are not', () {
      for (final s in [
        ...light.supportRowShadows,
        ...light.supportFieldSectionShadows,
        ...light.supportInputShadows,
      ]) {
        expect(s.inset, isTrue);
      }
      for (final s in [
        ...light.supportCreateCardShadows,
        ...light.supportAddButtonShadows,
        ...light.supportComposerBarShadows,
        ...light.supportComposerFieldShadows,
      ]) {
        expect(s.inset, isFalse);
      }
    });

    test('dark: no shadow anywhere and Glass G5 on the four surfaces that '
        'have a token - stand-ins, no dark frame exists', () {
      expect(dark.supportCreateCardShadows, isEmpty);
      expect(dark.supportAddButtonShadows, isEmpty);
      expect(dark.supportRowShadows, isEmpty);
      expect(dark.supportFieldSectionShadows, isEmpty);
      expect(dark.supportInputShadows, isEmpty);
      expect(dark.supportComposerBarShadows, isEmpty);
      expect(dark.supportComposerFieldShadows, isEmpty);
      expect(dark.supportCreateCardGlass, g5);
      expect(dark.supportRowGlass, g5);
      expect(dark.supportFieldSectionGlass, g5);
      expect(dark.supportComposerBarGlass, g5);
    });

    test('every one is wired through copyWith and lerp', () {
      const probeShadows = [
        FigmaShadow(color: black25, offset: Offset(9, 9), blur: 9),
      ];
      const probeGlass = GlassStyle(
        frost: 9,
        refraction: 0.1,
        depth: 9,
        lightAngle: 9,
        lightIntensity: 0.9,
        dispersion: 0.9,
        splay: 9,
      );
      final one = light.copyWith(
        supportCreateCardShadows: probeShadows,
        supportCreateCardGlass: probeGlass,
        supportAddButtonShadows: probeShadows,
        supportRowShadows: probeShadows,
        supportRowGlass: probeGlass,
        supportFieldSectionShadows: probeShadows,
        supportFieldSectionGlass: probeGlass,
        supportInputShadows: probeShadows,
        supportComposerBarShadows: probeShadows,
        supportComposerBarGlass: probeGlass,
        supportComposerFieldShadows: probeShadows,
      );
      expect(one.supportCreateCardShadows, probeShadows);
      expect(one.supportCreateCardGlass, probeGlass);
      expect(one.supportAddButtonShadows, probeShadows);
      expect(one.supportRowShadows, probeShadows);
      expect(one.supportRowGlass, probeGlass);
      expect(one.supportFieldSectionShadows, probeShadows);
      expect(one.supportFieldSectionGlass, probeGlass);
      expect(one.supportInputShadows, probeShadows);
      expect(one.supportComposerBarShadows, probeShadows);
      expect(one.supportComposerBarGlass, probeGlass);
      expect(one.supportComposerFieldShadows, probeShadows);
      // …and a neighbour is left alone.
      expect(one.notificationRowShadows, light.notificationRowShadows);
      expect(one.flashcardCardShadows, light.flashcardCardShadows);

      // Light and dark differ in every one, so a lerp that ignored a token
      // would leave it at the start value.
      final end = light.lerp(dark, 1);
      expect(end.supportCreateCardGlass, g5);
      expect(end.supportRowGlass, g5);
      expect(end.supportFieldSectionGlass, g5);
      expect(end.supportComposerBarGlass, g5);
      expect(end.supportCreateCardShadows, isEmpty);
      expect(end.supportAddButtonShadows, isEmpty);
      expect(end.supportRowShadows, isEmpty);
      expect(end.supportFieldSectionShadows, isEmpty);
      expect(end.supportInputShadows, isEmpty);
      expect(end.supportComposerBarShadows, isEmpty);
      expect(end.supportComposerFieldShadows, isEmpty);
      final start = light.lerp(dark, 0);
      expect(start.supportRowGlass, isNull);
      expect(start.supportCreateCardShadows, light.supportCreateCardShadows);
      expect(start.supportRowShadows, light.supportRowShadows);
      expect(start.supportInputShadows, light.supportInputShadows);
      expect(start.supportComposerBarShadows, light.supportComposerBarShadows);
    });
  });

  // -------------------------------------------------------------------------
  /// Every shadow-list token, by name, so the sweeps below cannot quietly miss
  /// one that was added to the class after they were written.
  Map<String, List<FigmaShadow>> shadowsOf(AppElevation e) => {
    'navBarShadows': e.navBarShadows,
    'primaryCtaShadows': e.primaryCtaShadows,
    'outlineCtaShadows': e.outlineCtaShadows,
    'backChipShadows': e.backChipShadows,
    'onboardingSheetShadows': e.onboardingSheetShadows,
    'levelCardShadows': e.levelCardShadows,
    'continueLearningShadows': e.continueLearningShadows,
    'subjectSearchShadows': e.subjectSearchShadows,
    'subjectCardShadows': e.subjectCardShadows,
    'mistakesPillShadows': e.mistakesPillShadows,
    'mistakesCardShadows': e.mistakesCardShadows,
    'pillTrackInsetShadows': e.pillTrackInsetShadows,
    'pillTrackSelectedInsetShadows': e.pillTrackSelectedInsetShadows,
    'lengthChipShadows': e.lengthChipShadows,
    'aiPanelCardShadows': e.aiPanelCardShadows,
    'quizPrevButtonShadows': e.quizPrevButtonShadows,
    'resultBucketShadows': e.resultBucketShadows,
    'rewardsCardShadows': e.rewardsCardShadows,
    'reviewFilterIdleShadows': e.reviewFilterIdleShadows,
    'scopeTrackInsetShadows': e.scopeTrackInsetShadows,
    'scopeSelectedInsetShadows': e.scopeSelectedInsetShadows,
    'leaderboardListShadows': e.leaderboardListShadows,
    'profileHeaderShadows': e.profileHeaderShadows,
    'profileEditChipShadows': e.profileEditChipShadows,
    'profileStatShadows': e.profileStatShadows,
    'avatarBadgeShadows': e.avatarBadgeShadows,
    'otpTimerInsetShadows': e.otpTimerInsetShadows,
    'otpCardShadows': e.otpCardShadows,
    'trackCardShadows': e.trackCardShadows,
    'flashcardCardShadows': e.flashcardCardShadows,
    'notificationRowShadows': e.notificationRowShadows,
    'notificationChipIdleShadows': e.notificationChipIdleShadows,
    'supportCreateCardShadows': e.supportCreateCardShadows,
    'supportAddButtonShadows': e.supportAddButtonShadows,
    'supportRowShadows': e.supportRowShadows,
    'supportFieldSectionShadows': e.supportFieldSectionShadows,
    'supportInputShadows': e.supportInputShadows,
    'supportComposerBarShadows': e.supportComposerBarShadows,
    'supportComposerFieldShadows': e.supportComposerFieldShadows,
  };

  group('#34 — the dark canvas drops BLACK shadows, never cream', () {
    test('every dark DROP shadow is black except the two glows', () {
      // edit1.md §5.3: thirteen dark nodes were measured and all are black at
      // the light alpha. The only non-black dark drop shadows in the file are
      // two deliberate coloured glows.
      const glows = {'navBarShadows', 'otpCardShadows'};

      shadowsOf(dark).forEach((name, shadows) {
        for (final s in shadows) {
          if (s.inset || glows.contains(name)) continue;
          expect(
            [s.color.r, s.color.g, s.color.b],
            [0.0, 0.0, 0.0],
            reason: '$name is not black on the dark canvas',
          );
        }
      });
    });

    test('the withdrawn cream appears in no token, on either canvas', () {
      // The derivation #34 overturned: `AppColors.dark.elevationShadow` was
      // this cream, and the token was deleted on 2026-09-20 with its last
      // call site. The hex is written out here rather than imported, because
      // this test is the only reason the value still needs to exist at all -
      // if it ever shows up in a token again, the ruling has been silently
      // reversed.
      const cream = Color(0xFFFCFBF9);
      for (final palette in [shadowsOf(light), shadowsOf(dark)]) {
        palette.forEach((name, shadows) {
          for (final s in shadows) {
            expect(
              [s.color.r, s.color.g, s.color.b],
              isNot([cream.r, cream.g, cream.b]),
              reason: '$name paints the withdrawn cream',
            );
          }
        });
      }
    });

    test('a dark token with no shadow is a reading, not a gap', () {
      // Eight components elevate in dark with Glass INSTEAD of a shadow. If a
      // later edit "restores" one of these, it is inventing.
      for (final empty in [
        dark.backChipShadows,
        dark.levelCardShadows,
        dark.subjectSearchShadows,
        dark.quizPrevButtonShadows,
        dark.resultBucketShadows,
        dark.rewardsCardShadows,
        dark.reviewFilterIdleShadows,
        dark.trackCardShadows,
      ]) {
        expect(empty, isEmpty);
      }
    });
  });

  // -------------------------------------------------------------------------
  group('Glass is a dark-canvas mechanism', () {
    /// Every Glass token by name.
    Map<String, GlassStyle?> glassOf(AppElevation e) => {
      'backChipGlass': e.backChipGlass,
      'registrationBackChipGlass': e.registrationBackChipGlass,
      'languagePillGlass': e.languagePillGlass,
      'fieldGlass': e.fieldGlass,
      'onboardingSheetGlass': e.onboardingSheetGlass,
      'levelCardGlass': e.levelCardGlass,
      'dailyTasksGlass': e.dailyTasksGlass,
      'topStudentGlass': e.topStudentGlass,
      'homeBellGlass': e.homeBellGlass,
      'subjectSearchGlass': e.subjectSearchGlass,
      'mistakesPillGlass': e.mistakesPillGlass,
      'mistakesCardGlass': e.mistakesCardGlass,
      'treeRowBadgeGlass': e.treeRowBadgeGlass,
      'aiPanelGlass': e.aiPanelGlass,
      'aiPanelCardGlass': e.aiPanelCardGlass,
      'quizPrevButtonGlass': e.quizPrevButtonGlass,
      'resultBucketGlass': e.resultBucketGlass,
      'rewardsCardGlass': e.rewardsCardGlass,
      'resultStarDiscGlass': e.resultStarDiscGlass,
      'reviewFilterIdleGlass': e.reviewFilterIdleGlass,
      'leaderboardRowGlass': e.leaderboardRowGlass,
      'leaderboardRowGroupGlass': e.leaderboardRowGroupGlass,
      'profileHeaderGlass': e.profileHeaderGlass,
      'profileEditChipGlass': e.profileEditChipGlass,
      'profileMenuRowGlass': e.profileMenuRowGlass,
      'profileMenuIconDiscGlass': e.profileMenuIconDiscGlass,
      'avatarBadgeGlass': e.avatarBadgeGlass,
      'settingsSectionGlass': e.settingsSectionGlass,
      'otpDigitGlass': e.otpDigitGlass,
      'trackCardGlassFirst': e.trackCardGlassFirst,
      'trackCardGlassSecond': e.trackCardGlassSecond,
      'notificationRowGlass': e.notificationRowGlass,
      'notificationDiscGlass': e.notificationDiscGlass,
      'notificationChipIdleGlass': e.notificationChipIdleGlass,
      'supportCreateCardGlass': e.supportCreateCardGlass,
      'supportRowGlass': e.supportRowGlass,
      'supportFieldSectionGlass': e.supportFieldSectionGlass,
      'supportComposerBarGlass': e.supportComposerBarGlass,
    };

    test('the onboarding sheet is the ONLY light Glass', () {
      glassOf(light).forEach((name, glass) {
        if (name == 'onboardingSheetGlass') {
          expect(glass, isNotNull);
        } else {
          expect(glass, isNull, reason: '$name should have no Glass in light');
        }
      });
    });

    test('every dark surface that Figma glassed has a token', () {
      glassOf(dark).forEach((name, glass) {
        expect(glass, isNotNull, reason: '$name lost its dark Glass');
      });
    });

    test('every back-light is dark-only and takes the palette colour', () {
      final backlights = <String, Backlight?>{
        'levelCardSchool': dark.levelCardBacklightSchool,
        'levelCardUniversity': dark.levelCardBacklightUniversity,
        'dailyTasksSchool': dark.dailyTasksBacklightSchool,
        'dailyTasksUniversity': dark.dailyTasksBacklightUniversity,
        'topStudentSchool': dark.topStudentBacklightSchool,
        'aiPanel': dark.aiPanelBacklight,
        'rewardsCard': dark.rewardsCardBacklight,
        'profileHeader': dark.profileHeaderBacklight,
        'notificationPreferencesSchool':
            dark.notificationPreferencesBacklightSchool,
        'notificationPreferencesUniversity':
            dark.notificationPreferencesBacklightUniversity,
      };
      expect(backlights.length, 10, reason: 'ten of the sixteen are built');

      backlights.forEach((name, b) {
        expect(b, isNotNull, reason: '$name lost its back-light');
        expect(b!.color, AppColors.dark.backlight);
      });

      for (final b in [
        light.levelCardBacklightSchool,
        light.dailyTasksBacklightSchool,
        light.aiPanelBacklight,
        light.profileHeaderBacklight,
        light.notificationPreferencesBacklightSchool,
      ]) {
        expect(b, isNull, reason: 'no light frame has a back-light');
      }
    });
  });

  // -------------------------------------------------------------------------
  group('the extension is wired in all four places', () {
    test('props covers every field', () {
      // The guard on `==`/`hashCode`: a token added to the class but forgotten
      // in `props` would make two different AppElevations compare equal.
      expect(
        // 84 until 2026-09-20, when edit4 added `quizPrevButtonRadius` (the
        // previous button's radius differs per canvas) and `reviewRowGlass`.
        // 87 from API→UI Wave 11: `quizSetupDividerWidth` (1.18 / 0.5).
        // 88 from API→UI Wave 22: `flashcardCardShadows`.
        // 93 from CW07a: the inbox's row and idle-chip shadows and the three
        // Glass tokens (row, disc, idle chip).
        // 104 from CW12a: the support screens' seven shadow lists and four
        // Glass tokens (create card, row, field section, composer bar).
        light.props.length,
        104,
        reason:
            'a token was added or removed. Update props (and this count) so '
            'equality keeps covering every field.',
      );
      expect(dark.props.length, light.props.length);
    });

    test('copyWith round-trips, and leaves the others alone', () {
      const probe = [
        FigmaShadow(color: black25, offset: Offset(9, 9), blur: 9),
      ];
      final one = light.copyWith(profileStatShadows: probe);
      expect(one.profileStatShadows, probe);
      expect(one.profileHeaderShadows, light.profileHeaderShadows);
      expect(one.otpDigitBorderWidth, light.otpDigitBorderWidth);

      expect(light.copyWith(otpDigitBorderWidth: 3).otpDigitBorderWidth, 3);
      expect(light.copyWith(fieldGlass: g5).fieldGlass, g5);
    });

    test('lerp endpoints are exact', () {
      expect(light.lerp(dark, 0), light);
      expect(light.lerp(dark, 1), dark);
    });

    test('lerp actually moves, and snaps what cannot be interpolated', () {
      final mid = light.lerp(dark, 0.5);

      // A number lerps.
      expect(
        mid.fieldBorderWidth,
        closeTo((1.17338 + 0.03) / 2, 1e-9),
        reason: 'a token missing from lerp silently stops animating',
      );
      // A same-length list lerps element-wise.
      expect(mid.navBarShadows.single.blur, closeTo((16.08 + 12.5) / 2, 1e-9));
      // A different-length list snaps to the far side at the midpoint.
      expect(mid.levelCardShadows, dark.levelCardShadows);
      // A nullable mechanism snaps rather than half-existing.
      expect(mid.levelCardGlass, dark.levelCardGlass);
      expect(light.lerp(dark, 0.49).levelCardGlass, isNull);
    });

    test('lerp ignores a foreign extension, as ThemeExtension requires', () {
      expect(light.lerp(null, 0.5), light);
    });

    test('equality is by value, not by identity', () {
      expect(light.copyWith(), light);
      expect(light.copyWith().hashCode, light.hashCode);
      expect(light, isNot(dark));
    });

    test('both ThemeData objects carry it', () {
      expect(
        AppTheme.light.extension<AppElevation>(),
        same(AppElevation.light),
      );
      expect(AppTheme.dark.extension<AppElevation>(), same(AppElevation.dark));
    });
  });
}
