import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/screens/lessons_screen.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// Lessons · API→UI Wave 10.
///
/// The rhythm (W10-1): light `135:1485` and dark `337:6143` stack their 78 dp
/// rows on a 94 dp pitch, so the rows sit 16 apart, as on Units and Chapters.
/// The build had 12.
///
/// The semantics: Lessons is the school level whose rows carry a bar, so it is
/// where W08-6 (a row exposed as a progress bar) would come back. The row test
/// covers the widget; this covers the screen.
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());
  });

  /// Learn → Biology → Cell Biology → The Cell (two lessons).
  Future<void> openLessons(WidgetTester tester) async {
    await pumpCatalogApp(tester, catalog: catalog);
    await openLearnTab(tester);
    for (final name in ['Biology', 'Cell Biology', 'The Cell']) {
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
    }
    expect(find.byType(LessonsScreen), findsOneWidget);
  }

  testWidgets('the rows sit 16 apart', (tester) async {
    await openLessons(tester);

    final rows = find.byType(TreeListRow);
    expect(rows, findsNWidgets(2));
    expect(
      tester.getRect(rows.at(1)).top - tester.getRect(rows.at(0)).bottom,
      16,
    );
  });

  testWidgets('every lesson row is a button, not a progress bar', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await openLessons(tester);

    final rows = find.byType(TreeListRow);
    for (var i = 0; i < 2; i++) {
      final node = tester.getSemantics(rows.at(i));
      expect(node.role, isNot(SemanticsRole.progressBar), reason: 'row $i');
      expect(node.value, isEmpty, reason: 'row $i');
      expect(
        node,
        isSemantics(isButton: true, hasTapAction: true),
        reason: 'row $i',
      );
    }
    expect(tester.getSemantics(rows.at(0)).label, contains('0 / 25 questions'));
    expect(
      tester.getSemantics(rows.at(1)).label,
      contains('40 / 40 questions'),
    );
    handle.dispose();
  });
}
