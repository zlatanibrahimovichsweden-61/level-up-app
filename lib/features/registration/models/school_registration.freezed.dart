// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'school_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchoolRegistration {

/// The discriminator. Defaulted rather than `required` because it is a
/// constant of THIS shape, not data — see `discriminator.mapping` in the
/// contract.
 String get track; String get registrationToken;/// Contract-REQUIRED since 2.0.0-m1. No `@JsonKey`: the key is already
/// camelCase, and `includeIfNull` cannot apply to a non-nullable field —
/// this is a required field, not one of the omit-when-absent optionals.
 DeviceInfo get device; String get name;@DateOnlyConverter() DateTime get dateOfBirth; String get countryCode;@JsonKey(includeIfNull: false) String? get governorateId;/// adr-028 §1 — exactly one of these two reaches the wire. Both are
/// nullable because the contract expresses "at least one" as an `anyOf`
/// rather than by making either required.
@JsonKey(includeIfNull: false) String? get cityId;@JsonKey(includeIfNull: false) String? get cityName;@JsonKey(includeIfNull: false) String? get schoolId; String get stage; String get educationSystem; String get parentPhone;@JsonKey(includeIfNull: false) String? get email;@JsonKey(includeIfNull: false) String? get avatarId;/// A friend's Refer a Friend code (`SchoolRegistration.inviteCode`). The
/// contract ignores case, spaces and hyphens, so the code goes out as typed
/// bar the outer whitespace. `includeIfNull: false` is load-bearing: the
/// key is OMITTED when the student entered nothing, never null and never
/// empty (`Only a string is accepted`).
@JsonKey(includeIfNull: false) String? get inviteCode;
/// Create a copy of SchoolRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchoolRegistrationCopyWith<SchoolRegistration> get copyWith => _$SchoolRegistrationCopyWithImpl<SchoolRegistration>(this as SchoolRegistration, _$identity);

  /// Serializes this SchoolRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchoolRegistration&&(identical(other.track, track) || other.track == track)&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.device, device) || other.device == device)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.governorateId, governorateId) || other.governorateId == governorateId)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,registrationToken,device,name,dateOfBirth,countryCode,governorateId,cityId,cityName,schoolId,stage,educationSystem,parentPhone,email,avatarId,inviteCode);



}

