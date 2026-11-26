# AFTER FOUR — Organization-Level Audit Foundation Decision Package

**Prepared:** 2026-11-26

**Status:** `EXTERNAL_REVIEW_NOT_YET_PERFORMED`

**Final verdict:** `EXTERNAL_REVIEW_NOT_YET_PERFORMED`

> **Owner decision record — 2026-11-27.** The Owner confirmed `AUD-DEC-01` through `AUD-DEC-06` exactly as recommended in this package. These are local review references, not ODB allocations. The decisions approve the bounded design direction only: empty initial catalog/no producer; narrow exact-signature `SECURITY DEFINER`; Organization + Producer + Stable Attempt Key identity; Branch forbidden; human actor shape only; and separated database duties. Security review, an exact role provisioning/custody verification plan, implementation authorization, post-authorization disposable evidence and every production event remain outstanding. Environment-specific provisioning evidence is a later deployment prerequisite. The current review package is [Organization-Level Audit Security Design Closure](organization_level_audit_security_design_closure.md).

> **Independent-review remediation — 2026-11-27.** The original option analysis and finding descriptions remain historical evidence. `ISR-AUD-001`–`003` are remediated in design only in the current security closure: Slice 1 has no Branch representation; outcome/catalog validation is NULL-safe and fail-closed; privilege installation is specified; and one staged prerequisite matrix separates the empty slice from later producers and governance. The findings are not closed until focused independent re-review.

> **Security remediation round 2 — 2026-11-27.** The focused re-review verified `ISR-AUD-001/002`, found `ISR-AUD-003` partially remediated and added `ISR-AUD-004`–`006`. The current [security closure](organization_level_audit_security_design_closure.md) supersedes stale proposal language for identifier grammar, database/parameter privileges, evidence timing and failure-class authority. Audit Evidence owns immutable registration/failure-class selection; producers cannot submit a weaker class. The new design remediations remain open pending focused follow-up review.

> **Security remediation round 3 — 2026-11-27.** The follow-up review added `ISR-AUD-007`–`010`. The current security closure supersedes delimiter-joined array checks, ambiguous `42501` mapping, pre-commit durability language and non-finite occurrence-time acceptance. Branch remains conclusively forbidden for Slice 1; current system testing proves interface absence rather than pretending that a system-provenance parameter exists. These design corrections await focused independent re-review.

> **Security remediation round 4 — 2026-11-27.** The Round 3 re-review added `ISR-AUD-011/012`. The current security closure now requires locked atomic helper replacement plus forced full dependent-CHECK validation, and separates `PendingAppendReceipt` from outer-owner-only `CommittedAppendResult`. These corrections remain design proposals pending focused independent re-review and do not change any Owner decision.

> **ISR-AUD-013 remediation — 2026-11-27.** All catalog arrays representing logical sets now reject duplicates without normalization or reordering. Registration manifests preserve one explicit order, and Application/catalog projection plus release hashes compare the ordered arrays exactly. The rule is design-remediated only and awaits independent review.

> **ISR-AUD-013 remediation round 2 — 2026-11-27.** The logical contract now supplies the exact version-1 binary registration projection and SHA-256 contract, with Audit Evidence as the existing logical authority and no independent Ruby/JSON/PostgreSQL-text serialization. Fixture bytes/digests remain pending independent review and later authorized generation; no decision or implementation authority changes.

> **Authorization-readiness consolidation — 2026-11-27.** Internal parallel review added `ISR-AUD-014`–`023`; re-review added `ISR-AUD-024`–`030`. The five-document package now closes those documentation findings, including exact decoder/date/result/NUL semantics, the `Platform::AuditEvidence` boundary, concurrency-safe rollback/owner assumption, no Empty-Slice runtime membership, complete function/trigger catalog assertions and consistent current status/provenance. This is internal review evidence only; an external independent reviewer must still disposition every `ISR-AUD-*` and `AUD-SEC-*` finding.

> **P0 internal-review remediation — 2026-11-27.** Zero-cost adversarial review added `ISR-AUD-031`–`039`. The design now removes unnecessary replay locking; specifies exact C-collation/UTF-8 identity; separates global, per-schema and object function privileges; enumerates every PostgreSQL 18 table privilege; constrains the migrator; defines the shared-pool module-local Rails persistence base; distinguishes static architecture guards from runtime ACLs; and requires structured SQLSTATE plus full transaction unwind. Each finding remains `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED`, not verified or closed.

> **Final design clarification — 2026-11-27.** The preceding clarification introduced Rails/transaction identity and distinct UTF-8 lifecycle requirements for `ISR-AUD-036/039`; the later five-finding remediation below supersedes its narrower identity and session wording. Both findings remain open for focused re-review, executable evidence and external disposition.

> **ISR-AUD-036/039/040/041/042 design remediation — 2026-11-27.** The canonical package requires the outer wrapper to hold the lease, reject ambient transactions, open the transaction itself and alone issue the capability; joined scopes reuse it and real savepoints/nested issuers fail closed. Restore acceptance uses a non-reusable attempt, unique invocation, exclusive target-generation fence, exact evidence scope and atomic `QUARANTINED -> ACCEPTED` promotion. The subsequent narrow review verified `ISR-AUD-039/040/042` at design level and returned `ISR-AUD-036/041` for the final micro-remediation recorded below; all five still require later authorized executable evidence and external disposition.

> **Final micro-remediation — 2026-11-27.** The package now names only **wrapper-owned transaction participation**: the designated outer wrapper proves its adapter is idle, opens and owns the supported boundary, and issues the sole capability. Joined inner services may reuse it; arbitrary caller-owned or pre-existing ambient transactions remain unsupported and require a separately designed and approved protocol. PostgreSQL failures before function entry are now distinct from the first in-function exact-session encoding guard: only a successfully entered function promises `AUE02`, while both paths fail closed and unwind the whole transaction. `ISR-AUD-036/041` remain pending final narrow read-only verification and later executable evidence.

This package closes research and presents concrete choices for the Organization-level Audit Foundation. It is not an Owner decision, security acceptance, legal/privacy opinion, implementation authorization, or production-readiness record.

## 1. Executive summary

The repository supports a safe **infrastructure-only first slice**: a deep Audit Evidence platform module, immutable logical envelope, separate empty Organization-level store, deny-by-default catalog, narrow append interface, append-only controls, and security tests. The safest initial state is an empty catalog with no production producer. Test-only catalog fixtures can characterize the module without inventing business events.

The first slice should support trusted **human actor shape only** and leave system producers disabled. No Organization-level system operation currently needs migration, while the only implemented system audit writer is the existing Branch-scoped Order expiration job. Deferring system activation avoids prematurely selecting producer identities, credentials, rotation, and deployment provenance.

Nine current Branch event types were verified. They are existing legacy behavior, not approved Organization catalog entries. All current writers receive raw caller `actor_id` values rather than the trusted Identity authorization context, and none stores Organization identity. Their audit inserts participate in current local business transactions and failure-injection tests demonstrate rollback for the covered mutations.

The original PostgreSQL proposal had two pre-implementation design issues:

1. The abbreviated `SECURITY DEFINER` append body was not deployable until fully specified and adversarially reviewed.
2. The proposed idempotency uniqueness included event type/version and conflicted with the intended changed-semantic-replay rule.

The security closure supersedes both original proposal defects and records the later independent-review remediation. Focused re-review, implementation evidence and authorization remain outstanding.

Production role custody is also unresolved. Current development and CI use the PostgreSQL `postgres` superuser, so no runtime privilege claim has been experimentally established.

### Recommended defaults for Owner review

| Topic | Recommended answer | Approval status |
|---|---|---|
| First catalog | Create infrastructure with an empty catalog and no production producer | `OWNER_CONFIRMED` (`AUD-DEC-01`, 2026-11-27) |
| Initial actor support | Human actor shape only; system provenance schema/contract designed but disabled | `OWNER_CONFIRMED` (`AUD-DEC-05`, 2026-11-27) |
| Append mechanism | Narrow `SECURITY DEFINER` function, exact-signature `EXECUTE`, no runtime table privileges | `OWNER_CONFIRMED` (`AUD-DEC-02`, 2026-11-27); independent security review required |
| Idempotency scope | One key per Organization and producer logical attempt, independent of event type/version; changed type/version is conflict | `OWNER_CONFIRMED` (`AUD-DEC-03`, 2026-11-27); design reconciled in security closure |
| Initial Branch handling | No Branch column, FK, target, validation path, catalog mode, fixture or indirect identity in Organization Slice 1 | `OWNER_CONFIRMED` (`AUD-DEC-04`, 2026-11-27); verified design remediation, external whole-package review still required |
| Metadata profile | Flat JSON object, event-specific keys, no arrays/nesting initially, 2,048-byte candidate maximum | `PROPOSED_NOT_OWNER_APPROVED`, security/privacy review required |
| Existing producer migration | Defer; review Orders, Payments, and Preparation independently after exact event approval | `PROPOSED_NOT_OWNER_APPROVED` |

