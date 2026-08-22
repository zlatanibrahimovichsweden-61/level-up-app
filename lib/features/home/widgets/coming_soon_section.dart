import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// A Home section whose CONTENT has no endpoint yet — Daily Tasks (`337:5353`),
/// Continue Learning (`337:5427`), Top Student (`337:5456`).
///
/// The section header is real (it is in the frame and costs nothing); the body
/// is an explicit "Coming soon" card. Deliberately NOT populated with the
/// frame's sample rows: "Complete 2 Quizzes 1/2", "Physics 80%", "Sara 18,200"
/// are the designer's mock values, and rendering them would put invented
/// progress and invented leaderboard standings in front of a real student.
/// Every one needs a draft or non-existent endpoint:
///   - Daily Tasks       → no tasks endpoint in the contract at all
///   - Continue Learning → quiz history (draft)
///   - Top Student       → `GET /leaderboard` (stable, but it is the
///                         Leaderboard tab's data and out of Day 4's scope)
///
/// `See All` is inert for the same reason — there is nothing to see all of yet.
class ComingSoonSection extends StatelessWidget {
  const ComingSoonSection({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.h3.copyWith(color: ext.textPrimary),
              ),
            ),
            Text(
              l10n.seeAll,
              style: AppType.bodyMedium.copyWith(color: ext.mutedText),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 96,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: ext.cardFill,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, size: 18, color: ext.mutedText),
              const SizedBox(width: 8),
              Text(
                l10n.comingSoon,
                style: AppType.captionRegular.copyWith(color: ext.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
