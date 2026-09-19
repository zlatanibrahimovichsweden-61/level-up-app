import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';

/// The four Day-00 tokens, and the one rule about them that is easy to break
/// silently: a token missing from `lerp` does not fail to compile — it just
/// stops animating when the theme changes, and nobody notices for months.
void main() {
  group('Day-00 tokens are wired in all four places', () {
    test('light and dark both define them', () {
      // `copyWith`/`lerp` below would not compile if the constructor were
      // missing a field, so declaring them here covers the first two places.
      for (final palette in [AppColors.light, AppColors.dark]) {
        expect(
          palette.sheetFill.a,
          closeTo(0.2, 0.01),
          reason: 'sheetFill is a 20% wash',
        );
        expect(palette.accentSoft.a, 1.0);
        expect(palette.bodyMuted.a, 1.0);
        expect(palette.successBadge.a, 1.0);
      }
    });

    test('copyWith round-trips each of them', () {
      const probe = Color(0xFF010203);

      expect(AppColors.light.copyWith(sheetFill: probe).sheetFill, probe);
      expect(AppColors.light.copyWith(accentSoft: probe).accentSoft, probe);
      expect(AppColors.light.copyWith(bodyMuted: probe).bodyMuted, probe);
      expect(AppColors.light.copyWith(successBadge: probe).successBadge, probe);

      // …and leaves the others alone.
      final one = AppColors.light.copyWith(sheetFill: probe);
      expect(one.accentSoft, AppColors.light.accentSoft);
      expect(one.background, AppColors.light.background);
    });

    test(
      'lerp moves each of them — a missing entry would pin one in place',
      () {
        final mid = AppColors.light.lerp(AppColors.dark, 0.5);

        expect(
          mid.sheetFill,
          Color.lerp(AppColors.light.sheetFill, AppColors.dark.sheetFill, 0.5),
        );
        expect(
          mid.accentSoft,
          Color.lerp(
            AppColors.light.accentSoft,
            AppColors.dark.accentSoft,
            0.5,
          ),
        );
        expect(
          mid.bodyMuted,
          Color.lerp(AppColors.light.bodyMuted, AppColors.dark.bodyMuted, 0.5),
        );

        // The three that differ between palettes must actually MOVE at t=0.5 —
        // this is what catches a token that was added to the constructor but
        // forgotten in lerp (it would sit on the light value forever).
        expect(mid.accentSoft, isNot(AppColors.light.accentSoft));
        expect(mid.bodyMuted, isNot(AppColors.light.bodyMuted));

        expect(mid.sheetFill, isNot(AppColors.light.sheetFill));
      },
    );

    test('lerp endpoints are exact', () {
      expect(
        AppColors.light.lerp(AppColors.dark, 1).accentSoft,
        AppColors.dark.accentSoft,
      );
      expect(
        AppColors.light.lerp(AppColors.dark, 0).accentSoft,
        AppColors.light.accentSoft,
      );
    });
  });

  // The Mistakes tokens once shipped with dark == light, on an observation of
  // the dark frames that was never measured and turned out to be wrong
  // (docs/DESIGN_ISSUES.md #70). Every value pinned here is read off a Figma
  // Properties panel. Pinning them is what stops a later tidy-up from quietly
  // carrying the light values across again.
  group('Mistakes tokens follow the dark frames and leave light alone', () {
    test('light is unchanged by the dark correction', () {
      final light = AppColors.light;

      expect(light.mistakesCardFill, const Color(0xFFEAD5D5)); // 404:6322
      expect(light.mistakesRowFill, const Color(0xFFEAD5D5)); // 404:6642
      expect(light.mistakesContent, const Color(0xFF384F47)); // 404:6329
      expect(light.mistakesCount, const Color(0xFFEF4444)); // 404:6338
      expect(light.mistakesRowBorder, const Color(0xFF4B675E)); // 404:6642
      // The light disc was never read; it keeps what the badge shipped with.
      expect(light.mistakesBadgeFill, light.cardFill);
    });

    test('dark is the 404:7428 family, not the light values', () {
      final dark = AppColors.dark;

      expect(dark.mistakesCardFill, const Color(0x4D27282C)); // 404:7637
      expect(dark.mistakesRowFill, const Color(0xFF27282C)); // 404:7765
      expect(dark.mistakesContent, const Color(0xFFFCFBF9)); // 404:7771
      expect(dark.mistakesCount, const Color(0xFFEF4444)); // 404:7884
      expect(dark.mistakesRowBorder, const Color(0xFFFCFBF9)); // 404:7765
      expect(dark.mistakesBadgeFill, const Color(0x3327282C)); // 404:7767

      // The specific regression: no pink ground in dark.
      expect(dark.mistakesCardFill, isNot(AppColors.light.mistakesCardFill));
      expect(dark.mistakesRowFill, isNot(AppColors.light.mistakesRowFill));
    });

    test('the two new tokens are wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);

      expect(
        AppColors.light.copyWith(mistakesRowFill: probe).mistakesRowFill,
        probe,
      );
      expect(
        AppColors.light.copyWith(mistakesBadgeFill: probe).mistakesBadgeFill,
        probe,
      );

      // Every Mistakes token that differs between palettes must MOVE at 0.5.
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);
      expect(mid.mistakesCardFill, isNot(AppColors.light.mistakesCardFill));
      expect(mid.mistakesRowFill, isNot(AppColors.light.mistakesRowFill));
      expect(mid.mistakesContent, isNot(AppColors.light.mistakesContent));
      expect(mid.mistakesRowBorder, isNot(AppColors.light.mistakesRowBorder));
      expect(mid.mistakesBadgeFill, isNot(AppColors.light.mistakesBadgeFill));
    });
  });

  group('successBadge', () {
    test(
      'is identical in both palettes — it must not follow the accent flip',
      () {
        // The bug this exists to prevent: the badge used to be tinted with
        // colorScheme.primary, which is green in light and PURPLE in dark. A
        // success signal is semantic, not decorative.
        expect(AppColors.light.successBadge, AppColors.dark.successBadge);
        expect(
          AppColors.light.successBadge,
          isNot(AppColors.light.accentSoft),
          reason: 'successBadge must not be an accent',
        );
        expect(AppColors.dark.successBadge, isNot(Brand.purplePrimary));
        expect(AppColors.light.successBadge, isNot(Brand.greenPrimary));
      },
    );

    test('equals the fill in the exported SVG — not an estimate', () {
      // There is no green anywhere in the Figma file's variables (the only bound
      // variable on the success frame is White #FFFFFF), so the token's value
      // came out of the asset. This asserts the two have not drifted: if the
      // designer re-exports 82:1598 with a different green, this fails instead
      // of the badge quietly disagreeing with the palette.
      final svg = File('assets/images/success_badge.svg').readAsStringSync();

      final fills = RegExp(
        r'fill="(#[0-9A-Fa-f]{6})"',
      ).allMatches(svg).map((m) => m.group(1)!.toUpperCase()).toSet();

      expect(fills, contains('#22C55E'));
      expect(
        AppColors.light.successBadge,
        const Color(0xFF22C55E),
        reason: 'token must match the SVG fill',
      );
    });

    test('the badge keeps its white checkmark — so it is never srcIn-tinted', () {
      // Documents why the screen renders the asset unfiltered: it is a TWO
      // colour mark. Any single-colour ColorFilter would flatten the check into
      // the scallop and leave a green blob.
      final svg = File('assets/images/success_badge.svg').readAsStringSync();

      expect(svg, contains('fill="white"'));
    });
  });

  test('the OTP stopwatch export is stroked in the light primary', () {
    // DESIGN_ISSUES #49. The resend-timer pill tints the glyph with
    // `colorScheme.primary` BECAUSE the designer's export is stroked #384F47 —
    // the light primary, and the colour of the "Resend OTP" label under it.
    // If a re-export changes that stroke, this fails instead of the glyph
    // quietly disagreeing with the palette.
    final svg = File('assets/icons/stopwatch.svg').readAsStringSync();

    final strokes = RegExp(
      r'stroke="(#[0-9A-Fa-f]{6})"',
    ).allMatches(svg).map((m) => m.group(1)!.toUpperCase()).toSet();

    expect(strokes, {'#384F47'}, reason: 'one stroke colour, the primary');
    expect(
      Brand.greenPrimary,
      const Color(0xFF384F47),
      reason: 'light colorScheme.primary must match the export stroke',
    );
  });

  // The elevation pass (edit1.md section 8.1) added 48 surface tokens in one
  // change. Pinned here for the reason the Mistakes group above is pinned: the
  // dark values are MEASURED, and the failure mode that has actually happened
  // on this project is a later tidy-up carrying a light value across.
  group('elevation-pass surfaces', () {
    final light = AppColors.light;
    final dark = AppColors.dark;

    test('the dark canvas washes at 20%, it does not paint an opaque card', () {
      // Fourteen of them are the same story: a neutral at 20% alpha under a
      // Glass effect. If one of these ever goes opaque, its Glass stops
      // reading.
      for (final entry in <String, Color>{
        'backChipSurfaceFill': dark.backChipSurfaceFill,
        'registrationBackChipFill': dark.registrationBackChipFill,
        'languagePillFill': dark.languagePillFill,
        'homeBellFill': dark.homeBellFill,
        'dailyTasksFill': dark.dailyTasksFill,
        'topStudentFill': dark.topStudentFill,
        'subjectSearchFill': dark.subjectSearchFill,
        'aiPanelOuterFill': dark.aiPanelOuterFill,
        'resultCardFill': dark.resultCardFill,
        'leaderboardRowFill': dark.leaderboardRowFill,
        'profileHeaderFill': dark.profileHeaderFill,
        'settingsSectionFill': dark.settingsSectionFill,
        'avatarBadgeFill': dark.avatarBadgeFill,
        'trackCardFill': dark.trackCardFill,
      }.entries) {
        expect(
          entry.value.a,
          closeTo(0.2, 0.005),
          reason: '${entry.key} should be a 20% wash',
        );
      }
    });

    test('the three dark surfaces that are deliberately OPAQUE', () {
      // Read from their own frames, not inferred from the rule above.
      expect(dark.subjectCardFill, const Color(0xFF27282C)); // 337:5732
      expect(dark.treeRowFill, const Color(0xFF27282C)); // 337:5926
      expect(dark.profileStatFill, const Color(0xFF27282C)); // 661:8579
    });

    test('light values are the frames, not a reuse of an old token', () {
      // Three of these caught an existing token being wrong:
      expect(
        light.subjectCardFill,
        const Color(0xFFFFFFFF),
        reason: '135:618 is pure white, not the cream catalogCardFill',
      );
      expect(
        light.topStudentFill,
        const Color(0xFFFFFFFF),
        reason: '59:2090 is pure white',
      );
      expect(
        light.treeRowBorder,
        const Color(0xFF4B675E),
        reason: 'the row border was fieldBorder #D1D1D1 — the frame says green',
      );
      expect(
        light.settingsSectionBorder,
        Brand.purplePrimary,
        reason: 'it read profileRowBorder #7070A0; 176:1840 says #AE87E7',
      );
      expect(light.quizPrevButtonFill, const Color.fromRGBO(56, 79, 71, 0.6));
      expect(light.resultStarDiscFill, const Color(0xFFF8EFFC));
      expect(light.subjectSearchTopBorder, const Color(0xFFF3F4F6)); // 135:610
      expect(light.otpDigitFill, const Color(0xFFFDFDFD));
      expect(light.continueLearningFillSchool, const Color(0xFFF3E5FF));
      expect(light.continueLearningFillUniversity, const Color(0xFFDBB0FF));
    });

    test('the five light-only borders are null in dark, not a fallback', () {
      // Null means "the dark frame draws no stroke" — a reading. A later edit
      // must not fill one in.
      expect(dark.dailyTasksBorder, isNull); // 337:5357
      expect(dark.subjectSearchTopBorder, isNull); // 337:5724
      expect(dark.aiPanelOuterBorder, isNull); // 337:9270
      expect(dark.profileMenuRowBorder, isNull); // 337:7479
      expect(dark.settingsSectionBorder, isNull); // 337:8195

      for (final c in [
        light.dailyTasksBorder,
        light.subjectSearchTopBorder,
        light.aiPanelOuterBorder,
        light.profileMenuRowBorder,
        light.settingsSectionBorder,
      ]) {
        expect(c, isNotNull);
      }
    });

    test('otpCardGlow is dark-only, and is the OTP card shadow colour', () {
      expect(light.otpCardGlow, isNull); // no glow in 308:5114
      expect(dark.otpCardGlow, const Color.fromRGBO(174, 135, 231, 0.25));
    });

    test('the tokens that must NOT flip with the canvas', () {
      // Semantic or medal-order values, the same rule as successBadge above.
      expect(light.mistakesPillAccent, dark.mistakesPillAccent);
      expect(light.otpDigitBorder, dark.otpDigitBorder);
      expect(light.topStudentTopBorder, dark.topStudentTopBorder);
      expect(light.pillTrackSelectedFill, dark.pillTrackSelectedFill);
      expect(light.backlight, dark.backlight);
      expect(
        light.continueLearningFillUniversity,
        dark.continueLearningFillUniversity,
      );
      expect(
        light.backlight,
        Brand.purplePrimary,
        reason: 'all sixteen B1..B16 ellipses are #AE87E7',
      );
    });

    test('every new token is wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);

      expect(light.copyWith(backlight: probe).backlight, probe);
      expect(light.copyWith(otpCardGlow: probe).otpCardGlow, probe);
      expect(light.copyWith(subjectCardFill: probe).subjectCardFill, probe);
      // …and leaves its neighbours alone.
      final one = light.copyWith(subjectCardFill: probe);
      expect(one.treeRowFill, light.treeRowFill);
      expect(one.backlight, light.backlight);

      // Anything that differs between palettes must MOVE at t = 0.5 — the
      // check that catches a token added to the constructor and forgotten in
      // lerp, which does not fail to compile, it just stops animating.
      final mid = light.lerp(dark, 0.5);
      for (final pair in <String, List<Color?>>{
        'backChipSurfaceFill': [
          mid.backChipSurfaceFill,
          light.backChipSurfaceFill,
        ],
        'dailyTasksFill': [mid.dailyTasksFill, light.dailyTasksFill],
        'subjectCardFill': [mid.subjectCardFill, light.subjectCardFill],
        'treeRowBorder': [mid.treeRowBorder, light.treeRowBorder],
        'pillTrackFill': [mid.pillTrackFill, light.pillTrackFill],
        'aiPanelCardFill': [mid.aiPanelCardFill, light.aiPanelCardFill],
        'quizPrevButtonFill': [
          mid.quizPrevButtonFill,
          light.quizPrevButtonFill,
        ],
        'scopeSelectedFill': [mid.scopeSelectedFill, light.scopeSelectedFill],
        'profileStatFill': [mid.profileStatFill, light.profileStatFill],
        'otpTimerFill': [mid.otpTimerFill, light.otpTimerFill],
        'trackCardFill': [mid.trackCardFill, light.trackCardFill],
        'otpCardGlow': [mid.otpCardGlow, light.otpCardGlow],
      }.entries) {
        expect(
          pair.value.first,
          isNot(pair.value.last),
          reason: '${pair.key} did not move — check its lerp line',
        );
      }

      // And the endpoints stay exact.
      expect(light.lerp(dark, 1).backlight, dark.backlight);
      expect(
        light.lerp(dark, 0).settingsSectionBorder,
        light.settingsSectionBorder,
      );
    });
  });

  test('all three brand assets landed', () {
    // DESIGN_ISSUES #1 (export disabled on a View-only seat) is closed; these
    // three were placeholders since Day 1.
    for (final path in [
      'assets/images/onboarding_illustration.svg',
      'assets/images/success_badge.svg',
      'assets/images/bird_logo.svg',
    ]) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: '$path is missing');
      expect(file.lengthSync(), greaterThan(1000), reason: '$path looks empty');
    }
  });
}
