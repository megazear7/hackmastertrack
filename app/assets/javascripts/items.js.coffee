# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  if $(".character-select").val()
    updateSpecializations($(".character-select").val())

  $(".character-select").change (e) ->
    if $(e.target).val()
      updateSpecializations($(e.target).val())
