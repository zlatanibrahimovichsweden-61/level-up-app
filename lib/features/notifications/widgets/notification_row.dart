import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../l10n/app_localizations.dart';
import '../models/notification_models.dart';
import 'notification_category_style.dart';

/// One inbox row · Figma `180:8743`: a 40 category disc, a title with the
/// unread dot at its end, the body, then the category pill and the time.
///
/// **Only renderable items reach this widget.** The notifier's `visibleItems`
/// holds exactly the items [NotificationItem.content] classifies; an ignored
/// kind has no row at all (`openapi.yaml:1165-1167`). Building one anyway is a
/// programming error, so it fails loudly in debug and draws nothing in release.
///
/// **What each kind shows**
/// - `announcement`: the Admin's own text, the Arabic pair under an Arabic UI
///   and the English pair otherwise, as PLAIN text — line breaks kept, never
///   auto-linked (`openapi.yaml:1168-1174`).
/// - `moderation_warning`: the client-approved copy the contract prints
///   verbatim, from two ARB keys.
///
/// **Full text, no clipping.** The frame clips the body at two lines, but no
/// detail view exists to read the rest (DG-42) and the warning's body is five
/// sentences, so title and body render in full. Logged for the designer.
///
/// **Unread rows are buttons; read rows are not.** A tap on an unread row marks
/// it read ([onMarkRead]) and nothing else — there is no target to open.
/// Whether a row is unread is the caller's call ([unread]), because "read" is
/// the server's `readAt` plus what this session has just acknowledged.
class NotificationRow extends StatelessWidget {
  const NotificationRow({
    super.key,
    required this.item,
    required this.unread,
    required this.onMarkRead,
  });

  final NotificationItem item;

  /// Whether to draw the unread dot and answer taps.
  final bool unread;

  /// Called on a tap of an UNREAD row. Never called for a read one.
  final VoidCallback onMarkRead;

  /// The frame's card: radius 16.268, a 1.2 hairline, content 16.26 inside it.
  static const _radius = 16.268;
  static const _border = 1.2;

  /// `ElevatedSurface` paints its hairline INSIDE the shape and takes no layout
  /// space, whereas the frame's content sits 16.26 inside the border's inner
  /// edge (`180:8744`, positioned against the padding box) — so the padding
  /// here is the two added.
  static const _inset = 16.26 + _border;

  static const _disc = 40.0;
  static const _discGap = 12.201;

  /// `180:8752`: an 8.119 dot, 6.101 below the title line's top. The frame's
  /// title line is 21.352 tall and the scale's `h3` is 24, so the offset is
  /// raised by half the difference to keep the dot centred on the first line
  /// where the frame centres it. The line grows with the text scale, so the
  /// offset is worked out from the line actually drawn ([_dotTopFor]) and the
  /// dot stays on the first line rather than drifting up it.
  static const _dot = 8.119;
  static const _dotFrameTop = 6.101;
  static const _frameTitleLine = 21.352;

  /// The dot's top offset for a title line [titleLine] tall.
  static double _dotTopFor(double titleLine) =>
      _dotFrameTop + (titleLine - _frameTitleLine) / 2;

  /// The gap kept between the title and the dot. The frame has none (its title
  /// is one line and the dot is pushed to the end); a long title wraps in full
  /// here and must not touch the dot.
  static const _dotGap = 8.0;

  /// `180:8756`: the meta row sits 8.134 under the body, its two items 8.134
  /// apart; the pill is 19.294 high with 12 either side of its label.
  static const _metaTop = 8.134;
  static const _pillHeight = 19.294;

  @override
  Widget build(BuildContext context) {
    final content = item.content;
    final category = item.knownCategory;
    assert(
      content != null && category != null,
      'An ignored item must never reach NotificationRow; render only '
      'InboxResults.visibleItems.',
    );
    if (content == null || category == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;
    final locale = Localizations.localeOf(context);

    final (title, body) = switch (content) {
      AnnouncementContent c => (
        c.titleFor(locale.languageCode),
        c.bodyFor(locale.languageCode),
      ),
      ModerationWarningContent() => (
        l10n.notifModerationWarningTitle,
        l10n.notifModerationWarningBody,
      ),
    };

    // The title's first line at the ambient text scale: the font is scaled and
    // the style's line-height multiplier is applied to the scaled size.
    final titleLine =
        MediaQuery.textScalerOf(context).scale(AppType.h3.fontSize!) *
        AppType.h3.height!;

    // An absolute date and time, in the UI's locale and the device's zone —
    // the contract gives an instant, and "5 min ago" would be a second piece
    // of copy with no source (DG-57 neighbours, logged). Same call shape as
    // `date_of_birth_field.dart`.
    final time = DateFormat.yMMMd(
      locale.toString(),
    ).add_jm().format(item.createdAt.toLocal());

    // ONE node: title, body, category and time read together, and a BUTTON
    // only while the row can be marked read. There is deliberately no "unread"
    // word in it — no sourced copy exists for one (logged for the designer).
    return MergeSemantics(
      child: Semantics(
        button: unread ? true : null,
        child: ElevatedSurface(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          color: ext.notificationRowFill,
          side: BorderSide(color: ext.notificationRowBorder, width: _border),
          shadows: elevation.notificationRowShadows,
          glass: elevation.notificationRowGlass,
          // A read row has no ink and no tap: it does not respond and do
          // nothing.
          onTap: unread ? onMarkRead : null,
          padding: const EdgeInsets.all(_inset),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedSurface(
                width: _disc,
                height: _disc,
                shape: const CircleBorder(),
                color: ext.notificationDiscFill,
                glass: elevation.notificationDiscGlass,
                child: Center(
                  child: SvgPicture.asset(
                    category.glyphAsset,
                    // Height only — see [NotificationCategoryStyle].
                    height: category.discGlyphSize,
                    colorFilter: ColorFilter.mode(
                      ext.notificationDiscGlyph,
                      BlendMode.srcIn,
                    ),
                    // The row's own text names it; an image node inside would
                    // turn the merged node into an ImageView on Android.
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              const SizedBox(width: _discGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppType.h3.copyWith(color: ext.textPrimary),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: _dotGap),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: _dotTopFor(titleLine),
                            ),
                            child: Container(
                              key: const Key('notification_unread_dot'),
                              width: _dot,
                              height: _dot,
                              decoration: BoxDecoration(
                                color: ext.notificationUnreadDot,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      body,
                      style: AppType.labelMedium.copyWith(
                        color: ext.notificationBody,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: _metaTop),
                      child: Wrap(
                        spacing: _metaTop,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              minHeight: _pillHeight,
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12,
                            ),
                            decoration: ShapeDecoration(
                              color: category.pillFill(ext),
                              shape: const StadiumBorder(),
                            ),
                            // A Row, not an `alignment`: an Align fills the
                            // width a Wrap offers it, and the pill must hug its
                            // label. The Row centres the label on the minimum
                            // height by itself.
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  category.label(l10n),
                                  style: AppType.labelSmall.copyWith(
                                    color: category.pillLabel(ext),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            time,
                            style: AppType.labelMedium.copyWith(
                              color: ext.notificationTime,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
