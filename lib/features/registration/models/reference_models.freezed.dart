// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NamedRef {

 String get id; String get nameAr; String get nameEn;
/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NamedRefCopyWith<NamedRef> get copyWith => _$NamedRefCopyWithImpl<NamedRef>(this as NamedRef, _$identity);

  /// Serializes this NamedRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NamedRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameEn);

@override
String toString() {
  return 'NamedRef(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
}


}

/// @nodoc
abstract mixin class $NamedRefCopyWith<$Res>  {
  factory $NamedRefCopyWith(NamedRef value, $Res Function(NamedRef) _then) = _$NamedRefCopyWithImpl;
@useResult
$Res call({
 String id, String nameAr, String nameEn
});




}
/// @nodoc
class _$NamedRefCopyWithImpl<$Res>
    implements $NamedRefCopyWith<$Res> {
  _$NamedRefCopyWithImpl(this._self, this._then);

  final NamedRef _self;
  final $Res Function(NamedRef) _then;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameAr = null,Object? nameEn = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NamedRef].
extension NamedRefPatterns on NamedRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NamedRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NamedRef value)  $default,){
final _that = this;
switch (_that) {
case _NamedRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NamedRef value)?  $default,){
final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameEn)  $default,) {final _that = this;
switch (_that) {
case _NamedRef():
return $default(_that.id,_that.nameAr,_that.nameEn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nameAr,  String nameEn)?  $default,) {final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameEn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NamedRef implements NamedRef {
  const _NamedRef({required this.id, required this.nameAr, required this.nameEn});
  factory _NamedRef.fromJson(Map<String, dynamic> json) => _$NamedRefFromJson(json);

@override final  String id;
@override final  String nameAr;
@override final  String nameEn;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NamedRefCopyWith<_NamedRef> get copyWith => __$NamedRefCopyWithImpl<_NamedRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NamedRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NamedRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameEn);

@override
String toString() {
  return 'NamedRef(id: $id, nameAr: $nameAr, nameEn: $nameEn)';
}


}

/// @nodoc
abstract mixin class _$NamedRefCopyWith<$Res> implements $NamedRefCopyWith<$Res> {
  factory _$NamedRefCopyWith(_NamedRef value, $Res Function(_NamedRef) _then) = __$NamedRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String nameAr, String nameEn
});




}
/// @nodoc
class __$NamedRefCopyWithImpl<$Res>
    implements _$NamedRefCopyWith<$Res> {
  __$NamedRefCopyWithImpl(this._self, this._then);

  final _NamedRef _self;
  final $Res Function(_NamedRef) _then;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameAr = null,Object? nameEn = null,}) {
  return _then(_NamedRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Country {

 String get code; String get nameAr; String get nameEn; bool get requiresGovernorate;
/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryCopyWith<Country> get copyWith => _$CountryCopyWithImpl<Country>(this as Country, _$identity);

  /// Serializes this Country to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Country&&(identical(other.code, code) || other.code == code)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.requiresGovernorate, requiresGovernorate) || other.requiresGovernorate == requiresGovernorate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,nameAr,nameEn,requiresGovernorate);

@override
String toString() {
  return 'Country(code: $code, nameAr: $nameAr, nameEn: $nameEn, requiresGovernorate: $requiresGovernorate)';
}


}

/// @nodoc
abstract mixin class $CountryCopyWith<$Res>  {
  factory $CountryCopyWith(Country value, $Res Function(Country) _then) = _$CountryCopyWithImpl;
@useResult
$Res call({
 String code, String nameAr, String nameEn, bool requiresGovernorate
});




}
/// @nodoc
class _$CountryCopyWithImpl<$Res>
    implements $CountryCopyWith<$Res> {
  _$CountryCopyWithImpl(this._self, this._then);

  final Country _self;
  final $Res Function(Country) _then;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameAr = null,Object? nameEn = null,Object? requiresGovernorate = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,requiresGovernorate: null == requiresGovernorate ? _self.requiresGovernorate : requiresGovernorate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Country].
extension CountryPatterns on Country {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Country value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Country() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Country value)  $default,){
final _that = this;
switch (_that) {
case _Country():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Country value)?  $default,){
final _that = this;
switch (_that) {
case _Country() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameAr,  String nameEn,  bool requiresGovernorate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that.code,_that.nameAr,_that.nameEn,_that.requiresGovernorate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameAr,  String nameEn,  bool requiresGovernorate)  $default,) {final _that = this;
switch (_that) {
case _Country():
return $default(_that.code,_that.nameAr,_that.nameEn,_that.requiresGovernorate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameAr,  String nameEn,  bool requiresGovernorate)?  $default,) {final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that.code,_that.nameAr,_that.nameEn,_that.requiresGovernorate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Country implements Country {
  const _Country({required this.code, required this.nameAr, required this.nameEn, required this.requiresGovernorate});
  factory _Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

@override final  String code;
@override final  String nameAr;
@override final  String nameEn;
@override final  bool requiresGovernorate;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryCopyWith<_Country> get copyWith => __$CountryCopyWithImpl<_Country>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Country&&(identical(other.code, code) || other.code == code)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.requiresGovernorate, requiresGovernorate) || other.requiresGovernorate == requiresGovernorate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,nameAr,nameEn,requiresGovernorate);

@override
String toString() {
  return 'Country(code: $code, nameAr: $nameAr, nameEn: $nameEn, requiresGovernorate: $requiresGovernorate)';
}


}

/// @nodoc
abstract mixin class _$CountryCopyWith<$Res> implements $CountryCopyWith<$Res> {
  factory _$CountryCopyWith(_Country value, $Res Function(_Country) _then) = __$CountryCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameAr, String nameEn, bool requiresGovernorate
});




}
/// @nodoc
class __$CountryCopyWithImpl<$Res>
    implements _$CountryCopyWith<$Res> {
  __$CountryCopyWithImpl(this._self, this._then);

  final _Country _self;
  final $Res Function(_Country) _then;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameAr = null,Object? nameEn = null,Object? requiresGovernorate = null,}) {
  return _then(_Country(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,requiresGovernorate: null == requiresGovernorate ? _self.requiresGovernorate : requiresGovernorate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EducationSystemRef {

 String get code; String get nameAr; String get nameEn;
/// Create a copy of EducationSystemRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationSystemRefCopyWith<EducationSystemRef> get copyWith => _$EducationSystemRefCopyWithImpl<EducationSystemRef>(this as EducationSystemRef, _$identity);

  /// Serializes this EducationSystemRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationSystemRef&&(identical(other.code, code) || other.code == code)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,nameAr,nameEn);

@override
String toString() {
  return 'EducationSystemRef(code: $code, nameAr: $nameAr, nameEn: $nameEn)';
}


}

/// @nodoc
abstract mixin class $EducationSystemRefCopyWith<$Res>  {
  factory $EducationSystemRefCopyWith(EducationSystemRef value, $Res Function(EducationSystemRef) _then) = _$EducationSystemRefCopyWithImpl;
@useResult
$Res call({
 String code, String nameAr, String nameEn
});




}
/// @nodoc
class _$EducationSystemRefCopyWithImpl<$Res>
    implements $EducationSystemRefCopyWith<$Res> {
  _$EducationSystemRefCopyWithImpl(this._self, this._then);

  final EducationSystemRef _self;
  final $Res Function(EducationSystemRef) _then;

/// Create a copy of EducationSystemRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameAr = null,Object? nameEn = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationSystemRef].
extension EducationSystemRefPatterns on EducationSystemRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationSystemRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationSystemRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationSystemRef value)  $default,){
final _that = this;
switch (_that) {
case _EducationSystemRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationSystemRef value)?  $default,){
final _that = this;
switch (_that) {
case _EducationSystemRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameAr,  String nameEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationSystemRef() when $default != null:
return $default(_that.code,_that.nameAr,_that.nameEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameAr,  String nameEn)  $default,) {final _that = this;
switch (_that) {
case _EducationSystemRef():
return $default(_that.code,_that.nameAr,_that.nameEn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameAr,  String nameEn)?  $default,) {final _that = this;
switch (_that) {
case _EducationSystemRef() when $default != null:
return $default(_that.code,_that.nameAr,_that.nameEn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationSystemRef implements EducationSystemRef {
  const _EducationSystemRef({required this.code, required this.nameAr, required this.nameEn});
  factory _EducationSystemRef.fromJson(Map<String, dynamic> json) => _$EducationSystemRefFromJson(json);

@override final  String code;
@override final  String nameAr;
@override final  String nameEn;

/// Create a copy of EducationSystemRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationSystemRefCopyWith<_EducationSystemRef> get copyWith => __$EducationSystemRefCopyWithImpl<_EducationSystemRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationSystemRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationSystemRef&&(identical(other.code, code) || other.code == code)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,nameAr,nameEn);

@override
String toString() {
  return 'EducationSystemRef(code: $code, nameAr: $nameAr, nameEn: $nameEn)';
}


}

/// @nodoc
abstract mixin class _$EducationSystemRefCopyWith<$Res> implements $EducationSystemRefCopyWith<$Res> {
  factory _$EducationSystemRefCopyWith(_EducationSystemRef value, $Res Function(_EducationSystemRef) _then) = __$EducationSystemRefCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameAr, String nameEn
});




}
/// @nodoc
class __$EducationSystemRefCopyWithImpl<$Res>
    implements _$EducationSystemRefCopyWith<$Res> {
  __$EducationSystemRefCopyWithImpl(this._self, this._then);

  final _EducationSystemRef _self;
  final $Res Function(_EducationSystemRef) _then;

/// Create a copy of EducationSystemRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameAr = null,Object? nameEn = null,}) {
  return _then(_EducationSystemRef(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UniversityRef {

 String get id; String get nameAr; String get nameEn; List<FacultyRef> get faculties;
/// Create a copy of UniversityRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniversityRefCopyWith<UniversityRef> get copyWith => _$UniversityRefCopyWithImpl<UniversityRef>(this as UniversityRef, _$identity);

  /// Serializes this UniversityRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniversityRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&const DeepCollectionEquality().equals(other.faculties, faculties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameEn,const DeepCollectionEquality().hash(faculties));

@override
String toString() {
  return 'UniversityRef(id: $id, nameAr: $nameAr, nameEn: $nameEn, faculties: $faculties)';
}


}

/// @nodoc
abstract mixin class $UniversityRefCopyWith<$Res>  {
  factory $UniversityRefCopyWith(UniversityRef value, $Res Function(UniversityRef) _then) = _$UniversityRefCopyWithImpl;
@useResult
$Res call({
 String id, String nameAr, String nameEn, List<FacultyRef> faculties
});




}
/// @nodoc
class _$UniversityRefCopyWithImpl<$Res>
    implements $UniversityRefCopyWith<$Res> {
  _$UniversityRefCopyWithImpl(this._self, this._then);

  final UniversityRef _self;
  final $Res Function(UniversityRef) _then;

/// Create a copy of UniversityRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameAr = null,Object? nameEn = null,Object? faculties = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,faculties: null == faculties ? _self.faculties : faculties // ignore: cast_nullable_to_non_nullable
as List<FacultyRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [UniversityRef].
extension UniversityRefPatterns on UniversityRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UniversityRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UniversityRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UniversityRef value)  $default,){
final _that = this;
switch (_that) {
case _UniversityRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UniversityRef value)?  $default,){
final _that = this;
switch (_that) {
case _UniversityRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameEn,  List<FacultyRef> faculties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UniversityRef() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameEn,_that.faculties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameEn,  List<FacultyRef> faculties)  $default,) {final _that = this;
switch (_that) {
case _UniversityRef():
return $default(_that.id,_that.nameAr,_that.nameEn,_that.faculties);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nameAr,  String nameEn,  List<FacultyRef> faculties)?  $default,) {final _that = this;
switch (_that) {
case _UniversityRef() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameEn,_that.faculties);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UniversityRef implements UniversityRef {
  const _UniversityRef({required this.id, required this.nameAr, required this.nameEn, required final  List<FacultyRef> faculties}): _faculties = faculties;
  factory _UniversityRef.fromJson(Map<String, dynamic> json) => _$UniversityRefFromJson(json);

@override final  String id;
@override final  String nameAr;
@override final  String nameEn;
 final  List<FacultyRef> _faculties;
@override List<FacultyRef> get faculties {
  if (_faculties is EqualUnmodifiableListView) return _faculties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faculties);
}


/// Create a copy of UniversityRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniversityRefCopyWith<_UniversityRef> get copyWith => __$UniversityRefCopyWithImpl<_UniversityRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniversityRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UniversityRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&const DeepCollectionEquality().equals(other._faculties, _faculties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameEn,const DeepCollectionEquality().hash(_faculties));

@override
String toString() {
  return 'UniversityRef(id: $id, nameAr: $nameAr, nameEn: $nameEn, faculties: $faculties)';
}


}

/// @nodoc
abstract mixin class _$UniversityRefCopyWith<$Res> implements $UniversityRefCopyWith<$Res> {
  factory _$UniversityRefCopyWith(_UniversityRef value, $Res Function(_UniversityRef) _then) = __$UniversityRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String nameAr, String nameEn, List<FacultyRef> faculties
});




}
/// @nodoc
class __$UniversityRefCopyWithImpl<$Res>
    implements _$UniversityRefCopyWith<$Res> {
  __$UniversityRefCopyWithImpl(this._self, this._then);

  final _UniversityRef _self;
  final $Res Function(_UniversityRef) _then;

/// Create a copy of UniversityRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameAr = null,Object? nameEn = null,Object? faculties = null,}) {
  return _then(_UniversityRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,faculties: null == faculties ? _self._faculties : faculties // ignore: cast_nullable_to_non_nullable
as List<FacultyRef>,
  ));
}


}


/// @nodoc
mixin _$FacultyRef {

 String get id; String get nameAr; String get nameEn; List<StudyYearRef> get years;
/// Create a copy of FacultyRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacultyRefCopyWith<FacultyRef> get copyWith => _$FacultyRefCopyWithImpl<FacultyRef>(this as FacultyRef, _$identity);

  /// Serializes this FacultyRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacultyRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&const DeepCollectionEquality().equals(other.years, years));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameEn,const DeepCollectionEquality().hash(years));

@override
String toString() {
  return 'FacultyRef(id: $id, nameAr: $nameAr, nameEn: $nameEn, years: $years)';
}


}

/// @nodoc
abstract mixin class $FacultyRefCopyWith<$Res>  {
  factory $FacultyRefCopyWith(FacultyRef value, $Res Function(FacultyRef) _then) = _$FacultyRefCopyWithImpl;
@useResult
$Res call({
 String id, String nameAr, String nameEn, List<StudyYearRef> years
});




}
/// @nodoc
class _$FacultyRefCopyWithImpl<$Res>
    implements $FacultyRefCopyWith<$Res> {
  _$FacultyRefCopyWithImpl(this._self, this._then);

  final FacultyRef _self;
  final $Res Function(FacultyRef) _then;

/// Create a copy of FacultyRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameAr = null,Object? nameEn = null,Object? years = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as List<StudyYearRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [FacultyRef].
extension FacultyRefPatterns on FacultyRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacultyRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacultyRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacultyRef value)  $default,){
final _that = this;
switch (_that) {
case _FacultyRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacultyRef value)?  $default,){
final _that = this;
switch (_that) {
case _FacultyRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameEn,  List<StudyYearRef> years)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacultyRef() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameEn,_that.years);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameEn,  List<StudyYearRef> years)  $default,) {final _that = this;
switch (_that) {
case _FacultyRef():
return $default(_that.id,_that.nameAr,_that.nameEn,_that.years);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nameAr,  String nameEn,  List<StudyYearRef> years)?  $default,) {final _that = this;
switch (_that) {
case _FacultyRef() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameEn,_that.years);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacultyRef implements FacultyRef {
  const _FacultyRef({required this.id, required this.nameAr, required this.nameEn, required final  List<StudyYearRef> years}): _years = years;
  factory _FacultyRef.fromJson(Map<String, dynamic> json) => _$FacultyRefFromJson(json);

@override final  String id;
@override final  String nameAr;
@override final  String nameEn;
 final  List<StudyYearRef> _years;
@override List<StudyYearRef> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}


/// Create a copy of FacultyRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacultyRefCopyWith<_FacultyRef> get copyWith => __$FacultyRefCopyWithImpl<_FacultyRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacultyRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacultyRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&const DeepCollectionEquality().equals(other._years, _years));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameEn,const DeepCollectionEquality().hash(_years));

@override
String toString() {
  return 'FacultyRef(id: $id, nameAr: $nameAr, nameEn: $nameEn, years: $years)';
}


}

