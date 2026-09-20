import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/profile/widgets/profile_header_card.dart';
import 'package:level_up_app/features/profile/widgets/profile_menu_row.dart';

import 'profile_fixtures.dart';
import 'profile_harness.dart';

/// The Profile hub's surfaces, on both canvases · edit5 items #21, #22, #24.
///
/// Three things are pinned here that nothing else would catch:
///
/// 1. the header's **back-light is dark-only** and mirrors in RTL — a
///    `Backlight` passed on the light canvas would assert inside
///    `ElevatedSurface`, and one that did not mirror would sit behind the
///    name instead of the avatar in Arabic (edit1.md R6/R9);
/// 2. the edit chip is a **40 dp disc inside a 48 dp target** — the frame's
///    size and the platform's minimum are different numbers and the build has
///    to satisfy both;
/// 3. every menu row carries a **disc**, including the eight navigation rows
///    whose doc said for two months that they did not (see [ProfileRowTone]).
void main() {
  Widget app(Brightness brightness, Widget child, {TextDirection? direction}) =>
      MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
        // MaterialApp CROSS-FADES a theme change over 200ms. A test that pumps
        // light and then dark inside one `testWidgets` reads the light values
        // back on the second pump unless the animation is off, which looks
        // exactly like a widget that ignores its canvas.
        themeAnimationDuration: Duration.zero,
        home: Directionality(
          textDirection: direction ?? TextDirection.ltr,
          child: Scaffold(body: Center(child: child)),
        ),
      );

  Widget header() => const ProfileHeaderCard(
    name: 'Ahmed Mohamed',
    avatarUrl: 'https://example.invalid/a.png',
    levelLabel: 'Level 8',
    editLabel: 'Edit profile',
    onEdit: _noop,
  );

  // ---------------------------------------------------------------------
  group('#21 the header card', () {
    ElevatedSurface cardOf(WidgetTester tester) => tester.widget(
      find
          .descendant(
            of: find.byType(ProfileHeaderCard),
            matching: find.byType(ElevatedSurface),
          )
          .first,
    );

    testWidgets('light: the frame shadow, no Glass, no back-light', (
      tester,
    ) async {
      await tester.pumpWidget(app(Brightness.light, header()));
      final card = cardOf(tester);

      expect(card.shadows, AppElevation.light.profileHeaderShadows);
      expect(card.shadows.single.offset, const Offset(0.5, 0.5));
      expect(card.shadows.single.blur, 4);
      expect(card.glass, isNull);
      expect(
        card.backlights,
        isEmpty,
        reason:
            'no light frame draws an ellipse, and passing one without Glass '
            'trips the primitive\'s own assert',
      );
      expect(card.color, AppColors.light.profileHeaderFill);
    });

    testWidgets('dark: the SAME shadow, plus G15 and the B7 back-light', (
      tester,
    ) async {
      await tester.pumpWidget(app(Brightness.dark, header()));
      final card = cardOf(tester);

      expect(
        card.shadows,
        AppElevation.light.profileHeaderShadows,
        reason: '`337:7455` keeps the light canvas\'s black shadow verbatim',
      );
      expect(card.glass, AppElevation.dark.profileHeaderGlass);
      expect(card.glass!.frost, 57, reason: 'G15');
      expect(card.backlights.single, AppElevation.dark.profileHeaderBacklight);
      expect(card.backlights.single.size, const Size(100, 14));
      expect(card.backlights.single.offset, const Offset(4, 11));
      expect(
        card.color,
        AppColors.dark.profileHeaderFill,
        reason: '#27282C at 20%, which is what makes the Glass visible',
      );
    });

    testWidgets('the back-light offset is directional, so AR mirrors it', (
      tester,
    ) async {
      // The offset itself is the same value in both directions — the mirroring
      // happens in `paintBacklights`, which needs the ambient direction. What
      // this pins is that the card does not hand the painter a resolved
      // left-edge offset, which would put the haze behind the name in Arabic.
      await tester.pumpWidget(
        app(Brightness.dark, header(), direction: TextDirection.rtl),
      );
      expect(cardOf(tester).backlights.single.offset, const Offset(4, 11));
      expect(
        Directionality.of(tester.element(find.byType(ProfileHeaderCard))),
        TextDirection.rtl,
      );
    });
  });

  // ---------------------------------------------------------------------
  group('#22 the edit chip', () {
    ElevatedSurface chipOf(WidgetTester tester) => tester.widget(
      find.descendant(
        of: find.byKey(const Key('profile_edit_button')),
        matching: find.byType(ElevatedSurface),
      ),
    );

    testWidgets('is a 40 dp disc inside a 48 dp tap target', (tester) async {
      await tester.pumpWidget(app(Brightness.light, header()));

      final chip = chipOf(tester);
      expect(chip.shape, const CircleBorder());
      expect(chip.width, 40);
      expect(chip.height, 40);

      final target = tester.getSize(
        find.byKey(const Key('profile_edit_button')),
      );
      expect(
        target.width,
        greaterThanOrEqualTo(48),
        reason:
            'the frame draws 40; the platform minimum is 48; the gesture '
            'region is padded so neither number has to move',
      );
      expect(target.height, greaterThanOrEqualTo(48));
    });

    testWidgets('light: cream with the tight blur-1.3 shadow, no Glass', (
      tester,
    ) async {
      await tester.pumpWidget(app(Brightness.light, header()));
      final chip = chipOf(tester);

      expect(chip.color, AppColors.light.profileEditChipFill);
      expect(chip.shadows, AppElevation.light.profileEditChipShadows);
      expect(chip.shadows.single.blur, 1.3);
      expect(chip.glass, isNull);
    });

    testWidgets('dark: a 20% wash under G5, same shadow', (tester) async {
      await tester.pumpWidget(app(Brightness.dark, header()));
      final chip = chipOf(tester);

      expect(chip.color, AppColors.dark.profileEditChipFill);
      expect(chip.glass, AppElevation.dark.profileEditChipGlass);
      expect(chip.shadows, AppElevation.light.profileEditChipShadows);
    });

    testWidgets('the glyph is the READ colour, not the accent', (tester) async {
      for (final (brightness, palette) in [
        (Brightness.light, AppColors.light),
        (Brightness.dark, AppColors.dark),
      ]) {
        await tester.pumpWidget(app(brightness, header()));
        final icon = tester.widget<Icon>(
          find.descendant(
            of: find.byKey(const Key('profile_edit_button')),
            matching: find.byType(Icon),
          ),
        );
        expect(icon.color, palette.profileEditChipGlyph);
        expect(
          icon.color,
          isNot(palette.homeAccent),
          reason:
              'the bare IconButton this replaced was lavender in both '
              'canvases; `170:4674` is #333333 and `337:7466` is #FCFBF9',
        );
        expect(icon.size, 20, reason: 'the frame\'s 20x20 vector');
      }
    });

    testWidgets('the key, the tooltip and the semantics label survive', (
      tester,
    ) async {
      await tester.pumpWidget(app(Brightness.light, header()));

      expect(find.byKey(const Key('profile_edit_button')), findsOneWidget);
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        'Edit profile',
      );

      final handle = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.byKey(const Key('profile_edit_button'))),
        matchesSemantics(
          label: 'Edit profile',
          tooltip: 'Edit profile',
          isButton: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('tapping it still fires onEdit', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        app(
          Brightness.light,
          ProfileHeaderCard(
            name: 'Ahmed Mohamed',
            avatarUrl: 'https://example.invalid/a.png',
            levelLabel: 'Level 8',
            editLabel: 'Edit profile',
            onEdit: () => taps++,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('profile_edit_button')));
      await tester.pump();
      expect(taps, 1);
    });
  });

  // ---------------------------------------------------------------------
  group('#24 the menu rows', () {
    Widget row(ProfileRowTone tone, {bool enabled = true}) => ProfileMenuRow(
      icon: Icons.settings,
      label: 'Settings',
      tone: tone,
      onTap: enabled ? _noop : null,
      disabledHint: enabled ? null : 'no destination yet',
    );

    List<ElevatedSurface> surfacesOf(WidgetTester tester) => tester
        .widgetList<ElevatedSurface>(
          find.descendant(
            of: find.byType(ProfileMenuRow),
            matching: find.byType(ElevatedSurface),
          ),
        )
        .toList();

    testWidgets('EVERY tone draws the 35 dp disc — the refuted reading', (
      tester,
    ) async {
      for (final tone in ProfileRowTone.values) {
        await tester.pumpWidget(app(Brightness.light, row(tone)));
        final surfaces = surfacesOf(tester);

        expect(
          surfaces.length,
          2,
          reason: 'the row itself and its icon disc — $tone',
        );
        final disc = surfaces.last;
        expect(disc.shape, const CircleBorder());
        expect(disc.width, 35);
        expect(disc.height, 35);
        expect(disc.color, AppColors.light.profileMenuIconDiscFill);
        expect(
          disc.color,
          const Color(0xFFF4E6FF),
          reason:
              '`170:4861`, `170:4902` and `176:1186` all read #F4E6FF at '
              '35x35 r48.17 — the disc is the Iconify frame\'s own fill',
        );
      }
    });

    testWidgets('light hairlines: grey, #101010, red — one per tone', (
      tester,
    ) async {
      final expected = {
        ProfileRowTone.neutral: AppColors.light.profileMenuRowBorder,
        ProfileRowTone.emphasis: AppColors.light.profileMenuEmphasisRowBorder,
        ProfileRowTone.destructive: AppColors.light.destructive,
      };

      for (final tone in ProfileRowTone.values) {
        await tester.pumpWidget(app(Brightness.light, row(tone)));
        final side = surfacesOf(tester).first.side;
        expect(side, isNotNull, reason: '$tone');
        expect(side!.color, expected[tone], reason: '$tone');
        expect(side.width, 0.5, reason: '$tone');
      }

      expect(
        AppColors.light.profileMenuEmphasisRowBorder,
        isNot(AppColors.light.textPrimary),
        reason:
            'the emphasis row used to borrow textPrimary #0E0E0E; the frame '
            'stroke `170:4921` is #101010',
      );
    });

    testWidgets('dark: only Logout keeps a hairline, and everything gets G5', (
      tester,
    ) async {
      for (final tone in ProfileRowTone.values) {
        await tester.pumpWidget(app(Brightness.dark, row(tone)));
        final surfaces = surfacesOf(tester);

        expect(surfaces.first.glass, AppElevation.dark.profileMenuRowGlass);
        expect(surfaces.last.glass, AppElevation.dark.profileMenuIconDiscGlass);
        expect(surfaces.first.color, AppColors.dark.profileMenuRowFill);

        if (tone == ProfileRowTone.destructive) {
          expect(surfaces.first.side?.color, AppColors.dark.destructive);
        } else {
          expect(
            surfaces.first.side,
            isNull,
            reason: '`337:7433` draws no stroke on $tone in dark',
          );
        }
      }
    });

    testWidgets('a disabled row is still inert and still dimmed', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(Brightness.light, row(ProfileRowTone.neutral, enabled: false)),
      );

      expect(
        find.descendant(
          of: find.byType(ProfileMenuRow),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      expect(find.byType(IgnorePointer), findsWidgets);
      expect(
        tester
            .widgetList<Opacity>(find.byType(Opacity))
            .map((o) => o.opacity)
            .contains(kProfileDisabledOpacity),
        isTrue,
      );
    });
  });

  // ---------------------------------------------------------------------
  // `edit5.md` §12's text-scale line names three surfaces - the language
  // track, the menu rows and the OTP row - and only the track had a test.
  // This is the rows, pumped through the REAL hub so the labels are the
  // localized ones rather than a literal chosen to pass.
  group('#24 the menu rows at text scale 1.3', () {
    for (final locale in ['en', 'ar']) {
      testWidgets('the hub does not overflow in $locale', (tester) async {
        // Errors are captured rather than left to fail the test outright, so
        // the assertion can say WHICH one appeared. The same caveat the
        // Settings test carries applies (#81): this binding's font is ~1.5x
        // wider than Inter, so a pass here is stricter than the device.
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) => errors.add(details.toString());
        addTearDown(() => FlutterError.onError = previous);

        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        // The frame's own width. The harness's default 800 is wide enough
        // that no label could overflow, which would make this test green
        // and worthless.
        await tester.binding.setSurfaceSize(const Size(402, 1400));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await pumpProfileScreen(
          tester,
          profile: profileRepo(me: schoolProfile()),
          locale: locale,
        );

        expect(find.byType(ProfileMenuRow), findsWidgets);
        expect(
          errors.where((e) => e.contains('overflowed')),
          isEmpty,
          reason: 'a row grows or wraps; it does not overflow',
        );
      });
    }
  });
}

void _noop() {}
