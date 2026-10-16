import 'package:level_up_app/features/notifications/models/notification_models.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';

/// The four text keys an `announcement` carries, plus its id
/// (`openapi.yaml:1168-1174`). Sample text only.
Map<String, String> announcementData({
  String announcementId = 'ann-1',
  String titleEn = 'English title',
  String titleAr = 'عنوان عربي',
  String bodyEn = 'English body',
  String bodyAr = 'نص عربي',
}) => {
  'announcementId': announcementId,
  'titleEn': titleEn,
  'titleAr': titleAr,
  'bodyEn': bodyEn,
  'bodyAr': bodyAr,
};

/// One inbox row with every field spelled out only when a test cares.
NotificationItem notification(
  String id, {
  String kind = 'announcement',
  String category = 'announcements',
  Map<String, String>? data,
  DateTime? createdAt,
  DateTime? readAt,
}) {
  return NotificationItem(
    notificationId: id,
    kind: kind,
    category: category,
    data: data ?? announcementData(announcementId: 'ann-$id'),
    createdAt: createdAt ?? DateTime.utc(2026, 10, 9, 12),
    readAt: readAt,
  );
}

/// A renderable row (an `announcement`).
NotificationItem announcementItem(String id, {DateTime? readAt}) =>
    notification(id, readAt: readAt);

/// A renderable `moderation_warning` — `data` is always empty.
NotificationItem warningItem(String id, {DateTime? readAt}) => notification(
  id,
  kind: 'moderation_warning',
  category: 'system',
  data: const {},
  readAt: readAt,
);

/// A row the app ignores: `enrolment_opened` is KNOWN to the contract and still
/// not rendered in CW07a.
NotificationItem ignoredItem(String id) => notification(
  id,
  kind: 'enrolment_opened',
  category: 'system',
  data: const {},
);

/// A page of the inbox.
///
/// [hasMore] defaults to `false` so a fixture is a COMPLETE inbox unless a test
/// deliberately says otherwise.
CursorPage<NotificationItem> inboxPage(
  List<NotificationItem> items, {
  bool hasMore = false,
  String? nextCursor,
}) => CursorPage<NotificationItem>(
  items: items,
  hasMore: hasMore,
  nextCursor: nextCursor,
);

/// A page carrying nothing the app renders while the server still says there
/// is more — contract-legal, since `hasMore` (not the page size) decides.
CursorPage<NotificationItem> ignoredOnlyPage(
  String id, {
  String nextCursor = 'cursor-next',
}) => inboxPage([ignoredItem(id)], hasMore: true, nextCursor: nextCursor);

/// The wire JSON of one item, as `GET /me/notifications` sends it.
Map<String, dynamic> wireItem({
  String notificationId = '5a000000-0000-4000-8000-000000000001',
  String kind = 'announcement',
  String category = 'announcements',
  Object? data,
  String createdAt = '2026-10-09T12:00:00Z',
  String? readAt,
}) => {
  'notificationId': notificationId,
  'kind': kind,
  'category': category,
  'data': data ?? announcementData(),
  'createdAt': createdAt,
  'readAt': readAt,
};
