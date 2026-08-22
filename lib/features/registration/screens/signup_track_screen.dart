import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
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
    context.push(
      track == RegTrack.school ? '/register/school' : '/register/university',
    );
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
                // Side inset is 20 in the frame, not 24.
                padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleBackButton(onPressed: () => context.pop()),
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
                      style: AppType.h1.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.chooseTrackSubtitle,
                      style: AppType.bodyLarge.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _TrackCard(
                      label: l10n.trackSchool,
                      art: 'assets/images/track_school.svg',
                      selected: _selected == RegTrack.school,
                      onTap: () => setState(() => _selected = RegTrack.school),
                    ),
                    const SizedBox(height: 16),
                    _TrackCard(
                      label: l10n.trackUniversity,
                      art: 'assets/images/track_university.svg',
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
                        style: AppType.buttonLarge,
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

/// A large single-select track card · Figma `82:1785` (light) / `337:15947`
/// (dark), cards `125:862` / `125:959`.
///
/// UNSELECTED is drawn to the frame: 112 tall, radius 25, page-fill surface, a
/// 1px gradient outline in light and none in dark, the 98-ish illustration in
/// the leading slot and an r=9.5 hollow radio ring.
///
/// SELECTED is NOT in the frame — both cards are drawn unselected there. The
/// primary-at-8% wash, 2px solid border and filled radio below are the
/// invention that shipped on Day 2 and are kept EXACTLY as they were
/// (docs/DESIGN_ISSUES.md #40, open question 4). Swapping them for a
/// better-looking second guess would just move the problem.
class _TrackCard extends StatelessWidget {
  const _TrackCard({
    required this.label,
    required this.art,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String art;
  final bool selected;
  final VoidCallback onTap;

  static const _height = 112.0;
  static const _radius = 25.0;

  /// The illustration's slot. The frame puts the label at x=107, so the art
  /// owns the leading ~99 and the gap is what is left.
  static const _artSlot = 99.0;

  /// Tallest of the two exports (track_school is 99×101); BoxFit.contain then
  /// letterboxes the 98×97 university cap into the same slot rather than
  /// stretching it.
  static const _artHeight = 101.0;
  static const _labelStart = 107.0;
  static const _trailingInset = 20.0;

  /// The invented selected state's border. Unselected is a 1px gradient.
  static const _selectedBorderWidth = 2.0;
  static const _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    final start = ext.trackCardBorderStart;
    final end = ext.trackCardBorderEnd;
    // Null in dark: the frame draws no outline there at all.
    final hasGradientBorder = !selected && start != null && end != null;
    final borderWidth = selected
        ? _selectedBorderWidth
        : (hasGradientBorder ? _borderWidth : 0.0);

    final surface = Container(
      decoration: BoxDecoration(
        color: selected ? cs.primary.withValues(alpha: 0.08) : ext.background,
        borderRadius: BorderRadius.circular(_radius - borderWidth),
      ),
      child: Row(
        children: [
          SizedBox(
            width: _artSlot,
            // The two track illustrations are the ONLY assets in this pass
            // rendered without a colorFilter — they are full-colour art, not
            // glyphs.
            child: SvgPicture.asset(
              art,
              width: _artSlot,
              height: _artHeight,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: _labelStart - _artSlot),
          Expanded(
            child: Text(
              label,
              style: AppType.h3.copyWith(color: ext.textPrimary),
            ),
          ),
          _Radio(selected: selected),
          const SizedBox(width: _trailingInset),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: Container(
          height: _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            // Flutter has no gradient Border, so the outline is a
            // gradient-filled box with the surface inset 1px on top of it.
            gradient: hasGradientBorder
                ? LinearGradient(
                    begin: AlignmentDirectional.topEnd,
                    end: AlignmentDirectional.bottomStart,
                    colors: [start, end],
                  )
                : null,
            color: selected ? cs.primary : null,
          ),
          padding: EdgeInsets.all(borderWidth),
          child: surface,
        ),
      ),
    );
  }
}

/// The frame's radio: a circle of radius 9.5 with a 1px ring and no fill.
/// The CHECKED form is the Day-2 invention, kept as-is — see [_TrackCard].
class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  static const _diameter = 19.0; // r = 9.5

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    if (selected) {
      return Icon(
        Icons.radio_button_checked,
        size: _diameter,
        color: cs.primary,
      );
    }
    return Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ext.trackRadioRing),
      ),
    );
  }
}
