FactoryBot.define do
  factory :category do
    user
    name { Faker::Lorem.word }
  end
end
