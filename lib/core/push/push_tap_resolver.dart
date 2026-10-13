import 'package:flutter/foundation.dart';

import 'push_gateway.dart';

/// The four kinds the server ever pushes (`contract/realtime.md`, "Push
/// notifications (FCM)": "Exactly four kinds push ... Nothing else is ever
/// pushed"), by their wire string.
enum PushKind {
  supportTicketReplied('support_ticket_replied'),
  friendRequestReceived('friend_request_received'),
  academicYearOpened('academic_year_opened'),
  chatMessageReceived('chat_message_received');

  const PushKind(this.wire);

  /// The exact string in the payload's `data.kind`.
  final String wire;

  /// The kind for a wire string, or `null` for anything this build does not
  /// know - which is a normal answer, not an error: the contract says what to
  /// do with it ([resolvePushTap]).
  static PushKind? fromWire(String? wire) {
    for (final kind in values) {
      if (kind.wire == wire) return kind;
    }
    return null;
  }
}

/// Where a tapped notification goes. Sealed so a caller must handle both.
sealed class PushTapResolution {
  const PushTapResolution();
}

/// Open [location] - a route that exists today.
@immutable
final class PushTapOpen extends PushTapResolution {
  const PushTapOpen(this.location);

  /// A go_router location. For a ticket it carries the (opaque) ticket id, so
  /// [toString] withholds it.
  final String location;

  @override
  bool operator ==(Object other) =>
      other is PushTapOpen && other.location == location;

  @override
  int get hashCode => location.hashCode;

  @override
  String toString() => 'PushTapOpen';
}

/// The notification is a known kind whose destination is not built yet, so
/// there is no route to open (friend requests: CW09; chat conversation: CW10).
/// A typed result rather than a silent fallback: whoever wires the taps decides
/// what the user sees, and this answer says plainly that nothing was chosen for
/// them.
@immutable
final class PushTapTargetNotBuilt extends PushTapResolution {
  const PushTapTargetNotBuilt(this.kind);

  final PushKind kind;

  @override
  bool operator ==(Object other) =>
      other is PushTapTargetNotBuilt && other.kind == kind;

  @override
  int get hashCode => kind.hashCode;

  @override
  String toString() => 'PushTapTargetNotBuilt(${kind.wire})';
}

/// The notifications screen (`/notifications`) - the inbox, which exists.
const kPushFallbackLocation = '/notifications';

/// Maps a tapped push to where it goes, per `contract/realtime.md` "Tap
/// handling". **Pure**: a function of the payload alone, no router, no state, no
/// logging.
///
/// | `data.kind` | result |
/// |---|---|
/// | `support_ticket_replied` + `ticketId` | open `/support/tickets/{ticketId}` |
/// | `academic_year_opened` | open `/notifications` (the same event is an inbox row) |
/// | `friend_request_received` | [PushTapTargetNotBuilt] - the friend requests list is CW09 |
/// | `chat_message_received` | [PushTapTargetNotBuilt] - the conversation route is CW10 |
/// | anything else, or no `kind` | open `/notifications` and ignore the rest |
///
/// The last row is the contract's own rule: "**An unknown `kind`: open the
/// notifications screen and ignore the rest.**" A `support_ticket_replied`
/// without a usable `ticketId` is a payload the server promises never to send;
/// it is treated like an unrecognisable one (`/notifications`) rather than
/// guessed at, since the contract defines no other destination for it.
///
/// The ticket id is opaque (`getMySupportTicket` is keyed by it); it is
/// percent-encoded into the path and otherwise passed through untouched.
PushTapResolution resolvePushTap(PushTap tap) {
  final kind = PushKind.fromWire(tap.kind);
  if (kind == null) return const PushTapOpen(kPushFallbackLocation);
  switch (kind) {
    case PushKind.supportTicketReplied:
      final ticketId = tap.data['ticketId'];
      if (ticketId == null || ticketId.trim().isEmpty) {
        return const PushTapOpen(kPushFallbackLocation);
      }
      return PushTapOpen('/support/tickets/${Uri.encodeComponent(ticketId)}');
    case PushKind.academicYearOpened:
      return const PushTapOpen(kPushFallbackLocation);
    case PushKind.friendRequestReceived:
    case PushKind.chatMessageReceived:
      return PushTapTargetNotBuilt(kind);
  }
}
