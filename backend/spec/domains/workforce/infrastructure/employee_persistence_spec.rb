require "rails_helper"

RSpec.describe "Workforce Employee foundation persistence" do
  let(:employee_id) { SecureRandom.uuid }
  let(:organization) do
    Organization::Infrastructure::Persistence::OrganizationRecord.create!(
      name: "Workforce Test Organization"
    )
  end
  let(:organization_reference) do
    Workforce::Domain::ValueObjects::OrganizationReference.new(organization.id)
  end
  let(:mapper) { Workforce::Infrastructure::Persistence::EmployeeMapper.new }
  let(:repository) do
    Workforce::Infrastructure::Persistence::ActiveRecordEmployeeRepository.new(mapper: mapper)
  end

  def build_employee(id: employee_id, organization: organization_reference)
    Workforce::Domain::Aggregates::Employee.create_identity(
      id: Workforce::Domain::ValueObjects::EmployeeId.new(id),
      organization_reference: organization
    )
  end

  it "round-trips only identity, Organization ownership, and lock version" do
    employee = build_employee
    record = mapper.build_record(employee)
    record.save!
    reconstituted = mapper.to_domain(record.reload)

    expect(record).to have_attributes(
      id: employee_id,
      organization_id: organization.id,
      lock_version: 0
    )
    expect(reconstituted).to have_attributes(
      id: employee.id,
      organization_reference: employee.organization_reference,
      lock_version: 0
    )
    expect(reconstituted).not_to respond_to(:created_at)
    expect(reconstituted).not_to respond_to(:updated_at)
  end

  it "rejects malformed persisted identity and version instead of repairing them" do
    persisted_fact = Struct.new(:id, :organization_id, :lock_version)

    expect do
      mapper.to_domain(persisted_fact.new("INVALID", organization.id, 0))
    end.to raise_error(ArgumentError, "Employee ID must be a canonical UUID")
    expect do
      mapper.to_domain(persisted_fact.new(employee_id, "INVALID", 0))
    end.to raise_error(ArgumentError, "Organization reference must be a canonical UUID")
    expect do
      mapper.to_domain(persisted_fact.new(employee_id, organization.id, -1))
    end.to raise_error(ArgumentError, "Employee lock version must be a nonnegative integer")
  end

  it "adds and finds an Employee only through Organization scope" do
    employee = build_employee
    repository.add(employee)

    found = repository.find(
      organization_reference: organization_reference,
      employee_id: employee.id
    )

    expect(found).to have_attributes(id: employee.id, organization_reference: organization_reference)
    expect(repository).not_to respond_to(:find_unscoped)
    expect(repository).not_to respond_to(:all)
  end

  it "makes wrong-Organization and unknown-Employee lookups indistinguishable" do
    employee = build_employee
    other_organization = Organization::Infrastructure::Persistence::OrganizationRecord.create!(
      name: "Other Workforce Test Organization"
    )
    repository.add(employee)

    wrong_organization = repository.find(
      organization_reference: Workforce::Domain::ValueObjects::OrganizationReference.new(other_organization.id),
      employee_id: employee.id
    )
    unknown_employee = repository.find(
      organization_reference: organization_reference,
      employee_id: Workforce::Domain::ValueObjects::EmployeeId.new(SecureRandom.uuid)
    )

    expect(wrong_organization).to be_nil
    expect(unknown_employee).to be_nil
  end

  it "isolates Employees with known identifiers across Organizations" do
    employee = build_employee
    other_organization = Organization::Infrastructure::Persistence::OrganizationRecord.create!(
      name: "Isolated Workforce Test Organization"
    )
    repository.add(employee)

    expect(
      repository.find(
        organization_reference: Workforce::Domain::ValueObjects::OrganizationReference.new(other_organization.id),
        employee_id: employee.id
      )
    ).to be_nil
  end

  it "translates duplicate Employee identity into the repository contract" do
    employee = build_employee
    repository.add(employee)

    expect { repository.add(employee) }
      .to raise_error(Workforce::Application::Ports::EmployeeRepository::DuplicateEmployeeId)
  end

  it "relies on the real Organization foreign key and restrictive deletion" do
    unknown_organization = Workforce::Domain::ValueObjects::OrganizationReference.new(SecureRandom.uuid)

    expect { repository.add(build_employee(organization: unknown_organization)) }
      .to raise_error(ActiveRecord::InvalidForeignKey)

    repository.add(build_employee)
    expect { organization.destroy! }.to raise_error(ActiveRecord::StatementInvalid) { |error|
      expect(error.cause).to be_a(PG::RestrictViolation)
    }
  end

  it "has the approved non-unique Organization index" do
    index = ActiveRecord::Base.connection.indexes(:employees).find do |candidate|
      candidate.name == "index_employees_on_organization_id"
    end

    expect(index).not_to be_nil
    expect(index.columns).to eq([ "organization_id" ])
    expect(index.unique).to be(false)
  end

  it "defaults lock version to zero and enforces the nonnegative database check" do
    record = Workforce::Infrastructure::Persistence::EmployeeRecord.create!(
      id: employee_id,
      organization_id: organization.id
    )

    expect(record.lock_version).to eq(0)
    expect do
      Workforce::Infrastructure::Persistence::EmployeeRecord.insert_all!([
        {
          id: SecureRandom.uuid,
          organization_id: organization.id,
          lock_version: -1,
          created_at: Time.current,
          updated_at: Time.current
        }
      ])
    end.to raise_error(ActiveRecord::StatementInvalid) { |error|
      expect(error.cause).to be_a(PG::CheckViolation)
    }
  end

  it "uses Active Record optimistic locking without adding a business mutation command" do
    repository.add(build_employee)
    current = Workforce::Infrastructure::Persistence::EmployeeRecord.find(employee_id)
    stale = Workforce::Infrastructure::Persistence::EmployeeRecord.find(employee_id)

    current.touch

    expect { stale.touch }.to raise_error(ActiveRecord::StaleObjectError)
  end

  it "rolls Employee persistence back with the ambient transaction" do
    employee = build_employee

    ApplicationRecord.transaction do
      repository.add(employee)
      raise ActiveRecord::Rollback
    end

    expect(Workforce::Infrastructure::Persistence::EmployeeRecord.where(id: employee.id.to_s)).to be_empty
  end

  it "does not leave a partial row when mapper extraction fails" do
    failing_mapper = Class.new do
      def build_record(_employee)
        raise "mapper failure"
      end
    end.new
    failing_repository = Workforce::Infrastructure::Persistence::ActiveRecordEmployeeRepository.new(
      mapper: failing_mapper
    )

    expect { failing_repository.add(build_employee) }.to raise_error("mapper failure")
    expect(Workforce::Infrastructure::Persistence::EmployeeRecord.where(id: employee_id)).to be_empty
  end
end
