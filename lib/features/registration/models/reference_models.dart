import 'package:freezed_annotation/freezed_annotation.dart';

part 'reference_models.freezed.dart';
part 'reference_models.g.dart';

/// The reference-data models consumed by the registration wizard's pickers.
/// Every one mirrors a `/reference/*` response in Seif's contract EXACTLY.
///
/// Contract keys are already camelCase, so NO `@JsonKey` bridge is needed and
/// none must be added. Contract-required fields are `required` with no default —
/// a missing field must throw, surfacing contract drift rather than hiding it.
///
/// `EducationSystem.code` and `StudyYearRef.status` are kept as `String` (not
/// Dart enums) on purpose: the contract marks `EducationSystem` as extensible
/// ("clients must tolerate unknown values"), and a generated enum would throw on
/// a newly-added value. The UI compares against the known wire values.

/// Generic bilingual reference row — `{id, nameAr, nameEn}`. Reused for
/// governorates, cities, and schools (contract `NamedRef`). `id` is a UUID
/// string, opaque to the client; the UI shows `nameAr`/`nameEn` by locale and
/// submits `id`.
@freezed
abstract class NamedRef with _$NamedRef {
  const factory NamedRef({
    required String id,
    required String nameAr,
    required String nameEn,
  }) = _NamedRef;

  factory NamedRef.fromJson(Map<String, dynamic> json) =>
      _$NamedRefFromJson(json);
}

/// A registration country — `GET /reference/countries`.
/// `requiresGovernorate` is `true` only for EG and drives the geography branch
/// (EG → governorate + city + school; other → city only).
@freezed
abstract class Country with _$Country {
  const factory Country({
    required String code,
    required String nameAr,
    required String nameEn,
    required bool requiresGovernorate,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}

/// A school education system — `GET /reference/education-systems`.
/// `code` is the wire enum value (`nationalArabic` / `nationalLanguages` / `ig`
/// / `american` / `ib`, extensible) submitted verbatim at registration.
@freezed
abstract class EducationSystemRef with _$EducationSystemRef {
  const factory EducationSystemRef({
    required String code,
    required String nameAr,
    required String nameEn,
  }) = _EducationSystemRef;

  factory EducationSystemRef.fromJson(Map<String, dynamic> json) =>
      _$EducationSystemRefFromJson(json);
}

/// A university with its nested faculties — `GET /reference/universities`.
/// The client drills university → faculty → year; only `active` years are
/// selectable at registration (`soon` years are shown but rejected server-side).
@freezed
abstract class UniversityRef with _$UniversityRef {
  const factory UniversityRef({
    required String id,
    required String nameAr,
    required String nameEn,
    required List<FacultyRef> faculties,
  }) = _UniversityRef;

  factory UniversityRef.fromJson(Map<String, dynamic> json) =>
      _$UniversityRefFromJson(json);
}

/// A faculty within a [UniversityRef], carrying its data-driven study years.
@freezed
abstract class FacultyRef with _$FacultyRef {
  const factory FacultyRef({
    required String id,
    required String nameAr,
    required String nameEn,
    required List<StudyYearRef> years,
  }) = _FacultyRef;

  factory FacultyRef.fromJson(Map<String, dynamic> json) =>
      _$FacultyRefFromJson(json);
}

/// A study year within a [FacultyRef]. `status` is `active` | `soon` (kept as a
/// `String` — the UI only enables `active`); submit `id` as `studyYearId`.
@freezed
abstract class StudyYearRef with _$StudyYearRef {
  const factory StudyYearRef({
    required String id,
    required int yearNumber,
    required String status,
  }) = _StudyYearRef;

  factory StudyYearRef.fromJson(Map<String, dynamic> json) =>
      _$StudyYearRefFromJson(json);
}

/// A default avatar — `GET /reference/avatars`. `url` is a network image the
/// registration avatar picker (Day 3) renders; submit `id`.
@freezed
abstract class Avatar with _$Avatar {
  const factory Avatar({required String id, required String url}) = _Avatar;

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}

/// The contract's single open-list envelope (`CursorPage`, ADR-026 §6). Modeled
/// once, generically — `schools` is the first consumer; Day-3 lists reuse it.
/// `nextCursor` is an opaque base64 keyset (`null` ⇒ no more pages).
@Freezed(genericArgumentFactories: true)
abstract class CursorPage<T> with _$CursorPage<T> {
  const factory CursorPage({
    required List<T> items,
    String? nextCursor,
    required bool hasMore,
  }) = _CursorPage<T>;

  factory CursorPage.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CursorPageFromJson(json, fromJsonT);
}
