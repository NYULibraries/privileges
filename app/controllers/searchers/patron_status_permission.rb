# This parent module defines Sunspot search methods and helpers
#
# This sub module Searchers::PatronStatusPermission defines specific methods to be included in the controller
# for searching a Sunspot index of patron status permissions
module Searchers
  module PatronStatusPermission
      # Join patron status permissions retrieved from Sunspot search to additional elements needed for display
      def patron_status_sublibrary_permissions
        unless @sublibrary.nil?
          #Retrieve IDs from Solr for these PatronStatusPermissions
          psp_hits = patron_status_permissions_hits
          #Get only fields required to show permission relation to user after sunspot searching returns hits
          @patron_status_sublibrary_permissions ||= ::PatronStatusPermission.select("patron_status_permissions.*, permissions.web_text as permission_web_text, permission_values.web_text as permission_value_web_text").where(:id => psp_hits.map(&:to_param)).joins(:permission_value => :permission).order("permissions.sort_order asc")
        end
      end
      
      # Shortcut to get patron status permissions hits
      def patron_status_permissions_hits
        @patron_status_permissions_hits ||= patron_status_permissions_search(patron_status_code, sublibrary_code).hits
      end
      
      # Perform Sunspot PatronStatusPermissions search
      def patron_status_permissions_search patron_status_code, sublibrary_code
        ::PatronStatusPermission.search {
          # Find permission for this combo of status/library
          with(:patron_status_code, patron_status_code)
          with(:sublibrary_code, sublibrary_code)
          # Only show is the permission itself (separate model Permission) is set to visible
          with(:permission_visible, true)
          # Show hidden patron status permission to admin users in the admin panel
          with(:visible, true) unless is_admin? && is_in_admin_view?
        }
      end
    end
end