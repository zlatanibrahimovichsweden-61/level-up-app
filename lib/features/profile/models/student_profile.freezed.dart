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
 List<EntitlementState> get entitlements; DateTime get createdAt;/// adr-114 — present ONLY while a deletion request is pending.
///
/// **Absence is the flag, and the contract is emphatic that it is absence
/// and not null** (`openapi.yaml:2430-2436`: *"Absent otherwise — never
/// `null`"*). Both decode to null here, which is correct and not a
/// weakening: `json['pendingDeletion'] as Map?` is null for an absent key
/// and for an explicit null alike, and the client's question is only ever
/// "is a deletion pending?".
///
/// Not in the contract's `required` list, so it is nullable with no
/// default — a default would have to invent either a window or the absence
/// of one.
 PendingDeletion? get pendingDeletion;
/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileCopyWith<StudentProfile> get copyWith => _$StudentProfileCopyWithImpl<StudentProfile>(this as StudentProfile, _$identity);

  /// Serializes this StudentProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.track, track) || other.track == track)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.geography, geography) || other.geography == geography)&&(identical(other.school, school) || other.school == school)&&(identical(other.university, university) || other.university == university)&&(identical(other.points, points) || other.points == points)&&(identical(other.level, level) || other.level == level)&&(identical(other.badges, badges) || other.badges == badges)&&(identical(other.privacy, privacy) || other.privacy == privacy)&&const DeepCollectionEquality().equals(other.entitlements, entitlements)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.pendingDeletion, pendingDeletion) || other.pendingDeletion == pendingDeletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,track,name,phone,email,dateOfBirth,avatar,geography,school,university,points,level,badges,privacy,const DeepCollectionEquality().hash(entitlements),createdAt,pendingDeletion);

@override
String toString() {
  return 'StudentProfile(id: $id, track: $track, name: $name, phone: $phone, email: $email, dateOfBirth: $dateOfBirth, avatar: $avatar, geography: $geography, school: $school, university: $university, points: $points, level: $level, badges: $badges, privacy: $privacy, entitlements: $entitlements, createdAt: $createdAt, pendingDeletion: $pendingDeletion)';
}


}

