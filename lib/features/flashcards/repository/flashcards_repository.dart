import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../registration/models/reference_models.dart' show CursorPage;
import '../models/flashcard.dart';

/// The only place that touches Dio for the Flashcards study surface.
///
/// Both operations are `x-stability: stable` at the current pin and carry no
/// `x-consumers`, so they are this app's to build. They are authenticated and
/// ride the main [dioProvider], so `AuthInterceptor` attaches the Bearer and
/// `ErrorInterceptor` has already mapped failures by the time they arrive here.
///
/// **University track only.** The refusal for everyone else is deliberately
/// indistinguishable from three other causes — see [getFlashcardsForLecture].
///
/// `CursorPage` is reused from `reference_models.dart` rather than redeclared:
/// the contract has exactly ONE open-list envelope (ADR-026 §6) and that file
/// models it generically for precisely this.
class FlashcardsRepository {
  FlashcardsRepository(this._dio);

  final Dio _dio;

  /// The contract's own default. Its maximum is 50 — **not** the 100 the
  /// shared `Limit` parameter allows — and that narrower cap is deliberate: a
  /// page is charged per distinct card against a 50/week allowance, so a
  /// 100-card page could spend a non-holder's whole week in one request.
  ///
  /// The ceiling is deliberately NOT mirrored as a constant here. Nothing in
  /// this app sends anything but this default, the bound is the server's to
  /// enforce (`400 validation_failed` outside `1..50`), and
  /// `ReferenceRepository.searchSchools` passes its own `limit` through the
  /// same way. A client-side copy would be a second source of truth for a
  /// number only the contract owns.
  static const defaultPageSize = 20;

  /// `GET /flashcards/lectures/{lectureId}/cards` — one lecture's cards.
  ///
  /// 🔴 **A page may come back SHORTER than [pageSize] and still not be the end
  /// of the list.** When the caller's remaining weekly allowance cannot pay for
  /// a whole page, the server delivers the prefix it can pay for, sets
  /// `hasMore: true` and returns a `nextCursor` pointing at the first card they
  /// did NOT receive. **Callers must branch on `hasMore`, never on
  /// `items.length`.** This repository returns the envelope untouched so that
  /// distinction survives; collapsing it to a bare list here would destroy the
  /// only signal that says whether to keep paging.
  ///
  /// An EMPTY `items` is a normal response meaning the lecture genuinely has no
  /// active cards. It is not the allowance running out — that case is
  /// `403 flashcard_subscription_required`, never an empty page.
  ///
  /// **Two ways to receive cards.** With an active `flashcardSubscription`
  /// every page is delivered in full and nothing is counted. Without one, each
  /// card not already shown THIS WEEK consumes one unit of the same 50/week
  /// allowance quiz questions draw from — one allowance across both surfaces,
  /// not 50 each — and a card already charged for re-delivers free, so paging
  /// back and forth never costs twice. A `baseSubscription` changes nothing
  /// here: the two subscriptions are independent (adr-004/adr-060).
  ///
  /// [cursor] is the contract's OPAQUE keyset token: follow it, never parse or
  /// construct it. `null` means the first page.
  Future<CursorPage<FlashcardCard>> getFlashcardsForLecture(
    String lectureId, {
    String? cursor,
    int? pageSize,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/flashcards/lectures/$lectureId/cards',
        queryParameters: {'cursor': ?cursor, 'pageSize': ?pageSize},
      );
      return CursorPage<FlashcardCard>.fromJson(
        res.data!,
        (json) => FlashcardCard.fromJson(json! as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a core
      // TypeError/FormatException here, not a DioException. Wrap it so the
      // typed boundary holds. runtimeType only: response bodies carry minors'
      // data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `PUT /flashcards/cards/{flashcardId}/self-grade` — record the latest
  /// grade. Answers `204`, so there is nothing to decode and nothing to return.
  ///
  /// **Idempotent**: sending the same value twice is `204` both times, which is
  /// what makes a user-tapped retry safe.
  ///
  /// Same gate as the card list, plus one more collapsed cause: grading a card
  /// that exists but was never shown to you is the same `403
  /// insufficient_scope`, for the same no-existence-oracle reason.
  /// `flashcard_subscription_required` is deliberately NOT returned here —
  /// grading a card you were never shown has exhausted nothing, so offering a
  /// subscription would be both false and a confirmation that the card exists.
  Future<void> setSelfGrade(
    String flashcardId,
    FlashcardSelfGrade grade,
  ) async {
    try {
      await _dio.put<void>(
        '/flashcards/cards/$flashcardId/self-grade',
        // Encoded by name, matching the contract enum `[gotIt, again]`. The
        // generated `_$FlashcardSelfGradeEnumMap` is private to the model
        // library, and the two values are their own wire spelling.
        data: {'grade': grade.name},
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

final flashcardsRepositoryProvider = Provider<FlashcardsRepository>(
  (ref) => FlashcardsRepository(ref.watch(dioProvider)),
);
