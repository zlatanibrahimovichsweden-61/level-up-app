import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../models/subject.dart';
import '../models/subject_tree.dart';

/// The only place that touches Dio for the catalog browse stack.
///
/// Both endpoints are `x-stability: stable` and authenticated, so they ride the
/// main [dioProvider] and the AuthInterceptor attaches the Bearer.
///
/// Neither call takes scope parameters: the server derives the student's scope
/// from the token (adr-013). If you ever find yourself adding `?stage=` here,
/// the contract is being worked around.
class CatalogRepository {
  CatalogRepository(this._dio);

  final Dio _dio;

  /// `GET /catalog/subjects` — a BARE array (no pagination envelope: the
  /// per-student set is closed and small).
  Future<List<Subject>> getSubjects() async {
    try {
      final res = await _dio.get<List<dynamic>>('/catalog/subjects');
      return (res.data ?? const [])
          .map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } on DioException catch (e) {
      throw _asAppException(e);
    }
  }

  /// `GET /catalog/subjects/{subjectId}/tree` — the WHOLE nested structure in
  /// one call. Callers must fetch this once per subject and read every level
  /// from the result; there is no per-level endpoint to call.
  ///
  /// A `403 insufficient_scope` (subject outside the caller's scope) arrives
  /// here as an [ApiException] carrying that code — the ErrorInterceptor
  /// already mapped it — and the screens turn it into its own copy rather than
  /// a generic failure.
  Future<SubjectTree> getSubjectTree(String subjectId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/catalog/subjects/$subjectId/tree',
      );
      final json = res.data!;
      // The contract's `discriminator: {propertyName: track, mapping: {...}}`,
      // mirrored one-for-one. Dispatching on the key BEFORE parsing is what
      // keeps a university payload from being fed to the school model, where the
      // missing `units` would surface as a raw TypeError out of generated code.
      //
      // A fourth value is contract drift, not a client bug: it fails loudly with
      // a typed error instead of rendering an empty screen.
      return switch (json['track']) {
        'school' => SchoolSubjectTree.fromJson(json),
        'university' => UniversitySubjectTree.fromJson(json),
        final track => throw UnknownException(
          detail: 'unsupported subject tree track: $track',
        ),
      };
    } on DioException catch (e) {
      throw _asAppException(e);
    }
  }

  /// The ErrorInterceptor already mapped the failure onto [DioException.error].
  /// Unwrap it; fall back to [UnknownException] if something bypassed the chain.
  AppException _asAppException(DioException e) {
    final err = e.error;
    return err is AppException ? err : const UnknownException();
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(ref.watch(dioProvider)),
);
