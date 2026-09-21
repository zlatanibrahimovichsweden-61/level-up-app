// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlashcardCard {

 String get id;/// The prompt side.
 String get front;/// The answer side. **Free multi-line text, and it may hold several
/// answers** — the contract says to render it as a block, not as a single
/// label.
 String get back;/// Absolute, content-addressed CDN URL for the card's image — or `null`.
///
/// Contract-`required` but nullable, and **`null` is the answer in every
/// environment today**: no card-image CDN origin is provisioned anywhere.
/// It is not an error and not a missing image. When a value does appear it
/// is immutable — a corrected image produces a DIFFERENT URL, never new
/// bytes at the same one — so it is safe to cache forever.
 String? get imageUrl;/// YOUR latest grade for this card, or `null` if you have never graded it.
///
/// A property of the READER, not of the card: two students holding the same
/// page see different values, which is why it can never be cached across
/// accounts.
 FlashcardSelfGrade? get selfGrade;
/// Create a copy of FlashcardCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardCardCopyWith<FlashcardCard> get copyWith => _$FlashcardCardCopyWithImpl<FlashcardCard>(this as FlashcardCard, _$identity);

  /// Serializes this FlashcardCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardCard&&(identical(other.id, id) || other.id == id)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.selfGrade, selfGrade) || other.selfGrade == selfGrade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,front,back,imageUrl,selfGrade);

@override
String toString() {
  return 'FlashcardCard(id: $id, front: $front, back: $back, imageUrl: $imageUrl, selfGrade: $selfGrade)';
}


}

/// @nodoc
abstract mixin class $FlashcardCardCopyWith<$Res>  {
  factory $FlashcardCardCopyWith(FlashcardCard value, $Res Function(FlashcardCard) _then) = _$FlashcardCardCopyWithImpl;
@useResult
$Res call({
 String id, String front, String back, String? imageUrl, FlashcardSelfGrade? selfGrade
});




}
/// @nodoc
class _$FlashcardCardCopyWithImpl<$Res>
    implements $FlashcardCardCopyWith<$Res> {
  _$FlashcardCardCopyWithImpl(this._self, this._then);

  final FlashcardCard _self;
  final $Res Function(FlashcardCard) _then;

/// Create a copy of FlashcardCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? front = null,Object? back = null,Object? imageUrl = freezed,Object? selfGrade = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,selfGrade: freezed == selfGrade ? _self.selfGrade : selfGrade // ignore: cast_nullable_to_non_nullable
as FlashcardSelfGrade?,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashcardCard].
extension FlashcardCardPatterns on FlashcardCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardCard value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardCard value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String front,  String back,  String? imageUrl,  FlashcardSelfGrade? selfGrade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashcardCard() when $default != null:
return $default(_that.id,_that.front,_that.back,_that.imageUrl,_that.selfGrade);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String front,  String back,  String? imageUrl,  FlashcardSelfGrade? selfGrade)  $default,) {final _that = this;
switch (_that) {
case _FlashcardCard():
return $default(_that.id,_that.front,_that.back,_that.imageUrl,_that.selfGrade);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String front,  String back,  String? imageUrl,  FlashcardSelfGrade? selfGrade)?  $default,) {final _that = this;
switch (_that) {
case _FlashcardCard() when $default != null:
return $default(_that.id,_that.front,_that.back,_that.imageUrl,_that.selfGrade);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlashcardCard implements FlashcardCard {
  const _FlashcardCard({required this.id, required this.front, required this.back, required this.imageUrl, required this.selfGrade});
  factory _FlashcardCard.fromJson(Map<String, dynamic> json) => _$FlashcardCardFromJson(json);

@override final  String id;
/// The prompt side.
@override final  String front;
/// The answer side. **Free multi-line text, and it may hold several
/// answers** — the contract says to render it as a block, not as a single
/// label.
@override final  String back;
/// Absolute, content-addressed CDN URL for the card's image — or `null`.
///
/// Contract-`required` but nullable, and **`null` is the answer in every
/// environment today**: no card-image CDN origin is provisioned anywhere.
/// It is not an error and not a missing image. When a value does appear it
/// is immutable — a corrected image produces a DIFFERENT URL, never new
/// bytes at the same one — so it is safe to cache forever.
@override final  String? imageUrl;
/// YOUR latest grade for this card, or `null` if you have never graded it.
///
/// A property of the READER, not of the card: two students holding the same
/// page see different values, which is why it can never be cached across
/// accounts.
@override final  FlashcardSelfGrade? selfGrade;

/// Create a copy of FlashcardCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardCardCopyWith<_FlashcardCard> get copyWith => __$FlashcardCardCopyWithImpl<_FlashcardCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashcardCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardCard&&(identical(other.id, id) || other.id == id)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.selfGrade, selfGrade) || other.selfGrade == selfGrade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,front,back,imageUrl,selfGrade);

@override
String toString() {
  return 'FlashcardCard(id: $id, front: $front, back: $back, imageUrl: $imageUrl, selfGrade: $selfGrade)';
}


}

/// @nodoc
abstract mixin class _$FlashcardCardCopyWith<$Res> implements $FlashcardCardCopyWith<$Res> {
  factory _$FlashcardCardCopyWith(_FlashcardCard value, $Res Function(_FlashcardCard) _then) = __$FlashcardCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String front, String back, String? imageUrl, FlashcardSelfGrade? selfGrade
});




}
/// @nodoc
class __$FlashcardCardCopyWithImpl<$Res>
    implements _$FlashcardCardCopyWith<$Res> {
  __$FlashcardCardCopyWithImpl(this._self, this._then);

  final _FlashcardCard _self;
  final $Res Function(_FlashcardCard) _then;

/// Create a copy of FlashcardCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? front = null,Object? back = null,Object? imageUrl = freezed,Object? selfGrade = freezed,}) {
  return _then(_FlashcardCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,selfGrade: freezed == selfGrade ? _self.selfGrade : selfGrade // ignore: cast_nullable_to_non_nullable
as FlashcardSelfGrade?,
  ));
}


}

// dart format on
