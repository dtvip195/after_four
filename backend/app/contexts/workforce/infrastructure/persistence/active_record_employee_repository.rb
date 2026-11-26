module Workforce
  module Infrastructure
    module Persistence
      class ActiveRecordEmployeeRepository
        include Application::Ports::EmployeeRepository

        def initialize(mapper: EmployeeMapper.new)
          @mapper = mapper
        end

        def add(employee)
          mapper.build_record(employee).save!
        rescue ActiveRecord::RecordNotUnique
          raise Application::Ports::EmployeeRepository::DuplicateEmployeeId
        end

        def find(organization_reference:, employee_id:)
          ensure_reference_types!(organization_reference, employee_id)
          record = EmployeeRecord.find_by(
            organization_id: organization_reference.to_s,
            id: employee_id.to_s
          )
          record && mapper.to_domain(record)
        end

        private

        attr_reader :mapper

        def ensure_reference_types!(organization_reference, employee_id)
          unless organization_reference.is_a?(Domain::ValueObjects::OrganizationReference)
            raise ArgumentError, "Organization reference must be OrganizationReference"
          end
          return if employee_id.is_a?(Domain::ValueObjects::EmployeeId)

          raise ArgumentError, "Employee ID must be EmployeeId"
        end
      end
    end
  end
end
