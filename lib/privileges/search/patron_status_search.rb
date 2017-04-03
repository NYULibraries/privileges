module Privileges
  module Search
    class PatronStatusSearch
      FIELDS = [:q, :sort, :page, :patron_status_code, :sublibrary_code, :sort_column, :sort_direction, :admin_view]
      attr_accessor *FIELDS

      def self.new_from_params(params, **options)
        new **params.compact.symbolize_keys.merge(options).slice(*FIELDS)
      end

      def initialize(q: nil, sort: nil, page: 1, patron_status_code: nil, sublibrary_code: nil, sort_column: :title_search, sort_direction: :asc, admin_view: false)
        @q = q
        @sort = sort
        @page = page
        @patron_status_code = patron_status_code
        @sublibrary_code = sublibrary_code
        @sort_column = sort_column
        @sort_direction = sort_direction
        @admin_view = admin_view
      end

      def page
        @page || 1
      end

      # Shortcut for retrieving patron status results from database
      def results
        @results ||= search.results
      end

      # Shortcut for retrieving patron status hits
      def hits
        @hits ||= search.hits
      end

      # # Get patron status code if it exists
      # def patron_status_code
      #   @patron_status_code ||= @patron_status.code unless @patron_status.nil?
      # end

      # Retrive a list of sublibraries this patron status has access to
      def sublibraries_with_access
        @sublibraries_with_access ||= hits.first.stored(:sublibraries_with_access) if hits
      end

      # Sunspot Patron Statuses search
      def search
        ::PatronStatus.search {
          # We don't want nil values for admin or non admin
          without(:web_text, nil)
          # Options for admin patron status search
          if admin_view
            fulltext q, fields: [:keywords, :web_text, :code, :description, :under_header, :original_text]
            # Default search should be by header and then by web-text
            unless sort
              order_by(:sort_header, :asc)
              order_by(:web_text, :asc)
            # Sort by sort parameter
            else
              order_by(sort_column.to_sym, sort_direction.to_sym)
            end
            paginate page: page, per_page: 30

          # Options for nonadmin patron status search
          else
            # Limited search for non admins
            fulltext q, fields: [:keywords, :web_text, :code]
            # Only visible patron statuses
            with(:visible, true)
            # Find only patron statuses with access to the given sublibrary
            with(:sublibraries_with_access, sublibrary_code) if sublibrary_code.present?
            # Only find one patron status if defined
            with(:code, patron_status_code) if patron_status_code.present?
            order_by(:sort_header, :asc)
            order_by(:web_text, :asc)
          end
        }
      end
    end
  end
end
