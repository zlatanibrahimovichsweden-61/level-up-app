import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/exceptions.dart';
import 'push_gateway.dart';
import 'push_token_repository.dart';

/// What one attempt to register the device's push token came to.
enum PushRegistrationOutcome {
  /// `204`: the server now holds this token for the signed-in student.
  registered,

  /// There was no token to register: the gateway has none (always the case for
  /// [NoopPushGateway]), it threw, or it returned an empty/whitespace-only
  /// string, which the server would refuse with `400` anyway. No request was
  /// made.
  noToken,

  /// Nothing to do: the server already accepted this very token during this
  /// sign-in, the sign-in was already started, or nothing is waiting for a
  /// retry. No request was made.
  notNeeded,

  /// The server refused, and asking again with the same token cannot change
  /// that: `400` (the token itself is invalid), `401` (the session is gone) or
  /// `403 account_pending_deletion` (inside the deletion grace window). The
  /// token is dropped, not kept for a retry. A LATER, different token (the SDK
  /// rotating it) is still attempted - that is a new fact.
  refused,

  /// A transient failure (offline, timeout, `5xx`, `429` ...). The token is
  /// kept pending; [PushRegistrationLifecycle.retryPending] tries it again.
  /// Nothing retries on its own.
  retryLater,

  /// The student signed out while this attempt was queued or in flight, so its
  /// result was discarded and no state was changed.
  sessionEnded,
}

/// Registers the device's push token with the server: once per sign-in, and
/// once more for each token the SDK rotates (`contract/realtime.md`: "The app
/// registers its FCM token after sign-in and on every token refresh").
///
/// A plain class, not a notifier: it holds no student data, only the push
/// token in memory for the length of one sign-in, and it is driven by calls
/// ([onSignedIn], [onSignedOut], [retryPending]) rather than by watching a
/// provider. **Nothing calls it yet** - hooking it to the auth state is a
/// deferred integration, not part of this wave.
///
/// ## Dormant by construction
///
/// With the default [NoopPushGateway], [PushGateway.currentToken] is `null` and
/// [PushGateway.tokenRefreshes] never fires, so [onSignedIn] answers
/// [PushRegistrationOutcome.noToken] and **no request is ever made**. Only a
/// gateway that can return a token - which no real flavor is given - can cause
/// a `PUT`.
///
/// ## Rules
///
/// - **Once per sign-in.** A second [onSignedIn] without an [onSignedOut] in
///   between does nothing. After a sign-out and a new sign-in the SAME device
///   token is registered again: the server keeps one token per student, and the
///   next student on this handset has none yet.
/// - **Latest wins, in order.** Attempts run one at a time, in the order the
///   tokens arrived, so the last `PUT` the server sees is the newest token.
/// - **No automatic retry.** `400`, `401` and `403 account_pending_deletion`
///   are final for that token ([PushRegistrationOutcome.refused]); a transient
///   failure keeps the token pending for an explicit [retryPending] (app
///   resume, say). There is no timer and no backoff.
/// - **Never logs, never throws.** An error from the gateway or the repository
///   is classified and dropped; it is not stored, printed or rethrown. The
///   token is held in a field for deduplication and is never written anywhere.
/// - **Sign-out clears nothing on the server.** Deleting the token at sign-out
///   is a 3.47 server change plus an SDK call (SQ-09) and is out of scope here;
///   [onSignedOut] only stops listening and forgets what this instance learned.
class PushRegistrationLifecycle {
  PushRegistrationLifecycle({
    required PushGateway gateway,
    required PushTokenRepository repository,
  }) : _gateway = gateway,
       _repository = repository;

  final PushGateway _gateway;
  final PushTokenRepository _repository;

  StreamSubscription<String>? _refreshes;
  bool _active = false;

  /// Bumped on every sign-in and sign-out, so an attempt that outlives its
  /// session can tell and discard itself.
  int _generation = 0;

  /// The token the server last accepted during this sign-in.
  String? _registered;

  /// The token whose last attempt failed transiently.
  String? _pending;

  /// Serialises attempts: each runs after the previous settled.
  Future<void> _tail = Future<void>.value();

  /// Whether the SDK rotated the token since this sign-in started. A rotation
  /// is newer than the first read of the current token, so once one has been
  /// seen that read is stale and is dropped (see [onSignedIn]).
  bool _rotatedSinceSignIn = false;

