module ApplicationHelper

  def application_title
    get_formatted_detail('page_title')
  end

  # Print formatted page title as application name
  def application_name
    get_formatted_detail('page_title')
  end
  
  # Stylesheets to include in layout
  def catalog_stylesheets
    catalog_stylesheets = stylesheet_link_tag "http://fonts.googleapis.com/css?family=Muli"
    catalog_stylesheets += stylesheet_link_tag "application"
  end

  # Javascripts to include in layout
  def catalog_javascripts
    catalog_javascripts = javascript_include_tag "application"
  end

  # Create a select tag with permission values and select the correct one based on this PatronStatusPermission
  def get_permission_value(ps_perm)
   permission_values = ps_perm.permission.permission_values
   select_tag "update_permission_ids[#{ps_perm.id}]", options_for_select(permission_values.collect{ |pv| [pv.web_text.html_safe, pv.id] }, {:selected => ps_perm.permission_value_id}), {:prompt => "Select a permission value" }
  end

  # Format and santitize detail from database
  def get_formatted_detail(purpose, css = nil)
   simple_format(get_sanitized_detail(purpose), :class => css)
  end
  
  # Fetch application detail text by purpose
  def detail_by_purpose(purpose)
    ApplicationDetail.find_by_purpose(purpose)
  end

  # Sanitize detail
  def get_sanitized_detail(purpose)
   application_detail = detail_by_purpose(purpose)
   return print_sanitized_html(application_detail.the_text) if text_exists?(purpose)
  end

  # Returns boolean for whether or not there exists application detail text for this purpose
  def text_exists?(purpose)
   text = detail_by_purpose(purpose)
   return !(text.nil? || text.the_text.empty?)
  end

  # Sanitize HTML
  def print_sanitized_html(html)
   sanitize(html, :tags => %w(b strong i em br p a ul li), :attributes => %w(target href class)).html_safe
  end

  # Format html
  def print_formatted_html(html)
    simple_format(print_sanitized_html(html)).html_safe unless html.blank?
  end

  # Define hidden class value
  def hidden_class(inst)
   "is-hidden" unless inst.visible
  end
  
  # Will output HTML pagination controls. Modeled after blacklight helpers/blacklight/catalog_helper_behavior.rb#paginate_rsolr_response
  # Equivalent to kaminari "paginate", but takes a Sunspot response as first argument. 
  # Will convert it to something kaminari can deal with (using #paginate_params), and
  # then call kaminari page_entries_info with that. Other arguments (options and block) same as
  # kaminari paginate, passed on through. 
  def page_entries_info_sunspot(response, options = {}, &block)
    per_page = response.results.count
    per_page = 1 if per_page < 1
    current_page = (response.results.offset / per_page).ceil + 1
    page_entries_info Kaminari.paginate_array(response.results, :total_count => response.total).page(current_page).per(per_page), options, &block
  end

  # Retrieve a value matching a key to an icon class name
  def icons key
    icons_info[key.to_s]
  end
  
  # Load the icons YAML info file
  def icons_info
    @icons_info ||= YAML.load_file( File.join(Rails.root, "config", "icons.yml") )
  end
  
  # Generate a tooltip tag
  def tooltip_tag content, title
    link_to(content, "#", :class => "help-inline record-help", :data => { :placement => "right" }, :rel => "tooltip", :target => "_blank", :title => title)
  end
  
  # Generate an icon tag with class key
  def icon_tag key
    content_tag :i, "", :class => icons(key)
  end
  
  # Generate an abbr tag for long words
  def word_break word
    if word.length > 10
      content_tag :abbr, truncate(word, :length => 10), :title => word
    else
      word
    end
  end
  
  # Generate link to sorting action
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    direction_icon = (direction.eql? "desc") ? :sort_desc : :sort_asc
    search = params[:search]  
    html = link_to title, params.merge(:sort => column, :direction => direction, :page => nil, :id => ""), {:class => css_class}
    html << icon_tag(direction_icon) if column == sort_column
    return html
  end
end
