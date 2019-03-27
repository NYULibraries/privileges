# The controller handles the class that manages information for each patron status
class PatronStatusesController < ApplicationController
  before_action :authenticate_admin

  # GET /patron_statuses
  # GET /patron_statuses.json
  def index
    @patron_status_search = patron_status_search

    respond_to do |format|
      format.json do
        render json: @patron_status_search.results,
               layout: false and return
      end
      format.html
    end
  end

  # GET /patron_statuses/1
  def show
    @patron_status = PatronStatus.find(params[:id])
    @permissions = Permission.visible.where(from_aleph: false)
    @permission_values = PermissionValue.where(permission_code: params[:permission_code])
    @sublibraries = Sublibrary.search{ order_by(:sort_text, :asc) }.results
    @sublibrary = sublibrary
    @patron_status_permission = PatronStatusPermission.new
    @patron_status_permissions = patron_status_permissions
  end

  # GET /patron_statuses/new
  def new
    @patron_status = PatronStatus.new
  end

  # GET /patron_statuses/1/edit
  def edit
    @patron_status = PatronStatus.find(params[:id])
  end

  # POST /patron_statuses
  def create
    @patron_status = PatronStatus.new

    @patron_status.code = "#{prefix}#{patron_status_params[:code]}"
    @patron_status.web_text = patron_status_params[:web_text]
    @patron_status.keywords = patron_status_params[:keywords]
    @patron_status.from_aleph = (patron_status_params[:from_aleph]) ? patron_status_params[:from_aleph] : false
    @patron_status.under_header = patron_status_params[:under_header] unless patron_status_params[:under_header].blank?
    @patron_status.id_type = patron_status_params[:id_type]

    respond_to do |format|
      if @patron_status.save
        flash[:notice] = t('patron_statuses.create_success')
        format.html { redirect_to(@patron_status) }
      else
        #If failed, set the code back to user-entered code, without prefix
        @patron_status.code = patron_status_params[:code]
        format.html { render action: "new" }
      end
    end
  end

  # PUT /patron_statuses/1
  # PUT /patron_statuses/1.js
  def update
    @patron_status = PatronStatus.find(params[:id])
    @patron_statuses = patron_status_search.results

    respond_to do |format|
      if @patron_status.update_attributes(patron_status_params)
        flash[:notice] =  t('patron_statuses.update_success')
        format.html { redirect_to @patron_status }
        format.js { render nothing: true } if request.xhr?
      else
        format.html { render action: "edit" }
        format.js { render nothing: true } if request.xhr?
      end
    end
  end

  # DELETE /patron_statuses/1
  def destroy
    @patron_status = PatronStatus.find(params[:id])
    @patron_status.destroy

    respond_to do |format|
      format.html { redirect_to(patron_statuses_url) }
    end
  end

  # Local implementation of parent sort_column function
  def sort_column
    super "PatronStatus", ""
  end
  helper_method :sort_column

  private

  def patron_status_search
    @patron_status_search ||= Privileges::Search::PatronStatusSearch.new(**patron_status_search_params)
  end

  def patron_status_search_params
    params.permit(:q, :sort, :direction, :page, :patron_status_code, :sublibrary_code)
      .select{|k,v| v.present? }.to_h.symbolize_keys.merge(admin_view: admin_view?)
  end

  # Shortcut for retrieving sublibrary object
  def sublibrary
    @sublibrary ||= ::Sublibrary.find_by_code(params[:sublibrary_code]) if params[:sublibrary_code].present?
  end

  def patron_status_params
    params.require(:patron_status).permit(:web_text, :keywords, :under_header, :id_type, :description, :visible, :from_aleph, :code)
  end

  # Retreive this @patron_status patron_status_permissions with additional information joined in for display
  def patron_status_permissions
    @patron_status_permissions ||= @patron_status.patron_status_permissions.joins(permission_value: :permission).where(permissions: {visible: true}, sublibrary_code: sublibrary.code).order("permissions.sort_order asc") unless sublibrary.nil?
  end

  def prefix
    #This handles local creation of patron statuses by adding a namespace prefix, namely nyu_ag_noaleph_
    @prefix ||= (!params[:patron_status][:from_aleph].nil?) ? local_creation_prefix : ""
  end
end
