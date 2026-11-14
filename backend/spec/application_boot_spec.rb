require "rails_helper"
require "open3"

RSpec.describe "Application boot" do
  it "boots with the accepted foundation configuration" do
    expect(Rails.application).to be_initialized
    expect(Rails.configuration.api_only).to be(true)
    expect(ActiveRecord.schema_format).to eq(:sql)
    expect(Rails.application.config.active_job.queue_adapter).to eq(:test)
    expect(Time.zone.name).to eq("UTC")
    expect(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type).to eq(:timestamptz)
    expect(Rails.configuration.x.orders.payment_window_seconds).to eq(300)
  end

  it "applies a configured positive payment window at process boot" do
    output, error, status = rails_runner_with_payment_window("900")

    expect(status).to be_success, error
    expect(output).to eq("900\n")
  end

  it "fails process boot instead of accepting an invalid payment window" do
    _output, error, status = rails_runner_with_payment_window("0")

    expect(status).not_to be_success
    expect(error).to include(
      "ORDER_PAYMENT_WINDOW_SECONDS must be a positive integer whose deadline fits PostgreSQL timestamptz"
    )
  end

  def rails_runner_with_payment_window(value)
    Open3.capture3(
      { "RAILS_ENV" => "test", "ORDER_PAYMENT_WINDOW_SECONDS" => value },
      "bin/rails",
      "runner",
      "puts Rails.configuration.x.orders.payment_window_seconds"
    )
  end
end
