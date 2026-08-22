import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../quiz/models/quiz_type.dart';

/// The Lectures screen's quiz-type selector · Figma `180:5337`.
///
/// **Driven entirely by `tree.quizTypes`.** A subject with no practical
/// component does not list `practicalRevision`, and its tab must not appear —
/// so the row is built from the server's list, never from a hardcoded five.
///
/// The frame also draws a **"Flashcard"** tab. It is deliberately absent: the
/// contract's `quizTypes` enum has no flashcard value, flashcards are a separate
/// `flashcardSubscription` entitlement, and there is no M1 content endpoint to
/// open one with. Rendering it would be a tab that cannot do anything. See
/// docs/DESIGN_ISSUES.md #18.
///
/// Selecting a tab is local UI state — it filters nothing and re-fetches
/// nothing; it is carried into the `/quiz/setup` hand-off.
class QuizTypeTabs extends StatelessWidget {
  const QuizTypeTabs({
    super.key,
    required this.types,
    required this.selected,
    required this.onSelected,
  });

  final List<QuizType> types;
  final QuizType selected;
  final ValueChanged<QuizType> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        children: [
          for (final type in types) ...[
            _Tab(
              label: type.label(l10n),
              selected: type == selected,
              onTap: () => onSelected(type),
            ),
            if (type != types.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: selected ? cs.primary : ext.catalogCardFill,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            // Matches the row border, so tabs and rows read as one surface.
            border: Border.all(color: ext.fieldBorder, width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          child: Semantics(
            selected: selected,
            button: true,
            child: Text(
              label,
              style: AppType.labelMedium.copyWith(
                color: selected ? cs.onPrimary : ext.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
