import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/registration_draft.dart';
import '../notifier/registration_controller.dart';
import 'registration_expired_view.dart';

/// Sign Up_2 (track picker) · Figma `337:15947`. Single-select between School and
/// University — the discriminator `POST /auth/register` switches on. Continue is
/// disabled until a track is chosen; it sets the track on the draft and routes to
/// the (Day-3) track sub-flow. No network call on this screen.
class SignupTrackScreen extends ConsumerStatefulWidget {
  const SignupTrackScreen({super.key});

  @override
  ConsumerState<SignupTrackScreen> createState() => _SignupTrackScreenState();
}

class _SignupTrackScreenState extends ConsumerState<SignupTrackScreen> {
  RegTrack? _selected;

  @override
  void initState() {
    super.initState();
    // Preserve a previously-picked track on back-navigation.
    _selected = ref.read(registrationControllerProvider)?.track;
  }

  void _continue() {
    final track = _selected;
    if (track == null) return;
    ref.read(registrationControllerProvider.notifier).setTrack(track);
    // Day-3 sub-flow entries (placeholder routes for now).
    context.push(track == RegTrack.school ? '/register/school' : '/register/university');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final draft = ref.watch(registrationControllerProvider);
    final offline = ref.watch(isOnlineProvider).value == false;

    // Guard: reachable only within a live registration window.
    if (draft == null || draft.isExpired) {
      return const RegistrationExpiredView();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back),
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                        ),
                        const Spacer(),
                        LanguagePill(
                          label: l10n.switchLanguage,
                          onTap: () =>
                              ref.read(localeProvider.notifier).toggle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.chooseTrackTitle,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ext.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.chooseTrackSubtitle,
                      style: TextStyle(fontSize: 16, color: ext.textSecondary),
                    ),
                    const SizedBox(height: 28),
                    _TrackCard(
                      label: l10n.trackSchool,
                      icon: Icons.menu_book_outlined,
                      selected: _selected == RegTrack.school,
                      onTap: () =>
                          setState(() => _selected = RegTrack.school),
                    ),
                    const SizedBox(height: 16),
                    _TrackCard(
                      label: l10n.trackUniversity,
                      icon: Icons.school_outlined,
                      selected: _selected == RegTrack.university,
                      onTap: () =>
                          setState(() => _selected = RegTrack.university),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      // Disabled until a track is selected.
                      onPressed: _selected == null ? null : _continue,
                      child: Text(
                        l10n.continueLabel,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A large single-select track card. Selected state is theme-driven (primary
/// accent border + tint), so it follows the light/dark + track palettes.
class _TrackCard extends StatelessWidget {
  const _TrackCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: selected
                ? cs.primary.withValues(alpha: 0.08)
                : ext.fieldFill,
            border: Border.all(
              color: selected ? cs.primary : ext.fieldBorder,
              width: selected ? 2 : 1.17,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: selected ? cs.primary : ext.textSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ext.textPrimary,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? cs.primary : ext.hint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
