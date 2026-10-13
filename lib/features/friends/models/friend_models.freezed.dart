// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentCard {

 String get studentId; String get name; String get avatarUrl;
/// Create a copy of StudentCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCardCopyWith<StudentCard> get copyWith => _$StudentCardCopyWithImpl<StudentCard>(this as StudentCard, _$identity);

  /// Serializes this StudentCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentCard&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,name,avatarUrl);



}

/// @nodoc
abstract mixin class $StudentCardCopyWith<$Res>  {
  factory $StudentCardCopyWith(StudentCard value, $Res Function(StudentCard) _then) = _$StudentCardCopyWithImpl;
@useResult
$Res call({
 String studentId, String name, String avatarUrl
});




}
/// @nodoc
class _$StudentCardCopyWithImpl<$Res>
    implements $StudentCardCopyWith<$Res> {
  _$StudentCardCopyWithImpl(this._self, this._then);

  final StudentCard _self;
  final $Res Function(StudentCard) _then;

/// Create a copy of StudentCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? name = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentCard].
extension StudentCardPatterns on StudentCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentCard value)  $default,){
final _that = this;
switch (_that) {
case _StudentCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentCard value)?  $default,){
final _that = this;
switch (_that) {
case _StudentCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String name,  String avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentCard() when $default != null:
return $default(_that.studentId,_that.name,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String name,  String avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _StudentCard():
return $default(_that.studentId,_that.name,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String name,  String avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _StudentCard() when $default != null:
return $default(_that.studentId,_that.name,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentCard extends StudentCard {
  const _StudentCard({required this.studentId, required this.name, required this.avatarUrl}): super._();
  factory _StudentCard.fromJson(Map<String, dynamic> json) => _$StudentCardFromJson(json);

@override final  String studentId;
@override final  String name;
@override final  String avatarUrl;

/// Create a copy of StudentCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCardCopyWith<_StudentCard> get copyWith => __$StudentCardCopyWithImpl<_StudentCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentCard&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,name,avatarUrl);



}

/// @nodoc
abstract mixin class _$StudentCardCopyWith<$Res> implements $StudentCardCopyWith<$Res> {
  factory _$StudentCardCopyWith(_StudentCard value, $Res Function(_StudentCard) _then) = __$StudentCardCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String name, String avatarUrl
});




}
/// @nodoc
class __$StudentCardCopyWithImpl<$Res>
    implements _$StudentCardCopyWith<$Res> {
  __$StudentCardCopyWithImpl(this._self, this._then);

  final _StudentCard _self;
  final $Res Function(_StudentCard) _then;

/// Create a copy of StudentCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? name = null,Object? avatarUrl = null,}) {
  return _then(_StudentCard(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Friend {

 String get studentId; String get name; String get avatarUrl; int get level; int? get points; DateTime get friendsSince;
/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendCopyWith<Friend> get copyWith => _$FriendCopyWithImpl<Friend>(this as Friend, _$identity);

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Friend&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.points, points) || other.points == points)&&(identical(other.friendsSince, friendsSince) || other.friendsSince == friendsSince));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,name,avatarUrl,level,points,friendsSince);



}

/// @nodoc
abstract mixin class $FriendCopyWith<$Res>  {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) _then) = _$FriendCopyWithImpl;
@useResult
$Res call({
 String studentId, String name, String avatarUrl, int level, int? points, DateTime friendsSince
});




}
/// @nodoc
class _$FriendCopyWithImpl<$Res>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._self, this._then);

  final Friend _self;
  final $Res Function(Friend) _then;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? name = null,Object? avatarUrl = null,Object? level = null,Object? points = freezed,Object? friendsSince = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,friendsSince: null == friendsSince ? _self.friendsSince : friendsSince // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Friend].
extension FriendPatterns on Friend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Friend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Friend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Friend value)  $default,){
final _that = this;
switch (_that) {
case _Friend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Friend value)?  $default,){
final _that = this;
switch (_that) {
case _Friend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String name,  String avatarUrl,  int level,  int? points,  DateTime friendsSince)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Friend() when $default != null:
return $default(_that.studentId,_that.name,_that.avatarUrl,_that.level,_that.points,_that.friendsSince);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String name,  String avatarUrl,  int level,  int? points,  DateTime friendsSince)  $default,) {final _that = this;
switch (_that) {
case _Friend():
return $default(_that.studentId,_that.name,_that.avatarUrl,_that.level,_that.points,_that.friendsSince);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String name,  String avatarUrl,  int level,  int? points,  DateTime friendsSince)?  $default,) {final _that = this;
switch (_that) {
case _Friend() when $default != null:
return $default(_that.studentId,_that.name,_that.avatarUrl,_that.level,_that.points,_that.friendsSince);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Friend extends Friend {
  const _Friend({required this.studentId, required this.name, required this.avatarUrl, required this.level, this.points, required this.friendsSince}): super._();
  factory _Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

@override final  String studentId;
@override final  String name;
@override final  String avatarUrl;
@override final  int level;
@override final  int? points;
@override final  DateTime friendsSince;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendCopyWith<_Friend> get copyWith => __$FriendCopyWithImpl<_Friend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Friend&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.points, points) || other.points == points)&&(identical(other.friendsSince, friendsSince) || other.friendsSince == friendsSince));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,name,avatarUrl,level,points,friendsSince);



}

