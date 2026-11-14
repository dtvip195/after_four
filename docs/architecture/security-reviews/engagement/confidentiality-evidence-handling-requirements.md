# AFTER FOUR Confidentiality and Evidence-Handling Requirements

**Template status:** Baseline for proposal and engagement negotiation  
**No platform or retention duration is selected by this document.**

## 1. Evidence classifications

| Class | Examples | Handling baseline |
|---|---|---|
| Public | Published architecture references intentionally public | Approved ordinary sharing |
| Internal | Non-sensitive design/process documents | Named engagement participants; no public redistribution |
| Confidential | Source/configuration, unpublished topology, findings | Encrypted approved evidence room; named accounts/MFA; access logging; least privilege |
| Restricted personal data | Candidate/employee/customer/recovery evidence if genuinely needed | Minimize/redact/synthesize first; explicit Owner and legal/privacy approval; recipient/location/purpose controls |
| Secret | Passwords, PINs, raw tokens, MFA/recovery secrets, private keys, production credentials | Must not be shared. Use redacted metadata, controlled demonstration, or rotated test credentials instead. |

## 2. Evidence manifest and access

Every shared item has: artifact ID, description, source owner, version/hash, environment, classification, personal-data status, permitted reviewers, purpose, access date, and disposition requirement. Reviewers acknowledge actual receipt/examination.

- Access uses named accounts and MFA through an Owner-approved encrypted system.
- Shared links and accounts are non-transferable and expire when no longer needed.
- Subcontractor access requires prior disclosure and approval.
- Downloads/local copies are minimized and declared; removable media is prohibited unless explicitly approved and encrypted.
- Production access is not assumed. Any access is separately authorized, time-bound, least-privilege, monitored, and revocable.

## 3. Minimization and sanitization

- Prefer synthetic data, redacted configs, screenshots with safe values, schema/metadata, and controlled demonstrations.
- Never include raw passwords, PINs, Session/invitation/recovery/CSRF tokens, MFA seeds/codes, private keys, cookies/authorization headers, production credentials, unrestricted database dumps, or unrelated personal data.
- Reproduction artifacts use safe IDs and remove secrets, full request bodies, and unnecessary employee/customer/payroll details.
- A reviewer reports accidental secret/personal-data receipt immediately and stops copying/use pending direction.

## 4. Storage, transmission, and processing

The proposal/engagement must state encryption in transit/at rest, account/MFA controls, locations, subprocessors, cross-border transfers, backups, access logs, vulnerability/patch practices, and deletion capability. Email or consumer file sharing is not approved by default.

Automated analysis or AI tools may receive evidence only when expressly approved with tool/provider, data use/training, retention, location, access, confidentiality, and deletion terms recorded. Secret evidence remains prohibited.

## 5. Testing safety

Before active testing, record environment, permitted targets/methods, source addresses, test accounts/data, time window proposed by reviewer, monitoring contact, rate/load limit, prohibited actions, stop conditions, backup/rollback, incident escalation, and evidence capture. No template value itself authorizes testing.

## 6. Findings and communications

Findings inherit the highest classification of included evidence. Use the controlled finding record; private chat/email does not replace it. High-impact exposure is reported through the agreed urgent channel and then documented safely.

## 7. Incident response

The engagement specifies notification contacts and required content for suspected unauthorized access, loss, disclosure, compromise, subcontractor incident, or inability to delete. Preserve investigation evidence without expanding access. No notification deadline is invented here; qualified legal/contract input must set it.

## 8. Retention, return, destruction, and holds

The engagement records purpose-specific retention/return/destruction and backup treatment after qualified legal/privacy input. No duration is set by this template. A valid hold pauses destruction only for its authorized scope. Reviewer supplies destruction/return attestation when required; metadata necessary to prove review may be retained only under approved terms.

## 9. Completion checklist

- `[ ]` Evidence manifest approved.
- `[ ]` Reviewers/subcontractors/locations approved.
- `[ ]` Access controls and MFA verified.
- `[ ]` Personal data minimized and legal/privacy conditions recorded.
- `[ ]` No secret material shared.
- `[ ]` Testing authorization and safety plan separately approved.
- `[ ]` Incident route tested or acknowledged.
- `[ ]` Return/destruction/hold terms recorded.

Owner approval: `[NOT YET PROVIDED]`  
Reviewer acceptance/exceptions: `[NOT YET PROVIDED]`
