# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  specsAccordion = $("#accordion")
  if specsAccordion.length > 0
    specsAccordion.collapse()

  $("select.equip-item").each (index, select) ->
    $(select).change ->
      select.closest("form").submit()

  if $(".character-show-page").data("character-id")
    updateSpecializations($(".character-show-page").data("character-id"))

  if $(".class-option").length > 0
    $(".class-option").click (e) ->
      selection = $(e.target).closest(".class-option")
      if selection.length == 0
        selection = $(e.target)
      $("#character_character_class_id").val(selection.data("class"))
      $("#race-name").text(selection.data('text'))

  if $(".race-option").length > 0
    $(".race-option").click (e) ->
      selection = $(e.target).closest(".race-option")
      if selection.length == 0
        selection = $(e.target)
      $("#character_race_id").val(selection.data("race"))
      $("#class-name").text(selection.data('text'))

  if $(".alignment-option").length > 0
    $(".alignment-option").click (e) ->
      selection = $(e.target).closest(".alignment-option")
      if selection.length == 0
        selection = $(e.target)
      $("#character_alignment").val(selection.data("alignment"))
      $("#alignment-name").text(selection.data('text'))