/// @nodoc
abstract mixin class $StudentProfileCopyWith<$Res>  {
  factory $StudentProfileCopyWith(StudentProfile value, $Res Function(StudentProfile) _then) = _$StudentProfileCopyWithImpl;
@useResult
$Res call({
 String id, Track track, String name, String phone, String? email,@DateOnlyConverter() DateTime dateOfBirth, ProfileAvatar avatar, ProfileGeography geography, ProfileSchool? school, ProfileUniversity? university, ProfilePoints points, int level, int badges, ProfilePrivacy privacy, List<EntitlementState> entitlements, DateTime createdAt, PendingDeletion? pendingDeletion
});


$ProfileAvatarCopyWith<$Res> get avatar;$ProfileGeographyCopyWith<$Res> get geography;$ProfileSchoolCopyWith<$Res>? get school;$ProfileUniversityCopyWith<$Res>? get university;$ProfilePointsCopyWith<$Res> get points;$ProfilePrivacyCopyWith<$Res> get privacy;$PendingDeletionCopyWith<$Res>? get pendingDeletion;

}
/// @nodoc
class _$StudentProfileCopyWithImpl<$Res>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._self, this._then);

  final StudentProfile _self;
  final $Res Function(StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? track = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? dateOfBirth = null,Object? avatar = null,Object? geography = null,Object? school = freezed,Object? university = freezed,Object? points = null,Object? level = null,Object? badges = null,Object? privacy = null,Object? entitlements = null,Object? createdAt = null,Object? pendingDeletion = freezed,}) {
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
as DateTime,pendingDeletion: freezed == pendingDeletion ? _self.pendingDeletion : pendingDeletion // ignore: cast_nullable_to_non_nullable
as PendingDeletion?,
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
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingDeletionCopyWith<$Res>? get pendingDeletion {
    if (_self.pendingDeletion == null) {
    return null;
  }

  return $PendingDeletionCopyWith<$Res>(_self.pendingDeletion!, (value) {
    return _then(_self.copyWith(pendingDeletion: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Track track,  String name,  String phone,  String? email, @DateOnlyConverter()  DateTime dateOfBirth,  ProfileAvatar avatar,  ProfileGeography geography,  ProfileSchool? school,  ProfileUniversity? university,  ProfilePoints points,  int level,  int badges,  ProfilePrivacy privacy,  List<EntitlementState> entitlements,  DateTime createdAt,  PendingDeletion? pendingDeletion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.id,_that.track,_that.name,_that.phone,_that.email,_that.dateOfBirth,_that.avatar,_that.geography,_that.school,_that.university,_that.points,_that.level,_that.badges,_that.privacy,_that.entitlements,_that.createdAt,_that.pendingDeletion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Track track,  String name,  String phone,  String? email, @DateOnlyConverter()  DateTime dateOfBirth,  ProfileAvatar avatar,  ProfileGeography geography,  ProfileSchool? school,  ProfileUniversity? university,  ProfilePoints points,  int level,  int badges,  ProfilePrivacy privacy,  List<EntitlementState> entitlements,  DateTime createdAt,  PendingDeletion? pendingDeletion)  $default,) {final _that = this;
switch (_that) {
case _StudentProfile():
return $default(_that.id,_that.track,_that.name,_that.phone,_that.email,_that.dateOfBirth,_that.avatar,_that.geography,_that.school,_that.university,_that.points,_that.level,_that.badges,_that.privacy,_that.entitlements,_that.createdAt,_that.pendingDeletion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Track track,  String name,  String phone,  String? email, @DateOnlyConverter()  DateTime dateOfBirth,  ProfileAvatar avatar,  ProfileGeography geography,  ProfileSchool? school,  ProfileUniversity? university,  ProfilePoints points,  int level,  int badges,  ProfilePrivacy privacy,  List<EntitlementState> entitlements,  DateTime createdAt,  PendingDeletion? pendingDeletion)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.id,_that.track,_that.name,_that.phone,_that.email,_that.dateOfBirth,_that.avatar,_that.geography,_that.school,_that.university,_that.points,_that.level,_that.badges,_that.privacy,_that.entitlements,_that.createdAt,_that.pendingDeletion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentProfile implements StudentProfile {
  const _StudentProfile({required this.id, required this.track, required this.name, required this.phone, this.email, @DateOnlyConverter() required this.dateOfBirth, required this.avatar, required this.geography, this.school, this.university, required this.points, required this.level, required this.badges, required this.privacy, required final  List<EntitlementState> entitlements, required this.createdAt, this.pendingDeletion}): _entitlements = entitlements;
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
/// adr-114 — present ONLY while a deletion request is pending.
///
/// **Absence is the flag, and the contract is emphatic that it is absence
/// and not null** (`openapi.yaml:2430-2436`: *"Absent otherwise — never
/// `null`"*). Both decode to null here, which is correct and not a
/// weakening: `json['pendingDeletion'] as Map?` is null for an absent key
/// and for an explicit null alike, and the client's question is only ever
/// "is a deletion pending?".
///
/// Not in the contract's `required` list, so it is nullable with no
/// default — a default would have to invent either a window or the absence
/// of one.
@override final  PendingDeletion? pendingDeletion;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.track, track) || other.track == track)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.geography, geography) || other.geography == geography)&&(identical(other.school, school) || other.school == school)&&(identical(other.university, university) || other.university == university)&&(identical(other.points, points) || other.points == points)&&(identical(other.level, level) || other.level == level)&&(identical(other.badges, badges) || other.badges == badges)&&(identical(other.privacy, privacy) || other.privacy == privacy)&&const DeepCollectionEquality().equals(other._entitlements, _entitlements)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.pendingDeletion, pendingDeletion) || other.pendingDeletion == pendingDeletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,track,name,phone,email,dateOfBirth,avatar,geography,school,university,points,level,badges,privacy,const DeepCollectionEquality().hash(_entitlements),createdAt,pendingDeletion);

@override
String toString() {
  return 'StudentProfile(id: $id, track: $track, name: $name, phone: $phone, email: $email, dateOfBirth: $dateOfBirth, avatar: $avatar, geography: $geography, school: $school, university: $university, points: $points, level: $level, badges: $badges, privacy: $privacy, entitlements: $entitlements, createdAt: $createdAt, pendingDeletion: $pendingDeletion)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileCopyWith<$Res> implements $StudentProfileCopyWith<$Res> {
  factory _$StudentProfileCopyWith(_StudentProfile value, $Res Function(_StudentProfile) _then) = __$StudentProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, Track track, String name, String phone, String? email,@DateOnlyConverter() DateTime dateOfBirth, ProfileAvatar avatar, ProfileGeography geography, ProfileSchool? school, ProfileUniversity? university, ProfilePoints points, int level, int badges, ProfilePrivacy privacy, List<EntitlementState> entitlements, DateTime createdAt, PendingDeletion? pendingDeletion
});


