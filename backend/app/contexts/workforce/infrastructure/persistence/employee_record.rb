module Workforce
  module Infrastructure
    module Persistence
      class EmployeeRecord < ApplicationRecord
        self.table_name = "employees"
      end
    end
  end
end
