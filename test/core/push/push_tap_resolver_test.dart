import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/push/push_gateway.dart';
import 'package:level_up_app/core/push/push_tap_resolver.dart';

/// `contract/realtime.md`, "Tap handling", as a table. The resolver is pure, so
/// every row is just a payload in and a destination out.
void main() {
  PushTapResolution resolve(Map<String, String> data) =>
      resolvePushTap(PushTap(data));

  group('support_ticket_replied', () {
    test('opens that ticket', () {
      expect(
        resolve({
          'kind': 'support_ticket_replied',
          'ticketId': '5c000000-0000-4000-8000-000000000001',
        }),
        const PushTapOpen(
          '/support/tickets/5c000000-0000-4000-8000-000000000001',
        ),
      );
    });

    test('the ticket id is percent-encoded into the path, not interpreted', () {
      final resolution = resolve({
        'kind': 'support_ticket_replied',
        'ticketId': 'a/b?c#d e',
      });

      expect(
        resolution,
        const PushTapOpen('/support/tickets/a%2Fb%3Fc%23d%20e'),
      );
    });

    test('without a ticketId it falls back to the notifications screen', () {
      expect(
        resolve({'kind': 'support_ticket_replied'}),
        const PushTapOpen('/notifications'),
      );
    });

    test('an empty or blank ticketId is treated as missing', () {
      for (final id in ['', '   ']) {
        expect(
          resolve({'kind': 'support_ticket_replied', 'ticketId': id}),
          const PushTapOpen('/notifications'),
          reason: 'ticketId "$id"',
        );
      }
    });
  });

  group('academic_year_opened', () {
    test('opens the notifications screen', () {
      expect(
        resolve({'kind': 'academic_year_opened'}),
        const PushTapOpen('/notifications'),
      );
    });

    test('ignores anything else in the payload', () {
      expect(
        resolve({'kind': 'academic_year_opened', 'ticketId': 'x'}),
        const PushTapOpen('/notifications'),
      );
    });
  });

  group('kinds whose destination is not built yet', () {
    test('friend_request_received is a typed "target not built"', () {
      expect(
        resolve({
          'kind': 'friend_request_received',
          'friendRequestId': 'some-request',
        }),
        const PushTapTargetNotBuilt(PushKind.friendRequestReceived),
      );
    });

    test('chat_message_received is a typed "target not built"', () {
      expect(
        resolve({
          'kind': 'chat_message_received',
          'conversationId': 'some-conversation',
        }),
        const PushTapTargetNotBuilt(PushKind.chatMessageReceived),
      );
    });

    test('neither opens a route: the result is not a PushTapOpen', () {
      for (final kind in ['friend_request_received', 'chat_message_received']) {
        expect(resolve({'kind': kind}), isNot(isA<PushTapOpen>()));
      }
    });
  });

  group(
    'an unknown kind opens the notifications screen and ignores the rest',
    () {
      test('a kind this build has never heard of', () {
        expect(
          resolve({'kind': 'enrolment_opened', 'ticketId': 'x'}),
          const PushTapOpen('/notifications'),
        );
      });

      test('announcement (never pushed) is still just "unknown"', () {
        expect(
          resolve({'kind': 'announcement'}),
          const PushTapOpen('/notifications'),
        );
      });

      test('no kind at all', () {
        expect(resolve({}), const PushTapOpen('/notifications'));
      });

      test('an empty kind', () {
        expect(resolve({'kind': ''}), const PushTapOpen('/notifications'));
      });

      test('the kind is matched exactly: case and spacing do not widen it', () {
        for (final kind in [
          'Support_Ticket_Replied',
          ' support_ticket_replied',
          'support-ticket-replied',
        ]) {
          expect(
            resolve({'kind': kind, 'ticketId': 'x'}),
            const PushTapOpen('/notifications'),
            reason: kind,
          );
        }
      });
    },
  );

  group('PushKind', () {
    test('is exactly the four kinds the contract says are ever pushed', () {
      expect(PushKind.values.map((k) => k.wire).toSet(), {
        'support_ticket_replied',
        'friend_request_received',
        'academic_year_opened',
        'chat_message_received',
      });
    });

    test('fromWire round-trips each wire string and rejects the rest', () {
      for (final kind in PushKind.values) {
        expect(PushKind.fromWire(kind.wire), kind);
      }
      expect(PushKind.fromWire(null), isNull);
      expect(PushKind.fromWire('enrolment_opened'), isNull);
    });
  });

  group('results never leak the id into their string form', () {
    test('PushTapOpen', () {
      const open = PushTapOpen('/support/tickets/secret-ticket-id');

      expect(open.toString(), isNot(contains('secret-ticket-id')));
    });
  });

  test('the resolver is a function of the payload alone', () {
    final tap = PushTap.fromData({
      'kind': 'support_ticket_replied',
      'ticketId': 'same',
    });

    expect(resolvePushTap(tap), resolvePushTap(tap));
  });
}
