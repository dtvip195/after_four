# AFTER FOUR — Wave 2 Owner Internal Appointment Session

**Document status:** `OWNER_APPOINTMENT_SESSION_PREPARED — NO_APPOINTMENT_RECORDED`

**Preparation date:** 2026-11-24 (Asia/Tokyo)

**Repository baseline:** `78e4128cbf699d013edf6f8eecdde1e437d99b1b`

**Authority:** Decision-preparation artifact only; no appointment, contact, disclosure, delivery, policy, Gate, implementation, FOA, or Production Authorization

## 1. Purpose and decision boundary

This session prepares nine independent Owner decisions for appointing internal coordinators to resolve the first commissioning prerequisite: a named internal request owner. The [Prerequisite Resolution](after_four_wave_2_commissioning_prerequisite_resolution.md) establishes one accountable domain for each request but identifies no human appointment. The [Authorization Package](after_four_wave_2_owner_commissioning_authorization.md) defines recipient profiles and controls; the [Recipient Discovery](after_four_wave_2_recipient_prerequisite_discovery.md) confirms that profiles are not appointments.

The seven coordinator names in this document are **recommended profiles**, not established jobs, organizational positions, or existing people. The Owner must supply the human identity and confirm organizational authority. Leaving identity blank and selecting `DEFER` is valid.

Each appointment outcome is one of:

- `APPOINT`: appoint the supplied person for the complete bounded coordination scope stated in the ballot.
- `APPOINT_WITH_SCOPE`: appoint the supplied person only for explicit request IDs, entity/domain/Branch/period, and conditions written by the Owner.
- `DEFER`: make no appointment because identity, suitability, authority, scope, or conflict evidence is incomplete.
- `REJECT_PROPOSED_APPOINTMENT`: reject the supplied person/profile for this request without appointing a replacement.

An appointment permits internal coordination only. It does not authorize recipient selection/contact, disclosure, professional engagement, procurement, request delivery, evidence acceptance, policy or readiness change, or implementation.

## 2. Source-grounded appointment principles

1. **One accountable domain per request.** A coordinator administers evidence preparation for that domain; the appointment does not transfer policy accountability.
2. **Human identity is Owner-supplied.** A role title, repository author, commit author, or document editor is not an appointment.
3. **Organizational authority is verified, not presumed.** The Owner records domain, entity, Branch/process, effective period, and evidence-access scope.
4. **Consulted domains remain consulted.** They provide facts and review within their own boundaries; they do not become co-accountable.
5. **Shared appointments are explicit and bounded.** One person may cover multiple requests only when every request ID, scope, conflict assessment, and conditions are recorded separately.
6. **Segregation is preserved.** The coordinator may assemble and route proposed materials but may not self-verify professional qualification, approve their own disclosure, approve delivery, or convert evidence into policy.

These principles preserve the repository distinction between accountable domain, documented profile, actual appointed human, external recipient, and Owner authorization ([Prerequisite Resolution §§1, 4–6](after_four_wave_2_commissioning_prerequisite_resolution.md)).

## 3. Primary nine-request appointment ballot register

Every row is independently answerable. Blank identity means no appointment can be recorded; use `DEFER` or leave the selection pending.

