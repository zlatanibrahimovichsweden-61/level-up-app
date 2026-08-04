// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnswerResult {

 bool get correct;/// Revealed here and nowhere else. On a wrong answer the screen marks the
/// student's choice AND reveals this one.
 String get correctOptionId;/// The contract: *"0 or 1 (server-side award; 0 on retry replay or
/// free-plan edge)."*
///
/// **Server-authoritative and never accumulated client-side.** The app does
/// not sum these into a session total, does not preview a total on the
/// setup screen, and does not reconcile them against
/// `QuizSummary.pointsAwarded` — that value comes from `finish` and is the
/// only points figure ever rendered. See docs/seif_fight.md S12: the design
/// promises roughly 20x what this can award.
 int get pointsDelta;/// Gate for the AI EXPLANATION panel. When false there is nothing to fetch,
/// so the panel is not offered at all rather than offered and then failing.
 bool get explanationAvailable;
/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerResultCopyWith<AnswerResult> get copyWith => _$AnswerResultCopyWithImpl<AnswerResult>(this as AnswerResult, _$identity);

  /// Serializes this AnswerResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerResult&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.correctOptionId, correctOptionId) || other.correctOptionId == correctOptionId)&&(identical(other.pointsDelta, pointsDelta) || other.pointsDelta == pointsDelta)&&(identical(other.explanationAvailable, explanationAvailable) || other.explanationAvailable == explanationAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,correctOptionId,pointsDelta,explanationAvailable);

@override
String toString() {
  return 'AnswerResult(correct: $correct, correctOptionId: $correctOptionId, pointsDelta: $pointsDelta, explanationAvailable: $explanationAvailable)';
}


}

/// @nodoc
abstract mixin class $AnswerResultCopyWith<$Res>  {
  factory $AnswerResultCopyWith(AnswerResult value, $Res Function(AnswerResult) _then) = _$AnswerResultCopyWithImpl;
@useResult
$Res call({
 bool correct, String correctOptionId, int pointsDelta, bool explanationAvailable
});




}
/// @nodoc
class _$AnswerResultCopyWithImpl<$Res>
    implements $AnswerResultCopyWith<$Res> {
  _$AnswerResultCopyWithImpl(this._self, this._then);

  final AnswerResult _self;
  final $Res Function(AnswerResult) _then;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? correctOptionId = null,Object? pointsDelta = null,Object? explanationAvailable = null,}) {
  return _then(_self.copyWith(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,correctOptionId: null == correctOptionId ? _self.correctOptionId : correctOptionId // ignore: cast_nullable_to_non_nullable
as String,pointsDelta: null == pointsDelta ? _self.pointsDelta : pointsDelta // ignore: cast_nullable_to_non_nullable
as int,explanationAvailable: null == explanationAvailable ? _self.explanationAvailable : explanationAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnswerResult].
extension AnswerResultPatterns on AnswerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerResult value)  $default,){
final _that = this;
switch (_that) {
case _AnswerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerResult value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool correct,  String correctOptionId,  int pointsDelta,  bool explanationAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
return $default(_that.correct,_that.correctOptionId,_that.pointsDelta,_that.explanationAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool correct,  String correctOptionId,  int pointsDelta,  bool explanationAvailable)  $default,) {final _that = this;
switch (_that) {
case _AnswerResult():
return $default(_that.correct,_that.correctOptionId,_that.pointsDelta,_that.explanationAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool correct,  String correctOptionId,  int pointsDelta,  bool explanationAvailable)?  $default,) {final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
return $default(_that.correct,_that.correctOptionId,_that.pointsDelta,_that.explanationAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerResult implements AnswerResult {
  const _AnswerResult({required this.correct, required this.correctOptionId, required this.pointsDelta, required this.explanationAvailable});
  factory _AnswerResult.fromJson(Map<String, dynamic> json) => _$AnswerResultFromJson(json);

@override final  bool correct;
/// Revealed here and nowhere else. On a wrong answer the screen marks the
/// student's choice AND reveals this one.
@override final  String correctOptionId;
/// The contract: *"0 or 1 (server-side award; 0 on retry replay or
/// free-plan edge)."*
///
/// **Server-authoritative and never accumulated client-side.** The app does
/// not sum these into a session total, does not preview a total on the
/// setup screen, and does not reconcile them against
/// `QuizSummary.pointsAwarded` — that value comes from `finish` and is the
/// only points figure ever rendered. See docs/seif_fight.md S12: the design
/// promises roughly 20x what this can award.
@override final  int pointsDelta;
/// Gate for the AI EXPLANATION panel. When false there is nothing to fetch,
/// so the panel is not offered at all rather than offered and then failing.
@override final  bool explanationAvailable;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerResultCopyWith<_AnswerResult> get copyWith => __$AnswerResultCopyWithImpl<_AnswerResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerResult&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.correctOptionId, correctOptionId) || other.correctOptionId == correctOptionId)&&(identical(other.pointsDelta, pointsDelta) || other.pointsDelta == pointsDelta)&&(identical(other.explanationAvailable, explanationAvailable) || other.explanationAvailable == explanationAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,correctOptionId,pointsDelta,explanationAvailable);

@override
String toString() {
  return 'AnswerResult(correct: $correct, correctOptionId: $correctOptionId, pointsDelta: $pointsDelta, explanationAvailable: $explanationAvailable)';
}


}

/// @nodoc
abstract mixin class _$AnswerResultCopyWith<$Res> implements $AnswerResultCopyWith<$Res> {
  factory _$AnswerResultCopyWith(_AnswerResult value, $Res Function(_AnswerResult) _then) = __$AnswerResultCopyWithImpl;
@override @useResult
$Res call({
 bool correct, String correctOptionId, int pointsDelta, bool explanationAvailable
});




}
/// @nodoc
class __$AnswerResultCopyWithImpl<$Res>
    implements _$AnswerResultCopyWith<$Res> {
  __$AnswerResultCopyWithImpl(this._self, this._then);

  final _AnswerResult _self;
  final $Res Function(_AnswerResult) _then;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? correctOptionId = null,Object? pointsDelta = null,Object? explanationAvailable = null,}) {
  return _then(_AnswerResult(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,correctOptionId: null == correctOptionId ? _self.correctOptionId : correctOptionId // ignore: cast_nullable_to_non_nullable
as String,pointsDelta: null == pointsDelta ? _self.pointsDelta : pointsDelta // ignore: cast_nullable_to_non_nullable
as int,explanationAvailable: null == explanationAvailable ? _self.explanationAvailable : explanationAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
