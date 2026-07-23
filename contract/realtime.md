# Realtime contract — SignalR (ADR-026 §9)

OpenAPI covers REST only; this file is the owned artifact for realtime. Payloads follow the same JSON conventions (camelCase, UUIDv7 ids, UTC ISO 8601). Same change process as openapi.yaml (entries in contract-changelog.md).

## Hubs (to be drafted with their specs)

| Hub | Owner module | Purpose | Status |
|---|---|---|---|
| `leaderboard` | Gamification | Live rank updates (scoped per adr-015, privacy per adr-023) | not drafted |
| `streaks` | Social | StreakPair updates, ForwardedQuestion events | not drafted |
| `chat` | Social | Friend chat messages/photos (moderation states, adr-021) | not drafted |

For each hub, drafting means: hub route, auth handshake (Bearer), client→server methods, server→client events, payload schemas, reconnect/backfill semantics.
