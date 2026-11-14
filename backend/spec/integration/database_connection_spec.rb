require "rails_helper"

RSpec.describe "Database connection" do
  it "connects to PostgreSQL 18 in UTC" do
    connection = ActiveRecord::Base.connection

    expect(connection.select_value("SHOW server_version")).to match(/\A18\./)
    expect(connection.select_value("SHOW TIME ZONE")).to eq("UTC")
    expect(connection.select_value("SELECT 1")).to eq(1)
  end
end