| Request | Accountable domain | Recommended internal request-owner profile | Consulted internal domains/profiles | Owner-supplied human identity | Authority and scope to confirm | Permitted coordination responsibilities | Explicitly not granted | Owner selection | Conditions/comments | Decision date / recording status |
|---|---|---|---|---|---|---|---|---|---|---|
| `EC-W2-01` | Cash | Cash request coordinator | Reporting; Accounting input; Cash process evidence | ____________________ | Cash process, entity/regime/year, report scope, effective period, evidence access | Coordinate scoped internal facts; maintain prerequisite checklist; prepare a minimized draft bundle; obtain consulted-domain review | Discrepancy policy; accounting judgment; correction authority; disclosure; recipient contact; delivery approval | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EC-W2-02` | Promotions | Promotions request coordinator | Catalog/Pricing; Ordering; operations/Reporting | ____________________ | Entity, channel, catalogue, commercial-form scope, effective period, evidence access | Coordinate type-semantics inputs and proposed reviewer profile; maintain source/version and scope records | Select Promotion catalogue/expression model; professional judgment; disclosure/contact/delivery | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EC-W2-03` | Promotions | Promotions request coordinator | Customer; Privacy; fraud/risk; tax/accounting; support | ____________________ | Voucher/data-category/entity/channel/location/Customer scope, effective period, evidence access | Coordinate synthetic scenarios, data-category inventory and consulted reviews; prepare minimum-disclosure proposal | Voucher policy; privacy/legal/tax judgment; access to actual Customer data; disclosure/contact/delivery | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EC-W2-04` | Inventory | Preparation process coordinator | Preparation; Recipe/Catalog; Ordering; Inventory | ____________________ | Branch, product, station, workflow, Recipe/version, period, observation and evidence-access scope | Coordinate authoritative workflow fact collection and sanitized event/failure matrix; preserve source attribution | Choose recognition/valuation policy; authorize observation; expose recipes; engage accountant; disclose/contact/deliver | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EC-W2-05` | Promotions | Promotions request coordinator | Branch/Operations time; communications/support; technical timezone review | ____________________ | Campaign, Branch, operating-time, lifecycle, effective period and source-version scope | Coordinate time scenarios, source versions and internal wording review; prepare bounded reviewer questions | Choose timezone/interval policy; approve customer wording; disclosure/contact/delivery | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EU-W2-PAY-01` | Payment | Payment request coordinator | Ordering; Accounting; Reporting | ____________________ | Provider/product/version, environment, merchant configuration, method, entity/report scope and effective period | Coordinate internal Payment facts and provider-question draft; document configuration and contractual-sharing prerequisites | Provider representation; Refund policy; Ordering allocation policy; recipient contact; contractual disclosure; delivery approval | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EU-W2-CAT-01` | Catalog/Pricing | Catalog/Pricing request coordinator | Ordering; Reporting; tax/accounting input | ____________________ | Entity, channel, catalogue, component, tax type, transaction/invoice period, report scope | Coordinate authoritative component/source inventory and synthetic totals; prepare scoped professional questions | Select formula/order sequence; give tax/accounting advice; disclose commercial data; contact/deliver | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EU-W2-WF-01` | Workforce | Workforce request coordinator | Workforce operations; Payroll; Accounting/Reporting | ____________________ | Legal entity, worker classes, locations, schedules, period, Payroll product/configuration and evidence access | Coordinate synthetic scenarios, current internal process facts and provider/counsel prerequisite records | Employment/legal/Payroll policy; employee-record disclosure; professional engagement; contact/delivery | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |
| `EU-W2-INV-01` | Inventory | Inventory request coordinator | Branch/Preparation; Inventory operations; Accounting input | ____________________ | Entity/regime/year, Branch, item class, regulator, workflow, process and evidence-access scope | Coordinate separated workflow, food-safety and accounting scope inventories; prepare minimized annex drafts | Food-safety/accounting judgment; choose recognition/valuation; disclose recipes/costs; engage/contact/deliver | `PENDING`: `APPOINT` / `APPOINT_WITH_SCOPE` / `DEFER` / `REJECT_PROPOSED_APPOINTMENT` | ____________________ | Date: ______; `NOT_RECORDED_CANONICALLY` |

All nine requests remain `PENDING`, `NOT_SENT`, and `NOT_READY_FOR_OWNER_AUTHORIZATION`. A completed row records only an internal coordination appointment and must not change those states.

## 4. Recommended coordinator profiles

These profiles are recommendations derived from the request-owner domains and required evidence profiles. They are not established organizational positions.

| Proposed profile | Request mapping | Minimum suitability criteria | Evidence Owner should verify before appointment |
|---|---|---|---|
| Cash request coordinator | Cash discrepancy commission | Knowledge of the bounded Cash process and immutable-close/no-tolerance controls; ability to coordinate Reporting and Accounting inputs; no authority inferred from generic manager status | Organizational assignment; exact process/report scope; source access; effective period; conflict disclosure; ability to preserve evidence without deciding accounting or policy |
| Promotions request coordinator | Promotion catalogue, Voucher, and scheduling commissions | Knowledge of Promotions boundaries; ability to coordinate Catalog/Ordering, Customer/privacy/fraud, or Branch/time contributors per request; disciplined separation between recommendations and policy | Organizational assignment; explicit request IDs; campaign/Voucher/catalogue scope; data-access limitations; effective period; conflicts; no unilateral disclosure or policy authority |
| Preparation process coordinator | Preparation recognition commission | Direct knowledge of the actual Preparation workflow or verified access to its process owner; ability to document versioned workflow facts and sanitize Recipe/process material | Branch/product/station/workflow assignment; observation/access authority; workflow and Recipe versions; effective period; confidentiality and conflict controls |
| Payment request coordinator | Payment/refund upstream request | Knowledge of Payment-owned settlement/Refund facts and actual provider configuration; ability to keep Ordering, Accounting and Reporting consulted rather than co-accountable | Payment organizational assignment; provider/product/environment scope; configuration/source access; contractual-sharing limits; effective period; conflicts |
| Catalog/Pricing request coordinator | Catalog/pricing/totals upstream request | Knowledge of authoritative Catalog/Pricing component sources; ability to coordinate Ordering, Reporting and scoped professional review | Catalog/Pricing assignment; entity/channel/catalogue/component scope; authoritative-source access; commercial confidentiality; effective period; conflicts |
| Workforce request coordinator | Workforce/payroll upstream request | Knowledge of Workforce operations and ability to coordinate synthetic legal/Payroll evidence without disclosing employee records | Workforce assignment; legal entity/worker/location/schedule scope; Payroll product/configuration access; data minimization; effective period; conflicts |
| Inventory request coordinator | Inventory/safety/accounting upstream request | Knowledge of Inventory and Branch/Preparation workflows; ability to maintain separate food-safety, operational and accounting scopes | Inventory assignment; entity/year/Branch/item/regulator/workflow scope; source access; recipe/cost confidentiality; effective period; conflicts |

Generic titles such as Owner, manager, staff, analyst, accountant, counsel, or provider representative are insufficient by themselves. Suitability requires attributable organizational evidence for the exact request scope.

## 5. Shared appointment options and safeguards

A shared appointment is optional; the default remains nine independently reviewable decisions.

| Possible shared appointment | Explicit request scope | Why it may be practical | Mandatory safeguards |
|---|---|---|---|
| Promotions coordinator across three requests | `EC-W2-02`, `EC-W2-03`, and `EC-W2-05` | Same accountable domain and common commissioning controls | Record all three scopes independently; separate Customer/privacy data from catalogue and scheduling material; review conflicts and competence for each; permit partial appointment or deferral per request |
| Inventory coordinator across two requests | `EC-W2-04` and `EU-W2-INV-01` | Inventory is accountable for both commissioning records | Preserve Preparation workflow authority and external professional independence; separate Recipe/process, food-safety and accounting annexes; do not let shared coordination select recognition or valuation |
| One person holding unrelated coordinator profiles | Only the exact request IDs written by the Owner | May be necessary in a small organization | Use `APPOINT_WITH_SCOPE`; document why the person is suitable for each domain; perform conflict and workload review; preserve separate accountable domains, files, decisions and approval paths |

No shared appointment may:

- merge Cash, Promotions, Inventory, Payment, Catalog/Pricing, or Workforce accountability;
- allow the coordinator to approve their own disclosure, recipient qualification, evidence sufficiency, or delivery;
- treat Accounting, Reporting, Ordering, Customer, Privacy, Preparation, Recipe/Catalog, Branch/Operations, Payroll, or a provider as automatically appointed;
- bypass professional independence, confidentiality, privilege, contractual-sharing, or segregation requirements; or
- convert internal coordination into an Owner policy decision.

If one person would prepare evidence and also act as a proposed external professional/provider, approve disclosure, approve delivery, or determine evidence sufficiency, the appointment must be deferred or narrowed until independent review and authority are established.

## 6. Consolidated Owner decision worksheet

| Session field | Owner entry |
|---|---|
| Decisions reviewed | Nine independent appointment ballots in §3 |
| Appointments selected | ____________________ |
| Appointments with bounded scope | ____________________ |
| Deferred because no suitable person is known | ____________________ |
| Rejected proposed appointments | ____________________ |
| Shared appointment selections and exact request scope | ____________________ |
| Conflict/segregation conditions | ____________________ |
| Owner comments | ____________________ |
| Decision date | ____________________ |
| Canonical recording status | `NOT_RECORDED — SEPARATE GOVERNANCE SYNCHRONIZATION REQUIRED IF OWNER DECIDES` |

This worksheet records no selection in advance. It allocates no canonical ID and does not update the Owner Decision Baseline.

## 7. After-appointment prerequisite sequence

An appointment completes only part of internal prerequisite identification. A later, separately authorized work package must still:

1. identify actual external recipients and organizations;
2. verify qualification, engagement, organizational/provider authority and conflicts;
3. establish exact entity/domain/provider/Branch/year/item/worker/transaction/workflow applicability;
4. approve minimum disclosure, redaction, confidentiality, privilege, contractual and redistribution rights;
5. select an approved communication and evidence-handling channel;
6. freeze exact request and attachment versions; and
7. obtain separate Owner authorization for delivery of each request or an explicitly bounded batch.

Completing any step does not authorize the next. Appointment is not recipient selection; recipient selection is not contact; contact authority is not disclosure; disclosure approval is not delivery; delivery is not evidence acceptance; evidence receipt is not policy approval.

## 8. Explicit non-decisions and restrictions

- No human identity is populated, inferred, appointed, rejected, or contacted by this document.
- No email, message, request, invitation, connected app, Gmail account, private contact source, credential, or external directory was used.
- No external recipient, provider, counsel, accountant, adviser, or reviewer is selected or engaged.
- No disclosure, expenditure, procurement, professional engagement, request delivery, or evidence reliance is authorized.
- No request becomes `REQUESTED`, `EVIDENCE_RECEIVED`, `UNDER_REVIEW`, or `GAP_CLOSED`.
- No existing Owner decision, ballot, accountable domain, candidate status, crosswalk, or `ODB-*` identifier is changed, allocated, reserved, or proposed.
- The canonical 55-candidate reconciliation and every commissioning status remain unchanged.
- No schema, migration, database, API, code, test, dependency, runtime, deployment, technical implementation, Gate A/B/C, Control Acceptance, FOA, or Production Authorization is granted.

**Final status:** `NINE INDEPENDENT APPOINTMENT BALLOTS PREPARED — NO APPOINTMENT RECORDED — NO DELIVERY AUTHORIZED`
