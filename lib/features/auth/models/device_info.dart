import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';
part 'device_info.g.dart';

/// Mirrors the contract `DeviceInfo` schema. Sent with `POST /auth/otp/verify`
/// as the device-binding key (adr-019): a NEW device evicts the old session,
/// which then sees `session_superseded`.
///
/// `deviceId` is a client-generated stable id (≤64 chars) from SecureStorage;
/// `platform` is `android`|`ios`; `model` is an optional display label used in
/// eviction messaging. Contract-required: deviceId, platform.
///
/// `toString` is redacted: [deviceId] is the key a session is bound to and
/// [model] names the student's handset, and neither reaches a log, an error
/// detail or a test report by accident. Freezed emits no `toString` of its own
/// when the class declares one; equality, `copyWith` and JSON are unchanged.
@freezed
abstract class DeviceInfo with _$DeviceInfo {
  const DeviceInfo._();

  const factory DeviceInfo({
    required String deviceId,
    required String platform,
    String? model,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  @override
  String toString() => 'DeviceInfo(<redacted>)';
}
