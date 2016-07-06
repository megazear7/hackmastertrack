# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $(".character-show-page").data("character-id")
    updateSpecializations($(".character-show-page").data("character-id"))

  tab = getUrlParameter("tab");
  if $("a[href='#"+tab+"']").length > 0
    $("a[href='#"+tab+"']").tab("show")

  race = $("#character_race_id")
  if race
    race.change (e) ->
      raceId = $(e.target).val()
      $(".race-options tr").removeClass("selected");
      $(".race-options tr[data-race-id='"+raceId+"'").addClass("selected");

