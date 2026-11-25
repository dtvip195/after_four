# AFTER FOUR — R04/R05 Market Price Research

**Observation date:** 2026-11-25

**Evidence status:** `MARKET_REFERENCE_ONLY`
**Scope:** Public Vietnamese retail listings for planning the first `CM-R04-01` and `CM-R05-01` trials, plus bounded manufacturer and technical evidence used only to define what must be measured or verified. No listing or technical reference is an approved Ingredient, supplier, quotation, transaction, landed cost, Recipe/BOM cost, margin input, formulation, tolerance, or trial authorization.

**Structured datasets:** [ingredient observations](after_four_r04_r05_ingredient_market_prices.csv), [equipment observations](after_four_r04_r05_equipment_market_prices.csv), and [R04/R05 mapping](after_four_r04_r05_trial_kit_market_mapping.csv). The tables below summarize those datasets; the CSV files are the row-level import artifacts.

## 1. Method and limitations

The review prioritized manufacturer/brand pages, established Vietnamese retailers, and specialist coffee or baking-equipment retailers. A row is retained only when the public page identifies the product and price; normalization is performed only from an explicit package quantity. Shipping is blank unless the product page states a charge. A retailer's general coverage does not prove availability or delivery to the First Branch in Hoi An.

Public pages are volatile. `listed_price_vnd` is an observation, not a quotation. Regular and promotional prices are kept separate. Volume-to-mass conversion is prohibited without sourced density; therefore condensed-milk packages expressed in grams cannot produce a cost for a recipe quantity expressed in millilitres. Ice has no sufficiently specific, reliable public listing in this review.

## 2. Ingredient observations

