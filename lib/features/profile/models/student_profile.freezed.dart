// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentProfile {

 String get id; Track get track; String get name; String get phone;/// Contract-optional, and never a login channel (adr-019).
 String? get email;@DateOnlyConverter() DateTime get dateOfBirth; ProfileAvatar get avatar; ProfileGeography get geography;/// School-track block — null for university students.
 ProfileSchool? get school;/// University-track block — null for school students.
 ProfileUniversity? get university; ProfilePoints get points;/// 1–12, thresholds every 500 points. SERVER-AUTHORITATIVE — display only.
 int get level;/// Post-level-12 badges (every 5,000 points; first at 11,000).
/// SERVER-AUTHORITATIVE — display only.
 int get badges; ProfilePrivacy get privacy;/// Read-only embed for first paint. The paywall source of truth is
/// `GET /me/entitlements`.
 List<EntitlementState> get entitlements; DateTime get createdAt;
/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileCopyWith<StudentProfile> get copyWith => _$StudentProfileCopyWithImpl<StudentProfile>(this as StudentProfile, _$identity);

  /// Serializes this StudentProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.track, track) || other.track == track)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.geography, geography) || other.geography == geography)&&(identical(other.school, school) || other.school == school)&&(identical(other.university, university) || other.university == university)&&(identical(other.points, points) || other.points == points)&&(identical(other.level, level) || other.level == level)&&(identical(other.badges, badges) || other.badges == badges)&&(identical(other.privacy, privacy) || other.privacy == privacy)&&const DeepCollectionEquality().equals(other.entitlements, entitlements)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,track,name,phone,email,dateOfBirth,avatar,geography,school,university,points,level,badges,privacy,const DeepCollectionEquality().hash(entitlements),createdAt);

