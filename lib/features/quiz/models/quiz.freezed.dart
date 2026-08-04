// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Quiz {

 String get id; QuizMode get mode;/// University only — the contract types it `[string, "null"]` and school
/// quizzes carry no type at all.
 QuizType? get quizType;/// The contract's own word for it: "Lesson/lecture display name". Server
/// copy, already in the content language (adr-018), so it is rendered
/// verbatim and never looked up in the ARB.
///
/// **This is the only scope identity the quiz endpoints return.** Neither
/// `Quiz` nor `QuizSummary` carries a subject name, which is why the setup
/// and result screens are titled by scope alone — see docs/DESIGN_ISSUES.md.
 String get scopeName;/// In serving order. May legitimately be SHORTER than the requested length:
/// the contract only promises `not_enough_questions` when the pool is
/// smaller than `length` in normal mode, and the later modes may return
/// fewer by design. Nothing may assume `questions.length == length`.
 List<QuizQuestion> get questions; DateTime get createdAt;
/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizCopyWith<Quiz> get copyWith => _$QuizCopyWithImpl<Quiz>(this as Quiz, _$identity);

  /// Serializes this Quiz to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quiz&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.quizType, quizType) || other.quizType == quizType)&&(identical(other.scopeName, scopeName) || other.scopeName == scopeName)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mode,quizType,scopeName,const DeepCollectionEquality().hash(questions),createdAt);

@override
String toString() {
  return 'Quiz(id: $id, mode: $mode, quizType: $quizType, scopeName: $scopeName, questions: $questions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $QuizCopyWith<$Res>  {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) _then) = _$QuizCopyWithImpl;
@useResult
$Res call({
 String id, QuizMode mode, QuizType? quizType, String scopeName, List<QuizQuestion> questions, DateTime createdAt
});




}
/// @nodoc
class _$QuizCopyWithImpl<$Res>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._self, this._then);

  final Quiz _self;
  final $Res Function(Quiz) _then;

/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mode = null,Object? quizType = freezed,Object? scopeName = null,Object? questions = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as QuizMode,quizType: freezed == quizType ? _self.quizType : quizType // ignore: cast_nullable_to_non_nullable
as QuizType?,scopeName: null == scopeName ? _self.scopeName : scopeName // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Quiz].
extension QuizPatterns on Quiz {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quiz value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quiz() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quiz value)  $default,){
final _that = this;
switch (_that) {
case _Quiz():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quiz value)?  $default,){
final _that = this;
switch (_that) {
case _Quiz() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  QuizMode mode,  QuizType? quizType,  String scopeName,  List<QuizQuestion> questions,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quiz() when $default != null:
return $default(_that.id,_that.mode,_that.quizType,_that.scopeName,_that.questions,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  QuizMode mode,  QuizType? quizType,  String scopeName,  List<QuizQuestion> questions,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Quiz():
return $default(_that.id,_that.mode,_that.quizType,_that.scopeName,_that.questions,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  QuizMode mode,  QuizType? quizType,  String scopeName,  List<QuizQuestion> questions,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Quiz() when $default != null:
return $default(_that.id,_that.mode,_that.quizType,_that.scopeName,_that.questions,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quiz extends Quiz {
  const _Quiz({required this.id, required this.mode, this.quizType, required this.scopeName, required final  List<QuizQuestion> questions, required this.createdAt}): _questions = questions,super._();
  factory _Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

@override final  String id;
@override final  QuizMode mode;
/// University only — the contract types it `[string, "null"]` and school
/// quizzes carry no type at all.
@override final  QuizType? quizType;
/// The contract's own word for it: "Lesson/lecture display name". Server
/// copy, already in the content language (adr-018), so it is rendered
/// verbatim and never looked up in the ARB.
///
/// **This is the only scope identity the quiz endpoints return.** Neither
/// `Quiz` nor `QuizSummary` carries a subject name, which is why the setup
/// and result screens are titled by scope alone — see docs/DESIGN_ISSUES.md.
@override final  String scopeName;
/// In serving order. May legitimately be SHORTER than the requested length:
/// the contract only promises `not_enough_questions` when the pool is
/// smaller than `length` in normal mode, and the later modes may return
/// fewer by design. Nothing may assume `questions.length == length`.
 final  List<QuizQuestion> _questions;
/// In serving order. May legitimately be SHORTER than the requested length:
/// the contract only promises `not_enough_questions` when the pool is
/// smaller than `length` in normal mode, and the later modes may return
/// fewer by design. Nothing may assume `questions.length == length`.
@override List<QuizQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override final  DateTime createdAt;

/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizCopyWith<_Quiz> get copyWith => __$QuizCopyWithImpl<_Quiz>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quiz&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.quizType, quizType) || other.quizType == quizType)&&(identical(other.scopeName, scopeName) || other.scopeName == scopeName)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mode,quizType,scopeName,const DeepCollectionEquality().hash(_questions),createdAt);

@override
String toString() {
  return 'Quiz(id: $id, mode: $mode, quizType: $quizType, scopeName: $scopeName, questions: $questions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuizCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$QuizCopyWith(_Quiz value, $Res Function(_Quiz) _then) = __$QuizCopyWithImpl;
@override @useResult
$Res call({
 String id, QuizMode mode, QuizType? quizType, String scopeName, List<QuizQuestion> questions, DateTime createdAt
});




}
/// @nodoc
class __$QuizCopyWithImpl<$Res>
    implements _$QuizCopyWith<$Res> {
  __$QuizCopyWithImpl(this._self, this._then);

  final _Quiz _self;
  final $Res Function(_Quiz) _then;

/// Create a copy of Quiz
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mode = null,Object? quizType = freezed,Object? scopeName = null,Object? questions = null,Object? createdAt = null,}) {
  return _then(_Quiz(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as QuizMode,quizType: freezed == quizType ? _self.quizType : quizType // ignore: cast_nullable_to_non_nullable
as QuizType?,scopeName: null == scopeName ? _self.scopeName : scopeName // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
