require "rails_helper"

RSpec.describe "RSpec database isolation" do
  it "wraps database examples in a transaction" do
    expect(ActiveRecord::Base.connection).to be_transaction_open
  end
end
