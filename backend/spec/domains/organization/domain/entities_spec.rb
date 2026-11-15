require "spec_helper"
require_relative "../../../../app/domains/organization/domain/entities/organization"
require_relative "../../../../app/domains/organization/domain/entities/brand"
require_relative "../../../../app/domains/organization/domain/entities/branch"

RSpec.describe "Organization domain entities" do
  it "represents the established identity and relationship hierarchy without Rails" do
    branch = Organization::Domain::Entities::Branch.new(
      id: "branch-id",
      brand_id: "brand-id",
      name: "Main Branch",
      timezone_name: "Asia/Ho_Chi_Minh"
    )
    brand = Organization::Domain::Entities::Brand.new(
      id: "brand-id",
      organization_id: "organization-id",
      name: "AFTER FOUR",
      branches: [ branch ]
    )
    organization = Organization::Domain::Entities::Organization.new(
      id: "organization-id",
      name: "AFTER FOUR Organization",
      brands: [ brand ]
    )

    expect(organization.id).to eq("organization-id")
    expect(organization.brands).to contain_exactly(brand)
    expect(brand.organization_id).to eq(organization.id)
    expect(brand.branches).to contain_exactly(branch)
    expect(branch.brand_id).to eq(brand.id)
    expect(branch.timezone_name).to eq("Asia/Ho_Chi_Minh")
  end

  it "does not inherit from Active Record" do
    entity_classes = [
      Organization::Domain::Entities::Organization,
      Organization::Domain::Entities::Brand,
      Organization::Domain::Entities::Branch
    ]

    expect(entity_classes.map(&:superclass)).to all(eq(Object))
    expect(entity_classes.flat_map(&:ancestors).map(&:name)).not_to include("ApplicationRecord")
  end
end
