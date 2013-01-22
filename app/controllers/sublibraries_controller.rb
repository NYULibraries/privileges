class SublibrariesController < ApplicationController
  before_filter :authenticate_admin
  
  # GET /sublibraries
  def index
    @sublibraries = sublibraries_search
  end

  # GET /sublibraries/1
  def show
    @sublibrary = Sublibrary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /sublibraries/new
  def new
    @sublibrary = Sublibrary.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /sublibraries/1/edit
  def edit
    @sublibrary = Sublibrary.find(params[:id])
  end

  # POST /sublibraries
  def create
    @sublibrary = Sublibrary.new
    @sublibrary.code = "#{prefix}#{params[:sublibrary][:code]}"
    @sublibrary.web_text = params[:sublibrary][:web_text]
    @sublibrary.from_aleph = (params[:sublibrary][:from_aleph]) ? params[:sublibrary][:from_aleph] : false
    @sublibrary.under_header = params[:sublibrary][:under_header]
    
    respond_to do |format|
      if @sublibrary.save
        format.html { redirect_to @sublibrary, notice: t('sublibraries.create_success') }
      else
        # If failed, set the code back to user-entered code for rendering, without prefix
        @sublibrary.code = params[:sublibrary][:code]
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /sublibraries/1
  # PUT /sublibraries/1.js
  def update
    @sublibrary = Sublibrary.find(params[:id])
    @sublibraries = sublibraries_results

    respond_to do |format|
      if @sublibrary.update_attributes(params[:sublibrary])
        flash[:notice] = t('sublibraries.update_success')
        format.html { redirect_to @sublibrary }
        format.js { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.js { render :nothing => true }
      end
    end
  end

  # DELETE /sublibraries/1
  def destroy
    @sublibrary = Sublibrary.find(params[:id])
    @sublibrary.destroy

    respond_to do |format|
      format.html { redirect_to sublibraries_url, notice: t('sublibraries.destory_success') }
    end
  end

  def sort_column
    super "Sublibrary", "sort_text"
  end
  helper_method :sort_column

  def prefix
    #This handles local creation of patron statuses by adding a namespace prefix, namely nyu_ag_noaleph_
    @prefix ||= (!params[:sublibrary][:from_aleph]) ? local_creation_prefix : ""
  end
  private :prefix
  
end
