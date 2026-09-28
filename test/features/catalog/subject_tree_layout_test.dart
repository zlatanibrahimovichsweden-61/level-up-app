import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/widgets/quiz_type_tabs.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// The subject tree root's list rhythm · API→UI Wave 08 (W08-5).
///
/// Every frame of this screen stacks its 78 dp rows on a 94 dp pitch, so the
/// rows sit 16 apart: Units light `135:815` and dark `337:5894` (measured off
/// the render), Lectures `180:5354` / `180:5208` and dark `349:15962` /
/// `337:11059`. On Lectures the first row sits 25 below the quiz-type tabs
/// (tabs at 81 + 44, list at 150, on all four). The build had 12 and 20.
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
  });

  Future<void> openBiology(WidgetTester tester, Track track) async {
    await pumpCatalogApp(tester, catalog: catalog, track: track);
    await openLearnTab(tester);
    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();
  }

  testWidgets('school Units: the rows sit 16 apart', (tester) async {
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());
    await openBiology(tester, Track.school);

    final rows = find.byType(TreeListRow);
    expect(
      tester.getRect(rows.at(1)).top - tester.getRect(rows.at(0)).bottom,
      16,
    );
  });

  testWidgets('university Lectures: the rows sit 16 apart, the first 25 below '
      'the tabs', (tester) async {
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => universityTree());
    await openBiology(tester, Track.university);

    final rows = find.byType(TreeListRow);
    expect(
      tester.getRect(rows.at(1)).top - tester.getRect(rows.at(0)).bottom,
      16,
    );
    expect(
      tester.getRect(rows.at(0)).top -
          tester.getRect(find.byType(QuizTypeTabs)).bottom,
      25,
    );
  });
}
