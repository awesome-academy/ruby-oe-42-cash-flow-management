class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :destroy
  # authorize_resource giup tranh lap lai authorize!
  # nhieu lan o cac action khac nhau
  authorize_resource
  # before_action :check_admin_user, only: :destroy
  # before_action :check_current_user, only: :destroy

  def show; end

  def index
    @users = User.order_by_creat_at_desc
                 .paginate page: params[:page],
                           per_page: Settings.paginate.per_page
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.delete_user_success"
    else
      flash[:warning] = t "flash.delete_user_fail"
    end
    redirect_to users_path
  end

  private

  # thay vi dung method nay check admin user bang cancancan
  # def check_admin_user
  #   # return if @current_user.admin?

  #   # flash[:warning] = "You are not admin"
  #   # redirect_to users_path
  #   authorize! :destroy, @user
  # end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:warning] = t "flash.find_user_fail"
    redirect_to users_path
  end

  # thay vi dung method nay current user tu xoa minh bang cancancan
  # def check_current_user
  #   return unless @user == @current_user

  #   flash[:warning] = t "flash.delete_current_user"
  #   redirect_to users_path
  # end
end
