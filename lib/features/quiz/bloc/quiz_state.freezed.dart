// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizSession {

 Quiz get quiz; int get index;/// questionId → the server's grade. Presence here means the question is
/// COMMITTED and can never be re-answered.
 Map<String, AnswerResult> get grades;/// questionId → the option the student committed to. Kept alongside
/// [grades] because `AnswerResult` reports the CORRECT option, not the
/// chosen one, and the graded view has to mark both.
 Map<String, String> get chosen;/// questionId → panel state. Per question, so going back does not re-poll.
 Map<String, ExplanationState> get explanations;
/// Create a copy of QuizSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSessionCopyWith<QuizSession> get copyWith => _$QuizSessionCopyWithImpl<QuizSession>(this as QuizSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSession&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.grades, grades)&&const DeepCollectionEquality().equals(other.chosen, chosen)&&const DeepCollectionEquality().equals(other.explanations, explanations));
}


@override
int get hashCode => Object.hash(runtimeType,quiz,index,const DeepCollectionEquality().hash(grades),const DeepCollectionEquality().hash(chosen),const DeepCollectionEquality().hash(explanations));

@override
String toString() {
  return 'QuizSession(quiz: $quiz, index: $index, grades: $grades, chosen: $chosen, explanations: $explanations)';
}


}

/// @nodoc
abstract mixin class $QuizSessionCopyWith<$Res>  {
  factory $QuizSessionCopyWith(QuizSession value, $Res Function(QuizSession) _then) = _$QuizSessionCopyWithImpl;
@useResult
$Res call({
 Quiz quiz, int index, Map<String, AnswerResult> grades, Map<String, String> chosen, Map<String, ExplanationState> explanations
});


$QuizCopyWith<$Res> get quiz;

}
/// @nodoc
class _$QuizSessionCopyWithImpl<$Res>
    implements $QuizSessionCopyWith<$Res> {
  _$QuizSessionCopyWithImpl(this._self, this._then);

  final QuizSession _self;
  final $Res Function(QuizSession) _then;

/// Create a copy of QuizSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quiz = null,Object? index = null,Object? grades = null,Object? chosen = null,Object? explanations = null,}) {
  return _then(_self.copyWith(
quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,grades: null == grades ? _self.grades : grades // ignore: cast_nullable_to_non_nullable
as Map<String, AnswerResult>,chosen: null == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as Map<String, String>,explanations: null == explanations ? _self.explanations : explanations // ignore: cast_nullable_to_non_nullable
as Map<String, ExplanationState>,
  ));
}
/// Create a copy of QuizSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizSession].
extension QuizSessionPatterns on QuizSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizSession value)  $default,){
final _that = this;
switch (_that) {
case _QuizSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizSession value)?  $default,){
final _that = this;
switch (_that) {
case _QuizSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Quiz quiz,  int index,  Map<String, AnswerResult> grades,  Map<String, String> chosen,  Map<String, ExplanationState> explanations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizSession() when $default != null:
return $default(_that.quiz,_that.index,_that.grades,_that.chosen,_that.explanations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Quiz quiz,  int index,  Map<String, AnswerResult> grades,  Map<String, String> chosen,  Map<String, ExplanationState> explanations)  $default,) {final _that = this;
switch (_that) {
case _QuizSession():
return $default(_that.quiz,_that.index,_that.grades,_that.chosen,_that.explanations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Quiz quiz,  int index,  Map<String, AnswerResult> grades,  Map<String, String> chosen,  Map<String, ExplanationState> explanations)?  $default,) {final _that = this;
switch (_that) {
case _QuizSession() when $default != null:
return $default(_that.quiz,_that.index,_that.grades,_that.chosen,_that.explanations);case _:
  return null;

}
}

}

/// @nodoc


class _QuizSession extends QuizSession {
  const _QuizSession({required this.quiz, required this.index, required final  Map<String, AnswerResult> grades, required final  Map<String, String> chosen, required final  Map<String, ExplanationState> explanations}): _grades = grades,_chosen = chosen,_explanations = explanations,super._();
  

@override final  Quiz quiz;
@override final  int index;
/// questionId → the server's grade. Presence here means the question is
/// COMMITTED and can never be re-answered.
 final  Map<String, AnswerResult> _grades;
/// questionId → the server's grade. Presence here means the question is
/// COMMITTED and can never be re-answered.
@override Map<String, AnswerResult> get grades {
  if (_grades is EqualUnmodifiableMapView) return _grades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_grades);
}

/// questionId → the option the student committed to. Kept alongside
/// [grades] because `AnswerResult` reports the CORRECT option, not the
/// chosen one, and the graded view has to mark both.
 final  Map<String, String> _chosen;
/// questionId → the option the student committed to. Kept alongside
/// [grades] because `AnswerResult` reports the CORRECT option, not the
/// chosen one, and the graded view has to mark both.
@override Map<String, String> get chosen {
  if (_chosen is EqualUnmodifiableMapView) return _chosen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_chosen);
}

/// questionId → panel state. Per question, so going back does not re-poll.
 final  Map<String, ExplanationState> _explanations;
/// questionId → panel state. Per question, so going back does not re-poll.
@override Map<String, ExplanationState> get explanations {
  if (_explanations is EqualUnmodifiableMapView) return _explanations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_explanations);
}


/// Create a copy of QuizSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSessionCopyWith<_QuizSession> get copyWith => __$QuizSessionCopyWithImpl<_QuizSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSession&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other._grades, _grades)&&const DeepCollectionEquality().equals(other._chosen, _chosen)&&const DeepCollectionEquality().equals(other._explanations, _explanations));
}


@override
int get hashCode => Object.hash(runtimeType,quiz,index,const DeepCollectionEquality().hash(_grades),const DeepCollectionEquality().hash(_chosen),const DeepCollectionEquality().hash(_explanations));

@override
String toString() {
  return 'QuizSession(quiz: $quiz, index: $index, grades: $grades, chosen: $chosen, explanations: $explanations)';
}


}

/// @nodoc
abstract mixin class _$QuizSessionCopyWith<$Res> implements $QuizSessionCopyWith<$Res> {
  factory _$QuizSessionCopyWith(_QuizSession value, $Res Function(_QuizSession) _then) = __$QuizSessionCopyWithImpl;
@override @useResult
$Res call({
 Quiz quiz, int index, Map<String, AnswerResult> grades, Map<String, String> chosen, Map<String, ExplanationState> explanations
});


@override $QuizCopyWith<$Res> get quiz;

}
/// @nodoc
class __$QuizSessionCopyWithImpl<$Res>
    implements _$QuizSessionCopyWith<$Res> {
  __$QuizSessionCopyWithImpl(this._self, this._then);

  final _QuizSession _self;
  final $Res Function(_QuizSession) _then;

/// Create a copy of QuizSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quiz = null,Object? index = null,Object? grades = null,Object? chosen = null,Object? explanations = null,}) {
  return _then(_QuizSession(
quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,grades: null == grades ? _self._grades : grades // ignore: cast_nullable_to_non_nullable
as Map<String, AnswerResult>,chosen: null == chosen ? _self._chosen : chosen // ignore: cast_nullable_to_non_nullable
as Map<String, String>,explanations: null == explanations ? _self._explanations : explanations // ignore: cast_nullable_to_non_nullable
as Map<String, ExplanationState>,
  ));
}

/// Create a copy of QuizSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}
}

// dart format on
