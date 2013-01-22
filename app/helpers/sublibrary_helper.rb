module SublibraryHelper
  
  # Determine whether or not this @patron_status has access to the given sublibrary
  # * Return false if the sublibraries with access instance var is nil, that means there are no sublibraries this use has access to
  # * Return true if the current sublibrary is in the list of sublibraries this user has access to
  def access_to_sublibrary(sublibrary)
    (@sublibraries_with_access.nil?) ? false : (@sublibraries_with_access.include? sublibrary)
  end
  
  # Made a decision to print the sublibrary code if no web text is available
  def sublibrary_text(sublibrary)
    (sublibrary.web_text.empty?) ? sublibrary.code : sublibrary.web_text.html_safe
  end
  
  # Loop through grouped sublibraries to make optgroups for printing
  def grouped_sublibraries
    html = ""
    @sublibraries.keys.each do |sublibrary_group|
      html << content_tag(:optgroup, label: sublibrary_group) {
        @sublibraries[sublibrary_group].collect {|sublibrary|
         concat(content_tag(:option, "#{strip_tags(sublibrary.stored(:web_text))} #{!access_to_sublibrary(sublibrary.stored(:code)) ? '(no access)' : ''}", value: sublibrary.stored(:code), disabled: !access_to_sublibrary(sublibrary.stored(:code)), selected: sublibrary_selected(sublibrary)))
        }
      }
    end
    html
  end
  
  # Logic to decide if sublibrary option is selected
  # * True if sublibrary code exists and equals current selected param
  def sublibrary_selected(sublibrary)
    (!sublibrary.stored(:code).nil? && params[:sublibrary_code] == sublibrary.stored(:code))
  end

end