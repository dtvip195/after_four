module IdentityComposition
  Dependencies = Data.define(:credential_authenticator, :session_store)

  module_function

  def dependencies
    Dependencies.new(
      credential_authenticator: Identity::Infrastructure::Adapters::DeviseCredentialAuthenticator.new,
      session_store: Identity::Infrastructure::Adapters::ActiveRecordSessionStore.new
    )
  end

  def sign_in_use_case
    current = dependencies
    Identity::Application::UseCases::SignIn.new(
      credential_authenticator: current.credential_authenticator,
      session_store: current.session_store
    )
  end

  def authenticate_session_use_case
    Identity::Application::UseCases::AuthenticateSession.new(session_store: dependencies.session_store)
  end

  def sign_out_use_case
    Identity::Application::UseCases::SignOut.new(session_store: dependencies.session_store)
  end

  def authorization_use_case
    Identity::Application::UseCases::Authorize.new
  end
end
