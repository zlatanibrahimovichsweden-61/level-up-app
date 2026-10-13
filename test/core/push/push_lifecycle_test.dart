import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/push/push_gateway.dart';
import 'package:level_up_app/core/push/push_lifecycle.dart';
import 'package:level_up_app/core/push/push_token_repository.dart';

import 'fake_push_gateway.dart';

/// The push registration lifecycle, against fakes only: no SDK, no network.
///
/// Rules guarded here (each a sentence in `contract/realtime.md` or in the
/// wave's brief, not an implementation detail):
/// - a gateway with no token - the Noop every real flavor gets - never causes a
///   request;
/// - the token is registered once per sign-in and once more per rotation, in
///   arrival order, so the latest wins;
/// - `400`, `401` and `403 account_pending_deletion` are not retried; anything
///   else stays pending for an explicit retry;
/// - nothing the lifecycle does can throw, and the token never reaches a log.
void main() {
  late FakePushGateway gateway;
  late FakePushTokenRepository repository;
  late PushRegistrationLifecycle lifecycle;

  const t1 = 'fake-token-one';
  const t2 = 'fake-token-two';

  setUp(() {
    gateway = FakePushGateway(token: t1);
    repository = FakePushTokenRepository();
    lifecycle = PushRegistrationLifecycle(
      gateway: gateway,
      repository: repository,
    );
  });

  tearDown(() async {
    await lifecycle.dispose();
    await gateway.close();
  });

  /// Lets queued attempts and stream deliveries run.
  Future<void> settle() => pumpEventQueue();

  group('dormant: a gateway with no token never registers', () {
    test('the Noop gateway: no request, outcome noToken', () async {
      final noop = PushRegistrationLifecycle(
        gateway: const NoopPushGateway(),
        repository: repository,
      );

      final outcome = await noop.onSignedIn();
      await settle();

      expect(outcome, PushRegistrationOutcome.noToken);
      expect(repository.calls, isEmpty);
      await noop.dispose();
    });

    test('a null token makes no request', () async {
      gateway.token = null;

      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.noToken);
      expect(repository.calls, isEmpty);
    });

    test('an empty or whitespace-only token makes no request', () async {
      gateway.token = '   ';

      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.noToken);
      expect(repository.calls, isEmpty);
    });

    test('a gateway that throws is "no token", not a crash', () async {
      gateway.currentTokenThrows = true;

      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.noToken);
      expect(repository.calls, isEmpty);
    });
  });

  group('once per sign-in', () {
    test('registers the current token', () async {
      final outcome = await lifecycle.onSignedIn();

      expect(outcome, PushRegistrationOutcome.registered);
      expect(repository.calls, [t1]);
      expect(lifecycle.isActive, isTrue);
    });

    test('a second sign-in call without a sign-out does nothing', () async {
      await lifecycle.onSignedIn();

      final again = await lifecycle.onSignedIn();

      expect(again, PushRegistrationOutcome.notNeeded);
      expect(repository.calls, [t1]);
      expect(gateway.currentTokenCalls, 1);
    });

    test('sign-out then sign-in registers the SAME token again', () async {
      await lifecycle.onSignedIn();
      await lifecycle.onSignedOut();

      final outcome = await lifecycle.onSignedIn();

      expect(outcome, PushRegistrationOutcome.registered);
      expect(repository.calls, [t1, t1]);
    });

    test('sign-out stops listening and calls no server', () async {
      await lifecycle.onSignedIn();
      expect(gateway.hasRefreshListener, isTrue);

      await lifecycle.onSignedOut();

      expect(gateway.hasRefreshListener, isFalse);
      expect(lifecycle.isActive, isFalse);
      gateway.rotate(t2);
      await settle();
      expect(repository.calls, [t1]);
    });
  });

  group('token rotation', () {
    test('a new token is registered', () async {
      await lifecycle.onSignedIn();

      gateway.rotate(t2);
      await settle();

      expect(repository.calls, [t1, t2]);
    });

    test('the same token again is not sent twice', () async {
      await lifecycle.onSignedIn();

      gateway.rotate(t1);
      await settle();

      expect(repository.calls, [t1]);
    });

    test('a rotation before any sign-in is ignored', () async {
      gateway.rotate(t2);
      await settle();

      expect(repository.calls, isEmpty);
    });

    test('a stream error does not stop the listening', () async {
      await lifecycle.onSignedIn();

      gateway.rotateError();
      gateway.rotate(t2);
      await settle();

      expect(repository.calls, [t1, t2]);
    });

    test('a rotation that lands while the first read is slow wins: the older '
        'read is dropped, so the latest token is the last one sent', () async {
      gateway.holdCurrentToken = Completer<void>();
      final first = lifecycle.onSignedIn();
      await settle();

      gateway.rotate(t2);
      await settle();
      gateway.holdCurrentToken!.complete();
      final outcome = await first;
      await settle();

      // t1 is what the slow read returned, but t2 is newer: sending t1 after
      // t2 would leave the server holding the stale one.
      expect(repository.calls, [t2]);
      expect(outcome, PushRegistrationOutcome.notNeeded);
    });

    test(
      'a slow first read that finishes after a sign-out is discarded',
      () async {
        gateway.holdCurrentToken = Completer<void>();
        final first = lifecycle.onSignedIn();
        await settle();

        await lifecycle.onSignedOut();
        gateway.holdCurrentToken!.complete();
        final outcome = await first;
        await settle();

        expect(outcome, PushRegistrationOutcome.sessionEnded);
        expect(repository.calls, isEmpty);
      },
    );

    test(
      'attempts are serialised in arrival order, never overlapping',
      () async {
        repository.hold = Completer<void>();
        final first = lifecycle.onSignedIn();
        await settle();
        expect(repository.calls, [t1]);

        gateway.rotate(t2);
        await settle();
        // t1 is still in flight; t2 must wait for it.
        expect(repository.calls, [t1]);

        repository.hold!.complete();
        await first;
        await settle();
        expect(repository.calls, [t1, t2]);
      },
    );
  });

  group('final refusals are not retried', () {
    final refusals = <String, Object>{
      '400 validation_failed': const ValidationException(
        errors: {
          'token': ['Required.'],
        },
      ),
      '401 authentication_required': const UnauthorizedException(
        code: 'authentication_required',
      ),
      '401 session_superseded': const UnauthorizedException(
        code: 'session_superseded',
      ),
      '403 account_pending_deletion': const ApiException(
        status: 403,
        code: 'account_pending_deletion',
      ),
    };

    for (final entry in refusals.entries) {
      test('${entry.key}: refused, nothing pending, no second call', () async {
        repository.responses.add(entry.value);

        final outcome = await lifecycle.onSignedIn();
        final retry = await lifecycle.retryPending();
        await settle();

        expect(outcome, PushRegistrationOutcome.refused);
        expect(retry, PushRegistrationOutcome.notNeeded);
        expect(repository.calls, [t1]);
      });
    }

    test(
      'a refusal does not stop a LATER, different token being tried',
      () async {
        repository.responses.add(
          const ValidationException(
            errors: {
              'token': ['Required.'],
            },
          ),
        );
        await lifecycle.onSignedIn();

        gateway.rotate(t2);
        await settle();

        expect(repository.calls, [t1, t2]);
      },
    );

    test('a refusal is not remembered as registered: the next sign-in tries '
        'again', () async {
      repository.responses.add(
        const ApiException(status: 403, code: 'account_pending_deletion'),
      );
      await lifecycle.onSignedIn();
      await lifecycle.onSignedOut();

      final outcome = await lifecycle.onSignedIn();

      expect(outcome, PushRegistrationOutcome.registered);
      expect(repository.calls, [t1, t1]);
    });
  });

  group('transient failures stay pending for an explicit retry', () {
    final transient = <String, Object>{
      'offline': const OfflineException(),
      'timeout': const NetworkException(detail: 'timeout'),
      '500': const ApiException(status: 500, code: 'internal_error'),
      '429': const RateLimitedException(),
      'a body-less failure': const UnknownException(),
      'a 403 that is not the grace window': const ApiException(
        status: 403,
        code: 'insufficient_scope',
      ),
    };

    for (final entry in transient.entries) {
      test('${entry.key}: retryLater, then retryPending succeeds', () async {
        repository.responses.add(entry.value);

        final outcome = await lifecycle.onSignedIn();
        expect(outcome, PushRegistrationOutcome.retryLater);
        expect(repository.calls, [t1]);

        final retry = await lifecycle.retryPending();
        expect(retry, PushRegistrationOutcome.registered);
        expect(repository.calls, [t1, t1]);

        // Registered now: nothing is pending any more.
        expect(
          await lifecycle.retryPending(),
          PushRegistrationOutcome.notNeeded,
        );
        expect(repository.calls, [t1, t1]);
      });
    }

    test('nothing retries on its own', () async {
      repository.responses.add(const OfflineException());

      await lifecycle.onSignedIn();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await settle();

      expect(repository.calls, [t1]);
    });

    test('a newer token replaces the pending one (latest wins)', () async {
      repository.responses.add(const OfflineException());
      await lifecycle.onSignedIn();

      gateway.rotate(t2);
      await settle();

      expect(repository.calls, [t1, t2]);
      expect(await lifecycle.retryPending(), PushRegistrationOutcome.notNeeded);
      expect(repository.calls, [t1, t2]);
    });

    test('a pending token is forgotten at sign-out', () async {
      repository.responses.add(const OfflineException());
      await lifecycle.onSignedIn();
      await lifecycle.onSignedOut();

      expect(await lifecycle.retryPending(), PushRegistrationOutcome.notNeeded);
      expect(repository.calls, [t1]);
    });

    test('retryPending before any sign-in does nothing', () async {
      expect(await lifecycle.retryPending(), PushRegistrationOutcome.notNeeded);
      expect(repository.calls, isEmpty);
    });
  });

  group('a sign-out mid-flight', () {
    test('discards the result and changes nothing', () async {
      repository.hold = Completer<void>();
      final first = lifecycle.onSignedIn();
      await settle();
      expect(repository.calls, [t1]);

      await lifecycle.onSignedOut();
      repository.hold!.complete();
      final outcome = await first;

      expect(outcome, PushRegistrationOutcome.sessionEnded);

      // The discarded success did not leak into the next sign-in's dedupe.
      repository.hold = null;
      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.registered);
      expect(repository.calls, [t1, t1]);
    });

    test('a queued attempt for the ended session is never sent', () async {
      repository.hold = Completer<void>();
      final first = lifecycle.onSignedIn();
      await settle();
      gateway.rotate(t2);
      await settle();
      expect(repository.calls, [t1]);

      await lifecycle.onSignedOut();
      repository.hold!.complete();
      await first;
      await settle();

      expect(repository.calls, [t1]);
    });
  });

  group('never logs the token', () {
    test(
      'nothing is printed through registered, refused and retry paths',
      () async {
        final printed = <String>[];
        await runZoned(
          () async {
            repository.responses
              ..add(const OfflineException())
              ..add(
                const ApiException(
                  status: 403,
                  code: 'account_pending_deletion',
                ),
              );
            await lifecycle.onSignedIn();
            await lifecycle.retryPending();
            gateway.rotate(t2);
            await settle();
            await lifecycle.onSignedOut();
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) => printed.add(line),
          ),
        );

        expect(printed, isEmpty);
      },
    );
  });

  group('the provider', () {
    test(
      'defaults to the Noop gateway, so a bare container never PUTs',
      () async {
        final container = ProviderContainer(
          overrides: [
            pushTokenRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(pushGatewayProvider), isA<NoopPushGateway>());
        final outcome = await container
            .read(pushRegistrationLifecycleProvider)
            .onSignedIn();

        expect(outcome, PushRegistrationOutcome.noToken);
        expect(repository.calls, isEmpty);
      },
    );

    test(
      'disposing the container releases the token-refresh listener',
      () async {
        final container = ProviderContainer(
          overrides: [
            pushGatewayProvider.overrideWithValue(gateway),
            pushTokenRepositoryProvider.overrideWithValue(repository),
          ],
        );
        await container.read(pushRegistrationLifecycleProvider).onSignedIn();
        expect(gateway.hasRefreshListener, isTrue);

        container.dispose();
        await settle();

        expect(gateway.hasRefreshListener, isFalse);
      },
    );
  });
}
