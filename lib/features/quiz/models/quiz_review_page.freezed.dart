// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_review_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizReview {

 String get id;/// The CURRENT subject name for a normal-mode quiz; **null** for
/// `retakeWrong` and `favorites` quizzes (they span subjects) and when the
/// subject can no longer be resolved. Required but nullable: the key is
/// always there and its value is often null. Note the contrast with
/// `QuizHistoryItem.subjectName`, which spells the same situation `''`.
 String? get subjectName; String get scopeName;/// Correct answers, frozen at finish.
 int get score; int get totalQuestions;/// When the quiz was finished (normally UTC). Call `.toLocal()` before
/// formatting it for display.
 DateTime get finishedAt; List<QuizReviewQuestion> get questions;
/// Create a copy of QuizReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizReviewCopyWith<QuizReview> get copyWith => _$QuizReviewCopyWithImpl<QuizReview>(this as QuizReview, _$identity);

  /// Serializes this QuizReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizReview&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.scopeName, scopeName) || other.scopeName == scopeName)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectName,scopeName,score,totalQuestions,finishedAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'QuizReview(id: $id, subjectName: $subjectName, scopeName: $scopeName, score: $score, totalQuestions: $totalQuestions, finishedAt: $finishedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $QuizReviewCopyWith<$Res>  {
  factory $QuizReviewCopyWith(QuizReview value, $Res Function(QuizReview) _then) = _$QuizReviewCopyWithImpl;
@useResult
$Res call({
 String id, String? subjectName, String scopeName, int score, int totalQuestions, DateTime finishedAt, List<QuizReviewQuestion> questions
});




}
/// @nodoc
class _$QuizReviewCopyWithImpl<$Res>
    implements $QuizReviewCopyWith<$Res> {
  _$QuizReviewCopyWithImpl(this._self, this._then);

  final QuizReview _self;
  final $Res Function(QuizReview) _then;

/// Create a copy of QuizReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subjectName = freezed,Object? scopeName = null,Object? score = null,Object? totalQuestions = null,Object? finishedAt = null,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectName: freezed == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String?,scopeName: null == scopeName ? _self.scopeName : scopeName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizReviewQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizReview].
extension QuizReviewPatterns on QuizReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizReview value)  $default,){
final _that = this;
switch (_that) {
case _QuizReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizReview value)?  $default,){
final _that = this;
switch (_that) {
case _QuizReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? subjectName,  String scopeName,  int score,  int totalQuestions,  DateTime finishedAt,  List<QuizReviewQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizReview() when $default != null:
return $default(_that.id,_that.subjectName,_that.scopeName,_that.score,_that.totalQuestions,_that.finishedAt,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? subjectName,  String scopeName,  int score,  int totalQuestions,  DateTime finishedAt,  List<QuizReviewQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _QuizReview():
return $default(_that.id,_that.subjectName,_that.scopeName,_that.score,_that.totalQuestions,_that.finishedAt,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? subjectName,  String scopeName,  int score,  int totalQuestions,  DateTime finishedAt,  List<QuizReviewQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _QuizReview() when $default != null:
return $default(_that.id,_that.subjectName,_that.scopeName,_that.score,_that.totalQuestions,_that.finishedAt,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizReview implements QuizReview {
  const _QuizReview({required this.id, required this.subjectName, required this.scopeName, required this.score, required this.totalQuestions, required this.finishedAt, required final  List<QuizReviewQuestion> questions}): _questions = questions;
  factory _QuizReview.fromJson(Map<String, dynamic> json) => _$QuizReviewFromJson(json);

@override final  String id;
/// The CURRENT subject name for a normal-mode quiz; **null** for
/// `retakeWrong` and `favorites` quizzes (they span subjects) and when the
/// subject can no longer be resolved. Required but nullable: the key is
/// always there and its value is often null. Note the contrast with
/// `QuizHistoryItem.subjectName`, which spells the same situation `''`.
@override final  String? subjectName;
@override final  String scopeName;
/// Correct answers, frozen at finish.
@override final  int score;
@override final  int totalQuestions;
/// When the quiz was finished (normally UTC). Call `.toLocal()` before
/// formatting it for display.
@override final  DateTime finishedAt;
 final  List<QuizReviewQuestion> _questions;
@override List<QuizReviewQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of QuizReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizReviewCopyWith<_QuizReview> get copyWith => __$QuizReviewCopyWithImpl<_QuizReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizReview&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.scopeName, scopeName) || other.scopeName == scopeName)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectName,scopeName,score,totalQuestions,finishedAt,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'QuizReview(id: $id, subjectName: $subjectName, scopeName: $scopeName, score: $score, totalQuestions: $totalQuestions, finishedAt: $finishedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuizReviewCopyWith<$Res> implements $QuizReviewCopyWith<$Res> {
  factory _$QuizReviewCopyWith(_QuizReview value, $Res Function(_QuizReview) _then) = __$QuizReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String? subjectName, String scopeName, int score, int totalQuestions, DateTime finishedAt, List<QuizReviewQuestion> questions
});




}
/// @nodoc
class __$QuizReviewCopyWithImpl<$Res>
    implements _$QuizReviewCopyWith<$Res> {
  __$QuizReviewCopyWithImpl(this._self, this._then);

  final _QuizReview _self;
  final $Res Function(_QuizReview) _then;

/// Create a copy of QuizReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subjectName = freezed,Object? scopeName = null,Object? score = null,Object? totalQuestions = null,Object? finishedAt = null,Object? questions = null,}) {
  return _then(_QuizReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectName: freezed == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String?,scopeName: null == scopeName ? _self.scopeName : scopeName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizReviewQuestion>,
  ));
}


}

