// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entitlement_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntitlementState {

@JsonKey(unknownEnumValue: EntitlementType.unknown) EntitlementType get type; bool get active; DateTime? get expiresAt;/// 2-day grace window after expiry (requirements §5).
 bool get inGrace; DateTime? get graceEndsAt;
/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementStateCopyWith<EntitlementState> get copyWith => _$EntitlementStateCopyWithImpl<EntitlementState>(this as EntitlementState, _$identity);

  /// Serializes this EntitlementState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementState&&(identical(other.type, type) || other.type == type)&&(identical(other.active, active) || other.active == active)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.inGrace, inGrace) || other.inGrace == inGrace)&&(identical(other.graceEndsAt, graceEndsAt) || other.graceEndsAt == graceEndsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,active,expiresAt,inGrace,graceEndsAt);

@override
String toString() {
  return 'EntitlementState(type: $type, active: $active, expiresAt: $expiresAt, inGrace: $inGrace, graceEndsAt: $graceEndsAt)';
}


}

/// @nodoc
abstract mixin class $EntitlementStateCopyWith<$Res>  {
  factory $EntitlementStateCopyWith(EntitlementState value, $Res Function(EntitlementState) _then) = _$EntitlementStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: EntitlementType.unknown) EntitlementType type, bool active, DateTime? expiresAt, bool inGrace, DateTime? graceEndsAt
});




}
/// @nodoc
class _$EntitlementStateCopyWithImpl<$Res>
    implements $EntitlementStateCopyWith<$Res> {
  _$EntitlementStateCopyWithImpl(this._self, this._then);

  final EntitlementState _self;
  final $Res Function(EntitlementState) _then;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? active = null,Object? expiresAt = freezed,Object? inGrace = null,Object? graceEndsAt = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntitlementType,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inGrace: null == inGrace ? _self.inGrace : inGrace // ignore: cast_nullable_to_non_nullable
as bool,graceEndsAt: freezed == graceEndsAt ? _self.graceEndsAt : graceEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementState].
extension EntitlementStatePatterns on EntitlementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementState value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementState value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: EntitlementType.unknown)  EntitlementType type,  bool active,  DateTime? expiresAt,  bool inGrace,  DateTime? graceEndsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that.type,_that.active,_that.expiresAt,_that.inGrace,_that.graceEndsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: EntitlementType.unknown)  EntitlementType type,  bool active,  DateTime? expiresAt,  bool inGrace,  DateTime? graceEndsAt)  $default,) {final _that = this;
switch (_that) {
case _EntitlementState():
return $default(_that.type,_that.active,_that.expiresAt,_that.inGrace,_that.graceEndsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: EntitlementType.unknown)  EntitlementType type,  bool active,  DateTime? expiresAt,  bool inGrace,  DateTime? graceEndsAt)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that.type,_that.active,_that.expiresAt,_that.inGrace,_that.graceEndsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementState implements EntitlementState {
  const _EntitlementState({@JsonKey(unknownEnumValue: EntitlementType.unknown) required this.type, required this.active, this.expiresAt, required this.inGrace, this.graceEndsAt});
  factory _EntitlementState.fromJson(Map<String, dynamic> json) => _$EntitlementStateFromJson(json);

@override@JsonKey(unknownEnumValue: EntitlementType.unknown) final  EntitlementType type;
@override final  bool active;
@override final  DateTime? expiresAt;
/// 2-day grace window after expiry (requirements §5).
@override final  bool inGrace;
@override final  DateTime? graceEndsAt;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementStateCopyWith<_EntitlementState> get copyWith => __$EntitlementStateCopyWithImpl<_EntitlementState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementState&&(identical(other.type, type) || other.type == type)&&(identical(other.active, active) || other.active == active)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.inGrace, inGrace) || other.inGrace == inGrace)&&(identical(other.graceEndsAt, graceEndsAt) || other.graceEndsAt == graceEndsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,active,expiresAt,inGrace,graceEndsAt);

