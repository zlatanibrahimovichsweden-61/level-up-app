import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_module.freezed.dart';
part 'catalog_module.g.dart';

/// One element of `GET /catalog/modules` (`listModules`, `openapi.yaml:1685`),
/// the inline item schema required `[id, name, displayOrder, subjectIds]`.
///
/// The contract names no component schema for it. A module is the subject
/// picker's **admin-owned grouping overlay** (adr-036 §3): it groups subjects
/// for navigation and NOTHING else. It never scopes content, never gates an
/// entitlement, never enters a leaderboard key, never appears in a progress
/// counter and is never on the import path. So no code may treat a module as a
/// scope or filter content by it.
///
/// **"All subjects" is not a module.** There is no such entry in the response:
/// `GET /catalog/subjects` IS that view, and a subject filed in zero modules is
/// legal and expected. A picker built on this model must keep the "All
/// subjects" view permanently - a module-only picker would silently hide
/// content.
///
/// University only: a school student's response is the empty array, a normal
/// answer rather than an error.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
@freezed
abstract class CatalogModule with _$CatalogModule {
  const factory CatalogModule({
    required String id,

    /// Server copy in the content language (adr-018), rendered verbatim.
    required String name,

    /// The server's order: the response is already sorted by [displayOrder]
    /// and then [name], so keep the list as received. Carried for fidelity,
    /// not for re-sorting.
    required int displayOrder,

    /// adr-036 term signals, **optional AND nullable, and null is normal** (a
    /// university profile during the summer gap, or a cohort with no schedule
    /// row). [termId] is opaque (adr-026 §7): never hardcode one and never
    /// derive an order from it. [termNumber] is the only orderable/labellable
    /// term signal on the wire; term NAMES are never sent, so any label is
    /// rendered client-side.
    String? termId,
    int? termNumber,

    /// The ids of the subjects filed in this module that passed the release
    /// gate. **May be empty.** These are `Subject.id` values from
    /// `GET /catalog/subjects`; resolve them there, do not assume every one is
    /// present in a list the caller already holds.
    required List<String> subjectIds,
  }) = _CatalogModule;

  factory CatalogModule.fromJson(Map<String, dynamic> json) =>
      _$CatalogModuleFromJson(json);
}
