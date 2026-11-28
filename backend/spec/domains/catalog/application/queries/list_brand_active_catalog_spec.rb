require "rails_helper"

RSpec.describe Catalog::Application::Queries::ListBrandActiveCatalog do
  let(:brand_reference) do
    Catalog::Application::Contracts::BrandReference.new("11111111-1111-1111-1111-111111111111")
  end
  let(:category_reference) do
    Catalog::Application::Contracts::CategoryReference.new("22222222-2222-2222-2222-222222222222")
  end
  let(:page_request) do
    Catalog::Application::Contracts::BrandActiveCatalogPageRequest.new(
      page: 2,
      limit: 10,
      category_reference: category_reference
    )
  end
  let(:product_fact) do
    Catalog::Application::Ports::BrandActiveCatalogReader::ProductFact.new(
      id: "33333333-3333-3333-3333-333333333333",
      brand_id: brand_reference.value,
      category_id: category_reference.value,
      category_code: "COFFEE",
      category_name: "Coffee",
      category_position: 1,
      code: "LATTE",
      name: "Latte",
      description: "Synthetic test description",
      variants: [
        Catalog::Application::Ports::BrandActiveCatalogReader::VariantFact.new(
          id: "44444444-4444-4444-4444-444444444444",
          product_id: "33333333-3333-3333-3333-333333333333",
          brand_id: brand_reference.value,
          code: "DEFAULT",
          name: "Default",
          position: 0,
          default: true,
          customer_visible: true
        )
      ]
    )
  end

  it "returns an immutable bounded page without inventing commercial data" do
    reader = reader_returning(
      Catalog::Application::Ports::BrandActiveCatalogReader::Result.found(
        products: [ product_fact ],
        total: 15
      )
    )

    result = described_class.new(reader: reader).call(
      brand_reference: brand_reference,
      page_request: page_request
    )

    expect(result).to be_found
    expect(result.page).to have_attributes(page: 2, limit: 10, total: 15, total_pages: 2)
    product = result.page.products.fetch(0)
    expect(product).to be_frozen
    expect(product.brand_id).to eq(brand_reference.value)
    expect(product.category_id).to eq(category_reference.value)
    expect(product.pricing_status).to eq(:price_unavailable)
    expect(product).not_to respond_to(:price)
    expect(product).not_to respond_to(:branch_id)
    expect(product).not_to respond_to(:sellable)
    expect(product.variants.fetch(0)).to be_frozen
    expect(reader).to have_received(:read).with(
      brand_reference: brand_reference,
      category_reference: category_reference,
      offset: 10,
      limit: 10
    )
  end

  it "does not claim Branch assortment or sellability" do
    expect(described_class.instance_method(:call).parameters).to eq(
      [ [ :keyreq, :brand_reference ], [ :keyreq, :page_request ] ]
    )
    expect(Catalog::Application::Contracts.constants.grep(/Menu|Sellable/)).to be_empty
  end

  it "returns an empty found page without disclosing another Brand" do
    result = described_class.new(
      reader: reader_returning(
        Catalog::Application::Ports::BrandActiveCatalogReader::Result.found(products: [], total: 0)
      )
    ).call(brand_reference: brand_reference, page_request: page_request)

    expect(result).to be_found
    expect(result.page.products).to be_empty
    expect(result.page.total).to eq(0)
  end

  it "rejects invalid inputs before persistence" do
    reader = instance_spy(Catalog::Application::Ports::BrandActiveCatalogReader)

    result = described_class.new(reader: reader).call(
      brand_reference: brand_reference.value,
      page_request: page_request
    )

    expect(result).to be_invalid
    expect(reader).not_to have_received(:read)
    expect do
      Catalog::Application::Contracts::BrandActiveCatalogPageRequest.new(
        page: 0,
        limit: 101,
        category_reference: nil
      )
    end.to raise_error(ArgumentError)
  end

  it "fails closed for foreign, duplicate, malformed, or inconsistent facts" do
    foreign_fact = Catalog::Application::Ports::BrandActiveCatalogReader::ProductFact.new(
      **product_fact.to_h.merge(brand_id: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
    )

    [
      [ foreign_fact ],
      [ product_fact, product_fact ],
      [ Object.new ]
    ].each do |products|
      result = described_class.new(
        reader: reader_returning(
          Catalog::Application::Ports::BrandActiveCatalogReader::Result.found(
            products: products,
            total: products.length
          )
        )
      ).call(brand_reference: brand_reference, page_request: page_request)

      expect(result).to be_inconsistent
      expect(result.page).to be_nil
    end
  end

  it "preserves unavailable references and sanitizes unexpected defects" do
    failure_reference = Catalog::Application::Contracts::SafeFailureReference.new(
      "55555555-5555-5555-5555-555555555555"
    )
    unavailable = described_class.new(
      reader: reader_returning(
        Catalog::Application::Ports::BrandActiveCatalogReader::Result.unavailable(failure_reference)
      )
    ).call(brand_reference: brand_reference, page_request: page_request)

    expect(unavailable).to be_unavailable
    expect(unavailable.failure_reference).to equal(failure_reference)

    source_message = "protected catalog data password=do-not-leak"
    reader = instance_double(Catalog::Application::Ports::BrandActiveCatalogReader)
    allow(reader).to receive(:read).and_raise(NoMethodError, source_message)

    expect do
      described_class.new(reader: reader).call(
        brand_reference: brand_reference,
        page_request: page_request
      )
    end.to raise_error(Catalog::Application::Errors::UnexpectedFailure) { |error|
      expect(error.cause).to be_nil
      expect(error.backtrace).to eq([])
      expect(error.full_message).not_to include(source_message)
    }
  end

  def reader_returning(result)
    instance_double(Catalog::Application::Ports::BrandActiveCatalogReader, read: result)
  end
end
