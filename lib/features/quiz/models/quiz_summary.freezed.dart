// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizSummary {

 String get quizId;/// Correct answers. The numerator of the percentage ring.
 int get score; int get totalQuestions;/// Questions the student actually answered. Distinct from
/// [totalQuestions] because *"unanswered questions are recorded unanswered
/// (not counted wrong)"* — which is the whole reason [wrong] and [skipped]
/// below are two different numbers.
 int get answeredCount;/// Points awarded for THIS quiz. Rendered verbatim; never computed,
/// predicted or previewed. See docs/seif_fight.md S12.
 int get pointsAwarded;/// True when THIS quiz crossed a level boundary.
///
/// A frozen EVENT (adr-102): set at the moment it happened and never
/// changed by a later quiz. Do not recompute it by comparing two `GET /me`
/// reads — that approximation is wrong whenever another quiz awarded
/// points while this one was open.
///
/// **Parsed, not celebrated.** The contract goes to the trouble of telling
/// us, but the result frame has no level-up state to render — flagged in
/// docs/DESIGN_ISSUES.md rather than invented here.
 bool get leveledUp;/// True when THIS quiz earned a badge (every 5,000 total_points past
/// Level 12). Frozen on the same rule as [leveledUp].
///
/// Identical treatment: required by the contract, so it is parsed; no
/// badge celebration exists in the result frame, so nothing is rendered.
/// Owner decision — no celebration UI this ticket.
 bool get newBadge;/// Per-question recap rows. The contract points at
/// `GET /quizzes/{id}` for the full review, which is `draft` — so these
/// rows are the only post-quiz per-question data available today.
///
/// Parsed because the contract requires them; not rendered, because the
/// result frame's only per-question affordance is "Review Questions", and
/// that is disabled (docs/seif_fight.md S14).
 List<QuizSummaryQuestion> get questions;
/// Create a copy of QuizSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSummaryCopyWith<QuizSummary> get copyWith => _$QuizSummaryCopyWithImpl<QuizSummary>(this as QuizSummary, _$identity);

  /// Serializes this QuizSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSummary&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.answeredCount, answeredCount) || other.answeredCount == answeredCount)&&(identical(other.pointsAwarded, pointsAwarded) || other.pointsAwarded == pointsAwarded)&&(identical(other.leveledUp, leveledUp) || other.leveledUp == leveledUp)&&(identical(other.newBadge, newBadge) || other.newBadge == newBadge)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,score,totalQuestions,answeredCount,pointsAwarded,leveledUp,newBadge,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'QuizSummary(quizId: $quizId, score: $score, totalQuestions: $totalQuestions, answeredCount: $answeredCount, pointsAwarded: $pointsAwarded, leveledUp: $leveledUp, newBadge: $newBadge, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $QuizSummaryCopyWith<$Res>  {
  factory $QuizSummaryCopyWith(QuizSummary value, $Res Function(QuizSummary) _then) = _$QuizSummaryCopyWithImpl;
