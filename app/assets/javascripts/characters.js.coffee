# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $("#solr-full-search").submit (e) ->
    e.preventDefault()
    phrase = $("#solr-search").val()
    $(".actual-search-result").slideUp done: ->
      $(this).remove()
    if phrase.trim() != ""
      $results = $(".solr-results")
      HackSolr.search phrase, {rows: 12, owners: [$("#user").data("id")], groups: $("#user").data("groups")}, (results) ->
        $.each results, ->
          result = $(".search-result-template").clone()
          result.removeClass("hidden")
          result.removeClass("search-result-template");
          result.hide()
          result.addClass("actual-search-result");
          result.find(".tile").data("click", unescape(this.category) + "_" + this.id)
          result.find("a").attr("href", this.path)
          result.find("a").attr("id", unescape(this.category) + "_" + this.id)
          result.find("a").text(unescape(this.title))
          result.find(".category1").text(unescape(this.category1))
          if this.category2
            result.find(".category2").text(unescape(this.category2))
          $results.append(result);
          result.slideDown()

  $("input#solr-search").on "input", (e) ->
    if $(this).val().length > 3
      HackSolr.suggest $(this).val(), (suggestions) ->
        termsUsed = []
        if suggestions.length > 0
          $("#solr-full-search .suggestion1").html suggestions[0].term
          $("#solr-full-search .suggestion1").show()
          termsUsed.push suggestions[0].term.toLowerCase()
        else
          $("#solr-full-search .suggestion1").html ""
          $("#solr-full-search .suggestion1").hide()
        if suggestions.length > 1 && termsUsed.indexOf(suggestions[1].term.toLowerCase()) == -1
          $("#solr-full-search .suggestion2").html suggestions[1].term
          $("#solr-full-search .suggestion2").show()
          termsUsed.push suggestions[1].term.toLowerCase()
        else
          $("#solr-full-search .suggestion2").html ""
          $("#solr-full-search .suggestion2").hide()
        if suggestions.length > 2 && termsUsed.indexOf(suggestions[2].term.toLowerCase()) == -1
          $("#solr-full-search .suggestion3").html suggestions[2].term
          $("#solr-full-search .suggestion3").show()
          termsUsed.push suggestions[2].term.toLowerCase()
        else
          $("#solr-full-search .suggestion3").html ""
          $("#solr-full-search .suggestion3").hide()
        if suggestions.length > 0
          $(".suggestions").show()
        else
          $(".suggestions").hide()
    else
      $(".suggestions").hide()

  $(".suggestions div").click (e) ->
    $("input#solr-search").val($(this).text())
    $("#solr-full-search").submit()
    $(".suggestions").hide()

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

  if $(".bp-option").length > 0
    $(".bp-option").click (e) ->
      selection = $(e.target).closest(".bp-option")
      if selection.length == 0
        selection = $(e.target)
      $("#character_building_points").val(selection.data("value"))
