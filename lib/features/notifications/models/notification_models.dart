import 'package:flutter/foundation.dart';

/// The inbox tabs the contract can filter by — `category` on
/// `GET /me/notifications` (`openapi.yaml:1153-1159`), enum
/// `[system, announcements, support]`.
///
/// **Absent means All.** There is deliberately no `all` member: "All" is the
/// absence of the filter, and a member that stood for it would invite a call
/// site to send `category=all`, which the server answers with
/// `400 validation_failed`. Callers hold a `NotificationCategory?` and pass
/// `null` for All.
///
/// The set is the contract's *published* set, but a server may add values
/// later, and the contract tells clients to **ignore an unknown `category`**
/// (`:1166-1167`). That is why [NotificationItem.category] stays a plain
/// `String` and this enum is reached through [tryParse], which returns `null`
/// for a value it does not know instead of throwing.
enum NotificationCategory {
  system,
  announcements,
  support;

  /// The wire value. `name` already matches the contract's spelling exactly;
  /// this getter exists so call sites read as wire values rather than as Dart
  /// enum names that happen to coincide.
  String get wire => name;

  /// The member whose wire value is [value], or `null` for anything else —
  /// including `null` itself. Never throws.
  static NotificationCategory? tryParse(String? value) {
    for (final category in values) {
      if (category.wire == value) return category;
    }
    return null;
  }
}

/// The two `kind` values this app renders (`openapi.yaml:1211`).
///
/// `kind` is a **localization contract**, not display text (`:1163-1165`): the
/// client owns the string for a kind and substitutes `data`. Two kinds sit
/// outside that — see [notificationContentFor].
abstract final class NotificationKinds {
  /// `kind: announcement` (`category: announcements`, spec-052).
  static const announcement = 'announcement';

  /// `kind: moderation_warning` (`category: system`, spec-062).
  static const moderationWarning = 'moderation_warning';
}

/// One row of `GET /me/notifications` (`openapi.yaml:1209-1216`).
///
/// Hand-written rather than freezed, on purpose: three of its fields are
/// decoded **leniently** and json_serializable has no way to say so without a
/// converter per field —
/// - [kind] and [category] are `String`, not enums, because the contract says
///   a client MUST ignore a `kind` it does not recognise and MUST ignore an
///   unknown `category` (`:1165-1167`). A strict enum would turn the first new
///   server-side value into a parse failure for the WHOLE page, taking every
///   row the student can read down with it;
/// - [data] keeps only the entries whose value is a `String`. The contract
///   types it `additionalProperties: { type: string }`, so a non-string value
///   is not something this app has a meaning for.
///
/// The six wire fields are still all **required**, and decoding them is as
/// strict as every other model here: a missing `notificationId`, `kind`,
/// `category`, `data` or `createdAt`, or a value of the wrong type, throws —
/// and the repository wraps that into a typed `UnknownException`.
/// `readAt` is the one nullable field: `null` is "not read yet", which is its
/// ordinary value, not an error.
///
/// There is no `title` or `body` here. Display text comes from [content], and
/// for the kinds the app does not render it is `null`.
@immutable
class NotificationItem {
  const NotificationItem({
    required this.notificationId,
    required this.kind,
    required this.category,
    required this.data,
    required this.createdAt,
    required this.readAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>;
    final readAt = json['readAt'] as String?;
    return NotificationItem(
      notificationId: json['notificationId'] as String,
      kind: json['kind'] as String,
      category: json['category'] as String,
      data: {
        for (final entry in rawData.entries)
          if (entry.value is String) entry.key: entry.value as String,
      },
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: readAt == null ? null : DateTime.parse(readAt),
    );
  }

  /// `Uuid`. The only value the app ever sends back (`markNotificationRead`).
  final String notificationId;

  /// Open vocabulary — see the class doc. Compare against [NotificationKinds];
  /// never switch exhaustively on it.
  final String kind;

  /// Open vocabulary. Derived server-side from [kind]. Use [knownCategory] to
  /// get the enum, or `null` when the server sent a value this app predates.
  final String category;

  /// Localization parameters for every kind except `announcement`, whose
  /// `data` carries the display text itself. String-valued entries only.
  final Map<String, String> data;

  /// When the server created the item, as it sent it (`format: date-time`,
  /// normally UTC). **Call `.toLocal()` before formatting it for display** — the
  /// model does not guess the device's zone.
  final DateTime createdAt;

  /// When the item was first read, or `null` while it is unread.
  ///
  /// The server sets it once and never moves it (`:1252-1254`). The client
  /// never writes it: a row the student has just opened is remembered as read
  /// by the notifier's own set of ids, because inventing a timestamp here would
  /// author a time the server never reported.
  final DateTime? readAt;

  /// [category] as an enum, or `null` for a value this app does not know.
  NotificationCategory? get knownCategory =>
      NotificationCategory.tryParse(category);

  /// What to show for this item, or `null` when it must be **ignored**.
  /// See [notificationContentFor] for the rules.
  NotificationContent? get content => notificationContentFor(this);
}

/// What the inbox shows for one [NotificationItem].
///
/// Sealed, so a screen's `switch` over it is exhaustive and a third rendered
/// kind cannot be added without the compiler pointing at every place that must
/// learn about it.
sealed class NotificationContent {
  const NotificationContent();
}

/// `kind: announcement` — text written by an Admin (spec-052).
///
/// **The one exception to the localization contract** (`openapi.yaml:1168-1174`):
/// `data` always carries exactly five keys — `announcementId`, `titleAr`,
/// `titleEn`, `bodyAr`, `bodyEn` — and the four text values ARE display text.
/// Show the Arabic pair when the UI is Arabic and the English pair when it is
/// English, as **plain text**: keep line breaks and **never auto-link**
/// anything in them. `announcementId` is not display text and is not modelled.
@immutable
class AnnouncementContent extends NotificationContent {
  const AnnouncementContent({
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
  });

  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;

