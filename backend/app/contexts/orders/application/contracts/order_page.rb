module Orders
  module Application
    module Contracts
      OrderPage = Data.define(:orders, :page, :limit, :total, :total_pages) do
        def initialize(orders:, **)
          super(orders: orders.dup.freeze, **)
        end
      end
    end
  end
end
