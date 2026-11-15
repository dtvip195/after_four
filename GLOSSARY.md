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
The business reporting and limit period used for daily cash, Expense, and reporting rules. Its exact cutoff and timezone are not yet defined.  
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