/// @nodoc
abstract mixin class _$FriendCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$FriendCopyWith(_Friend value, $Res Function(_Friend) _then) = __$FriendCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String name, String avatarUrl, int level, int? points, DateTime friendsSince
});




}
/// @nodoc
class __$FriendCopyWithImpl<$Res>
    implements _$FriendCopyWith<$Res> {
  __$FriendCopyWithImpl(this._self, this._then);

  final _Friend _self;
  final $Res Function(_Friend) _then;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? name = null,Object? avatarUrl = null,Object? level = null,Object? points = freezed,Object? friendsSince = null,}) {
  return _then(_Friend(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,friendsSince: null == friendsSince ? _self.friendsSince : friendsSince // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FriendRequest {

 String get requestId; FriendRequestDirection get direction; StudentCard get student; DateTime get createdAt;
/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendRequestCopyWith<FriendRequest> get copyWith => _$FriendRequestCopyWithImpl<FriendRequest>(this as FriendRequest, _$identity);

  /// Serializes this FriendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.student, student) || other.student == student)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,direction,student,createdAt);



}

/// @nodoc
abstract mixin class $FriendRequestCopyWith<$Res>  {
  factory $FriendRequestCopyWith(FriendRequest value, $Res Function(FriendRequest) _then) = _$FriendRequestCopyWithImpl;
@useResult
$Res call({
 String requestId, FriendRequestDirection direction, StudentCard student, DateTime createdAt
});


$StudentCardCopyWith<$Res> get student;

}
/// @nodoc
class _$FriendRequestCopyWithImpl<$Res>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._self, this._then);

  final FriendRequest _self;
  final $Res Function(FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? direction = null,Object? student = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as FriendRequestDirection,student: null == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as StudentCard,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentCardCopyWith<$Res> get student {
  
  return $StudentCardCopyWith<$Res>(_self.student, (value) {
    return _then(_self.copyWith(student: value));
  });
}
}


/// Adds pattern-matching-related methods to [FriendRequest].
extension FriendRequestPatterns on FriendRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendRequest value)  $default,){
final _that = this;
switch (_that) {
case _FriendRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  FriendRequestDirection direction,  StudentCard student,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.requestId,_that.direction,_that.student,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  FriendRequestDirection direction,  StudentCard student,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FriendRequest():
return $default(_that.requestId,_that.direction,_that.student,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  FriendRequestDirection direction,  StudentCard student,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.requestId,_that.direction,_that.student,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendRequest extends FriendRequest {
  const _FriendRequest({required this.requestId, required this.direction, required this.student, required this.createdAt}): super._();
  factory _FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);

@override final  String requestId;
@override final  FriendRequestDirection direction;
@override final  StudentCard student;
@override final  DateTime createdAt;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendRequestCopyWith<_FriendRequest> get copyWith => __$FriendRequestCopyWithImpl<_FriendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.student, student) || other.student == student)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,direction,student,createdAt);



}

