import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_text_direction.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/support_models.dart';
import 'support_closed_pill.dart';

/// One ticket on the support list · Figma `178:3104`: the subject in full, the
/// `TK-n · yyyy-MM-dd` meta line under it, and at the end the Closed pill when,
/// and only when, the ticket is closed.
///
/// **The subject renders in full.** The frame draws one line, but a student
/// writes the subject (up to 120 characters) and nothing else on this screen
/// shows it, so it wraps rather than being cut off.
///
/// **`reference` is a label, never an id.** The tap goes to the thread by
/// `ticketId`; the reference is only ever printed.
///
/// **One semantics node.** The subject, the meta line and (for a closed ticket)
/// its status read together as a single button. Nothing in the node says
/// "open", "pending" or "in progress": no approved text exists for them
/// (CW12a_PLAN §4.3).
///
/// **Content direction.** The subject is the student's own text, in whatever
/// language they wrote it, so it takes the direction of its first strong
/// character (BUG-020's rule) while the chrome around it stays the app's.
///
/// Dark has no frame: the row takes the support stand-ins (Glass G5, no shadow).
class SupportTicketRow extends StatelessWidget {
  const SupportTicketRow({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  final SupportTicketSummary ticket;
  final VoidCallback onTap;

  static const _radius = 16.0;
  static const _border = 0.5;

  /// The frame pads 16.5 from the border; `ElevatedSurface` paints its hairline
  /// INSIDE the shape and takes no layout space, so the padding is the two
  /// added.
  static const _inset = 16.5 + _border;

  /// The frame's row is at least 75.315 high (`178:3104`). The padding does NOT
  /// give that on its own: with the scale's line heights a one-line subject and
  /// its meta line plus the 2 between them come to about 70, not the 75.315 of
  /// the frame's 21 + 18 lines. So the height is a stated minimum; the content
  /// stays vertically centred in it, and a wrapped subject grows the row past it.
  static const _minHeight = 75.315;

  static const _metaGap = 2.0;

  /// The gap between the text column and the Closed pill: `gap-[8px]` on
  /// `178:3105`.
  static const _pillGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    final locale = Localizations.localeOf(context).toString();

    // The frame's pattern, `yyyy-MM-dd`, in the UI's locale and the device's
    // zone (the contract gives an instant).
    final date = DateFormat(
      'yyyy-MM-dd',
      locale,
    ).format(ticket.createdAt.toLocal());
    final meta = l10n.supportTicketMeta(ticket.reference, date);

    return MergeSemantics(
      child: Semantics(
        button: true,
        // The minimum is on the surface itself (outside its padding), so the
        // whole row - fill, hairline, ink - is 75.315 and the tap target is the
        // row, not the content in it.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minHeight),
          child: ElevatedSurface(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
            color: ext.supportSurfaceFill,
            side: BorderSide(color: ext.supportRowBorder, width: _border),
            shadows: elevation.supportRowShadows,
            glass: elevation.supportRowGlass,
            onTap: onTap,
            padding: const EdgeInsets.all(_inset),
            // A `Row` centres its children across the cross axis (the default),
            // so a short row keeps its content in the middle of the minimum.
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.subject,
                        textDirection: contentTextDirection(
                          ticket.subject,
                          fallback: Directionality.of(context),
                        ),
                        style: AppType.labelLarge.copyWith(
                          color: ext.supportInk,
                        ),
                      ),
                      const SizedBox(height: _metaGap),
                      Text(
                        meta,
                        style: AppType.buttonSmall.copyWith(
                          color: ext.supportInkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (ticket.isClosed) ...[
                  const SizedBox(width: _pillGap),
                  SupportClosedPill(
                    key: Key('support_status_pill_${ticket.ticketId}'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
