class ExpirePendingOrdersJob < ApplicationJob
  queue_as :default

  def perform
    OrderingComposition.expire_pending_use_case.call(now: Time.current)
  end
end
