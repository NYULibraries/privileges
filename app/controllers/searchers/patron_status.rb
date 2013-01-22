# This parent module defines Sunspot search methods and helpers
#
# This sub module Searchers::PatronStatus defines specific methods to be included in the controller
# for searching a Sunspot index of patron statuses
module Searchers
  module PatronStatus
      # Shortcut for retrieving patron status results from database
      def patron_statuses_results
        @patron_statuses_results ||= patron_statuses_search.results
      end
      
      # Shortcut for retrieving patron status hits
      def patron_statuses_hits
        @patron_statuses_hits ||= patron_statuses_search.hits
      end

      # Get patron status code if it exists
      def patron_status_code
        @patron_status_code ||= @patron_status.code unless @patron_status.nil?
      end
      
      # Retrive a list of sublibraries this patron status has access to
      def sublibraries_with_access
        @sublibraries_with_access ||= patron_statuses_hits.first.stored(:sublibraries_with_access) unless patron_statuses_hits.nil?
      end
      
      # Sunspot Patron Statuses search
      def patron_statuses_search
        ::PatronStatus.search {
          # We don't want nil values for admin or non admin
          without(:web_text, nil)
          # Options for admin patron status search
          if is_admin? && is_in_admin_view?
            fulltext params[:q], :fields => [:keywords, :web_text, :code, :description, :under_header, :original_text]
            # Default search should be by header and then by web-text
            unless params[:sort].present?
              order_by(:sort_header, :asc)
              order_by(:web_text, :asc)
            # Sort by sort parameter
            else
              order_by(sort_column.to_sym, sort_direction.to_sym)
            end
            paginate :page => params[:page] || 1, :per_page => 30

          # Options for nonadmin patron status search
          else
            # Limited search for non admins
            fulltext params[:q], :fields => [:keywords, :web_text, :code]
            # Only visible patron statuses
            with(:visible, true)
            # Find only patron statuses with access to the given sublibrary
            with(:sublibraries_with_access, params[:sublibrary_code]) if params[:sublibrary_code].present?
            # Only find one patron status if defined
            with(:code, params[:patron_status_code]) if params[:patron_status_code].present?
            order_by(:sort_header, :asc)
            order_by(:web_text, :asc)
          end
        }
      end
  end
end