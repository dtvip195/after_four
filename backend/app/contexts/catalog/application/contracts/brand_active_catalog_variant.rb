module Catalog
  module Application
    module Contracts
      BrandActiveCatalogVariant = Data.define(
        :id,
        :code,
        :name,
        :position,
        :default,
        :customer_visible
      )
    end
  end
end
