// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchoolSubjectTree {

/// Always [Track.school] here.
 Track get track; List<Unit> get units;
/// Create a copy of SchoolSubjectTree
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchoolSubjectTreeCopyWith<SchoolSubjectTree> get copyWith => _$SchoolSubjectTreeCopyWithImpl<SchoolSubjectTree>(this as SchoolSubjectTree, _$identity);

  /// Serializes this SchoolSubjectTree to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchoolSubjectTree&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other.units, units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,const DeepCollectionEquality().hash(units));

@override
String toString() {
  return 'SchoolSubjectTree(track: $track, units: $units)';
}


}

/// @nodoc
abstract mixin class $SchoolSubjectTreeCopyWith<$Res>  {
  factory $SchoolSubjectTreeCopyWith(SchoolSubjectTree value, $Res Function(SchoolSubjectTree) _then) = _$SchoolSubjectTreeCopyWithImpl;
@useResult
$Res call({
 Track track, List<Unit> units
});




}
/// @nodoc
class _$SchoolSubjectTreeCopyWithImpl<$Res>
    implements $SchoolSubjectTreeCopyWith<$Res> {
  _$SchoolSubjectTreeCopyWithImpl(this._self, this._then);

  final SchoolSubjectTree _self;
  final $Res Function(SchoolSubjectTree) _then;

/// Create a copy of SchoolSubjectTree
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? units = null,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<Unit>,
  ));
}

}


/// Adds pattern-matching-related methods to [SchoolSubjectTree].
extension SchoolSubjectTreePatterns on SchoolSubjectTree {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchoolSubjectTree value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchoolSubjectTree() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchoolSubjectTree value)  $default,){
final _that = this;
switch (_that) {
case _SchoolSubjectTree():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchoolSubjectTree value)?  $default,){
final _that = this;
switch (_that) {
case _SchoolSubjectTree() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Track track,  List<Unit> units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchoolSubjectTree() when $default != null:
return $default(_that.track,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Track track,  List<Unit> units)  $default,) {final _that = this;
switch (_that) {
case _SchoolSubjectTree():
return $default(_that.track,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Track track,  List<Unit> units)?  $default,) {final _that = this;
switch (_that) {
case _SchoolSubjectTree() when $default != null:
return $default(_that.track,_that.units);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchoolSubjectTree implements SchoolSubjectTree {
  const _SchoolSubjectTree({required this.track, required final  List<Unit> units}): _units = units;
  factory _SchoolSubjectTree.fromJson(Map<String, dynamic> json) => _$SchoolSubjectTreeFromJson(json);

/// Always [Track.school] here.
@override final  Track track;
 final  List<Unit> _units;
@override List<Unit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}


/// Create a copy of SchoolSubjectTree
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchoolSubjectTreeCopyWith<_SchoolSubjectTree> get copyWith => __$SchoolSubjectTreeCopyWithImpl<_SchoolSubjectTree>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchoolSubjectTreeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchoolSubjectTree&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other._units, _units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,const DeepCollectionEquality().hash(_units));

@override
String toString() {
  return 'SchoolSubjectTree(track: $track, units: $units)';
}


}

/// @nodoc
abstract mixin class _$SchoolSubjectTreeCopyWith<$Res> implements $SchoolSubjectTreeCopyWith<$Res> {
  factory _$SchoolSubjectTreeCopyWith(_SchoolSubjectTree value, $Res Function(_SchoolSubjectTree) _then) = __$SchoolSubjectTreeCopyWithImpl;
@override @useResult
$Res call({
 Track track, List<Unit> units
});




}
/// @nodoc
class __$SchoolSubjectTreeCopyWithImpl<$Res>
    implements _$SchoolSubjectTreeCopyWith<$Res> {
  __$SchoolSubjectTreeCopyWithImpl(this._self, this._then);

  final _SchoolSubjectTree _self;
  final $Res Function(_SchoolSubjectTree) _then;

/// Create a copy of SchoolSubjectTree
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? units = null,}) {
  return _then(_SchoolSubjectTree(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<Unit>,
  ));
}


}


