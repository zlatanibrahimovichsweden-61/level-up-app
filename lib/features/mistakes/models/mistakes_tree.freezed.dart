// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mistakes_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchoolMistakesTree {

/// Always [Track.school] here.
 Track get track;/// Sum over the whole subject; `minimum: 0`, and `0` exactly when [units]
/// is empty.
 int get mistakeCount;/// Only units containing at least one mistake. **May be EMPTY — that is a
/// normal response**, not an error.
 List<MistakesUnit> get units;
/// Create a copy of SchoolMistakesTree
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchoolMistakesTreeCopyWith<SchoolMistakesTree> get copyWith => _$SchoolMistakesTreeCopyWithImpl<SchoolMistakesTree>(this as SchoolMistakesTree, _$identity);

  /// Serializes this SchoolMistakesTree to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchoolMistakesTree&&(identical(other.track, track) || other.track == track)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other.units, units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,mistakeCount,const DeepCollectionEquality().hash(units));

@override
String toString() {
  return 'SchoolMistakesTree(track: $track, mistakeCount: $mistakeCount, units: $units)';
}


}

/// @nodoc
abstract mixin class $SchoolMistakesTreeCopyWith<$Res>  {
  factory $SchoolMistakesTreeCopyWith(SchoolMistakesTree value, $Res Function(SchoolMistakesTree) _then) = _$SchoolMistakesTreeCopyWithImpl;
@useResult
$Res call({
 Track track, int mistakeCount, List<MistakesUnit> units
});




}
/// @nodoc
class _$SchoolMistakesTreeCopyWithImpl<$Res>
    implements $SchoolMistakesTreeCopyWith<$Res> {
  _$SchoolMistakesTreeCopyWithImpl(this._self, this._then);

  final SchoolMistakesTree _self;
  final $Res Function(SchoolMistakesTree) _then;

/// Create a copy of SchoolMistakesTree
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? mistakeCount = null,Object? units = null,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<MistakesUnit>,
  ));
}

}


/// Adds pattern-matching-related methods to [SchoolMistakesTree].
extension SchoolMistakesTreePatterns on SchoolMistakesTree {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchoolMistakesTree value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchoolMistakesTree() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchoolMistakesTree value)  $default,){
final _that = this;
switch (_that) {
case _SchoolMistakesTree():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchoolMistakesTree value)?  $default,){
final _that = this;
switch (_that) {
case _SchoolMistakesTree() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Track track,  int mistakeCount,  List<MistakesUnit> units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchoolMistakesTree() when $default != null:
return $default(_that.track,_that.mistakeCount,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Track track,  int mistakeCount,  List<MistakesUnit> units)  $default,) {final _that = this;
switch (_that) {
case _SchoolMistakesTree():
return $default(_that.track,_that.mistakeCount,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Track track,  int mistakeCount,  List<MistakesUnit> units)?  $default,) {final _that = this;
switch (_that) {
case _SchoolMistakesTree() when $default != null:
return $default(_that.track,_that.mistakeCount,_that.units);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchoolMistakesTree implements SchoolMistakesTree {
  const _SchoolMistakesTree({required this.track, required this.mistakeCount, required final  List<MistakesUnit> units}): _units = units;
  factory _SchoolMistakesTree.fromJson(Map<String, dynamic> json) => _$SchoolMistakesTreeFromJson(json);

/// Always [Track.school] here.
@override final  Track track;
/// Sum over the whole subject; `minimum: 0`, and `0` exactly when [units]
/// is empty.
@override final  int mistakeCount;
/// Only units containing at least one mistake. **May be EMPTY — that is a
/// normal response**, not an error.
 final  List<MistakesUnit> _units;
/// Only units containing at least one mistake. **May be EMPTY — that is a
/// normal response**, not an error.
@override List<MistakesUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}


/// Create a copy of SchoolMistakesTree
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchoolMistakesTreeCopyWith<_SchoolMistakesTree> get copyWith => __$SchoolMistakesTreeCopyWithImpl<_SchoolMistakesTree>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchoolMistakesTreeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchoolMistakesTree&&(identical(other.track, track) || other.track == track)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other._units, _units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,mistakeCount,const DeepCollectionEquality().hash(_units));

@override
String toString() {
  return 'SchoolMistakesTree(track: $track, mistakeCount: $mistakeCount, units: $units)';
}


}

/// @nodoc
abstract mixin class _$SchoolMistakesTreeCopyWith<$Res> implements $SchoolMistakesTreeCopyWith<$Res> {
  factory _$SchoolMistakesTreeCopyWith(_SchoolMistakesTree value, $Res Function(_SchoolMistakesTree) _then) = __$SchoolMistakesTreeCopyWithImpl;
@override @useResult
$Res call({
 Track track, int mistakeCount, List<MistakesUnit> units
});




}
/// @nodoc
class __$SchoolMistakesTreeCopyWithImpl<$Res>
    implements _$SchoolMistakesTreeCopyWith<$Res> {
  __$SchoolMistakesTreeCopyWithImpl(this._self, this._then);

  final _SchoolMistakesTree _self;
  final $Res Function(_SchoolMistakesTree) _then;

/// Create a copy of SchoolMistakesTree
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? mistakeCount = null,Object? units = null,}) {
  return _then(_SchoolMistakesTree(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<MistakesUnit>,
  ));
}


}


