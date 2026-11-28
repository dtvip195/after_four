# POS-2A B1 R2 CA-16 Rollback Verification

**Scope:** Disposable code-and-spec rollback verification only.
**Base:** `c05b7ed8994e0fd4c39645db43ba6b0c85bdb165`
**Authorization boundary:** This evidence does not claim production rollback, database rollback, deployment authorization, Control Acceptance, Operational Acceptance, or independent external review.

## Verification method

`backend/script/verify_pos_2a_b1_rollback`:

1. validates the exact 35 new B1 paths and the one narrowly modifiable existing spec;
2. copies the current worktree into a disposable filesystem directory;
3. records every non-B1 path and SHA-256 value;
4. removes only the 35 B1 additions and restores `authorize_spec.rb` from the recorded base;
5. proves all non-B1 paths and hashes are unchanged;
6. verifies the three protected Identity production hashes and the base hash of `authorize_spec.rb`;
7. prepares a newly created loopback-only PostgreSQL 18.7 database and runs the restored self-session regression plus the complete backend RSpec suite; and
8. removes only its own disposable container, volume, and filesystem copy.

## Reproduction

From the repository root:

```bash
backend/script/verify_pos_2a_b1_rollback
```

The script requires Ruby 3.4.13, Homebrew PostgreSQL 18 client tools at `/opt/homebrew/opt/postgresql@18/bin`, Docker, and the `postgres:18.7` image. It uses a process-local PATH and never changes shell configuration.

## Recorded execution — 2026-11-28

Result: `PASS`

| Check | Result |
|---|---|
| Exact B1 additions removed in disposable copy | 35 |
| Existing spec restored | `backend/spec/domains/identity/application/authorize_spec.rb` from base |
| Non-B1 path comparison | Identical before/after |
| Non-B1 SHA-256 comparison | Identical before/after |
| Protected `CapabilityIdentifier` hash | Matched `85e069e2d59bc95cc608bbbbe054e66f99f7d7705873f191a823aa13fbbbd343` |
| Protected `AuthorizationRequest` hash | Matched `c8ca1dc891d9b11e6e501941111d3a48084f62fc1342cbf1b136af3902da86f8` |
| Protected `Authorize` hash | Matched `e6477ff0c7383a60b468cd9f07ed02ac3a12c93458b5cc60e85beb6c49815e5a` |
| Restored self-session regression | 4 examples, 0 failures; seed `58840` |
| Complete backend regression after rollback | 436 examples, 0 failures; seed `24525` |
| Post-rollback SimpleCov | 95.59% line (`3299/3451`); 75.29% branch (`509/676`) |
| PostgreSQL server | 18.7 (`postgres:18.7`) |
| Disposable container | `af-pos-b1-ca16-40876-db` — removed after execution |
| Disposable volume | `af-pos-b1-ca16-40876-pgdata` — removed after execution |

The script exited successfully after printing `CA16_ROLLBACK_VERIFICATION=PASS`. Independent post-run inspection confirmed that both named Docker resources were absent. The repository under review was not modified by the rehearsal; all rollback mutations occurred in the disposable copy.

## Limitation

CA-16 here proves that the authorized B1 code and spec changes can be removed in a disposable copy without altering other repository files, and that baseline behavior remains testable afterward. B1 contains no authorized schema or production-data change. This procedure therefore makes no claim about production rollback or database rollback.
