FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
  end

  factory :admin, parent: :user do
    is_admin { true }
  end
end
