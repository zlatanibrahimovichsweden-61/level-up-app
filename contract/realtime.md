# Realtime contract — SignalR (ADR-026 §9)

OpenAPI covers REST only; this file is the owned artifact for realtime. Payloads follow the same JSON conventions (camelCase, UUIDv7 ids, UTC ISO 8601). Same change process as openapi.yaml (entries in contract-changelog.md).

## Hubs (to be drafted with their specs)

| Hub | Owner module | Purpose | Status |
|---|---|---|---|
| `leaderboard` | Gamification | Live rank updates (scoped per adr-015, privacy per adr-023) | not drafted |
| `streaks` | Social | Folded into `chat` (spec-056, adr-219) — will not be built | folded into `chat` |
| `chat` | Social | Friend one-to-one **text** chat events (spec-055, adr-196) — see below; forwarded-question cards and friend-streak changes (spec-056, `stable` since 3.44.0-m1) | **stable** (3.39.0-m1; drafted 3.31.0-m1) |

For each hub, drafting means: hub route, auth handshake (Bearer), client→server methods, server→client events, payload schemas, reconnect/backfill semantics.

## `chat` hub — `stable` (spec-055, adr-196 D5/D7; stable since 3.39.0-m1)

**Build against it.** Every state change in chat is a REST call (`openapi.yaml`, tag `chat`); this hub only **pushes** what changed, plus one fire-and-forget `typing` signal. Photo, voice and group chat are not part of it.

### Route and authentication

- **Route:** `/hubs/chat` (outside `/api/v1`).
- **Auth:** the same bearer access token as REST — in the `Authorization` header, or, for the WebSocket handshake where a header cannot be set, in the `access_token` query parameter. The query string is scrubbed from every server log.
- **Connect is refused** for an invalid or expired token, a superseded session (logged in on another device), and an account pending deletion (adr-114).
- **Transport — WebSockets only, with `skipNegotiation: true`.** Set the client's transport to WebSockets and turn negotiation off (in most SignalR clients: `transport: WebSockets`, `skipNegotiation: true`). Pass the token through the client's access-token option; it then travels as the `access_token` query parameter of the WebSocket handshake.

**What this means for you.** Production runs the API on more than one server behind a load balancer. A negotiated connection is two separate requests (negotiate, then connect), and the load balancer can send them to different servers, so the second one fails. With negotiation skipped the connection is one WebSocket request, and it stays whole on one server. Nothing else changes: the route, the token, the events, their payloads and your reconnect-then-REST-backfill logic are the same as before.

### Session invalidation (adr-196 G-4 / D7)

- The session is checked **at connect, on every client invocation, and before every push**, against the same session store the REST `401 session_superseded` check uses.
- A connection whose session is superseded is **aborted** and receives nothing further.
- A connection also closes when its access token expires. The client reconnects with a fresh token.
- **At most 3 open `chat` connections per student** (adr-201 D7). A fourth connection closes the OLDEST one, never the new one, so a reconnecting app is never locked out by its own stale connections. Open one connection per app instance and reuse it.

### Client → server

| Method | Arguments | Behaviour |
|---|---|---|
| `typing` | `{ conversationId }` | Fire-and-forget. Tells the peer the caller is typing. Nothing is stored and no content is carried. An unauthorized call (not a participant, conversation ended) or one over the limit (30 per student per 60 s, its own budget) is **dropped silently** — no error is returned. |

### Server → client events

Every event goes only to the two participants of a live conversation, addressed by the server-resolved student id — never by a client-supplied id. Before each push the server re-checks, live, that the conversation still exists, the recipient is still a participant, and the recipient's account is not pending deletion; a failed check drops the event.

| Event | Payload | Meaning |
|---|---|---|
| `messageCreated` | `{ message: ChatMessage }` | A new message. `sentByMe` is computed for the receiving connection. |
| `messageEdited` | `{ message: ChatMessage }` | A message's body changed (`editedAt` set). |
| `messageDeleted` | `{ conversationId, messageId }` | A message was deleted **for everyone** — show the tombstone. (`scope=me` deletes emit nothing to the peer.) |
| `conversationRead` | `{ conversationId, lastReadMessageId }` | The **peer's** read cursor moved — drives "Seen". |
| `typing` | `{ conversationId }` | The peer is typing. Show it for about 5 seconds; the timeout is client-side only. |
| `conversationRemoved` | `{ conversationId }` | The conversation is gone (unfriend, block or Track transfer). Sent to both participants and identical in every case — never infer a block from it. |

`ChatMessage` is the `openapi.yaml` schema of the same name.

### Forwarded-question events (spec-056) — `stable` since 3.44.0-m1

A forwarded-question card arrives through the existing `messageCreated` with `message.kind: forwardedQuestion`, in the receiving student's own view (`ChatMessage`, `ForwardedQuestionCard`). Every rule above applies to the two new events: participants only, server-resolved student ids, the live re-check before each push, at-most-once delivery, REST backfill.

