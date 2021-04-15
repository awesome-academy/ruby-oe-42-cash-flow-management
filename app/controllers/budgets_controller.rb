class BudgetsController < ApplicationController
  before_action :logged_in_user
  before_action :load_budgets, only: %i(index new create)
  before_action :find_parent_budget, only: %i(new create),
                if: ->{params[:parent_id]}
  before_action :vaild_range_money, only: :index

  def index
    search_by_name if params[:name].present?
    if params[:from_money].present? || params[:to_money].present?
      @budgets = search_by_money
    end
    @budgets = paginate @budgets.order_by_creat_at_desc
  end

  def new
    @budget = Budget.new
  end

  def create
    @budget = current_user.budgets.build budget_params
    if @budget.save
      flash[:success] = t "flash.create_budget_success"
      redirect_to budgets_path
    else
      params[:parent_id] = params[:budget][:parent_id]
      render :new
    end
  end

  private

  def budget_params
    params.require(:budget).permit :parent_id, :name, :money
  end

  def load_budgets
    @budgets = current_user.budgets.where_parent
  end

  def find_parent_budget
    @parent_budget = @current_user.budgets.find_by id: params[:parent_id]
    return if @parent_budget

    flash[:danger] = t "flash.not_found_budget"
    redirect_to new_budget_path
  end

  def search_by_name
    @budgets = @budgets.search_by_name params[:name]
  end

  def search_by_money
    if valid_money_params?
      return @budgets.search_by_money_range(params[:from_money],
                                            params[:to_money])
    end

    if params[:from_money].present?
      return @budgets.search_by_from_money params[:from_money]
    end

    @budgets.search_by_to_money params[:to_money]
  end

  def valid_money_params?
    params[:from_money].present? && params[:to_money].present?
  end

  def vaild_range_money
    return if params[:from_money].blank? || params[:to_money].blank?

    return if params[:from_money].to_f < params[:to_money].to_f

    @budgets = paginate @budgets.order_by_creat_at_desc
    flash.now[:danger] = t "budget.alert_money_error"
    render :index
  end
end