@override $ProfileAvatarCopyWith<$Res> get avatar;@override $ProfileGeographyCopyWith<$Res> get geography;@override $ProfileSchoolCopyWith<$Res>? get school;@override $ProfileUniversityCopyWith<$Res>? get university;@override $ProfilePointsCopyWith<$Res> get points;@override $ProfilePrivacyCopyWith<$Res> get privacy;@override $PendingDeletionCopyWith<$Res>? get pendingDeletion;

}
/// @nodoc
class __$StudentProfileCopyWithImpl<$Res>
    implements _$StudentProfileCopyWith<$Res> {
  __$StudentProfileCopyWithImpl(this._self, this._then);

  final _StudentProfile _self;
  final $Res Function(_StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? track = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? dateOfBirth = null,Object? avatar = null,Object? geography = null,Object? school = freezed,Object? university = freezed,Object? points = null,Object? level = null,Object? badges = null,Object? privacy = null,Object? entitlements = null,Object? createdAt = null,Object? pendingDeletion = freezed,}) {
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
as DateTime,pendingDeletion: freezed == pendingDeletion ? _self.pendingDeletion : pendingDeletion // ignore: cast_nullable_to_non_nullable
as PendingDeletion?,
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
}/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingDeletionCopyWith<$Res>? get pendingDeletion {
    if (_self.pendingDeletion == null) {
    return null;
  }

  return $PendingDeletionCopyWith<$Res>(_self.pendingDeletion!, (value) {
    return _then(_self.copyWith(pendingDeletion: value));
  });
}
}


/// @nodoc
mixin _$PendingDeletion {

 DateTime get effectiveAt;
/// Create a copy of PendingDeletion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingDeletionCopyWith<PendingDeletion> get copyWith => _$PendingDeletionCopyWithImpl<PendingDeletion>(this as PendingDeletion, _$identity);

  /// Serializes this PendingDeletion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingDeletion&&(identical(other.effectiveAt, effectiveAt) || other.effectiveAt == effectiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveAt);

@override
String toString() {
  return 'PendingDeletion(effectiveAt: $effectiveAt)';
}


}

