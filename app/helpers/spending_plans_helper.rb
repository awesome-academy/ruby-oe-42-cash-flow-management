module SpendingPlansHelper
  def select_for_type_plan
    I18n.t("spending_plans.form.option_for_type_plan")
  end

  def select_for_type_repeat
    I18n.t("spending_plans.form.option_for_type_repeat")
  end

  def select_for_status
    I18n.t("spending_plans.form.option_for_status")
  end

  def select_budget
    I18n.t("spending_plans.form.option_new_budget")
        .merge @current_user.budgets.pluck(:name, :id).to_h
  end

  def select_budget_when_search
    @current_user.budgets.pluck(:name, :id).to_h
  end

  def default_for_select_budget
    return params[:budget_id] if params[:budget_id].present?

    return @spending_plan.budget.id if @spending_plan.budget.present?

    -1
  end
end