@useResult
$Res call({
 String quizId, int score, int totalQuestions, int answeredCount, int pointsAwarded, bool leveledUp, bool newBadge, List<QuizSummaryQuestion> questions
});




}
/// @nodoc
class _$QuizSummaryCopyWithImpl<$Res>
    implements $QuizSummaryCopyWith<$Res> {
  _$QuizSummaryCopyWithImpl(this._self, this._then);

  final QuizSummary _self;
  final $Res Function(QuizSummary) _then;

/// Create a copy of QuizSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? score = null,Object? totalQuestions = null,Object? answeredCount = null,Object? pointsAwarded = null,Object? leveledUp = null,Object? newBadge = null,Object? questions = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,pointsAwarded: null == pointsAwarded ? _self.pointsAwarded : pointsAwarded // ignore: cast_nullable_to_non_nullable
as int,leveledUp: null == leveledUp ? _self.leveledUp : leveledUp // ignore: cast_nullable_to_non_nullable
as bool,newBadge: null == newBadge ? _self.newBadge : newBadge // ignore: cast_nullable_to_non_nullable
as bool,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizSummaryQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizSummary].
extension QuizSummaryPatterns on QuizSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizSummary value)  $default,){
final _that = this;
switch (_that) {
case _QuizSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizSummary value)?  $default,){
final _that = this;
switch (_that) {
case _QuizSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String quizId,  int score,  int totalQuestions,  int answeredCount,  int pointsAwarded,  bool leveledUp,  bool newBadge,  List<QuizSummaryQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizSummary() when $default != null:
return $default(_that.quizId,_that.score,_that.totalQuestions,_that.answeredCount,_that.pointsAwarded,_that.leveledUp,_that.newBadge,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String quizId,  int score,  int totalQuestions,  int answeredCount,  int pointsAwarded,  bool leveledUp,  bool newBadge,  List<QuizSummaryQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _QuizSummary():
return $default(_that.quizId,_that.score,_that.totalQuestions,_that.answeredCount,_that.pointsAwarded,_that.leveledUp,_that.newBadge,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String quizId,  int score,  int totalQuestions,  int answeredCount,  int pointsAwarded,  bool leveledUp,  bool newBadge,  List<QuizSummaryQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _QuizSummary() when $default != null:
return $default(_that.quizId,_that.score,_that.totalQuestions,_that.answeredCount,_that.pointsAwarded,_that.leveledUp,_that.newBadge,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizSummary extends QuizSummary {
  const _QuizSummary({required this.quizId, required this.score, required this.totalQuestions, required this.answeredCount, required this.pointsAwarded, required this.leveledUp, required this.newBadge, required final  List<QuizSummaryQuestion> questions}): _questions = questions,super._();
  factory _QuizSummary.fromJson(Map<String, dynamic> json) => _$QuizSummaryFromJson(json);

@override final  String quizId;
/// Correct answers. The numerator of the percentage ring.
@override final  int score;
@override final  int totalQuestions;
/// Questions the student actually answered. Distinct from
/// [totalQuestions] because *"unanswered questions are recorded unanswered
/// (not counted wrong)"* — which is the whole reason [wrong] and [skipped]
/// below are two different numbers.
@override final  int answeredCount;
/// Points awarded for THIS quiz. Rendered verbatim; never computed,
/// predicted or previewed. See docs/seif_fight.md S12.
@override final  int pointsAwarded;
/// True when THIS quiz crossed a level boundary.
///
/// A frozen EVENT (adr-102): set at the moment it happened and never
/// changed by a later quiz. Do not recompute it by comparing two `GET /me`
/// reads — that approximation is wrong whenever another quiz awarded
/// points while this one was open.
///
/// **Parsed, not celebrated.** The contract goes to the trouble of telling
/// us, but the result frame has no level-up state to render — flagged in
/// docs/DESIGN_ISSUES.md rather than invented here.
@override final  bool leveledUp;
/// True when THIS quiz earned a badge (every 5,000 total_points past
/// Level 12). Frozen on the same rule as [leveledUp].
///
/// Identical treatment: required by the contract, so it is parsed; no
/// badge celebration exists in the result frame, so nothing is rendered.
/// Owner decision — no celebration UI this ticket.
@override final  bool newBadge;
/// Per-question recap rows. The contract points at
/// `GET /quizzes/{id}` for the full review, which is `draft` — so these
/// rows are the only post-quiz per-question data available today.
///
/// Parsed because the contract requires them; not rendered, because the
/// result frame's only per-question affordance is "Review Questions", and
/// that is disabled (docs/seif_fight.md S14).
 final  List<QuizSummaryQuestion> _questions;
/// Per-question recap rows. The contract points at
/// `GET /quizzes/{id}` for the full review, which is `draft` — so these
/// rows are the only post-quiz per-question data available today.
///
/// Parsed because the contract requires them; not rendered, because the
/// result frame's only per-question affordance is "Review Questions", and
/// that is disabled (docs/seif_fight.md S14).
@override List<QuizSummaryQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of QuizSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSummaryCopyWith<_QuizSummary> get copyWith => __$QuizSummaryCopyWithImpl<_QuizSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSummary&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.answeredCount, answeredCount) || other.answeredCount == answeredCount)&&(identical(other.pointsAwarded, pointsAwarded) || other.pointsAwarded == pointsAwarded)&&(identical(other.leveledUp, leveledUp) || other.leveledUp == leveledUp)&&(identical(other.newBadge, newBadge) || other.newBadge == newBadge)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,score,totalQuestions,answeredCount,pointsAwarded,leveledUp,newBadge,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'QuizSummary(quizId: $quizId, score: $score, totalQuestions: $totalQuestions, answeredCount: $answeredCount, pointsAwarded: $pointsAwarded, leveledUp: $leveledUp, newBadge: $newBadge, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuizSummaryCopyWith<$Res> implements $QuizSummaryCopyWith<$Res> {
  factory _$QuizSummaryCopyWith(_QuizSummary value, $Res Function(_QuizSummary) _then) = __$QuizSummaryCopyWithImpl;
@override @useResult
$Res call({
 String quizId, int score, int totalQuestions, int answeredCount, int pointsAwarded, bool leveledUp, bool newBadge, List<QuizSummaryQuestion> questions
});




}
/// @nodoc
class __$QuizSummaryCopyWithImpl<$Res>
    implements _$QuizSummaryCopyWith<$Res> {
  __$QuizSummaryCopyWithImpl(this._self, this._then);

  final _QuizSummary _self;
  final $Res Function(_QuizSummary) _then;

/// Create a copy of QuizSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? score = null,Object? totalQuestions = null,Object? answeredCount = null,Object? pointsAwarded = null,Object? leveledUp = null,Object? newBadge = null,Object? questions = null,}) {
  return _then(_QuizSummary(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,pointsAwarded: null == pointsAwarded ? _self.pointsAwarded : pointsAwarded // ignore: cast_nullable_to_non_nullable
as int,leveledUp: null == leveledUp ? _self.leveledUp : leveledUp // ignore: cast_nullable_to_non_nullable
as bool,newBadge: null == newBadge ? _self.newBadge : newBadge // ignore: cast_nullable_to_non_nullable
as bool,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizSummaryQuestion>,
  ));
}


}


/// @nodoc
mixin _$QuizSummaryQuestion {

 String get questionId; bool get answered;/// Contract-nullable: *"null when unanswered."* The three-way
/// correct/wrong/unanswered distinction lives in this one field.
 bool? get correct;
/// Create a copy of QuizSummaryQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSummaryQuestionCopyWith<QuizSummaryQuestion> get copyWith => _$QuizSummaryQuestionCopyWithImpl<QuizSummaryQuestion>(this as QuizSummaryQuestion, _$identity);

  /// Serializes this QuizSummaryQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSummaryQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,answered,correct);

@override
String toString() {
  return 'QuizSummaryQuestion(questionId: $questionId, answered: $answered, correct: $correct)';
}


}

/// @nodoc
abstract mixin class $QuizSummaryQuestionCopyWith<$Res>  {
  factory $QuizSummaryQuestionCopyWith(QuizSummaryQuestion value, $Res Function(QuizSummaryQuestion) _then) = _$QuizSummaryQuestionCopyWithImpl;
@useResult
$Res call({
 String questionId, bool answered, bool? correct
});




}
/// @nodoc
class _$QuizSummaryQuestionCopyWithImpl<$Res>
    implements $QuizSummaryQuestionCopyWith<$Res> {
  _$QuizSummaryQuestionCopyWithImpl(this._self, this._then);

  final QuizSummaryQuestion _self;
  final $Res Function(QuizSummaryQuestion) _then;

/// Create a copy of QuizSummaryQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? answered = null,Object? correct = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as bool,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizSummaryQuestion].
extension QuizSummaryQuestionPatterns on QuizSummaryQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizSummaryQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizSummaryQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizSummaryQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizSummaryQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizSummaryQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizSummaryQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  bool answered,  bool? correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizSummaryQuestion() when $default != null:
return $default(_that.questionId,_that.answered,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  bool answered,  bool? correct)  $default,) {final _that = this;
switch (_that) {
case _QuizSummaryQuestion():
return $default(_that.questionId,_that.answered,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  bool answered,  bool? correct)?  $default,) {final _that = this;
switch (_that) {
case _QuizSummaryQuestion() when $default != null:
return $default(_that.questionId,_that.answered,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizSummaryQuestion implements QuizSummaryQuestion {
  const _QuizSummaryQuestion({required this.questionId, required this.answered, this.correct});
  factory _QuizSummaryQuestion.fromJson(Map<String, dynamic> json) => _$QuizSummaryQuestionFromJson(json);

@override final  String questionId;
@override final  bool answered;
/// Contract-nullable: *"null when unanswered."* The three-way
/// correct/wrong/unanswered distinction lives in this one field.
@override final  bool? correct;

/// Create a copy of QuizSummaryQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSummaryQuestionCopyWith<_QuizSummaryQuestion> get copyWith => __$QuizSummaryQuestionCopyWithImpl<_QuizSummaryQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizSummaryQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSummaryQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,answered,correct);

@override
String toString() {
  return 'QuizSummaryQuestion(questionId: $questionId, answered: $answered, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$QuizSummaryQuestionCopyWith<$Res> implements $QuizSummaryQuestionCopyWith<$Res> {
  factory _$QuizSummaryQuestionCopyWith(_QuizSummaryQuestion value, $Res Function(_QuizSummaryQuestion) _then) = __$QuizSummaryQuestionCopyWithImpl;
@override @useResult
$Res call({
 String questionId, bool answered, bool? correct
});




}
/// @nodoc
class __$QuizSummaryQuestionCopyWithImpl<$Res>
    implements _$QuizSummaryQuestionCopyWith<$Res> {
  __$QuizSummaryQuestionCopyWithImpl(this._self, this._then);

  final _QuizSummaryQuestion _self;
  final $Res Function(_QuizSummaryQuestion) _then;

/// Create a copy of QuizSummaryQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? answered = null,Object? correct = freezed,}) {
  return _then(_QuizSummaryQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as bool,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
