# AFTER FOUR — SDP-CUST-02 Owner Decision

**Local review reference:** `SDP-CUST-02`

**Decision date:** 2026-11-16

**Authority:** Owner

**Decision-record status:** `OWNER_DECIDED`

**Baseline classification:** `OWNER_CONFIRMED`

**Selected option:** `B — Pseudonymize`

**Canonical ODB ID:** `ID_PENDING_OWNER_GOVERNANCE`

**Implementation authorization:** `NOT_GRANTED`

**Legal/privacy approval:** `NOT_GRANTED`

## 1. Decision

When Customer anonymization becomes effective:

1. relevant downstream business records should use pseudonymous Customer references instead of directly exposing Customer PII where a Customer relationship must be retained;
2. necessary Loyalty audit, reconciliation, and historical business relationships may be preserved through pseudonymous references;
3. Promotions may retain a Customer relationship only where a documented and legitimate business requirement requires it, such as audit, usage-limit enforcement, or abuse prevention;
4. Loyalty and Promotions must not automatically receive access to the original Customer identity or identity-to-reference mapping;
5. direct PII must not be retained in Loyalty or Promotions merely for convenience when a pseudonymous reference is sufficient; and
6. the exact data retained by each domain must remain proportionate to its documented business purpose.

This is an Owner-approved business-policy decision. The local review reference remains `SDP-CUST-02`; no canonical `ODB-*` identifier has been allocated.

Pseudonymization under this decision is not irreversible anonymization and must not be represented as automatically removing data from privacy-law scope.

## 2. Relationship to SDP-CUST-01

This decision preserves and does not weaken [`SDP-CUST-01`](after_four_sdp_cust_01_owner_decision.md):

- the existing Loyalty balance and ledger remain preserved;
- redemption remains frozen after Customer anonymization becomes effective;
- no new Customer-specific Loyalty benefits are issued;
- a pseudonymous reference does not restore redemption eligibility; and
- exceptional treatment still requires separately approved policy and appropriate authority.

## 3. Domain ownership

- Customer Management owns Customer Profile, original identity data, and anonymization state.
- Loyalty owns Loyalty Account, balance, ledger, and redemption eligibility.
- Promotions owns Promotion eligibility, usage, and related policy.
- Ordering owns Order and historical commercial records.
- Customer Management has no direct authority to rewrite or delete Loyalty or Promotions histories.

This decision creates no runtime service, database, module, or Bounded Context.

## 4. Explicitly unresolved

This decision does not determine:

- the pseudonymous identifier format or generation algorithm;
- whether the identifier is random, deterministic, tokenized, or otherwise derived;
- the mapping store or its technical ownership;
- encryption, key management, access control, or mapping-access audit mechanisms;
- whether mapping may ever be used for re-identification or the separately approved authority required for it;
- retention periods, legal basis, statutory deletion obligations, or financial-record treatment;
- exact domain-specific data fields or retention periods;
- event propagation, transaction boundaries, retry, idempotency, concurrency, or failure semantics;
- the final Customer, Loyalty, and Promotions Bounded Context topology; or
- legal or privacy approval.

## 5. Governance boundary

Only the Owner business-policy choice in this record is approved. This decision:

- does not approve architecture or Bounded Context topology;
- does not grant Bounded Implementation Authorization or Control Acceptance;
- does not authorize source code, schema, migration, API, database, configuration, deployment, or production changes;
- does not grant legal/privacy approval, Final Operational Acceptance, or Production Authorization; and
- does not create or decide any other `SDP-*` decision.

Existing Gate A, Gate B, Gate C, Final Operational Acceptance, and Production Authorization distinctions remain unchanged.

## 6. Canonical references

- [Owner Decision Baseline §5A](after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)
- [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions)
- [SDP-CUST-01 Owner Decision](after_four_sdp_cust_01_owner_decision.md)

**Final Operational Acceptance:** `NOT_GRANTED`

**Production Authorization:** `NOT_GRANTED`
