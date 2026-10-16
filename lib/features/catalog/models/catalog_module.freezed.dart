// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogModule {

 String get id; String get name;/// The server sorts by this, then by [name]. Carried so the order is
/// documented on the model; the app never re-sorts by it.
 int get displayOrder;/// adr-036 term signals, **optional** on this item and modelled like
/// `Subject`'s: nullable, NO default, because a defaulted `termNumber`
/// would fabricate an ordinal the server never sent. `termId` is opaque
/// (adr-026 §7); `termNumber` is the only labellable term signal, and this
/// build draws no term header (CW16b-M).
 String? get termId; int? get termNumber;/// The subjects in this module that pass the release gate. MAY be empty,
/// and the contract promises no order for it: the app keeps the order as
/// served and never re-sorts it.
 List<String> get subjectIds;
/// Create a copy of CatalogModule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogModuleCopyWith<CatalogModule> get copyWith => _$CatalogModuleCopyWithImpl<CatalogModule>(this as CatalogModule, _$identity);

  /// Serializes this CatalogModule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogModule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber)&&const DeepCollectionEquality().equals(other.subjectIds, subjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,displayOrder,termId,termNumber,const DeepCollectionEquality().hash(subjectIds));

@override
String toString() {
  return 'CatalogModule(id: $id, name: $name, displayOrder: $displayOrder, termId: $termId, termNumber: $termNumber, subjectIds: $subjectIds)';
}


}

/// @nodoc
abstract mixin class $CatalogModuleCopyWith<$Res>  {
  factory $CatalogModuleCopyWith(CatalogModule value, $Res Function(CatalogModule) _then) = _$CatalogModuleCopyWithImpl;
@useResult
$Res call({
 String id, String name, int displayOrder, String? termId, int? termNumber, List<String> subjectIds
});




}
/// @nodoc
class _$CatalogModuleCopyWithImpl<$Res>
    implements $CatalogModuleCopyWith<$Res> {
  _$CatalogModuleCopyWithImpl(this._self, this._then);

  final CatalogModule _self;
  final $Res Function(CatalogModule) _then;

/// Create a copy of CatalogModule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? displayOrder = null,Object? termId = freezed,Object? termNumber = freezed,Object? subjectIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,subjectIds: null == subjectIds ? _self.subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogModule].
extension CatalogModulePatterns on CatalogModule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogModule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogModule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogModule value)  $default,){
final _that = this;
switch (_that) {
case _CatalogModule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogModule value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogModule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int displayOrder,  String? termId,  int? termNumber,  List<String> subjectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogModule() when $default != null:
return $default(_that.id,_that.name,_that.displayOrder,_that.termId,_that.termNumber,_that.subjectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int displayOrder,  String? termId,  int? termNumber,  List<String> subjectIds)  $default,) {final _that = this;
switch (_that) {
case _CatalogModule():
return $default(_that.id,_that.name,_that.displayOrder,_that.termId,_that.termNumber,_that.subjectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int displayOrder,  String? termId,  int? termNumber,  List<String> subjectIds)?  $default,) {final _that = this;
switch (_that) {
case _CatalogModule() when $default != null:
return $default(_that.id,_that.name,_that.displayOrder,_that.termId,_that.termNumber,_that.subjectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogModule implements CatalogModule {
  const _CatalogModule({required this.id, required this.name, required this.displayOrder, this.termId, this.termNumber, required final  List<String> subjectIds}): _subjectIds = subjectIds;
  factory _CatalogModule.fromJson(Map<String, dynamic> json) => _$CatalogModuleFromJson(json);

@override final  String id;
@override final  String name;
/// The server sorts by this, then by [name]. Carried so the order is
/// documented on the model; the app never re-sorts by it.
@override final  int displayOrder;
/// adr-036 term signals, **optional** on this item and modelled like
/// `Subject`'s: nullable, NO default, because a defaulted `termNumber`
/// would fabricate an ordinal the server never sent. `termId` is opaque
/// (adr-026 §7); `termNumber` is the only labellable term signal, and this
/// build draws no term header (CW16b-M).
@override final  String? termId;
@override final  int? termNumber;
/// The subjects in this module that pass the release gate. MAY be empty,
/// and the contract promises no order for it: the app keeps the order as
/// served and never re-sorts it.
 final  List<String> _subjectIds;
/// The subjects in this module that pass the release gate. MAY be empty,
/// and the contract promises no order for it: the app keeps the order as
/// served and never re-sorts it.
@override List<String> get subjectIds {
  if (_subjectIds is EqualUnmodifiableListView) return _subjectIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjectIds);
}


/// Create a copy of CatalogModule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogModuleCopyWith<_CatalogModule> get copyWith => __$CatalogModuleCopyWithImpl<_CatalogModule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogModuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogModule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber)&&const DeepCollectionEquality().equals(other._subjectIds, _subjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,displayOrder,termId,termNumber,const DeepCollectionEquality().hash(_subjectIds));

@override
String toString() {
  return 'CatalogModule(id: $id, name: $name, displayOrder: $displayOrder, termId: $termId, termNumber: $termNumber, subjectIds: $subjectIds)';
}


}

/// @nodoc
abstract mixin class _$CatalogModuleCopyWith<$Res> implements $CatalogModuleCopyWith<$Res> {
  factory _$CatalogModuleCopyWith(_CatalogModule value, $Res Function(_CatalogModule) _then) = __$CatalogModuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int displayOrder, String? termId, int? termNumber, List<String> subjectIds
});




}
/// @nodoc
class __$CatalogModuleCopyWithImpl<$Res>
    implements _$CatalogModuleCopyWith<$Res> {
  __$CatalogModuleCopyWithImpl(this._self, this._then);

  final _CatalogModule _self;
  final $Res Function(_CatalogModule) _then;

/// Create a copy of CatalogModule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? displayOrder = null,Object? termId = freezed,Object? termNumber = freezed,Object? subjectIds = null,}) {
  return _then(_CatalogModule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,subjectIds: null == subjectIds ? _self._subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
