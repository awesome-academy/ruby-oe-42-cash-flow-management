# Generate a bunch of additional users.
50.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@cashflow.org"
  password = "123123"
  User.create! name: name,
               email: email,
               password: password,
               password_confirmation: password
end

# Generate budget for a subset of users.
users = User.order(:created_at).take(6)
10.times do
  name = Faker::Lorem.sentence(word_count: 4)
  users.each {|user| user.budgets.create!(name: name, money: rand(1000..1000000))}
end

(1..10).each {|i| User.find_by(id: i).admin!}
