// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteQuestion {

/// `Uuid`. The only value the app sends back: `PUT`/`DELETE
/// /questions/{questionId}/favorite`.
 String get questionId;/// The question stem. The contract does not repeat `QuizQuestion.text`'s
/// "only `<u>...</u>` markup" note for this field, so do not assume the
/// absence of markup: render it through whatever renders a question stem.
 String get text;/// Server copy in the content language (adr-018), rendered verbatim.
 String get subjectName;/// When the student favourited it, as the server sent it (normally UTC).
/// Call `.toLocal()` before formatting it for display.
 DateTime get favoritedAt;
/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteQuestionCopyWith<FavoriteQuestion> get copyWith => _$FavoriteQuestionCopyWithImpl<FavoriteQuestion>(this as FavoriteQuestion, _$identity);

  /// Serializes this FavoriteQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.text, text) || other.text == text)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.favoritedAt, favoritedAt) || other.favoritedAt == favoritedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,text,subjectName,favoritedAt);

@override
String toString() {
  return 'FavoriteQuestion(questionId: $questionId, text: $text, subjectName: $subjectName, favoritedAt: $favoritedAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteQuestionCopyWith<$Res>  {
  factory $FavoriteQuestionCopyWith(FavoriteQuestion value, $Res Function(FavoriteQuestion) _then) = _$FavoriteQuestionCopyWithImpl;
@useResult
$Res call({
 String questionId, String text, String subjectName, DateTime favoritedAt
});




}
/// @nodoc
class _$FavoriteQuestionCopyWithImpl<$Res>
    implements $FavoriteQuestionCopyWith<$Res> {
  _$FavoriteQuestionCopyWithImpl(this._self, this._then);

  final FavoriteQuestion _self;
  final $Res Function(FavoriteQuestion) _then;

/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? text = null,Object? subjectName = null,Object? favoritedAt = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,favoritedAt: null == favoritedAt ? _self.favoritedAt : favoritedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteQuestion].
extension FavoriteQuestionPatterns on FavoriteQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteQuestion value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  String text,  String subjectName,  DateTime favoritedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
return $default(_that.questionId,_that.text,_that.subjectName,_that.favoritedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  String text,  String subjectName,  DateTime favoritedAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteQuestion():
return $default(_that.questionId,_that.text,_that.subjectName,_that.favoritedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  String text,  String subjectName,  DateTime favoritedAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
return $default(_that.questionId,_that.text,_that.subjectName,_that.favoritedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteQuestion implements FavoriteQuestion {
  const _FavoriteQuestion({required this.questionId, required this.text, required this.subjectName, required this.favoritedAt});
  factory _FavoriteQuestion.fromJson(Map<String, dynamic> json) => _$FavoriteQuestionFromJson(json);

/// `Uuid`. The only value the app sends back: `PUT`/`DELETE
/// /questions/{questionId}/favorite`.
@override final  String questionId;
/// The question stem. The contract does not repeat `QuizQuestion.text`'s
/// "only `<u>...</u>` markup" note for this field, so do not assume the
/// absence of markup: render it through whatever renders a question stem.
@override final  String text;
/// Server copy in the content language (adr-018), rendered verbatim.
@override final  String subjectName;
/// When the student favourited it, as the server sent it (normally UTC).
/// Call `.toLocal()` before formatting it for display.
@override final  DateTime favoritedAt;

/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteQuestionCopyWith<_FavoriteQuestion> get copyWith => __$FavoriteQuestionCopyWithImpl<_FavoriteQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.text, text) || other.text == text)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.favoritedAt, favoritedAt) || other.favoritedAt == favoritedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,text,subjectName,favoritedAt);

@override
String toString() {
  return 'FavoriteQuestion(questionId: $questionId, text: $text, subjectName: $subjectName, favoritedAt: $favoritedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteQuestionCopyWith<$Res> implements $FavoriteQuestionCopyWith<$Res> {
  factory _$FavoriteQuestionCopyWith(_FavoriteQuestion value, $Res Function(_FavoriteQuestion) _then) = __$FavoriteQuestionCopyWithImpl;
@override @useResult
$Res call({
 String questionId, String text, String subjectName, DateTime favoritedAt
});




}
/// @nodoc
class __$FavoriteQuestionCopyWithImpl<$Res>
    implements _$FavoriteQuestionCopyWith<$Res> {
  __$FavoriteQuestionCopyWithImpl(this._self, this._then);

  final _FavoriteQuestion _self;
  final $Res Function(_FavoriteQuestion) _then;

/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? text = null,Object? subjectName = null,Object? favoritedAt = null,}) {
  return _then(_FavoriteQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,favoritedAt: null == favoritedAt ? _self.favoritedAt : favoritedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
