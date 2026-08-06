import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// The Profile confirmation dialog · Figma `180:4445`.
///
/// **This is a dialog, not a screen, and that is a routing decision.** The
/// frames named `Logout` and `Go to Uni` both render the *Profile* screen with
/// this card on top of a scrim — so neither gets a route. Giving them one would
/// put a modal in the back stack and let a cold deep-link land a student on a
/// bare "are you sure?" with nothing behind it.
///
/// Dismissal is the ✕ in the header, per frame — the frame draws no Cancel
/// button, so the ✕ *is* the neutral dismiss. It pops `false`; confirm pops
/// `true`.
///
/// [confirmEnabled] false means the confirm is genuinely disabled: the button
/// keeps its real colours at reduced opacity (it is not repainted Material
/// grey), it has no callback at all, and [disabledReason] renders under it — so
/// the student is told why rather than left tapping a dead control.
///
/// The dialog pops itself. Both buttons call `Navigator.of(context)` with the
/// DIALOG's context, which is the only one that resolves to the route
/// `showDialog` actually pushed — a caller inside the nav shell would resolve
/// to its branch Navigator and pop the wrong route.
class ProfileConfirmDialog extends StatelessWidget {
  const ProfileConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    this.note,
    this.confirmEnabled = false,
    this.disabledReason,
    this.tone = ProfileConfirmTone.primary,
    this.confirmKey,
  });

  final String title;
  final String body;
  final String confirmLabel;

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

  /// Shows the dialog and resolves to `true` only if the student confirmed.
  /// A barrier tap, a Back press and the ✕ all resolve to `false`.
  static Future<bool> show(BuildContext context, ProfileConfirmDialog dialog) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => dialog,
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final cs = Theme.of(context).colorScheme;

    final confirmColour = switch (tone) {
      ProfileConfirmTone.primary => cs.primary,
      ProfileConfirmTone.destructive => ext.destructive,
    };

    return Dialog(
      backgroundColor: ext.cardFill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 29, vertical: 24),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(18, 20, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 35,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: ext.profileStatLabel,
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    child: IconButton(
                      key: const Key('profile_dialog_dismiss'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 35,
                        height: 35,
                      ),
                      tooltip: l10n.dialogClose,
                      // Pops FALSE. The one exit that does not act.
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: Icon(Icons.close, size: 23, color: ext.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 11),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: ext.profileStatLabel,
                    ),
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      note!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: ext.dialogNote,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: confirmKey,
                onPressed: confirmEnabled
                    ? () => Navigator.of(context).pop(true)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: confirmColour,
                  // Disabled keeps the frame's colours at reduced opacity
                  // rather than Material's grey: the control must still look
                  // like the control it is, just unusable.
                  disabledBackgroundColor:
                      confirmColour.withValues(alpha: 0.45),
                  disabledForegroundColor:
                      const Color(0xFFFCFBF9).withValues(alpha: 0.7),
                ),
                child: Text(
                  confirmLabel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (!confirmEnabled && disabledReason != null) ...[
              const SizedBox(height: 12),
              Text(
                disabledReason!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: ext.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Which accent the confirm button wears. `destructive` is Logout's red
/// (`#EF4444`); `primary` is the frame's green/purple brand button.
enum ProfileConfirmTone { primary, destructive }
