import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

/// Mirrors the contract `TokenPair` schema exactly. Keys are already camelCase
/// in the contract, so no `@JsonKey` bridge is needed. All four fields are
/// contract-required — no defaults (a missing field must throw, surfacing drift).
///
/// Token VALUES are secrets: they go straight to SecureStorage and are never
/// logged (minors' data).
@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    required String accessToken,
    required int accessExpiresInSeconds,
    required String refreshToken,
    required int refreshExpiresInSeconds,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}
