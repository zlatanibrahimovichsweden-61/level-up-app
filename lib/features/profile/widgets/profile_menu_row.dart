import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';

/// Opacity applied to a control that renders but cannot be used.
///
/// One constant, so "disabled" looks the same on every row and a reviewer can
/// grep for the rule instead of comparing magic numbers.
const kProfileDisabledOpacity = 0.45;

/// Which of the frame's three row treatments to draw (Figma `166:4416`).
///
/// **The three differ only in their hairline and their label colour.** Every
/// row — all ten — carries the same 35x35 lavender disc behind its glyph. The
/// enum's doc used to say the eight navigation rows had a bare glyph; that came
/// from an older frame (`170:4933`) and was refuted on the Properties panel
/// 2026-09-20: `170:4861` (Settings), `170:4902` (Privacy) and `176:1186`
/// (Logout) are each a 35x35 frame at radius 48.17 filled `#F4E6FF`, with the
/// glyph vector inside. The disc is not a sibling ellipse — it is the Iconify
/// component frame's own fill, which is why it does not appear as a layer of
/// its own and is nearly invisible at 50% zoom on a cream card.
///
/// In DARK no row but Logout's has a hairline (`337:7433`), and every row and
/// every disc takes G5 instead.
enum ProfileRowTone {
  /// The eight navigation rows — `#7070A0` outline in light, none in dark,
  /// chevron.
  neutral,

  /// `GO to University` — `#101010` outline in light (`170:4921`), none in
  /// dark, no chevron.
  emphasis,

  /// `Logout` — `#EF4444` outline AND label on BOTH canvases (`176:1185`,
  /// `337:7545`), no chevron.
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
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    // Nullable on purpose: in dark every tone but `destructive` reads NO
    // hairline, and a null token is that reading, not a missing value.
    final (Color? border, Color content) = switch (tone) {
      ProfileRowTone.neutral => (ext.profileMenuRowBorder, ext.textPrimary),
      ProfileRowTone.emphasis => (
        ext.profileMenuEmphasisRowBorder,
        ext.textPrimary,
      ),
      ProfileRowTone.destructive => (ext.destructive, ext.destructive),
    };

    final row = ElevatedSurface(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
      // The build's 16.5 / 14.5, kept. The Properties panel reads 16 / 14 on
      // `170:4790` — half a dp apart, and this edit is about the row's
      // elevation, not its geometry; edit5.md §7.4.1 says to keep these.
      // Recorded in docs/DESIGN_ISSUES.md #72.
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16.5,
        vertical: 14.5,
      ),
      color: ext.profileMenuRowFill,
      side: border == null ? null : BorderSide(color: border, width: 0.5),
      glass: elevation.profileMenuRowGlass,
      child: Row(
        children: [
          // TODO(design-asset): the frame uses per-row Iconify glyphs
          // (`lets-icons:setting-fill`, `stash:save-ribbon`, `solar:logout-2`…).
          // Material stand-ins until the designer exports the set — the same
          // call docs/ASSET_MANIFEST.md already makes for the notification bell.
          _Glyph(icon: icon, colour: content),
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

/// The 35x35 disc behind a row's glyph — on EVERY row, see [ProfileRowTone].
///
/// The glyph is 22. The frame's own vectors are 21-23 (`170:4674` 23x23,
/// `170:4910` 21x26) because each Iconify export has its own box inside the
/// shared 35 frame; 22 is one value for a set of Material stand-ins, kept from
/// the two rows that already had a disc rather than adopting one export's
/// number for all ten (edit5.md §7.4.2).
class _Glyph extends StatelessWidget {
  const _Glyph({required this.icon, required this.colour});

  final IconData icon;
  final Color colour;

  static const _glyph = 22.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    return ElevatedSurface(
      shape: const CircleBorder(),
      width: ProfileMenuRow._glyphSize,
      height: ProfileMenuRow._glyphSize,
      color: ext.profileMenuIconDiscFill,
      glass: elevation.profileMenuIconDiscGlass,
      child: Center(
        child: Icon(icon, size: _glyph, color: colour),
      ),
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
/// render, not from a bound variable, because the icon node carries none. It
/// stays on [AppColors.profileRowBorder] rather than following the row to
/// [AppColors.profileMenuRowBorder], which is null in dark — the hairline goes
/// away there, the chevron does not.
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
        // Decorative. Without this the chevron's image semantics merged into
        // the row and TalkBack announced every row with one as an IMAGE, not
        // a button (Fable-eye audit 2026-10-06, FE-02) — the same defect
        // BUG-013 fixed on the back chip.
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(ext.profileRowBorder, BlendMode.srcIn),
      ),
    );
  }
}
