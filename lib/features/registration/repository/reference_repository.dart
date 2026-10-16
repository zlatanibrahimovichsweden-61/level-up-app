import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/reference_models.dart';

/// The only place that touches Dio for the registration reference pickers.
/// Returns domain models, throws the typed [AppException] hierarchy; the
/// notifiers/pickers catch these and the UI never sees Dio.
///
/// All eight endpoints are `x-stability: stable` and `security: []` (public —
/// needed at registration before any account exists). They ride the main
/// [dioProvider]; with no stored token the AuthInterceptor attaches no Bearer,
/// which is exactly right here.
///
/// Closed sets come back as bare arrays; only `schools` is cursor-paginated.
class ReferenceRepository {
  ReferenceRepository(this._dio);

  final Dio _dio;

  /// `GET /reference/countries` — launch countries (EG, AE, SA, OM…).
  Future<List<Country>> getCountries() async {
    try {
      final res = await _dio.get<List<dynamic>>('/reference/countries');
      return res.data!
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/countries/{countryCode}/governorates` — empty for non-EG.
  Future<List<NamedRef>> getGovernorates(String countryCode) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '/reference/countries/$countryCode/governorates',
      );
      return res.data!
          .map((e) => NamedRef.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/cities` — EG passes `governorateId`; other countries pass
  /// `countryCode` only.
  Future<List<NamedRef>> getCities({
    required String countryCode,
    String? governorateId,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '/reference/cities',
        queryParameters: {
          'countryCode': countryCode,
          'governorateId': ?governorateId,
        },
      );
      return res.data!
          .map((e) => NamedRef.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/schools` — Egyptian coded school search, cursor-paginated.
  /// Omit `cursor` for the first page; follow [CursorPage.nextCursor] for more.
  Future<CursorPage<NamedRef>> searchSchools({
    String? q,
    String? governorateId,
    String? cityId,
    String? cursor,
    int? limit,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/reference/schools',
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
          'governorateId': ?governorateId,
          'cityId': ?cityId,
          'cursor': ?cursor,
          'limit': ?limit,
        },
      );
      return CursorPage<NamedRef>.fromJson(
        res.data!,
        (json) => NamedRef.fromJson(json! as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/education-systems` — school systems (closed, bare array).
  Future<List<EducationSystemRef>> getEducationSystems() async {
    try {
      final res = await _dio.get<List<dynamic>>('/reference/education-systems');
      return res.data!
          .map((e) => EducationSystemRef.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/school-stages` — the six School stages, each `active` or
  /// `soon` (closed, bare array, `listSchoolStages`). The open set is a server
  /// setting, so the School form reads it on every visit.
  Future<List<SchoolStageRef>> getSchoolStages() async {
    try {
      final res = await _dio.get<List<dynamic>>('/reference/school-stages');
      return res.data!
          .map((e) => SchoolStageRef.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/universities` — nested universities → faculties → years.
  Future<List<UniversityRef>> getUniversities() async {
    try {
      final res = await _dio.get<List<dynamic>>('/reference/universities');
      return res.data!
          .map((e) => UniversityRef.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
      // core TypeError/FormatException here, not a DioException. Wrap it so
      // the typed boundary holds. runtimeType only: response bodies carry
      // minors' data and must never leak into an error detail.
      throw UnknownException(detail: 'parse: ${e.runtimeType}');
    }
  }

  /// `GET /reference/avatars` — the default avatars (closed, bare array).
  Future<List<Avatar>> getAvatars() async {
    try {
      final res = await _dio.get<List<dynamic>>('/reference/avatars');
      return res.data!
          .map((e) => Avatar.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asAppException(e);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      // F-7-01: fromJson runs OUTSIDE Dio — real-API schema drift throws a
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

final referenceRepositoryProvider = Provider<ReferenceRepository>(
  (ref) => ReferenceRepository(ref.watch(dioProvider)),
);