/// @nodoc
mixin _$Unit {

 String get id; String get name; List<Chapter> get chapters;
/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitCopyWith<Unit> get copyWith => _$UnitCopyWithImpl<Unit>(this as Unit, _$identity);

  /// Serializes this Unit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'Unit(id: $id, name: $name, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $UnitCopyWith<$Res>  {
  factory $UnitCopyWith(Unit value, $Res Function(Unit) _then) = _$UnitCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<Chapter> chapters
});




}
/// @nodoc
class _$UnitCopyWithImpl<$Res>
    implements $UnitCopyWith<$Res> {
  _$UnitCopyWithImpl(this._self, this._then);

  final Unit _self;
  final $Res Function(Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? chapters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,
  ));
}

}


/// Adds pattern-matching-related methods to [Unit].
extension UnitPatterns on Unit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Unit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Unit value)  $default,){
final _that = this;
switch (_that) {
case _Unit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Unit value)?  $default,){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<Chapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.name,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<Chapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _Unit():
return $default(_that.id,_that.name,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<Chapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.name,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Unit implements Unit {
  const _Unit({required this.id, required this.name, required final  List<Chapter> chapters}): _chapters = chapters;
  factory _Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

@override final  String id;
@override final  String name;
 final  List<Chapter> _chapters;
@override List<Chapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitCopyWith<_Unit> get copyWith => __$UnitCopyWithImpl<_Unit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'Unit(id: $id, name: $name, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$UnitCopyWith<$Res> implements $UnitCopyWith<$Res> {
  factory _$UnitCopyWith(_Unit value, $Res Function(_Unit) _then) = __$UnitCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<Chapter> chapters
});




}
/// @nodoc
class __$UnitCopyWithImpl<$Res>
    implements _$UnitCopyWith<$Res> {
  __$UnitCopyWithImpl(this._self, this._then);

  final _Unit _self;
  final $Res Function(_Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? chapters = null,}) {
  return _then(_Unit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,
  ));
}


}


/// @nodoc
mixin _$Chapter {

 String get id; String get name; List<Lesson> get lessons;
/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCopyWith<Chapter> get copyWith => _$ChapterCopyWithImpl<Chapter>(this as Chapter, _$identity);

  /// Serializes this Chapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chapter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.lessons, lessons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(lessons));

@override
String toString() {
  return 'Chapter(id: $id, name: $name, lessons: $lessons)';
}


}

/// @nodoc
abstract mixin class $ChapterCopyWith<$Res>  {
  factory $ChapterCopyWith(Chapter value, $Res Function(Chapter) _then) = _$ChapterCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<Lesson> lessons
});




}
/// @nodoc
class _$ChapterCopyWithImpl<$Res>
    implements $ChapterCopyWith<$Res> {
  _$ChapterCopyWithImpl(this._self, this._then);

  final Chapter _self;
  final $Res Function(Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lessons = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,
  ));
}

}


/// Adds pattern-matching-related methods to [Chapter].
extension ChapterPatterns on Chapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chapter value)  $default,){
final _that = this;
switch (_that) {
case _Chapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chapter value)?  $default,){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<Lesson> lessons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.id,_that.name,_that.lessons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<Lesson> lessons)  $default,) {final _that = this;
switch (_that) {
case _Chapter():
return $default(_that.id,_that.name,_that.lessons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<Lesson> lessons)?  $default,) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.id,_that.name,_that.lessons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chapter implements Chapter {
  const _Chapter({required this.id, required this.name, required final  List<Lesson> lessons}): _lessons = lessons;
  factory _Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);

@override final  String id;
@override final  String name;
 final  List<Lesson> _lessons;
@override List<Lesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}


/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCopyWith<_Chapter> get copyWith => __$ChapterCopyWithImpl<_Chapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chapter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._lessons, _lessons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_lessons));

@override
String toString() {
  return 'Chapter(id: $id, name: $name, lessons: $lessons)';
}


}

