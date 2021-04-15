class SharePlansController < ApplicationController
  include PlanServices

  before_action :logged_in_user
  before_action :load_spending_plan, only: :create
  before_action :check_owner_of_plan, only: :create
  before_action :load_user, only: :create

  def index
    @shared_plans = SpendingPlan.load_shared_plan(@current_user.id)
                                .includes(:budget).includes(:user)
    @shared_plans = paginate @shared_plans.order_by_creat_at_desc
  end

  def create
    @share_success = []
    @exist_share = []
    create_sharing
    redirect_to spending_plans_path
  end

  private

  def load_user
    @users_exist = []
    @emails_not_exist = []
    params[:emails].split.uniq.each do |email|
      user = User.find_by email: email
      if user
        @users_exist << user
      else
        @emails_not_exist << email
      end
    end
  end

  def create_sharing
    ActiveRecord::Base.transaction do
      @users_exist.each do |user|
        if AllowSharing.find_by user_id: user.id,
                               spending_plan_id: @spending_plan.id
          @exist_share << user.email
        else
          AllowSharing.create! user_id: user.id,
                               spending_plan_id: @spending_plan.id
          @share_success << user.email
        end
      end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "spending_plans.record_invalid"
    rescue StandardError => e
      Rails.logger.debug e.message
    else
      add_flash
    end
  end

  def add_flash
    flash[:success] = t("flash.share_plan_success") + @share_success.to_s unless
                                                      @share_success.empty?
    flash[:warning] = t("flash.exist_sharing") + @exist_share.to_s unless
                                                 @exist_share.empty?
    flash[:danger] = t("flash.not_found_user") + @emails_not_exist.to_s unless
                                                 @emails_not_exist.empty?
  end
end
