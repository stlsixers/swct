# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'change', '#card_sets_select', (evt) ->
    $.ajax 'update_cards',
      type: 'GET'
      dataType: 'script'
      data: {
        card_set_id: $("#card_sets_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")
  $(document).on 'change', '#categories_select', (evt) ->
    $.ajax 'update_machines',
      type: 'GET'
      dataType: 'script'
      data: {
        category_id: $("#categories_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")