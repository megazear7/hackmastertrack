# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  # when the user selects a character to purchase an item for, update the form with the character id
  $(".character_select_for_item_purchase").change ->
    id = $(this).attr("id")
    char_id = $("##{id} option:selected").val()
    form = $(this).closest('form')
    action = form.attr('action')
    action = action.replace(/\d+/, char_id)
    form.attr('action', action)

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
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "armor"
      $(".polearm-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "shield"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "melee"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".ranged-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "ranged"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "consumable"
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".ranged-section").remove()
      $(".polearm-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "wearable"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "precious"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "loadbearing"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "containers"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "misc"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "food"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "lodging"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".services-section").remove()
      $(".transport-section").remove()
    else if item == "services"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".transport-section").remove()
    else if item == "transport"
      $(".polearm-section").remove()
      $(".armor-section").remove()
      $(".shield-section").remove()
      $(".melee-section").remove()
      $(".consumable-section").remove()
      $(".wearable-section").remove()
      $(".precious-section").remove()
      $(".loadbearing-section").remove()
      $(".containers-section").remove()
      $(".misc-section").remove()
      $(".food-section").remove()
      $(".lodging-section").remove()
      $(".services-section").remove()
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
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "armor"
      $(".polearm-section").hide()
      $(".armor-section").show()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "shield"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").show()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "melee"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").show()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "ranged"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").show()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "consumable"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").show()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "wearable"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").show()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "precious"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").show()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "loadbearing"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").show()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "containers"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").show()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "misc"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").show()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "food"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").show()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "lodging"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").show()
      $(".services-section").hide()
      $(".transport-section").hide()
    else if item == "services"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").show()
      $(".transport-section").hide()
    else if item == "transport"
      $(".polearm-section").hide()
      $(".armor-section").hide()
      $(".shield-section").hide()
      $(".melee-section").hide()
      $(".ranged-section").hide()
      $(".consumable-section").hide()
      $(".wearable-section").hide()
      $(".precious-section").hide()
      $(".loadbearing-section").hide()
      $(".containers-section").hide()
      $(".misc-section").hide()
      $(".food-section").hide()
      $(".lodging-section").hide()
      $(".services-section").hide()
      $(".transport-section").show()

  count = 0
  $("#item_item_type").change ->
    show_fields($(this))

  show_fields($("#item_item_type"))

  ### Item Show Page ###
  $(".character-select").change (e) ->
    $(".specializations").each (index, specialization) ->
      $(specialization).find(".specialization_character_id input").val($(e.target).val())
      character_id = $(e.target).val()
      item_id = $(specialization).find(".specialization_item_id input").val()
      stat_name = $(specialization).find(".specialization_stat_name input").val()

      if character_id != "" and stat_name != ""
        $.getJSON("/specialization/retrieve" + "?character_id=#{character_id}" + "&item_id=#{item_id}" + "&stat_name=#{stat_name}", (data) ->
          if data
            console.log(data.value);
            $(specialization).find(".specialization_value input").val(data.value + 1)
            $(specialization).find(".bp-cost").text(data.cost)

            $(specialization).find(".current-value").empty()

            for [0...data.value]
              $(specialization).find(".current-value").append("<span class='glyphicon glyphicon-stop'></span>")
            for [data.value...5]
              $(specialization).find(".current-value").append("<span class='glyphicon glyphicon-unchecked'></span>")
        )
