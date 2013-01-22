# This parent module defines Sunspot search methods and helpers
#
# This sub module Searchers::Sublibrary defines specific methods to be included in the controller
# for searching a Sunspot index of sublibraries
module Searchers
  module Sublibrary
      
      # Retrieve actual records from sunspot search
      def sublibraries_results
        @sublibraries_results ||= sublibraries_search.results
      end

      # Shortcut for retrieving hits from sunspot search
      def sublibraries_hits
        @sublibraties_hits ||= sublibraries_search.hits
      end

      # Shortcut for retrieving sublibrary code if it exists
      def sublibrary_code
        @sublibrary_code ||= @sublibrary.code unless @sublibrary.nil?
      end
      
      # Shortcut for retrieving sublibrary object
      def sublibrary
        @sublibrary ||= ::Sublibrary.find_by_code(params[:sublibrary_code]) if params[:sublibrary_code].present?
      end
      private :sublibrary

      # Sunspot Sublibraries search
      def sublibraries_search
        ::Sublibrary.search {
        # Options for admin sublibraries search
        if is_admin? && is_in_admin_view?
          # Full text search possible on default fields
          fulltext params[:q]
          # Sort by both fields if no sorting fn used
          unless params[:sort].present?
            order_by(:sort_header, :asc)
            order_by(:sort_text, :asc)
          else
            order_by(sort_column.to_sym, sort_direction.to_sym)
          end
          paginate :page => params[:page] || 1, :per_page => 30
        else
          # Only visible
          with(:visible_frontend, true)
          # Default sort
          order_by(:sort_header, :asc)
          order_by(:sort_text, :asc)  
        end
        }
      end
      

  end
end