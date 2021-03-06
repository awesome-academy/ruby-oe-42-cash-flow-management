class SpendingPlansController < ApplicationController
  include PlanServices

  before_action :logged_in_user
  before_action :load_spending_plan, except: %i(new index create)
  before_action :check_owner_of_plan, except: %i(new index create)
  before_action :send_plan_to_recycle, only: :destroy
  before_action :load_budget, only: %i(create update)

  def new
    @spending_plan = SpendingPlan.new
  end

  def index
    @spending_plans = current_user.spending_plans.includes(:budget)
                                  .is_recycle(false)
    search_spending_plan
    @spending_plans = @spending_plans.order_by_creat_at_desc
                                     .paginate page: params[:page],
                                      per_page: Settings.paginate.per_page
  end

  def edit; end

  def update
    @spending_plan.budget_id = @budget.id
    if @spending_plan.update spending_plan_params
      flash[:success] = t "flash.update_plan_success"
      redirect_to @spending_plan
    else
      render :edit
    end
  end

  def show; end

  def create
    @spending_plan = current_user.spending_plans.build spending_plan_params
    @spending_plan.budget_id = @budget.id
    if @spending_plan.save
      flash[:success] = t("flash.create_plan_success")
      redirect_to new_spending_plan_path
    else
      render :new
    end
  end

  def destroy
    if @spending_plan.destroy
      flash[:success] = t "flash.delete_plan_success"
    else
      flash[:danger] = t "flash.delete_plan_fail"
    end
  end

  private

  def spending_plan_params
    params.require(:spending_plan).permit :name, :start_date,
                                          :end_date, :total_money, :note,
                                          :plan_type, :is_repeat,
                                          :repeat_type, :budget_id
  end

  def load_budget
    @budget = Budget.find_by id: params[:spending_plan][:budget_id] if
    params[:spending_plan].present?
    return if @budget.present?

    flash[:warning] = t "flash.budget_can_not_load"
    redirect_to new_spending_plan_path
  end

  def search_spending_plan
    @spending_plans = @spending_plans.filter_name params[:keyword] if
                      params[:keyword].present?
    @spending_plans = @spending_plans.filter_budget_id params[:budget_id] if
                      params[:budget_id].present?
    @spending_plans = @spending_plans.filter_plan_type params[:plan_type] if
                      params[:plan_type].present?
  end

  def send_plan_to_recycle
    return if @spending_plan.recycle

    if @spending_plan.update_column :recycle, true
      flash[:success] = t "flash.plan_to_recycle_success"
      redirect_to spending_plans_path
    else
      flash[:success] = t "flash.plan_to_recycle_fail"
      redirect_to @spending_plans
    end
  end
end
