module Privileges
  module Search
    class SublibrarySearch < Base
      PARAM_FIELDS = [:q, :sort, :direction, :page]
      attr_reader *PARAM_FIELDS
      attr_reader :admin_view

      def self.new_from_params(params, **options)
        nonempty_params = params.compact.select{|k,v| v.present? }
        filtered_params = nonempty_params.symbolize_keys.slice(*PARAM_FIELDS)
        new **filtered_params.merge(options)
      end

      def initialize(q: nil, sort: nil, direction: :asc, page: 1, admin_view: false)
        @q = q
        @sort = sort
        @direction = direction
        @page = page
        @admin_view = admin_view
      end

      # Sunspot Sublibraries search
      def solr_search
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
              order_by(sort.to_sym, direction.to_sym)
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
