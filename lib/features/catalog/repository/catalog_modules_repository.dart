import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/catalog_module.dart';

/// The only place that touches Dio for the subject picker's module overlay
/// (CW16b data layer).
///
/// One operation, `x-stability: stable` with no `x-consumers`
/// (`openapi.yaml:1685`), authenticated and on the main [dioProvider]. It lives
/// beside `CatalogRepository` rather than in it so the Learn tab's existing
/// repository, its notifiers and their tests stay untouched until the module
/// picker's release scope is ruled (B-2 row 14). Nothing consumes it yet.
///
/// Like `GET /catalog/subjects`, it takes no scope parameters: the server
/// derives the student's scope from the token (adr-013). If you find yourself
/// adding `?track=` here, the contract is being worked around.
class CatalogModulesRepository {
  CatalogModulesRepository(this._dio);

  final Dio _dio;

  /// `GET /catalog/modules` - a BARE array (a closed per-student set, no
  /// pagination envelope), already ordered by `displayOrder` then `name`, so
  /// the list is returned exactly as received.
  ///
  /// **Possibly EMPTY, and that is a normal answer**: a school student always
  /// gets `[]` (the overlay is university-only), and a university student gets
  /// `[]` when no module of theirs has a released term.
  ///
  /// Entitlement is not consulted: this is a catalog read, so there is no
  /// subscription-shaped refusal to handle. The ordinary ones (`401`, and
  /// `403 account_pending_deletion` while the account is in its deletion grace
  /// window) surface untouched as the typed [AppException].
  ///
  /// This is NOT the "All subjects" view - that is `GET /catalog/subjects`
  /// (`CatalogRepository.getSubjects`), and a picker must keep it.
  Future<List<CatalogModule>> listModules() async {
    try {
      final res = await _dio.get<List<dynamic>>('/catalog/modules');
      return (res.data ?? const [])
          .map((e) => CatalogModule.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio - real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final catalogModulesRepositoryProvider = Provider<CatalogModulesRepository>(
  (ref) => CatalogModulesRepository(ref.watch(dioProvider)),
);
