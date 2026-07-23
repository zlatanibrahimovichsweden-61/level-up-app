# Brief — Forced-logout + session guard (closes Day 1 auth)

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> This is **infrastructure, not a designed screen** — the Figma Common Sign-up flow
> has no forced-logout frame, so the "you've been signed out" state is a redirect to
> `/login` + a one-time message (snackbar/banner). If the designer later supplies a
> frame, swap it in.

## Skills (in order)

1. `level-up-domain` — operating rules (server-authoritative, minors, glossary)
2. `seif-api-contract` — refresh/logout against `contract/openapi.yaml`
3. `flutter-setup-declarative-routing` — the go_router `redirect` + `refreshListenable` pattern
4. `river` — `AuthController` as a Riverpod `Notifier`, exposed as a `Listenable`
5. `screen-states` — the login message pass (AR/EN)

## Contract (verbatim, both stable, `security: []` on refresh)

```
POST /auth/refresh
  req:  { refreshToken: string, deviceId: string }   # deviceId = the SAME stable id sent at verify
  200:  TokenPair   # rotated — new access + new refresh
  401:  refresh_token_invalid   # expired / revoked / REUSED (reuse revokes the whole chain → full re-login)
        session_superseded      # a newer device session exists → forced logout

POST /auth/logout   # requires Bearer
  204:  revoked (idempotent)
  401:  authentication_required
```

Key contract facts that drive the design:
- **Any authenticated endpoint** can return `401 session_superseded` at any moment (instant device eviction, adr-019).
- `authentication_required` = access token missing/expired → refresh, retry once.
- `refresh_token_invalid` = the refresh itself is dead → full re-login (clear tokens).
- Refresh sends `deviceId` from `SecureStorage.readOrCreateDeviceId()`.

---

## Piece 1 — `AuthController` (the single source of auth truth)

New: `lib/features/auth/notifier/auth_controller.dart` (+ provider in `core_providers.dart` or here).

- State: `sealed AuthStatus { unknown, authenticated, unauthenticated(LogoutReason?) }`
  where `LogoutReason { supersededOtherDevice, sessionExpired, userInitiated }`.
- `build()`: read access token → `authenticated` if present else `unauthenticated(null)`. Start as `unknown` only if the read is async (first frame).
- `markAuthenticated()` — called after tokens are written (see Piece 5 wiring).
- `forceLogout(LogoutReason reason)` — `SecureStorage.clearTokens()` then state = `unauthenticated(reason)`. **Never** `clear()` (preserve `device_id` — see Decisions_Log 2026-07-23).
- `logout()` — best-effort `POST /auth/logout` (ignore failures), then `clearTokens()`, state = `unauthenticated(userInitiated)`. (No caller yet; Settings wires the button later.)
- Expose a `Listenable` for go_router: either `ChangeNotifierProvider`-style or wrap with a small `ValueNotifier` mirror. The router's `refreshListenable` watches it.

## Piece 2 — Refresh in the repository

`auth_repository.dart`: add
```
Future<TokenPair> refresh({required String refreshToken, required String deviceId});
Future<void> logout();   // POST /auth/logout, Bearer, 204; swallow 401 authentication_required
```
`refresh` throws the typed exceptions (`UnauthorizedException` carrying `refresh_token_invalid` / `session_superseded`) via the existing ErrorInterceptor mapping.

## Piece 3 — `AuthInterceptor` rewrite (the hard part — get concurrency right)

Rewrite `lib/core/network/interceptors/auth_interceptor.dart`:

- `onRequest`: attach Bearer (unchanged).
- `onError`, when `response?.statusCode == 401`:
  - Read the mapped `code` from the error.
  - **`session_superseded`** → `authController.forceLogout(supersededOtherDevice)`; `handler.reject(err)`. Do NOT refresh, do NOT retry.
  - **`authentication_required`** → attempt a **single-flight** refresh:
    1. If this request was already retried (`options.extra['__retried'] == true`) → reject (prevents loops).
    2. If a refresh is already in flight, await that same `Future` (concurrent 401s share ONE refresh).
    3. Otherwise run refresh: read `refreshToken` + `deviceId` from storage → `authRepository.refresh(...)`.
       - **success** → `writeTokens(new)`; re-issue the ORIGINAL request once with `extra['__retried']=true` and the new access token; `handler.resolve(response)`.
       - **`refresh_token_invalid`** → `forceLogout(sessionExpired)`; reject.
       - **`session_superseded`** → `forceLogout(supersededOtherDevice)`; reject.
       - **network/offline error** (`NetworkException`/`OfflineException`) → do NOT log out (transient); reject with that error so the caller shows offline/error and can retry.
  - Any other 401 code (e.g. `registration_token_invalid`) → just reject; not this interceptor's job.
