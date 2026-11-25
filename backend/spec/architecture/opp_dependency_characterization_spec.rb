require "rails_helper"
require "prism"

RSpec.describe "ADR-0012 Ordering, Payment, and Preparation dependency baseline" do
  class DependencyScanner < Prism::Visitor
    PERSISTENCE_METHODS = %i[
      all where joins pluck exists? find find_by find_by! find_each new create create!
      update update! update_all save save! delete delete_all destroy destroy_all connection lock
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

    attr_reader :constant_paths, :calls

    def initialize(source)
      super()
      @constant_paths = []
      @calls = []
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
    payment_to_ordering: %w[app/domains/payments/confirm.rb],
    payment_to_preparation: %w[app/domains/payments/confirm.rb],
    preparation_to_ordering: %w[app/domains/preparation/request_dispatch.rb],
    preparation_to_payment: %w[app/domains/preparation/request_dispatch.rb]
  }.freeze

  LEGACY_TECHNICAL_FACILITY_FILES = {
    audit: %w[
      app/domains/orders/infrastructure/adapters/active_record_audit_log.rb
      app/domains/payments/confirm.rb
      app/domains/preparation/request_dispatch.rb
      app/domains/preparation/retry_dispatch.rb
    ],
    outbox: %w[
      app/domains/payments/confirm.rb
      app/domains/preparation/request_dispatch.rb
      app/domains/preparation/retry_dispatch.rb
    ]
  }.freeze

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

  it "records direct Audit and Outbox access as technical-facility debt, not business contexts" do
    actual = {
      audit: all_context_files_matching(/\bAuditEvent\b/),
      outbox: all_context_files_matching(/\bOutboxEvent\b/)
    }

    expect(actual).to eq(LEGACY_TECHNICAL_FACILITY_FILES)
  end

  it "keeps newly introduced Domain and Application layers independent of Rails persistence" do
    expect(target_layer_files).not_to be_empty

    target_layer_files.each do |path|
      scanner = scan(path)
      expect(scanner).not_to reference_forbidden_layer_dependency(relative(path)), relative(path)
    end
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
      reference_forbidden_layer_dependency("app/domains/orders/application/example.rb")
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
    Dir[Rails.root.join("app/domains", context, "**/*.rb")].sort
  end

  def target_layer_files
    %w[orders payments preparation].flat_map do |context|
      %w[domain application].flat_map do |layer|
        Dir[Rails.root.join("app/domains", context, layer, "**/*.rb")]
      end
    end.sort
  end

  def scan(path)
    DependencyScanner.new(File.read(path))
  end

  def reference_forbidden_layer_dependency(path = nil)
    owned_constants = case path
    when %r{app/domains/orders/}
      %w[Order Orders]
    when %r{app/domains/payments/}
      %w[Payment Payments]
    when %r{app/domains/preparation/}
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
      record_files = Dir[Rails.root.join("app/domains/**/infrastructure/persistence/**/*_record.rb")]
      (model_files + record_files).map do |file|
        File.basename(file, ".rb").camelize
      end.uniq
    end
  end

  def relative(path)
    Pathname(path).relative_path_from(Rails.root).to_s
  end
end
