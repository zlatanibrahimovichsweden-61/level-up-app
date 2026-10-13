import 'package:flutter/painting.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/notification_models.dart';

/// How each inbox [NotificationCategory] is drawn — one place, so the filter
/// chip, the row's disc and the row's pill cannot disagree about what
/// "Support" looks like.
///
/// The three glyphs are the frame's own SVG exports (`180:8854`, `180:8711`
/// and their siblings): `streamline-plump:announcement-megaphone-solid`,
/// `bx:support` and `lets-icons:setting-fill`. They are tinted through a
/// `ColorFilter` with a theme token, never baked to a colour.
extension NotificationCategoryStyle on NotificationCategory {
  /// The glyph asset for this category.
  String get glyphAsset => switch (this) {
    NotificationCategory.announcements =>
      'assets/icons/notification_announcement.svg',
    NotificationCategory.support => 'assets/icons/notification_support.svg',
    NotificationCategory.system => 'assets/icons/notification_system.svg',
  };

  /// The glyph's drawn size inside a row's 40 disc — the export's own height,
  /// which is what the frame draws it at (29 / 31 / 31). Sized by HEIGHT:
  /// `flutter_svg` derives the width from it and ignores a width passed beside
  /// it.
  double get discGlyphSize => switch (this) {
    NotificationCategory.announcements => 29,
    NotificationCategory.support => 31,
    NotificationCategory.system => 31,
  };

  /// The category's name — the chip's label AND the row's pill. Existing keys,
  /// the same words in both places (`180:8558`, `180:8730`, `180:8738`).
  String label(AppLocalizations l10n) => switch (this) {
    NotificationCategory.announcements => l10n.notifAnnouncements,
    NotificationCategory.support => l10n.notifSupport,
    NotificationCategory.system => l10n.notifSystem,
  };

  Color pillFill(AppColors ext) => switch (this) {
    NotificationCategory.announcements => ext.notificationPillAnnouncementsFill,
    NotificationCategory.support => ext.notificationPillSupportFill,
    NotificationCategory.system => ext.notificationPillSystemFill,
  };

  Color pillLabel(AppColors ext) => switch (this) {
    NotificationCategory.announcements =>
      ext.notificationPillAnnouncementsLabel,
    NotificationCategory.support => ext.notificationPillSupportLabel,
    NotificationCategory.system => ext.notificationPillSystemLabel,
  };
}