/// @nodoc
abstract mixin class _$ChapterCopyWith<$Res> implements $ChapterCopyWith<$Res> {
  factory _$ChapterCopyWith(_Chapter value, $Res Function(_Chapter) _then) = __$ChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<Lesson> lessons
});




}
/// @nodoc
class __$ChapterCopyWithImpl<$Res>
    implements _$ChapterCopyWith<$Res> {
  __$ChapterCopyWithImpl(this._self, this._then);

  final _Chapter _self;
  final $Res Function(_Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lessons = null,}) {
  return _then(_Chapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,
  ));
}


}


/// @nodoc
mixin _$Lesson {

 String get id; String get name; QuestionCounter get questionCounter;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.questionCounter, questionCounter) || other.questionCounter == questionCounter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,questionCounter);

@override
String toString() {
  return 'Lesson(id: $id, name: $name, questionCounter: $questionCounter)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, String name, QuestionCounter questionCounter
});


$QuestionCounterCopyWith<$Res> get questionCounter;

}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? questionCounter = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,questionCounter: null == questionCounter ? _self.questionCounter : questionCounter // ignore: cast_nullable_to_non_nullable
as QuestionCounter,
  ));
}
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCounterCopyWith<$Res> get questionCounter {
  
  return $QuestionCounterCopyWith<$Res>(_self.questionCounter, (value) {
    return _then(_self.copyWith(questionCounter: value));
  });
}
}


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  QuestionCounter questionCounter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.name,_that.questionCounter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  QuestionCounter questionCounter)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.name,_that.questionCounter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  QuestionCounter questionCounter)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.name,_that.questionCounter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({required this.id, required this.name, required this.questionCounter});
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  String name;
@override final  QuestionCounter questionCounter;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.questionCounter, questionCounter) || other.questionCounter == questionCounter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,questionCounter);

@override
String toString() {
  return 'Lesson(id: $id, name: $name, questionCounter: $questionCounter)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, QuestionCounter questionCounter
});


@override $QuestionCounterCopyWith<$Res> get questionCounter;

}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? questionCounter = null,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,questionCounter: null == questionCounter ? _self.questionCounter : questionCounter // ignore: cast_nullable_to_non_nullable
as QuestionCounter,
  ));
}

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCounterCopyWith<$Res> get questionCounter {
  
  return $QuestionCounterCopyWith<$Res>(_self.questionCounter, (value) {
    return _then(_self.copyWith(questionCounter: value));
  });
}
}


/// @nodoc
mixin _$UniversitySubjectTree {

/// Always [Track.university] here.
 Track get track; List<QuizType> get quizTypes; List<Lecture> get lectures;
/// Create a copy of UniversitySubjectTree
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniversitySubjectTreeCopyWith<UniversitySubjectTree> get copyWith => _$UniversitySubjectTreeCopyWithImpl<UniversitySubjectTree>(this as UniversitySubjectTree, _$identity);

  /// Serializes this UniversitySubjectTree to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniversitySubjectTree&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other.quizTypes, quizTypes)&&const DeepCollectionEquality().equals(other.lectures, lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,const DeepCollectionEquality().hash(quizTypes),const DeepCollectionEquality().hash(lectures));

@override
String toString() {
  return 'UniversitySubjectTree(track: $track, quizTypes: $quizTypes, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class $UniversitySubjectTreeCopyWith<$Res>  {
  factory $UniversitySubjectTreeCopyWith(UniversitySubjectTree value, $Res Function(UniversitySubjectTree) _then) = _$UniversitySubjectTreeCopyWithImpl;
@useResult
$Res call({
 Track track, List<QuizType> quizTypes, List<Lecture> lectures
});




}
/// @nodoc
class _$UniversitySubjectTreeCopyWithImpl<$Res>
    implements $UniversitySubjectTreeCopyWith<$Res> {
  _$UniversitySubjectTreeCopyWithImpl(this._self, this._then);

  final UniversitySubjectTree _self;
  final $Res Function(UniversitySubjectTree) _then;

/// Create a copy of UniversitySubjectTree
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? quizTypes = null,Object? lectures = null,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,quizTypes: null == quizTypes ? _self.quizTypes : quizTypes // ignore: cast_nullable_to_non_nullable
as List<QuizType>,lectures: null == lectures ? _self.lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<Lecture>,
  ));
}

}


