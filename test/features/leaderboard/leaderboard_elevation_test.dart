/// The leaderboard's two elevated components, mounted directly.
///
/// **Directly, because the screen is not reachable.** `/leaderboard` still
/// serves `LeaderboardPlaceholderScreen` under `docs/DECISIONS.md` D-008, so
/// nothing here can be driven through the router the way
/// `leaderboard_screen_test.dart` drives the rest of the board. Mounting the
/// widgets is what `edit4.md` §11.5 asks for, and it is also the only thing
/// that would catch a regression while the gate stands.
///
/// What the edit4 wave changed here:
///
///  * `ScopeToggle` stopped hand-rolling a track and moved onto edit1's
///    `SegmentedTrack`, which brings the dark groove's two inner shadows and
///    the selected pill's white inner highlight with it;
///  * its labels took `scopeIdleLabel`, a value that was READ rather than the
///    `textSecondary` the guide assumed;
///  * `LeaderboardRow` took the list's drop shadow and, in dark, G5 Glass —
///    except on the caller's own row, which the frame leaves unglassed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/segmented_track.dart';
import 'package:level_up_app/features/leaderboard/models/leaderboard_models.dart';
import 'package:level_up_app/features/leaderboard/widgets/leaderboard_row.dart';
import 'package:level_up_app/features/leaderboard/widgets/scope_toggle.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'leaderboard_fixtures.dart';

