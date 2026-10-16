import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../models/support_models.dart';

/// A ticket's status pill · Figma `178:3131` (the Closed pill): 23.974 high,
/// at least 73.323 wide, a stadium filled with `#B6B6B6` at 13%, its label
/// centred.
///
/// **One look for every status.** The frame draws only the Closed pill, so the
/// Open and In progress pills reuse it as drawn (its fill and label tokens);
/// the words, not the colour, tell them apart until the designer draws
/// per-status pills (DG-63). Which status gets which words is [labelFor]; the
/// caller decides whether to draw a pill at all.
///
/// The label is `buttonSmall` (12 / 16, SemiBold), the nearest style on the
/// scale to the frame's 12 / 16 SemiBold. The height is a MINIMUM, so the pill
/// grows with the text scale instead of clipping its label.
class SupportStatusPill extends StatelessWidget {
  const SupportStatusPill({super.key, required this.label});

  /// The pill's text: one of the approved status labels ([labelFor]).
  final String label;

  static const _minHeight = 23.974;
  static const _minWidth = 73.323;

  /// The approved words for the wire [status], or `null` when it gets no pill
  /// (owner-approved copy, O-14, 2026-10-10).
  ///
  /// * `closed` → Closed; `open` → Open; `in_progress` → In progress.
  /// * **A status this app does not know** → In progress: the contract says to
  ///   treat an unknown value as "in progress - not closed"
  ///   (`openapi.yaml:3911-3922`).
  /// * **`pending` → no pill.** What it means to a student is not defined yet
  ///   (SQ-32), so it has no approved label, and borrowing another status's
  ///   words would tell the student something the server did not say.
  static String? labelFor(AppLocalizations l10n, String status) =>
      switch (SupportTicketStatus.tryParse(status)) {
        SupportTicketStatus.closed => l10n.supportStatusClosed,
        SupportTicketStatus.open => l10n.supportStatusOpen,
        SupportTicketStatus.inProgress || null => l10n.supportStatusInProgress,
        SupportTicketStatus.pending => null,
      };

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;

    return Container(
      constraints: const BoxConstraints(
        minHeight: _minHeight,
        minWidth: _minWidth,
      ),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: ext.supportPillClosedFill,
        shape: const StadiumBorder(),
      ),
      // A Row, not an `alignment`: it centres the label on the minimum height
      // and on the minimum width, and lets the pill hug a longer label.
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppType.buttonSmall.copyWith(
                color: ext.supportPillClosedLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
