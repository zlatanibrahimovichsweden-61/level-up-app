// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegistrationDraft {

 String get registrationToken; DateTime get tokenExpiresAt; String get phone; String? get name; String? get parentPhone; String? get referralCode; RegTrack? get track; DateTime? get dateOfBirth; String? get countryCode; bool? get requiresGovernorate; String? get governorateId;/// The adr-028 §1 city union, held as two fields because the wire has two
/// keys. Never both at once: every setter that populates one clears the
/// other, which is what makes `cityUnionFromDraft`'s "both → throw"
/// unreachable through the UI.
 String? get cityId; String? get cityName; String? get schoolId; String? get stage; String? get educationSystem; String? get universityId; String? get facultyId; String? get studyYearId;
/// Create a copy of RegistrationDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationDraftCopyWith<RegistrationDraft> get copyWith => _$RegistrationDraftCopyWithImpl<RegistrationDraft>(this as RegistrationDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationDraft&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.tokenExpiresAt, tokenExpiresAt) || other.tokenExpiresAt == tokenExpiresAt)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.track, track) || other.track == track)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.requiresGovernorate, requiresGovernorate) || other.requiresGovernorate == requiresGovernorate)&&(identical(other.governorateId, governorateId) || other.governorateId == governorateId)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.studyYearId, studyYearId) || other.studyYearId == studyYearId));
}


@override
int get hashCode => Object.hashAll([runtimeType,registrationToken,tokenExpiresAt,phone,name,parentPhone,referralCode,track,dateOfBirth,countryCode,requiresGovernorate,governorateId,cityId,cityName,schoolId,stage,educationSystem,universityId,facultyId,studyYearId]);

@override
String toString() {
  return 'RegistrationDraft(registrationToken: $registrationToken, tokenExpiresAt: $tokenExpiresAt, phone: $phone, name: $name, parentPhone: $parentPhone, referralCode: $referralCode, track: $track, dateOfBirth: $dateOfBirth, countryCode: $countryCode, requiresGovernorate: $requiresGovernorate, governorateId: $governorateId, cityId: $cityId, cityName: $cityName, schoolId: $schoolId, stage: $stage, educationSystem: $educationSystem, universityId: $universityId, facultyId: $facultyId, studyYearId: $studyYearId)';
}


}

