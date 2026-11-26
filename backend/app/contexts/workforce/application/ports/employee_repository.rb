module Workforce
  module Application
    module Ports
      module EmployeeRepository
        class DuplicateEmployeeId < StandardError; end

        def add(_employee)
          raise NotImplementedError
        end

        def find(organization_reference:, employee_id:)
          raise NotImplementedError
        end
      end
    end
  end
end
