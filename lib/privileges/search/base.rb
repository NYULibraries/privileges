module Privileges
  module Search
    class Base
      def total
        @total ||= cached_solr_search.total
      end

      def results
        @results ||= cached_solr_search.results
      end

      def hits
        @hits ||= cached_solr_search.hits
      end

      def cached_solr_search
        solr_search.tap do |search_obj|
          cache.write(full_cache_key, search_obj)
        end
      rescue RSolr::Error::Http => e
        cache.read(full_cache_key)
      rescue StandardError => e
        cache.read(full_cache_key)
      end

      def solr_search
        raise "You must define solr_search in your subclass of Privileges::Search::Base"
      end

      def cache_key
        raise "You must define cache_key in your subclass of Privileges::Search::Base"
      end

      private
      def full_cache_key
        [self.class.name, cache_key, "solr_search"].join("/")
      end

      def cache
        Rails.cache
      end
    end
  end
end
