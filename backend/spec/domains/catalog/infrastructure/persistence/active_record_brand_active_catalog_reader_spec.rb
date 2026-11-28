require "rails_helper"

RSpec.describe Catalog::Infrastructure::Persistence::ActiveRecordBrandActiveCatalogReader do
  let(:brand_reference_class) { Catalog::Application::Contracts::BrandReference }
  let(:category_reference_class) { Catalog::Application::Contracts::CategoryReference }
  let(:failure_reference_value) { "33333333-3333-3333-3333-333333333333" }

  it "reads an exact Brand's brand-active Catalog in deterministic order with bounded queries" do
    brand = create(:brand_record)
    later_category = activate_category(create(:category_record, brand_record: brand, position: 2))
    earlier_category = activate_category(create(:category_record, brand_record: brand, position: 1))
    later_product = create_active_product(category: later_category, name: "Americano")
    earlier_product = create_active_product(category: earlier_category, name: "Latte", default_position: 1)
    extra_variant = create(:product_variant_record, product: earlier_product, customer_visible: false, position: 0)
    activate_variant(extra_variant)
    observed_sql = []
    subscriber = lambda do |_name, _started, _finished, _unique_id, payload|
      sql = payload.fetch(:sql).strip
      observed_sql << sql if payload.fetch(:name) != "SCHEMA" && sql.match?(/\ASELECT\b/i)
    end

    result = ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.new.read(
        brand_reference: brand_reference_class.new(brand.id), category_reference: nil, offset: 0, limit: 10
      )
    end

    expect(result).to be_found
    expect(result.total).to eq(2)
    expect(result.products.map(&:id)).to eq([ earlier_product.id, later_product.id ])
    expect(result.products.first.variants.map(&:position)).to eq([ 0, 1 ])
    expect(result.products).not_to include(ActiveRecord::Base)
    expect(observed_sql.length).to be <= 3
    expect(observed_sql.join(" ")).not_to match(/\bbranches\b/i)
  end

  it "filters by the exact typed Category without leaking another Brand or inactive records" do
    brand = create(:brand_record)
    requested_category = activate_category(create(:category_record, brand_record: brand))
    other_category = activate_category(create(:category_record, brand_record: brand))
    included = create_active_product(category: requested_category)
    excluded_category_product = create_active_product(category: other_category)
    inactive_product = create(:product_record, category: requested_category, lifecycle_status: "inactive")
    activate_variant(create(:product_variant_record, product: inactive_product, is_default: true))
    inactive_category = activate_category(create(:category_record, brand_record: brand))
    inactive_category.update!(lifecycle_status: "inactive")
    create(:product_record, category: inactive_category, lifecycle_status: "inactive")
    other_brand_product = create_active_product(category: activate_category(create(:category_record)))

    result = described_class.new.read(
      brand_reference: brand_reference_class.new(brand.id),
      category_reference: category_reference_class.new(requested_category.id),
      offset: 0,
      limit: 10
    )

    expect(result).to be_found
    expect(result.total).to eq(1)
    expect(result.products.map(&:id)).to eq([ included.id ])
  end

  it "returns a found empty page when the requested page has no active products" do
    brand = create(:brand_record)

    result = described_class.new.read(
      brand_reference: brand_reference_class.new(brand.id), category_reference: nil, offset: 10, limit: 10
    )

    expect(result).to be_found
    expect(result.products).to eq([])
    expect(result.total).to eq(0)
  end

  it "rejects untyped inputs before persistence access" do
    reader = described_class.new

    expect do
      reader.read(brand_reference: "brand", category_reference: nil, offset: 0, limit: 10)
    end.to raise_error(ArgumentError, /brand_reference/)
    expect do
      reader.read(
        brand_reference: brand_reference_class.new("11111111-1111-1111-1111-111111111111"),
        category_reference: "category", offset: 0, limit: 10
      )
    end.to raise_error(ArgumentError, /category_reference/)
  end

  it "maps only the narrow availability exception allowlist" do
    recognized = ActiveRecord::ConnectionTimeoutError.new("pool unavailable")
    reader = reader_raising(recognized)

    result = reader.read(
      brand_reference: brand_reference_class.new("11111111-1111-1111-1111-111111111111"),
      category_reference: nil, offset: 0, limit: 10
    )

    expect(result).to be_unavailable
    expect(result.failure_reference.value).to eq(failure_reference_value)

    rejected = ActiveRecord::StatementInvalid.new("bad SQL")
    expect do
      reader_raising(rejected).read(
        brand_reference: brand_reference_class.new("11111111-1111-1111-1111-111111111111"),
        category_reference: nil, offset: 0, limit: 10
      )
    end.to raise_error(ActiveRecord::StatementInvalid, "bad SQL")
  end

  def reader_raising(error)
    product_record_class = class_double(Catalog::Infrastructure::Persistence::ProductRecord)
    allow(product_record_class).to receive(:joins).with(:category).and_raise(error)
    described_class.new(
      product_record_class: product_record_class,
      failure_reference_generator: -> { failure_reference_value }
    )
  end

  def activate_category(category)
    category.update!(lifecycle_status: "active")
    category
  end

  def activate_variant(variant)
    variant.update!(lifecycle_status: "active")
    variant
  end

  def create_active_product(category:, name: nil, default_position: 0)
    attributes = { category: category, lifecycle_status: "inactive" }
    attributes[:name] = name if name
    product = create(:product_record, **attributes)
    activate_variant(
      create(
        :product_variant_record,
        product: product,
        is_default: true,
        customer_visible: true,
        position: default_position
      )
    )
    product.update!(lifecycle_status: "active")
    product
  end
end
