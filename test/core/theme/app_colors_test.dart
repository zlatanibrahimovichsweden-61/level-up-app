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

  // Wave 01 device walk: the Login bird drew #040404 on the dark canvas
  // (#232428) because the app had one asset and no dark value. Both values are
  // the fills of the frames' own SVG exports — light 82:849, dark 337:15678.
  group('brandLogo', () {
    test("light is the shipped SVG's own fill; dark is the dark frame's", () {
      final svg = File('assets/images/bird_logo.svg').readAsStringSync();
      expect(svg, contains('fill="#040404"'));
      expect(AppColors.light.brandLogo, const Color(0xFF040404));
      expect(AppColors.dark.brandLogo, const Color(0xFFFCFBF9));
    });

    test('is wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);
      expect(AppColors.light.copyWith(brandLogo: probe).brandLogo, probe);
      expect(
        AppColors.light.lerp(AppColors.dark, 1).brandLogo,
        AppColors.dark.brandLogo,
      );
      expect(
        AppColors.light.lerp(AppColors.dark, 0).brandLogo,
        AppColors.light.brandLogo,
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
      expect(light.mistakesBadgeFill, const Color(0xFFF4E6FF)); // 404:6644
      expect(light.mistakesCardChevron, const Color(0xFF517066)); // 404:6533
      expect(light.mistakesRowChevron, const Color(0xFF4B675E)); // 404:6654
    });

    test('dark is the 404:7428 family, not the light values', () {
      final dark = AppColors.dark;

      expect(dark.mistakesCardFill, const Color(0x4D27282C)); // 404:7637
      expect(dark.mistakesRowFill, const Color(0xFF27282C)); // 404:7765
      expect(dark.mistakesContent, const Color(0xFFFCFBF9)); // 404:7771
      expect(dark.mistakesCount, const Color(0xFFEF4444)); // 404:7884
      expect(dark.mistakesRowBorder, const Color(0xFFFCFBF9)); // 404:7765
      expect(dark.mistakesBadgeFill, const Color(0x3327282C)); // 404:7767
      expect(dark.mistakesCardChevron, const Color(0xFFFCFBF9)); // 404:7651
      expect(dark.mistakesRowChevron, const Color(0xFFFCFBF9)); // 404:7778

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

  test('the OTP stopwatch export is stroked in the light otpTimerContent', () {
    // DESIGN_ISSUES #49. The resend-timer pill tints the glyph with
    // `otpTimerContent` BECAUSE the designer's export is stroked #384F47 —
    // the light value, and the colour of the digits beside it (`82:1316`).
    // If a re-export changes that stroke, this fails instead of the glyph
    // quietly disagreeing with the palette.
    final svg = File('assets/icons/stopwatch.svg').readAsStringSync();

    final strokes = RegExp(
      r'stroke="(#[0-9A-Fa-f]{6})"',
    ).allMatches(svg).map((m) => m.group(1)!.toUpperCase()).toSet();

    expect(strokes, {'#384F47'}, reason: 'one stroke colour');
    expect(
      AppColors.light.otpTimerContent,
      const Color(0xFF384F47),
      reason: 'light otpTimerContent must match the export stroke',
    );
  });

  // Wave 02 (2026-09-24): three OTP values read with get_design_context.
  group('OTP timer content and error state', () {
    test('timer content: #384F47 light, cream dark (82:1316 / 337:19503)', () {
      expect(AppColors.light.otpTimerContent, const Color(0xFF384F47));
      expect(AppColors.dark.otpTimerContent, const Color(0xFFFCFBF9));
    });

    test('error line #FF465C and cell stroke #EB001B@50%, both canvases', () {
      for (final c in [AppColors.light, AppColors.dark]) {
        expect(c.otpErrorText, const Color(0xFFFF465C));
        expect(c.otpDigitErrorBorder, const Color(0x80EB001B));
      }
    });

    test('copyWith and lerp carry the three tokens', () {
      const red = Color(0xFFFF0000);
      final copy = AppColors.light.copyWith(
        otpTimerContent: red,
        otpErrorText: red,
        otpDigitErrorBorder: red,
      );
      expect(copy.otpTimerContent, red);
      expect(copy.otpErrorText, red);
      expect(copy.otpDigitErrorBorder, red);

      final end = AppColors.light.lerp(AppColors.dark, 1);
      expect(end.otpTimerContent, AppColors.dark.otpTimerContent);
    });
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
      expect(light.topStudentBorder, dark.topStudentBorder);
      expect(light.podiumSecondBadgeBorder, dark.podiumSecondBadgeBorder);
      expect(light.subjectCardProgress, dark.subjectCardProgress);
      expect(light.catalogTrack, dark.catalogTrack);
      expect(light.treeRowProgress, dark.treeRowProgress);
      expect(light.podiumThirdBadgeFill, dark.podiumThirdBadgeFill);
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

  // Same reasoning as the Mistakes group above: every value here was read off a
  // Properties panel in the owner's signed-in Figma session on 2026-09-20, and
  // pinning them is what stops a later tidy-up from carrying a neighbour's
  // value across again. Two of them ARE a later tidy-up being undone.
  group('edit4 — quiz review rows, prev button, scope toggle', () {
    final light = AppColors.light;
    final dark = AppColors.dark;

    test(
      'the three review-row fills: light opaque, dark at the frame\'s 20%',
      () {
        // Light is byte-identical to what shipped before D-010 — the ruling is a
        // DARK ruling and the light frame was never in question.
        expect(light.reviewRowCorrectFill, light.quizCorrectFill);
        expect(light.reviewRowWrongFill, light.quizWrongFill);
        expect(light.reviewRowSkippedFill, light.quizOptionFill);

        // Dark: the semantic HUE unchanged, at the frame's alpha. 337:6731.
        expect(dark.reviewRowCorrectFill, const Color(0x33BFFFC3));
        expect(dark.reviewRowWrongFill, const Color(0x33FFC0C0));
        expect(dark.reviewRowSkippedFill, const Color(0x3327282C));

        // Equal in treatment — the ruling's own words. A row left opaque beside
        // a glassed neighbour is the defect it named.
        for (final c in [
          dark.reviewRowCorrectFill,
          dark.reviewRowWrongFill,
          dark.reviewRowSkippedFill,
        ]) {
          expect(c.a, closeTo(0.2, 0.005));
        }
      },
    );

    test(
      'the wrong row keeps the SHIPPED hue, not the review frame\'s drift',
      () {
        // 337:6731's wrong twin draws #FDE9E8 with a #921019 stroke — one hex
        // digit from the shipped pair, ruled unadopted in 2026-09-08 and still
        // open as DESIGN_ISSUES #52. Only the ALPHA follows the frame.
        expect(dark.reviewRowWrongFill.r, dark.quizWrongFill.r);
        expect(dark.reviewRowWrongFill.g, dark.quizWrongFill.g);
        expect(dark.reviewRowWrongFill.b, dark.quizWrongFill.b);
        expect(dark.quizWrongBorder, const Color(0xFF921119));
      },
    );

    test(
      'quizReviewRowContent stopped being canvas-independent, and had to',
      () {
        // It used to be the same green on both, because its fill was opaque mint
        // on both. Once the dark fill composites to #425047 that green measures
        // 1.04:1. The replacement was READ off 337:6715, not chosen.
        expect(light.quizReviewRowContent, const Color(0xFF384F47)); // 162:2510
        expect(dark.quizReviewRowContent, const Color(0xFFFCFBF9)); // 337:6715
        expect(light.quizReviewRowContent, isNot(dark.quizReviewRowContent));
      },
    );

    test('the previous-button glyph is cream on BOTH canvases', () {
      // 159:1922 and 337:6466. edit4.md §13 listed this as unread and offered
      // a two-branch fallback; neither branch was needed.
      expect(light.quizPrevButtonGlyph, const Color(0xFFFCFBF9));
      expect(dark.quizPrevButtonGlyph, const Color(0xFFFCFBF9));
      // Its own token even so: it sits on quizPrevButtonFill, which is a 60%
      // green wash in light and a 20% neutral in dark — unrelated surfaces.
      expect(light.quizPrevButtonFill, isNot(dark.quizPrevButtonFill));
    });

    test('the light selected scope fill is #DBB0FF — the re-read value', () {
      // Carried #D8B0FF (read 2026-09-08) until a 2026-09-16 CSS export
      // disagreed. 158:840 settles it. Three units of red apart, which is how
      // it survived two readings.
      expect(light.scopeSelectedFill, const Color(0xFFDBB0FF));
      expect(dark.scopeSelectedFill, const Color(0xFFC4A8E3));
      // podiumAccent was NOT moved with it on 2026-09-20: 134:3554 had not
      // been re-read, and a sibling's reading is not evidence about this one.
      // The Wave 06 walk read 134:3554 AND 337:5638 at #DBB0FF (W06-3).
      expect(light.podiumAccent, const Color(0xFFDBB0FF));
      expect(dark.podiumAccent, const Color(0xFFDBB0FF));
      // Still two tokens: they agree in light and part in dark.
      expect(dark.scopeSelectedFill, isNot(dark.podiumAccent));
    });

    test('the idle scope label is a dark GREEN, not textSecondary grey', () {
      // 158:843 / 337:5619. edit4.md §7.8 asked for textSecondary here, which
      // is the same substitution DESIGN_ISSUES #77 caught on the pill track.
      expect(light.scopeIdleLabel, const Color(0xFF384F47));
      expect(dark.scopeIdleLabel, const Color(0xFFFCFBF9));
      expect(light.scopeIdleLabel, isNot(light.textSecondary));

      // Numerically equal to pillTrackLabel and still its own token: the two
      // controls are different Figma components with different selected fills
      // and, per #77, two contrast problems that will not be fixed together.
      expect(light.scopeIdleLabel, light.pillTrackLabel);
      expect(light.scopeTrackFill, isNot(light.pillTrackSelectedFill));
    });

    test('the badge ring took the frame\'s lavender without moving the shared '
        'token', () {
      // Owner ruling 2026-09-20, DESIGN_ISSUES #83. 337:6447.
      expect(
        dark.quizOptionBadgeRing,
        const Color.fromRGBO(174, 135, 231, 0.5),
      );
      expect(dark.quizOptionBadgeRing, dark.quizOptionTileBorder);
      // The shared token stayed: the review skipped row still reads it for
      // both its outline and its own badge.
      expect(dark.quizOptionBorder, const Color(0xFF4B675E));
      expect(dark.quizOptionBorder, isNot(dark.quizOptionBadgeRing));
      // Light was not separately read — it is quizOptionBorder carried across,
      // so the light canvas is byte-identical.
      expect(light.quizOptionBadgeRing, light.quizOptionBorder);
    });

    test('every edit4 token is wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);

      expect(
        light.copyWith(reviewRowCorrectFill: probe).reviewRowCorrectFill,
        probe,
      );
      expect(
        light.copyWith(reviewRowWrongFill: probe).reviewRowWrongFill,
        probe,
      );
      expect(
        light.copyWith(reviewRowSkippedFill: probe).reviewRowSkippedFill,
        probe,
      );
      expect(
        light.copyWith(quizPrevButtonGlyph: probe).quizPrevButtonGlyph,
        probe,
      );
      expect(light.copyWith(scopeIdleLabel: probe).scopeIdleLabel, probe);
      expect(
        light.copyWith(quizOptionBadgeRing: probe).quizOptionBadgeRing,
        probe,
      );

      // …and each leaves its neighbours alone.
      final one = light.copyWith(scopeIdleLabel: probe);
      expect(one.scopeSelectedFill, light.scopeSelectedFill);
      expect(one.pillTrackLabel, light.pillTrackLabel);

      // lerp endpoints are exact, so a mid-animation frame cannot be the only
      // place a token is correct.
      final mixed = light.lerp(dark, 1);
      expect(mixed.reviewRowCorrectFill, dark.reviewRowCorrectFill);
      expect(mixed.scopeIdleLabel, dark.scopeIdleLabel);
      expect(mixed.quizOptionBadgeRing, dark.quizOptionBadgeRing);
    });
  });

  // API→UI Wave 20: Edit Profile's avatar disc, badge glyph and action sheet.
  group('Wave 20 avatar tokens', () {
    const light = AppColors.light;
    const dark = AppColors.dark;

    test('the frames\' values in both palettes', () {
      // The disc's radial gradient is the same on both canvases (`176:1343`,
      // `337:7923`), and so is the sheet's hairline (`216:3343`, `337:8137`).
      for (final palette in [light, dark]) {
        expect(palette.avatarDiscInner, const Color(0xFF4B675E));
        expect(palette.avatarDiscOuter, const Color(0xFF95CDBB));
        expect(palette.avatarSheetDivider, const Color(0x994B675E));
      }
      expect(light.avatarBadgeGlyph, const Color(0xFF384F47)); // 176:1347
      expect(dark.avatarBadgeGlyph, const Color(0xFFFCFBF9)); // 337:7926
      expect(light.avatarSheetHandle, const Color(0xFF000000)); // 216:3342
      expect(dark.avatarSheetHandle, const Color(0xFFFCFBF9)); // 337:8136
    });

    test('every one is wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);

      expect(light.copyWith(avatarDiscInner: probe).avatarDiscInner, probe);
      expect(light.copyWith(avatarDiscOuter: probe).avatarDiscOuter, probe);
      expect(light.copyWith(avatarBadgeGlyph: probe).avatarBadgeGlyph, probe);
      expect(light.copyWith(avatarSheetHandle: probe).avatarSheetHandle, probe);
      expect(
        light.copyWith(avatarSheetDivider: probe).avatarSheetDivider,
        probe,
      );

      // …and each leaves its neighbours alone.
      final one = light.copyWith(avatarSheetHandle: probe);
      expect(one.avatarSheetDivider, light.avatarSheetDivider);
      expect(one.profileDialogClose, light.profileDialogClose);

      // lerp endpoints are exact, so a mid-animation frame cannot be the only
      // place a token is correct.
      final mixed = light.lerp(dark, 1);
      expect(mixed.avatarBadgeGlyph, dark.avatarBadgeGlyph);
      expect(mixed.avatarSheetHandle, dark.avatarSheetHandle);
      expect(mixed.avatarDiscInner, dark.avatarDiscInner);
      expect(mixed.avatarDiscOuter, dark.avatarDiscOuter);
      expect(mixed.avatarSheetDivider, dark.avatarSheetDivider);
      expect(light.lerp(dark, 0).avatarBadgeGlyph, light.avatarBadgeGlyph);
    });
  });

  group('Wave 21 Settings tokens', () {
    const light = AppColors.light;
    const dark = AppColors.dark;

    test('the frames\' values in both palettes', () {
      // The switch is the same on both canvases: `642:8525` / `642:8587` track,
      // `642:8526` / `642:8588` knob.
      for (final palette in [light, dark]) {
        expect(palette.settingsToggleOnTrack, const Color(0xFFAE87E7));
        expect(palette.settingsToggleKnob, const Color(0xFFFFFFFF));
        // Not designed — the app's inactive grey, [mutedText]'s value, until
        // the designer draws OFF (docs/DESIGN_ISSUES.md #107).
        expect(palette.settingsToggleOffTrack, const Color(0xFFB3B3B3));
        expect(palette.settingsToggleOffTrack, palette.mutedText);
      }
      expect(light.settingsRowLabel, const Color(0xFF384F47)); // 642:8524
      expect(dark.settingsRowLabel, const Color(0xFFFCFBF9)); // 642:8586
    });

    test('every one is wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);

      expect(light.copyWith(settingsRowLabel: probe).settingsRowLabel, probe);
      expect(
        light.copyWith(settingsToggleOnTrack: probe).settingsToggleOnTrack,
        probe,
      );
      expect(
        light.copyWith(settingsToggleOffTrack: probe).settingsToggleOffTrack,
        probe,
      );
      expect(
        light.copyWith(settingsToggleKnob: probe).settingsToggleKnob,
        probe,
      );

      // …and each leaves its neighbours alone.
      final one = light.copyWith(settingsToggleOffTrack: probe);
      expect(one.settingsToggleOnTrack, light.settingsToggleOnTrack);
      expect(one.settingsToggleKnob, light.settingsToggleKnob);
      expect(one.settingsRowLabel, light.settingsRowLabel);

      // Three of the four are the same on both canvases, so lerping light to
      // dark would pass with a broken lerp. Lerp towards probes instead.
      final target = light.copyWith(
        settingsRowLabel: probe,
        settingsToggleOnTrack: probe,
        settingsToggleOffTrack: probe,
        settingsToggleKnob: probe,
      );
      final mixed = light.lerp(target, 1);
      expect(mixed.settingsRowLabel, probe);
      expect(mixed.settingsToggleOnTrack, probe);
      expect(mixed.settingsToggleOffTrack, probe);
      expect(mixed.settingsToggleKnob, probe);
      final start = light.lerp(target, 0);
      expect(start.settingsToggleOnTrack, light.settingsToggleOnTrack);
      expect(start.settingsToggleKnob, light.settingsToggleKnob);
    });
  });

  // API→UI Wave 22: the flashcards study screen and Flash Card Setup.
  group('Wave 22 Flashcards tokens', () {
    const light = AppColors.light;
    const dark = AppColors.dark;

    test('the designed values, light and dark', () {
      // Progress fill: the one thing the study header does not share with the
      // quiz's. Light 225:5616; dark is the fill inside 337:14475 (349:15348).
      expect(light.flashcardProgressFill, const Color(0xFF5A7F73));
      expect(dark.flashcardProgressFill, const Color(0xFFAE87E7));
      expect(light.flashcardProgressFill, isNot(light.quizProgressFill));

      // The card is a LIGHT object on the dark canvas (337:14513): face and
      // ink are the same in both palettes.
      for (final palette in [light, dark]) {
        expect(palette.flashcardCardFill, const Color(0xFFFCFBF9));
        expect(palette.flashcardCardText, const Color(0xFF384F47));
        expect(
          palette.flashcardAgainGlyph,
          const Color(0xFFFCFBF9),
        ); // 1229:8745
      }

      // Again button: light is drawn (1229:8739); dark is not.
      expect(light.flashcardAgainFill, const Color(0xFF4B675E));

      // Setup: light is drawn (1234:8847, 1234:8848, 1237:9845).
      expect(light.flashcardSetupPillFill, const Color(0xFFFFFFFF));
      expect(light.flashcardSetupPillBorder, const Color(0xFF384F47));
      expect(light.flashcardSetupPillText, const Color(0xFF384F47));
      expect(light.flashcardSetupHelper, const Color(0xFF6E7F7A));
    });

    test('the grade-failure line is composed from existing error colours, '
        'not from the quiz\'s dark red', () {
      // No frame draws it (DESIGN_ISSUES #119). Light is the quiz's inline-error
      // red; dark is the app's existing dark error text.
      expect(light.flashcardGradeError, const Color(0xFF921119));
      expect(light.flashcardGradeError, light.quizWrongBorder);
      expect(dark.flashcardGradeError, const Color(0xFFFF465C));
      expect(dark.flashcardGradeError, dark.otpErrorText);
      // quizWrongBorder is #921119 on BOTH canvases, which is what made the line
      // unreadable on the dark one.
      expect(dark.quizWrongBorder, const Color(0xFF921119));
      expect(dark.flashcardGradeError, isNot(dark.quizWrongBorder));
    });

    test(
      'the grade-failure line reads on its own canvas: 4.5:1 for body text',
      () {
        // WCAG contrast, on the scaffold colour the line is drawn straight onto.
        double contrast(Color a, Color b) {
          final la = a.computeLuminance();
          final lb = b.computeLuminance();
          return (la > lb ? la + 0.05 : lb + 0.05) /
              (la > lb ? lb + 0.05 : la + 0.05);
        }

        expect(
          contrast(light.flashcardGradeError, light.background),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrast(dark.flashcardGradeError, dark.background),
          greaterThanOrEqualTo(4.5),
        );
        // The reason for the token: the quiz's red on the dark canvas.
        expect(contrast(dark.quizWrongBorder, dark.background), lessThan(2));
      },
    );

    test(
      'the dark values with no frame are named stand-ins, not inventions',
      () {
        // 337:14475 predates the restart button: the dark primary accent
        // (its primary button, 349:15308).
        expect(dark.flashcardAgainFill, const Color(0xFFAE87E7));
        expect(dark.flashcardAgainFill, dark.homeAccent);

        // No dark Setup frame at all. The dark quiz-setup chip (337:6239): fill
        // #27282C and a #FCFBF9 label; the border is the dark counterpart of the
        // light ink #384F47.
        expect(dark.flashcardSetupPillFill, const Color(0xFF27282C));
        expect(dark.flashcardSetupPillFill, dark.quizOptionFill);
        expect(dark.flashcardSetupPillBorder, const Color(0xFFFCFBF9));
        expect(dark.flashcardSetupPillText, const Color(0xFFFCFBF9));
        expect(dark.flashcardSetupPillText, dark.textPrimary);

        // The helper is mutedText's value, so it stays quieter than the label.
        expect(dark.flashcardSetupHelper, const Color(0xFFB3B3B3));
        expect(dark.flashcardSetupHelper, dark.mutedText);
      },
    );

    test('every one is wired through copyWith and lerp', () {
      const probe = Color(0xFF010203);

      expect(
        light.copyWith(flashcardProgressFill: probe).flashcardProgressFill,
        probe,
      );
      expect(light.copyWith(flashcardCardFill: probe).flashcardCardFill, probe);
      expect(light.copyWith(flashcardCardText: probe).flashcardCardText, probe);
      expect(
        light.copyWith(flashcardAgainFill: probe).flashcardAgainFill,
        probe,
      );
      expect(
        light.copyWith(flashcardAgainGlyph: probe).flashcardAgainGlyph,
        probe,
      );
      expect(
        light.copyWith(flashcardSetupPillFill: probe).flashcardSetupPillFill,
        probe,
      );
      expect(
        light
            .copyWith(flashcardSetupPillBorder: probe)
            .flashcardSetupPillBorder,
        probe,
      );
      expect(
        light.copyWith(flashcardSetupPillText: probe).flashcardSetupPillText,
        probe,
      );
      expect(
        light.copyWith(flashcardSetupHelper: probe).flashcardSetupHelper,
        probe,
      );
      expect(
        light.copyWith(flashcardGradeError: probe).flashcardGradeError,
        probe,
      );

      // …and each leaves its neighbours alone.
      final one = light.copyWith(flashcardAgainFill: probe);
      expect(one.flashcardAgainGlyph, light.flashcardAgainGlyph);
      expect(one.flashcardCardFill, light.flashcardCardFill);
      expect(one.flashcardCardText, light.flashcardCardText);

      // Several are identical on both canvases, so light→dark would pass with
      // a broken lerp. Lerp towards probes instead.
      final target = light.copyWith(
        flashcardProgressFill: probe,
        flashcardCardFill: probe,
        flashcardCardText: probe,
        flashcardAgainFill: probe,
        flashcardAgainGlyph: probe,
        flashcardSetupPillFill: probe,
        flashcardSetupPillBorder: probe,
        flashcardSetupPillText: probe,
        flashcardSetupHelper: probe,
        flashcardGradeError: probe,
      );
      final end = light.lerp(target, 1);
      expect(end.flashcardProgressFill, probe);
      expect(end.flashcardCardFill, probe);
      expect(end.flashcardCardText, probe);
      expect(end.flashcardAgainFill, probe);
      expect(end.flashcardAgainGlyph, probe);
      expect(end.flashcardSetupPillFill, probe);
      expect(end.flashcardSetupPillBorder, probe);
      expect(end.flashcardSetupPillText, probe);
      expect(end.flashcardSetupHelper, probe);
      expect(end.flashcardGradeError, probe);
      final start = light.lerp(target, 0);
      expect(start.flashcardProgressFill, light.flashcardProgressFill);
      expect(start.flashcardCardFill, light.flashcardCardFill);
      expect(start.flashcardSetupHelper, light.flashcardSetupHelper);
      expect(start.flashcardGradeError, light.flashcardGradeError);
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
