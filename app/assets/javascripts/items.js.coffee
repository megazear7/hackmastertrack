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

  $("#solr-submit").click (e) ->
    phrase = $("#solr-search").val();
    HackSolr.search phrase, {}, (data) ->
      $(".item_group").show()
      $("tr.item_row").hide()
      $("tr.item_row").removeClass("search-revealed")
      $.each data.response.docs, ->
        id = this.id.split("/items/")[1]
        $("tr.item_row_"+id).show()
        $("tr.item_row_"+id).addClass("search-revealed")

      $(".item_group").each ->
        if $(this).find(".search-revealed").length == 0
          console.log($(this))
          $(this).hide()
