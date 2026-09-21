import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/registration/widgets/reference_dropdown.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// [PickerOption.enabled] — the per-option disabled capability.
///
/// Distinct from [ReferenceDropdown.enabled], which gates the WHOLE field on an
/// upstream selection (Faculty before University). This one is per row, and it
/// exists for rows the contract says must be visible but not selectable — a
/// `soon` study year being the case that forced it: the year is real, the
/// student can see their faculty offers it, and `POST /auth/register` answers
/// `validation_failed` if they pick it.
///
/// Phase 1 shipped the capability; Phase 2 wired the university year picker to
/// it, so `soon` years are now offered disabled rather than hidden. The
/// picker's own behaviour is covered in `university_detail_screen_test.dart` —
/// this file covers the widget in isolation.
void main() {
  PickerOption option(String id, {bool enabled = true}) =>
      (id: id, label: id.toUpperCase(), leading: null, enabled: enabled);

  Future<String?> pumpPicker(
    WidgetTester tester, {
    required List<PickerOption> rows,
  }) async {
    String? picked;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ReferenceDropdown(
              label: 'Year',
              value: null,
              options: AsyncData(rows),
              onSelected: (id) => picked = id,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return picked;
  }

  testWidgets('an enabled option is still selectable — no regression', (
    tester,
  ) async {
    // The half that matters most: the capability must not have changed the
    // behaviour of the seven pickers already shipping.
    String? picked;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ReferenceDropdown(
              label: 'Year',
              value: null,
              options: AsyncData([option('y1'), option('y2')]),
              onSelected: (id) => picked = id,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Y2').last);
    await tester.pumpAndSettle();

    expect(picked, 'y2');
  });

  testWidgets('a disabled option is SHOWN — not filtered out of the list', (
    tester,
  ) async {
    // "Visible but refused" is the whole point. Hiding the row is what the year
    // picker does today, and it is why a student cannot tell a year that does
    // not exist from one that is not open yet.
    await pumpPicker(
      tester,
      rows: [option('y1'), option('y2', enabled: false)],
    );

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    expect(find.text('Y2'), findsWidgets);
  });

  testWidgets('tapping a disabled option selects nothing', (tester) async {
    String? picked;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ReferenceDropdown(
              label: 'Year',
              value: null,
              options: AsyncData([option('y1'), option('y2', enabled: false)]),
              onSelected: (id) => picked = id,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Y2').last, warnIfMissed: false);
    await tester.pumpAndSettle();

    // A submitted `soon` id is a `validation_failed` the student cannot
    // explain, so nothing must reach the caller.
    expect(picked, isNull);
  });

  testWidgets('the DropdownMenuItem carries the flag through', (tester) async {
    await pumpPicker(
      tester,
      rows: [option('y1'), option('y2', enabled: false)],
    );

    // Read off the button rather than the rendered menu: a closed
    // `DropdownButton` puts no `DropdownMenuItem` in the tree at all, so
    // finding them by type would assert on nothing and pass once the list
    // happened to be empty.
    final items = tester
        .widget<DropdownButton<String>>(find.byType(DropdownButton<String>))
        .items!;

    expect(items, hasLength(2));
    expect(items[0].enabled, isTrue);
    expect(items[1].enabled, isFalse);
  });

  testWidgets('a disabled row can still be the CURRENT value', (tester) async {
    // The server may hold a selection that has since stopped being selectable.
    // Blanking the field would lose a value the student never changed.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ReferenceDropdown(
              label: 'Year',
              value: 'y2',
              options: AsyncData([option('y1'), option('y2', enabled: false)]),
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Read the RESOLVED value off the button. `find.text('Y2')` would prove
    // nothing here — the row is in the items list whether or not the lookup
    // resolves it, so that assertion passed either way. This one goes red if
    // the lookup ever starts filtering on `enabled`, which is the regression
    // the comment in `reference_dropdown.dart` warns about.
    final button = tester.widget<DropdownButton<String>>(
      find.byType(DropdownButton<String>),
    );
    expect(button.value, 'y2');
  });
}
