# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $(document).on('submit', 'form', (e) ->
    item = $("#item_item_type").val()
    if item == "polearm"
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
    else if item == "armor"
      $(".polearm-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
    else if item == "shield"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
    else if item == "melee"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
    else if item == "ranged"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
    else if item == "consumable"
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".polearm-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
    else if item == "wearable"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".precious-section").remove()
    else if item == "precious"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
    )

  show_fields = (elem) ->
    if count == 1
      location.reload()
    count = 1
    item = elem.val()
    if item == "polearm"
      $(".polearm-section").show()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
    else if item == "armor"
      $(".polearm-section").hide()
      $(".armor-section").show()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
    else if item == "shield"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").show()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
    else if item == "melee"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").show()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
    else if item == "ranged"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").show()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
    else if item == "consumable"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").show()
      $(".wearable-section").hide()
      $(".precious-section").hide()
    else if item == "wearable"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").show()
      $(".precious-section").hide()
    else if item == "precious"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").show()

  count = 0
  $("#item_item_type").change ->
    show_fields($(this))

  show_fields($("#item_item_type"))

