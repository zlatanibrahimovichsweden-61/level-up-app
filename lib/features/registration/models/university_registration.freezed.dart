// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'university_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UniversityRegistration {

 String get track; String get registrationToken;/// Contract-REQUIRED since 2.0.0-m1. No `@JsonKey`: the key is already
/// camelCase, and `includeIfNull` cannot apply to a non-nullable field.
 DeviceInfo get device; String get name;@DateOnlyConverter() DateTime get dateOfBirth; String get universityId; String get facultyId; String get studyYearId; String get governorateId;/// adr-028 §1 — exactly one of these two reaches the wire, same rule as
/// the school body. Both nullable: the contract expresses "at least one"
/// as an `anyOf`, not by making either required.
@JsonKey(includeIfNull: false) String? get cityId;@JsonKey(includeIfNull: false) String? get cityName; String get parentPhone;@JsonKey(includeIfNull: false) String? get email;@JsonKey(includeIfNull: false) String? get avatarId;
/// Create a copy of UniversityRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniversityRegistrationCopyWith<UniversityRegistration> get copyWith => _$UniversityRegistrationCopyWithImpl<UniversityRegistration>(this as UniversityRegistration, _$identity);

  /// Serializes this UniversityRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniversityRegistration&&(identical(other.track, track) || other.track == track)&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.device, device) || other.device == device)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.studyYearId, studyYearId) || other.studyYearId == studyYearId)&&(identical(other.governorateId, governorateId) || other.governorateId == governorateId)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,registrationToken,device,name,dateOfBirth,universityId,facultyId,studyYearId,governorateId,cityId,cityName,parentPhone,email,avatarId);

@override
String toString() {
  return 'UniversityRegistration(track: $track, registrationToken: $registrationToken, device: $device, name: $name, dateOfBirth: $dateOfBirth, universityId: $universityId, facultyId: $facultyId, studyYearId: $studyYearId, governorateId: $governorateId, cityId: $cityId, cityName: $cityName, parentPhone: $parentPhone, email: $email, avatarId: $avatarId)';
}


}

