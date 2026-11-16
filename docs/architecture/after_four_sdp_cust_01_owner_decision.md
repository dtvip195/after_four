# AFTER FOUR — SDP-CUST-01 Owner Decision

**Local review reference:** `SDP-CUST-01`

**Decision date:** 2026-11-16

**Authority:** Owner

**Decision-record status:** `OWNER_DECIDED`

**Baseline classification:** `OWNER_CONFIRMED`

**Selected option:** `A — Preserve & Freeze`

**Canonical ODB ID:** `ID_PENDING_OWNER_GOVERNANCE`

**Implementation authorization:** `NOT_GRANTED`

## 1. Decision

When Customer anonymization becomes effective:

1. preserve the existing Loyalty balance at that point;
2. preserve the existing Loyalty ledger and necessary transaction/audit history;
3. freeze redemption of the preserved balance;
4. issue no new Customer-specific Loyalty benefits to the anonymized Customer;
5. do not automatically delete, transfer, extinguish, or reassign the existing balance;
6. do not automatically restore redemption eligibility if a person later provides another phone number or creates another Customer Profile; and
7. require a separately approved business policy and appropriate authority for any exceptional adjustment or other treatment of the preserved balance.

This is an Owner-approved business-policy decision. The local review reference remains `SDP-CUST-01`; no canonical `ODB-*` identifier has been allocated.

## 2. Domain ownership

- Customer Management owns Customer Profile and anonymization state.
- Loyalty owns Loyalty Account, balance, ledger, and redemption eligibility.
- Ordering owns Order and historical commercial records.
- Promotions owns Promotion eligibility and usage policy.
- Customer Management must not directly rewrite or delete Loyalty ledger history.

The technical mechanism by which Loyalty learns that anonymization has become effective remains undecided.

## 3. Explicitly unresolved

This decision does not determine:

- the technical anonymization or pseudonymization method;
- the cross-context non-PII Customer reference design;
- legal basis, statutory retention, deletion obligations, or financial treatment;
- who may authorize exceptional balance adjustments;
- whether or how re-identification may occur under a separately approved legal process;
- transaction, concurrency, retry, event-propagation, or integration semantics; or
- the final Customer, Loyalty, and Promotions Bounded Context topology.

## 4. Governance boundary

This decision:

- does not approve Option A as a Bounded Context topology;
- does not approve the combined `Customers, Loyalty & Promotions` context;
- does not approve Option C or another topology;
- does not authorize source code, schema, migration, API, database, deployment, or production changes;
- does not constitute legal or privacy approval;
- does not grant Final Operational Acceptance or Production Authorization; and
- does not resolve any other `SDP-*` decision.

Existing Gate A, Gate B, Gate C, Final Operational Acceptance, and Production Authorization distinctions remain unchanged.

## 5. Canonical references

- [Owner Decision Baseline §5A](after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)
- [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions)

**Final Operational Acceptance:** `NOT_GRANTED`

**Production Authorization:** `NOT_GRANTED`
