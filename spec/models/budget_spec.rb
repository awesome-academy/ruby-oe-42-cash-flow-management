require "rails_helper"

RSpec.describe Budget, type: :model do

  describe "Associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:spending_plans).dependent(:destroy) }
    it { is_expected.to have_many(:child_budgets).class_name(Budget.name).with_foreign_key(:parent_id).dependent(:destroy) }
    it { is_expected.to belong_to(:parent).class_name(Budget.name).optional }
  end

  let(:user) {FactoryBot.create :user}
  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:money) }
    it { is_expected.to validate_numericality_of(:money).is_greater_than_or_equal_to(0) }

    let(:parent_budget) {FactoryBot.create :budget, money: 50, user_id: user.id}
    it "should have a valid money" do
      budget = Budget.new(money: 15, parent_id: parent_budget.id)
      expect(budget).to be_invalid
      expect(budget.errors[:money]).to be_empty
    end

    it "should have a invalid money" do
      budget = Budget.new(money: 100, parent_id: parent_budget.id)
      expect(budget).to be_invalid
      expect(budget.errors[:money]).to include(I18n.t("budget.money_error"))
    end
  end

  describe "#search_by_money_range" do
    it "returns a budget has money between money range" do
      budget = FactoryBot.create :budget, user_id: user.id, money: 159
      expect(Budget.search_by_money_range(158, 160)).to include budget
    end
  end
end
