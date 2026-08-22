# Vendored API contract — pinned copy

Source: https://github.com/seifhamdii-collab/level-up-contract
Pinned commit: 61905ce ("Mirror contract from level-up-backend@e25a272c5392a1a1c6f1a1668c8ff18bb970f2f0") — full SHA 61905cedc36459200a95288bf40f70d15c891c4d
Vendored: 2026-08-18
Previous pin: ee2ed8f ("Contract v1.1.0-m1 - city fallback, optional school, per-resource not-found"), vendored 2026-08-03

info.version at this pin: 2.1.0-m1
Independently confirmed to match the live backend build actually serving staging: `GET
https://level-up-backend-staging.up.railway.app/health/version` returns commit
`e25a272c5392a1a1c6f1a1668c8ff18bb970f2f0` — the exact commit named in this pin's mirror
commit message (checked 2026-08-18).

Intermediate versions skipped by this pin (all superseded, none adopted): 1.2.0-m1, 1.2.1-m1,
1.3.0-m1, 2.0.0-m1. Full delta from 1.1.0-m1 recorded in contract-changelog.md (newest first).
The version string 1.4.0-m1 is PERMANENTLY INVALID — briefly published 2026-08-14, reverted
~15 minutes later without a changelog entry. Discard any document labelled 1.4.0-m1 on sight.

Do NOT edit these files here — they are Seif's owned artifact. When Seif publishes a
new version, re-copy from the source repo and bump the commit above. Build ONLY against
paths marked `x-stability: stable`.
