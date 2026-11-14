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

**Deactivation**:  
An Owner-controlled end to User access with no automatic return. Historical Employee, audit, and business records are preserved; later re-employment requires explicit Owner rehire/reactivation.  
_Avoid_: deletion, temporary lock

**Invitation Delegation**:  
Time-limited Owner-granted authority for an active Branch Manager to invite Staff to that manager's assigned Branches. It is distinct from Role Assignment and Branch Assignment and grants neither assignment approval nor onward delegation.  
_Avoid_: role, Role Assignment, Branch Assignment

**Organization**:  
The chain-level enterprise that owns Brands, Branches, Users, and Employees.

**Operating Day**:  
The business reporting and limit period used for daily cash, Expense, and reporting rules. Its exact cutoff and timezone are not yet defined.  
_Avoid_: assuming calendar day, shift

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
