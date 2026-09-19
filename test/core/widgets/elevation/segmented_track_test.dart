import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/theme/app_typography.dart';
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

  group('no overflow at 1.3x text scale', () {
    // The measured breaking point for this project's cards
    // (docs/RESPONSIVE.md). Labels scale down rather than clip or overflow.
    for (final entry in <String, List<String>>{
      'en': ['Multiple choice', 'True or False', 'Essay'],
      'ar': ['اختيار من متعدد', 'صح أو خطأ', 'مقال'],
    }.entries) {
      testWidgets(entry.key, (tester) async {
        await tester.pumpWidget(
          host(
            segments: entry.value,
            selected: entry.value.first,
            onChanged: (_) {},
            direction: entry.key == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            textScale: 1.3,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
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
  });
}