/// @nodoc
abstract mixin class $SchoolRegistrationCopyWith<$Res>  {
  factory $SchoolRegistrationCopyWith(SchoolRegistration value, $Res Function(SchoolRegistration) _then) = _$SchoolRegistrationCopyWithImpl;
@useResult
$Res call({
 String track, String registrationToken, DeviceInfo device, String name,@DateOnlyConverter() DateTime dateOfBirth, String countryCode,@JsonKey(includeIfNull: false) String? governorateId,@JsonKey(includeIfNull: false) String? cityId,@JsonKey(includeIfNull: false) String? cityName,@JsonKey(includeIfNull: false) String? schoolId, String stage, String educationSystem, String parentPhone,@JsonKey(includeIfNull: false) String? email,@JsonKey(includeIfNull: false) String? avatarId,@JsonKey(includeIfNull: false) String? inviteCode
});


$DeviceInfoCopyWith<$Res> get device;

}
/// @nodoc
class _$SchoolRegistrationCopyWithImpl<$Res>
    implements $SchoolRegistrationCopyWith<$Res> {
  _$SchoolRegistrationCopyWithImpl(this._self, this._then);

  final SchoolRegistration _self;
  final $Res Function(SchoolRegistration) _then;

/// Create a copy of SchoolRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? registrationToken = null,Object? device = null,Object? name = null,Object? dateOfBirth = null,Object? countryCode = null,Object? governorateId = freezed,Object? cityId = freezed,Object? cityName = freezed,Object? schoolId = freezed,Object? stage = null,Object? educationSystem = null,Object? parentPhone = null,Object? email = freezed,Object? avatarId = freezed,Object? inviteCode = freezed,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as String,registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,governorateId: freezed == governorateId ? _self.governorateId : governorateId // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,educationSystem: null == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String,parentPhone: null == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarId: freezed == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String?,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SchoolRegistration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get device {
  
  return $DeviceInfoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [SchoolRegistration].
extension SchoolRegistrationPatterns on SchoolRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchoolRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchoolRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchoolRegistration value)  $default,){
final _that = this;
switch (_that) {
case _SchoolRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchoolRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _SchoolRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String track,  String registrationToken,  DeviceInfo device,  String name, @DateOnlyConverter()  DateTime dateOfBirth,  String countryCode, @JsonKey(includeIfNull: false)  String? governorateId, @JsonKey(includeIfNull: false)  String? cityId, @JsonKey(includeIfNull: false)  String? cityName, @JsonKey(includeIfNull: false)  String? schoolId,  String stage,  String educationSystem,  String parentPhone, @JsonKey(includeIfNull: false)  String? email, @JsonKey(includeIfNull: false)  String? avatarId, @JsonKey(includeIfNull: false)  String? inviteCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchoolRegistration() when $default != null:
return $default(_that.track,_that.registrationToken,_that.device,_that.name,_that.dateOfBirth,_that.countryCode,_that.governorateId,_that.cityId,_that.cityName,_that.schoolId,_that.stage,_that.educationSystem,_that.parentPhone,_that.email,_that.avatarId,_that.inviteCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String track,  String registrationToken,  DeviceInfo device,  String name, @DateOnlyConverter()  DateTime dateOfBirth,  String countryCode, @JsonKey(includeIfNull: false)  String? governorateId, @JsonKey(includeIfNull: false)  String? cityId, @JsonKey(includeIfNull: false)  String? cityName, @JsonKey(includeIfNull: false)  String? schoolId,  String stage,  String educationSystem,  String parentPhone, @JsonKey(includeIfNull: false)  String? email, @JsonKey(includeIfNull: false)  String? avatarId, @JsonKey(includeIfNull: false)  String? inviteCode)  $default,) {final _that = this;
switch (_that) {
case _SchoolRegistration():
return $default(_that.track,_that.registrationToken,_that.device,_that.name,_that.dateOfBirth,_that.countryCode,_that.governorateId,_that.cityId,_that.cityName,_that.schoolId,_that.stage,_that.educationSystem,_that.parentPhone,_that.email,_that.avatarId,_that.inviteCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String track,  String registrationToken,  DeviceInfo device,  String name, @DateOnlyConverter()  DateTime dateOfBirth,  String countryCode, @JsonKey(includeIfNull: false)  String? governorateId, @JsonKey(includeIfNull: false)  String? cityId, @JsonKey(includeIfNull: false)  String? cityName, @JsonKey(includeIfNull: false)  String? schoolId,  String stage,  String educationSystem,  String parentPhone, @JsonKey(includeIfNull: false)  String? email, @JsonKey(includeIfNull: false)  String? avatarId, @JsonKey(includeIfNull: false)  String? inviteCode)?  $default,) {final _that = this;
switch (_that) {
case _SchoolRegistration() when $default != null:
return $default(_that.track,_that.registrationToken,_that.device,_that.name,_that.dateOfBirth,_that.countryCode,_that.governorateId,_that.cityId,_that.cityName,_that.schoolId,_that.stage,_that.educationSystem,_that.parentPhone,_that.email,_that.avatarId,_that.inviteCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchoolRegistration extends SchoolRegistration {
  const _SchoolRegistration({this.track = kTrackSchool, required this.registrationToken, required this.device, required this.name, @DateOnlyConverter() required this.dateOfBirth, required this.countryCode, @JsonKey(includeIfNull: false) this.governorateId, @JsonKey(includeIfNull: false) this.cityId, @JsonKey(includeIfNull: false) this.cityName, @JsonKey(includeIfNull: false) this.schoolId, required this.stage, required this.educationSystem, required this.parentPhone, @JsonKey(includeIfNull: false) this.email, @JsonKey(includeIfNull: false) this.avatarId, @JsonKey(includeIfNull: false) this.inviteCode}): super._();
  factory _SchoolRegistration.fromJson(Map<String, dynamic> json) => _$SchoolRegistrationFromJson(json);

/// The discriminator. Defaulted rather than `required` because it is a
/// constant of THIS shape, not data — see `discriminator.mapping` in the
/// contract.
@override@JsonKey() final  String track;
@override final  String registrationToken;
/// Contract-REQUIRED since 2.0.0-m1. No `@JsonKey`: the key is already
/// camelCase, and `includeIfNull` cannot apply to a non-nullable field —
/// this is a required field, not one of the omit-when-absent optionals.
@override final  DeviceInfo device;
@override final  String name;
@override@DateOnlyConverter() final  DateTime dateOfBirth;
@override final  String countryCode;
@override@JsonKey(includeIfNull: false) final  String? governorateId;
/// adr-028 §1 — exactly one of these two reaches the wire. Both are
/// nullable because the contract expresses "at least one" as an `anyOf`
/// rather than by making either required.
@override@JsonKey(includeIfNull: false) final  String? cityId;
@override@JsonKey(includeIfNull: false) final  String? cityName;
@override@JsonKey(includeIfNull: false) final  String? schoolId;
@override final  String stage;
@override final  String educationSystem;
@override final  String parentPhone;
@override@JsonKey(includeIfNull: false) final  String? email;
@override@JsonKey(includeIfNull: false) final  String? avatarId;
/// A friend's Refer a Friend code (`SchoolRegistration.inviteCode`). The
/// contract ignores case, spaces and hyphens, so the code goes out as typed
/// bar the outer whitespace. `includeIfNull: false` is load-bearing: the
/// key is OMITTED when the student entered nothing, never null and never
/// empty (`Only a string is accepted`).
@override@JsonKey(includeIfNull: false) final  String? inviteCode;

/// Create a copy of SchoolRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchoolRegistrationCopyWith<_SchoolRegistration> get copyWith => __$SchoolRegistrationCopyWithImpl<_SchoolRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchoolRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchoolRegistration&&(identical(other.track, track) || other.track == track)&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.device, device) || other.device == device)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.governorateId, governorateId) || other.governorateId == governorateId)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,registrationToken,device,name,dateOfBirth,countryCode,governorateId,cityId,cityName,schoolId,stage,educationSystem,parentPhone,email,avatarId,inviteCode);



}

/// @nodoc
abstract mixin class _$SchoolRegistrationCopyWith<$Res> implements $SchoolRegistrationCopyWith<$Res> {
  factory _$SchoolRegistrationCopyWith(_SchoolRegistration value, $Res Function(_SchoolRegistration) _then) = __$SchoolRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String track, String registrationToken, DeviceInfo device, String name,@DateOnlyConverter() DateTime dateOfBirth, String countryCode,@JsonKey(includeIfNull: false) String? governorateId,@JsonKey(includeIfNull: false) String? cityId,@JsonKey(includeIfNull: false) String? cityName,@JsonKey(includeIfNull: false) String? schoolId, String stage, String educationSystem, String parentPhone,@JsonKey(includeIfNull: false) String? email,@JsonKey(includeIfNull: false) String? avatarId,@JsonKey(includeIfNull: false) String? inviteCode
});


@override $DeviceInfoCopyWith<$Res> get device;

}
/// @nodoc
class __$SchoolRegistrationCopyWithImpl<$Res>
    implements _$SchoolRegistrationCopyWith<$Res> {
  __$SchoolRegistrationCopyWithImpl(this._self, this._then);

  final _SchoolRegistration _self;
  final $Res Function(_SchoolRegistration) _then;

/// Create a copy of SchoolRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? registrationToken = null,Object? device = null,Object? name = null,Object? dateOfBirth = null,Object? countryCode = null,Object? governorateId = freezed,Object? cityId = freezed,Object? cityName = freezed,Object? schoolId = freezed,Object? stage = null,Object? educationSystem = null,Object? parentPhone = null,Object? email = freezed,Object? avatarId = freezed,Object? inviteCode = freezed,}) {
  return _then(_SchoolRegistration(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as String,registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,governorateId: freezed == governorateId ? _self.governorateId : governorateId // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,educationSystem: null == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String,parentPhone: null == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarId: freezed == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String?,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SchoolRegistration
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
