module Catalog
  module Application
    module Contracts
      BrandActiveCatalogProduct = Data.define(
        :id,
        :brand_id,
        :category_id,
        :category_code,
        :category_name,
        :category_position,
        :code,
        :name,
        :description,
        :variants,
        :pricing_status
      )
    end
  end
end
