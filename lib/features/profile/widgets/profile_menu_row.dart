import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Opacity applied to a control that renders but cannot be used.
///
/// One constant, so "disabled" looks the same on every row and a reviewer can
/// grep for the rule instead of comparing magic numbers.
const kProfileDisabledOpacity = 0.45;

/// Which of the frame's three row treatments to draw (Figma `170:4933`).
enum ProfileRowTone {
  /// The eight navigation rows — `#7070A0` outline, chevron, plain glyph.
  neutral,

  /// `GO to University` — `#101010` outline, no chevron, lavender icon chip.
  emphasis,

  /// `Logout` — `#EF4444` outline AND label, no chevron, lavender icon chip.
  destructive,
}

/// One Profile menu row · Figma `170:4790` and siblings.
///
/// **[onTap] is the enabled/disabled switch, and disabled is real.** A null
/// [onTap] produces a row with no [InkWell] anywhere in its subtree, wrapped in
/// an [IgnorePointer] — not a live tap target with a no-op callback. That
/// distinction is the whole point: six of these rows have no destination in the
/// contract, and a row that looks tappable and swallows the tap is a bug
/// dressed as a feature.
///
/// Every disabled instance carries a stable [Key] so a widget test can assert
/// both halves of the claim — present, and not tappable.
class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.tone = ProfileRowTone.neutral,
    this.disabledHint,
  });

  final IconData icon;
  final String label;

  /// Null → the row is disabled: dimmed, non-interactive, and announced as a
  /// disabled button with [disabledHint] as its reason.
  final VoidCallback? onTap;

  final ProfileRowTone tone;

  /// Screen-reader reason for a disabled row. Ignored when [onTap] is set.
  final String? disabledHint;

  bool get _enabled => onTap != null;

  static const _radius = 16.0;
  static const _glyphSize = 35.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    final (border, content) = switch (tone) {
      ProfileRowTone.neutral => (ext.profileRowBorder, ext.textPrimary),
      ProfileRowTone.emphasis => (ext.textPrimary, ext.textPrimary),
      ProfileRowTone.destructive => (ext.destructive, ext.destructive),
    };
    // The frame gives the two action rows a lavender disc behind the glyph and
    // the eight navigation rows a bare glyph.
    final chipped = tone != ProfileRowTone.neutral;

    final row = Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16.5,
        vertical: 14.5,
      ),
      decoration: BoxDecoration(
        color: ext.cardFill,
        border: Border.all(color: border, width: 0.5),
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Row(
        children: [
          // TODO(design-asset): the frame uses per-row Iconify glyphs
          // (`lets-icons:setting-fill`, `stash:save-ribbon`, `solar:logout-2`…).
          // Material stand-ins until the designer exports the set — the same
          // call docs/ASSET_MANIFEST.md already makes for the notification bell.
          _Glyph(icon: icon, colour: content, chipped: chipped, ext: ext),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.h3.copyWith(color: content),
            ),
          ),
          // The two action rows end the list and open a dialog rather than
          // navigating, so the frame gives them no forward affordance.
          if (tone == ProfileRowTone.neutral) const _Chevron(),
        ],
      ),
    );

    if (!_enabled) {
      return Semantics(
        button: true,
        enabled: false,
        hint: disabledHint,
        child: IgnorePointer(
          child: Opacity(opacity: kProfileDisabledOpacity, child: row),
        ),
      );
    }

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: row,
        ),
      ),
    );
  }
}

class _Glyph extends StatelessWidget {
  const _Glyph({
    required this.icon,
    required this.colour,
    required this.chipped,
    required this.ext,
  });

  final IconData icon;
  final Color colour;
  final bool chipped;
  final AppColors ext;

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon, size: chipped ? 22 : 28, color: colour);
    if (!chipped) {
      return SizedBox(
        width: ProfileMenuRow._glyphSize,
        height: ProfileMenuRow._glyphSize,
        child: Center(child: glyph),
      );
    }
    return Container(
      width: ProfileMenuRow._glyphSize,
      height: ProfileMenuRow._glyphSize,
      decoration: BoxDecoration(
        color: ext.profileIconChip,
        shape: BoxShape.circle,
      ),
      child: Center(child: glyph),
    );
  }
}

/// The row's forward chevron.
///
/// `chevron.svg` points END-ward natively (which is why `CircleBackButton`
/// flips it in LTR to make a BACK arrow); here the flip is the other way round,
/// so the arrow follows reading direction in both locales.
///
/// TODO(design): the tint is the row outline `#7070A0` — read off the frame's
/// render, not from a bound variable, because the icon node carries none.
class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Transform.flip(
      flipX: rtl,
      child: SvgPicture.asset(
        'assets/icons/chevron.svg',
        width: 8,
        height: 16,
        colorFilter: ColorFilter.mode(ext.profileRowBorder, BlendMode.srcIn),
      ),
    );
  }
}
