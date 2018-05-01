FactoryBot.define do
  factory :entry do
    user
    feed { build(:feed, user: user) }
    external_id { SecureRandom.uuid }
    name { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
  end
end
