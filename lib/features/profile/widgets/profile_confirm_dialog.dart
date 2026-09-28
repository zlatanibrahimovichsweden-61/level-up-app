import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/app_modal.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../l10n/app_localizations.dart';

/// The Profile confirmation dialog · Figma `180:4445` (Go to Uni) and
/// `180:4704` (Logout).
///
/// **This is a dialog, not a screen, and that is a routing decision.** The
/// frames named `Logout` and `Go to Uni` both render the *Profile* screen with
/// this card on top of a scrim — so neither gets a route. Giving them one would
/// put a modal in the back stack and let a cold deep-link land a student on a
/// bare "are you sure?" with nothing behind it.
///
/// **Two shapes, one per frame.** Go to Uni draws the ✕ and ONE button, so the
/// ✕ is its neutral dismiss. Logout draws the ✕ and a No / Yes pair, which
/// [cancelLabel] turns on: No and the ✕ pop `false`, Yes pops `true`. (Logout
/// used to ship Go to Uni's shape with a red confirm; API→UI Wave 19.)
///
/// [confirmEnabled] false means the confirm is genuinely disabled: the button
/// keeps its real colours at reduced opacity (it is not repainted Material
/// grey), it has no callback at all, and [disabledReason] renders under it — so
/// the student is told why rather than left tapping a dead control.
///
/// The dialog pops itself. Every button calls `Navigator.of(context)` with the
/// DIALOG's context, which is the only one that resolves to the route
/// `showDialog` actually pushed — a caller inside the nav shell would resolve
/// to its branch Navigator and pop the wrong route.
class ProfileConfirmDialog extends StatelessWidget {
  const ProfileConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    this.cancelLabel,
    this.note,
    this.confirmEnabled = false,
    this.disabledReason,
    this.tone = ProfileConfirmTone.primary,
    this.confirmKey,
    this.cancelKey,
  });

  final String title;
  final String body;
  final String confirmLabel;

  /// The Logout frame's "No" (`180:4756`). Set, the dialog draws the frame's
  /// No / Yes pair; null keeps Go to Uni's single full-row confirm.
  final String? cancelLabel;

  /// The purple caution line under [body] (Figma `180:4571`). Omitted when the
  /// dialog has nothing extra to warn about.
  final String? note;

  /// False → the confirm renders disabled and cannot resolve the dialog.
  final bool confirmEnabled;

  /// Shown under a disabled confirm. Required in practice whenever
  /// [confirmEnabled] is false — a dimmed button with no explanation is the
  /// thing this repo keeps promising not to ship.
  final String? disabledReason;

  final ProfileConfirmTone tone;
  final Key? confirmKey;
  final Key? cancelKey;

  /// Shows the dialog and resolves to `true` only if the student confirmed.
  /// A barrier tap, a Back press, the ✕ and No all resolve to `false`.
  static Future<bool> show(
    BuildContext context,
    ProfileConfirmDialog dialog,
  ) async {
    // Two frames, two scrims: Logout and Go-to-University are both 30% in
    // light with no blur, and in dark both go to 60% over a blurred page —
    // 9.95 sigma for Logout, 10.05 for Go to University. A tenth of a pixel
    // apart and both kept verbatim (edit1.md R2). The dark UNIVERSITY Logout
    // frame (`349:10749`) draws 30% with the same blur; kept at 60% on both
    // tracks by the owner's ruling (2026-09-27, DESIGN_ISSUES #103).
    final elevation = Theme.of(context).extension<AppElevation>()!;
    final confirmed = await showAppDialog<bool>(
      context: context,
      scrim: dialog.tone == ProfileConfirmTone.destructive
          ? elevation.logoutDialogScrim
          : elevation.goToUniversityDialogScrim,
      builder: (_) => dialog,
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final cs = Theme.of(context).colorScheme;
    final cancel = cancelLabel;

    // The pair's Yes is the brand button (`Frame 427319502`: `#384F47` light,
    // `#AE87E7` dark, on BOTH tracks, which is `cs.primary`: theme-driven, not
    // track-driven). A lone confirm takes the tone.
    final confirmColour = cancel != null
        ? cs.primary
        : switch (tone) {
            ProfileConfirmTone.primary => cs.primary,
            ProfileConfirmTone.destructive => ext.destructive,
          };

    final confirmButton = FilledButton(
      key: confirmKey,
      onPressed: confirmEnabled ? () => Navigator.of(context).pop(true) : null,
      style: FilledButton.styleFrom(
        backgroundColor: confirmColour,
        // Disabled keeps the frame's colours at reduced opacity rather than
        // Material's grey: the control must still look like the control it
        // is, just unusable.
        disabledBackgroundColor: confirmColour.withValues(alpha: 0.45),
        // `onPrimary` is where the ENABLED label's colour comes from
        // (`AppTheme`'s filledButtonTheme sets `foregroundColor` to it), so the
        // disabled state is that same colour dimmed rather than a hardcoded
        // copy of what it happens to be today.
        disabledForegroundColor: cs.onPrimary.withValues(alpha: 0.7),
      ),
      child: Text(confirmLabel, style: AppType.buttonLarge),
    );

    return Dialog(
      // OPAQUE. The Figma dialog panel is `#FCFBF9` / `#232428` — the page
      // fill, not the 20% `cardFill` wash, which in dark rendered a
      // see-through dialog with the Profile screen legible through it.
      backgroundColor: ext.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      // 345 wide on the 402 frame, like the limit card. 29 a side drew 344.
      insetPadding: const EdgeInsets.symmetric(horizontal: 28.5, vertical: 24),
      child: Padding(
        // Top: the frame's 20 over a 35 dp title bar, re-centred on the 48 dp
        // row the ✕'s target needs (13.5 = 20 - (48 - 35) / 2), as on the
        // limit card. Bottom: 15 under Logout's pair (`180:4704`: 239 - 224),
        // 20 under Go to Uni's button (`180:4445`: 278 - 258).
        padding: EdgeInsetsDirectional.only(
          top: 13.5,
          bottom: cancel != null ? 15 : 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Stretched, so the title row is the card's full width and
          // `start: 0` below is the ROW's edge. Loose, the row shrank to the
          // title and the ✕ landed on its first letter (Pixel 8, 2026-08-21:
          // the X over "تسجيل الخروج").
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The frame's title bar: a 23 dp ✕ box 6 inside a bar inset 18,
            // i.e. 24 from the card's start edge, and the title centred. The ✕
            // keeps a full 48 x 48 target centred on that box: inset 11.5 =
            // 24 - (48 - 23) / 2, in a 48 dp row so the whole target is inside
            // it (a box never hit-tests outside its own size, D-013). It was a
            // 35 x 35 button in the 35 dp bar (API→UI Wave 19).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.5),
              child: SizedBox(
                height: 48,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Padding(
                      // Clear of the ✕ target on BOTH sides, so the title
                      // stays centred and never runs under it.
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        // One line, like `TitledChrome`: a wrapped title would
                        // not fit the bar (register SF-08).
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.h2.copyWith(color: ext.profileStatLabel),
                      ),
                    ),
                    PositionedDirectional(
                      start: 0,
                      child: IconButton(
                        key: const Key('profile_dialog_dismiss'),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 48,
                          height: 48,
                        ),
                        tooltip: l10n.dialogClose,
                        // Pops FALSE. An exit that does not act.
                        onPressed: () => Navigator.of(context).pop(false),
                        // The frame's own `akar-icons:cross` (`180:4706`), the
                        // limit card's asset: `Icons.close` drew a shorter
                        // stroke (W11-5).
                        icon: SvgPicture.asset(
                          'assets/icons/close_cross.svg',
                          width: 23,
                          height: 23,
                          // The tooltip names the button; the glyph's own
                          // image semantics would make it an ImageView (W11-7).
                          excludeFromSemantics: true,
                          colorFilter: ColorFilter.mode(
                            ext.profileDialogClose,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 30 under the frame's 35 dp bar is 23.5 under this 48 dp row.
            const SizedBox(height: 23.5),
            Padding(
              // The body's 288 dp box (`180:4709`: at 29 on the 345 card),
              // centred.
              padding: const EdgeInsets.symmetric(horizontal: 28.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: AppType.bodyLarge.copyWith(
                      color: ext.profileStatLabel,
                    ),
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      note!,
                      textAlign: TextAlign.center,
                      style: AppType.bodyMediumStrong.copyWith(
                        color: ext.dialogNote,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            if (cancel != null)
              Padding(
                // Logout's No / Yes (`180:4757`): a row 15 in from each side,
                // two 155 x 60 buttons 5 apart on the 345 card. A directional
                // Row, so Arabic puts No at the reading start, on the right:
                // the owner's ruling (2026-09-27, DESIGN_ISSUES #102). The RTL
                // frames keep No on the left, the half-mirrored RTL family of
                // #58 and #64.
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      // `Frame 1000003068`: red, the shadow and no glow.
                      child: PrimaryCta(
                        tone: CtaTone.destructive,
                        child: FilledButton(
                          key: cancelKey,
                          // Pops FALSE, like the ✕.
                          onPressed: () => Navigator.of(context).pop(false),
                          style: FilledButton.styleFrom(
                            backgroundColor: ext.destructive,
                          ),
                          child: Text(cancel, style: AppType.buttonLarge),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      // `Frame 427319502`: the brand fill, the shadow and NO
                      // glow, even in dark (edit2 #12).
                      child: PrimaryCta(
                        tone: CtaTone.shadowOnly,
                        enabled: confirmEnabled,
                        child: confirmButton,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                // Go to Uni's button is 284 wide (`180:4572`: at 31 on the 345
                // card), centred, not the full row (API→UI Wave 19; it was 309
                // at 18).
                padding: const EdgeInsets.symmetric(horizontal: 30.5),
                // The destructive tone carries the drop shadow and NO glow;
                // the primary tone is Go to University, which does glow in
                // dark.
                child: PrimaryCta(
                  tone: tone == ProfileConfirmTone.destructive
                      ? CtaTone.destructive
                      : CtaTone.primary,
                  enabled: confirmEnabled,
                  child: confirmButton,
                ),
              ),
            if (!confirmEnabled && disabledReason != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  disabledReason!,
                  textAlign: TextAlign.center,
                  style: AppType.captionRegular.copyWith(
                    color: ext.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Which accent a lone confirm wears, and which scrim the dialog takes.
/// `destructive` is Logout's (`#EF4444` when it stands alone; with the No /
/// Yes pair the red goes to No); `primary` is the brand button.
enum ProfileConfirmTone { primary, destructive }