/// Adds pattern-matching-related methods to [UniversitySubjectTree].
extension UniversitySubjectTreePatterns on UniversitySubjectTree {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UniversitySubjectTree value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UniversitySubjectTree() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UniversitySubjectTree value)  $default,){
final _that = this;
switch (_that) {
case _UniversitySubjectTree():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UniversitySubjectTree value)?  $default,){
final _that = this;
switch (_that) {
case _UniversitySubjectTree() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Track track,  List<QuizType> quizTypes,  List<Lecture> lectures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UniversitySubjectTree() when $default != null:
return $default(_that.track,_that.quizTypes,_that.lectures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Track track,  List<QuizType> quizTypes,  List<Lecture> lectures)  $default,) {final _that = this;
switch (_that) {
case _UniversitySubjectTree():
return $default(_that.track,_that.quizTypes,_that.lectures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Track track,  List<QuizType> quizTypes,  List<Lecture> lectures)?  $default,) {final _that = this;
switch (_that) {
case _UniversitySubjectTree() when $default != null:
return $default(_that.track,_that.quizTypes,_that.lectures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UniversitySubjectTree implements UniversitySubjectTree {
  const _UniversitySubjectTree({required this.track, required final  List<QuizType> quizTypes, required final  List<Lecture> lectures}): _quizTypes = quizTypes,_lectures = lectures;
  factory _UniversitySubjectTree.fromJson(Map<String, dynamic> json) => _$UniversitySubjectTreeFromJson(json);

/// Always [Track.university] here.
@override final  Track track;
 final  List<QuizType> _quizTypes;
@override List<QuizType> get quizTypes {
  if (_quizTypes is EqualUnmodifiableListView) return _quizTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quizTypes);
}

 final  List<Lecture> _lectures;
@override List<Lecture> get lectures {
  if (_lectures is EqualUnmodifiableListView) return _lectures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lectures);
}


/// Create a copy of UniversitySubjectTree
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniversitySubjectTreeCopyWith<_UniversitySubjectTree> get copyWith => __$UniversitySubjectTreeCopyWithImpl<_UniversitySubjectTree>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniversitySubjectTreeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UniversitySubjectTree&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other._quizTypes, _quizTypes)&&const DeepCollectionEquality().equals(other._lectures, _lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,const DeepCollectionEquality().hash(_quizTypes),const DeepCollectionEquality().hash(_lectures));

@override
String toString() {
  return 'UniversitySubjectTree(track: $track, quizTypes: $quizTypes, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class _$UniversitySubjectTreeCopyWith<$Res> implements $UniversitySubjectTreeCopyWith<$Res> {
  factory _$UniversitySubjectTreeCopyWith(_UniversitySubjectTree value, $Res Function(_UniversitySubjectTree) _then) = __$UniversitySubjectTreeCopyWithImpl;
@override @useResult
$Res call({
 Track track, List<QuizType> quizTypes, List<Lecture> lectures
});




}
/// @nodoc
class __$UniversitySubjectTreeCopyWithImpl<$Res>
    implements _$UniversitySubjectTreeCopyWith<$Res> {
  __$UniversitySubjectTreeCopyWithImpl(this._self, this._then);

  final _UniversitySubjectTree _self;
  final $Res Function(_UniversitySubjectTree) _then;

/// Create a copy of UniversitySubjectTree
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? quizTypes = null,Object? lectures = null,}) {
  return _then(_UniversitySubjectTree(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,quizTypes: null == quizTypes ? _self._quizTypes : quizTypes // ignore: cast_nullable_to_non_nullable
as List<QuizType>,lectures: null == lectures ? _self._lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<Lecture>,
  ));
}


}


/// @nodoc
mixin _$Lecture {

 String get id; String get name; QuestionCounter get questionCounter;
/// Create a copy of Lecture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LectureCopyWith<Lecture> get copyWith => _$LectureCopyWithImpl<Lecture>(this as Lecture, _$identity);

  /// Serializes this Lecture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lecture&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.questionCounter, questionCounter) || other.questionCounter == questionCounter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,questionCounter);

@override
String toString() {
  return 'Lecture(id: $id, name: $name, questionCounter: $questionCounter)';
}


}

/// @nodoc
abstract mixin class $LectureCopyWith<$Res>  {
  factory $LectureCopyWith(Lecture value, $Res Function(Lecture) _then) = _$LectureCopyWithImpl;
@useResult
$Res call({
 String id, String name, QuestionCounter questionCounter
});


$QuestionCounterCopyWith<$Res> get questionCounter;

}
/// @nodoc
class _$LectureCopyWithImpl<$Res>
    implements $LectureCopyWith<$Res> {
  _$LectureCopyWithImpl(this._self, this._then);

  final Lecture _self;
  final $Res Function(Lecture) _then;

/// Create a copy of Lecture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? questionCounter = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,questionCounter: null == questionCounter ? _self.questionCounter : questionCounter // ignore: cast_nullable_to_non_nullable
as QuestionCounter,
  ));
}
/// Create a copy of Lecture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCounterCopyWith<$Res> get questionCounter {
  
  return $QuestionCounterCopyWith<$Res>(_self.questionCounter, (value) {
    return _then(_self.copyWith(questionCounter: value));
  });
}
}