- **Loop safety:** the refresh call must NOT pass back through this retry path. Use a dedicated Dio (no AuthInterceptor) for the refresh request, OR tag the refresh request with `extra['__isRefresh']=true` and early-return in `onError`. Prefer a separate bare Dio built in the repository.
- The interceptor needs the `AuthController` — inject it (constructor) so it never navigates directly; it only flips auth state, and the router reacts.

## Piece 4 — Router redirect guard

`app_router.dart`:
- `GoRouter(refreshListenable: <authController listenable>, redirect: (context, state) { ... })`
- Logic:
  ```
  final status = ref.read(authControllerProvider);      // read fresh
  final atAuthRoute = {'/login','/otp','/register'}.contains(state.matchedLocation);
  if (status is Unknown) return null;                   // splash/first frame
  if (status is Unauthenticated && !atAuthRoute) return '/login';
  if (status is Authenticated && state.matchedLocation == '/login') return '/home';
  return null;
  ```
- Remove the `initialLocation: '/login'` assumption's staleness — the guard now decides. Keep `/` (onboarding) deferred.
- On `forceLogout`, the listenable fires → redirect re-runs → user lands on `/login`.

## Piece 5 — Wire login success into AuthController

`otp_notifier.dart` currently writes tokens then emits `AuthenticatedOutcome`. Add: after `writeTokens`, call `authController.markAuthenticated()` so the router flips to authenticated. (Alternatively the router reads the token directly, but the controller is the single source — prefer calling it.)

## Piece 6 — The forced-logout message (no screen)

On `/login`, read the `LogoutReason` from `AuthController` and show it **once** (SnackBar or a top banner), then clear it so it doesn't repeat:
- `supersededOtherDevice` → new l10n key, e.g. EN "You've been signed out — your account was used on another device." / AR equivalent.
- `sessionExpired` → EN "Your session expired. Please sign in again." / AR.
- `userInitiated` → no message.
Add the keys to both `.arb` files.

---

## Edge cases (must all hold)

| Case | Expected |
|---|---|
| Concurrent 401s (several requests) | refresh runs **exactly once**; all retried after |
| Refresh request itself 401s | no recursion (separate Dio / `__isRefresh` guard) |
| Already-retried request 401s again | reject, no second retry |
| Offline during refresh | NO logout (transient) — surface offline/error, allow retry |
| `session_superseded` on any endpoint | immediate forceLogout, no refresh |
| `refresh_token_invalid` | forceLogout(sessionExpired), tokens cleared |
| App start, no token | `unauthenticated` → `/login` |
| App start, expired access + valid refresh | first authed call 401 → refresh → succeeds silently |
| logout endpoint returns 401 | treat as already-logged-out; clearTokens anyway |
| forceLogout | uses `clearTokens()`, `device_id` preserved |

## Acceptance / tests

- Interceptor unit tests (mock Dio + mock repo):
  - `authentication_required` → refresh once → original retried with new token → success
  - `session_superseded` → forceLogout, tokens cleared, no refresh, no retry
  - refresh → `refresh_token_invalid` → forceLogout(sessionExpired)
  - concurrent 401s → refresh called exactly once
  - already-retried → not retried again
  - offline during refresh → no logout
- Router tests: unauthenticated → `/login`; authenticated at `/login` → `/home`; forceLogout flips to `/login`.
- Login shows the reason message once (widget test), AR + EN.
- `flutter analyze` clean · full suite green · `build_runner` ok.

## Scope / do NOT

- No new designed screen; no Settings logout button yet (just the `logout()` method).
- Don't touch Paymob/deep-link routes. Don't build `/register` or `/home` (still placeholders).
- Do NOT commit — leave for review.
