$ ->
  # when the user selects a character to purchase an item for, update the form with the character id
  $(".character_select_for_item_purchase").change ->
    id = $(this).attr("id")
    char_id = $("##{id} option:selected").val()
    form = $(this).closest('form')
    action = form.attr('action')
    action = action.replace(/\d+/, char_id)
    form.attr('action', action)

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
