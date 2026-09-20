import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/segmented_track.dart';

void main() {
  final style = SegmentedTrackStyle(
    trackColor: AppColors.dark.pillTrackFill,
    trackRadius: 22,
    trackInsetShadows: AppElevation.dark.pillTrackInsetShadows,
    selectedColor: AppColors.dark.pillTrackSelectedFill,
    selectedRadius: 22,
    selectedInsetShadows: AppElevation.dark.pillTrackSelectedInsetShadows,
    labelStyle: AppType.h3,
    idleLabelColor: AppColors.dark.textSecondary,
    selectedLabelColor: AppColors.dark.background,
  );

  Widget host({
    required List<String> segments,
    required String selected,
    required ValueChanged<String> onChanged,
    TextDirection direction = TextDirection.ltr,
    double textScale = 1,
    double width = 362,
  }) => MaterialApp(
    theme: AppTheme.dark,
    home: Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: SegmentedTrack<String>(
                segments: segments,
                selected: selected,
                onChanged: onChanged,
                labelOf: (s) => s,
                keyOf: (s) => Key('segment-$s'),
                style: style,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('an unselected segment paints NOTHING, whatever the style says', (
    tester,
  ) async {
    // The mechanised form of the 2026-09-20 ruling (docs/DESIGN_ISSUES.md #84):
    // an idle segment is transparent, always. `SegmentedTrackStyle` used to
    // carry an `idleSegmentColor` and `QuizTypeTabs` set it to the track's own
    // opaque colour, which covered the dark groove's two inner shadows — 2087
    // differing pixels on the scope toggle's dark golden, every one of them
    // inside the idle segment.
    //
    // The knob is gone rather than defaulted, so this test is really asserting
    // that it stays gone: the only way to reintroduce the defect is to add a
    // colour back, and the moment anyone does, this fails for every consumer at
    // once rather than for whichever one they remembered to check.
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay', 'True/False'],
        selected: 'Essay',
        onChanged: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    final surfaces = tester
        .widgetList<ElevatedSurface>(
          find.descendant(
            of: find.byType(SegmentedTrack<String>),
            matching: find.byType(ElevatedSurface),
          ),
        )
        .toList();

    // The groove, then one surface per segment.
    expect(surfaces, hasLength(4));
    expect(surfaces.first.color, style.trackColor);

    final segments = surfaces.skip(1).toList();
    expect(segments[1].color, style.selectedColor, reason: 'the selected one');
    for (final i in const [0, 2]) {
      expect(
        segments[i].color?.a,
        0,
        reason: 'segment $i is idle and must paint nothing',
      );
    }

    // Transparent is not enough on its own: the tween runs between the idle
    // fill and the selected colour, so the idle fill has to be the SELECTED
    // hue at zero alpha, or a half-finished animation passes through a third
    // colour on its way. Checked mid-flight rather than reasoned about.
    //
    // Driven by moving the selection on a rebuild, not by tapping: this host is
    // stateless and its `onChanged` is a no-op, so a tap reports the change and
    // renders nothing. The theme is the same object across the two pumps, so
    // nothing here is reading a half-lerped canvas.
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay', 'True/False'],
        selected: 'MCQ',
        onChanged: (_) {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 75));
    final mid = tester
        .widgetList<ElevatedSurface>(
          find.descendant(
            of: find.byType(SegmentedTrack<String>),
            matching: find.byType(ElevatedSurface),
          ),
        )
        .elementAt(1)
        .color!;
    expect(mid.a, greaterThan(0));
    expect(mid.a, lessThan(1));
    expect(mid.r, closeTo(style.selectedColor.r, 0.001));
    expect(mid.g, closeTo(style.selectedColor.g, 0.001));
    expect(mid.b, closeTo(style.selectedColor.b, 0.001));

    await tester.pumpAndSettle();
  });

  testWidgets('tapping an idle segment reports it', (tester) async {
    String? picked;
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay', 'True/False'],
        selected: 'MCQ',
        onChanged: (s) => picked = s,
      ),
    );

    await tester.tap(find.text('Essay'));
    await tester.pumpAndSettle();
    expect(picked, 'Essay');
  });

  testWidgets('the whole segment is the target, not just the label', (
    tester,
  ) async {
    // A 44pt-high segment whose tappable area is the text is a 12pt target.
    String? picked;
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay'],
        selected: 'MCQ',
        onChanged: (s) => picked = s,
      ),
    );

    // Well away from the label, but inside the track's rounded outline — the
    // ClipPath hit-tests against the shape, which is the behaviour we want.
    final box = tester.getRect(find.byKey(const Key('segment-Essay')));
    await tester.tapAt(Offset(box.right - 8, box.center.dy));
    await tester.pumpAndSettle();
    expect(picked, 'Essay');
  });

  testWidgets('each segment carries mutually-exclusive selection semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay'],
        selected: 'MCQ',
        onChanged: (_) {},
      ),
    );

    expect(
      tester.getSemantics(find.byKey(const Key('segment-MCQ'))),
      isSemantics(
        isButton: true,
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
        label: 'MCQ',
      ),
    );
    expect(
      tester.getSemantics(find.byKey(const Key('segment-Essay'))),
      isSemantics(isSelected: false, label: 'Essay'),
    );
    handle.dispose();
  });

  testWidgets('a screen-reader user can actually CHANGE the selection', (
    tester,
  ) async {
    // `excludeSemantics: true` stops the label being announced twice — and it
    // took the `GestureDetector`'s tap action out with the subtree, leaving a
    // node that announced itself a button, announced which segment was
    // selected, and offered no action to select another one. The quiz-type
    // selector was unusable by a screen reader for exactly as long as this
    // primitive has existed.
    final handle = tester.ensureSemantics();
    String? picked;
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay'],
        selected: 'MCQ',
        onChanged: (s) => picked = s,
      ),
    );

    final node = tester.getSemantics(find.byKey(const Key('segment-Essay')));
    expect(
      node.getSemanticsData().hasAction(SemanticsAction.tap),
      isTrue,
      reason: 'a button with no actions is not a control',
    );

    // Driven through the semantics tree, not through a synthetic pointer — a
    // pointer tap would pass whether or not the action is exposed. This throws
    // by itself if the action is missing, so it is a second guard on the same
    // regression rather than a restatement of the first.
    tester.semantics.tap(find.semantics.byLabel('Essay'));
    await tester.pumpAndSettle();
    expect(picked, 'Essay');
    handle.dispose();
  });

  testWidgets('keyOf is honoured, so a screen keeps its existing test keys', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay'],
        selected: 'MCQ',
        onChanged: (_) {},
      ),
    );
    expect(find.byKey(const Key('segment-MCQ')), findsOneWidget);
    expect(find.byKey(const Key('segment-Essay')), findsOneWidget);
  });

  testWidgets('RTL reverses the segment order with no mirroring code', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay'],
        selected: 'MCQ',
        onChanged: (_) {},
        direction: TextDirection.rtl,
      ),
    );

    // The first segment is the LEADING one, which in RTL is on the right.
    expect(
      tester.getCenter(find.byKey(const Key('segment-MCQ'))).dx,
      greaterThan(tester.getCenter(find.byKey(const Key('segment-Essay'))).dx),
    );
  });

  testWidgets('LTR puts the first segment on the left', (tester) async {
    await tester.pumpWidget(
      host(
        segments: const ['MCQ', 'Essay'],
        selected: 'MCQ',
        onChanged: (_) {},
      ),
    );
    expect(
      tester.getCenter(find.byKey(const Key('segment-MCQ'))).dx,
      lessThan(tester.getCenter(find.byKey(const Key('segment-Essay'))).dx),
    );
  });

  /// The label is NEVER shrunk to fit · D-012 · DESIGN_ISSUES #81.
  ///
  /// This group is the guard on the owner's 2026-09-19 ruling: Arabic
  /// readability and the student's text-scale setting outrank the Figma
  /// groove's fixed width. Each test below fails if a `FittedBox` — or
  /// anything else that trades type size for fit — comes back.
  group('labels are laid out at full size, and the track yields instead', () {
    /// The PAINTED height against the LAID-OUT height.
    ///
    /// `getRect` walks the ancestor transforms and so sees any scale applied
    /// above the text; `getSize` is the box the text itself asked for. A
    /// shrink-to-fit shows up as the first being smaller than the second, and
    /// shows up nowhere else — which is why this pair, and not a pixel size,
    /// is what these assert.
    (double painted, double laid) glyph(WidgetTester tester, String label) => (
      tester.getRect(find.text(label)).height,
      tester.getSize(find.text(label)).height,
    );

    /// The groove, which is the first `ElevatedSurface` under the track.
    double grooveWidth(WidgetTester tester) => tester
        .getSize(
          find
              .descendant(
                of: find.byType(SegmentedTrack<String>),
                matching: find.byType(ElevatedSurface),
              )
              .first,
        )
        .width;

    const long = ['A label that does not fit', 'Short', 'Middling'];

    for (final scale in [1.0, 1.3]) {
      for (final entry in <String, List<String>>{
        'en': ['Multiple choice', 'True or False', 'Essay'],
        'ar': ['اختيار من متعدد', 'صح أو خطأ', 'مقال'],
      }.entries) {
        testWidgets('${entry.key} at ${scale}x: nothing is scaled down', (
          tester,
        ) async {
          await tester.pumpWidget(
            host(
              segments: entry.value,
              selected: entry.value.first,
              onChanged: (_) {},
              direction: entry.key == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              textScale: scale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          for (final label in entry.value) {
            final (painted, laid) = glyph(tester, label);
            expect(painted, closeTo(laid, 0.01), reason: '$label at ${scale}x');
          }
        });
      }
    }

    testWidgets('the text-scale setting reaches EVERY label, not just the '
        'short ones', (tester) async {
      // The sharp end of #81. At the old build a long label came back the same
      // size at 1.3x as at 1.0x — the fixed segment handed back exactly what
      // the scale added — while a short one beside it grew. A student who
      // enlarged their text got a row with two different type sizes in it.
      await tester.pumpWidget(
        host(segments: long, selected: long.first, onChanged: (_) {}),
      );
      final before = [for (final l in long) glyph(tester, l).$1];

      await tester.pumpWidget(
        host(
          segments: long,
          selected: long.first,
          onChanged: (_) {},
          textScale: 1.3,
        ),
      );
      await tester.pumpAndSettle();
      final after = [for (final l in long) glyph(tester, l).$1];

      for (var i = 0; i < long.length; i++) {
        expect(
          after[i],
          greaterThan(before[i]),
          reason: '${long[i]} ignored the text scale',
        );
        // ...and they all grow by the SAME factor, which is the part that
        // makes the row read as one type scale rather than three.
        expect(after[i] / before[i], closeTo(after.first / before.first, 0.05));
      }
    });

    testWidgets('labels that FIT lay out exactly as the frame draws them', (
      tester,
    ) async {
      // The common case, and the one that must not have moved: the groove
      // spans the full width it is given and the segments divide it equally.
      // It is what keeps `quiz_type_tabs_dark.png` to a ONE-pixel move: the
      // groove's width now arrives through `IntrinsicWidth` rather than
      // straight off the parent's constraint, which rounds one edge pixel's
      // blend by 1/255 and changes nothing else.
      await tester.pumpWidget(
        host(
          segments: const ['One', 'Two', 'Six'],
          selected: 'One',
          onChanged: (_) {},
        ),
      );

      expect(grooveWidth(tester), 362, reason: 'nothing to scroll');
      final widths = [
        for (final s in const ['One', 'Two', 'Six'])
          tester.getSize(find.byKey(Key('segment-$s'))).width,
      ];
      for (final w in widths) {
        expect(w, closeTo(362 / 3, 1));
      }
    });

    testWidgets('labels that do NOT fit widen the groove past the viewport', (
      tester,
    ) async {
      // The fallback: equal segments still, each one as wide as the LONGEST
      // label plus the frame's own 10 dp padding, and the overflow becomes
      // something the student can drag instead of something the type size
      // absorbs.
      await tester.pumpWidget(
        host(segments: long, selected: long.first, onChanged: (_) {}),
      );

      expect(grooveWidth(tester), greaterThan(362));

      final widths = [
        for (final l in long)
          tester.getSize(find.byKey(Key('segment-$l'))).width,
      ];
      for (final w in widths) {
        expect(w, closeTo(widths.first, 1), reason: 'segments stay equal');
      }
      // Each segment holds its own label at full size, plus the padding.
      final longest = tester.getSize(find.text(long.first)).width;
      expect(widths.first, closeTo(longest + 20, 1));

      // And the overflow is really draggable, not merely off the edge.
      final before = tester
          .getRect(find.byKey(const Key('segment-Short')))
          .left;
      await tester.drag(
        find.byType(SegmentedTrack<String>),
        const Offset(-60, 0),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byKey(const Key('segment-Short'))).left,
        lessThan(before),
      );
    });
  });

  testWidgets('an empty segment list renders nothing rather than throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(segments: const [], selected: '', onChanged: (_) {}),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SizedBox), findsWidgets);
  });

  test('the style compares by value, so it does not force repaints', () {
    // Two separately-built styles with the same tokens must be equal, or every
    // rebuild of a screen repaints its track.
    final twin = SegmentedTrackStyle(
      trackColor: AppColors.dark.pillTrackFill,
      trackRadius: 22,
      trackInsetShadows: AppElevation.dark.pillTrackInsetShadows,
      selectedColor: AppColors.dark.pillTrackSelectedFill,
      selectedRadius: 22,
      selectedInsetShadows: AppElevation.dark.pillTrackSelectedInsetShadows,
      labelStyle: AppType.h3,
      idleLabelColor: AppColors.dark.textSecondary,
      selectedLabelColor: AppColors.dark.background,
    );
    expect(twin, style);
    expect(twin.hashCode, style.hashCode);

    // `segmentPadding` is part of that identity: it decides how wide a segment
    // has to be, so a style that differs only there is a different layout.
    expect(
      twin.segmentPadding,
      const EdgeInsetsDirectional.symmetric(horizontal: 10),
      reason: "Figma's own segment padding, `180:5338` / `180:5340`",
    );
    final padded = SegmentedTrackStyle(
      trackColor: AppColors.dark.pillTrackFill,
      trackRadius: 22,
      trackInsetShadows: AppElevation.dark.pillTrackInsetShadows,
      selectedColor: AppColors.dark.pillTrackSelectedFill,
      selectedRadius: 22,
      selectedInsetShadows: AppElevation.dark.pillTrackSelectedInsetShadows,
      labelStyle: AppType.h3,
      idleLabelColor: AppColors.dark.textSecondary,
      selectedLabelColor: AppColors.dark.background,
      segmentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
    );
    expect(padded, isNot(style));
  });
}
