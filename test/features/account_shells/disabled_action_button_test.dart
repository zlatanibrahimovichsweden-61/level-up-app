import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/account_shells/widgets/shell_body.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

/// The shells' dead primary control, to TalkBack.
///
/// Its `Semantics(label)` and its painted `Text` used to merge into one node
/// that said the label twice — "Share invite, Share invite, Inviting friends
/// isn't available yet." (Fable-eye audit 2026-10-06, FE-05; BUG-016 and
/// BUG-018 were the same pattern elsewhere).
void main() {
  testWidgets('says its label ONCE, disabled, with the reason as the hint', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: DisabledActionButton(
            label: 'Share invite',
            disabledHint: 'Not yet.',
          ),
        ),
      ),
    );

    final node = tester.getSemantics(find.byType(DisabledActionButton));
    expect(node.label, 'Share invite');
    expect(node.hint, 'Not yet.');
    expect(
      node,
      isSemantics(isButton: true, hasEnabledState: true, isEnabled: false),
    );
    handle.dispose();
  });

  // RESPONSIVE.md #6: the button's 60 is Edit Profile's Save height, and it was a
  // fixed HEIGHT around a scalable label. It is now the button's FLOOR: exactly
  // 60 at the default scale, and tall enough for its label at a larger one (or
  // for an Arabic label that wraps).
  group('the 60 is a floor, not a height (RESPONSIVE #6)', () {
    Future<void> pumpShell(
      WidgetTester tester, {
      required String locale,
      required double width,
      required double textScale,
      required String label,
    }) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = Size(width, 900);
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      tester.platformDispatcher.textScaleFactorTestValue = textScale;

      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(locale),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ShellBody(
              icon: Icons.group_outlined,
              message: 'Not available yet.',
              action: DisabledActionButton(
                label: label,
                disabledHint: 'Not yet.',
              ),
            ),
          ),
        ),
      );
    }

    Rect buttonRect(WidgetTester tester) => tester.getRect(
      find
          .descendant(
            of: find.byType(DisabledActionButton),
            matching: find.byType(Container),
          )
          .first,
    );

    for (final (locale, label) in [
      ('en', 'Share invite'),
      ('ar', 'شارك الدعوة'),
    ]) {
      for (final width in [360.0, 402.0]) {
        testWidgets('$width dp · $locale · 1.0x · exactly 60 tall, as drawn', (
          tester,
        ) async {
          await pumpShell(
            tester,
            locale: locale,
            width: width,
            textScale: 1.0,
            label: label,
          );

          final button = buttonRect(tester);
          expect(button.height, 60);
          // Full width between ShellBody's 24 gutters.
          expect(button.width, width - 48);
          expect(tester.takeException(), isNull);
        });

        testWidgets('$width dp · $locale · 2.0x · a long label wraps INSIDE '
            'the button', (tester) async {
          await pumpShell(
            tester,
            locale: locale,
            width: width,
            textScale: 2.0,
            label: '$label $label $label',
          );

          final button = buttonRect(tester);
          final painted = find.descendant(
            of: find.byType(DisabledActionButton),
            matching: find.byType(Text),
          );
          expect(button.height, greaterThanOrEqualTo(60));
          // The button holds the label's WHOLE height. A paragraph's own rect
          // is clamped to the room it is given, so it cannot show a spill; the
          // height its lines need is measured with a painter instead.
          final paragraph = tester.renderObject<RenderParagraph>(painted);
          final painter = TextPainter(
            text: paragraph.text,
            textDirection: paragraph.textDirection,
            textScaler: paragraph.textScaler,
            maxLines: paragraph.maxLines,
            locale: paragraph.locale,
          )..layout(maxWidth: paragraph.size.width);
          addTearDown(painter.dispose);
          expect(
            button.height,
            greaterThanOrEqualTo(painter.height),
            reason: 'nothing spills out of the button',
          );
          expect(
            tester.getRect(painted).bottom,
            lessThanOrEqualTo(button.bottom),
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
  testWidgets('in a BOUNDED parent it is still exactly 60, not the room', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(402, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: DisabledActionButton(label: 'Share', disabledHint: 'x'),
          ),
        ),
      ),
    );

    expect(tester.getRect(find.byType(DisabledActionButton)).height, 60);
  });
}