/// @nodoc
mixin _$MistakesUnit {

 String get id; String get name;/// Sum over this unit's chapters — server-computed, `minimum: 1`.
 int get mistakeCount; List<MistakesChapter> get chapters;
/// Create a copy of MistakesUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakesUnitCopyWith<MistakesUnit> get copyWith => _$MistakesUnitCopyWithImpl<MistakesUnit>(this as MistakesUnit, _$identity);

  /// Serializes this MistakesUnit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakesUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'MistakesUnit(id: $id, name: $name, mistakeCount: $mistakeCount, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $MistakesUnitCopyWith<$Res>  {
  factory $MistakesUnitCopyWith(MistakesUnit value, $Res Function(MistakesUnit) _then) = _$MistakesUnitCopyWithImpl;
@useResult
$Res call({
 String id, String name, int mistakeCount, List<MistakesChapter> chapters
});




}
/// @nodoc
class _$MistakesUnitCopyWithImpl<$Res>
    implements $MistakesUnitCopyWith<$Res> {
  _$MistakesUnitCopyWithImpl(this._self, this._then);

  final MistakesUnit _self;
  final $Res Function(MistakesUnit) _then;

/// Create a copy of MistakesUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,Object? chapters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<MistakesChapter>,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakesUnit].
extension MistakesUnitPatterns on MistakesUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakesUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakesUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakesUnit value)  $default,){
final _that = this;
switch (_that) {
case _MistakesUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakesUnit value)?  $default,){
final _that = this;
switch (_that) {
case _MistakesUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount,  List<MistakesChapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakesUnit() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount,  List<MistakesChapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _MistakesUnit():
return $default(_that.id,_that.name,_that.mistakeCount,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int mistakeCount,  List<MistakesChapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _MistakesUnit() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MistakesUnit implements MistakesUnit {
  const _MistakesUnit({required this.id, required this.name, required this.mistakeCount, required final  List<MistakesChapter> chapters}): _chapters = chapters;
  factory _MistakesUnit.fromJson(Map<String, dynamic> json) => _$MistakesUnitFromJson(json);

@override final  String id;
@override final  String name;
/// Sum over this unit's chapters — server-computed, `minimum: 1`.
@override final  int mistakeCount;
 final  List<MistakesChapter> _chapters;
@override List<MistakesChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of MistakesUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakesUnitCopyWith<_MistakesUnit> get copyWith => __$MistakesUnitCopyWithImpl<_MistakesUnit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakesUnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakesUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'MistakesUnit(id: $id, name: $name, mistakeCount: $mistakeCount, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$MistakesUnitCopyWith<$Res> implements $MistakesUnitCopyWith<$Res> {
  factory _$MistakesUnitCopyWith(_MistakesUnit value, $Res Function(_MistakesUnit) _then) = __$MistakesUnitCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int mistakeCount, List<MistakesChapter> chapters
});




}
/// @nodoc
class __$MistakesUnitCopyWithImpl<$Res>
    implements _$MistakesUnitCopyWith<$Res> {
  __$MistakesUnitCopyWithImpl(this._self, this._then);

  final _MistakesUnit _self;
  final $Res Function(_MistakesUnit) _then;

/// Create a copy of MistakesUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,Object? chapters = null,}) {
  return _then(_MistakesUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<MistakesChapter>,
  ));
}


}