/// @nodoc
abstract mixin class $RegistrationDraftCopyWith<$Res>  {
  factory $RegistrationDraftCopyWith(RegistrationDraft value, $Res Function(RegistrationDraft) _then) = _$RegistrationDraftCopyWithImpl;
@useResult
$Res call({
 String registrationToken, DateTime tokenExpiresAt, String phone, String? name, String? parentPhone, String? referralCode, RegTrack? track, DateTime? dateOfBirth, String? countryCode, bool? requiresGovernorate, String? governorateId, String? cityId, String? cityName, String? schoolId, String? stage, String? educationSystem, String? universityId, String? facultyId, String? studyYearId
});




}
/// @nodoc
class _$RegistrationDraftCopyWithImpl<$Res>
    implements $RegistrationDraftCopyWith<$Res> {
  _$RegistrationDraftCopyWithImpl(this._self, this._then);

  final RegistrationDraft _self;
  final $Res Function(RegistrationDraft) _then;

/// Create a copy of RegistrationDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationToken = null,Object? tokenExpiresAt = null,Object? phone = null,Object? name = freezed,Object? parentPhone = freezed,Object? referralCode = freezed,Object? track = freezed,Object? dateOfBirth = freezed,Object? countryCode = freezed,Object? requiresGovernorate = freezed,Object? governorateId = freezed,Object? cityId = freezed,Object? cityName = freezed,Object? schoolId = freezed,Object? stage = freezed,Object? educationSystem = freezed,Object? universityId = freezed,Object? facultyId = freezed,Object? studyYearId = freezed,}) {
  return _then(_self.copyWith(
registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,tokenExpiresAt: null == tokenExpiresAt ? _self.tokenExpiresAt : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentPhone: freezed == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String?,referralCode: freezed == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as RegTrack?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,requiresGovernorate: freezed == requiresGovernorate ? _self.requiresGovernorate : requiresGovernorate // ignore: cast_nullable_to_non_nullable
as bool?,governorateId: freezed == governorateId ? _self.governorateId : governorateId // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,educationSystem: freezed == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String?,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,facultyId: freezed == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String?,studyYearId: freezed == studyYearId ? _self.studyYearId : studyYearId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationDraft].
extension RegistrationDraftPatterns on RegistrationDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationDraft value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationDraft value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String registrationToken,  DateTime tokenExpiresAt,  String phone,  String? name,  String? parentPhone,  String? referralCode,  RegTrack? track,  DateTime? dateOfBirth,  String? countryCode,  bool? requiresGovernorate,  String? governorateId,  String? cityId,  String? cityName,  String? schoolId,  String? stage,  String? educationSystem,  String? universityId,  String? facultyId,  String? studyYearId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationDraft() when $default != null:
return $default(_that.registrationToken,_that.tokenExpiresAt,_that.phone,_that.name,_that.parentPhone,_that.referralCode,_that.track,_that.dateOfBirth,_that.countryCode,_that.requiresGovernorate,_that.governorateId,_that.cityId,_that.cityName,_that.schoolId,_that.stage,_that.educationSystem,_that.universityId,_that.facultyId,_that.studyYearId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String registrationToken,  DateTime tokenExpiresAt,  String phone,  String? name,  String? parentPhone,  String? referralCode,  RegTrack? track,  DateTime? dateOfBirth,  String? countryCode,  bool? requiresGovernorate,  String? governorateId,  String? cityId,  String? cityName,  String? schoolId,  String? stage,  String? educationSystem,  String? universityId,  String? facultyId,  String? studyYearId)  $default,) {final _that = this;
switch (_that) {
case _RegistrationDraft():
return $default(_that.registrationToken,_that.tokenExpiresAt,_that.phone,_that.name,_that.parentPhone,_that.referralCode,_that.track,_that.dateOfBirth,_that.countryCode,_that.requiresGovernorate,_that.governorateId,_that.cityId,_that.cityName,_that.schoolId,_that.stage,_that.educationSystem,_that.universityId,_that.facultyId,_that.studyYearId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String registrationToken,  DateTime tokenExpiresAt,  String phone,  String? name,  String? parentPhone,  String? referralCode,  RegTrack? track,  DateTime? dateOfBirth,  String? countryCode,  bool? requiresGovernorate,  String? governorateId,  String? cityId,  String? cityName,  String? schoolId,  String? stage,  String? educationSystem,  String? universityId,  String? facultyId,  String? studyYearId)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationDraft() when $default != null:
return $default(_that.registrationToken,_that.tokenExpiresAt,_that.phone,_that.name,_that.parentPhone,_that.referralCode,_that.track,_that.dateOfBirth,_that.countryCode,_that.requiresGovernorate,_that.governorateId,_that.cityId,_that.cityName,_that.schoolId,_that.stage,_that.educationSystem,_that.universityId,_that.facultyId,_that.studyYearId);case _:
  return null;

}
}

}

/// @nodoc


class _RegistrationDraft extends RegistrationDraft {
  const _RegistrationDraft({required this.registrationToken, required this.tokenExpiresAt, required this.phone, this.name, this.parentPhone, this.referralCode, this.track, this.dateOfBirth, this.countryCode, this.requiresGovernorate, this.governorateId, this.cityId, this.cityName, this.schoolId, this.stage, this.educationSystem, this.universityId, this.facultyId, this.studyYearId}): super._();
  

@override final  String registrationToken;
@override final  DateTime tokenExpiresAt;
@override final  String phone;
@override final  String? name;
@override final  String? parentPhone;
@override final  String? referralCode;
@override final  RegTrack? track;
@override final  DateTime? dateOfBirth;
@override final  String? countryCode;
@override final  bool? requiresGovernorate;
@override final  String? governorateId;
/// The adr-028 §1 city union, held as two fields because the wire has two
/// keys. Never both at once: every setter that populates one clears the
/// other, which is what makes `cityUnionFromDraft`'s "both → throw"
/// unreachable through the UI.
@override final  String? cityId;
@override final  String? cityName;
@override final  String? schoolId;
@override final  String? stage;
@override final  String? educationSystem;
@override final  String? universityId;
@override final  String? facultyId;
@override final  String? studyYearId;

/// Create a copy of RegistrationDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationDraftCopyWith<_RegistrationDraft> get copyWith => __$RegistrationDraftCopyWithImpl<_RegistrationDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationDraft&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.tokenExpiresAt, tokenExpiresAt) || other.tokenExpiresAt == tokenExpiresAt)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.track, track) || other.track == track)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.requiresGovernorate, requiresGovernorate) || other.requiresGovernorate == requiresGovernorate)&&(identical(other.governorateId, governorateId) || other.governorateId == governorateId)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.studyYearId, studyYearId) || other.studyYearId == studyYearId));
}


@override
int get hashCode => Object.hashAll([runtimeType,registrationToken,tokenExpiresAt,phone,name,parentPhone,referralCode,track,dateOfBirth,countryCode,requiresGovernorate,governorateId,cityId,cityName,schoolId,stage,educationSystem,universityId,facultyId,studyYearId]);

@override
String toString() {
  return 'RegistrationDraft(registrationToken: $registrationToken, tokenExpiresAt: $tokenExpiresAt, phone: $phone, name: $name, parentPhone: $parentPhone, referralCode: $referralCode, track: $track, dateOfBirth: $dateOfBirth, countryCode: $countryCode, requiresGovernorate: $requiresGovernorate, governorateId: $governorateId, cityId: $cityId, cityName: $cityName, schoolId: $schoolId, stage: $stage, educationSystem: $educationSystem, universityId: $universityId, facultyId: $facultyId, studyYearId: $studyYearId)';
}


}