  /// Whether a sign-in is currently being served.
  bool get isActive => _active;

  /// Starts serving a sign-in: listens for token rotations and registers the
  /// current token, if there is one. Returns the outcome of that first attempt.
  Future<PushRegistrationOutcome> onSignedIn() async {
    if (_active) return PushRegistrationOutcome.notNeeded;
    _active = true;
    final generation = ++_generation;
    _rotatedSinceSignIn = false;
    _refreshes = _gateway.tokenRefreshes.listen(
      (token) {
        _rotatedSinceSignIn = true;
        unawaited(_enqueue(generation, token));
      },
      // A stream error is an SDK fault, not a reason to stop listening, and
      // its text is nobody's business here.
      onError: (Object _) {},
    );

    String? token;
    try {
      token = await _gateway.currentToken();
    } on Object {
      token = null;
    }
    if (generation != _generation) return PushRegistrationOutcome.sessionEnded;
    // A token that rotated while this read was in flight is newer than whatever
    // the read returned, and has already been queued: registering the older
    // value after it would make the server's "latest wins" the wrong one.
    if (_rotatedSinceSignIn) return PushRegistrationOutcome.notNeeded;
    return _enqueue(generation, token);
  }

  /// Stops serving the sign-in: cancels the listener and forgets the registered
  /// and pending tokens, so the next [onSignedIn] registers afresh. Does not
  /// call the server.
  Future<void> onSignedOut() async {
    _generation++;
    _active = false;
    _registered = null;
    _pending = null;
    final subscription = _refreshes;
    _refreshes = null;
    await subscription?.cancel();
  }

  /// Tries again with the token a transient failure left pending. Answers
  /// [PushRegistrationOutcome.notNeeded] when nothing is pending or no sign-in
  /// is active. Intended for an explicit trigger such as the app resuming.
  Future<PushRegistrationOutcome> retryPending() {
    final token = _pending;
    if (!_active || token == null) {
      return Future<PushRegistrationOutcome>.value(
        PushRegistrationOutcome.notNeeded,
      );
    }
    return _enqueue(_generation, token);
  }

  /// Releases the listener. Same as [onSignedOut]; named for the owner that
  /// disposes the provider holding this object.
  Future<void> dispose() => onSignedOut();

  Future<PushRegistrationOutcome> _enqueue(int generation, String? token) {
    final result = _tail.then((_) => _attempt(generation, token));
    _tail = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<PushRegistrationOutcome> _attempt(
    int generation,
    String? token,
  ) async {
    if (generation != _generation) return PushRegistrationOutcome.sessionEnded;
    if (token == null || token.trim().isEmpty) {
      return PushRegistrationOutcome.noToken;
    }
    if (token == _registered) return PushRegistrationOutcome.notNeeded;

    try {
      await _repository.registerFcmToken(token);
    } on Object catch (error) {
      if (generation != _generation) {
        return PushRegistrationOutcome.sessionEnded;
      }
      if (_isFinalRefusal(error)) {
        _pending = null;
        return PushRegistrationOutcome.refused;
      }
      _pending = token;
      return PushRegistrationOutcome.retryLater;
    }

    if (generation != _generation) return PushRegistrationOutcome.sessionEnded;
    _registered = token;
    _pending = null;
    return PushRegistrationOutcome.registered;
  }

  /// `400`, `401` and `403 account_pending_deletion`: the answers a retry of
  /// the same token cannot improve. Everything else is treated as transient.
  static bool _isFinalRefusal(Object error) {
    if (isAccountPendingDeletion(error)) return true;
    return error is ApiException &&
        (error.status == 400 || error.status == 401);
  }
}

/// The lifecycle for the app's [pushGatewayProvider] and
/// [pushTokenRepositoryProvider]. A plain `Provider`; it releases the listener
/// when the container is disposed. **Nothing reads it yet** (deferred wiring).
final pushRegistrationLifecycleProvider = Provider<PushRegistrationLifecycle>((
  ref,
) {
  final lifecycle = PushRegistrationLifecycle(
    gateway: ref.watch(pushGatewayProvider),
    repository: ref.watch(pushTokenRepositoryProvider),
  );
  ref.onDispose(() => unawaited(lifecycle.dispose()));
  return lifecycle;
});
