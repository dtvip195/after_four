# AFTER FOUR Glossary

Stable business language for the AFTER FOUR cafe chain. Implementation and security mechanics belong in the linked architecture documents.

## Language

**Branch Assignment**:  
An effective-dated relationship showing that an Employee is eligible to work at a Branch, as a primary or temporary assignment. It does not grant capabilities by itself.

**Branch Manager**:  
An active authorization role limited to explicitly assigned Branches.  
_Avoid_: Manager, Store Manager

**Employee**:  
The employment identity used for work history, Branch Assignments, shifts, attendance, compensation, and offboarding. An Employee may exist without login access.  
_Avoid_: User, account

**Authentication Lock**:  
A temporary automated restriction applied by authentication defenses and released only under an approved security policy. It does not suspend employment or deactivate the User.  
_Avoid_: suspension, deactivation

**User Deactivation**:
An Owner-controlled end to User access with no automatic return. Historical Employee, audit, and business records are preserved; later re-employment requires explicit Owner rehire/reactivation.  
_Avoid_: deletion, temporary lock

**Invitation Delegation**:  
Time-limited Owner-granted authority for an active Branch Manager to invite Staff to that manager's assigned Branches. It is distinct from Role Assignment and Branch Assignment and grants neither assignment approval nor onward delegation.  
_Avoid_: role, Role Assignment, Branch Assignment

**Organization**:  
The chain-level enterprise that owns Brands, Users, and Employees. Initial deployment has one Organization, but the domain permits more than one.

**Brand**: A customer-facing business identity belonging to an Organization. Initial deployment has one Brand, but the domain permits more than one.

**Branch**: A physical cafe location belonging to a Brand.

**Operating Day**:  
The business reporting and limit period used for daily cash, Expense, and reporting rules. Each Branch uses its explicitly configured timezone and cutoff. The initial cutoff is `00:00` local time; the first Hoi An Branch uses `Asia/Ho_Chi_Minh`. Future per-Branch cutoff configurability is an approved product direction, not implementation authorization.
_Avoid_: assuming calendar day, shift

**Product**: A Brand-global menu identity assigned to its original Category for the initial MVP, while Branch availability and pricing may vary. An Active Product belongs to an Active Category and has exactly one Active Default Variant.

**Category**: A flat Brand-owned catalog grouping created in Draft, to which every Product belongs. It follows an explicit lifecycle; Restore returns Archived Category to Inactive, while an Active Product requires an Active Category.

**Variant**: A persisted Product selection created in Draft. Archive and Restore change only lifecycle status, preserving Default designation and customer visibility; Restore returns Archived Variant to Inactive before separate reactivation.

_Avoid_: treating the Product itself as an unrecorded sellable option

**Catalog Deactivation**: A temporary, reversible suspension of a Category or Variant. Category Deactivation is blocked while Active Products remain assigned and is distinct from Category Archive and Branch-level availability.

**Catalog Archive**: Long-term retirement of a Category or Variant, with validated restoration to Inactive. Catalog Core MVP uses Archive/lifecycle retention rather than Soft Delete.

**Soft Delete**: Retention of a database record while marking it as deleted. It is a possible entity-specific mechanism, not the default for all AFTER FOUR data.

_Avoid_: Archive, Deactivate, Purge

**Immutable Retention**: Preservation of an important business, financial, historical, or audit record without ordinary modification or deletion.

_Avoid_: Soft Delete, Archive

**Physical Delete / Purge**: Permanent removal of a record from storage. It is prohibited for Category, Product, and Variant in Catalog Core MVP, regardless of lifecycle state.

_Avoid_: Soft Delete, Archive, Deactivate

**Default Variant**: A Variant designated as its Product's default; every Product has at most one, while an Active Product has exactly one and that Variant is Active. Default designation, Variant lifecycle status, and customer visibility are independent, so a hidden Active Variant may be the Default.

