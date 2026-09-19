import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/leaderboard_models.dart';

/// The two-segment scope switcher · Figma "Global / Cohort".
///
/// The frame draws two different controls: the university board switches
/// `Global | Cohort`, which are contract scopes, and the school board switches
/// `NOW | Last Month`, which are **not** — the contract has no time dimension at
/// all and no historical board exists. Both boards are therefore built as the
/// university one: a scope switcher. The school segments are its two scopes,
/// `System | Governorate`.
///
/// [scopes] comes from [LeaderboardScope.scopesFor], so the control can only
/// ever offer a scope the caller's track and country allow — a school student
/// outside Egypt has no `governorate` board, and rather than draw a segment
/// that is guaranteed to answer `400`, the control hides itself.
class ScopeToggle extends StatelessWidget {
  const ScopeToggle({
    super.key,
    required this.scopes,
    required this.selected,
    required this.onChanged,
    required this.labelFor,
  });

  final List<LeaderboardScope> scopes;
  final LeaderboardScope selected;
  final ValueChanged<LeaderboardScope> onChanged;
  final String Function(LeaderboardScope scope) labelFor;

  /// Figma `158:839`: the track is 362 × 44 with radius 32, inset 20 from each
  /// edge of the 402pt frame. The active pill (`158:840`) is 44 high with
  /// radius 51 — at this height both radii are already past the half-height mark, so a
  /// half-height radius renders identically and is used instead of carrying two
  /// numbers that cannot differ on screen.
  static const _height = 44.0;

  @override
  Widget build(BuildContext context) {
    if (scopes.length < 2) return const SizedBox.shrink();

    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: ext.progressTrack,
        borderRadius: BorderRadius.circular(_height / 2),
      ),
      child: Row(
        children: [
          for (final scope in scopes)
            Expanded(
              child: _Segment(
                label: labelFor(scope),
                selected: scope == selected,
                onTap: () => onChanged(scope),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? ext.podiumAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(ScopeToggle._height / 2),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // Figma `158:841` is Inter 500 / 18px. [AppType.h3] is the only
            // 18pt token and carries w600 — one weight step heavier. The size
            // is now exact; the weight divergence is recorded rather than fixed
            // with a new scale entry, which would raise the hardcoded-fontSize
            // ratchet that Wave 3D is blocked on.
            style: AppType.h3.copyWith(
              color: selected ? ext.podiumOnAccent : ext.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
