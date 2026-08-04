// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizQuestion {

 String get id;/// Serving order, server-assigned. The app renders `questions` in the order
/// it received them — this is carried for fidelity and for the recap rows,
/// not used to re-sort. Re-sorting client-side would mean deciding the
/// server got the order wrong.
 int get order;/// Plain text; the contract allows `<u>…</u>` and nothing else.
 String get text;/// Full image, DO Spaces CDN, WebP. Null on most questions — when present,
/// the taking screen renders the "with photo" variant (`159:1852`).
 String? get imageUrl;/// Contract-optional companion to [imageUrl]. Parsed because the contract
/// defines it; the taking screen shows one question at a time at full
/// width, so there is no list context that would want the thumbnail.
 String? get thumbnailUrl;/// `minItems: 2` — NOT fixed at four. The design draws four buttons, but a
/// two- or three-option question is contract-legal, so the renderer builds
/// from this list's length rather than from a hardcoded four.
 List<QuizOption> get options;/// **Parsed, never rendered.** It is a required field, so it must be on the
/// model or nothing parses. But all three favourite endpoints
/// (`PUT`/`DELETE /questions/{questionId}/favorite`, `GET /me/favorites`)
/// are `x-stability: draft`, so there is no write path to put behind the
/// bookmark icon the header draws (node `295:3139`).
///
/// Landing the field now means the model, the JSON and the tests do not
/// move when those endpoints are promoted — that work becomes a widget plus
/// two repository methods. See docs/seif_fight.md S11.
 bool get isFavorite;
/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<QuizQuestion> get copyWith => _$QuizQuestionCopyWithImpl<QuizQuestion>(this as QuizQuestion, _$identity);

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,text,imageUrl,thumbnailUrl,const DeepCollectionEquality().hash(options),isFavorite);

@override
String toString() {
  return 'QuizQuestion(id: $id, order: $order, text: $text, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, options: $options, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $QuizQuestionCopyWith<$Res>  {
  factory $QuizQuestionCopyWith(QuizQuestion value, $Res Function(QuizQuestion) _then) = _$QuizQuestionCopyWithImpl;
@useResult
$Res call({
 String id, int order, String text, String? imageUrl, String? thumbnailUrl, List<QuizOption> options, bool isFavorite
});




}
/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._self, this._then);

  final QuizQuestion _self;
  final $Res Function(QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order = null,Object? text = null,Object? imageUrl = freezed,Object? thumbnailUrl = freezed,Object? options = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuizOption>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizQuestion].
extension QuizQuestionPatterns on QuizQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int order,  String text,  String? imageUrl,  String? thumbnailUrl,  List<QuizOption> options,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.order,_that.text,_that.imageUrl,_that.thumbnailUrl,_that.options,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int order,  String text,  String? imageUrl,  String? thumbnailUrl,  List<QuizOption> options,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion():
return $default(_that.id,_that.order,_that.text,_that.imageUrl,_that.thumbnailUrl,_that.options,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int order,  String text,  String? imageUrl,  String? thumbnailUrl,  List<QuizOption> options,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.order,_that.text,_that.imageUrl,_that.thumbnailUrl,_that.options,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizQuestion implements QuizQuestion {
  const _QuizQuestion({required this.id, required this.order, required this.text, this.imageUrl, this.thumbnailUrl, required final  List<QuizOption> options, required this.isFavorite}): _options = options;
  factory _QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

@override final  String id;
/// Serving order, server-assigned. The app renders `questions` in the order
/// it received them — this is carried for fidelity and for the recap rows,
/// not used to re-sort. Re-sorting client-side would mean deciding the
/// server got the order wrong.
@override final  int order;
/// Plain text; the contract allows `<u>…</u>` and nothing else.
@override final  String text;
/// Full image, DO Spaces CDN, WebP. Null on most questions — when present,
/// the taking screen renders the "with photo" variant (`159:1852`).
@override final  String? imageUrl;
/// Contract-optional companion to [imageUrl]. Parsed because the contract
/// defines it; the taking screen shows one question at a time at full
/// width, so there is no list context that would want the thumbnail.
@override final  String? thumbnailUrl;
/// `minItems: 2` — NOT fixed at four. The design draws four buttons, but a
/// two- or three-option question is contract-legal, so the renderer builds
/// from this list's length rather than from a hardcoded four.
 final  List<QuizOption> _options;
/// `minItems: 2` — NOT fixed at four. The design draws four buttons, but a
/// two- or three-option question is contract-legal, so the renderer builds
/// from this list's length rather than from a hardcoded four.
@override List<QuizOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

/// **Parsed, never rendered.** It is a required field, so it must be on the
/// model or nothing parses. But all three favourite endpoints
/// (`PUT`/`DELETE /questions/{questionId}/favorite`, `GET /me/favorites`)
/// are `x-stability: draft`, so there is no write path to put behind the
/// bookmark icon the header draws (node `295:3139`).
///
/// Landing the field now means the model, the JSON and the tests do not
/// move when those endpoints are promoted — that work becomes a widget plus
/// two repository methods. See docs/seif_fight.md S11.
@override final  bool isFavorite;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizQuestionCopyWith<_QuizQuestion> get copyWith => __$QuizQuestionCopyWithImpl<_QuizQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,text,imageUrl,thumbnailUrl,const DeepCollectionEquality().hash(_options),isFavorite);

@override
String toString() {
  return 'QuizQuestion(id: $id, order: $order, text: $text, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, options: $options, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$QuizQuestionCopyWith<$Res> implements $QuizQuestionCopyWith<$Res> {
  factory _$QuizQuestionCopyWith(_QuizQuestion value, $Res Function(_QuizQuestion) _then) = __$QuizQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, int order, String text, String? imageUrl, String? thumbnailUrl, List<QuizOption> options, bool isFavorite
});




}
/// @nodoc
class __$QuizQuestionCopyWithImpl<$Res>
    implements _$QuizQuestionCopyWith<$Res> {
  __$QuizQuestionCopyWithImpl(this._self, this._then);

  final _QuizQuestion _self;
  final $Res Function(_QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order = null,Object? text = null,Object? imageUrl = freezed,Object? thumbnailUrl = freezed,Object? options = null,Object? isFavorite = null,}) {
  return _then(_QuizQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuizOption>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
