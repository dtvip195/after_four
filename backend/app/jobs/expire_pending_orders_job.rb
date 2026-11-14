class ExpirePendingOrdersJob < ApplicationJob
  queue_as :default

  def perform
    Orders::ExpirePending.call
  end
end
