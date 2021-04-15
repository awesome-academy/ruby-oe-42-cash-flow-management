FactoryBot.define do
  factory :budget do
    name { Faker::Lorem.sentence(word_count: 3) }
    money { rand(1000..1000000) }
  end
end
