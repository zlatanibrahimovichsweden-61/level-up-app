import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../../leaderboard/board_failure.dart';
import '../../leaderboard/models/leaderboard_models.dart';
import '../../leaderboard/notifier/leaderboard_notifier.dart';
import '../../leaderboard/widgets/board_avatar.dart';
import '../../profile/models/student_profile.dart';
import '../../profile/notifier/me_notifier.dart';

/// Home's "Top Student" block · `59:2086` (school), `125:2373` (university),
/// `337:5456` (dark): the top three of `GET /leaderboard`.
///
/// **Which board, and where "See All" goes, are owner decisions** (API→UI
/// Wave 05, 2026-09-24). The frame settles neither, and `scope` is required
/// with no server default. The block shows [LeaderboardScope.defaultFor] —
/// school `system`, university `global`, the board the Leaderboard tab opens
/// on — and "See All" opens that tab.
///
/// It reads the SAME `leaderboardProvider(scope)` instance as the tab: one
/// request serves both and the tab opens warm. Home takes the first three rows
/// of the tab's page one; a separate `limit: 3` read would be a second request
/// for rows the tab fetches anyway.
///
/// Each row is the frame's: medal · avatar · name · points. Rows are not
/// tappable (there is no student profile screen to open) and the caller's own
/// row gets no "You" treatment (the frame draws none).
///
/// States: loading · empty ([LeaderboardResults.isEmpty], never a short page) ·
/// error (the tab's copy and retry rules, [boardFailureText] and
/// [boardRetryAllowed]) · offline (its own copy). A failed board stays inside
/// this block — Home around it keeps working.
class TopStudentSection extends ConsumerWidget {
  const TopStudentSection({super.key, required this.profile});

  final StudentProfile profile;

  /// The frame draws three rows (`59:2091`, `59:2099`, `59:2107`).
  static const rowCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final scope = LeaderboardScope.defaultFor(profile);
    final board = ref.watch(leaderboardProvider(scope));

    // A finished quiz re-reads `/me` (the quiz screen invalidates
    // `meProvider`), and the level card above shows the new total at once. The
    // board ranks on that same total, so when it moves the board is fetched
    // again — otherwise a student in the top three would read two different
    // totals for themselves on one screen. The tab shares this instance and
    // gets the fresh board too.
    //
    // The WHOLE family, not `leaderboardProvider(scope)`: the tab may be
    // sitting on its other scope, and the shell's IndexedStack keeps that
    // notifier alive — so invalidating this block's key alone left a
    // Governorate board reading the old total after a quiz while the level
    // card above read the new one (Fable-eye audit 2026-10-06, FE-07).
    ref.listen(meProvider.select((me) => me.value?.points.total), (
      previous,
      next,
    ) {
      if (previous != null && next != null && previous != next) {
        ref.invalidate(leaderboardProvider);
      }
    });

    Future<void> retry() =>
        ref.read(leaderboardProvider(scope).notifier).refresh();

    final body = board.when(
      data: (results) => results.isEmpty
          ? _message(Icons.leaderboard_outlined, l10n.leaderboardEmpty)
          : TopStudentSurface(
              track: profile.track,
              child: _Rows(entries: results.items.take(rowCount).toList()),
            ),
      loading: () => TopStudentSurface(
        track: profile.track,
        height: TopStudentSurface.messageHeight,
        child: const Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, _) => isOffline(error)
          ? _message(Icons.wifi_off, l10n.offline, onRetry: retry)
          : _message(
              Icons.error_outline,
              boardFailureText(l10n, error),
              onRetry: boardRetryAllowed(error) ? retry : null,
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                l10n.topStudent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.h3.copyWith(color: ext.textPrimary),
              ),
            ),
            // Owner, Wave 05: opens the Leaderboard tab, which starts on the
            // same scope this block shows.
            Semantics(
              button: true,
              child: InkWell(
                onTap: () => context.go('/leaderboard'),
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  l10n.seeAll,
                  // The title's colour, as the frames draw it (W05-1).
                  style: AppType.bodyMedium.copyWith(color: ext.textPrimary),
                ),
              ),
            ),
          ],
        ),
        // The same 12 the placeholder sections use under their header.
        const SizedBox(height: 12),
        body,
      ],
    );
  }

  Widget _message(IconData icon, String text, {VoidCallback? onRetry}) =>
      TopStudentSurface(
        track: profile.track,
        height: TopStudentSurface.messageHeight,
        child: _Message(icon: icon, text: text, onRetry: onRetry),
      );
}

