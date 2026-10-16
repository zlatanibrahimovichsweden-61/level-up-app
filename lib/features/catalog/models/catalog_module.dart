import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_module.freezed.dart';
part 'catalog_module.g.dart';

/// One item of `GET /catalog/modules` (`listModules`) - a University student's
/// grouping of subjects, "an ADMIN-OWNED OVERLAY, never a scope" (adr-036 §3).
///
/// 🔴 **A module groups subjects for navigation and NOTHING else.** The contract
/// is explicit: "a module never scopes content, never gates an entitlement,
/// never enters a leaderboard key, never appears in a progress counter, and is
/// never on the import path". So nothing in this app may use a module to gate,
/// hide, count, rank or re-scope anything - it picks which already-loaded
/// subjects the Subjects screen lists, and that is all. A subject filed in ZERO
/// modules is legal and expected, which is why the picker keeps "All subjects"
/// on screen permanently.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// [name] arrives already in the content language (adr-018) - it is rendered
/// verbatim and never looked up in the ARB.
@freezed
abstract class CatalogModule with _$CatalogModule {
  const factory CatalogModule({
    required String id,
    required String name,

    /// The server sorts by this, then by [name]. Carried so the order is
    /// documented on the model; the app never re-sorts by it.
    required int displayOrder,

    /// adr-036 term signals, **optional** on this item and modelled like
    /// `Subject`'s: nullable, NO default, because a defaulted `termNumber`
    /// would fabricate an ordinal the server never sent. `termId` is opaque
    /// (adr-026 §7); `termNumber` is the only labellable term signal, and this
    /// build draws no term header (CW16b-M).
    String? termId,
    int? termNumber,

    /// The subjects in this module that pass the release gate. MAY be empty,
    /// and the contract promises no order for it: the app keeps the order as
    /// served and never re-sorts it.
    required List<String> subjectIds,
  }) = _CatalogModule;

  factory CatalogModule.fromJson(Map<String, dynamic> json) =>
      _$CatalogModuleFromJson(json);
}