/// @nodoc
abstract mixin class _$FacultyRefCopyWith<$Res> implements $FacultyRefCopyWith<$Res> {
  factory _$FacultyRefCopyWith(_FacultyRef value, $Res Function(_FacultyRef) _then) = __$FacultyRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String nameAr, String nameEn, List<StudyYearRef> years
});




}
/// @nodoc
class __$FacultyRefCopyWithImpl<$Res>
    implements _$FacultyRefCopyWith<$Res> {
  __$FacultyRefCopyWithImpl(this._self, this._then);

  final _FacultyRef _self;
  final $Res Function(_FacultyRef) _then;

/// Create a copy of FacultyRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameAr = null,Object? nameEn = null,Object? years = null,}) {
  return _then(_FacultyRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,years: null == years ? _self._years : years // ignore: cast_nullable_to_non_nullable
as List<StudyYearRef>,
  ));
}


}


/// @nodoc
mixin _$StudyYearRef {

 String get id; int get yearNumber; String get status;
/// Create a copy of StudyYearRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyYearRefCopyWith<StudyYearRef> get copyWith => _$StudyYearRefCopyWithImpl<StudyYearRef>(this as StudyYearRef, _$identity);

  /// Serializes this StudyYearRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyYearRef&&(identical(other.id, id) || other.id == id)&&(identical(other.yearNumber, yearNumber) || other.yearNumber == yearNumber)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearNumber,status);

@override
String toString() {
  return 'StudyYearRef(id: $id, yearNumber: $yearNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class $StudyYearRefCopyWith<$Res>  {
  factory $StudyYearRefCopyWith(StudyYearRef value, $Res Function(StudyYearRef) _then) = _$StudyYearRefCopyWithImpl;
@useResult
$Res call({
 String id, int yearNumber, String status
});




}
/// @nodoc
class _$StudyYearRefCopyWithImpl<$Res>
    implements $StudyYearRefCopyWith<$Res> {
  _$StudyYearRefCopyWithImpl(this._self, this._then);

  final StudyYearRef _self;
  final $Res Function(StudyYearRef) _then;

/// Create a copy of StudyYearRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearNumber = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearNumber: null == yearNumber ? _self.yearNumber : yearNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyYearRef].
extension StudyYearRefPatterns on StudyYearRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyYearRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyYearRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyYearRef value)  $default,){
final _that = this;
switch (_that) {
case _StudyYearRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyYearRef value)?  $default,){
final _that = this;
switch (_that) {
case _StudyYearRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearNumber,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyYearRef() when $default != null:
return $default(_that.id,_that.yearNumber,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearNumber,  String status)  $default,) {final _that = this;
switch (_that) {
case _StudyYearRef():
return $default(_that.id,_that.yearNumber,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearNumber,  String status)?  $default,) {final _that = this;
switch (_that) {
case _StudyYearRef() when $default != null:
return $default(_that.id,_that.yearNumber,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyYearRef implements StudyYearRef {
  const _StudyYearRef({required this.id, required this.yearNumber, required this.status});
  factory _StudyYearRef.fromJson(Map<String, dynamic> json) => _$StudyYearRefFromJson(json);

@override final  String id;
@override final  int yearNumber;
@override final  String status;

/// Create a copy of StudyYearRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyYearRefCopyWith<_StudyYearRef> get copyWith => __$StudyYearRefCopyWithImpl<_StudyYearRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyYearRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyYearRef&&(identical(other.id, id) || other.id == id)&&(identical(other.yearNumber, yearNumber) || other.yearNumber == yearNumber)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearNumber,status);

@override
String toString() {
  return 'StudyYearRef(id: $id, yearNumber: $yearNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class _$StudyYearRefCopyWith<$Res> implements $StudyYearRefCopyWith<$Res> {
  factory _$StudyYearRefCopyWith(_StudyYearRef value, $Res Function(_StudyYearRef) _then) = __$StudyYearRefCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearNumber, String status
});




}
/// @nodoc
class __$StudyYearRefCopyWithImpl<$Res>
    implements _$StudyYearRefCopyWith<$Res> {
  __$StudyYearRefCopyWithImpl(this._self, this._then);

  final _StudyYearRef _self;
  final $Res Function(_StudyYearRef) _then;

/// Create a copy of StudyYearRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearNumber = null,Object? status = null,}) {
  return _then(_StudyYearRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearNumber: null == yearNumber ? _self.yearNumber : yearNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Avatar {

 String get id; String get url;
/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarCopyWith<Avatar> get copyWith => _$AvatarCopyWithImpl<Avatar>(this as Avatar, _$identity);

  /// Serializes this Avatar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Avatar&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url);

@override
String toString() {
  return 'Avatar(id: $id, url: $url)';
}


}

/// @nodoc
abstract mixin class $AvatarCopyWith<$Res>  {
  factory $AvatarCopyWith(Avatar value, $Res Function(Avatar) _then) = _$AvatarCopyWithImpl;
@useResult
$Res call({
 String id, String url
});




}
/// @nodoc
class _$AvatarCopyWithImpl<$Res>
    implements $AvatarCopyWith<$Res> {
  _$AvatarCopyWithImpl(this._self, this._then);

  final Avatar _self;
  final $Res Function(Avatar) _then;

/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Avatar].
extension AvatarPatterns on Avatar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Avatar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Avatar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Avatar value)  $default,){
final _that = this;
switch (_that) {
case _Avatar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Avatar value)?  $default,){
final _that = this;
switch (_that) {
case _Avatar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Avatar() when $default != null:
return $default(_that.id,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url)  $default,) {final _that = this;
switch (_that) {
case _Avatar():
return $default(_that.id,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url)?  $default,) {final _that = this;
switch (_that) {
case _Avatar() when $default != null:
return $default(_that.id,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Avatar implements Avatar {
  const _Avatar({required this.id, required this.url});
  factory _Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

@override final  String id;
@override final  String url;

/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarCopyWith<_Avatar> get copyWith => __$AvatarCopyWithImpl<_Avatar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Avatar&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url);

@override
String toString() {
  return 'Avatar(id: $id, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AvatarCopyWith<$Res> implements $AvatarCopyWith<$Res> {
  factory _$AvatarCopyWith(_Avatar value, $Res Function(_Avatar) _then) = __$AvatarCopyWithImpl;
@override @useResult
$Res call({
 String id, String url
});




}
/// @nodoc
class __$AvatarCopyWithImpl<$Res>
    implements _$AvatarCopyWith<$Res> {
  __$AvatarCopyWithImpl(this._self, this._then);

  final _Avatar _self;
  final $Res Function(_Avatar) _then;

/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,}) {
  return _then(_Avatar(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CursorPage<T> {

 List<T> get items; String? get nextCursor; bool get hasMore;
/// Create a copy of CursorPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CursorPageCopyWith<T, CursorPage<T>> get copyWith => _$CursorPageCopyWithImpl<T, CursorPage<T>>(this as CursorPage<T>, _$identity);

  /// Serializes this CursorPage to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CursorPage<T>&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'CursorPage<$T>(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $CursorPageCopyWith<T,$Res>  {
  factory $CursorPageCopyWith(CursorPage<T> value, $Res Function(CursorPage<T>) _then) = _$CursorPageCopyWithImpl;
@useResult
$Res call({
 List<T> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$CursorPageCopyWithImpl<T,$Res>
    implements $CursorPageCopyWith<T, $Res> {
  _$CursorPageCopyWithImpl(this._self, this._then);

  final CursorPage<T> _self;
  final $Res Function(CursorPage<T>) _then;

/// Create a copy of CursorPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CursorPage].
extension CursorPagePatterns<T> on CursorPage<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CursorPage<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CursorPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CursorPage<T> value)  $default,){
final _that = this;
switch (_that) {
case _CursorPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CursorPage<T> value)?  $default,){
final _that = this;
switch (_that) {
case _CursorPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items,  String? nextCursor,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CursorPage() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items,  String? nextCursor,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _CursorPage():
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items,  String? nextCursor,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _CursorPage() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _CursorPage<T> implements CursorPage<T> {
  const _CursorPage({required final  List<T> items, this.nextCursor, required this.hasMore}): _items = items;
  factory _CursorPage.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$CursorPageFromJson(json,fromJsonT);

 final  List<T> _items;
@override List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;
@override final  bool hasMore;

/// Create a copy of CursorPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CursorPageCopyWith<T, _CursorPage<T>> get copyWith => __$CursorPageCopyWithImpl<T, _CursorPage<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$CursorPageToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CursorPage<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'CursorPage<$T>(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$CursorPageCopyWith<T,$Res> implements $CursorPageCopyWith<T, $Res> {
  factory _$CursorPageCopyWith(_CursorPage<T> value, $Res Function(_CursorPage<T>) _then) = __$CursorPageCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class __$CursorPageCopyWithImpl<T,$Res>
    implements _$CursorPageCopyWith<T, $Res> {
  __$CursorPageCopyWithImpl(this._self, this._then);

  final _CursorPage<T> _self;
  final $Res Function(_CursorPage<T>) _then;

/// Create a copy of CursorPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_CursorPage<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
