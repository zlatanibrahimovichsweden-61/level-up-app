// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionCounter {

/// Distinct questions this student has ever answered in scope.
 int get answered; int get total;
/// Create a copy of QuestionCounter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCounterCopyWith<QuestionCounter> get copyWith => _$QuestionCounterCopyWithImpl<QuestionCounter>(this as QuestionCounter, _$identity);

  /// Serializes this QuestionCounter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionCounter&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,answered,total);

@override
String toString() {
  return 'QuestionCounter(answered: $answered, total: $total)';
}


}

/// @nodoc
abstract mixin class $QuestionCounterCopyWith<$Res>  {
  factory $QuestionCounterCopyWith(QuestionCounter value, $Res Function(QuestionCounter) _then) = _$QuestionCounterCopyWithImpl;
@useResult
$Res call({
 int answered, int total
});




}
/// @nodoc
class _$QuestionCounterCopyWithImpl<$Res>
    implements $QuestionCounterCopyWith<$Res> {
  _$QuestionCounterCopyWithImpl(this._self, this._then);

  final QuestionCounter _self;
  final $Res Function(QuestionCounter) _then;

/// Create a copy of QuestionCounter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? answered = null,Object? total = null,}) {
  return _then(_self.copyWith(
answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionCounter].
extension QuestionCounterPatterns on QuestionCounter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionCounter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionCounter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionCounter value)  $default,){
final _that = this;
switch (_that) {
case _QuestionCounter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionCounter value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionCounter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int answered,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionCounter() when $default != null:
return $default(_that.answered,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int answered,  int total)  $default,) {final _that = this;
switch (_that) {
case _QuestionCounter():
return $default(_that.answered,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int answered,  int total)?  $default,) {final _that = this;
switch (_that) {
case _QuestionCounter() when $default != null:
return $default(_that.answered,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionCounter extends QuestionCounter {
  const _QuestionCounter({required this.answered, required this.total}): super._();
  factory _QuestionCounter.fromJson(Map<String, dynamic> json) => _$QuestionCounterFromJson(json);

/// Distinct questions this student has ever answered in scope.
@override final  int answered;
@override final  int total;

/// Create a copy of QuestionCounter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCounterCopyWith<_QuestionCounter> get copyWith => __$QuestionCounterCopyWithImpl<_QuestionCounter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionCounterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionCounter&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,answered,total);

@override
String toString() {
  return 'QuestionCounter(answered: $answered, total: $total)';
}


}

/// @nodoc
abstract mixin class _$QuestionCounterCopyWith<$Res> implements $QuestionCounterCopyWith<$Res> {
  factory _$QuestionCounterCopyWith(_QuestionCounter value, $Res Function(_QuestionCounter) _then) = __$QuestionCounterCopyWithImpl;
@override @useResult
$Res call({
 int answered, int total
});




}
/// @nodoc
class __$QuestionCounterCopyWithImpl<$Res>
    implements _$QuestionCounterCopyWith<$Res> {
  __$QuestionCounterCopyWithImpl(this._self, this._then);

  final _QuestionCounter _self;
  final $Res Function(_QuestionCounter) _then;

/// Create a copy of QuestionCounter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? answered = null,Object? total = null,}) {
  return _then(_QuestionCounter(
answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Subject {

 String get id; String get name;/// adr-036 term signals, added in contract 1.2.0-m1. **Optional AND
/// nullable, and null is NORMAL** — school subjects carry `termId: null`
/// outright, and a university subject can too when its cohort has no
/// schedule row. `termId` is opaque (adr-026 §7): never
/// hardcode one and never derive an order from it. `termNumber` is the
/// only orderable/labellable term signal on the wire — term NAMES are
/// never sent, so any label is rendered client-side (adr-026 §5).
///
/// No default, deliberately: a defaulted `termNumber` would fabricate an
/// ordinal the server never sent.
///
/// A year-long university course arrives as TWO subjects with an IDENTICAL
/// [name], one per term (adr-036 §2) — `termNumber` is what tells them
/// apart.
 String? get termId; int? get termNumber; QuestionCounter get questionCounter;
/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectCopyWith<Subject> get copyWith => _$SubjectCopyWithImpl<Subject>(this as Subject, _$identity);

  /// Serializes this Subject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber)&&(identical(other.questionCounter, questionCounter) || other.questionCounter == questionCounter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,termId,termNumber,questionCounter);

@override
String toString() {
  return 'Subject(id: $id, name: $name, termId: $termId, termNumber: $termNumber, questionCounter: $questionCounter)';
}


}

/// @nodoc
abstract mixin class $SubjectCopyWith<$Res>  {
  factory $SubjectCopyWith(Subject value, $Res Function(Subject) _then) = _$SubjectCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? termId, int? termNumber, QuestionCounter questionCounter
});


$QuestionCounterCopyWith<$Res> get questionCounter;

}
/// @nodoc
class _$SubjectCopyWithImpl<$Res>
    implements $SubjectCopyWith<$Res> {
  _$SubjectCopyWithImpl(this._self, this._then);

  final Subject _self;
  final $Res Function(Subject) _then;

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? termId = freezed,Object? termNumber = freezed,Object? questionCounter = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,questionCounter: null == questionCounter ? _self.questionCounter : questionCounter // ignore: cast_nullable_to_non_nullable
as QuestionCounter,
  ));
}
/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCounterCopyWith<$Res> get questionCounter {
  
  return $QuestionCounterCopyWith<$Res>(_self.questionCounter, (value) {
    return _then(_self.copyWith(questionCounter: value));
  });
}
}


/// Adds pattern-matching-related methods to [Subject].
extension SubjectPatterns on Subject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subject value)  $default,){
final _that = this;
switch (_that) {
case _Subject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subject value)?  $default,){
final _that = this;
switch (_that) {
case _Subject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? termId,  int? termNumber,  QuestionCounter questionCounter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subject() when $default != null:
return $default(_that.id,_that.name,_that.termId,_that.termNumber,_that.questionCounter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? termId,  int? termNumber,  QuestionCounter questionCounter)  $default,) {final _that = this;
switch (_that) {
case _Subject():
return $default(_that.id,_that.name,_that.termId,_that.termNumber,_that.questionCounter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? termId,  int? termNumber,  QuestionCounter questionCounter)?  $default,) {final _that = this;
switch (_that) {
case _Subject() when $default != null:
return $default(_that.id,_that.name,_that.termId,_that.termNumber,_that.questionCounter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Subject implements Subject {
  const _Subject({required this.id, required this.name, this.termId, this.termNumber, required this.questionCounter});
  factory _Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

@override final  String id;
@override final  String name;
/// adr-036 term signals, added in contract 1.2.0-m1. **Optional AND
/// nullable, and null is NORMAL** — school subjects carry `termId: null`
/// outright, and a university subject can too when its cohort has no
/// schedule row. `termId` is opaque (adr-026 §7): never
/// hardcode one and never derive an order from it. `termNumber` is the
/// only orderable/labellable term signal on the wire — term NAMES are
/// never sent, so any label is rendered client-side (adr-026 §5).
///
/// No default, deliberately: a defaulted `termNumber` would fabricate an
/// ordinal the server never sent.
///
/// A year-long university course arrives as TWO subjects with an IDENTICAL
/// [name], one per term (adr-036 §2) — `termNumber` is what tells them
/// apart.
@override final  String? termId;
@override final  int? termNumber;
@override final  QuestionCounter questionCounter;

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectCopyWith<_Subject> get copyWith => __$SubjectCopyWithImpl<_Subject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber)&&(identical(other.questionCounter, questionCounter) || other.questionCounter == questionCounter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,termId,termNumber,questionCounter);

@override
String toString() {
  return 'Subject(id: $id, name: $name, termId: $termId, termNumber: $termNumber, questionCounter: $questionCounter)';
}


}

/// @nodoc
abstract mixin class _$SubjectCopyWith<$Res> implements $SubjectCopyWith<$Res> {
  factory _$SubjectCopyWith(_Subject value, $Res Function(_Subject) _then) = __$SubjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? termId, int? termNumber, QuestionCounter questionCounter
});


@override $QuestionCounterCopyWith<$Res> get questionCounter;

}
/// @nodoc
class __$SubjectCopyWithImpl<$Res>
    implements _$SubjectCopyWith<$Res> {
  __$SubjectCopyWithImpl(this._self, this._then);

  final _Subject _self;
  final $Res Function(_Subject) _then;

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? termId = freezed,Object? termNumber = freezed,Object? questionCounter = null,}) {
  return _then(_Subject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,questionCounter: null == questionCounter ? _self.questionCounter : questionCounter // ignore: cast_nullable_to_non_nullable
as QuestionCounter,
  ));
}

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCounterCopyWith<$Res> get questionCounter {
  
  return $QuestionCounterCopyWith<$Res>(_self.questionCounter, (value) {
    return _then(_self.copyWith(questionCounter: value));
  });
}
}

// dart format on
