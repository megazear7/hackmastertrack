# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $(".character-show-page").data("character-id")
    updateSpecializations($(".character-show-page").data("character-id"))

  raceInput = $("#character_race_id")
  if raceInput
    initRace = $(".race-options tbody tr").first()
    raceInput.val(initRace.data("race-id"))
    $(".race-options tr").removeClass("selected")
    initRace.addClass("selected")

    $(".race-options tbody tr").click (e) ->
      raceSelection = $(e.target.closest("tr"))
      if raceSelection.length == 0
        raceSelection = $(e.target)
      raceInput.val(raceSelection.data("race-id"))
      $(".race-options tr").removeClass("selected")
      raceSelection.addClass("selected")

