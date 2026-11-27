# AFTER FOUR — Commercial Foundation & Validation Program Roadmap

**Prepared:** 2026-11-27  
**Program:** Phase 1 Commercial Foundation + Phase 2 Commercial Validation & Unit Economics  
**Repository baseline:** `development` at `7efb60b028de02126e8fc01762203f385005019e`  
**Authority:** Internal repository work only; external commitments and real-world evidence remain separately authorized

## 1. Controlling model

This is the single authoritative program roadmap. It sequences existing controls; it does not replace the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [CE-02 evidence protocol](AFTER_FOUR_COMMERCIAL_CE02_EVIDENCE_INTAKE_INTEGRITY_AUTHORIZATION_PACKAGE.md), [CE-03 ballot register](AFTER_FOUR_COMMERCIAL_CE03_OWNER_AUTHORIZATION_BALLOT_REGISTER.md), or [governing 32-gap report](after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md).

Current verified baseline: 28 Products; 52 Product/Variant combinations; 48 MAKE and four BUY; 52/52 costing rows `MISSING_INPUT`; 48/48 MAKE rows unapproved; four incomplete BUY chains; zero evidence-backed unit costs or margins; 32 gaps with only post-decision synchronization closed on the current baseline.

The program uses this state sequence:

`activity authorization → activity/source evidence → CE-02 intake → separate evidence acceptance → separate exact-manifest recording authorization → canonical recording → validation → downstream decision eligibility`

No state implies the next. Recording is never standing or reusable authority. A procedure, template, plan, public reference, or synthetic test does not close an external evidence gap.

## 2. Phase 1 — Commercial Foundation

| Work package | Repository result | Exit condition |
|---|---|---|
| CE-01 baseline | Primary sources, counts, decisions, conflicts, dependencies and workstream isolation reconciled | Baseline counts reproduce and authoritative-source conflicts are resolved or disclosed |
| CE-02 governance | Evidence envelope, immutable originals, provenance, digests, classification, duplicate/conflict handling, acceptance/rejection, retention, correction, supersession and recording separation | Protocol is executable without inventing evidence or authority |
| CE-03 control | 69 unique stable ballots and matching controls; operational/acceptance/recording dependencies separated | All ballots pending/unauthorized; DAG acyclic; exact destinations verified |
| Operational intake | Empty intake register and runbook | Rejection, resubmission, restricted information, change history and recording handoff are explicit |
| Integrity validation | Read-only validator and synthetic-only formula tests | Counts, status propagation, IDs, parity and formulas reproduce |

Phase 1 documentation was accepted as documentation only through [`COMM-P1-ACCEPT-01`](AFTER_FOUR_COMMERCIAL_PHASE_1_OWNER_ACCEPTANCE_DECISION.md) on 2026-11-27. Every CE-03 ballot and real-world activity remains pending and separately unauthorized.

## 3. Phase 2 — Execution sequence

### 3.1 R04 and R05

Run R04 and R05 independently:

1. Authorize bounded contact/quotation/acquisition only if materials are not already lawfully available.
2. Retain quotation, transaction and receiving originals independently; accept them through CE-02.
3. Complete track-specific material, equipment, vessel, water/ice and measurement readiness.
4. Obtain a separate bounded trial authorization with tester, location, run count, limits, expiry and stop conditions.
5. Capture raw inputs, preparation, outputs, saleable portions, loss/waste, timing, sensory observations, deviations and repeat results in the Signature Protocol.
6. Perform separate evidence review; then make a separate exact-version Recipe/BOM business decision.
7. Only after accepted evidence and decision, seek exact-manifest canonical recording authority.

R04 values never populate R05, and R05 never silently hybridizes R04.

### 3.2 MAKE — 48 combinations

For each Product/Variant independently, establish: versioned approved Recipe/BOM; exact Ingredient/substitute; purchase and preparation units; supported conversion; gross and usable inputs; actual batch consumption/output; saleable portions; measured loss/waste and reason; shared-component allocation; channel packaging fit/quantity; actual transaction/receiving evidence; dates/provenance; and approval record. Shared preparation may reuse one accepted component version only when the allocation basis and every consuming Product/Variant are explicitly approved.

