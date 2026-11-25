module Payments
  module Infrastructure
    module Persistence
      class ActiveRecordPaymentRepository
        include Application::Ports::PaymentRepository

        def initialize(mapper: PaymentMapper.new)
          @mapper = mapper
          @locked_records = {}
        end

        def lock_by_order_id(order_id)
          record = PaymentRecord.lock.find_by!(order_id: order_id.to_s)
          locked_records[record.id.to_s] = record
          mapper.to_domain(record)
        end

        def save(payment)
          record = locked_records.fetch(payment.id.to_s) do
            raise Application::Ports::PaymentRepository::PaymentNotLocked,
              "Payment must be locked through this repository before it can be saved"
          end
          persisted_attempt_ids = record.payment_attempt_records.pluck(:id).map(&:to_s)
          payment.attempts.each do |attempt|
            if persisted_attempt_ids.include?(attempt.id.to_s)
              attempt_record = record.payment_attempt_records.lock.find(attempt.id.to_s)
              mapper.apply_attempt(attempt, attempt_record)
              attempt_record.save! if attempt_record.changed?
            else
              PaymentAttemptRecord.create!(mapper.attempt_attributes(attempt))
            end
          end
          mapper.apply(payment, record).save!
        end

        private

        attr_reader :mapper, :locked_records
      end
    end
  end
end
