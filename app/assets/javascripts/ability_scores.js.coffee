# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $(document).on('submit', 'form', (e) ->
    ability = $("#ability_score_ability").val()
    if ability == "Strength"
      $(".intelligence-section").remove()
      $(".wisdom-section").remove()
      $(".dexterity-section").remove()
      $(".constitution-section").remove()
      $(".charisma-section").remove()
    else if ability == "Intelligence"
      $(".strength-section").remove()
      $(".wisdom-section").remove()
      $(".dexterity-section").remove()
      $(".constitution-section").remove()
      $(".charisma-section").remove()
    else if ability == "Wisdom"
      $(".strength-section").remove()
      $(".intelligence-section").remove()
      $(".dexterity-section").remove()
      $(".constitution-section").remove()
      $(".charisma-section").remove()
    else if ability == "Dexterity"
      $(".strength-section").remove()
      $(".intelligence-section").remove()
      $(".wisdom-section").remove()
      $(".constitution-section").remove()
      $(".charisma-section").remove()
    else if ability == "Constitution"
      $(".strength-section").remove()
      $(".intelligence-section").remove()
      $(".wisdom-section").remove()
      $(".dexterity-section").remove()
      $(".charisma-section").remove()
    else if ability == "Charisma"
      $(".strength-section").remove()
      $(".intelligence-section").remove()
      $(".wisdom-section").remove()
      $(".dexterity-section").remove()
      $(".constitution-section").remove()
    )

  show_fields = (elem) ->
    if count == 1
      location.reload()
    count = 1
    ability = elem.val()
    if ability == "Strength"
      $(".strength-section").show()
      $(".intelligence-section").hide()
      $(".wisdom-section").hide()
      $(".dexterity-section").hide()
      $(".constitution-section").hide()
      $(".charisma-section").hide()
    else if ability == "Intelligence"
      $(".strength-section").hide()
      $(".intelligence-section").show()
      $(".wisdom-section").hide()
      $(".dexterity-section").hide()
      $(".constitution-section").hide()
      $(".charisma-section").hide()
    else if ability == "Wisdom"
      $(".strength-section").hide()
      $(".intelligence-section").hide()
      $(".wisdom-section").show()
      $(".dexterity-section").hide()
      $(".constitution-section").hide()
      $(".charisma-section").hide()
    else if ability == "Dexterity"
      $(".strength-section").hide()
      $(".intelligence-section").hide()
      $(".wisdom-section").hide()
      $(".dexterity-section").show()
      $(".constitution-section").hide()
      $(".charisma-section").hide()
    else if ability == "Constitution"
      $(".strength-section").hide()
      $(".intelligence-section").hide()
      $(".wisdom-section").hide()
      $(".dexterity-section").hide()
      $(".constitution-section").show()
      $(".charisma-section").hide()
    else if ability == "Charisma"
      $(".strength-section").hide()
      $(".intelligence-section").hide()
      $(".wisdom-section").hide()
      $(".dexterity-section").hide()
      $(".constitution-section").hide()
      $(".charisma-section").show()

  count = 0
  $("#ability_score_ability").change ->
    show_fields($(this))

  show_fields($("#ability_score_ability"))

