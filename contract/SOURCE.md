# Vendored API contract — pinned copy

Source: https://github.com/seifhamdii-collab/level-up-contract
Pinned commit: 184d6ec ("Mirror contract from level-up-backend@4a8e7cfe63696bbfc2125b158e7ffdbcd149ed27") — full SHA 184d6ec80cbde708acfe605d00eb8a5c756de797
Vendored: 2026-09-04
Previous pin: 61905ce ("Mirror contract from level-up-backend@e25a272c5392a1a1c6f1a1668c8ff18bb970f2f0", v2.1.0-m1), vendored 2026-08-18

info.version at this pin: 3.0.0-m1
The four files vendored here are byte-identical at 184d6ec and at 36a37d1 ("Mirror contract
from level-up-backend@aed86fb0c9df3bbb805afe1b3d95a2d74ce1159f", 2026-09-03T07:05Z) — the
commit that introduced 3.0.0-m1. 184d6ec (2026-09-03T09:39Z) changed only the admin files
(see below). Provenance: the source repo answered 404 for part of 2026-09-04 and the owner
supplied the four files by hand; when the repo became reachable again the same day, the
hand-supplied copies were confirmed identical to 184d6ec and re-copied from the clone.

Live backend at vendoring time: `GET
https://level-up-backend-staging.up.railway.app/health/version` returns commit
`78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1`, built 2026-09-03T15:38:17Z — this is NOT the
commit named in this pin's mirror message. It is a later build (the mirror workflow fires only
when a contract file changes), so it presumably contains 4a8e7cf, but the backend repo is
private and the ancestry could not be checked from outside it. Whether staging serves the
3.0.0-m1 `QuizSummary` is UNOBSERVED: on 2026-09-04 the smoke harness could not reach
`POST /quizzes/{quizId}/finish` (the test account's catalog is empty — contract-legal).

Intermediate versions skipped by this pin (all superseded, none adopted): 2.2.0-m1, 2.3.0-m1.
Full delta from 2.1.0-m1 recorded in contract-changelog.md (newest first): 2.2.0-m1 deleted
`POST /checkout/sessions` and added `x-consumers` (adr-049, adr-057 — Breaking: no); 2.3.0-m1
un-gated the catalog (adr-091 — Breaking: BEHAVIOURAL); 3.0.0-m1 removed `totalPoints` and
`level` from `QuizSummary` (adr-102 — Breaking: yes).
The version string 1.4.0-m1 is PERMANENTLY INVALID — briefly published 2026-08-14, reverted
~15 minutes later without a changelog entry. Discard any document labelled 1.4.0-m1 on sight.

The source repo also carries `openapi-admin.yaml`, `error-codes-admin.md` and
`contract-changelog-admin.md` — the admin SPA's contract (adr-050). They are deliberately NOT
vendored: the app has never consumed them and they are not the mobile partner's surface.

Do NOT edit these files here — they are Seif's owned artifact. When Seif publishes a
new version, re-copy from the source repo and bump the commit above. Build ONLY against
paths marked `x-stability: stable`.
