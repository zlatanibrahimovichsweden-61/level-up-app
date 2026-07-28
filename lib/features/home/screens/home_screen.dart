import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/models/student_profile.dart';
import '../../profile/notifier/me_notifier.dart';
import '../widgets/coming_soon_section.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/level_card.dart';

/// Home (school) · Figma `337:5303`. The first tab of the nav shell.
///
/// Powered by ONE call, `GET /me`. Only the header and the level card are real;
/// Daily Tasks / Continue Learning / Top Student have no endpoint yet and render
/// as coming-soon sections (see [ComingSoonSection] for why they are not
/// populated with the frame's sample values).
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
          LevelCard(level: profile.level, totalPoints: profile.points.total),
          const SizedBox(height: 25),
          ComingSoonSection(title: l10n.dailyTasks),
          const SizedBox(height: 25),
          ComingSoonSection(title: l10n.continueLearning),
          const SizedBox(height: 25),
          ComingSoonSection(title: l10n.topStudent),
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
          const _Block(width: 120, height: 18),
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
              style: TextStyle(fontSize: 16, color: ext.textSecondary),
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