  /// The title for the UI language: Arabic for `ar`, English for everything
  /// else (the app ships exactly those two).
  String titleFor(String languageCode) =>
      languageCode == 'ar' ? titleAr : titleEn;

  /// The body for the UI language; same rule as [titleFor].
  String bodyFor(String languageCode) => languageCode == 'ar' ? bodyAr : bodyEn;
}

/// `kind: moderation_warning` — a fixed warning from Support after a report
/// about content from the student's account (spec-062).
///
/// Its `data` is always empty (`openapi.yaml:1175-1177`): no student text, no
/// reporter, no staff name. The title and body are the **client-approved
/// copy** the contract prints verbatim (`:1177-1185`, approved in writing
/// 2026-10-07), which the screen reads from its localizations. They are NOT
/// carried here — there is nothing in the payload to carry.
@immutable
class ModerationWarningContent extends NotificationContent {
  const ModerationWarningContent();
}

/// Classifies [item] for display: the content to render, or `null` when the
/// item must be **ignored** (not rendered, not counted as visible, not
/// replaced by a placeholder).
///
/// The contract's rule is that a client MUST ignore a `kind` it does not
/// recognise and an unknown `category`, so new values can be added without a
/// breaking change (`openapi.yaml:1165-1167`). Concretely, `null` for:
/// - any `kind` other than `announcement` and `moderation_warning`;
/// - a `category` outside [NotificationCategory];
/// - an `announcement` missing any of `titleEn`, `titleAr`, `bodyEn`, `bodyAr`.
///   A malformed announcement is dropped rather than shown with a blank title
///   or the other language's text standing in for it.
///
/// **Three kinds are KNOWN to the contract and still ignored in CW07a**, which
/// is not the same as "unknown":
/// - `enrolment_opened` (`category: system`) — every student receives one as a
///   welcome item, and its localized copy and `data` keys are not sourced yet
///   (SQ-20 to Seif). Inventing text for it would make this app author a
///   message the product has not written;
/// - `support_ticket_replied` (`category: support`, `:1186-1192`) and
///   `academic_year_opened` (`category: system`, `:1193-1197`) — their `data`
///   is defined, but the only EN/AR text that exists for them is the push
///   wording in `realtime.md`, and whether that is also the inbox text is an
///   open question. They are CW07b, behind an owner opt-in.
///
/// Pure: no I/O, no clock, no locale. The same item always classifies the same
/// way, which is what lets the notifier decide "is there anything to show?"
/// before any widget exists.
NotificationContent? notificationContentFor(NotificationItem item) {
  if (NotificationCategory.tryParse(item.category) == null) return null;

  switch (item.kind) {
    case NotificationKinds.announcement:
      final titleEn = item.data['titleEn'];
      final titleAr = item.data['titleAr'];
      final bodyEn = item.data['bodyEn'];
      final bodyAr = item.data['bodyAr'];
      if (titleEn == null ||
          titleAr == null ||
          bodyEn == null ||
          bodyAr == null) {
        return null;
      }
      return AnnouncementContent(
        titleEn: titleEn,
        titleAr: titleAr,
        bodyEn: bodyEn,
        bodyAr: bodyAr,
      );
    case NotificationKinds.moderationWarning:
      return const ModerationWarningContent();
    default:
      return null;
  }
}