/// The block's card · `59:2090` / `337:5460`. It was the "coming soon"
/// placeholder's Top Student surface until Wave 05.
///
/// The hairline runs round ALL FOUR sides, 1.20791 on both canvases, with the
/// frame's 1.208 padding inside it: both frames say `border-[1.208px]` and
/// `p-[1.208px]`. `edit3.md` #3 read the border as top-only, and it was built
/// that way until the Wave 05 walk (W05-2). The university frame has no
/// back-light here (`349:16788` covers nothing, edit3.md #44), so that token
/// is school-only.
class TopStudentSurface extends StatelessWidget {
  const TopStudentSurface({
    super.key,
    required this.track,
    required this.child,
    this.height,
  });

  final Track track;
  final Widget child;

  /// Null sizes the card to its rows; the one-line states use [messageHeight].
  final double? height;

  /// The placeholder's height, kept for the one-line states so the page does
  /// not jump between loading, a message and the rows.
  static const messageHeight = 96.0;

  /// `p-[1.208px]` inside the border, both frames. It keeps the row dividers
  /// off the outline; without it their ends double the 10% violet.
  static const framePadding = 1.208;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final e = Theme.of(context).extension<AppElevation>()!;
    final light = switch (track) {
      Track.school => e.topStudentBacklightSchool,
      Track.university => null,
    };
    final glass = e.topStudentGlass;

    return ElevatedSurface(
      height: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.374941),
      ),
      color: ext.topStudentFill,
      side: e.topStudentBorderWidth > 0
          ? BorderSide(
              color: ext.topStudentBorder,
              width: e.topStudentBorderWidth,
            )
          : null,
      padding: EdgeInsets.all(e.topStudentBorderWidth + framePadding),
      glass: glass,
      // A back-light shows only through a frost (edit1.md R6).
      backlights: (glass == null || light == null) ? const [] : [light],
      child: child,
    );
  }
}

class _Rows extends StatelessWidget {
  const _Rows({required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final e = Theme.of(context).extension<AppElevation>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          // `59:2091` / `59:2099` close with a bottom stroke in the card's own
          // hairline colour and width; the last row (`59:2107`) has none.
          if (i > 0)
            ColoredBox(
              color: ext.topStudentBorder,
              child: SizedBox(
                height: e.topStudentBorderWidth,
                width: double.infinity,
              ),
            ),
          _TopStudentRow(entry: entries[i]),
        ],
      ],
    );
  }
}

/// One row · `59:2091`: 16.375 side padding, 12.281 above and below the
/// 40.134 avatar, and 12.281 between the four children.
class _TopStudentRow extends StatelessWidget {
  const _TopStudentRow({required this.entry});

  final LeaderboardEntry entry;

  static const _sidePadding = 16.375;
  static const _gap = 12.281;
  static const _avatar = 40.134;

  /// The medal column is 20.36 wide in all three rows.
  static const _medalWidth = 20.36;

  /// Ranks 1–3 as the frame draws them. Ranks are dense and start at 1, so
  /// the first three rows never rank below 3; the number fallback only guards
  /// against a server that breaks that.
  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final rank = entry.rank;
    final medal = rank >= 1 && rank <= _medals.length
        ? _medals[rank - 1]
        : '$rank';

    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: _sidePadding,
          vertical: _gap,
        ),
        child: Row(
          children: [
            SizedBox(
              width: _medalWidth,
              // The frame sets the medals at 16.8 and 20.5, off the scale;
              // `h3` (18) is the scale size between them and fills the 20.36
              // column.
              child: Text(
                medal,
                textAlign: TextAlign.center,
                style: AppType.h3,
              ),
            ),
            const SizedBox(width: _gap),
            BoardAvatar(url: entry.avatarUrl, diameter: _avatar),
            const SizedBox(width: _gap),
            Expanded(
              // Cairo SemiBold 13.3 in the frame; `labelLarge` (14, 600) is
              // the scale's semibold 14.
              child: Text(
                entry.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.labelLarge.copyWith(color: ext.topStudentName),
              ),
            ),
            const SizedBox(width: _gap),
            // Rajdhani Bold 13.3 in the frame, no unit ("18,200").
            Text(
              l10n.pointsValue(entry.points),
              style: AppType.labelLarge.copyWith(color: ext.topStudentPoints),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;

  /// Null withholds Retry (see [boardRetryAllowed]).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: ext.mutedText),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppType.captionRegular.copyWith(color: ext.mutedText),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ],
      ),
    );
  }
}
