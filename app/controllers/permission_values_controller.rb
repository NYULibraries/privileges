# This controller handles the values which are assigned to permissions
class PermissionValuesController < ApplicationController
  before_filter :authenticate_admin

  # GET /permission_values/1
  def show
    @permission_value = PermissionValue.find(params[:id])
    @permission = Permission.find_by_code(@permission_value.permission_code)
  end

  # GET /permission_values/1/edit
  def edit
    @permission_value = PermissionValue.find(params[:id])
    @permission = Permission.find_by_code(@permission_value.permission_code)
  end

  # POST /permission_values
  def create
    @permission_value = PermissionValue.new(permission_value_params)
    @permission_value.code = "#{prefix}#{params[:permission_value][:code]}"
    @permission_value.from_aleph = (params[:permission_value][:from_aleph]) ? params[:permission_value][:from_aleph] : false

    @permission = Permission.find_by_code(@permission_value.permission_code)
    @permission_values = PermissionValue.where(permission_code: @permission.code)

    respond_to do |format|
      if @permission_value.save
        flash[:notice] = t("permission_values.create_success")
        format.html { redirect_to(@permission) }
      else
        #If failed, set the code back to user-entered code, without prefix
        @permission_value.code = params[:permission_value][:code]
        flash[:danger] = t("permission_values.create_failure")
        format.html { redirect_to @permission }
      end
    end
  end

  # PUT /permission_values/1
  def update
    @permission_value = PermissionValue.find(params[:id])
    @permission = Permission.find_by_code(@permission_value.permission_code)

    respond_to do |format|
      if @permission_value.update_attributes(permission_value_params)
        flash[:notice] = t("permission_values.update_success")
        format.html { redirect_to(@permission) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /permission_values/1
  def destroy
    @permission_value = PermissionValue.find(params[:id])
    @permission = @permission_value.permission
    @permission_value.destroy

    respond_to do |format|
      format.html { redirect_to @permission }
    end
  end

  private
  def permission_value_params
    if params[:permission_value].present?
      params.require(:permission_value).permit(:code, :web_text, :from_aleph, :permission_code)
    else
      {}
    end
  end

  def prefix
    @prefix ||= (!params[:permission_value][:from_aleph]) ? local_creation_prefix : ""
  end
end
