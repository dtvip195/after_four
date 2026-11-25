require "digest"

module Orders
  module Application
    module UseCases
      class CreateDraft
        include InputValidation

        Result = Data.define(:order, :payment_reference, :replayed)

        def initialize(
          order_repository:,
          payment_gateway:,
          audit_log:,
          unit_of_work:,
          id_generator:,
          order_number_token_generator:
        )
          @order_repository = order_repository
          @payment_gateway = payment_gateway
          @audit_log = audit_log
          @unit_of_work = unit_of_work
          @id_generator = id_generator
          @order_number_token_generator = order_number_token_generator
        end

        def call(actor_id:, branch_id:, channel:, total_amount:, currency_code:, idempotency_key:, now:)
          input = normalize(
            actor_id: actor_id,
            branch_id: branch_id,
            channel: channel,
            total_amount: total_amount,
            currency_code: currency_code,
            idempotency_key: idempotency_key
          )
          existing = order_repository.find_by_creation_key(
            branch_id: input.fetch(:branch_id),
            idempotency_key: input.fetch(:idempotency_key)
          )
          return replay(existing, input) if existing

          order_number = Domain::ValueObjects::OrderNumber.generate(token: order_number_token_generator.call)
          request_fingerprint = fingerprint(input)
          order = build_order(input, order_number, request_fingerprint, now)
          payment_reference = nil
          unit_of_work.call do
            order_repository.add(order)
            payment_reference = payment_gateway.create_target(
              order_id: order.id.to_s,
              amount: order.total.amount,
              currency_code: order.total.currency_code,
              now: now
            )
            audit_log.order_created(order: order, actor_id: input.fetch(:actor_id), now: now)
          end
          Result.new(order: order, payment_reference: payment_reference, replayed: false)
        rescue Ports::OrderRepository::DuplicateCreationKey
          replay(
            order_repository.find_by_creation_key(
              branch_id: input.fetch(:branch_id),
              idempotency_key: input.fetch(:idempotency_key)
            ),
            input
          )
        end

        private

        attr_reader :order_repository, :payment_gateway, :audit_log, :unit_of_work,
          :id_generator, :order_number_token_generator

        def normalize(actor_id:, branch_id:, channel:, total_amount:, currency_code:, idempotency_key:)
          {
            actor_id: require_actor!(actor_id),
            branch_id: require_branch!(branch_id),
            idempotency_key: require_idempotency_key!(idempotency_key),
            channel: channel.to_s,
            total_amount: Integer(total_amount),
            currency_code: currency_code.to_s.upcase
          }
        end

        def build_order(input, order_number, request_fingerprint, now)
          Domain::Aggregates::Order.draft(
            id: id_generator.call,
            branch_id: input.fetch(:branch_id),
            created_by_actor_id: input.fetch(:actor_id),
            order_number: order_number,
            channel: Domain::ValueObjects::ServiceChannel.new(input.fetch(:channel)),
            total: Domain::ValueObjects::Money.new(
              amount: input.fetch(:total_amount),
              currency_code: input.fetch(:currency_code)
            ),
            creation_idempotency_key: input.fetch(:idempotency_key),
            creation_request_fingerprint: request_fingerprint,
            created_at: now
          )
        rescue ArgumentError => error
          raise Errors::InvalidDraft.new(
            attributes: {
              branch_id: input.fetch(:branch_id),
              created_by_actor_id: input.fetch(:actor_id),
              order_number: order_number.to_s,
              channel: input.fetch(:channel),
              status: "draft",
              total_amount: input.fetch(:total_amount),
              currency_code: input.fetch(:currency_code),
              creation_idempotency_key: input.fetch(:idempotency_key),
              creation_request_fingerprint: request_fingerprint,
              created_at: now,
              updated_at: now
            }
          )
        end

        def replay(order, input)
          unless order && order.creation_request_fingerprint == fingerprint(input)
            raise Domain::Errors::RuleViolation.new(
              "idempotency_conflict",
              "Idempotency key was already used with different draft creation input"
            )
          end

          Result.new(
            order: order,
            payment_reference: payment_gateway.reference_for_order(order_id: order.id.to_s),
            replayed: true
          )
        end

        def fingerprint(input)
          canonical_input = [
            "after_four.order.create.v1",
            input.fetch(:actor_id),
            input.fetch(:channel),
            input.fetch(:total_amount).to_s,
            input.fetch(:currency_code)
          ].join("\n")
          Digest::SHA256.hexdigest(canonical_input)
        end
      end
    end
  end
end
