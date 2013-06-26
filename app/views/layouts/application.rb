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
      
      # Stylesheets to include in layout
      def stylesheets
        catalog_stylesheets
      end
      
      # Javascripts to include in layout
      def javascripts
        catalog_javascripts
      end

      def application
        strip_tags(application_name)
      end
      
      def title
        application
      end
      
      # Render the sidebar partial
      def sidebar
        render :partial => "common/sidebar"
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
      
      # Render footer partial
      def footer
        render :partial => "common/footer"
      end
      
      # Prepend modal dialog elements to the body
      def prepend_body
        content_tag(:div, nil, :class => "modal-container")+
        content_tag(:div, nil, :id => "ajax-modal", :class => "modal hide fade", :tabindex => "-1")
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