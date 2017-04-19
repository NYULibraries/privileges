module PaginationHelper
  # Will output HTML pagination controls. Modeled after blacklight helpers/blacklight/catalog_helper_behavior.rb#paginate_rsolr_response
  # Equivalent to kaminari "paginate", but takes a Sunspot response as first argument.
  # Will convert it to something kaminari can deal with (using #paginate_params), and
  # then call kaminari page_entries_info with that. Other arguments (options and block) same as
  # kaminari paginate, passed on through.
  def page_entries_info_sunspot(search, options = {}, &block)
    per_page = search.results.count
    per_page = 1 if per_page < 1
    current_page = (search.results.offset / per_page).ceil + 1
    page_entries_info Kaminari.paginate_array(search.results, total_count: search.total).page(current_page).per(per_page), options, &block
  end
end
