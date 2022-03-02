FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email(name:) }
    password { "password" }
  end

  factory :admin, parent: :user do
    is_admin { true }
  end
end
