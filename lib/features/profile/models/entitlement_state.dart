import 'package:freezed_annotation/freezed_annotation.dart';

part 'entitlement_state.freezed.dart';
part 'entitlement_state.g.dart';

/// The paywall signal — contract `EntitlementState`, returned both by
/// `GET /me/entitlements` and embedded read-only in `GET /me` for first paint.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is needed
/// and none must be added.
///
/// Server-authoritative: the app never derives "is subscribed" from anything
/// else (a stored receipt, a past checkout, a date it computed itself) — it
/// displays what this says. Note adr-020: card payments have NO `pending`
/// state; an entitlement is verified-active or it isn't.

/// `EntitlementType`. The contract marks this set as **extensible** ("clients
/// must tolerate unknown values additively"), so a bare generated enum would
/// throw the day Seif adds one. [unknown] is the client-side sink for values
/// this build has never heard of — it is NOT a contract value and is never sent.
@JsonEnum()
enum EntitlementType { baseSubscription, flashcardSubscription, unknown }

@freezed
abstract class EntitlementState with _$EntitlementState {
  const factory EntitlementState({
    // The one permitted `@JsonKey` here: `unknownEnumValue` is the extensibility
    // guard the contract requires, not a snake_case name bridge.
    @JsonKey(unknownEnumValue: EntitlementType.unknown)
    required EntitlementType type,
    required bool active,
    DateTime? expiresAt,

    /// 2-day grace window after expiry (requirements §5).
    required bool inGrace,
    DateTime? graceEndsAt,
  }) = _EntitlementState;

  factory EntitlementState.fromJson(Map<String, dynamic> json) =>
      _$EntitlementStateFromJson(json);
}

/// The `{ items: [...] }` envelope of `GET /me/entitlements`.
@freezed
abstract class EntitlementsResponse with _$EntitlementsResponse {
  const factory EntitlementsResponse({required List<EntitlementState> items}) =
      _EntitlementsResponse;

  factory EntitlementsResponse.fromJson(Map<String, dynamic> json) =>
      _$EntitlementsResponseFromJson(json);
}