| ID | Category | Product / brand | Exact public specification | Package | Listed price VND | Price condition | Normalized reference | Retailer / source | Availability / geography note | Confidence |
|---|---|---|---|---:|---:|---|---|---|---|---|
| `R04M-I01` | Robusta coffee | Trung Nguyên Sáng Tạo 1 | 100% Robusta; ground coffee; public product page | 340 g | 95,000 | Public retail | 279.41 VND/g; 27,941 VND/100 g | WinMart — [listing](https://winmart.vn/products/trung-nguyen-cafexay-sang-tao1-goi-340g--s10013011) | Page showed in stock when indexed; no Hoi An delivery inference | High |
| `R04M-I02` | Robusta coffee | Trung Nguyên Sáng Tạo 1 | 100% Robusta; SKU 3330468 | 340 g | 89,700 | Public product-page price; separate category page displayed a lower promotion and is not silently substituted | 263.82 VND/g; 26,382 VND/100 g | Co.op Online — [listing](https://cooponline.vn/ca-phe-trung-nguyen-sang-tao-1-goi-340g--s250107910) | Stock/location depends on selected Co.op store | High |
| `R04M-I03` | Sweetened condensed milk | Vinamilk Ông Thọ green label | Sweetened condensed milk | 380 g | 29,700 | Public retail; page says VAT included, shipping excluded if applicable | 78.16 VND/g; 7,816 VND/100 g | WinMart — [listing](https://winmart.vn/products/vnm-ong-tho-sua-dac-chu-xanh-380g--s10010455) | Page showed in stock; delivery not established for Hoi An | High |
| `R04M-I04` | Sweetened condensed milk | Dutch Lady full-cream | Sweetened condensed milk, full-cream | 380 g | 36,300 | Public retail | 95.53 VND/g; 9,553 VND/100 g | WinMart — [listing](https://winmart.vn/products/dutch-lady-sua-dac-co-dg-ng.kem-lon-380g--s10010462) | Page showed in stock; delivery not established for Hoi An | High |
| `R04M-I05` | Whipping cream | Anchor | UHT whipping cream | 1 L | 204,500 | Public retail; VAT included, shipping excluded if applicable | 204.50 VND/ml; 20,450 VND/100 ml | WinMart — [listing](https://winmart.vn/products/anchor-kem-sua-tuoi-whipping-cream-1l--s10005822) | Page showed in stock; cold-chain/delivery to Hoi An unverified | High |
| `R04M-I06` | Whipping cream | Anchor | UHT whipping cream | 1 L | 210,000 | Public retail | 210 VND/ml; 21,000 VND/100 ml | Annam Gourmet — [search listing](https://shop.annam-gourmet.com/hcm-est/catalogsearch/result/?q=chilled+whipping+cream) | HCMC storefront context; delivery to Hoi An unverified | Medium |
| `R04M-I07` | Whipping cream | Emborg | UHT whipping cream, 35.1% fat | 200 ml | 84,000 | Public retail | 420 VND/ml; 42,000 VND/100 ml | Annam Gourmet — [search listing](https://shop.annam-gourmet.com/hcm-est/catalogsearch/result/?q=chilled+whipping+cream) | HCMC storefront context; delivery to Hoi An unverified | Medium |
| `R04M-I08` | Fresh milk | Meadow Fresh | UHT full-cream milk | 1 L | 57,700 | Public retail; VAT included, shipping excluded if applicable | 57.70 VND/ml; 5,770 VND/100 ml | WinMart — [listing](https://winmart.vn/products/meadow-fresh-sua-tiet-trung-nguyenkem-1l--s10010634) | Page showed in stock; delivery to Hoi An unverified | High |
| `R04M-I09` | Fresh milk comparator | TH true MILK | UHT milk, sweetened | 1 L | 44,500 | Public retail | 44.50 VND/ml; 4,450 VND/100 ml | WinMart — [listing](https://winmart.vn/products/thtrue-milk-sua-tuoi-tt-co-duong-hop-1l--s10005291) | Sweetened product is not assumed equivalent to full-cream/unsweetened milk | High |
| `R04M-I10` | Salt | Co.op Select | Fine dried iodized sea salt | 500 g | 3,600 | Public retail | 7.20 VND/g; 720 VND/100 g | Co.op Online — [listing](https://cooponline.vn/muoi-bien-tinh-say-i-ot-coop-select-500g--s250100888) | Stock/location depends on selected store | High |
| `R04M-I11` | Salt | Muối Miền Nam | Fine dried iodized salt, purple pack | 500 g | 3,800 | Public retail | 7.60 VND/g; 760 VND/100 g | Co.op Online — [brand listing](https://cooponline.vn/muoi-mien-nam-brand.muoi-mien-nam) | Stock/location depends on selected store | Medium |
| `R04M-I12` | Process/drinking water | Aquafina | Purified bottled water | 1.5 L | 11,700 | Public retail | 7.80 VND/ml; 780 VND/100 ml | WinMart — [listing](https://winmart.vn/products/aquafina-nuoc-tinh-khiet-1.5l--s10011217) | Page showed in stock; delivery to Hoi An unverified | High |
| `R04M-I13` | Ice | — | Trial requires measured ice mass | — | `PRICE_NOT_PUBLIC` | No sufficiently specific reliable listing retained | — | Gap | Ice source, food-handling specification, pack mass and price remain unverified | Low |

## 3. Equipment and tool observations

| ID | Category | Product | Public specification | Listed price VND | Price condition | Retailer / source | Missing specification / limitation | Confidence |
|---|---|---|---|---:|---|---|---|---|
| `R04M-E01` | Phin | Vinbar stainless phin | Inox; stated 20–25 g coffee / 170 ml water | 47,000 | Promotional; regular 53,000 | Vinbar — [listing](https://vinbar.vn/collections/nguyen-lieu-dung-cu-pha-che/products/phin-pha-ca-phe-inox) | Suitability for R04/R05 output must be physically tested | High |
| `R04M-E02` | Phin | Light Coffee stainless phin | Inox; complete base/filter/lid; 6×6×6 cm | 59,000 | Promotional; regular 60,000 | Light Coffee — [listing](https://lightcoffee.vn/products/phin-pha-ca-phe-phin-inox-light-coffee) | Capacity not stated | High |
| `R04M-E03` | Digital scale | I2000 | 3 kg maximum; 0.1 g division | 115,000 | Public retail | Phadin Coffee — [category listing](https://phadincoffee.com/cua-hang/dung-cu-ca-phe/) | Power source, dimensions and warranty not shown in category evidence | High |
| `R04M-E04` | Digital scale/timer | Promix CDTP-06 | 5 kg maximum; 0.1 g division; timer | 390,000 | Public retail | Phadin Coffee — [category listing](https://phadincoffee.com/cua-hang/dung-cu-ca-phe/) | Power source, dimensions and warranty not shown | High |
| `R04M-E05` | Digital scale comparator | Electronic Kitchen Scale | Exact capacity/resolution not visible in category result | 80,000 | Promotional; regular 120,000 | Beemart — [measurement-tools listing](https://www.beemart.vn/dung-cu-dong-chia) | Cannot establish gram-level suitability without resolution | Medium |
| `R04M-E06` | Foam tool | Thick stainless balloon whisk | 30 cm | 55,000 | Public retail | Beemart — [foam-tool listing](https://www.beemart.vn/dung-cu-danh-trung) | Manual output/repeatability not established | Medium |
| `R04M-E07` | Electric foam tool comparator | Bear B02P5 hand mixer | 125 W; 220 V; five speeds; two beaters; 12-month warranty | 399,000 | Public retail | Beemart — [listing](https://www.beemart.vn/may-danh-trung-bear-b02p5) | Dimensions not stated; not selected for the trial | High |
| `R04M-E08` | Food thermometer | Liquid thermometer | Product category identifies liquid thermometer | 51,000 | Public retail | Phadin Coffee — [category listing](https://phadincoffee.com/cua-hang/dung-cu-ca-phe/) | Range, resolution, response time and calibration evidence missing | Medium |
| `R04M-E09` | Food thermometer comparator | WT-01 candy thermometer | Product identity visible | 120,000 | Public retail | Beemart — [measurement-tools listing](https://www.beemart.vn/dung-cu-dong-chia) | Range, resolution and calibration evidence missing | Medium |
| `R04M-E10` | Graduated measure | Plastic measuring jug | 100 ml | 10,000 | Public retail | Beemart — [measurement-tools listing](https://www.beemart.vn/dung-cu-dong-chia) | Graduation interval and tolerance not stated | Medium |
| `R04M-E11` | Graduated measure | Plastic measuring jug | 250 ml | 36,000 | Public retail | Beemart — [measurement-tools listing](https://www.beemart.vn/dung-cu-dong-chia) | Graduation interval and tolerance not stated | Medium |
| `R04M-E12` | Graduated measure | Plastic measuring jug | 500 ml | 40,000 | Public retail | Beemart — [measurement-tools listing](https://www.beemart.vn/dung-cu-dong-chia) | Graduation interval and tolerance not stated | Medium |
| `R04M-E13` | Serving-vessel comparator | Volcano phin combo | Inox phin plus borosilicate glass, 360 ml, and 100 filters | 477,000 | Public listed silver combo; other colors 497,000 | Volcano — [price/specification page](https://volcanovietnam.com/cach-pha-ca-phe-phin-inox-304) | Combo price does not establish standalone vessel price or measured usable capacity | Medium |
| `R04M-E14` | Standalone timer | — | Timer function required | — | `PRICE_NOT_PUBLIC` | Gap | Promix scale includes a timer; no sufficiently specified standalone timer listing retained | Low |
| `R04M-E15` | Vessel-capacity measurement | Graduated measure plus actual vessel | Capacity must be physically measured | — | No separate price; use only a verified graduated tool | Existing tool observations | No public listing can establish usable capacity of the Owner's actual vessel | High boundary confidence |

## 4. Reproducible public-price ranges

Ranges compare only compatible public observations. A median is omitted where fewer than three compatible priced observations exist.

| Category | Valid comparable observations | Lowest | Highest | Dispersion / limitation |
|---|---:|---:|---:|---|
| 100% Robusta ground coffee, 340 g | 2 | 89,700 VND | 95,000 VND | Same named product at two retailers; observed spread 5,300 VND (5.9% of low). |
| Sweetened condensed milk, 380 g | 2 | 29,700 VND | 36,300 VND | Different brands/types; no formulation equivalence assumed. |
| UHT whipping cream | 3 | 204.50 VND/ml | 420 VND/ml | Different brands and pack sizes; median 210 VND/ml; observed unit-price spread 215.50 VND/ml. |
| UHT fresh milk, 1 L | 2 | 44,500 VND | 57,700 VND | Products are not equivalent: one is sweetened, one full-cream. |
| Fine iodized salt, 500 g | 2 | 3,600 VND | 3,800 VND | Different brands; observed spread 200 VND. |
| Phin | 2 | 47,000 VND | 59,000 VND | Different dimensions/capacity evidence; not interchangeable. |
| Scale with explicit 0.1 g division | 2 | 115,000 VND | 390,000 VND | Higher-priced listing also includes timer and higher maximum load. |
| Food thermometer | 2 | 51,000 VND | 120,000 VND | Measurement ranges/resolutions absent, so functional comparability remains incomplete. |
| Graduated plastic measure | 3 | 10,000 VND | 40,000 VND | Capacities differ (100/250/500 ml); median 36,000 VND describes listed tools, not equal-capacity products. |

## 5. R04/R05 trial-kit mapping

### R04 public market-reference envelope

| Required input | Source amount | Applicable observations | Indicative amount reference | Boundary |
|---|---:|---|---:|---|
| Vietnamese Robusta | 20 g | `R04M-I01/I02` | 5,276–5,588 VND | Candidate retail products only; grind suitability and approval unresolved. |
| Water | 100 ml | `R04M-I12` | 780 VND | Bottled-water comparator only; process-water choice unresolved. |
| Condensed milk | 20 ml | `R04M-I03/I04` | Not calculated | Retail packages are in grams; no sourced density supports ml-to-g conversion. |
| Whipping cream | 60 ml | `R04M-I05/I06/I07` | 12,270–25,200 VND | Brand/type not selected; pack-size effects retained. |
| Salt | 0.75–1.5 g | `R04M-I10/I11` | 5.4–11.4 VND | Owner must select the trial value; salts are not assumed sensory-equivalent. |
| Ice | Measured during trial | `R04M-I13` | `PRICE_NOT_PUBLIC` | Actual mass, source and price absent. |

The visible, valid partial envelope is approximately **18,332–31,580 VND**, calculated from the unrounded normalized references and rounded to the nearest VND. It excludes condensed milk and ice and excludes equipment, shipping, waste and packaging. It is not a unit cost or costing-ready result.

### R05 public market-reference envelope

| Required input | Source amount | Applicable observations | Indicative amount reference | Boundary |
|---|---:|---|---:|---|
| Phin coffee | 20 g | `R04M-I01/I02` | 5,276–5,588 VND | Candidate Robusta comparator; exact coffee remains Owner input. |
| Water | 80 ml | `R04M-I12` | 624 VND | Bottled-water comparator only. |
| Condensed milk in coffee | 15–20 ml | `R04M-I03/I04` | Not calculated | No sourced density. |
| Cream | 50 ml | `R04M-I05/I06/I07` | 10,225–21,000 VND | Exact cream type not selected. |
| Fresh milk | 20 ml | `R04M-I08/I09` | 890–1,154 VND | Sweetened and full-cream products are not formulation-equivalent. |
| Condensed milk in foam | 10 ml | `R04M-I03/I04` | Not calculated | No sourced density. |
| Salt | Approximately 0.5 g | `R04M-I10/I11` | 3.6–3.8 VND | Approximate source quantity remains unchanged. |
| Ice | Measured during trial | `R04M-I13` | `PRICE_NOT_PUBLIC` | Actual mass, source and price absent. |

The visible, valid partial envelope is **17,019–28,370 VND**, excluding both condensed-milk quantities and ice and excluding equipment, shipping, waste and packaging. It is not a unit cost or costing-ready result.

No complete equipment-kit total is defensible: the observations are alternatives, some specifications are incomplete, the actual serving vessel is unidentified, and a standalone timer price was not verified. Equipment must be selected and physically checked by the Owner; this research makes no selection.

## 6. Source and freshness register

| Source group | Pages reviewed / retained use | Evidence classification | Last checked |
|---|---:|---|---|
| WinMart | 8 product/retailer pages; 6 retained product observations | Current public retail listing; location and delivery unresolved | 2026-11-25 |
| Co.op Online | 6 category/product pages; 4 retained observations | Current public retail listing; store selection affects stock | 2026-11-25 |
| Annam Gourmet | 2 search/category pages; 2 retained cream observations | Current HCMC storefront listing | 2026-11-25 |
| Phadin Coffee | 5 category/guidance pages; 4 retained tool observations | Specialist-retailer public listing; some specification fields missing | 2026-11-25 |
| Beemart | 5 category/product pages; 7 retained tool observations | Established retail listing; promotions kept explicit | 2026-11-25 |
| Vinbar, Light Coffee, Volcano | 3 product/specification pages; 3 retained observations | Specialist/brand retail evidence | 2026-11-25 |

## 7. Remaining evidence gaps

- No actual Ingredient/SKU has been selected or physically confirmed for either run.
- No reliable ice pack/price/source evidence was retained.
- Condensed-milk recipe quantities cannot be normalized from ml to a gram-priced retail package without sourced density or actual measurement.
- Delivery, shipping, cold chain and availability at the First Branch are unverified.
- Several tools lack range, resolution, calibration, dimensions, power-source or warranty detail.
- No serving vessel has been selected or measured; public nominal capacity cannot replace usable-capacity measurement.
- No supplier identity, quotation, transaction, receipt, actual purchase price, landed cost, Recipe/BOM cost or margin evidence exists.

All findings remain `MARKET_REFERENCE_ONLY`. Nothing here authorizes supplier contact, RFQ, purchase, payment, substitution, Ingredient approval, Recipe/BOM approval, trial execution, costing, pricing, implementation, Gate, FOA, or Production Authorization.

## 8. R04 Internet evidence completion

**Internet review date:** 2026-11-25. This section strengthens the Owner's provisional R04 preparation choices; it does not change them. Manufacturer facts, retailer observations and technical references are deliberately separated.

### 8.1 R04 Ingredient comparison

| Input | Provisional candidate and strongest evidence | Research comparators | Evidence-backed assessment | Owner-review recommendation |
|---|---|---|---|---|
| Coffee | `R04M-I01/I02`, Trung Nguyên Sáng Tạo 1, 340 g. Manufacturer packaging/self-declaration identifies 100% Robusta, ground coffee, 340 g, dry/cool storage, and phin directions using about 20 g; see `R04X-S01`. | La Viet F1 is explicitly ground for Vietnamese phin (`R04X-S02`); Mr. Việt Robusta is a 250 g, 100% Robusta, medium-dark, ground comparator (`R04X-S03`). These are not the same Product or sensory substitute. | The two retained retailer rows refer to the same named Product and package size. `I01` is the stronger direct retailer page; `I02` adds retailer SKU `3330468` and the lower observed public price. No evidence proves a shared retailer SKU, current Hội An stock or grind performance in `R04M-E01`. | **Retain `I01/I02` for trial preparation.** Use `I01` as primary listing evidence and `I02` as retailer/price corroboration; physically verify the actual package and grind before trial. |
| Condensed milk | `R04M-I03`, Ông Thọ Nhãn xanh biển 380 g. Vinamilk's Product page provides the ingredient declaration and nutrition panel (`R04X-S04`). | Other Ông Thọ variants have distinct formulations and are comparators only. Vinamilk label evidence for another 380 g Ông Thọ variant confirms the pattern “close tightly, refrigerate after opening, use within 7 days,” but the actual green-label package must be checked before applying that instruction (`R04X-S05`). | Official evidence supports exact identity, package and ingredients. It does not supply a defensible density for converting R04's 20 ml into grams. | **Retain `I03`.** Verify the green-label package's own after-opening instruction, lot and expiry; measure 20 ml directly. |
| Whipping cream | `R04M-I05/I06`, Anchor UHT Whipping Cream 1 L. Anchor identifies 1 L, item code `119204`, minimum 35% milk fat, UHT handling, 2–4°C after opening, use within 3 days and do not freeze (`R04X-S06`). | Emborg 200 ml is an official Vietnam-market 35.1% alternative (`R04X-S07`). Elle & Vire 1 L is a Vietnam retailer/distributor comparator with public pricing but incomplete official handling evidence in the retained page (`R04X-S08`). | `I05` is the stronger direct retailer listing and `I06` a secondary retailer observation. Alternatives differ in brand, pack and possibly functional output; no interchangeability is established. | **Retain Anchor `I05/I06`.** Use `I05` as primary public listing; physically verify exact item, cold-chain/package condition and after-opening instruction. |
| Salt | `R04M-I10/I11`; quantity remains 1.0 g. Co.op's direct `I10` page states fine dried iodized sea salt, 500 g, NaCl 99.996–99.998% and KIO3 0.002–0.004% (`R04X-S09`). | `I11` remains a lower-detail brand/category listing. | `I10` has the stronger identity, ingredient/mineral and public-price evidence. Grain behavior and sensory suitability remain physical-trial questions. | **Prefer `I10` for Owner review; retain `I11` as alternative.** This is not Ingredient approval. |
| Water | `R04M-I12`, Aquafina 1.5 L. Public label documentation identifies bottled water, 1.5 L, barcode `8934588063060`, RO/ozone/UV treatment and dry/cool/clean storage away from sunlight, strong odors and chemicals (`R04X-S10`). | A controlled potable-water source could be compared later only with its own source and quality evidence. | The evidence supports a bounded bottled-water comparator, not a permanent café water policy or local delivery. | **Retain `I12` for the bounded R04 trial.** Verify the actual sealed bottle, label, lot/expiry and source. |
| Ice | `R04M-I13` remains a gap. Vietnamese food-safety materials identify instant-use/food-processing ice as a regulated food category and QCVN 10:2011/BYT provides the relevant safety framework (`R04X-S11`, `R04X-S12`). | Internet searches did not yield a sufficiently verifiable Hội An/Đà Nẵng Product page combining exact producer identity, package, current public price, food-safety evidence and delivery terms. | No supplier, pack size, price, mass or local availability can be responsibly selected. | **No verifiable candidate.** Owner/operator must physically identify a packaged or documented food-grade source and weigh the actual trial portion. |

### 8.2 R04 equipment shortlist and purchase-reference comparison

Every price is `MARKET_REFERENCE_ONLY`. “Primary” means best aligned with the existing provisional checkpoint or strongest documentation; it is not an acquisition decision.

| Function | Primary candidate | Alternative(s) | Public price evidence | Technical evidence and limitation | Status |
|---|---|---|---|---|---|
| Phin | `R04M-E01` Vinbar inox; public listing states a 20–25 g coffee / 170 ml water basis. | QiFi aluminium phin states one 20 g serving (`R04X-S13`); 88 Coffee stainless phin states 20 g capacity (`R04X-S14`). | Vinbar 47,000 promotional / 53,000 regular; alternatives' Vietnam price not verified. | Material/capacity claims do not prove perforation consistency, extraction or physical condition. Exact basket dimensions were not verified for `E01`. | Retain `E01`; `PHYSICAL_VERIFICATION_REQUIRED`. |
| General scale/timer | `R04M-E04` Promix CDTP-06, public retailer evidence: 5 kg, 0.1 g division, timer, 390,000 VND. Promix's own page states `0.1g - 5000g`, 200×145×29 mm, 4.5 V and 12-month warranty (`R04X-S25`). | `E03` I2000; laboratory/technical alternative PCE-BT 2000: 2,100 g, 0.01 g readability/repeatability, ±0.2 g linearity, external calibration, 19,025,188 VND incl. VAT (`R04X-S15`). | As stated. | The Promix page does not distinguish display interval from verified accuracy, state `Min`, publish repeatability/linearity, or provide a calibration/test report. OIML R 76 explains that verification scale interval and minimum capacity are separate metrological characteristics, and that use below `Min` can have considerable relative error (`R04X-S29`). PCE's 0.01 g readability still does not meet the proposed ±0.05 g R04 operating band merely by specification because its stated linearity is ±0.2 g. | Retain `E04` for general measurements/timer; **no publicly verified scale currently proves the proposed R04 salt band**. Separate physical verification or a suitable verified precision balance is required. |
| Thermometer | Testo 104 official Vietnam page: -50 to +250°C, accuracy ±0.5°C from -30 to +99.9°C and ±1% above 100°C (`R04X-S16`). The official data sheet additionally states 0.1°C resolution and 10 s response time in moving liquid (`R04X-S26`). | Nitori NDO-1: -15 to 250°C, 0.1°C display, ±1°C from 0 to 100°C (`R04X-S17`); TZ-FMT04 distributor document: -50 to 300°C, 0.1°C resolution, published ±1°C relevant range (`R04X-S18`). | Testo/Nitori/TZ prices not consistently verified in retained direct pages. | All cover 90–96°C on paper. The 10 s response is specified for moving liquid, not the selected phin geometry. Cleaning, actual response, physical condition and comparison check remain required; a factory data sheet or calibration feature is not current calibration evidence for the acquired unit. | Testo 104 is strongest technical candidate; NDO-1/TZ-FMT04 are alternatives. `OWNER_CONFIRMATION_REQUIRED`. |
| 20/60/100 ml volume | DURAN 100 ml Class A cylinder with ISO 4788 basis and stated 0.5 ml tolerance, individually calibrated with ISO 17025-accredited certificate (`R04X-S19`). | Existing `E10/E11/E12` food jugs have public capacity/price but no graduation/tolerance evidence. A food-safe syringe may be considered for 20 ml only if its specification and cleaning controls are documented. | DURAN price not verified; existing jugs 10,000/36,000/40,000 VND. | Laboratory cylinder provides stronger volumetric evidence but food-contact use, cleaning, breakage risk and availability must be reviewed. Separate appropriate tools may be needed for viscous condensed milk and cream. | Prefer a documented cylinder/reference system for verification; actual working tool remains `OWNER_CONFIRMATION_REQUIRED`. |
| Foam tool | `R04M-E07` Bear DDQ-B02P5: Bear identifies 125 W, five speeds and stainless beaters (`R04X-S20`); retailer observation 399,000 VND. | Bear HM-5H01J29: 125 W, 220 V/50 Hz, five speeds, 915–1480 rpm, two beaters, 18-month warranty, 690,000 VND on Bear Vietnam (`R04X-S21`). Tetra Pak's technical handbook describes pure whipping-cream temperature, time and overrun controls (`R04X-S28`). | As stated. | Neither mixer candidate specifies which speed/time produces the R04 or R05 mixed foam. The Tetra Pak method concerns whipping cream, including a 40% cream test example; it does not validate a foam containing condensed milk, salt, or R05 fresh milk and does not create a sensory acceptance threshold. | Retain `E07`; HM-5H01J29 is documented alternative, not a substitution. Record actual inputs, starting/ending temperature, tool/speed, time and output; keep pass/fail criteria open. |
| Serving vessel | No actual vessel selected. Luminarc Salto 350 ml is listed at 41,900 VND with food-safe glass and dishwasher claims (`R04X-S23`). | Libbey Venice 350 ml is listed at 56,100 VND (`R04X-S24`); existing `E13` remains only a 360 ml combo comparator. | 41,900 / 56,100 VND; `MARKET_REFERENCE_ONLY`. | The complete R04 output is unmeasured, so neither nominal 350 ml vessel is proven large enough. Luminarc's retained page also states a 60°C thermal threshold, requiring separation from hot brewing and physical handling review. Nominal capacity is not usable capacity. | Shortlist both for Owner review only; final selection requires measured output/headspace and three physical usable-capacity observations. |
| Ice/output weighing | `E04` may cover full-vessel mass if it passes physical verification. | A separate suitable scale may be used if its range, readability and check evidence are documented. | No additional price retained. | Salt precision and full-vessel capacity are different measurement problems and need not use the same instrument. | `PHYSICAL_VERIFICATION_REQUIRED`. |

### 8.3 Food-safety and handling controls

These controls combine manufacturer instructions and general authoritative guidance. They are not a legal-compliance determination.

| Control | Source-grounded requirement for the R04 checklist | Evidence class |
|---|---|---|
| Anchor cream | Verify unopened package and date; protect from direct sunlight; once opened keep at 2–4°C, use within 3 days and do not freeze, subject to confirmation on the actual Vietnam package. | `OFFICIAL_MANUFACTURER_SPEC` — `R04X-S06` |
| Condensed milk | Follow the actual green-label package. The retained Vinamilk label reference for a 380 g Ông Thọ variant says close tightly, refrigerate after opening and use within 7 days; do not transfer it silently if the selected package differs. | `OFFICIAL_PRODUCT_LABEL` / `PHYSICAL_VERIFICATION_REQUIRED` — `R04X-S05` |
| Ice and water | Use a traceable safe source; retain source/package evidence; protect from contamination; use clean dedicated containers and scoops; never infer safety from visual appearance. | `TECHNICAL_REFERENCE` — WHO Five Keys (`R04X-S22`) and Vietnamese ice framework (`R04X-S11/S12`) |
| Equipment and surfaces | Wash and sanitize food-contact surfaces/equipment, keep clean, and avoid cross-contamination. Record actual cleaning method and any manufacturer restriction for thermometer probes and mixer beaters. | `TECHNICAL_REFERENCE` — `R04X-S22` |
| Temperature tool | Clean the probe before/after use according to its instructions; do not submerge non-waterproof parts; retain comparison-check evidence separately from formal calibration. | Manufacturer-specific instruction remains `PHYSICAL_VERIFICATION_REQUIRED`; general hygiene from `R04X-S22`. |
| Finished drink | Record preparation/holding time and protect the finished beverage from contamination. No shelf-life or service-time threshold is created here. | `OWNER_CONFIRMATION_REQUIRED`; general practice from `R04X-S22`. |

### 8.4 Source register

| Source ID | Page title / publisher | URL | Accessed | Classification | Retained use |
|---|---|---|---|---|---|
| `R04X-S01` | Cà phê rang xay Sáng Tạo 1 — Trung Nguyên Legend | https://trungnguyenlegend.com/files/HO-SO-TU-CONG-BO-SAN-PHAM/CPRX-SangTao1.pdf | 2026-11-25 | `OFFICIAL_PRODUCT_LABEL` | Identity, 340 g, 100% Robusta, ground/phin directions, storage. |
| `R04X-S02` | F1 — La Viet Coffee | https://laviet.coffee/en/san-pham/f1-en-2/ | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | Ground-for-phin coffee comparator. |
| `R04X-S03` | Mr. Viet Robusta Ground Coffee — L's Place | https://lsplace.com.vn/products/mr-viet-cafe-robusta | 2026-11-25 | `RETAILER_PRODUCT_LISTING` | 250 g 100% Robusta ground comparator. |
| `R04X-S04` | Ông Thọ Nhãn xanh biển — Vinamilk | https://www.vinamilk.com.vn/products/sua-dac-co-duong-ong-tho-chu-xanh?pack=380g+h%E1%BB%99p+thi%E1%BA%BFc | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | Exact identity, ingredients and nutrition. |
| `R04X-S05` | Ông Thọ 380 g label publication — Vinamilk | https://www.vinamilk.com.vn/cong-bo-san-pham/wp-content/uploads/cbsp/pc-000042-tb-cts-ncpt-04-ncpt-22-final.pdf | 2026-11-25 | `OFFICIAL_PRODUCT_LABEL` | Variant-specific storage comparator; actual green label still controls. |
| `R04X-S06` | Anchor Whipping Cream — Anchor Food Professionals | https://www.anchorfoodprofessionals.com/id/en/our-products/cream/anchor-whipping-cream.html | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | 1 L/item code, milk fat, UHT storage and after-opening handling. |
| `R04X-S07` | Natural Whipping Cream — Emborg Vietnam | https://www.emborg.com/vn/product/natural-whipping-cream/ | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | 200 ml, 35.1% fat alternative. |
| `R04X-S08` | Elle & Vire Vietnam catalogue — Beemart | https://ellevire.beemart.vn/ | 2026-11-25 | `DISTRIBUTOR_INFORMATION` | 1 L public-price alternative; handling evidence incomplete. |
| `R04X-S09` | Co.op Select fine dried iodized sea salt 500 g — Co.op Online | https://cooponline.vn/muoi-bien-tinh-say-i-ot-coop-select-500g--s250100888 | 2026-11-25 | `RETAILER_PRODUCT_LISTING` | Identity, composition, package, storage and price. |
| `R04X-S10` | Aquafina 1.5 L label publication | https://prod-cdn.pharmacity.io/e-com/attachments/product-notification/20250428112012-0-d8e3cecef96feba4b0249235f18d18b4.pdf | 2026-11-25 | `OFFICIAL_PRODUCT_LABEL` | Bottle identity, treatment, barcode and storage. |
| `R04X-S11` | Food-product management annex — Vietnam Food Administration | https://thongtinattp.vfa.gov.vn/app/P0103 | 2026-11-25 | `TECHNICAL_REFERENCE` | Instant-use/food-processing ice category. |
| `R04X-S12` | QCVN 10:2011/BYT | https://kiemnghiemkhanhhoa.gov.vn/wp-content/uploads/2019/10/QCVN-10-2011-BYT.pdf | 2026-11-25 | `TECHNICAL_REFERENCE` | National technical framework for edible ice. |
| `R04X-S13` | QiFi aluminium phin | https://qifi.vn/en/products/phin-nhom-qifi | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | 20 g one-serving alternative. |
| `R04X-S14` | 88 Coffee stainless phin | https://88coffeecompany.com/collections/frontpage/products/phin | 2026-11-25 | `RETAILER_PRODUCT_LISTING` | 20 g stainless alternative. |
| `R04X-S15` | PCE-BT 2000 precision balance — EMIN Vietnam | https://emin.vn/en/pce-bt-2000-pce-bt-2000-precision-balance-2100g-0-01g-120303/pr.html | 2026-11-25 | `DISTRIBUTOR_INFORMATION` | Readability, repeatability, linearity, calibration and price comparator. |
| `R04X-S16` | testo 104 — Testo Vietnam | https://www.testo.com/en-VN/testo-104/p/0563-0104 | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | Thermometer range and accuracy. |
| `R04X-S17` | NDO-1 digital food thermometer — Nitori Vietnam | https://www.nitori.com.vn/products/digital-food-thermometer-ndo-1 | 2026-11-25 | `RETAILER_PRODUCT_LISTING` | Range, 0.1°C display and accuracy. |
| `R04X-S18` | TZ-FMT04 food thermometer — APV | https://apvco.vn/uploads/files/ApLog/TZ-FMT04.pdf | 2026-11-25 | `DISTRIBUTOR_INFORMATION` | Range, resolution, accuracy and recalibration feature. |
| `R04X-S19` | DURAN 100 ml Class A cylinder — Hoa Viet | https://shop.hoaviet.vn/en/duran-100ml-class-a-glass-measuring-cylinder-with-ukas-calibration-certificate | 2026-11-25 | `DISTRIBUTOR_INFORMATION` | ISO 4788, 0.5 ml tolerance, calibration-certificate claim. |
| `R04X-S20` | Bear DDQ-B02P5 — Bear Vietnam | https://bearvietnam.vn/tu-van-may-danh-trung/may-danh-trung-cam-tay-loai-nao-tot.html | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | 125 W, five speeds and beaters. |
| `R04X-S21` | Bear HM-5H01J29 — Bear Vietnam | https://bearvietnam.vn/san-pham/may-danh-trung-bear-hm-5h01j29/ | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | Documented foam-tool alternative and public price. |
| `R04X-S22` | Five Keys to Safer Food — WHO | https://www.who.int/publications/i/item/9789241594639/ | 2026-11-25 | `TECHNICAL_REFERENCE` | Cleaning, separation, safe temperature, water and raw-material controls. |
| `R04X-S23` | Luminarc Salto Highball Glass 350 ml — Lotte Mart Vietnam | https://www.lottemart.vn/en-cto/product/luminarc-salto-highball-glass-350ml-8935295600647-p32303 | 2026-11-25 | `RETAILER_PRODUCT_LISTING` | Vessel candidate, nominal capacity, care claims and public price. |
| `R04X-S24` | Libbey Venice Beverage Glass 350 ml — Thai Sa Hospitality | https://www.thaisa.vn/libbey | 2026-11-25 | `DISTRIBUTOR_INFORMATION` | Vessel alternative and public price. |
| `R04X-S25` | PM CDT-06 — Promix | https://shop.promix.vn/cdtp-06 | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | Dimensions, voltage, stated `0.1g - 5000g` range, materials, warranty and public price; no accuracy, `Min`, repeatability, linearity or calibration report. |
| `R04X-S26` | Data sheet: testo 104 folding thermometer — Testo SE & Co. KGaA | https://media.testo.com/media/c4/61/6f5a24a66668/testo-104-Data-sheet.pdf | 2026-11-25 | `OFFICIAL_MANUFACTURER_SPEC` | January 2018 data sheet; range, accuracy, resolution, response time and IP65 rating; not current calibration evidence for an acquired unit. |
| `R04X-S27` | SCA's Minimum Certification Requirements for Coffee Brewers — Specialty Coffee Association | https://sca.coffee/s/2017-SCA-CHB-Program-Requirements-ba6g.pdf; current standards index: https://sca.coffee/research/coffee-standards | 2026-11-25 | `HISTORICAL_TECHNICAL_REFERENCE` | Archived automatic-brewer certification §§2–3 provide contact-time and 92–96°C water-at-grounds measurement context. The current SCA index identifies `SCA-310` as the current home-brewer standard but requires member access; this archived document is therefore not evidence of the current certification text, a phin recipe, or an R04/R05 acceptance standard. |
| `R04X-S28` | Dairy Processing Handbook, “Pasteurized and ESL dairy products”, “The whipping method” — Tetra Pak | https://dairyprocessinghandbook.tetrapak.com/chapter/pasteurized-and-esl-dairy-products | 2026-11-25 | `TECHNICAL_REFERENCE` | Pure whipping-cream process variables and test method; not validation of the R04/R05 mixed foam or a sensory specification. |
| `R04X-S29` | OIML R 76-1:2006, Non-automatic weighing instruments — International Organization of Legal Metrology | https://www.oiml.org/en/publications/recommendations/en/files/pdf_r/r076-1-e06.pdf | 2026-11-25 | `TECHNICAL_REFERENCE` | §§2.2, 3.1.2: verification interval, minimum capacity and relative-error boundary; does not certify any candidate scale. |

### 8.5 Owner-review ballot and unresolved blockers

Existing provisional selections are not reopened. For each research recommendation the Owner may mark `RETAIN_FOR_TRIAL_PREPARATION`, `REPLACE`, `DEFER`, or `REJECT`; blank means undecided.

| Decision area | Evidence-backed recommendation | Owner disposition | Comment / replacement evidence |
|---|---|---|---|
| Coffee | Retain `I01/I02`; `I01` primary listing, `I02` corroborating retailer evidence. |  |  |
| Condensed milk | Retain `I03`; verify actual green-label package/storage statement. |  |  |
| Cream | Retain Anchor `I05/I06`; `I05` primary listing. |  |  |
| Salt Product | Prefer `I10`; retain `I11` alternative; keep 1.0 g unchanged. |  |  |
| Water | Retain `I12` for the bounded trial only. |  |  |
| Ice | No online candidate meets the evidence threshold; require physical/documentary source identification. |  |  |
| Phin | Retain `E01`; physically verify assembly/capacity. |  |  |
| Scale | Retain `E04` for general measurements/timer, but require a separately defensible salt-measurement solution if checks cannot support 1.0 g. |  |  |
| Thermometer | Review Testo 104 first; NDO-1 and TZ-FMT04 as alternatives. |  |  |
| Volume measurement | Review a documented Class A/reference cylinder system; define suitable working tools for viscous 20/60 ml inputs. |  |  |
| Foam tool | Retain `E07`; keep HM-5H01J29 as documented alternative. |  |  |
| Vessel | Select only after physical identity and three usable-capacity observations. |  |  |

The remaining blockers are physical package/lot evidence, actual local availability, ice source, equipment possession/condition, Promix accuracy and repeatability evidence, suitable salt measurement, actual vessel capacity, acquisition authority and trial-execution authority. Internet research cannot close those facts.

All R04 Internet findings remain preparation evidence. They authorize no contact, purchase, trial, Recipe/BOM, cost, margin, Gate, FOA or Production action.

### 8.6 R04/R05 technical measurement evidence and proposed controls

The following controls are deliberately separated from source facts. Each proposed control is `PROPOSED_NOT_APPROVED`; it is neither a Recipe change nor trial authorization. Technical references establish measurement risks and comparable methods, not that a candidate instrument has passed verification.

| Area | Exact primary/technical source basis | Establishes | Does not establish | Proposed trial control — `PROPOSED_NOT_APPROVED` | Confidence |
|---|---|---|---|---|---|
| Coffee contact temperature | The archived SCA automatic-brewer requirements, §§2–3 (`R04X-S27`), measure water where it contacts the grounds and use 92–96°C for that historical certification program. The current SCA standards index identifies `SCA-310` but does not expose its text publicly. R05 independently states 92–96°C in its source formulation; R04's retained formulation remains unchanged. | Kettle display temperature is not necessarily coffee-bed contact temperature; the measurement point and time matter. | The archived automatic-drip certification does not establish current SCA requirements, validate phin geometry, R04/R05 sensory quality, contact time, extraction yield, or a winning formulation. It does not add 92–96°C to R04. | For R05 only, use a thermometer whose stated error is no greater than ±0.5°C over 92–96°C, record both kettle and at-grounds readings with elapsed time, and record rather than “correct” a failed reading. The exact phin probe position and acceptance method remain open. | High for the archived source meaning; low/medium for transfer to current phin use. |
| Thermometer response and verification | Testo 104 data sheet, “Technical data” (`R04X-S26`): ±0.5°C from -30 to +99.9°C, 0.1°C resolution, 10 s response in moving liquid. | A candidate class exists whose published accuracy is tighter than the proposed ±0.5°C R05 measurement limit. Response time depends on test conditions. | It does not prove the purchased unit's calibration, response in a phin bed, hygiene condition, or correct operator technique. | Before use, identify the actual unit and calibration/check evidence; record stabilization time and any comparison check. Do not treat display resolution as accuracy. | High. |
| R04 salt mass | R04 Owner-preparation baseline remains 1.0 g. Promix's official page (`R04X-S25`) states `0.1g - 5000g` but no verified accuracy, while OIML R 76-1 §§2.2 and 3.1.2 (`R04X-S29`) distinguish accuracy/verification interval and `Min`. | A displayed 0.1 g increment or range statement alone cannot establish uncertainty at a 1.0 g load. | Neither source certifies `E04`, supports a Recipe quantity, or proves that 1.0 g can be measured within any specified band. | Preserve the already stated internal target of 1.00 g with a ±0.05 g operating band, but label it `PROPOSED_NOT_APPROVED`. Do not use `E04` for acceptance unless actual repeatability, error and minimum-load evidence support that band; otherwise use a separately verified precision balance. | High for metrology boundary; low for the unapproved operating band. |
| R05 salt mass | R05's public formulation says approximately 0.5 g; OIML R 76-1 (`R04X-S29`) supplies the same minimum-load/relative-error caution. | Approximate source wording remains approximate even if a precise instrument is used. | No evidence converts 0.5 g into an exact target or supplies an acceptance tolerance. | Record the actual mass and instrument evidence without creating a pass/fail band. Any exact target or tolerance requires separate Owner formulation approval. | High. |
| Liquid volume | DURAN Class A 100 ml cylinder evidence (`R04X-S19`) states a 0.5 ml tolerance and certificate basis. | A documented 100 ml reference tool can have an explicit tolerance. | It does not establish suitable food-service working tools or tolerances for viscous 20 ml condensed milk, 50/60 ml cream, or all R04/R05 inputs. | Record tool identity, nominal capacity, graduation and published tolerance for each measured liquid. No numeric acceptance tolerance is proposed for 20/50/60 ml until the actual tool and method are selected. | High for the 100 ml source; low outside that scope. |
| Foam process | Tetra Pak, “The whipping method” (`R04X-S28`), identifies low starting temperature, measured whipping time and overrun as relevant for pure whipping cream; Anchor separately requires its selected cream to be kept at 2–4°C after opening (`R04X-S06`). | Temperature, mechanical treatment, time and volume change are material process observations. | The pure-cream method and 40% cream example do not validate R04/R05 mixed foam, set mixer speed/time, establish salt performance, or supply sensory thresholds. | Keep R04 and R05 independent. Record exact cream/condensed-milk/milk/salt identities and amounts, starting/ending temperatures, mixer/beater, speed, duration, initial/final mass and volume, and observed separation. No numeric foam acceptance tolerance is established. | High for variables; low for formulation transfer. |

#### Technical-source provenance

| Source ID | Title | Organization | Publication / edition date | URL | Access date | Exact section used | Establishes | Does not establish | Confidence |
|---|---|---|---|---|---|---|---|---|---|
| `R04X-S25` | PM CDT-06 | Promix | Not stated | https://shop.promix.vn/cdtp-06 | 2026-11-25 | Product specification block | Stated range, dimensions, voltage, materials and warranty. | Accuracy, `Min`, repeatability, calibration or salt suitability. | High for listed specifications. |
| `R04X-S26` | Data sheet: testo 104 folding thermometer | Testo SE & Co. KGaA | 2018-01 (document code `01.2018`) | https://media.testo.com/media/c4/61/6f5a24a66668/testo-104-Data-sheet.pdf | 2026-11-25 | “Technical data” | Published range, accuracy, resolution and moving-liquid response time. | Calibration/status of a particular acquired unit or response in a phin bed. | High. |
| `R04X-S27` | SCA's Minimum Certification Requirements for Coffee Brewers | Specialty Coffee Association | Date not stated in visible archived document; current `SCA-310` text is member-gated | https://sca.coffee/s/2017-SCA-CHB-Program-Requirements-ba6g.pdf; https://sca.coffee/research/coffee-standards | 2026-11-25 | Archived §§2–3, “Brewing Time” and “Brewing Temperature”; current public standards index | Historical automatic-brewer certification measurement point and temperature context; current index identity only. | Current `SCA-310` text, phin acceptance, Recipe approval, R04 temperature, sensory quality or extraction result. | High for archived text; low/medium for current or phin transfer. |
| `R04X-S28` | Dairy Processing Handbook: Pasteurized and ESL dairy products | Tetra Pak | Date not stated | https://dairyprocessinghandbook.tetrapak.com/chapter/pasteurized-and-esl-dairy-products | 2026-11-25 | “Whipping cream” → “The whipping method” | General pure-cream whipping variables and test method. | R04/R05 mixed-foam composition, settings or acceptance criteria. | High for cream science; low for mixed-foam transfer. |
| `R04X-S29` | OIML R 76-1:2006 — Non-automatic weighing instruments | International Organization of Legal Metrology | 2006 edition | https://www.oiml.org/en/publications/recommendations/en/files/pdf_r/r076-1-e06.pdf | 2026-11-25 | §§2.2 and 3.1.2 | Verification interval/minimum capacity concepts and relative-error warning. | Certification or fitness of `E04`, `E03` or any untested scale. | High. |

Remaining evidence gaps after this research are physical rather than web-resolvable: acquired-unit identity and condition; current calibration or documented comparison checks; Promix `Min`, repeatability and error; a verified R04 salt method; selected phin probe placement; actual foam temperature/time/output observations; exact ice identity/mass; and Owner-approved acceptance criteria. R04 and R05 still require separate execution authorization and separate physical records.
