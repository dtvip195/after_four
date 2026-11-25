FactoryBot.define do
  factory :identity_user_record,
    class: "Identity::Infrastructure::Persistence::UserRecord" do
    organization_id { association(:organization_record).id }
    sequence(:username) { |number| "identity-user-#{number}" }
    password { "correct horse battery staple" }
    password_confirmation { password }
    status { "active" }
  end
end
