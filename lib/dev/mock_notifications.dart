/// Throwaway on-device preview data for the Notifications inbox — NOT
/// production code.
///
/// Answers the two operations the app calls — `GET /me/notifications` and
/// `POST /me/notifications/{notificationId}/read` (`contract/openapi.yaml:
/// 1144-1262`, both `x-stability: stable`) — for `lib/dev/mock_backend.dart`,
/// which owns the request plumbing. This file holds the data and the contract's
/// rules; the interceptor turns a [MockNotificationsReply] into a Dio response.
///
/// It lives in its own file so the interceptor gains one field and one dispatch
/// block instead of a few hundred lines of fixtures.
///
/// **Everything below is MOCK SAMPLE DATA, not product copy.** The announcement
/// texts are short invented samples (one reuses the Figma frame's English
/// sample); the real ones are written by an Admin and arrive from the server.
///
/// Strict where the server is strict, per `mock_backend.dart`'s own rule:
/// - `limit` is VALIDATED, NOT CLAMPED — outside 1..100 is
///   `400 validation_failed` on field `limit`;
/// - `category` must be one of `system` / `announcements` / `support`, else
///   `400 validation_failed` on field `category`;
/// - `cursor` is opaque to the app; here it is an offset in disguise, and a
///   token this mock did not issue is `400 validation_failed` on field `cursor`;
/// - marking read is idempotent and never moves `readAt`; an unknown id is
///   `404 not_found`.
///
/// State is per [MockNotificationsInbox] instance, so marking a row read
/// persists for the life of one mock session (one `buildMockDio`) and a fresh
/// session starts from the fixtures again.
library;

import 'dart:convert';

/// What the mock answers, in terms the interceptor maps onto its own `_ok`,
/// `_validationFailed` and `_problem` helpers.
sealed class MockNotificationsReply {
  const MockNotificationsReply();
}

/// A success: [status] (`200` or `204`) and the JSON body, or `null` for `204`.
final class MockNotificationsOk extends MockNotificationsReply {
  const MockNotificationsOk(this.status, this.data);

