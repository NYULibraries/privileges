class UsersController < ApplicationController
  before_action :authenticate_admin
  respond_to :html, :json
  respond_to :csv, only: [:index]

  # GET /users
  def index
    @users = User.order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    @users = @users.with_query(params[:q]) unless params[:q].blank?

    respond_with(@users) do |format|
      format.csv { render csv: @users, filename: "privileges_guide_users" }
    end
  end

  # GET /users/1
  def show
    @user = (User.find_by_username(params[:id]) || User.find(params[:id]))
    respond_with(@user)
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by_username(params[:id])
    respond_with(@user) do |format|
      format.html { redirect_to root_url }
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(@user)
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    @user.admin = (user_params[:admin].to_i == 1)
    @user.save

    respond_with(@user)
  end

  # Delete all non-admin patrons
  def clear_patron_data
    @users = User.non_admin
    flash[:success] = t('users.clear_patron_data_success') if @users.destroy_all
    respond_with(@users, location: users_url)
  end

  # Implement sort column function for this model
  def sort_column
    super "User", "lastname"
  end
  helper_method :sort_column

  def user_params
    params.require(:user).permit(:admin)
  end
  private :user_params

end
