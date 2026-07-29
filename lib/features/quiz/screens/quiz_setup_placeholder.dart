import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/quiz_setup_args.dart';

/// `/quiz/setup` — the Day-6 hand-off point.
///
/// Day 5 ends at the lesson. This screen exists so the browse stack terminates
/// somewhere real and the arguments it passes are verifiable; the actual setup
/// UI (length 10/30/50, `POST /quizzes`) is Day 6 and is NOT built here.
///
/// It shows the lesson it was opened with — that is the contract between the two
/// days, and the router test asserts it.
class QuizSetupPlaceholderScreen extends StatelessWidget {
  const QuizSetupPlaceholderScreen({super.key, required this.args});

  final QuizSetupArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(title: Text(args.lessonName)),
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
            ],
          ),
        ),
      ),
    );
  }
}
