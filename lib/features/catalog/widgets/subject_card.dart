import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject.dart';
import 'catalog_scaffold.dart';

/// One cell of the Subjects grid · Figma `337:5732`.
///
/// Name + chevron, a progress bar, and the `{answered} / {total} questions`
/// caption. The counter is DISPLAY ONLY (contract: "never locks retakes") — this
/// card is fully tappable at `0 / 0` and at `480 / 480` alike. Nothing here
/// reads the counter to decide anything.
class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.subject, required this.onTap});

  final Subject subject;
  final VoidCallback onTap;

  /// Figma card 173 × 89.
  static const aspectRatio = 173 / 89;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;
    final counter = subject.questionCounter;

    return Material(
      color: ext.catalogCardFill,
      borderRadius: BorderRadius.circular(10.7),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(9, 11, 9, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      // Already in the content language (adr-018) — rendered
                      // verbatim, never looked up in the ARB.
                      subject.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ext.textPrimary,
                      ),
                    ),
                  ),
                  Icon(forwardChevron(context), size: 16, color: ext.textPrimary),
                ],
              ),
              const SizedBox(height: 10),
              // Mirrors itself under RTL via Directionality, so the bar fills
              // from the correct edge in Arabic for free.
              LinearProgressIndicator(
                value: counter.fraction,
                minHeight: 4,
                backgroundColor: ext.catalogTrack,
                color: cs.primary,
                borderRadius: BorderRadius.circular(52),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.questionsCount(counter.answered, counter.total),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // The frame specifies 8.56dp; raised to 10 — 8.5dp is below any
                // readable minimum on a real phone. Flagged to the designer.
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ext.cardLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