| Event | Payload | Meaning |
|---|---|---|
| `forwardedQuestionAnswered` | `{ message: ChatMessage }` | A forwarded-question card in this conversation was answered. Each participant receives their OWN view: the forwarder sees `answered` and `correct` only; the recipient also sees `selectedOptionId` and `correctOptionId`. Replace the card in local state. |
| `friendStreakChanged` | `{ friendStreak: FriendStreak }` | The pair's friend streak took today's step (adr-203). `friendStreak.friendStudentId` is always the OTHER participant for the receiving student. Not sent when a second answer the same Cairo day leaves the count unchanged. A streak that breaks at Cairo midnight emits nothing — read `listMyFriendStreaks`. |

Backfill: `listConversationMessages` (cards) and `listMyFriendStreaks` (streaks). REST is the source of truth.

### Delivery and backfill

- **At-most-once, best-effort.** An event can be missed (no connection, app backgrounded, reconnect).
- **Backfill is REST:** after (re)connecting, call `listConversations`, then `listConversationMessages` for the open conversation. REST is the source of truth.
- An event never carries anything REST would refuse the recipient.
- **Expiry emits no event.** A message expires 24 hours after the recipient read it or 30 days after it was sent (adr-196 D1); drop any message REST no longer returns.

### Notifications

A new message may produce a push of kind `chat_message_received` carrying only `kind` and `conversationId`, rendered from generic keys (no name, no text); at most one per conversation per 5 minutes; none when the app's chat connection received the message on the serving instance; it writes no inbox row (adr-196 D9, adr-221 as amended 2026-10-07 evening). A forwarded-question card makes the same `chat_message_received` push as a text message; answering a card makes none. See **Push notifications** below.

## Push notifications (FCM) — `stable` shape, delivery staged

Push is not SignalR; it is documented here because it is the other server-initiated channel (spec-068, adr-221). **The shape below is `stable`. Delivery is off in every environment until the staging verification is recorded, then switched on in production per adr-221.** Build against the shape now; do not expect a push from any environment until you are told it is on.

- **Exactly four kinds push** (adr-221 D1 as amended 2026-10-07 evening): `support_ticket_replied`, `friend_request_received`, `academic_year_opened`, `chat_message_received`. Nothing else is ever pushed — not `enrolment_opened`, not `announcement`.
- **Notification messages with localization keys, never text.** The server sends no title or body text, no name, no message text and no ticket subject. Android receives `android.notification.title_loc_key` / `body_loc_key`; iOS receives `apns.payload.aps.alert.title-loc-key` / `loc-key` with `sound: default`. The phone renders the keys from strings shipped in the app, so **the text follows the phone's language**, not the in-app language switch.
- **`data` holds `kind` (the wire string below) and opaque ids only**, all string values. Any other key is never sent.

| `kind` | Title key / body key | `data` |
|---|---|---|
| `support_ticket_replied` | `push_support_ticket_replied_title` / `push_support_ticket_replied_body` | `kind`, `ticketId` |
| `friend_request_received` | `push_friend_request_received_title` / `push_friend_request_received_body` | `kind`, `friendRequestId` |
| `academic_year_opened` | `push_academic_year_opened_title` / `push_academic_year_opened_body` | `kind` |
| `chat_message_received` | `push_chat_message_received_title` / `push_chat_message_received_body` | `kind`, `conversationId` |

The eight strings the app ships:

| Key | English | Arabic |
|---|---|---|
| `push_support_ticket_replied_title` | Support replied | رد فريق الدعم |
| `push_support_ticket_replied_body` | You have a new reply on your support ticket. | لديك رد جديد على تذكرة الدعم. |
| `push_friend_request_received_title` | Friend request | طلب صداقة |
| `push_friend_request_received_body` | You have a new friend request. | لديك طلب صداقة جديد. |
| `push_academic_year_opened_title` | New academic year | عام دراسي جديد |
| `push_academic_year_opened_body` | A new academic year has started. Open the app to get ready. | بدأ عام دراسي جديد. افتح التطبيق واستعد. |
| `push_chat_message_received_title` | New message | رسالة جديدة |
| `push_chat_message_received_body` | You have a new message. | لديك رسالة جديدة. |

- **Tap handling.** `support_ticket_replied`: open the ticket (`ticketId`, `getMySupportTicket`). `friend_request_received`: `friendRequestId` equals the incoming request's `requestId`; open the friend requests list (`listMyFriendRequests`). `academic_year_opened`: open the notifications screen — the same event also arrives as an inbox item of kind `academic_year_opened` (its `track` and `academicYear` are inbox `data`, never push `data`). `chat_message_received`: open the conversation (`conversationId`); it writes no inbox row. **An unknown `kind`: open the notifications screen and ignore the rest.**
- **At most one per event.** A push is never repeated for the same event once delivered. Each kind is limited per student per hour; a chat conversation produces at most one push per 5 minutes, and none while the app's chat connection received the message.
- **Token.** The app registers its FCM token after sign-in and on every token refresh (`registerFcmToken`, `PUT /api/v1/me/fcm-token`); one token per student, the latest wins.
