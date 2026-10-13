import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

/// Mirrors the contract `TokenPair` schema exactly. Keys are already camelCase
/// in the contract, so no `@JsonKey` bridge is needed. All four fields are
/// contract-required — no defaults (a missing field must throw, surfacing drift).
///
/// Token VALUES are secrets: they go straight to SecureStorage and are never
/// logged (minors' data).
///
/// That includes the implicit way. Freezed would otherwise generate a
/// `toString()` printing every field, so any `'$tokens'`, uncaught-error dump or
/// failing-test message would carry both bearer credentials. The override below
/// says the type and nothing else (freezed emits no `toString` of its own when
/// the class declares one). Equality, `copyWith` and JSON are untouched.
@freezed
abstract class TokenPair with _$TokenPair {
  const TokenPair._();

  const factory TokenPair({
    required String accessToken,
    required int accessExpiresInSeconds,
    required String refreshToken,
    required int refreshExpiresInSeconds,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);

  @override
  String toString() => 'TokenPair(<redacted>)';
}
