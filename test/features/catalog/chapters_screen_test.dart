import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/features/catalog/screens/chapters_screen.dart';
import 'package:level_up_app/features/catalog/widgets/tree_list_row.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// Chapters · API→UI Wave 09.
///
/// The rhythm (W09-1): light `135:1270` and dark `337:6047` stack their 78 dp
/// rows on a 94 dp pitch, so the rows sit 16 apart, the same as Units. The
/// build had 12.
///
/// The unknown unit: the screen reads the cached tree and looks its unit up by
/// the id in the URL. An id that is not there (a stale link, a withdrawn unit)
/// or a university tree (which has no units at all) is EMPTY, never a crash and
/// never an error. The navigation tests reach an empty LESSONS level only.
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());
  });

  testWidgets('the rows sit 16 apart', (tester) async {
    await pumpCatalogApp(tester, catalog: catalog);
    await openLearnTab(tester);
    await tester.tap(find.text('Biology'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cell Biology'));
    await tester.pumpAndSettle();

    expect(find.byType(ChaptersScreen), findsOneWidget);
    final rows = find.byType(TreeListRow);
    expect(rows, findsNWidgets(2));
    expect(
      tester.getRect(rows.at(1)).top - tester.getRect(rows.at(0)).bottom,
      16,
    );
  });

  group('a unit the tree does not have', () {
    Future<void> openUnit(WidgetTester tester, String unitId) async {
      final container = await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);
      container.read(routerProvider).go('/learn/subject/sub-1/unit/$unitId');
      await tester.pumpAndSettle();
      expect(find.byType(ChaptersScreen), findsOneWidget);
    }

    testWidgets('an unknown unit id is empty, not an error', (tester) async {
      await openUnit(tester, 'unit-withdrawn');

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byType(TreeListRow), findsNothing);
      // No unit, so no name to title the screen after: the bare fallback.
      expect(find.text('Chapters'), findsOneWidget);
    });

    testWidgets('a university tree (no units at all) is empty too', (
      tester,
    ) async {
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => universityTree());
      await openUnit(tester, 'unit-1');

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byType(TreeListRow), findsNothing);
    });
  });
}
