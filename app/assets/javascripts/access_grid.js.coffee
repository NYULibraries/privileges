$ ->
  new window.nyulibraries.Tooltip('.record-help').html(false).trigger('hover').init()
  $('ul#edit_permissions_list').sortable { 
    handle: "i.icon-move"
    update: -> $(this).closest("form").submit()
    opacity: 0.4
    cursor: 'move'
  }
  $("*[type='submit'][data-remote='true']").closest("tr").hide()
  $("*[type='submit'][data-remote='true']").hide()
  $("#edit_patron_status_permissions").find("select").live 'change', ->
    $(this).closest("form").submit()
  $("#patron_status_permission_new_form").find("select#permission_code_").live 'change', ->
    $.ajax {
      url: $(this).closest("form").attr "action"
      type: $(this).closest("form").attr "method"
      data: $(this).closest("form").serialize()
    }
  $("#show_user").find("input[type='checkbox']").live 'change', ->
    $(this).closest("form").submit()
  $("a.toggle_visible").live 'click', ->
    if ($(this).text() == "Hide") 
      $(this).html("Reveal")
      $(this).prevAll("h4.permission_header:first").addClass("is-hidden")
      $(this).closest("tr").addClass("is-hidden")
    else 
      $(this).html("Hide")
      $(this).prevAll("h4.permission_header:first").removeClass("is-hidden")
      $(this).closest("tr").removeClass("is-hidden")
  $(".autocomplete_query").typeahead {
    source: (query, process) -> 
        $.getJSON($(".autocomplete_query").closest("form").attr("action") + ".json", { query: query }, process);
  }
  $("#get_sublibrary_permissions").find("select").live 'change', -> 
    $("#permissions_chart").children().hide()
    $("#permissions_chart").prepend($("<div />").attr({'id': 'permissions_progress'}).addClass("progress progress-striped active").append($("<div />").addClass("bar").css({width: '5%'})));
    setTimeout( -> 
      $("#permissions_progress > div.bar").css({width: "98%"})
    , 0)
    $(this).closest("form").submit ->
      success: -> 
        $("#permissions_progress").remove
    $(this).closest("form").submit()
