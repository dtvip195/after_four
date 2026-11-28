module Catalog
  module Application
    module Contracts
      BrandActiveCatalogPage = Data.define(:products, :page, :limit, :total, :total_pages)
    end
  end
end
