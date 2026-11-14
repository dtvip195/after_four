require "rails_helper"

RSpec.describe Platform::StructuredLogFormatter do
  subject(:formatter) { described_class.new }

  it "emits one JSON object with stable foundation fields" do
    output = formatter.call("INFO", Time.utc(2026, 11, 14, 12), nil, "booted")
    event = JSON.parse(output)

    expect(event.fetch("timestamp")).to eq("2026-11-14T12:00:00.000000Z")
    expect(event.fetch("severity")).to eq("INFO")
    expect(event.fetch("service")).to eq("after-four-backend")
    expect(event.fetch("message")).to eq("booted")
  end

  it "does not serialize exception details" do
    output = formatter.call("ERROR", Time.utc(2026, 11, 14, 12), nil, RuntimeError.new("secret"))

    expect(JSON.parse(output).fetch("message")).to eq("RuntimeError")
    expect(output).not_to include("secret")
  end
end
