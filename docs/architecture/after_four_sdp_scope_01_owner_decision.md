# AFTER FOUR — SDP-SCOPE-01 Owner Decision

**Local decision reference:** `SDP-SCOPE-01`

**Decision date:** 2026-11-16

**Authority:** Owner

**Owner business-policy direction:** `OWNER_DECIDED` / `OWNER_CONFIRMED`

**Business policy:** `OPTION_D_DELIBERATE_DEFERRAL`

**Technical direction:** `PRESERVE_OPTION_C_EVOLUTION`

**Canonical ODB ID:** `ID_PENDING_OWNER_GOVERNANCE`

**Technical design approval:** `NOT_GRANTED`

**Context topology approval:** `NOT_GRANTED`

**Legal/privacy approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Control Acceptance:** `NOT_GRANTED`

## 1. Owner-confirmed business policy

For current operations, the Owner deliberately defers the Organization-wide versus Brand-scoped Customer identity policy:

1. retain the initial operating assumption of one Organization and one Brand;
2. do not introduce complex multi-Brand Customer UI/UX now;
3. do not interpret that initial assumption as approval of either Organization-wide or Brand-scoped Customer identity semantics;
4. do not implicitly authorize cross-Brand Customer discovery, visibility, Loyalty sharing, Promotion applicability, or benefits; and
5. keep unresolved multi-Brand business semantics explicitly unresolved.

This is an Owner-decided deferral, not an implicit selection of another business-policy option.

## 2. Technical design direction

Future design must preserve the ability to evolve toward Option C: Organization-wide canonical Customer identity with Brand-specific participation.

The direction requires future design work to:

- keep canonical/original Customer identity conceptually separate from Brand-scoped business and transaction context;
- preserve data and API boundaries in which Brand-specific transactions and relationships need not expose original Customer identity directly;
- avoid irreversibly binding canonical Customer identity to one Brand merely because initial operation uses one Organization and one Brand; and
- keep cross-Brand access, participation, consent, benefits, visibility, and authorization explicit and independently governed.

“Preserve Option C evolution” means structural evolvability only. It does not select Option C as business policy or context topology and does not approve a schema, foreign-key arrangement, identifier algorithm, mapping store, API contract, module, service, or database.

## 3. Preserved SDP-CUST decisions

This decision does not modify or reinterpret:

- [`SDP-CUST-01`](after_four_sdp_cust_01_owner_decision.md) — existing Loyalty balance and ledger remain preserved, redemption remains frozen after anonymization becomes effective, no new Customer-specific Loyalty benefits are issued, and exceptional treatment requires separately approved policy and appropriate authority; or
- [`SDP-CUST-02`](after_four_sdp_cust_02_owner_decision.md) — pseudonymous references do not restore redemption eligibility, and downstream domains receive no automatic access to original identity or identity mapping.

No cross-Brand Loyalty or Promotion sharing is inferred.

## 4. Domain ownership boundary

- Customer Management owns Customer Profile, original identity data, and anonymization state.
- Loyalty owns Loyalty Account, balance, ledger, and redemption eligibility.
- Promotions owns Promotion eligibility, usage, and related policy.
- Ordering owns Order and historical commercial records.

The technical direction does not change these ownership boundaries or authorize one domain to rewrite another domain's history.

## 5. Unresolved business questions

The following remain unresolved:

- Organization-wide versus Brand-scoped Customer identity semantics for future operations;
- Brand participation and consent;
- cross-Brand discovery, visibility, and authorization;
- cross-Brand Loyalty and Promotion applicability or benefits;
- phone uniqueness scope and normalization; and
- pseudonymous-reference scope and mapping governance.

## 6. Open technical decisions

This decision does not determine:

- schema or relationship design;
- identifier, tokenization, or mapping mechanisms;
- API contracts or authorization boundaries;
- transaction propagation, concurrency, retry, idempotency, or failure handling;
- the final Customer, Loyalty, and Promotions Bounded Context topology; or
- any implementation or migration plan.

## 7. Governance boundary

Only the business-policy deferral and limited technical evolution direction above are confirmed. This record grants no:

- technical design or context-topology approval;
- legal or privacy approval;
- Bounded Implementation Authorization;
- Control Acceptance;
- Final Operational Acceptance; or
- Production Authorization.

It authorizes no source code, test, schema, migration, database, API implementation, configuration, deployment, or runtime change and allocates no canonical `ODB-*` identifier.

## 8. Evidence limitation

The scenario-based decision register that introduced local reference `SDP-SCOPE-01` is not stored as a repository document. Its source was supplied as read-only review material. This record preserves the Owner-confirmed decision without recreating or treating that non-repository register as a canonical document.

## 9. Canonical references

- [Owner Decision Baseline §5A](after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)
- [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions)
- [Data Dictionary §6](after_four_data_dictionary.md#6-customers-loyalty-and-promotions)
- [ERD §7](after_four_erd.md#7-customer-and-loyalty-erd)
- [SDP-CUST-01 Owner Decision](after_four_sdp_cust_01_owner_decision.md)
- [SDP-CUST-02 Owner Decision](after_four_sdp_cust_02_owner_decision.md)

**Final Operational Acceptance:** `NOT_GRANTED`

**Production Authorization:** `NOT_GRANTED`
