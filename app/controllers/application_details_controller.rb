# This controller handles methods for administrator-managed
# application text, which are displayed to frontend users
#
class ApplicationDetailsController < ApplicationController
  before_filter :authenticate_admin
  
  # GET /application_details
  def index
    @application_details = ApplicationDetail.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /application_details/1/edit
  def edit
    @application_detail = ApplicationDetail.find(params[:id])
  end

  # PUT /application_details/1
  def update
    @application_detail = ApplicationDetail.find(params[:id])

    respond_to do |format|
      if @application_detail.update_attributes(params[:application_detail])
        flash[:notice] = t('application_details.update_success')
        format.html { redirect_to(application_details_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
