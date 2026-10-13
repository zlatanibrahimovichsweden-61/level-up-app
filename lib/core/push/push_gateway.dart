import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The app's whole view of the push SDK: three things, no SDK type.
///
/// Push is staged (`contract/realtime.md`, "Push notifications (FCM)": the
/// *shape* is `stable`, delivery is off in every environment until the staging
/// verification is recorded). This seam is the Dart side of that shape, built
/// BEFORE any SDK so that the registration lifecycle and the tap routing can be
/// written and tested now, against fakes. The SDK adapter (CW08b) will be one
/// more implementation of this interface, and nothing above it changes.
///
/// ## The one rule that matters: no real flavor can return a token
///
/// [pushGatewayProvider] defaults to [NoopPushGateway], and **no entrypoint
/// overrides it** (that is a deliberately deferred integration - the wiring is
/// not part of this wave). A [NoopPushGateway] has no token, so nothing
/// registers, so a dormant-push production build never `PUT`s a token. Whether
/// a build may do so is an open owner call (`BACKEND_HANDOFF.md:486`, D-023 /
/// R-9); until it is answered, the answer in code is "no". Tests pass fakes.
///
/// Nothing in this file logs, and a token must never reach a log line or an
/// error detail anywhere in `lib/core/push/`.
abstract interface class PushGateway {
  /// The device's current push token, or `null` when there is none: the user
  /// has not granted notification permission, the platform has not issued one
  /// yet, or this gateway has no SDK behind it ([NoopPushGateway]).
  ///
  /// A call may throw (an SDK can); callers treat a throw as "no token" and do
  /// not log it.
  Future<String?> currentToken();

  /// Every NEW token after the first, as the SDK rotates it (the contract:
  /// "The app registers its FCM token after sign-in and on every token
  /// refresh"). Does not replay [currentToken]. A broadcast stream: it may be
  /// listened to, cancelled and listened to again across sign-ins.
  Stream<String> get tokenRefreshes;

  /// Every notification the user TAPPED to open or resume the app, as its raw
  /// `data` payload. A cold-start tap (the app was terminated) is the SDK
  /// adapter's to deliver as the first event here. Foreground presentation is a
  /// separate, undesigned concern (DG-13) and is not carried by this stream.
  Stream<PushTap> get taps;
}

/// A tapped notification's `data` map. The contract promises
/// `kind` (the wire string) plus opaque ids, **all string values, and "any
/// other key is never sent"** (`realtime.md`). This keeps only `String` to
/// `String` entries, so a platform that hands over loosely typed maps cannot
/// smuggle a non-string through.
///
/// Ids are opaque and personal-adjacent, so [toString] reports the kind only.
@immutable
class PushTap {
  const PushTap(this.data);

  /// Keeps the entries whose key and value are both strings, drops the rest.
  factory PushTap.fromData(Map<Object?, Object?> data) => PushTap(
    Map<String, String>.unmodifiable(<String, String>{
      for (final MapEntry(:key, :value) in data.entries)
        if (key is String && value is String) key: value,
    }),
  );

  final Map<String, String> data;

  /// The payload's `kind`, or `null` when the payload carries none.
  String? get kind => data['kind'];

  @override
  String toString() => 'PushTap(kind: $kind)';
}

/// The gateway every real flavor uses until the SDK exists (CW08b): no token,
/// no refreshes, no taps. Because [currentToken] is `null`, the registration
/// lifecycle never calls `PUT /me/fcm-token` with it.
class NoopPushGateway implements PushGateway {
  const NoopPushGateway();

  @override
  Future<String?> currentToken() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream<String>.empty();

  @override
  Stream<PushTap> get taps => const Stream<PushTap>.empty();
}

/// The gateway in use. A plain `Provider` defaulting to [NoopPushGateway]; a
/// test overrides it with a fake. **No entrypoint overrides it** (see
/// [PushGateway]), so every flavor gets the Noop.
final pushGatewayProvider = Provider<PushGateway>(
  (ref) => const NoopPushGateway(),
);