## 2. Verified repository baseline

| Item | Verified value |
|---|---|
| Branch | `development` |
| HEAD | `b49a8827be53797b30ea1d7cb47791e7c74e7231` |
| Upstream | `origin/development` |
| Upstream delta | `0 / 0` |
| Initial working tree | Original package began with three untracked inputs; remediation baseline has all five audit research documents untracked and no tracked modifications |
| PostgreSQL CI service | PostgreSQL `18.7`, user `postgres` |
| Local/default database credential | `postgres` unless environment overrides it |
| Rails schema format | SQL, committed as `backend/db/structure.sql` |

The three input documents are:

- [Foundation assessment](organization_level_audit_foundation_assessment.md)
- [Logical contract design](organization_level_audit_logical_contract_design.md)
- [PostgreSQL design](organization_level_audit_postgresql_design.md)

They are design evidence, not implementation. Canonical architecture remains ADR-0011, ADR-0012, Data Integrity Rules, the Identity decisions, and the Owner Decision Baseline.

### 2.1 Verified implementation

- `audit_events` is Branch-required and has no Organization, event version, explicit outcome, causation, or independent recorded-time field ([migration](../../backend/db/migrate/20261114192000_create_order_payment_foundation.rb#L74)).
- A model callback and PostgreSQL trigger reject ordinary update/delete; `TRUNCATE`, owner/superuser action, and restore remain outside that guarantee ([model](../../backend/app/models/audit_event.rb), [trigger](../../backend/db/migrate/20261114203000_protect_audit_events_append_only.rb), [owner cleanup bypass](../../backend/spec/support/audit_event_cleanup.rb)).
- Orders, Payments, and Preparation directly write the root `AuditEvent` record from their Infrastructure adapters.
- Identity has a privately issued `TrustedAuthorizationContext`, but the three audit ports accept raw actor UUIDs ([trusted context](../../backend/app/contexts/identity/application/contracts/trusted_authorization_context.rb)).
- Workforce has an Organization-scoped Employee foundation and no production Employee creation workflow ([migration](../../backend/db/migrate/20261126120000_create_workforce_employee_foundation.rb)).
- CI and local configuration use the PostgreSQL superuser and do not exercise production role separation ([CI workflow](../../.github/workflows/quality.yml), [database configuration](../../backend/config/database.yml)).

### 2.2 Confirmed Owner decisions

| Confirmed decision | Consequence |
|---|---|
| Audit Evidence is a dedicated deep platform module/package, not a business Bounded Context | Event semantics remain producer-owned; common validation/persistence stays behind one narrow interface |
| Initial Organization store is separate | Existing Branch store remains unchanged; no backfill or global cross-store order |
| Failure semantics are class-specific | Catalog must bind each approved event to a failure class; caller cannot weaken it |
| Only explicitly approved event types may be recorded | Empty catalog is safe; runtime registration is prohibited |
| System events need verifiable producer provenance | `system` alone is insufficient; no fabricated User |
| Identity, Workforce, and Organization retain their confirmed ownership | Audit cannot infer authentication, employment, assignment, Organization, Brand, or Branch authority |
| User and Employee are independent | Actor User must not be treated as Employee identity or employment evidence |
| Employee creation is unauthorized | No Employee event or producer is included in the initial slice |

## 3. Workstream A — Initial event catalog

### 3.1 Complete current event inventory

Every row below is `EXISTING_LEGACY_BEHAVIOR`. No exact event has canonical Owner approval as an Organization catalog entry; its proposed catalog status is therefore `PROPOSED_NOT_OWNER_APPROVED`.

| Event type | Producer/writer | Trigger and target | Actor and scope | Current metadata | Idempotency and transaction | Current append-failure behavior |
|---|---|---|---|---|---|---|
| `order.created` | Orders `ActiveRecordAuditLog#order_created` | Draft creation; target `Order` | Raw caller actor UUID; Branch copied from Order; no Organization | `channel` string | `order.created:<creation key>`; same unit of work as Order and Payment target | Failure rolls back Order, Payment target, and audit; verified by failure injection |
| `order.confirmed` | Orders `#order_confirmed` | Applied confirmation; target `Order` | Raw caller actor UUID; Order Branch; no Organization | `payment_expires_at` ISO-8601 string | `order.confirmed:<confirmation key>`; confirmation transaction; replay emits no new event | Failure rolls back confirmation |
| `order.held` | Orders `#order_held` | Applied hold; target `Order` | Raw caller actor UUID; Order Branch; no Organization | Raw `reason` string | `order.held:<hold key>`; hold transaction; replay emits no new event | Failure rolls back hold |
| `order.payment_window_expired` | Orders `#order_expired` from `ExpirePendingOrdersJob` use case | Applied expiry; target `Order` | `system` with null human actor; Branch; no registered producer or Organization | Empty | `order.payment_window_expired:<order id>`; one Order transaction per expiry | Failure rolls back expiry; current system provenance is insufficient for the new contract |
| `payment.amount_mismatch` | Payments `#amount_mismatch` | Persisted failed Payment Attempt; target `PaymentAttempt` | Raw caller actor UUID; Order Branch; no Organization | `method`, `received_amount`, `currency_code` | `payment.amount_mismatch:<order id>:<attempt command key>`; Payment transaction | Failure rolls back failed Attempt; otherwise transaction commits before deferred business error is raised |
| `payment.confirmed` | Payments `#payment_confirmed` | Successful settlement with eligible dispatch; target `PaymentAttempt` | Raw caller actor UUID; Order Branch; no Organization | `method`, `amount`, `currency_code`, `preparation_dispatch_id` | `payment.confirmed:<order id>:<attempt command key>`; settlement/Dispatch/Outbox transaction | Failure rolls back settlement, Attempt, Dispatch, Outbox, and audit |
| `payment.late_success_recorded` | Same Payments method, selected when Review Case exists | Successful funding after dispatch eligibility; target `PaymentAttempt` | Raw caller actor UUID; Order Branch; no Organization | `method`, `amount`, `currency_code`, `review_case_id` | Same `payment.confirmed:<order id>:<attempt command key>` shape; late-success transaction | Failure rolls back settlement, Attempt, Review Case, and audit |
| `preparation.dispatch_requested` | Preparation `#dispatch_requested` | New Dispatch intent; target `PreparationDispatch` | Raw caller actor UUID; Dispatch Branch; no Organization | `order_id` | `preparation.dispatch_requested:<command key>`; Dispatch/Outbox transaction | Failure rolls back Dispatch and Outbox; verified |
| `preparation.dispatch_retry_requested` | Preparation `#dispatch_retry_requested` | Outbox requeue; target `PreparationDispatch` | Raw caller actor UUID; Dispatch Branch; no Organization | Empty | `preparation.dispatch_retry:<dispatch id>:<command key>`; audit lookup supplies replay evidence | Failure rolls back Outbox update; concurrency spec expects one audit row |

Sources: [Orders adapter](../../backend/app/contexts/orders/infrastructure/adapters/active_record_audit_log.rb), [Payments adapter](../../backend/app/contexts/payments/infrastructure/adapters/active_record_audit_log.rb), [Preparation adapter](../../backend/app/contexts/preparation/infrastructure/adapters/active_record_audit_log.rb), [transaction evidence](../../backend/spec/integration/ordering_transaction_failure_evidence_spec.rb), and [Preparation recovery evidence](../../backend/spec/domains/preparation/infrastructure/transaction_recovery_spec.rb).

### 3.2 Proposed candidate catalog

These candidates describe a possible future approval, not current permission. They remain assigned to the existing Branch store unless a later Owner decision says otherwise.

| Candidate | Meaning/target | Proposed outcome | Metadata | Idempotency | Failure class | Actor/scope | Privacy | Status/rationale |
|---|---|---|---|---|---|---|---|---|
| `order.created.v1` | Draft Order durably created | `succeeded` | Required `channel` | Required stable creation attempt | `atomic_fail_closed` | Trusted human; Branch required | Operational internal | `PROPOSED_NOT_OWNER_APPROVED`; verified atomic behavior |
| `order.confirmed.v1` | Order confirmation applied | `succeeded` | Required `payment_expires_at` | Required stable confirmation attempt | `atomic_fail_closed` | Trusted human; Branch required | Operational internal | `PROPOSED_NOT_OWNER_APPROVED` |
| `order.held.v1` | Order hold applied | `succeeded` | Required safe `reason_code`; optional opaque domain-evidence reference | Required stable hold attempt | `atomic_fail_closed` | Trusted human; Branch required | Operational/security-sensitive | `PROPOSED_NOT_OWNER_APPROVED`; raw reason should not migrate unchanged |
| `order.payment_window_expired.v1` | Order expiry applied | `succeeded` | None | Required stable Order-expiry identity | `atomic_fail_closed` | Registered system producer; Branch required | Operational internal | `DEFERRED`; system provenance is not approved |
| `payment.amount_mismatch.v1` | Failed Payment Attempt durably recorded | `failed` | Method, received amount, currency | Required stable attempt | `atomic_fail_closed` | Trusted human; Branch required | Financial internal | `PROPOSED_NOT_OWNER_APPROVED`; outcome needs Owner confirmation |
| `payment.confirmed.v1` | Payment Attempt succeeded and normal dispatch route persisted | `succeeded` | Method, amount, currency, Dispatch reference | Required stable settlement attempt | `atomic_fail_closed` | Trusted human; Branch required | Financial internal | `PROPOSED_NOT_OWNER_APPROVED` |
| `payment.late_success_recorded.v1` | Funding succeeded and Review Case persisted without dispatch | `succeeded` | Method, amount, currency, Review Case reference | Required same stable settlement-attempt identity | `atomic_fail_closed` | Trusted human; Branch required | Financial/security-sensitive | `PROPOSED_NOT_OWNER_APPROVED` |
| `preparation.dispatch_requested.v1` | Unique Dispatch and delivery intent persisted | `succeeded` | Required Order reference | Required stable dispatch command | `atomic_fail_closed` | Trusted human; Branch required | Operational internal | `PROPOSED_NOT_OWNER_APPROVED` |
| `preparation.dispatch_retry_requested.v1` | Existing delivery intent requeued | `succeeded` | None | Required stable retry attempt | `atomic_fail_closed` | Trusted human; Branch required | Operational internal | `PROPOSED_NOT_OWNER_APPROVED` |

The exact version encoding remains affected by unresolved `OPP-ARCH-13`; `.v1` above is descriptive, not a selected encoding. Existing names must not be renamed in runtime without compatibility and approval.

### 3.3 Safest initial catalog

**Recommendation:** Slice 1 creates an empty deny-by-default catalog and no production producer. Test-only catalog rows live only in isolated test setup and use explicit nonproduction names. A “characterization event” in production is unnecessary: infrastructure can be tested without creating business evidence, and any production event would itself require exact meaning, actor, failure, metadata, retention, and access decisions.

Minimum approvals before the first production append:

1. exact event type and version encoding;
2. producer and target meaning;
3. actor mode and trusted evidence;
4. Organization-only scope and the separate Organization store; `AUD-DEC-04` already forbids every Branch representation in Slice 1, so Branch is not an open first-append choice;
5. allowed outcome(s);
6. idempotency scope/key semantics;
7. failure class and transaction behavior;
8. metadata keys/types/limits and privacy classification;
9. approval provenance/date; and
10. security acceptance of role/function controls.

## 4. Workstream B — Event-specific failure classification

### 4.1 Proposed failure classes

| Class | Meaning | Transaction behavior | Status |
|---|---|---|---|
| `atomic_fail_closed` | Authoritative event is mandatory for a successful mutation | Mutation and append share one transaction; append failure rolls both back | `PROPOSED_NOT_OWNER_APPROVED` per event |
| `durable_after_denial` | Denial/rejection occurred before business state change and approved evidence must survive | Denied operation remains denied; minimized evidence may use separate transaction | `PROPOSED_NOT_OWNER_APPROVED`; no concrete event |
| `durable_after_ambiguous` | Operation outcome is unknown/partial and approved uncertainty evidence must survive | Hold/reconcile; separate evidence records only known facts | `PROPOSED_NOT_OWNER_APPROVED`; no concrete event |
| `supplementary_delivery` | Authoritative local event already committed; downstream copy may retry | Delivery failure never rewrites local event or business result | `PROPOSED_NOT_OWNER_APPROVED`; no external sink |

### 4.2 Event-specific matrix

| Event | Success | Denied/validation/business rejection | Failed/ambiguous mutation | Replay/conflict | Audit storage failure | Recommended default |
|---|---|---|---|---|---|---|
| `order.created` | Authoritative success evidence | No current event; do not invent target/existence | Current transaction proves rollback on append failure; no ambiguity event | Business replay returns prior Order without new audit; conflicting command rejected | Roll back Order and Payment target | `atomic_fail_closed` |
| `order.confirmed` | Authoritative applied transition | Current rejection emits no event | Rollback preserves prior Order; no separate event approved | Applied replay emits none; conflicting replay remains domain error | Roll back confirmation | `atomic_fail_closed` |
| `order.held` | Authoritative applied transition | Current rejection emits no event | Rollback preserves prior state | Applied replay emits none; conflict remains domain error | Roll back hold | `atomic_fail_closed` |
| `order.payment_window_expired` | Authoritative system-applied transition | Ineligible candidate is skipped; no event | Per-Order transaction rollback; no separate event | Re-run only records once after actual transition | Roll back expiry | `atomic_fail_closed`, but migration `DEFERRED` |
| `payment.amount_mismatch` | Event records an authoritative failed Attempt, not successful funding | Input/domain rejection before Attempt has no event | Persisted mismatch and evidence commit before deferred error; unknown provider cases are outside this local path | Semantic replay returns prior Attempt and no new event; conflict rejected | Roll back failed Attempt; caller sees storage failure rather than business mismatch | `atomic_fail_closed`; proposed outcome `failed` |
| `payment.confirmed` | Authoritative settlement/Dispatch evidence | Not-payable and validation rejection emit no event | Current local path is atomic; provider-ambiguous handling is not implemented | Matching replay emits none; conflicting replay rejected | Roll back settlement, Attempt, Dispatch, Outbox | `atomic_fail_closed` |
| `payment.late_success_recorded` | Authoritative funding and Review Case evidence | No separate denial event | Current local path is atomic; provider-origin ambiguity is not implemented | Matching replay returns prior result; changed semantic route must be conflict | Roll back settlement, Attempt, Review Case | `atomic_fail_closed` |
| `preparation.dispatch_requested` | Authoritative Dispatch/Outbox evidence | Ineligible/unpaid rejection emits no event | Current transaction is atomic; delivery after commit is separate | Existing Dispatch returns replay without event; command conflict remains domain behavior | Roll back Dispatch and Outbox | `atomic_fail_closed` |
| `preparation.dispatch_retry_requested` | Authoritative requeue evidence | Non-retryable rejection emits no event | Outbox update and audit rollback together | Audit lookup recognizes same retry; concurrency yields one event | Roll back Outbox requeue | `atomic_fail_closed` |

All assignments are recommendations. Existing transaction tests verify behavior but do not constitute Owner approval of the future class.

### 4.3 Category truth rules

| Case | Durable evidence | Business effect on append failure | Separate transaction | Truth limitation |
|---|---|---|---|---|
| Successful material mutation | Required only for approved event | Fail closed and roll back when class is atomic | No substitute for success event | Never assert success unless both commit |
| Denied request before mutation | Event-specific | Access remains denied regardless | Permitted only for an approved minimized denial event | Never reveal target existence or fabricate actor |
| Validation rejection | Usually no general audit event; security abuse may differ | Rejection remains | Only if explicitly approved | Never assert durable target/mutation |
| Business-rule rejection | Event-specific | Rejection remains | Only approved evidence | Never convert rejection to failure/success |
| Failed mutation | Record only known failure if approved | Never make failure succeed | After rollback only | Do not claim state unchanged without proof |
| Ambiguous/partial outcome | Approved `unknown` evidence where needed | Hold/reconcile | May be required | Never guess succeeded/failed |
| Matching replay | Return original event/result | No second mutation/event | No | Replay is not re-execution |
| Conflicting replay | Integrity failure | Fail closed | Optional separately approved conflict signal | Never label as idempotent success |
| System operation | Underlying class plus producer provenance | Missing provenance fails closed when evidence required | Event-specific | Never fabricate human actor |
| Downstream copy failure | Local authoritative event remains | Business result remains committed | Asynchronous retry acceptable | Delivery is not authoritative event persistence |

## 5. Workstream C — System actor provenance

### 5.1 Existing behavior

The only discovered system audit writer is `order.payment_window_expired`, invoked through `ExpirePendingOrdersJob`. It stores `actor_type=system` and no actor ID, but records no stable producer identity, run identity, deployment/environment identity, scheduler origin, or protected assertion. This satisfies only actor-shape separation, not the confirmed provenance requirement ([job](../../backend/app/jobs/expire_pending_orders_job.rb), [adapter](../../backend/app/contexts/orders/infrastructure/adapters/active_record_audit_log.rb#L43)).

### 5.2 Provenance alternatives

| Model | What it proves | What it does not prove / main risk | Custody and operations | Status |
|---|---|---|---|---|
| Registered logical producer key | Event claims an approved producer name/version | Plain caller string can be spoofed; no execution identity | Migration-owned allowlist; version/revocation by reviewed release | Necessary but insufficient; `PROPOSED_NOT_APPROVED` |
| Execution/run UUID | Links one execution and its events | Random UUID does not establish who issued it | Generated server-side; replay/idempotency rules needed | Optional evidence; `PROPOSED_NOT_APPROVED` |
| Job/scheduler origin | Associates event with a job class/schedule | Framework class name/config is not authority and can be caller-controlled | Deployment configuration and job adapter evidence | Supplementary only |
| Environment/deployment identity | Identifies release/environment | Does not prove individual operation legitimacy; mutable environment values can be spoofed | Release identity, configuration custody, rotation | Future maturity |
| Signed producer assertion | Integrity/authenticity outside ordinary caller | Key compromise signs forged events; replay, rotation, availability, and verification complexity | Separate secret/HSM custody and incident response | Stronger but unjustified for first slice |
| Composition-issued producer context | Prevents ordinary clients from constructing provenance; preserves module seam | Ruby/in-process trust cannot resist arbitrary compromised runtime code | Private issuer, strict composition, Packwerk/tests | Recommended application mechanism once enabled |
| Separate process/database credential | DB can distinguish producer principal | Operational complexity, distributed transaction/availability changes | Per-producer credentials, rotation, deployment | Not recommended for initial modular monolith |

### 5.3 Logical distinction

| Concept | Meaning |
|---|---|
| Human actor | Trusted Identity User who initiated an operation; may carry safe Session reference |
| System actor type | States that no human User is asserted as direct actor |
| Registered system producer | Approved logical operation/module allowed to emit exact event versions |
| Execution identity | Opaque identifier for one run/invocation; correlation, not authority by itself |

### 5.4 Recommendation

Choose **Option A: human events only in the first enabled slice**. Slice 1 still implements and tests deny-by-default system fields, but catalog contains no system producer. This avoids premature credentials and identities, while the existing Branch expiration writer remains unchanged. System support can be enabled only after an exact producer, event, invocation requirements, deployment provenance, rotation/revocation, and failure behavior are approved.

Local/test fixtures must use unmistakably nonproduction producer keys, exist only in isolated test setup, and provide no production catalog migration. Production producer custody cannot inherit the development `postgres` shortcut.

## 6. Workstream D — Metadata and privacy

### 6.1 Field-level candidate schemas

All rows are `PROPOSED_NOT_OWNER_APPROVED`. Limits are technical recommendations for review.

| Event | Field | Type/source | Requirement and candidate limit | Sensitivity | Investigation need / safe treatment |
|---|---|---|---|---|---|
| `order.created` | `channel` | ASCII enum from Order | Required; max 24 characters | Operational | Necessary to identify sale channel; fixed vocabulary only |
| `order.confirmed` | `payment_expires_at` | RFC 3339 UTC string from Order deadline | Required; max 35 characters | Operational timing | Necessary decision evidence; envelope remains occurrence time |
| `order.held` | legacy `reason` | Caller/domain free text | **Do not migrate unchanged** | May contain personal, customer, payment, or secret data | Replace with approved `reason_code` max 64 and optional opaque domain evidence UUID; retain detailed reason only in its owning domain under approved access |
| `payment.amount_mismatch` | `method` | Payment Attempt method | Required; max 32 ASCII characters | Financial | Needed to interpret attempt; no credentials/provider payload |
| same | `received_amount` | Integer requested amount in currency base unit | Required signed 64-bit nonnegative integer | Financial | Necessary mismatch evidence; JSON integer, never float |
| same | `currency_code` | ISO-style uppercase code from Money | Required exactly three ASCII letters | Financial | Necessary numeric interpretation |
| `payment.confirmed` | `method` | Payment Attempt | Required; max 32 ASCII | Financial | Same restriction |
| same | `amount` | Integer successful amount | Required signed 64-bit nonnegative integer | Financial | Necessary; never float/formatted currency |
| same | `currency_code` | Payment Attempt | Required three uppercase ASCII letters | Financial | Necessary |
| same | `preparation_dispatch_id` | Dispatch UUID | Required for normal dispatch route | Operational reference | Opaque UUID is sufficient; no embedded Dispatch data |
| `payment.late_success_recorded` | `method` | Payment Attempt | Required; max 32 ASCII | Financial | Same restriction |
| same | `amount` | Integer successful amount | Required signed 64-bit nonnegative integer | Financial | Necessary |
| same | `currency_code` | Payment Attempt | Required three uppercase ASCII letters | Financial | Necessary |
| same | `review_case_id` | Review Case UUID | Required for late-success route | Financial/security reference | Opaque UUID only |
| `preparation.dispatch_requested` | `order_id` | Order UUID from Dispatch | Required | Operational reference | Needed cross-reference; opaque UUID only |
| Events with current empty metadata | None | — | Empty object only | — | Do not add convenience data |

`order.held.reason` is the only identified current field with material uncontrolled free-text leakage risk. No inspected metadata contains raw customer identity or payment credentials, but current adapters lack event-specific allowlist enforcement.

### 6.2 Proposed initial metadata profile

| Rule | Recommended value | Status/rationale |
|---|---|---|
| Root | JSON object | `TECHNICAL_RECOMMENDATION` |
| Maximum encoded payload | 2,048 UTF-8 bytes | `PROPOSED_NOT_APPROVED`; ample for current minimal fields, limits abuse |
| Nesting depth | 1; flat object | `PROPOSED_NOT_APPROVED`; current metadata is flat |
| Arrays | Forbidden initially | `PROPOSED_NOT_APPROVED`; no current need |
| Keys | Exact event/version allowlist; ASCII snake_case; max 64 characters | `PROPOSED_NOT_APPROVED` |
| General strings | Event-specific fixed vocabulary or max 200 characters | `PROPOSED_NOT_APPROVED`; tighter field limits above win |
| Unicode | NFC where free text is later approved; reject NUL and disallowed control characters | `PROPOSED_NOT_APPROVED`; initial catalog should avoid free text |
| Null | Omit optional key rather than store JSON null | `TECHNICAL_RECOMMENDATION` |
| Number | JSON integer within approved signed range; no float for money | `TECHNICAL_RECOMMENDATION` |
| Timestamp in metadata | RFC 3339 UTC with explicit offset; envelope uses `timestamptz` | `TECHNICAL_RECOMMENDATION` |
| Unknown key/type | Reject before persistence; function repeats key/size checks | Required by logical contract |
| Catalog arrays | Validate every element independently; reject duplicate elements; never validate a comma-joined serialization or silently normalize/deduplicate/reorder | Required by remediated logical/database contract |
| JSONB indexes | None | No reader/query policy approved |

### 6.3 Prohibited content and correction

Never record passwords, PINs, raw Session/recovery/invitation/CSRF/bearer tokens, MFA secrets/codes, authorization/cookie headers, payment credentials, unrestricted request/response bodies, uploaded documents, exception dumps, embedded credentials, or unnecessary personal data.

Safe errors return a stable category and opaque failure reference; rejected metadata is not echoed. Events are not redacted or corrected in place. A later correction/dispute requires a separately approved append event. Retention, holds, export recipients, anonymization, and employee/customer access remain legal/privacy decisions.

## 7. Workstream E — PostgreSQL roles and security review

### 7.1 Actual environment

PostgreSQL `18.7` is used in CI, but CI starts with `POSTGRES_USER=postgres`; default local configuration also uses `postgres`. No production `CREATE ROLE`, ownership topology, ACL export, default-privilege hardening, or dedicated privilege test job exists. SQL schema dumping is current, but role objects are cluster-level and are not established by `structure.sql` alone.

### 7.2 Recommended role custody model

Role names are candidates. No human appointment is made.

| Responsibility | Logical role | Custody requirement | Production separation | Local-only combination |
|---|---|---|---|---|
| Schema/migration owner | `af_schema_owner` + controlled `af_migrator` | Deployment authority; migrator can assume owner only during approved migration | Separate from runtime/function owner | May use test superuser only as nonproduction fixture |
| Audit table owner | `af_schema_owner` | Non-login; owns table/triggers/constraints | Must not be runtime or function owner | Same test superuser may emulate, never production evidence |
| Append function owner | `af_audit_function_owner` | Non-login, unassumable by runtime; owns only exact function | Separate from table/schema owner; minimal INSERT/SELECT grants | Test fixture may combine for functional tests, not privilege evidence |
| Runtime application | Deployment-managed login | Ordinary application credential | Not owner; no audit table privileges | Current `postgres` shortcut allowed only for ordinary tests |
| Append capability | `af_audit_appender` | Non-login grant role; no runtime member in Empty Slice 1 | Exact function EXECUTE only | Dedicated-role tests use a disposable post-authorization principal; production membership requires separate first-producer authorization |
| Future reader | `af_audit_reader` | No grants until policy approval | Separate from appender/export | Cannot be combined before approval |
| Break glass | `af_audit_break_glass` | Time-bound issuance, dual review, external access log, post-use review | No standing runtime membership | Not simulated as production approval |
| Backup/restore | Infrastructure operator role | Separate offline custody/runbook; restore boundary evidence | Separate from runtime/migrator where practical | Test restore role remains fixture only |

The Owner must assign accountable operational roles or approve a managed infrastructure responsibility model before production. Function-owner credentials should not exist: use a `NOLOGIN` role, and no runtime/developer role may assume it. Migration, runtime, break-glass, and backup credentials require separate generation, secret-manager storage, rotation, revocation, monitoring, and incident procedures.

### 7.3 `SECURITY DEFINER` adversarial findings

| ID | Severity | Finding / attack precondition | Impact | Required mitigation and negative test |
|---|---|---|---|---|
| AUD-SEC-01 | `BLOCKER` | The current closure has the full function, element-wise validation, locked helper/constraint revalidation lifecycle and provisional/committed result boundary | Semantic drift or malformed validation/durability handling remains possible until re-review and executable evidence | Review exact function/helpers/contracts; tests for helper replacement, catalog/reference/metadata/replay/time and transaction branches |
| AUD-SEC-02 | `BLOCKER` | No production role provisioning/custody exists; current runtime is superuser locally/CI | Runtime can bypass all controls; tests prove nothing about least privilege | Approve/provision real role topology; dedicated-role CI; catalog/ACL assertions |
| AUD-SEC-03 | `HIGH` | Any code with appender EXECUTE can supply Organization, actor, target, and provenance values | Forged or cross-Organization evidence if Audit Application/composition is bypassed | Decide trusted-runtime threat model; hide function behind Audit adapter, strict Packwerk/interface tests, scope validation; if DB-independent binding is required, separately design protected assertion/credential |
| AUD-SEC-04 | `HIGH` | Historical proposal included event type/version; current design removes them from uniqueness under `AUD-DEC-03` | Residual implementation drift could reintroduce semantic duplicates | Preserve Organization + Producer + Stable Attempt Key; concurrent cross-type/version negative tests |
| AUD-SEC-05 | `HIGH` | Default `PUBLIC EXECUTE`, inherited role memberships, or schema privileges may remain | Unauthorized append/function discovery | Revoke in same migration transaction; inspect effective ACL/membership and exact signature |
| AUD-SEC-06 | `HIGH` | Function owner owns function and can replace it if assumable/compromised | Arbitrary privileged SQL with function owner's grants | `NOLOGIN`, no runtime membership, controlled owner assumption, replacement-denial test, alert on function-definition drift |
| AUD-SEC-07 | `HIGH` | Function owner has table `SELECT`/`INSERT` to support replay | Compromised function can read/append structurally valid evidence | Minimize returned fields; no login/membership; audit definition/ACL; consider narrower helper only if it reduces rather than moves risk |
| AUD-SEC-08 | `MEDIUM` | `search_path`, temporary objects, overloaded signature, implicit casts/operators | Object shadowing or wrong function dispatch | Fixed `pg_catalog, pg_temp` with `pg_temp` explicit last, fully qualified objects, exact typed calls, no dynamic SQL; adversarial temp/overload/cast tests |
| AUD-SEC-09 | `MEDIUM` | Element-wise catalog key/size checks cannot prove metadata values are secret-free or semantically correct | Sensitive-data leakage in structurally valid keys | Audit Application schema validation, prohibited-value fixtures, safe error logging; no payload echo |
| AUD-SEC-10 | `MEDIUM` | Catalog approval provenance is stored text controlled by migration authority | False catalog row if migration process compromised | Reviewed migration tied to Owner decision; signed/reviewed release evidence; catalog drift monitoring |
| AUD-SEC-11 | `MEDIUM` | Original proposal retained a Branch FK/shape that could not prove same Organization | Prohibited scope/coupling and future cross-Organization association | Current remediation removes every Branch representation from Slice 1; any future Branch design requires a separate decision and review |
| AUD-SEC-12 | `MEDIUM` | Actor User has no DB Organization FK and function cannot verify Identity issuance | Cross-Organization or invented actor UUID if application trust is bypassed | Trusted context mapping, actor/org equality in Audit Application, negative interface tests; decide residual risk |
| AUD-SEC-13 | `LOW` | Caller supplies finite `occurred_at` through trusted Application | Extreme, backdated or future evidence if producer clock/value is wrong | Reject infinity generically; server clock contract and event-specific age/skew/delay policy; do not accept client timestamp |
| AUD-SEC-14 | `INFORMATIONAL` | Table owner, superuser, break-glass, and restore operator can bypass triggers/ACLs | Evidence rewrite/removal | Never claim absolute immutability; custody, monitoring, checkpoints, restore reconciliation |

### 7.4 Required privilege properties

- Runtime appender: exact-signature `EXECUTE` only; no base-table/catalog access, schema creation, ownership, trigger control, function replacement, or role administration.
- Function: `SECURITY DEFINER`, `VOLATILE`, fixed `search_path`, fully qualified application objects, no dynamic SQL, typed parameters, stable safe errors, and minimal result.
- Function owner: no login or table/schema ownership; only required event-table `SELECT`/`INSERT` and catalog `SELECT`; no `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN`, alter, role grant, or assumable runtime path. Replay uses no row lock.
- Table/schema owner: no runtime login or membership; migrations only.
- Reader: no initial grant.
- Break glass/restore: privileged limitations acknowledged, access externally logged/reviewed.
- `af_migrator`: `NOSUPERUSER NOCREATEROLE NOCREATEDB NOREPLICATION NOBYPASSRLS`; owner grants are recorded, time-bounded `SET TRUE, INHERIT FALSE, ADMIN FALSE` and revoked. Provider-control-plane authority is a separate trust boundary.
- `PUBLIC`: no table privileges or function execute; apply and inspect per-owner **global** default-function revocation separately from any per-schema default, and revoke each new object's `PUBLIC EXECUTE` in its creation transaction.
- Every relevant role and direct/`PUBLIC`/inherited/`SET ROLE` path: explicitly evaluate all eight table privileges—`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN`.

### 7.5 Test strategy

| Test class | Coverage | Environment |
|---|---|---|
| Normal CI | Empty catalog denial; envelope/metadata validation; matching/conflicting replay; two-session races; structured SQLSTATE; outer-wrapper issuance/ambient/nested/no-savepoint capability matrix; atomic rollback; separate pre-entry parse/resolution/bind/decode/conversion failure and post-entry exact-session `AUE02` cases; stage-specific UTF-8; non-reusable restore attempt, target-generation fencing, mixed-evidence rejection and atomic-promotion tests; monitoring-enforcement boundary; byte parity/C-collation; append-only trigger; migration/structure equivalence; Branch regressions | Rails 8.1.4.1 and PostgreSQL 18.7; may use fixture owner but cannot claim role security or provider enforcement |
| Dedicated privilege integration | All eight direct/effective table privileges; exact function EXECUTE; PUBLIC/default-ACL denial; migrator attributes and owner membership before/during/after; role assumption/ownership/function replacement/trigger tampering denial; cross-Organization and unapproved producer/event calls | Real separate roles provisioned in disposable DB |
| Privileged setup/teardown | Create/drop fixture roles, grants, owners; verify catalog ACLs; prove owner/superuser bypass and cleanup | Isolated disposable cluster/database only |
| Manual production readiness | Credential custody/rotation, effective grants, default privileges, function hash/definition, monitoring, backup/restore rehearsal, break-glass review | Production-parity controlled environment; no customer/employee data required |

No such privilege test was run in this task.

## 8. Cross-workstream consistency findings

| Finding | Status | Required action |
|---|---|---|
| Empty catalog aligns with “only approved types” | Consistent | Keep catalog empty in Slice 1 |
| Current nine events are Branch-scoped while first store is Organization-only | Consistent only if no migration/duplication occurs | Defer producer migration and preserve existing store |
| Raw legacy actor UUID conflicts with trusted human contract | Material gap | Producer migration requires trusted Identity context first |
| Current system expiry lacks registered provenance | Material gap | Keep system disabled in first Organization slice |
| PostgreSQL catalog actor/outcome/metadata rules align with logical envelope | Synchronized in Round 3 at design level | Re-review element-wise helpers and future Application schemas |
| Helper replacement versus previously validated CHECK constraints | Round 4 defines a single locked transaction that drops/recreates direct dependencies, forces full validation and rejects violating rows | Re-review the lifecycle; after authorization execute success/failure/concurrency/rollback/restore evidence |
| Embedded append versus committed Application success | Round 4 makes embedded return provisional and assigns committed-result construction only to the known-committed outermost owner | Re-review the logical boundary; later implementation must prove nested/outer and uncertain-commit behavior |
| Duplicate catalog-array elements versus stable registration projection | Duplicate outcomes/keys are rejected; the reviewed manifest's order is preserved and projection/hash comparison is exact and positional | Independently review; after authorization test duplicates, case variants, reordered arrays and hash/drift behavior |
| Idempotency type/version scope can permit semantic duplicate | Historical contradiction, superseded by `AUD-DEC-03` | Preserve Organization + Producer + Stable Attempt Key and cross-type/version conflict tests |
| Original optional Branch column versus binding prohibition | Original proposal contradicted `AUD-DEC-04` | Verified design remediation removes the column, FK, catalog mode and every indirect Branch identity; external whole-package review still required |
| Function EXECUTE does not cryptographically bind caller scope | Residual trust-model gap | Security decision: accept trusted monolith model or design stronger assertion/process separation |
| Existing transaction rollback supports recommended atomic class | Verified behavior, not approval | Owner approves per event before migration |
| Metadata schemas match actual fields except raw hold reason | One privacy remediation needed | Approve reason-code/reference replacement before migration |
| Existing strict Platform package exists; no Audit module exists | Expected | Slice 1 adds `backend/app/contexts/platform/audit_evidence/` under `Platform::AuditEvidence`; it does not create a Bounded Context or Packwerk package |
| Production privilege design is not exercised by current CI | Blocker for security claim | Add dedicated role tests in authorized slice |

## 9. Bounded implementation proposal

### 9.1 Slice 1 — Audit Evidence infrastructure

**Exact architecture scope:** add `backend/app/contexts/platform/audit_evidence/` with namespace `Platform::AuditEvidence` inside the existing dependency-free strict `backend/app/contexts/platform/package.yml`. Domain contains only framework-independent values and invariants; Application exposes the append contract, validation/orchestration and provisional results; Infrastructure contains persistence records, mapper/repository, PostgreSQL adapter and wrapper-owned transaction participation. Only the Application contract is cross-module. This is not a new Bounded Context or Packwerk package and adds no producer-package dependency. The designated outer wrapper must prove its selected adapter is idle, open and own the supported transaction, and issue the sole capability. Joined inner services may reuse it, but an arbitrary caller-owned or pre-existing ambient transaction is unsupported; adding caller-owned transaction support requires a separately designed, reviewed and approved protocol.

Infrastructure uses a module-local abstract `Platform::AuditEvidence::Infrastructure::Persistence::Record < ActiveRecord::Base` and must not inherit root `ApplicationRecord`, establish/switch a connection or create an independent pool. Subclassing does not establish atomicity. The supported primary-writing/default-shard path requires the outer wrapper to hold `with_connection`, prove no transaction is active, open the outer transaction itself and alone issue the capability from its yielded transaction object. Specification, role/shard pool, adapter/raw connection, yielded/current transaction object/UUID, Thread/Fiber and fresh attempt generation must all match. Joined scope reuses that capability; ambient transaction, nested issuer, `requires_new`/real savepoint/restarted parent, retry, stale/transfer/check-in/reconnect/switch or any unprovable identity fails before Audit SQL with no fallback. The authoritative rule is [Security Design Closure — Rails connection policy](organization_level_audit_security_design_closure.md#authoritative-rails-connection-and-transaction-participation-policy). Packwerk/custom guards remain static; PostgreSQL privileges remain runtime enforcement.

**Exact deliverable scope:** immutable envelope; append Application interface; empty migration-owned catalog; separate empty Organization event store; append-only controls; exact append function; database owner/function-owner/NOLOGIN appender roles and grants; migration/rollback, role, catalog, idempotency, transaction and architecture-guard tests. No production composition wiring, controller, job, callback, caller, catalog registration, projection fixture/hash implementation for an approved registration, reader or producer is included.

**Prerequisites before implementation authorization:** preserve `AUD-DEC-01`–`06`; obtain focused independent acceptance of the complete design; review the exact implementation diff scope plus disposable-role, privilege, migration, rollback and recovery test plans; confirm the catalog remains empty and no producer is included. Executed migration/role/test evidence is produced only after bounded authorization and must pass before implementation acceptance. Production provisioning/custody evidence remains a separate pre-deployment requirement.

**Acceptance criteria:**

- no production event can be appended with empty catalog;
- creation, migration, structure load, logical restore with/without `--create`, isolated physical restore, connection establishment, append, startup/return and monitoring follow the [UTF-8 lifecycle matrix](organization_level_audit_security_design_closure.md#utf-8-lifecycle-enforcement-matrix): native fail-closed handling for parse/resolution/bind/decode/conversion errors before function entry, exact-session `AUE02` only after successful entry reaches the first encoding guard, attempt/source/target-generation/invocation binding, quarantine until successful aggregate tool status, available worker evidence and reconciliation, atomic promotion, and separate readiness/traffic enforcement. Neither failure path permits a receipt, later statement or alternate-connection fallback; no prior or representative check substitutes for the executing append session;
- among non-owner principals, only the NOLOGIN `af_audit_appender` role receives explicit exact-function `EXECUTE`; `af_audit_function_owner` retains inherent owner execution rights, while `af_runtime` can assume neither role and has no callable production append interface in Empty Slice 1;
- matching replay is stable and conflicting replay is rejected, including changed type/version;
- replay uses ordinary post-conflict read with no mutation grant; concurrent identical/conflicting requests, winner commit/rollback, stronger-isolation/deadlock states and whole-transaction retry produce no duplicate or misleading result;
- embedded append returns only `PendingAppendReceipt`; only a successful, known wrapper-opened outer commit permits `CommittedAppendResult(appended or idempotent_replay)`. An ordinary joined scope must reuse the sole capability and retain the same public transaction object/UUID; ambient entry, nested issuance, `requires_new`, real savepoint or restarted parent is unsupported and fails before SQL with no receipt;
- every load/restore acceptance record is bound to one non-reusable attempt ID, unique invocation, source artifact and exclusively owned target generation. Generation is checked at preflight, completion, immediately before promotion and during an atomic one-way `QUARANTINED -> ACCEPTED` decision; mixed/stale/replayed/superseded evidence or unavailable provider-neutral fencing keeps the target quarantined;
- helper semantic changes cannot use `CREATE OR REPLACE FUNCTION` alone; the locked atomic drop/recreate/full-validation protocol and release evidence are mandatory;
- all three catalog arrays reject duplicates in Application and PostgreSQL; no trimming, folding, deduplication, sorting or reordering occurs, and projection/hash comparison preserves the reviewed order;
- catalog arrays are validated element-by-element, explicit registration denial is distinct from native privilege failure, and occurrence time is finite;
- Organization scope is enforced and static inspection proves the Slice 1 schema/contract contains no Branch representation;
- update/delete/truncate are rejected under runtime role;
- migration-from-empty, rollback while empty, and `structure.sql` equivalence pass;
- existing Branch audit files/schema/tests remain unchanged;
- database errors map only from structured `PG_DIAG_SQLSTATE`, always unwind the failed transaction, and never parse messages or continue/retry inside an aborted transaction;
- the module-local persistence base demonstrably satisfies the same-specification, same-pool, same-raw-connection and same-active-transaction predicate; business/Audit rollback is atomic; unsupported role/shard/class-root/multi-database paths fail before Audit SQL; source guards cover direct, absolute, aliased, chained and composition bypass forms; and
- full backend, architecture, Packwerk, static/security checks are run under the future implementation task.

**Rollback:** the authorized rollback test uses external quiescence plus one transaction, fixed `ACCESS EXCLUSIVE` order (catalog then events), under-lock emptiness checks, reviewed dependency inventory and exact dependency-order removal. Any row or mismatch aborts. It preserves unrelated objects and roles, proves rollback/reapply, and never treats a pre-lock observation as sufficient. Stop and use forward remediation once evidence exists.

**Stop conditions:** unresolved role ownership, incomplete function, unexpected existing producer access, inability to create real privilege tests, or any change to Branch audit behavior.

### 9.2 Slice 2 — First approved producer

**Scope:** exactly one Owner-approved human event, its producer port/adapter/composition, catalog migration, metadata schema, failure class, and tests. No Employee creation unless separately authorized.

**Prerequisites:** exact catalog decision; trusted Identity context available at use case; approved failure/idempotency/metadata policy; approved temporal source/past-age/future-skew/delay policy; security and privacy review proportionate to fields.

**Acceptance criteria:** producer cannot supply raw actor/Organization authority; cross-Organization and metadata attacks fail; transaction/failure semantics pass; no other event becomes enabled.

**Stop conditions:** system actor required, target scope cannot be proven, business authority unresolved, or event requires reader/retention policy not yet approved.

### 9.3 Slice 3 — Existing producer migration

Review Orders, Payments, and Preparation separately. Each migration must preserve verified transaction, replay, Outbox, late-success, and error behavior. It must decide whether the producer continues using the Branch store through the new module or moves under a later approved store design; it must never duplicate an event into both stores by default.

No wholesale rewrite, global backfill, shared event ordering, or silent actor change is allowed. Each event needs explicit approval and regression evidence.

### 9.4 Excluded from initial foundation

Reader/search interfaces, export, retention/purge jobs, legal hold, correction/redaction/anonymization workflows, external sink, global ordering, Branch backfill, Employee creation, new business workflows, deployment, Gate, FOA, and Production Authorization remain excluded.

## 10. Owner decision register

The IDs below are local review references, not canonical ODB allocations.

### A. Owner-confirmed design directions; implementation review remains required

| ID | Exact question | Why it matters | Recommended answer | Alternatives and risks | Blocks schema? | Blocks implementation? | Qualified input | Deferrable? |
|---|---|---|---|---|---|---|---|---|
| `AUD-DEC-01` | May Slice 1 create an empty catalog/store/package with no production producer? | Determines whether safe infrastructure can precede business-event policy | Yes | Add characterization event: creates unapproved business evidence; defer all: delays testable foundation | No | Review remains | Security review | `OWNER_CONFIRMED`, 2026-11-27 |
| `AUD-DEC-02` | Which append mechanism is approved? | Determines privilege surface and replay access | Narrow `SECURITY DEFINER`, exact EXECUTE, no runtime table grants | Direct INSERT: weaker catalog/replay isolation; separate process: operational/transaction complexity | Yes | Review remains | Security review required | `OWNER_CONFIRMED`, 2026-11-27 |
| `AUD-DEC-03` | What is one logical idempotency scope? | Prevents a changed semantic replay from becoming a second event | Unique by Organization + producer + stable attempt key; type/version changes conflict | Include type/version: semantic duplicate risk; global key: collision/coupling risk | Yes | Review remains | Technical/security review | `OWNER_CONFIRMED`, 2026-11-27 |
| `AUD-DEC-04` | May Slice 1 contain any Branch reference? | A dormant/nullable reference still creates prohibited scope and coupling | No; no Branch column, FK, target, validation path, catalog mode, fixture or indirect identity | Any future Branch support requires a separate decision/design/review | Yes | Review remains | Security review | `OWNER_CONFIRMED`, 2026-11-27; verified design remediation, external whole-package review still required |
| `AUD-DEC-05` | Which actor modes are enabled in first foundation? | System activation introduces producer custody and spoofing controls | Human shape only; no event enabled until catalog approval | Human+system: unresolved producer custody; system-only: no current need | No | Review remains | Security review | `OWNER_CONFIRMED`, 2026-11-27 |
| `AUD-DEC-06` | Approve proposed production role separation/custody model? | Append-only claims depend on ownership and effective privileges | Separate non-login schema/table owner and function owner; NOLOGIN appender is the sole non-owner explicit EXECUTE grantee; runtime membership waits for first-producer authorization | Combined production owner/runtime: defeats protections | Yes | Review remains | Security/operations review and Owner assignment | `OWNER_CONFIRMED`, 2026-11-27 |

### B. Must decide before first production event

| ID | Exact question | Why it matters | Recommended answer | Alternatives and risks | Blocks schema? | Blocks first event? | Qualified input | Deferrable? |
|---|---|---|---|---|---|---|---|---|
| `AUD-DEC-07` | Which exact event tuple is first? | Catalog must deny every unapproved meaning | Select one human, Organization-only event only after business authority exists | Enable legacy set: broad unreviewed migration; synthetic event: false evidence | No | Yes | Security/privacy depending fields | Yes, while catalog remains empty |
| `AUD-DEC-08` | What failure class applies to that event? | Determines transaction rollback and evidence truth | `atomic_fail_closed` for a successful sensitive/material mutation | Separate evidence: atomicity gap; fail-open: missing authoritative evidence | No | Yes | Security/business review | Yes, until first event |
| `AUD-DEC-09` | What actor/session evidence is mandatory? | Controls attribution, spoofing, and privacy | Trusted User+Organization; Session reference only when necessary and approved | Raw actor UUID: spoofing; universal Session: privacy/retention cost | No | Yes | Security/privacy | Yes, until first event |
| `AUD-DEC-10` | Approve the event-specific metadata schema and limits? | Prevents secret/PII leakage and ambiguous evidence | Exact minimal keys, flat object, no arrays, candidate 2,048-byte maximum | Unrestricted JSON: leakage/abuse; no metadata: inadequate evidence | No | Yes | Security/privacy | Yes, until first event |
| `AUD-DEC-11` | Accept trusted modular-monolith composition as actor/scope authority, or require DB-independent proof? | The function cannot itself prove Identity issuance or caller Organization | Accept for first bounded slice with explicit residual risk and strict tests | Signed assertion/separate process: stronger isolation, significant custody/availability complexity | No | Yes | Focused security review | No before first event |

### C. Deferrable until reader/export/retention slices

| ID | Exact question | Why it matters | Recommended answer | Alternatives and risks | Blocks empty foundation? | Blocks later feature/production? | Qualified input | Deferrable? |
|---|---|---|---|---|---|---|---|---|
| `AUD-DEC-12` | Who may read/search each event class and scope? | Audit data contains sensitive employee/financial/security evidence | Defer; grant no reader | Early reader: unauthorized exposure risk; no reader: no operational UI | No | Yes, reader feature | Security/privacy | Yes |
| `AUD-DEC-13` | Who may export, receive, approve, or deliver evidence? | Export creates a new disclosure and custody surface | Defer; implement no export | Early export: disclosure risk; no export: incident/manual investigation limited | No | Yes, export feature | Legal/privacy/security | Yes |
| `AUD-DEC-14` | What retention, hold/release, correction/dispute, anonymization, and backup-expiry rules apply? | Append-only evidence can conflict with privacy/deletion and legal duties | Defer feature, but obtain input before production data | Indefinite retention: privacy/legal uncertainty; premature deletion: evidence loss | No | Yes, production operation | Legal/privacy/accounting | Feature can defer; qualified input cannot defer past production data |

### D. Qualified review requirements

| ID | Required review | Exact scope | Blocking point |
|---|---|---|---|
| `AUD-REV-01` | Focused database/application security review | Function body, roles/ACLs, scope binding, idempotency, metadata, concurrency, failure/rollback, tampering tests | Before implementation authorization |
| `AUD-REV-02` | Legal/privacy review | Event-class purpose, employee/customer data, retention, access/correction, holds, anonymization/deletion, exports, backups | Before first production personal/security evidence and later reader/retention features |
| `AUD-REV-03` | Operational security review | Credential custody, rotation/revocation, migrations, break glass, backup/restore, monitoring and incident response | Before production deployment |

## 11. Security, legal, and privacy blockers

The canonical audit security review remains blocked and the retention/hold and export/anonymization reviews contain no qualified conclusions ([AF-SEC-008](../architecture/security-reviews/af-sec-008-audit-security.md), [AF-PRIV-004](../architecture/security-reviews/af-priv-004-audit-retention-legal-holds.md), [AF-PRIV-005](../architecture/security-reviews/af-priv-005-exports-anonymization.md)).

An empty infrastructure slice can be reviewed without deciding numeric retention or reader/export policy because it stores no production event. It still requires focused security acceptance of the privileged function and role topology. Production use requires event-purpose/privacy input and cannot inherit an indefinite-retention assumption.

Owner technical risk acceptance is not an independent security review or legal advice. No report may call this foundation tamper-proof, absolutely immutable, compliant, or production-ready.

## 12. Explicit exclusions and unresolved risks

This package does not implement or modify migrations, schema, roles, grants, packages, source code, tests, writers, catalog rows, Employee creation, readers, exports, retention, holds, redaction, CI, Packwerk, canonical policy, ADRs, or existing research reports.

Unresolved risks include arbitrary in-process caller access to the append function, privileged database/restore bypass, operational role custody, cross-Organization actor spoofing, unapproved event semantics, raw hold-reason leakage, metadata semantic bypass, denial/failure evidence gaps, reader/retention uncertainty, and lack of dedicated privilege-test evidence. The function-body and idempotency-design contradictions are resolved at design level in the security closure; implementation and adversarial evidence remain absent.

## 13. Recommended next action

Conduct the final narrow read-only verification of `ISR-AUD-036/041`, specifically wrapper-owned participation with ambient rejection and the pre-entry native-error versus in-function `AUE02` boundary. Preserve the latest design-level verification of `ISR-AUD-039/040/042`; executable evidence for all five remains later. The subsequent external review still covers the full remediated Branch-free DDL/function, NULL-safe and ASCII identifier validation, helper replacement/full-revalidation lifecycle, provisional/committed result boundary, complete database/parameter privilege installation, Audit-owned failure-class registration, trust boundary and staged evidence matrix in the security closure. Do not choose the first production event until `AUD-DEC-07` through `AUD-DEC-11` and proportionate qualified review are complete.

The follow-up review must also dispose `ISR-AUD-013`: verify duplicate rejection for all three catalog arrays in Application and PostgreSQL; exact case-sensitive comparison; no silent normalization/deduplication/reordering; the complete version-1 header, 21-field type/presence/length framing and scalar/array encodings; SHA-256 input/digest rules; Audit-owned authority boundary; release drift detection; unchanged subset semantics; NULL/empty boundaries; and the pending language-neutral fixture schema. No fixture digest, executable test or implementation has been generated or authorized by this documentation correction.

After focused re-review accepts the corrected empty-infrastructure design, the Owner may separately consider a narrowly scoped Slice 1 implementation authorization. `AUD-DEC-07` through `AUD-DEC-11` are not prerequisites to that empty-slice authorization; they remain mandatory before a first human producer. Do not automatically start implementation, add a catalog row, or migrate an existing producer.

## 14. External independent review handoff package

### 14.1 Review mandate

The external reviewer must inspect the actual five documents in §14.2 and adversarially assess:

- the Organization-level Audit architecture and Domain/Application/Infrastructure dependency direction;
- the canonical registration projection, strict decoder, hashing and comparison contract;
- PostgreSQL roles, ownership, effective privileges and exact `SECURITY DEFINER` boundary;
- controlled dual-owner `SET ROLE` installation and empty rollback;
- append-only trigger/function behavior, RLS assumptions and normalized catalog assertions;
- transaction ownership, pending/committed results, failure classification, replay and concurrency;
- catalog immutability, helper replacement/revalidation and release drift;
- migration, rollback, restore/recovery and fail-closed behavior; and
- the exact Empty Slice 1 manifest and exclusions from catalog registration, producers and later capabilities.

The reviewer must challenge the design rather than accept a remediation because this package or its finding register labels it remediated.

### 14.2 Exact review materials and snapshot identity

Review baseline: branch `development`, repository HEAD `b49a8827be53797b30ea1d7cb47791e7c74e7231`. The documents are untracked working artifacts, so the Git commit does not identify their contents. SHA-256 is over the exact UTF-8 file bytes at review-package preparation time:

| Required document | SHA-256 snapshot |
|---|---|
| `docs/research/organization_level_audit_foundation_assessment.md` | `f9e4ace72dcfd361d14f0d2deb6849fdcf2e3fcbcbf7d3aacb7a6f77a59bbe58` |
| `docs/research/organization_level_audit_logical_contract_design.md` | `cd66a60b5a58ed82e025803f70a53d08fe1ccfde2d3366d5dd8dd7dabe738121` |
| `docs/research/organization_level_audit_postgresql_design.md` | `5cd8a7c98a0782b5453f92595dbbc343083a83bd15f994ed7ecc65f77627207f` |
| `docs/research/organization_level_audit_foundation_decision_package.md` | Record the exact file SHA-256 in the external assignment/handoff after this manifest is finalized; a document cannot contain its own ordinary content hash without changing it. A missing handoff hash makes the review snapshot incomplete. |
| `docs/research/organization_level_audit_security_design_closure.md` | `1995c6249e46bc7a62e858325b850e7118c3173c26c73bb4d9b11db2dbd084c8` |

The reviewer must verify all five hashes supplied at handoff and inspect the actual documents, not merely an executive summary, copied finding list or Codex conclusion. Any post-handoff edit creates a new snapshot and must be disclosed.

### 14.3 Required qualifications and reviewer independence

At least one reviewer must be independent of the original design and implementation team and demonstrate relevant experience in PostgreSQL privilege/security design, `SECURITY DEFINER` hardening, safe database migrations/rollback, application architecture/domain boundaries, transaction semantics, audit-evidence integrity and adversarial review. Separate PostgreSQL-security and application-architecture specialists are recommended when one reviewer cannot credibly cover both.

The signed or otherwise attributable report must disclose:

- reviewer identity, organization and relevant qualifications;
- prior involvement in this design, repository or future implementation;
- financial, reporting-line or other organizational conflicts;
- repository/source access and exact snapshot hashes inspected;
- whether work was performed independently;
- methods, tools, tests or static analysis used; and
- limitations, exclusions, time constraints and evidence not reproduced.

Internal Codex agents, the authoring agent and a reviewer who only reads this summary do not satisfy this external-independence requirement.

### 14.4 Mandatory reviewer output and dispositions

The report is incomplete unless it contains exactly one explicit disposition for every `ISR-AUD-001`–`042`, every `AUD-SEC-01`–`14`, and every later new finding. Permitted dispositions are:

- `ACCEPTED_VERIFIED`;
- `ACCEPTED_WITH_CONDITIONS`;
- `PARTIALLY_ACCEPTED`;
- `REJECTED_UNRESOLVED`;
- `NOT_APPLICABLE_WITH_JUSTIFICATION`; or
- `REQUIRES_POST_AUTHORIZATION_EXECUTABLE_EVIDENCE`.

Each disposition must give severity, exploitability/correctness impact, exact affected sections, reviewed evidence, limitations, blocking scope (`EMPTY_SLICE_1`, `FIRST_CATALOG`, `FIRST_HUMAN_PRODUCER`, `LATER_CAPABILITY`, or combinations), required remediation, regression evidence and whether focused external re-review is required. “Overall pass” without per-finding dispositions is insufficient. A documentation claim alone cannot support `ACCEPTED_VERIFIED`.

The final overall verdict must state whether the reviewed snapshot is acceptable for the Owner to consider bounded Empty Slice 1 implementation authorization, and must explicitly exclude Stages B–D unless separately reviewed and authorized.

### 14.5 Reviewer response template

The reviewer should provide one row for each of the 56 existing findings and append new stable identifiers after `ISR-AUD-042`:

| Finding | Original severity | Disposition | Exact sections inspected | Evidence reproduced | Exploitability / correctness impact | Blocking scope | Conditions or remediation | Regression evidence | Re-review required? |
|---|---|---|---|---|---|---|---|---|---|
| `ISR-AUD-___` or `AUD-SEC-__` | Required | Required enum | Required | Required; state `NOT_REPRODUCED` when applicable | Required | Required stage(s) | Required or `NONE` | Required or future authorized evidence | `YES` / `NO`, with reason |

The report must also include the reviewer identity/qualification/conflict declaration, five verified hashes, methods and limitations, new-findings register and overall verdict.

### 14.6 Remediation and re-review tracking template

External findings remain open while Codex or the design team edits documentation. For each remediation, retain this ledger without replacing the original reviewer statement:

| Finding | External report reference | Original disposition | Remediation and changed sections | Regression risks | Internal validation | External re-review reference | Final external disposition |
|---|---|---|---|---|---|---|---|
| ID | Stable report/page/section | Verbatim status | Exact change | Required | Actual checks only | Required for material remediation | Remains open until supplied |

An ambiguous external statement requires reviewer clarification. It must not be interpreted as acceptance.

### 14.7 Authorization staging reviewed by the external reviewer

| Stage | Scope | Review/decision boundary |
|---|---|---|
| A — Empty Slice 1 | Exact `Platform::AuditEvidence` module, empty catalog/store, dormant function/triggers/roles/tests, no runtime appender membership or production caller | Subject of this external review; Owner authorization remains separate |
| B — First registration | Golden bytes/digests, two independent reproductions, executable parity, catalog-row authorization | Separate future review and authorization |
| C — First human producer | `AUD-DEC-07`–`11`, event/producer/actor/failure/privacy/operations | Separate future review and authorization |
| D — Later capabilities | System producers, reader/export, retention/hold/correction/redaction, Branch migration, deployment/Gate/FOA/Production Authorization | Deferred and excluded |

### 14.8 Review acceptance stop conditions

Stop the authorization path if the reviewer did not inspect the exact snapshot, lacks the required independence declaration, omits a finding, uses an ambiguous disposition, discovers a material unresolved defect, relies on unexecuted evidence as proof, expands Stage A, or cannot separate post-authorization executable evidence from pre-authorization design review.

## 15. Current external-review state

`EXTERNAL_REVIEW_NOT_YET_PERFORMED`

No external reviewer identity, engagement acceptance, independence declaration, verified-snapshot report or per-finding external disposition has been supplied. This package authorizes no contact, hiring, payment or disclosure. The Owner must select and authorize an appropriate reviewer and provide the exact five-file snapshot plus its complete hash manifest.

**Separate recommendation — not a decision (`AUD-GOV-ZC-01`).** Because Empty Slice 1 is dormant—empty catalog, no producer, no runtime appender membership, no reader/export and no production data—the Owner could reasonably consider a future, explicit internal-only assurance exception limited to evaluating that dormant infrastructure. Such an exception would need its own written scope, qualified independent internal reviewers, conflict disclosure, complete `ISR-AUD-001`–`042`/`AUD-SEC-01`–`14` dispositions, and a hard stop before any catalog row, producer, runtime grant or deployment. It would not equal external assurance or authorize implementation/production. `AUD-GOV-ZC-01` remains unresolved; this package does not select the exception.

## Final verdict

`EXTERNAL_REVIEW_NOT_YET_PERFORMED`

The Owner-confirmed `AUD-DEC-01`–`06` are not reopened, and `AUD-DEC-07`–`14` are correctly staged after the empty-slice decision point. No implementation authorization follows: after focused re-review of the newest corrections, a genuinely external independent review must disposition all `ISR-AUD-001`–`042` and `AUD-SEC-01`–`14`, after which the Owner may consider the exact bounded manifest above. Disposable implementation evidence follows authorization; production provisioning evidence remains a pre-deployment requirement.
