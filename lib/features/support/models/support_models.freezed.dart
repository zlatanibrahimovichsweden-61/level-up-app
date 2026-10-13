// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportTicketSummary {

 String get ticketId; String get reference; String get subject;/// The wire status, verbatim. Read it through [knownStatus] / [isClosed];
/// never switch exhaustively on the string.
 String get status; DateTime get createdAt;/// The ticket's creation or its latest reply, whichever is later - the
/// list's sort key.
 DateTime get lastActivityAt;
/// Create a copy of SupportTicketSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportTicketSummaryCopyWith<SupportTicketSummary> get copyWith => _$SupportTicketSummaryCopyWithImpl<SupportTicketSummary>(this as SupportTicketSummary, _$identity);

  /// Serializes this SupportTicketSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportTicketSummary&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ticketId,reference,subject,status,createdAt,lastActivityAt);

@override
String toString() {
  return 'SupportTicketSummary(ticketId: $ticketId, reference: $reference, subject: $subject, status: $status, createdAt: $createdAt, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class $SupportTicketSummaryCopyWith<$Res>  {
  factory $SupportTicketSummaryCopyWith(SupportTicketSummary value, $Res Function(SupportTicketSummary) _then) = _$SupportTicketSummaryCopyWithImpl;
@useResult
$Res call({
 String ticketId, String reference, String subject, String status, DateTime createdAt, DateTime lastActivityAt
});




}
/// @nodoc
class _$SupportTicketSummaryCopyWithImpl<$Res>
    implements $SupportTicketSummaryCopyWith<$Res> {
  _$SupportTicketSummaryCopyWithImpl(this._self, this._then);

  final SupportTicketSummary _self;
  final $Res Function(SupportTicketSummary) _then;

/// Create a copy of SupportTicketSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticketId = null,Object? reference = null,Object? subject = null,Object? status = null,Object? createdAt = null,Object? lastActivityAt = null,}) {
  return _then(_self.copyWith(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportTicketSummary].
extension SupportTicketSummaryPatterns on SupportTicketSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportTicketSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportTicketSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportTicketSummary value)  $default,){
final _that = this;
switch (_that) {
case _SupportTicketSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportTicketSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SupportTicketSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticketId,  String reference,  String subject,  String status,  DateTime createdAt,  DateTime lastActivityAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportTicketSummary() when $default != null:
return $default(_that.ticketId,_that.reference,_that.subject,_that.status,_that.createdAt,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticketId,  String reference,  String subject,  String status,  DateTime createdAt,  DateTime lastActivityAt)  $default,) {final _that = this;
switch (_that) {
case _SupportTicketSummary():
return $default(_that.ticketId,_that.reference,_that.subject,_that.status,_that.createdAt,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticketId,  String reference,  String subject,  String status,  DateTime createdAt,  DateTime lastActivityAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportTicketSummary() when $default != null:
return $default(_that.ticketId,_that.reference,_that.subject,_that.status,_that.createdAt,_that.lastActivityAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportTicketSummary extends SupportTicketSummary {
  const _SupportTicketSummary({required this.ticketId, required this.reference, required this.subject, required this.status, required this.createdAt, required this.lastActivityAt}): super._();
  factory _SupportTicketSummary.fromJson(Map<String, dynamic> json) => _$SupportTicketSummaryFromJson(json);

@override final  String ticketId;
@override final  String reference;
@override final  String subject;
/// The wire status, verbatim. Read it through [knownStatus] / [isClosed];
/// never switch exhaustively on the string.
@override final  String status;
@override final  DateTime createdAt;
/// The ticket's creation or its latest reply, whichever is later - the
/// list's sort key.
@override final  DateTime lastActivityAt;

/// Create a copy of SupportTicketSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportTicketSummaryCopyWith<_SupportTicketSummary> get copyWith => __$SupportTicketSummaryCopyWithImpl<_SupportTicketSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportTicketSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportTicketSummary&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ticketId,reference,subject,status,createdAt,lastActivityAt);

@override
String toString() {
  return 'SupportTicketSummary(ticketId: $ticketId, reference: $reference, subject: $subject, status: $status, createdAt: $createdAt, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class _$SupportTicketSummaryCopyWith<$Res> implements $SupportTicketSummaryCopyWith<$Res> {
  factory _$SupportTicketSummaryCopyWith(_SupportTicketSummary value, $Res Function(_SupportTicketSummary) _then) = __$SupportTicketSummaryCopyWithImpl;
@override @useResult
$Res call({
 String ticketId, String reference, String subject, String status, DateTime createdAt, DateTime lastActivityAt
});




}
/// @nodoc
class __$SupportTicketSummaryCopyWithImpl<$Res>
    implements _$SupportTicketSummaryCopyWith<$Res> {
  __$SupportTicketSummaryCopyWithImpl(this._self, this._then);

  final _SupportTicketSummary _self;
  final $Res Function(_SupportTicketSummary) _then;

/// Create a copy of SupportTicketSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticketId = null,Object? reference = null,Object? subject = null,Object? status = null,Object? createdAt = null,Object? lastActivityAt = null,}) {
  return _then(_SupportTicketSummary(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SupportTicket {

 String get ticketId; String get reference; String get subject; String get details;/// The wire status, verbatim. Read it through [knownStatus] / [isClosed].
 String get status; DateTime get createdAt; DateTime get lastActivityAt; DateTime? get closedAt;
/// Create a copy of SupportTicket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportTicketCopyWith<SupportTicket> get copyWith => _$SupportTicketCopyWithImpl<SupportTicket>(this as SupportTicket, _$identity);

  /// Serializes this SupportTicket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportTicket&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.details, details) || other.details == details)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ticketId,reference,subject,details,status,createdAt,lastActivityAt,closedAt);

@override
String toString() {
  return 'SupportTicket(ticketId: $ticketId, reference: $reference, subject: $subject, details: $details, status: $status, createdAt: $createdAt, lastActivityAt: $lastActivityAt, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class $SupportTicketCopyWith<$Res>  {
  factory $SupportTicketCopyWith(SupportTicket value, $Res Function(SupportTicket) _then) = _$SupportTicketCopyWithImpl;
@useResult
$Res call({
 String ticketId, String reference, String subject, String details, String status, DateTime createdAt, DateTime lastActivityAt, DateTime? closedAt
});




}
/// @nodoc
class _$SupportTicketCopyWithImpl<$Res>
    implements $SupportTicketCopyWith<$Res> {
  _$SupportTicketCopyWithImpl(this._self, this._then);

  final SupportTicket _self;
  final $Res Function(SupportTicket) _then;

/// Create a copy of SupportTicket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticketId = null,Object? reference = null,Object? subject = null,Object? details = null,Object? status = null,Object? createdAt = null,Object? lastActivityAt = null,Object? closedAt = freezed,}) {
  return _then(_self.copyWith(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportTicket].
extension SupportTicketPatterns on SupportTicket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportTicket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportTicket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportTicket value)  $default,){
final _that = this;
switch (_that) {
case _SupportTicket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportTicket value)?  $default,){
final _that = this;
switch (_that) {
case _SupportTicket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticketId,  String reference,  String subject,  String details,  String status,  DateTime createdAt,  DateTime lastActivityAt,  DateTime? closedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportTicket() when $default != null:
return $default(_that.ticketId,_that.reference,_that.subject,_that.details,_that.status,_that.createdAt,_that.lastActivityAt,_that.closedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticketId,  String reference,  String subject,  String details,  String status,  DateTime createdAt,  DateTime lastActivityAt,  DateTime? closedAt)  $default,) {final _that = this;
switch (_that) {
case _SupportTicket():
return $default(_that.ticketId,_that.reference,_that.subject,_that.details,_that.status,_that.createdAt,_that.lastActivityAt,_that.closedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticketId,  String reference,  String subject,  String details,  String status,  DateTime createdAt,  DateTime lastActivityAt,  DateTime? closedAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportTicket() when $default != null:
return $default(_that.ticketId,_that.reference,_that.subject,_that.details,_that.status,_that.createdAt,_that.lastActivityAt,_that.closedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportTicket extends SupportTicket {
  const _SupportTicket({required this.ticketId, required this.reference, required this.subject, required this.details, required this.status, required this.createdAt, required this.lastActivityAt, required this.closedAt}): super._();
  factory _SupportTicket.fromJson(Map<String, dynamic> json) => _$SupportTicketFromJson(json);

@override final  String ticketId;
@override final  String reference;
@override final  String subject;
@override final  String details;
/// The wire status, verbatim. Read it through [knownStatus] / [isClosed].
@override final  String status;
@override final  DateTime createdAt;
@override final  DateTime lastActivityAt;
@override final  DateTime? closedAt;

/// Create a copy of SupportTicket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportTicketCopyWith<_SupportTicket> get copyWith => __$SupportTicketCopyWithImpl<_SupportTicket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportTicketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportTicket&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.details, details) || other.details == details)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ticketId,reference,subject,details,status,createdAt,lastActivityAt,closedAt);

@override
String toString() {
  return 'SupportTicket(ticketId: $ticketId, reference: $reference, subject: $subject, details: $details, status: $status, createdAt: $createdAt, lastActivityAt: $lastActivityAt, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class _$SupportTicketCopyWith<$Res> implements $SupportTicketCopyWith<$Res> {
  factory _$SupportTicketCopyWith(_SupportTicket value, $Res Function(_SupportTicket) _then) = __$SupportTicketCopyWithImpl;
@override @useResult
$Res call({
 String ticketId, String reference, String subject, String details, String status, DateTime createdAt, DateTime lastActivityAt, DateTime? closedAt
});




}
/// @nodoc
class __$SupportTicketCopyWithImpl<$Res>
    implements _$SupportTicketCopyWith<$Res> {
  __$SupportTicketCopyWithImpl(this._self, this._then);

  final _SupportTicket _self;
  final $Res Function(_SupportTicket) _then;

/// Create a copy of SupportTicket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticketId = null,Object? reference = null,Object? subject = null,Object? details = null,Object? status = null,Object? createdAt = null,Object? lastActivityAt = null,Object? closedAt = freezed,}) {
  return _then(_SupportTicket(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SupportTicketMessage {

 String get messageId; String get authorKind; String get body; DateTime get createdAt;
/// Create a copy of SupportTicketMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportTicketMessageCopyWith<SupportTicketMessage> get copyWith => _$SupportTicketMessageCopyWithImpl<SupportTicketMessage>(this as SupportTicketMessage, _$identity);

  /// Serializes this SupportTicketMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportTicketMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorKind, authorKind) || other.authorKind == authorKind)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,authorKind,body,createdAt);

@override
String toString() {
  return 'SupportTicketMessage(messageId: $messageId, authorKind: $authorKind, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SupportTicketMessageCopyWith<$Res>  {
  factory $SupportTicketMessageCopyWith(SupportTicketMessage value, $Res Function(SupportTicketMessage) _then) = _$SupportTicketMessageCopyWithImpl;
@useResult
$Res call({
 String messageId, String authorKind, String body, DateTime createdAt
});




}
/// @nodoc
class _$SupportTicketMessageCopyWithImpl<$Res>
    implements $SupportTicketMessageCopyWith<$Res> {
  _$SupportTicketMessageCopyWithImpl(this._self, this._then);

  final SupportTicketMessage _self;
  final $Res Function(SupportTicketMessage) _then;

/// Create a copy of SupportTicketMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? authorKind = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorKind: null == authorKind ? _self.authorKind : authorKind // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportTicketMessage].
extension SupportTicketMessagePatterns on SupportTicketMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportTicketMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportTicketMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportTicketMessage value)  $default,){
final _that = this;
switch (_that) {
case _SupportTicketMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportTicketMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SupportTicketMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String authorKind,  String body,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportTicketMessage() when $default != null:
return $default(_that.messageId,_that.authorKind,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String authorKind,  String body,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SupportTicketMessage():
return $default(_that.messageId,_that.authorKind,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String authorKind,  String body,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportTicketMessage() when $default != null:
return $default(_that.messageId,_that.authorKind,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportTicketMessage extends SupportTicketMessage {
  const _SupportTicketMessage({required this.messageId, required this.authorKind, required this.body, required this.createdAt}): super._();
  factory _SupportTicketMessage.fromJson(Map<String, dynamic> json) => _$SupportTicketMessageFromJson(json);

@override final  String messageId;
@override final  String authorKind;
@override final  String body;
@override final  DateTime createdAt;

/// Create a copy of SupportTicketMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportTicketMessageCopyWith<_SupportTicketMessage> get copyWith => __$SupportTicketMessageCopyWithImpl<_SupportTicketMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportTicketMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportTicketMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorKind, authorKind) || other.authorKind == authorKind)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,authorKind,body,createdAt);

@override
String toString() {
  return 'SupportTicketMessage(messageId: $messageId, authorKind: $authorKind, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SupportTicketMessageCopyWith<$Res> implements $SupportTicketMessageCopyWith<$Res> {
  factory _$SupportTicketMessageCopyWith(_SupportTicketMessage value, $Res Function(_SupportTicketMessage) _then) = __$SupportTicketMessageCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String authorKind, String body, DateTime createdAt
});




}
/// @nodoc
class __$SupportTicketMessageCopyWithImpl<$Res>
    implements _$SupportTicketMessageCopyWith<$Res> {
  __$SupportTicketMessageCopyWithImpl(this._self, this._then);

  final _SupportTicketMessage _self;
  final $Res Function(_SupportTicketMessage) _then;

/// Create a copy of SupportTicketMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? authorKind = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_SupportTicketMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorKind: null == authorKind ? _self.authorKind : authorKind // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
