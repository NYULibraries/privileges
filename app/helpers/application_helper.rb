module ApplicationHelper

  # Print formatted page title as application name
  def application_name
    get_formatted_detail('page_title')
  end

  # Create a select tag with permission values and select the correct one based on this PatronStatusPermission
  def get_permission_value(ps_perm)
   permission_values = ps_perm.permission.permission_values
   select_tag "update_permission_ids[#{ps_perm.id}]", options_for_select(permission_values.collect{ |pv| [pv.web_text.html_safe, pv.id] }, {selected: ps_perm.permission_value_id}),
    {prompt: "Select a permission value", class: 'form-control'}
  end

  # Format and santitize detail from database
  def get_formatted_detail(purpose, css = nil)
   simple_format(get_sanitized_detail(purpose), class: css)
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
   sanitize(html, tags: %w(b strong i em br p a ul li), attributes: %w(target href class)).html_safe
  end

  # Format html
  def print_formatted_html(html)
    simple_format(print_sanitized_html(html)).html_safe unless html.blank?
  end

  # Define hidden class value
  def hidden_class(inst)
   "is-hidden" unless inst.visible
  end

  # Generate an abbr tag for long words
  def word_break word
    if word.length > 10
      content_tag :abbr, truncate(word, length: 10), title: word
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
    html = link_to title, params.merge(sort: column, direction: direction, page: nil, id: ""), {class: css_class}
    html << icon_tag(direction_icon) if column == sort_column
    return html
  end
end
