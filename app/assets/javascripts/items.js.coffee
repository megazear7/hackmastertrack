# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $(".character-select").val()
    updateSpecializations($(".character-select").val())

  itemGroupSelect = $("select.item-groups")
  if itemGroupSelect.length > 0
    itemGroupSelect.change (e) ->
      itemGroupSelect.closest("form").submit()

  $(".character-select").change (e) ->
    if $(e.target).val()
      updateSpecializations($(e.target).val())

  $("#solr-item-search").submit (e) ->
    e.preventDefault()
    phrase = $("#solr-search").val();
    if phrase.trim() != ""
      HackSolr.search phrase, {}, (results) ->
        $(".item_group").show()
        $("tr.item_row").hide()
        $("tr.item_row").removeClass("search-revealed")
        $.each results, ->
          $("tr.item_row_"+this.id).show()
          $("tr.item_row_"+this.id).addClass("search-revealed")
        $(".item_group").each ->
          if $(this).find(".search-revealed").length == 0
            $(this).hide()
    else
      $(".item_group").show()
      $("tr.item_row").show()
      $("tr.item_row").removeClass("search-revealed")

  $("#solr-clear").click () ->
    $(".item_group").show()
    $("tr.item_row").show()
    $("tr.item_row").removeClass("search-revealed")
      
