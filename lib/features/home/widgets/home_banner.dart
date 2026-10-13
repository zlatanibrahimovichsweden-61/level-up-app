import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// The "Learn Today, Lead Tomorrow" banner · Figma `337:5485`.
///
/// In the design this is a CAROUSEL of marketing slides with paging dots. Built
/// here as ONE static themed box, for two reasons:
///   - the illustration is export-blocked (View-only seat) — DESIGN_ISSUES #1;
///   - there is no content endpoint, so there are no slides to page BETWEEN.
///     Carousel mechanics over a single hardcoded slide would be motion for its
///     own sake.
///
/// TODO(design-asset): real banner artwork (Figma node 337:5486) + a decision on
/// where the slides come from before the paging dots are worth building.
class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      // 140 is the floor, not the height: the title is `displayLarge`, which
      // grows with the text scale and wraps in Arabic, so a fixed box clipped
      // it. Identical at 1.0x.
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ext.cardFill,
        borderRadius: BorderRadius.circular(15),
        // Home's accent, not colorScheme.primary — this placeholder sits on
        // Home, which is exempt from the green/purple flip (59:1439). The
        // frame gives no value for THIS box, so the token follows the
        // surface's rule rather than inventing a second one.
        border: Border.all(color: ext.homeAccent, width: 0.5),
      ),
      // `heightFactor: 1`: the Align takes its child's height (never the room
      // it is offered), so the box is the floor or the content, whichever is
      // taller, in a bounded parent as in Home's scrolling column. A bare
      // `alignment:` on the Container would stretch it to fill a bounded one.
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        heightFactor: 1,
        child: Row(
          children: [
            Icon(Icons.auto_stories_outlined, size: 32, color: ext.homeAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.learnTodayLeadTomorrow,
                style: AppType.displayLarge.copyWith(color: ext.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
