// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyInvite {

/// The invite code, exactly as the server sent it. One per student, created
/// on the first call, never changes and cannot be regenerated (R9).
 String get code;/// New accounts that registered with [code]. Stays counted if that student
/// later deletes their account.
 int get friendsJoined;/// Points the code has earned the caller. The server's figure, not
/// `10 x friendsJoined`.
 int get pointsEarned;
/// Create a copy of MyInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyInviteCopyWith<MyInvite> get copyWith => _$MyInviteCopyWithImpl<MyInvite>(this as MyInvite, _$identity);

  /// Serializes this MyInvite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyInvite&&(identical(other.code, code) || other.code == code)&&(identical(other.friendsJoined, friendsJoined) || other.friendsJoined == friendsJoined)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,friendsJoined,pointsEarned);



}

/// @nodoc
abstract mixin class $MyInviteCopyWith<$Res>  {
  factory $MyInviteCopyWith(MyInvite value, $Res Function(MyInvite) _then) = _$MyInviteCopyWithImpl;
@useResult
$Res call({
 String code, int friendsJoined, int pointsEarned
});




}
/// @nodoc
class _$MyInviteCopyWithImpl<$Res>
    implements $MyInviteCopyWith<$Res> {
  _$MyInviteCopyWithImpl(this._self, this._then);

  final MyInvite _self;
  final $Res Function(MyInvite) _then;

/// Create a copy of MyInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? friendsJoined = null,Object? pointsEarned = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,friendsJoined: null == friendsJoined ? _self.friendsJoined : friendsJoined // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyInvite].
extension MyInvitePatterns on MyInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyInvite value)  $default,){
final _that = this;
switch (_that) {
case _MyInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyInvite value)?  $default,){
final _that = this;
switch (_that) {
case _MyInvite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int friendsJoined,  int pointsEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyInvite() when $default != null:
return $default(_that.code,_that.friendsJoined,_that.pointsEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int friendsJoined,  int pointsEarned)  $default,) {final _that = this;
switch (_that) {
case _MyInvite():
return $default(_that.code,_that.friendsJoined,_that.pointsEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int friendsJoined,  int pointsEarned)?  $default,) {final _that = this;
switch (_that) {
case _MyInvite() when $default != null:
return $default(_that.code,_that.friendsJoined,_that.pointsEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyInvite extends MyInvite {
  const _MyInvite({required this.code, required this.friendsJoined, required this.pointsEarned}): super._();
  factory _MyInvite.fromJson(Map<String, dynamic> json) => _$MyInviteFromJson(json);

/// The invite code, exactly as the server sent it. One per student, created
/// on the first call, never changes and cannot be regenerated (R9).
@override final  String code;
/// New accounts that registered with [code]. Stays counted if that student
/// later deletes their account.
@override final  int friendsJoined;
/// Points the code has earned the caller. The server's figure, not
/// `10 x friendsJoined`.
@override final  int pointsEarned;

/// Create a copy of MyInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyInviteCopyWith<_MyInvite> get copyWith => __$MyInviteCopyWithImpl<_MyInvite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyInviteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyInvite&&(identical(other.code, code) || other.code == code)&&(identical(other.friendsJoined, friendsJoined) || other.friendsJoined == friendsJoined)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,friendsJoined,pointsEarned);



}

/// @nodoc
abstract mixin class _$MyInviteCopyWith<$Res> implements $MyInviteCopyWith<$Res> {
  factory _$MyInviteCopyWith(_MyInvite value, $Res Function(_MyInvite) _then) = __$MyInviteCopyWithImpl;
@override @useResult
$Res call({
 String code, int friendsJoined, int pointsEarned
});




}
/// @nodoc
class __$MyInviteCopyWithImpl<$Res>
    implements _$MyInviteCopyWith<$Res> {
  __$MyInviteCopyWithImpl(this._self, this._then);

  final _MyInvite _self;
  final $Res Function(_MyInvite) _then;

/// Create a copy of MyInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? friendsJoined = null,Object? pointsEarned = null,}) {
  return _then(_MyInvite(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,friendsJoined: null == friendsJoined ? _self.friendsJoined : friendsJoined // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
