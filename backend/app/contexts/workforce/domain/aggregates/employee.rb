module Workforce
  module Domain
    module Aggregates
      class Employee
        attr_reader :id, :organization_reference, :lock_version

        class << self
          def create_identity(id:, organization_reference:, lock_version: 0)
            unless lock_version == 0
              raise ArgumentError, "New Employee lock version must be zero"
            end

            new(
              id: id,
              organization_reference: organization_reference,
              lock_version: lock_version
            )
          end

          def reconstitute(id:, organization_reference:, lock_version:)
            new(
              id: id,
              organization_reference: organization_reference,
              lock_version: lock_version
            )
          end

          private

          def new(id:, organization_reference:, lock_version:)
            super
          end
        end

        private

        def initialize(id:, organization_reference:, lock_version:)
          unless id.is_a?(ValueObjects::EmployeeId)
            raise ArgumentError, "Employee ID must be EmployeeId"
          end
          unless organization_reference.is_a?(ValueObjects::OrganizationReference)
            raise ArgumentError, "Organization reference must be OrganizationReference"
          end
          unless lock_version.is_a?(Integer) && lock_version >= 0
            raise ArgumentError, "Employee lock version must be a nonnegative integer"
          end

          @id = id
          @organization_reference = organization_reference
          @lock_version = lock_version
          freeze
        end
      end
    end
  end
end
