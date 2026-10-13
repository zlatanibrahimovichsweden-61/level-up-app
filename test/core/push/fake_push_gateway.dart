import 'dart:async';

import 'package:level_up_app/core/push/push_gateway.dart';
import 'package:level_up_app/core/push/push_token_repository.dart';

/// A scripted [PushGateway] for tests: the only kind of gateway, besides the
/// Noop, that this app has until the SDK exists. Every token in the push tests
/// is a made-up string, never a real FCM token.
class FakePushGateway implements PushGateway {
  FakePushGateway({this.token, this.currentTokenThrows = false});

  /// What [currentToken] answers.
  String? token;

  /// Makes [currentToken] throw, as an SDK can.
  bool currentTokenThrows;

  /// Completing this holds [currentToken] open, so a test can interleave a
  /// token rotation with a slow first read.
  Completer<void>? holdCurrentToken;

  int currentTokenCalls = 0;

  final _refreshes = StreamController<String>.broadcast();
  final _taps = StreamController<PushTap>.broadcast();

  /// Whether anything is listening to [tokenRefreshes] right now.
  bool get hasRefreshListener => _refreshes.hasListener;

  void rotate(String newToken) => _refreshes.add(newToken);

  void rotateError() => _refreshes.addError(StateError('sdk fault'));

  void tap(PushTap tap) => _taps.add(tap);

  Future<void> close() async {
    await _refreshes.close();
    await _taps.close();
  }

  @override
  Future<String?> currentToken() async {
    currentTokenCalls++;
    final hold = holdCurrentToken;
    if (hold != null) await hold.future;
    if (currentTokenThrows) throw StateError('sdk fault');
    return token;
  }

  @override
  Stream<String> get tokenRefreshes => _refreshes.stream;

  @override
  Stream<PushTap> get taps => _taps.stream;
}

/// A scripted [PushTokenRepository]: records the tokens it was asked to
/// register and answers from [responses] (one per call, in order), then
/// succeeds.
class FakePushTokenRepository implements PushTokenRepository {
  final calls = <String>[];

  /// One entry per call: `null` succeeds, anything else is thrown.
  final responses = <Object?>[];

  /// Completing this holds a call open (for in-flight interleavings).
  Completer<void>? hold;

  @override
  Future<void> registerFcmToken(String token) async {
    calls.add(token);
    final gate = hold;
    if (gate != null) await gate.future;
    if (responses.isNotEmpty) {
      final next = responses.removeAt(0);
      if (next != null) throw next;
    }
  }
}