@override
String toString() {
  return 'EntitlementState(type: $type, active: $active, expiresAt: $expiresAt, inGrace: $inGrace, graceEndsAt: $graceEndsAt)';
}


}

/// @nodoc
abstract mixin class _$EntitlementStateCopyWith<$Res> implements $EntitlementStateCopyWith<$Res> {
  factory _$EntitlementStateCopyWith(_EntitlementState value, $Res Function(_EntitlementState) _then) = __$EntitlementStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: EntitlementType.unknown) EntitlementType type, bool active, DateTime? expiresAt, bool inGrace, DateTime? graceEndsAt
});




}
/// @nodoc
class __$EntitlementStateCopyWithImpl<$Res>
    implements _$EntitlementStateCopyWith<$Res> {
  __$EntitlementStateCopyWithImpl(this._self, this._then);

  final _EntitlementState _self;
  final $Res Function(_EntitlementState) _then;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? active = null,Object? expiresAt = freezed,Object? inGrace = null,Object? graceEndsAt = freezed,}) {
  return _then(_EntitlementState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntitlementType,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inGrace: null == inGrace ? _self.inGrace : inGrace // ignore: cast_nullable_to_non_nullable
as bool,graceEndsAt: freezed == graceEndsAt ? _self.graceEndsAt : graceEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$EntitlementsResponse {

 List<EntitlementState> get items;
/// Create a copy of EntitlementsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementsResponseCopyWith<EntitlementsResponse> get copyWith => _$EntitlementsResponseCopyWithImpl<EntitlementsResponse>(this as EntitlementsResponse, _$identity);

  /// Serializes this EntitlementsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementsResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'EntitlementsResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class $EntitlementsResponseCopyWith<$Res>  {
  factory $EntitlementsResponseCopyWith(EntitlementsResponse value, $Res Function(EntitlementsResponse) _then) = _$EntitlementsResponseCopyWithImpl;
@useResult
$Res call({
 List<EntitlementState> items
});




}
/// @nodoc
class _$EntitlementsResponseCopyWithImpl<$Res>
    implements $EntitlementsResponseCopyWith<$Res> {
  _$EntitlementsResponseCopyWithImpl(this._self, this._then);

  final EntitlementsResponse _self;
  final $Res Function(EntitlementsResponse) _then;

/// Create a copy of EntitlementsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EntitlementState>,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementsResponse].
extension EntitlementsResponsePatterns on EntitlementsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementsResponse value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EntitlementState> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementsResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EntitlementState> items)  $default,) {final _that = this;
switch (_that) {
case _EntitlementsResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EntitlementState> items)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementsResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementsResponse implements EntitlementsResponse {
  const _EntitlementsResponse({required final  List<EntitlementState> items}): _items = items;
  factory _EntitlementsResponse.fromJson(Map<String, dynamic> json) => _$EntitlementsResponseFromJson(json);

 final  List<EntitlementState> _items;
@override List<EntitlementState> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of EntitlementsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementsResponseCopyWith<_EntitlementsResponse> get copyWith => __$EntitlementsResponseCopyWithImpl<_EntitlementsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementsResponse&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'EntitlementsResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$EntitlementsResponseCopyWith<$Res> implements $EntitlementsResponseCopyWith<$Res> {
  factory _$EntitlementsResponseCopyWith(_EntitlementsResponse value, $Res Function(_EntitlementsResponse) _then) = __$EntitlementsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<EntitlementState> items
});




}
/// @nodoc
class __$EntitlementsResponseCopyWithImpl<$Res>
    implements _$EntitlementsResponseCopyWith<$Res> {
  __$EntitlementsResponseCopyWithImpl(this._self, this._then);

  final _EntitlementsResponse _self;
  final $Res Function(_EntitlementsResponse) _then;

/// Create a copy of EntitlementsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_EntitlementsResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EntitlementState>,
  ));
}


}

// dart format on
