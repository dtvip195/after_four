require "spec_helper"
require_relative "../../../../app/contexts/workforce/domain/value_objects/employee_id"
require_relative "../../../../app/contexts/workforce/domain/value_objects/organization_reference"
require_relative "../../../../app/contexts/workforce/domain/aggregates/employee"

RSpec.describe Workforce::Domain::Aggregates::Employee do
  let(:employee_id) do
    Workforce::Domain::ValueObjects::EmployeeId.new("8ea9d910-c925-4a9f-8f75-5f63229d2a65")
  end
  let(:organization_reference) do
    Workforce::Domain::ValueObjects::OrganizationReference.new("cf93a3ea-3db7-4d79-8947-c15fb376a63c")
  end

  it "creates an immutable Organization-scoped Employee identity at version zero" do
    employee = described_class.create_identity(
      id: employee_id,
      organization_reference: organization_reference
    )

    expect(employee).to have_attributes(
      id: employee_id,
      organization_reference: organization_reference,
      lock_version: 0
    )
    expect(employee).to be_frozen
    expect(employee.id).to be_frozen
    expect(employee.organization_reference).to be_frozen
  end

  it "rejects missing, malformed, or noncanonical identities" do
    invalid_values = [ nil, "", "not-a-uuid", "8EA9D910-C925-4A9F-8F75-5F63229D2A65" ]

    invalid_values.each do |invalid|
      expect { Workforce::Domain::ValueObjects::EmployeeId.new(invalid) }
        .to raise_error(ArgumentError, "Employee ID must be a canonical UUID")
      expect { Workforce::Domain::ValueObjects::OrganizationReference.new(invalid) }
        .to raise_error(ArgumentError, "Organization reference must be a canonical UUID")
    end

    expect do
      described_class.create_identity(id: nil, organization_reference: organization_reference)
    end.to raise_error(ArgumentError, "Employee ID must be EmployeeId")
    expect do
      described_class.create_identity(id: employee_id, organization_reference: nil)
    end.to raise_error(ArgumentError, "Organization reference must be OrganizationReference")
  end

  it "requires new identities to begin at version zero" do
    expect do
      described_class.create_identity(
        id: employee_id,
        organization_reference: organization_reference,
        lock_version: 1
      )
    end.to raise_error(ArgumentError, "New Employee lock version must be zero")
  end

  it "reconstitutes valid persistence state without adding lifecycle state" do
    employee = described_class.reconstitute(
      id: employee_id,
      organization_reference: organization_reference,
      lock_version: 7
    )

    expect(employee).to have_attributes(
      id: employee_id,
      organization_reference: organization_reference,
      lock_version: 7
    )
    expect(employee).not_to respond_to(:status)
    expect(employee).not_to respond_to(:user_id)
    expect(employee).not_to respond_to(:branch_id)
  end

  it "rejects invalid reconstituted versions rather than repairing them" do
    [ -1, "1", 1.5, nil ].each do |invalid|
      expect do
        described_class.reconstitute(
          id: employee_id,
          organization_reference: organization_reference,
          lock_version: invalid
        )
      end.to raise_error(ArgumentError, "Employee lock version must be a nonnegative integer")
    end
  end

  it "requires typed immutable identifiers during reconstitution" do
    expect do
      described_class.reconstitute(
        id: employee_id.to_s,
        organization_reference: organization_reference,
        lock_version: 0
      )
    end.to raise_error(ArgumentError, "Employee ID must be EmployeeId")

    expect do
      described_class.reconstitute(
        id: employee_id,
        organization_reference: organization_reference.to_s,
        lock_version: 0
      )
    end.to raise_error(ArgumentError, "Organization reference must be OrganizationReference")
  end
end
