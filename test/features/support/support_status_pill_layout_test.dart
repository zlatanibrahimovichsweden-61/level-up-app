import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/support/widgets/support_status_pill.dart';
import 'package:level_up_app/features/support/widgets/support_ticket_row.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import '../../goldens/golden_harness.dart';
import 'support_fixtures.dart';

/// The status pills on a ticket row, measured in the app's OWN fonts.
///
/// The Open and In progress pills (owner-approved copy, O-14) are wider than
/// the drawn Closed pill, and the row gives the pill its full width before the
/// subject column takes the rest. The placeholder test face draws every glyph a
/// full em wide, so in the other support tests "In progress" at 2.0x on a
/// 320 dp screen overflows the row. Inter, Tajawal and Cairo do not: this file
/// loads them and checks the real thing, at the narrowest supported width and
/// up to 3.0x text, in both languages.
void main() {
  setUpAll(loadAppFonts);

  Widget host(
    Widget child, {
    required String language,
    required double screenWidth,
    required double scale,
  }) => MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale(language),
    builder: (context, app) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: app!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        // The list's 20 dp side insets (CW12a_PLAN §5.1).
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(width: screenWidth - 40, child: child),
        ),
      ),
    ),
  );

  for (final language in ['en', 'ar']) {
    for (final status in ['open', 'in_progress', 'closed', 'escalated']) {
      for (final screenWidth in [320.0, 360.0]) {
        for (final scale in [1.0, 2.0, 3.0]) {
          testWidgets('$status fits its row · $language · $screenWidth dp · '
              '${scale}x', (tester) async {
            await tester.binding.setSurfaceSize(Size(screenWidth, 3000));
            addTearDown(() => tester.binding.setSurfaceSize(null));

            await tester.pumpWidget(
              host(
                SupportTicketRow(
                  ticket: ticketSummary(
                    't-x',
                    status: status,
                    subject: 'Cannot open a lecture after the update',
                  ),
                  onTap: () {},
                ),
                language: language,
                screenWidth: screenWidth,
                scale: scale,
              ),
            );

            expect(tester.takeException(), isNull, reason: 'no overflow');
            final row = tester.getRect(find.byType(SupportTicketRow));
            final pill = tester.getRect(find.byType(SupportStatusPill));
            expect(
              row.contains(pill.topLeft) && row.contains(pill.bottomRight),
              isTrue,
              reason: 'the pill sits inside its row',
            );
            // The label stays on one line: `buttonSmall` is a 16 line, scaled.
            final label = find.descendant(
              of: find.byType(SupportStatusPill),
              matching: find.byType(Text),
            );
            expect(tester.getSize(label).height, lessThan(16 * scale * 1.5));
          });
        }
      }
    }
  }

  testWidgets('a pending row has no pill and nothing to overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      host(
        SupportTicketRow(
          ticket: ticketSummary('t-x', status: 'pending'),
          onTap: () {},
        ),
        language: 'ar',
        screenWidth: 320,
        scale: 3.0,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SupportStatusPill), findsNothing);
  });
}
