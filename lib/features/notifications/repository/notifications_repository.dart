import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../registration/models/reference_models.dart' show CursorPage;
import '../models/notification_models.dart';

/// The only place that touches Dio for the Notifications inbox.
///
/// Two operations, both `x-stability: stable` with no `x-consumers`
/// (`openapi.yaml:1147`, `:1245`), authenticated and on the main [dioProvider]:
/// `AuthInterceptor` attaches the Bearer and `ErrorInterceptor` has already
/// mapped failures by the time they arrive here.
///
/// `GET /me/notifications/unread-count` (`getUnreadNotificationCount`) is
/// deliberately NOT called. Its number counts kinds a client ignores, so a dot
/// driven by it could stay lit over an inbox that shows nothing — see
/// [notificationContentFor]. That is CW07b.
///
/// Both calls are **default-denied** while the account is inside its
/// 30-day deletion grace window: `403 account_pending_deletion`, mapped to an
/// `ApiException` and recognised by `isAccountPendingDeletion`. It is surfaced
/// untouched — no retry, no sign-out.
class NotificationsRepository {
  NotificationsRepository(this._dio);

  final Dio _dio;

  /// The contract's published bound on `limit` (`Limit` parameter). It is
  /// **validated, not clamped**: a value outside 1–100 is
  /// `400 validation_failed` on field `limit`.
  static const minLimit = 1;
  static const maxLimit = 100;

  /// `GET /me/notifications` — one page of the caller's own inbox, newest first.
  ///
  /// 🔴 **Branch on `hasMore`, never on `items.length`** (`openapi.yaml:1165`).
  /// This returns the envelope untouched so that signal survives; a page may
  /// carry fewer rows than [limit], or none, and still not be the last. Items
  /// the app ignores (see [notificationContentFor]) are NOT dropped here: they
  /// are part of the page the server counted, and filtering them is the
  /// notifier's job so the paging decision stays visible in one place.
  ///
  /// [cursor] is the contract's OPAQUE keyset token (`Cursor`: "opaque (base64
  /// keyset). Omit for the first page"): follow it, never parse or construct
  /// it. `null` means the first page.
  ///
  /// [category] narrows the page to one inbox tab. `null` is **All** and sends
  /// no `category` parameter at all — there is no `all` value to send. A
  /// category no kind maps to yet returns an empty page, which is a normal
  /// answer. Nothing reuses a cursor across categories: each tab keeps its own.
  Future<CursorPage<NotificationItem>> listMyNotifications({
    String? cursor,
    int? limit,
    NotificationCategory? category,
  }) async {
    assert(
      limit == null || (limit >= minLimit && limit <= maxLimit),
      'limit must be $minLimit..$maxLimit — the server rejects anything else '
      'with 400 validation_failed rather than clamping it.',
    );
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/me/notifications',
        // Absent, not null: a `cursor: null` would be a malformed cursor (400),
        // and `category` has no "all" spelling.
        queryParameters: {
          'cursor': ?cursor,
          'limit': ?limit,
          'category': ?category?.wire,
        },
      );
      return CursorPage<NotificationItem>.fromJson(
        res.data!,
        (json) => NotificationItem.fromJson(json! as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // fromJson runs OUTSIDE Dio — real-API schema drift throws a core
      // TypeError/FormatException here, not a DioException. Wrap it so the
      // typed boundary holds. runtimeType only: an announcement's text and an
      // id are exactly what must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `POST /me/notifications/{notificationId}/read` — mark one of the caller's
  /// own items read. Answers `204`, so there is nothing to decode and nothing
  /// to return.
  ///
  /// **Idempotent**: `readAt` is set once and never moved, so a second call is
  /// `204` too (`openapi.yaml:1252-1254`).
  ///
  /// `404 not_found` means the id is unknown **or belongs to another account**
  /// — one code for both, deliberately, so it cannot be used as an existence
  /// probe (`:1255-1258`). It is surfaced as the typed
  /// `ApiException(status: 404, code: 'not_found')` and NOT swallowed here: it
  /// is the caller that knows an unreachable item is as good as read.
  Future<void> markNotificationRead(String notificationId) async {
    try {
      await _dio.post<void>(
        '/me/notifications/${Uri.encodeComponent(notificationId)}/read',
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    }
  }

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(dioProvider)),
);
