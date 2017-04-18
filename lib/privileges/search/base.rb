module Privileges
  module Search
    class Base
      # Shortcut for retrieving patron status results from database
      def results
        @results ||= solr_search.results
      end

      # Shortcut for retrieving patron status hits
      def hits
        @hits ||= solr_search.hits
      end
    end
  end
end
