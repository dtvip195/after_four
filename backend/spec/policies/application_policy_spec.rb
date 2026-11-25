require "rails_helper"

RSpec.describe ApplicationPolicy do
  subject(:policy) { described_class.new(Object.new, Object.new) }

  it "denies every standard action and every scope by default" do
    expect(policy).not_to be_index
    expect(policy).not_to be_show
    expect(policy).not_to be_create
    expect(policy).not_to be_new
    expect(policy).not_to be_update
    expect(policy).not_to be_edit
    expect(policy).not_to be_destroy
    expect { described_class::Scope.new(Object.new, Object.new).resolve }
      .to raise_error(Pundit::NotAuthorizedError)
  end

  it "raises when a protected controller path omits Pundit authorization" do
    controller = Api::V1::Auth::SessionsController.new

    expect { controller.__send__(:verify_authorized) }
      .to raise_error(Pundit::AuthorizationNotPerformedError)
  end
end
