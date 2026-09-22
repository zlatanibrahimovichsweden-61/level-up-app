# Part 13 — Contract/backend residual gaps (Wave 2-A), HEAD bf967d6, pin 768e67d (3.22.0-m1), 2026-09-22

**Verification levels used:** SOURCE = read in repo at HEAD; STAGING = unauthenticated GET/HEAD/POST
observed today (2026-09-22) against `level-up-backend-staging.up.railway.app` — not a claim about
production, which does not exist yet (see item 2). Read-only, no OTP requests, no personal data sent.

**Scope note:** this part resolves ten specific residuals left open after part 05 (contract/backend
audit) and part 12 §§POL-03/04/12 (policy gap analysis). It does not re-walk the full contract or
policy surface — see those two files for the census and the verdicts. New findings below continue
the ID series from part 05: **API-16 onward**.

---

## 1. Device binding vs concurrent reviewers

**One session per student, not per device — any new-device verify evicts the prior one, globally.**

> "Access JWT ~15 min; rotating refresh token, TTL 60 days. **Session eviction is instant**: the
> server checks the session version (Redis) on every authenticated request, so ANY endpoint may
> return `401` + `code: session_superseded` at any moment (logged in on another device)."
> — `contract/openapi.yaml:56-59`

Verify-OTP eviction text, quoted exactly:

> "Proving possession forks the flow: `authenticated` = tokens + profile, and if this is a NEW
> device the previous device's session is revoked HERE (it starts seeing `session_superseded`)."
> — `contract/openapi.yaml:178-181` (`verifyOtp` description)

`error-codes.md:13` — `session_superseded | 401 | Logged in on another device — this session was
evicted | Device binding (adr-019); app shows forced-logout flow`.

The binding key is the **account** (one active session per student), enforced by comparing a Redis
session version on every request — nothing in the mechanism is scoped to a device fingerprint or
IP; the device is only *recorded* (`DeviceInfo.model`, item 4 below), not what the eviction keys on.

**Conclusion: yes, two Apple reviewers — or a human reviewer plus Play's Robo device-farm crawler —
signed into the same reviewer phone number concurrently on two devices would evict each other.**
The second `verifyOtp` call on a second device revokes the first device's session immediately
(`:178-181`); the first device's next request answers `401 session_superseded` (`:56-59`). This is
exactly the risk POL-03 §Reasoning-1 already flagged; this item supplies the load-bearing quotes.

**No whitelist exemption exists for either eviction or the per-IP OTP throttle.** The only
whitelisting text in the contract is:

> "**Staging test numbers:** reserved fake numbers (+20100000000xx) are whitelisted in staging
> config only — fixed OTP `000000`, no SMS/WhatsApp ever sent, **rate limits identical to prod**
> (so throttle/lock states are testable). Absent from production configuration."
> — `contract/openapi.yaml:96-98`

That paragraph exempts the whitelisted numbers from *needing a real OTP*, and explicitly states rate
limits stay **identical to prod** for them — the opposite of an exemption. It says nothing about
device-binding/eviction at all: whitelisted numbers go through the same `verifyOtp` path at
`:178-181` and are evicted the same way a real number would be. There is no `x-`-extension, no
scope, and no error-code carve-out anywhere in `openapi.yaml` or `error-codes.md` for a
reviewer/QA cohort's eviction or IP-throttle behaviour. **Confirms part 05 Q1 and POL-03's
"ask Seif for ≥3 whitelisted numbers or a relaxed device-binding rule" — no contract mechanism
does this today; it would require a new backend rule.**

---

## 2. `servers:` block — no production URL anywhere

```yaml
servers:
  - url: https://level-up-backend-staging.up.railway.app/api/v1
    description: staging
```
— `contract/openapi.yaml:107-109`, verbatim, the entire block. **One entry, staging only.** No
`production`/`prod` server object exists in the document.

Repo-wide search for a "prod" hostname:

