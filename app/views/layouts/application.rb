# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Application < ActionView::Mustache
      # Meta tags to include in layout
      def meta
        meta = super
        meta << tag(:meta, :name => "HandheldFriendly", :content => "True")
        meta << tag(:meta, :name => "cleartype", :content => "on")
        meta << favicon_link_tag('https://library.nyu.edu/favicon.ico')
      end

      def application_title
        strip_tags(application_name)
      end
      
      def gauges_tracking_code
        Settings.gauges.tracking_code
      end
      
      # Print breadcrumb navigation
      def breadcrumbs
        breadcrumbs = super
        breadcrumbs << link_to_unless_current(strip_tags(application_name), root_url)
        breadcrumbs << link_to('Admin', :controller => 'users') if is_in_admin_view?
        breadcrumbs << link_to_unless_current(controller.controller_name.humanize, {:action => :index}) unless controller.controller_name.eql? "access_grid"
        breadcrumbs << link_to_unless_current(@patron_status.web_text) unless @patron_status.nil? or is_in_admin_view?
        return breadcrumbs
      end
    
      # Prepend modal dialog elements to the body
      def prepend_body
        render 'common/prepend_body'
      end
      
      # Prepend the flash message partial before yield
      def prepend_yield
        content_tag :div, :id => "main-flashses" do
         render :partial => 'common/flash_msg'
        end
      end

      # Boolean for whether or not to show tabs
      # This application doesn't need tabs
      def show_tabs
        false
      end
  
    end
  end
end