require "rails_helper"

RSpec.describe "A1 reference persistence records" do
  let(:organization_record_class) { Organization::Infrastructure::Persistence::OrganizationRecord }
  let(:brand_record_class) { Organization::Infrastructure::Persistence::BrandRecord }
  let(:branch_record_class) { Organization::Infrastructure::Persistence::BranchRecord }

  it "creates multiple synthetic Organization records" do
    first = create(:organization_record)
    second = create(:organization_record)

    expect(first).to be_persisted
    expect(second).to be_persisted
    expect(second.name).not_to eq(first.name)
  end

  it "creates multiple Brand records for one Organization" do
    organization = create(:organization_record)
    first = create(:brand_record, organization: organization)
    second = create(:brand_record, organization: organization)

    expect(organization.brands).to contain_exactly(first, second)
  end

  it "creates multiple synthetic Branch records for one Brand" do
    brand = create(:brand_record)
    first = create(:branch_record, brand: brand)
    second = create(:branch_record, brand: brand)

    expect(brand.branches).to contain_exactly(first, second)
    expect(first.timezone_name).to eq("UTC")
  end

  it "maps records to Domain Entities while preserving identity and relationships" do
    organization = create(:organization_record)
    brand = create(:brand_record, organization: organization)
    branch = create(:branch_record, brand: brand)

    domain_organization = organization.to_domain
    domain_brand = domain_organization.brands.fetch(0)
    domain_branch = domain_brand.branches.fetch(0)

    expect(domain_organization).to be_a(Organization::Domain::Entities::Organization)
    expect(domain_organization.id).to eq(organization.id)
    expect(domain_brand).to be_a(Organization::Domain::Entities::Brand)
    expect(domain_brand.id).to eq(brand.id)
    expect(domain_brand.organization_id).to eq(organization.id)
    expect(domain_branch).to be_a(Organization::Domain::Entities::Branch)
    expect(domain_branch.id).to eq(branch.id)
    expect(domain_branch.brand_id).to eq(brand.id)
  end

  it "allows duplicate names because names are not business identifiers" do
    organization = create(:organization_record, name: "Duplicate Name")
    create(:organization_record, name: organization.name)

    brand = create(:brand_record, name: "Duplicate Name")
    create(:brand_record, organization: brand.organization, name: brand.name)

    branch = create(:branch_record, name: "Duplicate Name")
    create(:branch_record, brand: branch.brand, name: branch.name)

    expect(organization_record_class.where(name: "Duplicate Name").count).to eq(2)
    expect(brand_record_class.where(name: "Duplicate Name").count).to eq(2)
    expect(branch_record_class.where(name: "Duplicate Name").count).to eq(2)
  end

  it "restricts dependent destruction through the persistence associations" do
    brand = create(:brand_record)
    branch = create(:branch_record, brand: brand)

    expect { brand.organization.destroy! }.to raise_error(ActiveRecord::DeleteRestrictionError)
    expect { brand.destroy! }.to raise_error(ActiveRecord::DeleteRestrictionError)
    expect(branch.reload).to be_persisted
  end

  it "uses lock_version for optimistic locking" do
    organization = create(:organization_record)
    stale_copy = organization_record_class.find(organization.id)
    organization.update!(name: "Updated Test Organization")

    expect do
      stale_copy.update!(name: "Stale Test Organization")
    end.to raise_error(ActiveRecord::StaleObjectError)
  end

  it "mirrors the database nonblank policy in persistence validation" do
    expect(build(:organization_record, name: " \t\n\r\f\v")).not_to be_valid
    expect(build(:brand_record, name: " \t\n\r\f\v")).not_to be_valid
    expect(build(:branch_record, name: " \t\n\r\f\v")).not_to be_valid
    expect(build(:branch_record, timezone_name: " \t\n\r\f\v")).not_to be_valid
  end
end