/// @nodoc
mixin _$MistakesChapter {

 String get id; String get name;/// Sum over this chapter's lessons — server-computed, `minimum: 1`.
 int get mistakeCount; List<MistakesLesson> get lessons;
/// Create a copy of MistakesChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakesChapterCopyWith<MistakesChapter> get copyWith => _$MistakesChapterCopyWithImpl<MistakesChapter>(this as MistakesChapter, _$identity);

  /// Serializes this MistakesChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakesChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other.lessons, lessons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount,const DeepCollectionEquality().hash(lessons));

@override
String toString() {
  return 'MistakesChapter(id: $id, name: $name, mistakeCount: $mistakeCount, lessons: $lessons)';
}


}

/// @nodoc
abstract mixin class $MistakesChapterCopyWith<$Res>  {
  factory $MistakesChapterCopyWith(MistakesChapter value, $Res Function(MistakesChapter) _then) = _$MistakesChapterCopyWithImpl;
@useResult
$Res call({
 String id, String name, int mistakeCount, List<MistakesLesson> lessons
});




}
/// @nodoc
class _$MistakesChapterCopyWithImpl<$Res>
    implements $MistakesChapterCopyWith<$Res> {
  _$MistakesChapterCopyWithImpl(this._self, this._then);

  final MistakesChapter _self;
  final $Res Function(MistakesChapter) _then;

/// Create a copy of MistakesChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,Object? lessons = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<MistakesLesson>,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakesChapter].
extension MistakesChapterPatterns on MistakesChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakesChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakesChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakesChapter value)  $default,){
final _that = this;
switch (_that) {
case _MistakesChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakesChapter value)?  $default,){
final _that = this;
switch (_that) {
case _MistakesChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount,  List<MistakesLesson> lessons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakesChapter() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount,_that.lessons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount,  List<MistakesLesson> lessons)  $default,) {final _that = this;
switch (_that) {
case _MistakesChapter():
return $default(_that.id,_that.name,_that.mistakeCount,_that.lessons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int mistakeCount,  List<MistakesLesson> lessons)?  $default,) {final _that = this;
switch (_that) {
case _MistakesChapter() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount,_that.lessons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MistakesChapter implements MistakesChapter {
  const _MistakesChapter({required this.id, required this.name, required this.mistakeCount, required final  List<MistakesLesson> lessons}): _lessons = lessons;
  factory _MistakesChapter.fromJson(Map<String, dynamic> json) => _$MistakesChapterFromJson(json);

@override final  String id;
@override final  String name;
/// Sum over this chapter's lessons — server-computed, `minimum: 1`.
@override final  int mistakeCount;
 final  List<MistakesLesson> _lessons;
@override List<MistakesLesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}


/// Create a copy of MistakesChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakesChapterCopyWith<_MistakesChapter> get copyWith => __$MistakesChapterCopyWithImpl<_MistakesChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakesChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakesChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other._lessons, _lessons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount,const DeepCollectionEquality().hash(_lessons));

@override
String toString() {
  return 'MistakesChapter(id: $id, name: $name, mistakeCount: $mistakeCount, lessons: $lessons)';
}


}

/// @nodoc
abstract mixin class _$MistakesChapterCopyWith<$Res> implements $MistakesChapterCopyWith<$Res> {
  factory _$MistakesChapterCopyWith(_MistakesChapter value, $Res Function(_MistakesChapter) _then) = __$MistakesChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int mistakeCount, List<MistakesLesson> lessons
});




}
/// @nodoc
class __$MistakesChapterCopyWithImpl<$Res>
    implements _$MistakesChapterCopyWith<$Res> {
  __$MistakesChapterCopyWithImpl(this._self, this._then);

  final _MistakesChapter _self;
  final $Res Function(_MistakesChapter) _then;

/// Create a copy of MistakesChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,Object? lessons = null,}) {
  return _then(_MistakesChapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<MistakesLesson>,
  ));
}


}


