// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizHistoryItem {

 String get id;/// The CURRENT subject name for a normal-mode quiz. **An empty string** -
/// not null, not absent - for `retakeWrong` and `favorites` quizzes (they
/// span subjects) and when the subject can no longer be resolved. Server
/// copy in the content language (adr-018): render it verbatim, never look
/// it up in the ARB. Use [hasSubject] rather than comparing to `''`.
 String get subjectName;/// The quiz's scope label as the server sends it (a lesson or lecture name
/// for a normal quiz). Also server copy, rendered verbatim.
 String get scopeName;/// A closed contract enum (`normal`, `retakeWrong`, `favorites`), so it
/// reuses [QuizMode] and an unknown value throws rather than being coerced:
/// the contract does not mark it extensible.
 QuizMode get mode;/// Correct answers, frozen at finish.
 int get score;/// The question count frozen at finish. A question whose content was later
/// removed is NOT subtracted: `GET /quizzes/{id}` may return fewer
/// questions than this and the two numbers are both right.
 int get totalQuestions;/// When the quiz was finished, as the server sent it (normally UTC). Call
/// `.toLocal()` before formatting it for display.
 DateTime get finishedAt;
/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizHistoryItemCopyWith<QuizHistoryItem> get copyWith => _$QuizHistoryItemCopyWithImpl<QuizHistoryItem>(this as QuizHistoryItem, _$identity);

  /// Serializes this QuizHistoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.scopeName, scopeName) || other.scopeName == scopeName)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectName,scopeName,mode,score,totalQuestions,finishedAt);

@override
String toString() {
  return 'QuizHistoryItem(id: $id, subjectName: $subjectName, scopeName: $scopeName, mode: $mode, score: $score, totalQuestions: $totalQuestions, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $QuizHistoryItemCopyWith<$Res>  {
  factory $QuizHistoryItemCopyWith(QuizHistoryItem value, $Res Function(QuizHistoryItem) _then) = _$QuizHistoryItemCopyWithImpl;
@useResult
$Res call({
 String id, String subjectName, String scopeName, QuizMode mode, int score, int totalQuestions, DateTime finishedAt
});




}
/// @nodoc
class _$QuizHistoryItemCopyWithImpl<$Res>
    implements $QuizHistoryItemCopyWith<$Res> {
  _$QuizHistoryItemCopyWithImpl(this._self, this._then);

  final QuizHistoryItem _self;
  final $Res Function(QuizHistoryItem) _then;

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subjectName = null,Object? scopeName = null,Object? mode = null,Object? score = null,Object? totalQuestions = null,Object? finishedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,scopeName: null == scopeName ? _self.scopeName : scopeName // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as QuizMode,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizHistoryItem].
extension QuizHistoryItemPatterns on QuizHistoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _QuizHistoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String subjectName,  String scopeName,  QuizMode mode,  int score,  int totalQuestions,  DateTime finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
return $default(_that.id,_that.subjectName,_that.scopeName,_that.mode,_that.score,_that.totalQuestions,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String subjectName,  String scopeName,  QuizMode mode,  int score,  int totalQuestions,  DateTime finishedAt)  $default,) {final _that = this;
switch (_that) {
case _QuizHistoryItem():
return $default(_that.id,_that.subjectName,_that.scopeName,_that.mode,_that.score,_that.totalQuestions,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String subjectName,  String scopeName,  QuizMode mode,  int score,  int totalQuestions,  DateTime finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
return $default(_that.id,_that.subjectName,_that.scopeName,_that.mode,_that.score,_that.totalQuestions,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizHistoryItem extends QuizHistoryItem {
  const _QuizHistoryItem({required this.id, required this.subjectName, required this.scopeName, required this.mode, required this.score, required this.totalQuestions, required this.finishedAt}): super._();
  factory _QuizHistoryItem.fromJson(Map<String, dynamic> json) => _$QuizHistoryItemFromJson(json);

@override final  String id;
/// The CURRENT subject name for a normal-mode quiz. **An empty string** -
/// not null, not absent - for `retakeWrong` and `favorites` quizzes (they
/// span subjects) and when the subject can no longer be resolved. Server
/// copy in the content language (adr-018): render it verbatim, never look
/// it up in the ARB. Use [hasSubject] rather than comparing to `''`.
@override final  String subjectName;
/// The quiz's scope label as the server sends it (a lesson or lecture name
/// for a normal quiz). Also server copy, rendered verbatim.
@override final  String scopeName;
/// A closed contract enum (`normal`, `retakeWrong`, `favorites`), so it
/// reuses [QuizMode] and an unknown value throws rather than being coerced:
/// the contract does not mark it extensible.
@override final  QuizMode mode;
/// Correct answers, frozen at finish.
@override final  int score;
/// The question count frozen at finish. A question whose content was later
/// removed is NOT subtracted: `GET /quizzes/{id}` may return fewer
/// questions than this and the two numbers are both right.
@override final  int totalQuestions;
/// When the quiz was finished, as the server sent it (normally UTC). Call
/// `.toLocal()` before formatting it for display.
@override final  DateTime finishedAt;

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizHistoryItemCopyWith<_QuizHistoryItem> get copyWith => __$QuizHistoryItemCopyWithImpl<_QuizHistoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizHistoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.scopeName, scopeName) || other.scopeName == scopeName)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectName,scopeName,mode,score,totalQuestions,finishedAt);

@override
String toString() {
  return 'QuizHistoryItem(id: $id, subjectName: $subjectName, scopeName: $scopeName, mode: $mode, score: $score, totalQuestions: $totalQuestions, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$QuizHistoryItemCopyWith<$Res> implements $QuizHistoryItemCopyWith<$Res> {
  factory _$QuizHistoryItemCopyWith(_QuizHistoryItem value, $Res Function(_QuizHistoryItem) _then) = __$QuizHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String subjectName, String scopeName, QuizMode mode, int score, int totalQuestions, DateTime finishedAt
});




}
/// @nodoc
class __$QuizHistoryItemCopyWithImpl<$Res>
    implements _$QuizHistoryItemCopyWith<$Res> {
  __$QuizHistoryItemCopyWithImpl(this._self, this._then);

  final _QuizHistoryItem _self;
  final $Res Function(_QuizHistoryItem) _then;

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subjectName = null,Object? scopeName = null,Object? mode = null,Object? score = null,Object? totalQuestions = null,Object? finishedAt = null,}) {
  return _then(_QuizHistoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,scopeName: null == scopeName ? _self.scopeName : scopeName // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as QuizMode,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
