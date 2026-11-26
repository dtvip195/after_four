module Workforce
  module Infrastructure
    module Persistence
      class EmployeeMapper
        def to_domain(record)
          Domain::Aggregates::Employee.reconstitute(
            id: Domain::ValueObjects::EmployeeId.new(record.id),
            organization_reference: Domain::ValueObjects::OrganizationReference.new(record.organization_id),
            lock_version: record.lock_version
          )
        end

        def build_record(employee)
          EmployeeRecord.new(
            id: employee.id.to_s,
            organization_id: employee.organization_reference.to_s,
            lock_version: employee.lock_version
          )
        end
      end
    end
  end
end