/// @nodoc
mixin _$QuizReviewQuestion {

/// `id`, `order`, `text`, `imageUrl`, `thumbnailUrl`, `options` and
/// `isFavorite` - the contract's `QuizQuestion` half of the `allOf`.
 QuizQuestion get question;/// The option the student picked; null = unanswered. Optional in the
/// contract, so an absent key reads as unanswered too.
 String? get selectedOptionId;/// The current correct option. Required but nullable: present ONLY when the
/// student answered the question ([selectedOptionId] is not null), null on
/// every unanswered one. The KEY must always be on the wire - a response
/// that drops it throws instead of reading as "withheld".
///
/// It is the CURRENT correct option, whereas [correct] is the verdict from
/// submit time, so the two can legitimately disagree (the question was
/// edited after the answer): `selectedOptionId == correctOptionId` does NOT
/// imply `correct == true`, and vice versa. Never derive one from the other.
 String? get correctOptionId;/// The verdict recorded at submit time, never recomputed; null when
/// unanswered. Optional in the contract.
 bool? get correct;/// The same value `AnswerResult.explanationAvailable` carries for this
/// question and track. Always false on an unanswered question (an
/// explanation is only served for a question the caller answered).
 bool get explanationAvailable;
/// Create a copy of QuizReviewQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizReviewQuestionCopyWith<QuizReviewQuestion> get copyWith => _$QuizReviewQuestionCopyWithImpl<QuizReviewQuestion>(this as QuizReviewQuestion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizReviewQuestion&&(identical(other.question, question) || other.question == question)&&(identical(other.selectedOptionId, selectedOptionId) || other.selectedOptionId == selectedOptionId)&&(identical(other.correctOptionId, correctOptionId) || other.correctOptionId == correctOptionId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.explanationAvailable, explanationAvailable) || other.explanationAvailable == explanationAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,question,selectedOptionId,correctOptionId,correct,explanationAvailable);

@override
String toString() {
  return 'QuizReviewQuestion(question: $question, selectedOptionId: $selectedOptionId, correctOptionId: $correctOptionId, correct: $correct, explanationAvailable: $explanationAvailable)';
}


}

