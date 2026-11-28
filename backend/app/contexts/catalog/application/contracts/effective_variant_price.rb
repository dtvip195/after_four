module Catalog
  module Application
    module Contracts
      EffectiveVariantPrice = Data.define(
        :variant_id, :branch_id, :price_version_id, :amount, :currency_code,
        :effective_from, :resolved_at
      )
    end
  end
end