/// @nodoc
abstract mixin class $PendingDeletionCopyWith<$Res>  {
  factory $PendingDeletionCopyWith(PendingDeletion value, $Res Function(PendingDeletion) _then) = _$PendingDeletionCopyWithImpl;
@useResult
$Res call({
 DateTime effectiveAt
});




}
/// @nodoc
class _$PendingDeletionCopyWithImpl<$Res>
    implements $PendingDeletionCopyWith<$Res> {
  _$PendingDeletionCopyWithImpl(this._self, this._then);

  final PendingDeletion _self;
  final $Res Function(PendingDeletion) _then;

/// Create a copy of PendingDeletion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? effectiveAt = null,}) {
  return _then(_self.copyWith(
effectiveAt: null == effectiveAt ? _self.effectiveAt : effectiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingDeletion].
extension PendingDeletionPatterns on PendingDeletion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingDeletion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingDeletion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingDeletion value)  $default,){
final _that = this;
switch (_that) {
case _PendingDeletion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingDeletion value)?  $default,){
final _that = this;
switch (_that) {
case _PendingDeletion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime effectiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingDeletion() when $default != null:
return $default(_that.effectiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime effectiveAt)  $default,) {final _that = this;
switch (_that) {
case _PendingDeletion():
return $default(_that.effectiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime effectiveAt)?  $default,) {final _that = this;
switch (_that) {
case _PendingDeletion() when $default != null:
return $default(_that.effectiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingDeletion implements PendingDeletion {
  const _PendingDeletion({required this.effectiveAt});
  factory _PendingDeletion.fromJson(Map<String, dynamic> json) => _$PendingDeletionFromJson(json);

@override final  DateTime effectiveAt;

/// Create a copy of PendingDeletion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingDeletionCopyWith<_PendingDeletion> get copyWith => __$PendingDeletionCopyWithImpl<_PendingDeletion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingDeletionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingDeletion&&(identical(other.effectiveAt, effectiveAt) || other.effectiveAt == effectiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveAt);

@override
String toString() {
  return 'PendingDeletion(effectiveAt: $effectiveAt)';
}


}

/// @nodoc
abstract mixin class _$PendingDeletionCopyWith<$Res> implements $PendingDeletionCopyWith<$Res> {
  factory _$PendingDeletionCopyWith(_PendingDeletion value, $Res Function(_PendingDeletion) _then) = __$PendingDeletionCopyWithImpl;
@override @useResult
$Res call({
 DateTime effectiveAt
});




}
/// @nodoc
class __$PendingDeletionCopyWithImpl<$Res>
    implements _$PendingDeletionCopyWith<$Res> {
  __$PendingDeletionCopyWithImpl(this._self, this._then);

  final _PendingDeletion _self;
  final $Res Function(_PendingDeletion) _then;

/// Create a copy of PendingDeletion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? effectiveAt = null,}) {
  return _then(_PendingDeletion(
effectiveAt: null == effectiveAt ? _self.effectiveAt : effectiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
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

 String get countryCode; NamedRef? get governorate; ProfileCity get city;
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
 String countryCode, NamedRef? governorate, ProfileCity city
});


$NamedRefCopyWith<$Res>? get governorate;$ProfileCityCopyWith<$Res> get city;

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
as ProfileCity,
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
$ProfileCityCopyWith<$Res> get city {
  
  return $ProfileCityCopyWith<$Res>(_self.city, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  NamedRef? governorate,  ProfileCity city)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  NamedRef? governorate,  ProfileCity city)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  NamedRef? governorate,  ProfileCity city)?  $default,) {final _that = this;
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
@override final  ProfileCity city;

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
 String countryCode, NamedRef? governorate, ProfileCity city
});


@override $NamedRefCopyWith<$Res>? get governorate;@override $ProfileCityCopyWith<$Res> get city;

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
as ProfileCity,
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
$ProfileCityCopyWith<$Res> get city {
  
  return $ProfileCityCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}

ProfileCity _$ProfileCityFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'coded':
          return CodedCity.fromJson(
            json
          );
                case 'freeText':
          return FreeTextCity.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ProfileCity',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ProfileCity {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileCity);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileCity()';
}


}

/// @nodoc
class $ProfileCityCopyWith<$Res>  {
$ProfileCityCopyWith(ProfileCity _, $Res Function(ProfileCity) __);
}


/// Adds pattern-matching-related methods to [ProfileCity].
extension ProfileCityPatterns on ProfileCity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CodedCity value)?  coded,TResult Function( FreeTextCity value)?  freeText,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CodedCity() when coded != null:
return coded(_that);case FreeTextCity() when freeText != null:
return freeText(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CodedCity value)  coded,required TResult Function( FreeTextCity value)  freeText,}){
final _that = this;
switch (_that) {
case CodedCity():
return coded(_that);case FreeTextCity():
return freeText(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CodedCity value)?  coded,TResult? Function( FreeTextCity value)?  freeText,}){
final _that = this;
switch (_that) {
case CodedCity() when coded != null:
return coded(_that);case FreeTextCity() when freeText != null:
return freeText(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( NamedRef ref)?  coded,TResult Function( String name)?  freeText,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CodedCity() when coded != null:
return coded(_that.ref);case FreeTextCity() when freeText != null:
return freeText(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( NamedRef ref)  coded,required TResult Function( String name)  freeText,}) {final _that = this;
switch (_that) {
case CodedCity():
return coded(_that.ref);case FreeTextCity():
return freeText(_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( NamedRef ref)?  coded,TResult? Function( String name)?  freeText,}) {final _that = this;
switch (_that) {
case CodedCity() when coded != null:
return coded(_that.ref);case FreeTextCity() when freeText != null:
return freeText(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class CodedCity extends ProfileCity {
  const CodedCity(this.ref, {final  String? $type}): $type = $type ?? 'coded',super._();
  factory CodedCity.fromJson(Map<String, dynamic> json) => _$CodedCityFromJson(json);

 final  NamedRef ref;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ProfileCity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodedCityCopyWith<CodedCity> get copyWith => _$CodedCityCopyWithImpl<CodedCity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodedCity&&(identical(other.ref, ref) || other.ref == ref));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref);

@override
String toString() {
  return 'ProfileCity.coded(ref: $ref)';
}


}

/// @nodoc
abstract mixin class $CodedCityCopyWith<$Res> implements $ProfileCityCopyWith<$Res> {
  factory $CodedCityCopyWith(CodedCity value, $Res Function(CodedCity) _then) = _$CodedCityCopyWithImpl;
@useResult
$Res call({
 NamedRef ref
});


$NamedRefCopyWith<$Res> get ref;

}
/// @nodoc
class _$CodedCityCopyWithImpl<$Res>
    implements $CodedCityCopyWith<$Res> {
  _$CodedCityCopyWithImpl(this._self, this._then);

  final CodedCity _self;
  final $Res Function(CodedCity) _then;

/// Create a copy of ProfileCity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ref = null,}) {
  return _then(CodedCity(
null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as NamedRef,
  ));
}

/// Create a copy of ProfileCity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedRefCopyWith<$Res> get ref {
  
  return $NamedRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}
}

/// @nodoc
@JsonSerializable(createToJson: false)

class FreeTextCity extends ProfileCity {
  const FreeTextCity(this.name, {final  String? $type}): $type = $type ?? 'freeText',super._();
  factory FreeTextCity.fromJson(Map<String, dynamic> json) => _$FreeTextCityFromJson(json);

 final  String name;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ProfileCity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreeTextCityCopyWith<FreeTextCity> get copyWith => _$FreeTextCityCopyWithImpl<FreeTextCity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreeTextCity&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ProfileCity.freeText(name: $name)';
}


}

/// @nodoc
abstract mixin class $FreeTextCityCopyWith<$Res> implements $ProfileCityCopyWith<$Res> {
  factory $FreeTextCityCopyWith(FreeTextCity value, $Res Function(FreeTextCity) _then) = _$FreeTextCityCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$FreeTextCityCopyWithImpl<$Res>
    implements $FreeTextCityCopyWith<$Res> {
  _$FreeTextCityCopyWithImpl(this._self, this._then);

  final FreeTextCity _self;
  final $Res Function(FreeTextCity) _then;

/// Create a copy of ProfileCity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(FreeTextCity(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProfileSchool {

/// The coded school. Null when the student did not pick one — **Egypt
/// included** since adr-028 §2 made `schoolId` optional for everyone. There
/// is no free-text counterpart: v1.1 removed `schoolName` from the contract
/// outright, so a missing school is simply a missing school.
///
/// This field was already nullable under v1.0 (where null meant "non-Egypt,
/// typed a name instead"), so the skipped-school case needed no change —
/// the same shape now carries a different meaning.
 NamedRef? get school; String get stage; String get educationSystem;/// adr-165 D7, contract 3.22.0-m1 — the ACTUAL parent-report status,
/// `active` | `inactive`. School track only; the whole block is null for
/// university students.
///
/// **Optional on the wire**: it is NOT in the contract's
/// `required: [stage, educationSystem]` (`openapi.yaml:2397`), so a server
/// that has not started sending it decodes to null rather than throwing.
///
/// Kept a wire `String` rather than a generated enum, for the same reason
/// [ProfileAvatar.type] is: it is a two-value set the UI does not branch on
/// today, and hard-typing it would only add a way for the whole profile
/// parse — and with it Home — to throw on a value nobody reads. There is
/// deliberately no `pending` value; the contract rules one out explicitly,
/// because no parent-side opt-in exists to pend on.
 String? get parentReportStatus;
/// Create a copy of ProfileSchool
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSchoolCopyWith<ProfileSchool> get copyWith => _$ProfileSchoolCopyWithImpl<ProfileSchool>(this as ProfileSchool, _$identity);

  /// Serializes this ProfileSchool to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSchool&&(identical(other.school, school) || other.school == school)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem)&&(identical(other.parentReportStatus, parentReportStatus) || other.parentReportStatus == parentReportStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,school,stage,educationSystem,parentReportStatus);

@override
String toString() {
  return 'ProfileSchool(school: $school, stage: $stage, educationSystem: $educationSystem, parentReportStatus: $parentReportStatus)';
}


}

/// @nodoc
abstract mixin class $ProfileSchoolCopyWith<$Res>  {
  factory $ProfileSchoolCopyWith(ProfileSchool value, $Res Function(ProfileSchool) _then) = _$ProfileSchoolCopyWithImpl;
@useResult
$Res call({
 NamedRef? school, String stage, String educationSystem, String? parentReportStatus
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
@pragma('vm:prefer-inline') @override $Res call({Object? school = freezed,Object? stage = null,Object? educationSystem = null,Object? parentReportStatus = freezed,}) {
  return _then(_self.copyWith(
school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as NamedRef?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,educationSystem: null == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String,parentReportStatus: freezed == parentReportStatus ? _self.parentReportStatus : parentReportStatus // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NamedRef? school,  String stage,  String educationSystem,  String? parentReportStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSchool() when $default != null:
return $default(_that.school,_that.stage,_that.educationSystem,_that.parentReportStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NamedRef? school,  String stage,  String educationSystem,  String? parentReportStatus)  $default,) {final _that = this;
switch (_that) {
case _ProfileSchool():
return $default(_that.school,_that.stage,_that.educationSystem,_that.parentReportStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NamedRef? school,  String stage,  String educationSystem,  String? parentReportStatus)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSchool() when $default != null:
return $default(_that.school,_that.stage,_that.educationSystem,_that.parentReportStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileSchool implements ProfileSchool {
  const _ProfileSchool({this.school, required this.stage, required this.educationSystem, this.parentReportStatus});
  factory _ProfileSchool.fromJson(Map<String, dynamic> json) => _$ProfileSchoolFromJson(json);

/// The coded school. Null when the student did not pick one — **Egypt
/// included** since adr-028 §2 made `schoolId` optional for everyone. There
/// is no free-text counterpart: v1.1 removed `schoolName` from the contract
/// outright, so a missing school is simply a missing school.
///
/// This field was already nullable under v1.0 (where null meant "non-Egypt,
/// typed a name instead"), so the skipped-school case needed no change —
/// the same shape now carries a different meaning.
@override final  NamedRef? school;
@override final  String stage;
@override final  String educationSystem;
/// adr-165 D7, contract 3.22.0-m1 — the ACTUAL parent-report status,
/// `active` | `inactive`. School track only; the whole block is null for
/// university students.
///
/// **Optional on the wire**: it is NOT in the contract's
/// `required: [stage, educationSystem]` (`openapi.yaml:2397`), so a server
/// that has not started sending it decodes to null rather than throwing.
///
/// Kept a wire `String` rather than a generated enum, for the same reason
/// [ProfileAvatar.type] is: it is a two-value set the UI does not branch on
/// today, and hard-typing it would only add a way for the whole profile
/// parse — and with it Home — to throw on a value nobody reads. There is
/// deliberately no `pending` value; the contract rules one out explicitly,
/// because no parent-side opt-in exists to pend on.
@override final  String? parentReportStatus;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSchool&&(identical(other.school, school) || other.school == school)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.educationSystem, educationSystem) || other.educationSystem == educationSystem)&&(identical(other.parentReportStatus, parentReportStatus) || other.parentReportStatus == parentReportStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,school,stage,educationSystem,parentReportStatus);

@override
String toString() {
  return 'ProfileSchool(school: $school, stage: $stage, educationSystem: $educationSystem, parentReportStatus: $parentReportStatus)';
}


}

/// @nodoc
abstract mixin class _$ProfileSchoolCopyWith<$Res> implements $ProfileSchoolCopyWith<$Res> {
  factory _$ProfileSchoolCopyWith(_ProfileSchool value, $Res Function(_ProfileSchool) _then) = __$ProfileSchoolCopyWithImpl;
@override @useResult
$Res call({
 NamedRef? school, String stage, String educationSystem, String? parentReportStatus
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
@override @pragma('vm:prefer-inline') $Res call({Object? school = freezed,Object? stage = null,Object? educationSystem = null,Object? parentReportStatus = freezed,}) {
  return _then(_ProfileSchool(
school: freezed == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as NamedRef?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,educationSystem: null == educationSystem ? _self.educationSystem : educationSystem // ignore: cast_nullable_to_non_nullable
as String,parentReportStatus: freezed == parentReportStatus ? _self.parentReportStatus : parentReportStatus // ignore: cast_nullable_to_non_nullable
as String?,
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

 NamedRef get university; NamedRef get faculty; int get yearNumber;/// adr-036 term signals, added in contract 1.2.0-m1. **Optional AND
/// nullable, and null is NORMAL** — null for every school-track resource,
/// and null on a university profile during the summer gap or when the
/// cohort has no schedule row. `termId` is opaque (adr-026 §7): never
/// hardcode one and never derive an order from it. `termNumber` is the
/// only orderable/labellable term signal on the wire — term NAMES are
/// never sent, so any label is rendered client-side (adr-026 §5).
///
/// No default, deliberately: a defaulted `termNumber` would fabricate an
/// ordinal the server never sent.
 String? get termId; int? get termNumber;
/// Create a copy of ProfileUniversity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUniversityCopyWith<ProfileUniversity> get copyWith => _$ProfileUniversityCopyWithImpl<ProfileUniversity>(this as ProfileUniversity, _$identity);

  /// Serializes this ProfileUniversity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUniversity&&(identical(other.university, university) || other.university == university)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearNumber, yearNumber) || other.yearNumber == yearNumber)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,university,faculty,yearNumber,termId,termNumber);

@override
String toString() {
  return 'ProfileUniversity(university: $university, faculty: $faculty, yearNumber: $yearNumber, termId: $termId, termNumber: $termNumber)';
}


}

/// @nodoc
abstract mixin class $ProfileUniversityCopyWith<$Res>  {
  factory $ProfileUniversityCopyWith(ProfileUniversity value, $Res Function(ProfileUniversity) _then) = _$ProfileUniversityCopyWithImpl;
@useResult
$Res call({
 NamedRef university, NamedRef faculty, int yearNumber, String? termId, int? termNumber
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
@pragma('vm:prefer-inline') @override $Res call({Object? university = null,Object? faculty = null,Object? yearNumber = null,Object? termId = freezed,Object? termNumber = freezed,}) {
  return _then(_self.copyWith(
university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as NamedRef,faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as NamedRef,yearNumber: null == yearNumber ? _self.yearNumber : yearNumber // ignore: cast_nullable_to_non_nullable
as int,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NamedRef university,  NamedRef faculty,  int yearNumber,  String? termId,  int? termNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUniversity() when $default != null:
return $default(_that.university,_that.faculty,_that.yearNumber,_that.termId,_that.termNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NamedRef university,  NamedRef faculty,  int yearNumber,  String? termId,  int? termNumber)  $default,) {final _that = this;
switch (_that) {
case _ProfileUniversity():
return $default(_that.university,_that.faculty,_that.yearNumber,_that.termId,_that.termNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NamedRef university,  NamedRef faculty,  int yearNumber,  String? termId,  int? termNumber)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUniversity() when $default != null:
return $default(_that.university,_that.faculty,_that.yearNumber,_that.termId,_that.termNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileUniversity implements ProfileUniversity {
  const _ProfileUniversity({required this.university, required this.faculty, required this.yearNumber, this.termId, this.termNumber});
  factory _ProfileUniversity.fromJson(Map<String, dynamic> json) => _$ProfileUniversityFromJson(json);

@override final  NamedRef university;
@override final  NamedRef faculty;
@override final  int yearNumber;
/// adr-036 term signals, added in contract 1.2.0-m1. **Optional AND
/// nullable, and null is NORMAL** — null for every school-track resource,
/// and null on a university profile during the summer gap or when the
/// cohort has no schedule row. `termId` is opaque (adr-026 §7): never
/// hardcode one and never derive an order from it. `termNumber` is the
/// only orderable/labellable term signal on the wire — term NAMES are
/// never sent, so any label is rendered client-side (adr-026 §5).
///
/// No default, deliberately: a defaulted `termNumber` would fabricate an
/// ordinal the server never sent.
@override final  String? termId;
@override final  int? termNumber;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUniversity&&(identical(other.university, university) || other.university == university)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearNumber, yearNumber) || other.yearNumber == yearNumber)&&(identical(other.termId, termId) || other.termId == termId)&&(identical(other.termNumber, termNumber) || other.termNumber == termNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,university,faculty,yearNumber,termId,termNumber);

@override
String toString() {
  return 'ProfileUniversity(university: $university, faculty: $faculty, yearNumber: $yearNumber, termId: $termId, termNumber: $termNumber)';
}


}

/// @nodoc
abstract mixin class _$ProfileUniversityCopyWith<$Res> implements $ProfileUniversityCopyWith<$Res> {
  factory _$ProfileUniversityCopyWith(_ProfileUniversity value, $Res Function(_ProfileUniversity) _then) = __$ProfileUniversityCopyWithImpl;
@override @useResult
$Res call({
 NamedRef university, NamedRef faculty, int yearNumber, String? termId, int? termNumber
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
@override @pragma('vm:prefer-inline') $Res call({Object? university = null,Object? faculty = null,Object? yearNumber = null,Object? termId = freezed,Object? termNumber = freezed,}) {
  return _then(_ProfileUniversity(
university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as NamedRef,faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as NamedRef,yearNumber: null == yearNumber ? _self.yearNumber : yearNumber // ignore: cast_nullable_to_non_nullable
as int,termId: freezed == termId ? _self.termId : termId // ignore: cast_nullable_to_non_nullable
as String?,termNumber: freezed == termNumber ? _self.termNumber : termNumber // ignore: cast_nullable_to_non_nullable
as int?,
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