/// @nodoc
abstract mixin class _$RegistrationDraftCopyWith<$Res> implements $RegistrationDraftCopyWith<$Res> {
  factory _$RegistrationDraftCopyWith(_RegistrationDraft value, $Res Function(_RegistrationDraft) _then) = __$RegistrationDraftCopyWithImpl;
@override @useResult
$Res call({
 String registrationToken, DateTime tokenExpiresAt, String phone, String? name, String? parentPhone, String? referralCode, RegTrack? track, DateTime? dateOfBirth, String? countryCode, bool? requiresGovernorate, String? governorateId, String? cityId, String? cityName, String? schoolId, String? stage, String? educationSystem, String? universityId, String? facultyId, String? studyYearId
});




}
/// @nodoc
class __$RegistrationDraftCopyWithImpl<$Res>
    implements _$RegistrationDraftCopyWith<$Res> {
  __$RegistrationDraftCopyWithImpl(this._self, this._then);

  final _RegistrationDraft _self;
  final $Res Function(_RegistrationDraft) _then;

/// Create a copy of RegistrationDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationToken = null,Object? tokenExpiresAt = null,Object? phone = null,Object? name = freezed,Object? parentPhone = freezed,Object? referralCode = freezed,Object? track = freezed,Object? dateOfBirth = freezed,Object? countryCode = freezed,Object? requiresGovernorate = freezed,Object? governorateId = freezed,Object? cityId = freezed,Object? cityName = freezed,Object? schoolId = freezed,Object? stage = freezed,Object? educationSystem = freezed,Object? universityId = freezed,Object? facultyId = freezed,Object? studyYearId = freezed,}) {
  return _then(_RegistrationDraft(
registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,tokenExpiresAt: null == tokenExpiresAt ? _self.tokenExpiresAt : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentPhone: freezed == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String?,referralCode: freezed == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as RegTrack?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,requiresGovernorate: freezed == requiresGovernorate ? _self.requiresGovernorate : requiresGovernorate // ignore: cast_nullable_to_non_nullable
as bool?,governorateId: freezed == governorateId ? _self.governorateId : governorateId // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,educationSystem: freezed == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String?,universityId: freezed == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String?,facultyId: freezed == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String?,studyYearId: freezed == studyYearId ? _self.studyYearId : studyYearId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