```
grep -rn -i "TBD.example" docs/ lib/ contract/
```

finds the placeholder `https://TBD.example/api/v1` only in **app-side** and **doc** files
(`lib/core/config/app_config.dart:54`, `docs/STORE_READINESS.md:40`, `docs/RISKS.md:121-122`,
`docs/seif_fight.md:605,656`, `docs/PROJECT_GUIDE.md:97`, `docs/DEVICE_VERIFICATION_2026-09-12.md:168,177`,
`docs/LEVEL_UP_AUDIT_2026-07-28.md:258,425`, `docs/STORE_READINESS_AUDIT_2026-09-05.md:33,68`,
`docs/PROGRESS.md:312,325`, `docs/day7_quiz_brief.md:441`, `docs/day7c_contract_v11_brief.md:444`)
— **never in `contract/`**. The contract itself has no placeholder and no real prod value; it simply
does not mention production. `contract-changelog.md:363` records the **staging** URL replacing an
earlier `staging.TBD.example` placeholder (2026-08-23) — that entry is staging-only too. **No "prod"
hostname exists anywhere in `contract/` or `docs/` as of this pin.** Confirms part 05 API-02/Q2 and
POL-03 requirement #1 (`Production host … Nothing below is testable without this`) are both still
fully open — this is not a reading gap, the value has never been published.

---

## 3. Deletion copy — banned-vocabulary collision, post-202 behaviour, grace-window allowlist

**Verbatim, `contract/openapi.yaml:999-1024`** (the `requestAccountDeletion` description in full):

> "Records a deletion request for the **caller's own** account (there is no id parameter) and
> returns the window. `effectiveAt` is `requestedAt` + 30 days, UTC, and is a **"no earlier
> than"** time: erasure runs from a daily job, so execution may lag `effectiveAt` by up to
> ~24 hours.
>
> **What happens immediately, at request time.** The caller's session and refresh chain are
> revoked — this `202` is the last thing that token does, so send the student to the login
> screen and purge the token pair; a retry with it will fail. The student is also removed
> from every peer-visible surface at once (leaderboards included).
>
> **Confirm-screen copy the app must show BEFORE calling this (adr-114 D3).** The request is
> reversible only inside the grace window, by logging in again and calling
> `DELETE /me/deletion-request`. **An active paid subscription is forfeited** — there is no
> partial refund, the remaining paid time is not restored by cancelling, and it does not
> carry to a future account. **A new account registered later with the same phone number
> starts from zero** — no points, no level, no badges, no quiz history. The phone stays
> blocked for the whole grace window (the account still exists) and is freed at execution.
>
> **During grace the account offers exactly one action**, enforced server-side: every
> authenticated `/api/v1` endpoint outside a four-endpoint allowlist answers `403`
> `account_pending_deletion`. The allowlist and the anonymous-recovery carve-out are in this
> document's top-level description."
— `contract/openapi.yaml:999-1024`

**Words that collide with adr-171 §3's banned list** (price / buy / purchase / payment / subscribe
/ paid / refund / provider / amount / currency), checked mechanically against lines 999-1024:

| Banned word | Present? | Location |
|---|---|---|
| paid | **yes** (×2) | "**An active paid subscription** is forfeited"; "the remaining **paid** time is not restored" (`:1014-1015`) |
| refund | **yes** (×1) | "there is no partial **refund**" (`:1015`) |
| price, buy, purchase, payment, subscribe, provider, amount, currency | no | not present in this range |

So exactly **three occurrences of two banned words** ("paid" ×2, "refund" ×1) — this matches POL-04's
finding verbatim; this item is the mechanical word-count confirming it.

**What the app must do after the 202, per contract:** purge the token pair and route to login
(`:1006-1009`, quoted above) — the contract is explicit that "a retry with it will fail" and gives no
in-app confirmation surface, because the session is dead at that instant. The contract does **not**
mandate or mention an out-of-band (SMS/email) completion confirmation anywhere in `openapi.yaml` or
`contract-changelog.md` — that requirement comes from Apple policy (POL-04 §Reasoning (b)), not from
the contract, and is an open ask to Seif, not something the contract already answers.

