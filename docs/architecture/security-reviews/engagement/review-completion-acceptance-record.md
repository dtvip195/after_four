---
record_type: professional_review_completion
review_id: null
status: draft
review_date: null
---

# AFTER FOUR Review Completion and Acceptance Record

**Template status:** Draft until populated with actual reviewer and evidence. A draft does not change canonical status.

## 1. Review identity

- Review ID and controlled record: `[AF-SEC/AF-PRIV ID + LINK]`
- Engagement/request ID: `[OWNER-ASSIGNED]`
- Prior canonical status: `[OPEN / BLOCKED / NOT_STARTED]`
- Scope and exclusions: `[ACTUAL REVIEWED SCOPE]`
- Reviewer identity and organization: `[ACTUAL]`
- Reviewer qualification evidence: `[LINK/REFERENCE]`
- Independence/conflict disposition: `[LINK]`
- Review start/completion dates: `[ACTUAL]`
- Environment/artifact baseline: `[VERSION/HASH/ENVIRONMENT]`

## 2. Evidence examined

| Evidence ID | Artifact/test/demonstration | Version/hash/environment | Date examined | Reviewer notes/limitations |
|---|---|---|---|---|
| `[EVID-NNN]` | `[ACTUAL EVIDENCE]` | `[IDENTIFIER]` | `[ACTUAL]` | `[NOTES]` |

Explicitly list required evidence that was missing or not tested. A design proposal is not executed evidence.

## 3. Acceptance criteria

| Criterion ID | Requirement/source | Evidence IDs | Result: pass/fail/not tested/not applicable | Reviewer rationale |
|---|---|---|---|---|
| `[AC-NNN]` | `[CHECKLIST/PACKAGE/RECORD]` | `[EVID IDS]` | `[RESULT]` | `[RATIONALE]` |

## 4. Findings and remediation

| Finding ID | Severity/classification | Summary | Remediation owner | Evidence/retest | Reviewer disposition | Residual risk |
|---|---|---|---|---|---|---|
| `[FIND-NNN]` | `[ACTUAL]` | `[SUMMARY]` | `[ASSIGNED]` | `[LINKS]` | `[OPEN/CLOSED/ACCEPTED RISK]` | `[ACTUAL]` |

Attach the full finding/retest reports. Preserve project response and reviewer disposition for disagreements.

## 5. Legal/privacy conclusions where applicable

- Qualified reviewer/opinion: `[ACTUAL OR NOT APPLICABLE WITH RATIONALE]`
- Mandatory/prohibited/permitted/recommended/uncertain conclusions: `[LINK/SUMMARY]`
- Owner choices remaining within legal bounds: `[LIST]`
- Re-review triggers: `[LIST]`

## 6. Reviewer recommendation

- Recommendation: `[ACCEPT / ACCEPT WITH EXPLICIT CONDITIONS WHERE CRITERIA PERMIT / DO NOT ACCEPT]`
- Unresolved findings/limitations: `[LIST]`
- Required production conditions: `[CONFIGURATION, MONITORING, RUNBOOK, PEOPLE, ENVIRONMENT]`
- Reviewer statement: `[ACTUAL SIGNED/EQUIVALENT RECORD]`
- Reviewer/date: `[ACTUAL]`

## 7. Project and canonical disposition

- Authorized risk-owner disposition: `[ACTUAL; DOES NOT OVERRIDE REVIEWER RESULT]`
- Owner project decision: `[ACTUAL; REVIEW DOES NOT AUTHORIZE IMPLEMENTATION]`
- Proposed canonical checklist status: `[UNCHANGED / IN_REVIEW / ACCEPTED]`
- Checklist update link and evidence: `[ONLY AFTER ACTUAL UPDATE]`
- ADR consequence: `[ADR-0006 REMAINS PROPOSED UNLESS SEPARATELY SATISFIED]`
- Follow-up owner/due condition: `[ACTUAL; NO TEMPLATE DEADLINE]`

## 8. Closure validation

- `[ ]` Real reviewer identity, qualification, independence, dates, and scope recorded.
- `[ ]` Every evidence claim links an actual immutable artifact.
- `[ ]` Every criterion has reviewer disposition.
- `[ ]` Findings are resolved/retested or explicitly accepted by authorized risk owner without falsifying criteria.
- `[ ]` Required legal/privacy input is attached.
- `[ ]` Reviewer recommendation and production conditions are recorded.
- `[ ]` Canonical status change, if any, is separately made and linked.
- `[ ]` No business permission, vendor choice, or implementation authorization is inferred.

Until every applicable item is complete, keep this record `draft` and the canonical review status unchanged.
