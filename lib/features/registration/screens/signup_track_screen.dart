import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/layer_blur.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
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
                        CircleBackButton(
                          onPressed: () => context.pop(),
                          variant: BackChipVariant.registration,
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
                    // School is the FIRST card on both canvases — read off
                    // `337:15947` and `82:1785` on 2026-09-20, which is what
                    // decides which Glass token each one gets. The build
                    // already had this order; the read is what makes it a
                    // fact rather than a coincidence.
                    _TrackCard(
                      index: 0,
                      label: l10n.trackSchool,
                      art: 'assets/images/track_school.svg',
                      // Only this card's illustration carries one; see
                      // [_TrackCard.artShadow].
                      artShadow: true,
                      selected: _selected == RegTrack.school,
                      onTap: () => setState(() => _selected = RegTrack.school),
                    ),
                    const SizedBox(height: 16),
                    _TrackCard(
                      index: 1,
                      label: l10n.trackUniversity,
                      art: 'assets/images/track_university.svg',
                      artShadow: false,
                      selected: _selected == RegTrack.university,
                      onTap: () =>
                          setState(() => _selected = RegTrack.university),
                    ),
                    const SizedBox(height: 32),
                    PrimaryCta(
                      enabled: _selected != null,
                      child: FilledButton(
                        // Disabled until a track is selected.
                        onPressed: _selected == null ? null : _continue,
                        child: Text(
                          l10n.continueLabel,
                          style: AppType.buttonLarge,
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

/// A large single-select track card · Figma `82:1785` (light) / `337:15947`
/// (dark), cards `125:862` / `125:959` and `337:15981` / `337:15982`.
///
/// UNSELECTED is drawn to the frame: 112 tall, radius 25, the 98-ish
/// illustration in the leading slot and an r=9.5 hollow radio ring. How it
/// ELEVATES differs completely between canvases, and that is the edit5 #32
/// change:
///
/// | | Light `125:862` | Dark `337:15981` |
/// | --- | --- | --- |
/// | Fill | `#FCFBF9` | `#232428` at **20%** — was opaque `background` |
/// | Outline | 1px gradient `#384F47` → `#95CDBB`, inner | **none** |
/// | Shadow | (0.5, 0.5) blur 4 black 25% | **none** |
/// | Glass | — | **G20** on the first card, **G5** on the second |
///
/// **The two cards carry two Glass tokens and the only difference is the light
/// angle** (25 against −45). School is the first card on both canvases — read
/// 2026-09-20 — so [index] 0 is School and 1 is University; see the call site.
///
/// SELECTED is NOT in the frame — both cards are drawn unselected there. The
/// primary-at-8% wash, 2px solid border and filled radio below are the
/// invention that shipped on Day 2 and are kept EXACTLY as they were
/// (docs/DESIGN_ISSUES.md #40, open question 4). Swapping them for a
/// better-looking second guess would just move the problem.
class _TrackCard extends StatelessWidget {
  const _TrackCard({
    required this.index,
    required this.label,
    required this.art,
    required this.artShadow,
    required this.selected,
    required this.onTap,
  });

  /// 0 = School, 1 = University — the frame's own order, and what picks
  /// between the two Glass tokens.
  final int index;

  final String label;
  final String art;

  /// Whether the illustration sits over its own soft shadow.
  ///
  /// **True for School only, and that is a reading.** `Group 37219` inside
  /// `Component 2` holds the same 98×98 asset TWICE on both canvases: a sharp
  /// copy at the origin, and behind it a copy offset (1, 2) at **53%** with a
  /// **layer blur of 7.4** (σ 3.7). The University card's art
  /// (`Component 3`) is a plain vector group with no duplicate, so it gets
  /// none.
  ///
  /// **The back copy is a black SILHOUETTE, not a coloured duplicate.** Both
  /// copies wrap the same `Group` at 75.66 × 84.91 — they are the same shape
  /// — but the back one's whole group is a single `#000000` at 25%. That
  /// matters, because a blurred copy of the COLOURED art puts a teal haze
  /// under the teal book and a gold one beside the gold book, and the frame
  /// puts a grey shadow under all of it. `docs/DESIGN_ISSUES.md` #40 recorded
  /// the same 0.53 × 0.25-black from the SVG export on 2026-08-04.
  final bool artShadow;

  final bool selected;
  final VoidCallback onTap;

  static const _height = 112.0;
  static const _radius = 25.0;

  /// The illustration's slot. The frame puts the label at x=107, so the art
  /// owns the leading ~99 and the gap is what is left. `Group 37219` reads
  /// 99 × 100 on both canvases, which is the sharp 98×98 plus the glow's
  /// (1, 2) offset — the arithmetic that confirms the slot.
  static const _artSlot = 99.0;

  /// Tallest of the two exports (track_school is 99×101); BoxFit.contain then
  /// letterboxes the 98×97 university cap into the same slot rather than
  /// stretching it.
  static const _artHeight = 101.0;
  static const _labelStart = 107.0;
  static const _trailingInset = 20.0;

  /// The art shadow, verbatim from the panel. The offset is PHYSICAL and does
  /// not mirror in RTL, the same rule the shadows follow (edit1.md R9): it is
  /// the illustration's own soft shadow, not a directional back-light.
  static const _artShadowOffset = Offset(1, 2);
  static const _artShadowSigma = 3.7; // layer blur 7.4, σ = B/2 (edit1.md R3)
  static const _artShadowOpacity = 0.53;

  /// The invented selected state's border. Unselected is a 1px gradient.
  static const _selectedBorderWidth = 2.0;
  static const _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    final start = ext.trackCardBorderStart;
    final end = ext.trackCardBorderEnd;
    // Null in dark: the frame draws no outline there at all.
    final hasGradientBorder = !selected && start != null && end != null;
    final borderWidth = selected
        ? _selectedBorderWidth
        : (hasGradientBorder ? _borderWidth : 0.0);
    final fill = selected
        ? cs.primary.withValues(alpha: 0.08)
        : ext.trackCardFill;

    // The two track illustrations are the ONLY assets in this pass rendered
    // without a colorFilter — they are full-colour art, not glyphs.
    //
    // `shadow` is the blurred copy behind the sharp one. Two things it does
    // NOT share with the sharp copy:
    //
    // * `srcIn` flattens every path to the frame's black 25%, because the
    //   frame's back copy is a silhouette and not a second picture;
    // * it is excluded from semantics. `flutter_svg` marks every
    //   `SvgPicture` `isImage`, and left in, the duplicate merges a second
    //   image node into the card's button node for one card and not the
    //   other — which made the two cards' flag sets differ.
    Widget artwork({bool shadow = false}) => SvgPicture.asset(
      art,
      width: _artSlot,
      height: _artHeight,
      fit: BoxFit.contain,
      excludeFromSemantics: shadow,
      colorFilter: shadow
          ? ColorFilter.mode(ext.trackCardArtShadow, BlendMode.srcIn)
          : null,
    );

    Widget content = Row(
      children: [
        SizedBox(
          width: _artSlot,
          child: artShadow
              // `Transform.translate` rather than a `Positioned`, so the
              // stack still sizes to the sharp copy and the shadow cannot
              // grow the slot.
              ? Stack(
                  children: [
                    Transform.translate(
                      offset: _artShadowOffset,
                      child: LayerBlur(
                        sigma: _artShadowSigma,
                        opacity: _artShadowOpacity,
                        child: artwork(shadow: true),
                      ),
                    ),
                    artwork(),
                  ],
                )
              : artwork(),
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
    );

    if (borderWidth > 0) {
      content = Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(_radius - borderWidth),
        ),
        child: content,
      );
      content = Container(
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
        child: content,
      );
    }

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ElevatedSurface(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        height: _height,
        // The fill goes WHEREVER the outline puts it. With an outline it
        // belongs to the surface inset inside it, or the gradient would be
        // painted over. With none — which is every dark frame Figma actually
        // draws — the card IS this surface, and the fill has to be here so
        // the Glass rim composites on top of the 20% wash instead of under
        // it.
        color: borderWidth > 0 ? null : fill,
        // Light only; the dark frames carry no shadow at all and elevate with
        // Glass instead (edit1.md R1).
        shadows: elevation.trackCardShadows,
        glass: index == 0
            ? elevation.trackCardGlassFirst
            : elevation.trackCardGlassSecond,
        onTap: onTap,
        child: content,
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