void main() {
  Widget host(
    Widget child, {
    required Brightness brightness,
    TextDirection direction = TextDirection.ltr,
  }) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: direction == TextDirection.rtl
        ? const Locale('ar')
        : const Locale('en'),
    home: Scaffold(body: Center(child: child)),
  );

  AppColors colours(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppColors>()!;

  AppElevation elevations(Brightness b) =>
      (b == Brightness.light ? AppTheme.light : AppTheme.dark)
          .extension<AppElevation>()!;

  // ---------------------------------------------------------------- #19 -----
  group('ScopeToggle · 158:839 light / 337:5615 dark', () {
    Widget toggle({
      LeaderboardScope selected = LeaderboardScope.system,
      ValueChanged<LeaderboardScope>? onChanged,
      List<LeaderboardScope> scopes = const [
        LeaderboardScope.system,
        LeaderboardScope.governorate,
      ],
    }) => ScopeToggle(
      scopes: scopes,
      selected: selected,
      onChanged: onChanged ?? (_) {},
      labelFor: (s) => s.name,
    );

    testWidgets('a one-scope board still collapses to nothing', (tester) async {
      // The early return has to stay AHEAD of the SegmentedTrack, which would
      // happily draw a 44-high groove with one segment in it.
      await tester.pumpWidget(
        host(
          toggle(scopes: const [LeaderboardScope.system]),
          brightness: Brightness.light,
        ),
      );

      expect(tester.getSize(find.byType(ScopeToggle)).height, 0);
      expect(find.byType(SegmentedTrack<LeaderboardScope>), findsNothing);
    });

    testWidgets('the track takes the scope toggle\'s own fills, not the pill '
        'track\'s', (tester) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.light));

      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;
      final ext = colours(Brightness.light);

      expect(style.trackColor, ext.scopeTrackFill);
      expect(style.selectedColor, ext.scopeSelectedFill);
      // `Frame 1000003008`, not `Frame 1000003007`. The two controls are
      // separate components that happen to agree on the GROOVE - both read
      // `#ECECEC` light and `#232429` dark - and disagree on the thing that
      // matters, which is why neither borrows the other's token.
      expect(style.selectedColor, isNot(ext.pillTrackSelectedFill));
    });

    testWidgets('the idle label is the GREEN the frame specifies, not '
        'textSecondary', (tester) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.light));

      final ext = colours(Brightness.light);
      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;

      // `158:843`. This is the substitution DESIGN_ISSUES #77 caught on the
      // sibling control, and `edit4.md` §7.8 would have repeated it.
      expect(style.idleLabelColor, ext.scopeIdleLabel);
      expect(style.idleLabelColor, isNot(ext.textSecondary));
      expect(style.selectedLabelColor, ext.podiumOnAccent);
    });

    testWidgets('dark draws the recessed groove and the lit pill', (
      tester,
    ) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.dark));

      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;
      final e = elevations(Brightness.dark);

      expect(style.trackInsetShadows, e.scopeTrackInsetShadows);
      expect(style.selectedInsetShadows, e.scopeSelectedInsetShadows);
      // Every one of them is a REAL inset, never an outer shadow faking one.
      for (final s in [
        ...style.trackInsetShadows,
        ...style.selectedInsetShadows,
      ]) {
        expect(s.inset, isTrue);
      }
    });

    testWidgets('an idle segment is TRANSPARENT, so it cannot paint over '
        'the groove', (tester) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.dark));

      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;

      // A segment is the full 44 dp height, so an OPAQUE idle fill covers
      // the track's two inner shadows and flattens the idle half of the
      // control. Both look identical on the light canvas, which is how
      // the opaque version got written in the first place; rendering the
      // dark golden both ways differs in 2087 pixels, all of them inside
      // the idle segment and concentrated in the two shadow bands.
      //
      // Asserted on what is PAINTED rather than on a style field. This
      // used to read `style.idleSegmentColor`, and that knob was removed
      // outright on 2026-09-20 (owner ruling, DESIGN_ISSUES #84) so that
      // no call site can set an opaque one — a test that reads a knob
      // cannot outlive the knob, and the ruling is about the paint.
      expect(style.selectedColor, colours(Brightness.dark).scopeSelectedFill);

      final surfaces = tester
          .widgetList<ElevatedSurface>(
            find.descendant(
              of: find.byType(SegmentedTrack<LeaderboardScope>),
              matching: find.byType(ElevatedSurface),
            ),
          )
          .toList();

      // The groove, then one surface per segment, in order.
      expect(surfaces, hasLength(3));
      expect(surfaces.first.color, colours(Brightness.dark).scopeTrackFill);

      // `toggle()` selects the FIRST scope, so segment 0 paints and
      // segment 1 must be fully transparent — not merely a different
      // colour from the track, which an opaque idle fill would also be.
      final segments = surfaces.skip(1).toList();
      expect(segments[0].color?.a, 1);
      expect(segments[1].color?.a, 0);
    });

    testWidgets('light draws a flat track — the empty lists are readings', (
      tester,
    ) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.light));

      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;

      expect(style.trackInsetShadows, isEmpty);
      expect(style.selectedInsetShadows, isEmpty);
    });

    testWidgets('the segment padding is passed explicitly, not inherited', (
      tester,
    ) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.light));

      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;

      // Figma `Padding 10` on `158:840` itself. The primitive's default is the
      // same number read off the QUIZ TAB's frames — identical today, and a
      // silent inheritance if it is ever left to the default.
      expect(
        style.segmentPadding,
        const EdgeInsetsDirectional.symmetric(horizontal: 10),
      );
    });

    testWidgets('the label keeps its 18pt token — no copyWith on the weight', (
      tester,
    ) async {
      await tester.pumpWidget(host(toggle(), brightness: Brightness.light));

      final style = tester
          .widget<SegmentedTrack<LeaderboardScope>>(
            find.byType(SegmentedTrack<LeaderboardScope>),
          )
          .style;

      // Figma is Inter 500 at this size; `AppType.h3` is the only token at it
      // and carries one weight step more. Recorded, not patched — the
      // typography guard bans the patch outright.
      expect(style.labelStyle, AppType.h3);
    });

    testWidgets('tapping a segment reports the scope', (tester) async {
      LeaderboardScope? picked;
      await tester.pumpWidget(
        host(
          toggle(onChanged: (s) => picked = s),
          brightness: Brightness.light,
        ),
      );

      await tester.tap(find.text('governorate'));
      await tester.pumpAndSettle();

      expect(picked, LeaderboardScope.governorate);
    });

    testWidgets('the segments announce themselves as an exclusive group', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(toggle(), brightness: Brightness.light));

      // The hand-rolled toggle had `button` + `selected`; the primitive adds
      // `inMutuallyExclusiveGroup`, and declares `onTap` on the Semantics node
      // itself so excluding the subtree does not take the ACTION with it.
      expect(
        tester.getSemantics(find.text('governorate')),
        matchesSemantics(
          label: 'governorate',
          isButton: true,
          hasTapAction: true,
          isInMutuallyExclusiveGroup: true,
          hasSelectedState: true,
          isSelected: false,
        ),
      );

      handle.dispose();
    });

    testWidgets('RTL leads with the first scope, without mirroring code', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          toggle(),
          brightness: Brightness.light,
          direction: TextDirection.rtl,
        ),
      );

      final first = tester.getRect(find.text('system'));
      final second = tester.getRect(find.text('governorate'));
      expect(first.center.dx, greaterThan(second.center.dx));
    });
  });

  // ---------------------------------------------------------------- #20 -----
  group('LeaderboardRow · 134:3538 light / 337:5630 dark', () {
    testWidgets('an ordinary dark row is a 20% wash carrying Glass', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(LeaderboardRow(entry: entry(4)), brightness: Brightness.dark),
      );

      final surface = tester.widget<ElevatedSurface>(
        find.byType(ElevatedSurface),
      );
      final ext = colours(Brightness.dark);
      final e = elevations(Brightness.dark);

      expect(surface.color, ext.leaderboardRowFill);
      expect(surface.glass, e.leaderboardRowGlass);
      // Without the rim this row is a 1.01:1 colour step against the page.
      expect(surface.glass, isNotNull);
      expect(surface.shadows, e.leaderboardListShadows);
      expect(surface.height, 48);
    });

    testWidgets('the caller\'s own row is lilac and carries NO Glass', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          LeaderboardRow(entry: entry(4, isMe: true)),
          brightness: Brightness.dark,
        ),
      );

      final surface = tester.widget<ElevatedSurface>(
        find.byType(ElevatedSurface),
      );
      final ext = colours(Brightness.dark);

      // `134:3554` draws no group Glass on the highlighted row. It is the one
      // opaque row in a column of translucent ones, which is the point of it.
      expect(surface.color, ext.podiumAccent);
      expect(surface.glass, isNull);
    });

    testWidgets('the light row is the frame\'s white, not the near-white it '
        'borrowed', (tester) async {
      await tester.pumpWidget(
        host(LeaderboardRow(entry: entry(4)), brightness: Brightness.light),
      );

      final surface = tester.widget<ElevatedSurface>(
        find.byType(ElevatedSurface),
      );
      final ext = colours(Brightness.light);

      expect(surface.color, ext.leaderboardRowFill);
      expect(surface.color, isNot(ext.cardFill));
      expect(surface.glass, isNull);
      // The list's shadow survives on the light canvas too.
      expect(surface.shadows, isNotEmpty);
    });

    testWidgets('both canvases keep the list shadow, and it is not a '
        'BoxShadow', (tester) async {
      for (final b in Brightness.values) {
        await tester.pumpWidget(
          host(LeaderboardRow(entry: entry(4)), brightness: b),
        );

        final surface = tester.widget<ElevatedSurface>(
          find.byType(ElevatedSurface),
        );
        expect(surface.shadows, elevations(b).leaderboardListShadows);
        for (final s in surface.shadows) {
          expect(s.inset, isFalse);
          // The frame's own numbers. Asserting `sigma == blur * 0.5` would
          // only restate the getter's definition back to itself; these are
          // the values off `133:3117`, and sigma 0.8 is what a 1.6 blur
          // becomes under the CSS conversion rather than under Flutter's.
          expect(s.blur, 1.6);
          expect(s.offset, const Offset(0.02, 0.02));
          expect(s.sigma, 0.8);
        }
      }
    });

    testWidgets('the row still reads its rank, name and points', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(LeaderboardRow(entry: entry(4)), brightness: Brightness.light),
      );

      expect(find.text('4'), findsOneWidget);
      expect(find.text('Student 4'), findsOneWidget);
    });
  });
}