**Catalog Code**: A stable Category, Product, or Variant identifier unique among the same entity type within its Brand and retained after archival. Category, Product, and Variant use separate namespaces, so the same Code may occur once in each type within one Brand; input permits ASCII Latin letters, digits, hyphen, and underscore and is trimmed/canonicalized to uppercase.

**SKU**: An optional Variant identifier that is unique within its Brand when supported and remains reserved after Archive or any future Soft Delete. SKU support and normalization are deferred beyond Catalog Core MVP and do not inherit Catalog Code rules.

**Modifier Group**: A set of selectable Modifiers whose minimum and maximum selections express optional/required and single/multiple choice rules.

**Price Version**: An immutable, effective-dated Price at chain-default or explicit Branch-override scope. Corrections create another version rather than rewrite effective history.

**Sold Price**: The authoritative Price locked into an Order Item when its Order is confirmed. Later Catalog or Price changes do not rewrite it.

**Signature Product**: A Product selected by the Owner to represent the AFTER FOUR menu and brand. The designation does not itself approve its Variants, Recipe, presentation, availability, or Price.

**Customer**: The person or business party about whom AFTER FOUR may maintain purpose-limited Customer records. It is not a User, phone number, Customer Profile identifier, Loyalty Account, or Order.

**Customer Profile**: The ordinary business-managed Customer record containing allowed basic information and an Active, Inactive, or Anonymized lifecycle state. It is not permanent identity proof and does not own Order, Loyalty, or Promotion history.

**Customer Lifecycle**: The controlled Active, Inactive, and Anonymized meanings and transitions of a Customer Profile. A lifecycle state does not itself grant authority or silently change another domain's records.

**Customer Phone Association**: The current relationship between one Customer Profile and one canonical phone within an Organization. Phone remains mutable contact/lookup data rather than identity or authority.

**Canonical Vietnamese Mobile**: A valid Vietnamese domestic mobile represented in the approved canonical form for Customer admission. It is not a landline, foreign number, guessed repair, or proof of identity.

**Organization-wide Phone Admission Control**: The rule permitting at most one current Customer Profile phone association or one unreleased former-phone restriction for a canonical phone within an Organization. It does not grant Organization-wide visibility or Customer identity linkage.

**Former-phone Restriction**: The admission-control restriction keeping a former phone unavailable until documented authorized manual release. It is distinct from Restricted Identity Evidence and does not identify the former Customer.

**Restricted Identity Evidence**: Optional, purpose-dependent identifying evidence retained under controlled access, audit, and retention after anonymization. It is not an ordinary Profile, lookup source, marketing source, or identity-restoration facility.

**Controlled Anonymization**: An explicit verified and authorized operation whose effective outcome makes ordinary Customer Profile operations nonidentifying. It is not inactivity automation, universal downstream deletion, automatic phone release, or an ordinary restoration path.

**Pseudonymous Customer Reference**: A non-PII downstream reference retained for an approved business purpose such as audit, reconciliation, or historical continuity. It is not automatically irreversible or permission to re-identify a Customer.

**Loyalty Benefit**: Customer-specific Loyalty value or eligibility governed by the Loyalty ledger and policy. It is distinct from a Promotion benefit and does not become transferable because Customer identity or phone changes.

**Promotion Benefit**: A Customer-specific or public Promotion outcome governed by Promotion policy. It is distinct from Loyalty value; anonymization freezes unredeemed Customer-specific benefits without changing general public Promotion rules.

**Shared / Family Phone Usage**: Multiple people using one phone without creating shared Customer identity or permitting more than one current Customer Profile association for that canonical phone within an Organization.

_Avoid_: shared Customer, family Profile

**Anonymous / Unregistered Order**: An Order created and completed without a Customer Profile association. Transaction phone data does not by itself identify a Customer or attach historical Orders.

_Avoid_: guest Customer

**Operation-Specific Authority**: An explicit, scope-bound authorization precondition for one Customer operation; a generic role title, phone, or Customer identifier does not supply it.

_Avoid_: role-based blanket permission

