import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/quiz_setup_args.dart';
import '../models/quiz_type.dart';

/// `/quiz/setup` — the Day-7 hand-off point.
///
/// Both tracks end here: school at a lesson, university at a lecture plus the
/// quiz type chosen on the tab row. The screen exists so the browse stacks
/// terminate somewhere real and the arguments they pass are verifiable; the
/// actual setup UI (length 10/30/50, `POST /quizzes`) is Day 7 and is NOT built.
///
/// It shows what it was opened with — that is the contract between the days, and
/// the router tests assert it.
class QuizSetupPlaceholderScreen extends StatelessWidget {
  const QuizSetupPlaceholderScreen({super.key, required this.args});

  final QuizSetupArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    final quizType = args.quizType;

    return Scaffold(
      appBar: AppBar(title: Text(args.scopeName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 48, color: ext.mutedText),
              const SizedBox(height: 16),
              Text(
                l10n.quizSetupComingSoon,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ext.textSecondary),
              ),
              // University only — shown so the selection made on the Lectures
              // tab row is visible end-to-end on device, not just in a test.
              if (quizType != null) ...[
                const SizedBox(height: 8),
                Text(
                  quizType.label(l10n),
                  style: TextStyle(fontSize: 14, color: ext.mutedText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
