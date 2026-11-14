# AFTER FOUR — Catalog/Pricing Domain Discovery and Decision Closure

**Status:** Discovery complete; original ten MVP decisions and thirteen subsequent Catalog Core decisions `OWNER_CONFIRMED`; implementation not authorized
**Repository record created:** 2026-11-14
**Scope:** Catalog/Pricing discovery, Owner decision closure (`ODB-CAT-01`–`ODB-CAT-10`, `ODB-CAT-14`–`ODB-CAT-26`), and remaining decision boundaries

> The original Catalog/Pricing Discovery report was delivered in conversation under a read-only requirement and therefore had no repository file. This document records that discovery outcome and the subsequent Owner closure without presenting the earlier conversation-local proposal labels as canonical decision IDs.

## 1. Authority and implementation boundary

The canonical decision statements are in [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp). The original discovery decisions are `ODB-CAT-01` through `ODB-CAT-10`; the later Catalog Core closures are `ODB-CAT-14` through `ODB-CAT-26`. Menu-scale and signature decisions `ODB-CAT-11` through `ODB-CAT-13` have a separate source and approval boundary in Proposed Launch Menu v3.

All twenty-three decisions covered by this report are `OWNER_CONFIRMED` and `NOT_IMPLEMENTED` unless the baseline explicitly notes an existing seam. They do not authorize application code, schema, migration, API, frontend, dependency, configuration, Payment-lifecycle, authentication, authorization, or deployment changes.

## 2. Original discovery conclusions closed by the Owner

| Canonical ID | Discovery topic | Closure | Status |
|---|---|---|---|
| `ODB-CAT-01` | Product scope | Product identity is brand-global; Branch-specific availability and pricing are supported. | `OWNER_CONFIRMED` |
| `ODB-CAT-02` | Category hierarchy | Categories are flat for MVP. | `OWNER_CONFIRMED` |
| `ODB-CAT-03` | Product lifecycle | Product states are Draft, Active, Inactive, and Archived. | `OWNER_CONFIRMED` |
| `ODB-CAT-04` | Sellable configuration | Every sellable selection is a persisted Variant; a hidden implicit/default Variant represents a Product with no customer-facing Variant choice. | `OWNER_CONFIRMED` |
| `ODB-CAT-05` | Modifier cardinality | Modifier Groups support required/optional, single/multiple, and minimum/maximum selection limits. | `OWNER_CONFIRMED` |
| `ODB-CAT-06` | Branch sellability | A Branch may explicitly override the chain availability default. | `OWNER_CONFIRMED` |
| `ODB-CAT-07` | Price scope | Chain-level default prices support explicit Branch-level overrides. | `OWNER_CONFIRMED` |
| `ODB-CAT-08` | Price history | Price versions are immutable and effective-dated. | `OWNER_CONFIRMED` |
| `ODB-CAT-09` | Draft repricing | An authoritative price change while an Order is Draft requires review of the revised quote before confirmation. | `OWNER_CONFIRMED` |
| `ODB-CAT-10` | Historical sold terms | Sold price is locked at Order confirmation. | `OWNER_CONFIRMED` |

Earlier conversation-local `CAT-DISC-*` labels were proposal-tracking labels only. They are not canonical Owner Decision IDs and must not be used as authority.

## 3. Consequences for the logical design

