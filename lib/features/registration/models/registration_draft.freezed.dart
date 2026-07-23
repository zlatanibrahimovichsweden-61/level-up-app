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

 String get registrationToken; DateTime get tokenExpiresAt; String get phone; String? get name; String? get parentPhone; String? get referralCode; RegTrack? get track; DateTime? get dateOfBirth;
/// Create a copy of RegistrationDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationDraftCopyWith<RegistrationDraft> get copyWith => _$RegistrationDraftCopyWithImpl<RegistrationDraft>(this as RegistrationDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationDraft&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.tokenExpiresAt, tokenExpiresAt) || other.tokenExpiresAt == tokenExpiresAt)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.track, track) || other.track == track)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}


@override
int get hashCode => Object.hash(runtimeType,registrationToken,tokenExpiresAt,phone,name,parentPhone,referralCode,track,dateOfBirth);

@override
String toString() {
  return 'RegistrationDraft(registrationToken: $registrationToken, tokenExpiresAt: $tokenExpiresAt, phone: $phone, name: $name, parentPhone: $parentPhone, referralCode: $referralCode, track: $track, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class $RegistrationDraftCopyWith<$Res>  {
  factory $RegistrationDraftCopyWith(RegistrationDraft value, $Res Function(RegistrationDraft) _then) = _$RegistrationDraftCopyWithImpl;
@useResult
$Res call({
 String registrationToken, DateTime tokenExpiresAt, String phone, String? name, String? parentPhone, String? referralCode, RegTrack? track, DateTime? dateOfBirth
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
@pragma('vm:prefer-inline') @override $Res call({Object? registrationToken = null,Object? tokenExpiresAt = null,Object? phone = null,Object? name = freezed,Object? parentPhone = freezed,Object? referralCode = freezed,Object? track = freezed,Object? dateOfBirth = freezed,}) {
  return _then(_self.copyWith(
registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,tokenExpiresAt: null == tokenExpiresAt ? _self.tokenExpiresAt : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentPhone: freezed == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String?,referralCode: freezed == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as RegTrack?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String registrationToken,  DateTime tokenExpiresAt,  String phone,  String? name,  String? parentPhone,  String? referralCode,  RegTrack? track,  DateTime? dateOfBirth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationDraft() when $default != null:
return $default(_that.registrationToken,_that.tokenExpiresAt,_that.phone,_that.name,_that.parentPhone,_that.referralCode,_that.track,_that.dateOfBirth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String registrationToken,  DateTime tokenExpiresAt,  String phone,  String? name,  String? parentPhone,  String? referralCode,  RegTrack? track,  DateTime? dateOfBirth)  $default,) {final _that = this;
switch (_that) {
case _RegistrationDraft():
return $default(_that.registrationToken,_that.tokenExpiresAt,_that.phone,_that.name,_that.parentPhone,_that.referralCode,_that.track,_that.dateOfBirth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String registrationToken,  DateTime tokenExpiresAt,  String phone,  String? name,  String? parentPhone,  String? referralCode,  RegTrack? track,  DateTime? dateOfBirth)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationDraft() when $default != null:
return $default(_that.registrationToken,_that.tokenExpiresAt,_that.phone,_that.name,_that.parentPhone,_that.referralCode,_that.track,_that.dateOfBirth);case _:
  return null;

}
}

}

/// @nodoc


class _RegistrationDraft extends RegistrationDraft {
  const _RegistrationDraft({required this.registrationToken, required this.tokenExpiresAt, required this.phone, this.name, this.parentPhone, this.referralCode, this.track, this.dateOfBirth}): super._();
  

@override final  String registrationToken;
@override final  DateTime tokenExpiresAt;
@override final  String phone;
@override final  String? name;
@override final  String? parentPhone;
@override final  String? referralCode;
@override final  RegTrack? track;
@override final  DateTime? dateOfBirth;

/// Create a copy of RegistrationDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationDraftCopyWith<_RegistrationDraft> get copyWith => __$RegistrationDraftCopyWithImpl<_RegistrationDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationDraft&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.tokenExpiresAt, tokenExpiresAt) || other.tokenExpiresAt == tokenExpiresAt)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentPhone, parentPhone) || other.parentPhone == parentPhone)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.track, track) || other.track == track)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}


@override
int get hashCode => Object.hash(runtimeType,registrationToken,tokenExpiresAt,phone,name,parentPhone,referralCode,track,dateOfBirth);

@override
String toString() {
  return 'RegistrationDraft(registrationToken: $registrationToken, tokenExpiresAt: $tokenExpiresAt, phone: $phone, name: $name, parentPhone: $parentPhone, referralCode: $referralCode, track: $track, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class _$RegistrationDraftCopyWith<$Res> implements $RegistrationDraftCopyWith<$Res> {
  factory _$RegistrationDraftCopyWith(_RegistrationDraft value, $Res Function(_RegistrationDraft) _then) = __$RegistrationDraftCopyWithImpl;
@override @useResult
$Res call({
 String registrationToken, DateTime tokenExpiresAt, String phone, String? name, String? parentPhone, String? referralCode, RegTrack? track, DateTime? dateOfBirth
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
@override @pragma('vm:prefer-inline') $Res call({Object? registrationToken = null,Object? tokenExpiresAt = null,Object? phone = null,Object? name = freezed,Object? parentPhone = freezed,Object? referralCode = freezed,Object? track = freezed,Object? dateOfBirth = freezed,}) {
  return _then(_RegistrationDraft(
registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,tokenExpiresAt: null == tokenExpiresAt ? _self.tokenExpiresAt : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentPhone: freezed == parentPhone ? _self.parentPhone : parentPhone // ignore: cast_nullable_to_non_nullable
as String?,referralCode: freezed == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as RegTrack?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
