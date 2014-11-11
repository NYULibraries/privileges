# This controller handles the permissions assigned to sublibraries
# each permission has a set of possible values (PermissionValues)
class PermissionsController < ApplicationController
  before_filter :authenticate_admin

  # GET /permissions
  def index
    @permissions = Permission.by_sort_order
  end

  # GET /permissions/1
  def show
    @permission = Permission.find(params[:id])
    @permission_values = PermissionValue.where(permission_code: @permission.code)
    @permission_value = PermissionValue.new
  end

  # GET /permissions/new
  def new
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
    @permission = Permission.find(params[:id])
  end

  # POST /permissions
  def create
    @permission = Permission.new
    @permission.code = "#{prefix}#{params[:permission][:code]}"
    @permission.web_text = params[:permission][:web_text]
    @permission.from_aleph = (params[:permission][:from_aleph]) ? params[:permission][:from_aleph] : false

    respond_to do |format|
      if @permission.save
        flash[:notice] = t("permissions.create_success")
        format.html { redirect_to(@permission) }
      else
        #If failed, set the code back to user-entered code, without prefix
	      @permission.code = params[:permission][:code]
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.js
  def update
    @permission = Permission.find(params[:id])
    @permissions = Permission.by_sort_order

    respond_to do |format|
      if @permission.update_attributes(permission_params)
        flash[:notice] = t("permissions.update_success")
        format.html { redirect_to(@permission) }
        format.js { render :nothing => true } if request.xhr?
      else
        flash[:danger] = t("permissions.update_failure")
        format.html { render :action => "edit" }
        format.js { render :nothing => true } if request.xhr?
      end
    end
  end

  # PUT /permissions/update_order
  # PUT /permissions/update_order.js
  def update_order
    if params[:permissions]
      params[:permissions].each_with_index do |id, index|
        Permission.find(id).update(sort_order: index+1)
      end
    end
    respond_to do |format|
      format.html { redirect_to permissions_url, notice: t("permissions.update_order_success") and return }
      format.js { render :layout => false } if request.xhr?
    end
  end

  # DELETE /permissions/1
  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to permissions_url, notice: t("permissions.delete_succes") }
    end
  end

  private
  def permission_params
    if params[:permission].present?
      params.require(:permission).permit(:code, :from_aleph, :visible, :web_text)
    else
      {}
    end
  end

  def prefix
    #This handles local creation of patron statuses by adding a namespace prefix, namely nyu_ag_noaleph_
    @prefix ||= (!params[:permission][:from_aleph].nil?) ? local_creation_prefix : ""
  end
end
