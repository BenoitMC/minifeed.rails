FactoryBot.define do
  factory :feed do
    user
    category { build(:category, user:) }
    name { Faker::Lorem.word }
    url { Faker::Internet.url }
  end
end
