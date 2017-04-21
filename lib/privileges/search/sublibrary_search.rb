module Privileges
  module Search
    class SublibrarySearch < Base
      FIELDS = [:q, :sort, :direction, :page, :admin_view]
      attr_reader *FIELDS

      def initialize(q: nil, sort: nil, direction: :asc, page: 1, admin_view: false)
        @q = q
        @sort = sort
        @direction = direction
        @page = page
        @admin_view = admin_view
      end

      def solr_search
        @solr_search ||= ::Sublibrary.search do
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
        end
      end

      def cache_key
        FIELDS.each{|field| public_send(field).inspect }.join("--")
      end
    end
  end
end