@override
String toString() {
  return 'StudentProfile(id: $id, track: $track, name: $name, phone: $phone, email: $email, dateOfBirth: $dateOfBirth, avatar: $avatar, geography: $geography, school: $school, university: $university, points: $points, level: $level, badges: $badges, privacy: $privacy, entitlements: $entitlements, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudentProfileCopyWith<$Res>  {
  factory $StudentProfileCopyWith(StudentProfile value, $Res Function(StudentProfile) _then) = _$StudentProfileCopyWithImpl;
@useResult
$Res call({
 String id, Track track, String name, String phone, String? email,@DateOnlyConverter() DateTime dateOfBirth, ProfileAvatar avatar, ProfileGeography geography, ProfileSchool? school, ProfileUniversity? university, ProfilePoints points, int level, int badges, ProfilePrivacy privacy, List<EntitlementState> entitlements, DateTime createdAt
});


$ProfileAvatarCopyWith<$Res> get avatar;$ProfileGeographyCopyWith<$Res> get geography;$ProfileSchoolCopyWith<$Res>? get school;$ProfileUniversityCopyWith<$Res>? get university;$ProfilePointsCopyWith<$Res> get points;$ProfilePrivacyCopyWith<$Res> get privacy;

}
/// @nodoc
class _$StudentProfileCopyWithImpl<$Res>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._self, this._then);

  final StudentProfile _self;
  final $Res Function(StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? track = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? dateOfBirth = null,Object? avatar = null,Object? geography = null,Object? school = freezed,Object? university = freezed,Object? points = null,Object? level = null,Object? badges = null,Object? privacy = null,Object? entitlements = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as ProfileAvatar,geography: null == geography ? _self.geography : geography // ignore: cast_nullable_to_non_nullable
as ProfileGeography,school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as ProfileSchool?,university: freezed == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as ProfileUniversity?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as ProfilePoints,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as int,privacy: null == privacy ? _self.privacy : privacy // ignore: cast_nullable_to_non_nullable
as ProfilePrivacy,entitlements: null == entitlements ? _self.entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as List<EntitlementState>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileAvatarCopyWith<$Res> get avatar {
  
  return $ProfileAvatarCopyWith<$Res>(_self.avatar, (value) {
    return _then(_self.copyWith(avatar: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileGeographyCopyWith<$Res> get geography {
  
  return $ProfileGeographyCopyWith<$Res>(_self.geography, (value) {
    return _then(_self.copyWith(geography: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSchoolCopyWith<$Res>? get school {
    if (_self.school == null) {
    return null;
  }

  return $ProfileSchoolCopyWith<$Res>(_self.school!, (value) {
    return _then(_self.copyWith(school: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileUniversityCopyWith<$Res>? get university {
    if (_self.university == null) {
    return null;
  }

  return $ProfileUniversityCopyWith<$Res>(_self.university!, (value) {
    return _then(_self.copyWith(university: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfilePointsCopyWith<$Res> get points {
  
  return $ProfilePointsCopyWith<$Res>(_self.points, (value) {
    return _then(_self.copyWith(points: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfilePrivacyCopyWith<$Res> get privacy {
  
  return $ProfilePrivacyCopyWith<$Res>(_self.privacy, (value) {
    return _then(_self.copyWith(privacy: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudentProfile].
extension StudentProfilePatterns on StudentProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentProfile value)  $default,){
final _that = this;
switch (_that) {
case _StudentProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentProfile value)?  $default,){
final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Track track,  String name,  String phone,  String? email, @DateOnlyConverter()  DateTime dateOfBirth,  ProfileAvatar avatar,  ProfileGeography geography,  ProfileSchool? school,  ProfileUniversity? university,  ProfilePoints points,  int level,  int badges,  ProfilePrivacy privacy,  List<EntitlementState> entitlements,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.id,_that.track,_that.name,_that.phone,_that.email,_that.dateOfBirth,_that.avatar,_that.geography,_that.school,_that.university,_that.points,_that.level,_that.badges,_that.privacy,_that.entitlements,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Track track,  String name,  String phone,  String? email, @DateOnlyConverter()  DateTime dateOfBirth,  ProfileAvatar avatar,  ProfileGeography geography,  ProfileSchool? school,  ProfileUniversity? university,  ProfilePoints points,  int level,  int badges,  ProfilePrivacy privacy,  List<EntitlementState> entitlements,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudentProfile():
return $default(_that.id,_that.track,_that.name,_that.phone,_that.email,_that.dateOfBirth,_that.avatar,_that.geography,_that.school,_that.university,_that.points,_that.level,_that.badges,_that.privacy,_that.entitlements,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Track track,  String name,  String phone,  String? email, @DateOnlyConverter()  DateTime dateOfBirth,  ProfileAvatar avatar,  ProfileGeography geography,  ProfileSchool? school,  ProfileUniversity? university,  ProfilePoints points,  int level,  int badges,  ProfilePrivacy privacy,  List<EntitlementState> entitlements,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.id,_that.track,_that.name,_that.phone,_that.email,_that.dateOfBirth,_that.avatar,_that.geography,_that.school,_that.university,_that.points,_that.level,_that.badges,_that.privacy,_that.entitlements,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentProfile implements StudentProfile {
  const _StudentProfile({required this.id, required this.track, required this.name, required this.phone, this.email, @DateOnlyConverter() required this.dateOfBirth, required this.avatar, required this.geography, this.school, this.university, required this.points, required this.level, required this.badges, required this.privacy, required final  List<EntitlementState> entitlements, required this.createdAt}): _entitlements = entitlements;
  factory _StudentProfile.fromJson(Map<String, dynamic> json) => _$StudentProfileFromJson(json);

@override final  String id;
@override final  Track track;
@override final  String name;
@override final  String phone;
/// Contract-optional, and never a login channel (adr-019).
@override final  String? email;
@override@DateOnlyConverter() final  DateTime dateOfBirth;
@override final  ProfileAvatar avatar;
@override final  ProfileGeography geography;
/// School-track block — null for university students.
@override final  ProfileSchool? school;
/// University-track block — null for school students.
@override final  ProfileUniversity? university;
@override final  ProfilePoints points;
/// 1–12, thresholds every 500 points. SERVER-AUTHORITATIVE — display only.
@override final  int level;
/// Post-level-12 badges (every 5,000 points; first at 11,000).
/// SERVER-AUTHORITATIVE — display only.
@override final  int badges;
@override final  ProfilePrivacy privacy;
/// Read-only embed for first paint. The paywall source of truth is
/// `GET /me/entitlements`.
 final  List<EntitlementState> _entitlements;
/// Read-only embed for first paint. The paywall source of truth is
/// `GET /me/entitlements`.
@override List<EntitlementState> get entitlements {
  if (_entitlements is EqualUnmodifiableListView) return _entitlements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entitlements);
}

@override final  DateTime createdAt;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentProfileCopyWith<_StudentProfile> get copyWith => __$StudentProfileCopyWithImpl<_StudentProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.track, track) || other.track == track)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.geography, geography) || other.geography == geography)&&(identical(other.school, school) || other.school == school)&&(identical(other.university, university) || other.university == university)&&(identical(other.points, points) || other.points == points)&&(identical(other.level, level) || other.level == level)&&(identical(other.badges, badges) || other.badges == badges)&&(identical(other.privacy, privacy) || other.privacy == privacy)&&const DeepCollectionEquality().equals(other._entitlements, _entitlements)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,track,name,phone,email,dateOfBirth,avatar,geography,school,university,points,level,badges,privacy,const DeepCollectionEquality().hash(_entitlements),createdAt);

@override
String toString() {
  return 'StudentProfile(id: $id, track: $track, name: $name, phone: $phone, email: $email, dateOfBirth: $dateOfBirth, avatar: $avatar, geography: $geography, school: $school, university: $university, points: $points, level: $level, badges: $badges, privacy: $privacy, entitlements: $entitlements, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileCopyWith<$Res> implements $StudentProfileCopyWith<$Res> {
  factory _$StudentProfileCopyWith(_StudentProfile value, $Res Function(_StudentProfile) _then) = __$StudentProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, Track track, String name, String phone, String? email,@DateOnlyConverter() DateTime dateOfBirth, ProfileAvatar avatar, ProfileGeography geography, ProfileSchool? school, ProfileUniversity? university, ProfilePoints points, int level, int badges, ProfilePrivacy privacy, List<EntitlementState> entitlements, DateTime createdAt
});


@override $ProfileAvatarCopyWith<$Res> get avatar;@override $ProfileGeographyCopyWith<$Res> get geography;@override $ProfileSchoolCopyWith<$Res>? get school;@override $ProfileUniversityCopyWith<$Res>? get university;@override $ProfilePointsCopyWith<$Res> get points;@override $ProfilePrivacyCopyWith<$Res> get privacy;

}
/// @nodoc
class __$StudentProfileCopyWithImpl<$Res>
    implements _$StudentProfileCopyWith<$Res> {
  __$StudentProfileCopyWithImpl(this._self, this._then);

  final _StudentProfile _self;
  final $Res Function(_StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? track = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? dateOfBirth = null,Object? avatar = null,Object? geography = null,Object? school = freezed,Object? university = freezed,Object? points = null,Object? level = null,Object? badges = null,Object? privacy = null,Object? entitlements = null,Object? createdAt = null,}) {
  return _then(_StudentProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as ProfileAvatar,geography: null == geography ? _self.geography : geography // ignore: cast_nullable_to_non_nullable
as ProfileGeography,school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as ProfileSchool?,university: freezed == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as ProfileUniversity?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as ProfilePoints,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as int,privacy: null == privacy ? _self.privacy : privacy // ignore: cast_nullable_to_non_nullable
as ProfilePrivacy,entitlements: null == entitlements ? _self._entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as List<EntitlementState>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileAvatarCopyWith<$Res> get avatar {
  
  return $ProfileAvatarCopyWith<$Res>(_self.avatar, (value) {
    return _then(_self.copyWith(avatar: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileGeographyCopyWith<$Res> get geography {
  
  return $ProfileGeographyCopyWith<$Res>(_self.geography, (value) {
    return _then(_self.copyWith(geography: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSchoolCopyWith<$Res>? get school {
    if (_self.school == null) {
    return null;
  }

  return $ProfileSchoolCopyWith<$Res>(_self.school!, (value) {
    return _then(_self.copyWith(school: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileUniversityCopyWith<$Res>? get university {
    if (_self.university == null) {
    return null;
  }

  return $ProfileUniversityCopyWith<$Res>(_self.university!, (value) {
    return _then(_self.copyWith(university: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfilePointsCopyWith<$Res> get points {
  
  return $ProfilePointsCopyWith<$Res>(_self.points, (value) {
    return _then(_self.copyWith(points: value));
  });
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfilePrivacyCopyWith<$Res> get privacy {
  
  return $ProfilePrivacyCopyWith<$Res>(_self.privacy, (value) {
    return _then(_self.copyWith(privacy: value));
  });
}
}


/// @nodoc
mixin _$ProfileAvatar {

 String get type;/// Present for default avatars only.
 String? get id; String get url;
/// Create a copy of ProfileAvatar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileAvatarCopyWith<ProfileAvatar> get copyWith => _$ProfileAvatarCopyWithImpl<ProfileAvatar>(this as ProfileAvatar, _$identity);

  /// Serializes this ProfileAvatar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileAvatar&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,url);

@override
String toString() {
  return 'ProfileAvatar(type: $type, id: $id, url: $url)';
}


}

/// @nodoc
abstract mixin class $ProfileAvatarCopyWith<$Res>  {
  factory $ProfileAvatarCopyWith(ProfileAvatar value, $Res Function(ProfileAvatar) _then) = _$ProfileAvatarCopyWithImpl;
@useResult
$Res call({
 String type, String? id, String url
});




}
/// @nodoc
class _$ProfileAvatarCopyWithImpl<$Res>
    implements $ProfileAvatarCopyWith<$Res> {
  _$ProfileAvatarCopyWithImpl(this._self, this._then);

  final ProfileAvatar _self;
  final $Res Function(ProfileAvatar) _then;

/// Create a copy of ProfileAvatar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = freezed,Object? url = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileAvatar].
extension ProfileAvatarPatterns on ProfileAvatar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileAvatar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileAvatar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileAvatar value)  $default,){
final _that = this;
switch (_that) {
case _ProfileAvatar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileAvatar value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileAvatar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? id,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileAvatar() when $default != null:
return $default(_that.type,_that.id,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? id,  String url)  $default,) {final _that = this;
switch (_that) {
case _ProfileAvatar():
return $default(_that.type,_that.id,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? id,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ProfileAvatar() when $default != null:
return $default(_that.type,_that.id,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileAvatar implements ProfileAvatar {
  const _ProfileAvatar({required this.type, this.id, required this.url});
  factory _ProfileAvatar.fromJson(Map<String, dynamic> json) => _$ProfileAvatarFromJson(json);

@override final  String type;
/// Present for default avatars only.
@override final  String? id;
@override final  String url;

/// Create a copy of ProfileAvatar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileAvatarCopyWith<_ProfileAvatar> get copyWith => __$ProfileAvatarCopyWithImpl<_ProfileAvatar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileAvatarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileAvatar&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,url);

@override
String toString() {
  return 'ProfileAvatar(type: $type, id: $id, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ProfileAvatarCopyWith<$Res> implements $ProfileAvatarCopyWith<$Res> {
  factory _$ProfileAvatarCopyWith(_ProfileAvatar value, $Res Function(_ProfileAvatar) _then) = __$ProfileAvatarCopyWithImpl;
@override @useResult
$Res call({
 String type, String? id, String url
});




}
/// @nodoc
class __$ProfileAvatarCopyWithImpl<$Res>
    implements _$ProfileAvatarCopyWith<$Res> {
  __$ProfileAvatarCopyWithImpl(this._self, this._then);

  final _ProfileAvatar _self;
  final $Res Function(_ProfileAvatar) _then;

/// Create a copy of ProfileAvatar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = freezed,Object? url = null,}) {
  return _then(_ProfileAvatar(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProfileGeography {

 String get countryCode; NamedRef? get governorate; NamedRef get city;
/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileGeographyCopyWith<ProfileGeography> get copyWith => _$ProfileGeographyCopyWithImpl<ProfileGeography>(this as ProfileGeography, _$identity);

  /// Serializes this ProfileGeography to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileGeography&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,governorate,city);

@override
String toString() {
  return 'ProfileGeography(countryCode: $countryCode, governorate: $governorate, city: $city)';
}


}

/// @nodoc
abstract mixin class $ProfileGeographyCopyWith<$Res>  {
  factory $ProfileGeographyCopyWith(ProfileGeography value, $Res Function(ProfileGeography) _then) = _$ProfileGeographyCopyWithImpl;
@useResult
$Res call({
 String countryCode, NamedRef? governorate, NamedRef city
});


$NamedRefCopyWith<$Res>? get governorate;$NamedRefCopyWith<$Res> get city;

}
/// @nodoc
class _$ProfileGeographyCopyWithImpl<$Res>
    implements $ProfileGeographyCopyWith<$Res> {
  _$ProfileGeographyCopyWithImpl(this._self, this._then);

  final ProfileGeography _self;
  final $Res Function(ProfileGeography) _then;

/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? governorate = freezed,Object? city = null,}) {
  return _then(_self.copyWith(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as NamedRef?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as NamedRef,
  ));
}
/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get governorate {
    if (_self.governorate == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.governorate!, (value) {
    return _then(_self.copyWith(governorate: value));
  });
}/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get city {
  
  return $NamedRefCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileGeography].
extension ProfileGeographyPatterns on ProfileGeography {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileGeography value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileGeography() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileGeography value)  $default,){
final _that = this;
switch (_that) {
case _ProfileGeography():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileGeography value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileGeography() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  NamedRef? governorate,  NamedRef city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileGeography() when $default != null:
return $default(_that.countryCode,_that.governorate,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  NamedRef? governorate,  NamedRef city)  $default,) {final _that = this;
switch (_that) {
case _ProfileGeography():
return $default(_that.countryCode,_that.governorate,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  NamedRef? governorate,  NamedRef city)?  $default,) {final _that = this;
switch (_that) {
case _ProfileGeography() when $default != null:
return $default(_that.countryCode,_that.governorate,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileGeography implements ProfileGeography {
  const _ProfileGeography({required this.countryCode, this.governorate, required this.city});
  factory _ProfileGeography.fromJson(Map<String, dynamic> json) => _$ProfileGeographyFromJson(json);

@override final  String countryCode;
@override final  NamedRef? governorate;
@override final  NamedRef city;

/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileGeographyCopyWith<_ProfileGeography> get copyWith => __$ProfileGeographyCopyWithImpl<_ProfileGeography>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileGeographyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileGeography&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,governorate,city);

@override
String toString() {
  return 'ProfileGeography(countryCode: $countryCode, governorate: $governorate, city: $city)';
}


}

/// @nodoc
abstract mixin class _$ProfileGeographyCopyWith<$Res> implements $ProfileGeographyCopyWith<$Res> {
  factory _$ProfileGeographyCopyWith(_ProfileGeography value, $Res Function(_ProfileGeography) _then) = __$ProfileGeographyCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, NamedRef? governorate, NamedRef city
});


@override $NamedRefCopyWith<$Res>? get governorate;@override $NamedRefCopyWith<$Res> get city;

}
/// @nodoc
class __$ProfileGeographyCopyWithImpl<$Res>
    implements _$ProfileGeographyCopyWith<$Res> {
  __$ProfileGeographyCopyWithImpl(this._self, this._then);

  final _ProfileGeography _self;
  final $Res Function(_ProfileGeography) _then;

/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? governorate = freezed,Object? city = null,}) {
  return _then(_ProfileGeography(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,governorate: freezed == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as NamedRef?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as NamedRef,
  ));
}

/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get governorate {
    if (_self.governorate == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.governorate!, (value) {
    return _then(_self.copyWith(governorate: value));
  });
}/// Create a copy of ProfileGeography
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get city {
  
  return $NamedRefCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// @nodoc
mixin _$ProfileSchool {

/// The coded school (Egypt). Null when the student typed a free-text name.
 NamedRef? get school;/// Free-text school name (non-Egypt).
 String? get schoolName; String get stage; String get educationSystem;
/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSchoolCopyWith<ProfileSchool> get copyWith => _$ProfileSchoolCopyWithImpl<ProfileSchool>(this as ProfileSchool, _$identity);

  /// Serializes this ProfileSchool to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSchool&&(identical(other.school, school) || other.school == school)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,school,schoolName,stage,educationSystem);

@override
String toString() {
  return 'ProfileSchool(school: $school, schoolName: $schoolName, stage: $stage, educationSystem: $educationSystem)';
}


}

/// @nodoc
abstract mixin class $ProfileSchoolCopyWith<$Res>  {
  factory $ProfileSchoolCopyWith(ProfileSchool value, $Res Function(ProfileSchool) _then) = _$ProfileSchoolCopyWithImpl;
@useResult
$Res call({
 NamedRef? school, String? schoolName, String stage, String educationSystem
});


$NamedRefCopyWith<$Res>? get school;

}
/// @nodoc
class _$ProfileSchoolCopyWithImpl<$Res>
    implements $ProfileSchoolCopyWith<$Res> {
  _$ProfileSchoolCopyWithImpl(this._self, this._then);

  final ProfileSchool _self;
  final $Res Function(ProfileSchool) _then;

/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? school = freezed,Object? schoolName = freezed,Object? stage = null,Object? educationSystem = null,}) {
  return _then(_self.copyWith(
school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as NamedRef?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,educationSystem: null == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get school {
    if (_self.school == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.school!, (value) {
    return _then(_self.copyWith(school: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileSchool].
extension ProfileSchoolPatterns on ProfileSchool {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSchool value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSchool() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSchool value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSchool():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSchool value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSchool() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NamedRef? school,  String? schoolName,  String stage,  String educationSystem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSchool() when $default != null:
return $default(_that.school,_that.schoolName,_that.stage,_that.educationSystem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NamedRef? school,  String? schoolName,  String stage,  String educationSystem)  $default,) {final _that = this;
switch (_that) {
case _ProfileSchool():
return $default(_that.school,_that.schoolName,_that.stage,_that.educationSystem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NamedRef? school,  String? schoolName,  String stage,  String educationSystem)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSchool() when $default != null:
return $default(_that.school,_that.schoolName,_that.stage,_that.educationSystem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileSchool implements ProfileSchool {
  const _ProfileSchool({this.school, this.schoolName, required this.stage, required this.educationSystem});
  factory _ProfileSchool.fromJson(Map<String, dynamic> json) => _$ProfileSchoolFromJson(json);

/// The coded school (Egypt). Null when the student typed a free-text name.
@override final  NamedRef? school;
/// Free-text school name (non-Egypt).
@override final  String? schoolName;
@override final  String stage;
@override final  String educationSystem;

/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSchoolCopyWith<_ProfileSchool> get copyWith => __$ProfileSchoolCopyWithImpl<_ProfileSchool>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileSchoolToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSchool&&(identical(other.school, school) || other.school == school)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,school,schoolName,stage,educationSystem);

@override
String toString() {
  return 'ProfileSchool(school: $school, schoolName: $schoolName, stage: $stage, educationSystem: $educationSystem)';
}


}

/// @nodoc
abstract mixin class _$ProfileSchoolCopyWith<$Res> implements $ProfileSchoolCopyWith<$Res> {
  factory _$ProfileSchoolCopyWith(_ProfileSchool value, $Res Function(_ProfileSchool) _then) = __$ProfileSchoolCopyWithImpl;
@override @useResult
$Res call({
 NamedRef? school, String? schoolName, String stage, String educationSystem
});


@override $NamedRefCopyWith<$Res>? get school;

}
/// @nodoc
class __$ProfileSchoolCopyWithImpl<$Res>
    implements _$ProfileSchoolCopyWith<$Res> {
  __$ProfileSchoolCopyWithImpl(this._self, this._then);

  final _ProfileSchool _self;
  final $Res Function(_ProfileSchool) _then;

/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? school = freezed,Object? schoolName = freezed,Object? stage = null,Object? educationSystem = null,}) {
  return _then(_ProfileSchool(
school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as NamedRef?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,educationSystem: null == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res>? get school {
    if (_self.school == null) {
    return null;
  }

  return $NamedRefCopyWith<$Res>(_self.school!, (value) {
    return _then(_self.copyWith(school: value));
  });
}
}


/// @nodoc
mixin _$ProfileUniversity {

 NamedRef get university; NamedRef get faculty; int get yearNumber;
/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUniversityCopyWith<ProfileUniversity> get copyWith => _$ProfileUniversityCopyWithImpl<ProfileUniversity>(this as ProfileUniversity, _$identity);

  /// Serializes this ProfileUniversity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUniversity&&(identical(other.university, university) || other.university == university)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearNumber, yearNumber) || other.yearNumber == yearNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,university,faculty,yearNumber);

@override
String toString() {
  return 'ProfileUniversity(university: $university, faculty: $faculty, yearNumber: $yearNumber)';
}


}

/// @nodoc
abstract mixin class $ProfileUniversityCopyWith<$Res>  {
  factory $ProfileUniversityCopyWith(ProfileUniversity value, $Res Function(ProfileUniversity) _then) = _$ProfileUniversityCopyWithImpl;
@useResult
$Res call({
 NamedRef university, NamedRef faculty, int yearNumber
});


$NamedRefCopyWith<$Res> get university;$NamedRefCopyWith<$Res> get faculty;

}
/// @nodoc
class _$ProfileUniversityCopyWithImpl<$Res>
    implements $ProfileUniversityCopyWith<$Res> {
  _$ProfileUniversityCopyWithImpl(this._self, this._then);

  final ProfileUniversity _self;
  final $Res Function(ProfileUniversity) _then;

/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? university = null,Object? faculty = null,Object? yearNumber = null,}) {
  return _then(_self.copyWith(
university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as NamedRef,faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as NamedRef,yearNumber: null == yearNumber ? _self.yearNumber : yearNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get university {
  
  return $NamedRefCopyWith<$Res>(_self.university, (value) {
    return _then(_self.copyWith(university: value));
  });
}/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get faculty {
  
  return $NamedRefCopyWith<$Res>(_self.faculty, (value) {
    return _then(_self.copyWith(faculty: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileUniversity].
extension ProfileUniversityPatterns on ProfileUniversity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileUniversity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileUniversity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileUniversity value)  $default,){
final _that = this;
switch (_that) {
case _ProfileUniversity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileUniversity value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileUniversity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NamedRef university,  NamedRef faculty,  int yearNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUniversity() when $default != null:
return $default(_that.university,_that.faculty,_that.yearNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NamedRef university,  NamedRef faculty,  int yearNumber)  $default,) {final _that = this;
switch (_that) {
case _ProfileUniversity():
return $default(_that.university,_that.faculty,_that.yearNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NamedRef university,  NamedRef faculty,  int yearNumber)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUniversity() when $default != null:
return $default(_that.university,_that.faculty,_that.yearNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileUniversity implements ProfileUniversity {
  const _ProfileUniversity({required this.university, required this.faculty, required this.yearNumber});
  factory _ProfileUniversity.fromJson(Map<String, dynamic> json) => _$ProfileUniversityFromJson(json);

@override final  NamedRef university;
@override final  NamedRef faculty;
@override final  int yearNumber;

/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileUniversityCopyWith<_ProfileUniversity> get copyWith => __$ProfileUniversityCopyWithImpl<_ProfileUniversity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileUniversityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUniversity&&(identical(other.university, university) || other.university == university)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearNumber, yearNumber) || other.yearNumber == yearNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,university,faculty,yearNumber);

@override
String toString() {
  return 'ProfileUniversity(university: $university, faculty: $faculty, yearNumber: $yearNumber)';
}


}

/// @nodoc
abstract mixin class _$ProfileUniversityCopyWith<$Res> implements $ProfileUniversityCopyWith<$Res> {
  factory _$ProfileUniversityCopyWith(_ProfileUniversity value, $Res Function(_ProfileUniversity) _then) = __$ProfileUniversityCopyWithImpl;
@override @useResult
$Res call({
 NamedRef university, NamedRef faculty, int yearNumber
});


@override $NamedRefCopyWith<$Res> get university;@override $NamedRefCopyWith<$Res> get faculty;

}
/// @nodoc
class __$ProfileUniversityCopyWithImpl<$Res>
    implements _$ProfileUniversityCopyWith<$Res> {
  __$ProfileUniversityCopyWithImpl(this._self, this._then);

  final _ProfileUniversity _self;
  final $Res Function(_ProfileUniversity) _then;

/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? university = null,Object? faculty = null,Object? yearNumber = null,}) {
  return _then(_ProfileUniversity(
university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as NamedRef,faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as NamedRef,yearNumber: null == yearNumber ? _self.yearNumber : yearNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get university {
  
  return $NamedRefCopyWith<$Res>(_self.university, (value) {
    return _then(_self.copyWith(university: value));
  });
}/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get faculty {
  
  return $NamedRefCopyWith<$Res>(_self.faculty, (value) {
    return _then(_self.copyWith(faculty: value));
  });
}
}


/// @nodoc
mixin _$ProfilePoints {

 int get school; int get university; int get total;
/// Create a copy of ProfilePoints
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilePointsCopyWith<ProfilePoints> get copyWith => _$ProfilePointsCopyWithImpl<ProfilePoints>(this as ProfilePoints, _$identity);

  /// Serializes this ProfilePoints to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilePoints&&(identical(other.school, school) || other.school == school)&&(identical(other.university, university) || other.university == university)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,school,university,total);

@override
String toString() {
  return 'ProfilePoints(school: $school, university: $university, total: $total)';
}


}

/// @nodoc
abstract mixin class $ProfilePointsCopyWith<$Res>  {
  factory $ProfilePointsCopyWith(ProfilePoints value, $Res Function(ProfilePoints) _then) = _$ProfilePointsCopyWithImpl;
@useResult
$Res call({
 int school, int university, int total
});




}
/// @nodoc
class _$ProfilePointsCopyWithImpl<$Res>
    implements $ProfilePointsCopyWith<$Res> {
  _$ProfilePointsCopyWithImpl(this._self, this._then);

  final ProfilePoints _self;
  final $Res Function(ProfilePoints) _then;

/// Create a copy of ProfilePoints
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? school = null,Object? university = null,Object? total = null,}) {
  return _then(_self.copyWith(
school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as int,university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfilePoints].
extension ProfilePointsPatterns on ProfilePoints {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfilePoints value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfilePoints() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfilePoints value)  $default,){
final _that = this;
switch (_that) {
case _ProfilePoints():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfilePoints value)?  $default,){
final _that = this;
switch (_that) {
case _ProfilePoints() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int school,  int university,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfilePoints() when $default != null:
return $default(_that.school,_that.university,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int school,  int university,  int total)  $default,) {final _that = this;
switch (_that) {
case _ProfilePoints():
return $default(_that.school,_that.university,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int school,  int university,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ProfilePoints() when $default != null:
return $default(_that.school,_that.university,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfilePoints implements ProfilePoints {
  const _ProfilePoints({required this.school, required this.university, required this.total});
  factory _ProfilePoints.fromJson(Map<String, dynamic> json) => _$ProfilePointsFromJson(json);

@override final  int school;
@override final  int university;
@override final  int total;

/// Create a copy of ProfilePoints
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfilePointsCopyWith<_ProfilePoints> get copyWith => __$ProfilePointsCopyWithImpl<_ProfilePoints>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfilePointsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfilePoints&&(identical(other.school, school) || other.school == school)&&(identical(other.university, university) || other.university == university)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,school,university,total);

@override
String toString() {
  return 'ProfilePoints(school: $school, university: $university, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ProfilePointsCopyWith<$Res> implements $ProfilePointsCopyWith<$Res> {
  factory _$ProfilePointsCopyWith(_ProfilePoints value, $Res Function(_ProfilePoints) _then) = __$ProfilePointsCopyWithImpl;
@override @useResult
$Res call({
 int school, int university, int total
});




}
/// @nodoc
class __$ProfilePointsCopyWithImpl<$Res>
    implements _$ProfilePointsCopyWith<$Res> {
  __$ProfilePointsCopyWithImpl(this._self, this._then);

  final _ProfilePoints _self;
  final $Res Function(_ProfilePoints) _then;

/// Create a copy of ProfilePoints
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? school = null,Object? university = null,Object? total = null,}) {
  return _then(_ProfilePoints(
school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as int,university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProfilePrivacy {

 bool get leaderboardVisible; bool get scoreHidden;
/// Create a copy of ProfilePrivacy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilePrivacyCopyWith<ProfilePrivacy> get copyWith => _$ProfilePrivacyCopyWithImpl<ProfilePrivacy>(this as ProfilePrivacy, _$identity);

  /// Serializes this ProfilePrivacy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilePrivacy&&(identical(other.leaderboardVisible, leaderboardVisible) || other.leaderboardVisible == leaderboardVisible)&&(identical(other.scoreHidden, scoreHidden) || other.scoreHidden == scoreHidden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leaderboardVisible,scoreHidden);

@override
String toString() {
  return 'ProfilePrivacy(leaderboardVisible: $leaderboardVisible, scoreHidden: $scoreHidden)';
}


}

/// @nodoc
abstract mixin class $ProfilePrivacyCopyWith<$Res>  {
  factory $ProfilePrivacyCopyWith(ProfilePrivacy value, $Res Function(ProfilePrivacy) _then) = _$ProfilePrivacyCopyWithImpl;
@useResult
$Res call({
 bool leaderboardVisible, bool scoreHidden
});




}
/// @nodoc
class _$ProfilePrivacyCopyWithImpl<$Res>
    implements $ProfilePrivacyCopyWith<$Res> {
  _$ProfilePrivacyCopyWithImpl(this._self, this._then);

  final ProfilePrivacy _self;
  final $Res Function(ProfilePrivacy) _then;

/// Create a copy of ProfilePrivacy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leaderboardVisible = null,Object? scoreHidden = null,}) {
  return _then(_self.copyWith(
leaderboardVisible: null == leaderboardVisible ? _self.leaderboardVisible : leaderboardVisible // ignore: cast_nullable_to_non_nullable
as bool,scoreHidden: null == scoreHidden ? _self.scoreHidden : scoreHidden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfilePrivacy].
extension ProfilePrivacyPatterns on ProfilePrivacy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfilePrivacy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfilePrivacy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfilePrivacy value)  $default,){
final _that = this;
switch (_that) {
case _ProfilePrivacy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfilePrivacy value)?  $default,){
final _that = this;
switch (_that) {
case _ProfilePrivacy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool leaderboardVisible,  bool scoreHidden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfilePrivacy() when $default != null:
return $default(_that.leaderboardVisible,_that.scoreHidden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool leaderboardVisible,  bool scoreHidden)  $default,) {final _that = this;
switch (_that) {
case _ProfilePrivacy():
return $default(_that.leaderboardVisible,_that.scoreHidden);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool leaderboardVisible,  bool scoreHidden)?  $default,) {final _that = this;
switch (_that) {
case _ProfilePrivacy() when $default != null:
return $default(_that.leaderboardVisible,_that.scoreHidden);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfilePrivacy implements ProfilePrivacy {
  const _ProfilePrivacy({required this.leaderboardVisible, required this.scoreHidden});
  factory _ProfilePrivacy.fromJson(Map<String, dynamic> json) => _$ProfilePrivacyFromJson(json);

@override final  bool leaderboardVisible;
@override final  bool scoreHidden;

/// Create a copy of ProfilePrivacy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfilePrivacyCopyWith<_ProfilePrivacy> get copyWith => __$ProfilePrivacyCopyWithImpl<_ProfilePrivacy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfilePrivacyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfilePrivacy&&(identical(other.leaderboardVisible, leaderboardVisible) || other.leaderboardVisible == leaderboardVisible)&&(identical(other.scoreHidden, scoreHidden) || other.scoreHidden == scoreHidden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leaderboardVisible,scoreHidden);

@override
String toString() {
  return 'ProfilePrivacy(leaderboardVisible: $leaderboardVisible, scoreHidden: $scoreHidden)';
}


}

/// @nodoc
abstract mixin class _$ProfilePrivacyCopyWith<$Res> implements $ProfilePrivacyCopyWith<$Res> {
  factory _$ProfilePrivacyCopyWith(_ProfilePrivacy value, $Res Function(_ProfilePrivacy) _then) = __$ProfilePrivacyCopyWithImpl;
@override @useResult
$Res call({
 bool leaderboardVisible, bool scoreHidden
});




}
/// @nodoc
class __$ProfilePrivacyCopyWithImpl<$Res>
    implements _$ProfilePrivacyCopyWith<$Res> {
  __$ProfilePrivacyCopyWithImpl(this._self, this._then);

  final _ProfilePrivacy _self;
  final $Res Function(_ProfilePrivacy) _then;

/// Create a copy of ProfilePrivacy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaderboardVisible = null,Object? scoreHidden = null,}) {
  return _then(_ProfilePrivacy(
leaderboardVisible: null == leaderboardVisible ? _self.leaderboardVisible : leaderboardVisible // ignore: cast_nullable_to_non_nullable
as bool,scoreHidden: null == scoreHidden ? _self.scoreHidden : scoreHidden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
