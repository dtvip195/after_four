# AFTER FOUR — R04/R05 Market Price Research

**Observation date:** 2026-11-25

**Evidence status:** `MARKET_REFERENCE_ONLY`
**Scope:** Public Vietnamese retail listings for planning the first `CM-R04-01` and `CM-R05-01` trials. No listing is an approved Ingredient, supplier, quotation, transaction, landed cost, Recipe/BOM cost, or margin input.

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
