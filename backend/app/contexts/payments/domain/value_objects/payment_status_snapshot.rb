module Payments
  module Domain
    module ValueObjects
      class PaymentStatusSnapshot
        FUNDING_STATUSES = %w[
          unpaid partially_paid fully_paid partially_refunded fully_refunded
        ].freeze
        ATTEMPT_ACTIVITIES = %w[idle processing reconciliation_required].freeze

        attr_reader :funding_status, :attempt_activity, :target, :successful_amount,
          :refunded_amount, :lock_version

        class << self
          def validate_classification!(funding_status:, attempt_activity:, target:)
            unless FUNDING_STATUSES.include?(funding_status)
              raise ArgumentError, "Payment funding status is invalid"
            end
            unless ATTEMPT_ACTIVITIES.include?(attempt_activity)
              raise ArgumentError, "Payment attempt activity is invalid"
            end
            raise ArgumentError, "Payment target must be Money" unless target.is_a?(Money)
          end
        end

        def initialize(
          funding_status:,
          attempt_activity:,
          target:,
          successful_amount:,
          refunded_amount:,
          lock_version:
        )
          self.class.validate_classification!(
            funding_status: funding_status,
            attempt_activity: attempt_activity,
            target: target
          )

          @funding_status = funding_status
          @attempt_activity = attempt_activity
          @target = target
          @successful_amount = Integer(successful_amount)
          @refunded_amount = Integer(refunded_amount)
          @lock_version = Integer(lock_version)
          validate_state!
          freeze
        end

        def target_amount = target.amount
        def currency_code = target.currency_code

        private

        def validate_state!
          if successful_amount.negative? || refunded_amount.negative?
            raise ArgumentError, "Payment amounts are invalid"
          end
          if successful_amount > target_amount || refunded_amount > successful_amount
            raise ArgumentError, "Payment amounts exceed their allowed bounds"
          end
          raise ArgumentError, "Payment lock version must be nonnegative" if lock_version.negative?
          if funding_status == "fully_paid" && successful_amount != target_amount
            raise ArgumentError, "Fully paid Payment must equal its target"
          end
          return unless funding_status == "unpaid" && successful_amount != 0

          raise ArgumentError, "Unpaid Payment cannot contain successful funding"
        end
      end
    end
  end
end
