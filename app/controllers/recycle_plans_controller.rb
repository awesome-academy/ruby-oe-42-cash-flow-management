class RecyclePlansController < ApplicationController
  include PlanServices

  before_action :authenticate_user!
  before_action :load_spending_plan, only: :update
  before_action :check_owner_of_plan, only: :update

  def index
    @spending_plans = current_user.spending_plans.includes(:budget)
                                  .is_recycle(true)
                                  .order_by_creat_at_desc
                                  .paginate page: params[:page],
                                            per_page: Settings.paginate.per_page
  end

  def update
    if @spending_plan.update_column :recycle, false
      flash[:success] = t "flash.restore_plan_success"
    else
      flash[:warning] = t "flash.restore_plan_fail"
    end
    redirect_to recycle_plans_path
  end
end
