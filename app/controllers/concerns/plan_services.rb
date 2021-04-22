module PlanServices
  def load_spending_plan
    @spending_plan = SpendingPlan.find_by id: params[:id]
    return if @spending_plan

    flash[:warning] = t "flash.plan_not_present"
    redirect_to spending_plans_path
  end

  def check_owner_of_plan
    return if @spending_plan.user.id == current_user.id

    flash[:warning] = t "flash.not_your_plan"
    redirect_to spending_plans_path
  end
end
