module Privileges
  module Search
    class SublibrarySearch
      FIELDS = [:q, :sort, :sort_column, :sort_direction, :page, :admin_view]
      attr_accessor *FIELDS

      def self.new_from_params(params, **options)
        new **params.compact.symbolize_keys.merge(options).slice(*FIELDS)
      end

      def initialize(q: nil, sort: nil, sort_column: :title_search, sort_direction: :asc, page: 1, admin_view: false)
        @q = q
        @sort = sort
        @sort_column = sort_column
        @sort_direction = sort_direction
        @page = page
        @admin_view = admin_view
      end

      # Retrieve actual records from sunspot search
      def results
        @results ||= search.results
      end

      # Shortcut for retrieving hits from sunspot search
      def hits
        @hits ||= search.hits
      end

      # Sunspot Sublibraries search
      def search
        ::Sublibrary.search {
        # Options for admin sublibraries search
        if admin_view
          # Full text search possible on default fields
          fulltext q
          # Sort by both fields if no sorting fn used
          unless sort.present?
            order_by(:sort_header, :asc)
            order_by(:sort_text, :asc)
          else
            order_by(sort_column.to_sym, sort_direction.to_sym)
          end
          paginate page: page, per_page: 30
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
end
