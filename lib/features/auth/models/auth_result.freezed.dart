// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AuthResult _$AuthResultFromJson(
  Map<String, dynamic> json
) {
        switch (json['result']) {
                  case 'authenticated':
          return AuthenticatedResult.fromJson(
            json
          );
                case 'registrationRequired':
          return RegistrationRequiredResult.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'result',
  'AuthResult',
  'Invalid union type "${json['result']}"!'
);
        }
      
}

/// @nodoc
mixin _$AuthResult {



  /// Serializes this AuthResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResult);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthResult()';
}


}

/// @nodoc
class $AuthResultCopyWith<$Res>  {
$AuthResultCopyWith(AuthResult _, $Res Function(AuthResult) __);
}


/// Adds pattern-matching-related methods to [AuthResult].
extension AuthResultPatterns on AuthResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthenticatedResult value)?  authenticated,TResult Function( RegistrationRequiredResult value)?  registrationRequired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthenticatedResult() when authenticated != null:
return authenticated(_that);case RegistrationRequiredResult() when registrationRequired != null:
return registrationRequired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthenticatedResult value)  authenticated,required TResult Function( RegistrationRequiredResult value)  registrationRequired,}){
final _that = this;
switch (_that) {
case AuthenticatedResult():
return authenticated(_that);case RegistrationRequiredResult():
return registrationRequired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthenticatedResult value)?  authenticated,TResult? Function( RegistrationRequiredResult value)?  registrationRequired,}){
final _that = this;
switch (_that) {
case AuthenticatedResult() when authenticated != null:
return authenticated(_that);case RegistrationRequiredResult() when registrationRequired != null:
return registrationRequired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TokenPair tokens,  Map<String, dynamic> profile, @JsonKey(includeIfNull: false)  bool? inviteCodeApplied)?  authenticated,TResult Function( String registrationToken,  int expiresInSeconds)?  registrationRequired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthenticatedResult() when authenticated != null:
return authenticated(_that.tokens,_that.profile,_that.inviteCodeApplied);case RegistrationRequiredResult() when registrationRequired != null:
return registrationRequired(_that.registrationToken,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TokenPair tokens,  Map<String, dynamic> profile, @JsonKey(includeIfNull: false)  bool? inviteCodeApplied)  authenticated,required TResult Function( String registrationToken,  int expiresInSeconds)  registrationRequired,}) {final _that = this;
switch (_that) {
case AuthenticatedResult():
return authenticated(_that.tokens,_that.profile,_that.inviteCodeApplied);case RegistrationRequiredResult():
return registrationRequired(_that.registrationToken,_that.expiresInSeconds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TokenPair tokens,  Map<String, dynamic> profile, @JsonKey(includeIfNull: false)  bool? inviteCodeApplied)?  authenticated,TResult? Function( String registrationToken,  int expiresInSeconds)?  registrationRequired,}) {final _that = this;
switch (_that) {
case AuthenticatedResult() when authenticated != null:
return authenticated(_that.tokens,_that.profile,_that.inviteCodeApplied);case RegistrationRequiredResult() when registrationRequired != null:
return registrationRequired(_that.registrationToken,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class AuthenticatedResult implements AuthResult {
  const AuthenticatedResult({required this.tokens, required final  Map<String, dynamic> profile, @JsonKey(includeIfNull: false) this.inviteCodeApplied, final  String? $type}): _profile = profile,$type = $type ?? 'authenticated';
  factory AuthenticatedResult.fromJson(Map<String, dynamic> json) => _$AuthenticatedResultFromJson(json);

 final  TokenPair tokens;
 final  Map<String, dynamic> _profile;
 Map<String, dynamic> get profile {
  if (_profile is EqualUnmodifiableMapView) return _profile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_profile);
}

@JsonKey(includeIfNull: false) final  bool? inviteCodeApplied;

@JsonKey(name: 'result')
final String $type;


/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedResultCopyWith<AuthenticatedResult> get copyWith => _$AuthenticatedResultCopyWithImpl<AuthenticatedResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticatedResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticatedResult&&(identical(other.tokens, tokens) || other.tokens == tokens)&&const DeepCollectionEquality().equals(other._profile, _profile)&&(identical(other.inviteCodeApplied, inviteCodeApplied) || other.inviteCodeApplied == inviteCodeApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokens,const DeepCollectionEquality().hash(_profile),inviteCodeApplied);

@override
String toString() {
  return 'AuthResult.authenticated(tokens: $tokens, profile: $profile, inviteCodeApplied: $inviteCodeApplied)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedResultCopyWith<$Res> implements $AuthResultCopyWith<$Res> {
  factory $AuthenticatedResultCopyWith(AuthenticatedResult value, $Res Function(AuthenticatedResult) _then) = _$AuthenticatedResultCopyWithImpl;
@useResult
$Res call({
 TokenPair tokens, Map<String, dynamic> profile,@JsonKey(includeIfNull: false) bool? inviteCodeApplied
});


$TokenPairCopyWith<$Res> get tokens;

}
/// @nodoc
class _$AuthenticatedResultCopyWithImpl<$Res>
    implements $AuthenticatedResultCopyWith<$Res> {
  _$AuthenticatedResultCopyWithImpl(this._self, this._then);

  final AuthenticatedResult _self;
  final $Res Function(AuthenticatedResult) _then;

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tokens = null,Object? profile = null,Object? inviteCodeApplied = freezed,}) {
  return _then(AuthenticatedResult(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as TokenPair,profile: null == profile ? _self._profile : profile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,inviteCodeApplied: freezed == inviteCodeApplied ? _self.inviteCodeApplied : inviteCodeApplied // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenPairCopyWith<$Res> get tokens {
  
  return $TokenPairCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class RegistrationRequiredResult implements AuthResult {
  const RegistrationRequiredResult({required this.registrationToken, required this.expiresInSeconds, final  String? $type}): $type = $type ?? 'registrationRequired';
  factory RegistrationRequiredResult.fromJson(Map<String, dynamic> json) => _$RegistrationRequiredResultFromJson(json);

 final  String registrationToken;
 final  int expiresInSeconds;

@JsonKey(name: 'result')
final String $type;


/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationRequiredResultCopyWith<RegistrationRequiredResult> get copyWith => _$RegistrationRequiredResultCopyWithImpl<RegistrationRequiredResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationRequiredResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationRequiredResult&&(identical(other.registrationToken, registrationToken) || other.registrationToken == registrationToken)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationToken,expiresInSeconds);

@override
String toString() {
  return 'AuthResult.registrationRequired(registrationToken: $registrationToken, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $RegistrationRequiredResultCopyWith<$Res> implements $AuthResultCopyWith<$Res> {
  factory $RegistrationRequiredResultCopyWith(RegistrationRequiredResult value, $Res Function(RegistrationRequiredResult) _then) = _$RegistrationRequiredResultCopyWithImpl;
@useResult
$Res call({
 String registrationToken, int expiresInSeconds
});




}
/// @nodoc
class _$RegistrationRequiredResultCopyWithImpl<$Res>
    implements $RegistrationRequiredResultCopyWith<$Res> {
  _$RegistrationRequiredResultCopyWithImpl(this._self, this._then);

  final RegistrationRequiredResult _self;
  final $Res Function(RegistrationRequiredResult) _then;

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? registrationToken = null,Object? expiresInSeconds = null,}) {
  return _then(RegistrationRequiredResult(
registrationToken: null == registrationToken ? _self.registrationToken : registrationToken // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
