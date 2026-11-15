FactoryBot.define do
  factory :category_record, class: "Catalog::Infrastructure::Persistence::CategoryRecord" do
    transient do
      brand_record { association(:brand_record) }
    end

    brand_id { brand_record.id }
    sequence(:code) { |number| "CATEGORY_#{number}" }
    sequence(:name) { |number| "Test Category #{number}" }
    position { 0 }
    lifecycle_status { "draft" }
  end

  factory :product_record, class: "Catalog::Infrastructure::Persistence::ProductRecord" do
    association :category, factory: :category_record
    brand_id { category.brand_id }
    sequence(:code) { |number| "PRODUCT_#{number}" }
    sequence(:name) { |number| "Test Product #{number}" }
    description { nil }
    lifecycle_status { "draft" }
  end

  factory :product_variant_record, class: "Catalog::Infrastructure::Persistence::ProductVariantRecord" do
    association :product, factory: :product_record
    brand_id { product.brand_id }
    sequence(:code) { |number| "VARIANT_#{number}" }
    sequence(:name) { |number| "Test Variant #{number}" }
    position { 0 }
    lifecycle_status { "draft" }
    is_default { false }
    customer_visible { false }
  end
end