**Four-endpoint allowlist, quoted from the document's top-level description** (`openapi.yaml:63-72`):

> "## Account deletion during grace (adr-114)
>
> A student with a pending deletion request can still log in, but the account offers **exactly
> one action**, and that is enforced server-side rather than by the client. Every authenticated
> `/api/v1` endpoint answers `403` + `code: account_pending_deletion` **except these four**:
> `GET /me`, `POST /me/deletion-request` (so its `409` is reachable and never shadowed by the
> `403`), `DELETE /me/deletion-request`, and `POST /auth/logout`. The rule is **default-deny** —
> an endpoint added to this document later is blocked during grace unless it is added to that
> list, so do not read the four as a category."
> — `contract/openapi.yaml:63-72`

Login during the grace window (the **anonymous** ladder, exempt by construction, quoted in full):

> "The whole **anonymous** ladder is outside the restriction by construction, because it carries
> no authenticated principal: `POST /auth/otp/request`, `/auth/otp/verify`, `/auth/register`,
> `/auth/refresh`, `/auth/recovery/start`, `/auth/recovery/verify-parent`,
> `/auth/recovery/new-phone` and `/auth/recovery/confirm` all behave normally during grace. That
> is deliberate and load-bearing: a student who lost their device must be able to recover an
> account in order to cancel its deletion."
> — `contract/openapi.yaml:74-81`

