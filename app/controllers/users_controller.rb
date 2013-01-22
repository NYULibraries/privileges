class UsersController < ApplicationController
  before_filter :authenticate_admin
  
  # GET /users
  def index
    @users = User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
  end

  # GET /users/1
  def show
    @user = User.find_by_username(params[:id])
    @user = User.find(params[:id]) if @user.nil?
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  # GET /users/1/edit
  def edit
    @user = User.find_by_username(params[:id])

    redirect_to root_url and return
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    user_attributes = {}
    user_attributes[:access_grid_admin] = params[:user][:access_grid_admin].to_i == 1
    @user.update_attributes(:user_attributes => user_attributes)

    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to(@user) }
    end
  end

  # Implement sort column function for this model
  def sort_column
    super "User", "lastname"
  end
  helper_method :sort_column
  
end
