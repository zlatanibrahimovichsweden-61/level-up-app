import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/segmented_track.dart';
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
    // Ahead of every sized surface, deliberately: a one-scope board draws
    // nothing at all, and `leaderboard_screen_test.dart` measures that as a
    // height of exactly 0.
    if (scopes.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return SegmentedTrack<LeaderboardScope>(
      segments: scopes,
      selected: selected,
      onChanged: onChanged,
      labelOf: labelFor,
      height: _height,
      style: SegmentedTrackStyle(
        // `progressTrack` stood in for this until the track was read; it is
        // the same `#ECECEC` in light and a different grey in dark.
        trackColor: ext.scopeTrackFill,
        trackRadius: 32,
        // Dark only: a lavender inner glow on the leading edge above a
        // black inner shadow, which is what makes the groove read recessed
        // (`337:5615`). Light draws a flat track and the list is empty.
        trackInsetShadows: elevation.scopeTrackInsetShadows,
        // There is no idle fill to pass: the primitive always draws an
        // unselected segment transparent, which is what lets this groove's
        // two inner shadows show through it. The 2087-pixel measurement that
        // settled it was taken on THIS control's dark golden and lives in
        // `segmented_track.dart`; owner ruling 2026-09-20,
        // docs/DESIGN_ISSUES.md #84.
        selectedColor: ext.scopeSelectedFill,
        selectedRadius: _height / 2,
        selectedInsetShadows: elevation.scopeSelectedInsetShadows,
        // Figma `158:841` / `337:5617` is Inter 500 / 18. [AppType.h3] is
        // the only 18pt token and carries w600 — one weight step heavier.
        // The size is exact; the weight divergence is recorded rather than
        // patched with a `copyWith`, which the typography guard bans
        // outright, or with a new scale entry, which only the designer can
        // supply.
        labelStyle: AppType.h3,
        // READ 2026-09-20, both canvases: idle `158:843` / `337:5619`,
        // selected `158:841` / `337:5617`. `edit4.md` §7.8 asked for
        // `textSecondary` on the idle label; the frame says a dark green in
        // light, which is the same correction DESIGN_ISSUES #77 made on the
        // sibling pill track.
        //
        // The SELECTED label is a live AA failure - 1.74:1 in light on
        // `#DBB0FF`, 2.02:1 in dark on `#C4A8E3`. Worse than the 2.74:1 the
        // owner accepted for the pill track, and a different colour pair, so
        // #77's ruling does not reach it. Drawn as measured and routed to
        // the designer; no colour is chosen here.
        idleLabelColor: ext.scopeIdleLabel,
        selectedLabelColor: ext.podiumOnAccent,
        // Figma `Padding 10` on `158:840` itself. The primitive defaults to
        // the same number off the QUIZ TAB's frames, which would have been
        // this screen silently inheriting another screen's reading - so it
        // is passed explicitly even though it changes nothing.
        segmentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      ),
    );
  }
}
