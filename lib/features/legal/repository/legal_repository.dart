import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/legal_document.dart';

/// The only place that touches Dio for the legal documents.
///
/// One operation, `getLegalDocument` (`GET /reference/legal-documents/
/// {document}`, `openapi.yaml:811`): `x-stability: stable`, `x-consumers:
/// [mobile, web]` and `security: []` — public, because Login links to these
/// documents before any account exists. Like the other `/reference` reads it
/// rides the main [dioProvider]; with no stored token the AuthInterceptor
/// attaches no Bearer.
///
/// Failures arrive already typed by the ErrorInterceptor and are rethrown as
/// they are:
/// - `404 legal_document_unavailable` → `ApiException(404, …)`: no approved
///   text is configured. "Never an empty 200", and not to be cached.
/// - `429 rate_limited` → [RateLimitedException] (the `/reference` per-address
///   limit; `Retry-After` when sent).
/// - `400 validation_failed` → [ValidationException]; unreachable, both
///   parameters come from closed enums.
/// - no connection / timeout → [NetworkException].
///
/// No `If-None-Match` is sent, so no `304` can come back: the document is
/// fetched each time the viewer opens, and nothing is cached on the device.
///
/// Nothing in this file logs a document, its text or its version.
class LegalRepository {
  LegalRepository(this._dio);

  final Dio _dio;

  /// The approved [document] text in [language] (`ar` | `en`).
  Future<LegalDocumentContent> getLegalDocument(
    LegalDocument document, {
    required String language,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/reference/legal-documents/${document.wireValue}',
        queryParameters: {'language': language},
      );
      return LegalDocumentContent.fromJson(res.data!);
    } on DioException catch (e) {
      final err = e.error;
      throw err is AppException ? err : const UnknownException();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // fromJson runs OUTSIDE Dio, so a body that breaks the contract throws a
      // TypeError here. The runtime type only: never the text.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }
}

final legalRepositoryProvider = Provider<LegalRepository>(
  (ref) => LegalRepository(ref.watch(dioProvider)),
);
