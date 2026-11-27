#!/usr/bin/env ruby
# frozen_string_literal: true

# Read-only validation for the AFTER FOUR Commercial Foundation & Validation
# Program. Costing examples below are synthetic test fixtures only. They are
# not commercial evidence and must never be copied into canonical CSV files.

require "csv"
require "pathname"

ROOT = Pathname(__dir__).join("../../..").expand_path

MAKE_CSV = ROOT.join("docs/architecture/after_four_commercial_v1_make_recipe_bom_input.csv")
BUY_CSV = ROOT.join("docs/architecture/after_four_commercial_v1_buy_finished_procurement_input.csv")
COSTING_CSV = ROOT.join("docs/architecture/after_four_commercial_v1_costing_input.csv")
CE03 = ROOT.join("docs/research/AFTER_FOUR_COMMERCIAL_CE03_OWNER_AUTHORIZATION_BALLOT_REGISTER.md")

class ValidationFailure < StandardError; end

def assert(condition, message)
  raise ValidationFailure, message unless condition
end

def rows(path)
  CSV.read(path, headers: true)
end

def decimal(value, name)
  number = Float(value)
  raise ValidationFailure, "#{name} must be finite and non-negative" unless number.finite? && number >= 0

  number
rescue ArgumentError, TypeError
  raise ValidationFailure, "#{name} must be numeric"
end

def unit_cost(component_costs:, packaging_cost:, direct_purchase_costs:, saleable_portions:)
  costs = component_costs.map.with_index { |value, index| decimal(value, "component_costs[#{index}]") }
  packaging = decimal(packaging_cost, "packaging_cost")
  direct = decimal(direct_purchase_costs, "direct_purchase_costs")
  portions = decimal(saleable_portions, "saleable_portions")
  raise ValidationFailure, "saleable_portions must be greater than zero" unless portions.positive?

  (costs.sum + packaging + direct) / portions
end

def gross_margin(selling_price:, complete_unit_cost:)
  price = decimal(selling_price, "selling_price")
  cost = decimal(complete_unit_cost, "complete_unit_cost")
  raise ValidationFailure, "selling_price must be greater than zero" unless price.positive?

  amount = price - cost
  [amount, amount / price]
end

make = rows(MAKE_CSV)
buy = rows(BUY_CSV)
costing = rows(COSTING_CSV)

assert(make.length == 48, "MAKE row count must be 48")
assert(buy.length == 4, "BUY row count must be 4")
assert(costing.length == 52, "Costing row count must be 52")
assert(costing.map { |row| [row["product"], row["approved_variant"]] }.uniq.length == 52,
       "Costing Product/Variant keys must be unique")
assert(costing.count { |row| row["buy_vs_make_decision"] == "MAKE_IN_HOUSE" } == 48,
       "Costing MAKE count must be 48")
assert(costing.count { |row| row["buy_vs_make_decision"] == "BUY_FINISHED" } == 4,
       "Costing BUY count must be 4")
assert(costing.all? { |row| row["verification_status"] == "MISSING_INPUT" },
       "Every costing row must remain MISSING_INPUT until accepted evidence exists")
assert(costing.all? { |row| row["calculation_status"] == "NOT_CALCULABLE_MISSING_EVIDENCE" },
       "Every costing row must remain not calculable while inputs are missing")
assert(costing.all? { |row| row["unit_cost_result_vnd"].to_s.empty? && row["gross_margin_amount_vnd"].to_s.empty? && row["gross_margin_percentage"].to_s.empty? },
       "No canonical unit-cost or margin result may be populated")
assert(make.all? { |row| row["recipe_approval_status"] == "MISSING_INPUT_NOT_OWNER_APPROVED" },
       "Every MAKE row must remain unapproved")
assert(buy.all? { |row| row["verification_status"] == "MISSING_INPUT" },
       "Every BUY row must remain MISSING_INPUT")

