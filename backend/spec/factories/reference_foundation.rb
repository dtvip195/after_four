FactoryBot.define do
  factory :organization_record, class: "Organization::Infrastructure::Persistence::OrganizationRecord" do
    sequence(:name) { |number| "Test Organization #{number}" }
  end

  factory :brand_record, class: "Organization::Infrastructure::Persistence::BrandRecord" do
    association :organization, factory: :organization_record
    sequence(:name) { |number| "Test Brand #{number}" }
  end

  factory :branch_record, class: "Organization::Infrastructure::Persistence::BranchRecord" do
    association :brand, factory: :brand_record
    sequence(:name) { |number| "Test Branch #{number}" }
    timezone_name { "UTC" }
  end
end