  final int status;
  final Object? data;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockNotificationsValidation extends MockNotificationsReply {
  const MockNotificationsValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// Any other ProblemDetails (here only `404 not_found`).
final class MockNotificationsProblem extends MockNotificationsReply {
  const MockNotificationsProblem(this.status, this.code, this.detail);

  final int status;
  final String code;
  final String detail;
}

/// The id of fixture number [n] (1-based, 1 = newest). Exposed so a test can
/// name a row without hard-coding a UUID.
String mockNotificationId(int n) =>
    '5a000000-0000-4000-8000-${n.toRadixString(16).padLeft(12, '0')}';

/// How many items the fixtures hold in total (the All tab, ignored kinds
/// included). More than the default page of 20, so the first page ends with
/// `hasMore: true`.
const kMockNotificationCount = 24;

/// One inbox per mock session. See the file header.
class MockNotificationsInbox {
  MockNotificationsInbox() : _items = _buildFixtures();

  /// Newest first — the order the contract promises and the order served.
  final List<_MockItem> _items;

  static const _defaultLimit = 20;
  static const _categories = {'system', 'announcements', 'support'};
  static final _readPath = RegExp(r'^/me/notifications/([^/]+)/read$');

  /// The reply for a notifications route, or `null` when [method] + [path] is
  /// not one of the two this mock serves (so the interceptor keeps looking —
  /// `GET /me/notifications/unread-count` is deliberately not served, because
  /// the app does not call it yet).
  MockNotificationsReply? handle(
    String method,
    String path,
    Map<String, dynamic> query,
  ) {
    if (method == 'GET' && path == '/me/notifications') return _list(query);
    if (method == 'POST') {
      final match = _readPath.firstMatch(path);
      if (match != null) return _markRead(Uri.decodeComponent(match.group(1)!));
    }
    return null;
  }

  MockNotificationsReply _list(Map<String, dynamic> query) {
    final errors = <String, List<String>>{};

    var limit = _defaultLimit;
    final rawLimit = query['limit'];
    if (rawLimit != null) {
      final parsed = int.tryParse(rawLimit.toString());
      if (parsed == null || parsed < 1 || parsed > 100) {
        errors['limit'] = ['Must be between 1 and 100.'];
      } else {
        limit = parsed;
      }
    }

    String? category;
    final rawCategory = query['category'];
    if (rawCategory != null) {
      if (rawCategory is String && _categories.contains(rawCategory)) {
        category = rawCategory;
      } else {
        errors['category'] = ['Must be one of system, announcements, support.'];
      }
    }

    var start = 0;
    final rawCursor = query['cursor'];
    if (rawCursor != null) {
      final parsed = rawCursor is String ? _decodeCursor(rawCursor) : null;
      if (parsed == null) {
        errors['cursor'] = ['Not a cursor this API issued.'];
      } else {
        start = parsed;
      }
    }

    if (errors.isNotEmpty) return MockNotificationsValidation(errors);

    // The category narrows the list BEFORE paging, as the server does, so the
    // cursor walks the filtered list and `hasMore` is about that list.
    final matching = [
      for (final item in _items)
        if (category == null || item.category == category) item,
    ];
    if (start > matching.length) start = matching.length;
    final end = (start + limit).clamp(0, matching.length);
    final hasMore = end < matching.length;

    return MockNotificationsOk(200, <String, dynamic>{
      'items': [for (final item in matching.sublist(start, end)) item.toJson()],
      'nextCursor': hasMore ? _encodeCursor(end) : null,
      'hasMore': hasMore,
    });
  }

  MockNotificationsReply _markRead(String notificationId) {
    final item = _items
        .where((candidate) => candidate.id == notificationId)
        .firstOrNull;
    if (item == null) {
      // One code for "unknown" and "someone else's" (openapi.yaml:1255-1258).
      return const MockNotificationsProblem(
        404,
        'not_found',
        'No such notification',
      );
    }
    // Idempotent: `readAt` is set once and never moved.
    item.readAt ??= DateTime.now().toUtc();
    return const MockNotificationsOk(204, null);
  }
}

// ---------------------------------------------------------------------------
// Cursor — opaque to the app, an offset here
// ---------------------------------------------------------------------------

String _encodeCursor(int offset) =>
    base64Url.encode(utf8.encode('mock-inbox:$offset'));

int? _decodeCursor(String cursor) {
  try {
    final decoded = utf8.decode(base64Url.decode(cursor));
    if (!decoded.startsWith('mock-inbox:')) return null;
    final offset = int.tryParse(decoded.substring('mock-inbox:'.length));
    return (offset == null || offset < 0) ? null : offset;
  } on FormatException {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

class _MockItem {
  _MockItem({
    required this.id,
    required this.kind,
    required this.category,
    required this.data,
    required this.createdAt,
    this.readAt,
  });

  final String id;
  final String kind;
  final String category;
  final Map<String, String> data;
  final DateTime createdAt;
  DateTime? readAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'notificationId': id,
    'kind': kind,
    'category': category,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
    'readAt': readAt?.toIso8601String(),
  };
}

/// The newest fixture's timestamp; each older one is three hours earlier.
final _newest = DateTime.utc(2026, 10, 9, 12);

/// 24 items, newest first. What each is, and what the app does with it:
///
/// | # | kind | category | read | the app |
/// |---|------|----------|------|---------|
/// | 1 | announcement ("New Biology Quiz Available!") | announcements | no | shows |
/// | 2 | moderation_warning | system | no | shows |
/// | 3 | support_ticket_replied (`TK-12`) | support | no | ignores (CW07b) |
/// | 4 | announcement (multi-line body) | announcements | no | shows |
/// | 5 | announcement | announcements | yes | shows |
/// | 6 | academic_year_opened (`2026/2027`) | system | yes | ignores (CW07b) |
/// | 7 | an unknown kind | system | no | ignores |
/// | 8 | announcement | announcements | no | shows |
/// | 9 | announcement | announcements | yes | shows |
/// | 10 | announcement | announcements | no | shows |
/// | 11 | announcement with an UNKNOWN category | `promotions` | no | ignores |
/// | 12, 13 | announcement | announcements | yes | shows |
/// | 14 | moderation_warning | system | yes | shows |
/// | 15 | announcement | announcements | no | shows |
/// | 16-18 | announcement | announcements | yes | shows |
/// | 19 | announcement | announcements | no | shows |
/// | 20 | announcement | announcements | yes | shows (last of page 1) |
/// | 21 | announcement | announcements | no | shows (page 2) |
/// | 22, 23 | announcement | announcements | yes | shows |
/// | 24 | enrolment_opened | system | yes | ignores (SQ-20) |
///
/// So All = 24 (20 + 4), announcements = 17, system = 5, support = 1.
List<_MockItem> _buildFixtures() {
  final items = <_MockItem>[];
  var n = 0;

  void add(
    String kind,
    String category,
    Map<String, String> data, {
    required bool read,
  }) {
    n++;
    final createdAt = _newest.subtract(Duration(hours: 3 * n));
    items.add(
      _MockItem(
        id: mockNotificationId(n),
        kind: kind,
        category: category,
        data: data,
        createdAt: createdAt,
        readAt: read ? createdAt.add(const Duration(minutes: 30)) : null,
      ),
    );
  }

  Map<String, String> announcement({
    required String titleEn,
    required String bodyEn,
    required String titleAr,
    required String bodyAr,
  }) => {
    'announcementId': mockNotificationId(100 + n + 1),
    'titleEn': titleEn,
    'bodyEn': bodyEn,
    'titleAr': titleAr,
    'bodyAr': bodyAr,
  };

  /// A plain filler announcement, numbered so rows are told apart on screen.
  Map<String, String> filler() => announcement(
    titleEn: 'Study update ${n + 1}',
    bodyEn: 'A short sample announcement for the mock inbox.',
    titleAr: 'تحديث دراسي ${n + 1}',
    bodyAr: 'إعلان تجريبي قصير لصندوق الإشعارات.',
  );

  const announcements = 'announcements';

  // 1
  add(
    'announcement',
    announcements,
    announcement(
      titleEn: 'New Biology Quiz Available!',
      bodyEn:
          'A new quiz on Cell Biology has been added. Test your knowledge now!',
      titleAr: 'اختبار جديد في الأحياء!',
      bodyAr: 'تمت إضافة اختبار جديد عن بيولوجيا الخلية. اختبر معلوماتك الآن!',
    ),
    read: false,
  );
  // 2 — `data` is always empty for a moderation warning.
  add('moderation_warning', 'system', const {}, read: false);
  // 3
  add('support_ticket_replied', 'support', {
    'ticketId': mockNotificationId(900),
    'reference': 'TK-12',
  }, read: false);
  // 4 — a body with line breaks, which must be kept.
  add(
    'announcement',
    announcements,
    announcement(
      titleEn: 'Revision tips',
      bodyEn:
          'Three tips for this week:\n1. Review your mistakes.\n'
          '2. Take a short quiz every day.\n3. Rest before the exam.',
      titleAr: 'نصائح للمراجعة',
      bodyAr:
          'ثلاث نصائح لهذا الأسبوع:\n1. راجع أخطاءك.\n'
          '2. حل اختبارًا قصيرًا كل يوم.\n3. استرح قبل الامتحان.',
    ),
    read: false,
  );
  // 5
  add(
    'announcement',
    announcements,
    announcement(
      titleEn: 'Exam timetable published',
      bodyEn: 'The exam timetable is out. Check your dates and plan ahead.',
      titleAr: 'تم نشر جدول الامتحانات',
      bodyAr: 'صدر جدول الامتحانات. راجع المواعيد وخطط مسبقًا.',
    ),
    read: true,
  );
  // 6
  add('academic_year_opened', 'system', {
    'track': 'school',
    'academicYear': '2026/2027',
  }, read: true);
  // 7 — a kind this app has never heard of.
  add('future_kind_sample', 'system', {'note': 'sample'}, read: false);
  // 8
  add(
    'announcement',
    announcements,
    announcement(
      titleEn: 'Study hall hours',
      bodyEn: 'The study hall now opens one hour earlier on weekdays.',
      titleAr: 'مواعيد قاعة المذاكرة',
      bodyAr:
          'تفتح قاعة المذاكرة الآن قبل ساعة من الموعد السابق في أيام الأسبوع.',
    ),
    read: false,
  );
  // 9
  add('announcement', announcements, filler(), read: true);
  // 10
  add('announcement', announcements, filler(), read: false);
  // 11 — a category value this app predates: ignored even though the kind and
  // the text are well-formed.
  add('announcement', 'promotions', filler(), read: false);
  // 12, 13
  add('announcement', announcements, filler(), read: true);
  add('announcement', announcements, filler(), read: true);
  // 14
  add('moderation_warning', 'system', const {}, read: true);
  // 15
  add('announcement', announcements, filler(), read: false);
  // 16, 17, 18
  add('announcement', announcements, filler(), read: true);
  add('announcement', announcements, filler(), read: true);
  add('announcement', announcements, filler(), read: true);
  // 19
  add('announcement', announcements, filler(), read: false);
  // 20 — the last row of the default page of 20.
  add('announcement', announcements, filler(), read: true);
  // 21
  add('announcement', announcements, filler(), read: false);
  // 22, 23
  add('announcement', announcements, filler(), read: true);
  add('announcement', announcements, filler(), read: true);
  // 24 — the welcome item every student gets; no sourced copy yet (SQ-20).
  add('enrolment_opened', 'system', const {}, read: true);

  assert(items.length == kMockNotificationCount);
  return items;
}