ce03 = CE03.read
section3 = ce03[/## 3\..*?(?=\n## 4\.)/m]
section4 = ce03[/## 4\..*?(?=\n## 5\.)/m]
ballot_ids = section3.scan(/^\| `(CE03-[^`]+)` \|/).flatten
products = %w[CRO CHE BRO MUF]
buy_control_ids = products.flat_map do |product|
  %w[01 02 03 04 05 01R 03R 04R 05R].map { |suffix| "CE03-BUY-#{product}-#{suffix}" }
end
control_ids = (section4.scan(/^\| `(CE03-[^`]+)` \|/).flatten + buy_control_ids).uniq

assert(ballot_ids.length == 69 && ballot_ids.uniq.length == 69, "CE-03 must contain 69 unique stable ballot IDs")
assert(control_ids.sort == ballot_ids.sort, "Every §3 ballot must have exactly one expanded §4 control")
assert(section3.lines.grep(/^\| `CE03-/).all? { |line| line.include?("`NOT_AUTHORIZED`") && line.include?("`PENDING_OWNER_DECISION`") },
       "Every ballot must remain unauthorized and pending")
assert(ce03.include?("never -03R"), "BUY purchase must not depend on quotation recording")
assert(ce03.include?("never -04R"), "BUY receiving must not depend on transaction recording")
assert(ce03.include?("CE03-PKG-01 source evidence -> separate CE-02 acquisition-evidence acceptance"),
       "PKG-01 evidence acceptance must be independent")
assert(ce03.include?("not a prerequisite for CE03-PKG-02"),
       "PKG-01 recording must not gate the fit test")

# Reproduce the explicit ballot-to-ballot dependency graph. Evidence-acceptance
# nodes external to the ballot inventory are intentionally omitted; recording
# ballots branch from their source activity and do not feed operational stages.
edges = []
%w[R04 R05].each do |track|
  chain = %W[CE03-#{track}-01 CE03-#{track}-01Q CE03-#{track}-01P CE03-#{track}-01R
             CE03-#{track}-02 CE03-#{track}-03 CE03-#{track}-04 CE03-#{track}-05]
  edges.concat(chain.each_cons(2).to_a)
  edges << ["CE03-#{track}-05", "CE03-#{track}-05R"]
end
products.each do |product|
  prefix = "CE03-BUY-#{product}"
  edges.concat([["#{prefix}-01", "#{prefix}-02"],
                ["#{prefix}-02", "#{prefix}-03"],
                ["#{prefix}-03", "#{prefix}-04"],
                ["#{prefix}-04", "#{prefix}-05"],
                ["#{prefix}-01", "#{prefix}-01R"],
                ["#{prefix}-03", "#{prefix}-03R"],
                ["#{prefix}-04", "#{prefix}-04R"],
                ["#{prefix}-05", "#{prefix}-05R"]])
end
edges.concat([["CE03-PKG-01", "CE03-PKG-02"], ["CE03-PKG-02", "CE03-PKG-03"]])

adjacency = Hash.new { |hash, key| hash[key] = [] }
edges.each do |from, to|
  assert(ballot_ids.include?(from) && ballot_ids.include?(to), "Dependency references an unknown ballot")
  adjacency[from] << to
end
visiting = {}
visited = {}
visit = lambda do |node|
  raise ValidationFailure, "CE-03 ballot dependency cycle detected at #{node}" if visiting[node]
  return if visited[node]

  visiting[node] = true
  adjacency[node].each { |child| visit.call(child) }
  visiting.delete(node)
  visited[node] = true
end
ballot_ids.each { |id| visit.call(id) }

# Synthetic formula tests. These values are intentionally artificial.
synthetic_cost = unit_cost(component_costs: [120.0, 80.0], packaging_cost: 20.0,
                           direct_purchase_costs: 30.0, saleable_portions: 5.0)
assert((synthetic_cost - 50.0).abs < 0.000001, "Synthetic unit-cost formula failed")
synthetic_amount, synthetic_rate = gross_margin(selling_price: 100.0, complete_unit_cost: synthetic_cost)
assert((synthetic_amount - 50.0).abs < 0.000001, "Synthetic gross-profit formula failed")
assert((synthetic_rate - 0.5).abs < 0.000001, "Synthetic gross-margin formula failed")

begin
  unit_cost(component_costs: [1], packaging_cost: 0, direct_purchase_costs: 0, saleable_portions: 0)
  raise ValidationFailure, "Zero saleable portions were not rejected"
rescue ValidationFailure => error
  raise unless error.message == "saleable_portions must be greater than zero"
end

begin
  unit_cost(component_costs: [nil], packaging_cost: 0, direct_purchase_costs: 0, saleable_portions: 1)
  raise ValidationFailure, "Missing component input was not rejected"
rescue ValidationFailure => error
  raise unless error.message == "component_costs[0] must be numeric"
end

begin
  gross_margin(selling_price: 0, complete_unit_cost: 1)
  raise ValidationFailure, "Zero selling price was not rejected"
rescue ValidationFailure => error
  raise unless error.message == "selling_price must be greater than zero"
end

puts "PASS: commercial baseline, CE-03 controls, and synthetic costing tests"
