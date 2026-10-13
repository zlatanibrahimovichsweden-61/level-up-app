// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_summary_solved.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizSummarySolved {

/// The number of DISTINCT questions the caller has answered correctly at
/// least once, in any quiz, finished or not. Lifetime and cross-track: it
/// survives a Track transfer and never shrinks, even when a question is
/// later deleted from the catalogue. Contract `minimum: 0`; `0` for a
/// student who has solved nothing yet.
 int get solvedQuestions;
/// Create a copy of QuizSummarySolved
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSummarySolvedCopyWith<QuizSummarySolved> get copyWith => _$QuizSummarySolvedCopyWithImpl<QuizSummarySolved>(this as QuizSummarySolved, _$identity);

  /// Serializes this QuizSummarySolved to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSummarySolved&&(identical(other.solvedQuestions, solvedQuestions) || other.solvedQuestions == solvedQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,solvedQuestions);

@override
String toString() {
  return 'QuizSummarySolved(solvedQuestions: $solvedQuestions)';
}


}

/// @nodoc
abstract mixin class $QuizSummarySolvedCopyWith<$Res>  {
  factory $QuizSummarySolvedCopyWith(QuizSummarySolved value, $Res Function(QuizSummarySolved) _then) = _$QuizSummarySolvedCopyWithImpl;
@useResult
$Res call({
 int solvedQuestions
});




}
/// @nodoc
class _$QuizSummarySolvedCopyWithImpl<$Res>
    implements $QuizSummarySolvedCopyWith<$Res> {
  _$QuizSummarySolvedCopyWithImpl(this._self, this._then);

  final QuizSummarySolved _self;
  final $Res Function(QuizSummarySolved) _then;

/// Create a copy of QuizSummarySolved
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? solvedQuestions = null,}) {
  return _then(_self.copyWith(
solvedQuestions: null == solvedQuestions ? _self.solvedQuestions : solvedQuestions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizSummarySolved].
extension QuizSummarySolvedPatterns on QuizSummarySolved {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizSummarySolved value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizSummarySolved() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizSummarySolved value)  $default,){
final _that = this;
switch (_that) {
case _QuizSummarySolved():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizSummarySolved value)?  $default,){
final _that = this;
switch (_that) {
case _QuizSummarySolved() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int solvedQuestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizSummarySolved() when $default != null:
return $default(_that.solvedQuestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int solvedQuestions)  $default,) {final _that = this;
switch (_that) {
case _QuizSummarySolved():
return $default(_that.solvedQuestions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int solvedQuestions)?  $default,) {final _that = this;
switch (_that) {
case _QuizSummarySolved() when $default != null:
return $default(_that.solvedQuestions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizSummarySolved implements QuizSummarySolved {
  const _QuizSummarySolved({required this.solvedQuestions});
  factory _QuizSummarySolved.fromJson(Map<String, dynamic> json) => _$QuizSummarySolvedFromJson(json);

/// The number of DISTINCT questions the caller has answered correctly at
/// least once, in any quiz, finished or not. Lifetime and cross-track: it
/// survives a Track transfer and never shrinks, even when a question is
/// later deleted from the catalogue. Contract `minimum: 0`; `0` for a
/// student who has solved nothing yet.
@override final  int solvedQuestions;

/// Create a copy of QuizSummarySolved
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSummarySolvedCopyWith<_QuizSummarySolved> get copyWith => __$QuizSummarySolvedCopyWithImpl<_QuizSummarySolved>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizSummarySolvedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSummarySolved&&(identical(other.solvedQuestions, solvedQuestions) || other.solvedQuestions == solvedQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,solvedQuestions);

@override
String toString() {
  return 'QuizSummarySolved(solvedQuestions: $solvedQuestions)';
}


}

/// @nodoc
abstract mixin class _$QuizSummarySolvedCopyWith<$Res> implements $QuizSummarySolvedCopyWith<$Res> {
  factory _$QuizSummarySolvedCopyWith(_QuizSummarySolved value, $Res Function(_QuizSummarySolved) _then) = __$QuizSummarySolvedCopyWithImpl;
@override @useResult
$Res call({
 int solvedQuestions
});




}
/// @nodoc
class __$QuizSummarySolvedCopyWithImpl<$Res>
    implements _$QuizSummarySolvedCopyWith<$Res> {
  __$QuizSummarySolvedCopyWithImpl(this._self, this._then);

  final _QuizSummarySolved _self;
  final $Res Function(_QuizSummarySolved) _then;

/// Create a copy of QuizSummarySolved
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? solvedQuestions = null,}) {
  return _then(_QuizSummarySolved(
solvedQuestions: null == solvedQuestions ? _self.solvedQuestions : solvedQuestions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
