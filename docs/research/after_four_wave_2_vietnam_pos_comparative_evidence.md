# AFTER FOUR — Wave 2 Vietnam POS Comparative Evidence

**Status:** `COMPARATIVE_RESEARCH — DESIGN_INPUT_ONLY — NO_GOVERNANCE_CHANGE`

**Repository baseline:** `894071a484c5045303666aaeea52886eb41427ee`

**Research cutoff:** 2026-11-24 (Asia/Tokyo)

## 1. Purpose and non-authorization

This document compares publicly documented behavior of POS/F&B products used in Vietnam and maps the evidence to all 55 active Wave 2 candidates. It supplies design questions and alternatives only. A vendor feature is neither an industry standard nor an AFTER FOUR policy.

Nothing here changes an Owner decision, candidate status, canonical record, ODB identifier, Gate, physical database authorization, implementation authorization, FOA, or Production Authorization. The initial one-Organization/one-Brand assumption and cross-Brand default deny remain unchanged.

## 2. Method and evidence grading

Sources were opened on 2026-11-24 and checked for URL, title, vendor identity, content and relevance. First-party help pages and feature matrices are stronger than first-party marketing/educational articles. Claims are classified as:

- **Documented feature:** explicit operational behavior in official help or feature documentation.
- **Vendor claim:** first-party marketing or educational material; useful as a design signal, not verified behavior.
- **Example:** a documented scenario whose values and workflow must not be generalized.
- **Inference:** a narrow comparison drawn from documented facts and labeled as such.
- **`NO_PUBLIC_EVIDENCE_FOUND`:** reviewed public sources do not establish the requested semantic detail.

Candidate-matrix evidence relationships use these stricter meanings:

- **`DIRECT`:** the source explicitly documents at least one specific policy subdimension named by the candidate.
- **`INDIRECT`:** the source documents an adjacent operational fact that informs the candidate but does not answer a named policy subdimension.
- **`CONTEXT_ONLY`:** the source supplies comparable product or domain context without evidence for the candidate's policy question.
- **`NO_PUBLIC_EVIDENCE_FOUND`:** no reviewed public source establishes even a relevant candidate subdimension.

A relationship label applies only to the exact subdimension stated in the same matrix row. `DIRECT` never means that the source establishes the entire candidate policy, and no relationship label changes the candidate's governance status.

No claim is made about backend transactions, data model, accounting compliance, locking, concurrency, APIs, immutable storage, or production configuration unless the source explicitly says so. Page update dates are recorded only when displayed by the source.

## 3. Vendor/product inventory

| Vendor/product | Coverage obtained | Evidence limits |
|---|---|---|
| Sapo FnB / Sapo Thu Ngân | Cash sessions, handover state, roles/permissions, promotion application, ingredients and commercial totals | Help pages describe UI behavior, not database/accounting semantics. |
| KiotViet F&B and KiotViet retail help | Promotion types/permissions/refund recalculation, F&B inventory overview, attendance context | Some detailed promotion/refund evidence is retail-scoped; it is context only for F&B decisions. |
| MISA CUKCUK | Promotion catalogue, voucher treatment, scheduling fields, branch applicability, post-close cancellation, inventory/cash indexes | Public help documents product behavior but not full authorization, refund-allocation, or accounting semantics. |
| iPOS FABi | Feature matrix for shift close, tender, e-voucher, permissions, reasons, promotions, channel pricing and reporting | Matrix is broad and lacks workflow/edge-case detail. iPOS Manager and chain pages are marketing-level only. |
| POS365 | Vendor-authored guidance on permissions, BOM/real-time deduction, stocktake variance and audit history | These are educational/marketing articles, not product help contracts; claims receive lower confidence. Two supplied URLs were inaccessible to the research tool. |

## 4. Source register

**Access date for every source below:** 2026-11-24 (Asia/Tokyo).

