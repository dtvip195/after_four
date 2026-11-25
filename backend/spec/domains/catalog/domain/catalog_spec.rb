require "spec_helper"
require_relative "../../../../app/contexts/catalog/domain/value_objects/catalog_code"
require_relative "../../../../app/contexts/catalog/domain/entities/category"
require_relative "../../../../app/contexts/catalog/domain/entities/variant"
require_relative "../../../../app/contexts/catalog/domain/aggregates/product"

RSpec.describe "Catalog domain" do
  describe Catalog::Domain::ValueObjects::CatalogCode do
    it "canonicalizes valid ASCII input" do
      code = described_class.new(" \tcoffee_01-iced\n")

      expect(code.to_s).to eq("COFFEE_01-ICED")
      expect(code).to eq(described_class.new("COFFEE_01-ICED"))
    end

    it "rejects invalid and oversized values" do
      [ nil, "", "   ", "cà-phê", "COFFEE SIZE", "COFFEE!", "A" * 65 ].each do |value|
        expect { described_class.new(value) }.to raise_error(ArgumentError)
      end
    end
  end

  it "represents Category and Variant state without Rails" do
    category = Catalog::Domain::Entities::Category.new(
      id: "category-id",
      brand_id: "brand-id",
      code: "coffee",
      name: "Coffee",
      position: 1,
      lifecycle_status: "draft",
      lock_version: 0
    )
    variant = Catalog::Domain::Entities::Variant.new(
      id: "variant-id",
      brand_id: "brand-id",
      product_id: "product-id",
      code: "default",
      name: "Default",
      position: 0,
      lifecycle_status: "active",
      is_default: true,
      customer_visible: false,
      lock_version: 0
    )

    expect(category.code.to_s).to eq("COFFEE")
    expect(category.lifecycle_status).to eq("draft")
    expect(variant.code.to_s).to eq("DEFAULT")
    expect(variant).to be_default
    expect(variant).not_to be_customer_visible
  end

  it "accepts a hidden Active Default for an Active Product" do
    product = build_product(
      lifecycle_status: "active",
      variants: [ build_variant(lifecycle_status: "active", is_default: true, customer_visible: false) ]
    )

    expect(product.default_variant).to have_attributes(lifecycle_status: "active", customer_visible: false)
  end

  it "allows zero or one designated Default for a non-Active Product" do
    expect(build_product(lifecycle_status: "draft", variants: []).default_variant).to be_nil
    expect(
      build_product(lifecycle_status: "inactive", variants: [ build_variant(is_default: true) ]).default_variant
    ).to be_default
  end

  it "rejects invalid Product aggregate final state" do
    invalid_variant_sets = [
      [],
      [ build_variant(lifecycle_status: "inactive", is_default: true) ],
      [ build_variant(is_default: false) ],
      [ build_variant(is_default: true), build_variant(id: "variant-2", code: "SECOND", is_default: true) ]
    ]

    invalid_variant_sets.each do |variants|
      expect do
        build_product(lifecycle_status: "active", variants: variants)
      end.to raise_error(ArgumentError)
    end

    expect do
      build_product(
        lifecycle_status: "draft",
        variants: [ build_variant(is_default: true), build_variant(id: "variant-2", code: "SECOND", is_default: true) ]
      )
    end.to raise_error(ArgumentError)
  end

  it "rejects invalid lifecycle vocabulary and cross-aggregate Variant identity" do
    expect { build_variant(lifecycle_status: "retired") }.to raise_error(ArgumentError)
    expect do
      build_product(variants: [ build_variant(product_id: "another-product") ])
    end.to raise_error(ArgumentError)
    expect do
      build_product(variants: [ build_variant(brand_id: "another-brand") ])
    end.to raise_error(ArgumentError)
  end

  it "keeps Domain types independent of Rails and Active Record" do
    domain_classes = [
      Catalog::Domain::ValueObjects::CatalogCode,
      Catalog::Domain::Entities::Category,
      Catalog::Domain::Entities::Variant,
      Catalog::Domain::Aggregates::Product
    ]

    expect(domain_classes.map(&:superclass)).to all(eq(Object))
    expect(domain_classes.flat_map(&:ancestors).map(&:name)).not_to include("ApplicationRecord")
  end

  def build_product(lifecycle_status: "draft", variants: [])
    Catalog::Domain::Aggregates::Product.new(
      id: "product-id",
      brand_id: "brand-id",
      category_id: "category-id",
      code: "LATTE",
      name: "Latte",
      description: nil,
      lifecycle_status: lifecycle_status,
      lock_version: 0,
      variants: variants
    )
  end

  def build_variant(
    id: "variant-id",
    brand_id: "brand-id",
    product_id: "product-id",
    code: "DEFAULT",
    lifecycle_status: "draft",
    is_default: false,
    customer_visible: false
  )
    Catalog::Domain::Entities::Variant.new(
      id: id,
      brand_id: brand_id,
      product_id: product_id,
      code: code,
      name: "Default",
      position: 0,
      lifecycle_status: lifecycle_status,
      is_default: is_default,
      customer_visible: customer_visible,
      lock_version: 0
    )
  end
end