### 3.3 BUY — four Products

For CRO, CHE, BRO and MUF independently:

`specification decision → specification evidence acceptance → optional -01R recording`

`specification → bounded RFQ/contact → quotation evidence acceptance → quotation decision → optional -03R recording`

`accepted quotation decision/evidence → purchase → transaction evidence acceptance → optional -04R recording`

`completed purchase + actual delivery → receiving inspection/decision → receiving evidence acceptance → optional -05R recording`

Recording branches do not gate later physical/commercial activities unless a future ballot expressly and defensibly says so. Receiving is not canonical Product approval.

### 3.4 Packaging

For each applicable Product/Variant/channel: authorize candidate acquisition; retain originals; accept acquisition evidence; separately authorize fit test; record exact SKU, components, quantity per sale, fit result and deviations; accept fit evidence; separately accept quotation/transaction/receiving, pack conversion and loss; then seek exact-manifest recording authority. No blanket Product/channel applicability is inferred.

### 3.5 Qualified input and independent review

Prepare complete fact packs before engagement. Qualified input must state discipline, competence, questions, facts, sources, assumptions, limitations, alternatives and conflicts. It informs but does not make Owner policy. `CP3-E03` and `CP3-E04` require separate genuine independent reviewers only after their respective upstream baselines close and synchronize.

## 4. Unit-economics method

No formula runs against a canonical row until every required input is accepted and recorded.

- Ingredient purchase-unit cost = supported landed purchase cost ÷ supported purchase quantity, using one consistent tax/freight/discount basis.
- Preparation-unit cost = purchase-unit cost transformed through one documented unit conversion; density or count conversions require evidence.
- MAKE component cost = approved quantity × supported preparation-unit cost.
- Batch cost = sum of component costs + channel-correct packaging + applicable supported direct purchase costs.
- Unit cost = complete batch cost ÷ measured saleable portions. Do not also apply the same waste as a second uplift.
- BUY unit cost = supported actual landed purchase cost allocated over supported saleable portions, plus channel-correct packaging when applicable.
- Gross profit = approved selling-price basis − complete unit cost.
- Gross margin = gross profit ÷ approved selling-price basis.

Fail closed on missing/invalid units, zero/negative denominators, incomplete BOM lines, unapproved Recipe/specification, quotation substituted for transaction, missing receiving, cross-channel packaging, double-counted freight/tax/waste, or incomplete provenance. Planning estimates, if ever separately Owner-approved, remain `ESTIMATE` and never become evidence-backed cost or margin.

## 5. Completion gates

Phase 1 exits when all internal foundation artifacts exist, references resolve, CE-03 remains coherent, destinations match actual files, hashes/counts reproduce, and two adversarial review cycles leave no internally correctable defect.

Phase 2 internal work exits when every combination and gap has an executable path, exact Owner/external action, acceptance criteria and destination, and the validation harness passes. Full Phase 2 requires accepted real evidence, 52/52 defensible costs/margins where required, completed professional/review dependencies, and Milestone A acceptance. The current repository cannot truthfully satisfy that full gate.

## 6. Priority order

1. Owner reviews the Phase 1 package and selects only the first exact ballots to execute.
2. Resolve prerequisite Owner facts and commission qualified input where required.
3. Execute R04/R05 readiness and trials independently under explicit authority.
4. Progress MAKE chains combination by combination; do not wait for all 48 to begin evidence intake.
5. Approve each BUY specification before any Product-scoped RFQ/contact.
6. Acquire and fit-test packaging per Product/Variant/channel.
7. Accept evidence, authorize exact recording, and validate each canonical change.
8. Calculate only complete rows; perform independent reproduction.
9. Run E03/E04 only after their respective upstream closure.
10. Reassess Milestone A without weakening its evidence standard.
