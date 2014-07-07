# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $("#proficiency_item_ids").change ->
    if ($(this).val()[0].toLowerCase().indexOf("minimal") >= 0)
      $("#proficiency_bp_cost").val(1)
    else if ($(this).val()[0].toLowerCase().indexOf("low") >= 0)
      $("#proficiency_bp_cost").val(2)
    else if ($(this).val()[0].toLowerCase().indexOf("medium") >= 0)
      $("#proficiency_bp_cost").val(4)
    else if ($(this).val()[0].toLowerCase().indexOf("high") >= 0)
      $("#proficiency_bp_cost").val(6)

