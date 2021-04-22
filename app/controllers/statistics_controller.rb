class StatisticsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_statistic

  def index
    return if @spending_plans.present?

    @spending_plans = current_user.spending_plans.is_recycle(false)
                                  .filter_statistic Time.zone.today - 1.month,
                                                    Time.zone.today
    load_info_statistic
  end

  private

  def load_info_statistic
    @number_plan = @spending_plans.count
    @total_money_income = @spending_plans.income.sum(:total_money)
    @total_money_expense = @spending_plans.expense.sum(:total_money)
    @spend_money = @total_money_income - @total_money_expense
  end

  def load_statistic
    return unless params[:start_date].present? &&
                  params[:end_date].present? &&
                  params[:end_date] >= params[:start_date]

    @spending_plans = current_user.spending_plans.is_recycle(false)
                                  .filter_statistic params[:start_date],
                                                    params[:start_date]
    load_info_statistic
  end
end
