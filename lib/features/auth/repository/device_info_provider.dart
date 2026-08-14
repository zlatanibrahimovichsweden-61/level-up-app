import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../models/device_info.dart';

/// Builds the [DeviceInfo] sent with `POST /auth/otp/verify` — the device-binding
/// key (adr-019). `deviceId` is the stable id persisted in SecureStorage
/// (survives restart, resets on reinstall); `platform` from dart:io; `model` is
/// an optional display label for eviction messaging.
///
/// Overridden in tests. Never logs any of these values.
final deviceInfoProvider = FutureProvider<DeviceInfo>((ref) async {
  final deviceId = await ref
      .watch(secureStorageProvider)
      .readOrCreateDeviceId();
  final plugin = DeviceInfoPlugin();

  if (Platform.isIOS) {
    final info = await plugin.iosInfo;
    return DeviceInfo(deviceId: deviceId, platform: 'ios', model: info.model);
  }
  // Contract's platform enum is android|ios; Android is the default branch.
  final info = await plugin.androidInfo;
  return DeviceInfo(deviceId: deviceId, platform: 'android', model: info.model);
});
