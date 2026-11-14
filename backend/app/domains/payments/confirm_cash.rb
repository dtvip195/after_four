module Payments
  class ConfirmCash
    def self.call(**attributes)
      Confirm.call(method: "cash", **attributes)
    end
  end
end
