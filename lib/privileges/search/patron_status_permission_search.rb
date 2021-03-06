module Privileges
  module Search
    class PatronStatusPermissionSearch < Base
      FIELDS = [:patron_status_code, :sublibrary_code, :admin_view]
      attr_reader *FIELDS

      def initialize(patron_status_code: nil, sublibrary_code: nil, admin_view: false)
        @patron_status_code = patron_status_code
        @sublibrary_code = sublibrary_code
        @admin_view = admin_view
      end

      # Join patron status permissions retrieved from Sunspot search to additional elements needed for display
      def sublibrary_permissions
        return unless sublibrary_code
        return @sublibrary_permissions if @sublibrary_permissions
        #Get only fields required to show permission relation to user after sunspot searching returns hits
        @sublibrary_permissions = ::PatronStatusPermission
          .select("patron_status_permissions.*, permissions.web_text as permission_web_text, permission_values.web_text as permission_value_web_text")
          .joins(permission_value: :permission).where(id: hits.map(&:to_param)).order("permissions.sort_order asc")
      end

      # def cached_patron_status_permissions_search(patron_status_code, sublibrary_code)
      #   result = patron_status_permissions_search(patron_status_code, sublibrary_code)
      #   if result.hits.empty?
      #     cached_result = Rails.cache.read(patron_status_permissions_search_cache_key(patron_status_code, sublibrary_code))
      #     return caches_result || result
      #   end
      #   key = patron_status_permissions_search_cache_key(patron_status_code, sublibrary_code)
      #   Rails.cache.write(key, result)
      # rescue RSolr::Error::Http => e
      #   Rails.cache.read(patron_status_permissions_search_cache_key(patron_status_code, sublibrary_code))
      # end

      def solr_search
        @solr_search ||= ::PatronStatusPermission.search do
          # Find permission for this combo of status/library
          with(:patron_status_code, patron_status_code)
          with(:sublibrary_code, sublibrary_code)
          # Only show is the permission itself (separate model Permission) is set to visible
          with(:permission_visible, true)
          # Show hidden patron status permission to admin users in the admin panel
          with(:visible, true) unless admin_view
        end
      end

      def cache_key
        FIELDS.each{|field| public_send(field).inspect }.join("--")
      end
    end
  end
end
