// Platform-sensitive: the .png baselines were captured on Windows and Flutter
// goldens embed platform text shaping and anti-aliasing, so these fail on a
// Linux runner even when the code is correct. The tag lets CI select by
// intent rather than by directory — see dart_test.yaml.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/widgets/quiz_type_tabs.dart';
import 'package:level_up_app/features/home/widgets/coming_soon_section.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';

import 'golden_harness.dart';

/// The two edit3 surfaces whose DARK rendering has no other pixel coverage.
///
/// Everything else this wave touched is asserted by token reads
/// (`coming_soon_section_test.dart`, `tree_list_row_test.dart`), which catch a
/// widget reading the wrong token but say nothing about what the frost, the
/// rim and the inset shadows actually draw. These two do:
///
///  * the Daily Tasks placeholder is the wave's only back-light behind a
///    frosted surface outside the level card, and the school ellipse is small
///    enough (100x14) that a mirroring or sigma regression is visible;
///  * the segmented track is the only place where TWO inner shadows work
///    against each other — the groove darkened along its bottom edge, the
///    selected segment along its top — and the sign of that pair is the single
///    easiest thing in this wave to get backwards. A token read cannot tell
///    the two apart; a pixel can.
///
/// Both are captured in dark only. Light draws no Glass, no back-light and no
/// inset shadow on either, so a light baseline would be pinning a flat
/// rectangle.
void main() {
  setUpAll(loadAppFonts);

  testWidgets('home section · daily tasks · dark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 160));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      goldenApp(
        brightness: Brightness.dark,
        child: const Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: ComingSoonSection(
            title: 'Daily Tasks',
            surface: ComingSoonSurface.dailyTasks,
            track: Track.school,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ComingSoonSection),
      matchesGoldenFile('home_section_daily_tasks_dark.png'),
    );
  });

  testWidgets('quiz type tabs · dark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      goldenApp(
        brightness: Brightness.dark,
        child: QuizTypeTabs(
          types: const [
            QuizType.normal,
            QuizType.midTermRevision,
            QuizType.finalRevision,
          ],
          // Not the first segment: a selected FIRST segment would sit in the
          // track's own rounded corner, where the selected pill's radius and
          // the track's overlap and neither can be judged.
          selected: QuizType.midTermRevision,
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(QuizTypeTabs),
      matchesGoldenFile('quiz_type_tabs_dark.png'),
    );
  });
}
