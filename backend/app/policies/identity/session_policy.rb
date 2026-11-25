module Identity
  class SessionPolicy < ApplicationPolicy
    def show?
      Application::UseCases::Authorize.new.call(context: user, request: record)
    end
  end
end