So login itself (`otp/request` + `otp/verify`) is not "restricted" (it's anonymous, always allowed);
**once authenticated**, the four-endpoint allowlist (`GET /me`, `POST/DELETE /me/deletion-request`,
`POST /auth/logout`) is what remains reachable. Everything else — including `redeemSubscriptionCode`
— answers `403 account_pending_deletion` (part 05 Q12 remains open: the contract's default-deny rule
implies this covers redemption too, but there is no explicit sentence naming that operation, so it
is an inference, not a quoted fact — keep it as an ask to Seif, not a confirmed answer).

---

## 4. `deviceId` semantics and the iOS Keychain contradiction

**Verbatim, `contract/openapi.yaml:2239-2246`:**

```yaml
DeviceInfo:
  type: object
  description: Client-generated STABLE id (survives app restarts, regenerated on reinstall) — the device-binding key (adr-019).
  properties:
    deviceId: { type: string, maxLength: 64 }
    platform: { type: string, enum: [android, ios] }
    model: { type: string, maxLength: 100, description: "Display label for eviction messaging, e.g. \"Redmi Note 12\"." }
  required: [deviceId, platform]
```

Two separate contract claims, both quoted above:
1. `deviceId` is "**regenerated on reinstall**" (`:2242`).
2. `model` exists specifically as a "**Display label for eviction messaging**" (`:2245`) — i.e. the
   contract's own reasoning for shipping `model` at all is so a forced-logout screen can tell the
   student *which* device evicted them ("signed out because of Redmi Note 12").

**Contract-accuracy item (cross-referenced from part 04 IOS-06, not re-derived here):** on iOS,
`flutter_secure_storage`'s Keychain-backed values **survive app uninstall** — only
`first_unlock_this_device` blocks cross-device/backup migration, not uninstall-then-reinstall on the
*same* device (`lib/core/storage/secure_storage.dart:31-34,66-69`; part 04 IOS-06). The app's
`deviceId` is generated once and stored exactly there (`device_info_provider.dart:11`), with no
first-launch-after-install guard. So on iOS, a real reinstall does **not** regenerate `deviceId` —
the old value survives and a second student on a hand-me-down iPhone silently inherits the first
student's `device_id` and, transitively, whatever eviction/session state hangs off it. **The
contract's own words ("regenerated on reinstall") are therefore false for the current iOS
implementation** — not a contract defect, but a build-vs-contract accuracy gap that should be logged
against IOS-06, because it means the eviction-messaging feature described in `:2245` (show which
device kicked you off) is being fed a stale identity on iOS reinstalls. This is the same point
part 12 §POL-11 already raised (`.ai/audits/current/store_readiness_parts/12_policy_gap_analysis.md:1023-1029`)
— recorded here as the contract-side half of that finding, confirmed against the live contract text
this session.

---

## 5. Retention / erasure / audit statements — exhaustive collection

Every sentence in `contract/openapi.yaml` and `contract/contract-changelog.md` touching retention,
erasure, "forever", a scheduled job, or pseudonymity/audit, with line numbers:

| # | Statement (quoted or tightly paraphrased) | Location |
|---|---|---|
| 1 | "erasure runs from a daily job, so execution may lag `effectiveAt` by up to ~24 hours" | `openapi.yaml:1001-1003` |
| 2 | "`effectiveAt`: … Erasure runs no EARLIER than this; the daily job may execute it up to ~24 h later." | `openapi.yaml:1034` (`202` response schema) |
| 3 | Same field, embedded read-only copy on `StudentProfile.pendingDeletion.effectiveAt`: "erasure runs no earlier than this. Cancel with `DELETE /me/deletion-request` before then." | `openapi.yaml:2437` |
| 4 | "`no_pending_deletion` — … Also returned once erasure has begun executing for this account: the grace window is over in fact, not just in wording, and the request can no longer be withdrawn." | `openapi.yaml:1059` (`cancelAccountDeletion` `404`) |
| 5 | "adr-017 keeps every attempt forever — the gate filters what is drawable, it does not delete" (quiz attempts) | `openapi.yaml:1426` |
| 6 | "Full quiz history (adr-017), newest first" | `openapi.yaml:1464` |
| 7 | Question-explanation text "generated once per question and cached server-side forever" | `openapi.yaml:1580` |
| 8 | Content/card image URLs: "it is safe to cache forever" (content-addressed, immutable) | `openapi.yaml:2494` |
| 9 | "Heavily rate-limited **+ audited**" — `startRecovery` (draft), because it confirms account existence | `openapi.yaml:443` |
| 10 | "any previous session is revoked, and the event **is audited** (adr-019 anti-sharing guard — recovery never grants a second concurrent session)" — `confirmRecovery` (draft) | `openapi.yaml:568` |
| 11 | `security.md` cited as the source for staging-number handling but not vendored | `openapi.yaml:98` ("See security.md") |
| 12 | "No admin/staff-initiated deletion … no erasure-status endpoint — **the audit is internal and pseudonymous**, and there is nothing for a client to poll; no web deletion URL (the Google Play Data-safety web leg is a separate, still-unowned decision)." | `contract-changelog.md:250` |
| 13 | "`imageUrl` … stays legal forever" / "safe to cache forever" (card images, not personal data) | `contract-changelog.md:116, 127, 133, 135` |
| 14 | OTP throttle is "per-identifier/device/IP" (a retention-adjacent statement: IP is processed, not just phone) | `openapi.yaml:169` |

**`security.md` is cited (`:98`, item 11) but is not in the vendored contract repo at this pin** —
confirmed again this session: `git -C contract ls-tree 768e67d` (re-run) still lists only
`openapi.yaml`, `openapi-admin.yaml`, `error-codes.md`, `error-codes-admin.md`,
`contract-changelog.md`, `contract-changelog-admin.md`, `realtime.md`, `SOURCE.md` — no
`security.md`. This is the single most-cited-but-unavailable retention source; everything about
logs, backups, subprocessors and IP retention is therefore genuinely absent from the contract, not
just unread. This is exhaustive for `openapi.yaml`/`contract-changelog.md` — nothing else in either
file uses "retain", "retention", "erase", "delete forever", "purge", or "audit" outside the 14 rows
above (`grep -n -i` re-run against both files for this report).

---

## 6. `docs/seif_fight.md` — open items touching store readiness

| Topic asked for | Filed as | Status text, quoted | Line(s) |
|---|---|---|---|
| Account deletion | **S38** | "🔴 … **This is not resolved.** The contract is no longer the blocker — build effort is. Nothing in `lib/` calls either operation, there is no cancel screen … **This entry stays Open until the re-vendor lands and the screen is built.**" (re-vendor since landed 3.22.0-m1; screen still not built per part 05 API-01) | `docs/seif_fight.md:1394-1417` |
| `parentPhone` write-only | **S34** | "🔴 … we compel a student to supply a parent's phone number at registration, and then there is no endpoint that will ever tell them what they gave us. Not read-only. Not masked. **Not at all.**" — **Open**, asks the server to add a masked form to `GET /me` | `docs/seif_fight.md:1279-1303` |
| `PATCH /me` can't edit school/geography | **S20** | "🟠 … School and geography are immutable after registration in v1.1." — **Open (Day 7c)** | `docs/seif_fight.md:1035-1055`, table row `:624` |
| Age rule / minimum age floor | **not filed** | Zero S-numbered entries. `grep -n -i "\bage\b"` over the file returns only incidental uses of "minor(s)" in S34's own prose (`:1163,1216,1300,1404,1413`) — no entry asks Seif for a `dateOfBirth` floor. This is a genuine gap in the ledger, not a "resolved" or even "open" item — it was **never filed**, and the question lives only in part 05 Q8/API-09 and POL-05 of this audit series. | — |
| Reviewer account (prod whitelist) | **not filed** | No S-number. The only place this is tracked is part 05's ad hoc "UNKNOWN — must ask backend" list (`05_api_backend.md:69`, Q1) and POL-03. `seif_fight.md`'s S-numbered ledger has no entry for it. | — |
| Production URL | **not filed** | Same — tracked only as `S1` **historically for staging** (`~~S1~~ … Resolved (2026-08-23) — 12/21 stable ops decoded against staging`, `:605`), which was closed when *staging* arrived; no S-number was ever opened for **production**. Prod-URL absence is tracked only in part 05 Q2/API-02 and POL-03 item 1. | `docs/seif_fight.md:605, 656, 664` (historical, staging-only) |
| Web deletion URL | **not filed** | No S-number. Tracked only in `contract-changelog.md:250` ("a separate, still-unowned decision") and part 05 API-04/Q3. | — |
| `security.md` | **not filed** | No S-number. Only the one inline citation at `openapi.yaml:98`; never raised as a question in `seif_fight.md`. | — |
| Name moderation (leaderboard) | **not filed** | No S-number. `error-codes.md`'s last line reserves codes for "chat block/report outcomes" (part 05 API-10) but `seif_fight.md` has no matching entry; the only place it's raised is part 05 Q10/API-10 and POL-06/POL-12(9). | — |

**Finding (API-16):** of the eight topics asked for, only **three** (S38 deletion, S34 parentPhone,
S20 school/geography) are actually filed as S-numbered `seif_fight.md` entries. The other **five** —
age floor, reviewer account, production URL, web deletion URL, `security.md`, name moderation — have
**never been filed there**; they exist only as ad hoc "UNKNOWN" questions inside part 05 and as
findings in part 12's policy analysis. `seif_fight.md`'s own header describes itself as the place
for "**Open question**, **Backend dependency**, **Confirmed fact**, **Unverified assumption**"
(`:37`) — every one of the five missing topics fits at least one of those categories and none is in
the ledger. **Severity D (process/hygiene):** the fix costs nothing (write five more S-numbered
entries from part 05's Q1–Q3, Q8, Q10) and removes the risk that a future session reads
`seif_fight.md` alone, sees only three deletion/profile items, and concludes reviewer-access and
prod-URL are not tracked anywhere.

---

## 7. `docs/DECISIONS.md` D-007 vs adr-171 — superseded, and who already knows

**D-007, quoted (`docs/DECISIONS.md:245-274`):**

> "### D-007 · The purchase surface is removed, and the limit-sheet bodies stop telling the student
> to upgrade
> **Feature:** Quiz / Profile / Router / l10n · **Date:** 2026-09-04 · **Status:** Accepted —
> surface final, wording provisional · **Raised by:** contract 2.2.0-m1 (adr-049 §3); ruled by the
> owner
>
> **Context.** adr-049 §3: the mobile app is **purchase-silent** — never a paywall, a price, an
> upgrade link, or where to buy; purchases happen on the website only, and voucher redemption is
> web-only (`x-consumers: [web]`). …
>
> **Consequences.** … Nothing in the app tells the student where to buy — that is the product
> decision, not an omission to fix later."

D-007 is dated 2026-09-04 and rules out *any* link at all ("never … an upgrade link"; "nothing in
the app tells the student where to buy"). **adr-171** (accepted 2026-09-16, twelve days later — per
the redemption warning doc read for this audit) explicitly reverses that: release 1 ships **exactly
one neutral link** to the redemption page (`flutter-partner-web-redemption-warning-v3.md` §2). D-007
is therefore **superseded/contradicted by a later, more authoritative decision** — it was correct
against the 2026-09-04 contract state and is factually wrong about the current one. **D-007 itself
has not been amended or given a follow-up entry** — `docs/DECISIONS.md` still shows it as
`Status: Accepted` with no cross-reference to adr-171, so a reader of `DECISIONS.md` alone (as
opposed to `store_readiness_state.md`) would not learn the "no link" ruling has been overtaken.

**Who already knows:** `grep -rn "adr-171\|spec-036\|redemption-session" docs/ contract/ .ai/` shows
the repo is **not** silent on this — adr-171/spec-036 are referenced extensively in
`contract/openapi.yaml` (`:216-219, 236, 242, 287, 1899, 1958, 1987`), `contract/error-codes.md:45`,
`contract/contract-changelog.md:17,23,30,33`, `contract/SOURCE.md:44`, and — most relevantly —
already flagged as a live contradiction in this same audit series:
`.ai/audits/current/store_readiness_parts/10_frontend_gaps_edge_cases.md:11,38,44,177,181`,
`12_policy_gap_analysis.md` (12+ references, e.g. `:88,110,494,516,564`), and
`.ai/audits/current/store_readiness_state.md:10,17,45,64-65,77,81` — the last of which states outright:
*"DECISIONS D-007/adr-049 §3 'no link at all' is now superseded by adr-171 — repo docs stale"*
(`store_readiness_state.md:65`). **Finding (API-17):** the contradiction is well-tracked at the
audit-report layer but **not yet closed at the source-of-truth layer** — `docs/DECISIONS.md` needs a
new decision entry (D-0xx) recording that D-007's "no link" clause is superseded by adr-171, the way
`DECISIONS.md` already does for other reversed rulings elsewhere in the file. Severity **D** (paper
fix, but leaves a live self-contradiction in the decisions ledger until written).

---

## 8. Rate limits — per-IP `/reference/*`, OTP throttle, and `Retry-After`

**`/reference/*` per-IP limit**, quoted (identical wording on every one of the seven reference
endpoints — countries, governorates, cities, schools, education-systems, universities, avatars):

> "`rate_limited` (unauthenticated per-IP limit on `/reference/*`) — honour `Retry-After`"
> — `contract/openapi.yaml:622, 649, 678, 717, 742, 786, 810`

**OTP throttle**, quoted:

> "`otp_throttled` (cooldown or per-identifier/device/IP limit)" — `openapi.yaml:169` (`otp/request`)
> "`otp_throttled` (cooldown or per-identifier/IP limit)" — `openapi.yaml:285` (`otp/verify`)

`error-codes.md:12` — `otp_throttled | 429 | OTP request/verify rate limit hit | adr-019 flood
protection` (no magnitude given). `error-codes.md:23` — `rate_limited | 429 | Generic request rate
limit hit (not OTP) | Unauthenticated /reference/* IP limit and any future non-OTP limiter. …
Honour Retry-After`.

**No numeric magnitude is declared anywhere** for either limiter — no requests-per-minute, no window
size, no burst allowance — in `openapi.yaml` or `error-codes.md`. This reconfirms part 05 Q13/UNKNOWN
exactly; this session did not find a number the prior audit missed.

**`Retry-After` is promised only for `rate_limited`, never for `otp_throttled`.** Every
`/reference/*` row above says "honour `Retry-After`"; the two `otp_throttled` rows (`:169, :285`)
say nothing about a header at all. The client-side timing for OTP throttling instead comes from the
`202` response body's own fields (part 05's auth summary: `resendAfterSeconds`/`expiresInSeconds`),
not a `Retry-After` header — so a reviewer farm hitting the **OTP** limiter behind one NAT has no
contract-declared header to read a cooldown from, only whatever the `429` body happens to contain
(unspecified in the schema for that status). This sharpens POL-03's "shared-NAT OTP throttling" risk:
it is not just that the magnitude is unknown, but that the **mechanism for a client to learn the
cooldown on an OTP `429` is undocumented**, unlike the `/reference/*` case which explicitly has one.

---

## 9. Staging probe (read-only, 2026-09-22)

```
$ curl -sD - -o /dev/null https://level-up-backend-staging.up.railway.app/api/v1/me/entitlements
HTTP/1.1 401 Unauthorized
www-authenticate: Bearer
Content-Type: application/problem+json
x-robots-tag: noindex, nofollow
(no Strict-Transport-Security header)

$ curl -sI https://level-up-backend-staging.up.railway.app/api/v1/me/entitlements   # HEAD, not GET
HTTP/1.1 405 Method Not Allowed
allow: GET
(no Strict-Transport-Security header)

$ curl -s -o /dev/null -w '%{http_code}' -X POST https://level-up-backend-staging.up.railway.app/api/v1/me/deletion-request
401

$ curl -sD - -o /dev/null -X POST https://level-up-backend-staging.up.railway.app/api/v1/me/deletion-request
HTTP/1.1 401 Unauthorized
www-authenticate: Bearer
(no Strict-Transport-Security header)

$ curl -sD - -o /dev/null https://level-up-backend-staging.up.railway.app/api/v1/me/deletion-request   # GET, not allowed
HTTP/1.1 405 Method Not Allowed
allow: DELETE, POST
```

**Result: both routes exist and reconfirm part 05's earlier probe** — `GET /me/entitlements` → `401`
(route live, auth required); `POST /me/deletion-request` → `401` (route live, auth required); the
`allow` headers (`GET` only on entitlements; `DELETE, POST` on deletion-request) match the contract's
declared verbs exactly (`getMyEntitlements` is GET-only at `:1065`; `requestAccountDeletion`/
`cancelAccountDeletion` are POST/DELETE at `:994, :1042`).

**Methodology note (API-18):** the task's literal instruction (`curl -sI … /me/entitlements`, "expect
401") actually sends a **HEAD** request, which this endpoint does not route — the server answers
`405 Method Not Allowed` with `allow: GET`, not `401`. A plain `GET` on the same path does answer
`401` as expected. This is not a server defect (HEAD is legitimately unrouted for a GET-only
resource) but is worth flagging so a future session doesn't misread a `405` on a HEAD probe as a
broken route.

**No `Strict-Transport-Security` header on any of the four responses above**, on either
`/me/entitlements` or `/me/deletion-request`, GET or POST — reconfirms API-12's "no HSTS header
seen" as still true today, one day inside the previously-recorded cert validity window
(`2026-07-29 → 2026-10-27`, per part 05 API-12; not re-checked this session since API-12 already
captured the full TLS/cert detail and nothing about the routes' existence bears on it).

---

## 10. `contract/realtime.md` — no mobile work implied

`contract/realtime.md` in full is three unstarted hubs (`leaderboard`, `streaks`, `chat`, all
"not drafted") plus a note that drafting one means "hub route, auth handshake, client→server
methods, server→client events, payload schemas, reconnect/backfill semantics" — none of which
exists yet. `contract/SOURCE.md` states directly: **"`realtime.md` has not changed since the initial
contract commit (`23f0535`) and is byte-identical here; no realtime work is implied by this delta."**
(`contract/SOURCE.md`, "Codegen surface" paragraph). Every `contract-changelog.md` entry that touches
the redemption journey also says "`realtime.md` is **unchanged** — this journey has no SignalR
surface" (`contract-changelog.md:17, 30`). **One line: `realtime.md` confirms zero mobile
implementation work exists or is implied at this pin — it is a placeholder for hubs that have not
been designed, and nothing in the recent redemption/deletion/entitlement work touches it.**

---

## New findings index (API-16 onward)

| ID | Sev | Area | One-line finding |
|---|---|---|---|
| API-16 | D | Docs hygiene | 5 of 8 store-readiness topics (age floor, reviewer account, prod URL, web deletion URL, `security.md`, name moderation — 5 distinct, 1 restated) have **no S-numbered entry** in `docs/seif_fight.md`; tracked only in part 05's ad hoc list and part 12. |
| API-17 | D | Decisions ledger | `docs/DECISIONS.md` D-007 ("no link at all") is superseded by adr-171 (one neutral link) but carries no amendment or cross-reference; the contradiction is well-tracked in audit reports but not closed at the source-of-truth layer. |
| API-18 | E | Methodology | A `curl -I` (HEAD) probe against a GET-only route answers `405`, not `401` — probe-design nuance, not a server defect; a plain GET confirms `401` as expected. |
| API-19 | C | Contract accuracy | `DeviceInfo.deviceId` "regenerated on reinstall" (`openapi.yaml:2242`) is contract-stated but **false on iOS** (Keychain survives uninstall, part 04 IOS-06) — the eviction-messaging feature this field exists for (`model`, `:2245`) is fed a stale identity on iOS reinstalls. |
| API-20 | F | Retention | Retention/erasure/audit statements are genuinely scattered across 14 locations in `openapi.yaml`/`contract-changelog.md` (§5 above is now exhaustive) and all funnel back to one absent source, `security.md` (`openapi.yaml:98`, not in the vendored repo at this pin). |
| API-21 | B | Rate limits | No numeric magnitude is declared for `/reference/*` or OTP rate limits anywhere in the contract, and `Retry-After` is contractually promised only for `rate_limited`, never for `otp_throttled` — a reviewer-farm OTP-throttle `429` has no documented header to read a cooldown from. |
| API-22 | A (confirms POL-03) | Device binding | Verified against exact contract text: eviction is per-**student**-session (Redis session version), not per-device, with **no** whitelist exemption from eviction or from the per-IP OTP limit — concurrent reviewers/Robo-farm on one number will evict each other. |
| API-23 | A (confirms API-02/POL-03) | Production host | `servers:` declares staging only (`openapi.yaml:107-109`); zero "prod" hostname exists anywhere in `contract/` or `docs/` — the app's `TBD.example` is a client-side placeholder, not a contract value that merely needs reading. |
| API-24 | B (confirms POL-04) | Deletion copy | Mechanical word-check of `openapi.yaml:999-1024` finds exactly "paid" ×2 and "refund" ×1 colliding with adr-171 §3's banned list; no other banned word present. Contract does not mandate or mention an out-of-band completion confirmation — that need comes from Apple policy, not the contract. |

---
Lead's addendum (SOURCE level throughout this part; STAGING level for §9 only, probed 2026-09-22
04:54 UTC). No repo file other than this one was modified.
