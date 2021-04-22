FactoryBot.define do
  factory :user do
    name { Faker::Alphanumeric.alphanumeric(number: 20) }
    email { Faker::Internet.email }
    password { "123123" }
    password_confirmation { "123123" }
    confirmed_at { Time.zone.now }
  end
end
