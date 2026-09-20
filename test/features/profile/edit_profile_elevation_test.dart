import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';
import 'profile_harness.dart';

/// Edit Profile's elevation · edit5 items #25 and the #12 / #27 consumer steps.
///
/// The screen is driven through its real router harness rather than pumped in
/// isolation: the badge sits inside `_AvatarEditor`, which is private, and the
/// Save button's wrapper only exists in the assembled screen.
void main() {
  /// `Color.fromRGBO(0, 0, 0, 0.25)` — see `profile_stat_card_test.dart` for
  /// why this is not `Color(0x40000000)`.
  const black25 = Color.fromRGBO(0, 0, 0, 0.25);

  /// Scoped to the avatar's own tap target. The screen's back chip is also a
  /// circular `ElevatedSurface` (35 dp, `#232428` at 20% in dark), so a
  /// by-shape search finds the wrong one and still reads plausibly.
  ElevatedSurface badgeOf(WidgetTester tester) => tester.widget(
    find.descendant(
      of: find.byKey(const Key('edit_avatar_button')),
      matching: find.byType(ElevatedSurface),
    ),
  );

  group('#25 the avatar badge', () {
    testWidgets('light: the frame\'s TIGHT shadow, not the borrowed one', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: profileRepo(me: schoolProfile()));

      final badge = badgeOf(tester);
      expect(badge.width, 34);
      expect(badge.height, 34);
      expect(badge.color, AppColors.light.avatarBadgeFill);
      expect(badge.shadows, AppElevation.light.avatarBadgeShadows);

      final shadow = badge.shadows.single;
      expect(shadow.color, black25);
      expect(shadow.offset, const Offset(0.0240833, 0.0240833));
      expect(
        shadow.blur,
        1.105,
        reason:
            'it shipped at 0.5 / 0.5 / blur 2, borrowed from the profile '
            'header. `180:3989` is roughly twenty times tighter.',
      );
      expect(badge.glass, isNull);
    });

    testWidgets('dark: a 20% CREAM wash under G5, same black shadow', (
      tester,
    ) async {
      await pumpEditProfile(
        tester,
        profile: profileRepo(me: schoolProfile()),
        theme: AppTheme.dark,
      );

      final badge = badgeOf(tester);
      expect(badge.color, AppColors.dark.avatarBadgeFill);
      expect(
        badge.color,
        const Color(0x33FCFBF9),
        reason:
            '`337:7925` washes the LIGHT cream at 20%, not the dark card '
            'grey every other surface in this block uses',
      );
      expect(badge.glass, AppElevation.dark.avatarBadgeGlass);
      expect(
        badge.shadows,
        AppElevation.light.avatarBadgeShadows,
        reason: 'the dark frame keeps the same black shadow',
      );
    });
  });

  group('#12 consumer · Save wears the CTA elevation', () {
    PrimaryCta ctaOf(WidgetTester tester) => tester.widget(
      find
          .ancestor(
            of: find.byKey(const Key('edit_save_button')),
            matching: find.byType(PrimaryCta),
          )
          .first,
    );

    testWidgets('the primary tone, enabled while the form is idle', (
      tester,
    ) async {
      await pumpEditProfile(tester, profile: profileRepo(me: schoolProfile()));

      final cta = ctaOf(tester);
      expect(cta.tone, CtaTone.primary);
      expect(
        cta.enabled,
        isTrue,
        reason:
            'the frame draws the glow on this button (`348:8909`); it is the '
            'primary tone, not the destructive one',
      );
    });

    testWidgets('the Retry in the error state stays UNWRAPPED', (tester) async {
      // edit5.md §7.11a: the error-state Retry has no Figma frame, so giving
      // it a shadow would be inventing one. Asserted here rather than left
      // implicit, because "nobody wrapped it" and "it must not be wrapped"
      // look identical in a diff.
      final repo = profileRepo();
      when(repo.getMe).thenThrow(const UnknownException());

      await pumpEditProfile(tester, profile: repo);

      expect(find.byKey(const Key('edit_save_button')), findsNothing);
      expect(find.byType(PrimaryCta), findsNothing);
    });
  });
}