/// @nodoc
abstract mixin class _$FriendRequestCopyWith<$Res> implements $FriendRequestCopyWith<$Res> {
  factory _$FriendRequestCopyWith(_FriendRequest value, $Res Function(_FriendRequest) _then) = __$FriendRequestCopyWithImpl;
@override @useResult
$Res call({
 String requestId, FriendRequestDirection direction, StudentCard student, DateTime createdAt
});


@override $StudentCardCopyWith<$Res> get student;

}
/// @nodoc
class __$FriendRequestCopyWithImpl<$Res>
    implements _$FriendRequestCopyWith<$Res> {
  __$FriendRequestCopyWithImpl(this._self, this._then);

  final _FriendRequest _self;
  final $Res Function(_FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? direction = null,Object? student = null,Object? createdAt = null,}) {
  return _then(_FriendRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as FriendRequestDirection,student: null == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as StudentCard,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentCardCopyWith<$Res> get student {
  
  return $StudentCardCopyWith<$Res>(_self.student, (value) {
    return _then(_self.copyWith(student: value));
  });
}
}


/// @nodoc
mixin _$SendFriendRequestResult {

 SendFriendRequestStatus get status; FriendRequest? get request; Friend? get friend;
/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendFriendRequestResultCopyWith<SendFriendRequestResult> get copyWith => _$SendFriendRequestResultCopyWithImpl<SendFriendRequestResult>(this as SendFriendRequestResult, _$identity);

  /// Serializes this SendFriendRequestResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendFriendRequestResult&&(identical(other.status, status) || other.status == status)&&(identical(other.request, request) || other.request == request)&&(identical(other.friend, friend) || other.friend == friend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,request,friend);



}

/// @nodoc
abstract mixin class $SendFriendRequestResultCopyWith<$Res>  {
  factory $SendFriendRequestResultCopyWith(SendFriendRequestResult value, $Res Function(SendFriendRequestResult) _then) = _$SendFriendRequestResultCopyWithImpl;
@useResult
$Res call({
 SendFriendRequestStatus status, FriendRequest? request, Friend? friend
});


$FriendRequestCopyWith<$Res>? get request;$FriendCopyWith<$Res>? get friend;

}
/// @nodoc
class _$SendFriendRequestResultCopyWithImpl<$Res>
    implements $SendFriendRequestResultCopyWith<$Res> {
  _$SendFriendRequestResultCopyWithImpl(this._self, this._then);

  final SendFriendRequestResult _self;
  final $Res Function(SendFriendRequestResult) _then;

/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? request = freezed,Object? friend = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SendFriendRequestStatus,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as FriendRequest?,friend: freezed == friend ? _self.friend : friend // ignore: cast_nullable_to_non_nullable
as Friend?,
  ));
}
/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $FriendRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendCopyWith<$Res>? get friend {
    if (_self.friend == null) {
    return null;
  }

  return $FriendCopyWith<$Res>(_self.friend!, (value) {
    return _then(_self.copyWith(friend: value));
  });
}
}


/// Adds pattern-matching-related methods to [SendFriendRequestResult].
extension SendFriendRequestResultPatterns on SendFriendRequestResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendFriendRequestResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendFriendRequestResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendFriendRequestResult value)  $default,){
final _that = this;
switch (_that) {
case _SendFriendRequestResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendFriendRequestResult value)?  $default,){
final _that = this;
switch (_that) {
case _SendFriendRequestResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SendFriendRequestStatus status,  FriendRequest? request,  Friend? friend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendFriendRequestResult() when $default != null:
return $default(_that.status,_that.request,_that.friend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SendFriendRequestStatus status,  FriendRequest? request,  Friend? friend)  $default,) {final _that = this;
switch (_that) {
case _SendFriendRequestResult():
return $default(_that.status,_that.request,_that.friend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SendFriendRequestStatus status,  FriendRequest? request,  Friend? friend)?  $default,) {final _that = this;
switch (_that) {
case _SendFriendRequestResult() when $default != null:
return $default(_that.status,_that.request,_that.friend);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendFriendRequestResult extends SendFriendRequestResult {
  const _SendFriendRequestResult({required this.status, this.request, this.friend}): super._();
  factory _SendFriendRequestResult.fromJson(Map<String, dynamic> json) => _$SendFriendRequestResultFromJson(json);

@override final  SendFriendRequestStatus status;
@override final  FriendRequest? request;
@override final  Friend? friend;

/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendFriendRequestResultCopyWith<_SendFriendRequestResult> get copyWith => __$SendFriendRequestResultCopyWithImpl<_SendFriendRequestResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendFriendRequestResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendFriendRequestResult&&(identical(other.status, status) || other.status == status)&&(identical(other.request, request) || other.request == request)&&(identical(other.friend, friend) || other.friend == friend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,request,friend);



}

/// @nodoc
abstract mixin class _$SendFriendRequestResultCopyWith<$Res> implements $SendFriendRequestResultCopyWith<$Res> {
  factory _$SendFriendRequestResultCopyWith(_SendFriendRequestResult value, $Res Function(_SendFriendRequestResult) _then) = __$SendFriendRequestResultCopyWithImpl;
@override @useResult
$Res call({
 SendFriendRequestStatus status, FriendRequest? request, Friend? friend
});


@override $FriendRequestCopyWith<$Res>? get request;@override $FriendCopyWith<$Res>? get friend;

}
/// @nodoc
class __$SendFriendRequestResultCopyWithImpl<$Res>
    implements _$SendFriendRequestResultCopyWith<$Res> {
  __$SendFriendRequestResultCopyWithImpl(this._self, this._then);

  final _SendFriendRequestResult _self;
  final $Res Function(_SendFriendRequestResult) _then;

/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? request = freezed,Object? friend = freezed,}) {
  return _then(_SendFriendRequestResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SendFriendRequestStatus,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as FriendRequest?,friend: freezed == friend ? _self.friend : friend // ignore: cast_nullable_to_non_nullable
as Friend?,
  ));
}

/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendRequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $FriendRequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}/// Create a copy of SendFriendRequestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendCopyWith<$Res>? get friend {
    if (_self.friend == null) {
    return null;
  }

  return $FriendCopyWith<$Res>(_self.friend!, (value) {
    return _then(_self.copyWith(friend: value));
  });
}
}

// dart format on
