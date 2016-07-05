@updateSpecializations = (characterId) ->
  $(".specializations").each (index, specialization) ->
    $(specialization).find(".specialization_character_id input").val(characterId)
    character_id = characterId
    item_id = $(specialization).find(".specialization_item_id input").val()
    stat_name = $(specialization).find(".specialization_stat_name input").val()

    if character_id != "" and stat_name != ""
      $.getJSON("/specialization/retrieve" + "?character_id=#{character_id}" + "&item_id=#{item_id}" + "&stat_name=#{stat_name}", (data) ->
        $(specialization).find(".specialization_value input").val(data.value + 1)
        $(specialization).find(".bp-cost").text(data.cost)

        $(specialization).find(".current-value").empty()

        for [0...data.value]
          $(specialization).find(".current-value").append("<span class='glyphicon glyphicon-stop'></span>")
        for [data.value...5]
          $(specialization).find(".current-value").append("<span class='glyphicon glyphicon-unchecked'></span>")
      )