/// @nodoc
abstract mixin class $UniversityRegistrationCopyWith<$Res>  {
  factory $UniversityRegistrationCopyWith(UniversityRegistration value, $Res Function(UniversityRegistration) _then) = _$UniversityRegistrationCopyWithImpl;
@useResult
$Res call({
 String track, String registrationToken, DeviceInfo device, String name,@DateOnlyConverter() DateTime dateOfBirth, String universityId, String facultyId, String studyYearId, String governorateId,@JsonKey(includeIfNull: false) String? cityId,@JsonKey(includeIfNull: false) String? cityName, String parentPhone,@JsonKey(includeIfNull: false) String? email,@JsonKey(includeIfNull: false) String? avatarId
});


$DeviceInfoCopyWith<$Res> get device;

}
/// @nodoc
class _$UniversityRegistrationCopyWithImpl<$Res>
    implements $UniversityRegistrationCopyWith<$Res> {
  _$UniversityRegistrationCopyWithImpl(this._self, this._then);

  final UniversityRegistration _self;
  final $Res Function(UniversityRegistration) _then;

/// Create a copy of UniversityRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? registrationToken = null,Object? device = null,Object? name = null,Object? dateOfBirth = null,Object? universityId = null,Object? facultyId = null,Object? studyYearId = null,Object? governorateId = null,Object? cityId = freezed,Object? cityName = freezed,Object? parentPhone = null,Object? email = freezed,Object? avatarId = freezed,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as String,registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,studyYearId: null == studyYearId ? _self.studyYearId : studyYearId // ignore: cast_nullable_to_non_nullable
as String,governorateId: null == governorateId ? _self.governorateId : governorateId // ignore: cast_nullable_to_non_nullable
as String,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,parentPhone: null == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarId: freezed == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UniversityRegistration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get device {
  
  return $DeviceInfoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [UniversityRegistration].
extension UniversityRegistrationPatterns on UniversityRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UniversityRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UniversityRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UniversityRegistration value)  $default,){
final _that = this;
switch (_that) {
case _UniversityRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UniversityRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _UniversityRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String track,  String registrationToken,  DeviceInfo device,  String name, @DateOnlyConverter()  DateTime dateOfBirth,  String universityId,  String facultyId,  String studyYearId,  String governorateId, @JsonKey(includeIfNull: false)  String? cityId, @JsonKey(includeIfNull: false)  String? cityName,  String parentPhone, @JsonKey(includeIfNull: false)  String? email, @JsonKey(includeIfNull: false)  String? avatarId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UniversityRegistration() when $default != null:
return $default(_that.track,_that.registrationToken,_that.device,_that.name,_that.dateOfBirth,_that.universityId,_that.facultyId,_that.studyYearId,_that.governorateId,_that.cityId,_that.cityName,_that.parentPhone,_that.email,_that.avatarId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String track,  String registrationToken,  DeviceInfo device,  String name, @DateOnlyConverter()  DateTime dateOfBirth,  String universityId,  String facultyId,  String studyYearId,  String governorateId, @JsonKey(includeIfNull: false)  String? cityId, @JsonKey(includeIfNull: false)  String? cityName,  String parentPhone, @JsonKey(includeIfNull: false)  String? email, @JsonKey(includeIfNull: false)  String? avatarId)  $default,) {final _that = this;
switch (_that) {
case _UniversityRegistration():
return $default(_that.track,_that.registrationToken,_that.device,_that.name,_that.dateOfBirth,_that.universityId,_that.facultyId,_that.studyYearId,_that.governorateId,_that.cityId,_that.cityName,_that.parentPhone,_that.email,_that.avatarId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String track,  String registrationToken,  DeviceInfo device,  String name, @DateOnlyConverter()  DateTime dateOfBirth,  String universityId,  String facultyId,  String studyYearId,  String governorateId, @JsonKey(includeIfNull: false)  String? cityId, @JsonKey(includeIfNull: false)  String? cityName,  String parentPhone, @JsonKey(includeIfNull: false)  String? email, @JsonKey(includeIfNull: false)  String? avatarId)?  $default,) {final _that = this;
switch (_that) {
case _UniversityRegistration() when $default != null:
return $default(_that.track,_that.registrationToken,_that.device,_that.name,_that.dateOfBirth,_that.universityId,_that.facultyId,_that.studyYearId,_that.governorateId,_that.cityId,_that.cityName,_that.parentPhone,_that.email,_that.avatarId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UniversityRegistration extends UniversityRegistration {
  const _UniversityRegistration({this.track = kTrackUniversity, required this.registrationToken, required this.device, required this.name, @DateOnlyConverter() required this.dateOfBirth, required this.universityId, required this.facultyId, required this.studyYearId, required this.governorateId, @JsonKey(includeIfNull: false) this.cityId, @JsonKey(includeIfNull: false) this.cityName, required this.parentPhone, @JsonKey(includeIfNull: false) this.email, @JsonKey(includeIfNull: false) this.avatarId}): super._();
  factory _UniversityRegistration.fromJson(Map<String, dynamic> json) => _$UniversityRegistrationFromJson(json);

@override@JsonKey() final  String track;
@override final  String registrationToken;
/// Contract-REQUIRED since 2.0.0-m1. No `@JsonKey`: the key is already
/// camelCase, and `includeIfNull` cannot apply to a non-nullable field.
@override final  DeviceInfo device;
@override final  String name;
@override@DateOnlyConverter() final  DateTime dateOfBirth;
@override final  String universityId;
@override final  String facultyId;
@override final  String studyYearId;
@override final  String governorateId;
/// adr-028 §1 — exactly one of these two reaches the wire, same rule as
/// the school body. Both nullable: the contract expresses "at least one"
/// as an `anyOf`, not by making either required.
@override@JsonKey(includeIfNull: false) final  String? cityId;
@override@JsonKey(includeIfNull: false) final  String? cityName;
@override final  String parentPhone;
@override@JsonKey(includeIfNull: false) final  String? email;
@override@JsonKey(includeIfNull: false) final  String? avatarId;

/// Create a copy of UniversityRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniversityRegistrationCopyWith<_UniversityRegistration> get copyWith => __$UniversityRegistrationCopyWithImpl<_UniversityRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniversityRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UniversityRegistration&&(identical(other.track, track) || other.track == track)&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.device, device) || other.device == device)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.studyYearId, studyYearId) || other.studyYearId == studyYearId)&&(identical(other.governorateId, governorateId) || other.governorateId == governorateId)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,registrationToken,device,name,dateOfBirth,universityId,facultyId,studyYearId,governorateId,cityId,cityName,parentPhone,email,avatarId);

@override
String toString() {
  return 'UniversityRegistration(track: $track, registrationToken: $registrationToken, device: $device, name: $name, dateOfBirth: $dateOfBirth, universityId: $universityId, facultyId: $facultyId, studyYearId: $studyYearId, governorateId: $governorateId, cityId: $cityId, cityName: $cityName, parentPhone: $parentPhone, email: $email, avatarId: $avatarId)';
}


}

/// @nodoc
abstract mixin class _$UniversityRegistrationCopyWith<$Res> implements $UniversityRegistrationCopyWith<$Res> {
  factory _$UniversityRegistrationCopyWith(_UniversityRegistration value, $Res Function(_UniversityRegistration) _then) = __$UniversityRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String track, String registrationToken, DeviceInfo device, String name,@DateOnlyConverter() DateTime dateOfBirth, String universityId, String facultyId, String studyYearId, String governorateId,@JsonKey(includeIfNull: false) String? cityId,@JsonKey(includeIfNull: false) String? cityName, String parentPhone,@JsonKey(includeIfNull: false) String? email,@JsonKey(includeIfNull: false) String? avatarId
});


@override $DeviceInfoCopyWith<$Res> get device;

}
/// @nodoc
class __$UniversityRegistrationCopyWithImpl<$Res>
    implements _$UniversityRegistrationCopyWith<$Res> {
  __$UniversityRegistrationCopyWithImpl(this._self, this._then);

  final _UniversityRegistration _self;
  final $Res Function(_UniversityRegistration) _then;

/// Create a copy of UniversityRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? registrationToken = null,Object? device = null,Object? name = null,Object? dateOfBirth = null,Object? universityId = null,Object? facultyId = null,Object? studyYearId = null,Object? governorateId = null,Object? cityId = freezed,Object? cityName = freezed,Object? parentPhone = null,Object? email = freezed,Object? avatarId = freezed,}) {
  return _then(_UniversityRegistration(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as String,registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,studyYearId: null == studyYearId ? _self.studyYearId : studyYearId // ignore: cast_nullable_to_non_nullable
as String,governorateId: null == governorateId ? _self.governorateId : governorateId // ignore: cast_nullable_to_non_nullable
as String,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,parentPhone: null == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarId: freezed == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UniversityRegistration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get device {
  
  return $DeviceInfoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
