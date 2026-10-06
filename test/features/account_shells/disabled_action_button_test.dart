import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/account_shells/widgets/shell_body.dart';

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
      isSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    handle.dispose();
  });
}