/// @nodoc
mixin _$MistakesLesson {

 String get id; String get name; int get mistakeCount;
/// Create a copy of MistakesLesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakesLessonCopyWith<MistakesLesson> get copyWith => _$MistakesLessonCopyWithImpl<MistakesLesson>(this as MistakesLesson, _$identity);

  /// Serializes this MistakesLesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakesLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount);

@override
String toString() {
  return 'MistakesLesson(id: $id, name: $name, mistakeCount: $mistakeCount)';
}


}

/// @nodoc
abstract mixin class $MistakesLessonCopyWith<$Res>  {
  factory $MistakesLessonCopyWith(MistakesLesson value, $Res Function(MistakesLesson) _then) = _$MistakesLessonCopyWithImpl;
@useResult
$Res call({
 String id, String name, int mistakeCount
});




}
/// @nodoc
class _$MistakesLessonCopyWithImpl<$Res>
    implements $MistakesLessonCopyWith<$Res> {
  _$MistakesLessonCopyWithImpl(this._self, this._then);

  final MistakesLesson _self;
  final $Res Function(MistakesLesson) _then;

/// Create a copy of MistakesLesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakesLesson].
extension MistakesLessonPatterns on MistakesLesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakesLesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakesLesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakesLesson value)  $default,){
final _that = this;
switch (_that) {
case _MistakesLesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakesLesson value)?  $default,){
final _that = this;
switch (_that) {
case _MistakesLesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakesLesson() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount)  $default,) {final _that = this;
switch (_that) {
case _MistakesLesson():
return $default(_that.id,_that.name,_that.mistakeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int mistakeCount)?  $default,) {final _that = this;
switch (_that) {
case _MistakesLesson() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MistakesLesson implements MistakesLesson {
  const _MistakesLesson({required this.id, required this.name, required this.mistakeCount});
  factory _MistakesLesson.fromJson(Map<String, dynamic> json) => _$MistakesLessonFromJson(json);

@override final  String id;
@override final  String name;
@override final  int mistakeCount;

/// Create a copy of MistakesLesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakesLessonCopyWith<_MistakesLesson> get copyWith => __$MistakesLessonCopyWithImpl<_MistakesLesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakesLessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakesLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount);

@override
String toString() {
  return 'MistakesLesson(id: $id, name: $name, mistakeCount: $mistakeCount)';
}


}

/// @nodoc
abstract mixin class _$MistakesLessonCopyWith<$Res> implements $MistakesLessonCopyWith<$Res> {
  factory _$MistakesLessonCopyWith(_MistakesLesson value, $Res Function(_MistakesLesson) _then) = __$MistakesLessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int mistakeCount
});




}
/// @nodoc
class __$MistakesLessonCopyWithImpl<$Res>
    implements _$MistakesLessonCopyWith<$Res> {
  __$MistakesLessonCopyWithImpl(this._self, this._then);

  final _MistakesLesson _self;
  final $Res Function(_MistakesLesson) _then;

/// Create a copy of MistakesLesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,}) {
  return _then(_MistakesLesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UniversityMistakesTree {

/// Always [Track.university] here.
 Track get track;/// Sum over the whole subject; `0` exactly when [lectures] is empty.
 int get mistakeCount;/// Only lectures containing at least one mistake. May be EMPTY.
 List<MistakesLecture> get lectures;
/// Create a copy of UniversityMistakesTree
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniversityMistakesTreeCopyWith<UniversityMistakesTree> get copyWith => _$UniversityMistakesTreeCopyWithImpl<UniversityMistakesTree>(this as UniversityMistakesTree, _$identity);

  /// Serializes this UniversityMistakesTree to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniversityMistakesTree&&(identical(other.track, track) || other.track == track)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other.lectures, lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,mistakeCount,const DeepCollectionEquality().hash(lectures));

@override
String toString() {
  return 'UniversityMistakesTree(track: $track, mistakeCount: $mistakeCount, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class $UniversityMistakesTreeCopyWith<$Res>  {
  factory $UniversityMistakesTreeCopyWith(UniversityMistakesTree value, $Res Function(UniversityMistakesTree) _then) = _$UniversityMistakesTreeCopyWithImpl;
@useResult
$Res call({
 Track track, int mistakeCount, List<MistakesLecture> lectures
});




}
/// @nodoc
class _$UniversityMistakesTreeCopyWithImpl<$Res>
    implements $UniversityMistakesTreeCopyWith<$Res> {
  _$UniversityMistakesTreeCopyWithImpl(this._self, this._then);

  final UniversityMistakesTree _self;
  final $Res Function(UniversityMistakesTree) _then;

/// Create a copy of UniversityMistakesTree
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? track = null,Object? mistakeCount = null,Object? lectures = null,}) {
  return _then(_self.copyWith(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,lectures: null == lectures ? _self.lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<MistakesLecture>,
  ));
}

}


/// Adds pattern-matching-related methods to [UniversityMistakesTree].
extension UniversityMistakesTreePatterns on UniversityMistakesTree {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UniversityMistakesTree value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UniversityMistakesTree() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UniversityMistakesTree value)  $default,){
final _that = this;
switch (_that) {
case _UniversityMistakesTree():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UniversityMistakesTree value)?  $default,){
final _that = this;
switch (_that) {
case _UniversityMistakesTree() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Track track,  int mistakeCount,  List<MistakesLecture> lectures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UniversityMistakesTree() when $default != null:
return $default(_that.track,_that.mistakeCount,_that.lectures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Track track,  int mistakeCount,  List<MistakesLecture> lectures)  $default,) {final _that = this;
switch (_that) {
case _UniversityMistakesTree():
return $default(_that.track,_that.mistakeCount,_that.lectures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Track track,  int mistakeCount,  List<MistakesLecture> lectures)?  $default,) {final _that = this;
switch (_that) {
case _UniversityMistakesTree() when $default != null:
return $default(_that.track,_that.mistakeCount,_that.lectures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UniversityMistakesTree implements UniversityMistakesTree {
  const _UniversityMistakesTree({required this.track, required this.mistakeCount, required final  List<MistakesLecture> lectures}): _lectures = lectures;
  factory _UniversityMistakesTree.fromJson(Map<String, dynamic> json) => _$UniversityMistakesTreeFromJson(json);

/// Always [Track.university] here.
@override final  Track track;
/// Sum over the whole subject; `0` exactly when [lectures] is empty.
@override final  int mistakeCount;
/// Only lectures containing at least one mistake. May be EMPTY.
 final  List<MistakesLecture> _lectures;
/// Only lectures containing at least one mistake. May be EMPTY.
@override List<MistakesLecture> get lectures {
  if (_lectures is EqualUnmodifiableListView) return _lectures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lectures);
}


/// Create a copy of UniversityMistakesTree
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniversityMistakesTreeCopyWith<_UniversityMistakesTree> get copyWith => __$UniversityMistakesTreeCopyWithImpl<_UniversityMistakesTree>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniversityMistakesTreeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UniversityMistakesTree&&(identical(other.track, track) || other.track == track)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount)&&const DeepCollectionEquality().equals(other._lectures, _lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,track,mistakeCount,const DeepCollectionEquality().hash(_lectures));

@override
String toString() {
  return 'UniversityMistakesTree(track: $track, mistakeCount: $mistakeCount, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class _$UniversityMistakesTreeCopyWith<$Res> implements $UniversityMistakesTreeCopyWith<$Res> {
  factory _$UniversityMistakesTreeCopyWith(_UniversityMistakesTree value, $Res Function(_UniversityMistakesTree) _then) = __$UniversityMistakesTreeCopyWithImpl;
@override @useResult
$Res call({
 Track track, int mistakeCount, List<MistakesLecture> lectures
});




}
/// @nodoc
class __$UniversityMistakesTreeCopyWithImpl<$Res>
    implements _$UniversityMistakesTreeCopyWith<$Res> {
  __$UniversityMistakesTreeCopyWithImpl(this._self, this._then);

  final _UniversityMistakesTree _self;
  final $Res Function(_UniversityMistakesTree) _then;

/// Create a copy of UniversityMistakesTree
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? track = null,Object? mistakeCount = null,Object? lectures = null,}) {
  return _then(_UniversityMistakesTree(
track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,lectures: null == lectures ? _self._lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<MistakesLecture>,
  ));
}


}


/// @nodoc
mixin _$MistakesLecture {

 String get id; String get name; int get mistakeCount;
/// Create a copy of MistakesLecture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakesLectureCopyWith<MistakesLecture> get copyWith => _$MistakesLectureCopyWithImpl<MistakesLecture>(this as MistakesLecture, _$identity);

  /// Serializes this MistakesLecture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakesLecture&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount);

@override
String toString() {
  return 'MistakesLecture(id: $id, name: $name, mistakeCount: $mistakeCount)';
}


}

/// @nodoc
abstract mixin class $MistakesLectureCopyWith<$Res>  {
  factory $MistakesLectureCopyWith(MistakesLecture value, $Res Function(MistakesLecture) _then) = _$MistakesLectureCopyWithImpl;
@useResult
$Res call({
 String id, String name, int mistakeCount
});




}
/// @nodoc
class _$MistakesLectureCopyWithImpl<$Res>
    implements $MistakesLectureCopyWith<$Res> {
  _$MistakesLectureCopyWithImpl(this._self, this._then);

  final MistakesLecture _self;
  final $Res Function(MistakesLecture) _then;

/// Create a copy of MistakesLecture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakesLecture].
extension MistakesLecturePatterns on MistakesLecture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakesLecture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakesLecture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakesLecture value)  $default,){
final _that = this;
switch (_that) {
case _MistakesLecture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakesLecture value)?  $default,){
final _that = this;
switch (_that) {
case _MistakesLecture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakesLecture() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int mistakeCount)  $default,) {final _that = this;
switch (_that) {
case _MistakesLecture():
return $default(_that.id,_that.name,_that.mistakeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int mistakeCount)?  $default,) {final _that = this;
switch (_that) {
case _MistakesLecture() when $default != null:
return $default(_that.id,_that.name,_that.mistakeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MistakesLecture implements MistakesLecture {
  const _MistakesLecture({required this.id, required this.name, required this.mistakeCount});
  factory _MistakesLecture.fromJson(Map<String, dynamic> json) => _$MistakesLectureFromJson(json);

@override final  String id;
@override final  String name;
@override final  int mistakeCount;

/// Create a copy of MistakesLecture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakesLectureCopyWith<_MistakesLecture> get copyWith => __$MistakesLectureCopyWithImpl<_MistakesLecture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakesLectureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakesLecture&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mistakeCount, mistakeCount) || other.mistakeCount == mistakeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mistakeCount);

@override
String toString() {
  return 'MistakesLecture(id: $id, name: $name, mistakeCount: $mistakeCount)';
}


}

/// @nodoc
abstract mixin class _$MistakesLectureCopyWith<$Res> implements $MistakesLectureCopyWith<$Res> {
  factory _$MistakesLectureCopyWith(_MistakesLecture value, $Res Function(_MistakesLecture) _then) = __$MistakesLectureCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int mistakeCount
});




}
/// @nodoc
class __$MistakesLectureCopyWithImpl<$Res>
    implements _$MistakesLectureCopyWith<$Res> {
  __$MistakesLectureCopyWithImpl(this._self, this._then);

  final _MistakesLecture _self;
  final $Res Function(_MistakesLecture) _then;

/// Create a copy of MistakesLecture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mistakeCount = null,}) {
  return _then(_MistakesLecture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mistakeCount: null == mistakeCount ? _self.mistakeCount : mistakeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
