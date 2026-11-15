require "rails_helper"

RSpec.describe "Catalog persistence records" do
  let(:category_record_class) { Catalog::Infrastructure::Persistence::CategoryRecord }
  let(:product_record_class) { Catalog::Infrastructure::Persistence::ProductRecord }
  let(:variant_record_class) { Catalog::Infrastructure::Persistence::ProductVariantRecord }

  it "persists synthetic Catalog relationships within one Brand" do
    category = create(:category_record)
    product = create(:product_record, category: category)
    variant = create(:product_variant_record, product: product)

    expect(category.products).to contain_exactly(product)
    expect(product.product_variants).to contain_exactly(variant)
    expect(product.brand_id).to eq(category.brand_id)
    expect(variant.brand_id).to eq(product.brand_id)
  end

  it "projects Category and Variant records to framework-independent Domain entities" do
    category = create(:category_record, code: "COFFEE")
    product = create(:product_record, category: category)
    variant = create(
      :product_variant_record,
      product: product,
      code: "DEFAULT",
      is_default: true,
      customer_visible: false
    )

    domain_category = category.to_domain
    domain_variant = variant.to_domain

    expect(domain_category).to be_a(Catalog::Domain::Entities::Category)
    expect(domain_category).to have_attributes(id: category.id, brand_id: category.brand_id)
    expect(domain_category.code.to_s).to eq("COFFEE")
    expect(domain_variant).to be_a(Catalog::Domain::Entities::Variant)
    expect(domain_variant).to have_attributes(id: variant.id, product_id: product.id)
    expect(domain_variant).to be_default
    expect(domain_variant).not_to be_customer_visible
  end

  it "mirrors database-aligned validation without normalizing persistence input" do
    category = build(:category_record, code: "lowercase")
    product = build(:product_record, code: "PRODUCT CODE")
    variant = build(:product_variant_record, code: "CÀ_PHÊ")

    expect(category).not_to be_valid
    expect(product).not_to be_valid
    expect(variant).not_to be_valid
  end

  it "restricts dependent destruction in persistence associations" do
    category = create(:category_record)
    product = create(:product_record, category: category)
    create(:product_variant_record, product: product)

    expect { category.destroy! }.to raise_error(ActiveRecord::DeleteRestrictionError)
    expect { product.destroy! }.to raise_error(ActiveRecord::DeleteRestrictionError)
  end

  it "uses optimistic locking" do
    category = create(:category_record)
    stale = category_record_class.find(category.id)
    category.update!(name: "Updated Category")

    expect { stale.update!(name: "Stale Category") }.to raise_error(ActiveRecord::StaleObjectError)
  end

  it "keeps persistence records namespaced under Catalog Infrastructure" do
    expect(category_record_class.table_name).to eq("categories")
    expect(product_record_class.table_name).to eq("products")
    expect(variant_record_class.table_name).to eq("product_variants")
    expect(category_record_class.ancestors).to include(ApplicationRecord)
  end
end
