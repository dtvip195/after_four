module Payments
  class ConfirmBankTransfer
    def self.call(**attributes)
      Confirm.call(method: "bank_transfer", **attributes)
    end
  end
end
