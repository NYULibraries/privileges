# This controller handles methods for administrator-managed
# application text, which are displayed to frontend users
#
class ApplicationDetailsController < ApplicationController
  before_filter :authenticate_admin
  respond_to :html

  # GET /application_details
  def index
    @application_details = ApplicationDetail.all
    respond_with(@application_details)
  end

  # GET /application_details/1/edit
  def edit
    @application_detail = ApplicationDetail.find(params[:id])
    respond_with(@application_detail)
  end

  # PUT /application_details/1
  def update
    @application_detail = ApplicationDetail.find(params[:id])
    flash[:notice] = t('application_details.update_success') if @application_detail.update_attributes(application_detail_params)

    respond_with(@application_detail, location: application_details_path)
  end

  private
  def application_detail_params
    if params[:application_detail].present?
      params.require(:application_detail).permit(:purpose, :the_text, :description)
    else
      {}
    end
  end
end
