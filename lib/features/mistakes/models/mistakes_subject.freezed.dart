// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mistakes_subject.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MistakesSubject {

 String get id; String get name;/// adr-036 term signals. **Optional AND nullable, and null is NORMAL** —
/// school subjects carry `termId: null` outright (`:903`).
///
/// Modelled exactly as `Subject` models them, and for the same reasons:
/// `termId` is opaque (adr-026 §7), so never hardcode one and never derive
/// an order from it; `termNumber` is the only orderable/labellable term
/// signal on the wire, since term NAMES are never sent (adr-026 §5).
///
/// ⚠️ The contract lists both under `properties` but **not** under
/// `required` (`:921`), while the `200` description implies the key is
/// always present. Optional-and-nullable is the tolerant reading and
/// decodes both shapes identically. Open as `seif_fight.md` **S42**.
 String? get termId; int? get termNumber;/// **How many questions the student CURRENTLY has wrong in this subject.**
///
/// Not how many questions the subject has. The contract publishes
/// `minimum: 1` (`:915-920`) because a subject with zero current mistakes
/// is **absent from the array entirely, never present with `0`**.
///
/// 🔴 **This decays, and it is deliberately NOT the `mode: retakeWrong`
/// pool** (adr-133, `:888-893`). It counts a question only while the
/// student's most recent graded answer to it was wrong; answering it
/// correctly later removes it immediately. The retake pool is *ever wrong*
/// and does not decay. **Do not reconcile the two numbers and do not derive
/// one from the other.**
///
/// It is also computed on every read and never cached, so two requests
/// seconds apart can legitimately disagree (`:882-886`).
 int get mistakeCount;
/// Create a copy of MistakesSubject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakesSubjectCopyWith<MistakesSubject> get copyWith => _$MistakesSubjectCopyWithImpl<MistakesSubject>(this as MistakesSubject, _$identity);

  /// Serializes this MistakesSubject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakesSubject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,termId,termNumber,mistakeCount);

@override
String toString() {
  return 'MistakesSubject(id: $id, name: $name, termId: $termId, termNumber: $termNumber, mistakeCount: $mistakeCount)';
}


}

/// @nodoc
abstract mixin class $MistakesSubjectCopyWith<$Res>  {
  factory $MistakesSubjectCopyWith(MistakesSubject value, $Res Function(MistakesSubject) _then) = _$MistakesSubjectCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? termId, int? termNumber, int mistakeCount
});




}
/// @nodoc
class _$MistakesSubjectCopyWithImpl<$Res>
    implements $MistakesSubjectCopyWith<$Res> {
  _$MistakesSubjectCopyWithImpl(this._self, this._then);

  final MistakesSubject _self;
  final $Res Function(MistakesSubject) _then;

/// Create a copy of MistakesSubject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? termId = freezed,Object? termNumber = freezed,Object? mistakeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakesSubject].
extension MistakesSubjectPatterns on MistakesSubject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakesSubject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakesSubject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakesSubject value)  $default,){
final _that = this;
switch (_that) {
case _MistakesSubject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakesSubject value)?  $default,){
final _that = this;
switch (_that) {
case _MistakesSubject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? termId,  int? termNumber,  int mistakeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakesSubject() when $default != null:
return $default(_that.id,_that.name,_that.termId,_that.termNumber,_that.mistakeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? termId,  int? termNumber,  int mistakeCount)  $default,) {final _that = this;
switch (_that) {
case _MistakesSubject():
return $default(_that.id,_that.name,_that.termId,_that.termNumber,_that.mistakeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? termId,  int? termNumber,  int mistakeCount)?  $default,) {final _that = this;
switch (_that) {
case _MistakesSubject() when $default != null:
return $default(_that.id,_that.name,_that.termId,_that.termNumber,_that.mistakeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MistakesSubject implements MistakesSubject {
  const _MistakesSubject({required this.id, required this.name, this.termId, this.termNumber, required this.mistakeCount});
  factory _MistakesSubject.fromJson(Map<String, dynamic> json) => _$MistakesSubjectFromJson(json);

@override final  String id;
@override final  String name;
/// adr-036 term signals. **Optional AND nullable, and null is NORMAL** —
/// school subjects carry `termId: null` outright (`:903`).
///
/// Modelled exactly as `Subject` models them, and for the same reasons:
/// `termId` is opaque (adr-026 §7), so never hardcode one and never derive
/// an order from it; `termNumber` is the only orderable/labellable term
/// signal on the wire, since term NAMES are never sent (adr-026 §5).
///
/// ⚠️ The contract lists both under `properties` but **not** under
/// `required` (`:921`), while the `200` description implies the key is
/// always present. Optional-and-nullable is the tolerant reading and
/// decodes both shapes identically. Open as `seif_fight.md` **S42**.
@override final  String? termId;
@override final  int? termNumber;
/// **How many questions the student CURRENTLY has wrong in this subject.**
///
/// Not how many questions the subject has. The contract publishes
/// `minimum: 1` (`:915-920`) because a subject with zero current mistakes
/// is **absent from the array entirely, never present with `0`**.
///
/// 🔴 **This decays, and it is deliberately NOT the `mode: retakeWrong`
/// pool** (adr-133, `:888-893`). It counts a question only while the
/// student's most recent graded answer to it was wrong; answering it
/// correctly later removes it immediately. The retake pool is *ever wrong*
/// and does not decay. **Do not reconcile the two numbers and do not derive
/// one from the other.**
///
/// It is also computed on every read and never cached, so two requests
/// seconds apart can legitimately disagree (`:882-886`).
@override final  int mistakeCount;

/// Create a copy of MistakesSubject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakesSubjectCopyWith<_MistakesSubject> get copyWith => __$MistakesSubjectCopyWithImpl<_MistakesSubject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakesSubjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakesSubject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,termId,termNumber,mistakeCount);

@override
String toString() {
  return 'MistakesSubject(id: $id, name: $name, termId: $termId, termNumber: $termNumber, mistakeCount: $mistakeCount)';
}


}

/// @nodoc
abstract mixin class _$MistakesSubjectCopyWith<$Res> implements $MistakesSubjectCopyWith<$Res> {
  factory _$MistakesSubjectCopyWith(_MistakesSubject value, $Res Function(_MistakesSubject) _then) = __$MistakesSubjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? termId, int? termNumber, int mistakeCount
});




}
/// @nodoc
class __$MistakesSubjectCopyWithImpl<$Res>
    implements _$MistakesSubjectCopyWith<$Res> {
  __$MistakesSubjectCopyWithImpl(this._self, this._then);

  final _MistakesSubject _self;
  final $Res Function(_MistakesSubject) _then;

/// Create a copy of MistakesSubject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? termId = freezed,Object? termNumber = freezed,Object? mistakeCount = null,}) {
  return _then(_MistakesSubject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
