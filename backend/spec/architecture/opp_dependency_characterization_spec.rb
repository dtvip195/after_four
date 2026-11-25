require "rails_helper"
require "prism"

RSpec.describe "ADR-0012 Ordering, Payment, and Preparation dependency baseline" do
  class DependencyScanner < Prism::Visitor
    PERSISTENCE_METHODS = %i[
      all first take where joins pluck exists? find find_by find_by! find_each new create create!
      insert_all insert_all! upsert upsert_all update update! update_all save save!
      delete delete_all destroy destroy_all connection lock transaction
    ].freeze

    class AliasCollector < Prism::Visitor
      attr_reader :aliases

      def initialize
        super
        @aliases = {}
      end

      def visit_constant_write_node(node)
        target = DependencyScanner.constant_name(node.value)
        aliases[DependencyScanner.normalize_constant_path(node.name)] = target if target
        super
      end
    end

    ASSOCIATION_LOAD_METHODS = %i[
      belongs_to has_one has_many includes preload eager_load joins left_joins
    ].freeze

    attr_reader :constant_paths, :calls, :association_names

    def initialize(source)
      super()
      @constant_paths = []
      @calls = []
      @association_names = []
      result = Prism.parse(source)
      raise result.errors.map(&:message).join("; ") unless result.success?

      collector = AliasCollector.new
      result.value.accept(collector)
      @aliases = collector.aliases
      result.value.accept(self)
    end

    def visit_constant_read_node(node)
      constant_paths << resolve(self.class.constant_name(node))
      super
    end

    def visit_constant_path_node(node)
      constant_paths << resolve(self.class.constant_name(node))
      super
    end

    def visit_call_node(node)
      receiver = resolve(self.class.constant_receiver(node.receiver))
      calls << [ receiver, node.name ] if receiver
      calls << [ nil, node.name ] unless receiver
      if ASSOCIATION_LOAD_METHODS.include?(node.name)
        node.arguments&.arguments&.each do |argument|
          association_names << argument.value.to_sym if argument.is_a?(Prism::SymbolNode)
        end
      end
      super
    end

    def references?(*names)
      roots = names.map(&:to_s)
      constant_paths.any? do |path|
        roots.any? { |name| path == name || path.start_with?("#{name}::") }
      end
    end

    def calls_persistence_on?(*names)
      roots = names.map(&:to_s)
      calls.any? do |receiver, method|
        receiver && PERSISTENCE_METHODS.include?(method) &&
          roots.any? { |name| receiver == name || receiver.start_with?("#{name}::") }
      end
    end

    def calls_method?(name)
      calls.any? { |_receiver, method| method == name }
    end

    def references_association?(name)
      association_names.include?(name)
    end

    def self.constant_name(node)
      case node
      when Prism::ConstantReadNode
        normalize_constant_path(node.name)
      when Prism::ConstantPathNode
        normalize_constant_path(node.full_name)
      end
    end

    def self.constant_receiver(node)
      case node
      when Prism::ConstantReadNode, Prism::ConstantPathNode
        constant_name(node)
      when Prism::CallNode
        constant_receiver(node.receiver)
      end
    end

    def self.normalize_constant_path(path)
      path.to_s.sub(/\A::/, "")
    end

    private

    def resolve(path, seen = [])
      return unless path

      normalized = self.class.normalize_constant_path(path)
      root, *rest = normalized.split("::")
      return normalized if seen.include?(root)

      alias_target = @aliases[root]
      resolved_root = alias_target ? resolve(alias_target, seen + [ root ]) : root
      ([ resolved_root ] + rest).join("::")
    end
  end

  # This is an explicit legacy allowlist, not an exception to ADR-0012. Each entry
  # must disappear during its context's authorized model-replacement phase. Exact
  # comparison prevents a new file from silently introducing the same dependency.
  LEGACY_CROSS_CONTEXT_FILES = {
    ordering_to_payment: [],
    payment_to_ordering: [],
    payment_to_preparation: [],
    preparation_to_ordering: [],
    preparation_to_payment: []
  }.freeze

  TECHNICAL_FACILITY_ADAPTER_FILES = {
    audit: %w[
      app/contexts/orders/infrastructure/adapters/active_record_audit_log.rb
      app/contexts/payments/infrastructure/adapters/active_record_audit_log.rb
      app/contexts/preparation/infrastructure/adapters/active_record_audit_log.rb
    ],
    outbox: %w[
      app/contexts/preparation/infrastructure/adapters/active_record_outbox.rb
    ]
  }.freeze

  ORDERING_INFRASTRUCTURE_CROSS_CONTEXT_FILES = {
    payment: [],
    preparation: %w[
      app/contexts/orders/infrastructure/adapters/preparation_order_dispatch_gateway.rb
    ]
  }.freeze
  INFRASTRUCTURE_CONTRACT_REFERENCES = {
    "orders" => {
      "payments" => {},
      "preparation" => {
        "app/contexts/orders/infrastructure/adapters/preparation_order_dispatch_gateway.rb" =>
          %w[Preparation::Application::Ports]
      }
    },
    "payments" => {
      "orders" => {
        "app/contexts/payments/infrastructure/adapters/ordering_payment_gateway.rb" =>
          %w[Orders::Application::Ports]
      },
      "preparation" => {
        "app/contexts/payments/infrastructure/adapters/preparation_payment_settlement_gateway.rb" =>
          %w[Preparation::Application::Ports]
      }
    },
    "preparation" => {
      "orders" => {},
      "payments" => {}
    }
  }.freeze
  REMOVED_ORDERING_FACADES = %w[
    Orders::CreateDraft
    Orders::Confirm
    Orders::Hold
    Orders::ExpirePending
  ].freeze
  REMOVED_PAYMENT_FACADES = %w[
    Payments::Confirm
    Payments::ConfirmCash
    Payments::ConfirmBankTransfer
  ].freeze
  REMOVED_PREPARATION_FACADES = %w[
    Preparation::RequestDispatch
    Preparation::RetryDispatch
  ].freeze

  it "records the exact current cross-context persistence violations" do
    actual = {
      ordering_to_payment: files_with_dependency("orders", constants: %w[Payment PaymentAttempt PaymentReviewCase], association: :payment),
      payment_to_ordering: files_with_dependency("payments", constants: %w[Order]),
      payment_to_preparation: files_with_dependency("payments", constants: %w[PreparationDispatch]),
      preparation_to_ordering: files_with_dependency("preparation", constants: %w[Order]),
      preparation_to_payment: files_with_dependency("preparation", constants: %w[Payment], association: :payment)
    }

    expect(actual).to eq(LEGACY_CROSS_CONTEXT_FILES)
  end

  it "keeps direct Audit and Outbox access in explicit Infrastructure adapters" do
    actual = {
      audit: all_context_files_matching(/\bAuditEvent\b/),
      outbox: all_context_files_matching(/\bOutboxEvent\b/)
    }

    expect(actual).to eq(TECHNICAL_FACILITY_ADAPTER_FILES)
  end

  it "keeps newly introduced Domain and Application layers independent of Rails persistence" do
    expect(target_layer_files).not_to be_empty

    target_layer_files.each do |path|
      scanner = scan(path)
      expect(scanner).not_to reference_forbidden_layer_dependency(relative(path)), relative(path)
    end
  end

  it "keeps Ordering Infrastructure cross-context references limited to explicit composition" do
    actual = {
      payment: ordering_infrastructure_files.select do |path|
        ordering_infrastructure_cross_context_dependency?(scan(path), :payment)
      end.map { |path| relative(path) },
      preparation: ordering_infrastructure_files.select do |path|
        ordering_infrastructure_cross_context_dependency?(scan(path), :preparation)
      end.map { |path| relative(path) }
    }

    expect(actual).to eq(ORDERING_INFRASTRUCTURE_CROSS_CONTEXT_FILES)
  end

  it "keeps every Infrastructure cross-context reference on an explicit Application contract" do
    INFRASTRUCTURE_CONTRACT_REFERENCES.each do |source_context, target_contracts|
      target_contracts.each do |target_context, expected_files|
        actual_files = infrastructure_files(source_context).select do |path|
          cross_context_infrastructure_dependency?(scan(path), target_context)
        end
        actual = actual_files.to_h do |path|
          [ relative(path), cross_context_constant_paths(scan(path), target_context) ]
        end

        expect(actual.keys).to match_array(expected_files.keys), "#{source_context} -> #{target_context}"
        actual.each do |path, references|
          allowed_prefixes = expected_files.fetch(path)
          expect(references).not_to be_empty, path
          expect(references).to all(satisfy { |reference|
            allowed_prefixes.any? do |prefix|
              reference == prefix ||
                reference.start_with?("#{prefix}::") ||
                prefix.start_with?("#{reference}::")
            end
          }), "#{path}: #{references.inspect}"
        end
      end
    end
  end

  it "detects prohibited namespaced persistence and association paths from every Infrastructure context" do
    fixtures = {
      [ "orders", "payments" ] => [
        "Payments::Infrastructure::Persistence::PaymentRecord.lock.find(id)",
        "belongs_to :payment"
      ],
      [ "orders", "preparation" ] => [
        "Preparation::Infrastructure::Persistence::DispatchRecord.find(id)",
        "has_one :preparation_dispatch"
      ],
      [ "payments", "orders" ] => [
        "Orders::Infrastructure::Persistence::OrderRecord.lock.find(id)",
        "belongs_to :order"
      ],
      [ "payments", "preparation" ] => [
        "Preparation::Infrastructure::Persistence::DispatchRecord.find_by(order_id: id)",
        "has_one :preparation_dispatch"
      ],
      [ "preparation", "orders" ] => [
        "OrderStore = Orders::Infrastructure::Persistence::OrderRecord\nOrderStore.find(id)",
        "belongs_to :order"
      ],
      [ "preparation", "payments" ] => [
        "PaymentStore = ::Payments::Infrastructure::Persistence::PaymentRecord\nPaymentStore.where(order_id: id)",
        "belongs_to :payment"
      ]
    }

    fixtures.each do |(_source_context, target_context), sources|
      sources.each do |source|
        expect(cross_context_infrastructure_dependency?(DependencyScanner.new(source), target_context))
          .to be(true), source
      end
    end
  end

  it "detects namespaced, aliased, chained, and association-based Infrastructure bypasses" do
    payment_bypasses = [
      "Payments::Infrastructure::Persistence::PaymentRecord.first",
      "::Payments::Domain::Aggregates::Payment.new",
      "PaymentStore = Payments::Infrastructure::Persistence::PaymentRecord\nPaymentStore.upsert_all([])",
      "Payment.transaction { Payment.take }",
      "order.payment",
      "Order.joins(:payment).pluck(:id)"
    ]
    preparation_bypasses = [
      "Preparation::Infrastructure::Persistence::DispatchRecord.take",
      "DispatchStore = ::Preparation::Infrastructure::Persistence::DispatchRecord\nDispatchStore.insert_all([])",
      "order.preparation_dispatch"
    ]

    payment_bypasses.each do |source|
      expect(ordering_infrastructure_cross_context_dependency?(DependencyScanner.new(source), :payment))
        .to be(true), source
    end
    preparation_bypasses.each do |source|
      expect(ordering_infrastructure_cross_context_dependency?(DependencyScanner.new(source), :preparation))
        .to be(true), source
    end
  end

  it "allows Ordering Infrastructure to use its own layers and persistence" do
    source = <<~RUBY
      Orders::Infrastructure::Persistence::OrderRecord.where(status: "draft").first
      Orders::Domain::Aggregates::Order
      Orders::Application::Ports::OrderRepository
    RUBY
    scanner = DependencyScanner.new(source)

    expect(ordering_infrastructure_cross_context_dependency?(scanner, :payment)).to be(false)
    expect(ordering_infrastructure_cross_context_dependency?(scanner, :preparation)).to be(false)
  end

  it "rejects representative dependency aliases and persistence bypasses" do
    forbidden = [
      "Payment.where(status: 'unpaid')",
      "Payment.new",
      "Persistence = Payment\nPersistence.find(1)",
      "Persistence = ::Payment\nPersistence.all.where(status: 'unpaid')",
      "def load_rows; Persistence.where(status: 'unpaid'); end\nPersistence = Payment",
      "OrderRecord.find(1)",
      "Orders::Infrastructure::Persistence::OrderRecord.find(1)",
      "Infrastructure::SomeAdapter.call",
      "Order.all.where(status: 'draft')",
      "Order.joins(:payment).pluck(:id)",
      "Order.exists?(id: 1)",
      "Order.update_all(status: 'held')",
      "Order.delete_all",
      "Order.find_each { |order| order }",
      "PaymentReviewCase.where(status: 'open')",
      "AuditEvent.pluck(:id)",
      "Payments::Application::UseCases::Confirm.call",
      "Preparation::Application::UseCases::Dispatch.call",
      "Framework = Rails\nFramework.cache",
      "Framework = ::Rails\nFramework.cache",
      "Database = PG\nDatabase::Connection",
      "Database = ::PG\nDatabase::Connection"
    ]

    forbidden.each do |source|
      expect(DependencyScanner.new(source)).to reference_forbidden_layer_dependency, source
    end
  end

  it "allows Domain and Application code that depends only on owned abstractions" do
    source = <<~RUBY
      module Orders
        module Application
          class Confirm
            def initialize(order_repository:)
              @order_repository = order_repository
            end

            def call
              Orders::Domain::ValueObjects::Money.new(amount: 23_000, currency_code: "VND")
              @order_repository.find_by_creation_key(branch_id: "branch", idempotency_key: "key")
            end
          end
        end
      end
    RUBY

    expect(DependencyScanner.new(source)).not_to(
      reference_forbidden_layer_dependency("app/contexts/orders/application/example.rb")
    )
  end

  it "implements Ordering-owned ports only in Infrastructure adapters" do
    expect(
      Orders::Infrastructure::Persistence::ActiveRecordOrderRepository.ancestors
    ).to include(Orders::Application::Ports::OrderRepository)
    expect(
      Orders::Infrastructure::Persistence::ActiveRecordUnitOfWork.ancestors
    ).to include(Orders::Application::Ports::UnitOfWork)
    expect(
      Orders::Infrastructure::Adapters::ActiveRecordAuditLog.ancestors
    ).to include(Orders::Application::Ports::AuditLog)
    expect(
      Payments::Infrastructure::Adapters::OrderingPaymentGateway.ancestors
    ).to include(Orders::Application::Ports::PaymentGateway)
    expect(
      Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway.ancestors
    ).to include(Orders::Application::Ports::OrderSettlementGateway)
  end

  it "implements Payment and Preparation ports only in Infrastructure adapters" do
    expect(
      Payments::Infrastructure::Persistence::ActiveRecordPaymentRepository.ancestors
    ).to include(Payments::Application::Ports::PaymentRepository)
    expect(
      Payments::Infrastructure::Persistence::ActiveRecordUnitOfWork.ancestors
    ).to include(Payments::Application::Ports::UnitOfWork)
    expect(
      Payments::Infrastructure::Adapters::ActiveRecordAuditLog.ancestors
    ).to include(Payments::Application::Ports::AuditLog)
    expect(
      Payments::Infrastructure::Adapters::ActiveRecordReviewCaseGateway.ancestors
    ).to include(Payments::Application::Ports::ReviewCaseGateway)
    expect(
      Preparation::Infrastructure::Adapters::ActiveRecordSettlementDispatchGateway.ancestors
    ).to include(Preparation::Application::Ports::SettlementDispatchGateway)
    expect(
      Payments::Infrastructure::Adapters::PreparationPaymentSettlementGateway.ancestors
    ).to include(Preparation::Application::Ports::PaymentSettlementGateway)
    expect(
      Orders::Infrastructure::Adapters::PreparationOrderDispatchGateway.ancestors
    ).to include(Preparation::Application::Ports::OrderDispatchGateway)
    expect(
      Preparation::Infrastructure::Persistence::ActiveRecordDispatchRepository.ancestors
    ).to include(Preparation::Application::Ports::DispatchRepository)
    expect(
      Preparation::Infrastructure::Persistence::ActiveRecordUnitOfWork.ancestors
    ).to include(Preparation::Application::Ports::UnitOfWork)
    expect(
      Preparation::Infrastructure::Adapters::ActiveRecordOutbox.ancestors
    ).to include(Preparation::Application::Ports::Outbox)
    expect(
      Preparation::Infrastructure::Adapters::ActiveRecordAuditLog.ancestors
    ).to include(Preparation::Application::Ports::AuditLog)

    expect(Payments::Application::Ports::PaymentRepository.instance_method(:lock_by_order_id).parameters)
      .to eq([ [ :req, :_order_id ] ])
    expect(Payments::Application::Ports::PaymentRepository.instance_method(:save).parameters)
      .to eq([ [ :req, :_payment ] ])
    expect(Preparation::Application::Ports::SettlementDispatchGateway.instance_method(:request_for_settlement).parameters)
      .to eq([ [ :keyreq, :order_id ], [ :keyreq, :payment_id ], [ :keyreq, :branch_id ], [ :keyreq, :now ] ])
    expect(Preparation::Application::Ports::PaymentSettlementGateway.instance_method(:fully_settled?).parameters)
      .to eq([ [ :req, :_snapshot ] ])
    expect(Payments::Application::Ports::ReviewCaseGateway.instance_method(:open_late_success).parameters)
      .to eq([
        [ :keyreq, :order_id ],
        [ :keyreq, :payment_id ],
        [ :keyreq, :payment_attempt_id ],
        [ :keyreq, :actor_id ],
        [ :keyreq, :now ]
      ])
  end

  it "keeps Ordering composition limited to dependencies consumed by Ordering use cases" do
    dependencies = OrderingComposition.dependencies

    expect(dependencies.payment_gateway)
      .to be_a(Payments::Infrastructure::Adapters::OrderingPaymentGateway)
    expect(dependencies.order_repository)
      .to be_a(Orders::Infrastructure::Persistence::ActiveRecordOrderRepository)
    expect(dependencies).not_to respond_to(:order_settlement_gateway)
  end

  it "keeps production independent of the removed global TrustedActor helper" do
    removed_path = Rails.root.join("app/contexts/trusted_actor.rb")
    production_files = Dir[Rails.root.join("app/**/*.rb")].sort

    expect(removed_path).not_to exist
    production_files.each do |path|
      expect(scan(path).constant_paths).not_to include("TrustedActor"), relative(path)
    end
  end

  it "keeps production independent of removed Payment facades and legacy Active Record models" do
    removed_paths = %w[
      app/contexts/payments/confirm.rb
      app/contexts/payments/confirm_cash.rb
      app/contexts/payments/confirm_bank_transfer.rb
      app/models/payment.rb
      app/models/payment_attempt.rb
      app/models/payment_review_case.rb
    ].map { |path| Rails.root.join(path) }
    production_files = Dir[Rails.root.join("app/**/*.rb")].sort

    expect(removed_paths.select(&:exist?)).to be_empty
    production_files.each do |path|
      expect(scan(path).constant_paths & REMOVED_PAYMENT_FACADES).to be_empty, relative(path)
    end
    expect(Payments::Infrastructure::Persistence::PaymentRecord.table_name).to eq("payments")
    expect(Payments::Infrastructure::Persistence::PaymentAttemptRecord.table_name).to eq("payment_attempts")
    expect(Payments::Infrastructure::Persistence::PaymentReviewCaseRecord.table_name)
      .to eq("payment_review_cases")
  end

  it "keeps production independent of removed Preparation facades and legacy Active Record models" do
    removed_paths = %w[
      app/contexts/preparation/request_dispatch.rb
      app/contexts/preparation/retry_dispatch.rb
      app/models/preparation_dispatch.rb
      app/models/preparation_dispatch_attempt.rb
    ].map { |path| Rails.root.join(path) }
    production_files = Dir[Rails.root.join("app/**/*.rb")].sort

    expect(removed_paths.select(&:exist?)).to be_empty
    production_files.each do |path|
      expect(scan(path).constant_paths & REMOVED_PREPARATION_FACADES).to be_empty, relative(path)
    end
    expect(Preparation::Infrastructure::Persistence::DispatchRecord.table_name)
      .to eq("preparation_dispatches")
    expect(Preparation::Infrastructure::Persistence::DispatchAttemptRecord.table_name)
      .to eq("preparation_dispatch_attempts")
  end

  it "keeps production code independent of the removed Ordering service facades" do
    removed_paths = %w[create_draft confirm hold expire_pending].map do |name|
      Rails.root.join("app/contexts/orders/#{name}.rb")
    end
    production_files = Dir[Rails.root.join("app/**/*.rb")].sort

    expect(removed_paths.select { |path| File.exist?(path) }).to be_empty
    production_files.each do |path|
      expect(scan(path).constant_paths & REMOVED_ORDERING_FACADES).to be_empty, relative(path)
    end
  end

  it "detects direct, leading-qualified, and aliased references to removed Ordering facades" do
    fixtures = [
      "Orders::CreateDraft.call",
      "::Orders::Confirm.call",
      "LegacyHold = Orders::Hold\nLegacyHold.call",
      "LegacyExpiry = ::Orders::ExpirePending\nLegacyExpiry.call"
    ]

    fixtures.each do |source|
      expect(DependencyScanner.new(source).constant_paths & REMOVED_ORDERING_FACADES)
        .not_to be_empty, source
    end
  end

  it "keeps production independent of the removed legacy Order Active Record model" do
    legacy_path = Rails.root.join("app/models/order.rb")
    production_files = Dir[Rails.root.join("app/**/*.rb")].sort
    legacy_constant_references = production_files.select do |path|
      path != Rails.root.join("app/contexts/orders/domain/aggregates/order.rb").to_s &&
        scan(path).constant_paths.include?("Order")
    end
    legacy_associations = production_files.select do |path|
      File.read(path).match?(/\b(?:belongs_to|has_one|has_many)\s+:order\b/)
    end

    expect(File.exist?(legacy_path)).to be(false)
    expect(legacy_constant_references.map { |path| relative(path) }).to be_empty
    expect(legacy_associations.map { |path| relative(path) }).to be_empty
    expect(Orders::Infrastructure::Persistence::OrderRecord.table_name).to eq("orders")
  end

  it "detects direct, leading-qualified, and aliased legacy Order model references" do
    fixtures = [
      "Order.find(order_id)",
      "::Order.lock.find(order_id)",
      "LegacyOrder = Order\nLegacyOrder.where(status: 'confirmed')"
    ]

    fixtures.each do |source|
      expect(DependencyScanner.new(source).constant_paths).to include("Order"), source
    end
  end

  def files_matching(context, pattern)
    context_files(context).select { |path| File.read(path).match?(pattern) }.map { |path| relative(path) }
  end

  def files_with_dependency(context, constants:, association: nil)
    context_files(context).select do |path|
      scanner = scan(path)
      scanner.references?(*constants) || (association && scanner.calls_method?(association))
    end.map { |path| relative(path) }
  end

  def all_context_files_matching(pattern)
    %w[orders payments preparation].flat_map { |context| files_matching(context, pattern) }.sort
  end

  def context_files(context)
    Dir[Rails.root.join("app/contexts", context, "**/*.rb")].sort
  end

  def target_layer_files
    %w[orders payments preparation].flat_map do |context|
      %w[domain application].flat_map do |layer|
        Dir[Rails.root.join("app/contexts", context, layer, "**/*.rb")]
      end
    end.sort
  end

  def ordering_infrastructure_files
    Dir[Rails.root.join("app/contexts/orders/infrastructure/**/*.rb")].sort
  end

  def infrastructure_files(context)
    Dir[Rails.root.join("app/contexts", context, "infrastructure/**/*.rb")].sort
  end

  def cross_context_infrastructure_dependency?(scanner, context)
    scanner.references?(*cross_context_constant_names(context)) ||
      cross_context_association_names(context).any? do |name|
        scanner.references_association?(name)
      end
  end

  def cross_context_constant_paths(scanner, context)
    roots = cross_context_constant_names(context)
    scanner.constant_paths.select do |path|
      roots.any? { |root| path == root || path.start_with?("#{root}::") }
    end.uniq.sort
  end

  def cross_context_constant_names(context)
    case context
    when "orders"
      %w[Order Orders]
    when "payments"
      %w[Payment PaymentAttempt PaymentReviewCase Payments]
    when "preparation"
      %w[Preparation PreparationDispatch]
    else
      raise ArgumentError, "Unknown context: #{context}"
    end
  end

  def cross_context_association_names(context)
    case context
    when "orders"
      %i[order orders]
    when "payments"
      %i[payment payments payment_attempts payment_review_cases]
    when "preparation"
      %i[preparation_dispatch preparation_dispatches]
    else
      raise ArgumentError, "Unknown context: #{context}"
    end
  end

  def ordering_infrastructure_cross_context_dependency?(scanner, context)
    case context
    when :payment
      scanner.references?(
        "Payment",
        "PaymentAttempt",
        "PaymentReviewCase",
        "Payments::Infrastructure::Persistence::PaymentRecord",
        "Payments::Infrastructure::Persistence::PaymentAttemptRecord",
        "Payments::Infrastructure::Persistence::PaymentReviewCaseRecord",
        "Payments"
      ) ||
        %i[payment payment_attempts payment_review_cases].any? do |name|
          scanner.calls_method?(name) || scanner.references_association?(name)
        end
    when :preparation
      scanner.references?("Preparation", "PreparationDispatch") ||
        %i[preparation_dispatch preparation_dispatches].any? do |name|
          scanner.calls_method?(name) || scanner.references_association?(name)
        end
    else
      raise ArgumentError, "Unknown context: #{context}"
    end
  end

  def scan(path)
    DependencyScanner.new(File.read(path))
  end

  def reference_forbidden_layer_dependency(path = nil)
    owned_constants = case path
    when %r{app/contexts/orders/}
      %w[Order Orders]
    when %r{app/contexts/payments/}
      %w[Payment Payments]
    when %r{app/contexts/preparation/}
      %w[Preparation PreparationDispatch]
    else
      []
    end
    cross_context_constants = %w[Order Orders Payment Payments Preparation PreparationDispatch] - owned_constants

    satisfy do |scanner|
      scanner.references?("ActiveRecord", "ApplicationRecord", "Rails", "PG") ||
        scanner.constant_paths.any? do |constant_path|
          constant_path.split("::").include?("Infrastructure") || constant_path.end_with?("Record")
        end ||
        scanner.calls_persistence_on?(*persistence_constant_names) ||
        scanner.references?(*cross_context_constants)
    end
  end

  def persistence_constant_names
    @persistence_constant_names ||= begin
      model_files = Dir[Rails.root.join("app/models/**/*.rb")]
      record_files = Dir[Rails.root.join("app/contexts/**/infrastructure/persistence/**/*_record.rb")]
      names = (model_files + record_files).map do |file|
        File.basename(file, ".rb").camelize
      end
      (names + %w[Payment PaymentAttempt PaymentReviewCase]).uniq
    end
  end

  def relative(path)
    Pathname(path).relative_path_from(Rails.root).to_s
  end
end
