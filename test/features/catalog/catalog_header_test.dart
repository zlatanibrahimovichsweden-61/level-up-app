import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/catalog/screens/units_screen.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import 'catalog_fixtures.dart';
import 'catalog_harness.dart';

/// The catalog header's back chip · API→UI Wave 08 (W08-2, KNOWN_BUGS BUG-010).
///
/// The chip must exist exactly when THIS route has somewhere to go back to.
/// The Subjects root is a tab root, so it never does.
///
/// It used to ask `GoRouter.canPop()`, which answers for the whole app (the
/// root navigator first) and is read once, in build — `InheritedGoRouter`
/// never notifies. So anything that rebuilt the Subjects root while a route
/// sat on the ROOT navigator (Settings, above the shell) baked a chip into it,
/// and nothing took it out again after that route closed. Tapping it then
/// popped nothing. Device-proven on a tablet 2026-09-20, and reproduced every
/// time on a Pixel 8 on 2026-09-25 as Account → Settings → change the theme →
/// Back → Learn (W07-6).
void main() {
  late MockCatalogRepository catalog;

  setUp(() {
    catalog = MockCatalogRepository();
    when(catalog.getSubjects).thenAnswer((_) async => subjects());
    when(
      () => catalog.getSubjectTree(any()),
    ).thenAnswer((_) async => schoolTree());
  });

  /// The same app the harness pumped, on another theme.
  ///
  /// Changing the theme in Settings rebuilds every widget that reads it, and
  /// that includes the Learn branch sitting offstage in the shell's
  /// `IndexedStack`. The router instance is the one already in use, so no
  /// navigation state is lost; only the rebuild happens.
  Future<void> switchTheme(
    WidgetTester tester,
    ProviderContainer container,
    ThemeData theme,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final track in Track.values) {
    group('${track.name}:', () {
      testWidgets('a fresh Subjects root draws no back chip', (tester) async {
        await pumpCatalogApp(tester, catalog: catalog, track: track);
        await openLearnTab(tester);

        expect(find.byType(SubjectsScreen), findsOneWidget);
        expect(find.byType(CircleBackButton), findsNothing);
      });

      testWidgets('the Subjects root stays chip-free after Settings rebuilt '
          'it (the W07-6 repro)', (tester) async {
        final container = await pumpCatalogApp(
          tester,
          catalog: catalog,
          track: track,
        );
        // Learn first, so the branch exists and is kept offstage from here on.
        await openLearnTab(tester);

        await tester.tap(find.text('Account').last);
        await tester.pumpAndSettle();
        final router = container.read(routerProvider);
        router.push('/settings');
        await tester.pumpAndSettle();

        // Settings is on the ROOT navigator while this rebuild happens.
        await switchTheme(tester, container, AppTheme.dark);

        router.pop();
        await tester.pumpAndSettle();
        await openLearnTab(tester);

        expect(find.byType(SubjectsScreen), findsOneWidget);
        expect(
          find.byType(CircleBackButton),
          findsNothing,
          reason:
              'A tab root has nothing to pop. A chip here is the dead control '
              'the device walks found.',
        );
      });
    });
  }

  testWidgets(
    'one level down the chip is there, and it goes back to the root',
    (tester) async {
      await pumpCatalogApp(tester, catalog: catalog);
      await openLearnTab(tester);
      await tester.tap(find.text('Biology'));
      await tester.pumpAndSettle();

      expect(find.byType(UnitsView), findsOneWidget);
      expect(find.byType(CircleBackButton), findsOneWidget);

      await tester.tap(find.byType(CircleBackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SubjectsScreen), findsOneWidget);
      expect(find.byType(CircleBackButton), findsNothing);
    },
  );
}