| ID | Vendor | Exact title and URL | Source type / explicit publication or update date | Supported claim and limitation |
|---|---|---|---|---|
| `SAPO-01` | Sapo | [Mở ca và kết ca thu tiền trên ứng dụng Sapo FnB](https://help.sapo.vn/mo-ca-va-ket-ca-thu-tien-tren-ung-dung-sapo-fnb) | Official help; no explicit update date found | Documents opening cash, expected/actual/difference, withdrawals, states `Mới`/`Chưa bàn giao`/`Đã bàn giao`, optional or later handover, and history. A Cash Session belongs to the device that opened it; each cash-register device opens and reconciles separately; a cancellation performed on another device may not be reflected in the current device's session. Does not establish Operating Day or correction authority. High confidence. |
| `SAPO-02` | Sapo | [Quản lý ca bán hàng trên Sapo Thu Ngân](https://help.sapo.vn/quan-ly-ca-ban-hang-tren-sapo-thu-ngan) | Official help; undated | Documents opening float, closing/handover and a working-shift permission prerequisite. Does not prove operation-specific separation. High confidence. |
| `SAPO-03` | Sapo | [Thêm mới vai trò nhân viên trên trang quản trị Sapo FnB](https://help.sapo.vn/them-moi-vai-tro-nhan-vien-tren-trang-quan-tri-sapo-fnb) | Official help; undated | Documents configurable roles and detailed permissions, including reports, orders and activity log access. Does not prove AFTER FOUR capability semantics. High confidence. |
| `SAPO-04` | Sapo | [Tạo nguyên liệu trên trang quản trị Sapo FnB](https://help.sapo.vn/tao-nguyen-lieu-tren-trang-quan-tri-sapo-fnb) | Official help; undated | Documents ingredients, units, norms and inventory/cost use. Does not identify the stock-consumption recognition event. High confidence. |
| `SAPO-05` | Sapo | [Áp dụng khuyến mại, thuế và phí dịch vụ trên ứng dụng Sapo FnB](https://help.sapo.vn/ap-dung-khuyen-mai-thue-va-phi-dich-vu-tren-ung-dung-sapo-fnb) | Official help; undated | Separates configured promotion, manual discount, tax and service charge; documents discount permission and customer-group conditions. Does not establish calculation order or legal correctness. High confidence. |
| `IPOS-01` | iPOS FABi | [Tính năng phần mềm FABi](https://huongdan.ipos.vn/docs/bang-tinh-nang-phan-mem-ipos-vn/tinh-nang-phan-mem-fabi/) | Official feature matrix; undated | Lists per-user shift login/close, cash-count close, e-voucher tender, multiple tenders, permissions/reasons for void/edit/discount, promotion conditions, time/channel pricing and reports. Matrix lacks edge semantics. Medium-high confidence. |
| `IPOS-02` | iPOS | [iPOS Manager - Phần mềm Quản lý từ xa](https://ipos.vn/ipos-manager/) | Official marketing; undated | Confirms vendor product family/remote management positioning only. No detailed semantic claim is based on it. Low confidence. |
| `POS-01` | POS365 | [Phân quyền nhân viên nhà hàng: Ai được xóa món, giảm giá?](https://www.pos365.vn/cach-phan-quyen-nhan-vien-nha-hang-8689.html) | Vendor educational article; date not relied upon | Recommends bounded cashier/server/manager actions, manager password override and configured discounts. Recommendation, not verified product contract. Medium-low confidence. |
| `POS-02` | POS365 | [Hướng dẫn cách xây dựng định lượng món ăn (BOM) nhà hàng chuẩn xác](https://www.pos365.vn/quan-ly-kho-nha-hang-8698.html) | Vendor educational/marketing; date not verified (conflicting first-party renderings during recheck) | Claims multi-layer BOM, unit conversion, stock deduction when payment is initiated, and stocktake comparison. Does not prove correctness or suitability for AFTER FOUR. Medium-low confidence. |
| `POS-03` | POS365 | [Theo dõi lịch sử thao tác (audit log): Phát hiện ai sửa giá, hủy hóa đơn & xóa hàng](https://www.pos365.vn/theo-doi-lich-su-thao-tac-audit-log-9279.html) | Vendor educational/marketing; date not verified (conflicting first-party renderings during recheck) | Claims timestamp, account, device/shift, action and before/after values, plus non-editable log UI. It does not prove immutable database storage. Medium-low confidence. |
| `KIOT-01` | KiotViet | [Khuyến mại](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/retail-khuyen-mai/khuyen-mai/) | Official help; retail scope; undated | Documents invoice/item discounts, free goods, points, voucher, time/branch/customer conditions, automatic application, return recalculation and create/edit/delete permissions. Retail behavior is context only for F&B. Medium confidence. |
| `KIOT-02` | KiotViet | [Tổng quan các nhóm giải pháp KiotViet](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/fnb-he-thong-giai-phap-kiotviet/tong-quan-cac-nhom-giai-phap-kiotviet/) | Official F&B help; undated | Documents ingredient norms, automatic stock deduction when selling, stocktake, disposal, branch transfer and menu/combos. Does not specify exact order/preparation/payment event. Medium-high confidence. |
| `KIOT-03` | KiotViet | [Trả hàng](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/retail-tra-hang/tra-hang/) | Official help; retail scope; undated | Documents return/refund records and inventory consequences in retail contexts. It does not establish F&B waste/quarantine or tender allocation. Medium confidence. |
| `CUK-01` | MISA CUKCUK | [Quản lý chương trình khuyến mại](https://helpv2.cukcuk.vn/vi/kb/1030100_xay_dung_chuong_trinh_khuyen_mai-3) | Official help; updated 2026-09-08 | Documents gift item, item/invoice discount, buy-m-get-n, fixed price, timed-service discount and one/some/all restaurant applicability. Does not establish approval lifecycle. High confidence. |
| `CUK-02` | MISA CUKCUK | [Chương trình khuyến mại Giảm giá hóa đơn](https://helpv2.cukcuk.vn/vi/kb/1030100_giam_gia_theo_hoa_don) | Official help; updated 2026-09-04 | Documents percentage/amount discount, limits, exclusions, auto-apply and customer constraints. Does not establish generalized stacking priority. High confidence. |
| `CUK-03` | MISA CUKCUK | [Chương trình khuyến mại Tặng món](https://helpv2.cukcuk.vn/vi/kb/1030100_tang_mon) | Official help; updated 2026-09-14 | Documents free-item conditions and invoice/customer usage limits; one promotion per item in the example flow. High confidence for described flow only. |
| `CUK-04` | MISA CUKCUK | [Chương trình khuyến mại Giảm giá món](https://helpv2.cukcuk.vn/vi/kb/1030100_giam_gia_mon) | Official help; undated in captured excerpt | Documents percent/amount item discounts and scheduling by date, weekday and time. It does not state timezone, midnight crossing or interval inclusivity. High confidence. |
| `CUK-05` | MISA CUKCUK | [Quản lý khuyến mại theo thẻ voucher](https://helpv2.cukcuk.vn/vi/kb/1030200_the_voucher) | Official help; updated 2026-09-22 | Explicitly treats voucher as payment, not promotion value; records used codes but says per-code state management is unsupported. Does not establish binding, transfer, partial use or recovery. High confidence. |
| `CUK-06` | MISA CUKCUK | [Hướng dẫn thao tác hủy hóa đơn bán hàng khi thu ngân đã đóng ca trên máy tính](https://helpv2.cukcuk.vn/vi/kb/huy_hoa_don_sai_sau_khi_dong_ca) | Official help; updated 2026-09-26 | Documents manager post-close whole-invoice cancellation with reason; no single-item cancellation and no date/time edit. Does not establish refund tender or immutable linked correction. High confidence. |
| `CUK-07` | MISA CUKCUK | [Quản lý tồn kho](https://helpv2.cukcuk.vn/vi/ac/quan_ly_ton_kho_table_service) | Official help index; undated | Confirms initial stock, warehouses, receipt/issue/transfer/stocktake and costing topics; index alone does not establish detailed behavior. Medium confidence. |
| `CUK-08` | MISA CUKCUK | [Quản lý quỹ tiền mặt](https://helpv2.cukcuk.vn/vi/ac/1040000_quan_ly_quy_tien_mat) | Official help index; undated | Confirms cash receipts/payments, cash count and balance tracking; does not establish Cash Session semantics. Medium confidence. |

The supplied POS365 partial-refund and wrong-promotion-price URLs returned fetch/cache errors. The supplied Sapo pages were reachable. CUKCUK's old index redirects to the current `helpv2.cukcuk.vn` site. No detailed official KiotViet F&B page establishing Cash Session handover or the exact theoretical-consumption trigger was found.

## 5. Domain comparative matrix

| Domain question | Sapo | KiotViet | CUKCUK | iPOS FABi | POS365 | Comparative conclusion |
|---|---|---|---|---|---|---|
| Cash open/close | Opening float, expected/actual/difference, withdrawals, device-scoped sessions and handover states (`SAPO-01`) | `NO_PUBLIC_EVIDENCE_FOUND` in reviewed F&B help | Cash fund/count topics only (`CUK-08`) | Shift close, denomination count and per-user revenue (`IPOS-01`) | Audit article mentions shift attribution (`POS-03`) | Session concepts vary; none establishes AFTER FOUR Operating Day or zero-tolerance resolution. |
| Closed but unhanded-over | Explicit `Chưa bàn giao` state and optional handover at close (`SAPO-01`) | `NO_PUBLIC_EVIDENCE_FOUND` | `NO_PUBLIC_EVIDENCE_FOUND` | `NO_PUBLIC_EVIDENCE_FOUND` | `NO_PUBLIC_EVIDENCE_FOUND` | Supports considering close and handover as distinct, not adopting Sapo's transition. |
| Device-scoped Cash Session | Session belongs to its opening device; each register opens/reconciles separately; another device's cancellation may be absent; later handover remains possible (`SAPO-01`) | `NO_PUBLIC_EVIDENCE_FOUND` | `NO_PUBLIC_EVIDENCE_FOUND` | `NO_PUBLIC_EVIDENCE_FOUND` | `NO_PUBLIC_EVIDENCE_FOUND` | Vendor-specific operational evidence only; it establishes no AFTER FOUR device, reconciliation, cancellation, handover or architecture policy. |
| Promotion forms | Configured promotion and manual discount (`SAPO-05`) | Invoice/item discount, gifts, points, voucher (`KIOT-01`, retail) | Gift, invoice/item discount, buy-m-get-n, fixed price (`CUK-01`–`04`) | Item/group/invoice programs with conditions (`IPOS-01`) | Configured promotion examples only (`POS-01`) | Public evidence supports a finite explicit type surface; it does not select AFTER FOUR's catalogue. |
| Stacking/exclusion | Some conditions visible; exact priority absent | Return recalculation documented; exact stacking priority incomplete | Exclude items/already-promoted items; one-promotion-per-item example (`CUK-02`, `CUK-03`) | Multiple conditions advertised, priority absent | Recommendation only | `NO_PUBLIC_EVIDENCE_FOUND` for a portable deterministic priority algorithm. |
| Voucher semantics | `NO_PUBLIC_EVIDENCE_FOUND` in reviewed pages | Voucher listed as a promotion form in retail help (`KIOT-01`) | Voucher explicitly treated as payment, with limited per-code tracking (`CUK-05`) | E-voucher tender listed (`IPOS-01`) | Audit article mentions voucher application only | Vendors classify voucher differently; Promotion, entitlement, stored value and tender must remain separate choices. |
| Ingredient/BOM | Ingredient units/norms (`SAPO-04`) | Norms and deduction “when selling” (`KIOT-02`) | Inventory operations index (`CUK-07`) | Separate inventory product advertised; detailed trigger absent | Claims payment-command deduction and multi-level BOM (`POS-02`) | Evidence supports BOM/unit concepts but conflicts or lacks precision on recognition point. |
| Waste/stocktake | `NO_PUBLIC_EVIDENCE_FOUND` in reviewed pages | Disposal, stocktake and transfer listed (`KIOT-02`) | Issue/transfer/stocktake topics (`CUK-07`) | `NO_PUBLIC_EVIDENCE_FOUND` | Vendor article describes stocktake variance (`POS-02`) | Does not establish waste/remake classification, approval, accounting or food-safety handling. |
| Promotion schedule | Effective-time checks are mentioned (`SAPO-05`) | Time/branch/customer conditions (`KIOT-01`) | Date, weekday and time fields (`CUK-04`) | Time-based pricing (`IPOS-01`) | `NO_PUBLIC_EVIDENCE_FOUND` | No reviewed source defines timezone, DST, cross-midnight or inclusive/exclusive boundaries. |
| Refund/cancel | Cash session shows refund/cancel totals (`SAPO-01`) | Retail return recalculates discounted value (`KIOT-01`, `KIOT-03`) | Manager whole-invoice post-close cancel with reason (`CUK-06`) | Void/edit reasons and permissions (`IPOS-01`) | Partial-refund URL inaccessible | No universal tender, allocation, inventory or downstream reversal policy can be inferred. |
| Authorization/audit | Configurable roles and permissions (`SAPO-03`) | Create/edit/delete promotion permissions (`KIOT-01`) | Manager action plus reason for post-close cancel (`CUK-06`) | Specific void/price/discount permissions and reasons (`IPOS-01`) | Manager-password and audit claims (`POS-01`, `POS-03`) | Operation-level permissions and actor/reason evidence are recurring design options, not proof of an approved AFTER FOUR model. |
| Commercial totals | Separate discount, tax, service charge and payable (`SAPO-05`) | Price/promotion and return recalculation (`KIOT-01`) | Discount forms and zero-price gift (`CUK-02`, `CUK-03`) | Tax, service fee, discount and channel pricing (`IPOS-01`) | BOM/costing claims only | Components are evidenced, but calculation order, rounding, tax applicability and sold-price truth remain unresolved. |

## 6. Five priority candidate assessments

### 6.1 `P2B-CASH-OD-03` — discrepancy

`SAPO-01` directly documents expected, actual and difference values, including closed-but-unhanded-over sessions. It also documents a vendor-specific device boundary: a session belongs to its opening device, each cash register opens and reconciles separately, and cancellation on another device may not appear in the current device's session. `IPOS-01` documents cash denomination count; `CUK-08` exposes cash count as a product area. These sources support explicit discrepancy evidence and distinct handover states as design options. They do **not** establish no-tolerance policy, notification, correction authority, linked correction, accounting treatment, Reporting release, or an appropriate AFTER FOUR device architecture. AFTER FOUR's existing no-tolerance and immutable linked-correction decisions remain controlling. Status remains `CLARIFICATION_REQUIRED` / `REQUEST_SOURCE_OPTIONS`.

### 6.2 `P2A-PROMO-OD-01` — initial promotion types

CUKCUK explicitly documents gift item, item/invoice percentage or amount discounts, buy-m-get-n and fixed price (`CUK-01`–`04`). KiotViet retail help documents overlapping but not identical forms (`KIOT-01`); iPOS documents scope/conditions rather than a strict taxonomy (`IPOS-01`). Evidence supports presenting a finite type-selection surface, but not declaring any set correct or approved. General expressions remain a separate higher-complexity option with `NO_PUBLIC_EVIDENCE_FOUND` in the reviewed product help. Status remains `CLARIFICATION_REQUIRED`.

### 6.3 `P2A-PROMO-OD-06` — voucher

CUKCUK treats voucher as payment and lacks per-code status tracking (`CUK-05`); iPOS lists E-Voucher under payment (`IPOS-01`); KiotViet retail lists voucher among promotion forms (`KIOT-01`). This divergence is direct evidence that “voucher” is not one stable semantic category. No reviewed source establishes Customer binding, bearer transfer, reservation/release, partial redemption, recovery or fraud governance. Status remains `CLARIFICATION_REQUIRED`; privacy, fraud, tax/accounting and provider evidence is still required.

### 6.4 `P2B-INV-OD-04A` — normal consumption recognition

Sapo documents ingredient norms without a trigger (`SAPO-04`). KiotViet says automatic deduction “when selling” but does not resolve the precise event (`KIOT-02`). POS365's lower-grade article claims deduction when payment is initiated (`POS-02`). These are incompatible levels of precision and none proves physical consumption truth. Start, preparation completion, handoff, payment and another authoritative Preparation fact remain Owner/design alternatives. Status remains unresolved `CONDITIONALLY_REVIEWABLE` with `RECOMMENDATION_NOT_ESTABLISHED`.

### 6.5 `P2A-PROMO-OD-08` — timezone and interval boundaries

CUKCUK exposes date, weekday and time fields (`CUK-04`); Sapo checks whether a program remains in its configured effective time (`SAPO-05`); iPOS lists time-window pricing (`IPOS-01`). No reviewed source defines authoritative timezone, cross-midnight behavior, daylight-saving/offset changes, boundary inclusivity or schedule mutation after publication. UI date/time fields are not evidence of those semantics. Status remains unresolved `CONDITIONALLY_REVIEWABLE` with `RECOMMENDATION_NOT_ESTABLISHED`.

## 7. Cross-domain dependency evidence

- **Refund / Payment / Cash:** vendor sources show refund/cancel totals, retail discounted-return recalculation and post-close cancellation, but not a common original-tender or allocation rule (`SAPO-01`, `KIOT-01`, `CUK-06`). `P2B-CASH-OD-05` stays blocked by Payment facts.
- **Refund / Loyalty / Promotions:** KiotViet retail recalculates returned value after promotion (`KIOT-01`), but no reviewed source defines Loyalty reversal, benefit reservation/release or a portable discount-allocation formula. `P2A-LOY-OD-05` and `P2A-PROMO-OD-05` remain blocked.
- **Catalog / Pricing / Tax / Ordering:** Sapo and iPOS expose price, discount, tax, service-charge and channel components (`SAPO-05`, `IPOS-01`). They do not establish AFTER FOUR's source ownership, sequence, rounding or refund allocation. `W2-ORD-OD-01` remains blocked.
- **Preparation / Inventory:** BOM/ingredient support is common, while the recognition trigger is absent or vendor-specific (`SAPO-04`, `KIOT-02`, `POS-02`). Operational Preparation evidence remains necessary.
- **Workforce / Payroll:** reviewed product sources show accounts, shifts and permissions, not Vietnamese employment entitlement, payroll calculations, break/grace/rounding/leave/overtime legality. All seven Workforce dependency candidates still require qualified employment-law and Payroll evidence.

## 8. Authorization and audit comparison

Sapo and iPOS document configurable or action-level permissions (`SAPO-03`, `IPOS-01`); KiotViet documents separate promotion view/create/edit/delete permissions (`KIOT-01`); CUKCUK assigns a post-close cancellation to manager flow and requires a reason (`CUK-06`). POS365 recommends manager password override and claims detailed actor/time/before-after audit (`POS-01`, `POS-03`), but those are lower-grade vendor articles.

This supports considering operation-specific capability, reason, actor attribution, before/after evidence and manager override as separate design dimensions. It does not prove immutable storage, separation of duties, self-approval prohibition, trusted identity, delegation, or authorization scope. Generic role names must not be imported into AFTER FOUR.

## 9. Evidence gaps

Public POS documentation did not establish:

- Cash discrepancy correction authority, accounting journal, no-tolerance policy or Reporting hold/release;
- voucher identity binding, transfer, partial use, reserve/release/reverse, compromise recovery or privacy basis;
- authoritative physical-consumption recognition or waste/remake/failed-Preparation semantics;
- promotion timezone, UTC/DST, midnight crossing, interval boundaries or post-publication schedule correction;
- a universal Refund tender/allocation, Loyalty reversal, inventory disposition or Cash reconciliation rule;
- lawful Workforce/Payroll policies, Inventory valuation, food-safety applicability or Vietnamese tax/accounting correctness;
- backend transactions, isolation, concurrency, immutable persistence, schema, API or recovery semantics.

## 10. Design implications for AFTER FOUR

Evidence supports future Owner consideration of explicit finite promotion forms, distinct manual discount, operation-specific permissions, actor/reason evidence, Cash close/handover separation, explicit BOM/units, and explicit commercial-total components. Trade-offs remain vendor- and workflow-dependent: more granular lifecycle and authority improve accountability but increase operational steps; automatic application/deduction improves speed but can encode the wrong business event; bearer-like voucher use reduces friction but increases fraud/privacy ambiguity.

The Owner must still decide the five evidence-gate policies and every unresolved policy dimension. Qualified Vietnamese accounting, tax, employment, privacy and food-safety evidence remains required where already identified. Payment-provider evidence is required for provider-specific refund behavior. Comparative product documentation cannot close those prerequisites.

## 11. All-55 candidate coverage matrix

Status abbreviations preserve the canonical baseline: `RECORDED` (16 prior recorded decisions), `DIRECTION_CONFIRMED_CONDITIONAL` (22), `UNRESOLVED_CONDITIONAL` (2), `CLARIFICATION_REQUIRED` (3), and `DEPENDENCY_BLOCKED` (12). “External?” identifies whether qualified/provider evidence remains necessary; it does not change status.

| Candidate | Domain | Current canonical status | Evidence / relationship | Establishes / does not establish | External? |
|---|---|---|---|---|---|
| `P2B-CASH-OD-01` | Cash | `RECORDED` | `SAPO-01` `CONTEXT_ONLY` | Device-scoped session time exists; not Operating Day timezone/cutoff. | Reporting/operations |
| `P2B-CASH-OD-02` | Cash | `RECORDED` | `SAPO-02`,`SAPO-03`,`IPOS-01` `INDIRECT` | Generic shift/role and sensitive-action permissions exist; no source separates Open, Count, Handover and Close authority. | Identity/operations |
| `P2B-CASH-OD-03` | Cash | `CLARIFICATION_REQUIRED` | `SAPO-01`,`IPOS-01` `DIRECT` | Count/difference and device-local cancellation evidence only; not resolution/correction authority. | Accounting/Reporting |
| `P2B-CASH-OD-04` | Cash | `RECORDED` | `CUK-06`,`POS-03` `INDIRECT` | Post-close action/audit examples; not linked-fact mechanism. | Accounting/audit |
| `P2B-CASH-OD-05` | Cash | `DEPENDENCY_BLOCKED` | `SAPO-01`,`KIOT-03` `INDIRECT` | Device-local cancellation and retail return visibility; not tender/drawer rule. | Payment/provider/accounting |
| `P2B-CASH-OD-06` | Cash | `RECORDED` | `SAPO-01` `DIRECT` | Optional/later handover is a vendor-specific transition example; not approved evidence or AFTER FOUR transition. | Operations |
| `P2B-CASH-OD-07` | Cash | `DIRECTION_CONFIRMED_CONDITIONAL` | `SAPO-01`,`CUK-08` `INDIRECT` | Withdrawal/cash-fund context; not source/authority policy. | Accounting |
| `P2B-CASH-OD-08` | Cash | `DIRECTION_CONFIRMED_CONDITIONAL` | `SAPO-01`,`IPOS-01` `INDIRECT` | Device-local session reconciliation and shift-close context; not cadence, Operating Day completion or Reporting release. | Accounting/Reporting |
| `P2B-WF-OD-01` | Workforce | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | POS accounts do not establish Employee lifecycle/rehire. | Employment/Identity |
| `P2B-WF-OD-02` | Workforce | `RECORDED` | `SAPO-03` `CONTEXT_ONLY` | Roles exist; not effective-dated Branch Assignment. | Organization/Identity |
| `P2B-WF-OD-03` | Workforce | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | No shift draft/publish/change authority contract found. | Operations/employment |
| `P2B-WF-OD-04` | Workforce | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | No supported shift-swap acceptance/decision semantics. | Employment/operations |
| `P2B-WF-OD-05` | Workforce | `DIRECTION_CONFIRMED_CONDITIONAL` | `POS-03` `CONTEXT_ONLY` | Device/shift attribution claim; not trusted clock/correction policy. | Employment/device |
| `P2B-WF-OD-06A` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No legal break entitlement or Payroll outcome. | Employment/Payroll |
| `P2B-WF-OD-06B` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No lawful grace policy. | Employment/Payroll |
| `P2B-WF-OD-06C` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No lawful time-rounding policy. | Employment/Payroll |
| `P2B-WF-OD-06D` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No lateness consequences. | Employment/Payroll/Reporting |
| `P2B-WF-OD-06E` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No absence/leave outcome. | Employment/Payroll |
| `P2B-WF-OD-07A` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No leave entitlement/balance/workflow. | Employment/Payroll |
| `P2B-WF-OD-07B` | Workforce | `DEPENDENCY_BLOCKED` | `NO_PUBLIC_EVIDENCE_FOUND` | No overtime eligibility/rate/correction. | Employment/Payroll/accounting |
| `P2B-WF-OD-08A` | Workforce | `DIRECTION_CONFIRMED_CONDITIONAL` | `SAPO-03` `CONTEXT_ONLY` | Generic permissions/report access context; no Workforce fact-sharing or legitimate-purpose evidence. | Privacy/retention |
| `P2B-INV-OD-01` | Inventory | `RECORDED` | `CUK-07`,`KIOT-02` `DIRECT` | Warehouses/branch transfers exist; not AFTER FOUR topology. | Organization/operations |
| `P2B-INV-OD-02` | Inventory | `RECORDED` | `POS-02` `CONTEXT_ONLY` | Article discusses negative error risk; not exception policy. | Operations/accounting |
| `P2B-INV-OD-03` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | `NO_PUBLIC_EVIDENCE_FOUND` | No verified class-specific lot/expiry/quarantine/FEFO policy. | Food safety |
| `P2B-INV-OD-04A` | Inventory | `UNRESOLVED_CONDITIONAL` | `SAPO-04`,`KIOT-02`,`POS-02` `DIRECT` | BOM/deduction signals; no authoritative recognition event. | Preparation/accounting |
| `P2B-INV-OD-04B` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | `KIOT-02`,`POS-02` `INDIRECT` | Disposal/variance context; not deviation taxonomy/authority. | Operations/accounting/food safety |
| `P2B-INV-OD-05` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-07`,`KIOT-02` `INDIRECT` | Transfer exists; not dispatch/receipt/discrepancy policy. | Operations/accounting |
| `P2B-INV-OD-06` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-07`,`POS-02`,`POS-03` `INDIRECT` | Stocktake, variance and audit context; no adjustment authority, reason requirement, threshold or approval evidence. | Loss control/accounting |
| `P2B-INV-OD-07` | Inventory | `DEPENDENCY_BLOCKED` | `CUK-07`,`POS-02` `CONTEXT_ONLY` | Cost topics/claims; not applicable valuation selection. | Qualified accounting |
| `P2B-INV-OD-08` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | `SAPO-04`,`POS-02` `DIRECT` | Direct only for unit and conversion examples; not canonical set, conversion ownership, version effects or rounding. | Catalog/Recipe/accounting |
| `P2A-LOY-OD-01` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | `KIOT-01` `CONTEXT_ONLY` | Points promotion exists; not authoritative settled earning value. | Payment/accounting |
| `P2A-LOY-OD-02` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | `NO_PUBLIC_EVIDENCE_FOUND` | No deterministic redemption order/rate/rounding evidence. | Ordering/accounting |
| `P2A-LOY-OD-03` | Loyalty | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | No evidence changes disabled-expiry policy. | Legal/notice if revisited |
| `P2A-LOY-OD-04` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | `SAPO-03`,`IPOS-01` `INDIRECT` | Fine-grained permission option; not requester/approver thresholds. | Identity/audit |
| `P2A-LOY-OD-05` | Loyalty | `DEPENDENCY_BLOCKED` | `KIOT-01` `INDIRECT` | Discounted retail return recalculation; not points reversal allocation. | Payment/Ordering/accounting |
| `P2A-LOY-OD-06` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-01` `CONTEXT_ONLY` | Restaurant applicability exists for Promotions only; it supplies no Loyalty benefit-scope evidence. | Customer/privacy |
| `P2A-LOY-OD-07` | Loyalty | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | No evidence changes preserve/freeze/no-exception policy. | Privacy/legal if exception proposed |
| `P2A-PROMO-OD-01` | Promotions | `CLARIFICATION_REQUIRED` | `CUK-01`–`CUK-04`,`KIOT-01` `DIRECT` | Multiple finite forms; not approved AFTER FOUR set. | Trade/tax/accounting/operations |
| `P2A-PROMO-OD-02` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-01`,`KIOT-01`,`IPOS-01` `DIRECT` | Branch/channel/item scope options; not cross-Brand authority. | Catalog/operations |
| `P2A-PROMO-OD-03` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-02`,`CUK-03` `DIRECT` | Direct only for documented exclusions and a one-promotion-per-item example; not stacking groups, tie-breaking or deterministic global priority. | Ordering/Loyalty |
| `P2A-PROMO-OD-04` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-05` `CONTEXT_ONLY` | Used-code/tender context; not reserve/redeem/release/reverse. | Order/Payment/provider |
| `P2A-PROMO-OD-05` | Promotions | `DEPENDENCY_BLOCKED` | `KIOT-01`,`CUK-06` `INDIRECT` | Return/cancel examples; not discount allocation/reversal. | Payment/Catalog/accounting |
| `P2A-PROMO-OD-06` | Promotions | `CLARIFICATION_REQUIRED` | `CUK-05`,`IPOS-01`,`KIOT-01` `DIRECT` | Conflicting voucher categories; not complete lifecycle/binding. | Privacy/fraud/tax/provider |
| `P2A-PROMO-OD-07A` | Promotions | `RECORDED` | `KIOT-01`,`SAPO-03` `DIRECT` | Create permission exists; not AFTER FOUR assignment/scope. | Identity/operations |
| `P2A-PROMO-OD-07B` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `KIOT-01`,`SAPO-03` `DIRECT` | Edit permission exists; not allowed states/fields. | Identity/lifecycle |
| `P2A-PROMO-OD-07C` | Promotions | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | No submission-before-approval evidence found. | Operations/Identity |
| `P2A-PROMO-OD-07D` | Promotions | `RECORDED` | `POS-01`,`SAPO-03` `INDIRECT` | Manager/permission patterns; not approval capability assignment. | Identity/governance |
| `P2A-PROMO-OD-07E` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `NO_PUBLIC_EVIDENCE_FOUND` | No separate publish authority contract found. | Identity/lifecycle |
| `P2A-PROMO-OD-07F` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `NO_PUBLIC_EVIDENCE_FOUND` | No pause capability/reason/effect evidence. | Identity/lifecycle |
| `P2A-PROMO-OD-07G` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `NO_PUBLIC_EVIDENCE_FOUND` | No resume/revalidation evidence. | Identity/lifecycle |
| `P2A-PROMO-OD-07H` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `CUK-02` `CONTEXT_ONLY` | A stop-tracking UI option supplies lifecycle context only; no manual-end authority, reason, effective time or history evidence. | Identity/lifecycle |
| `P2A-PROMO-OD-07I` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | `KIOT-01`,`POS-03` `CONTEXT_ONLY` | Generic edit/audit context only; no published-Promotion correction, prospective reach or linked replacement evidence. | Identity/audit/Customer |
| `P2A-PROMO-OD-07J` | Promotions | `RECORDED` | `NO_PUBLIC_EVIDENCE_FOUND` | No evidence changes disabled emergency authority. | Governance if revisited |
| `P2A-PROMO-OD-08` | Promotions | `UNRESOLVED_CONDITIONAL` | `CUK-04`,`SAPO-05`,`IPOS-01` `DIRECT` | Schedule fields; not timezone/boundary semantics. | Operations/timezone |
| `W2-ORD-OD-01` | Ordering | `DEPENDENCY_BLOCKED` | `SAPO-05`,`IPOS-01`,`KIOT-01` `INDIRECT` | Components exist; not authoritative calculation sequence/allocation. | Catalog/Payment/Loyalty/Promotions/accounting |

Coverage reconciliation: Cash 8 + Workforce 13 + Inventory 9 + Loyalty 7 + Promotions 17 + Ordering 1 = **55**. Status reconciliation: **16 `RECORDED` + 22 `DIRECTION_CONFIRMED_CONDITIONAL` + 2 `UNRESOLVED_CONDITIONAL` + 3 `CLARIFICATION_REQUIRED` + 12 `DEPENDENCY_BLOCKED` = 55**. All twelve dependency-blocked candidates remain blocked.

## 12. Bibliography

The source register in §4 is the bibliography and contains every cited URL, title, source type, date availability, supported claim and limitation. Repository governance was cross-checked against:

- [Wave 2 Owner Review Package](after_four_wave_2_owner_review_package.md)
- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)

## 13. Explicit limitations and non-authorizations

Public pages can change without notice, product editions may differ, and screenshots may expose options unavailable in another plan or configuration. Undated pages have unknown currency. Marketing articles were not treated as operational contracts. Inaccessible pages were not used as evidence. Absence of public evidence does not prove absence of a feature.

This research records no Owner decision, changes no candidate status, allocates no ODB ID, and grants no Gate, schema, migration, database, API, implementation, UI, runtime, deployment, FOA, or Production Authorization. No vendor or external party was contacted; no email, request, attachment or confidential information was sent or disclosed.
