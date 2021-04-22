name_users = ["huy", "nhat", "loc", "son"]

name_users.each do |user|
  name = user
  email = "#{user}@gmail.com"
  password = "123123"
  User.create! name: name,
               email: email,
               password: password,
               password_confirmation: password,
               confirmed_at: Time.zone.now
end

users = User.order(:created_at)
users.each do |user|
  10.times do
    name_budget = Faker::Lorem.sentence(word_count: 2)
    budget = Budget.create!(name: name_budget, money: rand(1000..1000000), user_id: user.id)
    3.times do
      name_plan = Faker::Name.name
      start_date = Faker::Date.between(from: 10.month.ago, to: 1.month.ago)
      end_date = Faker::Date.between(from: start_date, to: start_date + 1.month)
      total_money = rand(1000..1000000)
      note = Faker::Food.fruits
      plan_type = rand(0..1)
      SpendingPlan.create!(name: name_plan, start_date: start_date, end_date: end_date,
                           total_money: total_money, note: note, plan_type: plan_type,
                           user_id: user.id, budget_id: budget.id)
    end
    1.times do
      name_plan = Faker::Name.name
      start_date = Faker::Date.between(from: 7.days.ago, to: 1.days.ago)
      end_date = Faker::Date.between(from: start_date, to: start_date + 7.days)
      total_money = rand(1000..1000000)
      note = Faker::Food.fruits
      plan_type = rand(0..1)
      SpendingPlan.create!(name: name_plan, start_date: start_date, end_date: end_date,
                           total_money: total_money, note: note, plan_type: plan_type,
                           user_id: user.id, budget_id: budget.id)
    end
    1.times do
      name_plan = Faker::Name.name
      start_date = Faker::Date.between(from: Date.today + 2.days, to: Date.today + 7.days)
      end_date = Faker::Date.between(from: start_date, to: start_date + 3.days)
      total_money = rand(1000..1000000)
      note = Faker::Food.fruits
      plan_type = rand(0..1)
      SpendingPlan.create!(name: name_plan, start_date: start_date, end_date: end_date,
                           total_money: total_money, note: note, plan_type: plan_type,
                           user_id: user.id, budget_id: budget.id)
    end
  end
end
User.all.where("id <> 1").each do |user|
  user.spending_plans.each do |plan|
    AllowSharing.create! user_id: 1,
                         spending_plan_id: plan.id
  end
end