**Customer Review Case**: A durable, purpose-limited record of a material Customer conflict, held disputed association, or authorized manual decision. Routine validation and duplicate rejection do not automatically create one.

_Avoid_: audit log, unrestricted identity record

**Re-identification**: Restoration or reconstruction of an anonymized Customer identity. Ordinary Customer operations prohibit it.

_Avoid_: reactivation, new Profile association

**Exceptional Identity-Evidence Access**: Separately authorized access or export of restricted identifying evidence for an approved exceptional purpose subject to legal/privacy assessment. It is not an ordinary Customer operation or automatic re-identification path.

_Avoid_: Customer lookup, Profile restore

**Order**:  
The commercial record of requested products for one service interaction. It does not represent Payment, Preparation, printing, or delivery state.

**Order Item**:  
A sold product configuration and quantity whose confirmed description and commercial terms remain historical.  
_Avoid_: current menu item

**Payment**:  
The settlement aggregate for one Order. It owns the target amount and aggregate funding/activity state; it is not one tender or provider attempt.

**Payment Attempt**:  
One cash or provider attempt for a Payment, with its own method, amount, idempotency identity, and authoritative outcome. A successful attempt contributes funding but is not interchangeable with the Payment aggregate.  
_Avoid_: Payment Transaction, transaction (legacy ambiguous labels in historical proposals)

**Preparation Dispatch**:  
The durable, retryable handoff that requests Preparation for an eligible fully paid Order exactly once. It is distinct from delivery retry state and the resulting Preparation Tickets.

**Preparation Ticket**:  
A uniquely identified instruction for Preparation work created from an eligible Preparation Dispatch.

**Cash Session**:  
An accountable operating period for one physical cash drawer, with opening/closing counts and immutable movement history. It is distinct from an Employee Shift and from the daily float.  
_Avoid_: Shift, till balance

**Cash Transaction**:  
An immutable cash inflow, outflow, top-up, adjustment, or correction recorded within Cash Management.  
_Avoid_: Payment Attempt, editable drawer balance

**Daily Float**:  
The Owner-controlled cash fund assigned to an Operating Day and carried across shift handovers. A new Cash Session or opening count does not create a new float allocation.  
_Avoid_: per-shift float, revenue

**Expense**:  
An evidenced operating cost with accountable requester/executor and approval where policy requires.  
_Avoid_: Cash Transaction, supplier payable

**Table Session**:  
The historical service visit associated with one or more physical table assignments. It is distinct from the physical Table and from an Order.

**POS PIN**:  
An individual numeric credential that may authenticate or reauthenticate one employee only on an enrolled POS device. It does not create a general-purpose Session, replace MFA, satisfy step-up or recovery, grant authorization, or permit privileged administration.  
_Avoid_: store PIN, shared PIN, convenience code

**Regional Manager**:  
A reserved, inactive future role for an explicit set of Branches. It grants no access until a future Owner decision activates its scope.  
_Avoid_: treating it as an active role

**Role Assignment**:  
An effective-dated grant of an authorization role to a User at Organization or Branch scope. It does not prove employment eligibility at a Branch by itself.

**Staff**:  
An active authorization role limited to explicitly assigned Branches and capabilities. Cashier, barista, server, and cleaning are shift duties or capabilities, not separate identity roles.

**Suspension**:  
An Owner-controlled temporary restriction on User access, distinct from Authentication Lock, Deactivation, and Employee status. Reactivation requires explicit Owner authorization and audit.

**User**:  
An individual authentication identity with lifecycle, credentials, sessions, and Role Assignments. It is distinct from the Employee employment record and must not be shared between people.  
_Avoid_: Employee, shared account

See the [Owner Decision Baseline](docs/architecture/after_four_owner_decision_baseline.md) for confirmed policy, [DDD Foundation](docs/architecture/after_four_ddd_foundation.md) for proposed context ownership, [Identity & Branch Authorization](docs/architecture/after_four_identity_authorization.md) for the proposed security design, and [Business Domain Model](docs/architecture/after_four_business_domain_model.md) for the canonical domain model.