/// @nodoc
abstract mixin class $QuizReviewQuestionCopyWith<$Res>  {
  factory $QuizReviewQuestionCopyWith(QuizReviewQuestion value, $Res Function(QuizReviewQuestion) _then) = _$QuizReviewQuestionCopyWithImpl;
@useResult
$Res call({
 QuizQuestion question, String? selectedOptionId, String? correctOptionId, bool? correct, bool explanationAvailable
});


$QuizQuestionCopyWith<$Res> get question;

}
/// @nodoc
class _$QuizReviewQuestionCopyWithImpl<$Res>
    implements $QuizReviewQuestionCopyWith<$Res> {
  _$QuizReviewQuestionCopyWithImpl(this._self, this._then);

  final QuizReviewQuestion _self;
  final $Res Function(QuizReviewQuestion) _then;

/// Create a copy of QuizReviewQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? selectedOptionId = freezed,Object? correctOptionId = freezed,Object? correct = freezed,Object? explanationAvailable = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as QuizQuestion,selectedOptionId: freezed == selectedOptionId ? _self.selectedOptionId : selectedOptionId // ignore: cast_nullable_to_non_nullable
as String?,correctOptionId: freezed == correctOptionId ? _self.correctOptionId : correctOptionId // ignore: cast_nullable_to_non_nullable
as String?,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool?,explanationAvailable: null == explanationAvailable ? _self.explanationAvailable : explanationAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of QuizReviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<$Res> get question {
  
  return $QuizQuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizReviewQuestion].
extension QuizReviewQuestionPatterns on QuizReviewQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizReviewQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizReviewQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizReviewQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizReviewQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizReviewQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizReviewQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuizQuestion question,  String? selectedOptionId,  String? correctOptionId,  bool? correct,  bool explanationAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizReviewQuestion() when $default != null:
return $default(_that.question,_that.selectedOptionId,_that.correctOptionId,_that.correct,_that.explanationAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuizQuestion question,  String? selectedOptionId,  String? correctOptionId,  bool? correct,  bool explanationAvailable)  $default,) {final _that = this;
switch (_that) {
case _QuizReviewQuestion():
return $default(_that.question,_that.selectedOptionId,_that.correctOptionId,_that.correct,_that.explanationAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuizQuestion question,  String? selectedOptionId,  String? correctOptionId,  bool? correct,  bool explanationAvailable)?  $default,) {final _that = this;
switch (_that) {
case _QuizReviewQuestion() when $default != null:
return $default(_that.question,_that.selectedOptionId,_that.correctOptionId,_that.correct,_that.explanationAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _QuizReviewQuestion extends QuizReviewQuestion {
  const _QuizReviewQuestion({required this.question, this.selectedOptionId, required this.correctOptionId, this.correct, required this.explanationAvailable}): super._();
  

/// `id`, `order`, `text`, `imageUrl`, `thumbnailUrl`, `options` and
/// `isFavorite` - the contract's `QuizQuestion` half of the `allOf`.
@override final  QuizQuestion question;
/// The option the student picked; null = unanswered. Optional in the
/// contract, so an absent key reads as unanswered too.
@override final  String? selectedOptionId;
/// The current correct option. Required but nullable: present ONLY when the
/// student answered the question ([selectedOptionId] is not null), null on
/// every unanswered one. The KEY must always be on the wire - a response
/// that drops it throws instead of reading as "withheld".
///
/// It is the CURRENT correct option, whereas [correct] is the verdict from
/// submit time, so the two can legitimately disagree (the question was
/// edited after the answer): `selectedOptionId == correctOptionId` does NOT
/// imply `correct == true`, and vice versa. Never derive one from the other.
@override final  String? correctOptionId;
/// The verdict recorded at submit time, never recomputed; null when
/// unanswered. Optional in the contract.
@override final  bool? correct;
/// The same value `AnswerResult.explanationAvailable` carries for this
/// question and track. Always false on an unanswered question (an
/// explanation is only served for a question the caller answered).
@override final  bool explanationAvailable;

/// Create a copy of QuizReviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizReviewQuestionCopyWith<_QuizReviewQuestion> get copyWith => __$QuizReviewQuestionCopyWithImpl<_QuizReviewQuestion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizReviewQuestion&&(identical(other.question, question) || other.question == question)&&(identical(other.selectedOptionId, selectedOptionId) || other.selectedOptionId == selectedOptionId)&&(identical(other.correctOptionId, correctOptionId) || other.correctOptionId == correctOptionId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.explanationAvailable, explanationAvailable) || other.explanationAvailable == explanationAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,question,selectedOptionId,correctOptionId,correct,explanationAvailable);

@override
String toString() {
  return 'QuizReviewQuestion(question: $question, selectedOptionId: $selectedOptionId, correctOptionId: $correctOptionId, correct: $correct, explanationAvailable: $explanationAvailable)';
}


}

/// @nodoc
abstract mixin class _$QuizReviewQuestionCopyWith<$Res> implements $QuizReviewQuestionCopyWith<$Res> {
  factory _$QuizReviewQuestionCopyWith(_QuizReviewQuestion value, $Res Function(_QuizReviewQuestion) _then) = __$QuizReviewQuestionCopyWithImpl;
@override @useResult
$Res call({
 QuizQuestion question, String? selectedOptionId, String? correctOptionId, bool? correct, bool explanationAvailable
});


@override $QuizQuestionCopyWith<$Res> get question;

}
/// @nodoc
class __$QuizReviewQuestionCopyWithImpl<$Res>
    implements _$QuizReviewQuestionCopyWith<$Res> {
  __$QuizReviewQuestionCopyWithImpl(this._self, this._then);

  final _QuizReviewQuestion _self;
  final $Res Function(_QuizReviewQuestion) _then;

/// Create a copy of QuizReviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? selectedOptionId = freezed,Object? correctOptionId = freezed,Object? correct = freezed,Object? explanationAvailable = null,}) {
  return _then(_QuizReviewQuestion(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as QuizQuestion,selectedOptionId: freezed == selectedOptionId ? _self.selectedOptionId : selectedOptionId // ignore: cast_nullable_to_non_nullable
as String?,correctOptionId: freezed == correctOptionId ? _self.correctOptionId : correctOptionId // ignore: cast_nullable_to_non_nullable
as String?,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool?,explanationAvailable: null == explanationAvailable ? _self.explanationAvailable : explanationAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of QuizReviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<$Res> get question {
  
  return $QuizQuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

// dart format on