/// Adds pattern-matching-related methods to [Lecture].
extension LecturePatterns on Lecture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lecture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lecture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lecture value)  $default,){
final _that = this;
switch (_that) {
case _Lecture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lecture value)?  $default,){
final _that = this;
switch (_that) {
case _Lecture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  QuestionCounter questionCounter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lecture() when $default != null:
return $default(_that.id,_that.name,_that.questionCounter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  QuestionCounter questionCounter)  $default,) {final _that = this;
switch (_that) {
case _Lecture():
return $default(_that.id,_that.name,_that.questionCounter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  QuestionCounter questionCounter)?  $default,) {final _that = this;
switch (_that) {
case _Lecture() when $default != null:
return $default(_that.id,_that.name,_that.questionCounter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lecture implements Lecture {
  const _Lecture({required this.id, required this.name, required this.questionCounter});
  factory _Lecture.fromJson(Map<String, dynamic> json) => _$LectureFromJson(json);

@override final  String id;
@override final  String name;
@override final  QuestionCounter questionCounter;

/// Create a copy of Lecture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LectureCopyWith<_Lecture> get copyWith => __$LectureCopyWithImpl<_Lecture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LectureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lecture&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.questionCounter, questionCounter) || other.questionCounter == questionCounter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,questionCounter);

@override
String toString() {
  return 'Lecture(id: $id, name: $name, questionCounter: $questionCounter)';
}


}

/// @nodoc
abstract mixin class _$LectureCopyWith<$Res> implements $LectureCopyWith<$Res> {
  factory _$LectureCopyWith(_Lecture value, $Res Function(_Lecture) _then) = __$LectureCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, QuestionCounter questionCounter
});


@override $QuestionCounterCopyWith<$Res> get questionCounter;

}
/// @nodoc
class __$LectureCopyWithImpl<$Res>
    implements _$LectureCopyWith<$Res> {
  __$LectureCopyWithImpl(this._self, this._then);

  final _Lecture _self;
  final $Res Function(_Lecture) _then;

/// Create a copy of Lecture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? questionCounter = null,}) {
  return _then(_Lecture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,questionCounter: null == questionCounter ? _self.questionCounter : questionCounter // ignore: cast_nullable_to_non_nullable
as QuestionCounter,
  ));
}

/// Create a copy of Lecture
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