- Catalog identity is Brand-owned; Branch variation is expressed through effective availability and Price policy, not duplicate Product identities.
- An Order Item always resolves to a persisted Variant. Where no customer choice exists, the effective Variant may be hidden; hidden visibility is not inherent in Default designation (`ODB-CAT-20`).
- Effective Branch availability inherits the chain default unless an effective explicit Branch override exists.
- Effective Branch price uses an explicit Branch version when present and otherwise the chain default version.
- Published Price history is append/version based. A correction does not mutate historical effective Price evidence.
- Draft pricing remains provisional. If authoritative commercial terms change, confirmation is blocked until the revised quote is presented for review and explicitly accepted through a future technical protocol.
- Confirmation freezes sold-price evidence in the Order Item snapshot; later Catalog or Price changes do not rewrite a sale.
- Initial deployment has one Organization and one Brand, but the schema must permit multiple rows of each and must not enforce a permanent singleton (`ODB-CAT-14`).
- Every Product, including Draft, belongs to exactly one Category (`ODB-CAT-15`).
- Category, Product, and Variant codes are unique within Brand. SKU is optional and unique within Brand when present. These identifiers remain reserved after archive (`ODB-CAT-16`–`ODB-CAT-18`).
- A Draft Product may temporarily have no Variants and no Default Variant (`ODB-CAT-19`). Default designation and customer visibility are independent (`ODB-CAT-20`).
- Category and Variant support archive/deactivation and restoration; physical deletion is prohibited while referenced (`ODB-CAT-21`).
- Catalog code input is trimmed, limited to ASCII Latin letters/digits/hyphen/underscore, and canonicalized uppercase. SKU has a separate unresolved normalization policy (`ODB-CAT-22`).
- Active Product has at least one Variant and exactly one Default, while Default and visibility remain independent (`ODB-CAT-23`).
- Archived Product restores to Inactive and requires separate activation (`ODB-CAT-24`).
- Category/Variant Deactivate and Archive are distinct validated/audited actions controlled by Owner or explicit delegate and protected by Active Product/Default dependency guards (`ODB-CAT-25`).
- Only dependency-free Draft records may be physically deleted; identifier reservation after such deletion remains unresolved (`ODB-CAT-26`).

These are domain constraints, not approval of a particular aggregate boundary, table shape, endpoint, UI flow, locking strategy, or implementation milestone.

## 4. Unresolved decisions preserved

The Owner has not decided through this closure:

- tax treatment or tax-inclusive/exclusive pricing;
- service charge policy;
- monetary rounding policy;
- zero-price/free-product policy;
- whether and how Modifier selections affect price, pending actual menu and pricing requirements;
- time-based menu availability;
- manual price overrides and their approval rules;
- inventory tracking;
- media storage or vendor selection.

Publication permissions, Product restoration authority, Category/Variant restoration target states and detailed transitions, delegated-authority enforcement, display rules beyond default/visibility independence, SKU normalization, identifier reservation after Draft deletion, same-Brand enforcement, quote/version-token mechanics, locking, safe-deletion proof, and migration strategy remain technical or authorization design work unless another canonical source decides them. Product restoration outcome, Category/Variant lifecycle distinction/authority, code normalization, Active Default completeness, and Draft deletion eligibility are no longer open (`ODB-CAT-22`–`ODB-CAT-26`).

The [Real Menu & Pricing Specification](after_four_real_menu_pricing_specification.md) is the Owner-input template for actual Categories, Products, Variants, Modifier Groups, Prices, availability, and the unresolved commercial policies above. Blank and `TBD` values in that draft are not Owner decisions.

## 5. Separate Payment design question

Whether Payment is created with the Draft Order or at Order confirmation remains a separate design question. These Catalog/Pricing decisions neither approve nor implement a change. The existing Phase 1 Payment creation timing and payment-before-preparation guarantees remain intact.

## 6. Synchronized references

- [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp)
- [DDD Foundation §3.2](after_four_ddd_foundation.md#32-catalogpricing)
- [Business Domain Model §7](after_four_business_domain_model.md#7-catalog-prices-recipes-and-historical-snapshots)
- [ERD §6](after_four_erd.md#6-product-and-recipe-erd)
- [Data Dictionary §5](after_four_data_dictionary.md#5-catalog-and-recipes)
- [Data Integrity Rules](after_four_data_integrity_rules.md)
- [API Contract §5](after_four_api_contract.md#5-product-and-menu-contracts)
- [State Machines §4](after_four_state_machines.md#4-order-state-machine)
- [Phase 1 implementation record](after_four_order_payment_implementation_phase1.md)
- [Real Menu & Pricing Specification](after_four_real_menu_pricing_specification.md)
