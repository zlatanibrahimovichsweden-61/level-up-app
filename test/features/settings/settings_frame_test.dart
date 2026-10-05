import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/segmented_track.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/settings/widgets/settings_rows.dart';
import 'package:level_up_app/features/settings/widgets/settings_section.dart';
import 'package:mocktail/mocktail.dart';

import '../../goldens/golden_harness.dart';
import '../profile/profile_fixtures.dart';
import 'settings_harness.dart';

/// Settings against its frames — API→UI Wave 21 (`176:1840`, dark `337:8141`,
/// Arabic `549:21759`).
///
/// **The bundled fonts are loaded here, and that is why this is its own file.**
/// The frame's spacing is measured to the headings' INK — Figma trims their
/// boxes to the cap height — so the only honest check is against where Inter
/// actually puts its baseline, which the test face does not. Every other
/// Settings file runs on the test face and stays that way.
void main() {
  setUpAll(() async {
    registerFallbackValue(const ProfileUpdate());
    await loadAppFonts();
  });

  /// Inter's cap height at 18: its OS/2 `sCapHeight` (1490) on a 2048 em.
  const capHeight = 18 * 1490 / 2048;

  /// Where the ENGINE puts Inter's baseline inside an `h3` line — measured,
  /// not taken from the constants under test.
  double h3Baseline() {
    final painter = TextPainter(
      text: TextSpan(
        text: 'Rank',
        style: AppType.h3.copyWith(fontFamily: 'Inter'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    addTearDown(painter.dispose);
    return painter.computeLineMetrics().single.baseline;
  }

  Rect heading(WidgetTester tester, String text) =>
      tester.getRect(find.text(text));

  /// The card of the [SettingsSection] titled [title].
  Rect card(WidgetTester tester, String title) => tester.getRect(
    find
        .descendant(
          of: find.ancestor(
            of: find.text(title),
            matching: find.byType(SettingsSection),
          ),
          matching: find.byType(ElevatedSurface),
        )
        .first,
  );

  Rect languageTrack(WidgetTester tester) =>
      tester.getRect(find.byType(SegmentedTrack<Locale>));

  Finder toggleIn(String rowKey) => find.descendant(
    of: find.byKey(Key(rowKey)),
    matching: find.byType(SettingsToggle),
  );

  Finder knobIn(String rowKey) => find.descendant(
    of: find.byKey(Key(rowKey)),
    matching: find.byKey(const Key('settings_toggle_knob')),
  );

  Color trackColour(WidgetTester tester, String rowKey) {
    final box = tester.widget<AnimatedContainer>(
      find.descendant(
        of: toggleIn(rowKey),
        matching: find.byType(AnimatedContainer),
      ),
    );
    return (box.decoration! as BoxDecoration).color!;
  }

  group('Wave 21: the frame\'s 25, measured to ink', () {
    testWidgets('the heading constants are Inter\'s own metrics', (
      tester,
    ) async {
      final baseline = h3Baseline();

      expect(
        kSettingsHeadingBelowBaseline,
        closeTo(24 - baseline, 0.01),
        reason: 'the part of an h3 line under the baseline',
      );
      expect(
        kSettingsHeadingCapTop,
        closeTo(baseline - capHeight, 0.01),
        reason: 'the part of an h3 line above the caps',
      );
    });

    testWidgets('bar → heading, heading → control, control → heading: 25', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');
      final baseline = h3Baseline();
      double capTop(Rect line) => line.top + baseline - capHeight;
      double baselineOf(Rect line) => line.top + baseline;

      // `176:1863` (the bar) ends at 95; `176:2298` starts at 120.
      final bar = tester.getRect(find.byKey(const Key('settings_back')));
      final languages = heading(tester, 'Languages');
      expect(capTop(languages) - bar.bottom, closeTo(25, 0.05));

      // Each block: heading baseline → its control, then control → the next
      // heading's cap top (`Frame 1000003054`, gap 25; each block, gap 25).
      final track = languageTrack(tester);
      expect(track.top - baselineOf(languages), closeTo(25, 0.05));

      final mode = heading(tester, 'Mode');
      expect(capTop(mode) - track.bottom, closeTo(25, 0.05));
      expect(card(tester, 'Mode').top - baselineOf(mode), closeTo(25, 0.05));

      final rank = heading(tester, 'Rank');
      expect(capTop(rank) - card(tester, 'Mode').bottom, closeTo(25, 0.05));
      expect(card(tester, 'Rank').top - baselineOf(rank), closeTo(25, 0.05));

      final notifications = heading(tester, 'Notification Preferences');
      expect(
        capTop(notifications) - card(tester, 'Rank').bottom,
        closeTo(25, 0.05),
      );
      expect(
        card(tester, 'Notification Preferences').top -
            baselineOf(notifications),
        closeTo(25, 0.05),
      );
    });

    testWidgets('headings sit on the content edge, on either side', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');

      // `642:8518` "Rank" at x 20, the card's own edge — no inset.
      expect(heading(tester, 'Languages').left, languageTrack(tester).left);
      for (final title in ['Mode', 'Rank', 'Notification Preferences']) {
        expect(heading(tester, title).left, card(tester, title).left);
      }
    });

    testWidgets('…and in Arabic on the right edge (549:21816)', (tester) async {
      await pumpAppAt(tester, '/settings', locale: 'ar');

      expect(heading(tester, 'اللغة').right, languageTrack(tester).right);
      for (final title in ['الأوضاع', 'الترتيب', 'تفضيلات الإشعارات']) {
        expect(heading(tester, title).right, card(tester, title).right);
      }
    });
  });

  group('Wave 21: the rows and the frame\'s switch', () {
    testWidgets('row labels are Inter Regular 16 in the frame\'s colour', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');

      void expectRowLabel(String text, AppColors palette) {
        final style = tester.widget<Text>(find.text(text)).style!;
        expect(style.fontSize, 16, reason: '$text: 642:8524 is 16');
        expect(style.fontWeight, FontWeight.w400, reason: '$text: Regular');
        expect(style.color, palette.settingsRowLabel, reason: text);
      }

      const labels = ['Show me on the leaderboard', 'Announcements', 'Light'];
      for (final text in labels) {
        expectRowLabel(text, AppColors.light);
      }

      await tester.tap(find.byKey(const Key('settings_mode_dark')));
      await tester.pumpAndSettle();
      for (final text in labels) {
        expectRowLabel(text, AppColors.dark);
      }
    });

    testWidgets('no stock Switch is left on the screen', (tester) async {
      await pumpAppAt(tester, '/settings');

      expect(find.byType(Switch), findsNothing);
      expect(find.byType(SettingsToggle), findsNWidgets(6));
    });

    testWidgets('ON: 48 x 24 in #AE87E7, a 16 white knob 4 from the end', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');
      const row = 'settings_leaderboard_visible'; // the fixture: true

      final toggle = tester.getRect(toggleIn(row));
      final knob = tester.getRect(knobIn(row));
      expect(toggle.size, const Size(48, 24));
      expect(knob.size, const Size(16, 16));
      expect(knob.right, closeTo(toggle.right - 4, 0.01));
      expect(knob.center.dy, closeTo(toggle.center.dy, 0.01));
      expect(trackColour(tester, row), AppColors.light.settingsToggleOnTrack);

      final knobBox = tester.widget<Container>(knobIn(row));
      expect(
        (knobBox.decoration! as BoxDecoration).color,
        AppColors.light.settingsToggleKnob,
      );

      // The frame's `Button` ends 16 in from the card (`642:8525` at 317.5
      // + 48 = 365.5; the card ends at 382, less its 0.5 hairline).
      expect(toggle.right, closeTo(card(tester, 'Rank').right - 16.5, 0.01));
    });

    testWidgets('OFF: the knob at the other end over the stand-in grey', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');
      const row = 'settings_score_hidden'; // the fixture: false

      final toggle = tester.getRect(toggleIn(row));
      final knob = tester.getRect(knobIn(row));
      expect(knob.left, closeTo(toggle.left + 4, 0.01));
      expect(trackColour(tester, row), AppColors.light.settingsToggleOffTrack);
    });

    testWidgets('a row is the frame\'s 52: 14 over and under the switch', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');

      // `176:2387`: padding 14 / 16 inside the card's 0.5 hairline, a 24 switch.
      const first = 'settings_notif_announcements';
      final notifications = card(tester, 'Notification Preferences');
      for (final row in [first, 'settings_notif_system']) {
        final rect = tester.getRect(find.byKey(Key(row)));
        expect(rect.height, closeTo(52, 0.01), reason: row);
        expect(
          tester.getRect(toggleIn(row)).top - rect.top,
          closeTo(14, 0.01),
          reason: row,
        );
      }
      expect(
        tester.getRect(find.byKey(const Key(first))).top - notifications.top,
        closeTo(0.5, 0.01),
        reason: 'inside the hairline, not under it',
      );
    });

    testWidgets('dark has no hairline, so no inset: 16 from the card', (
      tester,
    ) async {
      await pumpAppAt(tester, '/settings');
      await tester.tap(find.byKey(const Key('settings_mode_dark')));
      await tester.pumpAndSettle();

      const row = 'settings_notif_announcements';
      final notifications = card(tester, 'Notification Preferences');
      // `337:8196` sits on the card's edge; its switch ends 16 in (`337:8199`).
      expect(tester.getRect(find.byKey(const Key(row))).top, notifications.top);
      expect(
        tester.getRect(toggleIn(row)).right,
        closeTo(notifications.right - 16, 0.01),
      );
    });

    testWidgets(
      'in Arabic the row mirrors but ON keeps its knob on the right',
      (tester) async {
        await pumpAppAt(tester, '/settings', locale: 'ar');
        const row = 'settings_notif_announcements';

        final toggle = tester.getRect(toggleIn(row));
        final knob = tester.getRect(knobIn(row));
        // `549:21822` at x 36.5: the card's edge + 16.5.
        expect(
          toggle.left,
          closeTo(card(tester, 'تفضيلات الإشعارات').left + 16.5, 0.01),
        );
        // `549:21823` at 64.5–80.5 inside 36.5–84.5: 4 from the RIGHT end.
        expect(knob.right, closeTo(toggle.right - 4, 0.01));
      },
    );

    testWidgets('a Rank row is a switch a screen reader can flip', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final repo = settingsRepo();
      await pumpAppAt(tester, '/settings', profile: repo);
      final row = find.byKey(const Key('settings_leaderboard_visible'));

      final node = tester.getSemantics(row);
      expect(node.label, startsWith('Show me on the leaderboard'));
      expect(
        node,
        isSemantics(
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );

      // The stock Switch used to carry the action; the row carries it now.
      tester.semantics.tap(
        find.semantics.byLabel(RegExp('^Show me on the leaderboard')),
      );
      await tester.pumpAndSettle();
      expect(sentUpdate(repo).toJson(), <String, dynamic>{
        'leaderboardVisible': false,
      });
      handle.dispose();
    });

    testWidgets(
      'a disabled row says its label ONCE, and the reason (BUG-018)',
      (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAppAt(tester, '/settings');

        final labels = {
          'settings_notif_announcements': 'Announcements',
          'settings_notif_promotions': 'Promotions',
          'settings_notif_support': 'Support',
          'settings_notif_system': 'System',
        };
        for (final entry in labels.entries) {
          expect(
            tester.getSemantics(find.byKey(Key(entry.key))),
            isSemantics(
              label: entry.value,
              hint: 'Notification settings aren\'t available yet.',
              hasToggledState: true,
              isToggled: true,
              hasEnabledState: true,
              isEnabled: false,
              hasTapAction: false,
            ),
            reason: entry.key,
          );
        }
        handle.dispose();
      },
    );

    testWidgets('a save keeps the row\'s one node, so focus survives it', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final pending = Completer<StudentProfile>();
      final repo = settingsRepo();
      when(() => repo.updateMe(any())).thenAnswer((_) => pending.future);
      await pumpAppAt(tester, '/settings', profile: repo);
      final row = find.byKey(const Key('settings_leaderboard_visible'));

      final before = tester.getSemantics(row);
      await tester.tap(row);
      await tester.pump();

      // In flight: the same node, now disabled, with its label said once and
      // no reason (the row is about to come back on its own).
      final during = tester.getSemantics(row);
      expect(during.id, before.id);
      expect(during.label, before.label);
      expect(during, isSemantics(isEnabled: false, hasTapAction: false));
      expect(during.hint, isEmpty);

      pending.complete(schoolProfile());
      await tester.pumpAndSettle();
      expect(tester.getSemantics(row).id, before.id);
      handle.dispose();
    });

    testWidgets('each heading is a header of its own', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAppAt(tester, '/settings');

      for (final title in [
        'Languages',
        'Mode',
        'Rank',
        'Notification Preferences',
      ]) {
        expect(
          tester.getSemantics(find.text(title)),
          isSemantics(label: title, isHeader: true),
        );
      }
      handle.dispose();
    });

    testWidgets('a Mode row is ONE node: its label, checked, tappable', (
      tester,
    ) async {
      // A lens read the row's un-merged `Semantics` as a defect; probed, the
      // label already folds into the one node. Held here so it stays that way.
      final handle = tester.ensureSemantics();
      await pumpAppAt(tester, '/settings');

      expect(
        tester.getSemantics(find.byKey(const Key('settings_mode_light'))),
        isSemantics(
          label: 'Light',
          isButton: true,
          hasCheckedState: true,
          isChecked: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
          isFocusable: true,
        ),
      );
      handle.dispose();
    });
  });

  group('Wave 21: the Rank states nothing had pumped', () {
    testWidgets('while a save is in flight, BOTH switches are disabled', (
      tester,
    ) async {
      final pending = Completer<StudentProfile>();
      final repo = settingsRepo();
      when(() => repo.updateMe(any())).thenAnswer((_) => pending.future);
      await pumpAppAt(tester, '/settings', profile: repo);

      SettingsSwitchRow rowOf(String key) =>
          tester.widget<SettingsSwitchRow>(find.byKey(Key(key)));

      await tester.tap(find.byKey(const Key('settings_leaderboard_visible')));
      await tester.pump();

      // Not just the one tapped: a second write while the first is unanswered
      // could land in either order.
      expect(rowOf('settings_leaderboard_visible').onChanged, isNull);
      expect(rowOf('settings_score_hidden').onChanged, isNull);
      expect(
        rowOf('settings_leaderboard_visible').value,
        isTrue,
        reason: 'nothing optimistic while the request is out',
      );

      pending.complete(schoolProfile());
      await tester.pumpAndSettle();
      expect(rowOf('settings_leaderboard_visible').onChanged, isNotNull);
      expect(rowOf('settings_score_hidden').onChanged, isNotNull);
    });

    testWidgets(
      'until /me first answers, Rank holds its place and the rest works',
      (tester) async {
        final pending = Completer<StudentProfile>();
        final repo = settingsRepo();
        when(repo.getMe).thenAnswer((_) => pending.future);
        await pumpAppAt(tester, '/settings', profile: repo, settle: false);

        expect(find.byKey(const Key('settings_rank_loading')), findsOneWidget);
        expect(find.byType(SettingsToggle), findsNWidgets(4)); // the four S28
        expect(find.byKey(const Key('settings_language_ar')), findsOneWidget);
        expect(find.byKey(const Key('settings_mode_dark')), findsOneWidget);

        pending.complete(schoolProfile());
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('settings_rank_loading')), findsNothing);
        expect(
          find.byKey(const Key('settings_leaderboard_visible')),
          findsOneWidget,
        );
      },
    );
  });
}
