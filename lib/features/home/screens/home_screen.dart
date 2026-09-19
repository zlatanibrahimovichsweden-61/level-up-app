import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/models/student_profile.dart';
import '../../profile/notifier/me_notifier.dart';
import '../widgets/coming_soon_section.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/level_card.dart';

/// Home · Figma `337:5303` (school) and `125:2373` (university). The first tab
/// of the nav shell, and ONE screen for both tracks.
///
/// Powered by ONE call, `GET /me`, which is track-agnostic — header, level card
/// and points are identical on both frames. The two frames differ in exactly one
/// place: university adds a **Learning Tools** section between Daily Tasks and
/// Continue Learning. That is a `track` branch on the profile the server already
/// returned, not a second screen.
///
/// Only the header and the level card are real; Daily Tasks / Learning Tools /
/// Continue Learning / Top Student have no endpoint yet and render as
/// coming-soon sections (see [ComingSoonSection] for why they are not populated
/// with the frame's sample values).
///
/// States: loading (a skeleton shaped like the header + level card, not a bare
/// spinner) · error (retry re-calls `/me` on tap) · offline (its own view, and a
/// pinned banner when connectivity drops while data is already on screen).
/// There is no EMPTY state: `/me` either returns a profile or fails.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(meProvider);
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    return Scaffold(
      body: SafeArea(
        bottom: false, // the nav shell owns the bottom inset
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: me.when(
                data: (profile) => _Loaded(profile: profile),
                loading: () => const _Skeleton(),
                error: (error, _) => _Failure(
                  error: error,
                  onRetry: () => ref.read(meProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.profile});
  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHeader(name: profile.name, avatarUrl: profile.avatar.url),
          const SizedBox(height: 25),
          // Server-authoritative, straight from GET /me — never recomputed.
          // `track` is passed for the dark back-light only: the two frames'
          // ellipses sit two pixels apart and neither is derived.
          LevelCard(
            level: profile.level,
            totalPoints: profile.points.total,
            track: profile.track,
          ),
          const SizedBox(height: 25),
          ComingSoonSection(
            title: l10n.dailyTasks,
            surface: ComingSoonSurface.dailyTasks,
            track: profile.track,
          ),
          const SizedBox(height: 25),
          // University only (`125:2373`) — the school frame has no such section.
          // The frame draws five shortcut cards (Flash Card, Normal EX, Midterm,
          // Final, Practices) behind a premium crown. Every one of them needs an
          // endpoint that does not exist yet: the four quiz types need
          // `POST /quizzes` (Day 7), and Flashcard has no M1 content endpoint at
          // all (docs/DESIGN_ISSUES.md #18). Stubbed rather than drawn as dead
          // cards a student can tap into nothing.
          if (profile.track == Track.university) ...[
            // `plain`, not a section surface of its own: the frame's five
            // Learning Tools tiles are recorded unbuilt (DESIGN_ISSUES #20,
            // edit3.md #43) and there is no surface behind them to take.
            ComingSoonSection(
              title: l10n.learningTools,
              surface: ComingSoonSurface.plain,
              track: profile.track,
            ),
            const SizedBox(height: 25),
          ],
          // TODO(day7): the university frame's row reads "12 lecture left" where
          // school reads "lesson". Both live inside this section's CONTENT,
          // which is quiz-history data we deliberately do not invent — so the
          // noun has nowhere to render today. Whoever builds the real card must
          // pick it by track, not hardcode "lesson".
          ComingSoonSection(
            title: l10n.continueLearning,
            surface: ComingSoonSurface.continueLearning,
            track: profile.track,
          ),
          const SizedBox(height: 25),
          ComingSoonSection(
            title: l10n.topStudent,
            surface: ComingSoonSurface.topStudent,
            track: profile.track,
          ),
          const SizedBox(height: 25),
          const HomeBanner(),
        ],
      ),
    );
  }
}

/// Loading — grey blocks in the shape of the header and level card, so the page
/// doesn't jump when the real content lands.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _Block(width: 51, height: 51, radius: 51),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Block(width: 90, height: 10),
                  SizedBox(height: 8),
                  _Block(width: 140, height: 12),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          const _Block(height: 171, radius: 15),
          const SizedBox(height: 25),
          // 24, not 18: a section title is one h3 line (18 x 24/18) since the
          // type scale, so the block stands in for exactly that and the page
          // does not shift when the profile arrives. The 171 above is the
          // level card's pre-scale stand-in and is left for the device pass
          // (register SF-09 / DP-01).
          const _Block(width: 120, height: 24),
          const SizedBox(height: 12),
          const _Block(height: 96, radius: 15),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({this.width, required this.height, this.radius = 6});
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ext.progressTrack,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Error and Offline. Offline is NOT a generic error: it gets its own icon and
/// copy, chosen by the exception type the repository threw.
class _Failure extends StatelessWidget {
  const _Failure({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final wasOffline = isOffline(error);

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              wasOffline ? Icons.wifi_off : Icons.error_outline,
              size: 48,
              color: ext.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              // Server `title`/`detail` are developer-facing English and are
              // never shown; the mapped copy is.
              wasOffline ? l10n.offline : l10n.genericError,
              textAlign: TextAlign.center,
              style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
            ),
            const SizedBox(height: 20),
            // Retry re-triggers the same request on tap — never a silent loop.
            FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
