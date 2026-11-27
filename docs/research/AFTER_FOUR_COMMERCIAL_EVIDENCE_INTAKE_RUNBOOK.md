# AFTER FOUR — Commercial Evidence Intake Runbook

**Prepared:** 2026-11-27  
**Authority:** Internal documentation and validation only  
**Execution status:** `NO_EVIDENCE_COLLECTION_OR_CANONICAL_WRITE_AUTHORIZED`

## Purpose

This runbook operationalizes the evidence protocol in the [CE-02 package](AFTER_FOUR_COMMERCIAL_CE02_EVIDENCE_INTAKE_INTEGRITY_AUTHORIZATION_PACKAGE.md). It does not activate a CE-02 lane or authorize contact, acquisition, inspection, trial, professional engagement, independent review, evidence acceptance, or canonical recording.

The [intake register](AFTER_FOUR_COMMERCIAL_EVIDENCE_INTAKE_REGISTER.csv) is an empty template. A row may be created only for evidence lawfully obtained under the exact applicable authority. Template creation is not evidence collection.

## Intake procedure

1. Verify an active, unexpired, exact-scope activity authorization. If none exists, stop before collecting or requesting evidence.
2. Preserve the original source independently. Assign a stable `evidence_id`; record provider, authority basis, scope, dates, timezone, original location, version, and SHA-256 digest where practical.
3. Classify the item without promoting it: public reference, specification, quotation, transaction, receiving, physical observation, Owner decision, qualified input, independent review, or other explicitly defined CE-02 class.
4. Link Product, Variant, channel, Branch, run, transaction, gap, and lane only when the source itself supports that scope. Do not infer cross-Product or cross-track applicability.
5. Search identifiers, digests, source references, and content for duplicates. A duplicate remains linked to the first item and adds no independent weight.
6. Preserve conflicts. Record limitations and quarantine any item with missing identity, provenance, scope, authority, integrity, currency, or required fields.
7. If normalization is necessary, retain the original, identify the transformation, version the normalized extract, and make reproduction possible.
8. Route the item to a separately designated reviewer. The collector does not self-accept evidence where separation is required.
9. Record `ACCEPTED`, `REJECTED`, or `QUARANTINED` with reviewer, date, and rationale. Rejection never deletes the original; resubmission receives a new version/evidence ID and links to the rejected item.
10. Treat accepted source evidence as still non-canonical. A canonical write requires a separate, unexpired Owner-authorized recording ballot with an exact file/row/field manifest, source provenance, before-state, expected after-state, validation plan, and no-unrelated-change check.
11. After an authorized write, record the recording ballot and change-history reference. Never reuse recording authority for another item, Product, row, field, or later version.

## Fail-closed rules

- Missing input is never zero, false, approved, accepted, or not applicable.
- A public listing is not a supplier quotation, transaction, receipt, physical observation, or approved Recipe/BOM.
- A quotation is not a purchase; a purchase is not receiving acceptance; receiving is not Product approval.
- An activity result is not evidence acceptance; evidence acceptance is not canonical recording.
- A newer item supersedes only its exact documented claim and scope.
- Conflicting evidence blocks the affected claim until an authorized resolver records a disposition.
- Restricted commercial or personal information is retained only in an approved restricted location; the register stores the minimum necessary reference.

## Acceptance handoff checklist

- Exact authorization, scope, and validity window verified.
- Stable ID and original source retained.
- Digest, provider, dates, provenance, version, and limitations recorded.
- Duplicate and conflict checks completed.
- Required Product/Variant/channel/run/transaction linkage supported.
- Reviewer has appropriate authority and separation.
- Disposition and rationale recorded append-only.
- Canonical destination remains blank unless separately authorized.
- Rejection/resubmission and supersession links are complete where applicable.
