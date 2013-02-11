# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Bobcat < ActionView::Mustache
      # Meta tags to include in layout
      def meta
        meta = '<!-- Mobile viewport optimization h5bp.com/ad -->
        <meta name="HandheldFriendly" content="True">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">

        <!-- Mobile IE allows us to activate ClearType technology for smoothing fonts for easy reading -->
        <meta http-equiv="cleartype" content="on">'.html_safe

        meta << favicon_link_tag('https://library.nyu.edu/favicon.ico')
      end
      
      # Stylesheets to include in layout
      def stylesheets
        catalog_stylesheets = stylesheet_link_tag "http://fonts.googleapis.com/css?family=Muli"
        catalog_stylesheets += stylesheet_link_tag "application"
      end

      # Javascripts to include in layout
      def javascripts
        catalog_javascripts = javascript_include_tag "application"
      end

      # Generate link to application root
      def application
        application = link_to title, root_path
      end
      
      # Render the sidebar partial
      def sidebar
        render :partial => "shared/sidebar"
      end
      
      # Using Gauges?
      def gauges?
        (Rails.env.eql?("production") and (not gauges_tracking_code.nil?))
      end

      def gauges_tracking_code
        '51190f53108d7b115100000b'
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
        render :partial => "shared/footer"
      end
      
      # Prepend modal dialog elements to the body
      def prepend_body
        prepend_body = '<div class="modal-container"></div>'.html_safe
        prepend_body << '<div id="ajax-modal" class="modal hide fade" tabindex="-1"></div>'.html_safe
      end
      
      # Prepend the flash message partial before yield
      def prepend_yield
        content_tag :div, :id => "main-flashses" do
         render :partial => 'shared/flash_msg'
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