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
@freezed
abstract class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String deviceId,
    required String platform,
    String? model,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
